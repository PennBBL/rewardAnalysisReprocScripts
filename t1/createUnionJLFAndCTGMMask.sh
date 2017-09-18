# JLF-GM Intersection for n477 Reward

# Set paths
home=$(ls -d /data/joy/BBL/studies/reward/processedData/struct_pipeline/struct_pipeline_201705311006)
outdir=$(ls -d /data/joy/BBL/studies/reward/processedData/struct_pipeline/struct_pipeline_201705311006)
qa=$(ls -d /data/joy/BBL/projects/rewardAnalysisReproc/qa)
function=/data/joy/BBL/projects/pncReproc2015/pncReproc2015Scripts/antsCT/postProc/createUnionJLFAndCTGMMask.sh

# Set variables
for i in $(cat /data/joy/BBL/projects/rewardAnalysisReproc/n477_bblid_scanid_date.csv); do
	bblid=`echo "$i" | awk -F ',' '{print $2}'`
	datexscanid=`echo "$i" | awk -F ',' '{print $4}'`
 
	$function $home/$bblid/$datexscanid/jlf/${bblid}_${datexscanid}_Labels.nii.gz $home/$bblid/$datexscanid/antsCT/${bblid}_${datexscanid}_BrainSegmentation.nii.gz $home/$bblid/$datexscanid/jlf/${bblid}_${datexscanid}_jlfLabelsANTsCTIntersection.nii.gz

done
