-- ============================================================
-- FEATURE ENGINEERING LAYER
-- Create business-ready analytical dataset
-- Source  : flight_clean
-- Output  : flight_enriched
-- Grain   : 1 row = 1 completed flight
-- ============================================================

CREATE OR REPLACE TABLE flight_enriched AS
SELECT

    -- Keep all cleaned columns
    *,

    -- --------------------------------------------------------
    -- 1. DELAY KPI FLAG
    -- Industry standard: delayed if arrival delay > 15 minutes
    -- --------------------------------------------------------
    CASE
        WHEN "ArrDelay" > 15 THEN 1
        ELSE 0
    END AS is_delayed,

    -- --------------------------------------------------------
    -- 2. DELAY SEVERITY CATEGORY
    -- Used for performance segmentation
    -- --------------------------------------------------------
    CASE
        WHEN "ArrDelay" <= 15 THEN 'On Time'
        WHEN "ArrDelay" BETWEEN 16 AND 60 THEN 'Minor Delay'
        WHEN "ArrDelay" BETWEEN 61 AND 180 THEN 'Major Delay'
        ELSE 'Severe Delay'
    END AS delay_severity,

    -- --------------------------------------------------------
    -- 3. ROUTE IDENTIFIER
    -- Enables route-level performance analysis
    -- --------------------------------------------------------
    "Origin" || '-' || "Dest" AS flight_route,

    -- --------------------------------------------------------
    -- 4. DISTANCE CATEGORY
    -- Compare short, medium, and long haul performance
    -- --------------------------------------------------------
    CASE
        WHEN "Distance" < 500 THEN 'Short Haul'
        WHEN "Distance" BETWEEN 500 AND 1500 THEN 'Medium Haul'
        ELSE 'Long Haul'
    END AS distance_group,

    -- --------------------------------------------------------
    -- 5. TIME-BASED FEATURES
    -- Support time-series and seasonality analysis
    -- --------------------------------------------------------

    EXTRACT(YEAR FROM "FlightDate") AS flight_year,
    EXTRACT(MONTH FROM "FlightDate") AS flight_month,

    -- Day of week number (0 = Sunday, 6 = Saturday)
    STRFTIME("FlightDate", '%w') AS flight_day_of_week_num,

    -- Weekend indicator
    CASE
        WHEN STRFTIME("FlightDate", '%w') IN ('0','6') THEN 1
        ELSE 0
    END AS is_weekend

  -- ------------------------------------------------------------
-- VALIDATION: ROW COUNT
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_rows
FROM flight_enriched;


-- ------------------------------------------------------------
-- PREVIEW ENRICHED DATASET
-- ------------------------------------------------------------
SELECT *
FROM flight_enriched
LIMIT 100;

FROM flight_clean;
