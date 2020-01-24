# Script to Build and Upload AEX gts210ltexx.xml smt-815 
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
export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aex-pie/gts210ltexx.xml

# 710,715,810,815 out
# copy finished compiles to internal RAID storage on server

export shared815='/home/shared/triplr/builds/AEX815'

export t815=$out_dir/AEX/target/product/gts210ltexx


cd $BUILDd

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

# build 815
lunch aosp_gts210wifi-userdebug
mka aex -j$(nproc --all) | tee t815-log.txt

# Begin copy to shared and upload gts210ltexx
cd $t815
ls -al
filename815=$(basename *gts210ltexx*.zip) 
mv -v $BUILDd/710-log.txt $shared815/$filename815.log
mv -v $BUILDd/repo.log $shared815/$filename815.repo.log
mv -v  $filename815*  $shared815
cd $shared815
ls -al
gdrive upload --parent $AEX815G $filename815 
# Begin copy to shared and upload tblte
cd $AEXtblte
ls -al
cd $BUILDd
