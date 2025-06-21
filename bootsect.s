.segment "DISKHDR"

	.byte "CBM"     ; magic number for boot sector
	.addr $0000     ; address to load chained blocks to
	.byte $00       ; bank to load chained blocks to
	.byte $00       ; number of chained blocks to load
	.asciiz "AVVENTURA NEL CASTELLO"    ; name for "BOOTING ..." message
	.asciiz ""      ; don't load a .PRG

start:	ldx #<cmd-1	; Lo-byte of cmd - 1
	ldy #>cmd	; Hi-byte of cmd
	jmp $afa5	; Execute BASIC command.

cmd:	.byte "RUN"	; RUN"CAST"
	.byte $22
	.byte "CAST"
	.byte $22

