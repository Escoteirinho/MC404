.data
input_address: .space 20
output: .asciz "DDDD DDDD DDDD DDDD\n"

.text
.globl _start

_start:
    jal main
    jal exit


registrar:
    lb t0, 0(s0)
    sb t0, 0(s1)
    addi s0, s0, 1
    addi s1, s1, 1
    addi s3, s3, 1
    blt s3, s4, registrar
    ret

potencia: #calcula a potencia de 10^s4 e salva o resultado em s2
    mul s2, s2, 10
    addi s5, s5, 1
    blt s5, s7, potencia
    ret

string_to_dec: 
    /* Loop que tranforma 4 bytes em um numero decimal salvando no registrador s6
    Supoe que s3 é igual a zero e s4 é igual a 4 */
    lb t0, 0(s0)
    addi s2, t0, -48 #Transforma ascii para decimal
    li s5, 0
    sub s7, s4, s3 
    jal potencia
    add s6, s6, s2
    addi s0, s0, 1
    addi s3, s3, 1
    blt s3, s4, string_to_dec

dec_to_string:
    

read:
    li a0, 0  # file descriptor = 0 (stdin)
    la a1, input_address #  buffer to write the data
    li a2, 20  # size (reads only 1 byte)
    li a7, 63 # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output       # buffer
    li a2, 20           # size
    li a7, 64           # syscall write (64)
    ecall
    ret

main:
    jal read
    la s0, input_address
    la s1, output
    li s3, 0
    li s4, 4
    jar string_to_dec
    jal registrar
    jal write
    ret

exit:
    li a0, 0
    li a7, 93
    ecall
