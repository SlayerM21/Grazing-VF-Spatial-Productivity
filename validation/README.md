Current season ADG screening evidence: Season_ADG_IQR_Validation.txt and ADG checks in Validate_Table1_IQR.R / Validate_Original_Methods.R. Smooth_Period_ADG and Whole_Season_Smooth_ADG_kg_day now use 1.5-IQR.

Current restored full-interaction evidence: Restored_Full_Interactions_Validation.txt and Validate_Original_Methods.R. Period and RotationPeriod interactions restored; chunk output remains inline. This supersedes additive-period evidence below.

Current additive-period model and inline-output evidence: Additive_Period_Inline_Validation.txt and Validate_Original_Methods.R. This supersedes earlier full-period-interaction evidence.

Current grazing/traveling screening: Half_IQR_Validation.txt and Validate_Table1_IQR.R. Grazing_h and Traveling_h use 0.5-IQR; the other five screened responses use 1-IQR. Earlier uniform-multiplier evidence is historical.

Current RGP CH4/CO2 1-IQR evidence: RGP_Gas_IQR_Validation.txt and gas-subset/audit checks in Validate_Original_Methods.R and Validate_Table1_IQR.R.

Current 1-IQR and response-distribution evidence: One_IQR_Distribution_Validation.txt, Validate_Table1_IQR.R and Validate_Original_Methods.R. This supersedes earlier 1.5-IQR screening evidence.

Current raw inference TXT export evidence: Raw_Inference_Text_Validation.txt and round-trip checks in Validate_Original_Methods.R.

Current Table 1 IQR evidence: Table1_IQR_Validation.txt and Validate_Table1_IQR.R, plus model/workbook regression checks in Validate_Original_Methods.R.

Current plus/minus source-encoding evidence: Plus_Minus_Encoding_Validation.txt and publication-sheet checks in Validate_Original_Methods.R.

Current Table 1 family evidence: Table1_Gamma_Log_Validation.txt and strict Gamma tests in Validate_Original_Methods.R. Animal-year aggregation remains unchanged; earlier Gaussian Table 1 evidence is historical.

Current full period interaction plus Year:Pasture evidence: Full_Period_Nested_Validation.txt and Validate_Original_Methods.R. Season Year-only structure retained.

Current season post-hoc/superscript evidence: Season_Posthoc_Superscript_Validation.txt and Table2/WholeSeason workbook checks in Validate_Original_Methods.R.

Current requested formula evidence: Requested_Structures_Validation.txt and structure assertions in Validate_Original_Methods.R. Season models now use Year only; period models use additive Period with Year and Year:Pasture. Earlier covariance/interaction evidence is historical.

Current Table 1 evidence: Table1_Animal_Year_Validation.txt, Validate_Table1_Animal_Year.R and Validate_Original_Methods.R. Monthly-source Table 1 evidence below is historical and superseded.

Current flagged-row type fix: Diagnostic_Row_Types_Validation.txt and Validate_Diagnostic_Row_Types.R.

Current BW EDA export evidence: BW_EDA_Export_Validation.txt and Validate_BW_EDA_Exports.R (six TIFFs, disabled exports and repeatability).

Current KS/Lilliefors evidence: Lilliefors_Validation.txt and Validate_Lilliefors.R; workbook integration is also checked by both existing synthetic suites.

Current Table 1 evidence: Monthly_Source_Reuse_Validation.txt and Validate_Monthly_Source_Reuse.R. These four responses reuse original monthly Gaussian ML models and source tables. Validate_Original_Methods.R now covers the other canonical methods. Older season-mean Table 1 evidence retains historical scope.

Current evidence: Original_Methods_Restoration_Validation.txt and executable Validate_Original_Methods.R. Original family, robust fitting/fallback, RI/AR(1), response-scale inference and diagnostics are restored; historical Gaussian-only records below retain their original scope.

Current full period-interaction checks: Period_Interaction_Validation.txt. Earlier additive and removal records retain historical scope.

Current outside-RGP area removal checks are in Outside_RGP_Removal_Validation.txt. They validate 206 parsed chunks, unchanged retained specifications, publication filtering and catalog consistency. Earlier records below retain their original revision scope.

# Validation evidence

Current combined-gas removal records use the Combined_Gas_Removal_ prefix. They verify removal of exactly five response specifications and their two combined-total precursor calculations, preserving all surviving calculations, invalid-denominator/missing-data behavior, dataset keys, and model formulas. Model-specific fitting of the entire 45-specification study workflow has not been executed.

The current workbook records validate the user-requested first Table_1_Grazing_Behaviors sheet, Table2/WholeSeason_Additional response transfers, removed ShrunkBW_Season sheet, full cached Table 1 ANOVA export, and unchanged numerical inputs on fabricated fixtures. Current parse/reference records and the regenerated formula/Word checks identify their applicable revised Rmd hash.

Most Additive_ prefix records are prior additive-model execution evidence. They establish the earlier TRT * SR + Period (or RGP/RotationPeriod) implementation, Year/Pasture random intercepts, S/C preservation, source reuse and synthetic reporting. They are not evidence that all 45 surviving response specifications have been fitted in this revision. Additive_Period_Formula_Audit.csv is refreshed for the current 57 full formulas and four conditional alternatives; it is a static formula check.

Historical_Pre_Removal_Workbook/ preserves the preceding 62-entry Word and 30-sheet publication validation, which excluded Table 1 from that workbook. Those earlier behaviors differ from the new requested layout and are not current checks. Historical_Interaction_Models/ preserves validation of the preceding TRT * SR * Period model specification; those records do not validate additive-period models.

Unchanged shared-helper, parameter, map-safety, namespace and directory checks retain prior evidence with their original scope/checksum. Two_Scale_Compact_Export_* (8 checks) and Three_Grid_Compact_Export_* (12 checks) describe the earlier export-only filename repairs. Their scope records compare those particular revisions, rather than the current removal/routing revision. Their Linux synthetic exports and calculated Windows path lengths do not verify actual Windows or study-data writes.

All executed model/table/export checks used fabricated fixtures. Study datasets were not supplied. Actual study fits, sample sizes, estimates, P-values, maps, GIS files and full document knitting remain unverified. See Revision_Report.md for exact checks and limitations.

The latest packaging update removes the two standalone export-repair scripts because both corrections are already embedded in the main Rmd. The Rmd and Word hashes, models, datasets and calculations are unchanged. Earlier records mentioning recovery-script parity or repeated sourcing are preserved unchanged as historical checks of those former files; they do not indicate that standalone scripts remain in the current bundle. Use the built-in Rmd export chunks. No new study-model fitting or export execution is claimed for this packaging change.
