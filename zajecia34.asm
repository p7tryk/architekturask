;-----------------------------------------------------------------------------;
;                                                                             ;
; Autor: Dominik Szajerman, PWSZ                                              ;
; Opis:  Program pytajacy uzytkownika o imie i wypisujacy przywitanie         ;
;        (w tym imie wielkimi literami):                                      ;
;                                                                             ;
; Program>    Jak masz na imie?                                               ;
; Uzytkownik> Jasio                                                           ;
; Program>    Czesc, JASIO!                                                   ;
;                                                                             ;
;-----------------------------------------------------------------------------;

ORG 100h

    JMP Program

    BufLen      EQU 30
    Buf         DB BufLen+2 DUP('.')
    NapisNL     DB 13,10,'$'
	Napisczesc DB "Czesc, &"
	napispytanie DB "Jak masz na imie$"

Program:
	MOV DX, OFFSET Napispytanie
	MOV AH, 9
	INT 21h

	MOV DX, OFFSET NapisNL
	MOV AH, 9
	INT 21h

	
	MOV AL, BufLen
	MOV BX, OFFSET Buf
	CALL Proc_scanf_s

	call naduze

	MOV DX, OFFSET NapisNL
	MOV AH, 9
	INT 21h
	MOV DX, OFFSET Napisczesc
	MOV AH, 9
	INT 21h

	MOV DX, BX
	MOV AH, 9
	INT 21h

	MOV AH, 4Ch
	INT 21h
naduze:
	

; ---------------------------------------------
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


END Program
