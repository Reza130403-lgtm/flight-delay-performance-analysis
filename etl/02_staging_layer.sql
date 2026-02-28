-- ============================================================
-- STAGING LAYER
-- Select only relevant columns for flight delay analysis
-- This reduces data size and improves query performance
-- ============================================================

CREATE OR REPLACE TABLE flight_selected AS
SELECT
    "Year",
    "Month",
    "DayOfWeek",
    "FlightDate",
    "Operating_Airline ",
    "Origin",
    "OriginStateName",
    "Dest",
    "DestStateName",
    "DepDelay",
    "ArrDelay",
    "DepDel15",
    "ArrDel15",
    "Cancelled",
    "Diverted",
    "CRSElapsedTime",
    "ActualElapsedTime",
    "AirTime",
    "Distance",
    "CarrierDelay",
    "WeatherDelay",
    "NASDelay",
    "SecurityDelay",
    "LateAircraftDelay"
FROM flight_raw;

-- Preview staged data
SELECT *
FROM flight_selected
LIMIT 10;
