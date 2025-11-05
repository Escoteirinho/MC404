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

main:
# Le e salva na pilha todos os bytes lidos pela porta Serial
    li  t0, 1
    li  a0, serial_port
    li  a1, 10              # Armazena o valor de "\n" na tabela ASCII  
    mv  fp, sp              # Armazena a posição inicial da pilha
    li  a3, 2               # Armazena a quantidade maxima de "\n" durante a leitura 
1:
    sb  t0, 0x02(a0)        # Aciona a leitura da Porta Serial
2:
    lb  t1, 0x02(a0)
    bnez    t1, 2b          # Verifica se a leitura foi concluida
    lb  t1, 0x03(a0)        # Salva o byte armazenado pela Porta Serial
    beqz    t1, 1b          # Verifica se a leitura é vazia
    sb  t1, 0(sp)           # Salva o byte lido na pilha
    addi    sp, sp, -1
    bne t1, a1, 1b          # Verifica se o byte lido é um "\n"
    addi    a3, a3, -1
    bnez    a3, 1b

# Apos a leitura de todos os bytes da Porta Serial
    lb  t1, 0(fp)
    addi    t1, t1, -48     # Converte o numero da tabela ASCII para decimal
    beq t1, t0, reescrever
    li  t0, 2
    beq t1, t0, reescrever_inverso
    li  t0, 3
    beq t1, t0, converter_hexa
    li  t0, 4
    beq t1, t0, operacao_math

reescrever:
    li  a0, serial_port
    mv  a2, fp
    addi    a2, a2, -2
1:
    li  t0, 1
    lb  t1, 0(a2)           # Recupera o primeiro byte
    addi    a2, a2, -1
    sb  t1, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    sb  t0, 0(a0)           # Aciona a escrita da Porta Serial
2:
    lb  t0, 0(a0)           
    bnez    t0, 2b          # Verifica se escrita foi realizada pela Porta Serial
    bne t1, a1, 1b          # Verifica se foi escrito um "\n"
    mv sp, fp
    ret

reescrever_inverso:
    li  a0, serial_port
    addi    sp, sp, 1
1:
    li  t0, 1
    addi    sp, sp, 1
    lb  t1, 0(sp)           # Recupera o primeiro byte
    sb  t1, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    sb  t0, 0(a0)           # Aciona a escrita da Porta Serial
2:
    lb  t0, 0(a0)           
    bnez    t0, 2b          # Verifica se escrita foi realizada pela Porta Serial
    bne t1, a1, 1b          # Verifica se foi escrito um "\n"
    mv sp, fp
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
    li  a5, 0
    li  t2, 1
1:
    addi    sp, sp, 1
    lb  t0, 0(sp)
    li  t1, 45              # Armazena valor de "-" da tabela ASCII
    bne t0, t1, 2f
    li  t2, -1
    j   1b
2:
    li  t1, 48
    blt t0, t1, 3f          # Verifica se o byte lido deve ser convertido (esta dentro do intervalo de 0 a 9)
    mv  a0, a5
    jal potencia
    addi    t0, t0, -48     # Converte o numero da tabela ASCII para decimal
    mul     a0, a0, t0
    add     a4, a4, a0
    addi    a5, a5, 1
    j   1b
3:
    mv  ra, a6
    mv  a0, a4
    mul a0, a0, t2
    ret

converter_hexa:
    mv  a7, ra
    addi    sp, sp, 1
    jal string_to_dec
    mv  ra, a7
    mv  a7, a0
    li  a2, 16
    li  a3, 10
1:
    remu    a4, a7, a2      # Calcula o resto da divisão por 16
    blt a4, a3, 2f          # Verifica se o numero é maior igual a 10, caso seja
    addi    a4, a4, 7       # Soma parcialmente um valor para que a conversão em hexa ocorra corretamente
2:
    addi    a4, a4, 48      # Converte decimal para seu correspondente na tabela ASCII
    addi    sp, sp, -1
    sb  a4, 0(sp)           # Salva o byte na pilha
    divu     a7, a7, a2
    bnez    a7, 1b
    li  a0, serial_port
3:
    li  t0, 1
    lb  t1, 0(sp)
    addi    sp, sp, 1
    sb  t1, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    sb  t0, 0(a0)           # Aciona a escrita da Porta Serial
4:
    lb  t0, 0(a0)           
    bnez    t0, 4b          # Verifica se escrita foi realizada pela Porta Serial
    bne t1, a3, 3b          # Verifica se o byte escrito era um "\n"
    mv sp, fp
    ret

operacao_math:
# Leitura do primeiro numero
    mv  a7, ra
    addi    sp, sp, 1
    jal string_to_dec
    mv  ra, a7
    mv  a7, a0              # Salva o segundo valor
    addi    sp, sp, 1
    lb  s2, 0(sp)           # Salva o operador
# Leitura do segundo numero
    mv  s1, ra
    addi    sp, sp, 1
    jal string_to_dec       # Converte o primeiro valor e o armazena em a0
    mv  ra, s1
    li  t0, 43
    beq t0, s2, soma
    li  t0, 45
    beq t0, s2, subtracao
    li  t0, 42
    beq t0, s2, multiplicacao
    j   divisao
soma:
    add a7, a0, a7
    li  a1, 0
    li  a2, 10
    j   1f
subtracao:
    sub a7, a0, a7
    li  a1, 0
    li  a2, 10
    j   1f
multiplicacao:
    mul a7, a0, a7
    li  a1, 0
    li  a2, 10
    j   1f
divisao:
    div a7, a0, a7
    li  a1, 0
    li  a2, 10
    j   1f
1:
    li  a0, serial_port
    bge a7, zero, 2f
    li  t0, -1
    mul a7, a7, t0
    li  t1, 45
    li  t0, 1
    sb  t1, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    sb  t0, 0(a0)           # Aciona a escrita da Porta Serial
2:
    lb  t0, 0(a0)           
    bnez    t0, 2b          # Verifica se escrita foi realizada pela Porta Serial
3:    
    rem a4, a7, a2          # Calcula o resto da divisão por 10
    addi    a4, a4, 48      # Converte decimal para seu correspondente na tabela ASCII
    addi    sp, sp, -1
    sb  a4, 0(sp)           # Salva o byte na pilha
    div a7, a7, a2
    bnez    a7, 3b
4:
    li  t0, 1
    lb  t1, 0(sp)
    addi    sp, sp, 1
    sb  t1, 0x01(a0)        # Carrega o byte a ser escrito pela Porta Serial
    sb  t0, 0(a0)           # Aciona a escrita da Porta Serial
5:
    lb  t0, 0(a0)           
    bnez    t0, 5b          # Verifica se escrita foi realizada pela Porta Serial
    bne t1, a2, 4b          # Verifica se o byte escrito era um "\n"
    mv sp, fp
    ret
