.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\kernel32.lib

.data
	msg	db	"hello", 0Ah

.code
main PROC
	push	offset msg
	call	StdOut

	push	0
	call	ExitProcess

main ENDP
END main