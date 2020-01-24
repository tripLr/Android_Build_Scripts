# Script to Build and Upload AEX gts210wifi smt-810 
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
export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aex-pie/gts210wifi.xml

# 710,715,810,815 out
# copy finished compiles to internal RAID storage on server

export shared810='/home/shared/triplr/builds/AEX810'

export t810=$out_dir/AEX/target/product/gts210wifi

cd $BUILDd

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

# build 810
lunch aosp_gts210wifi-userdebug
mka aex -j$(nproc --all) | tee t810-log.txt

# build 810 
# Begin copy to shared and upload trlte
cd $t810
ls -al
filename810=$(basename *gts210wifi*.zip) 
mv -v $BUILDd/t810-log.txt $shared810/$filename810.log
mv -v $BUILDd/repo.log $shared810/$filename810.repo.log
mv -v  $filename810*  $shared810
cd $shared810
ls -al
gdrive upload --parent $AEX810G $filename810 
cd $BUILDd

