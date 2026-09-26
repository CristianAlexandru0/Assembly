section .note.GNU-stack

section .data
	; formatul pt eroare 1
	fmt_error db "Error: len <= %d", 10, 0
	; formatul pt eroare 2
	fmt_error2 db "The vector is empty", 10, 0
	; formatul pt inceputul afisarii
	fmt_s db "v -> {(", 0
	; formatul pentru sfarsitul afisarii
	fmt_e db "), %d, %d}", 10, 0
	; formatul pentru afisarea unui element
	fmt_val db "[%d]", 0
	; formatul pentru afisarea unui element gol
	fmt_gol db "[]", 0

struc vector
	arr: resq 1
	len: resd 1
	cap: resd 1
endstruc

section .text


global new_vector
global set_element
global get_element
global push_element
global pop_element
global print_vector
global free_vector

extern malloc
extern realloc
extern free
extern printf



new_vector:
	push rbp
	mov rbp, rsp
	xor rax, rax

	push rdi
	; aliniaza stiva
	sub rsp, 8
	mov rdi, vector_size
	call malloc
	; restaureaza stiva
	add rsp, 8
	pop rdi
	; salveaza adresa structurii
	push rax
	; salveaza capacitatea initiala a  vectorului
	push rdi
	; pune cap * sizeof(int)
	shl rdi, 2
	call malloc
	; restaureaza capacitatea
	pop rcx
	; adresa structurii
	pop rdx
	mov qword[rdx + arr], rax
	mov dword[rdx + len], 0x0
	mov dword[rdx + cap], ecx
	mov rax, rdx

	leave
	ret

set_element:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; pune adresa vectorului in rax
	mov rax, qword[rdi + arr]
	; compara pozitia cu lungimea vectorului
	cmp edx, dword[rdi + len]
	jb .ok
	; pune in rax -1 pentru ca functia sa returneze -1
	mov rax, -1
	; salveaza datele pe stiva
	push rax
	push rdi

	; printeaza eroarea
	lea rdi, [fmt_error]
	mov rsi, rdx
	xor rax, rax
	call printf

	; restaureaza datele
	pop rdi
	pop rax
	jmp .end
.ok:
	; pune la pozitita data elementul dorit
	mov dword[rax + rdx * 4], esi 
	mov rax, rdx
.end:
	leave
	ret

get_element:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; pune adresa vectorului in rax
	mov rax, qword[rdi + arr]
	; compara pozitia cu lungimea vectorului
	cmp esi, dword[rdi + len]
	jb .ok
	; pune in rax -1 pentru ca functia sa returneze -1
	mov rax, -1

	; salveaza datele pe stiva
	push rax
	push rdi

	; printeaza eroarea
	lea rdi, [fmt_error]
	xor rax, rax
	call printf

	; restauram valorile
	pop rdi
	pop rax

	jmp .end
.ok:
	; pune in eax elementul de la pozitia data
	mov eax, dword[rax + rsi * 4]
.end:
	leave
	ret

push_element:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; pune adresa vectorului in rax
	mov rax, qword[rdi + arr]
	xor rbx, rbx
	; pune in ebx lungimea vectorului
	mov ebx, dword[rdi + len]
	; compara lungimea cu capacitatea
	cmp ebx, dword[rdi + cap]
	jb .ok
	; pune in rdx capacitatea vectorului
	xor rdx, rdx
	mov edx, dword[rdi + cap]
	; pune pe stiva adresa structurii
	push rdi
	; pune pe stiva elementul
	push rsi
	; pune in rdi adresa vectorului
	mov rdi, rax
	; calculeaza offsetul inmultind capacitatea cu 2
	shl rdx, 1
	; inmulteste capacitatea cu sizeof(int) pentru realloc
	shl rdx, 2
	; punem in rsi noua marime
	mov rsi, rdx
	call realloc
	pop rsi
	pop rdi
	xor rdx, rdx
	; pune in edx capacitatea veche
	mov edx, dword[rdi + cap]
	; inmulteste rdx cu 2 pentru a dubla capacitatea
	shl rdx, 1
	; pune adresa vectorului in structura
	mov qword[rdi + arr], rax
	; pune noua capacitate in structura
	mov dword[rdi + cap], edx
.ok:
	; pune cate elemente sunt in vector in ebx
	mov ebx, dword[rdi + len]
	; calculeaza offsetul inmultind lungimea vectorului cu sizeof(int)
	shl rbx, 2
	; pune elementul la adresa calculata
	mov dword[rax + rbx], esi
	xor rax, rax
	; pune pozitia in eax
	mov eax, dword[rdi + len]
	; mareste lungimea cu 1
	add dword[rdi + len], 1

	leave
	ret

pop_element:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; punem in ebx lungimea vectorului
	mov ebx, dword[rdi + len]
	cmp ebx, 0x0
	ja .elements
.no_elements:
	; pune in rax -1 pentru ca functia sa returneze -1
	mov rax, -1
	; salveaza datele
	push rax
	push rdi

	lea rdi, [fmt_error2]
	xor rax, rax
	call printf

	; restarueaza datele
	pop rdi
	pop rax
	jmp .end
.elements:
	; punem adresa vectorului in rax
	mov rax, qword[rdi + arr]
	xor rdx, rdx
	; salveaza ultimul element in rdx
	mov edx, dword[rax + rbx * 4 - 4]
	; scadem unu din lungime, reactualizand o dupa pop
	dec dword[rdi + len]
	xor rbx, rbx
	; pune in ebx capcitatea
	mov ebx, dword[rdi + cap]
	; imparte capacitatea cu 2
	shr rbx, 1
	; daca capacitatea impartita la 2 e 0 nu face realloc
	cmp rbx, 0x0
	je .no_realloc
	; compara lungimea cu jumatatea a capacitatii
	cmp dword[rdi + len], ebx
	ja .no_realloc
	push rdx
	push rdi
	push rbx
	; aliniaza stiva
	sub rsp, 8

	; pune adresa arrayului
	mov rdi, rax
	; inmultim capacitatea cu sizeof(int) pentru realloc
	shl rbx, 2
	; pune dimensiunea pentru realocare in rsi
	mov rsi, rbx
	call realloc
	; restaureaza stiva
	add rsp, 8 
	pop rbx
	pop rdi
	pop rdx
	; actualizeaza adresa vectorului
	mov qword[rdi + arr], rax
	; actualizeaza capacitatea, noua
	mov dword[rdi + cap], ebx
.no_realloc:
	mov rax, rdx
.end:
	leave
	ret

print_vector:
	push rbp
	mov rbp, rsp
	xor rax, rax
	push rdi
	; aliniaza stiva
	sub rsp, 8
	; punem formatul in rdi
	lea rdi, [fmt_s]
	; printeaza formatul de start
	xor rax, rax
	call printf

	; restaureaza stiva
	add rsp, 8
	pop rdi
	; punem in rax adresa vectorului
	mov rax, qword[rdi + arr]
	xor rcx, rcx
	; printeaza elementele cu valori din vector
.print_loop_vals:
	cmp ecx, dword[rdi + len]
	jae .init_empty

	; salveaza valorile pe stiva si o aliniem
	push rcx
	push rax
	push rdi
	; aliniaza stiva
	sub rsp, 8

	; punem formatul in rdi
	lea rdi, [fmt_val]
	; punem in rsi valorile
	mov esi, dword[rax + rcx * 4]
	xor rax, rax
	call printf

	; restaureaza valorile
	add rsp, 8
	pop rdi
	pop rax
	pop rcx
	; creste contorul
	inc rcx
	jmp .print_loop_vals

.init_empty:
	xor rcx, rcx
	mov ecx, dword[rdi + len]
	; printeaza elementele goale din vector
.print_empty:
	cmp ecx, dword[rdi + cap]
	jae .end

	; salveaza valorile pe stiva si o aliniem
	push rcx
	push rax
	push rdi
	; aliniaza stiva
	sub rsp, 8

	; pune formatul in rdi
	lea rdi, [fmt_gol]
	xor rax, rax
	call printf

	; restaureaza valorile
	add rsp, 8
	pop rdi
	pop rax
	pop rcx
	; creste contorul
	inc rcx
	jmp .print_empty

.end:
	xor rsi, rsi
	xor rdx, rdx
	mov esi, dword[rdi + len]
	mov edx, dword[rdi + cap]
	lea rdi, [fmt_e]
	xor rax, rax
	call printf
	leave
	ret

free_vector:
	push rbp
	mov rbp, rsp
	xor rax, rax
	; pune in rax adresa structurii
	mov rax, qword[rdi]

	; seteaza parametrii cu 0
	mov dword[rax + len], 0x0
	mov dword[rax + cap], 0x0

	; elibereaza vectorul din structura
	push rdi
	push rax

	mov rdi, qword[rax + arr]
	call free

	pop rax
	pop rdi

	push rdi
	; aliniaza stiva
	sub rsp, 8

	mov rdi, rax
	call free

	; restaueaza stiva
	add rsp, 8
	pop rdi
	; seteaza rdi cu NULL
	mov qword[rdi], 0

	leave
	ret