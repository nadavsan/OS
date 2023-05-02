#include "types.h"
#include "uthread.h"

// User thread table
struct uthread uthreads[MAX_UTHREADS];

// Current running user thread index
int current_thread = 0;

// Number of currently active user threads
int num_threads = 0;

// Main user thread context
struct context main_context;

// Flag indicating whether user threads have been started
int threads_started = 0;

// Initialize user thread table
void uthread_init() {
    int i;
    for (i = 0; i < MAX_UTHREADS; i++) {
        uthreads[i].state = FREE;
    }
}

// Find a free slot in the user thread table
int find_free_thread() {
    int i;
    for (i = 0; i < MAX_UTHREADS; i++) {
        if (uthreads[i].state == FREE) {
            return i;
        }
    }
    return -1;
}

// Set the context of the current thread
void set_current_thread_context(struct context* context) {
    uthreads[current_thread].context = *context;
}

// Get the context of the current thread
void get_current_thread_context(struct context* context) {
    *context = uthreads[current_thread].context;
}

// Switch to the next runnable thread
void switch_thread() {
    // Save current thread's context
    struct context* current_context = &uthreads[current_thread].context;
    get_current_thread_context(current_context);

    // Find the next runnable thread
    int i;
    for (i = 0; i < MAX_UTHREADS; i++) {
        current_thread = (current_thread + sizeof(uthreads[i]));
        if (uthreads[current_thread].state == RUNNABLE && uthreads[current_thread].priority == HIGH) {
            break;
        }
    }

    if(i == MAX_UTHREADS){
        for (i = 0; i < MAX_UTHREADS; i++) {
            current_thread = (current_thread + sizeof(uthreads[i]));
            if (uthreads[current_thread].state == RUNNABLE && uthreads[current_thread].priority == MEDIUM) {
                break;
            }
        }
    }
     

    if(i == MAX_UTHREADS){
        for (i = 0; i < MAX_UTHREADS; i++) {
            current_thread = (current_thread + sizeof(uthreads[i]));
            if (uthreads[current_thread].state == RUNNABLE && uthreads[current_thread].priority == LOW) {
                break;
            }
        }
    }

    if (i == MAX_UTHREADS)
        exit(1);
    


    // Restore next thread's context
    struct context* next_context = &uthreads[current_thread].context;
    set_current_context(next_context);
    uswtch(current_context, next_context);
}

// Create a new user thread
int uthread_create(void (*start_func)(), enum sched_priority priority) {
    // Find a free slot in the user thread table
    int i = find_free_thread();
    if (i == -1) {
        return -1;
    }

    // Initialize the user thread's stack
    char* stack = uthreads[i].ustack;
    uthreads[i].context.ra = (uint64)stack + STACK_SIZE;
    uthreads[i].context.ra -= sizeof(uint64);
    *(uint64*)uthreads[i].context.ra = (uint64)start_func; // ra
    uthreads[i].context.sp = uthreads[i].context.ra - sizeof(uint64);
    *(uint64*)uthreads[i].context.sp = uthreads[i].context.sp; // sp

    // Set the user thread's fields
    uthreads[i].state = RUNNABLE;
    uthreads[i].priority = priority;

    // Increment the number of active user threads
    num_threads++;

    return 0;
}

// Yield the current user thread
void uthread_yield() {
    // Switch to the next runnable thread
    switch_thread();
}

// Terminate the current user thread
void uthread_exit() {
    // Decrement the number of active user threads
    num_threads--;
    if(/*shel hasmahot*/ num_threads == 0){
        exit(0);
    }
    switch_thread();
    // Set the current thread's state to FREE
    uthreads[current_thread].state = FREE;
    return 0;
}

enum sched_priority uthread_set_priority(enum sched_priority priority) {
    struct uthread* self = uthread_self();
    enum sched_priority old_priority = self->priority;
    self->priority = priority;
    return old_priority;
}

enum sched_priority uthread_get_priority() {
    struct uthread* self = uthread_self();
    return self->priority;
}

int uthread_start_all() {
    if (threads_started) {
        return -1;  // uthread_start_all can only be called once
    }
    threads_started = 1;

    struct uthread* next_thread = 0;
    int i;
    for (i = 0; i < MAX_UTHREADS; i++) {
        if (uthreads[i].state == RUNNABLE) {
            next_thread = &uthreads[i];
            break;
        }
    }

    if (next_thread == 0) {
        return -1;  // no runnable threads found
    }

    // set current thread to RUNNING and switch to next_thread
    current_thread = next_thread;
    uthreads[i].state = RUNNING;
    uswtch(&main_thread->context, &uthreads[i].context);
    
    return 0;  // never reached
}
