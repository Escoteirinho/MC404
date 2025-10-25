.text
.globl operation
operation:
    addi sp, sp, -32
    sw ra, 28(sp)
    sw a6, 24(sp)       # Salva g
    sw a0, 20(sp)       # Salva a
    sw a1, 16(sp)       # Salva b
    sw a2, 12(sp)       # Salva c
    sw a3, 8(sp)        # Salva d
    sw a4, 4(sp)        # Salva e
    sw a5, 0(sp)        # Salva f
    lw a0, 52(sp)       # Recupera n
    lw a1, 48(sp)       # Recupera m
    lw a2, 44(sp)       # Recupera l
    lw a3, 40(sp)       # Recupera k
    lw a4, 36(sp)       # Recupera j
    lw a5, 32(sp)       # Recuepera i
    mv a6, a7           # Salva h
    lw a7, 24(sp)       # Recupera g
    jal mystery_function
    lw ra, 28(sp)
    addi sp, sp, 32
    ret