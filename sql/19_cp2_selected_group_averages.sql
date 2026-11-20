-- Show average tip rates for the selected Part A splits and candidate drivers.
WITH analysis AS (
  SELECT *
  FROM `stately-mote-509700-r8.busm410_cp2.taxi_tip_analysis_2018`
), summaries AS (
  SELECT 'Payment type' AS dimension, payment_type AS value,
         COUNT(*) AS trip_count, AVG(tip_to_fare_rate) AS average_tip_rate
  FROM analysis GROUP BY payment_type
  UNION ALL
  SELECT 'Month', CAST(trip_month AS STRING), COUNT(*), AVG(tip_to_fare_rate)
  FROM analysis GROUP BY trip_month
  UNION ALL
  SELECT 'Trip hour', CAST(trip_hour AS STRING), COUNT(*), AVG(tip_to_fare_rate)
  FROM analysis GROUP BY trip_hour
  UNION ALL
  SELECT 'Company', company, COUNT(*), AVG(tip_to_fare_rate)
  FROM analysis GROUP BY company
)
SELECT dimension, value, trip_count, average_tip_rate
FROM summaries
ORDER BY dimension, value;
