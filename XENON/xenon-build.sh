# Scrpt to Buld and Upload XENONHD TRLTE
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

export out_dir=$OUT_DIR_COMMON_BASE

# Set build and directory parameters
export BUILDd=~/android/XENONHD
export ROOMd=~/android/XENONHD/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
         then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

cd $BUILDd

#trlte out
export XENONHDtrlte="$out_dir/XENONHD/target/product/trlte"
export kernelTR="$out_dir/XENONHD/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot"

# tblte out
export XENONHDtblte="$out_dir/XENONHD/target/product/tblte"
export kernelTB="$out_dir/XENONHD/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# trlteduos out
export XENONHDtrlteduos="$out_dir/XENONHD/target/product/trlteduos"
export kernelTD="$out_dir/XENONHD/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot"

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/XENONHD_trlte'
export sharedTB='/home/shared/triplr/builds/XENONHD_tblte'
export sharedTD='/home/shared/triplr/builds/XENONHD_trlteduos'
export ROOMs=https://raw.githubusercontent.com/triplr-dev/local_manifests/xenonhd-p/master.xml
export REPOd='repo init -u https://github.com/TeamHorizon/platform_manifest.git -b p'

# remove room service files
rm -v $ROOMd/*.xml

# make clean 
cd $BUILDd
make clean

# install from web roomservice
wget -O $ROOMd/XenonHD.xml $ROOMs
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# set environment for build 
. build/envsetup.sh

# build trlte
breakfast trlte 
brunch trlte | tee trlte-log.txt 

# build tblte
breakfast tblte 
brunch tblte | tee tblte-log.txt 

# build trlteduos
breakfast trlteduos 
brunch trlteduos | tee trlteduos-log.txt 

# Begin copy to shared and upload trlte
cd $XENONHDtrlte
ls -al
filename=$(basename X*.zip) 
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtrlteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtrlteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtrlteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtrlteG $filename.log && s=0 && break || s=$?; done; (exit $s)
# Begin copy to shared and upload tblte
cd $XENONHDtblte
ls -al
filename=$(basename X*.zip) 
mv -v $BUILDd/tblte-log.txt $sharedTB/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtblteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtblteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtblteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtblteG $filename.log && s=0 && break || s=$?; done; (exit $s)
# Begin copy to shared and upload trlteduos
cd $XENONHDtrlteduos
ls -al
filename=$(basename X*.zip) 
mv -v $BUILDd/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtrlteduosG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtrlteduosG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtrlteduosG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $XENONHDtrlteduosG $filename.log  && s=0 && break || s=$?; done; (exit $s)
cd $XENONHDb
