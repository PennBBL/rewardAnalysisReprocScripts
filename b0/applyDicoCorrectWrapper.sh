#!/bin/bash
# ---------------------------------------------------------------
# dicoCorrectWrapper.sh
#
# Use B0map use this wrapper to correct distortions for all images that require dico on CFN
#
# Lauren Beard 18092017
# ---------------------------------------------------------------

### Do for all reward subjects
#for i in $(ls -d /data/joy/BBL/studies/reward/rawData/*/*/restbold/nifti); do
#bblid=`echo $i | cut -d '/' -f8`
#datexscanid=`echo $i | cut -d '/' -f9`
bblid=16973
datexscanid=20120210x6418

# Create a function which will return the usage of this script
usage(){
echo
echo "Sean Yom	Usage:"
echo "  This script should be used to call /data/joy/BBL/applications/scripts/bin/dico_correct_v2.sh"
echo "	It will /data/joy/BBL/studies/reward/processedData/restbold/dico/16973/20120210x6418/16973_20120210x6418_dico.niibe used to dico all of the images in the rawData directory that requires dico"
echo "	Required input is a text file of the rps images and the respective paths"
echo "	dicoCorrectWrapper.sh -r <rpsmaps.txt>"
echo "  Optional arguments:"
echo "		-e: error output from sge directory"
echo "		-o: output directory for sge output"
echo "		-l: error log file"
echo "		-h: Output usage function"
echo
exit 2
}

# Create a group of functions which will be used to perform all of the error catching and logging
# The first function will check that files exist 
checkFileStatus(){
  fileToCheck=${1}
  logFile=${2}
  subj=${3}
  if [ ! -f "${fileToCheck}" ] ; then
    if [ ! -f "${logFile}" ] ; then
      echo "Error Image, Error Status" >> ${logFile} ; 
    fi
    echo "One of the dico correction images was not present"
    echo "Skipping ${subj}"
    echo "Check ${logFile} for more information"
    echo "${fileToCheck}, Image Not Found" >> ${logFile} 
    continue; 
  else
    return 0;
  fi
}


# Read in the input arguments
while getopts "r:e:o:l:h" OPTION ; do
  case ${OPTION} in
    r)
      rpsImageText=${OPTARG}
      ;;
    e)
      errorOutputDir=${OPTARG}
      ;;
    o)
      outputDir=${OPTARG}
      ;;
    h)
      usage
      ;;
    l)
      logDir=${OPTARG}
      ;;
    *)
      usage
      ;;
    esac
done

# Check to see if any inputs were provided
if [ $# == 0 ] ; then
  usage ; 
fi

# Now check to ensure that hostanem is chead
if [ ! `hostname` == "chead.uphs.upenn.edu" ] ; then
  echo "This script needs to be run from cfn's chead cluster"
  echo "This script is written to submit jobs to the grid"
  echo "chead is the cfn compute node with access to submit jobs"
  exit 2 ;
fi

# Check for optional inputs and if they are empty declare some
if [ -z "${errorOutputDir}" ] ; then
  errorOutputDir="~/" ; 
fi

if [ -z "${outputDir}" ] ; then
  outputDir="~/" ; 
fi

if [ -z "${logDir}" ] ; then
  u=`whoami`
  logDir="/home/${u}/" ; 
fi

# Now lets declare all of the statics
timeOfExecution=`date +%y_%m_%d_%H_%M_%S`
logFile="${logDir}dicoCorrectionErrorLog_${timeOfExecution}.csv"
finishedFile="${logDir}dicoCorrectionSubmittedLog_${timeOfExecution}.csv"
scriptToCall="/data/joy/BBL/applications/scripts/bin/dico_correct_v2.sh"
rawDataBase="/data/joy/BBL/studies/reward/rawData/"
processedDataBase="/data/joy/BBL/studies/reward/processedData/"
b0DataBase="${processedDataBase}b0mapwT2star/"
exampleDicomBase="/data/joy/BBL/projects/rewardAnalysisReproc/exampleDicoms/restbold/"
exampleDicomArray=("${exampleDicomBase}${bblid}_${datexscanid}_restbold_exampleDicom.dcm" )
baseQSubCall="qsub -V -q all.q -S /bin/bash -o ${outputDir} -e ${errorOutputDir}"
fileLength=`cat ${rpsImageText} | wc -l`

# Now go through some checks to ensure that the provided text input is correct
# First check to make sure that the provided input file is a text file
fileExtensionCheck=`echo ${rpsImageText} | rev | cut -f 1 -d '.' | rev`
if [ ! "${fileExtensionCheck}" == "txt" ]   ; then 
  echo "Provided file type for ${rpsImageText} is not a .txt file"
  echo "This file should be a text file which contains the paths to the rps images"
  echo "would you like to continue running this script?"
  read -r -p "Enter a y or n:" answer
  answer=${answer,,}
  if [[ ${answer} =~ ^(no|n)$ ]] ; then  
    echo "rpsmaps.txt can be created with either the ls command by running:"
    echo "ls /data/joy/BBL/studies/reward/processedData/b0mapwT2star/<BBLID>/<SCANDATE>x<SCANID>/<BBLID>_<SCANDATE>x<SCANID>_rpsmap.nii.gz > example.txt"
    echo "OR:"
    echo "find /data/joy/BBL/studies/reward/processedData/b0mapwT2star/<BBLID>/<SCANDATE>x<SCANID>/ -type f -name '*rps*'" 
    exit 2; 
  fi
fi

# Now check to make sure that the provided input file uses the correct paths for this script
providedFilePathCheck=`sed -n "1p" ${rpsImageText} | cut -f 1-8 -d /`
if [ ! "${providedFilePathCheck}" == "/data/joy/BBL/studies/reward/processedData/b0mapwT2star" ] ; then
  echo "The provided file path for the rps image was not correct"
  echo "RPS images must be stored in '/data/joy/BBL/studies/reward/processedData/b0mapwT2star'"
  echo "Following the <BBLID>/<SCANDATE>x<SCANID> file structure"
  echo "RPS images should be created, and then stored in the proper directory using the script seen below:"
  echo "/data/joy/BBL/applications/scripts/bin/dico_correct_v2.sh"
  echo "Creating the proper text file can be performed by following the logic of one of these script calls:"
  echo "ls /data/joy/BBL/studies/reward/processedData/b0mapwT2star/<BBLID>/<SCANDATE>x<SCANID>/<BBLID>_<SCANDATE>x<SCANID>_rpsmap.nii > example.txt"
  echo "OR:"
  echo "find /data/joy/BBL/studies/reward/processedData/b0mapwT2star/<BBLID>/<SCANDATE>x<SCANID>/ -type f -name '*rps*' > example.txt" 
  echo
  echo
  echo "Script will now exit"
  exit 2 ; 
fi


# Now prime the output finish log
echo "BBLID, SCANID, SEQUENCE, STATUS, QSUB_CALL" > ${finishedFile}

# Now cycle through each rps image in the input file
for indexValue in `seq 1 ${fileLength}` ; do
 
  # Now find the subject specific details
  rpsImage=`sed -n "${indexValue}p" ${rpsImageText}`
  allSubjInfo=`basename ${rpsImage} | xargs remove_ext`
  bblid=`echo ${allSubjInfo} | cut -f 1 -d '_'`
  scanid=`echo ${allSubjInfo} | cut -f 2 -d 'x' | cut -f 1 -d '_'`
  dateid=`echo ${allSubjInfo} | cut -f 1 -d 'x' | cut -f 2 -d '_'`
  magImage="${b0DataBase}${bblid}/${dateid}x${scanid}/${bblid}_${dateid}x${scanid}_mag1_brain.nii.gz"
  rpsMaskImage="${b0DataBase}${bblid}/${dateid}x${scanid}/${bblid}_${dateid}x${scanid}_mask.nii.gz"
  
  # Now do some quick sanity checks to make sure that all of the variables are present
  checkFileStatus ${magImage} ${logFile} ${bblid}
  checkFileStatus ${rpsMaskImage} ${logFile} ${bblid}
  checkFileStatus ${rpsImage} ${logFile} ${bblid}

  # Now go through each modality and check if there is a 4d nifti and if there is run the distortion correction file
##LBEARD removed frac2back idemo pcasl from this scanIdentifiers line 
 scanIdentifiers=( restbold )
  forLoopLength=`echo ${#scanIdentifiers[@]}-1 | bc`
  for seriesID in `seq 0 ${forLoopLength}` ; do 
    indScan=${scanIdentifiers[${seriesID}]}
    indExampleDicom=${exampleDicomArray[${seriesID}]}
    # Perform a quick sanity check to ensure that the indScan matchs up with the correct indExampleDicom
    ls ${indExampleDicom} | grep ${indScan} 2> /dev/null
    if [ ${?} -ne 0 ] ; then
      echo "A dicom does not match up with the current scan sequence"
      echo "DICOM FILE: ${indExampleDicom}"
      echo "SERIES: ${indScan}"
      echo "Check ${exampleDicomBase} to ensure that all Dicom files are present"
      echo "Here is a list of all of the sample Dicoms:"
      echo "${scanIdentifiers[@]}"
    fi
    # Now go thorugh the steps to submit the qsub job
    if [ "${indScan}" == "restbold" ] ; then
      tmpScanCheck=`find ${rawDataBase}${bblid}/${dateid}x${scanid}/ -maxdepth 1 -name "*${indScan}*" -type d` ; 
    elif [ "${indScan}" == "pcasl" ] ; then
      tmpScanCheck=`find ${rawDataBase}${bblid}/${dateid}x${scanid}/ -maxdepth 1 -name "*se*${indScan}*1200ms" -type d` ;
    else
      tmpScanCheck=`find ${rawDataBase}${bblid}/${dateid}x${scanid}/ -maxdepth 1 -name "*${indScan}*" -type d` ; 
    fi
    outputDir="${processedDataBase}${indScan}/dico/${bblid}/${dateid}x${scanid}/"
    output="${outputDir}${bblid}_${dateid}x${scanid}"
    if [[ -d ${tmpScanCheck} ]] ; then
      mkdir -p ${outputDir}
      niftiSeries=`ls ${tmpScanCheck}/nifti/*_RPI.nii.gz` 
      if [ "${indScan}" == "pcasl" ] ; then
        niftiSeries=`ls ${tmpScanCheck}/nifti/*SEQ??.nii.gz` >/dev/null
        if [ ${?} -ne 0 ] ; then
          niftiSeries=`ls ${tmpScanCheck}/nifti/*1200ms.nii.gz` ;
        fi ;
      fi
      if [ -f "${output}_dico.nii" ] ; then
        echo
        echo "Dico correction file is already present"
        echo "Skipping job submission for:"
        echo "BBLID: ${bblid}"
        echo "SCANID: ${scanid}"
        echo "DATE: ${dateid}"
        echo "SERIES: ${indScan}"
        echo "FINISHED DICO:${output}_dico.nii"
        echo "Check ${finishedFile} for more input"
        echo
        echo "${bblid}, ${scanid}, ${indScan}, File Already Present ${output}_dico.nii, N/A" >> ${finishedFile}
      else     
        qSubCall="${baseQSubCall} ${scriptToCall} -n -FS -e ${indExampleDicom} -f ${magImage} ${output} ${rpsImage} ${rpsMaskImage} ${niftiSeries}"
        ${qSubCall}
        ${baseQSubCall} /share/apps/fsl/5.0.8/bin/fslchfiletype NIFTI_GZ ${output}_dico.nii
        ${baseQSubCall} /share/apps/fsl/5.0.8/bin/fslchfiletype NIFTI_GZ ${output}_shiftmap.nii
        echo "${bblid}, ${scanid}, ${indScan}, Submitted @ `date +%y_%m_%d_%H_%M_%S`, ${qSubCall}" >> ${finishedFile}; 
      fi
    fi
    unset tmpScanCheck
  done
done

#done

echo "Done with job submission"
exit 0
