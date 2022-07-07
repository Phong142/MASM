.data
	hello	db "Hello hiii", 0Ah, 0h

.data?
	nbyte	db 1 dup(?)
	string	db 100 dup(?)
.code
main PROC
	push	rbp
	mov		rbp, rsp
	sub		rsp, 48h

	call	findkernel32
	mov		[rbp-08h], rax			;kernel32

	mov		rdx, 7487d823h
	mov		rcx, [rbp-08h]
	call	findhash
	mov		[rbp-10h], rax			;get handle
;
	;mov		ecx, -10
	;call	rax
	;mov		[rbp-18h], rax			;handle input
	;mov		rax, [rbp-10h]
	mov		ecx, -11
	call	rax
	mov		[rbp-10h], rax			;handle output
;
	;mov		rdx, 10fa6516h			;readfile
	;mov		rcx, [rbp-08h]
	;call	findhash
	;mov		rcx, [rbp-18h]
	;mov		rdx, offset string
	;mov		r8, 50
	;mov		r9, offset nbyte
	;call	rax

	mov     rdx, 0e80a791fh			;WriteFile
	mov		rcx, [rbp-08h]
	call	findhash
	mov		rcx, [rbp-10h]
	mov		rdx, offset hello
	mov		r8, 50
	mov		r9, offset nbyte
	call	rax

	mov     rdx, 73e2d87eh			;ExitProcess
    mov     rcx, [rbp - 8]
    call    findhash
    mov     rcx, 0
    call    rax 


main ENDP

findkernel32 PROC
	push	rsi
	xor		rax, rax
	mov		rax, gs:[rax+60h]			;&peb
	mov		rax, [rax+18h]			;&ldr
	mov		rsi, [rax+20h]			;ldr.inmemoryordermodulelist.flink
	lodsq							
	xchg	rax, rsi
	lodsq
	mov		rax, [rax+20h]			;3rd module kernel
	pop		rsi
	ret

findkernel32 ENDP

findhash PROC
	push	rbp
	mov		rbp, rsp
	push	rbx
	push	rsi
	sub		rsp, 10h
	mov		[rbp-10h], rdx			;hash value
	mov		[rbp-08h], rcx			;kernel32 base
	xor		rdx, rdx
	xor		rax, rax
	xor		rcx, rcx
	mov		rbx, [rbp-08h]
	mov		eax, [rbx+3Ch]			;pe signature
	add		rax, rbx
	;pe64 parsing
	mov		edx, [rax+88h]			;pe offset + optionalheader + data directory
	add		rdx, [rbp-08h]			;&image export directory
	mov		ecx, [rdx+18h]			;numberofname
	mov		ebx, [rdx+20h]			;addressofname
	add		rbx, [rbp-08h]			;rvx->va

	@search:
		jecxz	@error
		dec		rcx
		mov		esi, [rbx+rcx*4]	;next func
		add		rsi, [rbp-08h]
		push	rcx
		mov		rcx, rsi
		call	hashcmp				;cmp hash
		pop		rcx
		cmp		eax, [rbp-10h]
		jnz		@search

		mov		ebx, [rdx+24h]		;ordinal table
		add		rbx, [rbp-08h]
		mov		cx, [rbx+rcx*2]		;addressofname ordinal offset
		mov		ebx, [rdx+1Ch]		;addressoffunc
		add		rbx, [rbp-08h]
		mov		eax, [rbx+rcx*4]	;func rva
		add		rax, [rbp-08h]		;rvx->va
		jmp		@done

	@error:
		mov		rax, 0

	@done:
		pop		rsi
		pop		rbx
		mov		rsp, rbp
		pop		rbp
		ret

findhash ENDP

hashcmp PROC
	push	rbp
	mov		rbp, rsp
	push	rsi
	push	rdi
	mov		rsi, rcx

	xor		rdi, rdi
	cld
	@div:
		xor		rax, rax
		lodsb
		cmp		al, ah
		jz		@done
		ror		edi, 0Dh
		add		edi, eax
		jmp		@div

	@done:
		mov		eax, edi
		pop		rdi
		pop		rsi
		mov		rsp, rbp
		pop		rbp
		ret		
hashcmp ENDP
end