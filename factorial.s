###ENTRY POINT###
.section .opd "aw"
.align 3

.global factorial
factorial:
	.quad .factorial, .TOC.@tocbase, 0
.type factorial, @function

###CODE###
.text
.factorial:
    # PROLOGUE
	# reserve space
	# 48 (save areas) + 64 (parameter area) + 8 (local variable) = 120 bytes
	# aligned to 16-byte boundary = 128 bytes
	stdu 1, -128(1)
	# save Link Register
	mflr 0
	std 0, 144(1)

	# function body

	# base case? (register 3 == 0)
	cmpdi 3, 0
	bt- eq, return_one

	# not base case - recursive call
	# Save local variable
	std 3, 112(1)
	# NOTE - it could also have been stored in the parameter save area
	# parameter 1 would have been at 176(1)

	# subtract one
	subi 3, 3, 1

	# call the function (branch and set the link register to the return
	# address)
	bl factorial 
	# linker word
	nop

	# restore local variable (but to a different register -
	# register 3 is now the return value from the last factorial function)
	ld 4, 112(1)
	# multiply by return value
	mulld 3, 3, 4
	# result is in register 3, which is the return value register

factorial_return:
    # EPILOGUE
	# restore link register
	ld 0, 144(1)
	mtlr 0
	# restore stack
	ld 1, 0(1)
	# return 
	blr

return_one:
	# set reurn value to 1
	li 3, 1
	# return 
	b factorial_return
