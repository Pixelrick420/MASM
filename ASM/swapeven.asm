; Question : Given 2 arrays arr1, arr2 of size n in memory, for each index i such that 0 <= i < n, swap arr1[i] and arr2[i] if they are both even

ASSUME DS:DATA, CS:CODE, SS:STACK

STACK SEGMENT PARA STACK 'STACK'
    DB 128 DUP(?)
STACK ENDS

DATA SEGMENT 
    arr1 DB 04H, 03H, 00H, 06H, 07H
    arr2 DB 06H, 09H, 08H, 09H, 03H
    n DB 05H
DATA ENDS

CODE SEGMENT
    PRINT_ARRAY:                   
        MOV DL, [SI]
        ADD DL, '0'
        MOV AH, 02
        MOV AH, 02H
        INT 21H
        INC SI
        DEC CL
        JNZ PRINT_ARRAY
        RET

    START:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128
    
        MOV SI, OFFSET arr1
        MOV CL, n
        CALL PRINT_ARRAY

        MOV SI, OFFSET arr2
        MOV CL, n
        CALL PRINT_ARRAY

        MOV SI, OFFSET arr1
        MOV DI, OFFSET arr2
        MOV CL, n

    _LOOP:
        MOV AL, [SI]
        MOV BL, [DI]
        MOV AH, AL
        MOV BH, BL

        AND AL, 01H
        JNZ SKIP_SWAP
        AND BL, 01H
        JNZ SKIP_SWAP

        XCHG AX, BX

    SKIP_SWAP:
        MOV [SI], AH
        MOV [DI], BH
        INC SI
        INC DI
        DEC CL
        JNZ _LOOP

    STOP:
        MOV SI, OFFSET arr1
        MOV CL, n
        CALL PRINT_ARRAY

        MOV SI, OFFSET arr2
        MOV CL, n
        CALL PRINT_ARRAY

        MOV AH, 4CH
        INT 21H
CODE ENDS
END START


COMMENT @@@
8086 TRAINER KIT
MEMORY:
0800   04H
0801   03H 
0802   00H
0803   06H
0804   07H

0900   06H
0901   09H
0902   08H
0903   09H
0904   03H

1000   05H


CODE:
0300:    MOV SI, 0800H          
0303:    MOV DI, 0900H          
0306:    MOV CL, [1000H]        
030A:    MOV AL, [SI]           
030C:    MOV BL, [DI]
030E:    MOV AH, AL
0310:    MOV BH, BL
0312:    AND AL, 01H
0314:    JNZ 031CH              
0316:    AND BL, 01H
0319:    JNZ 031CH              
031B:    XCHG AX, BX
031C:    MOV [SI], AH           
031E:    MOV [DI], BH
0320:    INC SI
0321:    INC DI
0322:    DEC CL
0324:    JNZ 030AH              
0326:    HLT
@@@