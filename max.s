# as -64 max.s -o max.o
# ld -melf64ppc max.o -o max
# ./max
# echo $?

###PROGRAM DATA###
.data
.align 3
#value_list is the address of the beginning of the list
value_list:
	.quad 23, 50, 95, 96, 37, 85
#value_list_end is the address immediatedly after the list
value_list_end:

##STANDARD ENTRY POINT DECLARATION###
.section "opd", "aw"
.global _start
.align 3
_start:
	.quad ._start, .TOC.@tocbase, 0

###ACTUAL CODE###
.text
._start:

	#REGISTER USE DOCUMENTATION
	# register 3 -- current maximum
	# register 4 -- current value address
	# register 5 -- stop value address
	# register 6 -- current value

	# load the address of value_list into register 4
	lis 	4, value_list@highest
	ori 	4, 4, value_list@higher
	rldicr	4, 4, 32, 31
	oris	4, 4, value_list@h
	ori	4, 4, value_list@l

	#load the address of value_list_end into register 5
	lis 	5, value_list_end@highest
	ori	5, 5, value_list_end@higher
	rldicr	5, 5, 32, 31
	oris	5, 5, value_list_end@h
	ori	5, 5, value_list_end@l

	#initialize register 3 to 0
	li	3, 0

	#MAIN LOOP
loop:
	#compare register 4 to 5
	cpmd 	4, 5
	#if equal branch to end
	beq end

	#load the next value
	ld 	6, 0(4)
	#if reg. 6 is not greater than reg. 4 then brnach to loop_end
	ble 	loop_end

	#otherwise, move register 6 (current) to register 3 (current max)
	mr	3, 6

loop_end:
	#advance pointer to the next value (advances by 8-bytes)
	addi 	4, 4, 8
	#go back to the beginning of loop
	b loop

end:
	# set the system call number
	li 	0, 1
	# register 3 already has the value to exit with
	# signal the system call
	sc

# COMMENTS
# The data section is the same as before, except that we have several values
# after our value_list declaration. Note that this does not change value_list
# at all -- it is still a constant referring to the address of the first data 
# item that immediately follows it. The data after it is using 64-bits
# (signified by .quad) per value. The entry point decalaration is the same as 
# previous.

# In the program itself, one thing to notice is that we documented what we were
# using each register for. This practice will help you immensely to keep track
# of your code. Register 3 is the one we are storing the current maximum_value 
# in, which we initially set to 0. Register 4 contains the address of the next 
# value to load. It starts out at value_list and advances forward by 8 each 
# iteration. Register 5 contains the address immediately following the data in 
# value_list. This allows a simple comparison between 4 and register 5 to know
# when we are at the end of the list, and need to branch to end. Register 6
# contains the current value loaded from the location pointed to by register 4.
# In every iteration it is compared with register 3 (current maximum), and
# register 3 is replaced if register 6 is larger.

# Note that we marked each branch point with its own symbolic label, which 
# allowed us to use those labels as the targets for branch instructions.
# For example, beq end branches to the code immediately following the end symbol
# definition later on in this code.

# Another instruction to note is ld 6, 0(4). This uses the contents of register
# 4 as a memory address from which to retrieve a value, which it then stores it
# which it then stores into register 6.
