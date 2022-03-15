.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	a	db 30 dup(?)
	b	db 30 dup(?)
	cc	db 30 dup(?)
	len dd 0
.code
main PROC
	push	30
	push	offset a
	call	StdIn
	
	push	30
	push	offset b
	call	StdIn

	push	offset a
	push	offset b
	push	len
	call	strcmp

	push	len
	push	offset cc
	call	itoa

	push	offset cc
	call	StdOut

	push	0
	call	ExitProcess
main ENDP

strlen PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ebx, [ebp+08h]	;str
	xor		esi, esi
	xor		eax, eax

	@len:
		cmp		byte ptr [ebx+esi], 0
		jz		@done_len
		inc		esi
		jmp		@len

	@done_len:
		mov		eax, esi
		pop		ebx
		pop		ebp
		ret		4

strlen ENDP

strchr PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp+10h]	;str
	mov		ebx, [ebp+0Ch]	;ki tu
	mov		ecx, [ebp+08h]	;nstr
	xor		esi, esi
	xor		edi, edi

	@cmp_str:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		mov		dh, byte ptr [ebx+0]
		cmp		dl, dh
		jz		@mov_str
		inc		esi
		jmp		@cmp_str

	@mov_str:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		cmp		dl, 0
		jz		@break_mov
		mov		byte ptr [ecx+edi], dl
		inc		esi
		inc		edi
		jmp		@mov_str

	@break_mov:
		mov		byte ptr [ecx+edi], 0
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12

strchr ENDP

memcpy PROC
	push	ebp
	mov		ebp, esp

memcpy ENDP

strcmp PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp+10h]	;str1
	mov		ebx, [ebp+0Ch]	;str2
	mov		ecx, [ebp+08h]	;kq
	xor		esi, esi
	xor		edi, edi

	@cmp:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		mov		dh, byte ptr [ebx+esi]
		cmp		dl, dh
		jc		@movneg1
		cmp		dh, dl
		jc		@mov1
		inc		esi
		cmp		dl, 0
		jz		@mov0
		cmp		dh, 0
		jz		@mov0
		jmp		@cmp

	@mov0:
		mov		ecx, 0
		jmp		@break

	@mov1:
		mov		ecx, 1
		jmp		@break

	@movneg1:
		mov		ecx, 2
;		neg		ecx
		jmp		@break

	@break:
;		mov		byte ptr [ecx+edi], 0
;		mov		len, ecx
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12

strcmp ENDP

strset PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp+10h]	;str
	mov		ebx, [ebp+0Ch]	;ki tu
	mov		ecx, [ebp+08h]	;nstr
	xor		esi, esi

	@set:
		xor		edx, edx
		mov		dl, byte ptr [ebx+0]
		cmp		byte ptr [eax+esi], 0
		jz		@finished
		mov		byte ptr [ecx+esi], dl
		inc		esi
		jmp		@set

	@finished:
		mov		byte ptr [ecx+esi], 0
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12

strset ENDP

itoa PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+0Ch]	;number
	mov		ebx, [ebp+08h]	;nstr
	xor		esi, esi
	mov		ecx, 10
	push	69h

	@itoa_loop:
		xor		edx, edx
		div		ecx
		or		edx, 30h
		push	edx
		cmp		eax, 0
		jz		@pop_itoa
		jmp		@itoa_loop

	@pop_itoa:
		xor		edx, edx
		pop		edx
		cmp		dl, 69h
		jz		@break
		mov		byte ptr [ebx+esi], dl
		inc		esi
		jmp		@pop_itoa

	@break:
		mov		byte ptr [ebx+esi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP
END main