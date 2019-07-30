# Script to Build and Upload AEX TRLTE
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export AEXb=~/android/AEX/
export AEXr=~/android/AEX/.repo/local_manifests
export build_dir=$OUT_DIR_COMMON_BASE

#trlte out
export AEXtrlte="$build_dir/AEX/target/product/trlte"
export kernelTR="$build_dir/AEX/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot"

# tblte out
export AEXtblte="$build_dir/AEX/target/product/tblte"
export kernelTB="$build_dir/AEX/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# trlteduos out
export AEXtrlteduos="$build_dir/AEX/target/product/trlteduos"
export kernelTD="$build_dir/AEX/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot"

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/AEX_trlte'
export sharedTB='/home/shared/triplr/builds/AEX_tblte'
export sharedTD='/home/shared/triplr/builds/AEX_trlteduos'

# build aliases  
alias REPO='repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags'
alias build='. build/envsetup.sh'

# remove room service files
rm -v $AEXr/*.xml
# make clean 
cd $AEXb
make clean
# reset repo with no roomservices
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
# download roomservice files for device or group 
#wget -O $AEXr/manifest.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/trlte.xml
#wget -O $AEXr/manifest.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/tblte.xml
#wget -O $AEXr/manifest.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/trlteduos.xml
#wget -O $AEXr/AEX.xml https://raw.githubusercontent.com/tripLr/local_manifests/AOSP-9.x_linero/AEX.xml
# build for triplr-dev sources github.com/tripLr-dev
wget -O $AEXr/AEX.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/master.xml

# download group roomservice
# build for linero kernel 
cd $AEXb
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
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
mv -v ~/android/AEX/trlte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename.log && s=0 && break || s=$?; done; (exit $s)
# Begin copy to shared and upload tblte
cd $AEXtblte
ls -al
filename=$(basename Aosp*.zip)
mv -v ~/android/AEX/tblte-log.txt $sharedTB/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtblteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtblteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtblteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtblteG $filename.log && s=0 && break || s=$?; done; (exit $s)
# Begin copy to shared and upload trlteduos
# copy and upload trlteduos
cd $AEXtrlteduos
ls -al
filename=$(basename Aosp*.zip)
mv -v ~/android/AEX/trlteduos-log.txt $sharedTD/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteduosG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteduosG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteduosG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteduosG $filename.log  && s=0 && break || s=$?; done; (exit $s)
cd $AEXb
