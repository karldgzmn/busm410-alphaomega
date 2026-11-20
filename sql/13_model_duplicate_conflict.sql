-- Inspect the repeated key that differs on planned model fields; see sql/README.md.
WITH conflicts AS (
  SELECT unique_key
  FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
    AND DATE(trip_start_timestamp) < DATE '2019-01-01'
  GROUP BY unique_key
  HAVING COUNT(DISTINCT TO_JSON_STRING(STRUCT(
    trip_start_timestamp, payment_type, fare, tips,
    trip_miles, trip_seconds, pickup_community_area, company
  ))) > 1
)
SELECT t.unique_key, t.trip_start_timestamp, t.payment_type, t.fare, t.tips,
       t.trip_miles, t.trip_seconds, t.pickup_community_area, t.company
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips` AS t
JOIN conflicts USING (unique_key)
WHERE DATE(t.trip_start_timestamp) >= DATE '2018-01-01'
  AND DATE(t.trip_start_timestamp) < DATE '2019-01-01'
ORDER BY t.unique_key, t.trip_start_timestamp;
