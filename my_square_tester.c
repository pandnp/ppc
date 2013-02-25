/*
 * gcc -m64 my_square.s my_square_tester.c -o my_square_tester
 * ./my_square_tester
 * 
 * The -m64 flag tells the compiler to use 64-bit instructions,
 * compile using hte 64-bit ABI and libraries, and use the 64-bit
 * ABI for linking. 
 */

#include <stdio.h>

/* make declarations easier to write */
typedef long long int64;

int64 my_square(int64);

int main() {
	int a = 32;
	printf("The square of %lld is %lld.\n", a, my_square(a));
	return 0;
}
