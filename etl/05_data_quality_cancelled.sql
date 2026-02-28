-- ============================================================
-- DATA QUALITY CHECK: CANCELLED FLIGHTS
-- Evaluate impact before removing from analytical dataset
-- Source table: flight_dedup
-- ============================================================


-- ------------------------------------------------------------
-- 1. DISTRIBUTION OF CANCELLED VS OPERATED FLIGHTS
-- Purpose:
--   Understand how many records will be excluded
-- ------------------------------------------------------------
SELECT
    'Cancelled distribution' AS check_type,
    "Cancelled",
    COUNT(*) AS total_rows
FROM flight_dedup
GROUP BY "Cancelled"
ORDER BY "Cancelled";


-- ------------------------------------------------------------
-- 2. CANCELLATION RATE
-- Purpose:
--   Measure percentage of data to be removed
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN "Cancelled" = 1 THEN 1 ELSE 0 END) AS cancelled_rows,
    ROUND(
        100.0 * SUM(CASE WHEN "Cancelled" = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS cancelled_percentage
FROM flight_dedup;


-- ------------------------------------------------------------
-- 3. PREVIEW CANCELLED RECORDS
-- Purpose:
--   Confirm they contain no operational delay metrics
-- ------------------------------------------------------------
SELECT *
FROM flight_dedup
WHERE "Cancelled" = 1
LIMIT 100;


-- ------------------------------------------------------------
-- 4. VALIDATE DELAY METRICS FOR CANCELLED FLIGHTS
-- Purpose:
--   Ensure delay columns are NULL (not analytically usable)
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_cancelled_rows,
    SUM(CASE WHEN "DepDelay" IS NULL THEN 1 ELSE 0 END) AS depdelay_null,
    SUM(CASE WHEN "ArrDelay" IS NULL THEN 1 ELSE 0 END) AS arrdelay_null
FROM flight_dedup
WHERE "Cancelled" = 1;
