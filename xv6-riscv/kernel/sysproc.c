#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  char msg[32];
  argint(0, &n);
  argstr(1,msg,32);
  exit(n,msg);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  uint64 msg;
  argaddr(0, &p);
  argaddr(1, &msg);
  return wait(p,msg);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64 sys_memsize(void)
{
  return myproc()->sz;
}

uint64 sys_set_ps_priority(struct proc* p, int priority)
{
  argint(0, &priority);
  if(priority < 1 || priority > 10)
    return -1;
  p->ps_priority = priority;
  return priority;
}

uint64
sys_set_cfs_priority(void)
{
  int priority;
  argint(0, &priority);
  if (priority < 0 || priority > 2) {
    return -1;
  }
  set_cfs_priority(priority);
  // printf("priority: %d, myproc()->cfs_priority: %d\n", priority, myproc()->cfs_priority);
  return 0;
}

uint64
sys_set_policy(void){
  int policy;
  argint(0, &policy);
  if (policy < 0 || policy > 2) {
    return -1;
  }
  return set_policy(policy);
}

//TODO 1
uint64
sys_get_cfs_stats(void){
  int pid;
  int* arr;
  uint64 addr;
  argint(0, &pid);
  argaddr(1, &addr);
  arr = (int*)addr;
  get_cfs_stats(pid, arr);
  return 0;
}
