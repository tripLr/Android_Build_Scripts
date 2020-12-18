#!/bin/bash

manifests='../ROM_MANIFESTS/manifests.sh'
if 
	[ -f $manifests ];
		then
			echo 'Loading Rom Manifests';
			cat $manifests ;
			. $manifests ;
		else
			echo 'manifests.sh does not exist';
			
fi
			 

export BUILDd=~/android/PEplus-11.x
export INITd=$BUILDd/.repo
export ROOMd=$BUILDd/.repo/local_manifests

if 
   [ ! -d $INITd ];
   	then
	mkdir -pv $INITd;
	cd $BUILDd ;
	repo init --depth=1 -u $initPixelPlus ;
	repo sync -c -j32 --force-sync --no-clone-bundle --no-tags	;
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


