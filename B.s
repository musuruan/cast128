.feature c_comments

CHKKOM = $795c
MOVFRM = $7a85
PTRGET = $7aaf
PTRGET1 = $7b0b
FCERR = $7d28
AYINT = $84B4
GETSPA = $9299
JSRFAR = $ff6e
INDFET = $ff74
INDSTA = $ff77
BASIN = $ffcf
BSOUT = $ffd2
GETIN = $ffe4
CURSORON = $cd6f
CURSOROFF = $cd9f

FRETOP = $35
VARNAM = $47
VARPNT = $49
BUF= $0200
STAVEC = $02b9

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
;	jmp _GetChar
Input:
	jmp _Input
Scroller:
;	jmp _Scroller

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
	beq _InputLoop	; non esce se la stringa è zero
	; TODO: trovare un nome per questa routine
	jsr $558B	; termina la stringa con #$00 e stampa un CR

/*
	; temporary string descriptor
	lda $fd
	sta $03DB	;length of the string
	lda #<BUF
	sta $03DC	;lsb
	lda #>BUF
	sta $03DD	; msb of the string address

*/

	; riserva spazio per la stringa e abbassa di conseguenza FRETOP ($35)
	lda #15
	ldy #>GETSPA
	ldx #<GETSPA
	sta $02
	sty $03
	stx $04
	lda $fd
	sta $06
	jsr JSRFAR
	
	; copia il buffer nello spazio riservato alla stringa
	lda #FRETOP
	sta STAVEC
	ldy #0
:	lda BUF,y
	ldx #$01	; bank 1
	jsr INDSTA
	iny
	cpy $fd
	bne :-

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
	
	; TODO: annulla la vecchia stringa
	
	; aggiorna i descrittori della variabile
	lda #VARPNT
	sta STAVEC
	ldy #0
	lda $fd
	ldx #$01	; bank 1
	jsr INDSTA
:	iny
	lda FRETOP-1,y
	ldx #$01	; bank 1
	jsr INDSTA
        cpy #2
        bne :-

        ; TODO: LSB, MSB del descrittore della stringa
        ; (Basic 7 internals p. 25)

/*


	; descrittore stringa in 03DB, puntatore in $66
	lda #<$03DB
	sta $66
	lda #>$03DB
	sta $67

	;  assegna una stringa alla variabile il cui indirizzo è memorizzato nelle posizioni $4B,$4C (VARPNT)
	lda #15
	ldy #>$5405
	ldx #<$5405
	sta $02
	sty $03
	stx $04
	jsr JSRFAR

*/

	rts
	


.out .sprintf("u: %d", u)
.out .sprintf("m: %d", m)


