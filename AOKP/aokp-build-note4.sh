# Script to Build and Upload AOKP TRLTE
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export BUILD=~/android/AOKP_pie
export ROOM="$BUILD/.repo/local_manifests"
export build_dir=$OUT_DIR_COMMON_BASE

#trlte out
export AOKPtrlte="$build_dir/AOKP/target/product/trlte"
export kernelTR="$build_dir/AOKP/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot"

# tblte out
export AOKPtblte="$build_dir/AOKP/target/product/tblte"
export kernelTB="$build_dir/AOKP/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# trlteduos out
export AOKPtrlteduos="$build_dir/AOKP/target/product/trlteduos"
export kernelTD="$build_dir/AOKP/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot"

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/AOKP_trlte'
export sharedTB='/home/shared/triplr/builds/AOKP_tblte'
export sharedTD='/home/shared/triplr/builds/AOKP_trlteduos'


# remove room service files
rm -v $ROOM/*.xml
# make clean 
cd $BUILD
make clean

# reset repo with no roomservices
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

# download roomservice files for device or group 

get -O $ROOM/AOKP.xml  https://raw.githubusercontent.com/triplr-dev/local_manifests/aokp-pie/master.xml

cd $BUILD 
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
. build/envsetup.sh

# build trlte
lunch aokp_trlte-userdebug
mka  rainbowfarts -j$(nproc --all) | tee trlte-log.txt

# build tblte
lunch aokp_tblte-userdebug
mka rainbowfarts -j$(nproc --all) | tee tblte-log.txt

# build trlteduos
lunch aokp_trlteduos-userdebug
mka rainbowfarts -j$(nproc --all) | tee trlteduos-log.txt

# Begin copy to shared and upload trlte
cd $AOKPtrlte
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
# copy and upload trlteduos
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
cd $BUILD

