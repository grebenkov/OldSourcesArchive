(* Taken from PC World Best of *.* Volume 1 (1988) 
  NO LICENSE PROVIDED, PROBABLY PUBLIC DOMAIN (published on coverdisk) 
  Documentation: 

Title:      "New Math for Turbo Pascal"
Reference:  PC World August 1989
Author:     Keith Hattes

The file MATH.PAS is a Turbo Pascal unit (submodule) that contains a
variety of math functions not normally available, including a
function to raise numbers to a power, convert radians to degrees, and
calculate permutations. To use the unit, compile MATH.PAS to disk,
creating MATH.TPU. Then, insert the phrase USES MATH; after your
PROGRAM declaration. This makes the functions in the compiled unit
available to your program. Turbo Pascal 4.0 users must have a math
coprocessor in order to use the MATH unit. Versions 5.0 and 5.5 (and
presumably later releases) work with and without a math chip. *)

(* Turbo Pascal Math Functions by Keith A. Hattes *)

unit Math;

{$IFDEF VER40} {$N+} {$ELSE} {$N+,E+} {$ENDIF}

interface

Function Power( base, exponent : Double ) : Double;
   { Power of base rased to exponent }
Function Log( argument : Double ) : Double;
   { Log (base 10) of argument }
Function Rad( degrees : Double ) : Double;
   { Convert radians to degrees }
Function Deg( radians : Double ) : Double;
   { Convert degrees to radians }
Function Fact( x : Integer ) : Double;
   { Factorial of x }
Function Perm( n, r : integer ) : Double;
   { Permutations of n taken r at a time }
Function Comb( n, r : Integer ) : Double;
   { Combinations of n taken r at a time }

implementation

(* Original Power function from *.* 8/89
Function Power( base, exponent : Double ) : Double;
begin
   Power := Exp( exponent * Ln( base ) )
end; { Power }
*)

(* Corrected Power function from *.* 12/89*)
function power( base, exponent : Double ) : Double;
   function f( b, e : Double ) : Double;
      begin f := exp( e * ln( b ) ); end;
begin
  if base = 0.0
    then
      if exponent = 0.0
        then power := 1.0
        else
          if exponent < 0.0
            then runError( 207 )    { 0^negative }
            else power := 0.0
    else
      if base > 0.0
        then power := f( base, exponent )
    else
      if frac( exponent ) = 0.0
        then
          if odd( trunc( exponent ) )
            then power := -f( -base, exponent )
            else power :=  f( -base, exponent )
        else runError( 207 )     { negative^noninteger }
end; { power }

Function Log( argument : Double ) : Double;
const BASE = 10;
begin
   Log := Ln( argument ) / Ln( BASE )
end; { Log }

Function Rad( degrees : Double ) : Double;
const DEGCONVERT = 180.0;
begin
   Rad := Degrees * Pi / DEGCONVERT
end; { Rad }

Function Deg( radians : Double ) : Double;
const RADCONVERT = 180.0;
begin
   Deg := Radians * Radconvert / Pi
end; { Deg }

Function Fact( x : Integer ) : Double;
var   loop : Integer; mult : Double;
begin
   mult := 1;
   For loop := 1 To X Do
      mult := mult * loop;
   Fact := mult
end; { Fact }

Function Perm( n, r : integer ) : Double;
begin
   Perm := Fact( n ) / Fact( n - r )
end; { Perm }

Function Comb( n, r : Integer ) : Double;
begin
   Comb := Perm( n, r ) / Fact( r )
end; { Comb }

end. { Math unit }
