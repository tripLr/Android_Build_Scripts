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
export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aokp-oreo/gts210ltexx.xml

# 815 out gts210ltexx
export AOKP815b=$out_dir/AOKP_oreo/target/product/gts210ltexx
export kernel815b=$out_dir/AOKP_oreo/target/product/gts210ltexx/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export shared815='/home/shared/triplr/builds/gts2/815'

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

# build gts210ltexx T815
lunch aokp_gts210ltexx-userdebug
mka rainbowfarts -j$(nproc --all) | tee gts210ltexx-log.txt

# Begin copy to shared and upload T815 
cd $AOKP815b
ls -al
filename=$(basename aokp_gts*.zip)
mv -v ~/android/AOKP_oreo/gts210ltexx-log.txt $shared815/$filename.log
mv -v  $filename*  $shared815
mv -v $kernel815b/Image $shared815/$filename.img
cd $shared815
ls -al
gdrive upload --parent $AOKP815 $filename 
gdrive upload --parent $AOKP815 $filename.img 
gdrive upload --parent $AOKP815 $filename.md5sum 
gdrive upload --parent $AOKP815 $filename.log 

cd $BUILDd
