ASSUME DS:DATA, CS:CODE, SS:STACK

STACK SEGMENT PARA STACK 'STACK'
    DB 128 DUP(?)
STACK ENDS

DATA SEGMENT
    divident DB 08H
    divisor DB 05H
    quotient DB ?
    remainder DB ?
DATA ENDS

CODE SEGMENT 
    START:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128

        MOV CL, 00H
        MOV AL, divident
        MOV BL, divisor
        CMP BL, 00H
        JE DIV_BY_ZERO

    _LOOP:
        CMP AL, BL
        JBE STOP

        SUB AL, BL
        INC CL
        JMP _LOOP
    

    STOP:
        MOV remainder, AL
        MOV quotient, CL

        MOV AH, 02
        MOV DL, AL
        ADD DL, '0'
        INT 21H

        MOV AH, 02
        MOV DL, CL
        ADD DL, '0'
        INT 21H

        MOV AH, 4CH
        INT 21H
    
    DIV_BY_ZERO:
        MOV AH, 02
        MOV DL, 'Z'
        INT 21H

        MOV AH, 4CH
        INT 21H
        
CODE ENDS
END START