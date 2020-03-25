#!/bin/sh

# Abort and exit if any command fails
set -e

sh build_clean.sh
sh build_prepare.sh
sh build_thingml.sh
sh build_firmware.sh
sh build_package.sh

echo "[ALL: SUCCESS]"
