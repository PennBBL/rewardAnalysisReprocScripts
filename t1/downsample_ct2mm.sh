## Post Processing Script for ANTs
## Downsample ANTs cortical map to 2mm 

## Take all Cortical Thickness Maps (normalized to template)
for i in /data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/*/*/antsCT/*_CorticalThicknessNormalizedToTemplate.nii.gz; do 

## Get BBLID and SCANID
root=/data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006
id=`echo $i | cut -d "/" -f10`; 
sc=`echo $i | cut -d "/" -f11`;


root=`echo ${root}/${id}/${sc}`;
sc=`echo $sc | cut -d "x" -f2`;
outName=`echo ${root}/antsCT/${id}_${sc}_CorticalThicknessNormalizedToTemplate2mm.nii.gz`;


# USE ANTS Apply Transform to downsample this to 2mm space 
antsApplyTransforms -i ${i} -r /data/joy/BBL/studies/reward/templateCohort/template/templateResample/template_brain_2mm.nii.gz -o $outName

echo ' 
';
done
