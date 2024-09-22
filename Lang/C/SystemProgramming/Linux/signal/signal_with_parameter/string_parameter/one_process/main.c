/**
 * @file main.c
 * @author panxingyuan (panxingyuan1@163.com)
 * @brief 
 * @version 0.1
 * @date 2022-11-24 22:53:17
 *       Create this file. 
 * @copyright Copyright (c) 2022
 * @note The encoding of this file is "utf-8". 
 *
 * 不能既传递整数参数又传递字符串参数，这会导致断错误．
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>

static void sigusr1_sigaction(int sig, siginfo_t *info, void *ucontent)
{
    /** printf("Receive signal: %d. Receive data:%d. Receive string:%s.\n", sig, info->si_int, (char *)(info->si_ptr)); */
    /** printf("Receive signal: %d. Receive data:%d.\n", sig, info->si_int); */
    printf("Receive signal: %d. Receive string:%s.\n", sig, (char *)(info->si_ptr));
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

    int i = 0;
    char buf[] = "hello world";
    char buf2[32] = {};
    union sigval value;
    while (1)
    {
        sleep(1);

        /**
         * 这样调用会导致程序异常退出，不能同时传递整数和字符串．
         */
        /** value.sival_int = 0; */
        /** errno = 0; */
        /** if (-1 == sigqueue(getpid(), SIGUSR1, value)) */
        /** { */
        /**     fprintf(stderr, "Error: Send signal(SIGUSR1) error! %s.\n", strerror(errno)); */
        /**     return -1; */
        /** } */
        /**  */
        /** sleep(1); */

        /** value.sival_ptr = buf; */
        sprintf(buf2, "%s%d", buf, i);
        value.sival_ptr = buf2;
        errno = 0;
        if (-1 == sigqueue(getpid(), SIGUSR1, value))
        {
            fprintf(stderr, "Error: Send signal(SIGUSR1) error! %s.\n", strerror(errno));
            return -1;
        }

        i++;
    }

    return 0;
}
