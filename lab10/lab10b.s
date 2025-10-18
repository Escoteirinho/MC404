.data
buffer: .space 100

.text
.globl recursive_tree_search
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl exit

recursive_tree_search:
    li a3, 0
    li a4, 0
1:
    addi sp, sp, -16
    sw a4, 12(sp)       # Salva a altura correta
    sw a3, 8(sp)        # Salva a altura anterior
    sw a0, 4(sp)        # Salva o nó atual
    sw ra, 0(sp)        # Salva ra
    beq zero, a0, 2f
    addi a3, a3, 1
    lw a2, 0(a0)
    beq a1, a2, 3f
    lw a0, 4(a0)
    jal 1b              # Visita o nó esquerdo
    sw a0, 12(sp)       # Salva nova posição
    mv a4, a0
    lw a0, 4(sp)        # Recupera o no atual
    lw a0, 8(a0)
    jal 1b              # Visita o nó direito
    lw a3, 8(sp)        # Recupera altura anterior
    lw ra, 0(sp)        # Recupera ra
    addi sp, sp, 16
    ret

2:
    lw a0, 12(sp)
    lw ra, 0(sp)
    addi sp, sp, 16
    ret

3:
    mv a0, a3
    lw a3, 8(sp)        # Recupera altura anterior
    lw ra, 0(sp)
    addi sp, sp, 16
    ret

puts:
    lb a2, 0(a0)
    mv a1, a0
    addi a0, a0, 1
    beqz a2, 1f
    addi sp, sp, -16
    sw a0, 0(sp)
    li a0, 1            # file descriptor = 1 (stdout)
    li a2, 1            # size
    li a7, 64           # syscall white (64)
    ecall
    lw a0, 0(sp)
    addi sp, sp, 16
    j puts
1:
    li a1, 10
    sw a1, 0(a0)
    mv a1, a0
    li a0, 1
    li a2, 1
    li a7, 64
    ecall
    ret

gets:
    mv a3, a0
    addi sp, sp, -16
    sw a0, 0(sp)
    li a5, 10           # Salva o valor de "\n" em ASCII para comparação
1:
    li a0, 0            # file descriptor = 0 (stdin)
    la a1, buffer       # buffer
    li a2, 1            # size
    li a7, 63           # syscall read (63)
    ecall
    lw a4, 0(a1)
    beq a4, a5, 2f
    beq a4, zero, 2f
    sw a4, 0(a3)
    addi a3, a3, 1
    addi a1, a1, 1
    j 1b
2:
    lw a0, 0(sp)
    addi sp, sp, 16
    sw zero, 0(a3)
    ret

atoi:
    beqz a0, 4f
    li a2, 32
    li a3, 10
    li a4, 11
    li a5, 12
    li a6, 13
1:
    beqz a0, 4f
    lb a1, 0(a0)
    addi a0, a0, 1
    beq a1, a2, 1b
    beq a1, a3, 1b
    beq a1, a4, 1b
    beq a1, a5, 1b
    beq a1, a6, 1b
    li a4, -1           # Quantidade de digitos no numero a ser convertido para int
    li a5, 0            # Valor da string
    li a7, 0            # Valor do char
    li a6, 0            # Posição do char a ser convertido para int
    li a3, 43           # Salva o valor de "+" em ASCII
    beq a1, a3, 2f      # Verifica se o valor é positivo
    li a3, 45           # Salva o valor de "-" em ASCII
    beq a1, a3, 2f      # Verifica se o valor é negativo
    addi a4, a4, 1
    li a3, 48
    blt a1, a3, 4f      # Veriica se o primeiro digito é menor que "0" em ASCII
    li a3, 58
    bge a1, a3, 4f      # Veriica se o primeiro digito é maior que "9" em ASCII
2:
    lb a1, 0(a0)
    addi a4, a4, 1
    li a3, 48
    blt a1, a3, 3f      # Veriica se o primeiro digito é menor que "0" em ASCII
    li a3, 58
    bge a1, a3, 3f      # Veriica se o primeiro digito é maior que "9" em ASCII
    mv a6, a4
    addi a0, a0, 1
    j 2b
3:
    addi a0, a0, -1
    addi a4, a4, -1
    blt a4, zero, 5f
    lb a1, 0(a0)
    addi sp, sp, -16
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a4, 8(sp)
    sw ra, 12(sp)
    sub a0, a6, a4
    jal potencia
    mv t0, a0
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a4, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    addi a1, a1, -48    # Passa o valor do char em ASCII para decimal
    mul a7, a1, t0      # Multiplica o valor do char por sua potencia
    add a5, a5, a7      # Adiciona o valor do char no inteiro
    j 3b    
4:
    li a0, 0
    ret
5:
    lb a1, 0(a0)
    li a3, 45           # Salva o valor de "-" em ASCII
    beq a1, a3, 6f      # Verifica se o valor é negativo
    mv a0, a5
    ret
6:
    mv a0, a5
    li t0, -1
    mul a0, a0, t0
    ret

potencia:               # Calcula a potencia de 10^a0
    li a1, 1 
    li a2, 10
    li a3, 0
1:
    beq a0, a3, expoente_zero
    mul a1, a1, a2
    addi a3, a3, 1
    blt a3, a0, 1b
    mv a0, a1
    ret
    
expoente_zero:
    li a0, 1
    ret

itoa:
    li a4, 10
    li a3, 0
    mv a5, sp
    mv a6, a1
    bge a0, zero, 2f
1:
    li t0, 16
    beq a2, t0, 2f
    li t0, -1
    mul a0, a0, t0
    li t0, 45
    sw t0, 0(a1)
    addi a1, a1, 1
2:
    remu a3, a0, a2
    blt a3, a4, 3f
    addi a3, a3, 39     # Adiciona um parte do valor para a conversão para ASCII caso o resto seja maior que 9
3:
    addi a3, a3, 48     # Converte de inteiro para ASCII
    div a0, a0, a2
    addi sp, sp, -16
    sw a3, 0(sp)        # Salva o valor na pilha
    bne a0, zero, 2b
4:
    beq a5, sp, 5f
    lw a3, 0(sp)
    sw a3, 0(a1)
    addi sp, sp, 16
    addi a1, a1, 1
    j 4b
5:
    addi a1, a1, 1
    sw zero, 0(a1)
    mv a0, a6
    ret

exit:
    li a0, 0
    li a7, 93
    ecall

