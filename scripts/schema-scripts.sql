-- ======================================================
-- RAW SCHEMA: CREATE TABLE TO HOLD CITY DATA
-- ======================================================
CREATE OR REPLACE TABLE raw.cities (
    id INT,
    city VARCHAR(255),
    state VARCHAR(255),
    region VARCHAR(255),
    country VARCHAR(255),
    last_updated_at DATE
);

-- ======================================================
-- COPY CITY DATA FROM S3 INTO RAW.CITIES
-- (Make sure to use secure credentials)
-- ======================================================
COPY INTO raw.cities
FROM 's3://<bucket>/orders/20241213/cities.csv'
CREDENTIALS = (
  aws_key_id = '****',
  aws_secret_key = '****'
)
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);

-- ======================================================
-- STAGING SCHEMA: CREATE CUSTOMER DIMENSION (JOINING 3NF TABLES)
-- ======================================================
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
