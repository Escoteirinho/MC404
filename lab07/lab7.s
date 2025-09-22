.data
input_address_hamming: .space 8
input_address_bits: .space 5
hamming: .asciz "DDDDDDD\n"
decodificado: .asciz "DDDD\n"
num_erros: .asciz "D\n"

.text
.globl _start

_start:
    jal main
    jal exit

read:
    li a0, 0            # file descriptor = 0 (stdin)
    li a7, 63           # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    li a7, 64           # syscall write (64)
    ecall
    ret

exit:
    li a0, 0
    li a7, 93
    ecall

potencia:               # Calcula a potencia de s8^s7 e salva o resultado em s2
    beq s7, s5, expoente_zero
    li s8, 2
    mul s2, s2, s8
    addi s5, s5, 1
    blt s5, s7, potencia
    ret

expoente_zero:
    ret

string_to_dec:          # Loop que tranforma 4 bytes de s0 em um numero decimal salvando no registrador s6
                        # Supoe que s3 = 0 e s4 = 4
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
    blt s3, s4, string_to_dec
    ret

paridade_1:             # Retorna uma mascara armazenada em s2 de acordo com qual deve ser a paridade de p1
    and s2, s6, 1
    and s3, s6, 4
    or s2, s2, s3 
    and s3, s6, 8
    or s2, s2, s3
    li s4, 1
    beq s2, s4, retornar_p1
    li s4, 4
    beq s2, s4, retornar_p1
    li s4, 8
    beq s2, s4, retornar_p1
    li s4, 13
    beq s2, s4, retornar_p1
    li s2, 0
    ret

retornar_p1:
    li s2, 64           # Paridade 1 para p1
    ret

paridade_2:             # Retorna uma mascara armazenada em s2 de acordo com qual deve ser a paridade de p2
    and s2, s6, 1
    and s3, s6, 2
    or s2, s2, s3 
    and s3, s6, 8
    or s2, s2, s3
    li s4, 1
    beq s2, s4, retornar_p2
    li s4, 2
    beq s2, s4, retornar_p2
    li s4, 8
    beq s2, s4, retornar_p2
    li s4, 11
    beq s2, s4, retornar_p2
    li s2, 0
    ret

retornar_p2:
    li s2, 32           # Paridade 1 para p2
    ret

paridade_3:             # Retorna uma mascara armazenada em s2 de acordo com qual deve ser a paridade de p3
    andi s2, s6, 7 
    li s4, 1
    beq s2, s4, retornar_p3
    li s4, 2
    beq s2, s4, retornar_p3
    li s4, 4
    beq s2, s4, retornar_p3
    li s4, 7
    beq s2, s4, retornar_p3
    li s2, 0
    ret

retornar_p3:
    li s2, 8            # Paridade 1 para p3
    ret

registrar:
    addi t0, s2, 0
    sb t0, 6(s1)
    addi s1, s1, -1
    ret

dec_to_string:
    slli s3, s3, 1
    and s2, s3, s9
    beq s2, s6, registra_0
    addi s6, s2, 0
    li s2, 49
    j registrar

registra_0:
    addi s6, s2, 0
    li s2, 48
    j registrar

aux_dec_to_string:
    addi a0, ra, 0
    jal dec_to_string
    addi ra, a0, 0
    addi s5, s5, 1
    blt s5, s7, aux_dec_to_string
    ret

registrar_decod:
    addi t0, s2, 0
    sb t0, 3(s1)
    addi s1, s1, -1
    ret

dec_to_string_decod:
    slli s3, s3, 1
    and s2, s3, s9
    beq s2, s6, registra_0_decod
    addi s6, s2, 0
    li s2, 49
    j registrar_decod

registra_0_decod:
    addi s6, s2, 0
    li s2, 48
    j registrar_decod

aux_dec_to_string_decod:
    addi a0, ra, 0
    jal dec_to_string_decod
    addi ra, a0, 0
    addi s5, s5, 1
    blt s5, s7, aux_dec_to_string_decod
    ret

decodificacao:
    andi s3, s6, 7
    andi s7, s6, 16
    srli s7, s7, 1
    or s3, s3, s7
    ret

testar_paridade_1:
    andi s3, s11, 64     # Mask p1
    srli s3, s3, 6
    andi s4, s11, 16     # Mask d1
    srli s4, s4, 4
    xor s3, s3, s4
    andi s4, s11, 4      # Mask d2
    srli s4, s4, 2
    xor s3, s3, s4
    andi s4, s11, 1      # Mask d4
    xor s3, s3, s4
    li t0, 0
    bne s3, t0, paridade_errada
    li s2, 48
    ret

paridade_errada:
    li s2, 49
    ret

testar_paridade_2:
    andi s3, s11, 32     # Mask p2
    srli s3, s3, 5
    andi s4, s11, 16     # Mask d1
    srli s4, s4, 4
    xor s3, s3, s4
    andi s4, s11, 2      # Mask d3
    srli s4, s4, 1
    xor s3, s3, s4
    andi s4, s11, 1      # Mask d4
    xor s3, s3, s4
    li t0, 0
    bne s3, t0, paridade_errada
    li s2, 48
    ret

testar_paridade_3:
    andi s3, s11, 8      # Mask p3
    srli s3, s3, 3
    andi s4, s11, 4      # Mask d2
    srli s4, s4, 2
    xor s3, s3, s4
    andi s4, s11, 2      # Mask d3
    srli s4, s4, 1
    xor s3, s3, s4
    andi s4, s11, 1      # Mask d4
    xor s3, s3, s4
    li t0, 0
    bne s3, t0, paridade_errada
    li s2, 48
    ret

main:
    la a1, input_address_bits
    li a2, 5
    jal read
    la s0, input_address_bits
    li s3, 0
    li s4, 4
    jal string_to_dec
    addi s10, s6, 0     # Armazena valor decimal da primeira entrada
    addi s9, s6, 0
    andi s9, s9, 7
    jal paridade_1
    or s9, s9, s2
    jal paridade_2
    or s9, s9, s2
    jal paridade_3
    or s9, s9, s2
    slli s6, s6, 1
    and s6, s6, 16
    or s9, s9, s6
    li s5, 0
    li s7, 7
    la s1, hamming
    addi s6, s9, 0
    li s3, -1
    jal aux_dec_to_string
    la a1, hamming
    li a2, 8
    jal write

    la a1, input_address_hamming
    li a2, 8
    jal read
    la s0, input_address_hamming
    li s3, 0
    li s4, 7
    li s6, 0
    jal string_to_dec
    jal decodificacao
    addi s11, s6, 0     # Armazena valor decimal da segunda entrada
    addi s9, s3, 0
    li s5, 0
    li s7, 4
    la s1, decodificado
    li s3, -1
    addi s6, s9, 0
    jal aux_dec_to_string_decod
    la a1, decodificado
    li a2, 5
    jal write

    jal testar_paridade_1
    addi s5, s2, 0
    jal testar_paridade_2
    or s5, s2, s5
    jal testar_paridade_3
    or s5, s2, s5 
    la s1, num_erros
    sb s5, 0(s1)
    la a1, num_erros
    li a2, 2
    jal write
    ret
