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
	len		db 100 dup(?)
	ilen	dd 0
	bspace	db " ", 0

.code
main PROC
	push	100
	push	offset input
	call	StdIn

	push	offset input
	call	strlen
	mov		ilen, eax

;	push	ilen
;	push	offset len
;	call	itoa
;
;	push	offset len
;	call	StdOut

	push	offset input
	push	offset output
	call	reverse

	push	offset output
	call	StdOut

	push	0
	call	ExitProcess

main ENDP

reverse PROC					;idea: duyet tu cuoi chuoi, push het len stack, gap " " thì pop ra
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp+0Ch]			;offset input
	mov		ebx, [ebp+08h]			;offset output
	mov		esi, ilen
	xor		edi, edi
	push	0h

	for_dec:
		cmp		esi, 30h
		jz		break_re
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		cmp		dl, 0
		jz		pop_str
		cmp		dl, " " 
		jz		pop_str
		push	edx
		dec		esi
		jmp		for_dec

	pop_str:
;		xor		edx, edx
		pop		edx
		cmp		dl, 0h
		jz		push_0h
		mov		byte ptr [ebx+edi], dl
		inc		edi
		jmp		pop_str

	push_0h:
		push	0h
;		dec		esi
		jmp		for_dec

	break_re:
		mov		byte ptr [ebp+edi], 20h
		inc		edi
		mov		byte ptr [ebx+edi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

reverse ENDP		


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
		jz		break_itoa
		mov		byte ptr [ebx+edi], dl
		inc		edi
		jmp		pop_itoa

	break_itoa:
		mov		byte ptr [ebx+edi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP
END main