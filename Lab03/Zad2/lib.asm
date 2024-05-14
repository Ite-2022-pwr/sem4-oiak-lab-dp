BITS 64

section .text
    global addInt
    global subFloat
    global nwd
    extern _fun_modulo

addInt:
    push rbp
    mov rbp, rsp

    mov rax, rdi
    add rax, rsi

    leave
    ret

subFloat:
    push rbp
    mov rbp, rsp

    subss xmm0, xmm1

    leave
    ret

nwd:
    cmp rsi, 0
    je _end 
    jne _calc
    
_calc:
    call _fun_modulo
    push rsi    
    mov rsi, rax
    pop rdi
    jmp nwd

_end:
    mov rax, rdi
    leave
    ret

_fun_modulo:
    cmp rsi, 0
    je _devide_by_zero

    xor rdx, rdx

    mov rax, rdi
    div rsi                 ; devide rax / rsi, rdx = reminder
    jmp _exit

_devide_by_zero:
    mov rax, 0
    ret

_exit:
    mov rax, rdx            ; move reminder (result of modulo) to rax
    ret