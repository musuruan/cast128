100 rem # intro #
110 rem introduzione per
120 rem castello rev.2
130 rem (c) dinosoft 1984-2001
140 rem by enrico colombini
145 rem libera distribuzione
150 rem purche' non alterata
160 rem !defcommon ck,kb,ks,m0,m1
170 rem !defcommon d$,sh,br$,op$,rd$,wr$,cl$,ve$,ch$
180 rem !defcommon bs$,cr$,hi$,hn$,hh$
190 rem !defcommon fv$,fl$,fm$,ff$,fg$
200 rem !defcommon lu,nr,du,rp,nm,u
210 rem !defcommon az,og,la%,pa%,sa%,ta%,ra%,co%,mo%
220 rem !defcommon be$,nn$,fc,ts
230 rem !defcommon f(20),t(10),tu%(70),lo%(150),so%(150),vo%(150),pt%(80)
240 rem !defcommon l,nt,pt,ti,tt,tu,gi,mo
250 rem - entry:
260 print  chr$(4)"nomoncio"
270 onerr  goto 1090
280 rem costanti apple
290 ck = 49200: rem speaker
300 kb = 49152: rem keyb
310 ks = 49168: rem strobe
320 m0 = 49288 + peek(47081): rem motor off
330 m1 = m0 +1: rem motor on
340 rem costanti dos
350 d$ =  chr$(4)
360 sh = 1002: rem shooks
370 br$ = d$ +"brun"
380 op$ = d$ +"open"
390 rd$ = d$ +"read"
400 wr$ = d$ +"write"
410 cl$ = d$ +"close"
420 ve$ = d$ +"verify"
430 ch$ = d$ +"bloadchain,a520"
440 rem costanti hrcg
450 bs$ =  chr$(8)
460 cr$ =  chr$(13)
470 hi$ =  chr$(9): rem inverse
480 hn$ =  chr$(14): rem normal
490 hh$ =  chr$(16): rem home
500 rem nomi files
510 fv$ = "v": rem variabili
520 fl$ = "l": rem luoghi
530 fm$ = "m": rem messaggi
540 ff$ = "f": rem filer
550 fg$ = "g": rem gioco
560 rem costanti num cast
570 lu = 61: rem n. luoghi ***
580 nr = 80: rem n. routine
590 du = 60: rem un.ritardo
600 rp = 2: rem un.rit.stampa
610 nm = 4: rem max.ogg.trasp.
620 rem 
630 u = 6064: rem utility
640 m = 6400: rem $1900
650 az =  peek(m)
660 og =  peek(m +1)
670 la% = m +1
680 pa% = la% +az
690 sa% = pa% +az
700 ta% = sa% +az
710 ra% = ta% +az
720 co% = ra% +az
730 mo% = co% +og
740 rem costanti str cast
750 be$ =  chr$(7): rem  beep
760 nn$ =  chr$(20) + chr$(20): rem per messaggi
770 rem dimension variabili
780 dim f(20)
790 dim tu%(70)
800 dim lo%(150)
810 dim so%(150),vo%(150)
820 dim pt%(80): rem nr
830 rem init
840 htab 1: vtab 1
850 rr = 49281: rem  rom/ram
860 poke rr,0: poke rr,0
870 d0 = 53248: rem $d000
880 print d$"bload r, a"d0
890 poke 230,32: rem hires page
900 poke 228,0: rem hcolor
910 call u: rem link hrcg
920 rem titoli
930 hcolor= 1: rem green
940 hplot 0,171 to 279,171
950 hplot 0,187 to 279,187
960 poke ks,0:a3 = 0
970 a$ = "       * Avventura nel castello! *     Edizione freeware 2001 - libera distribuzione purche' non venga alterata "
980 a1 =  len(a$):a$ = a$ +a$ +" "
990 a2 = 1
1000 vtab 23: htab 1: print  mid$ (a$,a2,40);
1010 for i = 1 to 150: next 
1020 a2 = a2 +1: if a2 = a1  then a2 = 1
1030 a3 = a3 +1
1040 if  peek(kb) <128  then 1000
1050 a3 =  sqr(a3)/10:a3 =  rnd( -a3): rem init rnd
1060 vtab 1: print nn$
1070 goto 30010: rem chain filer
1080 rem error
1090 call 50688: rem boot 6
30000 rem chain filer
30010 in# 0: pr# 0: call sh: rem unlink hrcg
30020 fc = 0: rem filer command 
30030 ts = 0: rem tasc
30040 ts = 1: print ch$: call 520"filer": rem applesoft -- togliere per tasc --
30050 rem !clear chain
30060 print br$ff$: rem tasc
