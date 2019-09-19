# Script to Build and Upload LOS16 TRLTE
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
if 
	[ -f ../gdrive_aliases.sh ];
	  then
	    cp -v ../gdrive_aliases.sh ~/bin/ ;  
      	    echo 'file copied '
	  else
		echo 'file not found '
fi

. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export BUILDd=~/android/LOS16
export ROOMd=~/android/LOS16/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE
export ROOMs=https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/master.xml

#trlte out
export LOS16trlte=$out_dir/LOS16/target/product/trlte
#                        /LOS16/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot
export kernelTR=$out_dir/LOS16/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot

# tblte out
export LOS16tblte=$out_dir/LOS16/target/product/tblte
export kernelTB=$out_dir/LOS16/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot

# trlteduos out
export LOS16trlteduos=$out_dir/LOS16/target/product/trlteduos
export kernelTD=$out_dir/LOS16/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/LOS16_trlte'
export sharedTB='/home/shared/triplr/builds/LOS16_tblte'
export sharedTD='/home/shared/triplr/builds/LOS16_trlteduos'

cd $BUILDd
#make clean

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/LOS16.xml $ROOMs
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

# build trlte
lunch aosp_trlte-userdebug
mka aex -j$(nproc --all) | tee trlte-log.txt

# build tblte
lunch aosp_tblte-userdebug
mka aex -j$(nproc --all) | tee tblte-log.txt

# build trlteduos
lunch aosp_trlteduos-userdebug
mka aex -j$(nproc --all) | tee trlteduos-log.txt

# Begin copy to shared and upload trlte
cd $LOS16trlte
ls -al
filename=$(basename Aosp*.zip) 
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename.log
mv -v $BUILDd/repo.log $sharedTR/$filename.repo.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
gdrive upload --parent $LOS16trlteG $filename 
gdrive upload --parent $LOS16trlteG $filename.img 
gdrive upload --parent $LOS16trlteG $filename.md5sum 
# Begin copy to shared and upload tblte
cd $LOS16tblte
ls -al
filename=$(basename Aosp*.zip)
mv -v $BUILDd/tblte-log.txt $sharedTB/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
gdrive upload --parent $LOS16tblteG $filename 
gdrive upload --parent $LOS16tblteG $filename.img 
gdrive upload --parent $LOS16tblteG $filename.md5sum 
# Begin copy to shared and upload trlteduos
cd $LOS16trlteduos
ls -al
filename=$(basename Aosp*.zip)
mv -v $BUILDd/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
gdrive upload --parent $LOS16trlteduosG $filename 
gdrive upload --parent $LOS16trlteduosG $filename.img 
gdrive upload --parent $LOS16trlteduosG $filename.md5sum 
cd $BUILDd
