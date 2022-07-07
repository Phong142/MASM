.386
.model flat, stdcall
option casemap:none

include \masm32\include\kernel32.inc 
include \masm32\include\masm32.inc 
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

.data
	n		db 100 dup(?)
	num_n	dd 0
	mmry	dd 0
	print0	db '0', 20h, 20h, 0
	print1	db '1', 20h, 20h, 0
	s_f1	db 99 dup('0'), '1', 0
	s_f2	db 100 dup('0'), 0
	s_fn	db 101 dup(0)
	fn_fix	db 101 dup(0)
	bspace	db 20h, 20h, 0

.code
main PROC
	push	offset s_f1
	call	reverse

	push	100
	push	offset n
	call	StdIn

	push	offset n
	call	atoi
	mov		num_n, eax

	cmp		num_n, 0
	jz		print01
	cmp		num_n, 1
	jz		print01
	cmp		num_n, 2
;	je		print01
	jmp		print_fibo

	print01:
		push	offset print1
		call	StdOut
		jmp		exit

	print_fibo:
		push	offset print0
		call	StdOut

		push	offset print1
		call	StdOut

		mov		ecx, 2
		mov		eax, num_n
		sub		eax, ecx
		mov		num_n, eax
		mov		eax, 0
		jmp		find_fibo
		
;		mov		ecx, num_n
;		dec		ecx
;		mov		num_n, ecx
;		jmp		find_fibo

	find_fibo:
		mov		ecx, num_n
		cmp		num_n, 0
		je		exit
		
		push	offset s_f1
		push	offset s_f2
		push	offset s_fn
		call	addnum

		push	offset s_f1
		push	offset s_f2
		call	copy
		push	offset s_fn
		push	offset s_f1
		call	copy

		push	offset s_fn
		call	reverse
		push	offset s_fn
		call	fix_zero
		push	offset fn_fix
		call	reverse
		push	offset fn_fix
		call	StdOut

		push	offset bspace
		call	StdOut
		mov		ecx, num_n
		dec		ecx
		mov		num_n, ecx
		jmp		find_fibo

	exit:
		ret	
;		push	0
;		call	ExitProcess
	
	push	0
	call	ExitProcess

main ENDP

addnum PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	push	ecx
	mov		eax, [ebp+10h]			;f1
	mov		ebx, [ebp+0Ch]			;f2
	mov		ecx, [ebp+08h]			;fn
	xor		esi, esi
	xor		edi, edi

	for_add:
		xor		edx, edx
		cmp		esi, 100
		jz		end_add
		mov		dl, byte ptr [eax+esi]
		mov		dh, byte ptr [ebx+esi]
		sub		dl, 30h
		sub		dh, 30h
		add		dl, dh
		add		dl, byte ptr [mmry]
		cmp		dl, 0Ah
		jl		low_10
		mov		byte ptr [mmry], 1
		sub		dl, 0Ah
		add		dl, 30h
		xor		dh, dh
		mov		byte ptr [ecx+esi], dl
		inc		esi
		jmp		for_add

	low_10:
		mov		byte ptr [mmry], 0
		xor		dl, 30h
		xor		dh, dh
		mov		byte ptr [ecx+esi], dl
		inc		esi
		jmp		for_add

	end_add:
		mov		byte ptr [ecx+esi], 0
		pop		ecx
		pop		ebx
		pop		eax
		pop		ebp
		ret		12
		
addnum ENDP

copy PROC
	push	ebp	
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+0Ch]			;chuoi duoc cp
	mov		ebx, [ebp+08h]			;chuoi cp
	xor		esi, esi
;	xor		edi, edi

	for_copy:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		cmp		dl, 0
		jz		done_copy
		mov		byte ptr [ebx+esi], dl
		inc		esi
		jmp		for_copy

	done_copy:
		mov		byte ptr [ebx+esi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

copy ENDP

fix_zero PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+08h]
	xor		esi, esi
	xor		edi, edi

	for_fix:
		cmp		byte ptr [eax+esi], 30h
		jne		push_fix
		inc		esi
		jmp		for_fix

	push_fix:
		xor		edx, edx
		mov		dl, byte ptr [eax+esi]
		push	edx
		cmp		esi, 100
		je		pop_fix
		inc		esi
		inc		edi
		jmp		push_fix

	pop_fix:
		pop		edx
		mov		eax, offset fn_fix
		xor		esi, esi
		tmp:
			xor		edx, edx
			cmp		esi, edi
			je		end_fix
			pop		edx
			mov		byte ptr [eax+esi], dl
			inc		esi
			jmp		tmp

	end_fix:
		mov		byte ptr [eax+esi], 0
		pop		ebx
		pop		eax
		pop		ebp
		ret		4

fix_zero ENDP

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
		jz		break_re
		mov		byte ptr [eax+edi], dl
		inc		edi
		jmp		pop_re

	break_re:
		mov		byte ptr [eax+edi], 0
		pop		eax
		pop		ebp	
		ret		4

reverse ENDP

atoi PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ebx, [ebp+08h]
	xor		esi, esi
	xor		eax, eax
	mov		edi, 10

	for_atoi:
		xor		edx, edx
		mov		dl, byte ptr [ebx+esi]
		cmp		dl, 0
		jz		break_atoi
		sub		edx, 30h
		add		eax, edx
		mul		edi
		inc		esi
		jmp		for_atoi

	break_atoi:
		mov		byte ptr [ebx+esi], 0
		div		edi
		pop		ebx
		pop		ebp
		ret		4

atoi ENDP

itoa PROC
	push	ebp
	mov		ebp, esp
	push	eax
	push	ebx
	mov		eax, [ebp+0Ch]		;number
	mov		ebx, [ebp+08h]		;string
	xor		esi, esi
	mov		edi, 10
	push	69h

	for_itoa:
		xor		edx, edx
		div		edi
		xor		edx, 30h
		push	edx
		cmp		eax, 0
		jz		pop_itoa
		jmp		for_itoa

	pop_itoa:
		xor		edx, edx
		pop		edx
		cmp		dl, 69h
		jz		break_itoa
		mov		byte ptr [ebx+esi], dl
		inc		esi
		jmp		pop_itoa
	
	break_itoa:
		mov		byte ptr [ebx+esi], 0
;		div		edi
		xor		edi, edi
		pop		ebx
		pop		eax
		pop		ebp
		ret		8

itoa ENDP
END main