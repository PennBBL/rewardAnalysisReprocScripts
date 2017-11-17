scanids=$(cat /data/joy/BBL/projects/rewardAnalysisReproc/subjectLists/ravens/n324_rewardRavens.csv); 

for i in $scanids; do 
    id=$(echo $i|cut -d',' -f1); 
    sc=$(echo $i|cut -d',' -f2);
    sc=$(echo $sc|cut -d'x' -f2);
    meanCT=`cat /data/joy/BBL/studies/reward/processedData/structural/ravens/${id}/*${sc}/*MeanGM_CT_RAVENS2.txt`;
    spaCorr=`fslcc -p 10 --noabs /data/joy/BBL/studies/reward/processedData/structural/ravens/${id}/*${sc}/*_templateInSubjectSpace.nii.gz /data/joy/BBL/studies/reward/processedData/structural/struct_pipeline_201705311006/${id}/*${sc}/antsCT/*ExtractedBrain0N4.nii.gz`;
    spaCorr=$(echo $spaCorr | cut -d' ' -f3);
echo ${id},${sc},${meanCT},${spaCorr} >> /data/joy/BBL/projects/rewardAnalysisReproc/subjectLists/ravens/n324_Ravens_MeanCT.csv; 
done
