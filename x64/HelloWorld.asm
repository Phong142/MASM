extrn GetStdHandle	:PROC
extrn WriteFile		:PROC
extrn ExitProcess	:PROC

.data
	msg		db "Dcm kho vl", 0Ah, 0h

.data?
	nByte	dd ?

.code 
main PROC
	mov		rbp, rsp
	sub		rsp, 28h

	mov		rcx, -11			;shadow space + align
	call	GetStdHandle		;return handle rax
	xor		rbx, rbx
	mov		rcx, rax			;Std_Output_Handle
	mov		rdx, offset msg		
	mov     r8, sizeof msg		;lenght str
	mov		r9, offset nByte	;return value agrument
	mov		[rsp + 20h], rbx	
	call	WriteFile

	mov		rcx, 0
	call	ExitProcess

main ENDP
END
