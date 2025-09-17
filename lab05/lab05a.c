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
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}

int main () {
    int dec, h = 0,  bin_pack = 0;
    int x;
    char input[30], num[6];
    int LSB[5] = {3,8,5,5,11};
    int final[5] = {0,3,11,16,21};
    x = read(STDIN_FD, input, 30);
    for (int i=0; i < 30; i++) {
        for (int j=0; input[i] != ' ' && input[i] != '\n'; i++) {
            num[j] = input[i];
            j++;
        }
        dec = conv_string_dec(num, 5);
        dec = aplicar_mask(dec, LSB[h]+1);
        bin_pack = somar_bin(bin_pack, dec, final[h]);
        h++;
    }
    hex_code(bin_pack);
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