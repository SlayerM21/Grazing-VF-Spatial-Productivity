# AFRI grazing analysis

Response screening uses Q1 − k × IQR and Q3 + k × IQR, with k = 0.5 for Grazing_h and Traveling_h and k = 1 for the other screened responses, separately for Grazing_h, Resting_h, Traveling_h, mean_DDT_day, RGP_Smooth_ADG_kg_day, RGP_CH4_g_day and RGP_CO2_g_day. R type-7 quartiles use finite animal-year season averages for Table 1 and animal-period records for RGP ADG/CH4/CO2, pooled across treatment groups within each response. Fence values are retained; fewer than four finite observations are unscreened. Each response uses its own retained subset, with original datasets preserved. Response_IQR_Summary, Response_IQR_Audit and Response_IQR_Excluded record fences, counts and excluded records; Table1_IQR sheets remain available. Existing model families and formulas are retained. Monthly exploratory grazing/traveling screening uses 0.5 × IQR; resting/DDT screening uses 1 × IQR. Audit and summary sheets report IQR_multiplier explicitly. With export_results = TRUE, all canonical responses get before-screening and model-data histograms and normal QQ plots in 06_Statistical_Analysis/03_Figures/Response_Distributions, indexed by Distribution_Index.csv. These are response distribution plots, not residual normality tests. Outcome-based screening should be reported with the results.

Current Table 1 family update: Grazing_h, Resting_h, Traveling_h and mean_DDT_day use Gamma with a log link on the original animal-year season averages, with `TRT * SR + (1 | Year)`. Responses are not log-transformed. Nonpositive fitted response values and failed Gamma fits are reported explicitly; Table 1 does not switch to Gaussian/Tweedie. Other model structures/family rules, Tukey superscripts and exports remain unchanged. This supersedes earlier Gaussian Table 1 notes below.


Current update: season models remain `TRT * SR + (1 | Year)`; period models now use `TRT * SR * Period + (1 | Year) + (1 | Year:Pasture)`, and GreenFeed uses `TRT * SR * RotationPeriod + (1 | Year) + (1 | Year:Pasture)`. All period interactions and their omnibus P-value columns are included. Family rules, season averaging, superscripts and disabled animal/AR(1) structures remain unchanged. This supersedes older additive-period notes below.


Current requested structures: season `TRT * SR + (1 | Year)`; period `TRT * SR + Period + (1 | Year) + (1 | Year:Pasture)`; GreenFeed `TRT * SR + RotationPeriod + (1 | Year) + (1 | Year:Pasture)`. No period interactions, animal intercept or AR(1) candidate. Response-family rules and animal-year Table 1 averaging remain in place. This supersedes older model-structure notes below. Restart R and rerun all data/model/export chunks.


The current workflow restores the statistical methods from the supplied original `AFRI_CHAPTER_2_Master_Code_Year_Random_10-9-2026.Rmd`: response-specific Gaussian/Gamma/Tweedie rules, original positive-family AIC comparisons, robust numerical fallbacks, RI versus AR(1) repeated-period selection, with Table 1 using Gaussian animal-year season-average models.

Period fixed effects are `TRT * SR * Period` (source aliases RGP/RotationPeriod). Year and physical Pasture are random intercepts where estimable; original repeated-animal clustering and eligible AR(1) covariance candidates are restored. The final family, formula, covariance selection, fit status and diagnostics are exported. Table 1 fits Gaussian models to animal-year season means; earlier monthly source fits remain exploratory. Other outcomes retain the restored original canonical methods.

The outside-assigned-RGP active-area response and combined CH4 + CO2 responses remain removed. Individual CH4 and CO2 responses remain. The workbook starts with Table_1_Grazing_Behaviors, then Table2, WholeSeason_Additional, Pasture_RGP and Animal_RGP, plus raw model results and audits. It is saved under `Chapter_2_Results/06_Statistical_Analysis/01_Tables/AFRI_Statistical_Results.xlsx`.

- [Complete R Markdown workflow](AFRI_CHAPTER_2_Optimized.Rmd)
- [Complete response/model catalog](Complete_Response_Model_List.md)
- [CSV catalog](Complete_Response_Model_List.csv)
- [Word catalog](AFRI_Variables_Models_and_Datasets.docx)
- [Complete ZIP bundle](AFRI_Revision_Bundle.zip)

Start a fresh R session and rerun all input and model chunks; do not reuse old fits or the old workbook. Dependencies include glmmTMB and performance in addition to the shared runtime packages. Original HMM, BW, GreenFeed and GIS research inputs are not supplied, so exact reproduction of study tables and a full knit remain unverified. Synthetic fitting, response-scale EMM/SE, diagnostics and workbook checks are documented in validation/Original_Methods_Restoration_Validation.txt. Older evidence retains its original revision scope.


Lilliefors-corrected Kolmogorov–Smirnov normality diagnostics use `nortest::lillie.test()` on standardized conditional residuals for Gaussian LM/LMM fits and Pearson residuals for glmmTMB fits. Model_Diagnostics includes the statistic, corrected P-value, finite residual count/type and status. KS_Lilliefors_All_Models additionally covers source/exploratory fits, combining aliases of identical fits. Fewer than five finite residuals or constant residuals are reported unavailable. These are descriptive normality tests: fitted/repeated residuals affect iid calibration, and non-Gaussian models do not require normal Pearson residuals. DHARMa uniformity tests remain separate. No model, observation or inference is changed by this diagnostic. Install nortest if needed and rerun in a fresh R session.

BW EDA figures are now explicitly exported to `Chapter_2_Results/02_Grazing_BW_AFRI/03_Figures/`: daily BW distributions, TRT/SR boxplots, daily group trajectories, pasture trajectories, individual-animal trajectories, and animal growth slopes. The six `eda_*.tiff` files match GreenFeed settings (12 × 8 inches, 300 dpi, LZW compression, white background). Run the complete BW section with `export_results: true`; report plots are retained and no EDA calculations or model fits are changed.

Flagged-observation diagnostics normalize Year and other identifier/factor columns to text in reporting copies before combining source and canonical records. This avoids factor-versus-numeric bind errors without changing model data, residual values or fitted results.

Current Table 1: Grazing_h, Resting_h, Traveling_h and mean_DDT_day use Gaussian models of animal-year season averages: `response ~ TRT * SR + (1 | Year) + (1 | Pasture)`. Average retained daily values directly, not monthly averages. Restart R and rerun the analysis and final workbook export; the old monthly-source Table 1 has been superseded.

Season-table post-hoc letters compare all six TRT × SR EMM cells within each response using Tukey adjustment. They are displayed as Unicode superscripts immediately after the EMM and before ± SE (for example, 12.75ᵃ ± 0.61). Table2 and WholeSeason_Additional now include these letters. When pasture cells are unreplicated the comparisons are explicitly exploratory. Raw EMM/SE and plain letters remain available in EMMs_Raw and CLD; missing/nonestimable letters are not invented. Period letters retain their existing temporal comparison scope.

Plus/minus separators and post-hoc superscripts are constructed with ASCII Unicode escapes in the R source, avoiding corruption when files are opened under a different encoding. The workbook contains the actual ± symbol; after updating, rerun the publication-table and Excel-export chunks.

Raw inference text exports: with `export_results = TRUE`, the workbook export also writes `06_Statistical_Analysis/02_Model_Results/Raw_Inference_Text/`. `Model_Index.txt` maps numbered per-model reports to canonical model IDs. Each fitted-model report includes stored ANOVA, response-scale EMMs, post-hoc comparisons and letter groups. Combined `ANOVA.txt`, `EMMs.txt`, `Posthoc_Contrasts.txt`, `Posthoc_Letters.txt` and `Model_Fit_Status.txt` retain all numeric rows and columns as tab-separated UTF-8 text, including raw P-values and inference/adjustment notes. Tests are not rerun for export; failed fits are identified in the index.
