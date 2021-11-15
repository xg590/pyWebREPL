import os, sys 
sys.path.append(os.getcwd())
from pyWebREPL import WEBREPL

webrepl = WEBREPL(host=sys.argv[1], password='123456')
 
code = '''
import time  
from machine import Pin  
PIN_BUILTIN_LED = 2 
p2 = Pin(PIN_BUILTIN_LED, Pin.OUT, value=1)   
p2.off()  # Turn on the on-board LED            
time.sleep(0.5) 
p2.on()   # Turn off the on-board LED   
'''

for cmd in code.splitlines():
    webrepl.send(cmd)
    webrepl.send('\r')
    print(webrepl.recv()) 
 
webrepl.close()
