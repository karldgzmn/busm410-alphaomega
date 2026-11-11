-- Count 2018 missing and unusual values after key deduplication; method notes are in README.md.
WITH trips AS (
  SELECT DISTINCT unique_key, payment_type, fare, tips
  FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
    AND DATE(trip_start_timestamp) < DATE '2019-01-01'
)
SELECT COUNTIF(payment_type IS NULL OR TRIM(payment_type) = '') AS blank_payment_types,
       COUNTIF(fare IS NULL) AS missing_fares,
       COUNTIF(fare <= 0) AS nonpositive_fares,
       COUNTIF(tips IS NULL) AS missing_tips,
       COUNTIF(tips < 0) AS negative_tips
FROM trips;
