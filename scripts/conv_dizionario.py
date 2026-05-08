#!/usr/bin/python3

import petconv

fi = open("R.dump", "rb")
fo = open("r", "wb")

fo.write(b'\x00')
fo.write(b'\xd8')

fi.seek(2048) # $d800
while (True):
    d = fi.read(1)
    if not d:
        break
    d = ord(d.decode("ISO-8859-1"))
    if d == 255:
        break
    if d >= 128:
        # decripta il dato
        d = 253 - d # 125-(c-128)

        # converte in PESCII
        d = petconv.asc_to_pet_b(d)

        # cripta di nuovo il dato
        d = 253 - d

        b = d.to_bytes(1)
        fo.write(b)

        tp = fi.read(1)
        fo.write(tp)
        co = fi.read(1)
        fo.write(co)
    else:
        d = 125-d
        # questo blocco si può mettere in una procedura
        d = petconv.asc_to_pet_b(d)
        d = 125 - d
        b = d.to_bytes(1)
        fo.write(b)

fi.close()
fo.close()

