-- Check repeated keys for differences in analysis fields; method notes are in README.md.
WITH keyed AS (
  SELECT unique_key, COUNT(*) AS row_count,
         COUNT(DISTINCT TO_JSON_STRING(STRUCT(
           trip_start_timestamp, payment_type, fare, tips
         ))) AS value_versions
  FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
    AND DATE(trip_start_timestamp) < DATE '2019-01-01'
  GROUP BY unique_key
)
SELECT COUNTIF(row_count > 1) AS repeated_keys,
       COUNTIF(row_count > 1 AND value_versions > 1) AS repeated_keys_with_different_values
FROM keyed;
