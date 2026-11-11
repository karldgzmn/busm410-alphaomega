# Audit Log

## Summary

| Category | Entry count |
|---|---:|
| Caught an error | 1 |
| Verified a claim | 1 |
| Separated fact from opinion | 0 |
| Changed the analysis | 1 |
| Improved the agent's instructions | 0 |
| **Total** | **3** |

## Caught an error

| # | Date | What the agent said or did | How the human checked it | Result |
|---:|---|---|---|---|
| 1 | 2026-11-10 | Agent used the README's `stately-mote-509700-r8.chicago_taxi_trips` path as the data table. | Karl ran the metadata query; BigQuery reported that dataset was not found in the US location. | Agent corrected the source to the public BigQuery table. |

## Verified a claim

| # | Date | What the agent said or did | How the human checked it | Result |
|---:|---|---|---|---|
| 2 | 2026-11-10 | Agent proposed `bigquery-public-data.chicago_taxi_trips.taxi_trips` as the source, resolving entry 1. | Karl ran the schema query and pasted the 23 column names returned by BigQuery. | The public table and fields used in the analysis were confirmed. |

## Separated fact from opinion

| # | Date | What the agent said or did | How the human checked it | Result |
|---:|---|---|---|---|
| — | — | No entry yet. | — | — |

## Changed the analysis

| # | Date | What the agent said or did | How the human checked it | Result |
|---:|---|---|---|---|
| 3 | 2026-11-10 | Agent treated the raw 2018–2019 annual count drop as a candidate demand gap. | Karl ran the monthly query and shared 2019 counts including 114,692 in July, 11 in October, and no November or December rows ([query 03](../sql/03_monthly_counts.sql)). | Agent stopped using the annual decline as a demand claim and shifted to a within-2018 payment-type comparison. |

## Improved the agent's instructions

| # | Date | What the agent said or did | How the human checked it | Result |
|---:|---|---|---|---|
| — | — | No entry yet. | — | — |
