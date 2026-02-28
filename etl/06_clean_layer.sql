-- ============================================================
-- CLEAN LAYER
-- Build analytical base table for flight delay analysis
-- Each row represents one completed and valid operated flight
-- ============================================================

CREATE OR REPLACE TABLE flight_clean AS
SELECT

    -- --------------------------------------------------------
    -- Convert FlightDate to DATE for time-series analysis
    -- --------------------------------------------------------
    CAST("FlightDate" AS DATE) AS FlightDate,

    "Year",
    "Month",
    "DayOfWeek",

    -- Flight identifiers
    "Operating_Airline ",
    "Origin",
    "OriginStateName",
    "Dest",
    "DestStateName",

    -- Core delay KPIs (must be available)
    "DepDelay",
    "ArrDelay",

    -- Delay flags
    "DepDel15",
    "ArrDel15",

    -- Flight status
    "Cancelled",
    "Diverted",

    -- Duration metrics
    "CRSElapsedTime",
    "ActualElapsedTime",
    "AirTime",

    -- Distance
    "Distance",

    -- Delay cause columns
    -- NULL means the delay type did not occur
    "CarrierDelay",
    "WeatherDelay",
    "NASDelay",
    "SecurityDelay",
    "LateAircraftDelay"

FROM flight_dedup

WHERE

    -- Keep only operated flights
    "Cancelled" = 0

    -- Remove diverted flights
    AND "Diverted" = 0

    -- Ensure KPI completeness
    AND "DepDelay" IS NOT NULL
    AND "ArrDelay" IS NOT NULL

    -- Remove non-physical or corrupted records
    AND "CRSElapsedTime" > 0
    AND "ActualElapsedTime" > 0
    AND "AirTime" > 0
    AND "Distance" > 0;


-- ------------------------------------------------------------
-- VALIDATION: ROW COUNT
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_rows
FROM flight_clean;


-- ------------------------------------------------------------
-- VALIDATION: ENSURE NO CANCELLED OR DIVERTED FLIGHTS
-- ------------------------------------------------------------
SELECT "Cancelled", COUNT(*) FROM flight_clean GROUP BY "Cancelled";
SELECT "Diverted", COUNT(*) FROM flight_clean GROUP BY "Diverted";


-- ------------------------------------------------------------
-- VALIDATION: ENSURE KPI COMPLETENESS
-- ------------------------------------------------------------
SELECT
    SUM(CASE WHEN "DepDelay" IS NULL THEN 1 ELSE 0 END) AS depdelay_null,
    SUM(CASE WHEN "ArrDelay" IS NULL THEN 1 ELSE 0 END) AS arrdelay_null
FROM flight_clean;
