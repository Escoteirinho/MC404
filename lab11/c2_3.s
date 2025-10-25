.text
.globl fill_array_int
.globl fill_array_short
.globl fill_array_char

fill_array_int:
    addi sp, sp, -416
    sw ra, 404(sp)
    li t0, 100
    li t1, -1
    mv t3, sp
1:
    beq t1, t0, 2f
    addi t1, t1, 1
    sw t1, 0(t3)
    addi t3, t3, 4
    j 1b
2:
    mv a0, sp
    jal mystery_function_int
    lw ra, 404(sp)
    addi sp, sp, 416
    ret

fill_array_short:
    addi sp, sp, -208
    sw ra, 204(sp)
    li t0, 100
    li t1, -1
    mv t3, sp
1:
    beq t1, t0, 2f
    addi t1, t1, 1
    sw t1, 0(t3)
    addi t3, t3, 2
    j 1b
2:
    mv a0, sp
    jal mystery_function_short
    lw ra, 204(sp)
    addi sp, sp, 208
    ret

fill_array_char:
    addi sp, sp, -112
    sw ra, 108(sp)
    li t0, 100
    li t1, -1
    mv t3, sp
1:
    beq t1, t0, 2f
    addi t1, t1, 1
    sw t1, 0(t3)
    addi t3, t3, 1
    j 1b
2:
    mv a0, sp
    jal mystery_function_char
    lw ra, 108(sp)
    addi sp, sp, 112
    ret