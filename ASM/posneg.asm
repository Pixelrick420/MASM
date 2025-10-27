ASSUME CS:CODE, DS:DATA
DATA SEGMENT
    arr             DB 04H, 06H, 03H, 35H, 21H, 12H, 25H, 30H, 67H, 9BH
    n               DB 0AH
    poscount        DB ?
    negcount        DB ?
DATA ENDS

CODE SEGMENT
    PRINT:
        MOV AH, 2
        MOV DL, negcount
        ADD DL, 30H
        INT 21H
        MOV DL, poscount
        ADD DL, 30H
        INT 21H
        RET

    START:
        MOV AX, DATA
        MOV DS, AX

        MOV CL, n
        MOV SI, OFFSET arr
        MOV BL, 0                

    _LOOP:
        MOV AL, [SI]
        AND AL, 80H
        JNZ COUNT_NEG

    BACK:
        INC SI
        DEC CL
        JNZ _LOOP
        JMP FINISH

    COUNT_NEG:
        INC BL
        JMP BACK

    FINISH:
        MOV negcount, BL
        MOV AL, n
        SUB AL, BL
        MOV poscount, AL
        CALL PRINT
        MOV AH, 4CH
        INT 21H

CODE ENDS
END START
