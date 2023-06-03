
    ASSUME adl=1

mos_getkey:		    EQU	00h
mos_load:		    EQU	01h
mos_save:		    EQU	02h
mos_cd:			    EQU	03h
mos_dir:		    EQU	04h
mos_del:		    EQU	05h
mos_ren:		    EQU	06h
mos_mkdir:		    EQU	07h
mos_sysvars:	    EQU	08h
mos_editline:	    EQU	09h
mos_fopen:		    EQU	0Ah
mos_fclose:		    EQU	0Bh
mos_fgetc:		    EQU	0Ch
mos_fputc:		    EQU	0Dh
mos_feof:		    EQU	0Eh
mos_getError:	    EQU	0Fh
mos_oscli:		    EQU	10h
mos_copy:		    EQU	11h
mos_getrtc:		    EQU	12h
mos_setrtc:		    EQU	13h
mos_setintvector:	EQU	14h
mos_uopen:		    EQU	15h
mos_uclose:		    EQU	16h
mos_ugetc:		    EQU	17h
mos_uputc:		    EQU 18h
mos_getfil:		    EQU	19h
mos_fread:		    EQU	1Ah
mos_fwrite:		    EQU	1Bh
mos_flseek:		    EQU	1Ch

sysvar_time:		    EQU	00h	; 4: Clock timer in centiseconds (incremented by 2 every VBLANK)
sysvar_vpd_pflags:	    EQU	04h	; 1: Flags to indicate completion of VDP commands
sysvar_keyascii:	    EQU	05h	; 1: ASCII keycode, or 0 if no key is pressed
sysvar_keymods:		    EQU	06h	; 1: Keycode modifiers
sysvar_cursorX:		    EQU	07h	; 1: Cursor X position
sysvar_cursorY:		    EQU	08h	; 1: Cursor Y position
sysvar_scrchar:		    EQU	09h	; 1: Character read from screen
sysvar_scrpixel:	    EQU	0Ah	; 3: Pixel data read from screen (R,B,G)
sysvar_audioChannel:	EQU	0Dh	; 1: Audio channel 
sysvar_audioSuccess:	EQU	0Eh	; 1: Audio channel note queued (0 = no, 1 = yes)
sysvar_scrWidth:	    EQU	0Fh	; 2: Screen width in pixels
sysvar_scrHeight:	    EQU	11h	; 2: Screen height in pixels
sysvar_scrCols:		    EQU	13h	; 1: Screen columns in characters
sysvar_scrRows:		    EQU	14h	; 1: Screen rows in characters
sysvar_scrColours:	    EQU	15h	; 1: Number of colours displayed
sysvar_scrpixelIndex:	EQU	16h	; 1: Index of pixel data read from screen
sysvar_vkeycode:	    EQU	17h	; 1: Virtual key code from FabGL
sysvar_vkeydown		    EQU	18h	; 1: Virtual key state from FabGL (0=up, 1=down)
sysvar_vkeycount:	    EQU	19h	; 1: Incremented every time a key packet is received
sysvar_rtc:		        EQU	1Ah	; 8: Real time clock data
sysvar_keydelay:	    EQU	22h	; 2: Keyboard repeat delay
sysvar_keyrate:		    EQU	24h	; 2: Keyboard repeat reat
sysvar_keyled:		    EQU	26h	; 1: Keyboard LED status
sysvar_scrMode:		    EQU	27h	; 1: Screen mode

vdu_clear:              EQU 12  ; clear screen
vdu_home_cursor:        EQU 30  ; move to 0,0

ESC_character           EQU 1Bh ; Escape

    ORG $040000

    jp  start

    .align 64
    ; MOS Header
    db "MOS",0,1

vdu_disable_cursor:
    ;VDU 23, 1, 0
    db 23,1,0

vdu_time_position:
    ;VDU 31, x, y: TAB(x, y)
    db 31, 40,0

vdu_key_position:
    ;VDU 31, x, y: TAB(x, y)
    db 31, 0,4

; ************************************************
; ************************************************
; print_hex
;
; print the accumulator as a hex to the screen
; ************************************************
; ************************************************

hex_buffer:
    db 0,0

print_hex:
    push af		    ; Save A once

    push af          ; Save A again

    ; first nibble
    and a,0xF0
    rra 
    rra 
    rra 
    rra   	
    cp a,$0A
    jr nc, ten_or_more

;less_than_ten:    
    add a,'0'
    jr store_top_nibble

ten_or_more:
    add a,'A'-0x0A

store_top_nibble:
    ld (hex_buffer), a
   
    pop af		; Get back A
    and $0F
    cp  a,$0A
    jr nc, ten_or_more2

; less_than_ten:
    add a,'0'
    jr store_bottom_nibble

ten_or_more2:
    add a,'A'-0x0A

store_bottom_nibble:
    ld (hex_buffer+1),a 

    ld hl, hex_buffer
    ld bc, 2
    rst.lil 0x18
    pop af		; Restore A

    ret 

; ******************************************************************

start:
    push af
    push bc
    push de
    push ix 
    push iy

    ; clear the screen

    ld  a, vdu_clear        ; clear screen
    rst.lil 0x10            

    ld  a, 10               ; move cursor down
    rst.lil 0x10

    ; send the instructions

    ld  hl,instruction_str
    ld  bc, 0               ; bc = number of characters to print if non-zero
    ld  a,  0               ; if bc is zero, use the character in a as a delimiter to stop printing
    rst.lil 0x18            ; Output a stream of characters to the VPD (MOS 1.03 or above)

    ; disable the cursor

    ld  hl, vdu_disable_cursor
    ld  bc, 3
    rst.lil 0x18

    ; determine the seconds counter

    ld  a, mos_sysvars          ; Fetch a pointer to the system variables
	rst.lil	0x08                ; Execute a MOS command
    ld c, (IX + sysvar_rtc + 5) ; get the seconds
    dec c                       ; make sure it's different and can't be the same if it increments

repeat:

    ; remember the current state of C

    push bc 

    ;  get the system variables pointer

    ld  a, mos_sysvars      ; Fetch a pointer to the system variables
	rst.lil	0x08            ; Execute a MOS command

    ; determine if the user has pressed a key

    ld	a, (IX + sysvar_keyascii)
    jr  z, check_seconds    ; zero means no key

    ; get the key that is waiting

    ld  a, mos_getkey   
    rst.lil	0x08            ; Execute a MOS command

    cp 1Bh
    jr z, done              ; time to wrap things up
    
    ; key is in a, save it in d

    ld  d, a

    ld  hl, vdu_key_position
    ld  bc, 3
    rst.lil 0x18

    ld  hl,answer_str
    ld  bc, 0               ; bc = number of characters to print if non-zero
    ld  a,  0               ; if bc is zero, use the character in a as a delimiter to stop printing
    rst.lil 0x18            ; Output a stream of characters to the VPD (MOS 1.03 or above)

    ; put key, which was in d, back into a
    
    ld a, d

    ; a, The keycode of the character pressed

    call print_hex

check_seconds:

    pop bc      ; get the last value of seconds

    ;  get the current value of seconds

    ld a, (IX + sysvar_rtc + 5) ; second
    cp c                        ; is it the same as previous seconds?
    jr z, repeat                ; if it is, nothing to do

get_time:

    ; Seconds is different, than previously must display time

    ; move the cursor

    ld  hl, vdu_time_position
    ld  bc, 3
    rst.lil 0x18

    ; display the time
    ;
    ; +0: Year (offset from 1980, so 1989 is 9)
    ; +1: Month (1 to 12)
    ; +2: Day of Month (1 to 31)
    ; +3: Hour (0 to 23)
    ; +4: Minute (0 to 59)
    ; +5: Second (0 to 59)

    ld a, (IX + sysvar_rtc + 3) ; hour
    call print_hex
    ld a, ':'
    rst.lil 0x10
    ld a, (IX + sysvar_rtc + 4) ; minute
    call print_hex
    ld a, ':'
    rst.lil 0x10
    ld a, (IX + sysvar_rtc + 5) ; second
    call print_hex

    ; remember what 'seconds' was so we can check if we
    ; need to update time

    ld c, a     ; transfer seconds in a to c

    jr repeat

done:

    ld  hl, done_str
    ld  bc, 0
    ld  a,  0
    rst.lil 0x18

    pop bc  ; this was used to save seconds
    
    pop iy
    pop ix
    pop de
    pop bc
    pop af

    ld  hl, 0

    ret

instruction_str:
    db "Press ESC to quit or press a key to see display that key\r\n",0

answer_str:
    db "The key you pressed was: ",0

done_str:
    db "\r\nDone."
return_str:
    db "\r\n",0



