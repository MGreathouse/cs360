; Registers
; R0 = counter for moving through the data
; R1 = current value to check against
; R2 = next value to check against
; R3 = memory location
; R4 = scratch
; R5 = counter for racking how far to move through data
; R6 = base value to work with
;
;
;
        .ORIG   x3000       ; start at x3000
;
; Initialiation
        AND     R0, R0, 0   ; set R0 to 0
        ADD     R0, R0, #-1 ; set R0 to -1
        LDI     R6, BASE    ; sets R6 to the base data value
        LDI     R3, BASE    ; set R3 to base as well
        ADD     R3, R3, #-1 ; sets R3 to 1 less
;
; Bubble Sort
; Find end
NEXT    ADD     R0, R0, #1  ; increments counter by one
        ADD     R3, R3, #1  ; increments address by one
        LDR      R1, R3, 0   ; puts next value into R1
        BRnp    NEXT        ; runs until setinal value is found

        AND     R5, R5, 0   ; set R5 to 0
        ADD     R5, R5, R0  ; sets R5 to R0
        NOT     R5, R5      ; inverts R5
        ADD     R5, R5, #1  ; makes R5 negative of R0
;
; Sort
SORT    ADD     R5, R5, #1  ; increment R5 by 1 ~ outer loop
        BRz     ESCAPE      ; escape case
        AND     R0, R0, 0   ; reset R0
        LDI     R3, BASE    ; reset R3
LOOP    LDR     R1, R3, 0   ; loads current value to check ~ inner loop
        ADD     R0, R0, #1  ; increments counter by one
        ADD     R3, R3, #1  ; increments address by one
        LDR     R2, R3, 0   ; load next value to check
        NOT     R4, R2      ; invert R2 to check against
        ADD     R4, R4, #1  ;
        ADD     R4, R4, R1  ; check to see if current value is greater than next value
        BRp     SWAP        ; if positive swap the values
PROCEED ;ADD     R0, R0, #-1 ; return R0 to initial increment
        ;ADD     R3, R3, #-1 ; decrements address by one
        ADD     R4, R0, R6  ; check to see if inner loop is done
        BRz     SORT        ; if zero, go to the next level
        BRnzp   LOOP        ; next loop iteratio

SWAP    ADD     R0, R0, #-1 ; go back a value so they can be swapped
        ADD     R3, R3, #-1 ; deccrements address by one
        STR     R2, R3, 0   ; store R2 where R1 was
        ADD     R3, R3, #1  ; increments address by one
        ADD     R0, R0, #1  ; increment counter
        STR     R1, R3, 0   ; store R1 where R2 was
        BRnzp   PROCEED     ; return to right after the swap


ESCAPE  HALT


BASE    .FILL   x3500

        .END