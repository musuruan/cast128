100 rem # filer #
110 rem per castello rev.2
120 rem (c) dinosoft 1984-2001
130 rem by enrico colombini
135 rem libera distribuzione
140 rem purche' non alterata
240 rem - entry (chained):
250 rem fc=0: new game, load v
260 rem fc=1: "load" command
270 rem fc=2: "save" command
280 rem fc=3: morto
290 onerr goto 1620
300 call u: rem link hrcg
310 poke 1010,188: poke 1011,23: call 64367: rem pwr-up byte
320 poke 1008,188: poke 1009,23: rem break
330 dc = 1: rem disco cast
340 if fc = 0 then gosub 1530: rem titoli
350 rem reentry (on error)
360 print : print cl$: rem chiude tutto
370 on fc +1 gosub 400,470,530,590: rem esegue routine
380 goto 30010: rem chain game
390 rem new game
400 a$(1) = "Iniziare una nuova avventura"
410 a$(2) = "Riprendere una situazione da disco"
420 a = 2: gosub 1030
430 if a = 1 then gosub 870:f$ = fv$: gosub 1230: goto 450: rem start new game
440 gosub 470: if f$ = "" then 400: rem load or restart
450 return 
460 rem load command
470 a$ = "Quale situazione vuoi riprendere ?": gosub 710: rem input f$
480 if f$ = "" then 500: rem annullato
490 gosub 1230: rem load game
500 gosub 870: rem restore disk
510 return 
520 rem save command
530 a$ = "Come vuoi chiamare questa situazione ?": gosub 710: rem input f
540 if f$ = "" then 560: rem annullato
550 gosub 1390: rem save game
560 gosub 870: rem restore disk
570 return 
580 rem morto
590 gosub 940: rem spazio
600 a$(1) = "Smettere di giocare"
610 a$(2) = "Iniziare una nuova avventura"
620 a$(3) = "Riprendere una situazione da disco"
630 a = 3: gosub 1030
640 if a = 1 then 1780: rem stop
650 if a = 2 then gosub 870:f$ = fv$: gosub 1230: goto 670: rem start new game
660 if a = 3 then gosub 470: if f$ = "" then 590: rem load or restart
670 return 
680 rem input f$
690 rem in: a$=messaggio nome
700 rem out:f$=nome file o ""
710 print : print 
720 if not dc then 760: rem user disk
730 print hi$" Togli AVVENTURA NEL CASTELLO "hn$
740 print : print hi$" Inserisci un dischetto DOS 3.3 "hn$
750 dc = 0: rem disco user
760 print : print a$: rem nome?
770 print "(CAT mostra il catalogo, X annulla)"
780 print : print "Situazione: ";
790 li = 25: gosub 1140: rem input
800 if in$ = "CAT" then print d$"catalog": goto 760
810 if in$ = "X" then f$ = "": goto 840
820 f$ = in$: if left$(f$,5) = "cast." and len(f$) >5 then f$ = mid$ (f$,6)
830 f$ = "cast." +f$
840 return 
850 print 
860 rem restore disk
870 if dc then 920: rem cast disk
880 print : print 
890 print hi$" Rimetti AVVENTURA NEL CASTELLO "hn$
900 gosub 940: rem spazio
910 dc = 1: rem disco cast
920 return 
930 rem spazio
940 print 
950 print "Premi <spazio> quando sei pronto: ";
960 poke ks,0
970 get a$: if a$ < >" " then 970
980 print : return 
990 rem scelta
1000 rem in: a=n.scelte
1010 rem     a$(a)=scelte
1020 rem out:a=scelta
1030 print : print : print "VUOI:": print : print 
1040 for i = 1 to a: print "<"; left$(a$(i),1);"> "a$(i)".": print : next 
1050 print : print "QUALE ?  "bs$;
1060 poke ks,0:li = 1: gosub 1140
1070 t = 0: for i = 1 to a
1080 if in$ = left$(a$(i),1) then t = i
1090 next : if not t then poke 37, peek(37) -2: goto 1050
1100 a = t: return 
1110 rem input in$
1120 rem in: li=len max input
1130 rem solo upper (anche in$)
1140 in$ = " "
1150 get b$:c = asc(b$):ll = len(in$) -1
1160 if c <123 and c >96 then c = c -32: rem toupper
1170 if (c = 8 or c = 127) and ll then in$ = left$(in$,ll): print chr$(8)" " chr$(8);: goto 1150: rem delete
1180 if c = 13 and ll then print :in$ = mid$ (in$,2): return : rem remove blank
1190 if ll <li then if (c >32 and c <91 and c < >44) then print chr$(c);:in$ = in$ + chr$(c): rem accetta !-z esclusa virgola
1200 goto 1150
1210 rem load var file
1220 rem in: f$=nome file
1230 print : if f$ = fv$ then print "Un attimo che mi preparo...": goto 1260
1240 print "Un attimo che rileggo la situazione..."
1250 print 
1260 print ve$f$: rem error se non c'e'
1270 print op$f$: print rd$f$
1280 for i = 1 to lu: input tu%(i): poke m1,0: next 
1290 for i = 1 to og: input lo%(i),so%(i),vo%(i): poke m1,0: next 
1300 for i = 1 to nr: input pt%(i): poke m1,0: next 
1310 for i = 1 to 20: input f(i): poke m1,0: next 
1320 for i = 1 to 10: input t(i): poke m1,0: next 
1330 input l,nt,pt,ti,tt,tu
1340 poke m0,0: rem motor off
1350 print cl$f$
1360 return 
1370 rem save var file
1380 rem in: f$=nome file
1390 print : print "Un attimo che salvo la situazione...": print 
1400 print op$f$
1410 print d$"unlock"f$
1420 print wr$f$
1430 for i = 1 to lu: print tu%(i): poke m1,0: next 
1440 for i = 1 to og: print lo%(i): print so%(i): print vo%(i): poke m1,0: next : rem co,mo non cambiano
1450 for i = 1 to nr: print pt%(i): poke m1,0: next 
1460 for i = 1 to 20: print f(i): poke m1,0: next 
1470 for i = 1 to 10: print t(i): poke m1,0: next 
1480 print l: print nt: print pt: print ti: print tt: print tu
1490 poke m0,0: rem motor off
1500 print cl$f$: print ve$f$
1510 return 
1520 rem titoli
1530 print hh$: rem clear
1540 hcolor= 3
1550 hplot 0,14 to 279,14 to 279,72 to 0,72 to 0,14
1560 vtab 4: htab 7: print hi$" * AVVENTURA NEL CASTELLO * "hn$
1570 vtab 6: htab 3: print "di: Enrico Colombini e Chiara Tovena"
1580 vtab 8: htab 7: print "Copyright Dinosoft 1982-2001"
1590 vtab 10
1600 return 
1610 rem error
1620 call u +3: rem recovery
1630 call u: vtab 24: htab 1: rem relink hrcg 
1640 e = peek(222): rem error
1650 print : print hi$;
1660 if e = 255 then print " Perche' mi hai ucciso? "hn$: goto 1780: rem stop
1670 if dc and e >0 and e <16 then print " Problemi con il disco! "hn$be$be$: print : print "verifica che sia inserito il dischetto": print hi$" AVVENTURA NEL CASTELLO ";: goto 1730
1680 if e = 8 or e = 5 then print " Problemi con il disco! ";: goto 1730
1690 if e = 4 then print " Il disco e' protetto dalla scrittura! ";: goto 1730
1700 if e = 6 then print " "f$" non c'e' su questo disco! ";: goto 1730
1710 if e = 9 then print hn$: print d$"delete"f$: print hi$" Su questo disco non c'e' posto! ";: goto 1730
1720 print " errore "e"-" peek(218) +256 * peek(219)" "hn$be$be$: poke 216,0: goto 1780: rem stop
1730 print hn$be$be$
1740 if fc = 1 or fc = 2 then gosub 940: rem spazio se load o save
1750 if fc = 0 or fc = 3 then a = dc: gosub 870: if (a) then gosub 940: rem restore disk se new game o morto 
1760 goto 360: rem restart
1770 rem stop
1780 poke ks,0: print 
1790 in# 0: pr# 0: call sh: text : print : print "CIAO!": print d$"fp": rem exit
30000 rem chain game
30010 vtab 10: rem no scrolling
30020 :
30030 dload"game"
