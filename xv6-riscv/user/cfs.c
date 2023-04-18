#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int main(){
    int child_pid[3];
    for (int i = 2; i >= 0; i--) {
        int pid = fork();
        
        if (pid == -1) {
            exit(1, "");

        } else if (pid == 0) 
        { //child proc
            set_cfs_priority(i);
            
            for (int j=0;j<1000000;j++)
            {
                if (j%100000==0)
                {
                    sleep(1);
                }
            }
            int arr[4];
            if(get_cfs_stats(getpid(),arr) < 0){
                exit(1, "get_cfs_stats failed");
            }

            exit(0, "");
        }
        else{
            child_pid[i] = pid;
        }
    }
    for (int i = 0; i < 3; i++) {
        wait(&child_pid[i], 0);
    }
    return 0;

}