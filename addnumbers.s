# as -a64 addnumbers.s -o addnumbers.o
# ld -mel64ppc addnumbers.o -o addnumbers
# ./addnumbers
# echo $?


### PROGRAM DATA ###
# Create the values in the table of contents
.section .toc
first_value:
	.tc [TC], 1
second_value:
	.tc [TC], 2

### ENTRY POINT DECLARATION ###
.section .opd "aw"
.align 3
.globl _start
_start:
	.quad ._start, .TOC.@tocbase, 0

###CODE###
.text
._start
	## Load the values from the table of contents ##
	ld 4, first_value@toc(2)
	ld 5, second_value@toc(2)

	##Perform addition##
	add 3, 4, 5

	##Exit with status##
	li 0, 1
	sc
