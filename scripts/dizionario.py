#!/usr/bin/python3

f = open("R.dump", "rb")
f.seek(2048) # $d800
while (True):
    d = f.read(1)
    if not d:
        break
    d = ord(d.decode("ISO-8859-1"))
    if d == 255:
        break
    if d >= 128:
        d = 253 - d # 125-(c-128)
        print(chr(d))
        tp = f.read(1)
        print("TP", int.from_bytes(tp))
        co = f.read(1)
        print("CO", int.from_bytes(co))
    else:
        d = 125-d
        print(chr(d), end='')
#print(f.tell())        # 8235 = $F82b
f.close()

