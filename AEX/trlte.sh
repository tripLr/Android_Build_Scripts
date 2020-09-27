#!/bin/bash

# Script to Build and Upload AEX TRLTE

# Set Build Parameters

# Server Specific compile settings

. ~/bin/compile.sh

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

#trlte out
export AEXtrlte=$out_dir/AEX/target/product/trlte
export kernelTR=$out_dir/AEX/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot


# pull ~/bin/compile.sh variable for system shared dir
export sharedTR=$shareD/AEX_trlte
if 
   [ ! -d $sharedTR ];
  then
	echo 'Shared Dir does not exist on this system ';
	echo 'run command mkdir -pv $ROOMd ';
        exit ;   
  else
    echo '$sharedTR exists ' ;
fi

# test share section
###

## build rom section

cd $BUILDd

if 
	[ $1='clean' ]
then 	
	echo 'make clean in progress, please wait' ;
	make clean;
else	echo 'skipping make clean'
fi



# remove room service files
rm -v $ROOMd/*.xml

# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
repo sync -qc -j16 --force-sync --no-clone-bundle --no-tags

# set environment for build 
. build/envsetup.sh

# build trlte
lunch aosp_trlte-userdebug
mka aex -j$(nproc --all) | tee trlte-log.txt
# Begin copy to shared and upload trlte
cd $AEXtrlte
ls -al

filename_trlte=$(basename *-trlte*.zip)
echo $filename_trlte
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename_trlte.log
mv -v $BUILDd/repo.log $sharedTR/$filename_trlte.repo.log
mv -v  $filename_trlte*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename_trlte.img
cd $sharedTR
ls -al
gdrive upload --parent $AEXtrlteG $filename_trlte 
gdrive upload --parent $AEXtrlteG $filename_trlte.img
gdrive upload --parent $AEXtrlteG $filename_trlte.md5sum

exit

