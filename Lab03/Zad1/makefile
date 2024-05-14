# Zadanie 1
functions.out: functions.o main.o
	gcc -no-pie -ggdb -o functions.out functions.o main.o
functions.o: functions.asm
	nasm -f elf64 -g -F dwarf functions.asm -l functions.lst
main.o: main.c
	gcc -ggdb -c -o main.o main.c