section .data
    hello_msg db 'Hello, World!', 0

section .text
    global _start

_start:
    ; Wywołanie funkcji SYS_WRITE, aby wypisać komunikat na standardowym wyjściu
    mov rax, 1                  ; Numer funkcji SYS_WRITE
    mov rdi, 1                  ; Deskryptor pliku (stdout)
    mov rsi, hello_msg          ; Adres komunikatu
    mov rdx, 13                 ; Długość komunikatu
    syscall                     ; Wywołanie systemowe

    ; Wywołanie funkcji SYS_EXIT, aby zakończyć program
    mov rax, 60                 ; Numer funkcji SYS_EXIT
    xor rdi, rdi                ; Kod wyjścia 0
    syscall                     ; Wywołanie systemowe