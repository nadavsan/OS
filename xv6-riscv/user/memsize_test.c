#include "kernel/types.h"
#include "kernel/stat.h"
#include "user.h"

#define KB 1024
// #define MB (KB * KB)

int main(int argc, char *argv[]) {
    int mem_size;
    char *p;

    // Get memory size before allocation
    mem_size = memsize();
    printf("Memory size before allocation: %d bytes\n",mem_size);

    // Allocate 20k more bytes of memory
    p = malloc(20 * KB);

    // Get memory size after allocation
    mem_size = memsize();

    printf("Memory size after allocation: %d bytes\n",mem_size);

    // Free the allocated array
    free(p);

    // Get memory size after freeing the allocated memory
    mem_size = memsize();

    printf("Memory size after freeing the allocation: %d bytes\n",mem_size);

    exit(0);
}