.data
input_file: .asciz "image.pgm"
line_file: .space 262200
input_cabecalho: .space 14

.text
.globl _start

_start:
    jal main
    jal exit

exit:
    li a0, 0
    li a7, 93
    ecall

setPixel: # a0 = x coordinate, a1 = y coordinate, a2: concatenated pixel's colors: R | G | B | A
    addi sp, sp, -16
    sw ra, 0(sp)
    li a7, 2200          # syscall setPixel
    ecall
    lw ra, 0(sp)
    addi sp, sp, 16
    ret

setCanvasSize: # a0: canvas width (value between 0 and 512), a1: canvas height (value between 0 and 512)
    addi sp, sp, -16
    sw ra, 0(sp)
    li a7, 2201          # syscall setCanvasSize
    ecall
    lw ra, 0(sp)
    addi sp, sp, 16
    ret

setScaling: # a0: horizontal scaling, a1: vertical scaling
    addi sp, sp, -16
    sw ra, 0(sp)
    li a7, 2202          # syscall setScaling
    ecall
    lw ra, 0(sp)
    addi sp, sp, 16
    ret

open: # a0: address for the file path
    addi sp, sp, -16
    sw ra, 0(sp)
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # mode
    li a7, 1024          # syscall open
    ecall
    lw ra, 0(sp)
    addi sp, sp, 16
    ret

close:
    addi sp, sp, -16
    sw ra, 0(sp)
    li a7, 57            # syscall close
    ecall
    lw ra, 0(sp)
    addi sp, sp, 16
    ret

read: # a0: file descriptor a1: buffer to write the data, a2: size in bytes
    addi sp, sp, -16
    sw ra, 0(sp)
    li a7, 63           # syscall read
    ecall
    lw ra, 0(sp) 
    addi sp, sp, 16 
    ret 

write: # a1: buffer, a2: size in bytes
    addi sp, sp, -16
    sw ra, 0(sp)
    li a0, 1            # file descriptor = 1 (stdout)
    li a7, 64           # syscall write
    ecall
    lw ra, 0(sp) 
    addi sp, sp, 16 
    ret

final_dimencoes:
    li a3, 48
    li a0, 0
    1:
    addi a1, a1, 1
    lb t0, 0(a1)
    addi a0, a0, 1
    bge t0, a3, 1b
    ret

salvar_dimencao:
    li a3, 48           # valor de 0 tabela ASCII
    li a2, 0
    li a4, -1
    1:
    addi a1, a1, -1
    addi a4, a4, 1
    lb t0, 0(a1)
    addi t0, t0, -48    # Transforma em Decimal
    
    addi sp, sp, -32
    sw ra, 16(sp)      # Salva ra
    sw a1, 8(sp)       # Salva a1: line_file
    sw a2, 4(sp)       # Salva a2: Valor dimencao
    sw a3, 0(sp)       # Salva a3: Valor de zero em ASCII 
    addi a0, a4, 0
    li a3, 0
    li a1, 1
    jal potencia
    mul a0, a0, t0
    lw a3, 0(sp)       # Recupera a3: Valor de zero em ASCII
    lw a2, 4(sp)       # Recupera a2: Valor dimencao
    lw a1, 8(sp)       # Recupera a1: line_file
    lw ra, 16(sp)      # Recupera ra
    addi sp, sp, 32

    add a2, a2, a0
    blt a4, a5, 1b
    addi a0, a2, 0
    ret

potencia: # Calcula a potencia de 10^a0
    beq a0, a3, expoente_zero
    li a2, 10
    mul a1, a1, a2
    addi a3, a3, 1
    blt a3, a0, potencia
    addi a0, a1, 0
    ret
    
expoente_zero:
    li a0, 1
    ret

cal_pgm:                # Determina as coordenadas de x e y, as cores do pixel e chama SetPixel
    li a0, 0
    bne a5, a6, cal_linha
    ret

cal_linha:
    li a2, 0
    bne a0, a4, cal_cinza
    addi a5, a5, 1
    j cal_pgm

cal_cinza:
    addi a1, a1, 1
    lb t0, 0(a1)
    li a3, 32
    beq t0, a3, cal_cinza
    li a3, 10
    beq t0, a3, cal_cinza
    add a7, a7, t0
    slli a7, a7, 8      # Concatenando Blue
    addi a2, a7, 0
    slli a7, a7, 8      # Concatenando Green
    add a2, a2, a7
    slli a7, a7, 8      # Concatenando Red
    add a2, a2, a7
    addi a2, a2, 255    # Adiciona valor de Alfa
    addi sp, sp, -16
    sw ra, 8(sp)        # Salva ra
    sw a0, 4(sp)        # Salva a0: coordenada de x
    sw a1, 0(sp)        # Salva a1: line_file
    addi a1, a5, 0
    jal setPixel
    lw a1, 0(sp)        # Recupera a1
    lw a0, 4(sp)        # Recupera a0
    lw ra, 8(sp)        # Recupera ra
    addi sp, sp, 16
    addi a0, a0, 1
    li a7, 0
    j cal_linha

main:
    la a0, input_file
    jal open
    la a1, line_file
    li a2, 262200
    jal read

    addi sp, sp, -16
    sw a0, 0(sp)        # Salva a0: fd de image.pgm
    addi a1, a1, 2      # pula "magic number"
    jal final_dimencoes
    addi a5, a0, 0
    addi a5, a5, -2
    jal salvar_dimencao
    addi a7, a0, 0      # Salva a largura
    addi a5, a5, 1
    add a1, a1, a5
    jal final_dimencoes
    addi a5, a0, 0
    addi a5, a5, -2
    jal salvar_dimencao
    addi a6, a0, 0      # Salva a altura
    addi a5, a5, 1
    add a1, a1, a5
    addi a0, a7, 0
    sw a7, 8(sp)        # Salva a7: largura
    sw a1, 4(sp)        # Salva a1: line_file
    addi a1, a6, 0
    jal setCanvasSize   # Define o tamanho da tela do Canvas
    lw a0, 0(sp)        # Recupera a0: fd de image.pgm
    lw a1, 4(sp)        # Recupera a1: line_file
    lw a7, 8(sp)        # Recupera a7: largura
    addi sp, sp, 16

    addi a1, a1, 4      # Pula Maxval e espaço
    addi sp, sp, -16
    sw a0, 4(sp)        # Salva a0: fd de image.pgm
    sw a1, 0(sp)        # Salva a1: line_file
    addi a4, a7, 0
    addi a6, a6, 0
    li a7, 0
    li a5, 0
    li a3, 48
    li t1, 0
    jal cal_pgm
    lw a1, 0(sp)        # Recupera a1: line_file
    lw a0, 4(sp)        # Recupera a0: fd de image.pgm
    addi sp, sp, 16
    jal close
    ret