ORG 100h

;	policzyc wyrazy
	mov bx, offset napis-1
	mov al, 1
        jmp petla
	
Petla:
	add bx, 1

	cmp bx, offset napisend
	je wypisz

	cmp [bx-1], ' '
	jne petla

	cmp [bx],'A'
	jb petla
	cmp [bx], 'z'
	ja petla
	
	
	

	
	jmp count		
count:	
	inc al
	jmp petla
	
Wypisz:
	add	al, 48
	mov	offset liczba , al
	
        MOV     DX, OFFSET liczbawyrazow
        MOV     AH, 9
        INT     21h
        MOV     AX, 4C00h
        INT     21h

	
liczbawyrazow DB "Liczba wyrazow w napis="
liczba	DB "?",13,10
Napis  	 DB "KOBYLA  ma maly bok.", 13, 10
napisend DB "$"	
ret



