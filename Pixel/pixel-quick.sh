# Scrpt to Buld and Upload Pixel TRLTE
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export BUILDd=~/android/Pixel
export ROOMd=~/android/Pixel/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE

#trlte out
export Pixeltrlte="$out_dir/Pixel/target/product/trlte"
export kernelTR="$out_dir/Pixel/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot"

# tblte out
export Pixeltblte="$out_dir/Pixel/target/product/tblte"
export kernelTB="$out_dir/Pixel/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# trlteduos out
export Pixeltrlteduos="$out_dir/Pixel/target/product/trlteduos"
export kernelTD="$out_dir/Pixel/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot"

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/Pixel_trlte'
export sharedTB='/home/shared/triplr/builds/Pixel_tblte'
export sharedTD='/home/shared/triplr/builds/Pixel_trlteduos'

# make clean 
cd $BUILDd
# remove room service files
rm $ROOMd/*.xml 
# install from web roomservice
wget -O $ROOMd/Pixel.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aosp-pie/master.xml
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# set environment for build 
. build/envsetup.sh

# build trlte
lunch aosp_trlte-userdebug
mka bacon -j$(nproc --all) | tee trlte-log.txt

# build tblte
lunch aosp_tblte-userdebug
mka bacon -j$(nproc --all) | tee tblte-log.txt

# build trlteduos
lunch aosp_trlteduos-userdebug
mka bacon -j$(nproc --all) | tee trlteduos-log.txt

# Begin copy to shared and upload trlte
cd $Pixeltrlte
ls -al
filename=$(basename PixelExperience*.zip) 
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
gdrive upload --parent $PixeltrlteG $filename 
gdrive upload --parent $PixeltrlteG $filename.img 
gdrive upload --parent $PixeltrlteG $filename.md5sum 
# Begin copy to shared and upload tblte
cd $Pixeltblte
ls -al
filename=$(basename PixelExperience*.zip) 
mv -v $BUILDd/tblte-log.txt $sharedTB/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
gdrive upload --parent $PixeltblteG $filename 
gdrive upload --parent $PixeltblteG $filename.img 
gdrive upload --parent $PixeltblteG $filename.md5sum 
# Begin copy to shared and upload trlteduos
cd $Pixeltrlteduos
ls -al
filename=$(basename PixelExperience*.zip) 
mv -v $BUILDd/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
gdrive upload --parent $PixeltrlteduosG $filename 
gdrive upload --parent $PixeltrlteduosG $filename.img 
gdrive upload --parent $PixeltrlteduosG $filename.md5sum 
cd $Pixelb
