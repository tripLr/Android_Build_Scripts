# Script to Build and Upload PixelPlus Exynos 5433 
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account

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

export shared710='/home/shared/triplr/builds/PixelPlus710'
export shared715='/home/shared/triplr/builds/PixelPlus715'
export shared810='/home/shared/triplr/builds/PixelPlus810'
export shared815='/home/shared/triplr/builds/PixelPlus815'

# 710,715,810,815 out dir's
export t710=$out_dir/PixelPlus/target/product/gts28wifi
export t715=$out_dir/PixelPlus/target/product/gts28ltexx
export t810=$out_dir/PixelPlus/target/product/gts210wifi
export t815=$out_dir/PixelPlus/target/product/gts210ltexx

# google drive folders
export PixelPlus710G='1sJF5JNousgvpafKKUv-y_uOY4x8cwbF4'
export PixelPlus715G='1Ktv5s87fKgWS2TGVJ-fnwRU434qhbSj7'
export PixelPlus810G='1DDreVRyTM8qpHth4xge2nrj1sM1AFBWF'
export PixelPlus815G='1jA4MGBKDs7J2uyVZLj3wAy4eTnoAwUK4'


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

# build 710
lunch aosp_gts28wifi-userdebug &&
mka bacon -j$(nproc --all) | tee t710-log.txt &&

# Begin copy to shared and upload trlte
cd $t710  &&
ls -al &&
filename=$(basename PixelExperience*.zip)  &&
mv -v $BUILDd/t710-log.txt $shared710/$filename.log &&
mv -v $BUILDd/repo.log $shared710/$filename.repo.log &&
mv -v  $filename*  $shared710 &&
cd $shared710 &&
ls -al &&
gdrive upload --parent $PixelPlus710G $filename &

cd $BUILDd 

# build 715
lunch aosp_gts28ltexx-userdebug &&
mka bacon -j$(nproc --all) | tee t715-log.txt &&
cd $t715 &&
ls -al &&
filename=$(basename PixelExperience*.zip) &&
mv -v $BUILDd/t715-log.txt $shared715/$filename.log &&
mv -v $BUILDd/repo.log $shared715/$filename.repo.log &&
mv -v  $filename*  $shared715 &&
cd $shared715 &&
ls -al &&
gdrive upload --parent $PixelPlus715G $filename  &

cd $BUILDd

# build 810
lunch aosp_gts210wifi-userdebug &&
mka bacon -j$(nproc --all) | tee t810-log.txt &&
cd $t810 &&
ls -al &&
filename=$(basename PixelExperience*.zip)  &&
mv -v $BUILDd/t810-log.txt $shared810/$filename.log &&
mv -v $BUILDd/repo.log $shared810/$filename.repo.log &&
mv -v  $filename*  $shared810 &&
cd $shared810 &&
ls -al &&
gdrive upload --parent $PixelPlus810G $filename  &

cd $BUILDd

# build 815
lunch aosp_gts210ltexx-userdebug &&
mka bacon -j$(nproc --all) | tee t815-log.txt &&
cd $t815 &&
ls -al &&
filename=$(basename PixelExperience*.zip)  &&
mv -v $BUILDd/t815-log.txt $shared815/$filename.log &&
mv -v $BUILDd/repo.log $shared815/$filename.repo.log &&
mv -v  $filename*  $shared815 &&
cd $shared815 &&
ls -al &&
gdrive upload --parent $PixelPlus815G $filename  &

cd $BUILDd
ls -al

echo "Happy Flashing !!"
