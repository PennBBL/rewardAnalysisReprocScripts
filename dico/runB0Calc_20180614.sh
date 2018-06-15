#!/bin/bash

#########################################################################################
#####################       Reward n477 Distortion Correction         ###################
#####################                 Lauren Beard                    ###################
#####################              lbeard@sas.upenn.edu               ###################
#####################                   09/08/2017                    ###################
#########################################################################################

# This script was written to create all the reward b0 maps
# It is just a rough for loop which runs Mark Elliot's dico_b0calc_v4_afgr.sh script
# AFGR edited Mark Elliots script to make sure it took the correct inputs

# Run through each subject and calcualte a b0 rps map for them
subjFile="/data/jux/BBL/projects/rewardAnalysisReproc/subjectLists/n501_bblid_datexscanid_scanid_date.csv"
subjLength=`cat ${subjFile} | wc -l`
baseOutputPath="/data/joy/BBL/studies/reward/processedData/b0mapwT2star_20180614"
baseRawDataPath="/data/joy/BBL/studies/reward/rawData/"
baseExtractedPath="/data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/"
scriptToCall="/data/jux/BBL/projects/rewardAnalysisReproc/rewardAnalysisReprocScripts/dico/dico_b0calc_v4_afgr.sh"
forceScript="/data/joy/BBL/applications/scripts/bin/force_RPI.sh"  

for subj in `seq 1 ${subjLength}` ; do
  rndDig=${RANDOM}
  bblid=`sed -n "${subj}p" ${subjFile} | cut -f 1 -d ","`
  scanid=`sed -n "${subj}p" ${subjFile} | cut -f 3 -d ","`
  scandate=`sed -n "${subj}p" ${subjFile} | cut -f 4 -d ","`
  subjRawData="${baseRawDataPath}/${bblid}/${scandate}x${scanid}/"
  subjB0Maps=`find ${subjRawData} -name "b0_*" -type d`
  subjB0Maps1=`echo ${subjB0Maps} | cut -f 1 -d ' '`
  subjB0Maps2=`echo ${subjB0Maps} | cut -f 2 -d ' '`
  subjOutputDir="${baseOutputPath}/${bblid}/${scandate}x${scanid}/"
  mkdir -p ${subjOutputDir}
  rawT1=`find ${subjRawData}/t1/nifti -name "*nii.gz" -type f`
  ${forceScript} ${rawT1} /data/joy/BBL/studies/reward/processedData/b0mapwT2star_20180614/${bblid}/${scandate}x${scanid}/tmp${rndDig}.nii.gz
  rawT1="/data/joy/BBL/studies/reward/processedData/b0mapwT2star_20180614/${bblid}/${scandate}x${scanid}/tmp${rndDig}.nii.gz"
  extractedT1=`find ${baseExtractedPath}/${bblid}/${scandate}x${scanid} -name "*Extracted*nii.gz"`
  if [ -f ${subjOutputDir}/${bblid}_${scandate}x${scanid}_rpsmap.nii ] ; then
    echo "output already exists"
    echo "Skipping BBLID:${bblid}"
    echo "	   SCANID:${scanid}"
    echo "         DATE:${scandate}"
    echo "*************************" ; 
  else
    ${scriptToCall} ${subjOutputDir} ${subjB0Maps1}/dicom*/ ${subjB0Maps2}/dicom*/ ${rawT1} ${extractedT1}  
    for i in `ls ${subjOutputDir}` ; do
      mv ${subjOutputDir}${i} ${subjOutputDir}${bblid}_${scandate}x${scanid}${i} 
    done ;
    for i in `ls ${subjOutputDir}*nii` ; do 
      /share/apps/fsl/5.0.8/bin/fslchfiletype NIFTI_GZ ${i} ; 
    done   
  fi  
  rm  /data/joy/BBL/studies/reward/processedData/b0mapwT2star_20180614/${bblid}/${scandate}x${scanid}/*tmp*.nii.gz;  
done
