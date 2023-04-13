#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define HIGH_PRIO 0
#define NORMAL_PRIO 1
#define LOW_PRIO 2

int main() {
  // Fork 3 child processes with different priorities.
  int pid;
//   int pids[3];
  for (int i = 0; i < 5; i++) {
    if ((pid = fork()) < 0) {
        printf("Error: failed to fork\n");
        exit(1,"");
    } else if (pid == 0) {
      // Set the process priority based on the loop index.
      if (i == 0) {
        set_cfs_priority(HIGH_PRIO);
      } else if (i == 1 || i == 2) {
        set_cfs_priority(NORMAL_PRIO);
      } else {
        set_cfs_priority(LOW_PRIO);
      }

      // Run a loop with sleep time and print statistics.
      int rtime = 0, stime = 0, retime = 0, cfs_priority = 0;
      int* stats = 0;
      for (int j = 0; j < 1000000; j++) {
        // Sleep for 1 second every 100000 iterations.
        if (j % 100000 == 0) {
          sleep(1);
        }
        // Get process statistics.
        if (get_cfs_stats(stats) < 0) {
          printf("Error: failed to get statistics\n");
          exit(1,"");
        }
      }// Print process statistics.
      cfs_priority = stats[0];
      rtime = stats[1];
      stime = stats[2];
      retime = stats[3];
      printf("PID %d, CFS priority %d, run time %d, sleep time %d, runnable time %d\n", getpid(), cfs_priority, rtime, stime, retime);
      exit(0, "");
    } else if (pid > 0) {
        wait(0,"");
        wait(0,"");
        wait(0,"");
    } else {
      printf("Error: failed to fork process\n");
      exit(1,"");
    }
  }

  // Wait for all child processes to finish.
//   int status;
//   for (int i = 0; i < 3; i++) {
//     waitpid(pids[i], &status, 0);
//   }

  exit(0, "");
}