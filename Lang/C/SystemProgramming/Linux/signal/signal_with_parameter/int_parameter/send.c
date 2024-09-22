/**
 * @file send.c
 * @author panxingyuan (panxingyuan1@163.com)
 * @brief Send SIGUSR1 signal with integer argument. 
 * @version 0.1
 * @date 2022-11-23 21:59:51
 *       Create this file. 
 * @copyright Copyright (c) 2022
 * @note The encoding of this file is "utf-8". 
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>

/**
 *
 * argv[1] pid
 * argv[2] parameter
 */
int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        fprintf(stderr, "Error: invalid argument.\n");
        printf("Usage: %s <pid> <integer>.\n", argv[0]);
        return -1;
    }

    int pid = atoi(argv[1]);
    union sigval value;
    value.sival_int = atoi(argv[2]);

    errno = 0;
    if (-1 == sigqueue(pid, SIGUSR1, value))
    {
        fprintf(stderr, "Error: Send signal(SIGUSR1) error! %s.\n", strerror(errno));
        return -1;
    }

    return 0;
}
