from __future__ import annotations

import logging
from pathlib import Path
import pandas as pd


from src.features import ACCEPTED_PROFILE_COLUMNS, REJECTED_PROFILE_COLUMNS
from src.config import get_settings

settings = get_settings()

ACCEPTED_PATH = settings.raw_dir/"accepted_2007_to_2018Q4.csv"
REJECTED_PATH = settings.raw_dir/"rejected_2007_to_2018Q4.csv"

SAMPLE_ROWS = 200000
CHUNK_SIZE = 50000


def profile_csv(path: Path, selected_cols: list[str], logger: logging.Logger,
                sample_rows: int = SAMPLE_ROWS, chunk_size: int = CHUNK_SIZE) -> None:
    logger.info("=" * 100)
    logger.info("Profiling: %s", path)
    logger.info("=" * 100)

    if not path.exists():
        logger.warning("File not found: %s", path)
        return

    header_row = pd.read_csv(path, nrows=0)
    cols = header_row.columns.tolist()

    missing_in_file = [c for c in selected_cols if c not in cols]
    if missing_in_file:
        logger.warning("These selected columns are not in the file: %s", missing_in_file)
        return

    logger.info("Columns: %d", len(cols))
    logger.info("Selected columns for profiling: %d", len(selected_cols))
    logger.info("Selected columns: %s", selected_cols)

    total_read = 0
    missing_counts = pd.Series(0, index=cols, dtype="int64")
    sample_data_frames = []

    reader = pd.read_csv(path, chunksize=chunk_size, low_memory=False)

    for chunk in reader:
        remaining = sample_rows - total_read

        if remaining <= 0:
            break
        if len(chunk) > remaining:
            chunk = chunk.iloc[:remaining]

        total_read += len(chunk)

        missing_counts += chunk.isna().sum()
        sample_data_frames.append(chunk)

        if total_read >= sample_rows:
            break

    if not sample_data_frames:
        logger.warning("No sample data was read from file: %s", path)
        return

    sample_df = pd.concat(sample_data_frames, ignore_index=True)
    logger.info("Sample rows: %d", total_read)

    #Calculate missing percentage
    missing_pct = (missing_counts/total_read * 100).sort_values(ascending=False)
    logger.info("Columns by missing percentage:\n%s", missing_pct.round(2).to_string())

    #Profiling for selected cols
    logger.info("Missing percentage for selected columns:")
    logger.info("\n%s", missing_pct[selected_cols].round(2).sort_values(ascending=False).to_string())

    #datatype view
    selected_df = sample_df[selected_cols].copy()
    logger.info("Datatype for selected columns:\n%s", selected_df.dtypes.astype(str).to_string())

    #Sample 5 rows
    logger.info("Sample 5 rows from selected columns:")
    logger.info("\n%s", selected_df.head().to_string())

    #Converting object columns to numeric if possible
    for col in selected_df.columns:
        if selected_df[col].dtype == "object":
            converted = pd.to_numeric(selected_df[col], errors="coerce")
            if converted.notna().mean() > 0.8:
                selected_df[col] = converted

    numeric_cols = selected_df.select_dtypes(include=["number"]).columns.tolist()
    object_cols = selected_df.select_dtypes(include=["object"]).columns.tolist()

    if numeric_cols:
        logger.info("Numeric columns summary for selected columns:")
        logger.info("\n%s", selected_df[numeric_cols]
            .describe()
            .T[["count", "mean", "std", "min", "50%", "max"]]
            .round(2)
            .to_string()
        )

    if object_cols:
        logger.info("Low-cardinality categorical columns:")
        for col in object_cols:
            unique_count = selected_df[col].nunique(dropna=True)
            if unique_count <= 20:
                logger.info("%s (Unique Values: %d)", col, unique_count)
                logger.info( "\n%s",
                    selected_df[col].value_counts(dropna=False).head(10).to_string(),
                )

