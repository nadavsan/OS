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
  //TODO: should we just return kt?
  return &myproc()->kthread[0];
}

int allocktid(struct proc *p){
  //simillar to allocpid
  int ktid;
  acquire(&p->tid_lock);
  ktid=p->thread_count;
  p->thread_count=p->thread_count+1;
  release(&p->tid_lock);
  return ktid;

}

void freekt(struct kthread *kt)
{
  kt->chan=0;
  kt->state=UNUSED;
  kt->killed=0;
  kt->tid=0;
  kt->xstate=0;
}



struct trapframe *get_kthread_trapframe(struct proc *p, struct kthread *kt)
{
  return p->base_trapframes + ((int)(kt - p->kthread));
}

// TODO: delte this after you are done with task 2.2
void allocproc_help_function(struct proc *p)
{
  p->kthread->trapframe = get_kthread_trapframe(p, p->kthread);

  p->context.sp = p->kthread->kstack + PGSIZE;
}

struct kthread *allockt(struct proc *p)
{
  struct kthread *kt;

  for (kt=p->kthread; kt<&p->kthread[NKT];kt++)
  {
    acquire(&kt->lock);
    if(kt->state==UNUSED)
    {
      kt->tid==allocktid(p);
      kt->state=USED;
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
    //TODO: why is forkret not included ?
    kt->context.ra=(uint64)forkret;
    kt->context.sp=kt->kstack+PGSIZE;
    return kt;
  }
  else
  {
    return 0;
  }

}

void clearContext(struct kthread *kt)
{
  memset(&kt->context, 0, sizeof(kt->context));
}