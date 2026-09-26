section .text

;; DO NOT MODIFY
global check_column
global check_row
global check_box

; int check_row(int **array, int size, int rowNr)
; rdi = int **array
; rsi = int size
; rdx = int rowNr
check_row:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	; pune in rbx adresa coloanei respective
	mov rbx, [rdi + rdx * 8]
	xor r9, r9
	xor rcx, rcx
	; pune unu in rax pentru a calcula produsul tuturor elementelor de pe linia respectiva
	mov rax, 1
.loop_verify_row:
	cmp r9, rsi
	jz .done
	xor rdx, rdx
	; punem in edx elementul de pe linia si coloana respectiva
	mov edx, dword[rbx + r9 * 4]
	add ecx, edx
	mul rdx
	inc r9
	jmp .loop_verify_row

.done:
	; daca sizeul este 4, factorialul este 4! si va fi stocat in r15
	cmp rsi, 4
	jnz .factorial_9
	; 4!
	mov r15, 24
	jmp .end1
.factorial_9:
	; daca sizeul este 9, factorialul este 9! si va fi stocat in r15
	cmp rsi, 9
	jnz .factorial_16
	; 9!
	mov r15, 362880
	jmp .end1
.factorial_16:
	; daca sizeul este 16, factorialul este 16! si va fi stocat in r15
	; a ajuns pe ultimul caz, deci automat este 16 factorial
	mov r15, 20922789888000
.end1:
	cmp rax, r15
	jnz .not_factorial
	; a trecut de verificarea factoriala
	mov rax, 1
	jmp .ver_sum
.not_factorial:
	xor rax,rax
	jmp .end2
.ver_sum:
	; calculeaza suma lui gauss pentru size
	mov rax, rsi
	mov rdx, rax
	inc rdx
	mul rdx
	; imparte la 2 prin shiftarea de biti la dreapta cu 1
	shr rax, 1
	cmp rax, rcx
	jnz .not_equal
	; a trecut si de verificarea sumei
	mov rax, 1
	jmp .end2
.not_equal:
	xor rax,rax
.end2:

	;; Your code ends here
	;; DO NOT MODIFY
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
	;; DO NOT MODIFY

;; DO NOT MODIFY
; int check_column(int **array, int size, int columnNr)
; rdi = int **array
; rsi = int size
; rdx = int columnNr
check_column:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here

	xor r9, r9
	xor rcx, rcx
	; punem unu in rax pentru a calcula produsul tuturor elementelor de pe coloana respectiva
	mov rax, 1
	mov r14, rdx
.loop_verify_collumn:
	cmp r9, rsi
	jz .done
	; pune in rbx edresa liniilor, pentru a lua elementele de pe coloana fixata
	mov rbx, [rdi + r9 * 8]
	xor rdx, rdx
	; pune in edx elementul de pe linia si coloana respectiva
	mov edx, dword[rbx + r14 * 4]
	add ecx, edx
	mul rdx
	inc r9
	jmp .loop_verify_collumn

.done:
	; daca sizeul este 4, factorialul este 4! si va fi stocat in r15
	cmp rsi, 4
	jnz .factorial_9
	; 4!
	mov r15, 24
	jmp .end1
.factorial_9:
	; daca sizeul este 9, factorialul este 9! si va fi stocat in r15
	cmp rsi, 9
	jnz .factorial_16
	; 9!
	mov r15, 362880
	jmp .end1
.factorial_16:
	; daca sizeul este 16, factorialul este 16! si va fi stocat in r15
	; a ajuns pe ultimul caz, deci automat este 16 factorial
	; 16!
	mov r15, 20922789888000
.end1:
	cmp rax, r15
	jnz .not_factorial
	; a trecut de verificarea factoriala
	mov rax, 1
	jmp .ver_sum
.not_factorial:
	xor rax,rax
	jmp .end2
.ver_sum:
	mov rax, rsi
	mov rdx, rax
	inc rdx
	mul rdx
	; imparte suma la 2
	shr rax, 1
	cmp rax, rcx
	jnz .not_equal
	; a trecut si de verificarea sumelor
	mov rax, 1
	jmp .end2
.not_equal:
	xor rax,rax
.end2:
	;; Your code ends here
	;; DO NOT MODIFY
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
	;; DO NOT MODIFY

;; DO NOT MODIFY
; int check_box(int **array, int size, int boxNr)
; rdi = int **array
; rsi = int size
; rdx = int boxNr
check_box:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	xor rcx,rcx
	; verifica daca sizeul este 4 (dorim sa aflam radical din size si factorial de size)
	cmp rsi, 4
	jnz .cmp_9
	;radical 4
	mov eax, 2
	; 24!
	mov r15, 24
	jmp .done_cmp
.cmp_9:
	; verifica daca sizeul este 9
	cmp rsi, 9
	jnz .cmp_16
	;radical 9
	mov eax, 3
	; 9!
	mov r15, 362880
	jmp .done_cmp
.cmp_16:
	;radical 16
	mov eax, 4
	; 16!
	mov r15, 20922789888000
.done_cmp:
	; pentru a afla indicele liniei de start trebuie sa calculeze catul impartirii numarului casetei dorite
	; la radical din size, iar apoi inmultit cu radical din size
	mov rcx, rax
	mov rax, rdx
	xor rdx,rdx
	div rcx

	; pentru a salva restul , se va adauga rdx pe stiva
	sub rsp, 8
	mov qword[rsp], rdx

	mul rcx
	; indicele liniei de start
	mov r9, rax

	; pentru a afla indicele coloanei de start trebuie sa calculeze restul impartirii numarului casetei dorite
	; la radical din size, iar apoi inmultit cu radical din size
	; extrage catul de pe stiva
	mov rdx, qword[rsp]
	; realiniaza stiva
	add rsp, 8

	mov rax, rdx
	mul rcx
	; indicele coloanei de start
	mov r10, rax

	; este linia maxima pe care se poate duce
	mov r11, r9
	add r11, rcx
	; este coloana maxima pe care se poate duce
	mov r12, r10
	add r12, rcx

	xor rcx, rcx
	;  punem unu in rax pentru a calcula produsul tuturor elementelor din patratul respectiv
	mov rax, 1
	; salveaza in inceputul iteratiei a doua
	mov r13, r10
.loop_line:
	cmp r9,r11
	je .done2
	; se salveaza in rbx adresa liniei ce va fi parcursa
	mov rbx, [rdi + r9 * 8]
	mov r10, r13
.loop_col:
	cmp r10, r12
	je .done1
	xor rdx, rdx
	; pune in edx elementul de pe linia si coloana respectiva
	mov edx, dword [rbx + r10 * 4]
	add ecx, edx
	mul rdx
	inc r10
	jmp .loop_col
.done1:
	inc r9
	jmp .loop_line

.done2:

	cmp rax, r15
	jnz .not_factorial
	; a trecut de verificarea factoriala
	mov rax, 1
	jmp .ver_sum
.not_factorial:
	xor rax,rax
	jmp .end
.ver_sum:
	; calculeaza suma lui gauss pentru size
	mov rax, rsi
	mov rdx, rax
	inc rdx
	mul rdx
	; imparte suma la 2
	shr rax, 1
	cmp rax, rcx
	jnz .not_equal
	; a trecut de verificarea sumei
	mov rax, 1
	jmp .end
.not_equal:
	xor rax,rax
.end:
	;; Your code ends here
	;; DO NOT MODIFY
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
