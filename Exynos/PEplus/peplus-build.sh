# Script to Build and Upload PixelPlus Exynos 5433 
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
export BUILDd=~/android/9/PixelPlus
export ROOMd=~/android/9/PixelPlus/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE
#export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aex-pie/gts28wifi.xml

export ROOMs=https://raw.githubusercontent.com/tripLr/local_manifests/aex-9.x/Exynos/gts2.xml

# 710,715,810,815 out
# copy finished compiles to internal RAID storage on server

export shared710='/home/shared/triplr/builds/PixelPlus710'
export shared715='/home/shared/triplr/builds/PixelPlus715'
export shared810='/home/shared/triplr/builds/PixelPlus810'
export shared815='/home/shared/triplr/builds/PixelPlus815'

export t710=$out_dir/PixelPlus/target/product/gts28wifi
export t715=$out_dir/PixelPlus/target/product/gts28ltexx
export t810=$out_dir/PixelPlus/target/product/gts210wifi
export t815=$out_dir/PixelPlus/target/product/gts210ltexx

export t710k=$out_dir/PixelPlus/target/product/gts28wifi/obj/KERNEL_OBJ/arch/arm/boot
export t715k=$out_dir/PixelPlus/target/product/gts28ltexx/obj/KERNEL_OBJ/arch/arm/boot
export t810k=$out_dir/PixelPlus/target/product/gts210wifi/obj/KERNEL_OBJ/arch/arm/boot
export t815k=$out_dir/PixelPlus/target/product/gts210ltexx/obj/KERNEL_OBJ/arch/arm/boot

cd $BUILDd
make clean

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/PixelPlus.xml $ROOMs
repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

# build 710
lunch aosp_gts28wifi-userdebug
mka bacon -j$(nproc --all) | tee t710-log.txt

# build 715
lunch aosp_gts28ltexx-userdebug
mka bacon -j$(nproc --all) | tee t715-log.txt

# build 810
lunch aosp_gts210wifi-userdebug
mka bacon -j$(nproc --all) | tee t810-log.txt

# build 815
lunch aosp_gts210ltexx-userdebug
mka bacon -j$(nproc --all) | tee t815-log.txt

# Begin copy to shared and upload trlte
cd $t710
ls -al
filename=$(basename Aosp*.zip) 
mv -v $BUILDd/t710-log.txt $shared710/$filename.log
mv -v $BUILDd/repo.log $shared710/$filename.repo.log
mv -v  $710k/Image $shared710
mv -v  $filename*  $shared710
cd $shared710
ls -al
gdrive upload --parent $PixelPlus710G $filename 

cd $t715
ls -al
filename=$(basename Aosp*.zip) 
mv -v $BUILDd/t715-log.txt $shared715/$filename.log
mv -v $BUILDd/repo.log $shared715/$filename.repo.log
mv -v  $715k/Image $shared715
mv -v  $filename*  $shared715
cd $shared715
ls -al
gdrive upload --parent $PixelPlus715G $filename 

cd $t810
ls -al
filename=$(basename Aosp*.zip) 
mv -v $BUILDd/t810-log.txt $shared810/$filename.log
mv -v $BUILDd/repo.log $shared810/$filename.repo.log
mv -v  $810k/Image $shared810
mv -v  $filename*  $shared810
cd $shared810
ls -al
gdrive upload --parent $PixelPlus810G $filename 

cd $t815
ls -al
filename=$(basename Aosp*.zip) 
mv -v $BUILDd/t815-log.txt $shared815/$filename.log
mv -v $BUILDd/repo.log $shared815/$filename.repo.log
mv -v  $815k/Image $shared815
mv -v  $filename*  $shared815
cd $shared815
ls -al
gdrive upload --parent $PixelPlus815G $filename && cd $BUILDd && make clean

echo "Happy Flashing !!"
