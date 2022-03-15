extrn GetStdHandle	:PROC
extrn ReadFile		:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	sNum1	db "Num1 = ", 0h
	sNum2	db "Num2 = ", 0h
	sSum	db "Sum = ", 0h

.data?
	Num1	db 30 dup(?)
	Num2	db 30 dup(?)
	Sum		db 31 dup(?)
	nByte	dd ?

.code
main PROC
	mov		rbp, rsp
	sub		rsp, 40h

	mov		rcx, -11		;Std_Output_Handle
	call	GetStdHandle
	mov		[rbp-08h], rax	;Handle_Output	
	mov		rcx, -10		;Std_Input_handle
	call	GetStdHandle
	mov		[rbp-10h], rax	;Handle_Input
	xor		r14, r14

	;print sNum1 = "Num1 = "
	;scanf Num1
	mov		rcx, [rbp-08h]
	mov		rdx, offset sNum1
	mov		r8, sizeof sNum1
	mov		r9, offset nByte
	mov		[rsp+20h], r14
	call	WriteFile
	mov		rcx, [rbp-10h]
	mov		rdx, offset Num1
	mov		r8, 30
	mov		r9, offset nByte
	mov		[rsp+20h], r14
	call	ReadFile

	;print sNum2 = "Num2 = "
	;scanf Num2
	mov		rcx, [rbp-08h]
	mov		rdx, offset sNum2
	mov		r8, sizeof sNum2
	mov		r9, offset nByte
	mov		[rsp+20h], r14
	call	WriteFile
	mov		rcx, [rbp-10h]
	mov		rdx, offset Num2
	mov		r8, 30
	mov		r9, offset nByte
	mov		[rsp+20h], r14
	call	ReadFile

	;print sSum = "Sum = "
	mov		rcx, [rbp-08h]
	mov		rdx, offset sSum
	mov		r8, sizeof sSum
	mov		r9, offset nByte
	mov		[rsp+20h], r14
	call	WriteFile

	;calc
	mov		rsi, offset Num1
	mov		rdi, offset Num2
	mov		rdx, offset Sum
	call	bigsum

	mov		rax, r15
	mov		bx, 0A0Dh					;/r /n
	mov		word ptr [rsi+rax], bx
	add		rax, 2
	mov		rcx, [rbp-08h]			;Handle_Out
	mov		rdx, rsi
	mov		r8, rax
	mov		r9, offset nByte
	mov		[rsp+20h], r14
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP

bigsum PROC	
	push	rbp
	mov		rbp, rsp
	sub		rsp, 18h
	push	rax
	push	rbx
	push	rcx
	xor		r12, r12
	mov		[rbp-18h], rdx		;offset sum
	mov		[rbp-10h], rdi		;offset num2
	mov		[rbp-08h], rsi		;offset num1
	call	reverse				;reverse num1
	mov		rax, rdi			;rax = len(num1)
	mov		rsi, [rbp-10h]
	call	reverse				;reverse num2
	mov		rbx, rdi			;rbx = len(num2)

	cmp		rax, rbx
	jl		mlen2				;len1 < len2
	jg		mlen1				;len1 > len2

	mlen1:
		mov		rsi, [rbp-10h]	;num2
		push	rbx				;len2
		push	rax				;len1
		call	insertzero
		jmp		format

	mlen2:
		mov		rsi, [rbp-08h]	;num1
		push	rax				;len1
		push	rbx				;len2
		call	insertzero
		jmp		format
	
	format:
		;xor		rax, rax
		xor		rbx, rbx
		mov		rsi, [rbp-08h]	;num1
		mov		rdi, [rbp-10h]	;num2
		mov		rdx, [rbp-18h]	;sum
		mov		r12, 0			;mem
	calc:
		xor		rax, rax
		mov		al, byte ptr [rsi+rbx]
		mov		ah, byte ptr [rdi+rbx]
		cmp		al, 0Dh
		jz		done
		sub		al, 30h
		sub		ah, 30h
		add		al, ah
		xor		ah, ah
		add		rax, r12		;add mem
		mov		r12, 0
		cmp		al, 0Ah
		jnc		highh			;al>10

	next:
		add		al, 30h
		mov		byte ptr [rdx+rbx], al
		inc		rbx
		jmp		calc
	highh:
		mov		r12, 1
		sub		al, 10
		jmp		next

	done:
		xor		rax, rax
		mov		rax, r12
		cmp		al, 0
		je		endd
		add		al, 30h
		mov		byte ptr [rdx+rbx], al
		inc		rbx
	
	endd:
		mov		byte ptr [rdx+rbx], 0Dh
		mov		r15, rbx				;len sum
		pop		rcx
		pop		rbx
		pop		rax
		mov		rsi, [rbp-18h]
		call	reverse
		mov		rsp, rbp
		pop		rbp
		ret		
		
bigsum ENDP
	
insertzero PROC
	push	rbp
	mov		rbp, rsp
	sub		rsp, 08h
	push	rax
	push	rcx
	push	rdx
	mov		[rbp-08h], rsi			;string
	mov		rcx, [rbp+10h]			;len max
	mov		rdx, [rbp+18h]			;len min
	
	insert:
		cmp		rcx, rdx
		jz		break
		mov		byte ptr [rsi+rdx], 30h
		inc		rdx
		jmp		insert

	break:
		mov		byte ptr [rsi+rdx], 0Dh
		pop		rdx
		pop		rcx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret		16

insertzero ENDP

reverse PROC
	push	rbp
	mov		rbp, rsp
	push	rax
	push	rcx
	push	rdx
	mov		rdi, rsi		;num1
	mov		rdx, rsi
	xor		rax, rax
	xor		rcx, rcx
	cld

	pushLoop:
		lodsb			;al=[rsi++]
		cmp		al, 0Dh
		jz		popLoop
		push	rax
		inc		rcx
		jmp		pushLoop

	popLoop:
		test	rcx, rcx
		jz		break
		pop		rax
		stosb			;al=[rdi++]
		dec		rcx
		jmp		popLoop

	break:
		sub		rdi, rdx			;strlen
		mov		rsi, rdx
		pop		rdx
		pop		rcx
		pop		rax
		mov		rsp, rbp
		pop		rbp
		ret		
			
reverse ENDP
END