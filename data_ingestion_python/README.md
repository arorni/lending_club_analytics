# Lending Club Data Ingestion Pipeline

Stage 1 of the Lending Club Analytics Project.

This module implements a Python pipeline that downloads, processes, and loads the Lending Club dataset into PostgreSQL.

---

## Pipeline Responsibilities

The ingestion pipeline performs the following tasks:

1. Download the Lending Club dataset using the Kaggle API
2. Extract `.zip` and `.gz` archive files
3. Organize raw data and archive files
4. Profile dataset columns
5. Dynamically create PostgreSQL tables using CSV headers
6. Load data using PostgreSQL COPY
7. Validate ingestion using row-count comparisons
8. Capture structured execution logs

---

## Pipeline Architecture

Kaggle Dataset  
↓  
Download + Extract  
↓  
Data Profiling  
↓  
Table Creation  
↓  
Bulk Load into PostgreSQL  
↓  
Validation

---

## Project Structure

```data_ingestion_python/
│
├── data/               - The data and it's sub-folders will be created automatically
│   ├── archives/       - Zip files 
│   └── raw/            - csv files 
│
├── logs/               - Data profiling and data pipelines logs
│
├── src/    
│   ├── __init__.py             - A placeholder  
│   ├── main.py                 - Main file to run the data ingestion pipeline
│   ├── config.py               - Configuration 
│   ├── logging_utils.py        - Setup logging enviorment
│   ├── kaggle_download.py      - Script to download and extract kaggle dataset
│   ├── profile_data.py         - Script to profile the dataset 
│   ├── load_postgres.py        - Script to load the data in PostgreSQL
│   └── validate_load.py        - Script to validate the data in orginal CSV file with PostgreSQL
│
├── requirements.txt            - Listing all the requirements for the project
├── .env (not committed)
└── README.md               
```
---

## Installation

Clone repository

git clone https://github.com/arorni/lending_club_analytics.git

Navigate to ingestion module

cd lending_club_analytics/data_ingestion_python

Create virtual environment

python -m venv venv

Activate environment

Windows
venv\Scripts\activate

Mac/Linux
source venv/bin/activate

Install dependencies

pip install -r requirements.txt

---

## Environment Configuration

Create a `.env` file inside `data_ingestion_python`.

Example configuration:

KAGGLE_USERNAME=your_username  
KAGGLE_KEY=your_api_key  
KAGGLE_DATASET=wordsforthewise/lending-club  

RAW_DIR=data/raw  
ARCHIVE_DIR=data/archives  
LOG_DIR=logs  

DATABASE_URL=postgresql://username:password@localhost:5432/lending_club

---

## Running the Pipeline

### Run the full pipeline

python -m src.main all

### Run individual stages

python -m src.main download  
python -m src.main profile  
python -m src.main load  
python -m src.main validate

---

## Runtime Considerations

The Lending Club dataset contains approximately:

- 2.7M accepted loan records
- 27M rejected loan records

Execution time may vary depending on hardware resources such as CPU, memory, and disk speed.

---

## Logs

Pipeline logs capture:

- execution steps
- ingestion validation results
- runtime metrics
- profiling summaries
