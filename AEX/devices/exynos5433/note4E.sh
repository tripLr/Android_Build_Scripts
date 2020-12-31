# Script to Build and Upload AEX Exynos 5433 
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account

# update repo file to home dir
. ../../repo-update.sh

# Set build and directory parameters
export BUILDd=~/android/9/AEX
export ROOMd=~/android/9/AEX/.repo/local_manifests

# call server specific out dir
export out_dir=$OUT_DIR_COMMON_BASE

echo " using triplr room service for exynos master devices "
export ROOMs=https://raw.githubusercontent.com/tripLr/local_manifests/aex-pie/5433master.xml

# finished compiles to internal RAID storage on server
#  treltexx     910C /home/shared/OUT_DIR/triplr/AEX/target/product/treltexx
#  trelteskt    910S /home/shared/OUT_DIR/triplr/AEX/target/product/trelteskt
#  tphltexx     910U /home/shared/OUT_DIR/triplr/AEX/target/product/tphltexx
#  tbelteskt    915S /home/shared/OUT_DIR/triplr/AEX/target/product/tbelteskt
#  tre3calteskt 916S /home/shared/OUT_DIR/triplr/AEX/target/product/tre3calteskt

export shared910C=$shareD/AEX910C
export shared910S=$shareD/AEX910S
export shared910U=$shareD/AEX910U
export shared915S=$shareD/AEX915S
export shared916S=$shareD/AEX916S

#  out dir's
export out910C="$out_dir/AEX/target/product/treltexx"
  export k910C="$out910C/obj/KERNEL_OBJ/arch/arm/boot"
export out910S="$out_dir/AEX/target/product/trelteskt"
  export k910S="$out910S/obj/KERNEL_OBJ/arch/arm/boot"
export out910U="$out_dir/AEX/target/product/tphltexx"
  export k910U="$out910U/obj/KERNEL_OBJ/arch/arm/boot"
export out915S="$out_dir/AEX/target/product/tbelteskt"
  export k915S="$out915S/obj/KERNEL_OBJ/arch/arm/boot"
export out916S="$out_dir/AEX/target/product/tre3calteskt"
  export k916S="$out916S/obj/KERNEL_OBJ/arch/arm/boot"

# google drive folders
export AEX910C='18GW22NU1S51N-eDMD_yoJhxwQ584efKW'
export AEX910S='1RosSJ7u1da5-80zYKsL8K0Cm88SUVjm2'
export AEX910U='1c9zyTsg1I4lO_9zTfuxd3dYeKeLzDAg4'
export AEX915S='1VOM1VnHwE8EDU3cH7Qbt9EIm8gO6AnJJ'
export AEX916S='1GceKAhc8-IA8gj_wrQllfac6c8G_NJUe'


cd $BUILDd
make clean
# remove room service files
rm -v $ROOMd/*.xml
repo sync -c -j32 --force-sync --no-clone-bundle --no-tags

# install from web roomservice
wget -O $ROOMd/AEX.xml $ROOMs
#repo sync -c -j32 --force-sync --no-clone-bundle --no-tags | tee repo-note4E.log
REPO

# set environment for build 
. build/envsetup.sh

# note : && if step completed, goto next step else exit code exit
#        & run this step in background to upload file

# build treltexx 910C
lunch aosp_treltexx-userdebug
mka aex -j10 | tee treltexx-log.txt

cd $out910C 
ls -al 
filename910C=$(basename *-treltexx*.zip)  
cp -v $BUILDd/treltexx-log.txt $shared910C/$filename910C.log
cp -v $k910C/Image $shared910C/$filename910C.img 
mv -v  $filename910C*  $shared910C 
cd $shared910C 
ls -al 
gdrive upload --parent $AEX910C $filename910C 
gdrive upload --parent $AEX910C $filename910C.md5sum 
gdrive upload --parent $AEX910C $filename910C.img 

cd $BUILDd

# build trelteskt 910S
lunch aosp_trelteskt-userdebug
mka aex -j5 | tee trelteskt-log.txt

cd $out910S 
ls -al 
filename910S=$(basename *-trelteskt*.zip) 
cp -v $BUILDd/trelteskt-log.txt $shared910S/$filename910S.log
cp -v $k910S/Image $shared910S/$filename910S.img
mv -v  $filename910S*  $shared910S 
cd $shared910S 
ls -al 
gdrive upload --parent $AEX910S $filename910S  
gdrive upload --parent $AEX910S $filename910S.img  
gdrive upload --parent $AEX910S $filename910S.md5sum  

cd $BUILDd

# no ril at this time do not build
# build thpltexx 910U
#lunch aosp_tphltexx-userdebug
#mka aex -j$(nproc --all) | tee tphltexx-log.txt

#cd $out910U
#ls -al 
#filename910U=$(basename *thpltexx*.zip) 
#cp -v $BUILDd/tphltexx-log.txt $shared910U/$filename910U.log
#mv -v  $filename910U*  $shared910U 
#cd $shared910U 
#ls -al 
#gdrive upload --parent $AEX910U $filename910U  &



cd $BUILDd

# build tbelteskt 915S
lunch aosp_tbelteskt-userdebug
mka aex -j$(nproc --all) | tee tbelteskt-log.txt

cd $out915S
ls -al 
filename915S=$(basename *-tbelteskt*.zip) 
cp -v $BUILDd/tbelteskt-log.txt $shared915S/$filename915S.log
cp -v $k915S/Image $shared915S/$filename915S.img
mv -v  $filename915S*  $shared915S 
cd $shared915S 
ls -al 
gdrive upload --parent $AEX915S $filename915S 
gdrive upload --parent $AEX915S $filename915S.img 
gdrive upload --parent $AEX915S $filename915S.md5sum 



cd $BUILDd

# build tre3calteskt 916S
lunch aosp_tre3calteskt-userdebug
mka aex -j$(nproc --all) | tee tre3calteskt-log.txt

cd $out916S
ls -al 
filename916S=$(basename *-tre3calteskt*.zip) 
cp -v $BUILDd/tre3calteskt-log.txt $shared916S/$filename916S.log
cp -v $k916S/Image $shared916S/$filename916S.img
mv -v  $filename916S*  $shared916S 
cd $shared916S 
ls -al 
gdrive upload --parent $AEX910Sg $filename916S  
gdrive upload --parent $AEX910Sg $filename916S.img  
gdrive upload --parent $AEX910Sg $filename916S.md5sum  
cd $BUILDd 
make clean

# this combines all the below files into one build script
#treltexx_910C.sh
#trelteskt_910S.sh
#tphltexx_910U.sh 
#tbelteskt_915S.sh 
#tre3calteskt_916S.sh 



echo "Happy Flashing !!"
