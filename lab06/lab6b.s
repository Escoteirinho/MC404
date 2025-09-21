.data
input_address_tempo: .space 20
input_address_posic: .space 12
output: .asciz "S0000 S0000\n"

.text
.globl _start

_start:
    jal main
    jal exit

read:
    li a0, 0                      # file descriptor = 0 (stdin)
    li a7, 63                     # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, output       # buffer
    li a2, 12           # size
    li a7, 64           # syscall write (64)
    ecall
    ret

exit:
    li a0, 0
    li a7, 93
    ecall

registrar:
    addi t0, s3, 0
    sb t0, 3(s1)
    addi s1, s1, -1
    ret

registrar_output: # registra root em output
    lb t0, 0(s1)
    sb t0, 0(s9)
    addi s9, s9, 1
    addi s1, s1, 1
    addi s3, s3, 1
    blt s3, s4, registrar_output
    addi s9, s9, 1
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

string_to_dec:          # Loop que tranforma 4 bytes de s0 em um numero decimal salvando no registrador s6
                        # Supoe que s3 = 0 e s4 = 4
    lb t0, 0(s0)
    li a0, 45
    addi s0, s0, 1
    beq a0, t0, negativo
    li a0, 43
    beq a0, t0, positivo
    addi s0, s0, -1
    j sem_sinal

negativo:
    lb t0, 0(s0)
    addi s2, t0, -48    # Transforma ascii para decimal
    li s5, 0
    sub s7, s4, s3
    addi s7, s7, -1
    addi a0, ra, 0
    jal potencia
    addi ra, a0, 0
    add s6, s6, s2
    addi s0, s0, 1
    addi s3, s3, 1
    blt s3, s4, negativo
    li a0, -1
    mul s6, s6, a0
    ret

positivo:
    lb t0, 0(s0)
    addi s2, t0, -48    # Transforma ascii para decimal
    li s5, 0
    sub s7, s4, s3
    addi s7, s7, -1
    addi a0, ra, 0
    jal potencia
    addi ra, a0, 0
    add s6, s6, s2
    addi s0, s0, 1
    addi s3, s3, 1
    blt s3, s4, positivo
    ret

sem_sinal:
    lb t0, 0(s0)
    addi s2, t0, -48    # Transforma ascii para decimal
    li s5, 0
    sub s7, s4, s3
    addi s7, s7, -1
    addi a0, ra, 0
    jal potencia
    addi ra, a0, 0
    add s6, s6, s2
    addi s0, s0, 1
    addi s3, s3, 1
    blt s3, s4, sem_sinal
    ret


dec_to_string:      # Considera s6 como o decimal a ser convertido para string e registra a saida em output
    li s2, 10
    li s7, 0
    addi s1, s1, 1
    li t0, 45
    sb t0, -1(s1)
    blt s6, s7, negativo_1
    li t0, 43
    sb t0, -1(s1)
    bge s6, s7, positivo_1
    addi s1, s1, -1
    j dec_to_string_unsigned

negativo_1:
    li t0, -1
    mul s6, s6, t0
    j positivo_1

positivo_1:
    addi s3, s6, 0
    rem s3, s3, s2
    addi s3, s3, 48
    addi a0, ra, 0
    jal registrar
    addi ra, a0, 0
    div s6, s6, s2
    bne s6, s7, positivo_1
    ret

dec_to_string_unsigned:
    li s2, 10
    li s7, 0
    addi s3, s6, 0
    rem s3, s3, s2
    addi s3, s3, 48
    addi a0, ra, 0
    jal registrar
    addi ra, a0, 0
    div s6, s6, s2
    bne s6, s7, dec_to_string_unsigned
    ret

calcular_distancias:
    li s2, 3                        # Armazena valor da velocidade
    li s1, 10
    sub a3, a6, a3                  # Armazena Delta_Ta
    sub a4, a6, a4                  # Armazena Delta_Tb
    sub a5, a6, a5                  # Armazena Delta_Tc
    mul a3, a3, s2
    mul a4, a4, s2
    mul a5, a5, s2
    div a3, a3, s1
    div a4, a4, s1
    div a5, a5, s1
    mul a3, a3, a3                  # Distancia Da^2
    mul a4, a4, a4                  # Distancia Db^2
    mul a5, a5, a5                  # Distancia Dc^2
    ret

babylonian_method:
    div s4, s6, a0      # s4 = (quadrado)/k
    add a0, a0, s4     
    div a0, a0, s2      # k' = (k + (quadrado)/k)/2
    addi s7, s7, 1
    bne s7, s5, babylonian_method
    ret

confere_x:
    sub s4, a0, s10
    mul s4, s4, s4
    li t1, -1
    mul a0, a0, t1
    sub s5, a0, s10
    mul s5, s5, s5
    mul t0, a6, a6
    add s4, s4, t0                  # Armazena (x_positivo - Xc)^2 + y^2
    add s5, s5, t0                  # Armazena (x_negativo - Xc)^2 + y^2
    sub s4, s4, a3
    sub s5, s5, a3
    blt s4, s5, x_positivo
    bge s4, s5, x_negativo

x_positivo:                         # Retorna x positivo para s3
    ret

x_negativo:                         # Retorna x negativo para s3
    li t0, -1
    mul s3, s3, t0
    ret

calcula_y:
    mul t0, s9, s9
    add a6, a3, t0
    sub a6, a6, a4
    div a6, a6, s9
    li t0, 2
    div a6, a6, t0                  # Armazena valor de y 
    ret

main:
    la a1, input_address_posic      # buffer to write the data
    li a2, 12                       # size (reads only 1 byte)
    jal read
    la s0, input_address_posic
    li s3, 0
    li s4, 4
    li s6, 0
    jal string_to_dec
    addi s9, s6, 0                  # Armazena valor de Yb
    la s0, input_address_posic
    addi s0, s0, 6
    li s3, 0
    li s4, 4
    li s6, 0
    jal string_to_dec
    addi s10, s6, 0                 # Armazena valor de Xc

    la a1, input_address_tempo      # buffer to write the data
    li a2, 20                       # size (reads only 1 byte)
    jal read
    la s0, input_address_tempo
    li s3, 0
    li s4, 4
    li s6, 0
    jal string_to_dec
    addi a3, s6, 0                  # Armazena valor Ta
    la s0, input_address_tempo
    addi s0, s0, 5
    li s3, 0
    li s4, 4
    li s6, 0
    jal string_to_dec
    addi a4, s6, 0                  # Armazena valor Tb
    la s0, input_address_tempo
    addi s0, s0, 10
    li s3, 0
    li s4, 4
    li s6, 0
    jal string_to_dec
    addi a5, s6, 0                  # Armazena valor Tc
    la s0, input_address_tempo
    addi s0, s0, 15
    li s3, 0
    li s4, 4
    li s6, 0
    jal string_to_dec
    addi a6, s6, 0                  # Armazena valor Tr
    jal calcular_distancias

    jal calcula_y
    li s7, 0
    li s5, 21
    mul t0, a6, a6
    sub s6, a3, t0
    li s2, 2
    div a0, s6, s2                 # k = (quadrado)/2
    jal babylonian_method
    addi s3, a0, 0
    jal confere_x
    la s1, output
    addi s6, s3, 0
    jal dec_to_string
    la s1, output
    addi s1, s1, 6
    addi s6, a6, 0
    jal dec_to_string
    jal write
    ret
