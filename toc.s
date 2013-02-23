
###DATA###

# Create the variable my_var in the table of contents
.section .toc
my_var:
.tc [TC], 10

### ENTRY POINT DECLARATION ###
.section .opd "aw"
.align 3
.globl _start
_start:
	.quad ._start, .TOC.@tocbase, 0

### CODE ###
.text
._start:
	# loads the number 10 (my_var contents) into register 3
	ld 3, my_var@toc(2)
	
	# loads the address of my_var into register 4
	ld 4, my_var@got(2)
	# loads the number 10 (my var contents) into register 4
	ld 3, 0(4)

	# load the number 15 into register 5
	li 5, 15

	# store 15 (register 5) into my_var via ToC
	std 5, 0(4)

	# Exit with status 0
	li 0, 1
	li 3, 0
	sc
