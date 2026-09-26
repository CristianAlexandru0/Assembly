; write the structures. make sure it fits the layour in the README
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
global apply_delay

; void apply_delay(struct flight* flights, int nrFlights)
; rdi = struct flight *flightss
; rsi = int nrFlights
apply_delay:
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	;; DO NOT MODIFY
	;; Your code starts here

	xor rcx, rcx
	xor r9, r9
.loop_arrive:
	cmp rcx,rsi
	jz .done1
	xor r10, r10
	xor rax, rax
	xor rbx, rbx
	; adauga in rax adresa timpului de sosire a minutelor
	lea rax, [rdi + r9 + arrivingTime_minutes]
	; adauga in rbx adresa timpului de intarziere a minutelor
	lea rbx, [rdi + r9  + delayMinutes]
	;se modifica minutele in dl
	mov dl, byte[rax]
	add dl, byte[rbx]
	mov byte[rax], dl
	; daca numarul de minute este mai mic ca 60, trece direct la ore
	cmp dl, 60
	jl .hours1
	; adauga in r10 carry
	mov r10, 1
	; daca depaseste scade 60 si pune la loc in vector
	sub dl, 60
	mov [rax], dl
;se modifica ora
.hours1:
	; adauga in rax adresa timpului de sosire a orelor
	lea rax, [rdi + r9 + arrivingTime_hour]
	; adauga in rbx adresa timpului de intarziere a orelor
	lea rbx, [rdi + r9 + delayHours]
	; modifica ora in dl
	mov dl, byte[rax]
	add dl, byte[rbx]
	add dl, r10b
	xor r10, r10
	; o pune inapoi in vector
	mov byte[rax], dl
	; daca nu depaseste 24 de ore inseamna ca trece direct la zile
	cmp dl, 24
	jl .day1
	;adauga in r10 carry
	mov r10, 1
	; daca depaseste scade 24 si pune la loc in vector
	sub dl, 24
	mov byte[rax], dl
;se modifica ziua
.day1:
	; adauga in rax adresa timpului de sosire a zilei
	; la care se poate adauga doar 1, pentru ca numarul lunii nu este depasit
	lea rax, [rdi + r9 + arrivingTime_day]
	mov dl, byte[rax]
	add dl, r10b
	mov byte[rax], dl

	inc rcx
	add r9, flight_size
	jmp .loop_arrive

.done1:

	xor rcx, rcx
	xor r9, r9

.loop_departure:
	cmp rcx,rsi
	jz .done2
	xor r10, r10
	xor rax, rax
	xor rbx, rbx
	; adauga in rax adresa timpului de plecare a minutelor
	lea rax, [rdi + r9 + departingTime_minutes]
	; adauga in rbx adresa timpului de intarziere a minutelor
	lea rbx, [rdi + r9  + delayMinutes]
	;se modifica minutele in dl
	mov dl, byte[rax]
	add dl, byte[rbx]
	mov byte[rax], dl
	; daca numarul de minute este mai mic ca 60, trece direct la ore
	cmp dl, 60
	jl .hours2
	; adauga in r10 carry
	mov r10, 1
	; daca depaseste scade 60 si pune la loc in vector, 
	sub dl, 60
	mov [rax], dl
; se modifica ora
.hours2:
	; adauga in rax adresa timpului de plecare a orelor
	lea rax, [rdi + r9 + departingTime_hour]
	; adauga in rbx adresa timpului de intarziere a orelor
	lea rbx, [rdi + r9 + delayHours]
	; modifica ora in dl
	mov dl, byte[rax]
	add dl, byte[rbx]
	add dl, r10b
	xor r10, r10
	; o pune inapoi in vector
	mov byte[rax], dl
	; daca nu depaseste 24 de ore inseamna ca trece direct la zile
	cmp dl, 24
	jl .day2
	;adauga in r10 carry
	mov r10, 1
	; daca depaseste scade 24 si pune la loc in vector
	sub dl, 24
	mov byte[rax], dl
; se modifica ziua
.day2:
	; adauga in rax adresa timpului de plecare a zilei
	; la care se poate adauga doar 1, pentru ca numarul lunii nu este depasit
	lea rax, [rdi + r9 + departingTime_day]
	mov dl, byte[rax]
	add dl, r10b
	mov byte[rax], dl

	inc rcx
	add r9, flight_size
	jmp .loop_departure

.done2:

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
