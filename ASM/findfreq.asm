; Question : Given an array arr of length n and a number elem. Find the number of occurences of elem in arr.

ASSUME DS:DATA, CS:CODE, SS:STACK

STACK SEGMENT PARA STACK 'STACK'
    DB 128 DUP(?)           
STACK ENDS

DATA SEGMENT
    arr  DB 04H, 03H, 03H, 03H, 02H, 01H, 02H, 03H, 01H, 01H
    n    DB 0AH
    elem DB 04H
    freq DB ?
DATA ENDS

CODE SEGMENT 
    START:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128

        MOV SI, OFFSET arr
        MOV BL, elem
        MOV CL, n
        MOV DL, 00H

    _LOOP:
        MOV AL, [SI]
        CMP AL, BL
        JE INC_COUNT
    BACK:
        INC SI
        DEC CL
        JNZ _LOOP

        MOV freq, DL
        MOV AH, 02H
        ADD DL, '0'
        INT 21H

        MOV AH, 4CH
        INT 21H
    
    INC_COUNT:
        INC DL
        JMP BACK

CODE ENDS
END START

COMMENT @@@
8086 TRAINER KIT
MEMORY:
0800   04
0801   03
0802   03
0803   03
0804   02
0805   01
0806   02
0807   03
0808   01
0809   01
080A   0A
080B   04
080C   ??


CODE:
0300: MOV SI, OFFSET [0800]
0302: MOV BL, [080B]
0304: MOV CL, [080A]
0306: MOV DL, 00H
0308: MOV AL, [SI]
030A: CMP AL, BL
030C: JE 0316
030E: INC SI
030F: DEC CL
0310: JNZ 0308
0312: MOV [080C], DL
0314: HLT
0316: INC DL
0317: JMP 030E
@@@