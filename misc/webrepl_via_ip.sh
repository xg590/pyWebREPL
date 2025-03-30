#!/bin/bash 
if [[ $# -eq 0 ]]
    then 
        echo bash $0 192.168.1.x
        exit
fi
cd $PWD/$(dirname "$0")
cd ..
python << EOF | cat
import sys
sys.path.append("$PWD")
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
 