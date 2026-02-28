-- ============================================================
-- RAW LAYER
-- Load source parquet into DuckDB
-- ============================================================

CREATE OR REPLACE TABLE flight_raw AS
SELECT *
FROM read_parquet('data/flight_data.parquet');

-- Preview raw data
SELECT *
FROM flight_raw
LIMIT 10;

-- Check table structure
DESCRIBE flight_raw;
