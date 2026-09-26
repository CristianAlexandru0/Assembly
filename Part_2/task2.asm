section .note.GNU-stack
section .data
	; formatul pentru afisarea rezultatului final
	fmt db "%ld", 10, 0

section .bss
	; rezerva un buffer plin de zerouri in care sa citeasca
	buff resb 64

section .text

extern printf
extern stdin
extern fgets
extern atol
global reverse_polish_notation

reverse_polish_notation:
	push rbp
	mov rbp, rsp
	xor rax, rax
	xor r14, r14
	; alinieaza stiva

	; r14 arata daca trebuie aliniata stiva sau nu
	; daca e numar impar in el trebuie aliniata
	; daca este numar par este deja aliniata
	xor r14, r14
.loop_read:
	; verifica daca r14 e impar si trebuie aliniata stiva
	test r14, 0x1
	jz .aligned1
	; scade 8 bytes pentru a alinia
	sub rsp, 8
.aligned1:

	xor rax, rax
	; pune in rdi buffer-ul
	mov rdi, buff
	; pune in rsi size-ul bufferului
	mov rsi, 64
	; adresa stdin
	mov rdx, qword[stdin]
	call fgets
	; verifica daca r14 e impar si readuce stiva la pozitita anterioara
	test r14, 0x1
	jz .continue1
	; adauga la loc cei 8 bytes
	add rsp, 8
.continue1:
	; verifica daca a ajuns la sfarsitul fisierului
	cmp rax, 0x0
	je .end
	xor rbx, rbx
	mov bl, byte[buff]
.plus:
	; verifica daca e operatia +
	cmp bl, 43
	jne .minus
	; extrage cele 2 elemente
	pop r9
	pop r10

	add r9, r10

	push r9
	dec r14
	jmp .loop_read
.minus:
	; verifica daca e operatia -
	cmp bl, 45
	jne .divide
	; extrage cele 2 elemente
	pop r9
	pop r10

	sub r10, r9

	push r10
	dec r14
	jmp .loop_read
.divide:
	; verifica daca e operatia /
	cmp bl, 47
	jne .multiply
	; extrage cele 2 elemente
	pop r9
	pop rax

	xor rdx,rdx
	div r9

	push rax
	dec r14
	jmp .loop_read
.multiply:
	; verifica daca e operatia *
	cmp bl, 42
	jne .number
	; extrage cele 2 elemente
	pop r9
	pop rax

	xor rdx,rdx
	mul r9

	push rax
	dec r14
	jmp .loop_read
.number:
	; verifica daca r14 e impar si trebuie aliniata stiva
	test r14, 0x1
	jz .aligned2
	; aliniaza stiva
	sub rsp, 8
.aligned2:

	; transforma din caractere in numar
	mov rdi, buff
	call atol

	; verifica daca r14 e impar si readuce stiva la pozitita anterioara
	test r14, 0x1
	jz .continue2
	; adauga 8 bytes la stiva
	add rsp, 8
.continue2:

	push rax
	inc r14
	jmp .loop_read
.end:
	pop rax

	lea rdi, [fmt]
	mov rsi, rax
	call printf

	leave
	ret
