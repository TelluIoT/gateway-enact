This folder contains the code for the bluetooth medical gateway running as a system service.

## Files

 * `tryggi3d-bluetooth.service` contains the service description and instructions to deploy and start the service.

 * `BPSensorGateway.thingml` is the ThingML code for the service

 * `lib` folder contains the ThingML BLE library. 

**IMPORTANT: The lib should not be modified here, it comes from https://github.com/ffleurey/ThingML-BLEGateway**

## How to compile
Using the ThingML Posix Compiler on file `BPSensorGateway.thingml`. The generated code can be found in `Tryggi3D/thingml-gen/posix/BPSensorGateway/BPSensorGateway`

The generated code has to be compiled on the RPI3 and requires libbluetooth and libmosquitto:
 * `sudo apt-get install libbluetooth-dev`
 * `sudo apt-get install libmosquitto-dev`

## MQTT Setup
The code assumes that the MQTT broker is running on host "tryggi3d". Can be changed in `BPSensorGateway.thingml`.

Messages are published on topic `tryggi3d/speech` and provide the status for the gateway and connection status with the sensor in addition to the measurement itself. When a measurement is sent, the format of the message is:

`{"bpsensor_measurement":{"PressureSystolic":124,"PressureDiastolic":82,"PressureMean":99,"PulseRate":74,"IrregularPulse":0}}`

## Pairing of the Blood Pressure Sensor
The model for the supported BP sensor is: A&D UA-651BLE

The Bluetooth MAC address of the device (which can be found under the device) has to be put in the configuration part at the bottom of `BPSensorGateway.thingml`:

 `set main.BPAddress = "5C:31:3E:5F:4A:5C"`
 
 Pairing has to be done once on the command line using the `bluetoothctrl` tool and with the sensor in pairing mode (Long Press on the START button).
 
 ```
pi@TelluGW:~/test $ sudo bluetoothctl 
[NEW] Controller B8:27:EB:55:01:D4 TelluGW [default]
[bluetooth]# power on
Changing power on succeeded
[bluetooth]# agent on
Agent registered
[bluetooth]# default-agent 
Default agent request successful
[bluetooth]# scan on
Discovery started
[NEW] Device 5C:31:3E:5F:4A:5C A&D_UA-651BLE_5F4A5C
[bluetooth]# scan off
Discovery stopped
[bluetooth]# connect 5C:31:3E:5F:4A:5C
Attempting to connect to 5C:31:3E:5F:4A:5C
[CHG] Device 5C:31:3E:5F:4A:5C Connected: yes
Connection successful
Request authorization]# 
[agent] Accept pairing (yes/no): yes
[...]
[CHG] Device 5C:31:3E:5F:4A:5C ServicesResolved: yes
[CHG] Device 5C:31:3E:5F:4A:5C Paired: yes
[A&D_UA-651BLE_5F4A5C]# disconnect
[...]
 ```

 
