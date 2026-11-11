
# CP1 Charter

## The question

How large is the gap between recorded tips on cash-paid and credit-card-paid Chicago taxi trips in 2018, and what might that gap represent in unrecorded cash tips?

## The decision this supports

A taxi operations or data-reporting manager can decide whether reports should flag cash-tip under-recording or whether a separate cash-tip measure is needed before comparing tip performance by payment type.

## Scope

The source is `bigquery-public-data.chicago_taxi_trips.taxi_trips`. The comparison uses 2018 Cash and Credit Card trips. One analysis row is one distinct `unique_key`; repeated keys had identical values for the timestamp, payment type, fare, and tips fields used here. The tip-rate analysis excludes nonpositive fares and missing tips. The benchmark is the credit-card tip-to-fare rate in the same year. The estimated value assumes cash trips would have the same tip rate as card trips.

## What success looks like

- Report the cash and credit-card tip-to-fare rates from deduplicated, screened records.
- Explain why cash-tip records are incomplete and why card trips are the benchmark.
- Show the rate difference and estimated dollar value with the math and its assumption.
- Include one chart of the gap and benchmark.
- Document query steps, duplicate handling, and cleaning choices so the result can be reproduced.
