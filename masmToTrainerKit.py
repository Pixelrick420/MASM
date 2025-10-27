class Assembler:
    def __init__(self):
        self.symTab = {}
        self.memory = {}
        self.code = []
        self.dataAddr = 0x0800
        self.codeAddr = 0x0300
        self.locationCounter = 0x0300
        
    def isHex(self, value):
        if isinstance(value, str) and value.upper().endswith('H'):
            return True
        return False
    
    def hexToInt(self, hexStr):
        if hexStr.upper().endswith('H'):
            return int(hexStr[:-1], 16)
        return int(hexStr)
    
    def intToHex(self, value, digits=4):
        return f'{value:0{digits}X}'
    
    def getSize(self, instruction):
        opcode = instruction.split()[0].upper()
        
        size = {
            'MOV': 2, 'CALL': 3, 'JNZ': 2, 'INT': 2, 'INC': 1, 'DEC': 1,
            'AND': 2, 'XCHG': 1, 'JMP': 2, 'CMP': 2, 'JE': 2, 'MUL': 2, 'PUSH': 1
        }
        return size.get(opcode, 2)  
    
    def pass1(self, lines):
        curSegment = None
        dataOffset = self.dataAddr
        
        for line in lines:
            line = line.strip()
            if not line or line.startswith(';'):
                continue
                
            if line.upper().startswith('DATA SEGMENT'):
                curSegment = 'DATA'
                continue
            elif line.upper().startswith('CODE SEGMENT'):
                curSegment = 'CODE'
                continue
            elif line.upper().startswith('ENDS'):
                curSegment = None
                continue
            elif line.upper().startswith('END'):
                break
                
            if curSegment == 'DATA':
                parts = line.split()
                if len(parts) >= 3:
                    label = parts[0]
                    dtype = parts[1]
                    values = ' '.join(parts[2:])
                    
                    self.symTab[label] = dataOffset
                    
                    if 'DB' in dtype.upper():
                        if values == '?':
                            self.memory[dataOffset] = '??'  
                            dataOffset += 1
                        elif ',' in values:
                            hexVals = [v.strip() for v in values.split(',')]
                            for i, val in enumerate(hexVals):
                                if self.isHex(val):
                                    intVal = self.hexToInt(val)
                                    self.memory[dataOffset + i] = intVal
                                elif val == '?':
                                    self.memory[dataOffset + i] = '??'
                            dataOffset += len(hexVals)
                        else:
                            if self.isHex(values):
                                intVal = self.hexToInt(values)
                                self.memory[dataOffset] = intVal
                                dataOffset += 1
                            elif values == '?':
                                self.memory[dataOffset] = '??'
                                dataOffset += 1
                    
            elif curSegment == 'CODE':
                if ':' in line:
                    label = line.split(':')[0].strip()
                    self.symTab[label] = self.locationCounter
                    line = line.split(':', 1)[1].strip()
                
                if line:
                    self.locationCounter += self.getSize(line)
    
    def pass2(self, lines):
        curSegment = None
        codeAddr = self.codeAddr
        output = []
        
        for line in lines:
            line = line.strip()
            if not line or line.startswith(';'):
                continue
                
            if line.upper().startswith('DATA SEGMENT'):
                curSegment = 'DATA'
                continue
            elif line.upper().startswith('CODE SEGMENT'):
                curSegment = 'CODE'
                continue
            elif line.upper().startswith('ENDS'):
                curSegment = None
                continue
            elif line.upper().startswith('END'):
                break
                
            if curSegment == 'CODE':
                if ':' in line:
                    line = line.split(':', 1)[1].strip()
                
                if line:
                    resolved_line = self.resolve(line)
                    output.append(f'{self.intToHex(codeAddr)}: {resolved_line}')
                    codeAddr += self.getSize(line)
        
        return output
    
    def resolve(self, instruction):
        parts = instruction.split()
        resolved = []
        
        for i, part in enumerate(parts):
            if ',' in part and not part.startswith('['):
                subparts = part.split(',')
                resolved_subparts = []
                for subpart in subparts:
                    subpart = subpart.strip()
                    if subpart in self.symTab:
                        resolved_subparts.append(f'[{self.intToHex(self.symTab[subpart])}]')
                    else:
                        resolved_subparts.append(subpart)
                resolved.append(','.join(resolved_subparts))
            elif part in self.symTab:
                if parts[0].upper() in ['JMP', 'JE', 'JNZ', 'JZ', 'CALL']:
                    resolved.append(self.intToHex(self.symTab[part]))
                else:
                    resolved.append(f'[{self.intToHex(self.symTab[part])}]')
            elif part.upper() in ['DATA', 'STACK']:
                resolved.append(part)
            elif part.startswith('OFFSET'):
                symbol = part[6:].strip()
                if symbol in self.symTab:
                    resolved.append(f'OFFSET {self.intToHex(self.symTab[symbol])}')
                else:
                    resolved.append(part)
            elif part.startswith('[') and part.endswith(']'):
                inner = part[1:-1]
                if inner in self.symTab:
                    resolved.append(f'[{self.intToHex(self.symTab[inner])}]')
                else:
                    resolved.append(part)
            else:
                resolved.append(part)
        
        return ' '.join(resolved)
    
    def assemble(self, assembly):
        lines = assembly.split('\n')
        self.pass1(lines)
        self.pass2(lines)
        
        return self.formatOut()
    
    def formatOut(self):
        output = []
        
        output.append('MEMORY:')
        current_block = None
        
        for addr in sorted(self.memory.keys()):
            block = addr & 0xFF00
            if block != current_block:
                current_block = block
                output.append('')
            
            value = self.memory[addr]
            if value == '??':
                output.append(f'{self.intToHex(addr)}   ??')
            else:
                output.append(f'{self.intToHex(addr)}   {self.intToHex(value, 2)}')
        
        output.append('\n')
        
        output.append('CODE:')
        lines = self.pass2(assembly.split('\n'))
        for line in lines:
            output.append(line)
        
        return '\n'.join(output)



assembly = '''DATA SEGMENT
	a 	DB 04H
	b 	DB 08H
	lcm 	DB ?
	hcf 	DB ?
DATA ENDS

CODE SEGMENT
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
        HLT

CODE ENDS
END START'''


assembler = Assembler()
result = assembler.assemble(assembly)
print(result)