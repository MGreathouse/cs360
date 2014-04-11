            .ORIG   x4000
            LD      R0, VAR_1       ; Load vairables into R1 and R0 ~ my shortcut to enter initial values
            LD      R1, VAR_2

MUL         ST      R1, OSR1        ; registers needed by MUL
            ST      R2, OSR2
            ST      R3, OSR3

            AND     R2, R2, #0      ; set R2 to zero
            AND     R3, R3, #0      ; set R3 to zero
            AND     R5, R5, #0      ; set R5 to zero

            ADD     R0, R0, #0      ; check if R0 positive/negative
            BRn     VAR1_NEG        ; do apprpriate actions if var 1 is negative
            BRz     MUL_DONE        ; do apprpriate actions if var 1 is zero
CHK_VAR2    ADD     R1, R1, #0      ; check if R1 is positive/negative
            BRn     VAR2_NEG        ; do apprpriate actions if var 2 is negative
            BRz     MUL_DONE        ; do apprpriate actions if var 2 is zero
            BRnzp   MUL_LOOP        ; otherwise start multiplying

VAR1_NEG    NOT     R0, R0          ; invert R0
            ADD     R0, R0, #1      
            ADD     R3, R3, #1      ; increment R3 sign tracker
            BRnzp   CHK_VAR2        ; branch to check var 2

VAR2_NEG    NOT     R1, R1          ; invert R0
            ADD     R1, R1, #1      
            ADD     R3, R3, #1      ; increment R3 sign tracker

MUL_LOOP    ADD     R1, R1, #-1     ; subtract 1 from R1, used as a counter
            BRn     MUL_DONE        ; if negative, done multiplying
            ADD     R2, R2, R0      ; add var 1 to total
            BRnz    OVERFLOW        ; go set the overflow 
            BRnzp   MUL_LOOP        ; start multiplication loop over

OVERFLOW    ADD     R5, R5, #1      ; set R5 to 1
            BRnzp   MUL_DONE        ; value doesn't mantter now, this is done

SIGN_FIX    ADD     R3, R3, #-1     ; check to see if a sign change is needed after done multiplying
            BRnp    MUL_DONE        ; fix the zign if one was positive and the other negative

            NOT     R2, R2          ; invert R2
            ADD     R2, R2, #1

MUL_DONE    ADD     R0, R2, #0      ; set R0 to R2
            ST      R0, RESULT      ; store R0 -- this and the next instruction need to be ommited when this becomes a subroutine
            ST      R5, OVRFLW      ; store R5

            LD      R1, OSR1        ; registers returned by MUL
            LD      R2, OSR2
            LD      R3, OSR3
            HALT                    ; stop program -- this becomes a RET when this becomes a subroutine

VAR_1       .FILL   x0025
VAR_2       .FILL   X000F

RESULT      .BLKW   1
OVRFLW      .BLKW   1

OSR1        .BLKW   1
OSR2        .BLKW   1
OSR3        .BLKW   1
            .END