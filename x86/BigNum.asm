.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	num1	db 30 dup(?)
	num2	db 30 dup(?)
	res		db 31 dup(?)
	len1	dd 0
	len2	dd 0
	mem		dd 0

.code
main PROC
	push	30
	push	offset num1
	call	StdIn
	push	offset num1
	call	strlen
	mov		len1, eax

	push	30
	push	offset num2
	call	StdIn
	push	offset num2
	call	strlen
	mov		len2, eax

	push	offset num1
	call	reverse
	push	offset num2
	call	reverse

	mov		eax, len1
	mov		ebx, len2
	cmp		eax, ebx
	jz		jmp_add				;=
	cmp		eax, ebx
	jl		jmp_str2			;<
	cmp		eax, ebx
	jg		jmp_str1			;>

	jmp_add:
		push	offset num1
		push	offset num2
		push	offset res
		call	addnum
		jmp		@index

	jmp_str2:
		push	len2
		push	len1
		push	offset num1
		call	insert_zero
		push	offset num1
		push	offset num2
		push	offset res
		call	addnum
		jmp		@index

	jmp_str1:
		push	len1
		push	len2
		push	offset num2
		call	insert_zero
		push	offset num1
		push	offset num2
		push	offset res
		call	addnum
		jmp		@index

	@index:
		push	offset res
		call	reverse
		push	offset res
		call	StdOut

	push	0
	call	ExitProcess

main ENDP

addnum PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp+10h]		;num1
	mov		ebx, [ebp+0Ch]		;num2
	mov		ecx, [ebp+08h]		;res
	xor		esi, esi
	xor		edi, edi

	@add:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		mov		dh, byte ptr [ebx+esi]
		cmp		dl, 0
		jz		@done
		sub		dl, 30h
		sub		dh, 30h
		add		dl, dh
		xor		dh, dh
		add		edx, mem
		mov		mem, 0
		cmp		dl, 0Ah
		jnc		@high

	@next:
		add		dl, 30h
		mov		byte ptr [ecx+esi], dl
		inc		esi
		jmp		@add

	@high:
		mov		mem, 1
		sub		dl, 10
		jmp		@next

	@done:
		xor		edx, edx
		mov		edx, mem
		cmp		dl, 0
		je		@end
		add		dl, 30h
		mov		byte ptr [ecx+esi], dl
		inc		esi

	@end:
		mov		byte ptr [ecx+esi], 0
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12

addnum ENDP

insert_zero PROC
	push	ebp
	mov		ebp, esp
	push	esi				;lendai
	push	edi				;lenngan
	push	eax				;str
	mov		esi, [ebp+10h]
	mov		edi, [ebp+0Ch]
	mov		eax, [ebp+08h]
	
	@insert:
		cmp		edi, esi
		jz		@done
		mov		byte ptr [eax+edi], 30h
		inc		edi
		jmp		@insert

	@done:
		mov		byte ptr [eax+edi], 0
		pop		eax
		pop		edi
		pop		esi
		pop		ebp
		ret		12

insert_zero ENDP

reverse PROC
	push	ebp
	mov		ebp, esp
	push	eax
	mov		eax, [ebp+08h]
	xor		esi, esi
	xor		edi, edi
	push	0h

	for_re:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		cmp		dl, 0
		jz		pop_re
		push	edx
		inc		esi
		jmp		for_re

	pop_re:
		xor		edx, edx
		pop		edx
		cmp		dl, 0h
		jz		done_re
		mov		byte ptr [eax+edi], dl
		inc		edi
		jmp		pop_re

	done_re:
		mov		byte ptr [eax+edi], 0
		pop		eax
		pop		ebp
		ret		4

reverse ENDP

strlen PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ebx, [ebp+08h]
	xor		esi, esi
	xor		eax, eax

	@len:
		cmp		byte ptr [ebx+esi], 0
		jz		@finished
		inc		esi
		jmp		@len
	
	@finished:
		mov		eax, esi
		pop		ebx
		pop		ebp
		ret		4

strlen ENDP
END main