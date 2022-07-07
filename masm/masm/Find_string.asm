.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	strcha	db 100 dup(?)
	strcon	db 10 dup(?)
	index	db 5 dup(?)
	result	db 100 dup(?)
	clen	dd 0
	cnt		dd 0
	bspace	db " ", 0

.code 
main PROC
	push	100
	push	offset strcha
	call	StdIn

	push	10
	push	offset strcon
	call	StdIn

	push	offset strcon	
	call	strlen
	mov		clen, eax

	push	offset strcha
	push	offset strcon
	call	find_vt

	push	offset result
	call	StdOut

	push	0
	call	ExitProcess

main ENDP

find_vt PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+08h]
	mov		ebx, [ebp+0Ch]
	xor		esi, esi
	
	for_find:
		xor		edx, edx
		xor		edi, edi
		mov		dl, byte ptr [ebx+esi]
		cmp		dl, 0
		jz		done_find
		mov		dh, byte ptr [eax+0h]
		cmp		dl, dh
		jz		cmp_inc
		inc		esi
		jmp		for_find

	cmp_inc:
		xor		edx, edx
		mov		dl, byte ptr [eax+edi]
		cmp		dl, 0
		jz		pop_vt
		mov		dh, byte ptr [ebx+esi]
		cmp		dl, dh
		jnz		for_find
		inc		edi
		inc		esi
		jmp		cmp_inc

	pop_vt:
		sub		esi, clen
		push	esi
		push	offset index
		call	itoa
		add		esi, clen
		push	offset index
		push	offset result
		push	cnt
		call	cout 
		jmp		for_find

	done_find:
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

find_vt ENDP

cout PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp+10h]
	mov		ebx, [ebp+0Ch]
	mov		ecx, [ebp+08h]
	xor		edi, edi

	for_cout:
		xor		edx, edx
		mov		dl, byte ptr [eax+edi]
		cmp		dl, 0
		jz		done_cout
		mov		byte ptr [ebx+ecx], dl
		inc		ecx
		inc		edi
		jmp		for_cout

	done_cout:
		mov		byte ptr [ebx+ecx], 20h
		inc		ecx
		mov		byte ptr [ebx+ecx], 0
		mov		cnt, ecx
		xor		edi, edi
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12

cout ENDP


strlen PROC
	push	ebp
	mov		ebp, esp
	mov		ecx, [ebp+08h]
	xor		esi, esi
	xor		eax, eax

	next_char:
		cmp		byte ptr [ecx+esi], 0
		jz		break
		inc		esi
		jmp		next_char

	break:
		mov		eax, esi
		pop		ebp
		ret		4

strlen ENDP

itoa PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+0Ch]
	mov		ebx, [ebp+08h]
	mov		ecx, 10
	xor		edi, edi
	push	69h

	for_div:
		xor		edx, edx
		div		ecx
		or		edx, 30h
		push	edx
		cmp		eax, 0
		jz		pop_itoa
		jmp		for_div

	pop_itoa:
		pop		edx
		cmp		dl, 69h
		jz		break
		mov		byte ptr [ebx+edi], dl
		inc		edi
		jmp		pop_itoa

	break:
		mov		byte ptr [ebx+edi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP
END main