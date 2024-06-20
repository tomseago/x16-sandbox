; Globals, particularly zero page addresses

!address zPage = $30
    scnCharX = zPage + $00
    scnCharY = zPage + $01
    scnColor = zPage + $02



;!address    zTxtArg    = $30    ; either word with address of argument to print as text
;                                ; single char
;!address    zTxtSavedX = $32
;!address    zTxtSavedY = $33
;!address    zTxtColor  = $34
;
;!address    zaCharX     = $35
;!address    zaCharY     = $35