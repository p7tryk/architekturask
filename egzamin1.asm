;-----------------------------------------------------------------------------;
;                                                                             ;
; Autor: Patryk Kaniewski                                              ;   ;
;-----------------------------------------------------------------------------;

ORG 100h
    
	JMP setup

	BufLen  EQU 30
	Buf     DB BufLen+2 DUP('.')
	NapisNL       DB 13,10,'$'
	napispodaj db "O jakiej liczbie mysle$"
	napismalo db "za malo$"
	napisduzo db "za duzo$"
	napisok db "Zgadles$"

	
	temp db buflen
	zakres db 99
	number dw 0

setup:	
	call srand
	call rand
	
	xor dx,dx
	div word ptr [zakres] 	;w jakim zakresie beda liczby

 	inc dx		;0-99 na 1-100
	mov number, dx

	;; test
	mov ax,dx
	call printax
	call printnewline
	call printnewline
Program:
	call getnumber
	push ax
	call printnewline
	pop ax

;; dla negatywnych wejsc



	
	cmp ax, number
	jl bladmalo
	
	cmp ax, number
	ja bladduzo

	

	
	call ok
	;; ENDDDDDDDDDDDDDDDDDDDDDD
	MOV AH, 4Ch
	INT 21h


	
ok:
	MOV DX, OFFSET napisok
	MOV AH, 9
	INT 21h
	call printnewline
	ret
	
bladmalo:	
	MOV DX, OFFSET napismalo
	MOV AH, 9
	INT 21h
	call printnewline
	jmp program

bladduzo:
	MOV DX, OFFSET napisduzo
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

	CALL Proc_scanf_s	; teraz w [BX] jest odebrany napis

	CALL Proc_atois
				; teraz w AX jest odebrana liczba skonwertowana z napisu
	ret
	
printnewline:
	MOV DX, OFFSET NapisNL
	MOV AH, 9
	INT 21h
	ret

printax: 			;prints ax as number
	mov bx, offset buf
	call proc_itoas 	;signed version
	mov dx,bx
	mov ah, 9
	int 21h
	ret

	;; ---------------------koniec mojego kodu-------------------------
srand:
	xor ax,ax
	int 1Ah
	mov word ptr [seed],dx
	ret
rand:
	push dx
	mov ax, 25173
	mul word ptr [seed]
	add ax, 13849
	mov word ptr [seed], ax
	pop dx
	ret
	seed dw 11


	;; -------------------------------------------------------------------------------------------
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
