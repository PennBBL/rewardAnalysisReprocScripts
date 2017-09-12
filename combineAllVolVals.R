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
jlfVals <- read.csv('/data/joy/BBL/projects/grmpyProcessing2017/structural/OutputROI/JLFvol/jlfVolValues_20160805properSubjFieldsProperColNames.csv')
ctVals <- read.csv('/data/joy/BBL/projects/grmpyProcessing2017/structural/OutputROI/JLFvol/ctVolValues_20160805properSubjFieldsProperColNames.csv')
manQA1 <- read.csv('/data/joy/BBL/projects/grmpyProcessing2017/structural/OutputROI/JLFvol/n115_T1ManualQA_20170724.csv')
voxelDim <- read.csv('/data/joy/BBL/projects/grmpyProcessing2017/structural/OutputROI/JLFvol/voxelVolume_20160805properSubjFields.csv')
voxelDim <- voxelDim[which(duplicated(voxelDim)=='FALSE'),]

# Load project-specific data
n477.subjs <- read.csv('/data/joy/BBL/projects/rewardAnalysisReproc/qa/n477_scanid_bblid_date_datexscanid.csv')
n477.subjs <- n477.subjs[,c(2,1)]


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
n477.vol.vals <- merge(n477.subjs, jlfVals, by=c('bblid', 'scanid'))
n477.vol.ct.vals <- merge(n477.subjs, ctVals, by=c('bblid', 'scanid'))

# Now write the output
write.csv(n477.vol.vals, paste('/data/joy/BBL/projects/grmpyProcessing2017/structural/OutputROI/JLFvol/n477_jlfAntsCTIntersectionVol_',format(Sys.Date(), format="%Y%m%d"),'.csv', sep=''), quote=F, row.names=F)
write.csv(n477.vol.ct.vals, paste('/data/joy/BBL/projects/grmpyProcessing2017/structural/OutputROI/JLFvol/n477_ctVol',format(Sys.Date(), format="%Y%m%d"), '.csv', sep=''), quote=F, row.names=F)
