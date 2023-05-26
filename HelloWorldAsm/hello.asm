
    .assume adl=0

    .org $4000

    jp      start

    .align 64
    ; MOS Header
    db "MOS",0,0



start:
    push af
    push bc
    push de
    push ix 
    push iy


    ld hl,hello_str
    ld bc, 0
    ld a, 0

    rst 0x18

    pop iy
    pop ix
    pop de
    pop bc
    pop af

    ld hl, 0

    ret

hello_str:
    db "Hello, World!\r\n",0



