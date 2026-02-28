-- ============================================================
-- EXPORT FINAL ANALYTICAL DATASET
-- Save flight_enriched as CSV for further analysis
-- ============================================================

COPY flight_enriched
TO 'output/flight_enriched.csv'
(HEADER, DELIMITER ',');
