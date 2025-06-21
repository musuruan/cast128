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
	
# TODO: Convertire logo

# TODO: Convertire file dati

cast128.d64: bootsect cast.prg intro.prg filer.prg game.prg
	c1541 -format "cast128,ac" d64 cast128.d64
	c1541 -attach cast128.d64 -bwrite bootsect 1 0
	c1541 -attach cast128.d64 -write cast.prg cast
	c1541 -attach cast128.d64 -write intro.prg intro
	c1541 -attach cast128.d64 -write filer.prg filer
	c1541 -attach cast128.d64 -write game.prg game

clean:
	rm bootsect
	rm *.o
	rm *.prg
	rm cast128.d64

