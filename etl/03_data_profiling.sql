-- ============================================================
-- DATA PROFILING LAYER
-- Assess data quality before transformation
-- ============================================================
-- ------------------------------------------------------------
-- 1. CHECK TABLE STRUCTURE
-- ------------------------------------------------------------
DESCRIBE flight_selected;
-- ------------------------------------------------------------
-- 2. CHECK TOTAL NUMBER OF ROWS
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_rows
FROM flight_selected;
-- ------------------------------------------------------------
-- 3. CHECK DUPLICATE FLIGHT RECORDS
-- Business grain: one row per flight
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (
        "FlightDate",
        "Operating_Airline ",
        "Origin",
        "Dest",
        "CRSElapsedTime"
    )) AS unique_rows
FROM flight_selected;
-- ------------------------------------------------------------
-- 4. CHECK MISSING VALUES
-- Identify NULL distribution across columns
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN "DepDelay" IS NULL THEN 1 ELSE 0 END) AS depdelay_null,
    SUM(CASE WHEN "ArrDelay" IS NULL THEN 1 ELSE 0 END) AS arrdelay_null,
    SUM(CASE WHEN "CarrierDelay" IS NULL THEN 1 ELSE 0 END) AS carrierdelay_null,
    SUM(CASE WHEN "WeatherDelay" IS NULL THEN 1 ELSE 0 END) AS weatherdelay_null,
    SUM(CASE WHEN "NASDelay" IS NULL THEN 1 ELSE 0 END) AS nasdelay_null,
    SUM(CASE WHEN "SecurityDelay" IS NULL THEN 1 ELSE 0 END) AS securitydelay_null,
    SUM(CASE WHEN "LateAircraftDelay" IS NULL THEN 1 ELSE 0 END) AS lateaircraftdelay_null
FROM flight_selected;

-- ------------------------------------------------------------
-- 5. CHECK VALUE DOMAIN FOR STATUS COLUMNS
-- Ensure only valid flags exist
-- ------------------------------------------------------------
SELECT "Cancelled", COUNT(*) FROM flight_selected GROUP BY "Cancelled";
SELECT "Diverted", COUNT(*) FROM flight_selected GROUP BY "Diverted";
