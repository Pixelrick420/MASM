ASSUME DS:DATA, CS:CODE, SS:STACK

STACK SEGMENT PARA STACK 'STACK'
    DB 128 DUP(?)           ; change stack size as needed (if done also change SP initialization)
STACK ENDS

DATA SEGMENT
    ; data here
DATA ENDS

CODE SEGMENT 
    START:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128

        ; code here

        MOV AH, 4CH
        INT 21H
CODE ENDS
END START