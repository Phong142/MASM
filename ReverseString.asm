.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	input	db 100 dup(?)
	output	db 100 dup(?)
	ilen	dd 0

.code
main PROC
	push	100
	push	offset input
	call	StdIn

	push	offset input
	push	offset output
	call	reverse
	push	offset output
	call	StdOut

	push	0
	call	ExitProcess

main ENDP

reverse PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+0Ch]
	mov		ebx, [ebp+08h]
	xor		esi, esi
	xor		edi, edi
	push	0h

	for_dec:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		cmp		dl, 0
		jz		pop_str
		push	edx
		inc		esi
		jmp		for_dec

	pop_str:
		pop		edx
		cmp		dl, 0h
		jz		break
		mov		byte ptr [ebx+edi], dl
		inc		edi
		jmp		pop_str

	break:
		mov		byte ptr [ebx+edi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8
reverse ENDP

END main