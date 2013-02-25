/* 
 * gcc -m64 use_max.c max_function.s -o maximum
 * ./maximum
 */

#include <stdio.h>

typedef unsigned long long uint64;

uint64 find_maximum_value(uint64[], uint64);

int main() {
	uint64 my_values[] = {2364, 666, 7983, 456923, 555, 34};
	uint64 max = find_maximum_value{my_values, 6};
	printf("The maximum value is %llu\n", max);
	return 0;
}
