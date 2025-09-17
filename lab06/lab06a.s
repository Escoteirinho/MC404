read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 1  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall

input_address: .skip 0x10  # buffer

while:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, string       # buffer
    li a2, 19           # size
    li a7, 64           # syscall write (64)
    ecall
string:  .asciz "Hello! It works!!!\n"

string_to_dec:

# Salva o primeiro numero do buffer (primeiros 4 bytes) no registrador a6

    li a6, 0
    li a4, 1000
    lw a5, 0(a1)
    mul a5, a5, a4
    add a6, a6, a5
