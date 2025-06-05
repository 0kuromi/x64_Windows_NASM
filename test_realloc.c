#include <stdio.h>
#include <stdlib.h>
void *realloc_func(void *ptr, size_t size)
{
    void *new_ptr = realloc(ptr, size);
    if (new_ptr == NULL) {
        fprintf(stderr, "Reallocation failed\n");
        free(ptr);
    }
    return new_ptr;
}
int main()
{
    int *p = NULL;
    int i;

    // Allocate initial mmory for 5 integers
    p = (int *)malloc(5 * sizeof(int));
    if (p == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    p = realloc_func(p, 10 * sizeof(int)); // Update pointer to the newly allocated memory

    free(p);
    
    return 0;
}