.data
.equ address_car, 0xFFFF0100

.text
.globl _start

_start:
    jal main
    jal exit

exit:
    li  a0, 0
    li  a7, 93
    ecall

main:
    li  t0, 0
    li  a0, address_car
    sb  t0, 0x22(a0)
    li  t0, -15
    sb  t0, 0x20(a0)
loop:
    li  t0, 1
    sb  t0, 0x21(a0)
    lw  a1, 0x10(a0)
    lw  a2, 0x18(a0)
    addi    a1, a1, -73
    addi    a2, a2, 19
    li  t0, 10
    bge a1, t0, loop
    li  t1, -1
    mul a2, a2, t1
    bge a2, t0, loop
    li  t0, 1
    sb  t0, 0x22(a0)
    ret