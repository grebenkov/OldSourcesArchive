{ Taken from PC World Best of *.* Volume 1 (1988) }
{ NO LICENSE PROVIDED, PROBABLY PUBLIC DOMAIN (published on coverdisk) }
{ Documentation: }
{ WINDOWS.PAS expands on the ideas in POPUP.PAS (popupwindow.pas), showing how to program }
{ many windows on top of each other.  Run this program from inside the }
{ Turbo Pascal editor, or just type WINDOWS and press <Enter> at the }
{ DOS prompt for a demo.  If you have a Monochrome or Hercules display, }
{ change the scr_seg constant to $B000. }

{ REFERENCES }

{ "Pascal Pop-Ups" by Michael Fang, February 1988 }
{ "Pop-Up Bug" by George L. Shevenock II, August 1988 }
{ "Pop Goes the Window" by Stephen R. Brazzell, June 1988 }

program windows;

USES    crt, turbo3;    { Turbo 4.0-5.0.  Remove for earlier versions. }

const   top_ss : integer = 0;
        scr_seg = $b800;          { use $b000 for Monochrome * Hercules }

var     screenstack : array[ 1 .. 10000 ] of byte;
        j  : integer;
        cc : char;


procedure dobox( x1, y1, x2, y2 : integer );

var     ul, ur, ll, lr, h, v : integer;
        x, y : integer;

    procedure putchar( char_num, x, y : integer );
    begin
        gotoxy( x, y );
        write( chr( char_num ) );
    end;

begin
    ul := 201; ur := 187; ll := 200; lr := 188; h := 205; v := 186;
    putchar( ul, x1, y1 );
    putchar( ur, x2, y1 );
    putchar( ll, x1, y2 );
    putchar( lr, x2, y2 );
    for x := x1 + 1 to x2 - 1 do
    begin
        putchar( h, x, y1 );
        putchar( h, x, y2 );
    end;
    for y := y1 + 1 to y2 - 1 do
    begin
        putchar( v, x1, y );
        putchar( v, x2, y );
    end;
end;


function firstbyte( x, y : integer ) : integer;
begin
    firstbyte := ( x-1 ) * 2 + ( y-1 ) * 160;
end;


function lastbyte( x, y : integer ) : integer;
begin
    lastbyte:=( x-1 ) * 2 + ( y-1 ) * 160 + 1;
end;


procedure push_screen( x1, y1, x2, y2 : integer );
var     a, x, y : integer;
begin
    window( 1, 1, 80, 25 );
    a := 0;
    for y := y1 to y2 do
    begin
        for x := firstbyte( x1, y ) to lastbyte( x2, y ) do
        begin
            a := a + 1;  
            top_ss := top_ss + 1;
            screenstack[ top_ss ] := ( mem[ scr_seg:x ] );
        end;
    end;
    a := a + 5;
    top_ss := top_ss+1;   screenstack[ top_ss ] := ( x1 );
    top_ss := top_ss+1;   screenstack[ top_ss ] := ( y1 );
    top_ss := top_ss+1;   screenstack[ top_ss ] := ( x2 );
    top_ss := top_ss+1;   screenstack[ top_ss ] := ( y2 );
    top_ss := top_ss+1;   screenstack[ top_ss ] := ( a div 256 );
    top_ss := top_ss+1;   screenstack[ top_ss ] := ( a mod 256 );
    dobox( x1, y1, x2, y2 );
    window( x1+1, y1+1, x2-1, y2-1 );  
    clrscr;
end;


procedure pop_screen;
var     x, y, a, b, x1, y1, x2, y2 : integer;
begin
    if top_ss <> 0 then
    begin
        b  := ( screenstack[ top_ss ] );
        x1 := ( screenstack[ top_ss-1 ] );
        b  := x1 * 256 + b;    
        a  := top_ss - b - 1;
        x1 := ( screenstack[ top_ss-5 ] );
        y1 := ( screenstack[ top_ss-4 ] );
        x2 := ( screenstack[ top_ss-3 ] );
        y2 := ( screenstack[ top_ss-2 ] );
        top_ss := top_ss - b - 1;
        for y := y1 to y2 do
        begin
            for x := firstbyte( x1, y ) to lastbyte( x2, y ) do
            begin
                a := a + 1;
                mem[ scr_seg:x ] := ( screenstack[a] );
            end;
        end;
        if top_ss <> 0 then
        begin
            y2 := ( screenstack[ top_ss-2 ] );
            x2 := ( screenstack[ top_ss-3 ] );
            y1 := ( screenstack[ top_ss-4 ] );
            x1 := ( screenstack[ top_ss-5 ] );
            window( x1+1, y1+1, x2-1, y2-1 );
        end
            else window( 1, 1, 80, 25 );
    end
        else window( 1, 1, 80, 25 );
end;


begin
    clrscr;
    for j := 1 to 30 do
    begin
        write( 'This is some sample text to show ' );
        writeln( 'that the screen is restored...Ok............' );
    end;
    writeln;
    writeln( 'hit any key to begin seeing windows' );
    read( kbd, cc );

    push_screen( 2, 2, 67, 7 );
    writeln;
    writeln( '         here is the first overlapping window' );
    writeln( '                   hit any key.' );
    read( kbd, cc );

    push_screen( 25, 1, 77, 20 );
    writeln;
    writeln;
    writeln;
    writeln;
    writeln( '          this is an example of another' );
    writeln( '             overlapping window....' );
    writeln( '                 hit any key.' );
    read( kbd, cc );

    push_screen( 10, 18, 68, 23 );
    writeln;
    writeln( '          here is yet another window' );
    write( '                 hit any key.' );

    read( kbd, cc );    pop_screen;
    read( kbd, cc );    pop_screen;
    read( kbd, cc );    pop_screen;
    
    gotoxy( 1, 25 );    writeln

end.
