COMMENT @@@
Question : Given an integer n, find the factorial of n.
@@@
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

COMMENT @@@
8086 TRAINER KIT
MEMORY:
0800   05
0801   ??


CODE:
0300: MOV CL, [0800]
0302: MOV AX, 01H
0304: CMP CL, 01H
0306: JE 030D
0308: MUL CL
030A: DEC CL
030B: JMP 0304
030D: MOV [0801], AL
030F: PUSH AX
0310: HLT
@@@