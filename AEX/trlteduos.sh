#!/bin/bash

# Script to Build and Upload AEX TRLTEDUOS

# Set Build Parameters

# Server Specific compile settings

. ~/bin/compile.sh


# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
if 
        [ -f ../gdrive_aliases.sh ];
          then
            cp -v ../gdrive_aliases.sh ~/bin/ ;
            echo 'file copied '
          else
                echo 'file not found '
fi

. ~/bin/gdrive_aliases.sh

# Set build directory parameters
export BUILDd=~/android/9/AEX

# Set roomservice dir and create if necessary
export ROOMd=$BUILDd/.repo/local_manifests

if 
   [ ! -d $ROOMd ];
         then
    mkdir -pv $ROOMd ;
    exit ;
         else
    echo ' roomservice dir exists ' 
fi

# set web location of roomservice for device
export ROOMs=https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/master.xml

# set target build directories for copying files

export out_dir=$OUT_DIR_COMMON_BASE

# trlteduos out
export AEXtrlteduos=$out_dir/AEX/target/product/trlteduos
export kernelTD=$out_dir/AEX/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot

# pull ~/bin/compile.sh variable for system shared dir
export sharedTD=$shareD/AEX_trlteduos


if 
   [ ! -d $sharedTD ];
  then
	echo 'Shared Dir does not exist on this system ';
	mkdir -pv $shareTD ;
  else
    echo '$shareTD exists ' ;
fi


## build rom section

cd $BUILDd
echo make clean please wait
make clean

echo remove room service files
rm -v $ROOMd/*.xml
repo sync -qc -j16 --force-sync --no-clone-bundle --no-tags

# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
repo sync -qc -j16 --force-sync --no-clone-bundle --no-tags


# set environment for build 
. build/envsetup.sh

cd $BUILDd
# build trlteduos
lunch aosp_trlteduos-userdebug
#mka aex -j$(nproc --all) | tee trlteduos-log.txt
mka aex -j40 | tee trlteduos-log.txt


# Begin copy to shared and upload trlteduos
cd $AEXtrlteduos
ls -al
filename_duos=$(basename *-trlteduos*.zip)

cp -v $BUILDd/trlteduos-log.txt $sharedTD/$filename_duos.log
mv -v  $filename_duos*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename_duos.img
cd $sharedTD

ls -al
gdrive upload --parent $AEXtrlteduosG $filename_duos
gdrive upload --parent $AEXtrlteduosG $filename_duos.img
gdrive upload --parent $AEXtrlteduosG $filename_duos.md5sum
cd $BUILDd




exit

