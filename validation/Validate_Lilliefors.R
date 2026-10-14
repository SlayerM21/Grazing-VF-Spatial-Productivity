# Run from repository root; compare the helper directly with nortest.
lines<-readLines('AFRI_CHAPTER_2_Optimized.Rmd');code<-character();active<-FALSE;chunks<-list()
for(line in lines){
 if(!active&&grepl('^```\\{r',line)){active<-TRUE;code<-character();next}
 if(active&&grepl('^```\\s*$',line)){chunks[[length(chunks)+1]]<-parse(text=code);active<-FALSE;next}
 if(active)code<-c(code,line)
}
for(expressions in chunks)for(e in as.list(expressions)){
 if(is.call(e)&&identical(e[[1]],as.name('<-'))&&identical(e[[2]],as.name('afri_lilliefors')))eval(e)
}
set.seed(18)
for(x in list(rnorm(200),rexp(200),c(rnorm(200),NA,Inf))){
 clean<-x[is.finite(x)];expected<-nortest::lillie.test(clean);result<-afri_lilliefors(x)
 stopifnot(result$Lilliefors_N==length(clean),identical(result$Lilliefors_D,unname(expected$statistic)),identical(result$Lilliefors_p,expected$p.value))
}
stopifnot(is.na(afri_lilliefors(1:4)$Lilliefors_p),is.na(afri_lilliefors(rep(1,10))$Lilliefors_p))
cat('PASS: normal/skewed/nonfinite inputs match nortest exactly; small/constant samples reported unavailable; all chunks parse\n')
