.data
a: .word    1
b: .word    -2
c: .half    3
d: .half    -4
e: .byte    5
f: .byte    -6
g: .word    7
h: .word    -8
i: .byte    9
j: .byte    -10
k: .half    11
l: .half    -12
m: .word    13
n: .word    -14

.text
.globl operation
operation:
addi sp, sp, -32
sw ra, 28(sp)
lw a0, a
lw a1, b
lh a2, c
lh a3, d
lb a4, e
lb a5, f
lw a6, g
lw a7, h
lb t0, i
sw t0, 0(sp)
lb t0, j
sw t0, 4(sp)
lh t0, k
sw t0, 8(sp)
lh t0, l
sw t0, 12(sp)
lw t0, m
sw t0, 16(sp)
lw t0, n
sw t0, 20(sp)
jal mystery_function
lw ra, 28(sp)
addi sp, sp, 32
ret