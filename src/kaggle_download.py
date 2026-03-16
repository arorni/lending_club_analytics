import shutil
import zipfile
import gzip
from pathlib import Path
from kaggle.api.kaggle_api_extended import KaggleApi

import logging
logger = logging.getLogger(__name__)

def decompress_gz(gz_path: Path, raw_dir: Path) -> None:
    """
    Decompress .gz file into raw directory.
    :param gz_path:
    :param raw_dir:
    """
    csv_name = gz_path.stem
    csv_path = raw_dir/csv_name

    if csv_path.exists():
        logger.info("%s already exists, skipping decompression", csv_name)
        return

    logger.info("Decompressing %s", gz_path.name)

    with gzip.open(gz_path, "rb") as f_in:
        with open(csv_path, "wb") as f_out:
            shutil.copyfileobj(f_in, f_out)

def extract_zip(zip_path: Path, raw_dir: Path, archive_dir: Path) -> None:
    logger.info("Extracting %s", zip_path.name)

    with zipfile.ZipFile(zip_path, "r") as zip_ref:
        for member in zip_ref.namelist():
            member_path = Path(member)

            # skip directory entries
            if member.endswith("/"):
                continue

            file_name = member_path.name

            if file_name.endswith(".gz"):
                target_gz = archive_dir / file_name

                if not target_gz.exists():
                    logger.info("Saving archive file: %s", file_name)
                    with zip_ref.open(member) as source, open(target_gz, "wb") as target:
                        shutil.copyfileobj(source, target)

                decompress_gz(target_gz, raw_dir)

            elif file_name.endswith(".csv"):
                target_csv = raw_dir / file_name

                if not target_csv.exists():
                    logger.info("Saving CSV file: %s", file_name)
                    with zip_ref.open(member) as source, open(target_csv, "wb") as target:
                        shutil.copyfileobj(source, target)


def download_dataset(dataset: str, archive_dir: Path) -> Path:
    """
    Download Kaggle dataset ZIP file into data/archives
    """
    api = KaggleApi()
    api.authenticate()

    logger.info("Downloading dataset: %s", dataset)

    api.dataset_download_files(
        dataset,
        path=str(archive_dir),
        unzip=False,
        quiet=False
    )

    zip_files = list(archive_dir.glob("*.zip"))

    if not zip_files:
        raise FileNotFoundError("No ZIP file found after kaggle download")
    return zip_files[0]