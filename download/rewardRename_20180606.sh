# canoncial structure: 
# b0_a  b0_b  behavioral  cardA0  cardB0  itc1  itc2  restbold  rsMultiband  t1  t1_nav

# downloaded structure:
# B0map_onesizefitsall_v4_M  bbl1_effort3_mb6_1X1X1_236_um000  ep2d_effort2_236  localizer_um000
# B0map_onesizefitsall_v4_P  ep2d_effort1_236                  ep2d_single       MPRAGE_TI1100_ipat2_um001

for i in `ls -d /data/jux/BBL/projects/rewardAnalysisReproc/xnatDownload2/*/*`; do
	bblid=`echo "$i" | cut -d '/' -f8`
	datexscanid=`echo "$i" | cut -d '/' -f9`
	scanid=`echo "$datexscanid" | cut -d 'x' -f2`

	# t1 naming: MPRAGE_TI1100_ipat2_um000
	if [ -e /data/jux/BBL/projects/rewardAnalysisReproc/xnatDownload2/${bblid}/${datexscanid}/MPRAGE_TI1100_ipat2_um000/nifti/*.nii.gz ]; then
		mv /data/jux/BBL/projects/rewardAnalysisReproc/xnatDownload2/${bblid}/${datexscanid}/MPRAGE_TI1100_ipat2_um000 /data/jux/BBL/projects/rewardAnalysisReproc/xnatDownload2/${bblid}/${datexscanid}/t1
		mv /data/jux/BBL/projects/rewardAnalysisReproc/xnatDownload2/${bblid}/${datexscanid}/t1/nifti/*nii.gz /data/jux/BBL/projects/rewardAnalysisReproc/xnatDownload2/${bblid}/${datexscanid}/t1/nifti/${bblid}_${datexscanid}_t1.nii.gz

	fi
done

