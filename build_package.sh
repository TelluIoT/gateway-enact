#!/bin/sh

# Package all the code into a single archive to be placed as a Github release

# Abort and exit if any command fails
set -e

buildversion=`cat build_version.txt`

mkdir build-output
mkdir build-output/"$buildversion"

cp -r thingml-gen/posix/* build-output/"$buildversion"/

cp -r thingml-gen/arduino/DummySensor/DummySensor build-output/"$buildversion"/

cp thingml-gen/arduino/DummySensor/DummySensor.ino.hex build-output/"$buildversion"/DummySensor

cp thingml-gen/arduino/DummySensor/DummySensor_merged.thingml build-output/"$buildversion"/DummySensor

cd build-output

tar czvf "$buildversion".tar.gz "$buildversion"

cp "$buildversion".tar.gz ../ansible/releases/

echo "[PACKAGE: SUCCESS]"
