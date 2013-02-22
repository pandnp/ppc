# sum-improved.s

# as -a64 sum-improved.s -o sum.o
# ld -mel64ppc sum.o -o sum
# ./sum
# echo $?
# 3

# This code can be found at
# http://www.ibm.com/developerworks/library/l-powasm1/index.html
# A short version of the first program

.section ".opd", "aw"
.align 3
.global _start
_start
	.quad ._start, .TOC.@tocbase, 0
.text
	li 3, 1		# load "1" into register 3
	li 4, 2		# load "2" into register 4
	add 3, 3, 4	# add register 3 to register 4 and sore the result
			# in register 3
	li 0, 1		# laod "1" into register 0 for the system call
	sc
