# SQL Process and Results

## Source and unit

The queries use the public BigQuery table `bigquery-public-data.chicago_taxi_trips.taxi_trips`. The City describes a row as a taxi trip, but the BigQuery table contains repeated `unique_key` values. For the 2018 tip comparison, one analysis row is one distinct `unique_key`.

## Query sequence

| File | Purpose |
|---|---|
| [01_schema.sql](01_schema.sql) | Confirm the public source table and its columns |
| [02_year_counts.sql](02_year_counts.sql) | Explore raw records by year |
| [03_monthly_counts.sql](03_monthly_counts.sql) | Check month-by-month coverage around the 2018–2019 break |
| [04_raw_tip_rates.sql](04_raw_tip_rates.sql) | Explore recorded fare and tip totals by payment type before cleaning |
| [05_duplicate_check.sql](05_duplicate_check.sql) | Compare 2018 raw rows with distinct trip keys |
| [06_duplicate_sample.sql](06_duplicate_sample.sql) | Inspect a repeated key |
| [07_duplicate_value_consistency.sql](07_duplicate_value_consistency.sql) | Check whether repeated keys differ on fields used in the tip analysis |
| [08_cleaning_check.sql](08_cleaning_check.sql) | Count blank, missing, nonpositive, and negative values after deduplication |
| [09_cleaned_tip_rates.sql](09_cleaned_tip_rates.sql) | Produce the final deduplicated 2018 benchmark comparison |

## Exploration and coverage choice

The first raw annual count showed 32,651,674 rows in 2018 and 16,409,864 in 2019. The monthly query showed that 2019 had 114,692 rows in July, 11 in October, and no rows for November or December. The City’s documentation says the trip reporting process does not capture every trip and describes significant data changes in July 2019. For these reasons, the raw 2018–2019 difference is not presented as a demand decline. The final comparison uses Cash and Credit Card trips within 2018 instead. The monthly query showed records in all 12 months of 2018, but that does not prove every trip was reported.

## Cleaning choices

- **Repeated records:** The 2018 table had 32,651,674 rows, 20,687,760 distinct keys, no missing `unique_key` values, and 11,963,914 rows beyond one per key. A separate check found 6,018,199 repeated keys and zero repeated keys with different values for `trip_start_timestamp`, `payment_type`, `fare`, or `tips`. A sample repeated key appeared three times with identical values. Query 09 uses `SELECT DISTINCT unique_key, payment_type, fare, tips` to keep one analytic record per key.
- **Missing or unusual fields:** On the deduplicated 2018 rows, there were 0 blank payment types, 1,291 missing fares, 12,491 fares at or below zero, 1,291 missing tips, and 0 negative tips. Query 09 retains only rows with `fare > 0` and non-null `tips`. Zero tips remain because the City says cash tips generally are not recorded; zero is not treated as an impossible value.
- **Date coverage:** Query 03 flags the abrupt 2019 monthly changes. The annual query returned no null-year group and no years later than 2023. The final comparison is restricted to 2018.
- **Totals:** The final query groups by payment type after deduplication and cleaning. The benchmark calculation is a same-year comparison; the estimated dollar value assumes cash trips have the same tip-to-fare rate as credit-card trips.

## Final clean results

| Payment type | Clean trips | Fare total | Recorded tips | Tips ÷ fare |
|---|---:|---:|---:|---:|
| Cash | 10,725,251 | $125,091,981.14 | $200,737.49 | 0.1605% |
| Credit Card | 9,666,719 | $156,410,526.65 | $34,991,372.78 | 22.3715% |

The rate difference is 22.2110 percentage points. Estimated additional cash tips are `(credit-card tips ÷ credit-card fares) × cash fares − recorded cash tips`, or about $27,784,208.52. This is an estimate of potentially unrecorded tips, not actual cash income.
