###################################################################################################
##########################          Reward - Replication Analysis        ##########################
##########################              Robert Jirsaraie                 ##########################
##########################       rjirsara@pennmedicine.upenn.edu         ##########################
##########################                  11/21/2017                   ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
#### Use ####

# These analysis were conducted in order to compare the processed data from the Reward Dataset. 

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

##############################################################
##### Reads in the Original and Reduced Replication Data #####
##############################################################

repVol <- read.csv("/home/rjirsaraie/Testing/RewardReplication/Output/n10_jlfAntsCTIntersectionVol_20171121.csv")
repCT <- read.csv("/home/rjirsaraie/Testing/RewardReplication/Output/n10_jlfAntsCTIntersectionCt_20171121.csv")

OrgVol <- read.csv("/home/rjirsaraie/Testing/RewardReplication/RewardOutput/n477_jlfAntsCTIntersectionVol_20170721.csv")
OrgCT <- read.csv("/home/rjirsaraie/Testing/RewardReplication/RewardOutput/n477_jlfAntsCTIntersectionCt_20170731.csv")

###########################################################################
##### Selects Only the Subjects of Interest From The Original Dataset #####
###########################################################################

OrgVol <- OrgVol[(OrgVol$scanid %in% repVol$scanid),]

OrgCT <- OrgCT[(OrgCT$scanid %in% repCT$scanid),]

##########################################################################
##### Computes Averages of Rows and Adds them as a Column to Dataset #####
##########################################################################

repVol <- repVol[ -c(1,2) ]

repCT <- repCT[ -c(1,2) ]

OrgVol <- OrgVol[ -c(1,2) ]

OrgCT <- OrgCT[ -c(1,2) ]

#################################################################
##### Computes Averages of Columns and Adds them to Dataset #####
#################################################################

Means <- rowMeans(repVol, na.rm = FALSE, dims = 1)
repVol <- cbind(repVol,Means)

Means <- rowMeans(repCT, na.rm = FALSE, dims = 1)
repCT <- cbind(repCT,Means)

Means <- rowMeans(OrgVol, na.rm = FALSE, dims = 1)
OrgVol <- cbind(OrgVol,Means)

Means <- rowMeans(OrgCT, na.rm = FALSE, dims = 1)
OrgCT <- cbind(OrgCT,Means)

#############################################################
##### Takes the Average from the Average of all Columns #####
#############################################################

mrepVol<-mean(repVol$Means)

mrepCT<-mean(repCT$Means)

mOrgVol<-mean(OrgVol$Means)

mOrgCT<-mean(OrgCT$Means)

#########################################################################
##### Subtracts The Averages From One Another to get the Difference #####
#########################################################################

Voldiff <- mOrgVol-mrepVol

CTdiff <- mOrgCT-mrepCT

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
