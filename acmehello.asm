
!to "acmehello.prg", cbm

chrout = $ffd2

    * = $9000

start:
    lda #$55
    jsr printmsg
    rts

printmsg:
    ldy #$00
loop:
    lda .message,y
    beq exit
    jsr chrout
    iny
    bne loop

exit:
    rts

.message
    !pet "hello world!"
    !byte 0
