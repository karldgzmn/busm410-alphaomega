-- Count repeated keys in 2018; method notes are in README.md.
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT unique_key) AS distinct_keys,
       COUNTIF(unique_key IS NULL) AS missing_keys,
       COUNT(*) - COUNT(DISTINCT unique_key) - COUNTIF(unique_key IS NULL) AS duplicate_extra_rows
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
  AND DATE(trip_start_timestamp) < DATE '2019-01-01';
