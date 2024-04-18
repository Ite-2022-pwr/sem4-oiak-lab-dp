; program zamienia małe itery na duże oraz duże na małe
; jeśli znak nie jest literą program go pomija i wypisuje bez zmian

section .bss
	buffer resb 16		; rezerwacja pamięci na 16 słów 64-bitowych

section .text
	global _start		; etykieta globalna, punkt startu programu

_start:
	mov rax, 0			; załadowanie kodu SYS_READ do rejstry rax
	mov rdi, 0			; ustawienie stdin jako zródła danych
	mov rsi, buffer		; ustawienie adresu buffera jako danye wejściowe
	mov rdx, 16			; maksymalna długość wczytanych danych
	syscall				; wywołanie polecenia SYS_READ

	mov rdi, buffer		; załadowanie adresu buffera do rejestru rdi
	call _swap_chars	; wywołanie funkcji _swap_chars

	mov rax, 1			; załadowanie kodu SYS_WRITE do rejstry rax
	mov rdi, 1			; ustawienie stdout jako miejsca docelowgo danych
	mov rsi, buffer		; ustawienie adresu bufora jako źródła danych
	mov rdx, rbx		; ustawienie iteratora jako długość buffera
	syscall				; wywołanie polecenia SYS_WRITE

	mov rax, 60			; załadowanie kodu SYS_EXIT do rejstry rax
	mov rdi, 0			; ustawienie kodu błędu na 0
	syscall				; wywołanie polecenia SYS_EXIT

_swap_chars:
	mov rbx, 0			; wyzerowanie iteratora

_loop:
	movzx rsi, byte [rdi + rbx]		; załadowanie kolejnego pojedyńczego znaku w bufferze do rejstru rsi
	cmp rsi, 0						; sprawdzenie czy rsi wskazuje na koniec łańcucha 
	je _finish						; jeśli tak, skok do zakończenia przetwarzania ciągu
	cmp rsi, 'a'					; porównanie znaku do znaku ascii 'a'
	jl _not_lower					; jeśli kod ascii jest mniejszy od 'a', skok do etykiety _not_lower
	cmp rsi, 'z'					; porównanie znaku do znaku ascii 'z'
	jg _not_lower					; jeśli kod ascii jest większy od 'z', skok do etykiety _not_lower
	sub byte [rdi + rbx], 32		; odjęcie od wartości ascii znaku wartośći 32 (zamiana małej litery na dużą)

_not_lower:
	cmp rsi, 'A'					; porównanie znaku do znaku ascii 'A'
	jl _next_char					; jeśli kod ascii jest mniejszy, skok do etykiety _next_char
	cmp rsi, 'Z'					; porównanie znaku do znaku ascii 'Z'
	jg _next_char					; jeśli kod ascii jest większy, skok do etykiety _next_char
	add byte [rdi + rbx], 32		; dodanie od wartości ascii znaku wartośći 32 (zamiana dużej litery na małą)

_next_char:
	inc rbx							; zwiększenie wartości iteratora
	jmp _loop						; skok bezwarunkowy do pętli przetwarzającej znaki

_finish:
	inc rbx							; zwiększenie wartości iteratora
	mov byte [rdi + rbx], 10		; dodanie znaku nowej lini na koniec buffera				
	ret
