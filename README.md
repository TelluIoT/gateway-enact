
## 1. Initial setup

#### Hardware
The hardware for the gateway is:

* A Raspberry Pi 3 (OR a Compulab IOT-GATE-RPI)
* An Arduino UNO connected via USB
* One or more Ruuvi sensors
* A USB GPS (optionnal)


#### Software

##### Install the latest Raspbian image
 * Raspbian image can be downloaded from https://www.raspberrypi.org/downloads/raspbian/

 * SD card is flashed with image "2020-02-13-raspbian-buster-lite.img" usind dd or [Etcher](https://etcher.io): 
 
   `sudo dd bs=4M if=2020-02-13-raspbian-buster-lite.img of=/dev/sdXXX conv=fsync`

* Enable the ssh server by writing a file called ssh in /boot on the SD card to avoid the need for a keyboard/screen. See https://raspberrypi.stackexchange.com/questions/1747/starting-ssh-automatically-at-boot-time.

* Add a "wpa_supplicant.conf" file if you want the pi to connect to a wifi instead of using ethernet.
```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=NO
network={
    ssid="WIFI_SSID"
    psk="WIFI_PASS"
    # Protocol type can be: RSN (for WPA2) and WPA (for WPA1)
    proto=RSN

    # Key management type can be: WPA-PSK or WPA-EAP (Pre-Shared or Enterprise)
    key_mgmt=WPA-PSK

    # Pairwise can be CCMP or TKIP (for WPA2 or WPA1)
    pairwise=CCMP

    #Authorization option should be OPEN for both WPA1/WPA2 (in less commonly used are SHARED and LEAP)
    auth_alg=OPEN

    # For hidden SSID
    scan_ssid=1
}
```

* Put the SD card in the RPI3, connect Power (and Network) and let it boot.

##### Find the IP address of the Raspberry pi and save it in an Ansible inventory.

 * Use your router DHCP list of connected devices (the hostname is raspberrypi), nmap or similar.
 * Create an the Ansible Inventory file using the following template (replace `GATEWAY_HOSTNAME` and `LOCAL_IP_ADDRESS`).

```yaml
   gateways:
       hosts:
           GATEWAY_HOSTNAME:
               ansible_ssh_host: LOCAL_IP_ADDRESS
       vars:
           ansible_become: yes
           ansible_ssh_user: pi
           ansible_ssh_private_key_file: ./private-files/ssh-private-key
           ansible_ssh_pass: raspberry
```
   
   
Example (file `inventory_lan.yaml`):

```yaml
gateways:
    hosts:
        ENACT001:
            ansible_ssh_host: 192.168.1.170
    vars:
        ansible_become: yes
        ansible_ssh_user: pi
        ansible_ssh_private_key_file: ./private-files/ssh-key-gateway-enact
        ansible_ssh_pass: raspberry
```

##### Install Ansible and its plugins

Ansible is used both for the initial setup of the gateway and for the deployment of the Tellu components.

 * Install Ansible on your local system [following the official instructions.](http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-apt-ubuntu)
 * Install the plugins

```bash
   ansible-galaxy install ANXS.hostname
   ansible-galaxy install geerlingguy.firewall
   ansible-galaxy install geerlingguy.docker
   ansible-galaxy install geerlingguy.pip
   ansible-galaxy install dev-sec.ssh-hardening
```

## 3. Initial setup of the gateway 

List the gateways to be setup in an inventory file (for example `inventory_lan.yaml`). The following command will update the OS on the gateway, install all dependencies and setup the configuration for the tellu components.

```bash
   cd ansible
   ansible-playbook -i inventory_lan.yaml 1-initial-provisioning.yaml
```

## 3. Building the code

The code for the different components is in the src directory. For building the code a version number should be provided in `build_version.txt` then can `./build_all.sh`. This will generate C code for all the ThingML components and create a redy to deploy distribution archive in `ansible/releases`.

## 4. Deploying a specific release


* Set the desired version number in `ansible/public-files/gateway_version.yaml` (it must be available in `ansible/releases`)

*  Deploy release using ansible: 

```bash
   cd ansible
   ansible-playbook -i inventory_lan.yaml 2-deploy-software.yaml
```


## 5. Check what is running

* Access the MQTT broker (TCP on port 1883 or websocket on port 9001). All the inter-component communication is visible.
* Access Prometheus UI: http://192.168.1.170:9090/
* Prometeus Exporter: http://192.168.1.170:8086/

## 6. Adding a coimmand to the Arduino:

This commit provides an example to add a basic actuation command to the arduino:

https://github.com/TelluIoT/gateway-enact/commit/cd5f730c5a411faf9b95d60a2135654eb58d3e08
