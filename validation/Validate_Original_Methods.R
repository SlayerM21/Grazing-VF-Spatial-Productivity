library(dplyr)
path <- 'AFRI_CHAPTER_2_Optimized.Rmd'
grDevices::pdf(tempfile(fileext='.pdf'))
lines<-readLines(path); chunks<-list(); active<-FALSE
for(line in lines){
 if(!active && grepl('^```\\{r',line)){name<-sub('^```\\{r ([^,}]+).*','\\1',line);code<-character();active<-TRUE;next}
 if(active && grepl('^```\\s*$',line)){chunks[[name]]<-paste(code,collapse='\n');active<-FALSE;next}
 if(active)code<-c(code,line)
}
for(code in chunks)invisible(parse(text=code));cat('PASS: all',length(chunks),'R chunks parse\n')
for(name in c('shared-runtime',names(chunks)[grepl('^canonical-',names(chunks))])){
 for(e in as.list(parse(text=chunks[[name]]))){
  if(is.call(e)&&identical(e[[1]],as.name('<-'))&&is.call(e[[3]])&&identical(e[[3]][[1]],as.name('function')))eval(e)
 }
}
CANONICAL_MANAGEMENT_ALPHA<-0.05; CANONICAL_AR1_AIC_IMPROVEMENT<-2
CANONICAL_DHARMA_SIMULATIONS<-50L;CANONICAL_ALLOW_EXPLORATORY_MANAGEMENT_CLD<-FALSE
for(e in as.list(parse(text=chunks[['canonical-season-model-functions']]))){
 if(is.call(e)&&identical(e[[1]],as.name('<-'))&&as.character(e[[2]]) %in% c('afri_table1_responses','afri_table2_animal_responses','afri_table2_pasture_responses'))eval(e)
}
canonical_design_has_cell_replication<-FALSE;export_results<-FALSE;canonical_output_dir<-tempdir()
for(e in as.list(parse(text=chunks[['canonical-model-specification']]))){
 if(is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name('canonical_specs')))eval(e)
}
canonical_specs<-filter(canonical_specs,!Response %in% c('active_ha_outside_rgp','GHG_g_per_active_ha_all_pasture','GHG_g_per_active_ha_inside_rgp','GHG_g_per_kg_LWG','GHG_g_per_active_ha_whole_season','GHG_g_per_kg_LWG_whole_season'))
stopifnot(nrow(canonical_specs)==44)
set.seed(29)
period<-expand.grid(Year=2023:2025,Pasture=paste0('Pasture_',1:12),Period=paste0('RGP',1:5),stringsAsFactors=FALSE)
pasture_index<-as.integer(sub('Pasture_','',period$Pasture)); period$TRT<-ifelse(pasture_index<=6,'Continuous','Rotational');period$SR<-c('Light','Moderate','Heavy')[((pasture_index-1)%%3)+1]
period$SEID<-as.character(seq_len(nrow(period)));period$REAL_ID<-period$SEID
season<-period[period$Period=='RGP1',];season$Period<-NULL
canonical_datasets<-list()
for(key in unique(canonical_specs$Dataset_key)){
 specs<-filter(canonical_specs,Dataset_key==key);d<-if(all(specs$Scale=='season'))season else period
 for(response in specs$Response)d[[response]]<-rgamma(nrow(d),shape=8,scale=2)*exp(0.2*as.integer(factor(d$Year))+0.07*as.integer(factor(d$Pasture)))
 canonical_datasets[[key]]<-d
}
# Preserve within-year repeated animal identifiers for the animal-period fixture.
canonical_datasets$shrunk_period$SEID<-paste(canonical_datasets$shrunk_period$Year,canonical_datasets$shrunk_period$Pasture)
canonical_datasets$shrunk_period$REAL_ID<-canonical_datasets$shrunk_period$SEID
selected<-filter(canonical_specs,Response %in% c('Grazing_h','Resting_h','Traveling_h','mean_DDT_day','CH4_Mean_g_d','active_ha_whole_season','active_ha_all_pasture','CH4_g_per_active_ha_all_pasture','CH4_g_per_active_ha_inside_rgp','LWG_kg_per_active_ha_all_pasture','RGP_CH4_g_day','RGP_CO2_g_day','RGP_Smooth_ADG_kg_day','Smooth_Period_ADG','Whole_Season_Smooth_ADG_kg_day'))
canonical_specs<-selected
canonical_fits<-list()
for(i in seq_len(nrow(selected))){
 spec<-selected[i,];id<-afri_model_id(spec$Dataset_key,spec$Response)
 fit<-afri_fit_one_response(spec);canonical_fits[[id]]<-fit
 cat('FIT:',spec$Response,fit$distribution,fit$link,fit$formula,'\n')
 stopifnot(is.finite(as.numeric(logLik(fit$model))))
}
for(rule in c('gamma_log','auto_positive')){
 stopifnot(afri_resolve_family(c(1,2,3),rule)$distribution %in% c('Gamma','AUTO_GAUSSIAN_GAMMA'))
 stopifnot(afri_resolve_family(c(-1,2),rule)$distribution=='Gaussian')
}
stopifnot(afri_resolve_family(c(0,2),'gamma_log')$distribution=='Tweedie')
cat('PASS: original Gaussian/Gamma/Tweedie family resolution and original model fitting\n')
for(fit in canonical_fits){
 groups<-vapply(lme4::findbars(formula(fit$model)),function(term) paste(sort(strsplit(paste(deparse(term[[3]]),collapse=''),':',fixed=TRUE)[[1]]),collapse=':'),character(1))
 stopifnot(identical(sort(groups),if(fit$scale=='period')c('Pasture:Year','Year') else 'Year'))
 fixed<-attr(terms(lme4::nobars(formula(fit$model))),'term.labels')
 stopifnot(setequal(fixed,c('TRT','SR','TRT:SR',if(fit$scale=='period')c('Period'))))
}
cat('PASS: all synthetic season fits use Year only; period fits use additive Period effects and Year plus Year:Pasture, with no animal/AR(1) terms\n')

canonical_emmeans<-bind_rows(lapply(canonical_fits,afri_get_emmeans))
canonical_omnibus_tests<-bind_rows(lapply(canonical_fits,afri_omnibus_tests))
canonical_contrasts<-bind_rows(lapply(canonical_fits,afri_get_contrasts))
canonical_cld<-bind_rows(lapply(canonical_fits,afri_get_cld))
canonical_model_documentation<-bind_rows(lapply(canonical_fits,afri_fit_overview))
canonical_fit_status<-tibble();canonical_design_summary<-tibble();canonical_cell_replication<-tibble();canonical_pasture_influence_audit<-tibble();canonical_year_random_qc<-tibble();canonical_random_structure_qc<-tibble()
canonical_model_diagnostics<-tibble();canonical_influential_observations<-tibble();canonical_distribution_audit<-tibble();canonical_diagnostic_objects<-list()
eval(parse(text=chunks[['original-method-workbook-adapter']]))
stopifnot(all(is.finite(analysis_emmeans$EMM)),all(is.finite(analysis_emmeans$SE)),all(analysis_emmeans$SE>0))
cat('PASS: original response-scale EMM/real SE, Type III tests, contrasts/CLDs and workbook adapter\n')
# Publication tables must consume restored results, including canonical Table 1.
eval(parse(text=chunks[['publication-table-builders']]))
stopifnot(nrow(Table1_Professional)==4,nrow(Other_Period_EMMs_Professional)>0)
cat('PASS: current publication tables use original-method outputs\n')
# Exercise original GLMM diagnostics and current workbook writer, using temporary outputs.
diag <- afri_model_diagnostics(canonical_fits[['period_pasture__CH4_g_per_active_ha_all_pasture']])
stopifnot(nrow(diag$summary)==1,is.finite(diag$summary$Lilliefors_D),is.finite(diag$summary$Lilliefors_p))
cat('PASS: original Gamma model diagnostics executed\n')
canonical_table1_iqr_audit<-bind_rows(lapply(selected$Response[selected$Dataset_key=='table1'],function(r)afri_table1_iqr(canonical_datasets$table1,r)$audit))
canonical_table1_iqr_summary<-canonical_table1_iqr_audit %>% count(Response,IQR_excluded)
for(e in as.list(parse(text=chunks[['canonical-fit-functions']]))){
 if(is.call(e)&&identical(e[[1]],as.name('<-'))&&is.symbol(e[[2]])&&as.character(e[[2]]) %in% c('canonical_response_iqr_audit','canonical_response_iqr_summary'))eval(e)
}
export_results<-TRUE
analysis_output_dir<-file.path(tempdir(),'restored-method-workbook')
eval(parse(text=chunks[['publication-statistical-exports']]))
w<-openxlsx::loadWorkbook(professional_excel_file)
stopifnot(all(c('Pasture_RGP','Model_Summary') %in% names(w)))
raw<-openxlsx::read.xlsx(w,sheet='EMMs_Raw')
stopifnot(nrow(raw)==nrow(analysis_emmeans),all(is.finite(raw$SE)))
stopifnot('KS_Lilliefors_All_Models' %in% names(w))
cat('PASS: statistical workbook written and reopened with restored-model estimates/SEs\n')

grDevices::dev.off()

stopifnot(identical(publication_superscript(c('a','ab','',NA_character_)),c('ᵃ','ᵃᵇ','','')))
stopifnot(paste0(publication_number(12.75,2),publication_superscript('a'),' ± ',publication_number(0.61,2))=='12.75ᵃ ± 0.61')
for(sheet in c('Table2','WholeSeason_Additional')) {
 tab<-openxlsx::read.xlsx(w,sheet=sheet,check.names=FALSE)
 stopifnot(nrow(tab)>0)
 indices<-match(gsub(' ','.',publication_cells,fixed=TRUE),gsub(' ','.',names(tab),fixed=TRUE))
 stopifnot(!anyNA(indices))
 cells<-unlist(tab[,indices,drop=FALSE],use.names=FALSE)
 stopifnot(all(grepl('[ᵃᵇᶜᵈᵉᶠ].* ± ',cells)))
}
stopifnot(is.numeric(analysis_emmeans$EMM),is.numeric(analysis_emmeans$SE))
cat('PASS: Table2 and WholeSeason_Additional have Tukey superscripts after EMM and before ± SE in reopened Excel; raw numeric EMM/SE preserved\n')

stopifnot('P: Period' %in% names(Other_Period_EMMs_Professional), !any(c('P: TRT × Period','P: SR × Period','P: TRT × SR × Period') %in% names(Other_Period_EMMs_Professional)))
for(response in unique(analysis_omnibus_tests$Response[analysis_omnibus_tests$Scale=='period'])) {
 rows<-analysis_omnibus_tests %>% filter(Response==response,Scale=='period')
 stopifnot('Period' %in% rows$Term,!any(c('TRT:Period','SR:Period','TRT:SR:Period') %in% rows$Term))
}
cat('PASS: period omnibus records and publication columns include additive Period and omit period interactions\n')

for(response in c('Grazing_h','Resting_h','Traveling_h','mean_DDT_day')) {
 fit<-canonical_fits[[paste0('table1__',response)]]
 stopifnot(fit$distribution=='Gamma',fit$link=='log',inherits(fit$model,'glmmTMB'))
 original<-afri_table1_iqr(canonical_datasets$table1,response)$data[[response]]
 stopifnot(identical(as.numeric(model.frame(fit$model)[[response]]),as.numeric(original)))
 for(bad in c(0,-1)){
  saved<-canonical_datasets$table1[[response]];canonical_datasets$table1[[response]][]<-bad
  spec<-selected %>% filter(Dataset_key=='table1',Response==response)
  failed<-try(afri_fit_one_response(spec),silent=TRUE)
  stopifnot(inherits(failed,'try-error'),grepl('strictly positive',as.character(failed)))
  canonical_datasets$table1[[response]]<-saved
 }
}
cat('PASS: all four Table 1 fits are Gamma/log on unchanged original values; zeros/negatives explicitly rejected\n')
# Validate the convergence-failure path cannot silently switch Table 1 to Gaussian.
original_fitter<-afri_try_glmmtmb;afri_try_glmmtmb<-function(...)NULL
failed<-try(afri_fit_season_glmmtmb(canonical_fits[['table1__Grazing_h']]$data,'Grazing_h','animal','Gamma',allow_gaussian_fallback=FALSE),silent=TRUE)
stopifnot(inherits(failed,'try-error'),grepl('no Gaussian fallback',as.character(failed)))
afri_try_glmmtmb<-original_fitter

for(sheet in names(publication_table_objects)) {
 tab<-openxlsx::read.xlsx(w,sheet=sheet,check.names=FALSE)
 if(!nrow(tab))next
 indices<-match(gsub(' ','.',publication_cells,fixed=TRUE),gsub(' ','.',names(tab),fixed=TRUE))
 cells<-unlist(tab[,indices,drop=FALSE],use.names=FALSE)
 stopifnot(all(grepl('\u00B1',cells,fixed=TRUE)))
}
cat('PASS: every publication sheet read back from Excel contains the actual U+00B1 plus/minus symbol\n')

stopifnot(all(c('Table1_IQR_Summary','Table1_IQR_Audit') %in% names(w)))
iqr_rows<-openxlsx::read.xlsx(w,sheet='Table1_IQR_Audit')
stopifnot(nrow(iqr_rows)==nrow(canonical_datasets$table1)*4)
cat('PASS: workbook includes per-response IQR audit and exclusion summary\n')

# Text reports must preserve all rows and raw numeric results without refitting.
text_dir<-file.path(analysis_output_dir,'02_Model_Results','Raw_Inference_Text')
stopifnot(file.exists(file.path(text_dir,'ANOVA.txt')),
          file.exists(file.path(text_dir,'Posthoc_Contrasts.txt')),
          sum(grepl('^Model_[0-9]+[.]txt$',list.files(text_dir)))==length(canonical_fits))
read_text_table<-function(name) utils::read.delim(file.path(text_dir,name),skip=3,
  check.names=FALSE,stringsAsFactors=FALSE)
anova_text<-read_text_table('ANOVA.txt')
stopifnot(nrow(anova_text)==nrow(canonical_omnibus_tests),
          isTRUE(all.equal(anova_text$Raw_P_value,canonical_omnibus_tests$Raw_P_value,tolerance=1e-14)))
contrast_text<-read_text_table('Posthoc_Contrasts.txt')
stopifnot(nrow(contrast_text)==nrow(canonical_contrasts))
report<-readLines(file.path(text_dir,'Model_001.txt'),warn=FALSE)
stopifnot(all(vapply(c('=== ANOVA ===','=== EMMs ===','=== Posthoc_Contrasts ===','=== Posthoc_Letters ==='),
  function(x)any(grepl(x,report,fixed=TRUE)),logical(1))))
cat('PASS: per-model text reports and combined raw inference tables exported; ANOVA P-values round-trip without truncation\n')

stopifnot(all(response_distribution_inventory$Saved),nrow(response_distribution_inventory)==nrow(canonical_specs))
stopifnot(all(file.info(file.path(analysis_output_dir,'03_Figures','Response_Distributions',response_distribution_inventory$File))$size>0))
fit<-canonical_fits[['shrunk_period__RGP_Smooth_ADG_kg_day']]
expected<-afri_table1_iqr(canonical_datasets$shrunk_period,'RGP_Smooth_ADG_kg_day')$data
stopifnot(nrow(fit$data)==nrow(expected),'Response_IQR_Audit' %in% names(w))
cat('PASS: every response distribution PNG saved; period ADG screened and combined IQR workbook audit present\n')

for(response in c('RGP_CH4_g_day','RGP_CO2_g_day')) {
 fit<-canonical_fits[[paste0('shrunk_period__',response)]]
 expected<-afri_table1_iqr(canonical_datasets$shrunk_period,response)$data
 stopifnot(nrow(fit$data)==nrow(expected),
   identical(as.numeric(fit$data[[response]]),as.numeric(expected[[response]])))
 audit<-canonical_response_iqr_audit %>% filter(Response==response)
 stopifnot(nrow(audit)==nrow(canonical_datasets$shrunk_period),
   sum(audit$IQR_excluded)==nrow(audit)-nrow(expected))
}
cat('PASS: both RGP gas models use exact response-specific 1-IQR subsets and complete exclusion audits\n')

for(response in c('Smooth_Period_ADG','Whole_Season_Smooth_ADG_kg_day')) {
 spec<-selected %>% filter(Response==response)
 fit<-canonical_fits[[afri_model_id(spec$Dataset_key,response)]]
 expected<-afri_table1_iqr(canonical_datasets[[spec$Dataset_key]],response)$data
 stopifnot(identical(as.numeric(fit$data[[response]]),as.numeric(expected[[response]])))
 audit<-canonical_response_iqr_audit %>% filter(Response==response)
 stopifnot(all(audit$IQR_multiplier==1.5),nrow(audit)==nrow(canonical_datasets[[spec$Dataset_key]]))
}
cat('PASS: both season ADG models use response-specific 1.5-IQR subsets and complete audits\n')
