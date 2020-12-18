#!/bin/bash
# Script to Build and Upload AEX Pixel2
# Set Build Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
if 
	[ -f ../../gdrive_aliases.sh ];
	  then
	    cp -v ../../gdrive_aliases.sh ~/bin/ ;  
      	    echo 'file copied '
	  else
		echo 'file not found '
fi

. ~/bin/gdrive_aliases.sh
. ~/bin/repo-update.sh

# Set build and directory parameters
export BUILDd=~/android/AEX-11.x
export ROOMd=~/android/AEX-11.x/.repo/local_manifests
export shareD=/home/shared/triplr/
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE
export ROOMs=https://raw.githubusercontent.com/tripLr/manifests/11.x/pixel2/pixel2-aex.xml
# 710,715,810,815 out
# copy finished compiles to internal RAID storage on server

export sharedP2=$shareD/AEX-walleye
export sharedP2XL=$shareD/AEX-taimen

export tP2=$out_dir/AEX/target/product/walleye
export tP2XL=$out_dir/AEX/target/product/taimen

export tP2=$tP2/obj/KERNEL_OBJ/arch/arm/boot
export tP2XL=$tP2XL/obj/KERNEL_OBJ/arch/arm/boot

cd $BUILDd
make clean

# remove room service files
rm -v $ROOMd/*.xml
repo sync -c -j32 --force-sync --no-clone-bundle --no-tags 
# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo-tabs2.log

# set environment for build 
. build/envsetup.sh

# build 710
lunch aosp_gts28wifi-userdebug
mka aex -j$(nproc --all) | tee t710-log.txt

# Begin copy to shared and upload trlte
cd $t710
ls -al
filename710=$(basename *gts28wifi*.zip)
cp -v $BUILDd/t710-log.txt $shared710/$filename710.log
cp -v $BUILDd/repo-tabs2.log $shared710/$filename710.repo.log
mv -v  $t710k/Image $shared710/$filename710.img
mv -v  $filename710*  $shared710
cd $shared710
ls -al
gdrive upload --parent $AEX710G $filename710
gdrive upload --parent $AEX710G $filename710.img
gdrive upload --parent $AEX710G $filename710.md5sum
cd $BUILDd

# build 715
lunch aosp_gts28ltexx-userdebug
mka aex -j$(nproc --all) | tee t715-log.txt
cd $t715
ls -al
filename715=$(basename *gts28ltexx*.zip) 
cp -v $BUILDd/t715-log.txt $shared715/$filename715.log
cp -v $BUILDd/repo-tabs2.log $shared715/$filename715.repo.log
mv -v  $t715k/Image $shared715/$filename715.img
mv -v  $filename715*  $shared715
cd $shared715
ls -al
gdrive upload --parent $AEX715G $filename715
cd $BUILDd
#

# build 810
lunch aosp_gts210wifi-userdebug
mka aex -j$(nproc --all) | tee t810-log.txt
cd $t810
ls -al
filename810=$(basename *gts210wifi*.zip) 
cp -v $BUILDd/t810-log.txt $shared810/$filename810.log
cp -v $BUILDd/repo-tabs2.log $shared810/$filename810.repo.log
mv -v  $t810k/Image $shared810/$filename810.img
mv -v  $filename810*  $shared810
cd $shared810
ls -al
gdrive upload --parent $AEX810G $filename810
gdrive upload --parent $AEX810G $filename810.img
gdrive upload --parent $AEX810G $filename810.md5sum
cd $BUILDd
#

# build 815
lunch aosp_gts210ltexx-userdebug
mka aex -j$(nproc --all) | tee t815-log.txt

cd $t815
ls -al
filename815=$(basename *gts210ltexx*.zip) 
cp -v $BUILDd/t815-log.txt $shared815/$filename.log
cp -v $BUILDd/repo-tabs2.log $shared815/$filename.repo.log
mv -v  $t815k/Image $shared815/$filename815.img
mv -v  $filename815*  $shared815
cd $shared815
ls -al
gdrive upload --parent $AEX815G $filename815
gdrive upload --parent $AEX815G $filename815.img
gdrive upload --parent $AEX815G $filename815.md5sum
cd $BUILDd

ls -al
echo 'enjoy aex for Exynos tab s2'
