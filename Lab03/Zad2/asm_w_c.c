#include <stdio.h>

extern int addInt(int a, int b);
extern float subFloat(float a, float b);
extern int nwd(int a, int b);

int main(int argc, char *argv[])
{
    int res1 = addInt(5, 3);
    printf("sum result (int): %d\n", res1);
  
    float res2 = subFloat(3.14, 4.20);
    printf("sub result (float): %.3f\n", res2);

    int res3 = nwd(25,5);
    printf("nwd(25, 5): %d\n", res3);
    
    printf("hvc");
    return 0;
}