# AFRI grazing analysis

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
