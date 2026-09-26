struc flight
	destination: resb 32
	departingTime_day: resb 1
	departingTime_hour: resb 1
	departingTime_minutes: resb 1
	arrivingTime_day: resb 1
	arrivingTime_hour: resb 1
	arrivingTime_minutes: resb 1
	bag_weight: resw 1
	delayMinutes: resb 1
	delayHours: resb 1
endstruc

section .text

;; DO NOT MODIFY
global sort_and_return

; int sort_and_return(struct flight* flights, int nrFlights, 
;                      struct flight* bestFlight, char destination[32])
; rdi = flights (pointer)
; rsi = nrFlights (value)
; rdx = bestFlight (pointer to pre-allocated struct)
; rcx = destination (pointer to 32-byte string)
sort_and_return:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here
	; indexul pt a fixa elementul
	xor r14,r14
	;indexul pt a se plimba pe elementele de dupa
	xor r15, r15
	; salveaza rdx pentru a nu fi distrus de operatia mul
	push rdx
.for_sort1:
	cmp r14, rsi
	je .done
	; se calculeaza offsetul
	xor rax, rax
	add rax, flight_size
	mov r9, r14
	mul r9
	; in r9 se salveaza offsetul structurii ce este comparata cu celelalte
	mov r9, rax

	mov r15, r14
	inc r15
.for_sort2:
	cmp r15,rsi
	je .next2

	xor r12, r12
	; se calculeaza offsetul
	xor rax, rax
	add rax, flight_size
	mov r10, r15
	mul r10
	; in r10 se salveaza offsetul structurii cu, care vom compara structura aleasa
	mov r10, rax
	; se compara zilele de sosire
	mov al, byte[rdi + r9 + arrivingTime_day]
	mov bl, byte[rdi + r10 + arrivingTime_day]
	cmp al, bl
	jl .next1
	jg .swap
	; se compara orele de sosire
	mov al, byte[rdi + r9 + arrivingTime_hour]
	mov bl, byte[rdi + r10 + arrivingTime_hour]
	cmp al, bl
	jl .next1
	jg .swap
	; se compara minutele de sosire
	mov al, byte[rdi + r9 + arrivingTime_minutes]
	mov bl, byte[rdi + r10 + arrivingTime_minutes]
	cmp al, bl
	jl .next1
	jg .swap
	; se compara greutatea bagajelor
	mov ax, word[rdi + r9 + bag_weight]
	mov bx, word[rdi + r10 + bag_weight]
	cmp ax, bx
	jg .next1
	jl .swap
; daca zborul fixat soseste mai tarziu sau greutatea bagajului este mai mica
; face swap cu cel care soseste mai devreme sau are greutatea mai mare
.swap:
	cmp r12, flight_size
	jz .next1
	add r9, r12
	mov al, byte[rdi + r9] 
	add r10, r12
	mov bl, byte[rdi + r10] 

	mov byte[rdi + r9], bl
	sub r9, r12
	mov byte[rdi + r10], al
	sub r10, r12
	inc r12
	jmp .swap
.next1:
	inc r15
	jmp .for_sort2
.next2:
	inc r14
	jmp .for_sort1

.done:
	pop rdx

	; offsetul
	xor r9, r9
	; indexul
	xor r14, r14
.loop_search:
	cmp r14, rsi
	jz .done2
	; se adauga in rax adresa destinatiei
	lea rax, [rdi + r9 + destination]
	; indexul pentru a compara bit cu bit
	xor r12, r12
.loop_cmp:
	mov bl, [rax + r12]
	mov r10b, [rcx + r12]
	; daca a ajuns la final inseamna ca s a terminat copierea
	cmp r10b, 0
	jz .equal
	inc r12
	cmp bl, r10b
	jnz .next3
	jmp .loop_cmp

.equal:
	xor r12, r12
	; returneaza in rax 1, pentru ca am gasit un zbor la destinatia dorita
	mov rax, 1
; copiaza in rdx, zborul respectiv
.loop_copy:
	cmp r12, flight_size
	jz .return_1
	add r9, r12
	mov bl, byte[rdi + r9]
	sub r9, r12
	mov byte[rdx + r12], bl
	inc r12
	jmp .loop_copy
.next3:
	add r9, flight_size
	inc r14
	jmp .loop_search
.done2:
	xor rax, rax
.return_1:

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