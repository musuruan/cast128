100  rem # starter #
110  rem per prove castello
120  rem (c) dinosoft 1984-2001
130  rem by enrico colombini
140  rem set basic base
150  if  peek(104) < >64  then  poke 104,64: poke 16384,0: print  chr$(4)"run cast"
160  print  chr$(4)"maxfiles 2"
170 d$ =  chr$(4)
180  rem load b,logo
190  print d$"bload b, a$800"
200  print d$"bload logo, a$2000"
210  rem ready
220  print d$"run intro"
