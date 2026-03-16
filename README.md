## Lending Club Analytics Project
End-to-End Lending Analytics Pipeline (Python + PostgreSQL + Power BI + AI)
## Project Overview

This project builds an end‑to‑end analytics pipeline using the Lending
Club loan dataset. The goal is to transform raw lending data into a
structured analytics environment that supports:

-   data ingestion
-   SQL‑based analytics
-   business intelligence dashboards
-   AI‑driven natural language querying

The project is intentionally developed **in stages**, so each layer of
the analytics stack is built and documented incrementally.

Current focus: **Stage 1 -- Data Ingestion using Python**.

------------------------------------------------------------------------

# Business Context

Consumer lending platforms rely heavily on data to evaluate borrower
profiles, understand loan demand, monitor portfolio performance, and
identify risk signals.

The Lending Club dataset contains millions of loan applications and
funded loans, including borrower attributes, and loan characteristics and
performance metrics.

This project aims to support analysis of:

-   differences between accepted and rejected loan applications
-   borrower characteristics across loan segments
-   how lending patterns evolve over time


The ingestion pipeline developed in this stage prepares the dataset for
SQL analysis and dashboard visualization.

------------------------------------------------------------------------

# Project Architecture

              Kaggle Lending Club Dataset
                         │
                         ▼
             Python Data Ingestion Pipeline
                         │
                         ▼
                 PostgreSQL Database
                  (raw → clean → mart)
                         │
                         ▼
              SQL Analytical Queries
                         │
                         ▼
                 Power BI Dashboards
                         │
                         ▼
            Future: AI Text-to-SQL Interface

Each layer prepares the data for the next analytical stage.

------------------------------------------------------------------------

# Project Stages

## Stage 1 --- Data Ingestion Pipeline (Python)

This stage builds a modular Python pipeline to ingest the Lending Club
dataset into PostgreSQL.

Pipeline responsibilities:

1.  Download the Lending Club dataset using the Kaggle API
2.  Extract `.zip` and `.gz` files
3.  Organize raw data and archive files
4.  Profile selected dataset columns
5.  Dynamically create PostgreSQL tables from CSV headers
6.  Load CSV files using PostgreSQL `COPY`
7.  Validate ingestion using row‑count comparison
8.  Capture execution and profiling logs

------------------------------------------------------------------------

## Stage 2 --- PostgreSQL Analysis

The second stage will analyze the dataset using SQL queries inside
PostgreSQL.

The exact analytical questions will be added to this README after
completing the SQL exploration phase.

------------------------------------------------------------------------

## Stage 3 --- Power BI Visualization

The third stage will transform SQL analysis outputs into interactive
dashboards using Power BI.

Planned visualizations include, to highlight a few:

-   loan issuance trends
-   borrower and loan characteristic distributions
-   accepted vs rejected comparisons
-   portfolio segmentation views

------------------------------------------------------------------------

# Repository Structure

    lending_club_sql_analytics/
    │
    ├── data/
    │   ├── archives/        # compressed dataset files
    │   └── raw/             # extracted CSV files
    │
    ├── logs/
    │   ├── pipeline_*.log
    │   └── profiling_*.log
    │
    ├── src/
    │   ├── main.py
    │   ├── config.py
    │   ├── logging_utils.py
    │   ├── kaggle_download.py
    │   ├── profile_data.py
    │   ├── load_postgres.py
    │   └── validate_load.py
    │
    ├── requirements.txt
    ├── .gitignore
    ├── .env (not committed)
    └── README.md

------------------------------------------------------------------------

# Installation & Setup

## 1. Clone the repository

    git clone https://github.com/<your-username>/lending_club_sql_analytics.git
    cd lending_club_sql_analytics

## 2. Create a virtual environment

    python -m venv venv

Activate the environment.

**Windows**

    venv\Scripts\activate

**Mac / Linux**

    source venv/bin/activate

## 3. Install project dependencies

    pip install -r requirements.txt

------------------------------------------------------------------------

# Environment Configuration

Create a `.env` file in the project root.

Example configuration:

    KAGGLE_USERNAME=your_username
    KAGGLE_KEY=your_kaggle_api_key
    KAGGLE_DATASET=wordsforthewise/lending-club

    RAW_DIR=data/raw
    ARCHIVE_DIR=data/archives
    LOG_DIR=logs

    DATABASE_URL=postgresql://username:password@localhost:5432/lending_club

You will also need to configure your Kaggle API credentials locally.

Reference: https://www.kaggle.com/docs/api

------------------------------------------------------------------------

# Running the Pipeline

Run the full pipeline:

    python -m src.main all

Run individual steps if needed:

    python -m src.main download
    python -m src.main profile
    python -m src.main load
    python -m src.main validate

------------------------------------------------------------------------

# Logging

Two log streams are maintained.

### Pipeline Logs

Located in:

    logs/pipeline_*.log

Tracks:

-   pipeline execution steps
-   load operations
-   validation results
-   execution timing

### Profiling Logs

Located in:

    logs/profiling_*.log

Contains:

-   missing value summaries
-   datatype inspection
-   numeric distributions
-   categorical previews

------------------------------------------------------------------------

# Runtime Considerations

The Lending Club dataset contains approx. 2.76M accepted and 27.6M of rejected loan records, 
so runtime may vary depending on hardware resources such as CPU speed, memory etc.

If you encounter resource limitations, you may experiment using smaller
dataset samples before running the full ingestion pipeline. You can run download and
profile steps mentioned below:

python -m src.main download

python -m src.main profile

then trim the accepted and rejected CSV files in the raw folder before uploading the data in the postgresql.

------------------------------------------------------------------------

# Future Enhancements

Planned improvements include:

-   structured analytical SQL queries
-   Power BI dashboards for lending insights
-   query optimization and data modeling
-   an AI-powered Text‑to‑SQL interface that converts natural language
    questions into SQL queries

------------------------------------------------------------------------

# Project Status

Current Stage: **Stage 1 --- Data Ingestion Pipeline**
