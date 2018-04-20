#!/bin/bash

#set freesurfer specific environment variables for output
export SUBJECTS_DIR="/data/joy/BBL/studies/reward/processedData/freesurfer53"

slist=$(cat /data/joy/BBL/studies/reward/processedData/freesurfer53/needFS.txt) 

#create a variable which gets the log directory output
logs="/data/joy/BBL/studies/reward/processedData/freesurfer53/logs"

#for every subject in the subjects folder
for i in $slist
do

	#print the subject id to the screen
	echo $i

	#get bblid_scanid
	subjid=`echo "$i"`
	
	#create a variable for their MPRAGE dicom file (just one example dicom needed)	
	infile=`ls -d /data/joy/BBL/studies/reward/rawData/$subjid/t1/nifti/*t1.nii.gz`

	#get the working subjects folder for that subject
	surfpath=`ls -d /data/joy/BBL/studies/reward/processedData/freesurfer53/$subjid`
	
	#if the freesurfer folder isn't empty for that subject then skip that subject        
	#if [ "X$surfpath" != "X" ]; then
	#	echo "*-*-*-*-Freesurfer has already been run for this subject-*-*-*-*"
	#	continue
	
	#if there is no freesurfer folder for that subject then submit the freesurfer_grid_submission script to the grid
	#else
	qsub -V -e $logs -o $logs -q all.q -S /bin/bash /data/joy/BBL/studies/reward/processedData/freesurfer53/freesurfer_grid_submission.sh $infile $SUBJECTS_DIR $subjid
#fi
done 
