# AFGR August 5 2016
## LB June 25 2017

##Usage##
# This script is going to be used to prepare the antsCT JLF data
# Its going to rm extra columns and then prepare the data's header
# Might make this into one big function but we will see how that goes =/

# Load data
source('/home/arosen/adroseHelperScripts/R/afgrHelpFunc.R')
columnValues <- read.csv("/data/joy/BBL/projects/pncReproc2015/pncReproc2015Scripts/jlf/labelList/inclusionCheck.csv")
# ctValues was created by using the command found below:
#system("$XCPEDIR/utils/combineOutput -p /data/joy/BBL/studies/reward/processedData/struct_pipeline/struct_pipeline_201705311006/ -f JLF_val_corticalThickness.1D -o antsCT_JLF_vals.1D")
#system("mv /data/joy/BBL/studies/reward/processedData/struct_pipeline/struct_pipeline_201705311006/antsCT_JLF_vals.1D /data/joy/BBL/projects/rewardAnalysisReproc/qa/output/jlfAntsCTVals.1D") 
ctValues <- read.table("/data/joy/BBL/projects/rewardAnalysisReproc/qa/output/jlfAntsCTVals.1D", header=T)
n477.subjs <- read.csv('/data/joy/BBL/projects/rewardAnalysisReproc/n477_scanid_bblid_date_datexscanid.csv')
n477.subjs <- n477.subjs[,c(2,1)]

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
write.csv(ctValues, '/data/joy/BBL/projects/rewardAnalysisReproc/qa/output/jlfAntsValuesCT.csv', quote=F, row.names=F)
write.csv(ctValues, paste('/data/joy/BBL/projects/rewardAnalysisReproc/qa/output/n477_jlfAntsCTIntersectionCt_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)

# Now do the n477 specific csv
n477.ct.values <- merge(n477.subjs, ctValues, by=c('bblid', 'scanid'))
write.csv(n477.ct.values, paste('/data/joy/BBL/projects/rewardAnalysisReproc/qa/output/n477_jlfAtroposIntersectionCT_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)
