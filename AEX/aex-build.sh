# Script to Build and Upload AEX TRLTE
#Set Global Parameters
# call compile and define global outputs
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters

export AEXb='/home/triplr/android/AEX'
export AEXr='/home/triplr/android/AEX/.repo/local_manifests'


# trlte out
export AEXtrlte='/home/triplr/OUT_DIR/AEX/target/product/trlte'
export kernelTR='/home/triplr/OUT_DIR/AEX/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot'

# tblte out
export AEXtblte='/home/triplr/OUT_DIR/AEX/target/product/tblte'
export kernelTB='/home/triplr/OUT_DIR/AEX/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot'

# trlteduos out
export AEXtrlteduos='/home/triplr/OUT_DIR/AEX/target/product/trlteduos'
export kernelTD='/home/triplr/OUT_DIR/AEX/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot'

# copy finished compiles to internal RAID storage on server

export sharedTR='/home/shared/triplr/builds/AEX_trlte'
export sharedTB='/home/shared/triplr/builds/AEX_tblte'
export sharedTD='/home/shared/triplr/builds/AEX_trlteduos'

# build aliases  

alias REPO='repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags'
alias build='. $AEXb/build/envsetup.sh'


#begin case function to make clean all devices in repo

#input in entery string or ask ?
  
    #  $1 build.sh -c --clean  
    #  $1 build.sh -i --incremental do nothing incremental
    #  $1 build.sh -d --device $2 device name required or error 
    #  $1 build.sh -a --all         

# remove room service files
cd $AEXr
rm -v *.xml

# make clean 
cd $AEXb
make clean
make clobber

# reset repo with no roomservices
#REPO


# begin case function

# download roomservice files for device or group 

# build for lineageos bases including kernel @ripeedev
#wget -O $AEXr/manifest.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/trlte.xml
#wget -O $AEXr/manifest.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/tblte.xml
#wget -O $AEXr/manifest.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/trlteduos.xml

#wget -O $AEXr/AEX.xml https://raw.githubusercontent.com/tripLr/local_manifests/AOSP-9.x_linero/AEX.xml
# build for triplr-dev sources github.com/tripLr.dev

# download group roomservice
# build for linero kernel 
wget -O $AEXr/AEX.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/master.xml

cd $AEXb
REPO


# build trlte
lunch aosp_trlte-userdebug
#mka bacon -j$(nproc --all) # Build and Make
#mka bacon -j32 # Build and Make
mka aex -j$(nproc --all) | tee trlte-log.txt

# build tblte
lunch aosp_tblte-userdebug
#mka bacon -j$(nproc --all) # Build and Make
#mka bacon -j32 # Build and Make
mka aex -j$(nproc --all) | tee tblte-log.txt

# build trlteduos
lunch aosp_trlteduos-userdebug
#mka bacon -j$(nproc --all) # Build and Make
#mka bacon -j32 # Build and Make
mka aex -j$(nproc --all) | tee trlteduos-log.txt

# Begin copy to shared and upload trlte

# copy and upload trlte 

cd $AEXtrlte
filename=$(basename Aosp*.zip) 
mv -v ~/android/AEX/trlte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img

cd $sharedTR
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)

cd $AEXtblte
filename=$(basename Aosp*.zip)
mv -v ~/android/AEX/tblte-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img

cd $sharedTB
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtblteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtblteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtblteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)

cd $AEXtrlteduos
filename=$(basename Aosp*.zip)
mv -v ~/android/AEX/trlteduos-log.txt $sharedTR/$filename.log
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img

cd $sharedTD
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteduosG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteduosG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteduosG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)

