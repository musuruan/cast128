100 rem # intro #
110 rem introduzione per
120 rem castello rev.2
130 rem (c) dinosoft 1984-2001
140 rem by enrico colombini
145 rem libera distribuzione
150 rem purche' non alterata
250 rem - entry:
260 :
270 rem trap 1090
280 rem costanti apple
290 ck = 49200: rem speaker
300 :
310 ks = 208: rem strobe
320 :
330 :
340 rem costanti dos
350 :
360 :
370 :
380 :
390 :
400 :
410 :
420 :
430 :
440 rem costanti - TODO: Spostare nel listato per migliorare le performance
450 bs$ = "{left}"
460 :
470 hi$ = "{rvon}": rem inverse
480 hn$ = "{rvof}": rem normal
490 hh$ = "{clr}": rem home
500 rem nomi files
510 fv$ = "v": rem variabili
520 fl$ = "l,r": rem luoghi
530 fm$ = "m,r": rem messaggi
540 :
550 :
560 rem costanti num cast
570 lu = 61: rem n. luoghi ***
580 nr = 80: rem n. routine
590 du = 60: rem un.ritardo
600 rp = 2: rem un.rit.stampa
610 nm = 4: rem max.ogg.trasp.
620 rem
630 u = 4864: rem utility
640 m = 5164: rem TBD
650 az = peek(m)
660 og = peek(m +1)
670 la% = m +1
680 pa% = la% +az
690 sa% = pa% +az
700 ta% = sa% +az
710 ra% = ta% +az
720 co% = ra% +az
730 mo% = co% +og
740 rem costanti str cast
750 be$ = chr$(7): rem beep
760 :
770 rem dimension variabili
780 dim f(20)
790 dim tu%(70)
800 dim lo%(150)
810 dim so%(150),vo%(150)
820 dim pt%(80): rem nr
830 rem init
840 :
850 :
860 :
870 :
880 bload"r",b1
890 fast
900 graphic 3,0:sys u
910 slow
920 rem titoli
930 rem printchr$(14)chr$(147):color0,1:color 4,1:color5,6:
940 color 1,6
950 draw 1,0,180 to 319,180
960 draw 1,0,196 to 319,196
970 a$ = "       * Avventura nel castello! *     Edizione freeware 2001 - libera distribuzione purche' non venga alterata "
975 rem sys 4867,,,,,a$: goto 1050
977 getkey k$:goto 1050
980 a1 = len(a$):a$ = a$ +a$ +" "
990 a2 = 1
1000 do:sys 65520,,23,1: print mid$(a$,a2,38);
1010 for i = 1 to 55: next
1020 a2 = a2 +1: if a2 = a1 then a2 = 1
1030 :
1040 get k$: loop until k$<>""
1050 graphic 0:scnclr
1060 :
1070 goto 30010: rem chain filer
1080 rem error
1090 end
30000 rem chain filer
30010 :
30020 fc = 0: rem filer command
30040 dload"filer"
