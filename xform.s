# load a byte from the address in register 2, store it in register 3,
# and zero out the remaining bits
lbz 3, 0(2)

# store the 64-bit contents (double-word) of register 5 into the
# address 32 bits past the address specified by register 23
std 5, 32(23)

# store the low-order 32-bits (word) of register 5 into the address
# 32 bits past the address specified by register 23
stw 5, 32(23)

# store the byte in the low-order 8 bits of register 30 into the 
# address specified by register 4
stb 30, 0(4)

# load the 16 bits (half-word) at address 300 into register 4, and
# zero-out the remaining bits
lhz 4, 300(0)

# load the half-word (16-bits) that is 1 byte offset from the address
# in register 31 and store the result sign-extended into register 18
lha 18, 1(31)
