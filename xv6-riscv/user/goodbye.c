#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
  char child_msg[]= "Goodbye World xv6";
  exit(0, child_msg);
}