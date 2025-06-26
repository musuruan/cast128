100 rem # intro #
110 rem introduzione per
120 rem castello rev.2
130 rem (c) dinosoft 1984-2001
140 rem by enrico colombini
145 rem libera distribuzione
150 rem purche' non alterata
250 rem - entry:
260 :
270 trap 1090
280 rem costanti apple
290 ck = 49200: rem speaker
300 kb = 49152: rem keyb
310 ks = 49168: rem strobe
320 m0 = 49288 + peek(47081): rem motor off
330 m1 = m0 +1: rem motor on
340 rem costanti dos
350 d$ = chr$(4)
360 :
370 :
380 op$ = d$ +"open"
390 rd$ = d$ +"read"
400 wr$ = d$ +"write"
410 cl$ = d$ +"close"
420 ve$ = d$ +"verify"
430 :
440 rem costanti - TODO: Spostare nel listato per migliorare le performance
450 bs$ = "{left}"
460 cr$ = chr$(13)
470 hi$ = "{rvon}": rem inverse
480 hn$ = "{rvof}": rem normal
490 hh$ = "{clr}": rem home
500 rem nomi files
510 fv$ = "v": rem variabili
520 fl$ = "l": rem luoghi
530 fm$ = "m": rem messaggi
540 :
550 :
560 rem costanti num cast
570 lu = 61: rem n. luoghi ***
580 nr = 80: rem n. routine
590 du = 60: rem un.ritardo
600 rp = 2: rem un.rit.stampa
610 nm = 4: rem max.ogg.trasp.
620 rem
630 u = 6064: rem utility
640 m = 6400: rem $1900
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
840 graphic 4,0,21
870 :
880 :
890 :
900 :
910 :
920 rem titoli
930 printchr$(14)chr$(147):color0,1:color 4,1:color5,6:
940 sys 65520,,22,1:print"{38 SHIFT-*}";
950 sys 65520,,24,1:print"{38 SHIFT-*}";
960 color 5,2
970 a$ = "       * Avventura nel castello! *     Edizione freeware 2001 - libera distribuzione purche' non venga alterata "
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
