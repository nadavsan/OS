#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void main(){
    int p[3];
    int pid1, pid2, pid3;

    if ((pid1 = fork()) < 0){
        printf("Error: failed to fork\n");
        exit(1,"");
    }else if (pid1 == 0){
        set_cfs_priority(0);
        for (int i=0;i<10000000;i++){
            if(i%100000==0){
                sleep(1);
            }
        }
        if(get_cfs_stats(p) < 0){
            printf("Error: failed to get statistics\n");
            exit(1,"");
        }
    }
    else{
        printf("pid %d priority %d runnable time %d , run time %d, sleep time:%d\n",pid1,p[0],p[1],p[2], p[3]);
        if ((pid2=fork()) < 0){
            printf("Error: failed to fork\n");
            exit(1,"");
        }else if (pid2 == 0){
            set_cfs_priority(1);
            for (int i=0;i<10000000;i++){
                if(i%100000==0){
                sleep(1);
            }
        }
        if(get_cfs_stats(p) < 0){
            printf("Error: failed to get statistics\n");
            exit(1,"");
        }
    } else{
        printf("pid %d priority %d runnable time %d , run time %d, sleep time:%d\n",pid2,p[0],p[1],p[2], p[3]);
        if((pid3=fork()) < 0){
            printf("Error: failed to fork\n");
            exit(1,"");
        }else if (pid3==0){
            set_cfs_priority(2);
            for (int i=0;i<10000000;i++){
                if(i%100000==0){
                sleep(1);

            }
        }
        if(get_cfs_stats(p) < 0){
            printf("Error: failed to get statistics\n");
            exit(1,"");
        }
        } else{
            printf("pid %d priority %d runnable time %d , run time %d, sleep time:%d\n",pid3,p[0],p[1],p[2], p[3]);            
            wait(0,0);   
            wait(0,0); 
            wait(0,0);     
        }
        exit(0,"");

     }
    }
}