# Scrip to Build and Upload AOKP Exynos5433
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh
# Set build and directory parameters
export BUILDd=~/android/AOKP_oreo/
export ROOMd=~/android/AOKP_oreo/.repo/local_manifests
cd $BUILDd
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ; 
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE
#roomservices
# @inkypen # github.com/exynos5433
export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aokp-oreo/gts28wifi.xml

#710 out gts28wifi
export AOKP710b=$out_dir/AOKP_oreo/target/product/gts28wifi
export kernel710b=$out_dir/AOKP_oreo/target/product/gts28wifi/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export shared710='/home/shared/triplr/builds/gts2/710'

# remove room service files
rm -v $ROOMd/*.xml
REPO

# make clean 
cd $BUILDd
make clean

# build all
wget -O $ROOMd/AOKP_oreo.xml $ROOMs	 
REPO
. build/envsetup.sh

lunch aokp_gts28wifi-userdebug
mka rainbowfarts -j$(nproc --all) | tee gts28wifi-log.txt

 Begin copy to shared and upload T710 
cd $AOKP710b
ls -al
filename=$(basename aokp_gts*.zip) 
mv -v ~/android/AOKP_oreo/gts28wifi-log.txt $shared710/$filename.log
mv -v  $filename*  $shared710
mv -v $kernel710b/Image $shared710/$filename.img
cd $shared710
ls -al
gdrive upload --parent $AOKP710 $filename  
gdrive upload --parent $AOKP710 $filename.img  
gdrive upload --parent $AOKP710 $filename.md5sum  
gdrive upload --parent $AOKP710 $filename.log 
cd $BUILDd
