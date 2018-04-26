#The objective is to generate a subsample (n = 120) of the reward dataset  is balanced across age, sex, and diagnostic categories. 
#This subsample will subsequently be used to generate a dataset-specific template.

#Cohort identification requires a table of demographic variables and QA information for the entire dataset.

#####Overview of cohort selection strategy
#Determine age bins. In this case, age quintiles were used.
#Define diagnostic categories. We separated subjects into three categories: healthy/controls (no diagnosis), psychotic disorders (schizophrenia, schizoaffective disorder, schizophreniform disorder, psychotic disorder NOS, and clinical risk), and mood disorders (bipolar I, bipolar II, MDD, bipolar NOS, depressive NOS). Subjects whose diagnostic labels did not match any specifications were excluded from further consideration.
#Screen all subjects using the QA information.
#Categorise all subjects according to age, sex, and diagnosis. We defined total of 30 categories (5 age * 2 sex * 3 diagnosis).
#Balance across the 30 categories, ensuring that the same subject is not represented multiple times (e.g., in two different age bins for two different scan sessions).

#Packages needed

require("caret")
require("ggplot2")
require("grid")
require("gridExtra")

#Import Data
fullSample<-read.csv('/data/joy/BBL/studies/reward/summaryScores/clinical/subjectData/n301_T1_integratedData_041017.csv',header=T,na.strings=c('-9999','NA',''))
fs.key<-fullSample[,c("bblid","scanid","age_at_date_provided","sex","updated_study_gp")]

#Re-define study groups into three groups 
levels(fs.key$updated_study_gp)<-c("MOOD","MOOD","NC","PSY","PSY")

fs.key$sex<-as.factor(fs.key$sex)
levels(fs.key$sex)<-c("male","female")


#Split sample (creates a cohort representative of full sample)
set.seed(408)
splitIndex<-createDataPartition(fs.key$age_at_date_provided, p=.39, list = F, times =1)
templateCohort<-fs.key[splitIndex,]
remainingCohort<-fs.key[-splitIndex,]

#Visualize template cohort

#Age
p1<-ggplot(data = fs.key, aes(x = age_at_date_provided)) +
  geom_histogram(aes(y=..density..), bins = 10, fill = 'red', colour = 'black') +
  ggtitle("TOTAL SAMPLE x AGE") + 
  theme_bw(base_size=14, base_family = "Times" ) + 
  ylab("Density") 

p2<-ggplot(data = templateCohort, aes(age_at_date_provided))+
  geom_histogram(aes(y=..density..), bins = 10, fill = 'blue', colour = 'black') +
  ggtitle("TEMPLATE COHORT x AGE") +
  theme_bw(base_size=14, base_family = "Times" ) +
  ylab("Density") 

grid.arrange(p1, p2, ncol=2)

#Sex
p3<-ggplot(data = fs.key, aes(x = sex)) +
  geom_bar(aes(y = ..count../sum(..count..)), fill = 'green', colour = 'black') +
  ggtitle("TOTAL SAMPLE x SEX") + 
  theme_bw(base_size=14, base_family = "Times" ) + 
  ylab("Percent") + ylim(0,1)

p4<-ggplot(data = templateCohort, aes(x = sex)) +
  geom_bar(aes(y = ..count../sum(..count..)), fill = 'purple', colour = 'black') +
  ggtitle("TEMPLATE SAMPLE x SEX") + 
  theme_bw(base_size=14, base_family = "Times" ) + 
  ylab("Percent") + ylim(0,1)

grid.arrange(p3, p4, ncol=2)
 
#Group
p5<-ggplot(data = fs.key, aes(x = updated_study_gp)) +
  geom_bar(aes(y = ..count../sum(..count..)), fill = 'green', colour = 'black') +
  ggtitle("TOTAL SAMPLE x GROUP") + 
  theme_bw(base_size=14, base_family = "Times" ) + 
  ylab("Percent") + ylim(0,1)

p6<-ggplot(data = templateCohort, aes(x = updated_study_gp)) +
  geom_bar(aes(y = ..count../sum(..count..)), fill = 'purple', colour = 'black') +
  ggtitle("TEMPLATE SAMPLE x GROUP") + 
  theme_bw(base_size=14, base_family = "Times" ) + 
  ylab("Percent") + ylim(0,1)

grid.arrange(p5, p6, ncol=2)

#Visualize all plots
grid.arrange(p1, p2, p3, p4, p5, p6, ncol=2)

#Save selected template cohort
write.csv(templateCohort,'/data/joy/BBL/studies/reward/summaryScores/clinical/subjectData/n120_tempCohort_041317.csv', row.names=F)

templateCohortFull<-fullSample[splitIndex,]
write.csv(templateCohortFull,'/data/joy/BBL/studies/reward/summaryScores/clinical/subjectData/n120_tempCohortFullColumns_041317.csv', row.names=F)

#Key variables for T1 paths
tempCohortPath<-templateCohortFull[,c("bblid","scanid","date_provided")]
tempCohortPath.v2<-tempCohortPath[order(tempCohortPath$bblid),]
write.csv(tempCohortPath.v2,'/data/joy/BBL/studies/reward/summaryScores/clinical/subjectData/n120_tempCohortVarforPaths_041317.csv', row.names=F)


