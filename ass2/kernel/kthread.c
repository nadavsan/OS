#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

extern struct proc proc[NPROC];

void kthreadinit(struct proc *p)
{
  acquire(&p->lock);
  initlock(&p->tid_lock, "tcount lock");
  // another lock required??

  for (struct kthread *kt = p->kthread; kt < &p->kthread[NKT]; kt++)
  {
    initlock(&kt->lock, "kthread lock");
    kt->state = UNUSED;
    kt->p = p;

    // WARNING: Don't change this line!
    // get the pointer to the kernel stack of the kthread
    kt->kstack = KSTACK((int)((p - proc) * NKT + (kt - p->kthread)));
  }
  release(&p->lock);
}

struct kthread *mykthread()
{
  // based on myproc
  push_off();
  struct cpu *c=mycpu();
  struct kthread *kt=c->kthread;
  pop_off();
  return kt;
}

int allocktid(struct proc *p){
  //simillar to allocpid
  int ktid;
  acquire(&p->tid_lock);
  ktid=p->thread_count;
  p->thread_count+=1;
  release(&p->tid_lock);
  return ktid;

}

void freekt(struct kthread *kt)
{
  kt->chan=0;
  kt->state=TUNUSED;
  kt->killed=0;
  kt->tid=0;
  kt->xstate=0;
}



struct trapframe *get_kthread_trapframe(struct proc *p, struct kthread *kt)
{
  return p->base_trapframes + ((int)(kt - p->kthread));
}


struct kthread *allockt(struct proc *p)
{
  struct kthread *kt;

  for (kt=p->kthread; kt<&p->kthread[NKT];kt++)
  {
    acquire(&kt->lock);
    if(kt->state==TUNUSED)
    {
      kt->tid=allocktid(p);
      kt->state=TUSED;
      kt->trapframe=get_kthread_trapframe(p, kt);
      break;
    }
    else
    {
      release(&kt->lock);
    }

  }
  if(kt<&p->kthread[NKT])
  {
    clearContext(kt);
    kt->context.ra=(uint64)forkret;
    kt->context.sp=kt->kstack+PGSIZE;
    return kt;
  }
  return 0;

}

void clearContext(struct kthread *kt)
{
  memset(&kt->context, 0, sizeof(kt->context));
}

int kthread_create( void *(*start_func)(), void *stack, uint stack_size){
  struct proc *p = myproc();
  int tid;
  struct kthread *createt;
  
  createt = allockthread(p);
  // Allocate kthread
  if(createt  == 0){
    return -1;
  }
 
  createt->trapframe->epc = (uint64)start_func;
  createt->trapframe->sp = (uint64)stack + stack_size;
  tid = createt->tid;
  createt->state = RUNNABLE;
  release(&createt->lock);
  return tid;


}
