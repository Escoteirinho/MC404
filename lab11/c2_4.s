.text
.globl node_op
node_op:
    li t1, 0
    lw t0, 0(a0)
    add t1, t1, t0
    lb t0, 4(a0)
    add t1, t1, t0
    lb t0, 5(a0)
    sub t1, t1, t0
    lh t0, 6(a0)
    add t1, t1, t0
    mv a0, t1
    ret