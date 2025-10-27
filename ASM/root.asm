ASSUME DS:DATA, CS:CODE, SS:STACK

STACK SEGMENT PARA STACK 'STACK'
    DB 128 DUP(?)
STACK ENDS

DATA SEGMENT
    n DB 09H
    root DB ?
DATA ENDS

CODE SEGMENT 
    BISECT_LEFT:
        MOV BH, DL
        DEC BH              ; right = mid - 1
        JMP _LOOP

    BISECT_RIGHT:
        MOV BL, DL
        INC BL              ; left = mid + 1
        JMP _LOOP

    START:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128

        MOV BL, 00H         ; left
        MOV BH, n           ; right
        MOV CL, n           ; n for comparing

    _LOOP:
        CMP BH, BL
        JB NOT_FOUND
        MOV AL, BL
        ADD AL, BH 
        SHR AL, 1           ; mid
        MOV DL, AL          ; save copy of mid before squaring
        MUL AL              ; square of mid

        CMP AL, CL
        JB BISECT_RIGHT
        JE FOUND
        JMP BISECT_LEFT
    
    FOUND:
        MOV root, DL
        MOV AH, 02
        ADD DL, '0'
        INT 21H

        MOV AH, 4CH
        INT 21H

    NOT_FOUND:
        MOV AH, 02
        MOV DL, 'N'
        INT 21H

        MOV AH, 4CH
        INT 21H
CODE ENDS
END START