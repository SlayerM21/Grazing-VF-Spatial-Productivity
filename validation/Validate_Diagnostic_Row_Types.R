library(dplyr)
lines<-readLines('AFRI_CHAPTER_2_Optimized.Rmd');active<-FALSE;chunks<-list()
for(line in lines){
 if(!active&&grepl('^```\\{r',line)){active<-TRUE;code<-character();next}
 if(active&&grepl('^```\\s*$',line)){chunks[[length(chunks)+1]]<-parse(text=code);active<-FALSE;next}
 if(active)code<-c(code,line)
}
for(expressions in chunks)for(e in as.list(expressions)){
 if(is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name('afri_diagnostic_reporting_rows')))eval(e)
 if(is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name('canonical_influential_observations')))combine<-e
}
a<-tibble(Year=factor(c('2023','2024')),Pasture=factor(c('1','2')),SEID=c(101,102),TRT=factor(c('Continuous','Rotational')),Standardized_or_Pearson_residual=c(3.2,-4),Influence_flag=TRUE)
b<-tibble(Year=2025,Pasture='3',SEID='animal-103',TRT='Continuous',Standardized_or_Pearson_residual=3.8,Influence_flag=TRUE)
original<-a
canonical_diagnostic_objects<-list(list(influential=a),list(influential=tibble()),list(influential=b),list(influential=NULL))
eval(combine)
stopifnot(nrow(canonical_influential_observations)==3,identical(canonical_influential_observations$Year,c('2023','2024','2025')),is.character(canonical_influential_observations$SEID),is.numeric(canonical_influential_observations$Standardized_or_Pearson_residual),identical(canonical_influential_observations$Standardized_or_Pearson_residual,c(3.2,-4,3.8)),identical(a,original))
canonical_diagnostic_objects<-list(list(influential=tibble()),list(influential=NULL));eval(combine)
stopifnot(nrow(canonical_influential_observations)==0)
cat('PASS: all chunks parse; actual bind combines factor/double Year and mixed IDs, preserves numeric residuals and source types, and handles empty diagnostics\n')
