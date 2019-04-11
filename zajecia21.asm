ORG 100h


	mov bx, offset napis	
        jmp petla

Petla:
	add bx, 1
	cmp  [bx], 13
	je wypisz
	
	mov al, [bx]
	add al, wielkiemale
	mov [bx], al
	jmp petla

Wypisz:
        MOV     DX, OFFSET Napis
        MOV     AH, 9
        INT     21h
        MOV     AH, 4Ch
        INT     21h



	Napis     DB "KOBYLAMAMALYBOK", 13, 10, "$"
	napis2	  DB 
WielkieMale  EQU 32
ret



