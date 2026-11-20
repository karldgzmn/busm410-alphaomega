# Audit Log

## Summary

| Category | Entry count |
|---|---:|
| Caught an error | 1 |
| Verified a claim | 1 |
| Separated fact from opinion | 0 |
| Changed the analysis | 2 |
| Improved the agent's instructions | 0 |
| **Total** | **4** |

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
| 4 | 2026-11-19 | Codex wrote and ran the CP2 checks and linear regression. Full-table training hit the project free-storage quota, so Codex retrained on a deterministic 10% sample while keeping the full analysis table. | Karl approved the CP2 work in chat. Karl has not independently rerun these result checks yet. Codex checked: (1) 20,352,588 rows and distinct keys; (2) 0 null and 0 negative outcomes; (3) no negative miles/durations, 22 missing mile values and 1,601 missing duration values filled with 0, 53,021 unknown payment types, and 1,097,162 unknown pickup areas; (4) 80,751 rates above 100%, maximum 10,100, with the largest examples pairing a $0.01 fare and $40–$101 tips; (5) average rates range from 12.4% in August to over 200% in January–March, the `Unknown` pickup group averages 12.54, and Cash/Credit Card averages are 0.0030/2.6107. Query 25 and `bq show` both report 20,352,588 rows. | The model trained on 2,034,470 trips and returned held-out `r2_score = 0.1024`. The full analysis table remains available; the model is exploratory and the recorded checks await an independent human review. See [model card](../model/model_card.md) and queries 15–25. |

## Improved the agent's instructions

| # | Date | What the agent said or did | How the human checked it | Result |
|---:|---|---|---|---|
| — | — | No entry yet. | — | — |
