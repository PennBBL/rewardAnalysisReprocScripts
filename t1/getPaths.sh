#!/usr/bin/env bash

#This is a simple script to isolate all paths for a image sequence

#subject files 
subj1=$(ls -d /data/joy/BBL/studies/reward/rawData/*/*)  
rundir=t1
rundir2=t1_multiecho
niftidir=nifti
logdir=/data/joy/BBL/studies/reward/summaryScores/clinical/logs/
groupout=/data/joy/BBL/studies/reward/summaryScores/clinical/subjectLists/all_T1_Paths_050117.csv
outname1=*.nii.gz

#cleanup logs
rm -f $groupout	
rm -f $logdir/t1_nifti_missing_050117.txt

for s in $subj1; do 

	echo ""
	cd $s

	#get bblid id 
	bblid=$(echo $s | cut -d/ -f8)

	#get DOS
        dos=$(echo $s/* | cut -d/ -f9 | cut -dx -f1)

	echo "subject is $bblid $dos"

	#check if t1 nifti output is present
	t1_nifti=$(ls $s/$rundir/$niftidir/$outname1)
	if [ ! -e "$t1_nifti" ]; then 
		echo "t1 nifti not present! logging!"
		echo $bblid $dos >> $logdir/t1_nifti_missing_050117.txt
		continue
	else

		echo "t1 nifti present"

	fi
	
	#Save full T1 path
	echo "$t1_nifti" >> $groupout

	echo "output in $groupout"

done

for s in $subj1; do 

	echo ""
	cd $s

	#get bblid id 
	bblid=$(echo $s | cut -d/ -f8)

	#get DOS
        dos=$(echo $s/* | cut -d/ -f9 | cut -dx -f1)

	echo "subject is $bblid $dos"

	#check if t1_multiecho nifti output is present
	t1_multiecho_nifti=$(ls $s/$rundir2/$niftidir/$outname1)
	if [ ! -e "$t1_multiecho_nifti" ]; then 
		echo "t1_multiecho nifti not present! logging!"
		echo $bblid $dos >> $logdir/t1_nifti_missing_multiecho_050117.txt
		continue
	else

		echo "t1_multiecho nifti present"

	fi
	
	#Save full T1 path
	echo "$t1_multiecho_nifti" >> $groupout

	echo "output in $groupout"

done

exit 
