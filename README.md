# AFRI grazing analysis

The current workflow restores the statistical methods from the supplied original `AFRI_CHAPTER_2_Master_Code_Year_Random_10-9-2026.Rmd`: response-specific Gaussian/Gamma/Tweedie rules, original positive-family AIC comparisons, robust numerical fallbacks, RI versus AR(1) repeated-period selection, with Table 1 now reusing the original monthly Gaussian source models.

Period fixed effects are `TRT * SR * Period` (source aliases RGP/RotationPeriod). Year and physical Pasture are random intercepts where estimable; original repeated-animal clustering and eligible AR(1) covariance candidates are restored. The final family, formula, covariance selection, fit status and diagnostics are exported. The four Table 1 Gaussian monthly ML source fits are reused directly; other outcomes retain the restored original canonical methods.

The outside-assigned-RGP active-area response and combined CH4 + CO2 responses remain removed. Individual CH4 and CO2 responses remain. The workbook starts with Table_1_Grazing_Behaviors, then Table2, WholeSeason_Additional, Pasture_RGP and Animal_RGP, plus raw model results and audits. It is saved under `Chapter_2_Results/06_Statistical_Analysis/01_Tables/AFRI_Statistical_Results.xlsx`.

- [Complete R Markdown workflow](AFRI_CHAPTER_2_Optimized.Rmd)
- [Complete response/model catalog](Complete_Response_Model_List.md)
- [CSV catalog](Complete_Response_Model_List.csv)
- [Word catalog](AFRI_Variables_Models_and_Datasets.docx)
- [Complete ZIP bundle](AFRI_Revision_Bundle.zip)

Start a fresh R session and rerun all input and model chunks; do not reuse old fits or the old workbook. Dependencies include glmmTMB and performance in addition to the shared runtime packages. Original HMM, BW, GreenFeed and GIS research inputs are not supplied, so exact reproduction of study tables and a full knit remain unverified. Synthetic fitting, response-scale EMM/SE, diagnostics and workbook checks are documented in validation/Original_Methods_Restoration_Validation.txt. Older evidence retains its original revision scope.

Table 1 uses `mod.Monthly_Grazing`, `mod.Monthly_Resting`, `mod.Monthly_Traveling`, and `mod.Monthly_DDT_filtered`. It preserves the original filtered monthly datasets, source table, EMM/SE, CLDs and Type III Wald tests; no season aggregation or new Gaussian/Gamma fitting is used for these four responses. Run validation/Validate_Monthly_Source_Reuse.R to check the reuse and final workbook integration on synthetic data.
