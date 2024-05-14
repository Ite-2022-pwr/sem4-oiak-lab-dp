int add(int a, int b) {
    return a + b;
}

float substract(float a, float b) {
    return a - b;
}

int nwd(int a, int b) {
    if (b != 0) {
        return nwd(b, a % b);
    }
    return a;
}