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
        DEC BH              
        JMP _LOOP

    BISECT_RIGHT:
        MOV BL, DL
        INC BL              
        JMP _LOOP

    START:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128

        MOV BL, 00H         
        MOV BH, n           
        MOV CL, n           

    _LOOP:
        CMP BH, BL
        JB NOT_FOUND
        MOV AL, BL
        ADD AL, BH 
        SHR AL, 1           
        MOV DL, AL          
        MUL AL              

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

COMMENT @@@
8086 TRAINER KIT
MEMORY:
0800   09
0801   ??


CODE:
0300: MOV BL, 00H 
0302: MOV BH, [0800] 
0304: MOV CL, [0800] 
0306: CMP BH, BL
0308: JB [0320]
030A: MOV AL, BL
030C: ADD AL, BH
030E: SHR AL, 1 
0310: MOV DL, AL 
0312: MUL AL 
0314: CMP AL, CL
0316: JB [0329]
0318: JE 031C
031A: JMP 0324
031C: MOV [0801], DL
031E: HLT
0320: MOV [0801], 00H
0322: HLT
0324: MOV BH, DL
0326: DEC BH 
0327: JMP 0306
0329: MOV BL, DL
032B: INC BL 
032C: JMP 0306
@@@