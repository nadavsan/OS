#include "kernel/types.h"
#include "user.h"
#include "uthread.h"

// User thread table
struct uthread uthreads[MAX_UTHREADS];

// Current running user thread index
int current_thread_i = 0;

// Number of currently active user threads
int num_threads = 0;

// Main user thread context
struct context main_context;

// Global variable to make sure uthread_start_all() is called only once
int started = 0;

//global variables for uthread_start_all:
static struct uthread *current_thread;
static struct uthread main_thread;

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
    uthreads[current_thread_i].context = *context;
}

// Get the context of the current thread
void get_current_thread_context(struct context* context) {
    *context = uthreads[current_thread_i].context;
}

// Switch to the next runnable thread
void switch_thread() {
    // Save current thread's context
    struct context* current_context = &uthreads[current_thread_i].context;
    get_current_thread_context(current_context);

    // Find the next runnable thread
    int i;
    for (i = 0; i < MAX_UTHREADS; i++) {
        current_thread_i = (current_thread_i + sizeof(uthreads[i]));
        if (uthreads[current_thread_i].state == RUNNABLE && uthreads[current_thread_i].priority == HIGH) {
            break;
        }
    }

    if(i == MAX_UTHREADS){
        for (i = 0; i < MAX_UTHREADS; i++) {
            current_thread_i = (current_thread_i + sizeof(uthreads[i]));
            if (uthreads[current_thread_i].state == RUNNABLE && uthreads[current_thread_i].priority == MEDIUM) {
                break;
            }
        }
    }
     

    if(i == MAX_UTHREADS){
        for (i = 0; i < MAX_UTHREADS; i++) {
            current_thread_i = (current_thread_i + sizeof(uthreads[i]));
            if (uthreads[current_thread_i].state == RUNNABLE && uthreads[current_thread_i].priority == LOW) {
                break;
            }
        }
    }

    if (i == MAX_UTHREADS)
        exit(1);
    

    // Set current thread to next thread
    current_thread = &uthreads[current_thread_i];
    // Restore next thread's context
    struct context* next_context = &uthreads[current_thread_i].context;
    set_current_thread_context(next_context);
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
    uthreads[current_thread_i].state = FREE;
    return;
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
    // make sure that main thread is created
    if (main_thread.state == FREE) {
        if (uthread_create(0, LOW) == -1) {
            return -1;
        }
    }

    // make sure uthread_start_all() is not called more than once
    if (started) {
        return -1;
    }
    started = 1;

    // set current thread to main thread
    current_thread = &main_thread;
    current_thread->state = RUNNING;

    //TODO: check if we need to save main context and how to do it
    // save main context and switch to first thread
    // if (getcontext(&main_context) == -1) {
    //     perror("getcontext");
    //     exit(1);
    // }

    //TODO: check if that's the way to run the first thread (index 0)
    struct uthread *next_thread = &uthreads[0];
    if (next_thread != 0) {
        current_thread = next_thread;
        current_thread->state = RUNNING;
        uswtch(&main_context, &(current_thread->context));
    }

    // We should never reach this point, but just in case...
    return -1;
}


struct uthread* uthread_self() {
    return current_thread;
}

