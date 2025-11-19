.bss
isr_stack:                  # Final da pilha de interrupções
.skip   1024
isr_stack_end:              # Base da pilha de interrupções
user_stack:                 # Final da pilha do programa do usuario
.skip   1024
user_stack_end:             # Base da pilha do programa do usuario

.data
.equ    address_car,    0xFFFF0100

.text
.align 4

int_handler:
# Determina qual syscall dever ser realizada
    li  t0, 11 
    beq a7, t0, syscall_set_hand_brake

syscall_set_engine_and_steering:
# Salva o contexto
    csrrw   sp, mscratch, sp    # Troca sp com mscratch
    addi    sp, sp, -16
    sw  t0, 4(sp)
# Set a direção do movimento e ângulo do volante
    li  t0, address_car
    sb  a0, 0x21(t0)
    sb  a1, 0x20(t0)
# Ajustando MEPC para retornar de uma chamada de sistema
    csrr t0, mepc               # carrega endereço de retorno (endereço da instrução que invocou a syscall)
    addi t0, t0, 4              # soma 4 no endereço de retorno (para retornar após a ecall)
    csrw mepc, t0               # armazena endereço de retorno de volta no mepc
# Recupera o contexto
    lw  t0, 0(sp)
    addi    sp, sp, 16
    csrrw   sp, mscratch, sp    # Troca sp com mscratch
# Recupera restante do contexto
    mret

syscall_set_hand_brake:
# Salva o contexto
    csrrw   sp, mscratch, sp    # Troca sp com mscratch
    addi    sp, sp, -16
    sw  t0, 4(sp)
# Set freio de mão
    li  t0, address_car
    sb  a0, 0x22(t0)
# Ajustando MEPC para retornar de uma chamada de sistema
    csrr t0, mepc               # carrega endereço de retorno (endereço da instrução que invocou a syscall)
    addi t0, t0, 4              # soma 4 no endereço de retorno (para retornar após a ecall)
    csrw mepc, t0               # armazena endereço de retorno de volta no mepc
# Recupera o contexto
    lw  t0, 0(sp)
    addi    sp, sp, 16
    csrrw   sp, mscratch, sp    # Troca sp com mscratch
# Recupera restante do contexto
    mret

.globl _start
_start:
# Registra o handler interrupts em direct mode
    la  t0, int_handler
    csrw    mtvec, t0
# Configura mscratch com o topo da pilha de interrupções
    la  t0, isr_stack_end
    csrw    mscratch, t0
# Habilitando as interupções externas
    csrr    t1, mie         # Seta o bit 11 (MEIE) do registrador mie
    li  t2, 0x800
    or  t1, t1, t2
    csrw    mie, t1
# Habilita Interrupções Global
    csrr    t1, mstatus     # Seta o bit 3 (MIE) do registrador mstatus
    ori t1, t1, 0x8     
    csrw    mstatus, t1
# Configura a pilha do programa do usuario
    la  sp, user_stack_end
# Muda o codigo para modo de usuario
    csrr t1, mstatus    # Update the mstatus.MPP
    li t2, ~0x1800      # field (bits 11 and 12)
    and t1, t1, t2      # with value 00 (U-mode)
    csrw mstatus, t1
    la t0, user_main    # Loads the user software
    csrw mepc, t0       # entry point into mepc
# Pula para o endereço de user_main
    mret                # PC <= MEPC; mode <= MPP

.globl control_logic
control_logic:
    li a0, 0
    li a7, 11
    ecall
    li a0, 1
    li a1, -15
    li a7, 10
    ecall
    ret

