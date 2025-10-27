ASSUME DS:DATA, CS:CODE, SS:STACK

STACK SEGMENT PARA STACK 'STACK'
    DB 128 DUP(?)           
STACK ENDS

DATA SEGMENT
    n DB 05H
    factorial DB ?
DATA ENDS

CODE SEGMENT 
    START:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128

        MOV CL, n
        MOV AX, 01H

    _LOOP:
        CMP CL, 01H
        JE STOP
        MUL CL
        DEC CL
        JMP _LOOP
    
    STOP:
        MOV factorial, AL
        PUSH AX
        MOV AH, 4CH
        INT 21H
CODE ENDS
END START