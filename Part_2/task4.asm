section .note.GNU-stack

section .bss
	; un vector in care tine secventa generata actuala
	arr resd 30
	; vector de pointeri la solutii
	found resd 1
section .text

global check_langford
global generate_langford_sequences
extern malloc

check_langford:
	push rbp
	mov rbp, rsp
	xor rax, rax

	push rbx
	push r14
	mov r14, rsi
	xor r8,r8
	push rsi
	; aliniaza stiva
	sub rsp, 8
	; imparte lungimea la 2 
	shr rsi, 1
.loop_langford:

	xor r9,r9
.loop_search:
	; daca depaseste lungimea initiala
	cmp r9 , r14
	je .not_good
	xor rbx, rbx
	; pune cate un numar in bl din vector
	mov ebx, dword[rdi + r9 * 4]
	; trebuie sa gaseasca prima aparitie a numarului, dar r8 este indexat de la 0 asa ca face comparatia cu r10
	; r10 = r8 + 1
	mov r10 , r8
	inc r10
	;  vede daca a gasit prima aparitie a unui element
	cmp rbx, r10
	jz .verify
	inc r9
	jmp .loop_search
.verify:
	mov rdx, r9
	add rdx, r8
	inc rdx
	; inmulteste cu size of(int)
	shl rdx, 2
	; aduna o pozitie la offset pentru a ajunge la elemntul dorit
	add rdx, 4
	cmp ebx ,dword[rdi + rdx]
	jne .not_good

	inc r8
	; daca depaseste lungimea / 2 pentru ca verifica doar n/2 numere
	cmp r8, rsi
	je .good
	jmp .loop_langford
.not_good:
	; returneaza 0
	mov rax, 0
	jmp .end
.good:
	; returneaza 1
	mov rax, 1
.end:
	; restaureaza datele
	add rsp, 8
	pop rsi
	pop r14
	pop rbx
	leave
	ret


malloc_pointers:
	push rbp
	mov rbp, rsp
	; aloca 100 de bytes in vectorul de pointeri ce trebuie returnat
	mov rdi, 100
	call malloc

	leave
	ret

; in rdi primeste pasul
; in rdxnumarul de valori
; in rsi lungimea
; genereaza toate permutarile posibile si verifica daca sunt secvente langford
backtrack:
	push rbp
	mov rbp, rsp
	; verifica daca sirul generat a ajuns la lungime
	cmp rdi,rsi
	jnz .not_equal

	push rdi
	push rsi
	push rdx
	push rcx

	mov rdi, arr
	call check_langford
	pop rcx
	pop rdx
	pop rsi
	pop rdi

	; compara sa vada daca secventa este corespunzatoare
	cmp rax, 1
	jnz .no_save

	push rdi
	push rsi
	push rdx
	push rcx

	mov rdi, rsi
	;inmultim lungimea cu size of int
	shl rdi,2
	call malloc

	pop rcx
	pop rdx
	pop rsi
	pop rdi

	xor r10, r10
	mov r11, rsi
.loop_copy:
	cmp r10, r11
	je .ok

	xor r8, r8
	; copiaza in ecx valoarea din sir
	mov r8d, dword[arr + r10 * 4]
	; salveaza valoare din sir in array
	mov dword[rax + r10 * 4], r8d
	inc r10
	jmp .loop_copy

.ok:
	xor r8, r8
	; pune numarul de secvente gasite
	mov r8d, dword [found]
	; pune pointerul in 
	mov [rcx + r8 * 8], rax
	inc r8
	mov dword[found], r8d
.no_save:
	leave 
	ret
.not_equal:
	; r8 este indicele loopului si este indexat de la 1
	mov r8, 1 
.loop_back:
	cmp r8, rdx
	jg .end
	; pune in arr un numar deintre [1, n/2]
	mov dword[arr + rdi * 4], r8d

	push rdi
	push rsi
	push rdx
	push r8

	; merge la urmatorul pas
	add rdi, 1
	call backtrack

	pop r8
	pop rdx
	pop rsi
	pop rdi
	; merge la urmatorul element
	inc r8
	jmp .loop_back
.end:
	leave
	ret

generate_langford_sequences:
	push rbp
	mov rbp, rsp
	xor rax, rax

	push rdi
	push rsi

	call malloc_pointers

	pop rsi
	pop rdi

	push rsi
	push rdi
	push rdi
	; initializeaza numarul de secvente generate
	mov dword[found], 0
	; pune lungimea in rsi
	mov rdx, rdi
	pop rdi
	; pune numarul de  valori
	shl rdi,1
	mov rsi, rdi
	; pune pasul 0
	mov rdi, 0
	;pune vectorul de pointeri la secvente
	mov rcx, rax
	call backtrack

	pop rdi
	pop rsi

	; pune vectorul de pointeri la secvente in rax
	mov rax, rcx
	xor rcx, rcx
	mov ecx, dword[found]
	mov dword[rsi], ecx

.end:

	leave
	ret
