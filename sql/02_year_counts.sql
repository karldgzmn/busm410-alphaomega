-- Explore raw trip rows by year; method notes are in README.md.
SELECT EXTRACT(YEAR FROM trip_start_timestamp) AS trip_year, COUNT(*) AS trip_count
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
GROUP BY trip_year
ORDER BY trip_year;
