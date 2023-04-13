#!/bin/bash
# Author: Elias Assaf
# place file in xv6 directory and run using 'bash exit_changer.sh' or './exit_changer.sh'
# adds another arguement to all 'exit' calls [exit(0) becomes exit(0,0)], can be easily modified to also work on 'wait'.
# use at your own risk, and absolutely backup everything before using, preferably using git.
# if you want to understand how it works, open vim on some file in the user directory for example 'vim cat.c',
# then manually type ':%s/exit(\([0-9]\+\));/exit(\1,0);/g'
# in kernel directory there are only 2 calls to exit, change them manually.
cd user
vim -c "argdo %s/exit(\(-\?[0-9]\+\|&\?[a-z,A-Z][a-z,A-Z,0-9]*\));/exit(\1,0);/g | update | q" *
