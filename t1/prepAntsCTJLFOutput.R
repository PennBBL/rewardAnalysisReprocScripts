# AFGR August 5 2016
## LB June 25 2017

##Usage##
# This script is going to be used to prepare the antsCT JLF data
# Its going to rm extra columns and then prepare the data's header
# Might make this into one big function but we will see how that goes =/

# Load data
source('/home/arosen/adroseHelperScripts/R/afgrHelpFunc.R')
columnValues <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/subjectLists/inclusionCheck.csv")
# ctValues was created by using the command found below:
#system("$XCPEDIR/utils/combineOutput -p /data/jux/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/ -f JLF_val_corticalThickness.1D -o antsCT_JLF_vals.1D")
#system("mv /data/joy/BBL/studies/reward/processedData/struct_pipeline/struct_pipeline_201705311006/antsCT_JLF_vals.1D /data/joy/BBL/projects/rewardAnalysisReproc/qa/output/jlfAntsCTVals.1D") 
ctValues <- read.table("/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/jlfAntsCTVals.1D", header=T)
n489.subjs <- read.csv('/data/jux/BBL/projects/rewardAnalysisReproc/subjectLists/n489_bblid_datexscanid_scanid.csv')
n489.subjs <- n489.subjs[,c(1,3)]
names(n489.subjs)[1] <- "bblid"
names(n489.subjs)[2] <- "scanid"

# Now I need to limit it to just the NZmeans 
nzCols <- grep('NZMean', names(ctValues))
nzCols <- append(c(1, 2), nzCols)

ctValues <- ctValues[,nzCols]

# Now take only the column of interest
colsOfInterest <- columnValues$Label.Number[which(columnValues$CT==0)] + 2
colsOfInterest <- append(c(1,2), colsOfInterest)

# Now limit the PCASL values to just the columns of interest
ctValues <- ctValues[,colsOfInterest]

# Now change their names
columnNames <- gsub(x=gsub(x=columnValues$JLF.Column.Names, pattern='%MODALITY%', replacement='mprage'), pattern='%MEASURE%', replacement='ct')[which(columnValues$CT==0)]
colnames(ctValues)[3:length(ctValues)] <- as.character(columnNames)

# Now order and rename the files
ctValues[,2] <- strSplitMatrixReturn(ctValues$subject.1., 'x')[,2]
colnames(ctValues)[1:2] <- c('bblid', 'scanid')

# Now write the csv
write.csv(ctValues, '/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/jlfAntsValuesCT.csv', quote=F, row.names=F)
write.csv(ctValues, paste('/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611//n489_jlfAntsCTIntersectionCt_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)

# Now do the n489 specific csv
n489.ct.values <- merge(n489.subjs, ctValues, by=c('bblid', 'scanid'))
write.csv(n489.ct.values, paste('/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611//n489_jlfAtroposIntersectionCT_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)
