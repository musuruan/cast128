#!/usr/bin/python3

f = open("M.dump", "rb")
m = 1
while (m<=218):
    print(m)
    f.seek(30+m*6)
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
    while i1<i2:
        b = f.read(1)
        i1 = i1+1
        d = b[0]
    
        # converte da Apple II a ASCII
        d = d & 127
        
        if d > 29:
            d = 156 - d
            print(chr(d), end='')
        if d == 13:
            print()
        if d == 14:
            # Normal
            print("\033[27m\033[0m", end='')
        if d == 9 or d == 6:
            # Inverse/Flash-Inverse
            print("\033[7m", end='')
        if d == 15:
            # Morto
            print("MOOOORTO!!!")
        if d == 16:
            # More (bisogna premere un tasto per andare avanti)
            print("\n>> ")
        if d == 25:
            print("DELAY: ", end='')
        if d == 12:
            print("VAI A LUOGO: ", end='')
        if d == 19:
            print("RITARDO STAMPA: ", end='')

        if d == 25 or d == 12 or d == 19:
          while d != 13:
                b = f.read(1)
                i1 = i1+1
                d = b[0]
                d = d & 127
                if d != 13:
                    print(chr(d), end='')

    print()
    m=m+1
f.close()
