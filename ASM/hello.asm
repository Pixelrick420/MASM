; Question : Given an integer n, find the factorial of n.
ASSUME CS:CODE, DS:DATA, SS:STACK

STACK SEGMENT PARA STACK 'STACK'
    DW 128 DUP(?)     
STACK ENDS

DATA SEGMENT
    msg DB "Hello World", 0DH, 0AH, "$"
DATA ENDS

CODE SEGMENT
    INIT:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128
        JMP BACK

    START:
        JMP INIT
    BACK:
        MOV DX, OFFSET msg
        MOV AH, 09H
        INT 21H

        MOV AH, 4CH
        INT 21H

CODE ENDS
END START
