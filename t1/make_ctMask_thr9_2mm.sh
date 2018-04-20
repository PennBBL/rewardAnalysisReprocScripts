# Create a mask that will remove images with too many 0 or <.1 values using Phil's method.
# NOTE: need a qlogin with 50G of memory to run this, else, will say "core dumped" (qlogin -l h_vmem=50.5G,s_vmem=50.0G)

# Read list of subject IDs that pass QA
cat /data/joy/BBL/projects/rewardAnalysisReproc/subjectLists/n477_scanid_bblid_date_datexscanid.csv | while IFS="," read -r a b ;

do 

# Define output directory
outdir=/data/joy/BBL/studies/reward/n477_dataFreeze/neuroimaging/t1struct/ctMask

# Define the list of input image paths
imgList=`ls -d /data/joy/BBL/studies/reward/n477_dataFreeze/neuroimaging/t1struct/voxelwiseMaps_antsCt/${a}_CorticalThicknessNormalizedToTemplate2mm.nii.gz`;

# Create mask
for i in $imgList; do 

# get scanid: first echo the path (echo $i), then cut the path up by delimiter "/" (-d'/'), then take the 10th field (-f11) which is "2632_CorticalThicknessNormalizedToTemplate2mm.nii.gz", then cut up the file name by delimiter "." and just keep the first field (which will be the file name without ".nii.gz").                                                                                                                                                              
        fileName=$(echo $i | cut -d '/' -f11  | cut -d '.' -f1)
        echo "file name is $fileName"

	ThresholdImage 3 $i ${outdir}/${fileName}_mask.nii.gz 0.1 Inf
done

done

# Average the masks together and binarize/threshold the final mask.
outdir=/data/joy/BBL/studies/reward/n477_dataFreeze/neuroimaging/t1struct/ctMask

AverageImages 3 ${outdir}/coverageMask.nii.gz 0 ${outdir}/*mask.nii.gz

fslmaths ${outdir}/coverageMask.nii.gz -thr .9 -bin ${outdir}/n477_ctMask_thr9_2mm.nii.gz
