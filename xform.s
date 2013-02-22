# Load a doubleword (64 bits) from the address specififed by
# register 3 + register 20 and store the value into register 31
ldx 31, 3, 20

#Load a byte from the address specified by register 10 + register 12 
#and store the value into register 15 and zero-out remaining bits
lbzx 15, 10, 12

#Load a halfword (16 bits) from the address specified by 
#register 6 + register 7 and store the value into register 8, 
#sign-extending the result through the remaining bits
lhax 8, 6, 7

#Take the doubleword (64 bits) in register 20 and store it in the 
#address specified by register 10 + register 11
stdx 20, 10, 11

#Take the doubleword (64 bits) in register 20 and store it in the 
#address specified by register 10 + register 11, and then update 
#register 10 with the final address
stdux 20, 10, 11
