# 🏅 Tokyo Olympics Data Engineering Project (Azure End-to-End Pipeline)

This project showcases an end-to-end data engineering workflow using Azure services to analyze Olympic datasets. It covers everything from data ingestion to transformation, storage, and SQL-based analytics.

## 🚀 Project Overview

**Goal:** Build a full data pipeline to ingest, process, and analyze Tokyo Olympics data using modern Azure tools.

**Tech Stack:**
- **Azure Data Lake Storage Gen2 (ADLS)**
- **Azure Data Factory (ADF)**
- **Azure Databricks (PySpark)**
- **Azure Synapse Analytics (SQL + Visualization)**
- **Azure Blob File Access via `abfss://`**

---

## 🧱 Architecture

ADLS Gen2 (Raw CSV)
↓ (via ADF)
Azure Databricks (Transform with PySpark)
↓
ADLS Gen2 (Transformed)
↓
Azure Synapse Analytics (External Tables + SQL)

---

## 📂 Datasets

Stored in `raw-data/` and transformed into `transformed-data/` folders:

- `athletes.csv`
- `coaches.csv`
- `entriesgender.csv`
- `medals.csv`
- `teams.csv`

---

## ⚙️ ETL Workflow

1. **Ingestion:**  
   Data loaded into ADLS Gen2 via manual upload or ADF.

2. **Transformation:**  
   PySpark scripts in Databricks cleaned and standardized the data (type casting, column validation, partitioning, etc.).

3. **Loading:**  
   Cleaned data written back to ADLS as CSV in `transformed-data/`.

4. **Analytics:**  
   Connected Synapse Analytics to read transformed data via external tables.

5. **Exploration:**  
   Ran advanced SQL queries and visualized the data within Synapse Studio.

---

## 📊 Example SQL Analyses

- Top 10 countries by total medals
- Gender participation ratios per discipline
- Medal distribution by discipline
- Countries winning medals in the most disciplines
- Athletes with multiple discipline participation

👉 Full query list: [`SQL script.sql`](https://github.com/alicorduk/Azure-Data-Engineer---Tokyo-olympicData/blob/main/SQL%20script.sql)

---

## 📸 Screenshot

| Synapse Tables |
|----------------|
![Synapse Analytics](https://github.com/alicorduk/Azure-Data-Engineer---Tokyo-olympicData/blob/main/Synapse%20Analytics.png)


---

## 📈 Optional Next Steps

- Create Power BI dashboard via Synapse connection
- Schedule pipeline runs using ADF triggers
- Automate Spark notebooks using Azure Job APIs
- Register datasets in Unity Catalog

---

## 📁 Repo Structure

tokyo-olympics-data-engineering/
│
notebooks/ # Databricks ETL notebooks (.ipynb)
   
synapse/ # SQL scripts for table creation & analytics
   
screenshots/ # Output images (UI, SQL results)
   
README.md # This file

