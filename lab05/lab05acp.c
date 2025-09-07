#include <stdio.h>

int potencia(int base, int expoente) {
    int n = 1;
    for (int i=1; i <= expoente; i++) {
        n = n*base;
    }
    return n;
}

int criar_mask(int n_LSB) {
    int mask = 0b01111111111111111111111111111111;
    mask = mask >> (32-n_LSB);
    return mask;
}

int aplicar_mask(int original, int n_LSB) {
    int mask;
    mask = criar_mask(n_LSB);
    original = original & mask;
    return original;
}

int somar_bin(int original, int somar, int final) {
    original = original | (somar << final);
    return original;
}

int conv_string_dec(char str[], int tam) {
    int n = 0;
    int i = 0;
    for (i=0; i < tam-1 ; i++) {
        n = n + (str[tam-i-1] - '0')*potencia(10,i);
    }
    if (str[0] == '-') {
        return n*(-1);
    }
    return n;
}

void hex_code(int val) {
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;

    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\0';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    printf("%s\n", hex);
}

int main () {
    int dec, h = 0,  bin_pack = 0;
    char input[6];
    int LSB[5] = {3,8,5,5,11};
    int final[5] = {0,3,11,16,21};
    for (int i=0; i < 5; i++) {
        scanf("%s", input);
        dec = conv_string_dec(input, 5);
        dec = aplicar_mask(dec, LSB[h]+1);
        bin_pack = somar_bin(bin_pack, dec, final[h]);
        h++;
    }
    printf("%d\n", bin_pack);
    hex_code(bin_pack);
}