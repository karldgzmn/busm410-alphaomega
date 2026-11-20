-- Train on a deterministic 10% sample after full-table training hit the free-storage quota.
CREATE OR REPLACE MODEL `stately-mote-509700-r8.busm410_cp2.tip_rate_model_2018`
OPTIONS (
  model_type = 'linear_reg',
  input_label_cols = ['tip_to_fare_rate'],
  calculate_p_values = TRUE,
  category_encoding_method = 'DUMMY_ENCODING',
  max_iterations = 50,
  early_stop = FALSE
) AS
SELECT
  tip_to_fare_rate,
  payment_type,
  company,
  pickup_community_area,
  CAST(trip_month AS STRING) AS trip_month,
  CAST(trip_hour AS STRING) AS trip_hour,
  CAST(trip_day_of_week AS STRING) AS trip_day_of_week,
  trip_miles,
  trip_miles_missing,
  trip_seconds,
  trip_seconds_missing
FROM `stately-mote-509700-r8.busm410_cp2.taxi_tip_analysis_2018`
WHERE MOD(ABS(FARM_FINGERPRINT(unique_key)), 10) = 0;
