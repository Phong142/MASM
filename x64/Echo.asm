extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	msg		db "input: ", 0h

.data?
	msg2	db 100 dup(?)
	nByte	dd ?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 28h

	xor		rbx, rbx
	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset msg
	mov		r8, sizeof msg
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	WriteFile

	mov		rcx, -10
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset msg2
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	ReadFile

	mov		rcx, -11
	call	GetStdHandle
	mov		rcx, rax
	mov		rdx, offset msg2
	mov		r8, sizeof msg2
	mov		r9, offset nByte
	mov		[rsp+20h], rbx
	call	WriteFile

	mov		ecx, 0
	call	ExitProcess

main ENDP
END

