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
selected<-filter(canonical_specs,Response %in% c('Grazing_h','Resting_h','Traveling_h','mean_DDT_day','active_ha_all_pasture','CH4_g_per_active_ha_all_pasture','CH4_g_per_active_ha_inside_rgp','LWG_kg_per_active_ha_all_pasture','RGP_CH4_g_day'))
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
 stopifnot(setequal(fixed,c('TRT','SR','TRT:SR',if(fit$scale=='period')'Period')))
}
cat('PASS: all synthetic season fits use Year only; period fits use additive Period and Year plus Year:Pasture, with no animal/AR(1) terms\n')

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
