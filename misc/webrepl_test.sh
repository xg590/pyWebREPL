#!/bin/bash 
python << EOF | cat
import sys
sys.path.append(".")
from pyWebREPL import WEBREPL
webrepl = WEBREPL(host="$1", password='123456') 
webrepl.send('''
import network 
wlan = network.WLAN(network.STA_IF)  
wlan.ifconfig() 
''')
print(webrepl.recv()) 
webrepl.close()
EOF
 