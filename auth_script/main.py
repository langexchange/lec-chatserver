#!/usr/bin/python

import sys
import struct
import jwt
import os

jwt_secret = os.environ['JWT_KEY']

def read_from_stdin():
  ## Get size
  pkt_bsize = 0
  if hasattr(sys.stdin, 'buffer'):
    pkt_bsize = sys.stdin.buffer.read(2)
  else:
    pkt_bsize = sys.stdin.read(bytes)

  (pkt_size,) = struct.unpack('>H', pkt_bsize)

  return sys.stdin.read(pkt_size)

# def read_from_stdin_mock():
#     return input("Enter command: ")


def process_request():
    pkt = read_from_stdin()
    cmd = pkt.split(':')[0]
    if cmd == 'auth':
        u, _, p = pkt.split(':', 3)[1:]
        payload = {}
        try:
          payload = jwt.decode(p, jwt_secret, algorithms=["HS256"], options={
             "require":["exp", "iat"],
          })
        except:
          write(False)
          return
        
        # Validate user name in token against username which the user types in
        if "uname" not in payload or payload["uname"] != u:
           write(False)
           return
        
        write(True)
    elif cmd == 'isuser':
        write(True)
    else:
        write(False)

def write(result):
    if result:
        sys.stdout.write('\x00\x02\x00\x01')
    else:
        sys.stdout.write('\x00\x02\x00\x00')
    sys.stdout.flush()

# def write_mock(result):
#     print(result)
    


while(True):
    try:
        process_request()  
    except struct.error:
        pass
