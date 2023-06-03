
    .assume adl=1

    .org $040000

    jp      start

    .align 64
    ; MOS Header
    db "MOS",0,1



start:
    push af
    push bc
    push de
    push ix 
    push iy


    ld hl,hello_str
    ld bc, 0
    ld a, 0

    rst.lil 0x18

    ld a, 0
    rst.lil 0x08

    pop iy
    pop ix
    pop de
    pop bc
    pop af

    ld hl, 0

    ret

hello_str:
    db "Hello, World!\r\nPress any key\r\n",0




