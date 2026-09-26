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
global filter_flights

; void filter_flights(struct flight* origFlights, struct flight* finalFlights
;						 int* nrFlights, int min_bag_weight)
; rdi = struct flight *origFlights
; rsi = struct flight *finalFlights
; rdx = int *nrFlights
; rcx = int min_bag_weight
filter_flights:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here

	; indexul
	xor r10, r10
	; offsetul pt vectorul original
	xor r9, r9
	; offsetul pentru vectorul filtrat
	xor r13, r13
	; numarul de zboruri filtrate
	xor r11, r11
.loop_flight:
	cmp r10d, [rdx]
	jz .done

	xor rbx,rbx
	xor rax,rax
	; adauga in rax adresa greutatii bagajelor
	lea rax, [rdi + r9 + bag_weight]
	xor rbx, rbx
	mov bx, word[rax]
	; daca este mai mic decat greutatea nu il copiaza in vectorul filtrat 
	cmp rbx, rcx
	jl .no_copy
	inc r11
	;indexul pt copierea bitilor
	xor r12, r12
; copiaza bit cu bit in vectorul filtrat din vectorul original
.loop_copy:
	; verifica daca indexul a ajuns la 42, apoi iese din loop
	cmp r12, 42
	jz .offset_copy
	add r9, r12
	mov bl, byte[rdi + r9]
	sub r9, r12
	add r13, r12
	mov byte[rsi + r13], bl
	sub r13, r12

	inc r12
	jmp .loop_copy
.offset_copy:
	; se adauga la offsetul vectorului filtrat
	add r13, flight_size
.no_copy:
	inc r10
	add r9, flight_size
	jmp .loop_flight


.done:
	mov [rdx], r11d

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

	leave
	ret