extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC
extrn GetProcessHeap :PROC
extrn HeapAlloc      :PROC

.data
	wsizearr	db "Nhap vao kich thuoc mang: ", 0h
	sarr		db "Nhap vao tung phan tu: ", 0h
	sodd		db "Tong so le: ", 0h
	seven		db "Tong so chan: ", 0h

.data?
	narr		db 5 dup(?)
	arrstr		db 100 dup(?)
	arr			db 100 dup(?)
	sizearr		dd ?
	oddsum		dq ?
	evensum		dq ?
	nByte		dd ?

.code 
main PROC
	mov		rbp, rsp
	sub		rsp, 40h

	mov		rcx, -10		;std_input_handle
	call	GetStdHandle
	mov		[rbp-08h], rax
	mov		rcx, -11		;std_output_handle
	call	GetStdHandle
	mov		[rbp-10h], rax

	xor		r15, r15		;r15=0

	;printf text
	;scanf so phan tu
	mov		rcx, [rbp-10h]
	mov		rdx, offset wsizearr
	mov		r8, sizeof wsizearr
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	WriteFile
	mov		rcx, [rbp-08h]
	mov		rdx, offset narr
	mov		r8, 5
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	ReadFile
	mov		rsi, offset narr
	call	atoi
	mov		sizearr, eax			;sizearr = number

	;printf text
	mov		rcx, [rbp-10h]
	mov		rdx, offset sarr
	mov		r8, sizeof sarr
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	WriteFile

	xor		rbx, rbx
	;input arr
	input:
		mov		rcx, [rbp-08h]
		mov		rdx, offset arrstr
		mov		r8, 100
		mov		r9, offset nByte
		mov		[rsp+20h], r15
		call	ReadFile
		mov		rsi, offset arrstr			;rsi = arr[n]
		mov		r12, offset arr
	
	xlstr:
		push	rsi
		call	atoi
		mov		dword ptr [r12+rbx*4], eax
		inc		ebx							;inc de cmp so phan tu mang
		cmp		[sizearr], ebx
		jz		donearr
		pop		rsi

	looparr:
		cmp		byte ptr [rsi], 0Ah
		jz		input
		inc		rsi
		cmp		byte ptr [rsi-1], 20h
		jz		xlstr
		jmp		looparr

	donearr:
		mov		rdi, offset arr
		mov		esi, sizearr
		call	calculator
	
	;printf oddsum
	mov		rcx, [rbp-10h]
	mov		rdx, offset sodd
	mov		r8, sizeof sodd
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	WriteFile
	mov		rsi, oddsum
	call	itoa
	mov		bx, 0A0Dh
	mov		word ptr [rsi+rax], bx
	add		rax, 2
	mov		rcx, [rbp-10h]
	mov		rdx, rsi				;offset number
	mov		r8, rax
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	WriteFile

	;printf even
	mov		rcx, [rbp-10h]
	mov		rdx, offset seven
	mov		r8, sizeof seven
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	WriteFile
	mov		rsi, evensum
	call	itoa
	mov		word ptr [rsi+rax], bx
	add		rax, 2
	mov		rcx, [rbp-10h]
	mov		rdx, rsi				;offset number
	mov		r8, rax
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP

calculator PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rbx
	push	rdx
	xor		rax, rax
	xor		rbx, rbx
	xor		rdx, rdx
	;rsi = arr [n] phan tu
	ceven:
		mov		edx, dword ptr [rdi]
		test	edx, 1
		jnz		calceven
		add		rbx, rdx			;even
		jmp		check

	calceven:
		add		rax, rdx			;odd

	check:
		add		rdi, 4
		dec		esi
		cmp		esi, 0
		jz		break
		jmp		ceven

	break:
		mov		oddsum, rax
		mov		evensum, rbx
		pop		rdx
		pop		rbx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret

calculator ENDP

atoi PROC
	push	rbp
	mov		rbp, rsp
	push	rbx
	push	rdx
	xor		rax, rax
	mov		rbx, 10

	;rsi = offset str
	mulL:
		xor		rdx, rdx
		mov		dl, byte ptr [rsi]
		cmp		dl, 30h
		jl		break
		cmp		dl, 39h
		jg		break
		sub		dl, 30h
		add		eax, edx		;rax = number
		mul		rbx
		inc		rsi
		jmp		mulL

	break:
		xor		rdx, rdx
		div		rbx
		pop		rdx
		pop		rbx
		mov		rsp, rbp
		pop		rbp
		ret
				
atoi ENDP

itoa proc   ;long long int to ascii, rsi = n, return rax = len(n), rsi=&n
    push    rbp
    mov	    rbp, rsp
    push    rbx
    push    rdx
    xor	    rbx, rbx
    mov	    rbx, rsi
    
    sub	    rsp, 20h			; shadow space 
    call    GetProcessHeap		; get handle heap
    mov     rcx, rax			; rcx = handle heap
    mov     rdx, 0
    mov     r8, 21			; size allocate
    call    HeapAlloc			; HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, 10) 
    add     rsp, 20h			; Remove shadow space
    mov     rdi, rax            
    add     rdi, 20			; rdi = *(str + 20)

    mov	    rax, rbx
    mov	    rsi, rdi
    mov	    rbx, 10		

    div_Loop:
    xor	    rdx, rdx
    div	    rbx				; edx = n % 10
    or	    dl, 30h			; dl += 48
    mov	    byte ptr [rdi], dl					
    dec	    di
    test    rax, rax
    jz	    done_Div
    jmp	    div_Loop

    done_Div:
    sub	    rsi, rdi
    mov	    rax, rsi					; rax = n.length
    mov	    rsi, rdi
    inc	    rsi
    pop	    rbx
    pop	    rdx
    leave
    ret
itoa endp
end

