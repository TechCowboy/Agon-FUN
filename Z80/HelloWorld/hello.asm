
    
    .org $00000

    .assume adl=0

; Start in mixed mode. Assumes MBASE is set to correct segment
;	
    jp	start				; Jump to start
    ds	5

rst_08:		
    .db 0x49 
    rst 08h				; API call
    ret
    ds 	5
    
rst_10:		
    .db 0x49    
    rst 10h				; Output
    ret
    ds	5
    
rst_18:		
    .db 0x49 
    rst	18h				; Block Output
    ret
    ds	5
    
rst_20:		
    ds	8

rst_28:		
    ds	8

rst_30:		
    ds	8	

;	
; The NMI interrupt vector (not currently used by AGON)
;

rst_38:		
    ei
    reti
;
; The header stuff is from byte 64 onwards
;
    align	64
    
    db	"MOS"			; Flag for MOS - to confirm this is a valid MOS command
    db	0x00			; MOS header version 0
    db	0x00			; Flag for run mode (0: Z80, 1: ADL)
    
_exec_name:		
    ds	0xff	    	; The executable name, only used in argv	
	
;
; And the code follows on immediately after the header
;

start:

    ; Found out from the BBC code that you
    ; need to preserve the registers in ADL form
    ; I've written this so it works with
    ; assemblers that only know z80 opcodes

    ; save the registers

    .db 0x5b        ; lil prefix
    push ix

    .db 0x5b        ; lil prefix 
    push iy		    ; 

    .db 0x5b        ; lil prefix
    push af	    	; 

    .db 0x5b        ; lil prefix
    push bc

    .db 0x5b        ; lil prefix
    push de

    ; ***********************
    ; the z80 application
    ; ***********************

    ld hl,hello_str
    ld bc, 0
    ld a,0
    rst 0x18        ; print string

    ld a,0
    rst 0x08        ; get a character

    ; ***********************
    ; end z80 application
    ; ***********************

    ; Restore the registers

    .db 0x5b        ; lil prefix
    pop de

    .db 0x5b        ; lil prefix
    pop bc

    .db 0x5b        ; lil prefix
    pop af

    .db 0x5b        ; lil prefix
    pop iy	    	; 

    .db 0x5b        ; lil prefix
    pop ix	

    .db 0x49        ; lis prefix
    ld hl, 0

    .db 0x49        ; lis prefix
    ret 			; Return to MOS

hello_str:
    db "Hello, World!\r\nPress any key to continue\r\n",0
