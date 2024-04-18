section .bss
    array resq 100

section .text
    global _start

_start:
    call _array_fill_loop
    call _compute_values

    mov rax, 60
    xor rdi, rdi
    syscall

_array_fill_loop:
    mov rsi, array
    xor rdx, rdx
    mov rcx, 100

_fill_loop:
    mov byte [rsi], 1
    inc rsi

    dec rcx
    jnz _fill_loop

    ret

_compute_values:
    mov rsi, array
    mov byte [rsi + 0], 0
    mov byte [rsi + 1], 0
    mov rcx, 2

_outer_loop:
    cmp rcx, 100
    jge _end_compute

    mov rax, rcx
    imul rax, rcx
    mov rdx, rax

_inner_loop:
    cmp rdx, 100
    jge _end_inner_loop

    mov byte [rsi + rdx], 0
    add rdx, rcx
    jmp _inner_loop

_end_inner_loop:
    inc rcx
    jmp _outer_loop

_end_compute:
    ret