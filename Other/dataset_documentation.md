# Chicago Taxi Trips documentation

## Source

- BigQuery table: [`bigquery-public-data.chicago_taxi_trips.taxi_trips`](https://docs.cloud.google.com/bigquery/docs/data-canvas)
- City source: [Taxi Trips (2013–2023)](https://data.cityofchicago.org/Transportation/Taxi-Trips-2013-2023-/wrvz-psew)
- The City says the dataset includes trips reported to it, that not all trips are reported, and that cash tips generally are not recorded. Times are rounded to the nearest 15 minutes. The table is intended for aggregate analysis; some census-tract locations are suppressed.

## BigQuery schema

Types and descriptions below are from the BigQuery table schema. The project confirmed the column names using `INFORMATION_SCHEMA.COLUMNS` and read the field types and descriptions from the public table schema.

| Column | BigQuery type | Description |
|---|---|---|
| `unique_key` | STRING, required | Unique identifier for the trip |
| `taxi_id` | STRING, required | Unique identifier for the taxi |
| `trip_start_timestamp` | TIMESTAMP | Start time, rounded to 15 minutes |
| `trip_end_timestamp` | TIMESTAMP | End time, rounded to 15 minutes |
| `trip_seconds` | INTEGER | Trip duration in seconds |
| `trip_miles` | FLOAT | Trip distance in miles |
| `pickup_census_tract` | INTEGER | Pickup census tract; may be suppressed |
| `dropoff_census_tract` | INTEGER | Dropoff census tract; may be suppressed |
| `pickup_community_area` | INTEGER | Pickup community area |
| `dropoff_community_area` | INTEGER | Dropoff community area |
| `fare` | FLOAT | Fare for the trip |
| `tips` | FLOAT | Tip for the trip; cash tips generally are not recorded |
| `tolls` | FLOAT | Tolls for the trip |
| `extras` | FLOAT | Extra charges |
| `trip_total` | FLOAT | Fare, tips, tolls, and extras total |
| `payment_type` | STRING | Payment type |
| `company` | STRING | Taxi company |
| `pickup_latitude` | FLOAT | Pickup area latitude |
| `pickup_longitude` | FLOAT | Pickup area longitude |
| `pickup_location` | STRING | Pickup area location |
| `dropoff_latitude` | FLOAT | Dropoff area latitude |
| `dropoff_longitude` | FLOAT | Dropoff area longitude |
| `dropoff_location` | STRING | Dropoff area location |

The source is one denormalized trip table, so this project does not join it to another table. See [the DBML table diagram](table_diagram.dbml).
