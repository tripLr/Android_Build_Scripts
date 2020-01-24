# Script to Build and Upload AEX TBLTE
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
export ROOMs=https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/tblte.xml

# tblte out
export AEXtblte=$out_dir/AEX/target/product/tblte
export kernelTB=$out_dir/AEX/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export sharedTB='/home/shared/triplr/builds/AEX_tblte'

cd $BUILDd

# remove room service files
rm -v $ROOMd/*.xml
# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
~/bin/repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo.log


# set environment for build 
. build/envsetup.sh


cd $BUILDd
# build tblte
lunch aosp_tblte-userdebug
mka aex -j$(nproc --all) | tee tblte-log.txt

cd $AEXtblte
ls -al
filename_tblte=$(basename Aosp*.zip)
mv -v $BUILDd/tblte-log.txt $sharedTB/$filename_tblte.log
mv -v  $filename_tblte*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename_tblte.img
cd $sharedTB
ls -al
gdrive upload --parent $AEXtblteG $filename_tblte &&
gdrive upload --parent $AEXtblteG $filename_tblte.img &&
gdrive upload --parent $AEXtblteG $filename_tblte.md5sum 

echo '$filename_tblte uploaded'

exit
