#!/bin/bash

# Get the latest version of the thingml compiler (snapshot!!!).
# TODO: We should really use a released version to avoid issues

# Abort and exit if any command fails
set -e

###########################################################
# Download the thingML compiler if any newer version is available
###########################################################
wget -N http://thingml.org/dist/ThingML2CLI.jar



# Generate the MQTT serialization adapter
java -jar ThingML2CLI.jar -t posixmqttjson -s src/3_CloudAgent/CloudAgentMsgs.thingml


###########################################################
# Compile 4_BLEGateway
###########################################################

# Generate the MQTT serialization adapter
java -jar ThingML2CLI.jar -t posixmqttjson -s src/4_BLEGateway/BLEGatewayPorts.thingml

# Compile to Posix
java -jar ThingML2CLI.jar -c posix -s src/4_BLEGateway/BLEGateway.thingml -o thingml-gen/posix/BLEGateway


###########################################################
# Compile 5_GPS
###########################################################

# Generate the MQTT serialization adapter
java -jar ThingML2CLI.jar -t posixmqttjson -s src/5_GPS/GPSPorts.thingml

# Compile to Posix
java -jar ThingML2CLI.jar -c posix -s src/5_GPS/GPSDClient.thingml -o thingml-gen/posix/GPSDClient

###########################################################
# Compile 6_Sensor
###########################################################

# Compile to Arduino
java -jar ThingML2CLI.jar -c arduino -s src/6_Sensor/Sensor.thingml -o thingml-gen/arduino/DummySensor

###########################################################
# Compile 7_SensorBridge
###########################################################

# Generate the MQTT serialization adapter
java -jar ThingML2CLI.jar -t posixmqttjson -s src/7_SensorBridge/SensorBridgeMsgs.thingml

# Compile to Posix
java -jar ThingML2CLI.jar -c posix -s src/7_SensorBridge/SensorBridge.thingml -o thingml-gen/posix/SensorBridge

###########################################################
# Compile 8_NetworkAgent
###########################################################

# Compile to Posix
java -jar ThingML2CLI.jar -c posix -s  src/8_NetworkAgent/NetworkAgent.thingml -o thingml-gen/posix/NetworkAgent

###########################################################
# Compile 9_Prometheus
###########################################################

# Compile to Posix
java -jar ThingML2CLI.jar -c posix -s  src/9_Prometheus/Prometheus.thingml -o thingml-gen/posix/Prometheus
cp src/9_Prometheus/uthash.h thingml-gen/posix/Prometheus

echo "[THINGML: SUCCESS]"
