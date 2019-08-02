# Script to Build and Upload AOKP TRLTE
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export BUILDd=~/android/AOKP_oreo/
export ROOMd=~/android/AOKP_oreo/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ; 
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE


#710 out gts28wifi
export AOKP710="$out_dir/AOKP/target/product/gts28wifi"
export kernelTR="$out_dir/AOKP/target/product/gts28wifi/obj/KERNEL_OBJ/arch/arm/boot"

# 715 out gts28ltexx
export AOKP715="$out_dir/AOKP/target/product/gts28ltexx"
export kernelTB="$out_dir/AOKP/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# 810 out  gts210wifi
export AOKP810="$out_dir/AOKP/target/product/gts210wifi"
export kernelTD="$out_dir/AOKP/target/product/gts220wifi/obj/KERNEL_OBJ/arch/arm/boot"

# 815 out gts210ltexx
export AOKP815="$out_dir/AOKP/target/product/gts210ltexx"
export kernelTD="$out_dir/AOKP/target/product/gts210ltexx/obj/KERNEL_OBJ/arch/arm/boot"

# copy finished compiles to internal RAID storage on server
export shared710='home/shared/triplr/builds/gts2/710'
export shared715='/home/shared/triplr/builds/gts2/715'
export shared810='/home/shared/triplr/builds/gts2/810'
export shared815='/home/shared/triplr/builds/gts2/815'

# remove room service files
rm -v $ROOMd/*.xml

# make clean 
cd $BUILDd
make clean

# install from web roomservice
wget -O $ROOMd/AOKP.xml $AOKPgts28r
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# set environment for build 
. build/envsetup.sh

# build gts28wifi T710
lunch aosp_gts28wifi-userdebug
mka aosp -j$(nproc --all) | tee gts28wifi-log.txt

# build gts28ltexx T715
lunch aosp_gts29ltexx-userdebug
mka aosp -j$(nproc --all) | tee gts28ltexx-log.txt

# build gts210wifi T-810 
lunch aosp_gts210wifi-userdebug
mka aosp -j$(nproc --all) | tee gts210wifi-log.txt

# build gts210ltexx T815
lunch aosp_gts210ltexx-userdebug
mka aex -j$(nproc --all) | tee trlteduos-log.txt

# Begin copy to shared and upload trlte
cd $AOKPgts29wifi
ls -al
filename=$(basename Aosp*.zip) 
mv -v ~/android/AOKP/trlte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteG $filename.log && s=0 && break || s=$?; done; (exit $s)

# Begin copy to shared and upload tblte
cd $AOKPtblte
ls -al
filename=$(basename Aosp*.zip)
mv -v ~/android/AOKP/tblte-log.txt $sharedTB/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtblteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtblteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtblteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtblteG $filename.log && s=0 && break || s=$?; done; (exit $s)

# Begin copy to shared and upload trlteduos
cd $AOKPtrlteduos
ls -al
filename=$(basename Aosp*.zip)
mv -v ~/android/AOKP/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteduosG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteduosG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteduosG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteduosG $filename.log  && s=0 && break || s=$?; done; (exit $s)

cd $AOKPtrlteduos
ls -al
filename=$(basename Aosp*.zip)
mv -v ~/android/AOKP/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteduosG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteduosG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteduosG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteduosG $filename.log  && s=0 && break || s=$?; done; (exit $s)

cd $AOKPb
