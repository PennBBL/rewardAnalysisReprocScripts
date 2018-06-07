joblist="/data/jux/BBL/projects/rewardAnalysisReproc/subjectLists/n477_scanid_bblid_date_datexscanid.csv"
ntasks=$(cat ${joblist} | wc -l)

qsub -q all.q,basic.q -l h_vmem=1.9G,s_vmem=1.5G -S /bin/bash -t 1-${ntasks} /data/jux/BBL/projects/rewardAnalysisReproc/rewardAnalysisReprocScripts/t1/gmd/runCombineWrapper.sh ${joblist}

