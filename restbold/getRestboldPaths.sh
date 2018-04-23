#!/usr/bin/env bash

#This is a simple script to isolate all paths for a image sequence

#subject files 
subj1=$(ls -d /data/joy/BBL/studies/reward/rawData/*/*)  
rundir=restbold
niftidir=nifti
logdir=/data/joy/BBL/studies/reward/summaryScores/clinical/logs/
groupout=/data/joy/BBL/studies/reward/summaryScores/clinical/subjectLists/all_RB_Paths_050117.csv
outname1=*.nii.gz

#cleanup logs
rm -f $groupout	
rm -f $logdir/rb_nifti_missing_050117.txt

for s in $subj1; do 

	echo ""
	cd $s

	#get bblid id 
	bblid=$(echo $s | cut -d/ -f8)

	#get DOS
        dos=$(echo $s/* | cut -d/ -f9 | cut -dx -f1)

	echo "subject is $bblid $dos"

	#check if rb nifti output is present
	rb_nifti=$(ls $s/$rundir/$niftidir/$outname1)
	if [ ! -e "$rb_nifti" ]; then 
		echo "rb nifti not present! logging!"
		echo $bblid $dos >> $logdir/rb_nifti_missing_050117.txt
		continue
	else

		echo "rb nifti present"

	fi
	
	#Save full RB path
	echo "$rb_nifti" >> $groupout

	echo "output in $groupout"

done

exit 
