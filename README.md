# ECE30_nf_hanoi
#include <stdio.h>

int hanoi(int n);
void nf_hanoi(int n, int* src, int* dst);
void move(int* src, int* dst);

int main()
{
    int src = {1, 2, 3};
    int dst = {0, 0, 0};
    nf_hanoi(3, src, dst);
}

int hanoi(int n) {
    if (n == 1) {return 1;}
    else {return 3*hanoi(n-1)+2;}
}

void nf_hanoi(int n, int* src, int* dst) {
    int* tmp;
    
    if(n == 1) {move(src, dst);}
    else {
        nf_hanoi(n-1, src, dst);
        move(src, tmp);
        nf_hanoi(n-1, dst, src);
        move(tmp, dst);
        nf_hanoi(n-1, src, dst);
    }
}

void move(int* src, int* dst){
    int i = 0;
    int j = 0;

    while (src[i] == 0) {
        i++;
    }
    while (dst[j] == 0) {
        j++;
    }
    dst[j-1] = src[i];
    src[i] = 0;
}
