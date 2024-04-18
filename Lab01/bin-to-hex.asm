; program przyjmuje reprezentacje w NB i przesuwając i dodając bity rejestru rax uzyskuje
; wartość dziesiętną którą następnie zamienia na reprezentacje dziesiętną

section .bss
    binary_input resb 64       ; Bufor na wczytany ciąg znaków w postaci binarnej
    hex_output resb 20          ; Bufor na zapisaną liczbę heksadecymalną

section .text
    global _start

_start:
	mov rax, 0				; załadowanie kodu SYS_READ do rejstry rax
	mov rdi, 0				; ustawienie stdin jako zródła danych
	mov rsi, binary_input	; ustawienie adresu buffera jako danye wejściowe
	mov rdx, 64				; maksymalna długość wczytanych danych
	syscall					; wywołanie polecenia SYS_READ

    mov rax, 0              ; wyzerowanie sumy

_parse_loop:
    cmp byte [rsi], 0       ; sprawdzenie czy wartość znaku jest równa 0 
    je _end_parse           ; jeśli tak, zakończ zamianę

    call _process_char      ; wywołanie funkcji _process_char

    inc rsi                 ; zwiększenie iteratora buffera reprezentacji binarnej
    jmp _parse_loop         ; bezwarunkowy skok do etykiety _parse_loop

_end_parse:
    mov rsi, hex_output     ; ustawienie rejestru rsi na adres buffera wyjściowego 
    call _int_to_hex        ; wywołanie funkcji _int_to_hex

    mov rax, 1              ; załadowanie kodu SYS_WRITE do rejstru rax
    mov rdi, 1              ; ustawienie stdout jako miejsca docelowgo danych
    mov rdx, 20             ; ustawienie długości ciągu wyjściowego 
    syscall                 ; wywołanie polecenia SYS_WRITE

    mov rax, 60             ; załadowanie kodu SYS_EXIT do rejstru rax
    mov rdi, 0              ; ustawienie kodu błędu na 0
    syscall                 ; wywołanie polecenia SYS_EXIT

_process_char:
    cmp byte [rsi], '0'     ; porównanie wartości ascii znaku do '0'
    je _zero                ; jeśli tak, skocz do etykiety _zero
    cmp byte [rsi], '1'     ; porównanie wartości ascii znaku do '1'
    jne _not_binary         ; jeśli nie, skocz do etykiety _not_binary

    shl rax, 1              ; przesunięcie bitów rejestru rax o jeden bit w lewo
    add rax, 1              ; dodanie bitu do najmniej znaczącej pozycji
    ret

_zero:
    shl rax, 1              ; przesunięcie bitów rejestru rax o jeden bit w lewo
    ret

_not_binary:
    ret

_int_to_hex:
    mov rbx, 16             ; ustawienie wartości rbx na 16 (mnożnik do zamiany)

_reverse_loop:
    dec rsi                     ; przesunięcie wskaźnika na koniec bufora
    cmp rax, 0                  ; sprawdzenie czy wartość rejestru rax wynosi 0
    je _end_reverse             ; jeśli tak, skok do etykiety _end_reverse

    mov rdx, 0                  ; wyczyszczenie rejestru rdx
    div rbx                     ; podzielenie wartości rax przez 16, wynik w rax, reszta w rdx
    add dl, '0'                 ; zamiana reszty na znak ASCII
    cmp dl, '9'                 ; sprawdznie czy reszta to cyfra (0-9)
    jbe _store_digit            ; jeśli tak, skok do etykiety _store_digit
    add dl, 7                   ; jeśli nie, dodanie wartości 7 żeby uzyskać literę A-F

_store_digit:
    mov [rsi], dl               ; zapisanie znaku do buffera wyjściowego
    jmp _reverse_loop           ; skok bezwarunkowy do etykiety _reverse_loop

_end_reverse:
    inc rsi                     ; zwiększnie licznika
    ret