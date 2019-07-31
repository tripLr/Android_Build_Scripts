#!/bin/bash
# Script to Build and Upload AOKP_pie TRLTE
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export BUILDd=~/android/AOKP_pie
export ROOMd=~/android/AOKP_pie/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
         then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE


#trlte out
export AOKPtrlte="$out_dir/AOKP_pie/target/product/trlte"
export kernelTR="$out_dir/AOKP_pie/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot"

# tblte out
export AOKPtblte="$out_dir/AOKP_pie/target/product/tblte"
export kernelTB="$out_dir/AOKP_pie/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# trlteduos out
export AOKPtrlteduos="$out_dir/AOKP_pie/target/product/trlteduos"
export kernelTD="$out_dir/AOKP_pie/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot"

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/AOKP_trlte'
export sharedTB='/home/shared/triplr/builds/AOKP_tblte'
export sharedTD='/home/shared/triplr/builds/AOKP_trlteduos'



filename=$(basename aokp*unofficial*.zip)
mv -v  $filename*  $sharedTR
cd $sharedTR
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteG $filename && s=0 && break || s=$?; done; (exit $s)
# Begin copy to shared and upload tblte
cd $AOKPtblte
ls -al
filename=$(basename aokp*unofficial*.zip)
mv -v  $filename*  $sharedTB
cd $sharedTB
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtblteG $filename && s=0 && break || s=$?; done; (exit $s)
# Begin copy to shared and upload trlteduos
cd $AOKPtrlteduos
ls -al
filename=$(basename aokp*unofficial*.zip)
mv -v  $filename*  $sharedTD
cd $sharedTD
ls -al
for i in $(seq 1 50); do [ $i -gt 1 ] ; gdrive upload --parent $AOKPtrlteduosG $filename && s=0 && break || s=$?; done; (exit $s)
cd $AOKPb

