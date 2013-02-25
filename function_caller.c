/*
 * Compiling factorial_caller.c
 * gcc -m64 factorial.s factorial_caller.c -o factorial
 * ./factorial
 */

/*
 * Compiling shared libraries
 * gcc -m64 -shared factorial.s my_square.s -o libmymath.so
 */

/*
 * Using the shared library
 * gcc -m64 factorial caller.c -o factorial -L. -lmymath
 *
 * Tell the dynamic linker what additional directories to search
 * export LD_LIBRARY_PATH=.
 *
 * Run the program
 * ./factorial
 */

#include <stdio.h>
typedef long long int64;
int64 factorial(int64);

int main() {
	int64 a = 10;
	printf("The factorial of %lld is %lld\n", factorial(a));
	return 0;
}
