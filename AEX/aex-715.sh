# Script to Build and Upload AEX gts28ltexx 715
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

. ~/bin/gdrive_aliases.sh
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
export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aex-pie/gts28ltexx.xml

# 710,715,810,815 out
# copy finished compiles to internal RAID storage on server

export shared715='/home/shared/triplr/builds/AEX715'

export t715=$out_dir/AEX/target/product/gts28ltexx


cd $BUILDd
make clean

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

# build 715
lunch aosp_gts28ltexx-userdebug
mka aex -j$(nproc --all) | tee t715-log.txt

# Begin copy to shared and upload trlte
cd $t715
ls -al
filename715=$(basename *gts28ltexx*.zip) 
mv -v $BUILDd/t715-log.txt $shared715/$filename715.log
mv -v $BUILDd/repo.log $shared715/$filename715.repo.log
mv -v  $filename715*  $shared715
cd $shared715
ls -al
gdrive upload --parent $AEX715G $filename715 
cd $BUILDd
echo "build and upload complete"


