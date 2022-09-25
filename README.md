## pyWebREPL
* Forget about USB cable and /dev/ttyUSB0.
* Run this Python library on PC/Mac/Raspberry Pi to control ESP8266 remotely.
* This is a reverse-engineering work (Wireshark and Chrome Devtools) of [micropython/webrepl](https://micropython.org/webrepl/). 
<img src="misc/materials.png" width="450px" height="300px"></img>
## Follow this section and skip others if you only want blink ESP8266 over WiFi.
* Tested with a Linux PC (Rasberry Pi 3A) and a D1 mini (ESP8266).
* For one time, a USB cable is still necessary to connect ESP8266 with Raspberry Pi. 
* Run following commands on Raspberry Pi.
```
sudo apt update && sudo apt install python3 python3-pip
pip install esptool
git clone -b v1.1 https://github.com/xg590/pyWebREPL.git
cd pyWebREPL
wget https://micropython.org/resources/firmware/esp8266-20220618-v1.19.1.bin
bash misc/flash.sh /dev/ttyUSB0 myESP8266 esp8266-20220618-v1.19.1.bin [wifi_ssid] [wifi_passwd]
tail -n4 flash.log
```
* The last command tail will tell what IP is given by WiFi router to the ESP8266 board
* ESP8266 can already be detached with Raspberry Pi and powered by a separate USB charger. 
* Blink ESP8266 with pyWebREPL over WiFi.
```
python3 example/blink.py 192.168.x.xxx 
``` 
## Mechanism
* Flash the ESP8266 dev board with MicroPython firmware then one can get a MicroPython prompt.
* Enable MicroPython's WebREPL feature and join ESP8266 to a WiFi network so access the prompt can be accessed via a webservice.
* At this moment, there is only a [broswer client](https://micropython.org/webrepl/) for one  to talk to the webservice on ESP8266
* This library provide a Python client for Raspberry Pi to talk to the webservice
## More Deeper
* The webservice uses the websocket protocol 
* This Python library for Raspberry Pi converts the MicroPython code into websocket frames
* Frames are sent to the webservice then MicroPython code will be executed on ESP8266 in real time.
## Material List
* ESP8266 dev board
* Raspberry Pi (OR any Linux)
* WiFi router (Pi is already connected to this router)
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
## More about sending Nonprinting Characters
* In the MicroPython prompt, when we press <kbd>ctrl</kbd>+<kbd>e</kbd> (its caret notation is <kbd>^E</kbd>) on keyboard, we activate the paste mode. 
* If we refers to <i>Control code chart</i> of [ASCII](https://en.wikipedia.org/wiki/ASCII), we know <kbd>^E</kbd> is <kbd>"\x05"</kbd>, so we can activate the paste mode when we send b"\x05" via webREPL.
* Our code will be received in paste mode.