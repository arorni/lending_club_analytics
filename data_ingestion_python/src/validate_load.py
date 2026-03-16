from __future__ import annotations
from pathlib import Path
import time

import psycopg2
from psycopg2 import sql

from src.config import get_settings
import logging
logger = logging.getLogger("pipeline")
settings = get_settings()

def get_conn():
    return psycopg2.connect(settings.database_url)

def get_file_record_count(file_path: Path) -> int:
    """
    Return no. of records in a CSV file
    using powershell line count minus header record.
    """
    start = time.perf_counter()  # NEW
    logger.info("get_file_record_count started for file=%s", file_path)
    if not file_path.exists():
        logger.info("\nfile does not exist: %s",file_path )
        raise FileNotFoundError(f"CSV file not found: {file_path}")

    with open(file_path, "rb") as f:
        line_count = sum(buf.count(b"\n") for buf in iter(lambda: f.read(1024 * 1024), b""))
    elapsed = time.perf_counter() - start  # NEW

    logger.info(
        "get_file_record_count ended for file=%s | elapsed_seconds=%.3f",
        file_path,
        elapsed,
    )
    return max(line_count - 1, 0)

def get_table_row_count(conn, schema: str, table: str) -> int:
    start = time.perf_counter()  # NEW
    logger.info("get_table_row_count started for %s.%s", schema, table)
    query = sql.SQL("SELECT COUNT(*) FROM {}.{}").format(sql.Identifier(schema), sql.Identifier(table),)

    with conn.cursor() as cur:
        cur.execute(query)
        count = cur.fetchone()[0]

        elapsed = time.perf_counter() - start

        logger.info(
            "get_table_row_count ended for %s.%s | rows=%d | elapsed_seconds=%.3f",
            schema,
            table,
            count,
            elapsed,
        )
        return count


def validate_table(conn, file_path: Path, schema: str, table: str) -> None:
    no_of_recs_csv = get_file_record_count(file_path)
    no_of_recs_db = get_table_row_count(conn, schema, table)

    print(f"\nValidating {schema}.{table}\n")
    print(f"No. of records in the original csv file: {no_of_recs_csv}\n")
    print(f"No. of records uploaded in PostgreSQL: {no_of_recs_db}\n")

    if no_of_recs_csv != no_of_recs_db:
        raise ValueError(f"Row count mismatch for {schema}.{table}:"
                         f"CSV file: {no_of_recs_csv}, DB rows uploaded: {no_of_recs_db}")

    print("Validation Successful")

def main():
    accepted_path = settings.raw_dir / "accepted_2007_to_2018Q4.csv"
    rejected_path = settings.raw_dir / "rejected_2007_to_2018Q4.csv"

    targets = [
        (accepted_path, "raw", "accepted_loans_raw"),
        (rejected_path, "raw", "rejected_loans_raw"),
    ]

    conn = None
    try:
        conn = get_conn()
        print("Connected to PostgreSQL.")

        for file_path, schema, table in targets:
            validate_table(conn, file_path, schema, table)

        print("\nAll validations passed.")

    except Exception as e:
        print(f"\nValidation error: {e}")
        raise
    finally:
        if conn is not None:
            conn.close()
            print("PostgreSQL connection closed.")


if __name__ == "__main__":
    main()
