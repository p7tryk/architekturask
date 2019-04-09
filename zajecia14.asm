org 100h
	;; 3+4=?
	jmp start

	napis DB "? + ? = ?",13,10,"$"

start:

	
	mov bx, offset napis
	
	mov al, skladnik1
	add al, cyfranaascii
	mov [bx], al

	
	mov al, skladnik2
	add al, cyfranaascii
	mov [bx]+4, al
	
	
	add al, skladnik1
	mov [bx]+8,al
	

	mov dx, offset napis
	mov ah, 9
	int 21h
	

	skladnik1 equ 5
	skladnik2 equ 3
	cyfranaascii equ 48
ret



