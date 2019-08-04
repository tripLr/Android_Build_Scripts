#!/bin/bash
# AEX			repo init --depth=1 -u git://github.com/AospExtended/manifest.git -b 9.x
# AOKP			repo init --depth=1 -u https://github.com/AOKP/platform_manifest.git -b pie
# LineageOS		repo init --depth=1 -u git://github.com/LineageOS/android.git -b lineage-16.0
# Pixel Expierence	repo init --depth=1 -u https://github.com/PixelExperience/manifest -b pie
# ViperOS		repo init --depth=1 -u https://github.com/ViperOS/viper_manifest.git -b pie
# xenon 		repo init --depth=1 -u https://github.com/TeamHorizon/platform_manifest.git -b p

export BUILDd=~/android/AEX
export ROOMd=~/android/AEX/.repo/local_manifests
#

if 
   [ ! -d $ROOMd ];
      then
    	mkdir -pv $ROOMd ;
	cd $BUILDd ;
		
         else
    echo ' roomservice dir exists ' 
fi

