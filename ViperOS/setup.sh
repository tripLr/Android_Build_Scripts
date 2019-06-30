#!/bin/bash

# Script to Build and Upload ViperOS TRLTE
#Set Global Parameters
# call compile and define global outputs
. ~/bin/compile.sh
# call google drive folder variables
# to upload builds to google drive triplr.dev shared account
# do not publish file, internal use only
. ~/bin/gdrive_aliases.sh

# Set build and directory parameters

export ViperOSb='/home/triplr/android/ViperOS'
export ViperOSr='/home/triplr/android/ViperOS/.repo/local_manifests'


# trlte out
export ViperOStrlte='/home/triplr/OUT_DIR/ViperOS/target/product/trlte'
export kernelTR='/home/triplr/OUT_DIR/ViperOS/target/product/trlte/obj/KERNEL_OBJ/arch/arm/boot'

# tblte out
export ViperOStblte='/home/triplr/OUT_DIR/ViperOS/target/product/tblte'
export kernelTB='/home/triplr/OUT_DIR/ViperOS/target/product/tblte/obj/KERNEL_OBJ/arch/arm/boot'

# trlteduos out
export ViperOStrlteduos='/home/triplr/OUT_DIR/ViperOS/target/product/trlteduos'
export kernelTD='/home/triplr/OUT_DIR/ViperOS/target/product/trlteduos/obj/KERNEL_OBJ/arch/arm/boot'

# copy finished compiles to internal RAID storage on server

export sharedTR='/home/shared/triplr/builds/ViperOS_trlte'
export sharedTB='/home/shared/triplr/builds/ViperOS_tblte'
export sharedTD='/home/shared/triplr/builds/ViperOS_trlteduos'

# build aliases  

alias REPO='repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags'
alias build='. $ViperOSb/build/envsetup.sh'


#begin case function to make clean all devices in repo

#input in entery string or ask ?
  
    #  $1 build.sh -c --clean  
    #  $1 build.sh -i --incremental do nothing incremental
    #  $1 build.sh -d --device $2 device name required or error 
    #  $1 build.sh -a --all         


