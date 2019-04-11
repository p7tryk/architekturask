ORG 100h


	mov bx, offset napis-1	
        jmp petla
temp:	
	
Petla:
	add bx, 1

	cmp [bx], 13 		; jezeli newline to wypisz
	je wypisz
	
	cmp  [bx],'a'
	jb petla
	cmp [bx],'z'
	ja petla

	
	mov al, [bx]
	sub al, wielkiemale
	mov [bx], al
	jmp petla

Wypisz:
        MOV     DX, OFFSET Napis
        MOV     AH, 9
        INT     21h
        MOV     AX, 4C00h
        INT     21h


Napis     DB "KOBYLA ma maly bok.", 13, 10
NapisEnd  DB "$"
	WielkieMale  EQU 32
	
ret



