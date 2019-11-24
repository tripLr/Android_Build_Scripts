# Script to Build and Upload VIPER TRLTE
#Set Global Parameters
# call compile and define global outputs
. ~/bin/compile.sh
if 
	[ -f ../../gdrive_aliases.sh ];
	  then
	    cp -v ../../gdrive_aliases.sh ~/bin/ ;  
      	    echo 'file copied '
	  else
		echo 'file not found '
fi

. ~/bin/gdrive_aliases.sh
. ../../repo-update.sh

# Set build and directory parameters
export BUILDd=~/android/9/VIPER
export ROOMd=~/android/9/VIPER/.repo/local_manifests
# check if local manifest dir exists if not then create
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE

# trlte out
export VIPERtrlte=$out_dir/VIPER/target/product/trlte
export kernelTR=$out_dir/VIPER/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot

# tblte out
export VIPERtblte=$out_dir/VIPER/target/product/tblte
export kernelTB=$out_dir/VIPER/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot

# trlteduos out
export VIPERtrlteduos=$out_dir/VIPER/target/product/trlteduos
export kernelTD=$out_dir/VIPER/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/VIPER_trlte'
export sharedTB='/home/shared/triplr/builds/VIPER_tblte'
export sharedTD='/home/shared/triplr/builds/VIPER_trlteduos'

export VIPERr=https://raw.githubusercontent.com/triplr-dev/local_manifests/viper-pie/master.xml
echo "VIPER sources and Google Drive set"

# make clean 
cd $BUILDd
make clean 

# remove room service files and sync
rm -v $ROOMd/*.xml

wget -O $ROOMd/VIPER.xml $VIPERr #https://raw.githubusercontent.com/triplr-dev/local_manifests/viper-pie/master.xml 
# download group roomservice https://raw.githubusercontent.com/triplr-dev/local_manifests/viper-pie/master.xml
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags | tee repo.log

# set environment for build
. build/envsetup.sh

# build trlte
lunch viper_trlte-userdebug
mka poison -j$(nproc --all) | tee trlte-log.txt

# build tblte
lunch viper_tblte-userdebug
mka poison -j$(nproc --all) | tee tblte-log.txt

# build trlteduos
lunch viper_trlteduos-userdebug
mka poison -j$(nproc --all) | tee trlteduos-log.txt

# Begin copy to shared and upload trlte
cd $VIPERtrlte
ls -al
filename=$(basename Viper*.zip) 
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename.log
mv -v $BUILDd/repo.log $sharedTR/$filename.repo.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
gdrive upload --parent $VIPERtrlteG $filename 
gdrive upload --parent $VIPERtrlteG $filename.img 
gdrive upload --parent $VIPERtrlteG $filename.md5sum 
# Begin copy to shared and upload tblte
cd $VIPERtblte
ls -al
filename=$(basename Viper*.zip)
mv -v $BUILDd/tblte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
gdrive upload --parent $VIPERtblteG $filename 
gdrive upload --parent $VIPERtblteG $filename.img 
gdrive upload --parent $VIPERtblteG $filename.md5sum 
# Begin copy to shared and upload trlteduos
cd $VIPERtrlteduos
ls -al
filename=$(basename Viper*.zip)
mv -v $BUILDd/trlteduos-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
gdrive upload --parent $VIPERtrlteduosG $filename 
gdrive upload --parent $VIPERtrlteduosG $filename.img 
gdrive upload --parent $VIPERtrlteduosG $filename.md5sum
cd $BUILDd
