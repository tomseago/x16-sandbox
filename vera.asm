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
    php
    pha

    ; Debug ---------
;    pha
;    lda #$0a
;    sta EMU_debug_c
;    lda #$5b
;    sta EMU_debug_c
;    pla;
;
;    sta EMU_debug_1
;    lda scnCharX
;    sta EMU_debug_1
;    lda scnCharY
;    sta EMU_debug_1
;    lda #$5d
;    sta EMU_debug_c
;    lda #$0a
;    sta EMU_debug_c
    ; ---------- End Debug


    jsr .setPosAddr
    pla
    plp

    bcs +
    ; Carry not set, translate to screen
    tax
    lda .table_asc_to_screen,x
+
    sta VERA_D0 ; output char to vera

    inc VERA_L
    bne +
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

    ; Load X into low
    lda scnCharX
    asl             ; Account for double byte-ness in the row
    adc VERA_L
    sta VERA_L

    ; Load Y into med
    lda scnCharY
    adc VERA_M
    sta VERA_M

    rts

.table_asc_to_screen:
    !byte 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143
    !byte 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159
    !byte 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47
    !byte 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63
    !byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    !byte 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
    !byte 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79
    !byte 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95
    !byte 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207
    !byte 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223
    !byte 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111
    !byte 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127
    !byte 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79
    !byte 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95
    !byte 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111
    !byte 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 94


