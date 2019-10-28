# Script to Build and Upload AEX TRLTE
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

export shared710='/home/shared/triplr/builds/AEX710'
export shared715='/home/shared/triplr/builds/AEX715'
export shared810='/home/shared/triplr/builds/AEX810'
export shared815='/home/shared/triplr/builds/AEX815'

export t710=$out_dir/AEX/target/product/gts28wifi
export t715=$out_dir/AEX/target/product/gts28ltexx
export t810=$out_dir/AEX/target/product/gts210wifi
export t815=$out_dir/AEX/target/product/gts210ltexx


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
filename=$(basename Aosp*.zip) 
mv -v $BUILDd/715-log.txt $shared715/$filename.log
mv -v $BUILDd/repo.log $shared715/$filename.repo.log
mv -v  $filename*  $shared715
cd $shared715
ls -al
gdrive upload --parent $AEX715G $filename && cd $BUILDd && make clean



