# sum.s

# as -a64 sum.s -o sum.o
# ld -mel64ppc sum.o -o sum
# ./sum
# echo $?
# 3

# This code can be found at
# http://www.ibm.com/developerworks/library/l-powasm1/index.html
# Your first POWER5 program

#data section contains the pre-initialized data used for the program
.data
.align 3 # align to 8-byte boundary

#load first value
first_value:
	#"quad" actually emits 8-byte entities
	.quad 1
#load second value
second_Value:
	.quad 2

#Write the "official procedure descriptor" in its own section
.section ".opd", "aw"
.align 3 #align to 8-byte boundary

#procedure description to ._start
.global _start
#Note that the description is named _start
# and the beginning of the code is labeled._start
_start:
	.quad ._start, .TOC.@tocbase, 0

#text section contains the actual code (historically known as the program text)
.text
._start
	#Use register 7 to load in an address
	#64-bit addresses must be loaded in 16-bit pieces

	#Load in the high-order pieces of the address
	lis    7, first_value@highest
	ori    7, 7, first_value@higher
	#Shift these up to the high-order bits
	rldicr 7, 7, 32, 31
	#Load in the low-order pieces of the address
	oris   7, 7, first_value@h
	ori    7, 7, first_value@l

	#Load in first value to register 4, from the address we just loaded
	ld     4, 0(7)
	
	#Load in the address of the second value
	lis    7, second_value@highest
	ori    7, 7, second_value@higher
        rldicr 7, 7, 32, 31
        oris   7, 7, second_value@h
	ori    7, 7, second_value@l

	#Load in the second value to register 5, from the address we just loaded
	ld     5, 0(7)
	
	#Calculate the value to register 5, from the address we just loaded
	add    6, 4, 5

	#Exit with the status
	li    0, 1 #system call is in register 0
	mr    3, 6 #Move result into register 3 for the system call

	sc

# The first thing our program does is switch to the .data section, and set
# alignment to an 8-byte boundary.

# The line that says first_value: is a symbol declaration. This creates a symbol
# called first_value which is synonomous with the address of the next 
# declaration or instruction listed in the assembler. Note that first_value 
# itself is a constant, not a variable, though the memory address it refers to 
# may be updateable. first_value is simply an easy way to refer to a specific 
# address in memory. 

# The next directive, .quad 1, creates an 8-byte data value, holding the value 1

# After this, we have a similar set of directives defining the address
# second_value holding an 8-byte data item with a value of 2.

# The .section ".opd", "aw" creates an ".opd" section for our procedure
# descriptors. We force the section to align an 8-byte boundary. We then declare
# the symbol _start to be global, which means that it will not be discarded
# after linking. After that, the _start symbol itself is discarded (the .global
# assembler does not define _start, it only makes it to be global once it is
# defined). The next three data items generated are the procedure descriptor.

# Now we can switch to an actual program code. The .text directive tells the
# assembler that we are switching to the ".text" section. After this is where
# ._start is defined

# The first set of instructions loads in the address of the first value (not the
# value itself). Because PowerPC instructions are only 32-bits long, there are
# only 16 bits available within the instruction for loading constant values
# remember the address of first_value is constant). Therefore, since the address# can be up to 64 bits, we have to load it a piece at a time. .@-signs within
# the assembler instruct the assembler to give a specially-processed form of a 
# symbol value. The following are used here:

# @highest
#	refers to the bits 48-63 constant

# @higher
# 	refers to the bits 32-47 of a constant

# @h
#	refers to the bits 16-31 of a constant

# @l
#	refers to the bits 0-15 of a constant

# The first instruction used stands for "load immediate shifted". This loads the
# value on the far right side (bits 48-63 of first_value), shifts the number to
# the left 16 bits, and then stores the result into register 7. Bits 16-31 of
# register 7 now contain bits 48-63 of the address. Next we use the
# "or immediate" instruction to perform a logical or operation with register 7
# and the value on the right side (bits 32-47 of first_value), and store the 
# result in register 7. Now bits 32-47 of the address are in bits 0-15 of
# register 7. Register 7 is now shifted left 32 bits, with buits 0-31 cleared
# out, and the result is stored in register 7. Now bits 32-63 of register 7 
# contain bits 32-63 of the address we are loading. The next two instructions 
# use "or immediate" and "or immediate shifted" instruction to load bits 0-31
# in a similar manner.

# That's quite a lot of work just to load in a single 64-bit value. That's why
# most operations on PowerPC chips operate through the registers instead of 
# immediate values -- register operations can use all 64-bits at once, rather
# than being limited by the instruction length.

# Now remember, this only loads in the address of the value we want to load.
# Now we want to load the value itself into a register. To do this, we will use
# register 7 to tell the processor what address we want to load the value from.
# This will be indicated by putting "7" in parenthesis. The instruction
# ld 4, 0(7) loads the value at the address in register 7 into register 4
# the zero means to add zero to that address). Now register 4 has the first
# value.

# A similar process is used to load the second value into register 5.

# After the registers are loaded, we can now add our numbers. The instruction
# add 6, 4, 5 adds the contents of register 4 to register 5, and stores the
# result in register 6 (registers 4 and 5 are unaffected).

# Now that we have computed the value we want, the next thing we want to do is 
# use this value as the return/exit value for the program. The wat that you exit
# a program in assembly language is issuing a system call to do so (exiting is 
# done using the exit system call). Each system call has an associated number.
# This number is stored in register zero before making the call. The rest of the
# arguments start in register three, and continue on for however many arguments
# the system call needs. Then the sc instruction causes the kernel to take over
# and respond to the4 request. The system call number for exit it 1. Therefore,
# the first thing we need to do is to move the number 1 into register 0.

# On PowerPC machines, this is done by adding. The addi instruction adds
# together a register and a number and stores the result in a register. In some
# instructions (including addi), if the specified register is register 0, it
# doesn't add a register at all, and uses the number 0 instead. This seems
# confusing, but the reason for it is to allow PowerPCs to use the same
# instruction for adding as for loading.

# The exit system call takes one parameter -- the exit value. This is stored in
# register 3. Therefore, we need to move our answer from register 6 to register
# 3. The "register move" isntruction rm 3, 6 performs the needed move. Now we 
# are ready to tell the operating system we are ready for it do its trick.

# The instruction to call the operating system is simply sc for "system call".
# This wil invoke the operating system, which will read what we have in register
# 0 and register 3, and then exit with the contents of register 3 as our return
# value. On the command line, we can retireve this value using the command 
# echo $?.

# Just to point our a wlot of these instructions are redundant, but used for 
# teaching purposes. For example, sinc first_Value and second_value are
# essentially constant, there is no reason we can't just load them directly and 
# skip the data section altogether. Likewise we could have stored the result in
# register 3 to being with (instead of register 6), and saved a register move. 
# In fact we could have used register 3 for both a source and a descriptor 
# register.
