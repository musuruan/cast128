#!/usr/bin/python3

# TODO: Stampare le varie parti

f = open("V.dump", "rb")
while (data := f.read(1)):
    d = int.from_bytes(data, byteorder='little', signed=False)
    # converte da Apple II a ASCII
    d = d & 127

    if d == 13:
         print()
    else:
        print(chr(d), end='')
        
f.close()

