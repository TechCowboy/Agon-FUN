# Agon-FUN
Programs written to run on the Agon Light<br>
All the programs require a minimum of MOS 1.03 and VDP 1.03

## z88dk
WORK IN PROGRESS: 
Additional files to add to z88dk directory for Agon Light support
This will not support ADL mode, just Z80 (short) mode

## HelloWorld
Gotta start somewhere - first program that will be compiled once I get the compiler going

## HelloWorldASM and HelloWorldASMADL
See readme within directories for details

## Generic Info

## File Header / Program Skeleton

The agon executible files have a header for either mixed mode or ez80 mode
```
; mixed mode
    jp      start
;
; The header stuff is from byte 64 onwards
;
    align 64

mos_signature:
    db "MOS",0,0
    
    ; save the registers
    
    db 0x5b        ; lil prefix
    push ix

    db 0x5b        ; lil prefix 
    push iy		    

    db 0x5b        ; lil prefix
    push af	    

    db 0x5b        ; lil prefix
    push bc

    db 0x5b        ; lil prefix
    push de
    
    ;-----------------
    ; do z80 stuff
    ;-----------------
    
    ; Restore the registers

    db 0x5b        ; lil prefix
    pop de

    db 0x5b        ; lil prefix
    pop bc

    db 0x5b        ; lil prefix
    pop af

    db 0x5b        ; lil prefix
    pop iy	    	

    db 0x5b        ; lil prefix
    pop ix	

    db 0x49        ; lis prefix
    ld hl, 0  

    db 0x49        ; lis prefix
    ret 	   ; Return to MOS
```

```
; ez80 mode
    jp      start
;
; The header stuff is from byte 64 onwards
;

    align 64

mos_signature:
    db "MOS",0,1
start:

    push af
    push bc
    push de
    push ix 
    push iy
    
    ;-----------------
    ; do z80 stuff
    ;-----------------
    
    pop iy
    pop ix
    pop de
    pop bc
    pop af

    ld hl, 0

    ret

```

## MOS API

### RST $00
    Reset the eZ80

### RST $08
https://github.com/breakintoprogram/agon-docs/wiki/MOS-API </br>
The contents below was taken from mos_api.inc   

    MOS Command
    Function is value in accumuator
    for parameters see here:
```
	; MOS high level functions
	;
	mos_getkey:		EQU	00h
	mos_load:		EQU	01h
	mos_save:		EQU	02h
	mos_cd:			EQU	03h
	mos_dir:		EQU	04h
	mos_del:		EQU	05h
	mos_ren:		EQU	06h
	mos_mkdir:		EQU	07h
	mos_sysvars:		EQU	08h
	mos_editline:		EQU	09h
	mos_fopen:		EQU	0Ah
	mos_fclose:		EQU	0Bh
	mos_fgetc:		EQU	0Ch
	mos_fputc:		EQU	0Dh
	mos_feof:		EQU	0Eh
	mos_getError:		EQU	0Fh
	mos_oscli:		EQU	10h
	mos_copy:		EQU	11h
	mos_getrtc:		EQU	12h
	mos_setrtc:		EQU	13h
	mos_setintvector:	EQU	14h
	mos_uopen:		EQU	15h
	mos_uclose:		EQU	16h
	mos_ugetc:		EQU	17h
	mos_uputc:		EQU 	18h
	mos_getfil:		EQU	19h
	mos_fread:		EQU	1Ah
	mos_fwrite:		EQU	1Bh
	mos_flseek:		EQU	1Ch
```

### $10 VDU Character
    Output a single character to the VDP
    accumulator contains character to output
    
### $18 VDU String (MOS 1.03 or above)
    Output a stream of characters to the VDP
    hl - address of characters
    bc = print 'bc' characters, if zero, then use delimiter
    a  = deliminter if bc is zero


## Resources

### How to create a new target
https://github.com/z88dk/z88dk/wiki/Classic--Homebrew </br>
https://github.com/z88dk/z88dk/wiki/Classic--Retargetting

### Assembler
https://github.com/envenomator/agon-ez80asm

### Agon Emulator
https://github.com/astralaster/agon-light-emulator

### Assembly tutorial for Agon ez80 assembler
https://www.youtube.com/watch?v=75MTDGiehLs




