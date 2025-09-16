#!/usr/bin/python3

f = open("L.dump", "rb")
lu = 1
while (lu<=61):
    print(lu)
    f.seek(30+lu*6)
    data = f.read(12)
    string = ""
    for d in data:
        # converte da Apple II a ASCII
        d = d & 127
        string = string + chr(d)
    i = string.splitlines()
    i1 = int(i[0])
    i2 = int(i[1])
    print(i1,i2)
    f.seek(i1)
    data = f.read(i2-i1)
    for d in data:
        # converte da Apple II a ASCII
        d = d & 127
        if d != 13:
            d = 158-d

        if d == 13:
            print()
        else:
            print(chr(d), end='')
    lu=lu+1
    print()
f.close()

