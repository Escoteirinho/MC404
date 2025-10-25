.text
.globl middle_value_int
.globl middle_value_short
.globl middle_value_char
.globl value_matrix

middle_value_int:
    li t0, 2
    mul a1, a1, t0      # middle = (n/2)*4 -> n*2 onde 4 é a quantidade de bytes usado por int (word)
    add a0, a0, a1
    lw a0, 0(a0)        # Salva array[middle]
    ret

middle_value_short:
    add a0, a0, a1      # middle = middle = (n/2)*2 -> n onde 2 é a quantidade de bytes usado por short (halfword)
    lh a0, 0(a0)
    ret 

middle_value_char:
    li t0, 2
    div a1, a1, t0      # middle = n/2
    add a0, a0, a1      # Posiciona o array na posição de array[middle]
    lb a0, 0(a0)        # Salva array[middle]
    ret

value_matrix:
    li t0, 4
    mul a1, a1, t0      # Ajusta para o tamanho de int (word) 4 bytes 
    mul a2, a2, t0      # Ajusta para o tamanho de int (word) 4 bytes
    li t0, 42
    mul a1, a1, t0      # Posiciona na linha correta 42*r*4
    add a1, a1, a2      # Posiciona na colula correta
    add a0, a0, a1
    lw a0, 0(a0)
    ret
