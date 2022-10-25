## What is Automated in flash.sh
* Hook ESP8266 up with Raspberry Pi (or Linux PC) so ESP8266 appears as /dev/ttyUSB0
```
wget https://micropython.org/resources/firmware/esp8266-20220618-v1.19.1.bin
```
* Install ESPtool on Raspberry Pi
```
pip install esptool
```
* Flash EPS8266 with MicroPython Firmware [esp8266-20220618-v1.19.1.bin](https://micropython.org/download/esp8266/)
```
esptool.py --port /dev/ttyUSB0               erase_flash
esptool.py --port /dev/ttyUSB0 --baud 460800 write_flash --flash_size=detect 0 esp8266-20220618-v1.19.1.bin
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
