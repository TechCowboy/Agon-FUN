# Agon-FUN
Programs written to run on the Agon Light 2
All the programs require a minimum of MOS 1.03 and VDP 1.03

## Generic Info

## File Format

First few bytes have a jump instruction to the start of
your code, then there is a header.

```
      jp start
      ; MOS Header
      .align 64
      .db "MOS", 0, 0   ; use .db "MOS", 0, 1 for ADL executibles
start:
      ; save registers
      
stop:
      ; restore registers
      
      ld hl, 0  ; no error
      ret
``` 

## MOS API

### RST $00
    Reset the eZ80

### RST $08
    MOS Command
    Value in accumuator
    for parameters see here:
    
https://github.com/breakintoprogram/agon-docs/wiki/MOS-API </br>
The contents below was taken from mos_api.inc    

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
    Output a single character to the VDP</br>
    accumulator contains character to output
    
### $18 VDU String (MOS 1.03 or above)
    Output a stream of characters to the VDP</br>
    hl - address of characters</br>
    bc = print 'bc' characters, if zero, then use delimiter</br>
    a  = deliminter if bc is zero</br>

## z88dk
Additional files to add to z88dk directory for Agon Light support
This does not support ADL mode, just Z80 (short) mode

## HelloWorld
Gotta start somewhere

## Resources

### How to create a new target
https://github.com/z88dk/z88dk/wiki/Classic--Homebrew
https://github.com/z88dk/z88dk/wiki/Classic--Retargetting

### Assembly tutorial for Agon
https://www.youtube.com/watch?v=75MTDGiehLs




