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

        HLT
    
    DIV_BY_ZERO:
        MOV AH, 02
        MOV DL, 'Z'
        INT 21H

        HLT
        
CODE ENDS
END START

COMMENT @@@
8086 TRAINER KIT
MEMORY:
0800   08
0801   05
0802   ??
0803   ??


CODE:
0300: MOV CL, 00H
0302: MOV AL, [0800]
0304: MOV BL, [0801]
0306: CMP BL, 00H
0308: JE 0317
030A: CMP AL, BL
030C: JBE [0313]
030E: SUB AL, BL
0310: INC CL
0311: JMP 030A
0313: MOV [0803], AL
0315: MOV [0802], CL
0317: HLT
@@@