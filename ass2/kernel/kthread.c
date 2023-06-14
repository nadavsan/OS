#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

extern struct proc proc[NPROC];
struct spinlock threadlock;

void kthreadinit(struct proc *p)
{
  acquire(&p->lock);
  initlock(&p->tid_lock, "tcount lock");
  initlock(&threadlock, "tlock");

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
  struct kthread *t;

  for (t=p->kthread; t<&p->kthread[NKT];t++)
  {
    acquire(&t->lock);
    if(t->state==TUNUSED)
    {
      t->tid=allocktid(p);
      t->state=TUSED;
      t->trapframe=get_kthread_trapframe(p, t);
      break;
    }
    else
    {
      release(&t->lock);
    }

  }
  if(t<&p->kthread[NKT])
  {
    clearContext(t);
    return t;
  }
  return 0;

}

void clearContext(struct kthread *t)
{
  memset(&t->context, 0, sizeof(t->context));
  t->context.ra=(uint64)forkret;
  t->context.sp=t->kstack+PGSIZE;
}
// sys_exit(void) - Related original proc system call
// {
//   int n;
//   argint(0, &n);
//   exit(n);
//   return 0; // not reached
// }
void kthread_exit(int status){
  
  struct proc *p = myproc();
  struct kthread *t = mykthread();
  struct kthread *currentt;
  acquire(&threadlock);
  wakeup(t);

  //the lock in the thread
  acquire(&t->lock);
  t->state = TZOMBIE;
  t->xstate = status;
  uint64 flag = 1;
  
  for (currentt = p->kthread; currentt < &p->kthread[NKT]; currentt++){
    if(currentt != t){
      acquire(&currentt->lock);
      if(currentt->state != TUNUSED && currentt->state != TZOMBIE){
        flag = 0;
      }
      

      release(&currentt->lock);
    }
  
  }
  release(&threadlock);
  if(flag){
    release(&t->lock);
    exit(status);
  }
  
  sched();
  panic("zombie");
}



int kthread_kill(int ktid){
  struct proc *p = myproc();
  for (struct kthread *t = p->kthread; t < &p->kthread[NKT]; t++){
    if(t->tid == ktid){
      acquire(&t->lock);
      t->killed = 1;
      if(t->state == TSLEEPING){
        t->state = TRUNNABLE;
      }
      release(&t->lock);
      release(&p->lock);
      return 0;
    }
  }
  return -1;
}

int kthread_join(int ktid, uint64 status){
  struct kthread *t ;
  struct proc *p = myproc();
  int onerror = -1;

  for (t = p->kthread; t < &p->kthread[NKT]; t++)
  {
    if(t->tid == ktid){
      goto same;
    }
  }

  same:
  if(t->tid == ktid){
  acquire(&threadlock);
  for(;;)
  {
    acquire(&t->lock);
    if(t->state == TZOMBIE){
        if((copyout(p->pagetable, status, (char *)&t->xstate, sizeof(t->xstate)) < 0) && (status != 0 )) {                    
            release(&t->lock);
            release(&threadlock);
            return onerror;
            }
        freekt(t);

          //handle locks
        release(&t->lock);
        release(&threadlock);
        return 0;
    }
        release(&t->lock);
        sleep(t, &threadlock);
    }
  }
  return onerror;
  }

int kthread_create( void *(*start_func)(), void *stack, uint stack_size){
  struct proc *p = myproc();
  int tid;
  struct kthread *createt;
  
  createt = allockt(p);
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

int kthread_id(void){
  return mykthread()->tid;
}