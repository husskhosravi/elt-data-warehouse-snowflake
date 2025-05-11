# 📊 End-to-End Data Warehousing Project with Snowflake, S3 and ELT

## ✨ Project Overview

This project showcases my ability to design and implement an end-to-end data warehousing pipeline using **AWS S3**, **Snowflake**, and **SQL-based ELT**. I replicated a real-world scenario involving OLTP data ingestion, modelling a star schema, implementing Slowly Changing Dimensions (SCD), and handling both **initial** and **incremental loads**.

The project includes creating a raw data layer, staging layer, and dimensional data warehouse (DW) with **SCD Type 1 and Type 2** support, surrogate key handling, and performance-oriented design decisions.

---

## 🔧 Tech Stack & Tools

* **Cloud Warehouse:** Snowflake
* **Storage:** AWS S3 (source layer)
* **Modelling:** Star Schema
* **Scripting:** SQL (DDL + DML + CTEs)
* **SCD Management:** Type 1 & Type 2
* **Transformation Strategy:** ELT (Extract-Load-Transform)
* **Data Partitioning:** Calendar-based folders in S3
* **Optional Tooling:** Lucidchart (for ERD), Excel (for validation)

---

## 🤝 Key Learnings

### ✍️ Data Modelling

* Designed **conceptual, logical and physical** data models
* Practised **normalisation (1NF, 2NF, 3NF)** and when to denormalise for DW
* Built **ER diagrams** and star schemas with clear fact/dimension separation

### 📁 Data Warehouse Design

* Created **raw, staging and consumption layers**
* Implemented **SCD Type 1** for customers (overwrite) and **SCD Type 2** for products (historical tracking)
* Generated **surrogate keys** for performance and compatibility
* Managed **dimension and fact table loads** with correct sequencing
* Built reusable **calendar dimension** with recursive CTEs

### ⚙️ ELT & Automation

* Loaded data from S3 to Snowflake using `COPY INTO` statements
* Applied `INSERT` and `UPDATE` logic to handle incremental loads
* Developed logic for detecting and processing delta data using timestamp columns like `last_updated_at`
* Created reusable SQL scripts for staging and DW layer loads to support repeatable execution and scheduling
* Partitioned S3 by date folder structure (e.g., `/2024/12/20/`) for daily automation

---

## 🌐 Data Pipeline Flow

![flow_diagram3](https://github.com/user-attachments/assets/0bbb009f-b5f2-4574-8eed-7d40125e7d65)

---

## 📄 Project Structure

```
data_warehouse_project/
├── README.md
├── /sql_scripts/
│   ├── create_tables.sql
│   ├── load_initial_data.sql
│   └── incremental_load.sql
├── /sample_data/
│   ├── customers.csv
│   └── products.csv
│   └── other files
├── /diagrams/
│   ├── ERD.png
│   └── star_schema.png
│   └── pipeline_flow.png

```

---
## 🧱 Why I Started from a 3NF OLTP Model

To simulate a real-world enterprise scenario, I started from a highly normalised **OLTP dataset in 3rd Normal Form (3NF)** — typical of transactional systems.

This allowed me to:
- ✅ Practise real-world **data modelling**
- ✅ Transition from **normalised OLTP** → **star schema**
- ✅ Extract clean, deduplicated dimension entities
- ✅ Build **referential integrity** from raw rows

The 3NF model was generated using SQL with window functions and joins from the OLTP source.

### 📂 Sample Source
File: `sample_data/orders_OLTP_sample.csv`

### 🛠 Example: `cities` Table
```sql
WITH cte AS (
  SELECT city, state, region, country,
         ROW_NUMBER() OVER (PARTITION BY city ORDER BY orders.order_date) AS rn
  FROM orders
)
SELECT ROW_NUMBER() OVER (ORDER BY city) AS id,
       city, region, country
INTO cities
FROM cte
WHERE rn = 1;



## 🌟 Covered in this project

* Real-world **Data Engineering pipeline design**
* **Dimensional modelling** for analytics use cases
* Strong command of **SQL transformations and SCD implementations**
* ELT vs ETL trade-offs
* Handling **incremental data loads** and auditability

---

## 🚀 Future Enhancements

* Implement **data quality checks** (null checks, schema validation)
* Build **Power BI** or **Tableau** dashboards from DW layer
