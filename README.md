# 📊 End-to-End Data Warehousing Project with Snowflake, S3 and ELT

## ✨ Project Overview

This project showcases my ability to design and implement an end-to-end data warehousing pipeline using **AWS S3**, **Snowflake**, and **SQL-based ELT**. I replicated a real-world scenario involving OLTP data ingestion, modelling a star schema, implementing Slowly Changing Dimensions (SCD), and handling both **initial** and **incremental loads**.

The project includes creating a raw data layer, staging layer, and dimensional data warehouse (DW) with **SCD Type 1 and Type 2** support, surrogate key handling, and performance-oriented design decisions.

---

## 🌐 Data Pipeline Flow

![flow_diagram3](https://github.com/user-attachments/assets/0bbb009f-b5f2-4574-8eed-7d40125e7d65)

---

### 🔁 Pipeline Sequence Breakdown

1. **📦 OLTP (Flat File) → 3NF Normalisation**

   * Input: `orders_transaction_snapshot.csv`
   * Goal: Break denormalised data into normalised tables (`cities`, `pincode`, `customers`, `products`, etc.)
   * Output: 3NF-formatted SQL tables (simulate OLTP)

2. **☁️ COPY INTO Snowflake from S3**

   * Upload the 3NF `.csv` files to S3
   * Load into **raw schema** in Snowflake using `COPY INTO`

3. **🔄 Staging Layer Transformation**

   * Join 3NF entities to create **flattened, enriched views**
   * Example: `stg_customers`, `stg_products` from multiple raw tables

4. **🌟 Star Schema (Dimensional Model)**

   * Create **dimension tables** (e.g. `customer_dim`, `product_dim`) and **fact tables**
   * Apply SCD logic (Type 1 or 2), surrogate keys, date ranges
   * Structure aligned with **analytics/OLAP consumption**

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

## 🧱 Why I Started from a 3NF OLTP Model

To simulate a real-world enterprise scenario, I started from a highly normalised **OLTP dataset in 3rd Normal Form (3NF)** which is typical of transactional systems.

OLTP systems handle high volumes of short, atomic transactions like orders or payments, prioritising data integrity and write efficiency. They use Third Normal Form (3NF) to reduce redundancy, enforce entity separation, and prevent update anomalies, ensuring clean, consistent source data for downstream analytics.

This allowed me to:
- ✅ Practise real-world **data modelling**
- ✅ Transition from **normalised OLTP** → **star schema**
- ✅ Extract clean, deduplicated dimension entities
- ✅ Build **referential integrity** from raw rows

The 3NF model was generated using SQL with window functions and joins from the OLTP source.

### 📂 Sample Orders Transaction File
The dataset used here is a **denormalised transaction file** that mimics an OLTP export. It contains flattened order data with repeated values across rows — ideal for normalisation.

[Sample OLTP Orders File](./sample_data/orders_transaction_snapshot.csv)

I applied **3rd Normal Form (3NF)** transformations on this file using SQL. These transformations decomposed the flat structure into atomic entities (e.g., `cities`, `pincode`, `customers`, etc.) based on the ER diagram. Below is an example of how I extracted the `cities` table from this transaction file:

### 🛠 Example 3NF Extraction: `cities` Table
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
```
### 🛠 Example 3NF Extraction: `pincode` Table
```sql
WITH cte AS (
  SELECT postal_code, cities.id AS city_id,
         ROW_NUMBER() OVER (PARTITION BY postal_code ORDER BY postal_code) AS rn
  FROM orders
  INNER JOIN cities ON cities.city = orders.city
  WHERE postal_code IS NOT NULL
)
SELECT ROW_NUMBER() OVER (ORDER BY postal_code) AS id,
       postal_code, city_id
INTO pincode
FROM cte
WHERE rn = 1;
```
### 🧱 Example: Customer Dimension Creation

After loading 3NF-normalised tables into Snowflake’s `raw` schema, I created staging views to flatten and enrich the data before loading into the data warehouse. Below is the logic used to build the `stg_customers` table by joining `customers`, `pincode`, and `cities`.

```sql
CREATE OR REPLACE TABLE stg.stg_customers AS
SELECT
    cus.id AS customer_id,
    cus.customer_name,
    cus.username,
    cus.segment,
    p.postal_code,
    c.city,
    c.state,
    c.region,
    c.country
FROM raw.pincode p
INNER JOIN raw.cities c ON p.city_id = c.id
INNER JOIN raw.customers cus ON cus.pincode_id = p.id;
```
This staging table is then used to populate the final dw.customer_dim, applying SCD Type 1 logic.

---

### 📜 Key SQL Scripts
* Full pipeline from raw → staging → dw :: [Link](./scripts/schema-scripts.sql)

* Incremental load logic for *customer_dim* (SCD Type 1) :: [Link](./scripts/SCD-type1.sql)

* Full SCD Type 2 handling for *product_dim*, including surrogate key, date versioning :: [Link](./scripts/SCD-type2.sql)

---

## 🌟 Covered in this project

* Real-world **Data Engineering pipeline design**
* **Dimensional modelling** for analytics use cases
* Strong command of **SQL transformations and SCD implementations**
* Handling **incremental data loads** and auditability

---

## 📄 Project Structure

```
elt-data-warehouse-snowflake/
├── README.md
├── /scripts/
│   ├── schema-scripts.sql
│   ├── SCD-type1.sql
│   └── SCD-type2.sql
├── /sample_data/
│   ├── customers.csv
│   └── products.csv
│   └── ...
├── /diagrams/
│   ├── ERD.png
│   └── star_schema.png
│   └── pipeline_flow.png

```

---

## 🚀 Future Enhancements

* Implement **data quality checks** (null filters, type checks, referential integrity validation)
* Add **dynamic parameterisation** for S3 folder paths and load dates
* Use **orchestration tools** (e.g., dbt, Airflow, or Snowflake Tasks) to automate pipeline stages
* Enhance **error handling and logging** during ELT steps
* Extend with **BI dashboards** using Power BI / Tableau to demonstrate consumption layer utility
