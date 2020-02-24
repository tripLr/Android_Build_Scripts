#!/bin/bash

#https://android.googlesource.com/platform/manifest/+/refs/tags/android-r-preview-1
#repo init -u https://android.googlesource.com/platform/manifest -b
export BUILDd=~/android/11/aosp
export INITd=$BUILDd/.repo
export ROOMd=$BUILDd/.repo/local_manifests
#

if 
   [ ! -d $INITd ];
   	then
	mkdir -pv $INITd;
	cd $BUILDd ;
	repo init --depth=1 -u https://android.googlesource.com/platform/manifest -b android-r-preview-1 ;
	repo sync -qc -j16 --force-sync --no-clone-bundle ;
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


