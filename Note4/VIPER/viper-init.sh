#!/bin/bash
# AEX			repo init --depth=1 -u git://github.com/AospExtended/manifest.git -b 9.x
# AICP			repo init --depth=1 -u https://github.com/AICP/platform_manifest.git -b p9.0
# AOKP			repo init --depth=1 -u https://github.com/AOKP/platform_manifest.git -b pie
# LineageOS		repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-16.0
# Pixel Expierence	repo init --depth=1 -u https://github.com/PixelExperience/manifest -b pie
# ViperOS		repo init --depth=1 -u https://github.com/ViperOS/viper_manifest.git -b pie
# xenon 		repo init --depth=1 -u https://github.com/TeamHorizon/platform_manifest.git -b p

export BUILDd=~/android/9/VIPER
export INITd=$BUILDd/.repo
export ROOMd=$BUILDd/.repo/local_manifests
#

if 
   [ ! -d $INITd ];
   	then
	mkdir -pv $INITd;
	cd $INITd
	repo init --depth=1 -u https://github.com/ViperOS/viper_manifest.git -b pie ;
	repo sync -c --force-sync --no-clone-bundle --no-tags	;
	echo "REPO init and sync complete"		
         else
    echo ' repo dir exists ' 
fi

if 
   [ ! -d $ROOMd ];
      then
    	mkdir -pv $ROOMd ;
	cd $BUILDd ;
         else
    echo ' roomservice dir exists ' 
fi


