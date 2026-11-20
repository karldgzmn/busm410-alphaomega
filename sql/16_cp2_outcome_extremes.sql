-- Quantify extreme tip-to-fare rates before selecting the regression treatment.
SELECT
  COUNT(*) AS analysis_rows,
  COUNTIF(tip_to_fare_rate > 0.5) AS rates_over_50_percent,
  COUNTIF(tip_to_fare_rate > 1) AS rates_over_100_percent,
  COUNTIF(tip_to_fare_rate > 10) AS rates_over_1000_percent,
  COUNTIF(tip_to_fare_rate > 100) AS rates_over_10000_percent,
  SAFE_DIVIDE(COUNTIF(tip_to_fare_rate > 1), COUNT(*)) AS share_over_100_percent,
  APPROX_QUANTILES(tip_to_fare_rate, 1000)[OFFSET(990)] AS p99_tip_to_fare_rate
FROM `stately-mote-509700-r8.busm410_cp2.taxi_tip_analysis_2018`;
