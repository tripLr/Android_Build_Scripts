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
i
#roomservices
# @inkypen # github.com/exynos5433
export ROOMs=https://raw.githubusercontent.com/Exynos5433/local_manifests/aokp-oreo/gts28ltexx.xml

# 715 out gts28ltexx
export AOKP715b=$out_dir/AOKP_oreo/target/product/gts28ltexx
export kernel715b=$out_dir/AOKP_oreo/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export shared715='/home/shared/triplr/builds/gts2/715'

# remove room service files and reset repo
rm -v $ROOMd/*.xml
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# make clean 
cd $BUILDd
make clean

wget -O $ROOMd/AOKP_oreo.xml $ROOMs	 
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

#set build environment
. build/envsetup.sh

# build gts28ltexx T715
lunch aokp_gts28ltexx-userdebug
mka rainbowfarts -j$(nproc --all) | tee gts28ltexx-log.txt

# Begin copy to shared and upload 
cd $AOKP715b
ls -al
filename=$(basename aokp_gts*.zip)
mv -v ~/android/AOKP_oreo/gts28ltexx-log.txt $shared715/$filename.log
mv -v  $filename*  $shared715
mv -v $kernel715b/Image $shared715/$filename.img
cd $shared715
ls -al
gdrive upload --parent $AOKP715 $filename 
gdrive upload --parent $AOKP715 $filename.img  
gdrive upload --parent $AOKP715 $filename.md5sum 
gdrive upload --parent $AOKP715 $filename.log

cd $BUILDd
