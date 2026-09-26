; you can declare any helper variables in .data or .bss

section .text

;; DO NOT MODIFY
global solve_labyrinth

solve_labyrinth:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    mov     r12, rdi
    mov     r13, rsi
    mov     r14, rdx
    mov     r15, rcx
    mov     rbx, r8
    ;; DO NOT MODIFY
    ;; YOUR CODE STARTS HERE

    ; index pentru liniile matricei
    xor r9, r9
     ; index pentru coloanele matricei
    xor r10, r10

    dec r14
    dec r15
.loop_matrix
    ; verifica daca s-a ajuns la destinatie
    cmp r9, r14
    jz .done
    cmp r10, r15
    jz .done
    xor rdx, rdx
    ; in rcx este stocata adresa catre linia respectiva
    mov rcx, [r8 + r9 * 8]
    ; verifica daca e liber in jos
.down:
    ; in rbx este stocata adresa catre linia din josul linei respective
    mov rbx, [r8 + r9 * 8 + 8]
    ; in dl este stocata valoarea de sub pozitia actuala
    mov dl, byte[rbx + r10 * 1]
    cmp dl, '0'
    ; daca nu e 0 verifica pozitita de sus
    jnz .up
    ; a fost deja pe pozita aceasta si o noteaza cu 1
    mov byte[rcx + r10 * 1], 1
    inc r9
    jmp .next
    ; verifica daca e liber in sus
.up:
    ; daca e margine, trece la verificarea la dreapta
    cmp r9, 0
    jz .right
    ; in rbx este stocata adresa catre linia de deasupra linei respective
    mov rbx, [r8 + r9 * 8 - 8]
    ; in dl este stocata valoarea de deasupra pozitiei actuala
    mov dl, byte[rbx + r10 * 1]
    ; daca nu e 0 sus drumul este blocat in sus si verifica dreapta
    cmp dl, '0'
    jnz .right
    ; a fost deja pe pozita aceasta si o noteaza cu 1
    mov byte[rcx + r10 * 1], 1
    dec r9
    jmp .next
    ; verifica daca e liber la dreapta
.right:
    ; in dl este stocata valoarea din dreapta pozitiei actuala
    mov dl, byte[rcx + r10 * 1 + 1]
    ; daca nu e 0 la dreapta drumul este blocat si verifica la stanga
    cmp dl, '0'
    jnz .left
    ; a fost deja pe pozita aceasta si o noteaza cu 1
    mov byte[rcx + r10 * 1], 1
    inc r10
    jmp .next
.left:
    ; in dl este stocata valoarea din stanga pozitiei actuala
    mov dl, byte[rcx + r10 * 1 - 1]
    ; la stanga trebuie sa fie neaparat un 0, daca nu, ar fi un drum complet blocat
    mov byte[rcx + r10 *1], 1
    dec r10
    jmp .next
.next:

    jmp .loop_matrix


.done:
    mov [rdi], r9d
    mov [rsi], r10d
    ;; YOUR CODE ENDS HERE
    ;; DO NOT MODIFY
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret
    ;; DO NOT MODIFY