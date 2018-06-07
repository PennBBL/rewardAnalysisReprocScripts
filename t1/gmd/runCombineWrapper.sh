subjlist=${1}
noParcText="/data/jux/BBL/projects/rewardAnalysisReproc/subjectLists/n477_scanid_bblid_date_datexscanid.csv"
subj=$(cat $subjlist | sed -n "${SGE_TASK_ID}p")
bblid=`echo ${subj} | awk -F ',' '{print $2}'`
datexscanid=`echo ${subj} | awk -F ',' '{print $4}'`
antsPath="/data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/${bblid}/${datexscanid}/antsCT/"
outImg="atropos3class.nii.gz"
parcImg="/data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/${bblid}/${datexscanid}/jlf/${bblid}_${datexscanid}_Labels.nii.gz"
parcDir="JLF"
scriptToCall=""
templateImg="/data/joy/BBL/studies/reward/n477_dataFreeze/neuroimaging/rewardTemplate/templateBrain.nii.gz"
if [ -z ${parcImg} ] ; then 
  echo "${bblid},${scanid},${dateid}" >> ${noParcText}  
else
  /data/jux/BBL/projects/rewardAnalysisReproc/rewardAnalysisReprocScripts/t1/gmd/antsCTPostProcAndGMD.sh -d ${antsPath} -o ${outImg} -p ${parcImg} -P ${parcDir} -t ${templateImg} -s 0; 
fi
