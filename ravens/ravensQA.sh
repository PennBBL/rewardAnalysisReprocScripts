#Read Data
data <- read.csv("/data/jux/BBL/projects/rewardAnalysisReproc/qa/ravens/n491_Ravens_Mean.csv", header = F)
names(data) <- c("bblid","scanid","meanGM","spaCorr")


### Missing Ravens 
data$missingRavens <- 0
data$missingRavens[is.na(data$meanGM)] <- 1

### Flag 2.5 +/- SD

data$flagQA_mean <- 0

sd.Mean  <- 99.76159
mean.Mean <- 682.0285

data$flagQA_mean[which(data$meanGM > (mean.Mean + 2.5*sd.Mean) | data$meanGM < (mean.Mean -2.5*sd.Mean))] <- 1

## Flag 2.5 SD below correlation

data$flagQA_Corr <- 0
sd.Corr  <- 0.007048493
mean.Corr <- 0.982831


data$flagQA_Corr[which(data$spaCorr < (mean.Corr -2.5*sd.Corr))] <- 1


data$finalQA_ravens <- data$flagQA_mean + data$missingRavens + data$flagQA_Corr
data$finalQA_ravens[which(data$finalQA_ravens == 2)] <- 1

write.csv(data, "/data/jux/BBL/projects/rewardAnalysisReproc/qa/ravens/n491_ravensQA.csv", row.names=F)

## Post Processing Steps 
data$scanid[which(data$flagQA_mean == 1)]
data$scanid[order(data$spaCorr)][1:15]
