#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: policy <policy_code>\n");
        return 1;
    }

    int policy_code = atoi(argv[1]);

    int result = set_policy(policy_code);

    if (result == -1) {
        printf("Error setting policy: %d\n", policy_code);
        return 1;
    }

    printf("Policy set to: %d\n", policy_code);

    return 0;
}

