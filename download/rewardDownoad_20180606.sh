#scanid_list.txt contains a list of scanids you wish to download
subjects=/data/jux/BBL/projects/rewardAnalysisReproc/xnatDownload2/scanids_download.csv

#loop through scanid_list.txt (i.e. through subjects) and get scanid as a variable called "scanid"  
for i in `cat $subjects`; do  
scanid=`echo $i`  

#download MPRAGE data for each subject  

/share/apps/python/Python-2.7.9/bin/python /data/jux/BBL/applications-from-joy/scripts/bin/dicoms2nifti_bblxnat.py -scanid $scanid -download 1 -upload 0 -outdir /data/jux/BBL/projects/rewardAnalysisReproc/xnatdownload/ -tmpdir /data/jux/BBL/projects/rewardAnalysisReproc/xnatdownload/temp -force_unmatched 1 -download_dicoms 1 -skip_oblique 0

#end loop through subjects  
done

