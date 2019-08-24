# Script to Build and Upload AOSP TRLTE
# note need kernel source to include in build to build correctly for pure aosp
# see inkypens notes


# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export BUILDd=~/android/AOSP
export ROOMd=$BUILDd/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE

#trlte out
export AOSPtrlte="$out_dir/AOSP/target/product/trlte"
export kernelTR="$out_dir/AOSP/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot"

# tblte out
export AOSPtblte="$out_dir/AOSP/target/product/tblte"
export kernelTB="$out_dir/AOSP/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# trlteduos out
export AOSPtrlteduos="$out_dir/AOSP/target/product/trlteduos"
export kernelTD="$out_dir/AOSP/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot"

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/AOSP_trlte'
export sharedTB='/home/shared/triplr/builds/AOSP_tblte'
export sharedTD='/home/shared/triplr/builds/AOSP_trlteduos'

# remove room service files and clean
cd $BUILDd
make clean && make clobber
rm -v $ROOMd/*.xml
repo sync -c --force-sync --no-clone-bundle --no-tags

# install from web roomservice
wget -O $ROOMd/AOSP.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aosp-pie/master.xml
repo sync -c --force-sync --no-clone-bundle --no-tags

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
cd $AOSPtrlte
ls -al
filename=$(basename AOSPExperience*.zip) 
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
gdrive upload --parent $AOSPtrlteG $filename 
gdrive upload --parent $AOSPtrlteG $filename.img 
gdrive upload --parent $AOSPtrlteG $filename.md5sum 
# Begin copy to shared and upload tblte
cd $AOSPtblte
ls -al
filename=$(basename AOSPExperience*.zip) 
mv -v $BUILDd/tblte-log.txt $sharedTB/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
gdrive upload --parent $AOSPtblteG $filename 
gdrive upload --parent $AOSPtblteG $filename.img 
gdrive upload --parent $AOSPtblteG $filename.md5sum 
# Begin copy to shared and upload trlteduos
cd $AOSPtrlteduos
ls -al
filename=$(basename AOSPExperience*.zip) 
mv -v $BUILDd/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
gdrive upload --parent $AOSPtrlteduosG $filename 
gdrive upload --parent $AOSPtrlteduosG $filename.img 
gdrive upload --parent $AOSPtrlteduosG $filename.md5sum 
cd $AOSPb
