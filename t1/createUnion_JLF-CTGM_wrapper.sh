# JLF-GM Intersection for n489 Reward

# Set paths
home=$(ls -d /data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/)
outdir=$(ls -d /data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/)
qa=$(ls -d /data/jux/BBL/projects/rewardAnalysisReproc/qa)
function=/data/jux/BBL/projects/rewardAnalysisReproc/rewardAnalysisReprocScripts/t1/createUnionJLFAndCTGMMask.sh

# Set variables
for i in $(cat /data/jux/BBL/projects/rewardAnalysisReproc/xnatDownload2/n12_bblid_datexscanid_scanid.csv); do
	bblid=`echo "$i" | awk -F ',' '{print $1}'`
	datexscanid=`echo "$i" | awk -F ',' '{print $2}'`
 
	$function $home/$bblid/$datexscanid/jlf/${bblid}_${datexscanid}_Labels.nii.gz $home/$bblid/$datexscanid/antsCT/${bblid}_${datexscanid}_BrainSegmentation.nii.gz $home/$bblid/$datexscanid/jlf/${bblid}_${datexscanid}_jlfLabelsANTsCTIntersection.nii.gz

done
