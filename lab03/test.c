#include<stdio.h>

int potencia(int base, int expoente) {
    int n = 1;
    for (int i=1; i <= expoente; i++) {
        n = n*base;
    }
    return n;
}

int str_dec(char str[20]) {
    int n = 0;
    int i = 0;
    int j = 0;
    while (str[j] != '\0') {
        j++;
    }
    if (str[i] != '-') {
        for (i=0; i < j ; i++) {
            n = n + (str[j-i-1] - '0')*potencia(10,i);
        }
    }
    else {
        for (i=0; i < j-1 ; i++) {
            n = n + (str[j-i-1] - '0')*potencia(10,i);
        }
    }
    return n;
}

void limpar_vetor(char vetor[], int len) {
    int i;
    for (i=0; i < len-1; i++) {
        vetor[i] = '0';
    }
    vetor[i] = '\0';
}

void somar_bin(char bin[33]) {
    char carry = '1';
    for (int i=31; i > 0 && carry == '1'; i--) {
        if (bin[i] == '1') {
            bin[i] = '0';
        }
        else {
            bin[i] = '1';
            carry = '0';
        }
    }
}

void complemento_2(char bin[]) {
    for (int i=0; i < 32; i++) {
            if (bin[i] == '1') {
                bin[i] = '0';
            }
            else {
                bin[i] = '1';
            }
        }
        somar_bin(bin);
}

void dec_bin(char bin[33], int dec, int negativo) {
    int base = 2;
    int poten;
    if (negativo != 1) {
        int i;
        while (dec != 0) {
            poten = 1;
            for (i=0; poten*base <= dec; i++) {
                poten = poten*base;
            }
            bin[32-i-1] = '1';
            dec = dec - poten;
        }
    }
    else {
        int i;
        while (dec != 0) {
            poten = 1;
            for (i=0; poten*base <= dec; i++) {
                poten = poten*base;
            }
            bin[32-i-1] = '1';
            dec = dec - poten;
        }
        complemento_2(bin);
    }
}

void bin_hex(char bin[33], char hex[9]) {
    int n;
    limpar_vetor(hex, 9);
    for (int i=0; i < 8; i++) {
        n = 0;
        for (int j=i*4; j-i*4 < 4; j++) {
            n = n + (bin[j] - '0')*potencia(2, i*4+3-j);
        }
        if (n >= 10) {
            hex[i] = n + 'W';
        }
        else {
            hex[i] = n + '0';
        }
    }
}

void rm_bytes(char bytes[], int len) {
    int j = 0;
    int posic = 0;
    for (int i=0; i < len; i++) {
        if (j == 1) {
            bytes[posic] = bytes[i];
            posic++;
        }
        else if ((bytes[i] != '0') && (j == 0)) {
            j = 1;
            bytes[posic] = bytes[i];
            posic++;
        }
    }

    bytes[posic] = '\0';
}

int bin_dec(char bin[33]) {
    int n=0;
    for (int i=31; i > -1; i--) {
        n = n + (bin[i] - '0')*potencia(2,31-i);
    }
    return n;
}

int hex_endian(char hex[9]) {
    int n = 0;
    int conv_1, conv_2;
    for (int i=7; i > 0; i = i-2) {
        if (hex[i] >= 'a' && hex[i-1] >= 'a') {
            conv_1 = (hex[i-1] - 'W')*potencia(16,i);
            conv_2 = (hex[i] - 'W')*potencia(16,i-1);
            n = n + conv_1 + conv_2;
        }
        else if (hex[i] >= 'a' && hex[i-1] < 'a') {
            conv_1 = (hex[i-1] - '0')*potencia(16,i);
            conv_2 = (hex[i] - 'W')*potencia(16,i-1);
            n = n + conv_1 + conv_2;
        }
        else if (hex[i] < 'a' && hex[i-1] >= 'a') {
            conv_1 = (hex[i-1] - 'W')*potencia(16,i);
            conv_2 = (hex[i] - '0')*potencia(16,i-1);
            n = n + conv_1 + conv_2;
        }
        else {
            conv_1 = (hex[i-1] - '0')*potencia(16,i);
            conv_2 = (hex[i] - '0')*potencia(16,i-1);
            n = n + conv_1 + conv_2;
        }
    }
    return n;
}

int hex_dec(char hex[9]) {
    int n = 0;
    for (int i=7; i > 0; i--) {
        if (hex[i] >= 'a') {
            n = n + (hex[i] - 'W')*potencia(16,7-i);
        }
        else {
            n = n + (hex[i] - '0')*potencia(16,7-i);
        }
    }
    return n;
}

int tamanho_vetor(char vetor[]) {
    int tam = 0;
    while (vetor[tam] != '\0') {
        tam++;
    }
    return tam;
}

void hex_bin(char hex[9], char bin[33]) {
    int dec;
    for (int i=7; i > -1; i--) {
        if (hex[i] >= 'a') {
            dec = (hex[i]-'W')*potencia(16, 7-i);
            dec_bin(bin, dec, 0);
        }
        else {
            dec = (hex[i]-'0')*potencia(16, 7-i);
            dec_bin(bin, dec, 0);
        }
    }
}

void str_hex(char str[], char hex[]) {
    int tam = tamanho_vetor(str);
    int i, j = 2;
    for (i=0; i < 8; i++) {
        if (8-i > tam-2) {
            hex[i] = '0';
        }
        else {
            hex[i] = str[j];
            j++;
        }
    }
}

void dec_string(int dec, char string[]) {
    int i = 0;
    int negativo = 0;

    if (dec == 0) {
        string[i++] = '0';
        string[i] = '\0';
        return;
    }

    if (dec < 0) {
        negativo = 1;
        dec = -dec;
    }

    while (dec > 0) {
        int digito = dec % 10;
        string[i++] = '0' + digito;
        dec /= 10;
    }

    if (negativo) {
        string[i++] = '-';
    }

    string[i] = '\0';

    for (int j=0; j < i/2; ++j) {
        char temp = string[j];
        string[j] = string[i-j-1];
        string[i-j-1] = temp;
    }
}

int main() {
    int dec, dec_endian, negativo = 0;
    char str[20];
    char bin[33];
    char hex[9];
    char ini_bin[] = "0b";
    char ini_hex[] = "0x";
    char pula_linha[] = "\n";

    scanf("%s", str);

    if (str[0] == '0') {
        limpar_vetor(hex, 9);
        limpar_vetor(bin, 33);
        str_hex(str,hex);
        dec = hex_dec(hex);
        hex_bin(hex, bin);
        dec_endian = hex_endian(hex);
        rm_bytes(bin, 32);
        rm_bytes(hex, 8);
    }
    else {
        dec = str_dec(str);
        if (str[0] == '-') {
            negativo = 1;
        }
        limpar_vetor(hex, 9);
        limpar_vetor(bin, 33);
        dec_bin(bin, dec, negativo);
        bin_hex(bin, hex);
        dec_endian = hex_endian(hex);
        rm_bytes(bin, 32);
        rm_bytes(hex, 8);
        if (negativo == 1) {
            dec = dec*(-1);
        }
    }
    printf("%s%s%s%d%s%s%s%s%u%s", ini_bin,bin,pula_linha,dec,pula_linha,ini_hex,hex,pula_linha,dec_endian,pula_linha);

    return 0;
}