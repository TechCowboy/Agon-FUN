
    ASSUME adl=1


mos_dir:		    EQU	04h

    ORG $040000

    jp  start

    .align 64
    ; MOS Header
    db "MOS",0,1


; ******************************************************************

path:
    db ".",0
    ds 255

start:
    push af
    push bc
    push de
    push ix 
    push iy

; The main routine
; IXU: argv - pointer to array of parameters
;   C: argc - number of parameters
; Returns:
;  HL: Error code, or 0 if OK

    ld a, c 
    jr z, current_path

    ld hl, (ix)
    ld bc, 0
    ld a, 0
    rst.lil 0x18

current_path:
    LD	A, mos_dir
	rst.lil	0x08

done:
    
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



