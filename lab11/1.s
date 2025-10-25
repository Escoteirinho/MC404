	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_zicsr2p0_zifencei2p0_zmmul1p0_zaamo1p0_zalrsc1p0"
	.file	"c1_1.c"
	.text
	.globl	increment_my_var                # -- Begin function increment_my_var
	.p2align	2
	.type	increment_my_var,@function
increment_my_var:                       # @increment_my_var
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	lui	a1, %hi(my_var)
	lw	a0, %lo(my_var)(a1)
	addi	a0, a0, 1
	sw	a0, %lo(my_var)(a1)
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
.Lfunc_end0:
	.size	increment_my_var, .Lfunc_end0-increment_my_var
                                        # -- End function
	.type	my_var,@object                  # @my_var
	.data
	.globl	my_var
	.p2align	2, 0x0
my_var:
	.word	10                              # 0xa
	.size	my_var, 4

	.ident	"clang version 20.1.8 (Fedora 20.1.8-4.fc42)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym my_var
