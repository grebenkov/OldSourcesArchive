; Taken from PC World Best of *.* Volume 1 (1988)
; NO LICENSE PROVIDED, PROBABLY PUBLIC DOMAIN (published on coverdisk) 
; INSTRUCTIONS

; Have you ever started printing in mid-page accidentally because you
; previously printed a screen dump with <Shift>-<PrtSc> and forgot to
; press the form feed button?  If so, PSFF.COM will prevent that mishap
; by dumping your screen and pressing the form feed button for you.

; At the DOS prompt, type PSFF and press <Enter> to load
; the program into memory.  Because PSFF is a memory-resident program,
; do this only once.  (You might want to add the line PSFF to your
; AUTOEXEC.BAT file to load PSFF every time you boot.)

; To print the display as usual, press the left <Shift> key along with
; <Print Screen>.  To print the display and advance the paper to the
; top of the next page, press the right <Shift> key along with <Print
; Screen>.

; The PSFF.ASM file lists the assembly language text of the PSFF.COM
; program.  You can use Microsoft's Macro Assembler or Turbo Assembler
; to assemble this file.

; REFERENCES

; "Down in the Dumps" by Bruce L. Gregory, August 1988

;--------------------------------------------------
;      PSFF.ASM:   Print Screen with Form Feed
;      Written by: Bruce Gregory
;--------------------------------------------------

cseg    segment para public 'CODE'
        assume  cs:cseg,ds:cseg,ss:cseg,es:cseg

        org     100h            ; .COM file entry point

begin:  
        jmp     start           ; jump to TSR loader code

;----- New keyboard interrupt 9 handler

addroff dw      0       ; original interrupt vector (offset)
addrseg dw      0       ; original interrupt vector (segment)

int9:
        sti                     ; turn on interrupts
        push    ax              ; save ax register
        push    ds              ; save ds register
        in      al,60h          ; get keyboard data
        cmp     al,37h          ; test for PrtSc key
        jne     exit            ; exit if keypress is not PrtSc
        xor     ax,ax           ; set ax = 0000
        mov     ds,ax           ; set ds = 0000 to read BIOS data
        mov     al,byte ptr ds:[0417h]
        test    al,01h          ; test for <ShiftRight>
        jz      exit            ; exit if <ShiftRight> not down
        in      al,61h          ; get keyboard control information
        mov     ah,al           ; save in ah
        or      al,80h          ; set high bit
        out     61h,al          ; clear keyboard
        mov     al,ah           ; get saved control information
        out     61h,al          ; restore 8255A output data
        mov     al,20h          ; end of interrupt command
        out     20h,al          ; send command to intr. control port
        int     05h             ; perform screen dump
        push    dx              ; save dx register
        mov     dx,0000h        ; select printer #0
        mov     ax,000Ch        ; ah=print char; al=ASCII form feed
        int     17h             ; perform form feed
        pop     dx              ; restore saved dx register
        pop     ds              ; restore saved ds register
        pop     ax              ; restore saved ax register
        iret                    ; return from interrupt

;----- Jump to original BIOS keyboard interrupt (9)

exit:
        pop     ds              ; restore saved ds register
        pop     ax              ; restore saved ax register
        jmp     dword ptr cs:[addroff]

;----- Terminate and stay resident (TSR) loader

start:
        mov     ax,3509h        ; get current interrupt 9 vector
        int     21h             ; call DOS function
        mov     addroff, bx     ; save offset address
        mov     addrseg, es     ; save segment address
        mov     dx,offset int9  ; ds:dx = address of our handler
        mov     ax,2509h        ; change vector to our intr. 9 code
        int     21h             ; call DOS function
        mov     dx,offset message  ; display "installed" message
        mov     ah,9            ; print ASCII$ string
        int     21h             ; call DOS function
        mov     dx,offset start ; ds:dx = lowest available address
        int     27h             ; terminate, stay resident to ds:dx

message db      13, 10, 'PSFF Installed', 13, 10, '$'

cseg    ends                    ; end of segment
        end     begin           ; end of text
