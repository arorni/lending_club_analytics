# Lending Club Analytics Project

**End-to-End Lending Analytics Pipeline (Python • PostgreSQL • Power BI • AI)**

## Project Overview

This repository demonstrates an end-to-end analytics pipeline built using the Lending Club loan dataset containing approximately **30 million loan applications**.

The project covers the complete analytics workflow, from automated data ingestion and data preparation to business-focused SQL analysis, interactive Power BI dashboards, and a planned AI-powered natural language interface.

### Key Features

* Automated data ingestion using Python
* PostgreSQL Medallion architecture (Raw → Clean → Analytics)
* Data cleaning and feature engineering
* Business-focused SQL analysis
* Interactive Power BI dashboards *(in progress)*
* AI-powered Text-to-SQL interface *(planned)*

---

## Business Context

Consumer lending platforms rely heavily on data to assess borrower risk, monitor portfolio performance, and understand lending demand.

Using approximately **2.26 million accepted loans** and **27.6 million rejected loan applications**, this project explores:

* Borrower characteristics associated with higher default risk
* Lending portfolio performance over time
* Geographic comparison of accepted and rejected loan applications
* Business insights to support lending decisions

---

## Project Architecture

```
Kaggle Lending Club Dataset
            │
            ▼
 Python Data Ingestion Pipeline
            │
            ▼
 PostgreSQL (Raw → Clean → Analytics)
            │
            ▼
     SQL Business Analysis
            │
            ▼
     Power BI Dashboards
            │
            ▼
 Future: AI Text-to-SQL Interface
```

---

## Project Stages

### Stage 1 — Python Data Ingestion

Builds a modular Python pipeline to ingest raw Lending Club data into PostgreSQL.

Location:

```
data_ingestion_python/
```

---

### Stage 2 — PostgreSQL Analytics

Implements a Medallion-style data model and answers business questions using SQL.

Business analyses include:

* High-Risk Borrower Segments
* Loan Portfolio Trend Analysis
* Geographic Comparison of Accepted and Rejected Applications

Location:

```
SQL Analysis/
```

---

### Stage 3 — Power BI Dashboards *(In Progress)*

Interactive dashboards will visualize key lending, portfolio, and borrower insights generated from the SQL analytics layer.

---

## Repository Structure

```text
lending_club_analytics/
│
├── README.md
│
├── data_ingestion_python/
│
├── SQL Analysis/
│   ├── schema/
│   └── analysis/
│
├── powerbi_dashboards/
```

---

## Dataset

**Source:** Lending Club Dataset (Kaggle)

https://www.kaggle.com/datasets/wordsforthewise/lending-club

---

## Current Status

* ✅ Stage 1 — Python Data Ingestion
* ✅ Stage 2 — PostgreSQL Analytics
* 🚧 Stage 3 — Power BI Dashboards
* 📌 Stage 4 — AI-powered Text-to-SQL Interface *(planned)*
