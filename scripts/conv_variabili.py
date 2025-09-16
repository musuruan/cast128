#!/usr/bin/python3

fi = open("V.dump", "rb")
fo = open("v", "wb")

while True:
    b = fi.read(1)
    if not b:
        break
    d = b[0]
    
    if d > 127:
        d = d & 127

    b = d.to_bytes(1)
    fo.write(b)

fi.close()
fo.close()

