#!/bin/bash
if [[ -z $2 ]] ; then
                echo "Hostname the ESP8266 !"; exit;
fi

tty=$1
dhcp_hostname=$2
bin=$3
wifi_ssid=$4
wifi_passwd=$5
esptool.py --port $tty               erase_flash || exit
esptool.py --port $tty --baud 460800 write_flash --flash_size=detect 0 $bin

screen -L -Logfile flash.log -d -m -S esp8266 $tty 115200
sleep 5
screen -S esp8266 -X stuff "^M"
screen -S esp8266 -X stuff "import webrepl_setup ^M"
screen -S esp8266 -X stuff "E^M"
screen -S esp8266 -X stuff "123456^M"
screen -S esp8266 -X stuff "123456^M"
screen -S esp8266 -X stuff "y^M"
sleep 5
screen -S esp8266 -X stuff "^M"
screen -S esp8266 -X stuff "import network ^M"
screen -S esp8266 -X stuff "wlan = network.WLAN(network.STA_IF) ^M"
screen -S esp8266 -X stuff "wlan.active(True) ^M"
screen -S esp8266 -X stuff "wlan.config(dhcp_hostname='$dhcp_hostname') ^M"
screen -S esp8266 -X stuff "wlan.connect('$wifi_ssid', '$wifi_passwd') ^M"
sleep 10
screen -S esp8266 -X stuff "wlan.ifconfig() ^M"
screen -S esp8266 -X stuff "^M"
screen -S esp8266 -X quit