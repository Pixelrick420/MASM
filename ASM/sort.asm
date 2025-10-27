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

    SWAP:
        XCHG AL, BL
        JMP INNER_BACK

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

    INNER:
        MOV CL, CH
        MOV SI, OFFSET array
    INNER_LOOP:
        MOV AL, [SI]
        MOV BL, [SI + 1]
        CMP BL, AL
        JBE SWAP
    INNER_BACK:
        MOV [SI], AL
        MOV [SI + 1], BL
        INC SI
        DEC CL
        JNZ INNER_LOOP
        RET

    START:
        JMP INIT
    BACK:
        CALL PRINT_ARRAY
    OUTER:
        MOV CH, n
        DEC CH    
    OUTER_LOOP:
        CALL INNER
        DEC CH
        JNZ OUTER_LOOP
    STOP:
        CALL PRINT_ARRAY
        MOV AH, 4CH
        INT 21H
        
CODE ENDS
END START

COMMENT @@@
MEMORY:
0800 05H  
0801 04H 
0802 00H 
0803 01H
0804 06H
0900 05H 


CODE:
0600     MOV CH, [0900]
0604     DEC CH
0606     CALL 0613
0609     DEC CH
060B     JNZ 0606
060D     HLT

060E     XCHG AL, BL
0610     JMP 0621

0613     MOV CL, CH
0615     MOV SI, 0800
0618     MOV AL, [SI]
061A     MOV BL, [SI + 1]
061D     CMP BL, AL
061F     JBE 060E
0621     MOV [SI], AL
0623     MOV [SI + 1], BL
0626     INC SI
0627     DEC CL
0629     JNZ 0618
062B     RET
@@@