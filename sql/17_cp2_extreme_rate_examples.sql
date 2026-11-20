-- Inspect the largest source tip-to-fare ratios before deciding how to model them.
WITH one_per_key AS (
  SELECT
    unique_key,
    MAX(payment_type) AS payment_type,
    MAX(company) AS company,
    MAX(fare) AS fare,
    MAX(tips) AS tips
  FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
    AND DATE(trip_start_timestamp) < DATE '2019-01-01'
    AND unique_key IS NOT NULL
  GROUP BY unique_key
)
SELECT
  unique_key,
  payment_type,
  company,
  fare,
  tips,
  SAFE_DIVIDE(tips, fare) AS tip_to_fare_rate
FROM one_per_key
WHERE fare > 0 AND tips IS NOT NULL
ORDER BY tip_to_fare_rate DESC
LIMIT 20;
