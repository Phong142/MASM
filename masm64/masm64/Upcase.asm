extrn GetStdHandle   :PROC
extrn CreateFileA    :PROC
extrn SetFilePointer :PROC
extrn GetFileSize    :PROC
extrn ReadFile       :PROC
extrn WriteFile      :PROC
extrn GetConsoleMode :PROC
extrn SetConsoleMode :PROC
extrn ExitProcess    :PROC
extrn GetProcessHeap :PROC
extrn HeapAlloc      :PROC
extrn HeapFree       :PROC
extrn HeapDestroy    :PROC

.data?
	m		db 100 dup(?)
	nByte	dd ?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 40h

	mov     rcx, -10			; STD_INPUT_HANDLE
	call    GetStdHandle
	mov     [rbp - 8], rax		; Handle input
	mov     rcx, -11			; STD_OUTPUT_HANDLE
	call    GetStdHandle
	mov     [rbp - 10h], rax		; Handle output
	xor     r14, r14

	mov     rcx, [rbp - 8h]
    mov     rdx, offset m
    mov     r8, 100
    mov     r9, offset nByte
    mov     [rsp + 20h], r14
    call    ReadFile

	mov		rcx, offset m
	call	upcase

	mov     bx, 0A0Dh				; appended /r /n 
	mov     word ptr [rsi + rax], bx 
	add     rax, 2     
	mov		rcx, [rbp - 10h]
	mov		rdx, offset m
	mov		r8, rax
	mov		r9, offset nByte
	mov		[rsp+20h], r14
	call	WriteFile

	mov		ecx, 0
	call	ExitProcess

main ENDP

upcase PROC
	push	rbp
	mov		rbp, rsp
	mov		rsi, rcx		;offset m
	xor		rdi, rdi

	start:
		mov		dl, byte ptr [rsi+rdi]
		cmp		dl, 0Dh
		jz		break
		cmp		dl, 'a'
		jl		next
		cmp		dl, 'z'
		jg		next
		sub		dl, 20h
		mov		byte ptr [rsi+rdi], dl
		inc		rdi
		jmp		start

	next:
		inc		rdi
		jmp		start

	break:
		mov		rax, rdi
		mov		rsp, rbp
		pop		rbp
		ret		

upcase ENDP
END