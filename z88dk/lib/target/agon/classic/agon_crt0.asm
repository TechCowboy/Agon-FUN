;
; A configurable CRT for bare-metal
;
;

;Agon Light is an 8-bit microcomputer, 
;but its modern eZ80F92 CPU runs at a 
;blazing 18.432MHz clock speed.

    MODULE agon_crt0 

;-------
; Include zcc_opt.def to find out information about us
;-------

    defc    crt0 = 1
    INCLUDE "zcc_opt.def"

;-------
; Some general scope declarations
;-------

    EXTERN    _main           ;main() is always external to crt0 code
    PUBLIC    cleanup         ;jp'd to by exit()
    PUBLIC    l_dcal          ;jp(hl)
    EXTERN	  asm_im1_handler
    EXTERN	  asm_nmi_handler

IF DEFINED_CRT_ORG_BSS
    defc    __crt_org_bss = CRT_ORG_BSS
ENDIF

IFNDEF      CRT_ORG_CODE
    defc    CRT_ORG_CODE = 0x0000
ENDIF

IF CRT_ORG_CODE = 0x0000
    ; By default we don't have any rst handlers
    defc    TAR__crt_enable_rst = $0000
ENDIF

    ; Default, don't change the stack pointer
    defc    TAR__register_sp = -1
    defc    TAR__clib_exit_stack_size = 32
    ; Default, halt loop
    defc    TAR__crt_on_exit = 0x10001

    defc    __CPU_CLOCK = 18432000
    INCLUDE "crt/classic/crt_rules.inc"


    org    	CRT_ORG_CODE

IF CRT_ORG_CODE = 0x0000
    jp      start
    ds	5

rst_08:		
    db 0x49 
    rst 08h				; API call
    ret
    ds 	5
    
rst_10:		
    db 0x49    
    rst 10h				; Output
    ret
    ds	5
    
rst_18:		
    db 0x49 
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
    
    ;INCLUDE "crt/classic/crt_z80_rsts.asm"
    align 64
mos_signature:
    db "MOS",0,0
ENDIF

start:

    ; Found out from the BBC code that you
    ; need to preserve the registers in ADL form
    ; I've written this so it works with
    ; assemblers that only know z80 opcodes

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



    INCLUDE "crt/classic/crt_start_eidi.inc"
    INCLUDE "crt/classic/crt_init_sp.asm"
    ; Make room for the atexit() stack
    INCLUDE "crt/classic/crt_init_atexit.asm"
    call    crt0_init_bss
IF __CPU_INTEL__
    ld      hl,0
    add     hl,sp
    ld      (exitsp),hl
ELSE
    ld      (exitsp),sp
ENDIF

    ; Entry to the user code

    ; *****************************************
    ; TESTING
    ; *****************************************
    ld hl, mos_signature
    ld bc, 0
    ld a,0
    rst 0x18        ; print string
    ; *****************************************
    ; END TESTING
    ; *****************************************

    call    _main
    ; Exit code is in hl
cleanup:
    call    crt0_exit

    ; How does the program end?
    INCLUDE "crt/classic/crt_terminate.inc"

l_dcal:
    jp      (hl)

    INCLUDE "crt/classic/crt_runtime_selection.asm"

    ; If we were given a model then use it
IF DEFINED_CRT_MODEL
    defc __crt_model = CRT_MODEL
ELSE
    defc __crt_model = 1
ENDIF
    INCLUDE	"crt/classic/crt_section.asm"

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
    ret 		   ; Return to MOS
