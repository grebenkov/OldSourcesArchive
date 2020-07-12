{ Taken from PC World Best of *.* Volume 2 (1989) }
{ NO LICENSE PROVIDED, PROBABLY PUBLIC DOMAIN (published on coverdisk) }
{ Documentation: }
{ Title:      "Bullet-Proofing Pascal Input" }
{ Reference:  PC World April 1989 }
{ Author:     Michael Fang }

{ Although Turbo Pascal's Readln and Read procedures can input strings, }
{ they lack the editing features of a word processor. To enhance string }
{ input in your own Pascal programs, add procedure GetLn to your code, }
{ as demonstrated in TESTEDIT.PAS. To try it out, load the program into }
{ Turbo's editor and press <Ctrl>-<F9> to run. The procedure duplicates }
{ many of WordStar's popular keystrokes. Press <Ctrl>-T to delete a }
{ word, <Ctrl>-<Cursor Right> to move to the next word, <Ctrl>-<Cursor }
{ Left> to move to the previous word, and <Home> and <End> to jump to }
{ the beginning and end of the string. }

PROGRAM TestEdit;
USES  Dos, Crt;
CONST HOME=18176; ENDD=20224; LEFT=19200; RIGHT=19712;
      BACK=8; ENTER=13; ESC=27; INS=20992; DEL=21248; WRDLEFT=29440; 
      WRDRIGHT=29696; DELWRD=20; DELEOL=17; Blank=' '; {one blank}
VAR   teststr: string; p: integer;

FUNCTION GetKey:Integer;
var   regs: registers; key: integer;
BEGIN
   regs.ah := 0;
   intr( $16, regs );
   if regs.al = 0 then begin
      key := regs.ah; key := key shl 8
   end else
      key := regs.al;
   getkey := key
END; { getkey }

PROCEDURE GetLn( var xstr: string; n: integer; var position: integer );
var
   oldx, oldy: byte; workstr: string; xlen: integer;
   strpos: integer; oldlen: integer; key: integer;
   insmode: Boolean; i: integer;

   procedure initialize;
   begin
      oldx := wherex; oldy := whereY;
      workstr := xstr; insmode := true;
      xlen := lo( windmax ) - lo( windmin ) + 1 - oldx;
      if n > xlen then n := xlen;
      if length( workstr ) > n then workstr[0] := char(n);
      if position < 1 then position := 1;
      if position > length( workstr ) then
         position := length( workstr ) + 1;
      strpos := oldx + position - 1;
      write( workstr );
      gotoxy( strpos, oldy )
   end; { intitialize }

BEGIN { GetLn }
   initialize;
   repeat
      key := getkey;
      case key of
      32..126: if ( length( workstr ) < n ) and ( insmode or 
                  ( position > length( workstr ) ) ) then begin
                  insert( char(key), workstr, position );
                  inc( position );
                  gotoxy( oldx, oldy );
                  write( workstr )
               end else
               if ( not insmode ) and ( position < n + 1 ) then begin
                  workstr[ position ] := char( key );
                  write( workstr[ position ] );
                  inc( position )
               end;
      INS:     insmode := not insmode;
      ENTER:   xstr := workstr;
      LEFT:    if position > 1 then dec( position );
      RIGHT:   if position <= length( workstr ) then inc( position );
      HOME:    position := 1;
      ENDD:    position := length( workstr ) + 1;
      BACK:    if position > 1 then begin
                  dec( position );
                  delete( workstr, position, 1 );
                  gotoxy( oldx, oldy );
                  write( workstr, Blank )
               end;
      DEL:     if position <= length( workstr ) then begin
                  delete( workstr, position, 1 );
                  gotoxy( oldx, oldy );
                  write( workstr, Blank )
               end;
      DELWRD:  begin
                  oldlen := length( workstr );
                  if workstr[ position ] = Blank then
                     while ( workstr[ position ] = Blank ) and
                     ( position <= length( workstr ) ) do
                     delete( workstr, position, 1 )
                  else begin
                     while ( workstr[ position ] <> Blank ) and
                           ( position <= length( workstr ) ) do
                     delete( workstr, position, 1 );
                     while ( workstr[ position ] = Blank ) and
                           ( position <= length( workstr ) ) do
                     delete( workstr, position, 1 );
                  end; { else }
                  gotoxy( oldx, oldy );
                  write( workstr );
                  for i := 1 to oldlen - length( workstr ) do 
                     write( Blank )
               end;
      DELEOL:  begin 
                  oldlen := length( workstr );
                  case getkey of 
                     89, 121: if position <= oldlen then
                                 delete( workstr, position, 256 )
                  end; { case }
                  for i := 1 to oldlen - length( workstr ) do
                     write( Blank )
               end;
      WRDLEFT: if position > 1 then
               if ( position = 2 ) and 
                  ( workstr[ position ] <> Blank ) and
                  ( workstr[ position-1 ] = Blank ) then dec( position )
               else begin
                  if ( workstr[ position - 1 ] = Blank ) or
                     ( workstr[ position     ] = Blank ) then
                     repeat dec( position );
                     until ( position = 1 ) or 
                           ( workstr[ position ] <> Blank );
                  while ( workstr[ position ] <> Blank ) and 
                        ( position > 1 ) do dec( position );
                  if ( workstr[ position ] = Blank ) and
                     ( workstr[ position + 1 ] <> Blank ) then
                        inc( position )
               end;
      WRDRIGHT:   if position < length( workstr ) + 1 then begin
                     while ( workstr[ position ] <> Blank ) and
                           ( position < length( workstr ) + 1 ) do
                        inc( position );
                     while ( workstr[ position ] = Blank ) and
                           ( position < length( workstr ) + 1 ) do
                        inc( position );
                  end;
      end; { case }
      strpos := oldx + position - 1;
      gotoxy( strpos, oldy )
   until ( key = ENTER ) or ( key = ESC )
END; { GetLn }

BEGIN { TestEdit }
   clrscr;
   teststr := 'Read Star-Dot-Star in PC World!';
   p := 1;
   GetLn( teststr, 79, p );
   gotoxy( 1, 3 );
   writeln( 'Edited string = ', teststr )
END.
