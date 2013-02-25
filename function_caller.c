/*
 * gcc -m64 factorial.s factorial_caller.c -o factorial
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
