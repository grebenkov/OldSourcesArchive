{ Taken from PC World Best of *.* Volume 1 (1988) }
{ NO LICENSE PROVIDED, PROBABLY PUBLIC DOMAIN (published on coverdisk) }
{ Documentation: }
{ Load POPUP.PAS into Turbo Pascal's editor.  If you have a Monochrome }
{ or Hercules display, change the DISPLAY constant to $0B000.  Compile }
{ and run.  If you don't have Turbo Pascal, type POPUP and press }
{ <Enter> at the DOS prompt.  You'll see a display full of text.  Press }
{ <Enter> to clear the screen.  Then press <Enter> again to restore a }
{ portion of the display. }

{ Procedure MoveFromScreen in POPUP.PAS moves the screen contents into }
{ an array variable.  Procedure MoveToScreen moves the array's contents }
{ back to the screen.  Together, the two routines save and restore any }
{ rectangular display window. }

{ REFERENCES }

{ "Pascal Pop-Ups" by Michael Fang, February 1988 }
{ "Pop-Up Bug" by George L. Shevenock II, August 1988 }
{ "Pop Goes the Window" by Stephen R. Brazzell, June 1988 }
PROGRAM PopUp;

USES    crt, turbo3;    { Turbo 4.0-5.0.  Remove for earlier versions. }

CONST   DISPLAY = $0B800;  { $0B000 for Monochrome & Hercules displays }
VAR     buffer : ARRAY[ 1 .. 4000 ] OF BYTE;
        ulc, ulr, i, j : INTEGER;

PROCEDURE MoveFromScreen( x1, y1, x2, y2 : BYTE; VAR Buff );
VAR  upper, right, down, first, second, start : INTEGER;
     buffer : ARRAY[ 1 .. 4000 ] OF BYTE ABSOLUTE Buff;
BEGIN
   start := 1;
   upper := (((2*x1)-2)+((y1-1)*160))-1;
   right := ((x2-x1)+1)*2;
   down := (y2-y1)+1;
   FOR first := 1 TO down DO BEGIN
      FOR second := 1 TO right DO BEGIN
         buffer[ start ] := mem[ DISPLAY:upper + second ];
         start := succ( start )
      END;
      upper := upper + 160;   { advance to next line }
   END;
END;

PROCEDURE MoveToScreen( x1, y1, x2, y2 : BYTE; VAR Buff );
VAR  upper, right, down, first, second, start : INTEGER;
     buffer : ARRAY[ 1 .. 4000 ] OF BYTE ABSOLUTE Buff;
BEGIN
   start := 1;
   upper := (((2*x1)-2)+((y1-1)*160))-1;
   right := ((x2-x1)+1)*2;
   down := (y2-y1)+1;
   FOR first := 1 TO down DO BEGIN
      FOR second := 1 TO right DO BEGIN
         mem[ DISPLAY:upper+second ] := buffer[ start ];
         start := succ(start);
      END;
      upper := upper + 160;   { advance to next line }
   END;
END;

BEGIN
   ulc := 20; ulr := 6;
   TextMode(3); ClrScr;
   FOR i := 1 TO 19 DO        { create some text on screen }
      FOR j := 33 TO 123 DO
         Write( chr(j) );
   Write( '  *.*. PC Word, February 1988' );
   Writeln; Writeln;
   Write( '   Press <Enter> to display pop-up window.' );
   MoveFromScreen( 20, 6, 60, 18, buffer );  { Save screen }
   Readln;
   Gotoxy( ulc, ulr);    Write( 'ЙНННННННННННННННННННННННННННННННН»' );
   Gotoxy( ulc, ulr+1 ); Write( 'є                                є' );
   Gotoxy( ulc, ulr+2 ); Write( 'є   This pop-up window could     є' );
   Gotoxy( ulc, ulr+3 ); Write( 'є     display a menu listing     є' );
   Gotoxy( ulc, ulr+4 ); Write( 'є     or help information.       є' );
   Gotoxy( ulc, ulr+5 ); Write( 'є                                є' );
   Gotoxy( ulc, ulr+6 ); Write( 'є                                є' );
   Gotoxy( ulc, ulr+7 ); Write( 'є                                є' );
   Gotoxy( ulc, ulr+8 ); Write( 'є       Press <Enter> to         є' );
   Gotoxy( ulc, ulr+9 ); Write( 'є        restore screen.         є' );
   Gotoxy( ulc, ulr+10); Write( 'є                                є' );
   Gotoxy( ulc, ulr+11); Write( 'ИННННННННННННННННННННННННННННННННј' );
   Gotoxy( 1, 23 );
   Readln;
   MoveToScreen( 20, 6, 60, 18, buffer );    { Restore screen }
END.
