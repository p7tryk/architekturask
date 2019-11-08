;-----------------------------------------------------------------------------;
;                                                                             ;
; Autor: Dominik Szajerman, PWSZ                                              ;
; Opis:  Program dodajacy dwie liczby i wypisujacy wynik w ponizszy sposob:   ;
;                                                                             ;
; 1001 + 45 = 1046                                                            ;
;                                                                             ;
; Na jego podstawie stworzyc nizej opisane programy:                          ;
;                                                      ;
; Na jego podstawie stworzyc nizej opisane programy (cd. 02_01.asm):          ;
; 4. Obliczajacy reszte z dzielenia: 9753 % 11                                ;
; 5. Obliczajacy: 1000 + 40 * 3 (priorytety dzialan)                          ;
; 6. Obliczajacy: 999 - 400 / 3 (jw.)                                         ;
;-----------------------------------------------------------------------------;

ORG 100h

    JMP Program

    Buffer        DB "......"
    NapisPlus     DB " + $"
    NapisRownasie DB " = $"
    NapisNL       DB 13,10,'$'

	Dana1         EQU 1001
	Dana2         EQU 45
	Dana3		EQU 3
addaxcx:
	
	ret

	
Program:
	napisznak DB " % $"
	napisznak2 DB " * $"
	call printequation
	mov dx, 0
	mov ax, dana1
	mov cx, dana2
	div cx
	mov ax, dx
	call printaxnumber

	mov dx, offset napisnl
	call print
	
	mov bx, offset napisznak+1
	mov al, '+'
	mov [bx],al
	mov bx, offset napisznak2+1
	mov al, '*'
	mov [bx],al
	call printequation2
	
	mov ax, dana2
	mov cx, dana3
	mul cx
	add ax, dana1
	call printaxnumber

	mov dx, offset napisnl
	call print
	
	

	mov bx, offset napisznak+1
	mov al, '-'
	mov [bx],al
	mov bx, offset napisznak2+1
	mov al, '/'
	mov [bx],al
	call printequation2

	mov dx, 0
	mov ax, dana2
	mov cx, dana3
	div cx

	mov bx, dana1
	sub bx, ax
	mov ax,bx
	call printaxnumber

	
	MOV AH, 4Ch
	INT 21h
	ret
printequation:
	mov ax, dana1
	call printaxnumber
	
	mov dx, offset napisznak
	call print

	mov ax, dana2
	call printaxnumber

	mov dx, offset napisrownasie
	call print
	ret
printequation2:
	mov ax, dana1
	call printaxnumber
	
	mov dx, offset napisznak
	call print

	mov ax, dana2
	call printaxnumber

	mov dx, offset napisznak2
	call print

	mov ax, dana3
	call printaxnumber

	mov dx, offset napisrownasie
	call print
	ret
print:
	MOV AH, 9
	INT 21h
	ret

printaxnumber:
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
