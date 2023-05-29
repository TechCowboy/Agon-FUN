;
; implementation of get input from console

SECTION code_clib

EXTERN l_ret
PUBLIC fgetc_cons
PUBLIC _fgetc_cons

fgetc_cons:
_fgetc_cons:
    xor     a
    rst     0x08
    ld      l,a     ;Return the result in hl
    ld      h,0
    ret