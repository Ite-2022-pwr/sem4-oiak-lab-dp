# wykorzystanie zmiennych z asemblera w C
main.out: main.o main.c
	gcc -no-pie -ggdb -o main.out main.c main.o
main.o: main.asm
	nasm -f elf64 -g -F dwarf main.asm -l main.lst