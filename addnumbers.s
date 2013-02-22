# as -a64 addnumbers.s -o addnumbers.o
# ld -mel64ppc addnumbers.o -o addnumbers
# ./addnumbers
# echo $?


###DATA DEFINITIONS###
.data
.align 3
first_value:
	.quad 1
second_value:
	.quad 2

###ENTRY POINT DECLARATION###
.section .opd "aw"
.align 3
.globl _start
_start:
	.quad ._start, .TOC.@tocbase, 0

###CODE###
.text
._start
	###LOAD values###
	# Load the address of first_value into register 7 from the global
	# offset table
	ld 7, first_value@got(2)
	# Use the address to load the value of first_value into register 4
	ld 4, 0(7)
	# Load the address of second_value into register 7 from the global
	# offset table
	ld 7, second_value@got(2)
	# Use the address to load the value of second_value into register 5
	ld 5, 0(7)

	##Perform addition##
	add 3, 4, 5

	##Exit with status##
	li 0, 1
	sc
