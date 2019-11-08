;-----------------------------------------------------------------------------;
;                                                                             ;
; Autor: Dominik Szajerman, PWSZ                                              ;
; Opis:  Program pytajacy uzytkownika o dwie liczby i wypisujacy ich sume:    ;
;        (program wejsciowy jest identyczny z 04_01.asm)                      ;
;                                                                             ;
; Program>    Podaj pierwsza liczbe:                                          ;
; Uzytkownik> 12                                                              ;
; Program>    Podaj druga liczbe:                                             ;
; Uzytkownik> 15                                                              ;
; Program>    12 + 15 = 27                                                    ;
;                                                                             ;
;-----------------------------------------------------------------------------;

ORG 100h
    
    JMP Program

    BufLen  EQU 30
    Buf     DB BufLen+2 DUP('.')
	NapisNL DB 13,10,'$'
	dane db BufLen DUP('.')

	napisplus db " + $"
	napisrownasie db " = $"

	napispierwsza db "Podaj pierwsza liczbe$"
	napisdruga db "Podaj druga liczbe$"

	temp BD buflen+2 DUP('.')

Program:

	mov dx, offset napispierwsza
	mov ah, 9
	int 21h

	call printnewline

	
    MOV AL, BufLen
    MOV BX, OFFSET Buf

    CALL Proc_scanf_s
; teraz w [BX] jest odebrany napis

    CALL Proc_atoi
; teraz w AX jest odebrana liczba skonwertowana z napisu

	push ax 		;pierwsza liczba na stack

	call printnewline
	mov dx, offset napisdruga
	mov ah, 9
	int 21h
	call printnewline
	
	

	MOV AL, BufLen	
    MOV BX, OFFSET Buf
	
    CALL Proc_scanf_s
; teraz w [BX] jest odebrany napis

    CALL Proc_atoi
; teraz w AX jest odebrana liczba skonwertowana z napisu	

	push ax

	call printnewline

	pop ax
	push ax
	
	call printax

	call printplus
	
	
	pop ax
	pop bx

	push ax
	mov ax,bx
	push ax

	call printax

	call printrownasie
	
	pop ax
	pop bx

	add ax, bx

	call printax

	
	
	

	
	

    

    MOV AH, 4Ch
	INT 21h
printplus:
	mov dx, offset napisplus
	mov ah, 9
	int 21h
	ret

printrownasie:	
	mov dx, offset napisrownasie
	mov ah, 9
	int 21h
	ret
printax:
	mov bx, offset temp
	call proc_itoa
	mov dx,bx
	mov ah, 9
	int 21h
	ret

printnewline:
	mov dx, offset napisNL
	mov ah, 9
	int 21h
	ret

; ---------------------------------------------
; Procadura: Proc_scanf_s
; pobranie napisu do bufora
; we:
;   AL - dlugosc bufora
;   BX - adres bufora
; wy:
;   wypelniony bufor
;   BX - adres pierwszego pobranego znaku
; niszczy:
;   DX
; ---------------------------------------------
Proc_scanf_s:
	MOV	[BX], AL
	MOV	DX, BX
	MOV	AH, 0Ah
	INT	21h
	INC	BX
	MOV	AL, [BX]
	XOR	AH, AH
	ADD	BX, AX
	INC	BX
	MOV	DL, '$'
	MOV	[BX], DL
	SUB	BX, AX
	RET





	
; ---------------------------------------------
; Procedura: Proc_atoi
; konwersja Napisu (dziesietnie) na Int
; we:
;   BX - bufor we
; wy:
;   AX - skonwertowana liczba
;   BX - ustawiony na pierwszy znak bufora
;        nie bedacy cyfra
; niszczy:
;   CX, DX
; ---------------------------------------------
Proc_atoi:
	MOV	AX,	0
	MOV	CL, '0'
	MOV	CH, '9'
Proc_atoi_loop1:
	CMP	[BX], CL
	JB	Proc_atoi_skip1
	CMP	[BX], CH
	JA	Proc_atoi_skip1
	SHL	AX,1
	MOV	DX, AX
	SHL	DX,1
	SHL	DX,1
	ADD	AX,	DX	; AX*=10
	ADD	AL, [BX]
	ADC	AH, 0
	SUB	AX, '0'
	INC	BX
	JMP	Proc_atoi_loop1
Proc_atoi_skip1:
	RET

	
;---------------------------------------------------------------------;
; Procedura: Proc_itoa
; konwersja Int na Napis (dziesietnie)                                ;
; wejscie:                                                            ;
;   AX - liczba do konwersji                                          ;
;   BX - bufor wyjsciowy (gdzie umiescic napis)                       ;
; wyjscie:                                                            ;
;   BX - ustawiony na pierwszy znak napisu w buforze wyjsciowym       ;
; niszczy/uzywa:                                                      ;
;   CX, DX                                                            ;
;---------------------------------------------------------------------;
Proc_itoa:
	ADD	BX, 5
	MOV	CL, '$'
	MOV	[BX], CL
	MOV	CX, 10
Proc_itoa_loop1:
	DEC	BX
	XOR	DX, DX
	DIV	CX       ; DX:AX/CX -> 0:AX/10 => AX r. DX
	ADD	DL, '0'
	MOV	[BX], DL
	CMP	AX, 0
	JNE	Proc_itoa_loop1
	RET



END Program
