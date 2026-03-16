from __future__ import annotations

import logging
import time

from src.config import get_settings


def setup_logger(logger_name: str, log_file_name: str):
    settings = get_settings()
    settings.log_dir.mkdir(parents=True, exist_ok=True)

    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.INFO)

    if logger.handlers:
        return logger

    formatter = logging.Formatter(
        "%(asctime)s | %(name)s | %(levelname)s | %(message)s"
    )

    file_handler = logging.FileHandler(
        settings.log_dir / log_file_name,
        encoding="utf-8"
    )
    file_handler.setFormatter(formatter)

    logger.addHandler(file_handler)

    return logger

def timed_step(logger: logging.Logger, step_name: str, func, *args, **kwargs):
    start = time.perf_counter()
    logger.info("START: %s", step_name)

    result = func(*args, **kwargs)
    elapsed = time.perf_counter() - start
    logger.info("END: %s | elapsed_seconds:%.3f", step_name, elapsed)

    return result, elapsed
