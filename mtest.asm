; Basic header
  *= $0801
  !word +
  !word 10
  !byte $9e
  !text "2061"
  !byte 0
+
  !word 0





!address chrout = $ffd2

printmsg:
    ldy #$00
loop:
  brk
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




;  !src "definitions.a"
;  !src "rasterbar.a"
; !src "hello.a"

; Stay forever
;- jmp -
  rts

;  !src "strings.a"