-- Evaluate the CP2 model on BigQuery ML's held-out sample split.
SELECT *
FROM ML.EVALUATE(MODEL `stately-mote-509700-r8.busm410_cp2.tip_rate_model_2018`);
