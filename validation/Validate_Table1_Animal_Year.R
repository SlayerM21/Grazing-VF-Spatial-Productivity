library(dplyr)
lines<-readLines('AFRI_CHAPTER_2_Optimized.Rmd');active<-FALSE;chunks<-list()
for(line in lines){
 if(!active&&grepl('^```\\{r',line)){name<-sub('^```\\{r ([^,}]+).*','\\1',line);code<-character();active<-TRUE;next}
 if(active&&grepl('^```\\s*$',line)){chunks[[name]]<-paste(code,collapse='\n');active<-FALSE;next}
 if(active)code<-c(code,line)
}
for(code in chunks)invisible(parse(text=code))
e<-parse(text=chunks[['canonical-statistical-setup']]);for(x in as.list(e))if(is.call(x)&&identical(x[[1]],as.name('<-'))&&is.call(x[[3]])&&identical(x[[3]][[1]],as.name('function')))eval(x)
behavior_hours_wide_qc<-tibble(Year=2023,Pasture='1',TRT='Continuous',SR='Light',REAL_ID='A',Date=as.Date(c('2023-01-01','2023-01-02','2023-02-01')),Grazing=c(1,3,11),Resting=c(22,20,12),Traveling=1)
Daily_DDT<-mutate(behavior_hours_wide_qc,DDT=c(1000,3000,11000))
eval(parse(text=chunks[['canonical-table1-dataset']]))
stopifnot(nrow(Table1_Grazing_Behaviors)==1,Table1_Grazing_Behaviors$Grazing_h==5,Table1_Grazing_Behaviors$Resting_h==18,Table1_Grazing_Behaviors$Traveling_h==1,Table1_Grazing_Behaviors$mean_DDT_day==5)
e<-parse(text=chunks[['canonical-model-specification']]);for(x in as.list(e))if(is.call(x)&&identical(x[[1]],as.name('<-'))&&identical(x[[2]],as.name('canonical_specs')))eval(x)
spec<-filter(canonical_specs,Dataset_key=='table1')
stopifnot(nrow(spec)==4,all(spec$Scale=='season'),all(spec$Family_rule=='gamma_log_strict'))
cat('PASS: actual Table 1 builder averages daily values within animal-year (not monthly means); distance converted to km/day; all four season responses use strict Gamma/log on original values\n')
