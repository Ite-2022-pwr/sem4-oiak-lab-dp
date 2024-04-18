section .text
    global _start

_start:
    mov rdi, 49
    mov rsi, 7
    jmp _euklides

_euklides:
    cmp rsi, 0
    je _end_euklides
    jne _calc
    
_calc:
    call _modulo
    push rsi
    mov rsi, rdx
    pop rdi
    jmp _euklides

_modulo:            ; rdi - a, rsi - b
    cmp rsi, 0
    je _devide_by_zero

    xor rdx, rdx    ; zerwoanie reszty z dzielenia
    mov rax, rdi
    div rsi         ; wynik w rax, rdx - reszta
    ret

_devide_by_zero:
    mov rax, 0
    ret

_end_euklides:
    ;mov rax, rdi

_print_and_exit:
    mov rsi, rax
    mov rax, 1
    mov rdi, 1
    mov rdx, 8
    syscall

    mov rax, 60
    mov rdi, 0
    syscall 