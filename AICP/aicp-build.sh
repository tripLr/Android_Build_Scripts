# Script to Build and Upload AICP TRLTE
# Set Global Parameters
# Server Specific compile settings
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters
export BUILDd=~/android/AICP
export ROOMd=~/android/AICP/.repo/local_manifests
if 
   [ ! -d $ROOMd ];
	 then
    mkdir -pv $ROOMd ;
         else
    echo ' roomservice dir exists ' 
fi

export out_dir=$OUT_DIR_COMMON_BASE
export ROOMs='https://raw.githubusercontent.com/triplr-dev/local_manifests/aicp-p9.0/master.xml'

#trlte out
export AICPtrlte="$out_dir/AICP/target/product/trlte"
export kernelTR="$out_dir/AICP/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot"

# tblte out
export AICPtblte="$out_dir/AICP/target/product/tblte"
export kernelTB="$out_dir/AICP/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot"

# trlteduos out
export AICPtrlteduos="$out_dir/AICP/target/product/trlteduos"
export kernelTD="$out_dir/AICP/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot"

# copy finished compiles to internal RAID storage on server
export sharedTR='/home/shared/triplr/builds/AICP_trlte'
export sharedTB='/home/shared/triplr/builds/AICP_tblte'
export sharedTD='/home/shared/triplr/builds/AICP_trlteduos'

cd $BUILDd
make clean && make clobber

# remove room service files
rm -v $ROOMd/*.xml

cd $BUILDd
repo sync -c --force-sync --no-clone-bundle --no-tags

# install from web roomservice
wget -O $ROOMd/AICP.xml $ROOMs #https://raw.githubusercontent.com/triplr-dev/local_manifests/aokp-pie/master.xml
repo sync -c --force-sync --no-clone-bundle --no-tags

# set environment for build 
. build/envsetup.sh

# build trlte
brunch trlte | tee trlte-log.txt

# build tblte
brunch tblte | tee tblte-log.txt

# build trlteduos
brunch trlteduos | tee trlteduos-log.txt

# Begin copy to shared and upload trlte
cd $AICPtrlte
ls -al
filename=$(basename aicp*UNOFFICIAL*.zip) 
mv -v  $filename*  $sharedTR
mv -v $kernelTR/Image $sharedTR/$filename.img
cd $sharedTR
ls -al
gdrive upload --parent $AICPtrlteG $filename 
gdrive upload --parent $AICPtrlteG $filename.img 
gdrive upload --parent $AICPtrlteG $filename.md5sum 
# Begin copy to shared and upload tblte
cd $AICPtblte
ls -al
filename=$(basename aicp*UNOFFICIAL*.zip) 
mv -v  $filename*  $sharedTB
mv -v $kernelTB/Image $sharedTB/$filename.img
cd $sharedTB
ls -al
gdrive upload --parent $AICPtblteG $filename 
gdrive upload --parent $AICPtblteG $filename.img 
gdrive upload --parent $AICPtblteG $filename.md5sum 
# Begin copy to shared and upload trlteduos
cd $AICPtrlteduos
ls -al
filename=$(basename aicp*UNOFFICIAL*.zip) 
mv -v  $filename*  $sharedTD
mv -v $kernelTD/Image $sharedTD/$filename.img
cd $sharedTD
ls -al
gdrive upload --parent $AICPtrlteduosG $filename 
gdrive upload --parent $AICPtrlteduosG $filename.img
gdrive upload --parent $AICPtrlteduosG $filename.md5sum 
cd $AICPb
