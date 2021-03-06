import struct, socket 
from random import randint

class WEBREPL:
    def upgrade_http_to_websocket(self):
        frw = self.s.makefile("rwb", 0)
        frw.write(b"""GET / HTTP/1.1\r\nHost: echo.websocket.org\r\nConnection: Upgrade\r\nUpgrade: websocket\r\nSec-WebSocket-Key: foo\r\n\r\n""")  
        while True:
            l = frw.readline() 
            if l == b'\r\n': break  
            # Response = '''HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: BM0S0+ghftShuFVHQATK/DBiJq8=\r\n\r'''
    
        buf = b''
        while 1:
            c = self.s.recv(1)
            buf += c
            if c == b':': 
                self.s.recv(1)
                break 
    
    def send(self, payload): 
        l = len(payload)
        if l > 125: raise 
        key = [randint(0, 255),randint(0, 255),randint(0, 255),randint(0, 255)]
        masked_payload = [ord(c)^key[i%4] for i, c in enumerate(payload) ]
        frame = struct.pack(f">{6+l}B", 0b10000001, 0b10000000 | l, *key,  *masked_payload) 
        self.s.send(frame)
        
    def recv(self): 
        buf = b''
        while True:
            _ = self.s.recv(1) 
            assert _ == b'\x81' # Fin + reserve + OpCode
            l = ord(self.s.recv(1))
            buf += self.s.recv(l)    
            if buf[-4:]==b'>>> ':  
                return buf.decode()   
        
    def __init__(self, host='192.168.1.1', port=8266, password='123456'): 
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 
        self.s.connect((host, port))
        self.upgrade_http_to_websocket()
        self.send(password) 
        self.send('\r')
        print(self.recv())
        
    def close(self):
        self.s.send(struct.pack(f">6B", 0x88, 0x80, 0x00, 0x00, 0x00, 0x00)) 
