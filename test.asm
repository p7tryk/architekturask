	org 100h
	jmp start
	dana1 EQU 100
	dana2 EQU 50

start:
	mov ax, dana1
	mov bx, dana2

	mov [ax], 0
	mov [bx], 1

	m
	MOV AH, 9
	INT 21h
	
