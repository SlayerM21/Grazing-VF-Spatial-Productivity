library(dplyr);library(ggplot2)
lines<-readLines('AFRI_CHAPTER_2_Optimized.Rmd');chunks<-list();active<-FALSE
for(line in lines){
 if(!active&&grepl('^```\\{r',line)){name<-sub('^```\\{r ([^,}]+).*','\\1',line);code<-character();active<-TRUE;next}
 if(active&&grepl('^```\\s*$',line)){chunks[[name]]<-paste(code,collapse='\n');active<-FALSE;next}
 if(active)code<-c(code,line)
}
for(code in chunks)invisible(parse(text=code))
set.seed(9)
BW_daily<-expand.grid(Year=factor(2023:2025),Day_of_Study=1:4,TRT=c('Continuous','Rotational'),SR=c('Light','Moderate','Heavy'),SEID=1:3)
BW_daily$Pasture<-interaction(BW_daily$TRT,BW_daily$SR)
BW_daily$Animal_ID<-interaction(BW_daily$Year,BW_daily$Pasture,BW_daily$SEID)
BW_daily$BW<-300+BW_daily$Day_of_Study+rnorm(nrow(BW_daily),sd=5)
animal_growth<-distinct(BW_daily,Year,TRT,SR,Animal_ID);animal_growth$Regression_ADG<-rnorm(nrow(animal_growth),1,0.2)
bw_eda_figures<-list()
pdf(tempfile(fileext='.pdf'))
for(name in c('bw-eda-bw-distributions','bw-eda-bw-boxplots','bw-eda-daily-group-trajectories','bw-eda-pasture-trajectories','bw-eda-animal-trajectories','bw-eda-animal-growth-plot'))eval(parse(text=chunks[[name]]))
dev.off()
stopifnot(length(bw_eda_figures)==6,all(vapply(bw_eda_figures,inherits,logical(1),'ggplot')))
root<-tempfile('bw-eda-');analysis_output_dirs<-list(figures=file.path(root,'02_Grazing_BW_AFRI','03_Figures'))
export_results<-FALSE;eval(parse(text=chunks[['bw-export-eda-figures']]))
stopifnot(!dir.exists(root),nrow(bw_eda_figure_export_log)==0)
export_results<-TRUE;eval(parse(text=chunks[['bw-export-eda-figures']]))
files<-list.files(analysis_output_dirs$figures,pattern='\\.tiff$',full.names=TRUE)
stopifnot(length(files)==6,all(file.info(files)$size>0),nrow(bw_eda_figure_export_log)==6)
for(file in files){header<-readBin(file,'raw',n=4);stopifnot(identical(header,as.raw(c(73,73,42,0)))||identical(header,as.raw(c(77,77,0,42))))}
eval(parse(text=chunks[['bw-export-eda-figures']]))
stopifnot(length(list.files(analysis_output_dirs$figures,pattern='\\.tiff$'))==6)
cat('PASS: all chunks parse; six real EDA plots; six nonempty TIFF exports; disabled exports write nothing; repeat exports remain six files\n')
unlink(root,recursive=TRUE)
