# 📊 End-to-End Data Warehousing Project with Snowflake, S3 and ELT

## ✨ Project Overview

This project showcases my ability to design and implement an end-to-end data warehousing pipeline using **AWS S3**, **Snowflake**, and **SQL-based ELT**. I replicated a real-world scenario involving OLTP data ingestion, modelling a star schema, implementing Slowly Changing Dimensions (SCD), and handling both **initial** and **incremental loads**.

The project includes creating a raw data layer, staging layer, and dimensional data warehouse (DW) with **SCD Type 1 and Type 2** support, surrogate key handling, and performance-oriented design decisions.

---

## 🔧 Tech Stack & Tools

* **Cloud Warehouse:** Snowflake
* **Storage:** AWS S3 (source layer)
* **Modelling:** Star Schema
* **Scripting:** SQL (DDL + DML + CTEs + Merge)
* **SCD Management:** Type 1 & Type 2
* **Transformation Strategy:** ELT (Extract-Load-Transform)
* **Data Partitioning:** Calendar-based folders in S3
* **Optional Tooling:** Lucidchart (for ERD), Excel (for validation)

---

## 🤝 Key Steps

### ✍️ Data Modelling

* Designed **conceptual, logical and physical** data models
* Practised **normalisation (1NF, 2NF, 3NF)** and when to denormalise for DW
* Built **ER diagrams** and star schemas with clear fact/dimension separation

### 📁 Data Warehouse Design

* Created **raw, staging and consumption layers**
* Implemented **SCD Type 1** (overwrite) and **Type 2** (historical tracking)
* Generated **surrogate keys** for performance and compatibility
* Managed **dimension and fact table loads** with correct sequencing
* Built reusable **calendar dimension** with recursive CTEs

### ⚙️ ELT & Automation

* Loaded data from S3 to Snowflake using `COPY INTO` statements
* Applied `INSERT`, `UPDATE`, `MERGE` logic to handle incremental loads
* Used **last\_updated\_at** timestamp field to drive delta ingestion
