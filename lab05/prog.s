	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	.file	"lab05a.c"
	.text
	.globl	read                            # -- Begin function read
	.p2align	2
	.type	read,@function
read:                                   # @read
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall read code (63) 
	ecall	# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	sw	a3, -28(s0)                     # 4-byte Folded Spill
	lw	a0, -28(s0)                     # 4-byte Folded Reload
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read
                                        # -- End function
	.globl	write                           # -- Begin function write
	.p2align	2
	.type	write,@function
write:                                  # @write
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 64	# syscall write (64) 
	ecall
	#NO_APP
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write
                                        # -- End function
	.globl	potencia                        # -- Begin function potencia
	.p2align	2
	.type	potencia,@function
potencia:                               # @potencia
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 1
	sw	a0, -20(s0)
	sw	a0, -24(s0)
	j	.LBB2_1
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	lw	a1, -24(s0)
	lw	a0, -16(s0)
	blt	a0, a1, .LBB2_4
	j	.LBB2_2
.LBB2_2:                                #   in Loop: Header=BB2_1 Depth=1
	lw	a0, -20(s0)
	lw	a1, -12(s0)
	mul	a0, a0, a1
	sw	a0, -20(s0)
	j	.LBB2_3
.LBB2_3:                                #   in Loop: Header=BB2_1 Depth=1
	lw	a0, -24(s0)
	addi	a0, a0, 1
	sw	a0, -24(s0)
	j	.LBB2_1
.LBB2_4:
	lw	a0, -20(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end2:
	.size	potencia, .Lfunc_end2-potencia
                                        # -- End function
	.globl	criar_mask                      # -- Begin function criar_mask
	.p2align	2
	.type	criar_mask,@function
criar_mask:                             # @criar_mask
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lui	a0, 524288
	addi	a0, a0, -1
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	lw	a1, -12(s0)
	neg	a1, a1
	sra	a0, a0, a1
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end3:
	.size	criar_mask, .Lfunc_end3-criar_mask
                                        # -- End function
	.globl	aplicar_mask                    # -- Begin function aplicar_mask
	.p2align	2
	.type	aplicar_mask,@function
aplicar_mask:                           # @aplicar_mask
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a0, -16(s0)
	call	criar_mask
	sw	a0, -20(s0)
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	and	a0, a0, a1
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end4:
	.size	aplicar_mask, .Lfunc_end4-aplicar_mask
                                        # -- End function
	.globl	somar_bin                       # -- Begin function somar_bin
	.p2align	2
	.type	somar_bin,@function
somar_bin:                              # @somar_bin
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	lw	a2, -20(s0)
	sll	a1, a1, a2
	or	a0, a0, a1
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	somar_bin, .Lfunc_end5-somar_bin
                                        # -- End function
	.globl	conv_string_dec                 # -- Begin function conv_string_dec
	.p2align	2
	.type	conv_string_dec,@function
conv_string_dec:                        # @conv_string_dec
# %bb.0:
	addi	sp, sp, -48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 48
	sw	a0, -16(s0)
	sw	a1, -20(s0)
	li	a0, 0
	sw	a0, -24(s0)
	sw	a0, -28(s0)
	sw	a0, -28(s0)
	j	.LBB6_1
.LBB6_1:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -28(s0)
	lw	a1, -20(s0)
	addi	a1, a1, -1
	bge	a0, a1, .LBB6_4
	j	.LBB6_2
.LBB6_2:                                #   in Loop: Header=BB6_1 Depth=1
	lw	a0, -24(s0)
	sw	a0, -32(s0)                     # 4-byte Folded Spill
	lw	a2, -16(s0)
	lw	a0, -20(s0)
	lw	a1, -28(s0)
	sub	a0, a0, a1
	add	a0, a0, a2
	lbu	a0, -1(a0)
	addi	a0, a0, -48
	sw	a0, -36(s0)                     # 4-byte Folded Spill
	li	a0, 10
	call	potencia
	lw	a1, -36(s0)                     # 4-byte Folded Reload
	mv	a2, a0
	lw	a0, -32(s0)                     # 4-byte Folded Reload
	mul	a1, a1, a2
	add	a0, a0, a1
	sw	a0, -24(s0)
	j	.LBB6_3
.LBB6_3:                                #   in Loop: Header=BB6_1 Depth=1
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB6_1
.LBB6_4:
	lw	a0, -16(s0)
	lbu	a0, 0(a0)
	li	a1, 45
	bne	a0, a1, .LBB6_6
	j	.LBB6_5
.LBB6_5:
	lw	a1, -24(s0)
	li	a0, 0
	sub	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB6_7
.LBB6_6:
	lw	a0, -24(s0)
	sw	a0, -12(s0)
	j	.LBB6_7
.LBB6_7:
	lw	a0, -12(s0)
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
.Lfunc_end6:
	.size	conv_string_dec, .Lfunc_end6-conv_string_dec
                                        # -- End function
	.globl	hex_code                        # -- Begin function hex_code
	.p2align	2
	.type	hex_code,@function
hex_code:                               # @hex_code
# %bb.0:
	addi	sp, sp, -48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 48
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	sw	a0, -28(s0)
	li	a0, 48
	sb	a0, -23(s0)
	li	a0, 120
	sb	a0, -22(s0)
	li	a0, 0
	sb	a0, -13(s0)
	li	a0, 9
	sw	a0, -36(s0)
	j	.LBB7_1
.LBB7_1:                                # =>This Inner Loop Header: Depth=1
	lw	a0, -36(s0)
	li	a1, 2
	blt	a0, a1, .LBB7_7
	j	.LBB7_2
.LBB7_2:                                #   in Loop: Header=BB7_1 Depth=1
	lw	a0, -28(s0)
	andi	a0, a0, 15
	sw	a0, -32(s0)
	lw	a0, -32(s0)
	li	a1, 10
	bltu	a0, a1, .LBB7_4
	j	.LBB7_3
.LBB7_3:                                #   in Loop: Header=BB7_1 Depth=1
	lw	a0, -32(s0)
	addi	a0, a0, 55
	lw	a2, -36(s0)
	addi	a1, s0, -23
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB7_5
.LBB7_4:                                #   in Loop: Header=BB7_1 Depth=1
	lw	a0, -32(s0)
	addi	a0, a0, 48
	lw	a2, -36(s0)
	addi	a1, s0, -23
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	.LBB7_5
.LBB7_5:                                #   in Loop: Header=BB7_1 Depth=1
	lw	a0, -28(s0)
	srli	a0, a0, 4
	sw	a0, -28(s0)
	j	.LBB7_6
.LBB7_6:                                #   in Loop: Header=BB7_1 Depth=1
	lw	a0, -36(s0)
	addi	a0, a0, -1
	sw	a0, -36(s0)
	j	.LBB7_1
.LBB7_7:
	li	a0, 1
	addi	a1, s0, -23
	li	a2, 11
	call	write
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
.Lfunc_end7:
	.size	hex_code, .Lfunc_end7-hex_code
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   # @main
# %bb.0:
	addi	sp, sp, -80
	sw	ra, 76(sp)                      # 4-byte Folded Spill
	sw	s0, 72(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 80
	li	a0, 0
	sw	a0, -72(s0)                     # 4-byte Folded Spill
	sw	a0, -16(s0)
	sw	a0, -20(s0)
	sb	a0, -22(s0)
	lui	a1, 1
	addi	a1, a1, -1487
	sh	a1, -24(s0)
	lui	a1, 197379
	addi	a1, a1, 45
	sw	a1, -28(s0)
	li	a3, 11
	sw	a3, -32(s0)
	li	a1, 5
	sw	a1, -36(s0)
	sw	a1, -40(s0)
	li	a2, 8
	sw	a2, -44(s0)
	li	a2, 3
	sw	a2, -48(s0)
	li	a4, 21
	sw	a4, -52(s0)
	li	a4, 16
	sw	a4, -56(s0)
	sw	a3, -60(s0)
	sw	a2, -64(s0)
	sw	a0, -68(s0)
	addi	a0, s0, -28
	call	conv_string_dec
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	slli	a2, a1, 2
	addi	a1, s0, -48
	add	a1, a1, a2
	lw	a1, 0(a1)
	addi	a1, a1, 1
	call	aplicar_mask
	sw	a0, -12(s0)
	lw	a0, -20(s0)
	lw	a1, -12(s0)
	lw	a2, -16(s0)
	slli	a3, a2, 2
	addi	a2, s0, -68
	add	a2, a2, a3
	lw	a2, 0(a2)
	call	somar_bin
	sw	a0, -20(s0)
	lw	a0, -20(s0)
	call	hex_code
	lw	a0, -72(s0)                     # 4-byte Folded Reload
	lw	ra, 76(sp)                      # 4-byte Folded Reload
	lw	s0, 72(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 80
	ret
.Lfunc_end8:
	.size	main, .Lfunc_end8-main
                                        # -- End function
	.globl	exit                            # -- Begin function exit
	.p2align	2
	.type	exit,@function
exit:                                   # @exit
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a1, -12(s0)
	#APP
	mv	a0, a1	# return code
	li	a7, 93	# syscall exit (93) 
	ecall
	#NO_APP
.Lfunc_end9:
	.size	exit, .Lfunc_end9-exit
                                        # -- End function
	.globl	_start                          # -- Begin function _start
	.p2align	2
	.type	_start,@function
_start:                                 # @_start
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	call	main
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	exit
.Lfunc_end10:
	.size	_start, .Lfunc_end10-_start
                                        # -- End function
	.type	.L__const.main.input,@object    # @__const.main.input
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__const.main.input:
	.asciz	"-0001\n"
	.size	.L__const.main.input, 7

	.type	.L__const.main.LSB,@object      # @__const.main.LSB
	.section	.rodata,"a",@progbits
	.p2align	2, 0x0
.L__const.main.LSB:
	.word	3                               # 0x3
	.word	8                               # 0x8
	.word	5                               # 0x5
	.word	5                               # 0x5
	.word	11                              # 0xb
	.size	.L__const.main.LSB, 20

	.type	.L__const.main.final,@object    # @__const.main.final
	.p2align	2, 0x0
.L__const.main.final:
	.word	0                               # 0x0
	.word	3                               # 0x3
	.word	11                              # 0xb
	.word	16                              # 0x10
	.word	21                              # 0x15
	.size	.L__const.main.final, 20

	.ident	"clang version 20.1.8 (Fedora 20.1.8-4.fc42)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym write
	.addrsig_sym potencia
	.addrsig_sym criar_mask
	.addrsig_sym aplicar_mask
	.addrsig_sym somar_bin
	.addrsig_sym conv_string_dec
	.addrsig_sym hex_code
	.addrsig_sym main
	.addrsig_sym exit
