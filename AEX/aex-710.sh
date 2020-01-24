# Script to Build and Upload AEX gts28wifi smt-710
# Set Global Parameters
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

. gdrive_aliases.sh
. ../../repo-update.sh

# Set build and directory parameters
export BUILDd=~/android/9/AEX
export ROOMd=~/android/9/AEX/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE
export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aex-pie/gts28wifi.xml

# 710,715,810,815 out
# copy finished compiles to internal RAID storage on server

export shared710='/home/shared/triplr/builds/AEX710'
export t710=$out_dir/AEX/target/product/gts28wifi
cd $BUILDd
make clean

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo.log

# set environment for build 
. build/envsetup.sh

# build 710
lunch aosp_gts28wifi-userdebug
mka aex -j$(nproc --all) | tee t710-log.txt

# Begin copy to shared and upload gts28wifi 
cd $t710
ls -al
filename710=$(basename *gts28wifi*.zip) 
mv -v $BUILDd/t710-log.txt $shared710/$filename.log
mv -v $BUILDd/repo.log $shared710/$filename.repo.log
mv -v  $filename710*  $shared710
cd $shared710
ls -al
gdrive upload --parent $AEX710G $filename710 
cd $BUILDd

echo "compile and upload complete"
