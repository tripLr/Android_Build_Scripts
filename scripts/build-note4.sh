#!/bin/bash
echo "triplr note4 build all "
export ScriptD=~/github/triplr/Build_Scripts
./$ScriptD/XENON/*build.sh  
./$ScriptD/AEX/*build.sh
./$ScriptD/AICP/*build.sh
#./$ScriptD/AOKP/*aokp-build.sh
./$ScriptD/Pixel/*build.sh
./$ScriptD/VIPER/*build.sh
echo "build all successful"

