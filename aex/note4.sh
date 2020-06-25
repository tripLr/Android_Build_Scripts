#!/bin/bash

# Script to Build and Upload AEX TRLTE TBLTE TRLTEDUOS

if 
                        [ $1='clean' ]
                then    
                        export clean=$1 ;
		else 	export clean='dont clean this build' ;
fi



parameters() {
	
	# Set Build Parameters
	# Server Specific compile settings
		. ~/bin/compile.sh
		. ~/bin/gdrive_aliases.sh

	# Set build directory parameters
		export BUILDd=~/android/aex-9.x
	
	# set web location of roomservice for device
		export ROOMs=https://raw.githubusercontent.com/triplr-dev/local_manifests/aex-9.x/master.xml
		export ROOMd=$BUILDd/.repo/local_manifests
	# set target build directories for copying files

	export out_dir=$OUT_DIR_COMMON_BASE

	#trlte out
		export AEXtrlte=$out_dir/aex-9.x/target/product/trlte
		export kernelTR=$out_dir/aex-9.x/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot
		export sharedTR=$shareD/AEX_trlte
	# tblte out
		export AEXtblte=$out_dir/aex-9.x/target/product/tblte
		export kernelTB=$out_dir/aex-9.x/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot
		export sharedTB=$shareD/AEX_tblte
	# trlteduos out
		export AEXtrlteduos=$out_dir/aex-9.x/target/product/trlteduos
		export kernelTD=$out_dir/aex-9.x/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot
		export sharedTD=$shareD/AEX_trlteduos
	
}

clean() {
	## make clean selection

	cd $BUILDd

	if 
			[ $clean='clean' ]
		then 	
			echo 'make clean in progress, please wait' ;
			make clean;
		else	
			echo 'skipping $clean '
	fi

}

roomservice() {
	
	cd $BUILDd
	# remove room service files
	rm -v $ROOMd/*.xml

	# install from web roomservice
	wget -O $ROOMd/AEX.xml $ROOMs
	repo sync -j16 -qc --force-sync --no-clone-bundle --no-tags --fail-fast | tee trlte-repo.log
}

envsetup() {
	
	cd $BUILDd
	# set environment for build 
	. build/envsetup.sh
}

trlte() {

	cd $BUILDd

	# build trlte
		lunch aosp_trlte-userdebug
		mka aex -j$(nproc --all) | tee trlte-log.txt

}

tblte() {

	cd $BUILDd

	# build tblte
		lunch aosp_tblte-userdebug
		mka aex -j$(nproc --all) | tee tblte-log.txt
	
}

trlteduos() {

   	cd $BUILDd

	# build trlteduos
		lunch aosp_trlteduos-userdebug
		mka aex -j$(nproc --all) | tee trlteduos-log.txt


	# Begin copy to shared and upload trlteduos
	cd $AEXtrlteduos
	ls -al
		filename_duos=$(basename *-trlteduos*.zip)
		cp -v $BUILDd/trlteduos-log.txt $sharedTD/$filename_duos.log
		mv -v  $filename_duos*  $sharedTD
		mv -v $kernelTD/Image $sharedTD/$filename_duos.img
	cd $sharedTD

	ls -al
	gdrive upload --parent $AEXtrlteduosG $filename_duos
	gdrive upload --parent $AEXtrlteduosG $filename_duos.img
	gdrive upload --parent $AEXtrlteduosG $filename_duos.md5sum

	cd $BUILDd
}

upload_trlte() {
	# Begin copy to shared and upload trlte
	cd $AEXtrlte
	ls -al
	
	filename_trlte=$(basename *-trlte*.zip)
	echo $filename_trlte
	mv -v $BUILDd/trlte-log.txt $sharedTR/$filename_trlte.log
	mv -v $BUILDd/trlte-repo.log $sharedTR/$filename_trlte.repo.log
	mv -v  $filename_trlte*  $sharedTR
	mv -v $kernelTR/Image $sharedTR/$filename_trlte.img
	cd $sharedTR
	ls -al
	gdrive upload --parent $AEXtrlteG $filename_trlte 
	gdrive upload --parent $AEXtrlteG $filename_trlte.img
	gdrive upload --parent $AEXtrlteG $filename_trlte.md5sum
}

upload_tblte() {
	
	cd $AEXtblte
	ls -al
	filename_tblte=$(basename *-tblte*.zip)
	cp -v $BUILDd/tblte-log.txt $sharedTB/$filename_tblte.log
	mv -v  $filename_tblte*  $sharedTB
	mv -v $kernelTB/Image $sharedTB/$filename_tblte.img
	
	cd $sharedTB
	ls -al
	gdrive upload --parent $AEXtblteG $filename_tblte 
	gdrive upload --parent $AEXtblteG $filename_tblte.img 
	gdrive upload --parent $AEXtblteG $filename_tblte.md5sum

}
parameters
#clean
roomservice
envsetup
trlte
#tblte
#trlteduos
upload_trlte
#clean
