# Current AFRI model structures

Response screening excludes values below Q1 - 1 × IQR or above Q3 + 1 × IQR, separately for Grazing_h, Resting_h, Traveling_h, mean_DDT_day and RGP_Smooth_ADG_kg_day. R type-7 quartiles use finite animal-year season averages for Table 1 and animal-period records for RGP ADG, pooled across treatment groups within each response. Fence values are retained; fewer than four finite observations are unscreened. Each response uses its own retained subset, with original datasets preserved. Response_IQR_Summary, Response_IQR_Audit and Response_IQR_Excluded record fences, counts and excluded records; Table1_IQR sheets remain available. Existing model families and formulas are retained. Monthly exploratory grazing/DDT screening also uses 1 × IQR. With export_results = TRUE, all canonical responses get before-screening and model-data histograms and normal QQ plots in 06_Statistical_Analysis/03_Figures/Response_Distributions, indexed by Distribution_Index.csv. These are response distribution plots, not residual normality tests. Outcome-based screening should be reported with the results.

Season-table post-hoc letters compare all six TRT × SR EMM cells within each response using Tukey adjustment. They are displayed as Unicode superscripts immediately after the EMM and before ± SE (for example, 12.75ᵃ ± 0.61). Table2 and WholeSeason_Additional now include these letters. When pasture cells are unreplicated the comparisons are explicitly exploratory. Raw EMM/SE and plain letters remain available in EMMs_Raw and CLD; missing/nonestimable letters are not invented. Period letters retain their existing temporal comparison scope.

Season-level responses (including Gamma/log Table 1 animal-year season averages) use `response ~ TRT * SR + (1 | Year)`.

Period-level responses use `response ~ TRT * SR * Period + (1 | Year) + (1 | Year:Pasture)`.

Global GreenFeed uses `gas ~ TRT * SR * RotationPeriod + (1 | Year) + (1 | Year:Pasture)`. RGP and Pasture_ID aliases are equivalent in source analyses. Period includes TRT:Period, SR:Period and TRT:SR:Period interactions. There is no animal random intercept or AR(1) candidate. The separate endpoint ANCOVA source retains its IBW covariate.

Existing Gaussian/Gamma/Tweedie family rules are retained. Table 1 uses Gamma/log on original strictly positive animal-year averages, with no log transformation or Gaussian fallback. Diagnostics, KS/Lilliefors tests, EMM/SE and workbook routing remain enabled. Actual study-data numerical results require a fresh complete run; old fits and exports must not be reused. Treatment-cell replication remains limited; changing covariance does not create replication.

| Entry | Response | Scale | Family rule | Formula | Input dataset |
|---|---|---|---|---|---|
| 1 | Grazing_h | season | gamma_log_strict | `Grazing_h ~ TRT * SR + (1 \| Year)` | Table1_Grazing_Behaviors |
| 2 | Resting_h | season | gamma_log_strict | `Resting_h ~ TRT * SR + (1 \| Year)` | Table1_Grazing_Behaviors |
| 3 | Traveling_h | season | gamma_log_strict | `Traveling_h ~ TRT * SR + (1 \| Year)` | Table1_Grazing_Behaviors |
| 4 | mean_DDT_day | season | gamma_log_strict | `mean_DDT_day ~ TRT * SR + (1 \| Year)` | Table1_Grazing_Behaviors |
| 5 | CH4_Mean_g_d | season | auto_positive | `CH4_Mean_g_d ~ TRT * SR + (1 \| Year)` | dressler_animal_means |
| 6 | CO2_Mean_g_d | season | auto_positive | `CO2_Mean_g_d ~ TRT * SR + (1 \| Year)` | dressler_animal_means |
| 7 | Smooth_Period_ADG | season | gaussian | `Smooth_Period_ADG ~ TRT * SR + (1 \| Year)` | animal_spline_metrics |
| 8 | Shrunk_Initial_BW_kg | season | gaussian | `Shrunk_Initial_BW_kg ~ TRT * SR + (1 \| Year)` | shrunk_bw_season_analysis |
| 9 | Shrunk_Final_BW_kg | season | gaussian | `Shrunk_Final_BW_kg ~ TRT * SR + (1 \| Year)` | shrunk_bw_season_analysis |
| 10 | CH4_g_per_active_ha_whole_season | season | auto_positive | `CH4_g_per_active_ha_whole_season ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 11 | CO2_g_per_active_ha_whole_season | season | auto_positive | `CO2_g_per_active_ha_whole_season ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 12 | active_ha_whole_season | season | auto_positive | `active_ha_whole_season ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 13 | LWG_kg_per_active_ha_whole_season | season | auto_positive | `LWG_kg_per_active_ha_whole_season ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 14 | active_ha_all_pasture | period | gamma_log | `active_ha_all_pasture ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 15 | active_ha_inside_rgp | period | gamma_log | `active_ha_inside_rgp ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 16 | total_LWG_kg | season | gaussian | `total_LWG_kg ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 17 | mean_RGP_ADG_kg_day | period | gaussian | `mean_RGP_ADG_kg_day ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 18 | CH4_g_animal_day | period | gaussian | `CH4_g_animal_day ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 19 | CO2_g_animal_day | period | gaussian | `CO2_g_animal_day ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 20 | LWG_kg_per_active_ha_all_pasture | period | gaussian | `LWG_kg_per_active_ha_all_pasture ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 21 | LWG_kg_per_active_ha_inside_rgp | period | gaussian | `LWG_kg_per_active_ha_inside_rgp ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 22 | CH4_g_per_active_ha_all_pasture | period | gamma_log | `CH4_g_per_active_ha_all_pasture ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 23 | CH4_g_per_active_ha_inside_rgp | period | gamma_log | `CH4_g_per_active_ha_inside_rgp ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 24 | CO2_g_per_active_ha_all_pasture | period | gamma_log | `CO2_g_per_active_ha_all_pasture ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 25 | CO2_g_per_active_ha_inside_rgp | period | gamma_log | `CO2_g_per_active_ha_inside_rgp ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 26 | CH4_g_per_kg_LWG | period | gamma_log | `CH4_g_per_kg_LWG ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 27 | CO2_g_per_kg_LWG | period | gamma_log | `CO2_g_per_kg_LWG ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | period_level_grazing_productivity |
| 28 | total_LWG_kg | season | gaussian | `total_LWG_kg ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 29 | mean_Shrunk_Initial_BW_kg | season | gaussian | `mean_Shrunk_Initial_BW_kg ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 30 | mean_Shrunk_Final_BW_kg | season | gaussian | `mean_Shrunk_Final_BW_kg ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 31 | mean_Whole_Season_Smooth_ADG_kg_day | season | gaussian | `mean_Whole_Season_Smooth_ADG_kg_day ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 32 | whole_season_animal_avg_CH4_g_day | season | gaussian | `whole_season_animal_avg_CH4_g_day ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 33 | whole_season_animal_avg_CO2_g_day | season | gaussian | `whole_season_animal_avg_CO2_g_day ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 34 | CH4_g_per_active_ha_day_whole_season | season | auto_positive | `CH4_g_per_active_ha_day_whole_season ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 35 | CO2_g_per_active_ha_day_whole_season | season | auto_positive | `CO2_g_per_active_ha_day_whole_season ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 36 | ADG_Land_kg_per_active_ha_day_whole_season | season | gaussian | `ADG_Land_kg_per_active_ha_day_whole_season ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 37 | CH4_g_per_kg_LWG_whole_season | season | gamma_log | `CH4_g_per_kg_LWG_whole_season ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 38 | CO2_g_per_kg_LWG_whole_season | season | gamma_log | `CO2_g_per_kg_LWG_whole_season ~ TRT * SR + (1 \| Year)` | whole_season_grazing_productivity |
| 39 | Whole_Season_CH4_g_day | season | gaussian | `Whole_Season_CH4_g_day ~ TRT * SR + (1 \| Year)` | shrunk_bw_season_analysis |
| 40 | Whole_Season_CO2_g_day | season | gaussian | `Whole_Season_CO2_g_day ~ TRT * SR + (1 \| Year)` | shrunk_bw_season_analysis |
| 41 | Whole_Season_Smooth_ADG_kg_day | season | gaussian | `Whole_Season_Smooth_ADG_kg_day ~ TRT * SR + (1 \| Year)` | shrunk_bw_season_analysis |
| 42 | RGP_CH4_g_day | period | gaussian | `RGP_CH4_g_day ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | shrunk_bw_period_analysis |
| 43 | RGP_CO2_g_day | period | gaussian | `RGP_CO2_g_day ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | shrunk_bw_period_analysis |
| 44 | RGP_Smooth_ADG_kg_day | period | gaussian | `RGP_Smooth_ADG_kg_day ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | shrunk_bw_period_analysis |
| 45 | CH4_g_d | period | Exploratory source; see source chunk | `CH4_g_d ~ TRT * SR * RotationPeriod + (1 \| Year) + (1 \| Year:Pasture)` | ch4_rotation_model_data |
| 46 | CO2_g_d | period | Exploratory source; see source chunk | `CO2_g_d ~ TRT * SR * RotationPeriod + (1 \| Year) + (1 \| Year:Pasture)` | co2_rotation_model_data |
| 47 | Seasonal_ADG | season | Exploratory source; see source chunk | `Seasonal_ADG ~ TRT * SR + (1 \| Year)` | bw_season_model_data |
| 48 | FBW | season | Exploratory source; see source chunk | `FBW ~ IBW + TRT * SR + (1 \| Year)` | bw_season_model_data |
| 49 | CH4_g_d | period | Exploratory source; see source chunk | `CH4_g_d ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | gf_model_data (from gf_period_qualified) |
| 50 | CO2_g_d | period | Exploratory source; see source chunk | `CO2_g_d ~ TRT * SR * Period + (1 \| Year) + (1 \| Year:Pasture)` | gf_model_data (from gf_period_qualified) |
| 51 | Percent_pasture_active | period | Exploratory source; see source chunk | `Percent_pasture_active ~ TRT * SR * RGP + (1 \| Year) + (1 \| Year:Pasture)` | rgp_map_scopes [Grid_Map = ALL_PASTURE_GRAZING] |
| 52 | Gain_kg_per_active_ha | period | Exploratory source; see source chunk | `Gain_kg_per_active_ha ~ TRT * SR * RGP + (1 \| Year) + (1 \| Year:Pasture)` | rgp_map_scopes [Grid_Map = ALL_PASTURE_GRAZING] |
| 53 | Percent_pasture_active | period | Exploratory source; see source chunk | `Percent_pasture_active ~ TRT * SR * RGP + (1 \| Year) + (1 \| Year:Pasture)` | rgp_map_scopes [Grid_Map = INSIDE_RGP_GRAZING] |
| 54 | Gain_kg_per_active_ha | period | Exploratory source; see source chunk | `Gain_kg_per_active_ha ~ TRT * SR * RGP + (1 \| Year) + (1 \| Year:Pasture)` | rgp_map_scopes [Grid_Map = INSIDE_RGP_GRAZING] |
| 55 | Percent_pasture_active | season | Exploratory source; see source chunk | `Percent_pasture_active ~ TRT * SR + (1 \| Year)` | season_two_grid_outcomes [Grid_Map = WHOLE_SEASON_GRAZING] |
| 56 | Gain_kg_per_active_ha | season | Exploratory source; see source chunk | `Gain_kg_per_active_ha ~ TRT * SR + (1 \| Year)` | season_two_grid_outcomes [Grid_Map = WHOLE_SEASON_GRAZING] |
