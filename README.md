# AFRI analysis revision

The complete revised R Markdown and supporting records are available individually in this repository and together in the ZIP bundle, including the Word model and dataset catalog.

The current revision removes the requested combined CH4 + CO2 calculations and models. Individual CH4 and CO2 analyses remain. The statistical workbook starts with `Table_1_Grazing_Behaviors`; all former `ShrunkBW_Season` variables are in `Table2`, and the four season-total land responses are in `WholeSeason_Additional`. The separate `ShrunkBW_Season` sheet and standalone Table 1 workbook writer are removed. Existing result files on disk are not automatically deleted.

- [Download the complete bundle](AFRI_Revision_Bundle.zip)
- [Complete R Markdown workflow](AFRI_CHAPTER_2_Optimized.Rmd)
- [Download the Word variable/model/dataset document](AFRI_Variables_Models_and_Datasets.docx)
- [Response variables and exact model formulas](Complete_Response_Model_List.md)
- [Model list as CSV](Complete_Response_Model_List.csv)
- [Revision and validation report](Revision_Report.md)
- [Analysis/export audit](Analysis_Export_Audit.csv)
- [Expected output directory tree](Expected_Output_Directory_Tree.txt)

Global GreenFeed contains one Year-random model for CH4 and one for CO2. The separate fixed-year sensitivity analyses are absent from the current workflow and model list.

Unique two-scale outputs use `Chapter_2_Results/05_Two_Scale_Analysis_maps/`, with numbered subfolders for tables, models, figures, maps, and spatial datasets.

P, A, and Q period models use `TRT * SR + Period`; Global GreenFeed uses `TRT * SR + RotationPeriod`. All retain random Year and physical Pasture intercepts. Treatment × stocking rate remains; period interactions are removed. Baseline S and the final-weight ANCOVA C remain unchanged. The protected HMM/GPS specifications are preserved.

When applying the additive-period model specifications, start a fresh R session and rerun the analysis so its tables use newly fitted objects.

For the combined-gas removal and workbook reorganization, use the complete updated Rmd in a fresh R session so the integrated datasets and model lists contain only the retained responses. The surviving model formulas are unchanged. Publication chunks reuse the retained results; their exports also filter obsolete response records from older session objects.

The two-scale export fix is included in the main Rmd. Its exporter uses compact summary/diagnostic filenames and includes full model IDs in its audit. Eight targeted export checks passed; actual Windows writes remain unverified.

The final three-grid map export fix is also included in the main Rmd. It saves the nine cached plots under `01_Grazing_Behavior_Spatial_Aera/04_Maps/Three_Grid_Metrics/{01_LWG,02_CH4,03_CO2}` using compact filenames, retaining full metric/grid IDs in the inventory. Both standalone repair scripts have been removed from this repository and the ZIP bundle.

All 206 R chunks parsed, and targeted synthetic checks passed. Original research input datasets are not included; study-data model execution, research exports, and a full knit remain unverified. See the report for dependencies, input paths, remaining model limitations, and the precise validation scope.

The active-area-outside-assigned-RGP response, its hectare/square-meter calculations and aliases, and its statistical model have been removed. The period model catalog now contains 44 reporting specifications (56 total catalog entries). Rerun in a fresh R session; previously exported files are not deleted.
