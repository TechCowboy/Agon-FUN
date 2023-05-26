;
; implementation of get input from console

SECTION code_clib

EXTERN l_ret
PUBLIC fgetc_cons_native
PUBLIC _fgetc_cons_native

fgetc_cons_native:
_fgetc_cons_native:
    xor     a
    rst     0x08
    ld      l,a     ;Return the result in hl
    ld      h,0
    ret