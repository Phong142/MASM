.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
	mg		db	30 dup(?)			;khai bao mang mg 30 phan tu

.code
main PROC

	push	30
	push	offset mg
	call	StdIn			;nhap vao chuoi ki tu

	push	offset mg
	call	StdOut			;print chuoi vua nhap

	push	0
	call	ExitProcess		;exit

main ENDP
END main