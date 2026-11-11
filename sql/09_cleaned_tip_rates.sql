-- Compare cleaned 2018 tips by payment type; method notes are in README.md.
WITH trips AS (
  SELECT DISTINCT unique_key, payment_type, fare, tips
  FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
    AND DATE(trip_start_timestamp) < DATE '2019-01-01'
)
SELECT payment_type, COUNT(*) AS trip_count, SUM(fare) AS total_fare,
       SUM(tips) AS recorded_tips,
       SAFE_DIVIDE(SUM(tips), SUM(fare)) AS tip_to_fare_rate
FROM trips
WHERE fare > 0 AND tips IS NOT NULL
GROUP BY payment_type
ORDER BY trip_count DESC;
