# Run from repository root. No study-data estimates are fabricated or replaced.
library(dplyr)
lines <- readLines('AFRI_CHAPTER_2_Optimized.Rmd');chunks<-list();active<-FALSE
for(line in lines){
 if(!active && grepl('^```\\{r',line)){name<-sub('^```\\{r ([^,}]+).*','\\1',line);code<-character();active<-TRUE;next}
 if(active && grepl('^```\\s*$',line)){chunks[[name]]<-paste(code,collapse='\n');active<-FALSE;next}
 if(active)code<-c(code,line)
}
for(code in chunks)invisible(parse(text=code))
cat('PASS: all',length(chunks),'R chunks parse\n')
for(name in c('shared-runtime',names(chunks)[grepl('^canonical-',names(chunks))])){
 for(e in as.list(parse(text=chunks[[name]]))){
  if(is.call(e)&&identical(e[[1]],as.name('<-'))&&is.call(e[[3]])&&identical(e[[3]][[1]],as.name('function')))eval(e)
 }
}
afri_reference_test_registry<-new.env(parent=emptyenv())
canonical_design_has_cell_replication<-FALSE
set.seed(14)
d<-expand.grid(Year=factor(1:3),Pasture=factor(1:12),Month=factor(1:4),REAL_ID=1:2)
p<-as.integer(d$Pasture);d$TRT<-factor(ifelse(p<=6,'Continuous','Rotational'));d$SR<-factor(c('Light','Moderate','Heavy')[(p-1)%%3+1],levels=c('Light','Moderate','Heavy'))
d$mean_hours<-8+rnorm(3)[d$Year]+rnorm(nrow(d));d$mean_DDT_day<-5+rnorm(3)[d$Year]+rnorm(nrow(d))
Grazing_model_data<-Resting_model_data<-Traveling_model_data<-Monthly_DDT_filtered<-d
mod.Monthly_Grazing<-mod.Monthly_Resting<-mod.Monthly_Traveling<-lme4::lmer(mean_hours~TRT*SR+(1|Year)+(1|Pasture),d,REML=FALSE)
mod.Monthly_DDT_filtered<-lme4::lmer(mean_DDT_day~TRT*SR+(1|Year)+(1|Pasture),d,REML=FALSE)
emm.Monthly_Grazing<-emm.Monthly_Resting<-emm.Monthly_Traveling<-emmeans::emmeans(mod.Monthly_Grazing,~TRT*SR,lmer.df='asymptotic')
emm_DDT<-emmeans::emmeans(mod.Monthly_DDT_filtered,~TRT*SR,lmer.df='asymptotic')
models<-list(Grazing_h=mod.Monthly_Grazing,Resting_h=mod.Monthly_Resting,Traveling_h=mod.Monthly_Traveling,mean_DDT_day=mod.Monthly_DDT_filtered)
grids<-list(Grazing_h=emm.Monthly_Grazing,Resting_h=emm.Monthly_Resting,Traveling_h=emm.Monthly_Traveling,mean_DDT_day=emm_DDT)
canonical_fits<-list();spec_rows<-list()
for(response in names(models)){
 spec<-tibble(Dataset_key='table1',Dataset=paste0(response,'_source'),Response=response,Scale='monthly',Unit='animal',Subject='REAL_ID',Family_rule='gaussian',Table='TABLE 1')
 fit<-afri_fit_one_response(spec)
 canonical_fits[[paste0('table1__',response)]]<-fit;spec_rows[[response]]<-spec
 stopifnot(identical(fit$model,models[[response]]),fit$scale=='monthly',fit$distribution=='Gaussian',!lme4::isREML(fit$model),nrow(fit$data)==nobs(models[[response]]))
 tab<-afri_get_emmeans(fit);expected<-as.data.frame(grids[[response]])
 stopifnot(isTRUE(all.equal(tab$.EMM_estimate,expected$emmean)),isTRUE(all.equal(tab$.EMM_SE,expected$SE)))
 tests<-afri_omnibus_tests(fit);expected_tests<-as.data.frame(car::Anova(models[[response]],type=3))
 stopifnot(isTRUE(all.equal(tests$Raw_P_value,expected_tests[rownames(expected_tests)!='(Intercept)','Pr(>Chisq)'])))
 cat('PASS:',response,'reuses source model, monthly n, EMM/SE and Type III Wald tests\n')
}

CANONICAL_MANAGEMENT_ALPHA<-0.05;CANONICAL_ALLOW_EXPLORATORY_MANAGEMENT_CLD<-FALSE
export_results<-FALSE
# Execute the real source Table 1 formatter, skipping unrelated upstream exports.
source_code<-chunks[['hmm-export-analysis-tables']]
source_code<-substring(source_code,regexpr('anova_to_data_frame <-',source_code)[1])
eval(parse(text=source_code))
source_table<-Table_1_Grazing_Behaviors
canonical_specs<-bind_rows(spec_rows)
canonical_emmeans<-bind_rows(lapply(canonical_fits,afri_get_emmeans))
canonical_omnibus_tests<-bind_rows(lapply(canonical_fits,afri_omnibus_tests))
canonical_contrasts<-bind_rows(lapply(canonical_fits,afri_get_contrasts))
canonical_cld<-bind_rows(lapply(canonical_fits,afri_get_cld))
canonical_model_documentation<-bind_rows(lapply(canonical_fits,afri_fit_overview))
canonical_output_dir<-file.path(tempdir(),'monthly-source-workbook')
canonical_fit_status<-canonical_design_summary<-canonical_cell_replication<-canonical_pasture_influence_audit<-canonical_year_random_qc<-canonical_random_structure_qc<-canonical_model_diagnostics<-canonical_influential_observations<-canonical_distribution_audit<-tibble()
canonical_datasets<-list();canonical_diagnostic_objects<-list()
eval(parse(text=chunks[['original-method-workbook-adapter']]))
eval(parse(text=chunks[['publication-table-builders']]))
stopifnot(identical(Table1_Professional,source_table),all(analysis_emmeans$N_obs==nrow(d)))
export_results<-TRUE
eval(parse(text=chunks[['publication-statistical-exports']]))
readback<-openxlsx::read.xlsx(professional_excel_file,sheet='Table_1_Grazing_Behaviors',check.names=FALSE)
stopifnot(isTRUE(all.equal(as.data.frame(source_table),readback,check.attributes=FALSE)))
cat('PASS: original monthly source Table 1 preserved exactly through final workbook write/read\n')
