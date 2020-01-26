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
    exit ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE
export ROOMs=https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/master.xml

#trlte out
export AEXtrlte=$out_dir/AEX/target/product/trlte
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
~/bin/repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh

# build trlte
lunch aosp_trlte-userdebug
mka aex -j$(nproc --all) | tee trlte-log.txt
# Begin copy to shared and upload trlte
cd $AEXtrlte
ls -al
filename_trlte=$(basename *trlte*.zip) 
cp -v $BUILDd/trlte-log.txt $sharedTR/$filename_trlte.log
mv -v $BUILDd/repo.log $sharedTR/$filename_trlte.repo.log
mv -v  $filename_trlte*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename_trlte.img
cd $sharedTR
ls -al
gdrive upload --parent $AEXtrlteG $filename_trlte & 
gdrive upload --parent $AEXtrlteG $filename_trlte.img   
gdrive upload --parent $AEXtrlteG $filename_trlte.md5sum  


cd $BUILDd
# build tblte
lunch aosp_tblte-userdebug
mka aex -j$(nproc --all) | tee tblte-log.txt

cd $AEXtblte
ls -al
filename_tblte=$(basename Aosp*.zip)
cp -v $BUILDd/tblte-log.txt $sharedTB/$filename_tblte.log
mv -v  $filename_tblte*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename_tblte.img
cd $sharedTB
ls -al
gdrive upload --parent $AEXtblteG $filename_tblte &&
gdrive upload --parent $AEXtblteG $filename_tblte.img &&
gdrive upload --parent $AEXtblteG $filename_tblte.md5sum 

cd $BUILDd
# build trlteduos
lunch aosp_trlteduos-userdebug
mka aex -j$(nproc --all) | tee trlteduos-log.txt

# Begin copy to shared and upload trlteduos
cd $AEXtrlteduos
ls -al
filename_duos=$(basename Aosp*.zip)
cp -v $BUILDd/trlteduos-log.txt $sharedTD/$filename_duos.log
mv -v  $filename_duos*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename_duos.img
cd $sharedTD
ls -al
gdrive upload --parent $AEXtrlteduosG $filename_duos 
gdrive upload --parent $AEXtrlteduosG $filename_duos.img 
gdrive upload --parent $AEXtrlteduosG $filename_duos.md5sum 
cd $BUILDd
make clean

echo '$filename_trlte uploaded'
echo '$filename_tblte uploaded'
echo '$filename_duos  uploaded'

exit
