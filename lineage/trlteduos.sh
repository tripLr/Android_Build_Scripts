#!/bin/bash
# Script to Build and Upload LOS16 TRLTE duos


cd $BUILDd
make clean

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/LOS16.xml $ROOMs
repo sync -c -j4 force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

# build trlteduos
lunch aosp_trlteduos-userdebug
mka aex -j$(nproc --all) | tee trlteduos-log.txt

# Begin copy to shared and upload trlteduos
cd $LOS16trlteduos
ls -al
filename=$(basename Aosp*.zip)
mv -v $BUILDd/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
gdrive upload --parent $LOS16trlteduosG $filename 
gdrive upload --parent $LOS16trlteduosG $filename.img 
gdrive upload --parent $LOS16trlteduosG $filename.md5sum 
cd $BUILDd
