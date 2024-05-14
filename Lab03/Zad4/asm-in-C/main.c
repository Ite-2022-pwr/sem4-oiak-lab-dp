#include <stdio.h>

extern char string[];
extern int integer;
extern const float pi;

int main(int argc, char *argv[])
{
    printf("int: %d\n", integer);
    printf("string: %s\n", string);
    printf("const: %.2f\n", pi);
    return 0;
}
