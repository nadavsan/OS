#include "ustack.h"
#include "kernel/riscv.h"

static struct Header *base_pointer;
static struct Header *top_pointer;

void attach_node(struct Header* p)
{
    p->prevp = top_pointer;
    top_pointer = p;
    if (base_pointer == 0)
    {
        p->prevp = 0;
        base_pointer = p;
        top_pointer = p;
    }
}

// based on umalloc
void *ustack_malloc(uint len)
{
    struct Header *p;
    char *mem;

    if (len > MAX_SIZE)
    {
        return (void *)-1;
    }
    else
    {
        mem = sbrk(sizeof(struct Header) + len);
        p = (struct Header *)mem;

        if (p == (struct Header *)-1)
        {
            return (void *)-1;
        }
    }
    p->size=len;
    attach_node(p);
    return (void *)(p + 1);
}

int ustack_free(void)
{
    int size = top_pointer->size;
    if (base_pointer == 0)
    {
        return -1;
    }

    else if (top_pointer == base_pointer)
    {
        sbrk(-(size + sizeof(struct Header)));
        top_pointer = 0;
        base_pointer = 0;
    
        return size;
    }
    top_pointer = top_pointer->prevp;
    sbrk(-(size + sizeof(struct Header)));
    return size;
}