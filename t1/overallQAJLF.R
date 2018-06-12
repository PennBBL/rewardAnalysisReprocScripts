# ------------------------ #
# Reward 489 Structural QA #
# ------------------------ #

##############################################################################
## Volume ROI Flagging
##############################################################################


## Read in Data
JLFVol <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/n489_jlfAntsCTIntersectionVol_20180611.csv")
JLF_CT <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/jlfAntsValuesCT.csv") 
CTVol <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/n489_ctVol20180611.csv")
norm <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output/n489_norm_20180611.csv")
bblid_scanid_datexscanid <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/subjectLists/n489_bblid_datexscanid_scanid.csv",header=FALSE)
dataQA <- merge(JLFVol, JLF_CT, by=c("bblid","scanid"))
dataQA <- merge(dataQA, CTVol, by=c("bblid","scanid"))

##Generate JLF Dataset
dataJLF <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/n489_jlfAntsCTIntersectionVol_20180611.csv")
dataJLF$mean <- rowMeans(dataJLF[, 3:131])


##Create DataFrame for QA Values
dataOut <- as.data.frame(matrix(0, nrow=489, ncol=132))

## For each ROI calculate mean and SD and flag outlier ROIs
for (i in 3:131) {
  meanJLF <- mean(dataJLF[,i], na.rm=T)
  sdJLF <- sd(dataJLF[,i], na.rm=T)
  dataOut[which((dataJLF[,i] > meanJLF + 2.5*sdJLF) | (dataJLF[,i] < meanJLF - 2.5*sdJLF)), i] <- 1
}

## Flag outliers of the number of flagged ROIs
names(dataOut) <- names(dataJLF)
dataOut[,1:2] <- dataJLF[,1:2]
dataOut$outlierROIJLF <- rowMeans(dataOut[,3:131])
dataOut$outlierROIFlag <- 0
meanOut <- mean(dataOut$outlierROIJLF)
sdOut <- sd(dataOut$outlierROIJLF)
dataOut$outlierROIFlag[which(dataOut$outlierROIJLF > meanOut + 2.5*sdOut)] <- 1


#create Final Dataset
dataFinal <- dataOut[c("bblid","scanid","outlierROIFlag")]
names(dataFinal)[3] <- "JLFVolROIFlag"

##############################################################################
## Volume Laterality Flagging
##############################################################################

dataOut <- as.data.frame(matrix(0, nrow=489, ncol=132))

index <- grep("_R_", names(dataJLF))

#flag those that deviate in laterality 
for (i in index) {
  dataOut[,i] <- (dataJLF[,i] - dataJLF[,i + 1]) / (dataJLF[,i] + dataJLF[,i + 1])
  meanJLF <- mean(dataOut[,i])
  sdJLF <- sd(dataOut[,i])
  dataOut[which((dataOut[,i] > meanJLF + 2.5*sdJLF) | (dataOut[,i] < meanJLF - 2.5*sdJLF)), i + 1] <- 1
}


names(dataOut) <- names(dataJLF)
dataOut[, 1:2] <- dataJLF[,1:2]

dataOut <- dataOut[,c(1:2, index+1)]
for( i in 1:dim(dataOut)[2]) {
  names(dataOut)[i] <- gsub(pattern = "_L_", "_", names(dataOut)[i])
}


#Generate Means Across observations
dataOut$outlierROI <- rowMeans(dataOut[,3:63])
dataOut$outlierROIFlagLateralVol <- 0
meanOut <- mean(dataOut$outlierROI)
sdOut <- sd(dataOut$outlierROI)

dataOut$outlierROIFlagLateralVol[which(dataOut$outlierROI > meanOut + 2.5*sdOut)] <- 1

dataFinal.Temp <- dataOut[c("bblid","scanid","outlierROIFlagLateralVol")]
dataFinal <- merge(dataFinal, dataFinal.Temp, by=c("bblid","scanid"))
names(dataFinal)[4] <- "JLFVolLateralFlag"


##############################################################################
## Cortical Thickness ROI Flags
##############################################################################

#Generate 1601 Dataset
dataJLF <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/jlfAntsValuesCT.csv", as.is = T)

dataJLF$mean <- rowMeans(dataJLF[, 3:100])

dataOut <- as.data.frame(matrix(0, nrow=489, ncol=101))

#Calcualte mean and SD across all ROI
for (i in 3:101) {
  meanJLF <- mean(dataJLF[,i], na.rm=T)
  sdJLF <- sd(dataJLF[,i], na.rm=T)
  dataOut[which((dataJLF[,i] > meanJLF + 2.5*sdJLF) | (dataJLF[,i] < meanJLF - 2.5*sdJLF)), i] <- 1
}

names(dataOut) <- names(dataJLF)
dataOut[,1:2] <- dataJLF[,1:2]
dataOut$outlierROIJLF <- rowMeans(dataOut[,3:101])
dataOut$outlierROIFlag <- 0
meanOut <- mean(dataOut$outlierROIJLF)
sdOut <- sd(dataOut$outlierROIJLF)
dataOut$outlierROIFlag[which(dataOut$outlierROIJLF > meanOut + 2.5*sdOut)] <- 1

#Generate Flag and Merge with Final
dataFinal.Temp <- dataOut[c("bblid","scanid","outlierROIFlag")]
dataFinal <- merge(dataFinal, dataFinal.Temp, by=c("bblid","scanid"))
names(dataFinal)[5] <- "JLFCTROIFlag"

##############################################################################
## Cortical Thickness Laterality Flags
##############################################################################


dataOut <- as.data.frame(matrix(0, nrow=489, ncol=101))

index <- grep("_R_", names(dataJLF))

#Calculate Outliers Across ROI
for (i in index) {
  dataOut[,i] <- (dataJLF[,i] - dataJLF[,i + 1]) / (dataJLF[,i] + dataJLF[,i + 1])
  meanJLF <- mean(dataOut[,i])
  sdJLF <- sd(dataOut[,i])
  dataOut[which((dataOut[,i] > meanJLF + 2.5*sdJLF) | (dataOut[,i] < meanJLF - 2.5*sdJLF)), i + 1] <- 1
}

names(dataOut) <- names(dataJLF)
dataOut[, 1:2] <- dataJLF[,1:2]

dataOut <- dataOut[,c(1:2, index+1)]
for( i in 1:dim(dataOut)[2]) {
  names(dataOut)[i] <- gsub(pattern = "_L_", "_", names(dataOut)[i])
}


#calculate overall outlier
dataOut$outlierROI <- rowMeans(dataOut[,3:51])
dataOut$outlierROIFlagLateralVol <- 0
meanOut <- mean(dataOut$outlierROI)
sdOut <- sd(dataOut$outlierROI)

dataOut$outlierROIFlagLateralVol[which(dataOut$outlierROI > meanOut + 2.5*sdOut)] <- 1


#Merge with Final 
dataFinal.Temp <- dataOut[c("bblid","scanid","outlierROIFlagLateralVol")]
dataFinal <- merge(dataFinal, dataFinal.Temp, by=c("bblid","scanid"))
names(dataFinal)[6] <- "JLFCTLateralFlag"


##############################################################################
## Spatial Correlation Flag
##############################################################################
names(bblid_scanid_datexscanid)[1] <- "bblid"
names(bblid_scanid_datexscanid)[3] <- "scanid"
names(bblid_scanid_datexscanid)[2] <- "datexscanid"

norm$spatialCorrFlag <- 0
meanJLF <- mean(norm$normCrossCorr)
sdJLF <- sd(norm$normCrossCorr)
norm$spatialCorrFlag[dataQA$normCrossCorr < meanJLF - 2.5*sdJLF] <- 1
norm <- merge(bblid_scanid_datexscanid, norm, by=c("bblid","datexscanid"))
norm$X <- NULL
dataQA <- merge(dataQA, norm, by=c("bblid","scanid"))
dataFinal$spatialCorrFlag <- dataQA$spatialCorrFlag


##############################################################################
## Brain Mask Flag 
##############################################################################
dataQA$brainMaskFlag <- 0
meanJLF <- mean(dataQA$mprage_antsCT_vol_TBV)
sdJLF <- sd(dataQA$mprage_antsCT_vol_TBV)
dataQA$brainMaskFlag[(dataQA$mprage_antsCT_vol_TBV > meanJLF + 2.5*sdJLF) | (dataQA$mprage_antsCT_vol_TBV < meanJLF - 2.5*sdJLF)] <- 1
dataFinal$brainMaskFlag <- dataQA$brainMaskFlag


##############################################################################
## ANTS 6 Tissue Segmentation Flags 
##############################################################################
index <- grep("mprage_antsCT_vol_", names(dataQA))[1:6]

for (i in index) {
  dataQA[, dim(dataQA)[2] + 1]  <- 0
  meanJLF <- mean(dataQA[,i], na.rm=T)
  sdJLF <- sd(dataQA[,i], na.rm=T)
  dataQA[which((dataQA[,i] > meanJLF + 2.5*sdJLF) | (dataQA[,i] < meanJLF - 2.5*sdJLF)), dim(dataQA)[2] ] <- 1
}

names(dataQA)[230:235] <- paste0("flag", names(dataQA)[index])


## Merge all flags up until this point and create a final dataset 
dataFinal$finalFlag <- rowSums(dataFinal[, c(3:8)])
dataFinal$finalFlag[dataFinal$finalFlag > 0.5] <- 1

#Clean Final dataset
write.csv(dataFinal, "/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/n489_reward_QAFlags_Structural_final.csv",row.names=FALSE)

dataFinal$bblid[is.na(dataFinal$finalFlag)]
