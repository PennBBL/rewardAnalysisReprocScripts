###################################################################################################
##########################     Reward - Replication for Data Freeze      ##########################
##########################               Robert Jirsaraie                ##########################
##########################        rjirsara@pennmedicine.upenn.edu        ##########################
##########################                 11/13/2017                    ##########################
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
<<USE

This script contains the commands used in order to fully replicate the reward structural dataset.

USE
###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################

#######################################################################
##### Pulls the Scripts From The Reward Git Repo & Create Copies  #####
#######################################################################

mkdir -p /home/rjirsaraie/Testing/RewardReplication

cd /home/rjirsaraie/Testing/RewardReplication

#git clone git@github.com:PennBBL/rewardAnalysisReprocScripts.git # Use Git Pull Instead!

mkdir DesignFile
mkdir CohortFile

cp /home/rjirsaraie/Testing/RewardReplication/rewardAnalysisReprocScripts/t1/struct_pipeline_201705311006.dsn /home/rjirsaraie/Testing/RewardReplication/DesignFile/

cp /data/joy/BBL/projects/rewardAnalysisReproc/subjectLists/n477_cohort.csv /home/rjirsaraie/Testing/RewardReplication/CohortFile/

################################################################################
##### Randomly Selects 10 Subjects From the Cohort File & Creates New Copy #####
################################################################################

sort -R /home/rjirsaraie/Testing/RewardReplication/CohortFile/n477_cohort.csv | head -n 10 >>/home/rjirsaraie/Testing/RewardReplication/CohortFile/n10_Cohort_`date +"20%y%m%d"`.csv

########################################################
##### Adjusts the Design File & Creates a New Copy #####
########################################################

DSNfile=struct_pipeline_201705311006@struct_pipeline_replication_`date +"20%y%m%d"`

DSNPath=/data/joy/BBL/projects/rewardAnalysisReproc/rewardAnalysisReprocScripts/t1/struct_pipeline@/home/rjirsaraie/Testing/RewardReplication/DesignFile/struct_pipeline

Cohort=/data/joy/BBL/projects/rewardAnalysisReproc/subjectLists/n477_cohort.csv@/home/rjirsaraie/Testing/RewardReplication/CohortFile/n10_Cohort_20171113.csv

SubsCount=477@10

Output=/data/joy/BBL/studies/reward/processedData/@/data/joy/BBL/studies/reward/processedData/structural/

PathCorrect=/struct_pipeline/@"/"


cat /home/rjirsaraie/Testing/RewardReplication/DesignFile/struct_pipeline_201705311006.dsn |sed s@${DSNfile}@g|sed s@${DSNPath}@g|sed s@${Cohort}@g|sed s@${SubsCount}@g|sed s@${Output}@g|sed s@${PathCorrect}@g >> /home/rjirsaraie/Testing/RewardReplication/DesignFile/struct_pipeline_replication_`date +"20%y%m%d"`.dsn

chmod +x /home/rjirsaraie/Testing/RewardReplication/DesignFile/struct_pipeline_replication_`date +"20%y%m%d"`.dsn

###################################################
##### Executes the Call To Lanch the Pipeline #####
###################################################

/data/joy/BBL/applications/xcpEngine/xcpEngine -d /home/rjirsaraie/Testing/RewardReplication/DesignFile/struct_pipeline_replication_`date +"20%y%m%d"`.dsn -m 'c' -t 

###################################################################################################
#####  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  ⚡  #####
###################################################################################################
