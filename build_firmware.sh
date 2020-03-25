#!/bin/sh

# Arduino IDE needs to be installed. Here it is in /opt/arduino/arduino.
# Could make a script to install it in a tmp place but we will probably use a container.
#
#

# Abort and exit if any command fails
set -e

/opt/arduino/arduino --board arduino:avr:uno --verify --pref build.path=thingml-gen/arduino/DummySensor/ thingml-gen/arduino/DummySensor/DummySensor/DummySensor.ino 


echo "[FIRMWARE: SUCCESS]"