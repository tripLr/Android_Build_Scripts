#!/bin/bash
#export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx128G"
#export _JAVA_OPTIOND="-XX:+UseStringCache"
#export _JAVA_OPTIONS="-Xms1g"
#export _JAVA_OPTIONS="-Xmx32g"
#export ANDROID_COMPILE_WITH_JACK=false

# note : /home/shared is a different drive than the build drive
# with ssd's this prevents lots of random writes to the ssd
# so with dual drive systems /home/username is on a ssd drive
# and CCACHE and OUT_DIR_COMMON_BASE is on another drive performance does not suffer on the server
export CCACHE_DIR=/cloud/raid1/triplr/.ccache
export CCACHE_EXEC=/usr/bin/ccache
export OUT_DIR_COMMON_BASE=/cloud/raid1/triplr/OUT_DIR
export shareD=/home/shared/triplr/builds
# test dir real
if 
   [ ! -d $shareD ];
         then
    mkdir -pv $shareD ;
    echo '$shareD created' ;
         else
    echo '$shareD exists ' 
fi


export LANG=C
export PATH=~/bin:$PATH
export USE_CCACHE=1
export USE_NINJA=true
export WITH_SU=false
. ~/bin/repo-update.sh
alias REPO='repo sync -qc -j16 --force-sync --no-clone-bundle --no-tags'

echo '~/bin/compile.sh Compile variables complete '

