-- Confirm source columns; method notes are in README.md.
SELECT table_name, column_name
FROM `bigquery-public-data.chicago_taxi_trips.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'taxi_trips'
ORDER BY ordinal_position;
