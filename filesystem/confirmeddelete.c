/* Taken from PC World Best of *.* Volume 1 (1988) 
   NO LICENSE PROVIDED, PROBABLY PUBLIC DOMAIN (published on coverdisk) 
   
   DEL command replacement, asks for confirmation when deleting a file.
   
   REFERENCES
   "Oh, Those Wild Deletes" by Vincent D. O'Connor, November 1988
*/
/* delver.c, written by Vincent D. O'Connor in Turbo C */

#include <dos.h>
#include <dir.h>
#include <conio.h>
#include <stdio.h>
#include <ctype.h>
#include <process.h>

struct ffblk block;
char dir [MAXDIR], path [MAXPATH], drive [MAXDRIVE], file [MAXFILE];
char ext [MAXEXT];

void main (argc, argv)
    unsigned argc;
    char *argv [];

{
    if (argc != 2) {
        printf ("\aMust have two arguments\n");
        exit (1);
        }

    fnsplit (argv [1], drive, dir, 0, 0);

    if (findfirst (argv [1], &block, 0)){
        printf ("\aInvalid path");
        exit (1);
        }

    do  {
         fnsplit (block.ff_name, 0, 0, file, ext);
         fnmerge (path, drive, dir, file, ext);
         printf ("\nDelete %s? ", path);
         if (toupper (getche ()) == 'Y')
            if (unlink (path))
                    printf ("\aError while attempting deletion of file");
        } while (!findnext (&block));

    exit (0);

}
