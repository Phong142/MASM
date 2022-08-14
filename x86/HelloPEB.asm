.386
.model flat, stdcall
option casemap: none

.data
	hello	db "Hello hiii", 0Ah, 0h

.code
main PROC
	push	ebp
	mov		ebp, esp
	sub		esp, 0Ch

	call	findkernel32
	mov		[ebp-4h], eax			;dllbase

	push	7487d823h				;getstdhandle hash value
	push	[ebp-4]
	call	findhash

	push	-11
	call	eax
	mov		[ebp-8h], eax			;std output handle

	push    0e80a791fh				;WriteFile hash value
    push    [ebp - 4]           
    call    findhash 

	push	12
	push	offset hello
	push	[ebp-8h]
	call	eax						;writefile(handle, &output, sizr output)

	push    73e2d87eh				;ExitProcess hash value
    push    [ebp - 4]
    call    findhash

	push	0
	call	eax

main ENDP

findkernel32 PROC
	push	esi
	xor		eax, eax
	assume	fs: nothing
	mov		eax, [fs:30h]			;&peb
	mov		eax, [eax+0Ch]			;&peb->ldr
	mov		esi, [eax+14h]			;&ldr.InMemoryOrderModulList
	lodsd							;calc.exe
	xchg	eax, esi
	lodsd							;ntdll.dll
	mov		eax, [eax+10h]			;kernel32.dll
	pop		esi
	ret

findkernel32 ENDP

findhash PROC
	pushad
	mov		ebp, [esp+0Ch]			;&retadd
	mov		ebx, [ebp+04h]			;kernel32
	mov		eax, [ebx+3Ch]			;pe signature
	add		eax, ebx				;rva->va
	;pe32 parsing
	mov		edx, [eax+18h+60h]		;pe offset + optionalheader +data directory
	add		edx, ebx				;&image_export_directory
	mov		ecx, [edx+18h]			;numberofname
	mov		ebx, [edx+20h]			;addressofname
	add		ebx, [ebp+04h]			;rvx->va

	@search:
		jecxz	@error				;lap qua het dll
		dec		ecx
		mov		esi, [ebx+ecx*4]	;func name
		add		esi, [ebp+4]
		push	esi
		call	hashcmp
		cmp		eax, [ebp+08h]		;finded hash cmp  hash push
		jnz		@search

		mov		ebx, [edx+24h]		;ordnal table rva
		add		ebx, [ebp+4h]
		mov		cx,	[ebx+ecx*2]		;addressofname ordinal offset
		mov		ebx, [edx+1Ch]		;address of func
		add		ebx, [ebp+4h]

		mov		eax, [ebx+ecx*4]	;func rva
		add		eax, [ebp+4h]
		jmp		@done

	@error:
		mov		eax, 0

	@done:
		mov		[esp+1Ch], eax		
		popad
		ret		8

findhash ENDP

hashcmp PROC
	push	ebp
	mov		ebp, esp
	push	esi
	push	edi
	mov		esi, [ebp+08h]			;hash value finded

	xor		edi, edi
	cld								;clear flag

	@load:
		xor		eax, eax
		lodsb
		cmp		al, ah
		jz		@done
		ror		edi, 0Dh
		add		edi, eax
		jmp		@load

	@done:
		mov		eax, edi
		pop		edi
		pop		esi
		mov		esp, ebp
		pop		ebp
		ret		4

hashcmp ENDP
findSymbol proc
    pushad
    mov     ebp, [esp + 0ch]                    ; restore esp value before pushad into ebp to create stack frame
    mov     ebx, [ebp + 4]                      ; dllBase
    mov     eax, [ebx + 3ch]                    ; PE signature offset
    add     eax, ebx                            ; rva -> va
    ; pe32 parsing
    mov     edx, [eax + 18h + 60h]              ; pe offset + OptionalHeader + data directory
    add     edx, ebx                            ; edx = &IMAGE_EXPORT_DIRECTORY
    mov     ecx, [edx + 18h]                    ; ecx = NumberOfNames
    mov     ebx, [edx + 20h]                    ; ebx = AddressOfNames
    add     ebx, [ebp + 4]                      ; rva -> va

    searching:
    jecxz   nfound                              ; iterated through all functions in dll
    dec     ecx
    mov     esi, [ebx + ecx*4]                  ; next func name
    add     esi, [ebp + 4]
    push    esi
    call    hashcmp                           ; calc function hash
    cmp     eax, [ebp + 8]                      ; compare 2 hash
    jnz     searching

    mov     ebx, [edx + 24h]                    ; ordinal table rva
    add     ebx, [ebp + 4]                      ; rva -> va
    mov     cx, [ebx + ecx*2]                   ; AddressOfNameOrdinals offset
    mov     ebx, [edx + 1ch]                    ; ebx = AddressOfFunctions
    add     ebx, [ebp + 4]                      ; rva -> va

    mov     eax, [ebx + ecx*4]                  ; function rva
    add     eax, [ebp + 4]                      ; rva -> va
    jmp     done

    nfound:
    xor     eax, eax                            ; if fails, retur 0

    done:
    mov     [esp + 1ch], eax                    ; overwrite eax stored on stack to popad
    popad
    ret     8
findSymbol endp
END main



