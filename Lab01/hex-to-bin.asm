; program zamienia reprezentacje w systemie heksadecymalnym na wartość w systemie dziesiętnym
; następnie zamienia z wartości dziesiętnej na reprezentacje w systemie NB
; program pomija znaki które nie są cyfrą 0-9 oraz znakiem A-F

section .bss
	hex_buffer resb 20		; rezerwacja pamięci dla 20 słów 64-bitowych na dane wejściowe
	bin_buffer resb 64		; rezerwacja pamięci dla 64 słów 64-bitowych na dane wyjściowe

section .text
	global _start			; etykieta globalna, punkt startu programu

_start:
	mov rax, 0				; załadowanie kodu SYS_READ do rejstry rax
	mov rdi, 0				; ustawienie stdin jako zródła danych
	mov rsi, hex_buffer		; ustawienie adresu buffera jako danye wejściowe
	mov rdx, 20				; maksymalna długość wczytanych danych
	syscall					; wywołanie polecenia SYS_READ

	mov rdi, hex_buffer		; załadowanie adresu buffera do rejestru rdi
	call _hex_to_decimal	; wywołanie funkcji _hex_to_decimal

	mov rax, 1				; załadowanie kodu SYS_WRITE do rejstru rax
	mov rdi, 1				; ustawienie stdout jako miejsca docelowgo danych
	mov rsi, bin_buffer		; ustawienie adresu bufora jako źródła danych
	mov rdx, 64				; ustawienie iteratora jako długość buffera
	syscall					; wywołanie polecenia SYS_WRITE

	mov rax, 60				; załadowanie kodu SYS_EXIT do rejstru rax
	mov rdi, 0				; ustawienie kodu błędu na 0
	syscall					; wywołanie polecenia SYS_EXIT

_hex_to_decimal:
	xor rax, rax			; wyzerowanie rejestru rax
	xor rbx, rbx			; wyzerowanie rejestru rbx

_to_decimal:
	movzx rdx, byte[rdi + rbx]	; załadowanie pierwszego pojedynczego znaku do rejstru rdx
	cmp rdx, 0					; sprawdzenie czy rdx wskazuje na koniec łańcucha 
	je _done_conversion			; jeśli tak, skok do _done_convertion
	
	; sprawdzenie czy znak jest cyfrą 
	cmp rdx, '0'				; porównania rdx do kodu ascii '0'
	jl _not_digit				; jeśli wartość rdx jest mniejsza, skok do etykietu _not_digit
	cmp rdx, '9'				; porównania rdx do kodu ascii '9'
	jg _not_digit				; jeśli wartość rdx jest większa, skok do etykietu _not_digit

	sub rdx, '0'				; odjęcie wartości ascii '0' żeby uzyskać wartość znaku cyfry
	jmp _continue_loop			; skok bezwarunkowy do ustawienia kolejnego przejścia pętli

_not_digit:
	; sprawdzenie czy znak jest dużą literą od A do F
	cmp rdx, 'A'				; porównania rdx do kodu ascii 'A'
	jl _not_letter				; jeśli wartość rdx jest mniejsza, skok do etykietu _not_letter
	cmp rdx, 'F'				; porównania rdx do kodu ascii 'F'
	jg _not_letter				; jeśli wartość rdx jest mniejsza, skok do etykietu _not_letter
	sub rdx, 'A' - 10			; odjęcie wartości ascii 'A' oraz 10 żeby uzyskać wartość znaku litery

_continue_loop:
	imul rax, rax, 16			; przemnożenie wartości znajdującej się w rax przez 16
	add rax, rdx				; dodanie wartości znaku w hex do sumy wartości
	inc rbx						; zwiększenie wartości iteratora
	jmp _to_decimal				; bezwarunkowy skok do pętli przetwarzającej znaki

_not_letter:
	inc rbx						; zwiększenie wartości iteratora
	jmp _to_decimal				; bezwarunkowy skok do pętli przetwarzającej znaki

_done_conversion:
	mov rbx, 2					; ustawienie rbx na postawę systemu docelowego 
	mov rsi, bin_buffer			; ustawienie rsi na adres buffera
	add rsi, 63					; przesunięcie rsi na koniec buffera

_convert_to_binary:
	cmp rax, 0				; sprawdzenie czy rax jest zerem
	je _done_converting		; jesli tak, skok do etykiety _done_converting

	mov rdx, 0				; wyzerowanie rejestru rdx			
	div rbx					; podzielenie rax/rbx (rax/2), wynik w rax, reszta w rdx
	add dl, '0'				; uzyskanie wartości znaku w najmnej znaczącej częsci rdx (reszty z dzilenia)
	mov [rsi], dl			; dodanie reszty z dzielenia (0/1) do buffera wyjściowego 
	dec rsi					; zmniejszenie iteratora buffera wyjściowego 
	jmp _convert_to_binary	; skok bezwarunkowy do etykiety zamieniającej dec na bin

_done_converting:
	ret
