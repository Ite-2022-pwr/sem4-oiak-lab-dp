section .data
    fpu dw 0

section .text
    global set_fpu
    global get_fpu

get_fpu:
    push rbp
    mov rbp, rsp

    fstcw [fpu]
    mov ax, [fpu]
    
    leave
    ret

set_fpu:
    push rbp
    mov rbp, rsp

    mov ax, di
    fldcw [rax]
    
    leave
    ret