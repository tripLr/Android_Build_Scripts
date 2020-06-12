#!/bin/bash

# LineageOS 16 trlte
# Initialize Rom build, install roomservice,
# repo lists for triplr

# AEX			repo init --depth=1 -u git://github.com/AospExtended/manifest.git -b 9.x
# AICP			repo init --depth=1 -u https://github.com/AICP/platform_manifest.git -b p9.0
# AOKP			repo init --depth=1 -u https://github.com/AOKP/platform_manifest.git -b pie

# LineageOS 16		repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-16.0
# roomservice			https://raw.githubusercontent.com/triplr-dev/local_manifests/lineage-17.1/master.xml

# Pixel Expierence	repo init --depth=1 -u https://github.com/PixelExperience/manifest -b pie
# ViperOS		repo init --depth=1 -u https://github.com/ViperOS/viper_manifest.git -b pie
# xenon 		repo init --depth=1 -u https://github.com/TeamHorizon/platform_manifest.git -b p
# Lineageos 17.1 	



function load_gdrive_aliases {

	# call google drive folder variables
	# to upload builds to google drive triplr.dev shared account
	# check master copy gdrive_aliases.sh exists 
	# install and excecute

	if 
	   [ -f ../gdrive_aliases.sh ]; # looking for file in root of the gitfolder 
	  	then
	    		cp -v ../gdrive_aliases.sh ~/bin/ ;  
      	    		echo 'master google drive file copied ';
	 	else
			echo 'file not found ';
	fi

	. ~/bin/gdrive_aliases.sh

}

function load_server_parameters {

	# Set Global Parameters
	# Server Specific compile settings
	. ~/bin/compile.sh
}

function load_rom_variables {

	export rom="lineage-16.0"

	# Set build and directory parameters
	export BUILDd=~/android/$rom
	export ROOMd=~/android/$rom/.repo/local_manifests
	
	# set repo 
	export INITd=$BUILDd/.repo
	export ROOMd=$BUILDd/.repo/local_manifests
	export manifest='git://github.com/LineageOS/android.git -b lineage-16.0'

	# set shortcut for $OUT_DIR
	# pull varible from parameters function
	# OUT_DIR_COMMON_BASE is where rom and device specific builds are output
	# in this server case it is /home/shared/$user/OUT_DIR
 
	export out_dir=$OUT_DIR_COMMON_BASE

	# SET MASTER ROOMSERVICE FROM GITHUB HERE for device !!!
	export ROOMs=https://raw.githubusercontent.com/triplr-dev/local_manifests/lineage-16.0/master.xml

	# chiset similar device specific file targets set here
	#set finished build dir
	#set finished kernel boot image dir
	
	# trlte 
	export LOS16trlte=$out_dir/LOS16/target/product/trlte
	export kernelTR=$out_dir/LOS16/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot

	# tblte 
	export LOS16tblte=$out_dir/LOS16/target/product/tblte
	export kernelTB=$out_dir/LOS16/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot

	# trlteduos 
	export LOS16trlteduos=$out_dir/LOS16/target/product/trlteduos
	export kernelTD=$out_dir/LOS16/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot

	# archive and upload directory 
	export sharedTR='/home/shared/$USER/builds/LOS16_trlte'
	export sharedTB='/home/shared/$USER/builds/LOS16_tblte'
	export sharedTD='/home/shared/$USER/builds/LOS16_trlteduos'
}

function init_BUILDd {

	# check to see if build dir exists if not create
	if 
	   [ ! -d $BUILDd ] ;
		then
			mkdir -pv $BUILDd ;
		else
			echo '$BUILDd exists'
	fi

}

function init_REPOd {
	# check to see if manifest .repo exists, if not create, init, and sync
	if 
   	   [ ! -d $INITd ];
		then
			cd $BUILDd ;
			repo init --depth=1 -u	$manifest ;
			repo sync -c -j16 --force-sync --no-clone-bundle --no-tags	;
			echo "REPO init and sync complete";		
     		else
    			echo '$INITd exists ' ;
	fi
}

function init_ROOMd {

	# check to see if roomservice dir exists if not , create
	if 
   	   [ ! -d $ROOMd ];
        	then
    			mkdir -pv $ROOMd ;
			cd $BUILDd ;
         	else
    			echo '$ROOMd dir exists ' ;
	fi
}

function load_roomservice {
	
	# Update room room service files for this device 
		rm -v $ROOMd/*.xml 
	# install from web roomservice 
		wget -O $ROOMd/LOS16.xml $ROOMs 
		repo sync -c -j4 --force-sync --no-clone-bundle --no-tags | tee repo.log 
}


# call functions
load_gdrive_aliases
load_server_parameters
load_rom_variables
init_BUILDd
init_ROOMd
cd $BUILDd
load_roomservice

echo 'Begin rom build'


