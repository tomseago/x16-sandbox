!zone txtwin

!address .plot = $fff0
!address .chrout = $ffd2

txtwin_start:
    ; Store the current position
    ; Set carry which means read position
    sec
    jsr .plot

    ; Hold on to this for future
    stx zTxtSavedX
    sty zTxtSavedY

    ; TODO: Respect colors
    ; TODO: Move bottom row up by one

    ; Move position to bottom row
    ldx #20
    ldy #20
    clc
    jsr .plot
    rts

txtwin_stop:
    ldx zTxtSavedX
    ldy zTxtSavedY
    clc
    jsr .plot
    rts

txtwin_tom:
    lda #$54
    jsr .chrout
    lda #$4F
    jsr .chrout
    lda #$4D
    jsr .chrout

    ; Read for text out put
    rts

txtwin_print_char:
    ; Zeropage contains address of char
    ldx #$0
    lda (zTxtArg,x)
    brk
    jsr .chrout
+   rts


txtwin_print_str:
    ; Zeropage contains address of char
    ldx #$0
-
    lda (zTxtArg,x)
    beq +
    jsr .chrout
    inc zTxtArg
    bne -
+
    rts

txtwin_print_test:
    lda #>.hello
    sta zTxtArg
    lda #<.hello
    sta zTxtArg


printmsg:
    ldy #$00
loop:
    lda .hello,y
    beq exit
    jsr .chrout
    iny
    bne loop

.hello:
    !pet "hiya!"
    !byte $0A
    !byte $00
