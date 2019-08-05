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
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ; 
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE

#roomservices
export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aokp-oreo/gts210wifi.xml

# 810 out  gts210wifi
export AOKP810b=$out_dir/AOKP_oreo/target/product/gts210wifi
export kernel810b=$out_dir/AOKP_oreo/target/product/gts220wifi/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export shared810='/home/shared/triplr/builds/gts2/810'

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

# build gts210wifi T-810 
lunch aokp_gts210wifi-userdebug
mka rainbowfarts -j$(nproc --all) | tee gts210wifi-log.txt

# Begin copy to shared and upload T810 
cd $AOKP810b
ls -al
filename=$(basename aokp_gts*.zip)
mv -v ~/android/AOKP_oreo/gts210wifi-log.txt $shared810/$filename.log
mv -v  $filename*  $shared810
mv -v $kernel810b/Image $shared810/$filename.img
cd $shared810
ls -al
gdrive upload --parent $AOKP810 $filename 
gdrive upload --parent $AOKP810 $filename.img 
gdrive upload --parent $AOKP810 $filename.md5sum 
gdrive upload --parent $AOKP810 $filename.log 

cd $BUILDd
