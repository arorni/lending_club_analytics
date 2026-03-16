from __future__ import annotations

import argparse
from pathlib import Path
from datetime import datetime

from src.config import get_settings
from src.features import ACCEPTED_PROFILE_COLUMNS, REJECTED_PROFILE_COLUMNS
from src.kaggle_download import download_dataset, extract_zip
from src.profile_data import profile_csv
from src.validate_load import validate_table
from src.logging_utils import setup_logger, timed_step
from src.load_postgres import (
    get_conn,
    create_schemas,
    read_csv_header,
    create_raw_table_from_header,
    copy_csv_to_table,
)

def run_download_extract(settings, logger) -> None:
    """
    Download kaggle dataset into archive directory and extract files.
    """
    logger.info("run_download_extract function started.")
    if not settings.kaggle_username or not settings.kaggle_key:
        raise ValueError("Set KAGGLE_USERNAME and KAGGLE_KEY in .env")

    raw_dir = Path(settings.raw_dir)
    archive_dir = Path(settings.archive_dir)

    raw_dir.mkdir(parents=True, exist_ok=True)
    archive_dir.mkdir(parents=True, exist_ok=True)

    zip_path = download_dataset(settings.kaggle_dataset, archive_dir)
    logger.info("Downloaded ZIP: %s",zip_path)

    extract_zip(zip_path, raw_dir, archive_dir)

    logger.info("\nData has been extracted successfully.")
    logger.info("Archive folder: %s", archive_dir)
    logger.info("Raw folder: %s", raw_dir)
    logger.info("run_download_extract function ended.")

def run_profile(settings, pipeline_logger, profiling_logger) -> None:
    """
    Profile accepted and rejected loan files.
    """
    pipeline_logger.info("run_profile function started.")

    accepted_path = Path(settings.raw_dir) / "accepted_2007_to_2018Q4.csv"
    rejected_path = Path(settings.raw_dir) / "rejected_2007_to_2018Q4.csv"

    profile_csv(accepted_path, ACCEPTED_PROFILE_COLUMNS, profiling_logger)
    profile_csv(rejected_path, REJECTED_PROFILE_COLUMNS, profiling_logger)

    pipeline_logger.info("run_profile function ended.")


def run_load(settings, logger) ->None:
    logger.info("run_load function started.")

    accepted_path = Path(settings.raw_dir) / "accepted_2007_to_2018Q4.csv"
    rejected_path = Path(settings.raw_dir) / "rejected_2007_to_2018Q4.csv"

    conn = None
    try:
        conn = get_conn(settings.database_url)

        create_schemas(conn)

        accepted_columns = read_csv_header(accepted_path)
        rejected_columns = read_csv_header(rejected_path)

        create_raw_table_from_header(conn, "raw", "accepted_loans_raw", accepted_columns)
        create_raw_table_from_header(conn, "raw", "rejected_loans_raw", rejected_columns)

        copy_csv_to_table(conn, accepted_path, "raw", "accepted_loans_raw")
        copy_csv_to_table(conn, rejected_path, "raw", "rejected_loans_raw")

    except Exception as e:
        if conn is not None:
            conn.rollback()
        logger.exception("Load failed: %s", e)
        raise
    finally:
        if conn is not None:
            conn.close()
            logger.info("PostgreSQL connection closed.")
    logger.info("run_load function ended.")

def run_validate(settings, logger) -> None:
    """
    Validate loaded data row counts between CSV files and PostgreSQL tables.
    """
    logger.info("run_validate started")
    accepted_path = Path(settings.raw_dir) / "accepted_2007_to_2018Q4.csv"
    rejected_path = Path(settings.raw_dir) / "rejected_2007_to_2018Q4.csv"

    targets = [
        (accepted_path, "raw", "accepted_loans_raw"),
        (rejected_path, "raw", "rejected_loans_raw"),
    ]

    conn = None
    try:
        conn = get_conn(settings.database_url)

        for file_path, schema, table in targets:
            validate_table(conn, file_path, schema, table)

        logger.info("All validations passed.")

    finally:
        if conn is not None:
            conn.close()
            print("PostgreSQL connection closed.")
    logger.info("run_validate ended.")


def run_all(settings, pipeline_logger, profiling_logger) -> None:
    """
    Download, upload, and validate the data
    """
    pipeline_logger.info("Starting full pipeline...")
    timed_step(pipeline_logger, "run_download_extract", run_download_extract, settings, pipeline_logger,)
    timed_step(pipeline_logger, "run_profile", run_profile, settings, pipeline_logger, profiling_logger,)
    timed_step(pipeline_logger, "run_load", run_load, settings, pipeline_logger)
    timed_step(pipeline_logger, "run_validate", run_validate, settings, pipeline_logger)
    pipeline_logger.info("Pipeline completed successfully.")

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Lending Club data pipeline")

    parser.add_argument(
        "step",
        choices=["download", "profile", "load", "validate", "all"],
        nargs="?",
        default="all",
        help="Enter pipeline step to run.")
    return parser.parse_args()

def main():
    settings = get_settings()

    run_id = datetime.now().strftime("%Y%m%d_%H%M%S")
    pipeline_logger = setup_logger(
        "pipeline",
        f"pipeline_{run_id}.log"
    )
    profiling_logger = setup_logger(
        "profiling",
        f"profiling_{run_id}.log"
    )


    args = parse_args()
    try:
        pipeline_logger.info("Pipeline started with step=%s", args.step)
        if args.step == "download":
            timed_step(pipeline_logger, "run_download_extract", run_download_extract, settings, pipeline_logger)
        elif args.step == "profile":
            timed_step(pipeline_logger, "run_profile", run_profile, settings, pipeline_logger,profiling_logger)
        elif args.step == "load":
            timed_step(pipeline_logger, "run_load", run_load, settings, pipeline_logger)
        elif args.step == "validate":
            timed_step(pipeline_logger, "run_validate", run_validate, settings, pipeline_logger)
        elif args.step == "all":
            timed_step(pipeline_logger, "run_all", run_all, settings, pipeline_logger,profiling_logger)

        pipeline_logger.info("Pipeline completed successfully.")
        return 0
    except Exception as e:
        pipeline_logger.exception("Pipeline failed: %s", e)
        return 1

if __name__ == "__main__":
   raise SystemExit(main())