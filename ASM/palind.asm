; Question : Given an string s of length n, check whether it is a palindrome

ASSUME DS:DATA, CS:CODE, SS:STACK

STACK SEGMENT PARA STACK 'STACK'
    DB 128 DUP(?)           
STACK ENDS

DATA SEGMENT
    s DB 04H, 06H, 03H, 34H, 12H, 35H, 03H, 06H, 04H
    n DB 09H
    isPalindrome DB ?
DATA ENDS

CODE SEGMENT 
    START:
        MOV AX, DATA
        MOV DS, AX
        MOV AX, STACK
        MOV SS, AX
        MOV SP, 128

        MOV SI, OFFSET s
        MOV AX, SI 
        ADD AL, n 
        DEC AX            
        MOV DI, AX

    _LOOP:
        CMP DI, SI
        JBE PALINDROME
        MOV AL, [SI]
        MOV BL, [DI]
        CMP AL, BL
        JNZ NOT_PALINDROME
        INC SI
        DEC DI
        JMP _LOOP
    
    PALINDROME:
        MOV isPalindrome, 01H
        MOV AH, 02H
        MOV DL, '1'
        INT 21H
        JMP STOP
    
    NOT_PALINDROME:
        MOV isPalindrome, 00H
        MOV AH, 02H
        MOV DL, '0'
        INT 21H
        JMP STOP

    STOP:
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
0803   34
0804   12
0805   35
0806   03
0807   06
0808   04
0809   09
080A   ??


CODE:
0300: MOV SI, OFFSET [0800]
0302: MOV AX, SI
0304: ADD AL, [0809]
0306: DEC AX
0307: MOV DI, AX
0309: CMP DI, SI
030B: JBE [0319]
030D: MOV AL, [SI]
030F: MOV BL, [DI]
0311: CMP AL, BL
0313: JNZ 031D
0315: INC SI
0316: DEC DI
0317: JMP 0309
0319: MOV [080A], 01H
031B: HLT
031D: MOV [080A], 00H
031F: HLT
@@@