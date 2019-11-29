#!/bin/bash
# AEX			repo init --depth=1 -u git://github.com/AospExtended/manifest.git -b 9.x
# AICP			repo init --depth=1 -u https://github.com/AICP/platform_manifest.git -b p9.0
# AOKP			repo init --depth=1 -u https://github.com/AOKP/platform_manifest.git -b pie
# LineageOS		repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-16.0
# Pixel Expierence	repo init --depth=1 -u https://github.com/PixelExperience/manifest -b pie
# ViperOS		repo init --depth=1 -u https://github.com/ViperOS/viper_manifest.git -b pie
# xenon 		repo init --depth=1 -u https://github.com/TeamHorizon/platform_manifest.git -b p

export BUILDd=~/android/9/AICP
export INITd=$BUILDd/.repo
export ROOMd=$BUILDd/.repo/local_manifests
export manifest='https://github.com/AICP/platform_manifest.git -b p9.0'

# check to see if build dir exists if not create
if [ ! -d $BUILDd ] ;
	then
		mkdir -pv $BUILDd ;
	else
		echo '$BUILDd exists'
fi


# check to see if manifest .repo exists, if not create, init, and sync
if 
   [ ! -d $INITd ];
	then
		cd $BUILDd ;
		repo init --depth=1 -u	$manifest
		repo sync -c -j16 --force-sync --no-clone-bundle --no-tags	;
		echo "REPO init and sync complete"		
     	else
    		echo '$INITd exists ' 
fi

# check to see if roomservice dir exists if not , create
if 
   [ ! -d $ROOMd ];
      then
    	mkdir -pv $ROOMd ;
	cd $BUILDd ;
         else
    echo '$ROOMd dir exists ' 
fi

# change to build dir, and prepare to build
cd $BUILDd
pwd


