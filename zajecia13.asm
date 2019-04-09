org 100h

	jmp start

	napis DB "kobyla ma maly bok",13,10,"$"

start:
	mov bx, offset napis
	mov al, [bx]
	sub al, 32
	mov [bx], al

	

	mov dx, offset napis
	mov ah,9
	;; sub napis,32
	int 21h
	
	
ret



