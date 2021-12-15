.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	mode	db "1. Cong", 0Ah, "2. Tru", 0Ah, "3. Nhan", 0Ah, "4. Chia", 0
	mode1	db " + ", 0
	mode2	db " - ", 0
	mode3	db " * ", 0
	mode4	db " / ", 0
	bang	db " = ", 0
	input	db 3 dup(?)
	num1	db 30 dup(?)
	num2	db 30 dup(?)
	res		db 31 dup(?)
	n		dd 0
	n1		dd 0
	n2		dd 0
	sum		dd 0
	bspace	db 20, 0
	nline	db 0Ah, 0Dh, 0

.code
main PROC
	push	offset mode
	call	StdOut

	push	offset nline
	call	StdOut

	push	3
	push	offset input
	call	StdIn
	push	offset input
	call	atoi
	mov		n, eax					;string to int

	push	30
	push	offset num1
	call	StdIn
	push	offset num1
	call	atoi
	mov		n1, eax

	push	30
	push	offset num2
	call	StdIn
	push	offset num2
	call	atoi
	mov		n2, eax

	mov		ecx, n
	cmp		ecx, 1					;cmp mode
	jz		@add
	cmp		ecx, 2
	jz		@sub
	cmp		ecx, 3
	jz		@mul
	cmp		ecx, 4
	jz		@div
	jmp		@end

	@add:
		push	offset num1
		call	StdOut
		push	offset mode1
		call	StdOut
		push	offset num2
		call	StdOut
		push	offset bang
		call	StdOut
		xor		edx, edx
		xor		eax, eax
		xor		ebx, ebx
		mov		eax, n1					;num1
		mov		ebx, n2					;num2
		add		eax, ebx
		mov		sum, eax
		jmp		@end

	@sub:
		push	offset num1
		call	StdOut
		push	offset mode2
		call	StdOut
		push	offset num2
		call	StdOut
		push	offset bang
		call	StdOut
		xor		edx, edx
		xor		eax, eax
		xor		ebx, ebx
		mov		eax, n1					;num1
		mov		ebx, n2					;num2
		sub		eax, ebx
		mov		sum, eax
		jmp		@end

	@mul:
		push	offset num1
		call	StdOut
		push	offset mode3
		call	StdOut
		push	offset num2
		call	StdOut
		push	offset bang
		call	StdOut
		xor		edx, edx
		xor		eax, eax
		xor		ebx, ebx
		mov		eax, n1					;num1
		mov		ebx, n2					;num2
		mul		ebx
		mov		sum, eax
		jmp		@end

	@div:
		push	offset num1
		call	StdOut
		push	offset mode4
		call	StdOut
		push	offset num2
		call	StdOut
		push	offset bang
		call	StdOut
		xor		edx, edx
		xor		eax, eax
		xor		ebx, ebx
		mov		eax, n1					;num1
		mov		ebx, n2					;num2
		div		ebx
		mov		sum, eax
		jmp		@end

	@end:	
		push	sum
		push	offset res
		call	itoa
		push	offset res
		call	StdOut

		push	0
		call	ExitProcess

main ENDP

atoi PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ebx, [ebp+08h]
	xor		esi, esi
	xor		eax, eax
	mov		ecx, 10

	@mul:
		xor		edx, edx
		mov		dl, byte ptr [ebx+esi]
		cmp		dl, 0
		jz		@done
		sub		dl, 30h
		add		eax, edx
		mul		ecx
		inc		esi
		jmp		@mul

	@done:
		div		ecx
		pop		ebx
		pop		ebp
		ret		4

atoi ENDP

itoa PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+0Ch]
	mov		ebx, [ebp+08h]
	xor		esi, esi
	mov		ecx, 10
	push	0h

	@div:
		xor		edx, edx
		div		ecx
		or		edx, 30h
		push	edx
		cmp		eax, 0
		jz		@pop
		jmp		@div

	@pop:
		xor		edx, edx
		pop		edx
		cmp		dl, 0h
		jz		@done
		mov		byte ptr [ebx+esi], dl
		inc		esi
		jmp		@pop

	@done:
		mov		byte ptr [ebx+esi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP
END main