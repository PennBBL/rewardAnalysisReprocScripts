for i in $(ls -d /data/joy/BBL/studies/reward/rawData/*/*/restbold/nifti); do
bblid=`echo $i | cut -d '/' -f8`
datexscanid=`echo $i | cut -d '/' -f9`

/data/joy/BBL/applications/scripts/bin/force_RPI.sh /data/joy/BBL/studies/reward/rawData/$bblid/$datexscanid/restbold/nifti/${bblid}_${datexscanid}_restbold.nii.gz /data/joy/BBL/studies/reward/rawData/$bblid/$datexscanid/restbold/nifti/${bblid}_${datexscanid}_restbold_RPI.nii.gz

done
