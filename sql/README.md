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
| [10_create_cp2_dataset.sql](10_create_cp2_dataset.sql) | Create the US-region CP2 workspace |
| [11_model_duplicate_check.sql](11_model_duplicate_check.sql)–[13_model_duplicate_conflict.sql](13_model_duplicate_conflict.sql) | Recheck duplicate counts and inspect the one key with a null/non-null category conflict |
| [14_create_cp2_analysis_table.sql](14_create_cp2_analysis_table.sql) | Build one clean model row per eligible 2018 `unique_key` |
| [15_cp2_table_quality.sql](15_cp2_table_quality.sql)–[19_cp2_selected_group_averages.sql](19_cp2_selected_group_averages.sql) | Check the outcome and predictors; compare rates by month, area, payment type, company, and hour |
| [20_cp2_train_model.sql](20_cp2_train_model.sql) | Attempt full-table linear regression; BigQuery stopped it at the project free-storage quota |
| [21_cp2_storage_check.sql](21_cp2_storage_check.sql) | Check project table storage (permission denied for project-level metadata) |
| [22_cp2_train_model_sample.sql](22_cp2_train_model_sample.sql) | Train the final model on a deterministic 10% sample |
| [23_cp2_model_evaluation.sql](23_cp2_model_evaluation.sql) | Evaluate the held-out sample |
| [24_cp2_advanced_weights.sql](24_cp2_advanced_weights.sql) | Retrieve adjusted model coefficients and p-values |
| [25_cp2_model_sample_size_check.sql](25_cp2_model_sample_size_check.sql) | Check the model sample and independently count full-table rows |

## Exploration and coverage choice

The first raw annual count showed 32,651,674 rows in 2018 and 16,409,864 in 2019. The monthly query showed that 2019 had 114,692 rows in July, 11 in October, and no rows for November or December. The City’s documentation says the trip reporting process does not capture every trip and describes significant data changes in July 2019. For these reasons, the raw 2018–2019 difference is not presented as a demand decline. The final comparison uses Cash and Credit Card trips within 2018 instead. The monthly query showed records in all 12 months of 2018, but that does not prove every trip was reported.

## Cleaning choices

- **Repeated records:** The 2018 table had 32,651,674 rows, 20,687,760 distinct keys, no missing `unique_key` values, and 11,963,914 rows beyond one per key. A separate check found 6,018,199 repeated keys and zero repeated keys with different values for `trip_start_timestamp`, `payment_type`, `fare`, or `tips`. A sample repeated key appeared three times with identical values. Query 09 uses `SELECT DISTINCT unique_key, payment_type, fare, tips` to keep one analytic record per key.
- **Missing or unusual fields:** On the deduplicated 2018 rows, there were 0 blank payment types, 1,291 missing fares, 12,491 fares at or below zero, 1,291 missing tips, and 0 negative tips. Query 09 retains only rows with `fare > 0` and non-null `tips`. Zero tips remain because the City says cash tips generally are not recorded; zero is not treated as an impossible value.
- **Date coverage:** Query 03 flags the abrupt 2019 monthly changes. The annual query returned no null-year group and no years later than 2023. The final comparison is restricted to 2018.
- **Totals:** The final query groups by payment type after deduplication and cleaning. The benchmark calculation is a same-year comparison; the estimated dollar value assumes cash trips have the same tip-to-fare rate as credit-card trips.

The CP1 result table above records the counts from the original CP1 run. The public source is mutable: a CP2 rerun found different 2018 counts (33,262,714 raw rows, 20,365,539 distinct keys before outcome cleaning). CP2 therefore uses its current table count and results below; do not mix its refreshed rows with the earlier CP1 totals.

## CP2 analysis table and cleaning

The table `stately-mote-509700-r8.busm410_cp2.taxi_tip_analysis_2018` has **20,352,588** eligible rows, one per distinct key ([quality check](15_cp2_table_quality.sql)). It keeps 2018 rows with a non-null `unique_key`, positive fare, and recorded (including zero) tips. For the one repeated key with different model fields, timestamp and numeric fields match; one duplicate has null payment type/company and one has Credit Card/Flash Cab ([duplicate inspection](13_model_duplicate_conflict.sql)). The table aggregates each key with `MAX`, which takes the available non-null category values for that key. The other 6,951,459 repeated keys matched across the planned model fields ([duplicate check](11_model_duplicate_check.sql)).

The outcome is `tips / fare` for each trip. Predictors are payment type, company, pickup community area, month, hour, day of week, miles, duration, and two missing-value flags. `fare` and `tips` are not predictors because they define the outcome. Blank categories become `Unknown`; 22 missing mile values and 1,601 missing duration values become zero and have corresponding flags. There are 53,021 unknown payment types and 1,097,162 unknown pickup areas. The table has no null or negative outcomes, no negative miles or durations, and no null model inputs ([quality check](15_cp2_table_quality.sql)). The maximum outcome rate is 10,100; 80,751 rows exceed 100% ([extreme check](16_cp2_outcome_extremes.sql)). The largest examples pair a $0.01 fare with $40–$101 recorded tips ([examples](17_cp2_extreme_rate_examples.sql)). These remain in the model because the source alone does not prove they are invalid; they are a major limitation.

Part A shows large month and location variation, but those means are sensitive to the extreme records ([query 18](18_cp2_part_a_splits_and_suspects.sql)). By payment type, the mean trip-level rate is 0.0030 for Cash and 2.6107 for Credit Card; this is the mean of trip-level ratios, so it differs from CP1's ratio of total tips to total fares ([query 19](19_cp2_selected_group_averages.sql)). For the complete splits and suspect summaries see the [model card](../model/model_card.md).

## CP2 model results

The full-table model training attempt failed because the project exceeded its BigQuery free-storage quota. The model was retrained on a deterministic hash sample of 2,034,470 rows (about 10%); the full analysis table remains available. Evaluation on BigQuery ML's held-out portion of that sample returned `r2_score = 0.1024`, `mean_absolute_error = 4.4951`, and `mean_squared_error = 1003.3796`. The model explains little of the outcome variation and is not ready for prediction. The most prominent adjusted associations include Credit Card payment type and 303 Taxi company, but the latter is likely dominated by extreme $0.01-fare records; coefficients are not causal effects. See [model card](../model/model_card.md) and queries 22–24.

## Final clean results

| Payment type | Clean trips | Fare total | Recorded tips | Tips ÷ fare |
|---|---:|---:|---:|---:|
| Cash | 10,725,251 | $125,091,981.14 | $200,737.49 | 0.1605% |
| Credit Card | 9,666,719 | $156,410,526.65 | $34,991,372.78 | 22.3715% |

The rate difference is 22.2110 percentage points. Estimated additional cash tips are `(credit-card tips ÷ credit-card fares) × cash fares − recorded cash tips`, or about $27,784,208.52. This is an estimate of potentially unrecorded tips, not actual cash income.
