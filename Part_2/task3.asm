section .note.GNU-stack

section .text
extern atol
extern stdout
extern putc
global my_printf

; printeaza numere
print_type_d:
	push rbp
	mov rbp, rsp

	; punem 16 biti pentru aliniere
	sub rsp, 16
	; pointer la sir de pe stiva
	mov r9, rbp
	xor rax, rax
	; pune in rax stringul
	mov rax,rdi
	; scade pentru a ajunge la pozitita r9 -1
	sub r9, 1
	; pune la pozitita r9 - 1 terminatorul
	mov byte[r9], 0

.loop_push:
	; pune in rbx 10 pentru a imparti la 10
	mov rbx, 10
	xor rdx, rdx
	; imparte rax la 10 pentru a lua caracter cu caracter
	div rbx
	; in dl se va salva restul impartirii la 10
	add dl, '0'
	; se deuce cu un byte mai jos
	sub r9, 1
	; pune un numar pe aceasta pozitie
	mov byte[r9], dl
	; vede daca a ajuns la sfarsit
	cmp rax, 0
	jz .print
	jmp .loop_push

.print:
	; putem sa l printam ca un sir
	mov rdi, r9
	call print_type_s
.end:
	leave
	ret

; printeaza siruri
print_type_s:
	push rbp
	mov rbp, rsp

	xor rcx, rcx

.loop_string:
	xor rbx, rbx
	mov bl, byte[rdi + rcx]
	; verifica daca a ajuns la sfarsitul sirului
	cmp bl, 0
	je .end

	push rcx
	push rdi

	mov rdi, rbx
	mov rsi, qword[stdout]
	call putc

	pop rdi
	pop rcx

	inc rcx
	jmp .loop_string

.end:

	leave
	ret

; printeaza caractere
print_type_c:
	push rbp
	mov rbp, rsp

	; salveaza datele pe stiva
	push rdi
	; aliniaza stiva
	sub rsp, 8
	mov rsi, qword[stdout]
	call putc

	; reintoarcere la datele salvate
	add rsp, 8
	; reastaureaza datele
	pop rdi

	leave
	ret

; primeste in rdi d , s sau c
; primeste in rsi registrul ce trebuie afisat
select_type:
	push rbp
	mov rbp, rsp

	xor rbx, rbx
	; pune in bl, s sau c
	mov rbx, rdi

	; compara sa vada daca e numar
	cmp bl, 'l'
	jne .string
	; salveaza datele pe stiva
	push rdi
	push r10

	; pune registrul de care este nevoie pentru a inlocui %d
	mov rdi, rsi
	call print_type_d

	; restaureaza datele
	pop r10
	pop rdi
	; functia intoarce 3, pentru a sti cu cat trebuie deplasat offsetul
	mov rax, 3
	jmp .end
.string:
	cmp bl, 's'
	jne .char
	; salveaza datele pe stiva
	push rdi
	push r10

	; pune registrul de care este nevoie pentru a inlocui %d
	mov rdi, rsi
	call print_type_s

	; restaureaza datele
	pop r10
	pop rdi
	; functia intoarce 2, pentru a sti cu cat trebuie deplasat offsetul
	mov rax, 2
	jmp .end
.char:
	; salveaza datele pe stiva
	push rdi
	push r10

	; pune registrul de care este nevoie pentru a inlocui %d
	mov rdi, rsi
	call print_type_c

	; restaureaza datele
	pop r10
	pop rdi
	; functia intoarce 2, pentru a sti cu cat trebuie deplasat offsetul
	mov rax, 2

.end:

	leave
	ret

my_printf:
	push rbp
	mov rbp, rsp

	xor rax, rax
	push r14
	; aliniaza stiva
	sub rsp, 8
	; pune in r14 adresa lui rbp
	mov r14, rbp
	; pointer la primul parametru de pe stiva
	add r14, 16
	; offsetul
	xor r10, r10
	; numarul de %
	xor r11, r11
.loop_string:
	xor rax, rax
	; punem un caracter in al
	mov al, byte[rdi + r10]
	; verifica daca a ajuns la sfarsit
	cmp al, 0x0
	je .end
	; compara al cu % pentru a afla cand trebuie sa inlocuim
	cmp al, '%'
	jne .put
	; pune parametrul din rsi
	cmp r11, 0
	jne .next_par1
	; salveaza datele pe stiva
	push rdi
	push r10
	push r11
	push r14
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	; aliniaza stiva
	sub rsp, 8

	xor rbx,rbx
	; pune in bl caracterul de dupa %
	mov bl, byte[rdi + r10 +1]
	mov rdi, rbx
	call select_type

	; restaureaza datele
	add rsp, 8
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop r14
	pop r11
	pop r10
	pop rdi
	; mareste numarul de %
	inc r11
	; mareste offsetul
	add r10, rax
	jmp .loop_string
.next_par1:
	; pune parametrul din rdx
	cmp r11, 1
	jne .next_par2
	; salveaza datele pe stiva
	push rdi
	push r10
	push r11
	push r14
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	; aliniaza stiva
	sub rsp, 8

	xor rbx,rbx
	; pune in bl caracterul de dupa %
	mov bl, byte[rdi + r10 +1]
	mov rdi, rbx
	mov rsi, rdx
	call select_type

	; restaureaza datele
	add rsp, 8
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop r14
	pop r11
	pop r10
	pop rdi

	; mareste numarul de %
	inc r11
	; mareste offsetul
	add r10, rax
	jmp .loop_string
.next_par2:
	; pune parametrul din rcx
	cmp r11, 2
	jne .next_par3
	; salveaza datele pe stiva
	push rdi
	push r10
	push r11
	push r14
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	; aliniaza stiva
	sub rsp, 8

	xor rbx,rbx
	; pune in bl caracterul de dupa %
	mov bl, byte[rdi + r10 +1]
	mov rdi, rbx
	mov rsi, rcx
	call select_type

	; restaureaza datele
	add rsp, 8
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop r14
	pop r11
	pop r10
	pop rdi

	;mareste numarul de %
	inc r11
	; mareste offsetul
	add r10, rax
	jmp .loop_string
.next_par3:
	; pune parametrul din r8
	cmp r11, 3
	jne .next_par4
	; salveaza datele pe stiva
	push rdi
	push r10
	push r11
	push r14
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	; aliniaza stiva
	sub rsp, 8

	xor rbx,rbx
	; pune in bl caracterul de dupa %
	mov bl, byte[rdi + r10 +1]
	mov rdi, rbx
	mov rsi, r8
	call select_type

	; restaureaza datele
	add rsp, 8
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop r14
	pop r11
	pop r10
	pop rdi

	; mareste numarul de %
	inc r11
	; mareste offsetul
	add r10, rax
	jmp .loop_string
.next_par4:
; pune parametrul din r9
	cmp r11, 4
	jne .stack
	; salveaza datele pe stiva
	push rdi
	push r10
	push r11
	push r14
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	; aliniaza stiva
	sub rsp, 8

	xor rbx,rbx
	; pune in bl caracterul de dupa %
	mov bl, byte[rdi + r10 +1]
	mov rdi, rbx
	mov rsi, r9
	call select_type

	; restaureaza datele
	add rsp, 8
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop r14
	pop r11
	pop r10
	pop rdi

	;mareste numarul de %
	inc r11
	; mareste offsetul
	add r10, rax
	jmp .loop_string
.stack:

	; salveaza datele pe stiva
	push rdi
	push r10
	push r11
	push r14
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	; aliniaza stiva
	sub rsp, 8

	xor rbx, rbx
	; pune in bl caracterul de dupa %
	mov bl, byte[rdi + r10 +1]
	mov rdi, rbx
	mov rsi, qword[r14]
	call select_type

	; restaureaza datele
	add rsp, 8
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop r14
	pop r11
	pop r10
	pop rdi

	inc r11
	add r10, rax
	; se duce la urmatorul element de pe stiva
	add r14, 8
	jmp .loop_string
.put:
	; salveaza datele
	push rdi
	push r10
	push r11
	push r14
	push rsi
	push rdx
	push rcx
	push r8
	push r9
	; aliniaza stiva
	sub rsp, 8
	mov rdi, rax
	mov rsi, qword[stdout]
	call putc

	; restaureaza datele
	add rsp, 8
	pop r9
	pop r8
	pop rcx
	pop rdx
	pop rsi
	pop r14
	pop r11
	pop r10
	pop rdi

	inc r10
	jmp .loop_string
.end:
	; restaureaza stiva
	add rsp, 8
	pop r14

	leave
	ret
