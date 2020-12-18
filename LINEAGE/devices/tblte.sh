#!/bin/bash


cd $BUILDd
make clean

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/LOS16.xml $ROOMs
repo sync -c -j4 force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

# build tblte
lunch aosp_tblte-userdebug
mka aex -j$(nproc --all) | tee tblte-log.txt

 Begin copy to shared and upload tblte
cd $LOS16tblte
ls -al
filename=$(basename Aosp*.zip)
mv -v $BUILDd/tblte-log.txt $sharedTB/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
gdrive upload --parent $LOS16tblteG $filename 
gdrive upload --parent $LOS16tblteG $filename.img 
gdrive upload --parent $LOS16tblteG $filename.md5sum 
cd $BUILDd
