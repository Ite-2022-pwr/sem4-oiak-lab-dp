section .data
  printfFmt db "%d",10,0

section .text
    extern printf
    global main

main:
    mov rbx, 0      ; a
    mov rcx, 1      ; b
    mov rdx, 10      ; n
    mov rsi, 2      ; iterator
_fibonacci:
    cmp rsi, rdx
    jg _end_loop

    mov rax, rbx
    add rax, rcx
     
    mov rbx, rcx
    mov rcx, rax

    inc rsi
    
    jmp _fibonacci 

_end_loop:
    mov rax, rcx