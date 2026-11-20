# CP2 Model Card

## Question and unit

The outcome is each eligible trip's recorded tip-to-fare rate (`tips ÷ fare`). One analysis row is one distinct `unique_key` from 2018. The full table contains 20,352,588 rows. Fare and tips are not predictors because they define the outcome; including them would leak the answer. Predictors are payment type, company, pickup community area, month, hour, day of week, trip miles, trip seconds, and missing-value flags. See [the table build](../sql/14_create_cp2_analysis_table.sql) and [the model query](../sql/22_cp2_train_model_sample.sql).

## Data checks and model sample

The full analysis table was checked for unique keys, missing or negative outcomes, unknown categories, filled numeric inputs, and extreme ratios in [query 15](../sql/15_cp2_table_quality.sql) and [query 16](../sql/16_cp2_outcome_extremes.sql). Of 20,352,588 rows, 80,751 (0.397%) have a rate above 100%; the maximum is 10,100. The largest examples have a $0.01 fare and $40–$101 tips ([query 17](../sql/17_cp2_extreme_rate_examples.sql)). These records remain in the outcome because the source alone does not prove they are invalid. Their influence is a major limitation of this linear model.

Full-table training exceeded the project's BigQuery free-storage quota. The saved model uses a deterministic hash sample of 2,034,470 trips (about 10%); a second count is in [query 25](../sql/25_cp2_model_sample_size_check.sql). BigQuery held out part of this sample for evaluation. This sample is useful for exploratory inference, but its results should not be treated as causal or decision-ready.

## Report card

| Measure | Your number | What it means |
|---|---:|---|
| r2_score | 0.1024 | The model explains about 10.2% of the variation in the held-out sample. |
| mean absolute error | 4.4951 | A typical absolute prediction error is about 4.50 rate units; the extreme ratios make this large. |
| mean squared error | 1003.3796 | Large errors are strongly penalized, consistent with the extreme ratios. |

Our r2_score is 0.1024, so the model explains a little of the ups and downs in the trip-level tip-to-fare rate. It is not ready for prediction or business decisions. The result is consistent with the extreme values and with important influences missing from the data. Evaluation results are from [query 23](../sql/23_cp2_model_evaluation.sql).

## Adjusted coefficients

Reference categories with weight 0 and p-value NaN, and the intercept, are omitted as instructed. Coefficients for categories are differences from the model's reference category; numeric coefficients are per unit. A p-value below 0.05 is marked as a statistically distinct association, not proof of cause. Full output comes from [query 24](../sql/24_cp2_advanced_weights.sql).

| X | Category or unit | Coefficient | p-value | Reading |
|---|---|---:|---:|---|
| payment_type | Credit Card | +3.4965 | <0.0001 | Higher than reference, adjusted for other Xs. |
| payment_type | Mobile | +1.37775 | <0.0001 | Higher than reference, adjusted for other Xs. |
| payment_type | Prcard | +2.02189 | <0.0001 | Higher than reference, adjusted for other Xs. |
| payment_type | Unknown | +1.98818 | <0.0001 | Higher than reference, adjusted for other Xs. |
| payment_type | No Charge | +1.62804 | 0.0018 | Higher than reference, adjusted for other Xs. |
| payment_type | Dispute | +1.28695 | 0.2672 | No clear difference from reference (p≥0.05). |
| payment_type | Pcard | +2.09308 | 0.1250 | No clear difference from reference (p≥0.05). |
| payment_type | Split | +1.36717 | 0.5754 | No clear difference from reference (p≥0.05). |
| payment_type | Prepaid | +2.47963 | 0.3807 | No clear difference from reference (p≥0.05). |
| company | Taxi Affiliation Services | +0.132277 | 0.0975 | No clear difference from reference (p≥0.05). |
| company | Chicago Carriage Cab Corp | -0.180743 | 0.0261 | Lower than reference, adjusted for other Xs. |
| company | Medallion Leasin | -0.209402 | 0.0257 | Lower than reference, adjusted for other Xs. |
| company | City Service | +0.10954 | 0.2493 | No clear difference from reference (p≥0.05). |
| company | Sun Taxi | +0.0195636 | 0.8383 | No clear difference from reference (p≥0.05). |
| company | Taxi Affiliation Service Yellow | +0.208015 | 0.0322 | Higher than reference, adjusted for other Xs. |
| company | Star North Management LLC | -0.315479 | 0.0022 | Lower than reference, adjusted for other Xs. |
| company | Blue Ribbon Taxi Association Inc. | +0.516591 | <0.0001 | Higher than reference, adjusted for other Xs. |
| company | Yellow Cab | -0.0472912 | 0.6865 | No clear difference from reference (p≥0.05). |
| company | Globe Taxi | -0.210708 | 0.0805 | No clear difference from reference (p≥0.05). |
| company | Choice Taxi Association | -0.510658 | 0.0001 | Lower than reference, adjusted for other Xs. |
| company | Nova Taxi Affiliation Llc | +0.207857 | 0.1856 | No clear difference from reference (p≥0.05). |
| company | Patriot Taxi Dba Peace Taxi Associat | +0.0325175 | 0.8549 | No clear difference from reference (p≥0.05). |
| company | Chicago Independents | +0.52005 | 0.0052 | Higher than reference, adjusted for other Xs. |
| company | 303 Taxi | +77.5471 | <0.0001 | Higher than reference, adjusted for other Xs. |
| company | Blue Diamond | +0.0693729 | 0.7162 | No clear difference from reference (p≥0.05). |
| company | Checker Taxi Affiliation | +0.0493969 | 0.7975 | No clear difference from reference (p≥0.05). |
| company | 24 Seven Taxi | +0.467215 | 0.0180 | Higher than reference, adjusted for other Xs. |
| company | Chicago Medallion Management | -0.335987 | 0.0899 | No clear difference from reference (p≥0.05). |
| company | KOAM Taxi Association | -0.502916 | 0.0247 | Lower than reference, adjusted for other Xs. |
| company | Top Cab Affiliation | -0.565787 | 0.0136 | Lower than reference, adjusted for other Xs. |
| company | Chicago Taxicab | +1.04034 | <0.0001 | Higher than reference, adjusted for other Xs. |
| company | Checker Taxi | -0.0851436 | 0.7239 | No clear difference from reference (p≥0.05). |
| company | American United | -0.223413 | 0.4344 | No clear difference from reference (p≥0.05). |
| company | Gold Coast Taxi | -0.160197 | 0.6241 | No clear difference from reference (p≥0.05). |
| company | Norshore Cab | +5.4127 | <0.0001 | Higher than reference, adjusted for other Xs. |
| company | Service Taxi Association | +1.03043 | 0.0270 | Higher than reference, adjusted for other Xs. |
| company | Taxicab Insurance Agency, LLC | -0.295472 | 0.5332 | No clear difference from reference (p≥0.05). |
| company | Setare Inc | +0.0693544 | 0.8860 | No clear difference from reference (p≥0.05). |
| company | Metro Jet Taxi A | +2.0127 | 0.0011 | Higher than reference, adjusted for other Xs. |
| company | Metro Group | +7.09359 | <0.0001 | Higher than reference, adjusted for other Xs. |
| company | American United Taxi Affiliation | +0.364862 | 0.5886 | No clear difference from reference (p≥0.05). |
| company | Leonard Cab Co | +0.363162 | 0.6209 | No clear difference from reference (p≥0.05). |
| company | Dispatch Taxi Affiliation | +0.302431 | 0.6851 | No clear difference from reference (p≥0.05). |
| company | 5 Star Taxi | -0.304366 | 0.7165 | No clear difference from reference (p≥0.05). |
| company | 3591 - 63480 Chuks Cab | +0.125514 | 0.9072 | No clear difference from reference (p≥0.05). |
| company | 1085 - 72312 N and W Cab Co | +0.22065 | 0.8571 | No clear difference from reference (p≥0.05). |
| company | 3011 - 66308 JBL Cab Inc. | -0.301063 | 0.8061 | No clear difference from reference (p≥0.05). |
| company | 6743 - 78771 Luhak Corp | +0.144107 | 0.9111 | No clear difference from reference (p≥0.05). |
| company | 1469 - 64126 Omar Jada | -0.0637845 | 0.9617 | No clear difference from reference (p≥0.05). |
| company | 5006 - 39261 Salifu Bawa | +0.210322 | 0.8867 | No clear difference from reference (p≥0.05). |
| company | 6574 - Babylon Express Inc. | -0.428038 | 0.7779 | No clear difference from reference (p≥0.05). |
| company | 2092 - 61288 Sbeih company | +1.0295 | 0.5055 | No clear difference from reference (p≥0.05). |
| company | Top Cab - 312 MM Corp | -0.379407 | 0.8069 | No clear difference from reference (p≥0.05). |
| company | 3094 - 24059 G.L.B. Cab Co | +0.0573097 | 0.9717 | No clear difference from reference (p≥0.05). |
| company | 2733 - 74600 Benny Jona | -1.16441 | 0.4886 | No clear difference from reference (p≥0.05). |
| company | 6742 - 83735 Tasha ride inc | -0.32938 | 0.8455 | No clear difference from reference (p≥0.05). |
| company | 3623 - 72222 Arrington Enterprises | -0.362854 | 0.8364 | No clear difference from reference (p≥0.05). |
| company | 312 Medallion Management Corp | -0.447082 | 0.8004 | No clear difference from reference (p≥0.05). |
| company | Chicago Medallion Leasing INC | -0.43095 | 0.8142 | No clear difference from reference (p≥0.05). |
| company | 4623 - 27290 Jay Kim | -0.906505 | 0.6248 | No clear difference from reference (p≥0.05). |
| company | 4615 - 83503 Tyrone Henderson | +0.57054 | 0.7615 | No clear difference from reference (p≥0.05). |
| company | Chicago Star Taxicab | -0.701622 | 0.7277 | No clear difference from reference (p≥0.05). |
| company | 5062 - 34841 Sam Mestas | -0.0730646 | 0.9718 | No clear difference from reference (p≥0.05). |
| company | 3620 - 52292 David K. Cab Corp. | -0.895319 | 0.6633 | No clear difference from reference (p≥0.05). |
| company | 5874 - 73628 Sergey Cab Corp. | -1.29088 | 0.5305 | No clear difference from reference (p≥0.05). |
| company | 2192 - 73487 Zeymane Corp | -1.37448 | 0.5399 | No clear difference from reference (p≥0.05). |
| company | 3556 - 36214 RC Andrews Cab | +1.39795 | 0.5542 | No clear difference from reference (p≥0.05). |
| company | 3721 - Santamaria Express, Alvaro Santamaria | -1.32534 | 0.5892 | No clear difference from reference (p≥0.05). |
| company | 4053 - 40193 Adwar H. Nikola | -1.98151 | 0.4426 | No clear difference from reference (p≥0.05). |
| company | 3669 - 85800 Jordan Taxi Inc | +0.487796 | 0.8510 | No clear difference from reference (p≥0.05). |
| company | 5997 - 65283 AW Services Inc. | -0.0387537 | 0.9893 | No clear difference from reference (p≥0.05). |
| company | 0118 - 42111 Godfrey S.Awir | -0.134865 | 0.9632 | No clear difference from reference (p≥0.05). |
| company | 0694 - 59280 Chinesco Trans Inc | -0.522381 | 0.8704 | No clear difference from reference (p≥0.05). |
| company | 5074 - 54002 Ahzmi Inc | -1.36398 | 0.6809 | No clear difference from reference (p≥0.05). |
| company | 2241 - 44667 - Felman Corp, Manuel Alonso | -1.73556 | 0.8469 | No clear difference from reference (p≥0.05). |
| company | 6057 - 24657 Richard Addo | -0.123974 | 0.9897 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 32 | -0.0747626 | 0.1637 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 28 | +0.109835 | 0.1324 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 76 | -0.0665377 | 0.4667 | No clear difference from reference (p≥0.05). |
| pickup_community_area | Unknown | -6.1596 | <0.0001 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 6 | -0.173188 | 0.1296 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 33 | -0.538275 | <0.0001 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 7 | -0.0556537 | 0.6770 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 56 | -1.29833 | <0.0001 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 24 | +0.133918 | 0.4614 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 3 | +0.110029 | 0.5921 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 77 | +0.0945186 | 0.6845 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 22 | -0.0925931 | 0.7601 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 2 | -1.05929 | 0.0010 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 1 | -1.52876 | <0.0001 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 16 | -0.279078 | 0.4279 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 41 | -0.637755 | 0.0722 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 4 | +0.0444575 | 0.9018 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 5 | +0.0366338 | 0.9296 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 21 | +0.546915 | 0.2086 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 14 | -0.104957 | 0.8101 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 11 | +0.0358437 | 0.9392 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 35 | +0.177345 | 0.7154 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 15 | +0.0215422 | 0.9710 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 34 | +0.243069 | 0.7000 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 39 | -0.599166 | 0.3458 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 59 | +1.46223 | 0.0276 | Higher than reference, adjusted for other Xs. |
| pickup_community_area | 13 | +0.664948 | 0.3455 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 10 | -1.72902 | 0.0181 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 23 | -0.18767 | 0.8018 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 31 | +0.145521 | 0.8590 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 27 | +0.123933 | 0.8810 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 38 | -0.575263 | 0.4938 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 25 | -3.99705 | <0.0001 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 43 | -1.40743 | 0.1146 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 19 | -0.241796 | 0.7959 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 42 | -0.886725 | 0.3764 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 60 | +0.263022 | 0.7963 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 44 | -2.60654 | 0.0219 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 12 | -1.5653 | 0.1704 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 17 | -3.40452 | 0.0037 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 69 | -1.31164 | 0.2885 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 29 | -2.55627 | 0.0413 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 30 | -0.799143 | 0.5388 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 20 | +0.0912255 | 0.9452 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 36 | -1.21749 | 0.3946 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 71 | -3.94339 | 0.0068 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 61 | -0.585315 | 0.6920 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 49 | -2.64066 | 0.0760 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 40 | -0.0781801 | 0.9594 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 68 | -2.29742 | 0.1344 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 66 | -3.06292 | 0.0616 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 58 | -0.146329 | 0.9314 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 46 | -1.90433 | 0.2886 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 48 | -3.19125 | 0.0822 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 73 | -7.11196 | 0.0003 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 67 | -2.37821 | 0.2115 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 26 | -2.55579 | 0.1809 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 70 | -6.15089 | 0.0018 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 37 | -0.465894 | 0.8122 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 45 | -0.771973 | 0.6933 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 75 | -4.54107 | 0.0254 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 53 | -6.00733 | 0.0056 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 57 | -1.35823 | 0.5276 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 64 | -3.99524 | 0.0701 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 47 | -28.7024 | <0.0001 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 18 | -3.95323 | 0.0786 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 65 | -2.34492 | 0.3057 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 51 | -3.26777 | 0.1532 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 62 | -1.40302 | 0.5785 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 63 | -3.73778 | 0.1673 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 50 | -2.17476 | 0.4260 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 72 | -2.94642 | 0.2997 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 9 | -5.77267 | 0.0437 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 54 | -19.9771 | 0.0002 | Lower than reference, adjusted for other Xs. |
| pickup_community_area | 74 | -2.29782 | 0.6623 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 55 | -3.91821 | 0.4649 | No clear difference from reference (p≥0.05). |
| pickup_community_area | 52 | -1.37011 | 0.8131 | No clear difference from reference (p≥0.05). |
| trip_month | 3 | +0.227615 | 0.0133 | Higher than reference, adjusted for other Xs. |
| trip_month | 5 | -0.252415 | 0.0065 | Lower than reference, adjusted for other Xs. |
| trip_month | 4 | -0.131214 | 0.1572 | No clear difference from reference (p≥0.05). |
| trip_month | 10 | -0.176046 | 0.0609 | No clear difference from reference (p≥0.05). |
| trip_month | 8 | -0.0470399 | 0.6201 | No clear difference from reference (p≥0.05). |
| trip_month | 7 | -0.0570908 | 0.5511 | No clear difference from reference (p≥0.05). |
| trip_month | 1 | -0.122074 | 0.2050 | No clear difference from reference (p≥0.05). |
| trip_month | 2 | -0.160599 | 0.0969 | No clear difference from reference (p≥0.05). |
| trip_month | 9 | -0.107126 | 0.2693 | No clear difference from reference (p≥0.05). |
| trip_month | 11 | -0.12211 | 0.2113 | No clear difference from reference (p≥0.05). |
| trip_month | 12 | +0.129805 | 0.1956 | No clear difference from reference (p≥0.05). |
| trip_hour | 18 | +0.0330352 | 0.7585 | No clear difference from reference (p≥0.05). |
| trip_hour | 16 | -0.17728 | 0.1038 | No clear difference from reference (p≥0.05). |
| trip_hour | 19 | +0.0397276 | 0.7194 | No clear difference from reference (p≥0.05). |
| trip_hour | 15 | -0.900816 | <0.0001 | Lower than reference, adjusted for other Xs. |
| trip_hour | 13 | -0.53169 | <0.0001 | Lower than reference, adjusted for other Xs. |
| trip_hour | 14 | -0.865816 | <0.0001 | Lower than reference, adjusted for other Xs. |
| trip_hour | 12 | -0.444544 | 0.0002 | Lower than reference, adjusted for other Xs. |
| trip_hour | 11 | -0.252164 | 0.0284 | Lower than reference, adjusted for other Xs. |
| trip_hour | 20 | -0.0346736 | 0.7656 | No clear difference from reference (p≥0.05). |
| trip_hour | 9 | -0.502425 | <0.0001 | Lower than reference, adjusted for other Xs. |
| trip_hour | 10 | -0.315092 | 0.0085 | Lower than reference, adjusted for other Xs. |
| trip_hour | 21 | -0.0798411 | 0.5068 | No clear difference from reference (p≥0.05). |
| trip_hour | 8 | -0.780074 | <0.0001 | Lower than reference, adjusted for other Xs. |
| trip_hour | 22 | -0.115265 | 0.3546 | No clear difference from reference (p≥0.05). |
| trip_hour | 23 | -0.234967 | 0.0810 | No clear difference from reference (p≥0.05). |
| trip_hour | 7 | -0.564725 | 0.0002 | Lower than reference, adjusted for other Xs. |
| trip_hour | 0 | +0.00981836 | 0.9477 | No clear difference from reference (p≥0.05). |
| trip_hour | 1 | -0.139387 | 0.3877 | No clear difference from reference (p≥0.05). |
| trip_hour | 2 | -0.322452 | 0.0698 | No clear difference from reference (p≥0.05). |
| trip_hour | 6 | +2.80273 | <0.0001 | Higher than reference, adjusted for other Xs. |
| trip_hour | 3 | +0.107975 | 0.5882 | No clear difference from reference (p≥0.05). |
| trip_hour | 4 | +2.72372 | <0.0001 | Higher than reference, adjusted for other Xs. |
| trip_hour | 5 | +6.19762 | <0.0001 | Higher than reference, adjusted for other Xs. |
| trip_day_of_week | 5 | -0.130296 | 0.0600 | No clear difference from reference (p≥0.05). |
| trip_day_of_week | 4 | -0.144029 | 0.0410 | Lower than reference, adjusted for other Xs. |
| trip_day_of_week | 3 | -0.174169 | 0.0146 | Lower than reference, adjusted for other Xs. |
| trip_day_of_week | 2 | +0.0493661 | 0.4975 | No clear difference from reference (p≥0.05). |
| trip_day_of_week | 7 | +0.172155 | 0.0238 | Higher than reference, adjusted for other Xs. |
| trip_day_of_week | 1 | +0.123114 | 0.1292 | No clear difference from reference (p≥0.05). |
| trip_miles | — | +0.242137 | <0.0001 | Higher per unit, adjusted for other Xs. |
| trip_miles_missing | true | +0.379616 | 0.9789 | No clear difference from reference (p≥0.05). |
| trip_seconds | — | -0.000228785 | <0.0001 | Lower per unit, adjusted for other Xs. |
| trip_seconds_missing | true | +0.00423418 | 0.9985 | No clear difference from reference (p≥0.05). |

## Two strongest associations

Credit Card's coefficient is positive (+3.4965), with p<0.0001, so holding the other Xs steady, credit-card trips are associated with a higher recorded tip-to-fare rate than Cash trips, the reference category. This is consistent with the known recording gap and does not establish a difference in actual tips.

303 Taxi's coefficient is positive (+77.5471), with p<0.0001, so holding the other Xs steady, its trips are associated with a higher recorded rate than Flash Cab, the company reference category. This result is likely dominated by the $0.01 fare records identified in Part A; it should not be read as a company performance effect.

## Part A observations

These summaries use the average of the trip-level `tips ÷ fare` ratio. They are not the ratio of total tips to total fares used for the CP1 benchmark.

- **Time split:** Monthly averages range from 0.1245 in August to 2.3494 in January; January–March exceed 2.22. This unusual pattern is consistent with the extreme fare records, not evidence of seasonal changes in actual tipping ([query 18](../sql/18_cp2_part_a_splits_and_suspects.sql), [query 19](../sql/19_cp2_selected_group_averages.sql)).
- **Location split:** Pickup-area averages vary sharply. The `Unknown` group averages 12.5372; area 8 averages 0.1328. The elevated unknown-location rate is associated with missing location and unusual records, not a reliable location effect ([query 18](../sql/18_cp2_part_a_splits_and_suspects.sql)).
- **Payment type suspect:** Cash averages 0.0030 while Credit Card averages 2.6107. This is consistent in direction with the CP1 recorded-tip gap, but the credit-card mean is inflated by extreme per-trip ratios.
- **Company suspect:** 303 Taxi averages 72.6617 versus 0.1213 for Flash Cab. The difference is driven in part by $0.01 fares, so it is not evidence of a company effect.
- **Trip-hour suspect:** The average ranges from 0.3841 at 02:00 to 11.3058 at 05:00. This sharp early-morning spike signals data-quality outliers rather than a stable hour-of-day effect.

### Month split

| Month | Trips | Average tip-to-fare rate |
|---|---:|---:|
| 01 | 1,620,479 | 2.349392 |
| 10 | 1,744,789 | 0.131133 |
| 11 | 1,531,485 | 0.129850 |
| 12 | 1,401,561 | 0.143719 |
| 02 | 1,575,726 | 2.258483 |
| 03 | 1,928,036 | 2.229869 |
| 04 | 1,839,947 | 1.974293 |
| 05 | 1,897,024 | 1.872013 |
| 06 | 1,943,725 | 1.809695 |
| 07 | 1,624,497 | 0.906813 |
| 08 | 1,678,874 | 0.124475 |
| 09 | 1,566,445 | 0.126064 |

### Pickup community area split

| Pickup area | Trips | Average tip-to-fare rate |
|---|---:|---:|
| 1 | 79,035 | 0.220023 |
| 10 | 15,783 | 1.734393 |
| 11 | 37,646 | 0.100644 |
| 12 | 6,676 | 1.444317 |
| 13 | 16,130 | 0.335401 |
| 14 | 44,109 | 0.043094 |
| 15 | 24,552 | 0.097003 |
| 16 | 67,363 | 0.097095 |
| 17 | 5,699 | 0.122626 |
| 18 | 1,584 | 0.356755 |
| 19 | 9,834 | 0.165492 |
| 2 | 85,806 | 0.151625 |
| 20 | 4,509 | 0.044185 |
| 21 | 43,503 | 0.103711 |
| 22 | 90,472 | 0.124986 |
| 23 | 15,073 | 0.074019 |
| 24 | 255,332 | 0.114329 |
| 25 | 9,899 | 0.239698 |
| 26 | 2,174 | 0.009873 |
| 27 | 11,739 | 0.020003 |
| 28 | 2,065,660 | 0.132724 |
| 29 | 5,501 | 0.217925 |
| 3 | 198,263 | 0.073958 |
| 30 | 4,419 | 0.691526 |
| 31 | 12,484 | 0.160791 |
| 32 | 5,392,780 | 0.147421 |
| 33 | 600,415 | 0.132321 |
| 34 | 20,796 | 0.132209 |
| 35 | 34,660 | 0.041082 |
| 36 | 4,137 | 0.028724 |
| 37 | 2,050 | 0.028474 |
| 38 | 11,730 | 0.022056 |
| 39 | 19,991 | 0.049247 |
| 4 | 63,297 | 0.089316 |
| 40 | 3,635 | 0.036479 |
| 41 | 65,523 | 0.122371 |
| 42 | 8,036 | 0.036831 |
| 43 | 9,982 | 0.156416 |
| 44 | 6,075 | 0.028291 |
| 45 | 1,929 | 0.092413 |
| 46 | 2,656 | 0.043114 |
| 47 | 1,828 | 0.005419 |
| 48 | 2,502 | 0.008716 |
| 49 | 3,658 | 0.122112 |
| 5 | 47,748 | 0.069832 |
| 50 | 1,142 | 0.008573 |
| 51 | 1,633 | 0.017252 |
| 52 | 257 | 0.036407 |
| 53 | 1,645 | 0.617633 |
| 54 | 349 | 0.006314 |
| 55 | 245 | 0.164544 |
| 56 | 399,245 | 1.697519 |
| 57 | 1,570 | 2.664322 |
| 58 | 2,789 | 0.229553 |
| 59 | 18,495 | 0.091460 |
| 6 | 694,812 | 0.099186 |
| 60 | 7,612 | 0.302955 |
| 61 | 4,019 | 0.016765 |
| 62 | 1,297 | 0.678476 |
| 63 | 1,248 | 1.621654 |
| 64 | 1,659 | 1.850087 |
| 65 | 1,471 | 0.448208 |
| 66 | 2,589 | 0.015814 |
| 67 | 2,190 | 0.470472 |
| 68 | 3,616 | 0.040842 |
| 69 | 5,188 | 0.025014 |
| 7 | 487,190 | 0.104390 |
| 70 | 2,309 | 0.019765 |
| 71 | 3,751 | 0.359627 |
| 72 | 1,076 | 0.080231 |
| 73 | 2,435 | 1.446766 |
| 74 | 284 | 0.060440 |
| 75 | 1,877 | 0.283306 |
| 76 | 1,684,643 | 4.811050 |
| 77 | 153,727 | 0.101486 |
| 8 | 6,347,204 | 0.132845 |
| 9 | 1,186 | 0.623484 |
| Unknown | 1,097,162 | 12.537243 |

The grouped query returns every value for these three suspects; the complete result is shown below ([query 19](../sql/19_cp2_selected_group_averages.sql)).

### Payment type

| Value | Trips | Average tip-to-fare rate |
|---|---:|---:|

| Cash | 10,571,573 | 0.003003 |

| Credit Card | 9,505,389 | 2.610713 |

| Dispute | 5,990 | 0.000136 |

| Mobile | 116,399 | 0.206831 |

| No Charge | 32,856 | 0.000256 |

| Pcard | 4,269 | 0.010058 |

| Prcard | 60,703 | 0.027507 |

| Prepaid | 960 | 0.004465 |

| Split | 1,428 | 0.280040 |

| Unknown | 53,021 | 0.026834 |

### Company

| Value | Trips | Average tip-to-fare rate |
|---|---:|---:|

| 0118 - 42111 Godfrey S.Awir | 1,012 | 0.144650 |

| 0694 - 59280 Chinesco Trans Inc | 828 | 0.123333 |

| 1085 - 72312 N and W Cab Co | 5,413 | 0.110131 |

| 1469 - 64126 Omar Jada | 4,449 | 0.147402 |

| 2092 - 61288 Sbeih company | 3,688 | 0.008513 |

| 2192 - 73487 Zeymane Corp | 1,726 | 0.157323 |

| 2241 - 44667 - Felman Corp, Manuel Alonso | 75 | 0.190585 |

| 24 Seven Taxi | 226,130 | 0.143325 |

| 2733 - 74600 Benny Jona | 2,893 | 0.154218 |

| 2809 - 95474 C & D Cab Co Inc. | 6 | 0.172387 |

| 3011 - 66308 JBL Cab Inc. | 5,484 | 0.152299 |

| 303 Taxi | 306,703 | 72.661730 |

| 3094 - 24059 G.L.B. Cab Co | 3,148 | 0.163988 |

| 312 Medallion Management Corp | 2,753 | 0.126317 |

| 3556 - 36214 RC Andrews Cab | 1,517 | 0.022692 |

| 3591 - 63480 Chuks Cab | 6,787 | 0.134400 |

| 3620 - 52292 David K. Cab Corp. | 1,931 | 0.154846 |

| 3623 - 72222 Arrington Enterprises | 2,674 | 0.134836 |

| 3669 - 85800 Jordan Taxi Inc | 1,046 | 0.057845 |

| 3721 - Santamaria Express, Alvaro Santamaria | 1,360 | 0.166756 |

| 4053 - 40193 Adwar H. Nikola | 1,310 | 0.154895 |

| 4615 - 83503 Tyrone Henderson | 2,130 | 0.058508 |

| 4623 - 27290 Jay Kim | 2,415 | 0.151270 |

| 5 Star Taxi | 11,326 | 0.129937 |

| 5006 - 39261 Salifu Bawa | 3,617 | 0.118173 |

| 5062 - 34841 Sam Mestas | 1,791 | 0.131543 |

| 5074 - 54002 Ahzmi Inc | 948 | 0.120967 |

| 5874 - 73628 Sergey Cab Corp. | 2,145 | 0.134295 |

| 5997 - 65283 AW Services Inc. | 1,012 | 0.080652 |

| 6057 - 24657 Richard Addo | 59 | 0.115669 |

| 6574 - Babylon Express Inc. | 3,404 | 0.159721 |

| 6742 - 83735 Tasha ride inc | 2,872 | 0.132726 |

| 6743 - 78771 Luhak Corp | 4,731 | 0.096166 |

| American United | 103,514 | 0.109416 |

| American United Taxi Affiliation | 17,483 | 0.091288 |

| Blue Diamond | 243,934 | 0.124422 |

| Blue Ribbon Taxi Association Inc. | 881,224 | 0.129807 |

| Checker Taxi | 147,242 | 0.108521 |

| Checker Taxi Affiliation | 237,862 | 0.128597 |

| Chicago Carriage Cab Corp | 2,288,887 | 0.134496 |

| Chicago Independents | 264,063 | 0.128677 |

| Chicago Medallion Leasing INC | 2,165 | 0.126925 |

| Chicago Medallion Management | 222,907 | 0.131291 |

| Chicago Star Taxicab | 2,268 | 0.158784 |

| Chicago Taxicab | 161,831 | 0.120500 |

| Choice Taxi Association | 645,882 | 0.143745 |

| City Service | 1,342,031 | 0.134193 |

| Dispatch Taxi Affiliation | 14,386 | 0.087568 |

| Flash Cab | 2,840,595 | 0.121255 |

| Globe Taxi | 696,592 | 0.131532 |

| Gold Coast Taxi | 78,726 | 0.138647 |

| KOAM Taxi Association | 170,561 | 0.138124 |

| Leonard Cab Co | 15,140 | 0.125617 |

| Medallion Leasin | 1,389,860 | 0.134556 |

| Metro Group | 20,743 | 0.117196 |

| Metro Jet Taxi A | 23,427 | 0.117761 |

| Norshore Cab | 48,959 | 0.036280 |

| Nova Taxi Affiliation Llc | 375,061 | 0.107191 |

| Patriot Taxi Dba Peace Taxi Associat | 286,347 | 0.130219 |

| Service Taxi Association | 37,187 | 0.138094 |

| Setare Inc | 35,780 | 0.114621 |

| Star North Management LLC | 1,141,309 | 0.138461 |

| Sun Taxi | 1,312,930 | 0.141144 |

| Taxi Affiliation Service Yellow | 1,254,577 | 0.126088 |

| Taxi Affiliation Services | 2,471,940 | 0.126040 |

| Taxicab Insurance Agency, LLC | 36,554 | 0.139170 |

| Top Cab - 312 MM Corp | 3,517 | 0.122199 |

| Top Cab Affiliation | 164,829 | 0.132256 |

| Yellow Cab | 754,892 | 0.110582 |

### Trip hour

| Value | Trips | Average tip-to-fare rate |
|---|---:|---:|

| 00:00 | 508,009 | 0.686789 |

| 01:00 | 412,501 | 0.559661 |

| 10:00 | 968,191 | 1.124193 |

| 11:00 | 1,078,371 | 1.087081 |

| 12:00 | 1,164,763 | 0.896630 |

| 13:00 | 1,181,411 | 1.000931 |

| 14:00 | 1,177,188 | 0.964468 |

| 15:00 | 1,221,739 | 1.083342 |

| 16:00 | 1,322,029 | 0.984128 |

| 17:00 | 1,415,906 | 0.839935 |

| 18:00 | 1,390,836 | 0.866476 |

| 19:00 | 1,247,902 | 0.964006 |

| 02:00 | 325,149 | 0.384076 |

| 20:00 | 1,045,055 | 1.072234 |

| 21:00 | 935,898 | 1.056604 |

| 22:00 | 837,933 | 0.758160 |

| 23:00 | 658,972 | 0.583788 |

| 03:00 | 248,445 | 1.345259 |

| 04:00 | 187,380 | 5.273673 |

| 05:00 | 180,698 | 11.305784 |

| 06:00 | 295,289 | 6.750387 |

| 07:00 | 604,221 | 2.459521 |

| 08:00 | 935,213 | 1.346729 |

| 09:00 | 1,009,489 | 1.081752 |

These findings describe recorded values in this dataset. They do not show what a driver received in unrecorded cash tips and do not prove that any predictor caused a higher tip.
