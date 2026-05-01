100 rem
110 rem  #################
120 rem  #               #
130 rem  # avventura nel #
140 rem  #   castello!   #
150 rem  #               #
160 rem  #################
170 rem (c) dinosoft 1982-2001
180 rem by: enrico colombini
190 rem     & chiara tovena
195 rem libera distribuzione
200 rem purche' non alterata
210 rem versione per commodore 128
220 rem (c) andrea musuruane 2025-2026
300 rem - entry (chained):
310 trap 3120
320 goto 5010: rem main prog
330 rem ### subroutine ###
340 rem get con cursore
350 rem out: g=cod.carattere
360 rem ct+=1 ogni .25 secondi
370 cc = 0: rem cursor counter
380 if cc = 150 then cc = 0:ct = ct +1
390 if cc = 0 then print "_"bs$;
400 if cc = 75 then print " "bs$;:ct = ct +1
410 cc = cc +1:if peek(ks)=0 then 380:else g=peek(842)
420 print " "bs$;: poke ks,0: return
430 rem stampa messaggio
440 rem in: m=n.messaggio
450 rem non esegue cr finale
460 speed= 255:vp = 10
470 if p2 < = pl or ct <20 then 490: rem no test
480 p3 = p3 +1: gosub 3240: call 576: n1 = peek(579): gosub 3240:dy = 5: gosub 2950: call 576:n2 = peek(579): if n1 and n2 = 0 then p2 = 0:p3 = p3 -1: rem p2 test
490 :
500 n0=30+m*6:record#2,int(n0/254)+1,n0-int(n0/254)*254+1
510 :
520 :
530 p2 = 0: rem (p2 = p2 + 1) protezione disattivata 4/2001
540 gosub 815: n1=val(b$): gosub 815: n2=val(b$)
550 record#2,int(n1/254)+1,n1-int(n1/254)*254+1
560 c = n1: do while c<= n2-2: get#2,a$
570 c = c + 1
580 rem analisi comandi:
590 a1 = asc(a$)
600 if a1 >29 then a1 = 156 -a1: goto 700
610 if a1 = 14 then print hn$;: goto 720: rem normal
620 if a1 = 9 then print hi$;: goto 720: rem inverse
630 if a1 = 6 then print hi$;: goto 720: rem flash=inverse
640 if a1 = 15 then mo = 1: goto 720
650 if a1 = 16 then print : print tab(31);">> ";: poke ks,0: gosub 370: print : print : goto 720
660 if a1 = 25 then gosub 815: dy=val(b$): c = c + len(b$): gosub 2950: goto 720: rem delay
670 if a1 = 12 then gosub 815: l=val(b$): c = c + len(b$): goto 720
680 if a1 = 19 then gosub 815: vp=val(b$): c = c + len(b$): vp = ((256 -vp) *rp)/4: goto 720
690 rem stampa su video:
700 print chr$(a1);
710 for i = 1 to vp: next
720 loop : rem c
730 rem chiude lettura mantenendo cursore:
740 :
750 :
760 :
770 :
780 speed= 255: print hn$;
790 :
800 if p2 >pl then poke 767,3: sys u +15: rem seek t3
810 ct = 0: return
815 b$="":do:get#2,a$:b$=b$+a$:loop until asc(a$)=13:return
820 rem scansione parola
830 rem in: in$=stringa
840 rem out:a$=parola
850 rem     annulla apostrofi
860 a$ = "":c = 1:b = len(in$)
870 if in$ = "" then 980
880 b$ = mid$ (in$,c,1)
890 if b$ <>" " then if b$ <>"'" then 930
900 c = c +1: if c < = b then 880
910 goto 970: rem nulla
920 rem inizio parola:
930 b$ = mid$ (in$,c,1)
940 if b$ = " " or b$ = "'" then in$ = right$(in$,b -c +1): goto 980: rem fine parola
950 a$ = a$ +b$
960 c = c +1: if c < = b then 930
970 in$ = "": rem fine di in$
980 return
990 rem cerca codici pp/sp
1000 rem in: pp$, sp$ (parole)
1010 rem     vp$ (vecchia pp$)
1020 rem out:cp%, cs% (codici)
1030 rem     cs%=255 se sp in pp
1040 a$ = pp$
1050 gosub 1190: rem diz 1
1060 cp% = co: if tp <>1 then cp% = 0
1070 if tp = 2 then if vp$ <>"" then sp$ = pp$:pp$ = vp$:vp$ = "": goto 1040
1080 rem
1090 if sp$ = "" then cs% = 1: goto 1140
1100 a$ = sp$
1110 gosub 1190: rem diz 1
1120 cs% = co: if tp <>2 then cs% = 0
1130 if tp = 1 then cs% = 255
1140 vp$ = "": return
1150 rem consulta diz 1
1160 rem in:  a$=entry
1170 rem out: tp=tipo (0=no)
1180 rem      co=codice
1190 if a$ = "" then a$ = " "
1200 for c = 1 to len(a$): poke 575 +c,125 - asc( mid$ (a$,c,1)): next
1210 me = 575 +c -1: poke me, peek(me) +128: rem ultimo char
1220 sys u +3: rem diz.1
1230 tp = peek(766):co = peek(767)
1240 return
1250 rem consulta diz 2
1260 rem in:  tp=tipo
1270 rem      co=codice
1280 rem out: a$=entry
1290 rem a$="" se non esiste
1300 poke 766,tp: poke 767,co
1310 sys u +6: rem diz.2
1320 a$ = "":me = 576
1330 c = peek(me)
1340 if c <128 then a$ = a$ + chr$(125 -c):me = me +1: goto 1330
1350 if c <>255 then a$ = a$ + chr$(253 -c): rem 125-(c-128)
1360 return
1370 rem input in$
1380 rem in: li=len max input
1390 rem out:ct=tempo input
1400 rem accetta tutto se test
1410 rem echo upper, in$ lower
1420 in$ = " ":ct = 0
1430 gosub 370:c = g:ll = len(in$) -1
1440 :
1450 if c <91 and c >64 then c = c or 128: rem toupper
1460 if c = 20 and ll then in$ = left$(in$,ll): print "{left} {left}";: goto 1430: rem delete
1470 if c = 13 and ll then print :in$ = mid$ (in$,2):ct = ct +9 *ct : return : rem remove blank
1480 if ll <li then if (c >192 and c <219) or c = 32 or c = 39 or c = 45 then print chr$(c);:in$ = in$ + chr$(c and 127): rem accetta a-z,sp,"'","-" e tolower
1490 goto 1430
1500 rem input linea
1510 rem esce con pp$, sp$
1520 rem annulla articoli
1530 li = 60: gosub 1420: rem input in$
1540 gosub 860: rem 1. parola
1550 pp$ = a$
1560 gosub 1190: if tp = 3 then 1540
1570 gosub 860: rem 2. parola
1580 sp$ = a$
1590 gosub 1190: if tp = 3 then 1570
1600 if p3 >2 then 1600: rem pirata
1610 return
1620 rem da cod. sp a nome
1630 rem in:  a=codice sp
1640 rem out: a$=nome sp$
1650 tp = 2:co = a
1660 gosub 1300: rem diz 2
1670 return
1680 rem cerca nome stato
1690 rem in:  a=codice sp
1700 rem      s=stato (0/1/2)
1710 rem out: s$=nome stato
1720 if s = 0 then s$ = "": return
1730 co = a:tp = 5 +s: rem 6 o 7
1740 gosub 1300: rem diz 2
1750 s$ = a$: if s$ = " " then s$ = ""
1760 return
1770 rem cerca stato ogg.
1780 rem in: a=codice sp
1790 rem     l=luogo
1800 rem out:s=stato (a,l)
1810 rem      oppure (a,0)
1820 rem     mb=mobilita'
1830 for i = 1 to og: if a <> peek(co% +i) then next : return
1840 if lo%(i) = l or lo%(i) = 0 then s = so%(i):mb = peek(mo% +i): return
1850 next : return
1860 rem cambia stato ogg.
1870 rem in: a=codice sp
1880 rem     s=stato voluto
1890 rem     l=luogo
1900 rem out:cambia stato (a,l)
1910 rem     oppure stato (a,0)
1920 for i = 1 to og: if a <> peek(co% +i) then next : return
1930 if lo%(i) = l or lo%(i) = 0 then so%(i) = s: return
1940 next : return
1950 rem ogg. visibili
1960 rem in:  l=luogo
1970 for j = 1 to og
1980 if lo%(j) <>l then next : return
1990 if vo%(j) = 0 then next : return
2000 a = peek(co% +j): gosub 1650
2010 og$ = "Vedo " +a$
2020 s = so%(j): gosub 1720
2030 if s$ <>"" then og$ = og$ +" " +s$
2040 print og$"."
2050 next : return
2060 rem ogg. posseduti
2070 if nt = 0 then m = 154: goto 460: rem nulla
2080 m = 155: gosub 460
2090 for i = 1 to og: if lo%(i) = 0 then a = peek(co% +i): gosub 1650:og$ = "- " +a$:s = so%(i): gosub 1720: print og$" "s$
2100 next : print : return
2110 rem appare oggetto
2120 rem in:  a=codice sp
2130 rem      l=luogo
2140 for i = 1 to og: if lo%(i) = 255 then if a = peek(co% +i) then lo%(i) = l: return
2150 next : return
2160 rem scompare oggetto
2170 rem (anche trasportato)
2180 rem in:  a=codice sp
2190 rem      l=luogo
2200 for i = 1 to og: if a = peek(co% +i) then if lo%(i) = 0 or lo%(i) = l then 2220
2210 next : return
2220 if lo%(i) = 0 then nt = nt -1
2230 lo%(i) = 255: return
2240 rem ogg. presente ?
2250 rem in:  a=codice sp
2260 rem      l=luogo
2270 rem out: s=0 assente
2280 rem        1 presente
2290 rem        2 trasportato
2300 rem      mb=0 immobile
2310 rem      mb=1 mobile
2320 rem      e=0 non elencato
2330 rem      e=1 elencato
2340 rem se piu' oggetti uguali
2350 rem devono essere fissi
2360 e = 0:mb = 0:s = 0: rem se non lo trova
2370 for j = 1 to og: if a <> peek(co% +j) then next : return
2380 mb = peek(mo% +j):e = 1: rem trovato uno
2390 if lo%(j) = l then s = 1: return
2400 if lo%(j) = 0 then s = 2: return
2410 next : return : rem ne cerca un altro
2420 rem prende oggetto
2430 rem in:  a=codice sp
2440 rem      l=luogo
2450 for i = 1 to og: if a = peek(co% +i) then if l = lo%(i) then lo%(i) = 0:vo%(i) = 1:nt = nt +1: return
2460 next : return
2470 rem lascia oggetto
2480 rem in:  a=codice sp
2490 rem      l=luogo
2500 for i = 1 to og: if a = peek(co% +i) then lo%(i) = l:nt = nt -1: return
2510 next : return
2520 rem prende se puo'
2530 rem in:  a=codice sp
2540 rem      l=luogo
2550 gosub 2360: if s = 0 then 2640: rem che?
2560 if s = 2 then print : print "- Gia' fatto.": return
2570 if mb = 0 then m = 157: goto 460: rem impossibile
2580 if nt > = nm then m = 156: gosub 460: gosub 2070: return
2590 gosub 2450: print : print "Fatto.": return
2600 rem lascia se puo'
2610 gosub 2360: if s <>2 then m = 158: goto 460: rem non l'hai
2620 gosub 2500: print : print "Fatto.": return
2630 rem che oggetto ?
2640 if cs% = 23 then if l = 22 then a = 142: gosub 1830: if s = 1 then m = 83: goto 460: rem diam.del nano
2650 print : print "- Che "sp$" ?": return
2660 rem descr. lunga luogo
2670 rem in:  l=luogo
2680 if p2 < = pl or ct <20 then 2700: rem no test
2690 p3 = p3 +1: gosub 3240: call 576: n1 = peek(579): gosub 3240:dy = 5: gosub 2950: call 576:n2 = peek(579): if n1 and n2 = 0 then p2 = 0:p3 = p3 -1: rem p2 test
2700 n0=30+l*6:record#1,int(n0/254)+1,n0-int(n0/254)*254+1
2710 gosub 2775: n1=val(b$): gosub 2775: n2=val(b$)
2720 record#1,int(n1/254)+1,n1-int(n1/254)*254+1
2730 for c = n1 to n2 -1: get#1, a$:a1 = asc(a$): if a1 <>13 then a1 = 158 -a1
2740 :
2750 print chr$(a1);: next
2760 p2 = 0: rem (p2 = p2 + 1) protezione disattivata 4/2001
2770 goto 740: rem chiude e torna
2775 b$="":do:get#1,a$:b$=b$+a$:loop until asc(a$)=13:return
2780 rem somma punti
2790 pt = pt +pt%(re):pt%(re) = 0: return
2800 rem stampa punti
2810 m = 187: gosub 460: print pt;:m = 188: goto 460
2820 rem punti e titolo
2830 gosub 2810:m = 102: gosub 460
2840 print : print
2850 restore :m = 0
2860 for m = 0 to 9: read c: if pt > = c then next
2870 m = m +190: gosub 460
2880 print : print : print
2890 dy = 40: goto 2950
2900 rem pt per titoli
2910 data 35,59,150,300,450
2920 data 650,899,949,999,1000
2930 rem ritardo
2940 rem in: dy = n.unita' rit.
2950 for d1 = 1 to du *dy: next
2960 return
2970 rem si/no
2980 rem in:  m=mess.domanda
2990 rem out: s=1/0 (si/no)
3000 print
3010 li = 2: gosub 460: rem mess
3020 gosub 1420: rem input in$
3030 if left$(in$,1) = "s" or left$(in$,1) = "y" then s = 1: return
3040 if left$(in$,1) = "n" then s = 0: return
3050 s = m:m = 132: gosub 460:m = s: goto 3010
3060 rem morto
3070 mo = 0:gi = 0
3080 m = 159: gosub 460
3090 gosub 2830: rem titolo
3100 fc = 3: goto 30010: rem chain filer
3110 rem errori
3120 :
3130 if gi = 0 then 3180
3140 rem sys u +9: rem err.recvry
3150 if tu%(l) = 0 then tu%(l) = 1: rem no descr.lunga
3160 :
3170 :
3180 print be$: print err$(er);" error in line";el: goto 3200
3190 rem stop
3200 poke ks,0
3210 gosub 370: rem get
3220 print : print "CIAO!": end: rem exit
3230 rem decri p2 test
3240 i1 = 7424:i2 = i1 +127
3250 for i = 576 to 676 step 2
3260 poke i, peek(i2):i2 = i2 -1
3270 poke i +1, peek(i1):i1 = i1 +1
3280 next
3290 return
5000 rem ### main prog ###
5010 :
5020 dopen#1,(fl$): dopen#2,(fm$)
5030 scnclr: rem home
5040 p2 = 0:p3 = 0:pl = 6: rem p2 counters
5050 rem poke808,peek(808)-3: rem disabilita run/stop + restore
5060 :
5070 gi = 1: rem gioco iniziato
5080 if l = 1 and (fc = 0 or fc = 3) then t(1) = 8:tm = 1: print hh$;:m = 209: gosub 460: print hh$;:m = 15: gosub 460: rem prologo e precipita
5090 rem ### main cycle ###
5100 rem input e descriz.
5110 tp = 4:co = l: gosub 1300: rem a$=des.corta
5120 if l <>1 then a$ = "Sei " +a$
5130 print : if tu%(l) then if a$ <>"" then print a$: goto 5160
5140 if l >25 and l <33 then print a$: goto 5160: rem labir.
5150 gosub 2680: rem descr. lunga
5160 gosub 1970: rem vedo oggetti
5170 rem input e chiede
5180 if tm then gosub 15020: if tt then 5110: rem event. timer
5190 if mo then 3070
5200 tu%(l) = tu%(l) +1: rem turni luogo
5210 print : print : print " Cosa devo fare ? ";
5220 rem input e basta
5230 gosub 1530: rem input
5240 gosub 1040: rem codici
5250 if cp% = 7 then pp$ = sp$:sp$ = "": goto 5240: rem "VAI"
5260 if right$(pp$,2) = "re" then print : print "- Dammi del tu, per favore.": goto 5180
5270 rem per uso test
5280 if cp% = 29 then a = val(sp$): if a >0 and a < = lu then l = a: print hh$;:t(1) = 0: goto 5110
5290 rem parole valide ?
5300 if cp% = 0 then print : print "   Eh ? ";: goto 5230: rem pp??
5310 if cs% = 0 then print : print "   "sp$" ???": goto 5180: rem sp??
5320 rem pirata?
5330 if p3 >1 then for i = 1 to 2 step 0:m = 218: gosub 460: poke ks,0: gosub 370: next
5340 rem salta
5350 if cp% = 31 and cs% <>3 then cs% = 1
5360 rem varie
5370 tu = tu +1: rem contamosse
5380 rem
5390 rem cerca in azioni
5400 for i = 1 to az:a = peek(la% +i): if a = 0 or a = l then if cp% = peek(pa% +i) then if cs% = peek(sa% +i) then 5420
5410 next : goto 5470
5420 if peek(la% +i) = 0 then if cs% <>1 then if cs% <100 then a = cs%: gosub 2360: if s = 0 then gosub 2640:dy = 40: gosub 2950: goto 5110
5430 a = peek(ra% +i): if peek(ta% +i) then a = -a
5440 gosub 20040: if mo then 3070
5450 goto 5110
5460 rem basta
5470 if cp% <>8 then 5510
5480 m = 143: gosub 3000: if s = 0 then 5180
5490 m = 189: gosub 460: gosub 2830: goto 3200
5500 rem dove
5510 if cp% = 9 then 5110
5520 rem guarda
5530 if cp% = 102 then if cs% = 1 or cs% = 146 then print : goto 5150: rem des.lunga
5540 rem cosa
5550 if cp% = 10 then gosub 2070: goto 5180
5560 rem prendi
5570 if cp% = 100 then if cs% >1 and cs% <100 then a = cs%: gosub 2550: goto 5180
5580 rem lascia
5590 if cp% <>101 then 5640
5600 if cs% = 1 then 5640
5610 if l >25 and l <33 then l1 = l:l = 24:a = cs%: gosub 2610:l = l1: goto 5180
5620 a = cs%: gosub 2610: goto 5180
5630 rem mosse
5640 if cp% = 19 then m = 150: gosub 460: print tu" mosse.": goto 5180
5650 rem punti
5660 if cp% = 20 then gosub 2810: goto 5180
5670 rem load
5680 if cp% = 14 then if cs% = 1 then fc = 1: goto 30010: rem chain filer
5690 rem save
5700 if cp% = 15 then if cs% = 1 then fc = 2: goto 30010: rem chain filer
5710 rem direzioni
5720 if cp% >6 then 5840
5730 if p3 >2 then 5730: rem pirata
5740 co = l:tp = 5: rem mappa
5750 gosub 1300: rem diz 2
5760 a = val( mid$ (a$,2 *cp% -1,2))
5770 if a <>0 then l = a: goto 5110
5780 rem non puoi andare
5790 tp = 1:co = cp%
5800 gosub 1300: rem diz 2
5810 print : print "- "a$" non puoi andare.": goto 5180
5820 rem default intrans.
5830 rem (o trans. speciali)
5840 df = 0: gosub 10030: if df then 5180
5850 rem trans. senza oggetto ?
5860 if cs% = 1 then if cp% > = 100 then print : print "- "pp$" che cosa ? ";:vp$ = pp$: goto 5230
5870 rem intrans. con oggetto ?
5880 if cp% <100 then if cs% <>1 then 5960
5890 rem sp presente ?
5900 if cp% <100 then 5980: rem test solo se transitivo
5910 a = cs%: gosub 2360: if e = 0 then 5980: rem eh? (non elencato)
5920 if s = 0 then gosub 2640: goto 5180: rem elencato ma assente
5930 rem default transitivi
5940 df = 0: gosub 11050: if df then 5180
5950 rem altrimenti
5960 print : print "- Non capisco.": goto 5180
5970 rem garbage
5980 print : print "   Eh ? ";: goto 5230
10000 rem ### avventura ###
10010 rem default intrans.
10020 rem insulti:
10030 if cp% <>11 then 10120
10040 print : print : print hi$" ";: for i = 1 to len(pp$):a = asc( mid$ (pp$,i,1)): print chr$(a or 128);: next
10050 print " A ME ?!?"be$be$be$hn$:dy = 50: gosub 2950:m = 80: gosub 460
10060 for i = 1 to 500:a = peek(ck)
10070 :
10080 poke 1024+int(1000 * rnd(0)),int(91 * rnd(0)) or 128 * int(rnd(0) * 2)
10090 next
10100 print hh$: print hi$" Tie'!"be$be$: print :fc = 3: goto 30010: rem chain filer
10110 rem aiuto:
10120 if cp% <>16 then 10170
10130 m = 2
10140 gosub 460: rem punto comune
10150 df = 1: return : rem pure questo
10160 rem piangi:
10170 if cp% = 17 then m = 3: goto 10140
10180 rem prega:
10190 if cp% = 18 then m = 4: goto 10140
10200 rem atterra:
10210 if cp% = 30 then m = 5: goto 10140
10220 rem salta:
10230 if cp% = 31 then m = 6: goto 10140
10240 rem siedi:
10250 if cp% = 33 then m = 8: goto 10140
10260 rem buongiorno:
10270 if cp% = 35 then m = 9: goto 10140
10280 rem scava:
10290 if cp% = 27 then m = 135: goto 10140
10300 rem senno:
10310 if cp% = 23 then m = 136: goto 10140
10320 rem entra, esci etc.:
10330 if cp% = 39 or cp% = 37 then m = 201: goto 10140
10340 rem usa:
10350 if cp% = 129 then m = 133: goto 10140
10360 rem cerca:
10370 if cp% <>121 then 10420
10380 if cs% <>18 then m = 134: goto 10140
10390 if l <>11 then m = 115: goto 10140
10400 m = 63: goto 10140
10410 rem
10420 return
11000 rem default transitivi
11010 rem in: cp%,a=cs%
11020 rem     s=stato
11030 rem     mb=mobilita'
11040 rem guarda:
11050 if cp% = 102 then m = 10: goto 10140
11060 rem infila:
11070 if cp% = 117 then if l = 17 then m = 176: goto 10140
11080 rem prendi:
11090 if cp% = 100 then m = 96: goto 10140
11100 rem mangia:
11110 if cp% = 134 then m = 170: goto 10140
11120 rem rompi:
11130 if cp% = 124 then m = 96: goto 10140
11140 rem spingi:
11150 if cp% <>115 then 11210
11160 if cs% > = 100 then m = 96: goto 10140
11170 if s = 2 then m = 11: goto 10140
11180 if mb = 1 then 11250
11190 m = 12: goto 10140
11200 rem alza:
11210 if cp% <>119 then 11270
11220 if cs% > = 100 then m = 96: goto 10140
11230 if s = 2 then m = 11: goto 10140
11240 if mb = 1 then m = 14: goto 10140
11250 m = 211: goto 10140
11260 rem
11270 return
15000 rem temporizzatori
15010 rem t1:
15020 if t(1) = 0 then 15090
15030 t(1) = t(1) -1: if t(1) = 3 then m = 17: goto 460
15040 if t(1) = 2 then m = 18: goto 460
15050 if t(1) = 1 then m = 19: goto 460
15060 if t(1) then return
15070 mo = 1:m = 16: goto 460
15080 rem t2:
15090 if t(2) then t(2) = t(2) -1: return
15100 rem t3:
15110 if t(3) then m = 142: goto 460
15120 rem t4:
15130 if t(4) = 0 then 15200
15140 t(4) = t(4) -1
15150 if t(4) = 2 then m = 203: goto 460
15160 if t(4) = 1 then m = 204: goto 460
15170 if t(4) then return
15180 m = 205: goto 460
15190 rem
15200 tm = 0:tt = 0: return
20000 rem azioni
20010 rem a=n.azione se >0
20020 rem   n.messaggio se <0
20030 rem cp%,cs% validi
20040 if a <0 then m = -a: goto 460
20050 rem
20060 r = a:a = cs%: gosub 2360: rem determina s (0/1/2)
20070 rem
20080 re = r: rem rout.eseguita
20090 if p3 >3 then end: rem pirata
20100 rem
20110 on r goto 20280,20310,20340,20450,20480,20510,20540,20570,20650,20670,20690,20720,20750,20770,20810,20850,20880,20910,20940,20970
20120 rem
20130 r = r -20
20140 rem
20150 on r goto 21000,21040,21070,21090,21110,21150,21180,21220,21240,21280,21330,21360,21390,21410,21440,21500,21530,21560,21590,21630
20160 rem
20170 r = r -20
20180 rem
20190 on r goto 21660,21690,21730,21780,21870,21910,21950,21990,22030,22070,22130,22190,22230,22340,22360,22380,22400,22420,22440,22460
20200 rem
20210 r = r -20
20220 rem
20230 on r goto 22490,22520,22550,22580,22600,22660,22680,22700,22720,22740,22780,22800,22820,22850,22880,22910,22970,22990,23010,23030
20240 r = r -20
20250 rem
20260 return
20270 rem 1:
20280 if s = 0 then 2640
20290 m = 161: goto 460
20300 rem 2:
20310 if s = 0 then 2640
20320 m = 168: goto 460
20330 rem 3:
20340 a = 3: gosub 2360: if s = 2 then m = 26:t(1) = 0:l = 2: gosub 2790: goto 460
20350 m = 24: gosub 460:mo = 1: goto 20370
20360 rem aaaa...splat:
20370 speed= 180
20380 print "aaaa": print tab(12)"aaa": print tab(15)"aa": print tab(17)"a": print tab(18)"a"
20390 for i = 1 to 4: print tab(19)"a": next : for i = 1 to 4: print tab(19)":": next
20400 speed= 255
20410 print tab(15);"\   :   /": print tab(14);"- "hi$" SPLAT!"hn$" -"; chr$(7)
20420 dy = 40: gosub 2950
20430 return
20440 rem 4:
20450 if s = 0 then 2640
20460 m = 170: goto 460
20470 rem 5:
20480 if s = 2 then m = 182: goto 460
20490 m = 28: gosub 460: gosub 2790:a = 3: gosub 2140: goto 2450
20500 rem 6:
20510 a = 138: gosub 1830: if s = 1 then m = 29: goto 460
20520 l = 3: gosub 2790:m = 30: goto 460
20530 rem 7:
20540 if f(1) = 0 then 5790
20550 l = 18: goto 2790
20560 rem 8:
20570 a = 25: gosub 2360: if s <>2 then 2640
20580 gosub 1830: if s = 2 then m = 92: goto 460
20590 a = 19: gosub 2360: if s then m = 126: gosub 460:a = 25:s = 2: goto 1920
20600 if l = 22 then m = 169: goto 460
20610 if l = 16 then a = 141: gosub 2360: if s then m = 168: goto 460
20620 if l = 21 then a = 143: gosub 2360: if s then m = 180: goto 460
20630 m = 179: goto 460
20640 rem 9:
20650 gosub 2790:a = 138:s = 2: goto 1920
20660 rem 10:
20670 a = 138:s = 1: goto 1920
20680 rem 11:
20690 if f(4) = 0 then 5790
20700 l = 33: goto 2790
20710 rem 12:
20720 if f(7) = 0 then 5790
20730 gosub 2790:l = 34: return
20740 rem 13:
20750 f(8) = 1: gosub 2790:m = 101: goto 460
20760 rem 14:
20770 m = 145: gosub 3000
20780 if s = 1 then m = 40: gosub 460:mo = 1
20790 return
20800 rem 15:
20810 if s <>2 then 2640
20820 if f(1) then m = 70: goto 460
20830 a = 10:s = 2: gosub 1920:m = 43:f(1) = 1: gosub 2790: goto 460
20840 rem 16:
20850 gosub 1830: if s = 1 then m = 49: goto 460
20860 m = 100: goto 460
20870 rem 17:
20880 m = 20: gosub 3000: if s then 22800
20890 return
20900 rem 18:
20910 a = 13: gosub 1830: if s = 2 then m = 45: goto 460
20920 a = 13:s = 2: gosub 1920: gosub 2790:m = 46: gosub 460:a = 12: goto 2140
20930 rem 19:
20940 if s = 1 then m = 47: goto 460
20950 f(9) = 1: gosub 2790:m = 48: goto 460
20960 rem 20:
20970 a = 13: gosub 1830: if s = 1 then m = 49: goto 460
20980 m = 50:f(2) = 1: gosub 2790: goto 460
20990 rem 21:
21000 if f(8) = 0 or f(9) = 0 then m = 173: goto 460
21010 if (l <>11) or f(4) then m = 7: goto 460
21020 m = 52:f(4) = 1: gosub 2790: goto 460
21030 rem 22:
21040 if f(12) then l = 25: goto 2790
21050 print hh$;:m = 183: goto 460
21060 rem 23:
21070 m = 54: gosub 460: gosub 2790:a = 16: goto 2140
21080 rem 24:
21090 return
21100 rem 25:
21110 if s = 0 then 2640
21120 a = 16: gosub 1830: if s = 2 then m = 45: goto 460
21130 m = 57: gosub 460: gosub 2790:a = 17: gosub 2140:a = 16:s = 2: goto 1920
21140 rem 26:
21150 if s = 2 then m = 58: goto 460
21160 m = 59: goto 460
21170 rem 27:
21180 if s <>2 then 2640
21190 if l <>11 or f(2) = 0 then m = 61: goto 460
21200 gosub 2790:m = 62:f(12) = 1: goto 460
21210 rem 28:
21220 gosub 2790:m = 33: goto 460
21230 rem 29:
21240 if s = 2 then m = 64: goto 460
21250 if nt <nm then m = 65: gosub 460: gosub 2450:s = 2: goto 1920
21260 m = 156: gosub 460: goto 2070
21270 rem 30:
21280 if s = 1 then m = 67: goto 460
21290 if l <>53 then m = 68: goto 460
21300 if f(3) then m = 70: goto 460
21310 m = 71:f(3) = 1: gosub 2790: goto 460
21320 rem 31:
21330 if f(3) then m = 45: goto 460
21340 m = 72: goto 460
21350 rem 32:
21360 if f(3) = 0 then m = 49: goto 460
21370 f(10) = 1: gosub 2790:m = 73: goto 460
21380 rem 33:
21390 gosub 2790:m = 36: goto 460
21400 rem 34:
21410 a = 141: gosub 2360: if s = 0 then l = 19: return
21420 m = 75:mo = 1: goto 460
21430 rem 35:
21440 if f(10) = 0 then m = 173: goto 460
21450 a = 19: gosub 2360: if s = 0 then m = 7: goto 460
21460 m = 77: gosub 460
21470 if l <>16 then m = 78:mo = 1: goto 460
21480 m = 79: gosub 460: gosub 2790:a = 19: gosub 2200:a = 141: goto 2200
21490 rem 36:
21500 a = 142: gosub 1830: if s = 2 then m = 81: goto 460
21510 m = 82: gosub 460: gosub 2790:a = 142:s = 2: gosub 1920:a = 23: goto 2140
21520 rem 37:
21530 a = 142: gosub 1830: if s = 1 then m = 83: goto 460
21540 gosub 2790:a = 23: goto 2550
21550 rem 38:
21560 a = 11: gosub 2360: if s <>2 then m = 84: goto 460
21570 m = 85: gosub 460: gosub 2790:a = 23: gosub 2200:a = 24: goto 2140
21580 rem 39:
21590 m = 86: gosub 460
21600 a = 27: gosub 2360: if s <>1 then print ".": return
21610 m = 184: goto 460
21620 rem 40:
21630 if l = 33 and s = 1 then gosub 2550:re = 23: goto 21070
21640 goto 2550
21650 rem 41:
21660 if s = 1 then m = 121: goto 460
21670 m = 87: gosub 460: gosub 2790:s = 2: goto 1920
21680 rem 42:
21690 if f(5) = 1 then gosub 2790:a = 28:s = 2: goto 1920
21700 a = 143: gosub 2360: if s = 1 then m = 88:mo = 1: goto 460
21710 m = 89: gosub 460:a = 143: goto 2140
21720 rem 43:
21730 a = 25: gosub 2360: if s = 0 then 2640
21740 if s = 1 then m = 91: goto 460
21750 a = 25: gosub 1830: if s = 2 then m = 92: goto 460
21760 m = 93: gosub 460:t(2) = 3:tm = 1:s = 2: goto 1920
21770 rem 44:
21780 a = 27: gosub 2360: if s <>2 and l = 21 then m = 94: goto 460
21790 if s <>2 then 2640
21800 gosub 1830: if s = 1 then 2640
21810 if cp% = 118 then m = 146: gosub 3000: if s = 0 then return
21820 a = 143: gosub 2360: if s <>1 then m = 7: goto 460
21830 if l <>21 then m = 7: goto 460
21840 if t(2) = 0 then m = 97:mo = 1: goto 460
21850 m = 98: gosub 460:f(5) = 1: gosub 2790:a = 143: goto 2200
21860 rem 45:
21870 a = 28: gosub 1830: if s = 1 then m = 49: goto 460
21880 a = 29: gosub 2360: if s <>1 then if f(11) then m = 23: goto 460
21890 m = 99: gosub 460:f(11) = 1: gosub 2790:a = 29: goto 2140
21900 rem 46:
21910 if s = 2 then re = 3: goto 20340
21920 m = 212: goto 460
21930 return
21940 rem 47:
21950 if f(1) then m = 214: goto 460
21960 m = 213: goto 460
21970 return
21980 rem 48:
21990 if f(1) then re = 7: goto 20540
22000 m = 213: goto 460
22010 return
22020 rem 49:
22030 if s = 2 then m = 215: goto 460
22040 m = 216: goto 460
22050 return
22060 rem 50:
22070 if f(6) = 0 then m = 104: goto 460
22080 f(6) = f(6) +1: if f(6) = 5 then m = 105: gosub 460: for j = 1 to 12: print be$;:dy = 32: gosub 2950: next :m = 106:f(7) = 1: gosub 2790: goto 460
22090 if f(6) >5 then m = 107: goto 460
22100 m = 106 +f(6): goto 460: rem 57,58,59
22110 return
22120 rem 51:
22130 a = 24: gosub 2360: if s <>2 then m = 111: goto 460
22140 if f(6) >5 then m = 112: goto 460
22150 if f(6) then m = 113: goto 460
22160 for k = 1 to 4: for j = 1 to 15:a = peek(ck):dy = .6: gosub 2950: next :dy = 20: gosub 2950: next
22170 m = 114: gosub 460:f(6) = 1: gosub 2790:a = 32:s = 2: goto 1920
22180 rem 52:
22190 if s = 2 then m = 217: goto 460
22200 m = 212: goto 460
22210 return
22220 rem 53:
22230 if s = 1 then m = 117: goto 460
22240 if l = 61 then m = 206: gosub 460: goto 3200
22250 if l <>34 then m = 118: goto 460
22260 gosub 2790:m = 119: gosub 460
22270 print : print : print " Cosa devo fare ? ";: poke ks,0
22280 get a$
22290 print be$;be$;be$;:m = 120: gosub 460
22300 poke ks,0
22310 a = 3: gosub 2360: if s <>2 then m = 25: gosub 460: gosub 20370:m = 34:mo = 1: goto 460
22320 pt = 999:t(4) = 4:tm = 1:m = 200: goto 460
22330 rem 54:
22340 return
22350 rem 55:
22360 return
22370 rem 56:
22380 return
22390 rem 57:
22400 return
22410 rem 58:
22420 return
22430 rem 59:
22440 return
22450 rem 60:
22460 m = 147: gosub 3000: if s = 1 then m = 124: goto 460
22470 : return
22480 rem 61:
22490 m = 148: gosub 3000: if s = 1 then m = 53: goto 460
22500 return
22510 rem 62:
22520 if s <>2 then 2640
22530 m = 127: goto 460
22540 rem 63:
22550 if s <>2 then 2640
22560 goto 22530
22570 rem 64:
22580 return
22590 rem 65:
22600 if l <24 or l >32 then m = 129: goto 460
22610 m = 130: gosub 460:j = 1
22620 speed= 120: for i = 1 to 30 *j: print "mumble...";: next
22630 print :m = 131: gosub 460:m = 149: gosub 3000: if s = 1 then j = j *2: goto 22620
22640 return
22650 rem 66:
22660 return
22670 rem 67:
22680 return
22690 rem 68:
22700 return
22710 rem 69:
22720 m = 95: gosub 460: goto 2200
22730 rem 70:
22740 a = 25: gosub 2360: if s <>2 then m = 125: goto 460
22750 gosub 1830: if s = 2 then m = 92: goto 460
22760 m = 126: gosub 460:s = 2: goto 1920
22770 rem 71:
22780 return
22790 rem 72:
22800 t(3) = 1:tm = 1:m = 93: goto 460
22810 rem 73:
22820 a = 100 * rnd(0): if a <21 then l = 58: return
22830 m = 140: goto 460
22840 rem 74:
22850 if tu%(l) <50 then tu%(l) = 50:l = 21: return
22860 mo = 1:m = 137: goto 460
22870 rem 75:
22880 if t(3) then mo = 1:m = 139: goto 460
22890 l = 22: return
22900 rem 76:
22910 gosub 2790:a = 19: gosub 2360: if s <>2 then 22950
22920 a = 25: gosub 2360: if s <>2 then 22950
22930 gosub 1830: if s = 2 then 22950
22940 s = 2: gosub 1920:m = 126: gosub 460
22950 l = 35: return
22960 rem 77:
22970 return
22980 rem 78:
22990 return
23000 rem 79:
23010 return
23020 rem 80:
23030 return
30000 rem chain filer
30010 rem in: fc=comando filer
30020 dclose#1:dclose#2: rem l,m
30030 :
30040 dload"filer"
