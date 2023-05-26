;
; implementation of printing to console

SECTION code_clib

EXTERN l_ret
PUBLIC fputc_cons_native
PUBLIC _fputc_cons_native

fputc_cons_native:
_fputc_cons_native:
    pop     bc  ;return address
    pop     hl  ;character to print in l
    push    hl
    push    bc
    ld      a,l
    rst     0x10
    ret


