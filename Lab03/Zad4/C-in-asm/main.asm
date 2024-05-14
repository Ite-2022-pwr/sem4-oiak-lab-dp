BITS 64

section .data
    printfIntFormat db "%d", 10, 0
    extern arr

section .rodata
    extern arrayLength

section .text
    extern printf
    global main

main:
    push rbp
    mov rbp, rsp

    mov eax, dword[arrayLength]
    mov r8, rax
    mov rcx, r8

    mov eax, 1

.loop:
    mov rbx, r8
    sub rbx, rcx
    push rcx
    push r8

    mov rax, 0
    mov rdi, printfIntFormat
    mov esi, dword [arr + rbx * 4]
    call printf

    pop r8
    pop rcx

    loop .loop

    leave
    ret