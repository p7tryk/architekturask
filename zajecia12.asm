org 100h

	jmp start
	hello DB "Hello World$"

start:	
	mov dx, offset hello
	mov ah, 9
	int 21h
	mov ah, 4Ch
	int 21h
	
	
ret



