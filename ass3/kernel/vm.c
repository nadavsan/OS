#include "param.h"
#include "types.h"
#include "memlayout.h"
#include "elf.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"

#include "spinlock.h"
#include "proc.h"

/*
 * the kernel's page table.
 */
pagetable_t kernel_pagetable;

extern char etext[]; // kernel.ld sets this to end of kernel code.

extern char trampoline[]; // trampoline.S

// Make a direct-map page table for the kernel.
pagetable_t
kvmmake(void)
{
  pagetable_t kpgtbl;

  kpgtbl = (pagetable_t)kalloc();
  memset(kpgtbl, 0, PGSIZE);

  // uart registers
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);

  // virtio mmio disk interface
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);

  // PLIC
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);

  // map kernel text executable and read-only.
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);

  // map kernel data and the physical RAM we'll make use of.
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);

  // map the trampoline for trap entry/exit to
  // the highest virtual address in the kernel.
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);

  // allocate and map a kernel stack for each process.
  proc_mapstacks(kpgtbl);

  return kpgtbl;
}

// Initialize the one kernel_pagetable
void kvminit(void)
{
  kernel_pagetable = kvmmake();
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));

  // flush stale entries from the TLB.
  sfence_vma();
}

// Return the address of the PTE in page table pagetable
// that corresponds to virtual address va.  If alloc!=0,
// create any required page-table pages.
//
// The risc-v Sv39 scheme has three levels of page-table
// pages. A page-table page contains 512 64-bit PTEs.
// A 64-bit virtual address is split into five fields:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
  if (va >= MAXVA)
    panic("walk");

  for (int level = 2; level > 0; level--)
  {
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V)
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
}

// Look up a virtual address, return the physical address,
// or 0 if not mapped.
// Can only be used to look up user pages.
uint64
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    return 0;

  pte = walk(pagetable, va, 0);
  if (pte == 0)
    return 0;
  if ((*pte & PTE_V) == 0)
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}

// add a mapping to the kernel page table.
// only used when booting.
// does not flush TLB or enable paging.
void kvmmap(pagetable_t kpgtbl, uint64 va, uint64 pa, uint64 sz, int perm)
{
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    panic("kvmmap");
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    panic("mappages: size");

  a = PGROUNDDOWN(va);
  last = PGROUNDDOWN(va + size - 1);
  for (;;)
  {
    if ((pte = walk(pagetable, a, 1)) == 0)
      return -1;
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0){
    #if SWAP_ALGO != 0
    if((*pte & PTE_PG) == 0)
    #endif
    panic("uvmunmap: not mapped");  
    }
    if (PTE_FLAGS(*pte) == PTE_V)
      panic("uvmunmap: not a leaf");
    if (do_free && ((*pte & PTE_PG)==0))
    {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    #if SWAP_ALGO != 0
      struct proc *p = myproc();
      if (p->pid > 2)
      {
        for (int i = 0; i < MAX_TOTAL_PAGES; i++)
        {
          if (p->pages[i].va == a)
          {
            if (p->pages[i].used == PAGE_USED && p->pages[i].position == SWAPFILE)
            {
              p->fileCounter--;
              uint64 offset = p->pages[i].offset;
              p->fileOffsets[offset/PGSIZE].used = OFFSET_UNUSED;
            }
            if (p->pages[i].used == PAGE_USED && p->pages[i].position == RAM)
            {
              p->ramCounter--;
            }
            p->pages[i].va = 0;
            p->pages[i].used = PAGE_UNUSED;
            p->pages[i].position = ABSENT;
            p->pages[i].offset = -1;
            #if SWAP_ALGO == 2
              p->pages[i].counter = 0xFFFFFFFF;
            #endif
            #if SWAP_ALGO == 1
              p->pages[i].counter = 0;
            #endif
            #if SWAP_ALGO == 3
              p->pages[i].timeCreated = 0;
            #endif   
          }
        }
      }
    #endif
  }
}

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
  if (pagetable == 0)
    return 0;
  memset(pagetable, 0, PGSIZE);
  return pagetable;
}

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
  char *mem;

  if (sz >= PGSIZE)
    panic("uvmfirst: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
  memmove(mem, src, sz);
}

// Allocate PTEs and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
uint64
uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz, int xperm)
{
  char *mem;
  uint64 a;

  if (newsz < oldsz)
    return oldsz;

  oldsz = PGROUNDUP(oldsz);
  for (a = oldsz; a < newsz; a += PGSIZE)
  {
    mem = kalloc();
    if (mem == 0)
    {
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    {
      kfree(mem);
      uvmdealloc(pagetable, a, oldsz);
      return 0;
    }

    #if SWAP_ALGO != 0
      struct proc *p = myproc();
      int index;
      if (p->pid > 2 && p->pagetable == pagetable){
        if (p->ramCounter + p->fileCounter < MAX_TOTAL_PAGES){
          index = findNextIndex(p);
          if (index == -1)
          {
            panic("Counters dont match pages table");
          }
          if (p->ramCounter == MAX_PSYC_PAGES)
          {
            swapToFile(p);
          }
          p->pages[index].used = PAGE_USED;
          p->pages[index].va = a;
          p->pages[index].position = RAM;
          p->pages[index].offset = -1;
          p->pages[index].timeCreated = createTime();
          p->ramCounter++;
          #if SWAP_ALGO == 2
          p->pages[index].counter = 0xFFFFFFFF;
          #endif
          #if SWAP_ALGO == 1
          p->pages[index].counter = 0;
          #endif
        }
        else{
          panic("no more space in memory");
        }
      }
    #endif

  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if (newsz >= oldsz)
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
  {
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    }
    else if (pte & PTE_V)
    {
      panic("freewalk: leaf");
    }
  }
  kfree((void *)pagetable);
}

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
  if (sz > 0)
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
}

// Given a parent process's page table, copy
// its memory into a child's page table.
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    if(((*pte & PTE_V) == 0) && ((*pte & PTE_PG)==0))
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
      kfree(mem);
      goto err;
    }

    pte_t *new_pte = walk(new, i, 0);
    *new_pte = *new_pte | PTE_FLAGS(*pte);
  }

  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
  return -1;
}

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;

  pte = walk(pagetable, va, 0);
  if (pte == 0)
    panic("uvmclear");
  *pte &= ~PTE_U;
}

// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
  {
    va0 = PGROUNDDOWN(dstva);
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);

    len -= n;
    src += n;
    dstva = va0 + PGSIZE;
  }
  return 0;
}

// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
  {
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);

    len -= n;
    dst += n;
    srcva = va0 + PGSIZE;
  }
  return 0;
}

// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
  {
    va0 = PGROUNDDOWN(srcva);
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    if (n > max)
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
        got_null = 1;
        break;
      }
      else
      {
        *dst = *p;
      }
      --n;
      --max;
      p++;
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
  {
    return 0;
  }
  else
  {
    return -1;
  }
}

int findNextIndex(struct proc *p)
{
  for (int i = 0; i < MAX_TOTAL_PAGES; i++)
  {
    if (p->pages[i].used == PAGE_UNUSED)
    {
      return i;
    }
  }
  return -1;
}

int selectPageToSwap(struct proc *p)
{
  #if SWAP_ALGO == 1  
   return nfua(p);
  #endif

  #if SWAP_ALGO == 2
   return lapa(p);
  #endif
  
  #if SWAP_ALGO == 3
   return scfifo(p);
  #endif

  panic("page replacment algorithm dosen't match");
}

int nfua(struct proc *p) {
  printf("nfua");
  int indexToSwap = findFirst(p);
  uint min = p->pages[indexToSwap].counter;

  for(int i=0; i < MAX_TOTAL_PAGES; i++){
    if(p->pages[i].position == RAM && p->pages[i].counter < min){
      indexToSwap = i;
      min = p->pages[i].counter;
    }
  }

  return indexToSwap;
}

int lapa(struct proc *p){
  printf("lapa");
  int indexToSwap = findFirst(p);
  int minOnes = countOnes(p->pages[indexToSwap].counter);
  uint minCounter = p->pages[indexToSwap].counter;

  for(int i=0; i < MAX_TOTAL_PAGES; i++){
    if((p->pages[i].position == RAM && countOnes(p->pages[i].counter) < minOnes) ||
    (p->pages[i].position == RAM && countOnes(p->pages[i].counter) == minOnes &&
    p->pages[i].counter < minCounter)){
      indexToSwap = i;
      minOnes = countOnes(p->pages[i].counter);
      minCounter = p->pages[i].counter;
    }
  }

  return indexToSwap;
}

int scfifo(struct proc *p){
  printf("scfifo");
  int prev = -1;
  int indexToSwap;
  int firstIndex = findFirst(p);
  int firstMinValue = p->pages[firstIndex].timeCreated;
  int counter = 0;
  for(;;){
    indexToSwap = firstIndex;
    int min = firstMinValue;
    if(counter > 16){
      prev = -1;
    }
    for(int i=0; i< MAX_TOTAL_PAGES; i++){
      if(p->pages[i].position == RAM && prev < p->pages[i].timeCreated && p->pages[i].timeCreated < min){
        indexToSwap = i;
        min = p->pages[i].timeCreated;
      }
    }
    pte_t * pte = walk(p->pagetable, p->pages[indexToSwap].va,0);
    if (*pte & PTE_A) {
      *pte &= ~PTE_A;
      prev = p->pages[indexToSwap].timeCreated;
      counter++;
    }
    else{
      return indexToSwap;
    }
  }
}

int countOnes(uint n){ 
  int sum = 0; 
  while (n != 0){ 
      sum += n & 1;
      n >>= 1;
  } 
  return sum; 
}

int createTime() {
  int time;
  struct proc *p = myproc();
  acquire(&p->lock);
  time = p->time;
  p->time++;
  release(&p->lock);
  return time;
}

int findFirst(struct proc *p){
  for(int i = 0; i < MAX_TOTAL_PAGES; i++){
    if(p->pages[i].used == PAGE_USED && p->pages[i].position == RAM){
      return i;
    }
  }
  return -1;
}


int findNextOffset(struct proc *p){
  for(int i=0; i < MAX_TOTAL_PAGES; i++){
    if(p->fileOffsets[i].used == OFFSET_UNUSED){
      return i;
    }
  }
  return -1;
}

// need to check if pte use here is right
void swapToFile(struct proc *p)
{
  int indexToSwap = selectPageToSwap(p);
  printf("%d\n", indexToSwap);

  int offset = findNextOffset(p);

  uint64 pa = walkaddr(p->pagetable, p->pages[indexToSwap].va);
  if (writeToSwapFile(p, (void *)pa, offset * PGSIZE, PGSIZE) == -1)
    panic("write to swap file failed");

  p->pages[indexToSwap].position = SWAPFILE;
  p->pages[indexToSwap].offset = offset * PGSIZE;
  p->fileOffsets[offset].used = OFFSET_USED;

  #if SWAP_ALGO == 2
    p->pages[indexToSwap].counter = 0xFFFFFFFF;
  #endif
  #if SWAP_ALGO == 1
    p->pages[indexToSwap].counter = 0;
  #endif
  #if SWAP_ALGO == 3
    p->pages[indexToSwap].timeCreated = 0;
  #endif
  p->ramCounter--;
  p->fileCounter++;

  pte_t *pte;
  pte = walk(p->pagetable, p->pages[indexToSwap].va, 0);
  *pte |= PTE_PG;
  *pte &= ~PTE_V;

  kfree((void *)pa);
}

void swapToRam(struct proc *p, uint64 va)
{
  int index;
  for (index = 0; index < MAX_TOTAL_PAGES; index++)
  {
    if (p->pages[index].va == va)
    {
      break;
    }
  }

  char *pa = kalloc();
  if (readFromSwapFile(p, pa, p->pages[index].offset, PGSIZE) == -1)
  {
    panic("Fail");
  }

  p->pages[index].position = RAM;
  p->ramCounter++;

  uint64 offset = p->pages[index].offset;
  p->fileOffsets[offset/PGSIZE].used = OFFSET_UNUSED;
  p->pages[index].offset = -1;
  p->fileCounter--;

  p->pages[index].timeCreated = createTime();
  #if SWAP_ALGO == 2
    p->pages[index].counter = 0xFFFFFFFF;
  #endif
  #if SWAP_ALGO == 1
    p->pages[index].counter = 0;
  #endif

  pte_t *pte = walk(p->pagetable, va, 0);
  uint flags = PTE_FLAGS(*pte);
  *pte = PA2PTE(pa) | PTE_V | flags;

  // *pte &= ~PTE_PG;
  // *pte = *pte | PTE_V;
  // *pte = *pte | PTE_U;
  // *pte = *pte | PTE_R;
  // *pte = *pte | PA2PTE(pa);
}