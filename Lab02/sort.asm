section .data
    array dq 64, 34, 25, 12, 22, 11, 90
    array_len dq 7

section .text
    global _start

_start:
    call _start_bubble_sort

    ; Exit the program
    mov rax, 60
    xor rdi, rdi
    syscall

_start_bubble_sort:
    mov rsi, array              ; Pointer to the start of the array
    mov rdi, [array_len]          ; Length of the array
    dec rdi

    xor rbx, rbx                ; j = 0

_outer_loop:
    cmp rbx, rdi
    jge _end_outer_loop         ; If j >= array_len - 1, exit outer loop

    xor rcx, rcx                ; i = 0

_inner_loop:
    cmp rcx, rdi
    jge _end_inner_loop         ; If i >= array_len - 1 - j, exit inner loop

    mov rax, qword [rsi + rcx * 8]   ; Load array[i]
    mov rdx, qword [rsi + rcx * 8 + 8] ; Load array[i + 1]
    cmp rax, rdx

    jle _no_swap                ; If array[i] <= array[i + 1], no swap needed

    ; Swap array[i] and array[i + 1]
    mov qword [rsi + rcx * 8], rdx
    mov qword [rsi + rcx * 8 + 8], rax

_end_swap:
    inc rcx
    jmp _inner_loop

_no_swap:
    inc rcx                     ; Increment i
    jmp _inner_loop             ; Repeat inner loop

_end_inner_loop:
    inc rbx                     ; Increment j
    jmp _outer_loop             ; Repeat outer loop

_end_outer_loop:
    ret