.bss
isr_stack:                  # Final da pilha das ISRs
.skip   1024
isr_stack_end:              # Base da pilha das ISRs

.data
.globl  _system_time
_system_time:   .word   0
.equ    address_gpt,    0xFFFF0100
.equ    address_midi,   0xFFFF0300

.text
.globl  _start
.globl  play_note

_gpt_interrupt:
# Salva o contexto
    csrrw   sp, mscratch, sp    # Troca sp com mscratch
    addi    sp, sp, -16
    sw  t1, 4(sp)
    sw  t0, 0(sp)
# Incrementa _system_time
    la  t1, _system_time
    lw  t0, 0(t1)
    addi    t0, t0, 100
    sw  t0, 0(t1)
# Configura o GPT
    li  t0, address_gpt
    li  t1, 100
    sw  t1, 0x08(t0)        # Configura o GPT para gerar uma interupção externa apos t1 milissegundos
    li  t1, 1
    sb  t1, 0(t0)           # Ativa o GPT para ler o tempo do sistema atual
# Recupera o contexto
    lw  t0, 0(sp)
    lw  t1, 4(sp)
    addi    sp, sp, 16
    csrrw   sp, mscratch, sp    # Troca sp com mscratch
    mret

_start:
# Registra a ISR em direct mode
    la  t0, _gpt_interrupt
    csrw    mtvec, t0
# Configura mscratch com o topo da pilha das ISRs
    la  t0, isr_stack_end
    csrw    mscratch, t0
# Configura periféricos
    li  t0, address_gpt
    li  t1, 100
    sw  t1, 0x08(t0)        # Configura o GPT para gerar uma interupção externa apos t1 milissegundos
    li  t1, 1
    sb  t1, 0(t0)           # Ativa o GPT para ler o tempo do sistema atual
# Habilitando as interupções externas
    csrr    t1, mie         # Seta o bit 11 (MEIE) do registrador mie
    li  t2, 0x800
    or  t1, t1, t2
    csrw    mie, t1
# Habilita Interrupções Global
    csrr    t1, mstatus     # Seta o bit 3 (MIE) do registrador mstatus
    ori t1, t1, 0x8     
    csrw    mstatus, t1
# Chama a main
    jal main

play_note:
    addi    sp, sp, -16
    sw  a0, 0(sp)
    sw  a1, 4(sp)
    li  a0, address_midi
    sh  a1, 0x02(a0)        # Carrega o ID do instrumento
    sb  a2, 0x04(a0)        # Carrega a nota do instrumento
    sb  a3, 0x05(a0)        # Carrega a velocidade do instrumento
    sh  a4, 0x06(a0)        # Carrega a duração da nota do instrumento
    mv  a1, a0
    lb  a0, 0(sp)
    sb  a0, 0(a1)           # Carrega o canal do instrumento
    lh  a1, 4(sp)
    addi    sp, sp, 16
    ret