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
#export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aex-pie/gts28wifi.xml
export ROOMs=https://raw.githubusercontent.com/tripLr/local_manifests-1/aex-pie/exynos5433-master.xml
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

export t710k=$out_dir/AEX/target/product/gts28wifi/obj/KERNEL_OBJ/arch/arm/boot
export t715k=$out_dir/AEX/target/product/gts28ltexx/obj/KERNEL_OBJ/arch/arm/boot
export t810k=$out_dir/AEX/target/product/gts210wifi/obj/KERNEL_OBJ/arch/arm/boot
export t815k=$out_dir/AEX/target/product/gts210ltexx/obj/KERNEL_OBJ/arch/arm/boot

cd $BUILDd
# make clean

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
# Begin copy to shared and upload trlte
cd $t710
ls -al
filename710=$(basename Aosp*.zip)
cp -v $BUILDd/t710-log.txt $shared710/$filename710.log
cp -v $BUILDd/repo.log $shared710/$filename710.repo.log
cp -v  $710k/Image $shared710
cp -v  $filename710*  $shared710
cd $shared710
ls -al
gdrive upload --parent $AEX710G $filename710 &
cd $BUILDd
#
# build 715
lunch aosp_gts28ltexx-userdebug
mka aex -j$(nproc --all) | tee t715-log.txt
cd $t715
ls -al
filename715=$(basename Aosp*.zip) 
cp -v $BUILDd/t715-log.txt $shared715/$filename715.log
cp -v $BUILDd/repo.log $shared715/$filename715.repo.log
cp -v  $715k/Image $shared715
cp -v  $filename715*  $shared715
cd $shared715
ls -al
gdrive upload --parent $AEX715G $filename715 &
cd $BUILDd
#

# build 810
lunch aosp_gts210wifi-userdebug
mka aex -j$(nproc --all) | tee t810-log.txt
cd $t810
ls -al
filename810=$(basename Aosp*.zip) 
cp -v $BUILDd/t810-log.txt $shared810/$filename810.log
cp -v $BUILDd/repo.log $shared810/$filename810.repo.log
cp -v  $810k/Image $shared810
cp -v  $filename810*  $shared810
cd $shared810
ls -al
gdrive upload --parent $AEX810G $filename810 &
cd $BUILDd
#

# build 815
lunch aosp_gts210ltexx-userdebug
mka aex -j$(nproc --all) | tee t815-log.txt

cd $t815
ls -al
filename=$(basename Aosp*.zip) 
cp -v $BUILDd/t815-log.txt $shared815/$filename.log
cp -v $BUILDd/repo.log $shared815/$filename.repo.log
cp -v  $815k/Image $shared815
cp -v  $filename*  $shared815
cd $shared815
ls -al
gdrive upload --parent $AEX815G $filename &
cd $BUILDd

# build note 4 exynos
lunch aosp_treltexx-userdebug
mka aex -j$(nproc --all) | tee treltexx.log.txt
#
lunch aosp_trelteskt-userdebug 
mka aex -j$(nproc --all) | tee trelteskt.log.txt
#
lunch aosp_trhpltexx-userdebug
mka aex -j$(nproc --all) | tee trhpltexx.log.txt
#
lunch aosp_tre3calteskt-userdebug
mka aex -j$(nproc --all) | tee tre3calteskt.log.txt
#
lunch aosp_tbelteskt-userdebug
mka aex -j$(nproc --all) | tee tbelteskt.log.txt


cd $BUILDd
ls -al
#make clean
echo 'enjoy aex for Exynos tab s2'
