;-----------------------------------------------------------------------------;
;                                                                             ;
; Autor: Dominik Szajerman, PWSZ                                              ;
; Opis:  Program dodajacy dwie liczby i wypisujacy wynik w ponizszy sposob:   ;
;                                                                             ;
; 1001 + 45 = 1046                                                            ;
;                                                                             ;
; Na jego podstawie stworzyc nizej opisane programy:                          ;
; 1. Odejmujacy: 12345 - 543                                                  ;
; 2. Mnozacy: 234 * 95                                                        ;
; 3. Dzielacy: 9876 / 23                                                      ;
;                                                                             ;
;-----------------------------------------------------------------------------;

ORG 100h

    JMP Program

    Buffer        DB "......"
    NapisPlus     DB " + $"
    NapisRownasie DB " = $"
    NapisNL       DB 13,10,'$'

    Dana1         EQU 1001
    Dana2         EQU 45
addaxcx:
	ret

	
Program:
	napisznak DB " / $"
	call printequation
	mov dx, 0
	mov ax, dana1
	mov cx, dana2
	div cx
	call printax

	mov dx, offset napisnl
	call print
	
	mov bx, offset napisznak+1
	mov al, '*'
	mov [bx],al
	call printequation
	mov ax, dana1
	mov cx, dana2
	mul cx
	call printax
	
	mov dx, offset napisnl
	call print
	
	mov bx, offset napisznak+1
	mov al, '+'
	mov [bx],al
	call printequation
	mov ax, dana1
	mov cx, dana2
	add ax,cx
	call printax

	
	mov dx, offset napisnl
	call print
	
	mov bx, offset napisznak+1
	mov al, '-'
	mov [bx],al
	call printequation
	mov ax, dana1
	mov cx, dana2
	sub ax,cx
	call printax
	
	MOV AH, 4Ch
	INT 21h
	ret
printequation:
	mov ax, dana1
	call printax
	
	mov dx, offset napisznak
	call print

	mov ax, dana2
	call printax

	mov dx, offset napisrownasie
	call print
	ret
print:
	MOV AH, 9
	INT 21h
	ret

printax:
	MOV BX, OFFSET Buffer
	CALL Proc_itoa
	mov dx, bx
	call print
	ret

;---------------------------------------------------------------------;
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
	DIV	CX       ; DX:AX/CX => AX/10 -> AX, reszta -> DX
	ADD	DL, '0'
	MOV	[BX], DL
	CMP	AX, 0
	JNE	Proc_itoa_loop1
	RET



END Program
