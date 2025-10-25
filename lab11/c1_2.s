.text
.globl my_function
my_function:
    add sp, sp, -16
    sw ra, 8(sp)
    sw a1, 4(sp)            # Salva b
    sw a0, 0(sp)            # Salva a
    add a0, a0, a1          # a + b
    lw a1, 0(sp)            # Recupera a
    jal mystery_function    # mystery_function(a+b, a)
    lw a1, 4(sp)            # Recupera b
    sub a0, a1, a0          # b - mystery_function(a+b, a)
    add a0, a0, a2          # aux = b - mystery_function(a+b, a) + c
    sw a0, 12(sp)           # Salva aux na pilha
    lw a1, 4(sp)            # Recupera b
    jal mystery_function    # mystery_function(aux, b)
    sub a0, a2, a0          # c - mystery_function(aux, b)
    lw a1, 12(sp)           # Recupera aux
    add a0, a0, a1          # return c - mystery_function(aux, b) + aux
    lw ra, 8(sp)
    addi sp, sp, 16
    ret





