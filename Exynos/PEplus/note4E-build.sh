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
#  treltexx   	910C
#  trelteskt  	910S
#  trhpltexx  	910U
#  tre3calteskt 916S
#  tbelteskt  	915S

export shared910C='/home/shared/triplr/builds/PixelPlus910C'
export shared910S='/home/shared/triplr/builds/PixelPlus910S'
export shared910U='/home/shared/triplr/builds/PixelPlus910U'
export shared916S='/home/shared/triplr/builds/PixelPlus916S'
export shared915S='/home/shared/triplr/builds/PixelPlus915S'

# N910C,715,810,815 out dir's
export 910C=$out_dir/PixelPlus/target/product/gts210ltexx

#export N910C=$out_dir/PixelPlus/target/product/gts28wifi

#export t715=$out_dir/PixelPlus/target/product/gts28ltexx
#export t810=$out_dir/PixelPlus/target/product/gts210wifi



# google drive folders
export PixelPlusN910Cg='1Hz3126Gd4N_-JRI3OB3DWPV-3qJc-cOA'
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

# build N910C
# build treltexx
lunch aosp_trltexx-userdebug
mka bacon -j$(nproc --all) | tee treltexx-log.txt

cd $910C &&
ls -al &&
filename=$(basename *trltexx*.zip)  &&
mv -v $BUILDd/trltexx-log.txt $shared910C/$filename.log &&
mv -v  $filename*  $shared910C &&
cd $shared910C &&
ls -al &&
gdrive upload --parent $PixelPlus910Cg $filename  &

cd $BUILDd


# build treltexx
lunch aosp_trltexx-userdebug
mka bacon -j$(nproc --all) | tee treltexx-log.txt


cd $BUILDd

# build trelteskt
lunch aosp_trelteskt-userdebug
mka bacon -j$(nproc --all) | tee trelteskt-log.txt


cd $BUILDd

# build trhpltexx
lunch aosp_tphltexx-userdebug
mka bacon -j$(nproc --all) | tee tphltexx-log.txt


cd $BUILDd

# build tre3calteskt
lunch aosp_tre3calteskt-userdebug
mka bacon -j$(nproc --all) | tee tre3calteskt-log.txt


cd $BUILDd

# build tbelteskt
lunch aosp_tbelteskt-userdebug
mka bacon -j$(nproc --all) | tee tbeltekkt-log.txt


cd $BUILDd 
# && make clean











echo "Happy Flashing !!"
