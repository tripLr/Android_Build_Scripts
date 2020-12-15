#!/bin/bash
# Script to Build and Upload LOS16 TRLTE


cd $BUILDd

# set environment for build 
. build/envsetup.sh

# build trlte
brunch trlte-userdebug | tee trlte-log.txt

# Begin copy to shared and upload trlte
cd $LOS16trlte
ls -al
filename=$(basename Aosp*.zip) 
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename.log
mv -v $BUILDd/repo.log $sharedTR/$filename.repo.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
gdrive upload --parent $LOS16trlteG $filename 
gdrive upload --parent $LOS16trlteG $filename.img 
gdrive upload --parent $LOS16trlteG $filename.md5sum 
cd $BUILDd
