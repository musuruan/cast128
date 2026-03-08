all: cast128.d64

bootsect: bootsect.s
	cl65 -C linker.cfg -t none -o bootsect bootsect.s	

cast.prg: cast.bas
	petcat -w70 -o cast.prg -- cast.bas
	
intro.prg: intro.bas
	petcat -w70 -o intro.prg -- intro.bas
	
filer.prg: filer.bas
	petcat -w70 -o filer.prg -- filer.bas
	
game.prg: game.bas
	petcat -w70 -o game.prg -- game.bas

r: R.dump ./scripts/conv_dizionario.py
	./scripts/conv_dizionario.py

b: B.s
	cl65 -t none -o b B.s
	
v: V.dump ./scripts/conv_variabili.py
	./scripts/conv_variabili.py
	
l: L.dump ./scripts/conv_luoghi.py
	./scripts/conv_luoghi.py
	
m: M.dump ./scripts/conv_messaggi.py
	./scripts/conv_messaggi.py

cast128.d64: bootsect cast.prg intro.prg filer.prg game.prg logo.koa r b v l m
	c1541 -format "cast128,ac" d64 cast128.d64
	c1541 -attach cast128.d64 -bwrite bootsect 1 0
	c1541 -attach cast128.d64 -write cast.prg cast
	c1541 -attach cast128.d64 -write intro.prg intro
	c1541 -attach cast128.d64 -write filer.prg filer
	c1541 -attach cast128.d64 -write game.prg game
	c1541 -attach cast128.d64 -write logo.koa logo
	c1541 -attach cast128.d64 -write r
	c1541 -attach cast128.d64 -write b
	c1541 -attach cast128.d64 -write v v,s
	c1541 -attach cast128.d64 -write l l,l,254
	c1541 -attach cast128.d64 -write m m,l,254

clean:
	rm -f bootsect
	rm -f *.o
	rm -f *.prg
	rm -f r b v l m
	rm -f cast128.d64

