.feature c_comments

MOVFRM = $7a85
PTRGET1 = $7b0b
FCERR = $7d28
AYINT = $84B4
JSRFAR = $ff6e
INDFET = $ff74
INDSTA = $ff77
BASIN = $ffcf
BSOUT = $ffd2
GETIN = $ffe4
CURSORON = $cd6f
CURSOROFF = $cd9f

VARNAM = $47
VARPNT = $49
BUF= $0200
IRQVEC =$0314

Src  = $fb
Dest = $fd

PICTURE = $6000
BITMAP = PICTURE
VIDEO = PICTURE+$1f40
COLOR = PICTURE+$2328
BACKGROUND = PICTURE+$2710

ME = $0240 ; 576-676?-765?
TP = $02fe ; 766
CO = $02ff ; 767
DIZ = $d800 ; in BANK1

Length = $fb
Text = Length + 1
ZPHELPADR = $fe

; sprite storage range between 3584 ($0e00) and 4095 ($0fff)
sprite0 = $0e00
sprite1 = sprite0 + 64
sprite2 = sprite1 + 64
sprite3 = sprite2 + 64
sprite4 = sprite3 + 64
sprite5 = sprite4 + 64
sprite6 = sprite5 + 64
sprite7 = sprite6 + 64

; Commodore Load Address
LOADADDR = $1300

.word LOADADDR
.org LOADADDR

u:
Koala:
	jmp _Koala
Diz1:
	jmp _Diz1	; RECOVERY/DIZ.1
Diz2:
	jmp _Diz2	; DIZ.2
GetChar:
	jmp _GetChar
Input:
	jmp _Input
Scroller:
	jmp _Scroller

_Koala:
; Select RAM 0 and IO
	lda #$3e
	sta $ff00

; Disable interrupts and Access Color RAM 0 from CPU
	sei
	lda $01
	pha
	and #%11111110
	sta $01

; Transfer Background color
	lda BACKGROUND
	sta $d021

; Transfer Video and Color
	ldy #$00
:
	; Transfers video data
	lda VIDEO,y
	sta $1c00,y
	lda VIDEO+$100,y
	sta $1d00,y
	lda VIDEO+$200,y
	sta $1e00,y
	lda VIDEO+$2e8,y
	sta $1ee8,y
	; Transfers color data
	lda COLOR,y
	sta $d800,y
	lda COLOR+$100,y
	sta $d900,y
	lda COLOR+$200,y
	sta $da00,y
	lda COLOR+$2e8,y
	sta $dae8,y
	iny
	bne :-

; Trasfer Bitmap
	lda #<BITMAP
	sta Src
	lda #>BITMAP
	sta Src + 1
	lda #<$2000
	sta Dest
	lda #>$2000
	sta Dest + 1
	ldx #$20	; X = number of bytes * 256
	ldy #$00
:
	lda (Src),y
	sta (Dest),y
	iny
	bne :-
	inc Src + 1
	inc Dest + 1
	dex
	bne :-

; Restore $01 and interrupts
	pla
	sta $01
	cli

; Select bank 15
	lda #$00
	sta $ff00

	rts

; RECOVERY/DIZ.1
_Diz1:
	jsr     ReadRAM		; Abilita la lettura nel BANK1
	jsr     L1883		; $(FC) -> $D800 (è in R) + Y = 0
L1814:  jsr     L188E		; $(FC) + y, y=0
	lda     ($FC),y
	cmp     #$FF
	bne     L1824		; Se il contenuto di $(FC),y è diverso da #$FF va a L1824
	lda     #$00
	sta     TP		; Mette 0 in TP
	beq     L1845		; Esce dalla routine
L1824:  lda     ($FC),y		; confronta $(FC),y con ME,y
	tax
	cmp     ME,y
	beq     :+		; se uguale va a L1833
	jsr     L189B		; cerca la fine della stringa
	iny			; y = y+2
	iny
	bne     L1814		; se y !=0 (sempre?) va a L1814
:	txa
	bmi     :+		; se il carattere in byte in esame è maggiore di 128 (fine parola) va a L1839
	iny			; y = y+1
	bne     L1824		; se y !=0 va a L1814
:	iny			; y = y+1
	lda     ($FC),y		; mette il contenuto di $(FC),y in TP
	sta     TP
	iny			; y = y+1
	lda     ($FC),y		; mette il contenuto di $(FC),y in CO
	sta     CO
L1845:  jmp     ReadROM		; Disabilita la lettura in RAM + rts

; DIZ.2
_Diz2:
	jsr     ReadRAM		; Abilita la lettura in RAM
	jsr     L1883		; $(FC) -> $D800 (è in R) + Y = 0
L184E:  jsr     L188E		; $(FC) + y, y=0
	lda     ($FC),y
	cmp     #$FF
	bne     :+		; Se il contenuto di $(FC),y è diverso da #$FF va a L185F
	lda     #$A0
	sta     ME		; Mette 160 (spazio) in ME
	jmp     L1880		; Esce dalla routine

:	jsr     L189B		; cerca la fine della stringa
	lda     ($FC),y		; legge TPx e lo mette nel registro X
	tax
	iny
	lda     ($FC),y		; legge COx
	iny
	cmp     CO		; lo confronta con il valore presente a 767
	bne     L184E		; se sono diversi va a L184E (esamina la prossima stringa)
	txa			; mette nell'accumulatore TPx
	cmp     TP		; lo confronta con il valore presente a TP
	bne     L184E		; se sono diversi va a L184E (esamina la prossima stringa)
	ldy     #$00		; trasferisce il cotenuto della stringa a 576
:	lda     ($FC),y
	sta     ME,y
	bmi     L1880		; se è l'ultimo carattere va a L1880
	iny
	bne     :-		; altrimenti va a L1976
L1880:  jsr     ReadROM		; disabilita la lettura nel BANK1
L1883:  lda     #<DIZ		;$(FC) punta all'inizio del dizionario
	sta     $FC
	lda     #>DIZ
	sta     $FD
	ldy     #$00		; y=0
	rts

L188E:  tya			; $(FC)+y; y=0
	clc
	adc     $FC
	sta     $FC
	bcc     :+
	inc     $FD
:	ldy     #$00
	rts

L189B:  lda     ($FC),y		; cerca la fine della stringa (ha un carattere maggiore o uguale a 128 su apple II)
	bmi     :+
	;and #$20
	;bne	:+
	iny
	bne     L189B
:	iny
	rts

; Torna alla configurazione standard
ReadROM:
	lda #$00
	sta $ff00
	lda #$04
	sta $d506
	rts

; primi 16k dal BANK0, il resto dal BANK1
; https://archive.org/details/transactor-magazines-v7-i04/page/n59/mode/2up
ReadRAM:
	lda #$07
	sta $d506
	lda #$7f
	sta $ff00
	rts

_GetChar:
	jsr CURSORON
:	jsr GETIN
	beq :-
	pha
	jsr CURSOROFF
	pla
	rts

_Input:
	; prende il valore di li (lunghezza massima della stringa)
	lda #$4c ; "l"
	sta VARNAM
	lda #$49 ; "i"
	sta VARNAM+1

	lda #15		; salva in VARPNT il descrittore della variabile li
	ldy #>PTRGET1
	ldx #<PTRGET1
	sta $02
	sty $03
	stx $04
	jsr JSRFAR
	
	lda VARPNT	; Copia la variabile in floating point il cui indirizzo è in A e Y in FAC1
	sta $06
	ldy VARPNT+1
	sty $08
	lda #15
	ldy #>MOVFRM
	ldx #<MOVFRM
	sta $02
	sty $03
	stx $04
	jsr JSRFAR

	lda #15		; Converte il valore in virgola mobile contenuto in FAC1 in un numero intero a due byte, il cui valore viene memorizzato nelle variabili $66 e $67.
	ldy #>AYINT
	ldx #<AYINT
	sta $02
	sty $03
	stx $04
	jsr JSRFAR

	lda $66		; Illegal quantity error se li > 255
	beq :+
	jmp FCERR
:	lda $67
	sta $fe		; salva la lunghezza in $fe

	ldx #0
	stx $fd
	; accetta a-z,sp,"'","-"
_InputLoop:
	jsr _GetChar
	cmp #13		; return
	beq Return
	cmp #20		; del
	beq Del
	cmp #32		; spazio
	beq Add
	cmp #39		; apostrofo
	beq Add
	cmp #45		; trattino
	beq Add
	cmp #64
	bcc _InputLoop
	cmp #91
	bcs _InputLoop
    	
Add:  
	ldx $fd		; se è stata raggiunta la lunghezza massima della stringa
	cpx $fe		; non fa inserire altri caratteri
	bcs _InputLoop
	sta BUF,x	; stampa il carattere premuto in maiuscolo
	cmp #64
	bcc :+
	cmp #91
	bcs :+
	ora #$80
:	jsr BSOUT
	inx		; aumenta la lunghezza inserita
	stx $fd
	jmp _InputLoop
	
Del:
	ldx $fd
	beq _InputLoop
	jsr BSOUT
	dex
	stx $fd
	jmp _InputLoop
	
Return:
	ldx $fd
	beq _InputLoop	; non esce se la stringa è lunga zero
	
	; stampa un CR (nell'accumulatore c'è ancora il carattere inserito)
	jsr BSOUT
	
	; riserva spazio per la stringa
	; e sposta la stringa dalla RAM0 alla RAM1

	ldx #<BUF	; indirizzo della stringa
	ldy #>BUF
	stx $70
	sty $71

	lda $fd		; lunghezza della stringa
	sta $06
	
	lda #15
	ldy #>$86cc
	ldx #<$86cc
	sta $02
	sty $03
	stx $04
	jsr JSRFAR
	
	; 63 è la lunghezza
	; ($64) è l'indirizzo della stringa sullo stack
	; ($66) ?

	; cerca "in$"
	; restituisce VARPNT che punta a un'area di memoria dove, il primo byte è la lunghezza, i successivi 2 sono un puntatore alle locazioni dove è la stringa nel BANK1
	lda #$49 ; "i"
	sta VARNAM
	lda #$ce ; "n" or 128
	sta VARNAM+1

	lda #15
	ldy #>PTRGET1
	ldx #<PTRGET1
	sta $02
	sty $03
	stx $04
	jsr JSRFAR
	
	; ora ($61) punta al descrittore della stringa
	; (VARPNT) punta alla stringa
	lda VARPNT
	sta $4b
	ldy VARPNT+1
	sty $4c
	
	; assegna una stringa alla variabile il cui indirizzo è memorizzato in ($4b)
	lda #15
	ldy #>$5405
	ldx #<$5405
	sta $02
	sty $03
	stx $04
	jsr JSRFAR

	rts

_Scroller:
	; disabilita IRQ BASIC
	lda #$01
	sta $12fd

	; Clear Sprites
	ldx #62
:	lda #$00
	sta sprite0,x
	sta sprite1,x
	sta sprite2,x
	sta sprite3,x
	sta sprite4,x
	sta sprite5,x
	sta sprite6,x
	sta sprite7,x
	dex
	bpl :-

	;*** Impostazione degli sprite
	;*** Calcolo dell'indirizzo di partenza
	ldx #sprite0/64
	stx $1ff8
	inx
	stx $1ff9
	inx
	stx $1ffa
	inx
	stx $1ffb
	inx
	stx $1ffc
	inx
	stx $1ffd
	inx
	stx $1ffe
	
	;*** Imposta la posizione Y per tutti gli sprite
	lda #234
	sta $d001
	sta $d003
	sta $d005
	sta $d007
	sta $d009
	sta $d00b
	sta $d00d
	
	;*** Imposta la posizione X per tutti gli sprite
	lda #$18
	sta $d000
	lda #$48
	sta $d002
	lda #$78
	sta $d004
	lda #$a8
	sta $d006
	lda #$d8
	sta $d008
	lda #$08
	sta $d00a
	lda #$38
	sta $d00c
	
	;*** Posizione X per gli sprite 5 e 6 > 255
	lda #%01100000
	sta $d010
	
	;*** Colore (bianco) per tutti gli sprite
	lda #$01
	sta $d027
	sta $d028
	sta $d029
	sta $d02a
	sta $d02b
	sta $d02c
	sta $d02d
	
	;*** I primi sette sprite...
	lda #%01111111
	sta $d01d                          ;raddoppiare in larghezza
	ldy #0
	sty $d017                          ; ma non in altezza
	sta $d015                          ;e infine rendere visibile

	; cerca "a$"
	lda #$41 ; "a"
	sta VARNAM
	lda #$80 ; 128 per stringa
	sta VARNAM+1

	lda #15
	ldy #>PTRGET1
	ldx #<PTRGET1
	sta $02
	sty $03
	stx $04
	jsr JSRFAR
	
	; Accesso alla stringa A$
	; bisogna usare https://cx16.dk/c128-kernal-routines/indfet.html
	; TODO: sicuramente ci sono delle locazioni migliori per memorizzare questi dati
	lda #VARPNT
	ldy #0
	ldx #1	; bank 1
	jsr INDFET
	sta Length

	iny
	lda #VARPNT
	ldx #1	; bank 1
	jsr INDFET
	sta Text

	iny
	lda #VARPNT
	ldx #1	; bank 1
	jsr INDFET
	sta Text+1
	
	sei                                ;disabilita IRQs
	lda #<rasterIrq                    ;Modifica vettore
	sta IRQVEC
	lda #>rasterIrq
	sta IRQVEC+1
	lda #%00000001                     ;Consenti IRQ raster
	sta $d01a
	lda #$7f                           ;Blocca Timer-IRQ
	sta $dc0d
	lda $d011                          ;cancellare il BIT più alto per la linea raster
	and #%01111111
	sta $d011
	lda #$ff                           ;linea desiderata per l'IRQ raster
	sta $d012
	cli                                ;riabilita IRQs
	
WaitKey:
	jsr GETIN
	beq WaitKey

	; Ripristina raster interrupt standard
	sei
	lda #<$fa65
	sta IRQVEC
	lda #>$fa65
	sta IRQVEC+1
	cli
	
	; Disabilita tutti gli sprites
	lda #%00000000
	sta $d015

	; Riabilita IRQ Basic
	lda #$00
	sta $12fd
	
	rts
	
;*** Raster-IRQ
rasterIrq:
	cld

	dec infotextBitPos                 ;sono già stati “spostati” 8 bit
	bpl shiftAll                       ;Se no, “spostare” tutti i dati sprite.
	lda #$07                           ;altrimenti azzerare il contatore
	sta infotextBitPos                 ;e poi prende il carattere successivo

	inc infotextPos                    ;aumenta il puntatore al carattere successivo
	ldy infotextPos                    ;e lo mette nel registro Y
	cpy Length			; è la fine del testo?
	bne :+

	ldy #$00                           ;se si, puntatore sul primo carattere
	sty infotextPos

	; carattere nell'accumulatore
:	lda #Text
	ldx #1	; bank 1
	jsr INDFET
	
	; converte il carattere da PETSCII a SCREEN CODE
	tax                      ; Transfer PETSCII value from A to X
	lda screen_code,x        ; Look up the screen code directly

fetchChar:
	sta ZPHELPADR		; mettiamo in ZPHELPADR il codice del carattere da recuperare
	lda #$00
	sta ZPHELPADR+1

	asl ZPHELPADR		; lo moltiplichiamo per 8 (ogni carattere occupa 8 byte)
	rol ZPHELPADR+1
	asl ZPHELPADR
	rol ZPHELPADR+1
	asl ZPHELPADR
	rol ZPHELPADR+1

	lda ZPHELPADR+1		; aggiungiamo $d800 per ottenere l'indirizzo del carattere nella Char-ROM (con i caratteri minuscoli)
	clc
	adc #$d8
	sta ZPHELPADR+1


; TODO: Magari c'è un modo più furbo per fare questa operazione
	ldy #$07                           ;Y-Reg. per l'indirizzamento indicizzato Y
:	
	ldx #14
	lda #ZPHELPADR                      ;un BYTE dalla Char-ROM
	jsr INDFET
	sta $0100,y			; mettiamo temporaneamente qui
	dey
	bpl :-
	
	ldy #$07
	ldx #$15
:
	lda $0100,y
	sta sprite7+2,x				;copiare completamente a destra in sprite7
	dex
	dex
	dex
	dey
	bpl :-

;*** Sposta i caratteri attraverso gli sprite
shiftAll:
	ldx #3*7                           ;una riga ha 3 byte; un carattere 8 righe
:
	asl sprite7+2,x                    ;ora “shifta” tutti i dati sprite
	rol sprite7+1,x                    ;Il flag C viene utilizzato per indicare l'eliminazione del
	rol sprite7,x                      ;Bit trasferito al byte di dati successivo
	rol sprite6+2,x
	rol sprite6+1,x
	rol sprite6,x
	rol sprite5+2,x
	rol sprite5+1,x
	rol sprite5,x
	rol sprite4+2,x
	rol sprite4+1,x
	rol sprite4,x
	rol sprite3+2,x
	rol sprite3+1,x
	rol sprite3,x
	rol sprite2+2,x
	rol sprite2+1,x
	rol sprite2,x
	rol sprite1+2,x
	rol sprite1+1,x
	rol sprite1,x
	rol sprite0+2,x
	rol sprite0+1,x
	rol sprite0,x
	dex                                ;ridurre tre volte il registro X
	dex                                ;poiché in alto abbiamo sempre tre BYTE alla volta
	dex                                ;'shifta'
	bpl :-                      ;finché positivo -> ripetere
	
	jmp $fa65	; Salta all'usuale routine di interrupt


infotextPos:                         ;Puntatore sul carattere corrente
 .byte $ff

infotextBitPos:
 .byte 0


.align 256

screen_code:
    .byte $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
    .byte $90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f
    .byte $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F
    .byte $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F
    .byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F
    .byte $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F
    .byte $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F
    .byte $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$5B,$5C,$5D,$5E,$5F
    .byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
    .byte $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20
    .byte $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6E,$6F
    .byte $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7A,$7B,$7C,$7D,$7E,$7F
    .byte $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F
    .byte $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5A,$5B,$5C,$5D,$5E,$5F
    .byte $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6E,$6F
    .byte $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7A,$7B,$7C,$7D,$7E,$5E

.align 256

m:
az:
	.byte   $88
og:
	.byte   $89
az_table:
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$01,$01
	.byte   $01,$01,$01,$01,$01,$01,$01,$01
	.byte   $02,$02,$02,$02,$02,$02,$02,$02
	.byte   $02,$02,$02,$03,$03,$03,$07,$07
	.byte   $07,$07,$0A,$0B,$0B,$0B,$0C,$0D
	.byte   $0E,$0F,$10,$10,$10,$10,$11,$11
	.byte   $11,$11,$11,$11,$11,$11,$12,$15
	.byte   $15,$15,$15,$16,$16,$16,$16,$16
	.byte   $16,$17,$17,$17,$19,$19,$19,$19
	.byte   $19,$1D,$21,$21,$21,$21,$21,$21
	.byte   $21,$22,$22,$24,$25,$2A,$2A,$2A
	.byte   $2A,$2C,$2C,$2C,$30,$30,$33,$35
	.byte   $35,$35,$35,$35,$35,$36,$39,$3B
	.byte   $3B,$3B,$3B,$3D,$3D,$3D,$3D,$3D
	.byte   $0C,$16,$19,$24,$0D,$1A,$64,$7A
	.byte   $76,$78,$7C,$84,$85,$86,$76,$22
	.byte   $7C,$66,$7D,$76,$7E,$7A,$20,$82
	.byte   $7A,$7A,$15,$18,$83,$81,$06,$1E
	.byte   $1F,$6E,$64,$6F,$79,$66,$1F,$71
	.byte   $01,$27,$27,$02,$05,$70,$71,$73
	.byte   $72,$66,$66,$02,$66,$66,$66,$1F
	.byte   $06,$72,$06,$04,$71,$76,$1F,$1F
	.byte   $1F,$1F,$01,$82,$7B,$83,$04,$66
	.byte   $74,$75,$75,$66,$27,$79,$05,$71
	.byte   $66,$72,$82,$7B,$64,$23,$82,$66
	.byte   $83,$73,$66,$66,$05,$73,$7F,$66
	.byte   $80,$04,$21,$77,$64,$64,$71,$73
	.byte   $21,$64,$1F,$04,$01,$66,$64,$7D
	.byte   $71,$64,$77,$80,$66,$66,$66,$71
	.byte   $76,$64,$76,$77,$66,$66,$66,$01
	.byte   $04,$7C,$66,$26,$66,$66,$7B,$82
	.byte   $01,$01,$01,$01,$01,$01,$13,$14
	.byte   $0C,$11,$8B,$65,$13,$13,$11,$01
	.byte   $17,$1B,$65,$64,$64,$1D,$01,$13
	.byte   $2E,$2F,$01,$01,$13,$9B,$01,$01
	.byte   $01,$88,$03,$03,$03,$88,$03,$03
	.byte   $01,$01,$8A,$01,$01,$89,$8A,$8A
	.byte   $8A,$8A,$66,$01,$93,$90,$69,$01
	.byte   $01,$69,$01,$01,$0D,$0D,$01,$01
	.byte   $01,$01,$01,$8D,$8D,$8D,$01,$8C
	.byte   $09,$0A,$9D,$A0,$A0,$0A,$01,$1C
	.byte   $1C,$1C,$8F,$8E,$17,$01,$8E,$8E
	.byte   $8E,$8B,$8B,$90,$01,$1F,$1F,$20
	.byte   $20,$01,$0E,$0F,$0F,$10,$10,$0F
	.byte   $01,$21,$01,$01,$01,$32,$40,$40
	.byte   $32,$36,$36,$35,$37,$37,$1A,$0D
	.byte   $0D,$0D,$97,$0D,$0D,$27,$86,$01
	.byte   $01,$30,$30,$01,$9C,$A1,$9C,$9C
	.byte   $01,$01,$01,$01,$01,$01,$00,$00
	.byte   $00,$00,$01,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$01,$00,$00,$00,$01,$01
	.byte   $00,$01,$00,$00,$00,$01,$00,$00
	.byte   $00,$00,$00,$01,$01,$01,$00,$00
	.byte   $00,$01,$01,$01,$00,$01,$01,$01
	.byte   $00,$01,$00,$00,$00,$00,$01,$01
	.byte   $01,$01,$00,$01,$01,$00,$00,$01
	.byte   $00,$00,$00,$00,$00,$00,$01,$00
	.byte   $00,$00,$01,$00,$00,$00,$01,$01
	.byte   $01,$00,$01,$01,$00,$01,$01,$00
	.byte   $00,$00,$01,$00,$00,$01,$00,$00
	.byte   $00,$01,$01,$00,$00,$01,$00,$00
	.byte   $00,$01,$01,$01,$00,$01,$00,$00
	.byte   $00,$01,$00,$01,$01,$01,$01,$00
	.byte   $00,$01,$01,$01,$01,$01,$01,$01
	.byte   $8D,$09,$A4,$BA,$A5,$AC,$1D,$1E
	.byte   $13,$1B,$A7,$08,$01,$04,$1A,$23
	.byte   $26,$29,$2B,$2C,$2C,$35,$15,$45
	.byte   $3E,$3F,$80,$41,$46,$41,$15,$16
	.byte   $03,$1B,$05,$05,$05,$23,$2E,$34
	.byte   $06,$06,$06,$1F,$AB,$20,$09,$09
	.byte   $0A,$26,$7A,$B9,$1C,$27,$7B,$7C
	.byte   $3C,$9D,$4C,$0B,$12,$14,$AF,$AF
	.byte   $AF,$AF,$22,$38,$60,$02,$07,$25
	.byte   $0E,$0F,$0E,$2F,$30,$31,$2C,$2A
	.byte   $2D,$10,$5A,$24,$25,$24,$3C,$B1
	.byte   $A9,$21,$33,$27,$0C,$67,$07,$32
	.byte   $33,$16,$35,$17,$28,$37,$19,$17
	.byte   $3D,$74,$B5,$4A,$4B,$8A,$48,$48
	.byte   $11,$A6,$A6,$A6,$0D,$65,$27,$1F
	.byte   $20,$4A,$20,$A2,$A3,$B2,$29,$49
	.byte   $49,$A0,$AE,$CF,$CA,$D0,$D2,$38
og_table:
	.byte   $03,$09,$0A,$0B,$0C,$0D,$0D,$0E
	.byte   $0F,$10,$11,$12,$13,$17,$18,$19
	.byte   $1A,$1A,$1B,$1C,$1D,$1F,$20,$21
	.byte   $24,$25,$25,$25,$26,$26,$27,$27
	.byte   $27,$27,$28,$28,$29,$2A,$2A,$2B
	.byte   $2C,$2D,$2E,$2F,$14,$30,$31,$32
	.byte   $34,$35,$36,$37,$38,$38,$39,$3A
	.byte   $3A,$3B,$3C,$3D,$3E,$3F,$41,$66
	.byte   $68,$69,$6A,$6A,$6A,$6A,$6A,$6B
	.byte   $6B,$6B,$6B,$6C,$6D,$6D,$6D,$6E
	.byte   $6F,$70,$71,$72,$72,$73,$73,$74
	.byte   $75,$76,$76,$77,$78,$79,$7A,$7B
	.byte   $7C,$7D,$7E,$7F,$80,$81,$82,$83
	.byte   $84,$85,$86,$87,$87,$88,$89,$8A
	.byte   $8B,$8B,$8B,$8C,$8D,$8E,$8F,$90
	.byte   $90,$91,$91,$93,$94,$95,$96,$97
	.byte   $98,$99,$9A,$9C,$9C,$9E,$A0,$A1
	.byte   $A2,$01,$00,$01,$01,$01,$00,$00
	.byte   $00,$01,$00,$01,$01,$01,$01,$01
	.byte   $01,$00,$00,$01,$00,$01,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$01,$01,$01,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00,$00,$00,$00,$00,$00,$00
	.byte   $00,$00

.out .sprintf("u: %d", u)
.out .sprintf("m: %d", m)


