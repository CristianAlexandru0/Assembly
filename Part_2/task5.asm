section .note.GNU-stack
section .data
	; format pentru numere heavy
	fmt_heavy db "The number is heavy", 10, 0
	; format pentru numere ce nu sunt heavy
	fmt_no_heavy db "The number is not heavy", 10, 0
	;format pentru printarea elementului maxim de pe o coloana
	fmt_matrix db "%lu", 10, 0
section .text

extern printf
global ave
global switch_cases
global heavy
global flat_matrix

ave:
	push rbp
	mov rbp, rsp
	xor rax, rax

	xor r8,r8
	xor rax,rax
	;salveaza n in r9
	mov r9, rdx
.loop_formula:
	xor rax, rax
	; pune caracterul in al
	mov al, byte[rdi + r8]
	; daca este 0 s a terminat sirul
	cmp al, 0
	jz .end
	; scade din caracter 'A'
	sub rax, 'A'
	add rax, r9
	; scade 31 pana rax este mai mic ca 31
.loop_mod:
	; compara rax cu 31
	cmp rax, 31
	jl .end_mod
	; scade 31
	sub rax, 31
	jmp .loop_mod
.end_mod:
	add rax, 'A'
	; pune in destinatie noile caractere
	mov byte[rsi + r8], al
	inc r8
	jmp .loop_formula

.end:
	; pune pe ultimul caracter terminatorul de sir
	mov byte[rsi + r8], 0

	leave
	ret

switch_cases:
	push rbp
	mov rbp, rsp

	xor r8,r8
.loop_switch_case:
	xor rax,rax
	; pune in al caractere din sir
	mov al, byte[rdi + r8]
	; verifica daca a ajuns la sfarsitul sirului
	cmp al, 0
	jz .end
.bigger_a:
	; compara cu a
	cmp al, 'a'
	jl .bigger_A
.lower_z:
	; compara cu z
	cmp al, 'z'
	jg .bigger_A
	; transforma litera mica in litera mare
	sub rax, 32
	; pune in destinatie noul caracter
	mov byte[rsi + r8], al 
	inc r8
	jmp .loop_switch_case
.bigger_A:
	; compara cu A
	cmp al, 'A'
	jl .no_letter
.lower_Z:
	; compara cu Z
	cmp al, 'Z'
	jg	.no_letter
	; transforma litera marein litera mica
	add rax, 32
	; pune in destinatie noul caracter
	mov byte[rsi + r8], al
	inc r8
	jmp .loop_switch_case
.no_letter:
	; nu este litera, nu face nici o modificare
	mov byte[rsi + r8], al
	inc r8
	jmp .loop_switch_case
.end:
	; pune pe ultimul caracter terminatorul de sir
	mov byte[rsi + r8], 0

	leave
	ret

heavy:
	push rbp
	mov rbp, rsp
	xor rax, rax
	xor rbx,rbx
	; pune masca pentru a extrage ulitmul 
	mov ebx, 0x80000000
	; face operatia de and
	and rbx, rdi
	; daca msb este 0 inseamna ca bitul nu este setat
	cmp rbx, 0
	jz .not_heavy

	xor rbx, rbx
	xor rdx, rdx
	; masca pentru byte 3
	mov rbx, 0x00FF0000
	; masca pentru byte 4
	mov rdx, 0xFF000000
	; aplica masca pentru byte 3
	and rbx, rdi
	; aplica masca pentru byte 4
	and rdx, rdi

	; shifteaza la dreapta rbx si il pune pe a doua pozitie de la dreapta pentru a reprezenta numarul zecilor
	shr rbx, 8
	; sfifteaza la dreapta rdx si il pune pe ultima pozitie de la dreapta pentru a reprezenta numarul unitatilor
	shr rdx, 24
	; combina cele 2 numere
	or rbx, rdx
	; compara cu 255
	cmp rbx, 255
	jle .not_heavy

	; pune formatul pentru numar heavy
	lea rdi, [fmt_heavy]
	call printf
	jmp .end
.not_heavy:
	; pune formatul pentru numar not heavy
	lea rdi, [fmt_no_heavy]
	call printf
.end:
	leave
	ret

flat_matrix:
	push rbp
	mov rbp, rsp

	; face cate un loop pentru fiecare coloana
	xor r8, r8
.loop_cols:
	cmp r8, rsi
	jz .end
	xor rcx, rcx
	; initializeaza maximul in rcx
	mov rcx, -1
	xor r9,r9
.loop_search_max:
	cmp r9, rsi
	jz .print_max
	xor rdx, rdx
	xor rax, rax
	xor rbx, rbx
	; pune indicele r9 (i) in rax
	mov rax, r9
	; inmulteste rax (i) cu rsi (n)
	mul rsi
	; adauga r8 (j)
	add rax, r8
	; pune numerele de pe coloana respectiva
	mov ebx, dword[rdi + rax * 4]
	; compara cu maximul actual
	cmp rbx, rcx
	jle .continue
	; actualizeaza maximul
	mov rcx, rbx
.continue:
	inc r9
	jmp .loop_search_max
.print_max:
	push r8
	push rdi
	push rsi
	;aliniaza stiva
	sub rsp, 8

	mov rdi, fmt_matrix
	mov rsi, rcx
	call printf

	; restaureaza datele
	add rsp, 8
	pop rsi
	pop rdi
	pop r8
	inc r8
	jmp .loop_cols

.end:
	leave
	ret
