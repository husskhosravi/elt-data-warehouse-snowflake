-- ======================================================
-- DATA WAREHOUSE SCHEMA: CUSTOMER DIMENSION (SCD TYPE 1)
-- ======================================================
CREATE OR REPLACE TABLE dw.customer_dim (
    customer_key INT IDENTITY(1,1),  -- surrogate key
    customer_id NUMBER(38,0),
    customer_name VARCHAR(255),
    username VARCHAR(255),
    segment VARCHAR(255),
    postal_code VARCHAR(20),
    city VARCHAR(255),
    state VARCHAR(255),
    region VARCHAR(255),
    country VARCHAR(255)
);

-- ======================================================
-- FIRST LOAD INTO CUSTOMER_DIM FROM STAGING
-- ======================================================
INSERT INTO dw.customer_dim (
    customer_id, customer_name, username, segment,
    postal_code, city, state, region, country
)
SELECT
    customer_id, customer_name, username, segment,
    postal_code, city, state, region, country
FROM stg.stg_customers;
-- ======================================================
-- INCREMENTAL LOAD – CUSTOMER_DIM (SCD TYPE 1)
-- ======================================================
-- This logic applies updates to existing customers (overwrite style)
-- and inserts new customers based on customer_id
-- No historical tracking is retained

-- ======================================================
-- Step 1: UPDATE existing customers in CUSTOMER_DIM
-- Overwrite fields like segment and postal_code based on latest staging data
-- ======================================================
UPDATE dw.customer_dim
SET
    segment     = stg.segment,
    postal_code = stg.postal_code
FROM stg.stg_customers stg
WHERE stg.customer_id = dw.customer_dim.customer_id;

-- ======================================================
-- Step 2: INSERT new customers not already present in CUSTOMER_DIM
-- ======================================================
INSERT INTO dw.customer_dim (
    customer_id, customer_name, username, segment,
    postal_code, city, state, region, country
)
SELECT
    customer_id, customer_name, username, segment,
    postal_code, city, state, region, country
FROM stg.stg_customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM dw.customer_dim
);
