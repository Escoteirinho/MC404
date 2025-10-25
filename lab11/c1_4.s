.text
.globl operation
operation:
    add a0, a1, a2      # b + c
    sub a0, a0, a5      # b + c - f
    add a0, a0, a7      # b + c - f + h
    lw a1, 8(sp)
    add a0, a0, a1      # b + c - f + h + k
    lw a1, 16(sp)
    sub a0, a0, a1      # b + c - f + h + k - m
    ret