        .ORIG   x3000
START   LDI     R1, KBSR
        BRzp    START
        LDI     R0, KBDR
ECHO    LDI     R1, DSR
        BRzp    ECHO
        STI     R0, DDR
        BRnzp   START
KBSR    .FILL   xFE00
KBDR    .FILL   xFE02
DSR     .FILL   xFE04
DDR     .FILL   xFE06
        .END