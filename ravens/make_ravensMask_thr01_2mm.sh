# Create a cortical and subcortical mask.
# This will be the final mask for Ravens and a mask to remove brainstem and cerebellum in the GMD mask.

# See TemplateCreation wiki (https://github.com/PennBBL/pncReproc2015Scripts/wiki/TemplateCreation) for documentation of how the priors were made.

# prior image (cortical grey matter) 
prior002=/data/joy/BBL/studies/reward/templateCohort/template/templatePriorsRenorm/prior002_2mm.nii.gz

# prior image (subcortical grey matter)
prior004=/data/joy/BBL/studies/reward/templateCohort/template/templatePriorsRenorm/prior004_2mm.nii.gz

# This is where the output mask goes
outdir=/data/joy/BBL/projects/rewardAnalysisReproc/masks

echo "outdir is $outdir"

echo ""

# Combine the priors
fslmaths $prior002 -add $prior004 ${outdir}/prior_002_004_2mm_cortSubcort.nii.gz

# Threshold and binarize
# NOTE: A threshold of .01 was needed for continuous coverage with few holes.
fslmaths ${outdir}/prior_002_004_2mm_cortSubcort.nii.gz -thr 0 -bin ${outdir}/CorticalSubcorticalMask.nii.gz

# This will be the final Ravens mask
mv $outdir/CorticalSubcorticalMask.nii.gz $outdir/n477_ravensMask_thr0_2mm.nii.gz
