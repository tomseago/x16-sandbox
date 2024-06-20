!zone vera

!address VERA_L = $9f20
!address VERA_M = $9f21
!address VERA_H = $9f22

!address VERA_D0 = $9f23
!address VERA_D1 = $9f24

!address VERA_CTRL = $9f25
!address VERA_ISR = $9F27
!address VERA_VIDEO = $9f29

!address VERA_L0_CONFIG     = $9f2d
!address VERA_L0_MAPBASE    = $9f2e
!address VERA_L0_TILEBASE   = $9f2f

!address VERA_L1_CONFIG     = $9f34
!address VERA_L1_MAPBASE    = $9f35
!address VERA_L1_TILEBASE   = $9f36

    VERA_CBUF_M = $b0
    VERA_CBUF_H = $01

!address VERA_SPRITE_ATTR = $1fc00   ; VRAM address
!address VERA_POINTER_ADDR = $0      ; VRAM address where custom mouse pointer is stored

defaultColor = $05  ; bg = black, fg = green
statusColor = $30   ; red, black

numCols = 80
numRows = 40

charBug = $5e
charSpace = $20

;******************************************************************************
; Init vera before doing anything else.
;******************************************************************************
veraInit:
    ; Enable layers we care about
    lda VERA_VIDEO
;    ora #%01110000 ; Sprites, L1, L0
    ora #%00100000 ; Just L1
    sta VERA_VIDEO

    ; Config:
    ; Map height 2 | Map width 2 | T256C 1 | Bitmap Mode 1 | Color Depth 2
    lda VERA_L1_CONFIG
;    ora #%11110001
    lda #%01100000
    sta VERA_L1_CONFIG

    ; Use the default map base address
    lda #(VERA_CBUF_H<<7) | (VERA_CBUF_M >> 1)
    sta VERA_L1_MAPBASE

    lda VERA_L1_TILEBASE
    ; Probably is $f8 %1111 1000 = Tile base addr (16:11) %1111 10,
    ; tile h = 0, tile w = 0 => 16 pixels

    ; Our defaults
    lda #0
    sta scnCharX
    sta scnCharY
    lda #defaultColor ; black bg, green fg
    sta scnColor

    rts

;******************************************************************************
; Put a single char from .A at current position in current color.
; Does not change the position
;******************************************************************************
veraPutChar:
    pha ; derp a derp, can't do debugging before saving this!
    pha

    sta EMU_debug_1
    lda $30
    sta EMU_debug_1
    lda $31
    sta EMU_debug_1

    pla
    jsr .setPosAddr
    pla

    sta VERA_D0 ; output char to vera

    inc VERA_L
    beq +
    inc VERA_M
+
    lda scnColor
    sta VERA_D0 ; output color to vera

    rts

.setPosAddr:
    ; Always start at the base address
    lda #0
    sta VERA_L
    lda #VERA_CBUF_M
    sta VERA_M
    lda #VERA_CBUF_H
    sta VERA_H

    ; First we offset for number of full rows
    lda scnCharY
    beq +
-
    lda #numCols
    jsr veraIncAddr
    lda #numCols
    jsr veraIncAddr  ; Do it twice because 2 bytes per char
    dey
    bne -
+

    ; Now the x for number of used columns
    lda scnCharX
    jsr veraIncAddr
    lda scnCharX
    jsr veraIncAddr ; Twice because double bytes per char

    rts


veraIncAddr:
    ; .A contain increment so add address into it
    adc VERA_L
    sta VERA_L
    sta EMU_debug_2
    bcc +
    ; Handle carry
    inc VERA_M
    lda VERA_M
    sta EMU_debug_2
+
    rts

