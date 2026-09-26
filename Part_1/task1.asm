section .text

;; DO NOT MODIFY
global fix_lap_times


fix_lap_times:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    ;; DO NOT MODIFY
    ;; YOUR CODE STARTS HERE

    xor r10, r10
    ; indexul iteratiei
    xor r9, r9
    dec rdx
.loop:
    ; verifica daca r9 - 1 este rdx
    dec r9
    cmp r9, rdx
    je .done
    inc r9

    xor rbx, rbx
    ; pune in bl un bit de vectorul de erori
    mov bl, byte[rsi + r9]

    xor rax, rax
    ; pune in eax un numar din vectorul de valori
    mov eax, dword[rdi + r9 * 4]
    ;daca nu are eroare trece mai departe
    cmp bl, 0
    je .put_output
    ; creste numarul de lap-uri cu erori
    inc r10
    ; verifica daca este pe prima pozitie
    cmp r9, 0
    jne .verify_last
    ; pune in eax lap-ul urmator
    mov eax, dword[rdi + r9 * 4 + 4]
    jmp .put_output
.verify_last:
    ; verifica daca este pe ultima pozitie
    cmp r9, rdx
    jne .middle
    ; pune in eax lap-ul de dinainte
    mov eax, dword[rdi + r9 * 4 - 4]
    jmp .put_output
.middle:
    xor rax, rax
    ; pune in eax lap-ul de dinainte
    mov eax, dword[rdi + r9 * 4 - 4]
    xor rbx,rbx
    ; pune in ebx lap-ul urmator
    mov ebx, dword[rdi + r9 * 4 + 4]
    ; le aduna
    add eax, ebx
    ; imparte la 2 pentru a face media aritmetica
    shr eax, 1

.put_output:
    ; pune in vectorul de lap-uri valoarea noua
    mov dword[rcx + r9 * 4], eax
    inc r9
    jmp .loop

.done:
    mov dword[r8], r10d
    ;; YOUR CODE ENDS HERE
    ;; DO NOT MODIFY
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
    ;; DO NOT MODIFY