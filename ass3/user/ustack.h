#include "kernel/types.h"
#include "user/user.h"

#define MAX_SIZE 512

struct Header
{
    struct Header *prevp;
    uint size;
    
};

void* ustack_malloc (uint len);

int ustack_free(void);