ASSUME CS: CODE, DS: DATA, SS: STACK

STACK SEGMENT PARA STACK 'STACK'
    DW 128 DUP(?)
STACK ENDS

DATA SEGMENT
    array DB 05H, 04H, 00H, 01H, 06H, 07H, 02H, 08H, 09H, 03H
    n DB 0AH
DATA ENDS

CODE SEGMENT
    INIT:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128
        JMP BACK

    PRINT_AL:
        ADD AL, '0'
        MOV DL, AL
        MOV AH, 02H
        INT 21H
        RET

    PRINT_ARRAY:
        MOV SI, OFFSET array
        MOV CL, n
    PRINT_LOOP:
        MOV AL, [SI]
        CALL PRINT_AL
        INC SI
        DEC CL
        JNZ PRINT_LOOP
        RET


    START:
        JMP INIT
    BACK:
        CALL PRINT_ARRAY

        MOV SI, OFFSET array
        MOV DI, OFFSET array
        MOV CL, n
        MOV CH, 00H
        ADD DI, CX
        DEC DI

    _LOOP:
        CMP DI, SI
        JBE STOP

        MOV AL, [SI]
        XCHG AL, [DI]
        MOV [SI], AL

        INC SI
        DEC DI
        JMP _LOOP

    STOP:
        CALL PRINT_ARRAY
        MOV AH, 4CH
        INT 21H
        
CODE ENDS
END START

