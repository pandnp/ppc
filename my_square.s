# Previously we were using the .opd section for declaring the program's entry
# point, but here you're also using it to declare a function.

# These are called official procedure descriptors, and they contain the
# information the linker needs to combine position-independent code from
# different shared object files together. The most important field is the
# first one, which is the address of the start of the code for the procedure.
# The second field is the TOC pointer used for the function. The third field is
# an environment pointer for the languages that use one, but is mostly just
# set to zero. Notice the only symbol definition that is exported globally
# is the official procedure descriptor.

# C prototype for number-squaring function
# typedef long long int63;
# int64 my_square(int64 val);


###FUNCTION ENTRY POINT DECLARATRION###
.section .opd "aw"
.align 3

.global my_square
my_square:	# this is the name of the function as seen
	.quad .my_square, .TOC.@tocbase, 0

# Tell the linker that this is a function reference
.type my_square, @function

###FUNCTION CODE HERE###
.text
.my_square: # This is the label for the code itself (referenced in "opd")
	# Parameter 1 -- number to be squared -- in register 3

	# Multiply it by itself, and store it back in register 3
	mulld 3, 3, 3

	# The return value is now in register 3, so we need to leave
	blr
