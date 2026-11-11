-- Check month coverage around 2018–2019; method notes are in README.md.
SELECT FORMAT_DATE('%Y-%m', DATE(trip_start_timestamp)) AS trip_month, COUNT(*) AS trip_count
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
  AND DATE(trip_start_timestamp) < DATE '2020-01-01'
GROUP BY trip_month
ORDER BY trip_month;
