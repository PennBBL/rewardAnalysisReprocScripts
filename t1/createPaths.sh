#!/usr/bin/env bash

#This is a simple script to isolate the T1 paths for the template cohort

#subject files 
subjdir=$(ls -d /data/joy/BBL/studies/reward/rawData)  
cohort=$(cat /data/joy/BBL/studies/reward/summaryScores/clinical/subjectData/n120_tempCohortVarforPaths_041317.csv)
rundir=t1
niftidir=nifti
logdir=$(ls -d /data/joy/BBL/studies/reward/summaryScores/clinical/logs)
groupout=/data/joy/BBL/studies/reward/summaryScores/clinical/subjectLists/tempCohort_T1_Paths_041317.csv
outname1=*.nii.gz

#cleanup logs
rm -f $groupout	
rm -f $logdir/missingT1template_041317.txt

for c in $cohort; do

	echo "$c"

	#get bblid id 
	bblid=$(echo $c | cut -d, -f1)

	#get scan id
	scanid=$(echo $c | cut -d, -f2)

	#get DOS
        dos=$(echo $c | cut -d, -f3)

	echo "subject is $bblid $scanid $dos"

	#check if t1 nifti output is present
	t1_nifti=$(ls $subjdir/$bblid/${dos}x${scanid}/$rundir/$niftidir/${bblid}_${dos}x${scanid}_t1.nii.gz)
	if [ ! -e "$t1_nifti" ]; then 
		echo "t1 nifti not present! logging!"
		echo $bblid $dos >> $logdir/missingT1template_041317.txt
		continue
	else

		echo "t1 nifti present"
		fslinfo $t1_nifti | grep "dim" >> $logdir/imagedimensions_041317.txt
	
	fi
	
	#Save full T1 path
	echo "$t1_nifti" >> $groupout

	echo "output in $groupout"


done

exit
