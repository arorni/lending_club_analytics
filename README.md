# Lending Club Analytics Project
End-to-End Lending Analytics Pipeline (Python + PostgreSQL + Power BI + AI)

## Project Overview
This repository builds a complete analytics pipeline using the Lending Club loan dataset. 

This project focuses on below:

- automated data ingestion
- SQL-based analytics
- business intelligence dashboards
- AI-driven natural language querying

The project is intentionally developed **in stages**, so each layer of the analytics stack can be built and documented independently.

---

## Business Context
Consumer lending platforms rely heavily on data to evaluate borrower profiles, understand loan demand, monitor portfolio performance, and identify potential risk signals.

The Lending Club dataset contains approx. 2.76M of accepted and 27.6M of rejected loan applications. It has borrower attributes, loan characteristics, and loan performance metrics.

This project aims to support analysis of:

- differences between accepted and rejected loan applications
- borrower characteristics across loan segments
- lending behavior trends over time
- portfolio monitoring insights

---

## Project Architecture

Kaggle Lending Club Dataset  
↓  
Python Data Ingestion Pipeline  
↓  
PostgreSQL Database (raw → clean → analytics)  
↓  
SQL Analytical Queries  
↓  
Power BI Dashboards  
↓  
Future: AI Text‑to‑SQL Interface

---

## Project Stages

### Stage 1 — Data Ingestion Pipeline (Python)

Builds a modular Python pipeline to ingest the Lending Club dataset into PostgreSQL.

Location:

data_ingestion_python/

Detailed documentation:

data_ingestion_python/README.md

---

### Stage 2 — PostgreSQL Analytics (Planned)

The second stage will analyze the dataset using SQL queries inside
PostgreSQL.

The exact analytical questions will be added to this README after
completing the SQL exploration phase.

---

### Stage 3 — Power BI Visualization (Planned)

SQL outputs will be transformed into interactive dashboards.

---

## Repository Structure

```
lending_club_analytics/
│
├── README.md                      # Project overview
│
├── data_ingestion_python/         # Stage 1 – Python ingestion pipeline
│   ├── README.md
│   ├── src/
│   └── requirements.txt
│
├── sql_analytics/                 # Stage 2 – SQL analysis (planned)
│
├── powerbi_dashboards/            # Stage 3 – BI dashboards (planned)
│
└── docs/                          # Architecture diagrams and notes
```

---

## Dataset Source

Lending Club dataset available on Kaggle:

https://www.kaggle.com/datasets/wordsforthewise/lending-club

---

## Project Status

Current Stage: **Stage 1 — Data Ingestion Pipeline**
