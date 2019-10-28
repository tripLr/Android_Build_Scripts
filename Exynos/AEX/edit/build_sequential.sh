# Scrip to Build and Upload AOKP Exynos5433
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
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
#roomservices
# @inkypen # github.com/exynos5433
export r710=https://raw.githubusercontent.com/Exynos5433/local_manifests/aokp-oreo/gts28wifi.xml
export r715=https://raw.githubusercontent.com/Exynos5433/local_manifests/aokp-oreo/gts28ltexx.xml
export r810=https://raw.githubusercontent.com/Exynos5433/local_manifests/aokp-oreo/gts210wifi.xml
export r815=https://raw.githubusercontent.com/Exynos5433/local_manifests/aokp-oreo/gts210ltexx.xml
#triplr
# github.com/triplr/

#710 out gts28wifi
export AOKP710b=$out_dir/AOKP_oreo/target/product/gts28wifi
export kernel710b=$out_dir/AOKP_oreo/target/product/gts28wifi/obj/KERNEL_OBJ/arch/arm/boot

# 715 out gts28ltexx
export AOKP715b=$out_dir/AOKP_oreo/target/product/gts28ltexx
export kernel715b=$out_dir/AOKP_oreo/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot

# 810 out  gts210wifi
export AOKP810b=$out_dir/AOKP_oreo/target/product/gts210wifi
export kernel810b=$out_dir/AOKP_oreo/target/product/gts220wifi/obj/KERNEL_OBJ/arch/arm/boot

# 815 out gts210ltexx
export AOKP815b=$out_dir/AOKP_oreo/target/product/gts210ltexx
export kernel815b=$out_dir/AOKP_oreo/target/product/gts210ltexx/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export shared710='/home/shared/triplr/builds/gts2/710'
export shared715='/home/shared/triplr/builds/gts2/715'
export shared810='/home/shared/triplr/builds/gts2/810'
export shared815='/home/shared/triplr/builds/gts2/815'

# remove room service files
rm -v $ROOMd/*.xml
REPO
# make clean 
cd $BUILDd
make clean

# build gts28wifi T710
wget -O $ROOMd/AOKP_oreo.xml $r710	 
REPO
. build/envsetup.sh
lunch aokp_gts28wifi-userdebug
mka rainbowfarts -j$(nproc --all) | tee gts28wifi-log.txt

# build gts28ltexx T715
wget -O $ROOMd/AOKP_oreo.xml $r715
REPO
. build/envsetup.sh
lunch aokp_gts28ltexx-userdebug
mka rainbowfarts -j$(nproc --all) | tee gts28ltexx-log.txt

# build gts210wifi T-810 
wget -O $ROOMd/AOKP_oreo.xml $r810
REPO
. build/envsetup.sh
lunch aokp_gts210wifi-userdebug
mka rainbowfarts -j$(nproc --all) | tee gts210wifi-log.txt

# build gts210ltexx T815
wget -O $ROOMd/AOKP_oreo.xml $r815
REPO 
. build/envsetup.sh
lunch aokp_gts210ltexx-userdebug
mka rainbowfarts -j$(nproc --all) | tee gts210ltexx-log.txt

# Begin copy to shared and upload T710 
cd $AOKP710b
ls -al
filename=$(basename aokp_gts*.zip) 
mv -v ~/android/AOKP_oreo/gts28wifi-log.txt $shared710/$filename.log
mv -v  $filename*  $shared710
mv -v $kernel710b/Image $shared710/$filename.img
cd $shared710
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP710 $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP710 $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP710 $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP710 $filename.log && s=0 && break || s=$?; done; (exit $s)

# Begin copy to shared and upload tblte
cd $AOKP715b
ls -al
filename=$(basename aokp_gts*.zip)
mv -v ~/android/AOKP_oreo/gts28ltexx-log.txt $shared715/$filename.log
mv -v  $filename*  $shared715
mv -v $kernel715b/Image $shared715/$filename.img
cd $shared715
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP715 $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP715 $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP715 $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP715 $filename.log && s=0 && break || s=$?; done; (exit $s)

# Begin copy to shared and upload trlteduos
cd $AOKP810b
ls -al
filename=$(basename aokp_gts*.zip)
mv -v ~/android/AOKP_oreo/gts210wifi-log.txt $shared810/$filename.log
mv -v  $filename*  $shared810
mv -v $kernel810b/Image $shared810/$filename.img
cd $shared810
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP810 $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP810 $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP810 $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP810 $filename.log  && s=0 && break || s=$?; done; (exit $s)

cd $AOKP815b
ls -al
filename=$(basename aokp_gts*.zip)
mv -v ~/android/AOKP_oreo/gts210ltexx-log.txt $shared815/$filename.log
mv -v  $filename*  $shared815
mv -v $kernel815b/Image $shared815/$filename.img
cd $shared815
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP815 $filename && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP815 $filename.img && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP815 $filename.md5sum && s=0 && break || s=$?; done; (exit $s)
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKP815 $filename.log  && s=0 && break || s=$?; done; (exit $s)

cd $BUILDd
