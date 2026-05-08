#!/usr/bin/python3

import petconv

fi = open("L.dump", "rb")
fo = open("l", "wb")

# Legge indice
index = fi.read(30+63*6-1)
for b in index:
    # converte da Apple II a ASCII
    d = b & 127
    b = d.to_bytes(1)
    fo.write(b)

while True:
    b = fi.read(1)
    if not b:
        break
    d = b[0]
    
    # converte da Apple II a ASCII
    d = d & 127
    
    if d != 13:
        # decripta il dato
        d = 158 - d

        # converte in PESCII
        d = petconv.asc_to_pet_b(d)
    
        # cripta di nuovo il dato
        d = 158 - d
    
    b = d.to_bytes(1)
    fo.write(b)
    
fi.close()
fo.close()

