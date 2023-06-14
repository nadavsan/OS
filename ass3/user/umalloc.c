#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

// Memory allocator by Kernighan and Ritchie,
// The C programming Language, 2nd ed.  Section 8.7.

typedef long Align;

// Union to represent the header of a memory block
union header {
  struct {
    union header *ptr; // Pointer to the next free block
    uint size;         // Size of the block in bytes
  } s;
  Align x;
};

typedef union header Header;

static Header base;   // Base of the free list
static Header *freep; // Pointer to the first free block

// Function to free a memory block
void free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1; // Get the header of the block to be freed
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;

  // Merge freed block with the next block if contiguous
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;

  // Merge freed block with the previous block if contiguous
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;

  freep = p;
}

// Helper function to request more memory from the operating system
static Header* morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;

  p = sbrk(nu * sizeof(Header)); // Request additional memory from the OS
  if(p == (char*)-1)
    return 0;

  hp = (Header*)p;
  hp->s.size = nu;

  free((void*)(hp + 1)); // Merge new block with existing free blocks
  return freep;
}

// Function to allocate memory
void* malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  // Calculate the number of header units required to satisfy the requested nbytes
  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;

  // If freep is NULL, initialize the free list with a base block
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }

  // Iterate over the free list to find a suitable block
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      // If the block is exact size, remove it from the free list
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
      else {
        // If the block is larger, split it into two blocks
        p->s.size -= nunits;
        p += p->s.size;
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1); // Return pointer to the allocated memory (skip the header)
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0; // Request more memory and update freep
  }
}
