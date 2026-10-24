library(dplyr)
lines<-readLines('AFRI_CHAPTER_2_Optimized.Rmd');active<-FALSE;chunks<-list()
for(line in lines){
 if(!active&&grepl('^```\\{r',line)){active<-TRUE;code<-character();next}
 if(active&&grepl('^```\\s*$',line)){chunks[[length(chunks)+1]]<-parse(text=code);active<-FALSE;next}
 if(active)code<-c(code,line)
}
for(expressions in chunks)for(e in as.list(expressions)){
 if(is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name('afri_table1_iqr')))eval(e)
 if(is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name('canonical_table1_iqr_audit')))audit_expression<-e
 if(is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name('canonical_table1_iqr_summary')))summary_expression<-e
}
responses<-c('Grazing_h','Resting_h','Traveling_h','mean_DDT_day')
x<-c(0.1,10,11,12,13,14,15,100)
d<-tibble(Year=2023,Pasture='1',REAL_ID=as.character(1:8),TRT='Continuous',SR='Light')
for(i in seq_along(responses))d[[responses[i]]]<-x[c(i:8,seq_len(i-1))]
original<-d
for(response in responses){
 result<-afri_table1_iqr(d,response);q<-quantile(d[[response]],c(0.25,0.75),names=FALSE)
 k<-if(response %in% c("Grazing_h","Traveling_h"))0.5 else 1
 expected<-which(d[[response]]<q[1]-k*diff(q)|d[[response]]>q[2]+k*diff(q))
 stopifnot(all(result$audit$IQR_multiplier==k))
 stopifnot(nrow(result$data)==6,identical(result$audit$Source_row[result$audit$IQR_excluded],expected),all(result$audit$Q1==q[1]),identical(result$data,d[-expected,,drop=FALSE]),identical(d,original))
}
canonical_specs<-tibble(Dataset_key='table1',Response=responses)
canonical_datasets<-list(table1=d)
eval(audit_expression);eval(summary_expression)
stopifnot(nrow(canonical_table1_iqr_audit)==32,nrow(canonical_table1_iqr_summary)==4,all(canonical_table1_iqr_summary$N_IQR_excluded==2))
small<-afri_table1_iqr(d[1:3,],responses[1]);stopifnot(nrow(small$data)==3,!any(small$audit$IQR_excluded))
cat('PASS: all four responses use exact response-specific IQR fences independently; correct source rows excluded; values/source data unchanged; actual audit/summary records verified; small samples explicitly unscreened\n')

# Period ADG uses the same rule with its own dataset labels and fences.
adg<-d;adg$RGP_Smooth_ADG_kg_day<-c(-9,1,2,3,4,5,6,99)
z<-afri_table1_iqr(adg,'RGP_Smooth_ADG_kg_day','shrunk_period','shrunk_bw_period_analysis','SHRUNK BW — PERIOD')
stopifnot(sum(z$audit$IQR_excluded)==2,all(z$audit$Dataset_key=='shrunk_period'))
# A value between the old 1.5-IQR fence and new 1-IQR fence must be excluded.
border<-tibble(Grazing_h=c(0,1,2,3,4,5,6,11))
z<-afri_table1_iqr(border,'Grazing_h');stopifnot(tail(z$audit$IQR_excluded,1))
cat('PASS: ADG independently screened and stricter 1-IQR boundary verified\n')

for(response in c('RGP_CH4_g_day','RGP_CO2_g_day')) {
 gas<-d;gas[[response]]<-c(1,10,11,12,13,14,15,100)
 result<-afri_table1_iqr(gas,response,'shrunk_period','shrunk_bw_period_analysis','SHRUNK BW — PERIOD')
 stopifnot(sum(result$audit$IQR_excluded)==2,
   identical(result$data[[response]],c(10,11,12,13,14,15)),
   all(result$audit$Response==response))
}
cat('PASS: CH4 and CO2 response-specific fences exclude both extreme values\n')

# Value 8 lies outside 0.5-IQR but inside 1-IQR on this fixture.
for(response in responses){
 fixture<-tibble(value=c(0,1,2,3,4,5,6,8));names(fixture)<-response
 result<-afri_table1_iqr(fixture,response)
 stopifnot(tail(result$audit$IQR_excluded,1)==(response %in% c('Grazing_h','Traveling_h')))
}
cat('PASS: 0.5-IQR grazing/traveling exclusions differ from 1-IQR resting/DDT on boundary fixture\n')

for(response in c('Smooth_Period_ADG','Whole_Season_Smooth_ADG_kg_day')) {
 fixture<-tibble(value=c(0,1,2,3,4,5,6,10));names(fixture)<-response
 result<-afri_table1_iqr(fixture,response)
 stopifnot(all(result$audit$IQR_multiplier==1.5),!tail(result$audit$IQR_excluded,1))
 fixture[[response]][8]<-100
 result<-afri_table1_iqr(fixture,response)
 stopifnot(tail(result$audit$IQR_excluded,1),nrow(result$data)==7)
}
cat('PASS: both season ADG responses retain values within 1.5-IQR and exclude beyond-fence extremes\n')
