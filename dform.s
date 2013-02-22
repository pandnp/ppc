# Add the contents of register 3 to the number 25 and store in register 2
addi  2, 3, 25

# OR the contents of register 6 to the number 0b0000000000000001 and store
# in register 3
ori   3, 6, 0b0000000000000001

# Move the number 55 into register 7
# (remember, when 0 is the second register in D-Form instructions
# it means ignore the register)
addi  7, 0 , 55
#Here is the extended mnemonics for the same instruction
li    7, 55
