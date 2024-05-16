#include <stdio.h>

extern unsigned short get_fpu(void);
extern void set_fpu(unsigned short *control_word);

void printStatus(unsigned short fpu) {
    int binNumber[16];
    printf("FPU dec: %hd\n", fpu);
    printf("FPU hex: 0x%04x\n", fpu);
    for(int i = 0; i < 16; i++) {
        int bin = fpu % 2;
        binNumber[i] = bin;
        fpu /= 2;
    }

    printf("Invalid operand exception: %d\n", binNumber[15]);
    printf("Denormal operand exception: %d\n", binNumber[14]);
    printf("Zero devide exception: %d\n", binNumber[13]);
    printf("Overflow exception: %d\n", binNumber[12]);
    printf("Underflow exception: %d\n", binNumber[11]);
    printf("Precision exception: %d\n", binNumber[10]);

    printf("Interrupt enable mask: %d\n", binNumber[8]);
    printf("Precision control: %d%d\n", binNumber[7], binNumber[6]);
    printf("Rounding control: %d%d\n", binNumber[5], binNumber[4]);
    printf("Infinity control: %d\n", binNumber[3]);
    
}

int main() {
    unsigned short fpu = get_fpu();
    printf("Before set\n");
    printStatus(fpu);
    
    unsigned short new_fpu = 0x037E;
    set_fpu(&new_fpu);

    unsigned short fpu2 = get_fpu();
    printf("\nAfter set\n");
    printStatus(fpu2);

    return 0;
}