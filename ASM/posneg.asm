ASSUME CS:CODE, DS:DATA
DATA SEGMENT
    arr             DB 04H, 06H, 03H, 35H, 21H, 12H, 25H, 30H, 67H, 9BH
    n               DB 0AH
    poscount        DB ?
    negcount        DB ?
DATA ENDS

CODE SEGMENT
    PRINT:
        MOV AH, 2
        MOV DL, negcount
        ADD DL, 30H
        INT 21H
        MOV DL, poscount
        ADD DL, 30H
        INT 21H
        RET

    START:
        MOV AX, DATA
        MOV DS, AX

        MOV CL, n
        MOV SI, OFFSET arr
        MOV BL, 0                

    _LOOP:
        MOV AL, [SI]
        AND AL, 80H
        JNZ COUNT_NEG

    BACK:
        INC SI
        DEC CL
        JNZ _LOOP
        JMP FINISH

    COUNT_NEG:
        INC BL
        JMP BACK

    FINISH:
        MOV negcount, BL
        MOV AL, n
        SUB AL, BL
        MOV poscount, AL
        CALL PRINT
        MOV AH, 4CH
        INT 21H

CODE ENDS
END START


COMMENT @@@
8086 TRAINER KIT
MEMORY:

0800   04
0801   06
0802   03
0803   35
0804   21
0805   12
0806   25
0807   30
0808   67
0809   9B
080A   0A
080B   ??
080C   ??


CODE:
0300: MOV CL, [080A]
0302: MOV SI, OFFSET [0800]
0304: MOV BL, 0
0306: MOV AL, [SI]
0308: AND AL, 80H
030A: JNZ 0312
030C: INC SI
030D: DEC CL
030E: JNZ 0306
0310: JMP 0315
0312: INC BL
0313: JMP 030C
0315: MOV [080C], BL
0317: MOV AL, [080A]
0319: SUB AL, BL
031B: MOV [080B], AL
0320: HLT
@@@