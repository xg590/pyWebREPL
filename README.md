## pyWebREPL
* The libarary will enable remote control of ESP8266 dev board. 
* One can push MicroPython code to a ESP8266 wirelessly and run it in a real time manner.
## Mechanism
* An ESP8266 dev board will be flashed with MicroPython firmware
* Enable the board's WebREPL feature so one can get MicroPython prompt via a webservice
* Join the board to a wireless local area network
* At this moment, there is only a broswer client to talk to the webservice 
* This library provide a Python client to talk to the webservice
## More Deeper
* The webservice uses the websocket protocol 
* This Python library converts your MicroPython code into websocket frames
* Frames are sent to the webservice then MicroPython code will be executed in real time.
## Materials
* ESP8266 dev board
* A Linux with Python 3
* WiFi router
## Procedure
... ...
