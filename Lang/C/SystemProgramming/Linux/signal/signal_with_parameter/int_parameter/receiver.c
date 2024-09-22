/**
 * @file receiver.c
 * @author panxingyuan (panxingyuan1@163.com)
 * @brief Receive SIGUSR1 signal with integer argument. 
 * @version 0.1
 * @date 2022-11-23 21:34:47
 *       Create this file. 
 * @copyright Copyright (c) 2022
 * @note The encoding of this file is "utf-8". 
 */

#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>

static void sigusr1_sigaction(int sig, siginfo_t *info, void *ucontent)
{
    printf("Receive signal: %d. Receive data:%d.\n", sig, info->si_int);
}

static int register_signal_sigusr1()
{
    struct sigaction sigact = {};
    sigact.sa_flags = SA_SIGINFO;
    sigact.sa_sigaction = sigusr1_sigaction;

    errno = 0;
    if (-1 == sigaction(SIGUSR1, &sigact, NULL))
    {
        fprintf(stderr, "Error: Register signal(SIGUSR1) error! %s.\n", strerror(errno));
        return -1;
    }

    return 0;
}

int main(int argc, char *argv[])
{
    if (-1 == register_signal_sigusr1())
    {
        return -1;
    }

    while (1)
    {
        sleep(2);
        printf("Wait for the SIGUSR1 signal.\n");
    }

    return 0;
}
