section .data
    hello_msg db 'Hello, ', 0

section .bss
    name resb 20              ; Bufor na imię

section .text
    global _start

_start:
    ; Wczytaj imię ze standardowego wejścia
    mov rax, 0                  ; Numer funkcji SYS_READ
    mov rdi, 0                  ; Deskryptor pliku (stdin)
    mov rsi, name               ; Bufor na imię
    mov rdx, 20                 ; Maksymalna długość imienia
    syscall                     ; Wywołanie systemowe

    ; Wypisz komunikat proszący o wprowadzenie imienia
    mov rax, 1                  ; Numer funkcji SYS_WRITE
    mov rdi, 1                  ; Deskryptor pliku (stdout)
    mov rsi, hello_msg          ; Adres komunikatu
    mov rdx, 7                  ; Długość komunikatu
    syscall                     ; Wywołanie systemowe

    ; Wypisz imię na standardowym wyjściu
    mov rax, 1                  ; Numer funkcji SYS_WRITE
    mov rdi, 1                  ; Deskryptor pliku (stdout)
    mov rsi, name               ; Adres imienia
    mov rdx, 20
    syscall                     ; Wywołanie systemowe

    ; Zakończ program
    mov rax, 60                 ; Numer funkcji SYS_EXIT
    xor rdi, rdi                ; Kod wyjścia 0
    syscall                     ; Wywołanie systemowe