;-----------------------------------------------------------------------------;
;                                                                             ;
; Autor: Dominik Szajerman, PWSZ                                              ;
; Opis:  Program pytajacy uzytkownika o liczbe i wypisujacy jej kwadrat:      ;
;                                                                             ;
; Program>    Podaj liczbe:                                                   ;
; Uzytkownik> 12                                                              ;
; Program>    Kwadrat liczby 12 to 144                                        ;
;                                                                             ;
;-----------------------------------------------------------------------------;

ORG 100h
    
	JMP Program

	BufLen  EQU 30
	Buf     DB BufLen+2 DUP('.')
	NapisNL DB 13,10,'$'
	Napis 	DB "Kwadratem liczby $"
	Napisjest DB " jest $"
	DaneLen  EQU 20
	Dane     DB DaneLen DUP('.')


Program:
    MOV AL, BufLen
    MOV BX, OFFSET Buf

    CALL Proc_scanf_s
; teraz w [BX] jest odebrany napis

    CALL Proc_atoi
; teraz w AX jest odebrana liczba skonwertowana z napisu


; zachowanie rejestrow na stosie
    PUSH AX 
    PUSH BX
    
    MOV AX,123
    MOV CX,234
    
    POP BX
    POP AX
; zachowanie rejestrow na stosie
    

; zachowanie rejestrow w pamieci
    MOV WORD PTR [Dane],AX
    MOV WORD PTR [Dane+2],CX

    MOV AX,123
    MOV CX,234
    
    MOV AX, WORD PTR [Dane]
    MOV CX, WORD PTR [Dane+2]
; zachowanie rejestrow w pamieci
    
    
	push ax
	CALL Proc_itoa
; teraz w [BX] jest napis skonwertowany z liczby podanej wczesniej w AX
	


	
    MOV DX, OFFSET NapisNL
    MOV AH, 9
	INT 21h

	mov dx, offset napis
	MOV AH, 9
	INT 21h
	
    MOV DX, BX
    MOV AH, 9
	INT 21h

	mov dx, offset napisjest
	mov ah, 9
	int 21h

	pop ax
	mul ax

	mov bx, offset dane+4
	mov [bx], ax
	
	call proc_itoa
	MOV DX, BX
	MOV AH, 9
	INT 21h

    MOV AH, 4Ch
    INT 21h

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

