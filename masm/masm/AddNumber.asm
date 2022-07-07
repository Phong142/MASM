.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
	s1	db 10 dup(?)
	s2	db 10 dup(?)
	s3	db 10 dup(?)
	sum	dd 0
.code
atoi PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		ebx, [ebp+08h]
	xor		esi, esi								;esi=0
	xor		eax, eax
	mov		ecx, 10

	for_mul:
		xor		edx, edx
		mov		dl, byte ptr [ebx+esi]				;mov 1 byte ebx vao edx(dl)
		cmp		dl, 0								;cmp dl voi 0
		jz		break
		sub 	edx, 30h							;edx-48
		add		eax, edx							;cong vao eax
		mul		ecx									;mul eax voi 10
		inc		esi									;esi++
		jmp		for_mul

	break:
		div		ecx
		pop		ebx
		pop		ebp
		ret		4

atoi ENDP

itoa PROC
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    mov     eax, [ebp + 0Ch]						;gia tri so
    mov     ebx, [ebp + 08h]						;gia tri chuoi moi
    xor     esi, esi 
    mov     ecx, 10
    push    69h										;ki tu khac so

    div_Loop:
        xor     edx, edx
        div     ecx									;eax chia 10, mac dinh lay eax div hoac mul
        or      edx, 30h							;edx+48
        push    edx									;push len stack, mac dinh edx se lay so du		
        cmp     eax, 0								;eax=0
        jz      pop_itoa
        jmp     div_Loop

    pop_itoa:
        pop     edx
        cmp     dl, 69h								;edx ma khac so
        jz      break_itoa							;pop
        mov     byte ptr [ebx + esi], dl			;chuyen tung byte vao chuoi moi
        inc     esi
        jmp     pop_itoa

    break_itoa:
        mov     byte ptr [ebx + esi], 0
        pop     eax
        pop     ebx
        pop     ebp
        ret     8
itoa ENDP

main PROC
	push	10
	push	offset s1
	call	StdIn

	push	10
	push	offset s2
	call	StdIn

	push	offset s1	
	call	atoi  		
	add		sum, eax

	push	offset s2
	call	atoi
	add		sum, eax

	push	sum
	push	offset s3
	call	itoa
	push	offset s3
	call	StdOut

	push	0
	call	ExitProcess

main ENDP
END main
