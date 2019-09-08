# Scrpt to Buld and Upload PixelPlus TRLTE
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
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
export BUILDd=~/android/PixelPlus
export ROOMd=~/android/PixelPlus/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE

#trlte out
export PixelPlustrlte="$out_dir/PixelPlus/target/product/trlte"
export kernelTR="$out_dir/PixelPlus/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot"

# tblte out
export PixelPlustblte="$out_dir/PixelPlus/target/product/tblte"
export kernelTB="$out_dir/PixelPlus/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# trlteduos out
export PixelPlustrlteduos="$out_dir/PixelPlus/target/product/trlteduos"
export kernelTD="$out_dir/PixelPlus/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot"

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/PixelPlus_trlte'
export sharedTB='/home/shared/triplr/builds/PixelPlus_tblte'
export sharedTD='/home/shared/triplr/builds/PixelPlus_trlteduos'

# make clean 
cd $BUILDd
make clean
# remove room service files
rm -v $ROOMd/*.xml

# install from web roomservice
wget -O $ROOMd/PixelPlus.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aosp-pie/master.xml
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags | tee repo.log

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
cd $PixelPlustrlte
ls -al
filename=$(basename PixelExperience*.zip) 
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename.log
mv -v $BUILDd/repo.log $sharedTR/$filename.repo.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
gdrive upload --parent $PixelPlustrlteG $filename 
gdrive upload --parent $PixelPlustrlteG $filename.img 
gdrive upload --parent $PixelPlustrlteG $filename.md5sum 
# Begin copy to shared and upload tblte
cd $PixelPlustblte
ls -al
filename=$(basename PixelExperience*.zip) 
mv -v $BUILDd/tblte-log.txt $sharedTB/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
gdrive upload --parent $PixelPlustblteG $filename 
gdrive upload --parent $PixelPlustblteG $filename.img 
gdrive upload --parent $PixelPlustblteG $filename.md5sum 
# Begin copy to shared and upload trlteduos
cd $PixelPlustrlteduos
ls -al
filename=$(basename PixelExperience*.zip) 
mv -v $BUILDd/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
gdrive upload --parent $PixelPlustrlteduosG $filename 
gdrive upload --parent $PixelPlustrlteduosG $filename.img 
gdrive upload --parent $PixelPlustrlteduosG $filename.md5sum 
cd $PixelPlusb
