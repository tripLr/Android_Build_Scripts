#!/bin/bash 

# Script to Build and Upload AICP TRLTE

# Server Specific compile settings
. ~/bin/compile.sh
. ~/bin/gdrive_aliases.sh
. ~/bin/repo-update.sh

# Set build and directory parameters
export BUILDd=~/android/9/AICP
export ROOMd=~/android/9/AICP/.repo/local_manifests


export out_dir=$OUT_DIR_COMMON_BASE
export ROOMs='https://raw.githubusercontent.com/triplr-dev/local_manifests/aicp-p9.0/master.xml'

#trlte out
export AICPtrlte=$out_dir/AICP/target/product/trlte
export kernelTR=$out_dir/AICP/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot

# tblte out
export AICPtblte=$out_dir/AICP/target/product/tblte
export kernelTB=$out_dir/AICP/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot

# trlteduos out
export AICPtrlteduos=$out_dir/AICP/target/product/trlteduos
export kernelTD=$out_dir/AICP/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/AICP_trlte'
export sharedTB='/home/shared/triplr/builds/AICP_tblte'
export sharedTD='/home/shared/triplr/builds/AICP_trlteduos'

cd $BUILDd
#make clean 

# remove room service files
rm -v $ROOMd/*.xml

cd $BUILDd
# install from web roomservice
wget -O $ROOMd/AICP.xml $ROOMs 
#https://raw.githubusercontent.com/triplr-dev/local_manifests/aokp-pie/master.xml

. ~/bin/repo sync -c -j16 --force-sync --no-clone-bundle --no-tags | tee repo.log &&

# set environment for build 
. build/envsetup.sh

# build trlte
brunch trlte | tee trlte-log.txt

# Begin copy to shared and upload trlte
# upload
cd $AICPtrlte
ls -al
filename_trlte=$(basename aicp*UNOFFICIAL*.zip) 
mv -v $BUILDd/repo.log $sharedTR/$filename_trlte.repo.log
mv -v $BUILDd/trlte-log.txt $sharedTR/$filename_trlte.log
mv -v  $filename_trlte*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename_trlte.img
cd $sharedTR
ls -al
gdrive upload --parent $AICPtrlteG $filename_trlte 
gdrive upload --parent $AICPtrlteG $filename_trlte.img 
gdrive upload --parent $AICPtrlteG $filename_trlte.md5sum 

cd $BUILDd

# build tblte
brunch tblte | tee tblte-log.txt

# Begin copy to shared and upload tblte
# upload
cd $AICPtblte
ls -al
filename_tblte=$(basename aicp*UNOFFICIAL*.zip) 
mv -v $BUILDd/tblte-log.txt $sharedTB/$filename_tblte.log
mv -v  $filename_tblte*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename_tblte.img
cd $sharedTB
ls -al
gdrive upload --parent $AICPtblteG $filename_tblte 
gdrive upload --parent $AICPtblteG $filename_tblte.img 
gdrive upload --parent $AICPtblteG $filename_tblte.md5sum 


cd $BUILDd
# build trlteduos
brunch trlteduos | tee trlteduos-log.txt

# Begin copy to shared and upload trlteduos
cd $AICPtrlteduos
ls -al
filename_duos=$(basename aicp*UNOFFICIAL*.zip) 
mv -v $BUILDd/trlteduos-log.txt $sharedTB/$filename_duos.log
mv -v  $filename_duos*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename_duos.img
cd $sharedTD
ls -al
gdrive upload --parent $AICPtrlteduosG $filename_duos 
gdrive upload --parent $AICPtrlteduosG $filename_duos.img
gdrive upload --parent $AICPtrlteduosG $filename_duos.md5sum 
cd $BUILDd 

echo 'enjoy aicp , type make clean to clean build next run'
