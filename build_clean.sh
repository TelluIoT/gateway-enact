#!/bin/sh

# cleanup any existing generated code and the temporary build directory

# Abort and exit if any command fails
set -e

rm -rf build-tmp
rm -rf build-output
rm -rf thingml-gen



echo "[CLEAN: SUCCESS]"
