1 REM ИГРА "HALLOWEEN"
2 REM ADAPTED BY ANDROID CORPORATION
3 REM (С) БАЙТИК 1990
10 ? CHR$(148)CHR$(158)CHR$(140)CHR$(140)CHR$(145);
20 POKE &O177660,64%
30 ? AT(11,11)"HALLOWEEN";
40 FOR A%=0% TO 500%
50 OUT -50%,64%,1%
60 OUT -50%,64%,1%
70 OUT -50%,64%,0%
80 OUT -50%,64%,0%
90 NEXT A%
100 ? AT(6,23)"УПРАВЛЕНИЕ КУРСОРОМ";
110 IF INP(&O177716,64%)=64% TH 110
120 CLS
130 FOR A%=0% TO 500%
140 OUT -50%,64%,1%
150 OUT -50%,64%,1%
160 OUT -50%,64%,0%
170 OUT -50%,64%,0%
180 NEXT A%
190 POKE &O177660,0%
200 POKE &O104,0%
210 INPUT"КЛАСС(0-9)";LV%
220 CLS
230 POKE &O177660,64%
240 DE%=1000%-ABS(LV%*100%)
250 IF DE%<40% TH 940
260 CE%=0%
270 X0%=(RND(1%)*29%)+1%
280 Y0%=(RND(1%)*21%)+1%
290 POKE &O164,&O3200
300 P%=&O42000+X0%*2%+Y0%*640%
310 GOSUB 540 
320 LINE (6,6)-(249,233),2,B
330 ? AT(0,24)"УРОВЕНЬ:"LV%;AT(15,CSRLIN)"ПОРАЖЕНО ЦЕЛЕЙ:"CE%;
340 IF X%<1% OR X%>30% TH X%=1%
350 IF Y%<1% OR Y%>22% TH Y%=1%
360 AA%=PEEK(&O177662)
370 P%=&O42000+X%*2%+Y%*640%
380 GOSUB 760
390 IF X%=X0% AND Y%=Y0% TH 800
400 IF AA%=8% AND X%>1% TH X%=X%-1%
410 IF AA%=25% AND X%<30% TH X%=X%+1%
420 IF AA%=26% AND Y%>1% TH Y%=Y%-1%
430 IF AA%=27% AND Y%<22% TH Y%=Y%+1%
440 P%=&O42000+X%*2%+Y%*640%
450 GOSUB 650
460 IF X%=X0% AND Y%=Y0% TH 800
470 FOR A%=0% TO DE%
480 NEXT A%
490 IF X%<>X1% OR Y%<>Y1% TH OUT &O177716,64%,1%
500 X1%=X%
510 Y1%=Y%
520 OUT &O177716,64%,0%
530 GOTO 360
540 POKE P%+&O0000,&B0000101010000000
550 POKE P%+&O0100,&B0010011010100000 
560 POKE P%+&O0200,&B1001101010101000 
570 POKE P%+&O0300,&B1010101010101000 
580 POKE P%+&O0400,&B1000001000001000 
590 POKE P%+&O0500,&B1010001000101000 
600 POKE P%+&O0600,&B0000101010000000 
610 POKE P%+&O0700,&B0010000000100000 
620 POKE P%+&O1000,&B0010101010100000 
630 POKE P%+&O1100,&B0000101010000000 
640 RETURN
650 POKE P%+&O0000,&B0000000101000000 
660 POKE P%+&O0100,&B0000000101000000 
670 POKE P%+&O0200,&B0101010101010101 
680 POKE P%+&O0300,&B0000000101000000 
690 POKE P%+&O0400,&B0001010101000000 
700 POKE P%+&O0500,&B0000000101010100 
710 POKE P%+&O0600,&B0000000101000000 
720 POKE P%+&O0700,&B0000000101000000 
730 POKE P%+&O1000,&B0000000101000000 
740 POKE P%+&O1100,&B0000000000000000 
750 RETURN
760 FOR A%=0% TO &O1100 STEP 64%
770 POKE A%+P%,0%
780 NEXT A%
790 RETURN 
800 CE%=CE%+1%
810 FOR A%=0% TO 500%
820 OUT -50%,64%,1%
830 OUT -50%,64%,1%
840 OUT -50%,64%,1%
850 OUT -50%,64%,0%
860 OUT -50%,64%,0%
870 OUT -50%,64%,0%
880 NEXT A%
890 DE%=DE%-10%
900 IF DE% < 40% TH 940
910 IF CE% > 9% TH LV%=ABS(LV%)+1%
920 IF CE% > 9% TH 220
930 GOTO 270 
940 CLS
950 ?"ВЫ ПРОШЛИ ИГРУ. ПОЗДРАВЛЯЮ !!!”;
960 IF INP(&O177716,64%)=64% TH 960 ELSE 10
