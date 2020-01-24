# Script to Build and Upload AEX TRLTEDUOS
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
export BUILDd=~/android/9/AEX
export ROOMd=~/android/9/AEX/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
    exit ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE
export ROOMs=https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/trlteduos.xml

# trlteduos out
export AEXtrlteduos=$out_dir/AEX/target/product/trlteduos
export kernelTD=$out_dir/AEX/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export sharedTD='/home/shared/triplr/builds/AEX_trlteduos'

cd $BUILDd

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
~/bin/repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

cd $BUILDd
# build trlteduos
lunch aosp_trlteduos-userdebug
mka aex -j$(nproc --all) | tee trlteduos-log.txt

# Begin copy to shared and upload trlteduos
cd $AEXtrlteduos
ls -al
filename_duos=$(basename *trteduos*.zip)
mv -v $BUILDd/trlteduos-log.txt $sharedTD/$filename_duos.log
mv -v  $filename_duos*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename_duos.img
cd $sharedTD
ls -al
gdrive upload --parent $AEXtrlteduosG $filename_duos 
gdrive upload --parent $AEXtrlteduosG $filename_duos.img 
gdrive upload --parent $AEXtrlteduosG $filename_duos.md5sum 
cd $BUILDd
make clean

echo '$filename_duos  uploaded'

exit
