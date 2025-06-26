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
	
v.seq: V.txt
	unix2mac -n V.txt v.seq
	
# TODO: Convertire logo

# TODO: Convertire file dati

cast128.d64: bootsect cast.prg intro.prg filer.prg game.prg v.seq
	c1541 -format "cast128,ac" d64 cast128.d64
	c1541 -attach cast128.d64 -bwrite bootsect 1 0
	c1541 -attach cast128.d64 -write cast.prg cast
	c1541 -attach cast128.d64 -write intro.prg intro
	c1541 -attach cast128.d64 -write filer.prg filer
	c1541 -attach cast128.d64 -write game.prg game
	c1541 -attach cast128.d64 -write v.seq v,s

clean:
	rm -f bootsect
	rm -f *.o
	rm -f *.prg *.seq
	rm -f cast128.d64

