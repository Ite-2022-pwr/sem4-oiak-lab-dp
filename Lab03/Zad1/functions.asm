BITS 64

section .data
    printfIntFormat db "%d", 10, 0
    printFloatFormat db "%.3f", 10, 0

    aInt dd 4
    bInt dd 10

    aFloat dd 6.2
    bFloat dd 2.13

section .text
    extern add
    extern substract
    extern nwd
    extern printf

    global main

main:
    push rbp
    mov rbp, rsp

    mov rax, 0
    mov rdi, [aInt]
    mov rsi, [bInt]
    call add

    mov rsi, rax
    mov rdi, printfIntFormat
    mov rax, 0
    call printf

    mov rax, 2
    movsd xmm0, [aFloat]
    movsd xmm1, [bFloat]
    call substract

    cvtps2pd xmm0, xmm0
    mov rdi, printFloatFormat
    mov rax, 1
    call printf

    mov rax, 0
    mov rdi, 25
    mov rsi, 5
    call nwd

    mov rsi, rax
    mov rdi, printfIntFormat
    mov rax, 0
    call printf

    leave
    mov rax, 60
    mov rdi, 0
    syscall