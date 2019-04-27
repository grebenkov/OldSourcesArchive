CLS
DEFINT A-Z

FOR i = 1 TO 8
   FOR j = 1 TO 3
    READ cps(i, j)
  NEXT j
NEXT i

FOR k = 1 TO 8
  READ protocol$(k)
NEXT k

COLOR 11: PRINT CHR$(201); STRING$(78, CHR$(205)); CHR$(187)
          PRINT CHR$(186); STRING$(78, " "); CHR$(186)
          PRINT CHR$(186); STRING$(78, " "); CHR$(186)
          PRINT CHR$(186); STRING$(78, " "); CHR$(186)
          PRINT CHR$(200); STRING$(78, CHR$(205)); CHR$(188)

COLOR 10:
     LOCATE 2, 3: PRINT "TRANSFER TIME CALCULATOR - Popular Transfer Protocols Compared"
COLOR 15:   
     LOCATE 3, 18: PRINT "The PROF-BBS - Lexington, KY - FidoNet 108/111 - 606/269-1565"
     LOCATE 4, 10: PRINT "Copyright 1990 - Don Bodley, SysOp - Contributed to the Public Domain"
     PRINT : PRINT : PRINT

BEGIN:

COLOR 11: LOCATE 7, 66: PRINT STRING$(10, " ")
     LOCATE 7, 4: PRINT ">>> Enter Size of File to be Downloaded in bytes or 0 to Exit: ";
COLOR 15: INPUT "", size!
     IF size! = 0 THEN GOTO ALLDONE

FOR x = 1 TO 8
    FOR y = 1 TO 3
      speed(x, y) = (size! \ cps(x, y)) + 5
      mins(x, y) = speed(x, y) \ 60
      secs(x, y) = speed(x, y) MOD 60
    NEXT y
NEXT x

COLOR 15: PRINT : PRINT
PRINT "   +---------------+-----------------+-----------------+-----------------+"
PRINT "   | PROTOCOL      |    1200 baud    |    2400 baud    |    9600 baud    |"
PRINT "   +---------------+-----------------+-----------------+-----------------+"
FOR P = 1 TO 8
PRINT "   |               |                 |                 |                 |"
NEXT P
PRINT "   +---------------+-----------------+-----------------+-----------------+"

COLOR 10:
FOR x = 1 TO 8
    LOCATE 12 + x, 6: PRINT USING "\         \"; protocol$(x)
    LOCATE 12 + x, 21: PRINT USING "### min. ## sec."; mins(x, 1); secs(x, 1)
    LOCATE 12 + x, 39: PRINT USING "### min. ## sec."; mins(x, 2); secs(x, 2)
    LOCATE 12 + x, 57: PRINT USING "### min. ## sec."; mins(x, 3); secs(x, 3)
NEXT x
    
COLOR 11: PRINT : PRINT : PRINT "   >>> Press Any Key to continue... ";
    WHILE INKEY$ = "": WEND
    LOCATE 22: PRINT STRING$(78, " ");
    GOTO BEGIN

ALLDONE:
    CLS : END

' average protocol time in cps
DATA 80,114,180
DATA 108,221,890
DATA 108,222,890
DATA 114,234,1090
DATA 116,236,1120
DATA 117,235,1120
DATA 117,235,1120
DATA 116,236,1115
DATA Xmodem,1K Xmodem,Ymodem,Zmodem,Puma,Ymodem-G,1K Xmodem-G,BiModem

