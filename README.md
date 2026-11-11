<div align="center">

# Α ALPHA & OMEGA Ω

### BUSM 410 · Team 1

*Brigham Young University–Hawaii*


</div>

## About the Project

This project studies Chicago taxi trips in BigQuery. For CP1, we measure how cash-tip under-recording differs from recorded credit-card tips in 2018 and estimate the value of the missing records.

## Team Members

| Name | Role | GitHub |
|------|------|--------|
| Karl De Guzman | Data Analyst | [@karldgzmn](https://github.com/karldgzmn) |
| James Illorin | Data Analyst | [@jameskyle99](https://github.com/jameskyle99) |

## Data Source

| | |
|---|---|
| **Platform** | Google BigQuery |
| **Query job project** | `stately-mote-509700-r8` |
| **Source table** | [`bigquery-public-data.chicago_taxi_trips.taxi_trips`](https://docs.cloud.google.com/bigquery/docs/data-canvas) |
| **Origin** | [City of Chicago Taxi Trips](https://data.cityofchicago.org/Transportation/Taxi-Trips-2013-2023-/wrvz-psew) |

```sql
-- Quick start
SELECT *
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
LIMIT 10;
```

## Problem Framing

After deduplicating 2018 records, one analysis row represents one distinct `unique_key` trip. Recorded cash tips were 0.1605% of cash fares, compared with 22.3715% for credit-card trips, a 22.2110 percentage-point gap. Credit-card trips are the same-year peer benchmark. Applying their tip-to-fare rate to cash fares gives this estimate: `($34,991,372.78 ÷ $156,410,526.65) × $125,091,981.14 − $200,737.49 = $27,784,208.52`. This is potential unrecorded cash tips, not actual cash income. The City says cash tips generally are not recorded ([source](https://data.cityofchicago.org/Transportation/Taxi-Trips-2013-2023-/wrvz-psew)); the amount is calculated from [query 09](sql/09_cleaned_tip_rates.sql). See [findings.md](findings.md) and [sql/README.md](sql/README.md) for details.

## Explore the Work

| File | Purpose |
|---|---|
| [charter.md](charter.md) | Question, decision, scope, and success criteria |
| [findings.md](findings.md) | Measured gap, benchmark, value estimate, and chart |
| [sql/README.md](sql/README.md) | Query process, cleaning choices, and matching results |
| [sql/01_schema.sql](sql/01_schema.sql)–[sql/09_cleaned_tip_rates.sql](sql/09_cleaned_tip_rates.sql) | Numbered, reproducible BigQuery queries |
| [visuals/gap_chart.png](visuals/gap_chart.png) | Cash and credit-card recorded tip rates |
| [Other/dataset_documentation.md](Other/dataset_documentation.md) | Dataset source, limits, and relevant field definitions |
| [Other/table_diagram.dbml](Other/table_diagram.dbml) | DBML diagram for the source table |
| [Other/audit_protocol.md](Other/audit_protocol.md) | How the agent is directed and checked |
| [Other/audit_log.md](Other/audit_log.md) | Substantive human checks and their outcomes |


## How We Work

1. Pull `main`, then merge `main` into your own branch before you change files.
2. Keep commit messages short and clear (e.g. `Add market analysis draft`)
3. Put files in the right folder so everyone can find them
4. Push your branch and open a pull request for your partner to review. Merge finished work into `main` before the due date.

---

<div align="center">

**Team 1 — ALPHA & OMEGA** · BUSM 410 · BYU–Hawaii

</div>
