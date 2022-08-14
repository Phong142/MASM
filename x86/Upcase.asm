.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
	f	db	30 dup (?)

.code
main PROC
	push	30
	push	offset f
	call	StdIn

	mov	ecx, 0					;ecx=0
	upper:
		cmp	f [ecx], 0					;cmp voi 0
		jz	finished					;dung thi nhay 
		cmp	f [ecx], 'a'				;cmp voi 'a'
		jl	nochange					;<'a' thi nhay
		cmp	f [ecx], 'z'		
		jg	nochange			
		xor	f [ecx], 20h		

		nochange:
			inc	ecx						;ecx++
			jnz	upper			

		finished: 
			push	offset f	
			call	StdOut				;in ra f

			push	0
			call	ExitProcess			;exit

main ENDP
END main