# as -a64 branch_example.s -o branch_example.o
# ld -mel64ppc branch_example.o -o branch_example
# ./branch_example

### ENTRY POINT DECLARATION ###
.section .opd "aw"
.align 3
.globl _start
_start:
	.quad ._start, .TOC.@tocabse, 0

### PROGRAM CODE ###
.text
# branch to target
._start:
	b t2

t1:
# branch to target t3, setting the link register
	bl t3
# this is the instruction that it returns to

t2:
# branch to target t12 as an absolute address
	ba t1

t3:
# branch to the address specified in the link register
# (i.e. the return address)
	blr

t4:
	li 0, 1
	li 3, 0
	sc
