-- Reconcile current 2018 raw rows and distinct keys; see sql/README.md.
WITH keyed AS (
  SELECT unique_key, COUNT(*) AS rows_for_key
  FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
    AND DATE(trip_start_timestamp) < DATE '2019-01-01'
  GROUP BY unique_key
)
SELECT SUM(rows_for_key) AS total_rows,
       COUNTIF(unique_key IS NOT NULL) AS distinct_keys,
       COUNTIF(unique_key IS NULL) AS null_key_groups,
       COUNTIF(unique_key IS NOT NULL AND rows_for_key > 1) AS repeated_keys,
       SUM(rows_for_key) - COUNT(*) AS extra_rows_beyond_one_per_key
FROM keyed;
