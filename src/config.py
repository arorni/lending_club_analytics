from dataclasses import dataclass
from dotenv import load_dotenv
import os
from pathlib import Path

load_dotenv()

PROJECT_ROOT = Path(__file__).resolve().parents[1]

@dataclass(frozen=True)
class Settings:
    kaggle_username: str
    kaggle_key: str
    kaggle_dataset:str
    raw_dir: Path
    archive_dir: Path
    database_url: str
    log_dir: Path

def get_settings():
        return Settings(
            kaggle_username=os.getenv("KAGGLE_USERNAME", "").strip(),
            kaggle_key=os.getenv("KAGGLE_KEY","").strip(),
            kaggle_dataset=os.getenv("KAGGLE_DATASET","").strip(),
            raw_dir=PROJECT_ROOT/os.getenv("RAW_DIR", "").strip(),
            archive_dir=PROJECT_ROOT/os.getenv("ARCHIVE_DIR", "").strip(),
            database_url=os.getenv("DATABASE_URL","").strip(),
            log_dir=PROJECT_ROOT/os.getenv("LOG_DIR","").strip()

        )

