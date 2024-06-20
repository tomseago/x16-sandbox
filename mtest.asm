
; Basic header
; This allows the program to be loaded without the
; ,8,1 suffix and it can be run directly
    *= $0801      ; start of basic memory
    !zone basicheader

    !word +       ; address of next basic line
    !word 99      ; line number of current line
    !byte $9e     ; "SYS" token
    !text "2061"  ; argument for SYS
    !byte 0       ; EOL marker
+                 ; Second basic line
    !word 0       ; EOF marker

; --------------------  Start of the main ML Code

    !zone main

    jsr veraInit

    ; Show the bug
    lda #charBug
    jsr veraPutChar

.mainloop:
    jsr .handleKey
    jmp .mainloop

; --------------------  Subroutines

; Zero page definitions before use to avoid "Using oversized addressing mode"
; error message

    !src "variables.asm"

     ; Kernal
    !address .chrout = $ffd2
    !address .getin  = $ffe4
    !address KERNAL_enter_basic = $ff47

    ; Emulator
    !address EMU_debug_1 = $9fb9
    !address EMU_debug_2 = $9fba
    !address EMU_debug_c = $9fbb

.handleKey:
    jsr .getin
    cmp #$0
    bne +
    rts
+
    ;sta EMU_debug_1

    cmp #$1b ; escape
    beq .exit

+   cmp #$9d ; left
    beq .handle_left

+   cmp #$1d ; right
    beq .handle_right

    ; Nothing
    rts

.handle_left:
    lda scnCharX
    beq +

    ; Clear current char
    ;lda #charSpace
    lda #1
    jsr veraPutChar

    ;dec scnCharX
    ;sta scnCharX
    ;lda #charBug
    ;lda #2
    ;jsr veraPutChar
+
    rts

.handle_right:
    lda scnCharX
    cmp #numCols - 1
    beq +

    ; Clear current char
    lda #charSpace
    jsr veraPutChar

    inc scnCharX
    lda #charBug
    jsr veraPutChar
+
    rts

.exit
    ; Clear the screen by writing the clear screen code
    lda #$93
    jsr .chrout
    ; warm start for basic
    jmp KERNAL_enter_basic


; --------------------  External subroutines

    !src "vera.asm"

; --------------------  Data segments

    ; Zeropage has to be at the beginning though




    ;jsr printmsg ; Simple routine

;    jsr txtwin_start
;    jsr txtwin_tom
;    jsr txtwin_stop

    ; A single character
;    lda #$d3
 ;   sta zTxtArg
  ;  jsr txtwin_print_char

    ;  jsr txtwin_print_str

exit:
    rts


;    !src "txtwin.asm"

;!address chrout = $ffd2

;printmsg:
;    ldy #$00
;loop:
;  brk
;    lda .message,y
;    beq exit
;    jsr chrout
;    iny
;    bne loop


.message
    !pet "hello world!"
    !byte 0




;  !src "definitions.a"
;  !src "rasterbar.a"
; !src "hello.a"

; Stay forever
;- jmp -
  rts

;  !src "strings.a"