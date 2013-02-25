# as -a64 max_enhanced.s -o max_enhanced.o
# ld -melf64ppc max_enhanced.o -o max_enhanced
# ./max_enhanced

# The loop in this program is approximately 15% faster than the loop in 
# max.s because we shaved off several instructions from the main loop by 
# using the status register to detect the end of the list when we decrement
# register 5 and the program is using different register fields for the 
# comparison (so that the result of the decrement can be held for later)

# Note that using the link register in the call to set_new_maximum is not 
# strictly necessary. It would have worked just as well to set the return 
# address explicitly rather than using the link register. However this gives
# a good example of link register usage. 

###PROGRAM DATA###
.data
.align 3

value_list:
	.quad 23, 50, 95, 96, 37, 85
value_list_end:

# Compute a constant holding the size of the list
.equ value_list_size, value_list_end - value_list

###ENTRY POINT DECLARATION###
.section .opd "aw"
.global _start
.align 3
_start:
	.quad ._start, .TOC.@tocbase, 0
	
###CODE###
._start:
	.equ DATA_SIZE, 8

	#REGISTER USAGE
	#REGISTER 3 -- current maximum
	#REGISTER 4 -- list address
	#REGISTER 5 -- current index
	#REGISTER 6 -- current value
	#REGISTER 7 -- size of data (negative)

	# Load the address of the list
	ld 4, value_list@got(2)
	# Register 7 has data size (negative)
	li 7, -DATA_SIZE
	# Load the size of the list
	li 5, value_list_size
	# Set the "current maximum" to 0
	li 3, 0

loop:
	# Decrement index to the next value; set status register (in cr0)
	add. 5, 5, 7

	# Load value (X-Form - add register 4 + register 5 for final address)
	ldx 6, 4, 5
	
	# Unsigned comparison of current value to current maximum (use cr2)
	cmpld cr2, 6, 3
	
	# If the current one of greater, set it (sets the link register)
	btl 4*cr2+gt, set_new_maximum

	# Loop unless the last index decrement resulted in zero
	bf eq, loop

	# AFTER THE LOOP --exit
	li 0, 1
	sc

set_new_maximum:
	mr 3, 6
	blr (return using the link register)
