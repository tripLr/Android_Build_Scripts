#!/bin/bash

# tphltexx_910U.sh 


# Script to Build and Upload PixelPlus Exynos 5433 
# Set Global Parameters
. ~/bin/compile.sh

# update repo file to home dir
. ../../repo-update.sh

# Set build and directory parameters
export BUILDd=~/android/9/PixelPlus
export ROOMd=~/android/9/PixelPlus/.repo/local_manifests

# call server specific out dir
export out_dir=$OUT_DIR_COMMON_BASE

echo " using triplr room service for exynos master devices "
export ROOMs=https://raw.githubusercontent.com/tripLr/local_manifests-1/pixel-pie/exynos5433-master.xml

# finished compiles to internal RAID storage on server
#  treltexx     910C /home/shared/OUT_DIR/triplr/PixelPlus/target/product/treltexx
#  trelteskt    910S /home/shared/OUT_DIR/triplr/PixelPlus/target/product/trelteskt
#  tphltexx     910U /home/shared/OUT_DIR/triplr/PixelPlus/target/product/tphltexx
#  tbelteskt    915S /home/shared/OUT_DIR/triplr/PixelPlus/target/product/tbelteskt
#  tre3calteskt 916S /home/shared/OUT_DIR/triplr/PixelPlus/target/product/tre3calteskt

export shared910C='/home/shared/triplr/builds/PixelPlus910C'
export shared910S='/home/shared/triplr/builds/PixelPlus910S'
export shared910U='/home/shared/triplr/builds/PixelPlus910U'
export shared915S='/home/shared/triplr/builds/PixelPlus915S'
export shared916S='/home/shared/triplr/builds/PixelPlus916S'

#  out dir's
export out910C="$out_dir/PixelPlus/target/product/treltexx"
export out910S="$out_dir/PixelPlus/target/product/trelteskt"
export out910U="$out_dir/PixelPlus/target/product/tphltexx"
export out915S="$out_dir/PixelPlus/target/product/tbelteskt"
export out916S="$out_dir/PixelPlus/target/product/tre3calteskt"

# google drive folders
export AEX910C='18GW22NU1S51N-eDMD_yoJhxwQ584efKW'
export AEX910S='1RosSJ7u1da5-80zYKsL8K0Cm88SUVjm2'
export AEX910U='1c9zyTsg1I4lO_9zTfuxd3dYeKeLzDAg4'
export AEX915S='1VOM1VnHwE8EDU3cH7Qbt9EIm8gO6AnJJ'
export AEX916S='1GceKAhc8-IA8gj_wrQllfac6c8G_NJUe'



cd $BUILDd
# make clean

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/PixelPlus.xml $ROOMs
repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

# note : && if step completed, goto next step else exit code exit
#        & run this step in background to upload file

cd $BUILDd

# build thpltexx 910U
lunch aosp_tphltexx-userdebug
mka bacon -j$(nproc --all) | tee tphltexx-log.txt

cd $out910U
ls -al 
filename910U=$(basename *thpltexx*.zip) 
mv -v $BUILDd/tphltexx-log.txt $shared910U/$filename910U.log
mv -v  $filename*  $shared910U 
cd $shared910U 
ls -al 
gdrive upload --parent $AEX910U $filename910U  


cd $BUILDd 


echo "Happy Flashing !!"
