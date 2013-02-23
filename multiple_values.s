### Data ###
.data
first_value:
	# using "long" instead of "double" because
	# the "multiple" instruction only operates 
	# on 32-bits
	.long 1
second_value:
	.long 2

### ENTRY POINT DECLARATION ###
.section .opd "aw"
.align 3
.globl _start
_start:
	.quad ._start, .TOC.@tocbase, 0

### CODE ###
.text
._start
	# Load the address of our data from the GOT
	ld 7, first_value@got(2)
	
	# Load the values of the data into regsiters 30 and 31
	lmw 30, 0(7)

	# add the values together
	add 3, 30, 31
	
	# exit
	li 0, 1
	sc
