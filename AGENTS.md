# AGENTS.md

Read this before helping on our project.

- Team: Alpha & Omega (BUSM 410, Team 1). Partners: Karl De Guzman and James Illorin.
- Dataset: Chicago Taxi Trips (`chicago_taxi_trips` in BigQuery).
- Keep answers short and plain.
- Draft one step at a time, as a short query for us to approve. Never draft one long query that does everything.
- Don't save or change files until we say so.
- Back every claim about our data with a source, and say when something is your own conclusion.
- Ask us to confirm a table or column exists before you use it.
- Use our project audit skill (`.agents/skills/project-audit/SKILL.md`) to keep `Other/audit_log.md` up to date.
- Assume we're new to Git and GitHub. When we work together on our own computer, teach us how Git works as we go.
- Never run commits or pushes yourself. Give us the commands, and we'll run them.
- We each work on our own branch, named after the person (for example, `alex`). At the start of each session, remind us to run `git pull` on `main`, then merge `main` into our branch, before we change anything.
- At the end of each session, remind us to push our branch and open a pull request. Our partner reviews it before we merge it into `main`.
- If our work conflicts with our partner's, explain the conflict in plain words and help us decide what to keep.
- Remind us to merge finished work into `main` before each due date. Our instructor grades `main`.

## Project facts — CP1

- **Dataset:** Chicago Taxi Trips, from the public BigQuery table `bigquery-public-data.chicago_taxi_trips.taxi_trips`. The project `stately-mote-509700-r8` is used to run query jobs; the taxi table is not in that project's `chicago_taxi_trips` dataset.
- **Source and limits:** The City of Chicago describes this as taxi trips reported to the city, says not all trips are reported, and notes that cash tips generally are not recorded. The city also documents significant data changes in July 2019. See [the City dataset page](https://data.cityofchicago.org/Transportation/Taxi-Trips-2013-2023-/wrvz-psew) and [its 2019 change note](https://data.cityofchicago.org/Transportation/Taxi-Trips-2017/jeij-fq8w).
- **Gap:** For 2018 deduplicated trips with positive fares and recorded tips, cash tips were 0.1605% of cash fares; credit-card tips were 22.3715% of credit-card fares. Credit-card trips are the within-year benchmark.
- **Estimated value:** Applying the credit-card tip-to-fare rate to cash fares gives about $27.78 million more than the cash tips recorded. This estimates possible under-recorded cash tips; it is not actual lost or earned income.
- **Unit and key fields:** The analysis uses one row per distinct `unique_key`. Relevant fields are `unique_key`, `trip_start_timestamp`, `payment_type`, `fare`, and `tips`.
- **Cleaning decisions:** In 2018, 6,018,199 keys repeated, but none had different timestamps, payment types, fares, or tips. Deduplicate by `unique_key`; retain only `fare > 0` and non-null `tips` for tip-rate calculations. Keep zero tips because the City says cash tips generally are not recorded. Do not interpret 2018–2019 annual counts as a demand change: the 2019 monthly results have an abrupt midyear break and missing late-year months.
