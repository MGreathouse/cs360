            .ORIG       x4000
            LEA         R0, GET_MSG       ; displays get integer message
            LD          R2, ASCII_FIX     ; input will be 48 above anser

            PUTS
            TRAP        x20               ; IN - put ascii integer in
            ADD         R0, R0, R2        ; converts to a real integer
            BRnz        FACT_DISP         ; bad entry value
            ADD         R1, R0, #0        ; setup value to be mathed
            ;ADD         R2, R0, #0        ; setup value to be mathed

FACTORIAL   ADD         R1, R1, #-1       ; go to next 
            ;ADD         R1, R2, #-1       ; prep to be mathed
            ;ADD         R2, R1, #0        ; get next value ready
            BRz         FACT_DISP         ; if zero, the factorial is done
            JSR         MUL               ; jump to multiplication subroutine
            BRnzp       FACTORIAL         ; continue until done

FACT_DISP   ADD         R5, R5, #-1       ; check overflow to see if valid value
            BRzp        BAD_VAL           ; if bad, display that it was bad
            ST          R0, RESULT        ; store the result
            HALT
BAD_VAL     LEA         R0, BAD_MSG       ; display bad message
            PUTS
            HALT

ASCII_FIX   .FILL       #-48
RESULT      .BLKW       1
GET_MSG     .STRINGZ    "Enter an integer from 1-8:> "
BAD_MSG     .STRINGZ    "BAD VALUE ENTERED"

MUL         ST          R1, MUL_OSR1      ; registers needed by MUL
            ST          R2, MUL_OSR2
            ST          R3, MUL_OSR3

            AND         R2, R2, #0        ; set R2 to zero
            AND         R3, R3, #0        ; set R3 to zero
            AND         R5, R5, #0        ; set R5 to zero

            ADD         R0, R0, #0        ; check if R0 positive/negative
            BRn         MUL1_NEG          ; do apprpriate actions if var 1 is negative
            BRz         MUL_DONE          ; do apprpriate actions if var 1 is zero
MUL_VAR2    ADD         R1, R1, #0        ; check if R1 is positive/negative
            BRn         MUL2_NEG          ; do apprpriate actions if var 2 is negative
            BRz         MUL_DONE          ; do apprpriate actions if var 2 is zero
            BRnzp       MUL_LOOP          ; otherwise start multiplying

MUL1_NEG    NOT         R0, R0            ; invert R0
            ADD         R0, R0, #1      
            ADD         R3, R3, #1        ; increment R3 sign tracker
            BRnzp       MUL_VAR2          ; branch to check var 2

MUL2_NEG    NOT         R1, R1            ; invert R0
            ADD         R1, R1, #1      
            ADD         R3, R3, #1        ; increment R3 sign tracker

MUL_LOOP    ADD         R1, R1, #-1       ; subtract 1 from R1, used as a counter
            BRn         MUL_DONE          ; if negative, done multiplying
            ADD         R2, R2, R0        ; add var 1 to total
            BRnz        OVERFLOW          ; go set the overflow 
            BRnzp       MUL_LOOP          ; start multiplication loop over

OVERFLOW    ADD         R5, R5, #1        ; set R5 to 1
            BRnzp       MUL_DONE          ; value doesn't mantter now, this is done

SIGN_FIX    ADD         R3, R3, #-1       ; check to see if a sign change is needed after done multiplying
            BRnp        MUL_DONE          ; fix the zign if one was positive and the other negative

            NOT         R2, R2            ; invert R2
            ADD         R2, R2, #1

MUL_DONE    ADD         R0, R2, #0        ; set R0 to R2

            LD          R1, MUL_OSR1      ; registers returned by MUL
            LD          R2, MUL_OSR2
            LD          R3, MUL_OSR3
            RET

MUL_OSR1    .BLKW   1
MUL_OSR2    .BLKW   1
MUL_OSR3    .BLKW   1
            .END