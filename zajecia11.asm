org 100h
	mov dx, offset hello
	mov ah, 9
	int 21h
	mov ah, 4Ch
	int 21h
	
	hello DB "Hello World$" 10 13 "And my name is john cena$"
ret



