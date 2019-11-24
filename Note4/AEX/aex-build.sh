# Script to Build and Upload AEX TRLTE
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
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE
export ROOMs=https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/master.xml

#trlte out
export AEXtrlte=$out_dir/AEX/target/product/trlte
#                        /AEX/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot
export kernelTR=$out_dir/AEX/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot

# tblte out
export AEXtblte=$out_dir/AEX/target/product/tblte
export kernelTB=$out_dir/AEX/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot

# trlteduos out
export AEXtrlteduos=$out_dir/AEX/target/product/trlteduos
export kernelTD=$out_dir/AEX/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/AEX_trlte'
export sharedTB='/home/shared/triplr/builds/AEX_tblte'
export sharedTD='/home/shared/triplr/builds/AEX_trlteduos'

cd $BUILDd
# make clean &

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
~/bin/repo sync -c -j4 --force-sync --no-clone-bundle --no-tags | tee repo.log


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
cd $AEXtrlte
ls -al
filename=$(basename Aosp*.zip) 
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename.log
mv -v $BUILDd/repo.log $sharedTR/$filename.repo.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
gdrive upload --parent $AEXtrlteG $filename && 
gdrive upload --parent $AEXtrlteG $filename.img && 
gdrive upload --parent $AEXtrlteG $filename.md5sum  
# Begin copy to shared and upload tblte
cd $AEXtblte
ls -al
filename=$(basename Aosp*.zip)
mv -v $BUILDd/tblte-log.txt $sharedTB/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
gdrive upload --parent $AEXtblteG $filename &&
gdrive upload --parent $AEXtblteG $filename.img &&
gdrive upload --parent $AEXtblteG $filename.md5sum 
# Begin copy to shared and upload trlteduos
cd $AEXtrlteduos
ls -al
filename=$(basename Aosp*.zip)
mv -v $BUILDd/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
gdrive upload --parent $AEXtrlteduosG $filename 
gdrive upload --parent $AEXtrlteduosG $filename.img 
gdrive upload --parent $AEXtrlteduosG $filename.md5sum 
cd $BUILDd
make clean &
