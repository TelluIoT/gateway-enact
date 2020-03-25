#!/bin/bash

# Prepare the sources to be built in a tmp directory
# and substitute version number

# Abort and exit if any command fails
set -e


###########################################################
# Take a copy of the sources in the build directory
###########################################################
cp -r src build-tmp


###########################################################
# Replace version number in all source files
# Any file containing the tag __NO_BUILD_VERSION__
###########################################################

buildversion=`cat build_version.txt`

echo "Build version is $buildversion"


egrep -lRZ '__NO_BUILD_VERSION__' build-tmp | xargs -0 -l sed -i -e 's/__NO_BUILD_VERSION__/'"$buildversion"'/g'


echo "[PREPARE: SUCCESS]"
