extrn GetStdHandle		:PROC
extrn ReadFile			:PROC
extrn WriteFile			:PROC
extrn GetProcessHeap	:PROC
extrn HeapAlloc			:PROC
extrn ExitProcess		:PROC

.data
	mode	db "Chon 1 trong cac mode duoi day: ", 0Ah, "1. Cong", 0Ah, "2. Tru", 0Ah, "3. Nhan", 0Ah, "4. Chia", 0Ah, "5. Thoat", 0Ah, 0h
	scmode	db "Nhap so de chon mode: ", 0h
	snum1	db "Num1 = ", 0h
	snum2	db "Num2 = ", 0h
	kq		db "Ket qua = ", 0h

.data?
	n		dq 5 dup(?)
	num1	db 100 dup(?)
	num2	db 100 dup(?)
	nByte	dd ?
	res		dq ?
	remain	dq ?
	negt	dd ?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 40h

	mov		rcx, -10			;handle_input
	call	GetStdHandle
	mov		[rbp-08h], rax		;[rbp-08h] = handle_input
	mov		rcx, -11			;handle_output
	call	GetStdHandle		
	mov		[rbp-10h], rax		;[rbp-10h] = handle_output

	xor		r15, r15

	;printf text mode
	mov		rcx, [rbp-10h]
	mov		rdx, offset mode
	mov		r8, sizeof mode
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	WriteFile

	;scanf mode
	modee:
		mov		rcx, [rbp-10h]
		mov		rdx, offset scmode
		mov		r8, sizeof scmode
		mov		r9, offset nByte
		mov		[rsp+20h], r15
		call	WriteFile
		mov		rcx, [rbp-08h]
		mov		rdx, offset n
		mov		r8, 5
		mov		r9, offset nByte
		mov		[rsp+20h], r15
		call	ReadFile	

	mov		rdx, n
	cmp		dl, '5'
	jz		exit

	;printf text num1
	;scanf num1
	mov		rcx, [rbp-10h]
	mov		rdx, offset snum1
	mov		r8, sizeof snum1
	mov		r9, offset nByte
	mov		[rbp+20h], r15
	call	WriteFile
	mov		rcx, [rbp-08h]
	mov		rdx, offset num1
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	ReadFile

	;printf text num2
	;scanf num2
	mov		rcx, [rbp-10h]
	mov		rdx, offset snum2
	mov		r8, sizeof snum2
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	WriteFile
	mov		rcx, [rbp-08h]
	mov		rdx, offset num2
	mov		r8, 100
	mov		r9, offset nByte
	mov		[rsp+20h], r15
	call	ReadFile

	mov		rsi, offset num1
	call	atoi
	mov		r12, rax			;num1
	mov		rsi, offset num2
	call	atoi
	mov		r13, rax			;num2

	mov		rdx, n
	cmp		dl, '1'				;cong
	je		cong
	cmp		dl, '2'				;tru
	je		tru
	cmp		dl, '3'				;nhan
	je		nhan
	cmp		dl, '4'				;chia
	je		chia

	cong:
		mov		dword ptr [n], ' + '
		add		r12, r13
		mov		res, r12
		jmp		printres

	tru:
		mov		dword ptr [n], ' - '
		cmp		r12, r13
		jl		insertneg
		sub		r12, r13
		mov		res, r12
		jmp		printres

	nhan:
		mov		dword ptr [n], ' x '
		mov		rax, r12
		mul		r13
		mov		res, rax
		jmp		printres

	chia:
		xor		rdx, rdx
		mov		dword ptr [n], ' / '
		mov		rax, r12
		div		r13
		mov		res, rax
		mov		remain, rdx
		jmp		printres

	insertneg:
		mov		negt, 1
		sub		r13, r12
		mov		res, r13
		jmp		printres

	printres:
		;printf snum1
		mov		rcx, [rbp-10h]
		mov		rdx, offset num1
		call	rmnewline
		mov		r8, rax
		mov		r9, offset nByte
		mov		[rbp+20h], r15
		call	WriteFile
		;print phep tinh
		mov		rcx, [rbp-10h]
		mov		rdx, offset n
		mov		r8, sizeof n
		mov		r9, offset nByte
		mov		[rsp+20h], r15
		call	WriteFile
		;printf snum2
		mov		rcx, [rbp-10h]
		mov		rdx, offset num2
		call	rmnewline
		mov		r8, rax
		mov		r9, offset nByte
		mov		[rbp+20h], r15
		call	WriteFile
		; n: ' = '
		mov		dword ptr [n], ' = '
		mov		rcx, [rbp-10h]
		mov		rdx, offset n
		mov		r8, sizeof n
		mov		r9, offset nByte
		mov		[rbp+20h], r15
		call	WriteFile
		;printf res
		mov		rsi, res
		call	itoa
		cmp		negt, 1
		jz		insertneg2
		mov		word ptr [rsi+rax], 0A0Dh
		add		rax, 2
		mov		rcx, [rbp-10h]
		mov		rdx, rsi
		mov		r8, rax
		mov		r9, offset nByte
		mov		[rsp+20h], r15
		call	WriteFile
		mov		rdi, remain
		cmp		rdi, 0
		jnz		printremain
		jmp		modee

	insertneg2:
		dec		rsi
		mov		byte ptr [rsi], '-'
		inc		rax
		mov		word ptr [rsi+rax], 0A0Dh
		add		rax, 2
		mov		rcx, [rbp-10h]
		mov		rdx, rsi
		mov		r8, rax
		mov		r9, offset nByte
		mov		[rsp+20h], r15
		call	WriteFile
		mov		negt, 0
		jmp		modee

	printremain:
		mov		rsi, remain
		call	itoa
		mov		word ptr [rsi+rax], 0A0Dh
		add		rax, 2
		mov		rcx, [rbp-10h]
		mov		rdx, rsi
		mov		r8, rax
		mov		r9, offset nByte
		mov		[rsp+20h], r15
		call	WriteFile
		mov		remain, 0
		jmp		modee
		
	exit:
		mov		rcx, 0
		call	ExitProcess
main ENDP

rmnewline PROC			;rdx=offset str
	push	rbp
	mov		rbp, rsp		
	push	rbx
	push	rdi
	mov		rdi, rdx	;rdi = offset str
	xor		rax, rax

	nextchar:
		xor		rbx, rbx
		mov		bl, byte ptr [rdi]
		cmp		bl, 0Dh
		jz		break
		inc		rdi
		jmp		nextchar

	break:
		sub		rdi, rdx
		mov		rax, rdi		;rax=len
		pop		rdi
		pop		rbx
		mov		rsp, rbp
		pop		rbp
		ret

rmnewline ENDP

atoi PROC		;rsi = str, eax = number
	push	rbp
	mov		rbp, rsp
	push	rbx
	push	rdx
	xor		rax, rax
	mov		rbx, 10

	mulL:
		xor		rdx, rdx
		mov		dl, byte ptr [rsi]
		cmp		dl, 30h
		jl		break
		cmp		dl, 39h
		jg		break
		sub		dl, 30h
		add		rax, rdx
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

itoa PROC		;rsi = number
	push	rbp
	mov		rbp, rsp
	push	rbx
	push	rdx
	mov		rbx, rsi

	sub		rsp, 20h			;shadow space
	call	GetProcessHeap		;handle
	mov		rcx, rax			;rac = handle
	mov		rdx, 8				;0x8: khoi tao arr = 0
	mov		r8, 20				;kich thuoc arr
	call	HeapAlloc
	add		rsp, 20				;return shadow space
	mov		rdi, rax			;mov arr vao rdi
	add		rdi, 20				;rdi = *(str+20)

	mov		rax, rbx			;rax = number
	mov		rsi, rdi			;rsi = *arr
	mov		rbx, 10

	divL:
		xor		rdx, rdx
		div		rbx
		add		dl, 30h
		mov		byte ptr [rdi], dl
		dec		rdi
		cmp		rax, 0
		jz		break
		jmp		divL
	
	break:	
		sub		rsi, rdi		;len str
		mov		rax, rsi		;rax = len str
		mov		rsi, rdi		;rsi = offset str
		inc		rsi
		pop		rdx
		pop		rbx
		mov		rsp, rbp
		pop		rbp
		ret

itoa ENDP
end			