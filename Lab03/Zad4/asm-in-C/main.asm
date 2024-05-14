BITS 64

section .data
    global string
    global integer
    
    string db "Hello world!", 0
    integer dd 26

section .rodata
    global pi
    pi dd 3.14
