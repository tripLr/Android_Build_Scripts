# Script to Build and Upload VIPER TRLTE
#Set Global Parameters
# call compile and define global outputs
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export BUILDd=~/android/VIPER
export ROOMd=~/android/VIPER/.repo/local_manifests
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
export VIPERtrlte="$out_dir/VIPER/target/product/trlte"
export kernelTR="$out_dir/VIPER/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot"

# tblte out
export VIPERtblte="$out_dir/VIPER/target/product/tblte"
export kernelTB="$out_dir/VIPER/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# trlteduos out
export VIPERtrlteduos="$out_dir/VIPER/target/product/trlteduos"
export kernelTD="$out_dir/target/VIPER/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot'"

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/VIPER_trlte'
export sharedTB='/home/shared/triplr/builds/VIPER_tblte'
export sharedTD='/home/shared/triplr/builds/VIPER_trlteduos'

# remove room service files
rm -v $ROOMd/*.xml

# make clean 
cd $BUILDd
make clean

# download group roomservice https://raw.githubusercontent.com/triplr-dev/local_manifests/viper-pie/master.xml
wget -O $ROOMd/VIPER.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/viper-pie/master.xml 
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

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
mv -v ~/android/VIPER/trlte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtrlteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtrlteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtrlteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtrlteG $filename.log && s=0 && break || s=$?; done; (exit $s)
# Begin copy to shared and upload tblte
cd $VIPERtblte
ls -al
filename=$(basename Viper*.zip)
mv -v ~/android/VIPER/tblte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtblteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtblteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtblteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtblteG $filename.log && s=0 && break || s=$?; done; (exit $s)
# Begin copy to shared and upload trlteduos
cd $VIPERtrlteduos
ls -al
filename=$(basename Viper*.zip)
mv -v ~/android/VIPER/trlteduos-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtrlteduosG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtrlteduosG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtrlteduosG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $VIPERtrlteduosG $filename.log && s=0 && break || s=$?; done; (exit $s)
cd $BUILDd
