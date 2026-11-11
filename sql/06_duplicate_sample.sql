-- Inspect one repeated 2018 key; method notes are in README.md.
SELECT unique_key, trip_start_timestamp, payment_type, fare, tips
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE unique_key = '18654bb365f37c62ea4191bff30b36461c3a0e0f'
  AND DATE(trip_start_timestamp) >= DATE '2018-01-01'
  AND DATE(trip_start_timestamp) < DATE '2019-01-01'
ORDER BY trip_start_timestamp;
