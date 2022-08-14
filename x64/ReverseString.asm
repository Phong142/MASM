extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data?
	strr	db 100 dup(?)
	nByte	dd ?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 40h

	mov		rcx, -10		;Std_Input_Handle
	call	GetStdHandle
	mov		[rbp-08h], rax
	mov		rcx, -11		;Std_Output_Handle
	call	GetStdHandle
	mov		[rbp-10h], rax

	xor		r14, r14
	mov		rcx, [rbp-08h]
	mov		rdx, offset strr
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp+20h], r14
	call	ReadFile

	mov		rsi, offset strr
	call	reverse

	mov		rax, rdi
	mov		bx, 0A0Dh			;/r /n
	mov		word ptr [rsi+rax], bx
	add		rax, 2
	mov		rcx, [rbp-10h]
	mov		rdx, rsi			;offset strr
	mov		r8, rax
	mov		r9, offset nByte
	mov		[rsp+20h], r14
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP

reverse PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rcx
	push	rdx
	mov		rdi, rsi		;offset strr
	mov		rdx, rsi
	xor		rax, rax
	xor		rcx, rcx
	cld

	pushLoop:
		lodsb			;al = [esi++]
		cmp		al, 0Dh
		jz		popLoop
		push	rax
		inc		rcx
		jmp		pushLoop

	popLoop:
		test	rcx, rcx
		jz		break
		pop		rax
		stosb			;al = [edi++]
		dec		rcx
		jmp		popLoop

	break:
		sub		rdi, rdx		;rdi = strr len
		mov		rsi, rdx
		pop		rdx
		pop		rcx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret

reverse ENDP
END