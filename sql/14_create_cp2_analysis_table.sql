-- Build one cleaned 2018 model row per unique_key; see sql/README.md.
CREATE OR REPLACE TABLE `stately-mote-509700-r8.busm410_cp2.taxi_tip_analysis_2018` AS
WITH one_per_key AS (
  SELECT
    unique_key,
    MAX(trip_start_timestamp) AS trip_start_timestamp,
    MAX(payment_type) AS payment_type_raw,
    MAX(fare) AS fare,
    MAX(tips) AS tips,
    MAX(trip_miles) AS trip_miles_raw,
    MAX(trip_seconds) AS trip_seconds_raw,
    MAX(pickup_community_area) AS pickup_community_area_raw,
    MAX(company) AS company_raw
  FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
  WHERE DATE(trip_start_timestamp) >= DATE '2018-01-01'
    AND DATE(trip_start_timestamp) < DATE '2019-01-01'
    AND unique_key IS NOT NULL
  GROUP BY unique_key
)
SELECT
  unique_key,
  trip_start_timestamp,
  SAFE_DIVIDE(tips, fare) AS tip_to_fare_rate,
  COALESCE(CAST(payment_type_raw AS STRING), 'Unknown') AS payment_type,
  COALESCE(CAST(company_raw AS STRING), 'Unknown') AS company,
  COALESCE(CAST(pickup_community_area_raw AS STRING), 'Unknown') AS pickup_community_area,
  EXTRACT(MONTH FROM trip_start_timestamp) AS trip_month,
  EXTRACT(HOUR FROM trip_start_timestamp) AS trip_hour,
  EXTRACT(DAYOFWEEK FROM trip_start_timestamp) AS trip_day_of_week,
  trip_miles_raw IS NULL AS trip_miles_missing,
  COALESCE(trip_miles_raw, 0) AS trip_miles,
  trip_seconds_raw IS NULL AS trip_seconds_missing,
  COALESCE(trip_seconds_raw, 0) AS trip_seconds
FROM one_per_key
WHERE fare > 0
  AND tips IS NOT NULL;
