100  rem <ctrl-j><ctrl-j><ctrl-j># starter #<ctrl-j><ctrl-j>
110  rem per prove castello<ctrl-j>
120  rem (c) dinosoft 1984-2001
130  rem by enrico colombini
140  rem <ctrl-j><ctrl-j>set basic base<ctrl-j>
150  if  peek(104) < >64  then  poke 104,64: poke 16384,0: print  chr$(4)"run cast"
160  print  chr$(4)"maxfiles 2"
170 d$ =  chr$(4)
180  rem <ctrl-j><ctrl-j>load b,logo<ctrl-j>
190  print d$"bload b, a$800"
200  print d$"bload logo, a$2000"
210  rem <ctrl-j><ctrl-j>ready<ctrl-j>
220  print d$"run intro"