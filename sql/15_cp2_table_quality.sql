-- Check coverage and cleaned model fields in the CP2 analysis table.
SELECT
  COUNT(*) AS analysis_rows,
  COUNT(DISTINCT unique_key) AS distinct_keys,
  COUNTIF(tip_to_fare_rate IS NULL) AS null_outcomes,
  COUNTIF(tip_to_fare_rate < 0) AS negative_outcomes,
  COUNTIF(payment_type = 'Unknown') AS unknown_payment_type,
  COUNTIF(company = 'Unknown') AS unknown_company,
  COUNTIF(pickup_community_area = 'Unknown') AS unknown_pickup_area,
  COUNTIF(trip_miles_missing) AS missing_trip_miles_filled_with_zero,
  COUNTIF(trip_seconds_missing) AS missing_trip_seconds_filled_with_zero,
  COUNTIF(trip_miles < 0) AS negative_trip_miles,
  COUNTIF(trip_seconds < 0) AS negative_trip_seconds,
  MIN(tip_to_fare_rate) AS min_tip_to_fare_rate,
  APPROX_QUANTILES(tip_to_fare_rate, 100)[OFFSET(50)] AS median_tip_to_fare_rate,
  APPROX_QUANTILES(tip_to_fare_rate, 100)[OFFSET(95)] AS p95_tip_to_fare_rate,
  MAX(tip_to_fare_rate) AS max_tip_to_fare_rate
FROM `stately-mote-509700-r8.busm410_cp2.taxi_tip_analysis_2018`;
