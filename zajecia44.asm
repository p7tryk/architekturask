;-----------------------------------------------------------------------------;
;                                                                             ;
; Autor: Dominik Szajerman, PWSZ                                              ;
; Opis:  Program pytajacy uzytkownika o liczbe i sprawdzajacy, czy liczba     ;
; miesci sie w zakresie podanym w kodzie poprzez dyraktywy EQU:               ;
;                                                                             ;
; W kodzie>   Min1 EQU 2                                                      ;
; W kodzie>   Min2 EQU 7                                                      ;
;                                                                             ;
; Program>    Podaj liczbe (2...7):                                           ;
; Uzytkownik> -3                                                              ;
; Program>    Blad, liczba jest za mala                                       ;
; Program>    Podaj liczbe (2...7):                                           ;
; Uzytkownik> 11                                                              ;
; Program>    Blad, liczba jest za duza                                       ;
; Program>    Podaj liczbe (2...7):                                           ;
; Uzytkownik> 5                                                               ;
; Program>    Ok, liczba miesci sie w zakresie                                ;
;                                                                             ;
;-----------------------------------------------------------------------------;

ORG 100h
    
    JMP Program

    BufLen  EQU 30
    Buf     DB BufLen+2 DUP('.')
    NapisNL       DB 13,10,'$'
	napispodaj db "Podaj liczbe (?...?)$"
	napisblad db "blad$"
	napisok db "ok liczba miesci sie$"

	min1 equ 2
	min2 equ 7

	temp db buflen
Program:
	call setup

	
	call getnumber
	push ax
	call printnewline
	pop ax

	
	cmp ax, min1
	jb blad
	
	cmp ax, min2
	ja blad

	
	call ok



    MOV AH, 4Ch
	INT 21h
setup:
	mov ax, min1
	mov bx, min2
	add ax, 48
	add bx, 48
	mov offset napispodaj+14, al
	mov offset napispodaj+18, bl
	mov ax,0
	mov bx,0
	ret
ok:
	MOV DX, OFFSET Napisblad
	MOV AH, 9
	INT 21h
	call printnewline
	ret
blad:	
	MOV DX, OFFSET Napisblad
	MOV AH, 9
	INT 21h
	call printnewline
	jmp program
getnumber: 			;daje liczbe w ax
	mov dx,offset napispodaj
	mov ah,9
	int 21h

	call printnewline

	    MOV AL, BufLen
    MOV BX, OFFSET Buf

    CALL Proc_scanf_s
; teraz w [BX] jest odebrany napis

    CALL Proc_atois
				; teraz w AX jest odebrana liczba skonwertowana z napisu
	ret
printnewline:
	MOV DX, OFFSET NapisNL
	MOV AH, 9
	INT 21h
	ret

printax:
	mov bx, offset temp
	call proc_itoas 	;signed version
	mov dx,bx
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
; Procadura: Proc_atois
; konwersja Napisu (dziesietnie) na Signed Int
; we:
;   BX - bufor we
; wy:
;   AX - skonwertowana liczba
;   BX - ustawiony na pierwszy znak bufora
;        nie bedacy cyfra
; niszczy:
;   CX, DX
; ---------------------------------------------
Proc_atois:
	MOV	DL, '-'
	CMP	[BX], DL
	JNE	Proc_atois_not_minus
	INC	BX
	CALL	Proc_atoi
	NEG	AX
	RET
Proc_atois_not_minus:
	CALL	Proc_atoi
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

; ---------------------------------------------
; Procadura: Proc_itoas
; konwersja Signed Int na Napis (dziesietnie)
; we:
;   AX - liczba do konwersji
;   BX - bufor wy
; wy:
;   BX - ustawiony na pierwszy znak bufora wy
; niszczy:
;   CX, DX
; ---------------------------------------------
Proc_itoas:
	CMP	AX, 0
	JL	Proc_itoas_less_than_zero
	CALL	Proc_itoa
	RET
Proc_itoas_less_than_zero:
	INC	BX
	NEG	AX
	CALL	Proc_itoa
	DEC	BX
	MOV	DL, '-'
	MOV	[BX], DL
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
