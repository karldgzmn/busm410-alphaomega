-- Explore uncleaned 2018 tip totals by payment type; method notes are in README.md.
SELECT payment_type, COUNT(*) AS trips, SUM(fare) AS total_fare,
       SUM(tips) AS recorded_tips,
       SAFE_DIVIDE(SUM(tips), SUM(fare)) AS tip_to_fare_rate
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
  AND DATE(trip_start_timestamp) < DATE '2019-01-01'
GROUP BY payment_type
ORDER BY trips DESC;
