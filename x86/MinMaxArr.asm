.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	num		db 30 dup(?)
	index	db 35 dup(?)
	n		dd 0
	min		dd 100000
	max		dd 0
	bspace	db 20h, 0

.code
main PROC
	push	5
	push	offset num
	call	StdIn

	push	offset num
	call	atoi
	mov		n, eax

	@find:
		cmp		n, 0
		jz		@done
		push	30
		push	offset num
		call	StdIn
		dec		n
		push	offset num			;str
		call	atoi
		mov		ebx, eax			;ebx = number
		cmp		ebx, max
		jg		@max
		cmp		ebx, min
		jl		@min
		jmp		@find

	@min:
		mov		min, ebx
		jmp		@find

	@max:
		mov		max, ebx
		jmp		@find

	@done:
		push	max
		push	offset index
		call	itoa
		push	offset index
		call	StdOut

		push	offset bspace
		call	StdOut

		push	min
		push	offset index
		call	itoa
		push	offset index
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

	@atoi:
		xor		edx, edx
		mov		dl, byte ptr [ebx+esi]
		cmp		dl, 0
		jz		@done
		sub		dl, 30h
		add		eax, edx
		mul		ecx
		inc		esi
		jmp		@atoi

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
	xor		edi, edi
	mov		ecx, 10
	push	0h

	@itoa:
		xor		edx, edx
		div		ecx
		add		dl, 30h
		push	edx
		cmp		eax, 0
		jz		@pop
		jmp		@itoa

	@pop:
		pop		edx
		cmp		dl, 0h
		jz		@end
		mov		byte ptr [ebx+esi], dl
		inc		esi
		jmp		@pop

	@end:
		mov		byte ptr [ebx+esi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP
END main