# Build_Scripts
Android Build Scripts for my Fedora Server 33 

Here is how it works,

call variables for compiling
call variables for upload directies from non-public file 

set varibles for the build
   paths to repo directories, 
   paths to output directories,
   path to compiled products to storage "shared" drives and folders

if not performed 
   repo init
      and initial Repo sync command
    
copy over roomservice from location, in this case my github
    repo sync

build device
compile 

generate filename variable with newly created file
copy compiled rom
              kernel
              md5sum
              log
       to shared drive
 
 upload rom
 
 Programming upgrades and project
 
 version 2 
 will build all the devices that have the same chipset, and upload ( which is what i am using )
 
 version 3 
 sets up functions for each upload or compile, rather than a list of things to do as in version 2
   plus add variable for clean or incremental build
  
 version 4 will be a single command line entry to build (device or all), -i -f (incremental or full)
     using the if then statement in line 14 above
     if a roomservice exists,
     
 version 5 will have complete command line only single entry like above, but with a setup conf file for any rom
    ( hopefully )
   
 

