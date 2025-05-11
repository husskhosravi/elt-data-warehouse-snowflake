-- ======================================================
-- DW SCHEMA: CREATE PRODUCT DIMENSION TABLE (SCD TYPE 2)
-- ======================================================
CREATE OR REPLACE TABLE dw.product_dim (
    product_key INT IDENTITY(1,1),  -- surrogate key
    product_id NUMBER(38,0),
    product_name VARCHAR(255),
    price NUMBER(6,2),
    sub_category VARCHAR(255),
    category VARCHAR(255),
    effective_date DATE,
    end_date DATE
);

-- ======================================================
-- INITIAL (FIRST) LOAD INTO PRODUCT_DIM
-- Each product is inserted with an 'effective_date' as yesterday
-- and an open-ended 'end_date' of 9999-12-31 to denote current version
-- ======================================================
INSERT INTO dw.product_dim (
    product_id, product_name, price, sub_category, category,
    effective_date, end_date
)
SELECT 
    product_id, product_name, price, sub_category, category,
    CURRENT_DATE - 1 AS effective_date,
    '9999-12-31'::DATE AS end_date
FROM stg.stg_products;

-- ======================================================
-- INCREMENTAL LOAD – SCD TYPE 2 HANDLING
-- Step 1: Expire current version of changed products
-- ======================================================
UPDATE dw.product_dim
SET end_date = CURRENT_DATE
FROM stg.stg_products
WHERE dw.product_dim.product_id = stg.stg_products.product_id
  AND dw.product_dim.end_date = '9999-12-31';

-- ======================================================
-- Step 2: Insert new version of the product with updated values
-- effective_date is set to tomorrow; end_date open-ended
-- ======================================================
INSERT INTO dw.product_dim (
    product_id, product_name, price, sub_category, category,
    effective_date, end_date
)
SELECT 
    product_id, product_name, price, sub_category, category,
    CURRENT_DATE + 1 AS effective_date,
    '9999-12-31'::DATE AS end_date
FROM stg.stg_products;
