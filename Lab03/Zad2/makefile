# Zadanie 2
asm_w_c.out: lib.o asm_w_c.o
	gcc -no-pie -ggdb -o asm_w_c.out lib.o asm_w_c.o
asm_w_c.o: asm_w_c.c
	gcc -no-pie -c -o asm_w_c.o asm_w_c.c
lib.o: lib.asm
	nasm -f elf64 -g -F dwarf lib.asm -l lib.lst