#!/bin/bash
# build all successful
echo "triplr note4 build all "
export ScriptD="~/github/triplr/Build_Scripts"
./$ScriptD/AEX/aex-build.sh
./$ScriptD/AICP/aicp-build.sh
./$ScriptD/AOKP/aokp-build.sh
./$ScriptD/Pixel/pixelexperience-build.sh
./$ScriptD/VIPER/viper-build.sh
./$ScriptD/XENON/xenon-build.sh  
