.data
input_address: .space 20
output: .asciz "DDDD DDDD DDDD DDDD\n"
root: .asciz "0000"

.text
.globl _start

_start:
    jal main
    jal exit


registrar_output: # registra root em output
    lb t0, 0(s1)
    sb t0, 0(s9)
    addi s9, s9, 1
    addi s1, s1, 1
    addi s3, s3, 1
    blt s3, s4, registrar_output
    addi s9, s9, 1
    ret

registrar:
    addi t0, s3, 0
    sb t0, 3(s1)
    addi s1, s1, -1
    ret

potencia: # Calcula a potencia de 10^s7 e salva o resultado em s2
    beq s7, s5, expoente_zero
    li s8, 10
    mul s2, s2, s8
    addi s5, s5, 1
    blt s5, s7, potencia
    ret
    
expoente_zero:
    ret

string_to_dec:          # Loop que tranforma 4 bytes em um numero decimal salvando no registrador s6
                        # Supoe que s3 = 0 e s4 = 3
    lb t0, 0(s0)
    addi s2, t0, -48    # Transforma ascii para decimal
    li s5, 0
    sub s7, s4, s3
    addi a0, ra, 0
    jal potencia
    addi ra, a0, 0
    add s6, s6, s2
    addi s0, s0, 1
    addi s3, s3, 1
    blt s3, s4, string_to_dec
    ret

dec_to_string:      # Considera s6 como o decimal a ser convertido para string e registra a saida em output
    li s2, 10
    li s4, 0
    addi s3, s6, 0
    rem s3, s3, s2
    addi s3, s3, 48
    addi a0, ra, 0
    jal registrar
    addi ra, a0, 0
    div s6, s6, s2
    bne s6, s4, dec_to_string
    ret
    
babylonian_method:
    div s4, s6, a0      # s4 = y/k
    add a0, a0, s4     
    div a0, a0, s2      # k' = (k + y/k)/2
    addi s7, s7, 1
    bne s7, s5, babylonian_method
    ret

loop:                   # Calcula a raiz e registra em output
    la s1, root
    li s3, 0
    li s4, 3
    addi a3, ra, 0
    jal string_to_dec
    addi ra, a3, 0
    li s2, 2
    li s5, 10
    li s7, 0
    div a0, s6, s2      # k = y/2
    addi a3, ra, 0
    jal babylonian_method
    addi ra, a3, 0
    addi s6, a0, 0
    addi a3, ra, 0
    jal dec_to_string
    addi ra, a3, 0
    addi s0, s0, 2
    addi s1, s1, 2
    addi a3, ra, 0
    li s3, 0
    li s4, 4
    jal registrar_output
    addi ra, a3, 0
    addi a5, a5, 1
    bne a4, a5, loop
    ret

read:
    li a0, 0                # file descriptor = 0 (stdin)
    la a1, input_address    #  buffer to write the data
    li a2, 20               # size (reads only 1 byte)
    li a7, 63               # syscall read (63)
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
    la s9, output
    li a4, 4
    li a5, 0
    jal loop
    jal write
    ret

exit:
    li a0, 0
    li a7, 93
    ecall
