ORG 100h
	
	mov ax, 1234h
	mov bx, 1234h
	jmp	start
sub2:
	add ax, 12
	ret
	
sub1:
	sub ax, bx
	call sub2
	ret
start:
	mov ax, ip
	add ax, 6
	push ax
	jmp ax
	MOV     DX, OFFSET liczbawyrazow
        MOV     AH, 9
        INT     21h


	liczbawyrazow DB "1"
ret



