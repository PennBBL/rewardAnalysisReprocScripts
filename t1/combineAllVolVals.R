# AFGR August 5 2016

# This script will need to be modified to load and reflect your data

##Usage##
# This script is oging to be used to combine all of the:
#	1.) JLF Volumes
#	2.) ANTsCT Volumes
#	3.) Manual QA Values

# Load library(s)
source('/home/arosen/adroseHelperScripts/R/afgrHelpFunc.R')
install_load('tools')

# Load pre-made data
jlfVals <- read.csv('/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/jlfVolValues_20180611properSubjFieldsProperColNames.csv')
ctVals <- read.csv('/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/ctVolValues_20180611properSubjFieldsProperColNames.csv')
voxelDim <- read.csv('/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/voxelVolume_20180611properSubjFields.csv')
voxelDim <- voxelDim[which(duplicated(voxelDim)=='FALSE'),]

# Load project-specific data
n489.subjs <- read.csv('/data/jux/BBL/projects/rewardAnalysisReproc/subjectLists/n489_bblid_datexscanid_scanid.csv',header=FALSE)
n489.subjs <- n489.subjs[,c(1,3)]
names(n489.subjs)[1] <- "bblid"
names(n489.subjs)[2] <- "scanid"


# Convert all of our voxel counts to mm3
jlfVals <- merge(jlfVals, voxelDim, by=c('subject.0.', 'subject.1.'))
jlfVals[,3:131] <- apply(jlfVals[,3:131], 2, function(x) (x * jlfVals$output))
jlfVals <- jlfVals[,-132]
ctVals <- merge(ctVals, voxelDim, by=c('subject.0.', 'subject.1.'))
ctVals[,3:9] <- apply(ctVals[,3:9], 2, function(x) (x * ctVals$output))
ctVals <- ctVals[,-10]

# Now fix the column names
colnames(jlfVals)[1:2] <- c('bblid', 'scanid')
colnames(ctVals)[1:2] <- c('bblid', 'scanid')

# Now fix scanid
jlfVals[,2] <- strSplitMatrixReturn(charactersToSplit=jlfVals[,2], splitCharacter='x')[,2]
ctVals[,2] <- strSplitMatrixReturn(charactersToSplit=ctVals[,2], splitCharacter='x')[,2]

# Now write the n1601 file
# Start with JLF volumes
n489.vol.vals <- merge(n489.subjs, jlfVals, by=c('bblid', 'scanid'))
n489.vol.ct.vals <- merge(n489.subjs, ctVals, by=c('bblid', 'scanid'))

# Now write the output
write.csv(n489.vol.vals, paste('/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/n489_jlfAntsCTIntersectionVol_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)
write.csv(n489.vol.ct.vals, paste('/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/n489_ctVol',format(Sys.Date(), format="%Y%m%d"), '.csv', sep=''), quote=F, row.names=F)
