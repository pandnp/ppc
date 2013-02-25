###ENTRY POINT DECLARATION###
# Functions require entry point declarations as well
.section .opd "aw"
.global find_maximum_value
.align 3
find_maximum_value:
	.quad .find_maximum_value, .TOC.@tocbase, 0

###CODE###
.text
.align 3

# size of array members
.equ DATA_SIZE, 8

# function begin
.find_maximum_value:
	# REGISTER USAGE
	# REGISTER 3 -- list address
	# REGISTER 4 -- list size (elements)
	# REGISTER 5 -- current index in bytes (starts as list size in bytes)
	# REGISTER 6 -- current value
	# REGISTER 7 -- current maximum
	# REGISTER 8 -- size of data

	# Register 3 and 4 are already loaded -- passes in from calling function
	li 8, -DATA_SIZE

	# Extend the number of elements to the size of the array
	# (shiftign to multiply by 8)
	sldi 5, 4, 3

	# Set current maximum to 0
	li, 7, 0

loop:
	# Go to the next value; set status register (in cr0)
	add. 5, 5, 8

	# Load Value (X-Form - adds reg. 3 + reg. 5 to get the final address)
	ldx 6, 3, 5

	# Unsigned comparison of current value to current maximum (use cr7)
	cmpld cr7, 6, 7

	# if the current one is greater, set it
	bt 4*cr7+gt, set_new_maximum

set_new_maximum_ret:

	# Loop unless the last index decrement resulted in zero
	bf eq, loop

	#AFTER THE LOOP
	mr 3, 7

	#return
	blr

set_new_maximum:
	mr 7, 6
	b set_new_maximum_ret
