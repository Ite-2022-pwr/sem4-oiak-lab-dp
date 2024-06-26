section .bss
    dec_input resb 20
    bin_output resb 64
    dec_output resb 20
    
section .text
    global _start

_start:
    mov rax, 0                  ; SYS_READ
	mov rdi, 0                  ; stdin
	mov rsi, dec_input          ; buffer dla dziesiętnej reprezentacji
	mov rdx, 20                 ; długość buffera 
	syscall                     ; wywołania SYS_READ

    mov rdi, dec_input          ; załadowanie do rejestru rdi adresu buffera wejścia
    call _decimal_to_binary

    call _bin_to_dec

    mov rsi, dec_output
    call _dec_to_string

    mov rax, 1
    mov rdi, 1
    mov rdx, 20
    syscall

    mov rax, 60
    mov rdi, 0
    syscall

_decimal_to_binary:
    mov rax, 0      ; zerowanie wyniku
    mov rcx, 0      ; zerowanie licznika
    mov rdx, 0      ; zerowanie reprezentacji znaku

_next_decimal:
    movzx rdx, byte [rdi + rcx]     ; wczytanie znaku do rdx
    cmp rdx, 0                      ; porownanie znaku z 0
    je _done_decimal                ; zakończenie konwersji 

    cmp rdx, '0'
    jl _not_digit
    cmp rdx, '9'
    jg _not_digit

    sub rdx, '0'                    ; przekonwertowanie cyfry w znaku ascii na odpowiadającą mu wartość dziesiętną
    imul rax, rax, 10               ; przemnożenie wyniku razy 10 w celu konwersji kolejnej cyfry
    add rax, rdx                    ; dodanie kolejnej cyfry do najmniej znaczącej pozycji
    inc rcx                         ; zwiększenie iteratora
    jmp _next_decimal               ; skok bezwarunkowy do etykiety _next_decimal

_not_digit:
    inc rcx
    jmp _next_decimal

_done_decimal:
    mov rsi, bin_output             ; ustawienie rejestru rdi na adres buffera wyjściowego
    add rsi, 63                     ; przeunięcie rejestru na koniec buffora

_next_binary:
    cmp rax, 0                      ; sprawdzenie końca buffera
    je _done_binary

    mov rdx, 0                      ; wyzerowanie reszty z dzielenia
    mov rbx, 2                      ; podstawa systemu binarnego
    div rbx                         ; podzielenie rax / 2, wynik w rax, reszta w rdi
    add dl, '0'                     ; przekonwertowanie na znak ascii
    dec rsi                         ; dekrementacja iteratora
    mov [rsi], dl                   ; zapisanie wyniku w buferze 
    jmp _next_binary                ; kolejna iteracja konwersji 

_done_binary:
    ret

_bin_to_dec:
    mov rax, 0

_bin_parse_loop:
    ;sprawdzenie końca buffera
    cmp byte [rsi], 0
    je _dec_done

    call _process_char              ; obsłużenie znaku 

    inc rsi
    jmp _bin_parse_loop             ; kolejny znak w buforze

_process_char:
    ;sprawdzanie czy znak jest '0' lub '1'
    cmp byte[rsi], '0'
    je _zero
    cmp byte [rsi], '1'
    jne _not_binary

    shl rax, 1                      ; przesunięcie wartości rejestru o jeden bit w lewo
    add rax, 1                      ; dodanie 1 na najmniej znaczącej pozycji wartości rejestru rax
    ret

_zero:
    shl rax, 1                      ; przesunięcie wartości rejestru o jeden bit w lewo
    ret                             ; zostawienie zera na najmniej znaczącej pozycji wartości rejestru

_not_binary:
    ret                             ; ignorowanie znaków innych niż '0' i '1'

_dec_done:
    ret

_dec_to_string:
    mov rbx, 10                     ; podstawa systemu dziesiętnego

_dec_parse_loop:
    ; sprawdzenie końca buffera
    dec rsi
    test rax, rax
    jz _end_dec_loop

    mov rdx, 0                      ; wyzerownie reszty z dzielenia
    div rbx                         ; dzielenie rax / 10, wynik w rax, reszta w rdx
    add dl, '0'                     ; konwersja wartości zyfry na ascii
    mov [rsi], dl                   ; wpisanie reprezentacji do buffera
    jmp _dec_parse_loop             ; kolejna cyfra

_end_dec_loop:
    inc rsi
    ret