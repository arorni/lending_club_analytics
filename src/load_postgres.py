from __future__ import annotations

import csv
import logging

from pathlib import Path

import psycopg2
from psycopg2 import sql
from src.config import get_settings

settings = get_settings()

logger = logging.getLogger("pipeline")

def get_conn(database_url: str) -> psycopg2.Connection:
    logger.info("Connecting to PostgreSQL")
    return psycopg2.connect(database_url)

def read_csv_header(csv_path: Path) -> list[str]:
    """
    Read csv file header and return column names
    """
    if not csv_path.exists():
        raise FileNotFoundError(f"CSV file not found: {csv_path}")

    with open(csv_path, "r", encoding="utf-8", newline="") as file:
        reader = csv.reader(file)
        header = next(reader)

    if not header:
        raise ValueError(f"No header found in CSV: {csv_path}")

    return header

def create_schemas(conn) -> None:
    create_sql = """
    CREATE SCHEMA IF NOT EXISTS raw;
    CREATE SCHEMA IF NOT EXISTS clean;
    CREATE SCHEMA IF NOT EXISTS mart;
    """

    with conn.cursor() as cur:
        cur.execute(create_sql)
    conn.commit()
    logger.info("Schemas created or already exist.")

def create_raw_table_from_header(conn, schema:str, table:str, columns: list[str]) -> None:
    table_identifier = sql.Identifier(schema, table)

    drop_stmt = sql.SQL("DROP TABLE IF EXISTS {}").format(table_identifier)

    column_defs = [
        sql.SQL("{} TEXT").format(sql.Identifier(col))
        for col in columns
    ]

    create_stmt = sql.SQL("CREATE TABLE {} ({})").format(table_identifier, sql.SQL(",").join(column_defs),)

    with conn.cursor() as cur:
        cur.execute(drop_stmt)
        cur.execute(create_stmt)

    conn.commit()
    logger.info("Created table %s.%s with %d columns.", schema, table, len(columns))

def copy_csv_to_table(conn, csv_path: Path, schema: str, table: str) -> None:
    table_identifier = sql.Identifier(schema, table)

    copy_stmt = sql.SQL(
        "COPY {} FROM STDIN WITH (FORMAT CSV, HEADER TRUE)"
    ).format(table_identifier)

    with conn.cursor() as cur:
        with open(csv_path, "r", encoding="utf-8") as file:
            cur.copy_expert(copy_stmt.as_string(conn), file)

    conn.commit()
    logger.info("Loaded %s into %s.%s.", csv_path.name, schema, table)

def get_file_record_count(file_path: Path) -> int:
    """
    Returns no. of records in the CSV file
    (total lines - header)
    :param file_path:
    :return: no. of records
    """
    if not file_path.exists():
        raise FileNotFoundError(f"CSV file not found: {file_path}")

    with open(file_path, "rb") as f:
        line_count = sum(buf.count(b"\n") for buf in iter(lambda: f.read(1024 * 1024), b""))

    return max(line_count - 1, 0)

def get_table_row_count(conn, schema: str, table: str) -> int:
    query = sql.SQL("SELECT COUNT(*) FROM {}.{}").format(sql.Identifier(schema), sql.Identifier(table))

    with conn.cursor() as cur:
        cur.execute(query)
        return cur.fetchone()[0]