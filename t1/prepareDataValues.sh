#!/bin/bash
#AFGR August 5 2016
##LB July 5 2017
# This script is going to be used to prep the data for the JLF volume and ANTsCT volume values

# Delcare any statics
jlfDirectory="/data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/*/*/jlf/"
jlfVolDir="/data/jux/BBL/projects/rewardAnalysisReproc/qa/t1/output_20180611/"
ctDirectory="/data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/*/*/antsCT/"
scriptsDir="/data/jux/BBL/projects/rewardAnalysisReproc/rewardAnalysisReprocScripts/t1/"
subjInfoDir="/data/joy/BBL/studies/pnc/subjectData/"

# First thing we have to do is create the raw volume output for the jlf labels
rm -f ${jlfVolDir}jlfVolValues_20180611.txt
for i in `find ${jlfDirectory} -name "*jlfLabelsANTsCTIntersection.nii.gz"` ; do vals=`fslstats ${i} -H 208 0 207` ; echo ${i} ${vals} ; done >> ${jlfVolDir}jlfVolValues_20180611.txt

# Now do the antsCT values
rm -f ${jlfVolDir}ctVolValues_20180611.txt
for i in `find ${ctDirectory} -maxdepth 12 -name "*BrainSegmentation.nii.gz"` ; do vals=`fslstats ${i} -H 7 0 6` ; echo ${i} ${vals} ; done >> ${jlfVolDir}ctVolValues_20180611.txt

# Now fix the subject fields using an *NON FLEXIBLE R SCRIPT*
R --slave -f ${scriptsDir}/prepSubjFields.R ${jlfVolDir}jlfVolValues_20180611.txt
R --slave -f ${scriptsDir}/prepSubjFields.R ${jlfVolDir}ctVolValues_20180611.txt

# Now I need to adjust the headers of the proper Subject field files 
R --slave -f ${scriptsDir}/prepVolHeader.R ${jlfVolDir}jlfVolValues_20180611properSubjFields.csv
R --slave -f ${scriptsDir}/prepCtHeader.R ${jlfVolDir}ctVolValues_20180611properSubjFields.csv

# Now find voxel dimensions for each scan
for i in `find ${jlfDirectory} -name "*_Labels.nii.gz"` ; do 
  xDim=`fslinfo ${i} | grep pixdim1 | cut -f 9 -d ' '`
  yDim=`fslinfo ${i} | grep pixdim2 | cut -f 9 -d ' '`
  zDim=`fslinfo ${i} | grep pixdim3 | cut -f 9 -d ' '`
  voxDem=`echo "${xDim}*${yDim}*${zDim}" | bc`
  echo ${i} ${voxDem} >> ${jlfVolDir}voxelVolume_20180611.txt ; 
done

# Now I need to combine the manual ratings, jlf and ct values
R --slave -f ${scriptsDir}/prepSubjFields.R ${jlfVolDir}voxelVolume_20180611.txt
R --slave -f ${scriptsDir}/combineAllVolVals.R ${jlfVolDir}jlfVolValues_20170719properSubjFieldsProperColNames.csv  ${jlfVolDir}ctVolValues_20180611properSubjFieldsProperColNames.csv ${subjInfoDir}n1601_t1RawManualQA.csv ${subjInfoDir}n368_t1RawManualQA_GO2.csv ${jlfVolDir}voxelVolume_20180611properSubjFields.csv

# Now clean up 
rm -f ${jlfVolDir}*properSubjField.csv ${jlfVolDir}*ProperColNames.csv ${jlfVolDir}voxelVolume_20180611.txt ${jlfVolDir}ctVolValues_20180611.txt ${jlfVolDir}jlfVolValues_20180611.txt

