# MASM 8086 Development Environment

A complete MASM (Microsoft Macro Assembler) development setup for DOSBox with automated build tools and a Python-based assembler that converts MASM code to absolute-addressed machine code for 8086 trainer kits.

## Features

- **Automated Build System**: Single-command compilation and execution via `build.bat`
- **Organized Structure**: Separate directories for source (ASM), objects (OBJ), and executables (EXE)
- **Trainer Kit Converter**: Python tool that translates MASM programs into absolute memory format for 8086 hardware trainers
- **Sample Programs**: Collection of fundamental 8086 assembly programs

## Directory Structure

```
masm/
├── ASM/           # Assembly source files (.asm)
├── OBJ/           # Compiled object files
├── EXE/           # Linked executables
├── TOOLS/         # Assembler, linker, and build utilities
├── dosbox-config.conf
├── masmToTrainerKit.py
└── README.md
```

## Quick Start

### DOSBox Setup

1. Add to your DOSBox configuration file (`dosbox-x.x.x.conf`):

```dosini
[autoexec]
mount c /<your-path>/masm
c:
PATH=%PATH%;C:\TOOLS
```

2. Build and run programs:

```batch
build filename
```

Example: `build lcm` compiles `ASM\lcm.asm` and runs the executable.

### Trainer Kit Conversion

Convert MASM programs to absolute-addressed format:

```bash
python masmToTrainerKit.py
```

The converter performs a two-pass assembly:

- **Pass 1**: Builds symbol table with absolute addresses (DATA @ 0x0800, CODE @ 0x0300)
- **Pass 2**: Resolves all labels and symbols to absolute memory addresses

#### Output Format

```
MEMORY:
0800   04        ; a DB 04H
0801   08        ; b DB 08H
0802   ??        ; lcm DB ?
0803   ??        ; hcf DB ?

CODE:
0300: MOV AL, [0800]
0302: MOV BL, [0801]
0304: MOV AH, 00H
0306: ADD BL, 00H
0308: JNZ 030E
030A: MOV [0803], AL
030C: JMP 0316
030E: DIV BL
0310: MOV AL, BL
0312: MOV BL, AH
0314: JMP 0304
0316: MOV AL, [0800]
0318: MOV BL, [0801]
031A: MUL BL
031C: MOV BL, [0803]
031E: DIV BL
0320: MOV [0802], AL
0322: HLT
```

## Technical Details

### Converter Features

- Resolves labels to absolute addresses
- Handles DATA segment (default @ 0x0800) and CODE segment (default @ 0x0300)
- Supports instruction size calculation for proper address resolution
- Converts symbolic references to direct memory addressing
- Handles DB (Define Byte) with hex values and uninitialized (`?`) data

### Build Process

The `build.bat` script automates:

1. Assembly with MASM
2. Object file organization
3. Linking with LINK.EXE
4. Executable generation and execution

## Tools Included

- `MASM.EXE` - Microsoft Macro Assembler
- `LINK.EXE` - Microsoft Linker
- `DEBUG.EXE` - DOS debugger
- `TASM.EXE` - Turbo Assembler
- `EDIT.COM` - DOS text editor
- Supporting utilities (BIN2HEX, EXE2BIN)

## Usage Examples

### DOSBox Workflow

```batch
# Navigate to mounted drive
c:

# Build and run a program
build lcm

# The script automatically:
# - Assembles ASM\lcm.asm
# - Moves lcm.obj to OBJ\
# - Links to create executable
# - Moves lcm.exe to EXE\
# - Runs the program
```

### Python Converter Workflow

1. Edit the `assembly` variable in `masmToTrainerKit.py` with your MASM code
2. Run the converter:

```bash
python masmToTrainerKit.py
```

3. Copy the output memory and code addresses to your trainer kit

## Example Program

```asm
; LCM and HCF Calculator
ASSUME CS:CODE, DS:DATA

DATA SEGMENT
    a   DB 04H
    b   DB 08H
    lcm DB ?
    hcf DB ?
DATA ENDS

CODE SEGMENT
    START:
        MOV AX, DATA
        MOV DS, AX
        MOV AL, a
        MOV BL, b

    BACK:
        MOV AH, 00H
        ADD BL, 00H
        JNZ GET_HCF
        MOV hcf, AL
        JMP FINISH

    GET_HCF:
        DIV BL
        MOV AL, BL
        MOV BL, AH
        JMP BACK

    FINISH:
        MOV AL, a
        MOV BL, b
        MUL BL
        MOV BL, hcf
        DIV BL
        MOV lcm, AL
        MOV AH, 4CH
        INT 21H

CODE ENDS
END START
```

## Notes

- The Python converter is specifically designed for 8086 trainer kits where programs must be loaded as absolute machine code rather than DOS executables
- Default memory layout: DATA segment at 0x0800, CODE segment at 0x0300
- All sample programs are tested and working in DOSBox
