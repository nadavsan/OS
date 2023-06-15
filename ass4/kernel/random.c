#include <stdarg.h>
#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"
#include "proc.h"


struct {
  struct spinlock lock;
  uint8 seed;
} random;

// Linear feedback shift register
// Returns the next pseudo-random number
// The seed is updated with the returned value
uint8 lfsr_char(uint8 lfsr){
    uint8 bit;
    bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 4)) & 0x01;
    lfsr = (lfsr >> 1) | (bit << 7);
    return lfsr;
}

int
randomwrite(int user_src, uint64 src, int n)
{
    int ans = 1;
    if (n == 1){    
        char c;
        if(either_copyin(&c, user_src, src, 1) != -1){
            acquire(&random.lock);
            random.seed = c;
            release(&random.lock);
        }
        else {
            ans = -1;
        }
    }
    else{
        ans = -1;
    }

    return ans;
}

int
randomread(int user_dst, uint64 dst, int n)
{
  uint target;
  char cbuf;
  uint8 rand;

  target = n;
  //process concurency safty
  acquire(&random.lock);
  while(n > 0){

    rand = lfsr_char(random.seed);
    random.seed = rand;

    // copy the input byte to the user-space buffer.
    cbuf = rand;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
      break;

    n -= 1;
    dst += 1;
  }
  release(&random.lock);

  return target - n;
}

void
randominit(void)
{
  initlock(&random.lock, "random");
  random.seed = 0x2A;

  // connect read and write system calls
  // to randomread and randomwrite.
  devsw[RANDOM].read = randomread;
  devsw[RANDOM].write = randomwrite;
}

