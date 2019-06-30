# Script to Build and Upload AEX TRLTE
#Set Global Parameters
. ~/bin/compile.sh
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export AEXtrlte='/home/triplr/OUT_DIR/AEX/target/product/trlte'
export kernel='/home/triplr/OUT_DIR/AEX/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot'
export AEXb='/home/triplr/android/AEX'
export AEXr='/home/triplr/android/AEX/.repo/local_manifests'
export AEXtrlteS='home/shared/triplr/AEX/trlte'
export sharedTR='/home/shared/triplr/builds/AEX_trlte'
export sharedTB='/home/shared/triplr/builds/AEX_tblte'
export sharedTD='/home/shared/triplr/builds/AEX_trlteduos'
alias REPO='repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags'
alias build='. $AEXb/build/envsetup.sh'


cd $AEXr
rm -v *.xml

wget -O $AEXr/manifest.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/trlte.xml
#wget -O $AEXr/manifest.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/tblte.xml
#wget -O $AEXr/manifest.xml https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/trlteduos.xml
cd $AEXb
REPO
build
lunch aosp_trlte-userdebug
#mka bacon -j$(nproc --all) # Build and Make
mka bacon -j32 # Build and Make


# Begin copy to shared and upload trlte
cd $AEXtrlte
filename=$(basename Aosp*.zip) 
cp -v  $filename*  $shared
cp -v $kernel/Image $shared/$filename.img

cd $shared
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AEXtrlteG $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
