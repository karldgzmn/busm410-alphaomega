-- Count the deterministic model sample and cross-check the full analysis table size.
SELECT
  COUNT(*) AS full_analysis_rows,
  COUNTIF(MOD(ABS(FARM_FINGERPRINT(unique_key)), 10) = 0) AS deterministic_model_sample_rows,
  COUNT(DISTINCT unique_key) AS distinct_analysis_keys
FROM `stately-mote-509700-r8.busm410_cp2.taxi_tip_analysis_2018`;
