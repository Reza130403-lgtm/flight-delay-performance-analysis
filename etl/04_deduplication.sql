-- ============================================================
-- DEDUPLICATION LAYER
-- Retain the most complete record per flight
-- Business grain: one row per operated flight
-- ============================================================

CREATE OR REPLACE TABLE flight_dedup AS
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                "FlightDate",
                "Operating_Airline ",
                "Origin",
                "Dest",
                "CRSElapsedTime"
            ORDER BY
                -- Priority 1: valid departure delay
                CASE WHEN "DepDelay" IS NOT NULL THEN 1 ELSE 2 END,
                -- Priority 2: valid arrival delay
                CASE WHEN "ArrDelay" IS NOT NULL THEN 1 ELSE 2 END,
                -- Priority 3: actual airtime available
                CASE WHEN "AirTime" IS NOT NULL THEN 1 ELSE 2 END,
                -- Priority 4: actual elapsed time available
                CASE WHEN "ActualElapsedTime" IS NOT NULL THEN 1 ELSE 2 END
        ) AS rn
    FROM flight_selected
) t
WHERE rn = 1;

-- ------------------------------------------------------------
-- VALIDATION: ROW COUNT BEFORE VS AFTER DEDUP
-- ------------------------------------------------------------
SELECT 'flight_selected' AS layer, COUNT(*) FROM flight_selected
UNION ALL
SELECT 'flight_dedup', COUNT(*) FROM flight_dedup;

-- ------------------------------------------------------------
-- VALIDATION: ENSURE NO DUPLICATE FLIGHTS REMAIN
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
FROM flight_dedup;
