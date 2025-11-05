.data
.equ    serial_port, 0xffff0100

.text
.globl  _start

_start:
    jal main
    jal exit

exit:
    li  a0, 0
    li  a7, 93
    ecall

reescrever:
    li  a1, 10              # Armazena o valor de "\n" na tabela ASCII
1:
    li  t0, 1
    sb  t0, 0x02(a0)        # Aciona a leitura da Porta Serial 
2:
    lb  t3, 0x02(a0)
    bne t3, zero, 2b
    lb  t1, 0x03(a0)        # Salva o byte lido pela Porta Serial
    beq t0, zero, 1b
    sb  t1, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    sb  t0, 0(a0)           # Aciona a escrita da Porta Serial
3:
    lb  t0, 0(a0)
    beq t0, zero, 3b
    bne t1, a1, 1b
    ret

reescrever_inverso:
    li  a1, 0               # Armazena o espaço utilizado na pilha
    li  a2, 10              # Armazena o valor de "\n" na tabela ASCII
1:
    addi    sp, sp, -1
    addi    a1, a1, 1
    li  t0, 1
    sb  t0, 0x02(a0)        # Aciona a leitura da Porta Serial 
    lb  t1, 0x03(a0)        # Salva o byte lido pela Porta Serial
    beq t1, a2, 2f
    sb  t1, 0(sp)           # Carrega o byte a ser escrito pela Porta Serial na pilha
    j 1b
2:
    li  t0, 1
    sb  t1, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    lb  t0, 0(a0)           # Aciona a escrita da Porta Serial
    addi    sp, sp, 1
    addi    a1, a1, -1
    bne a1, zero, 2b
    sb  a2, 0x01(a0)        # Carrega o "\n" a ser escrito pela Porta Serial
    lb  t0, 0(a0)           # Aciona a escrita da Porta Serial
    ret

potencia:                   # Calcula a potencia de 10^a0
    li  a1, 1
    li  a2, 10
    li  a3, 0
1:
    beq a0, a3, expoente_zero
    mul a1, a1, a2
    addi    a3, a3, 1
    blt a3, a0, 1b
    mv  a0, a1
    ret
    
expoente_zero:
    li a0, 1
    ret

string_to_dec:
    mv  a6, ra
    li  a4, 0
    mv  a5, a1
1:
    beq a5, zero, 2f
    lb  a0, 0(sp)
    addi    a0, a0, -48
    jal potencia
    add     a4, a4, a0
    addi    a5, a5, -1
    addi    sp, sp, 1
    j   1b
2:
    mv  ra, a6
    mv  a0, a4
    ret

converter_hexa:
    li  a1, 0               # Armazena o espaço utilizado na pilha
    li  a2, 10              # Armazena o valor de "\n" na tabela ASCII
1:
    addi    sp, sp, -1
    addi    a1, a1, 1
    li  t0, 1
    sb  t0, 0x02(a0)        # Aciona a leitura da Porta Serial 
    lb  t1, 0x03(a0)        # Salva o byte lido pela Porta Serial
    beq t1, a2, 2f
    sb  t1, 0(sp)           # Carrega o byte a ser escrito pela Porta Serial na pilha
    j   1b
2:
    mv  a7, ra
    jal string_to_dec
    mv  ra, a7
    mv  a7, a0
    li  a1, 0
    li  a2, 16
    li  a3, 10
3:
    rem a4, a7, a2
    blt a4, a3, 4f
    addi    a4, a4, 39
4:
    addi    a4, a4, 48
    addi    sp, sp, -1
    addi    a1, a1, 1
    sb  a4, 0(sp)
    div a7, a7, a2
    bne a7, zero, 3b
    li  a0, serial_port
5:
    li  t0, 1
    lb  t1, 0(sp)
    addi    sp, sp, 1
    addi    a1, a1, -1
    sb  t1, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    lb  t0, 0(a0)           # Aciona a escrita da Porta Serial
    bne a1, zero, 5b
    sb  a3, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    lb  t0, 0(a0)           # Aciona a escrita da Porta Serial
    ret

operacao_math:
    li  a1, 0               # Armazena o espaço utilizado na pilha
    li  a2, 48              # Armazena o valor de "0" na tabela ASCII
1:
    addi    sp, sp, -1
    addi    a1, a1, 1
    li  t0, 1
    sb  t0, 0x02(a0)        # Aciona a leitura da Porta Serial 
    lb  t1, 0x03(a0)        # Salva o byte lido pela Porta Serial
    bge t1, a2, 2f
    sb  t1, 0(sp)           # Carrega o byte a ser escrito pela Porta Serial na pilha
    j   1b
2:
    mv  a7, ra
    jal string_to_dec
    mv  ra, a7
    mv  a7, a0              # Salva o primeiro numero da operação em um registrador seguro
    li a0, serial_port
    li  t0, 1
    sb  t0, 0x02(a0)        # Aciona a leitura da Porta Serial 
    lb  t1, 0x03(a0)        # Salva o byte de operação lido pela Porta Serial
    mv  a3, t1              # Salva o byte de operação em um registrador seguro
    li  a1, 0               # Armazena o espaço utilizado na pilha
    li  a2, 10              # Armazena o valor de "\n" na tabela ASCII
3:
    addi    sp, sp, -1
    addi    a1, a1, 1
    li  t0, 1
    sb  t0, 0x02(a0)        # Aciona a leitura da Porta Serial 
    lb  t1, 0x03(a0)        # Salva o byte lido pela Porta Serial
    bge t1, a2, 4f
    sb  t1, 0(sp)           # Carrega o byte a ser escrito pela Porta Serial na pilha
    j   3b
4:
    mv  s1, ra
    jal string_to_dec
    mv  ra, s1
    li  t0, 43
    beq t0, a3, soma
    li  t0, 45
    beq t0, a3, subtracao
    li  t0, 42
    beq t0, a3, multiplicacao
    j   divisao
soma:
    add a7, a7, a0
    li  a1, 0
    li  a2, 10
    j   5f
subtracao:
    sub a7, a7, a0
    li  a1, 0
    li  a2, 10
    j   5f
multiplicacao:
    mul a7, a7, a0
    li  a1, 0
    li  a2, 10
    j   5f
divisao:
    div a7, a7, a0
    li  a1, 0
    li  a2, 10
    j   5f
5:
    rem a4, a7, a2
    addi    a4, a4, 48
    addi    sp, sp, -1
    addi    a1, a1, 1
    sb  a4, 0(sp)
    div a7, a7, a2
    bne a7, zero, 5b
    li  a0, serial_port
5:
    li  t0, 1
    lb  t1, 0(sp)
    addi    sp, sp, 1
    addi    a1, a1, -1
    sb  t1, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    lb  t0, 0(a0)           # Aciona a escrita da Porta Serial
    bne a1, zero, 5b
    sb  a3, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    lb  t0, 0(a0)           # Aciona a escrita da Porta Serial
    ret

main:
    li  t0, 1
    li  a0, serial_port
    sb  t0, 0x02(a0)
1:
    lb  t3, 0x02(a0)
    bne t3, zero, 1b
    lb  a1, 0x03(a0)
    beq a1, zero, main
    addi    a1, a1, -48
2:
    sb  t0, 0x02(a0)
    lb  t3, 0x02(a0)
    bne t3, zero, 2b
    beq a1, t0, reescrever
    li  t0, 2
    beq a1, t0, reescrever_inverso
    li  t0, 3
    beq a1, t0, converter_hexa
    li  t0, 4
    beq a1, t0, operacao_math
    
    