int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall read code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

#define STDIN_FD  0
#define STDOUT_FD 1

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
    while (str[j] != '\n') {
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

unsigned int hex_endian(char hex[9]) {
    unsigned int n = 0;
    unsigned int conv_1, conv_2;
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
    while ((vetor[tam] != '\0') && (vetor[tam] != '\n')) {
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

void dec_string(int dec, char string[], int negativo) {
    int i = 0;

    if (dec == 0) {
        string[i++] = '0';
        string[i] = '\0';
        return;
    }

    while (dec > 0) {
        int digito = dec % 10;
        string[i++] = '0' + digito;
        dec /= 10;
    }

    if (negativo == 1) {
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
    int dec, n, negativo = 0;
    unsigned int dec_endian;
    char str[20];
    char bin[33];
    char hex[9];
    char ini_bin[] = "0b";
    char ini_hex[] = "0x";
    char pula_linha[] = "\n";
    char string_dec[20], string_endian[9];
    
    read(STDIN_FD, str, 20);

    if (str[0] == '0') {
        limpar_vetor(hex, 9);
        limpar_vetor(string_dec, 20);
        limpar_vetor(string_endian, 9);
        limpar_vetor(bin, 33);
        str_hex(str,hex);
        dec = hex_dec(hex);
        hex_bin(hex, bin);
        dec_endian = hex_endian(hex);
    }
    else {
        dec = str_dec(str);
        if (str[0] == '-') {
            negativo = 1;
        }
        limpar_vetor(hex, 9);
        limpar_vetor(bin, 33);
        limpar_vetor(string_dec, 20);
        limpar_vetor(string_endian, 9);
        dec_bin(bin, dec, negativo);
        bin_hex(bin, hex);
        dec_endian = hex_endian(hex);
    }

    rm_bytes(bin, 32);
    write(STDOUT_FD, ini_bin, 2);
    n = tamanho_vetor(bin);
    write(STDOUT_FD, bin, n);
    write(STDOUT_FD, pula_linha, 1);
    dec_string(dec, string_dec, negativo);
    n = tamanho_vetor(string_dec);
    write(STDOUT_FD, string_dec, n);
    write(STDOUT_FD, pula_linha, 1);
    write(STDOUT_FD, ini_hex, 2);
    rm_bytes(hex, 8);
    n = tamanho_vetor(hex);
    write(STDOUT_FD, hex, n);
    write(STDOUT_FD, pula_linha, 1);
    dec_string(dec_endian, string_endian, 0);
    n = tamanho_vetor(string_endian);
    write(STDOUT_FD, string_endian, n);
    write(STDOUT_FD, pula_linha, 1);

    return 0;
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (93) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}