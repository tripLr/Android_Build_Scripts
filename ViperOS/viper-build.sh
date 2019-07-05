# Script to Build and Upload ViperOS TRLTE
#Set Global Parameters
# call compile and define global outputs
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh
# Set build and directory parameters
# ViperOS sources
# 
export ViperOSb='/home/triplr/android/ViperOS'
export ViperOSr='/home/triplr/android/ViperOS/.repo/local_manifests'
# trlte out
export ViperOStrlte='/home/triplr/OUT_DIR/ViperOS/target/product/trlte'
export kernelTR='/home/triplr/OUT_DIR/ViperOS/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot'
# tblte out
export ViperOStblte='/home/triplr/OUT_DIR/ViperOS/target/product/tblte'
export kernelTB='/home/triplr/OUT_DIR/ViperOS/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot'
# trlteduos out
export ViperOStrlteduos='/home/triplr/OUT_DIR/ViperOS/target/product/trlteduos'
export kernelTD='/home/triplr/OUT_DIR/ViperOS/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot'
# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/ViperOS_trlte'
export sharedTB='/home/shared/triplr/builds/ViperOS_tblte'
export sharedTD='/home/shared/triplr/builds/ViperOS_trlteduos'
# build aliases  
alias REPO='repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags'
alias build='. $ViperOSb/build/envsetup.sh'
# remove room service files
cd $ViperOSr
rm -v *.xml
# make clean 
cd $ViperOSb
make clean
# download group roomservice
wget -O $ViperOSr/ViperOS.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/viper-pie/master.xml 
cd $ViperOSb
REPO
build
# build trlte
lunch viper_trlte-userdebug
mka poison -j64 | tee trlte-log.txt
# build tblte
lunch viper_tblte-userdebug
mka poison -j64| tee tblte-log.txt
# build trlteduos
lunch viper_trlteduos-userdebug
mka poison -j64 | tee trlteduos-log.txt
# Begin copy to shared and upload trlte
cd $ViperOStrlte
filename=$(basename Viper*.zip) 
mv -v ~/android/ViperOS/trlte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStrlteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStrlteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStrlteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStrlteG $filename.log && s=0 && break || s=$?; done; (exit $s)
cd $ViperOStblte
filename=$(basename Viper*.zip)
mv -v ~/android/ViperOS/tblte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStblteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStblteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStblteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStblteG $filename.log && s=0 && break || s=$?; done; (exit $s)
cd $ViperOStrlteduos
filename=$(basename Viper*.zip)
mv -v ~/android/ViperOS/trlteduos-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStrlteduosG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStrlteduosG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStrlteduosG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $ViperOStrlteduosG $filename.log && s=0 && break || s=$?; done; (exit $s)
cd $ViperOSb
