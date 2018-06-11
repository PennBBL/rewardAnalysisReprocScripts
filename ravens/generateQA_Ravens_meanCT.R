#Read Data
data <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/qa/ravens/n489_Ravens_MeanCT.csv", header = F)
names(data) <- c("bblid","scanid","meanGM","spaCorr")


### Missing Ravens 
data$missingRavens <- 0
data$missingRavens[is.na(data$meanGM)] <- 1

### Flag 2.5 +/- SD

data$flagQA_meanCT <- 0

sd.MeanCT  <- 99.93142
mean.MeanCT <- 682.161

data$flagQA_meanCT[which(data$meanGM > (mean.MeanCT + 2.5*sd.MeanCT) | data$meanGM < (mean.MeanCT -2.5*sd.MeanCT))] <- 1

## Flag 2.5 SD below correlation

data$flagQA_Corr <- 0
sd.Corr  <- 0.006369251
mean.Corr <- 0.9830256


data$flagQA_Corr[which(data$spaCorr < (mean.Corr -2.5*sd.Corr))] <- 1


data$finalQA_ravens <- data$flagQA_meanCT + data$missingRavens + data$flagQA_Corr
data$finalQA_ravens[which(data$finalQA_ravens == 2)] <- 1

write.csv(data, "/data/jux/BBL/projects/rewardAnalysisReproc/qa/ravens/n489_ravensQA.csv", row.names=F)

## Post Processing Steps 
data$scanid[which(data$flagQA_meanCT == 1)]
data$scanid[order(data$spaCorr)][1:15]
