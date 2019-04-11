ORG 100h


	mov bx, offset napis-1	
        jmp petla
temp:	
	
Petla:
	add bx, 1

	cmp [bx], 13 		; jezeli newline to wypisz
	je wypisz
	
	cmp  [bx],'A'
	jb petla
	cmp [bx],'Z'
	ja petla

	
	mov al, [bx]
	add al, wielkiemale
	mov [bx], al
	jmp petla

Wypisz:
        MOV     DX, OFFSET Napis
        MOV     AH, 9h
        INT     21h
        MOV     DX, OFFSET Napis2
        MOV     AH, 9
        INT     21h
        MOV     AX, 4C00h
        INT     21h


Napis     DB "KOBYLA MA MALY BOK.", 13, 10, "$"
Napis2    DB "A TEGO NIE ZMIENIAJ!$"
	
WielkieMale  EQU 32
ret



