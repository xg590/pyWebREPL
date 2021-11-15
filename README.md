## Follow this section and skip others if you only want blink ESP8266 over WiFi.
* Tested with a Linux PC (Rasberry Pi 3A) and a D1 mini (ESP8266).
* Use a USB cable to connect the ESP8266 to the Raspberry Pi
* Programm ESP8266 on Raspberry Pi with following code
```
sudo apt update && sudo apt install python3 python3-pip
pip install esptool
git clone https://github.com/xg590/pyWebREPL.git
cd pyWebREPL
wget https://micropython.org/resources/firmware/esp8266-20210902-v1.17.bin
```
* \# Connect ESP8266 to WiFi after it is flashed with MicroPython and WebREPL is enabled
```
bash misc/flash.sh ttyUSB0 giveESP8266aName [wifi_ssid] [wifi_passwd]
tail -n4 flash.log
```
* \# Command tail will tell us what IP is given by WiFi router to the ESP8266 board
* \# Blink ESP8266
```
python3 example/blink.py [192.168.x.xxx]
``` 
## pyWebREPL
* This is a reverse-engineering work (Wireshark and Chrome Devtools) of [micropython/webrepl](https://micropython.org/webrepl/).
* This Python library will enable remote control of ESP8266 dev board by pushing MicroPython code from PC/Mac/Raspberry Pi to ESP8266 wirelessly.
<img src="misc/materials.png"></img>
## Mechanism
* Run command on Raspberry Pi to flash the ESP8266 dev board with MicroPython firmware.
* Run command on Raspberry Pi to enable MicroPython's WebREPL feature so one can get the MicroPython prompt via a webservice
* Run command on Raspberry Pi to join ESP8266 to a router (wireless local area network)
* At this moment, there is only a broswer client for Raspberry Pi to talk to the webservice on ESP8266
* This library provide a Python client for Raspberry Pi to talk to the webservice
## More Deeper
* The webservice uses the websocket protocol 
* This Python library for Raspberry Pi converts the MicroPython code into websocket frames
* Frames are sent to the webservice then MicroPython code will be executed on ESP8266 in real time.
## Material List
* ESP8266 dev board
* Raspberry Pi (OR any Linux)
* WiFi router (Pi is already connected to this router)
## ESP8266 blink test with above materials
* Hook ESP8266 up with Raspberry Pi (or Linux PC) so ESP8266 appears as /dev/ttyUSB0
```
wget https://micropython.org/resources/firmware/esp8266-20210902-v1.17.bin
```
* Install ESPtool on Raspberry Pi
```
pip install esptool
```
* Flash EPS8266 with MicroPython Firmware [esp8266-20210902-v1.17.bin](https://micropython.org/download/esp8266/)
```
esptool.py --port /dev/ttyUSB0               erase_flash
esptool.py --port /dev/ttyUSB0 --baud 460800 write_flash --flash_size=detect 0 esp8266-20210902-v1.17.bin
screen /dev/ttyUSB0 115200
```
<img src="misc/flash_micropython_to_esp8266.png"></img>
* Enable WebREPL and Join ESP8266 to WiFi router
```
import webrepl_setup 
import network 
wlan = network.WLAN(network.STA_IF)
wlan.active(True)
# wlan.config(dhcp_hostname="IwantThisHostname") 
wlan.connect('xxx', 'xxxxxx')
wlan.ifconfig()
```
<img src="misc/enable_webrepl.png"></img>
* Run this [Python code](misc/pyWebREPL_blink.ipynb) on Raspberry Pi to blink ESP8266 
