/**
 * @file receiver.c
 * @author panxingyuan (panxingyuan1@163.com)
 * @brief Receive SIGUSR1 signal with integer argument. 
 * @version 0.1
 * @date 2022-11-23 21:34:47
 *       Create this file. 
 * @copyright Copyright (c) 2022
 * @note The encoding of this file is "utf-8". 
 *
 * 两个不相关联的进程之间无法直接通过信号传递字符串,利用共享内存传递字符串.
 */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>

static void sigusr1_sigaction(int sig, siginfo_t *info, void *ucontent)
{
    key_t key = ftok(".", 0x01);
    if (key == -1)
    {
        perror("ftok() error!");
        exit(EXIT_FAILURE);
    }

    int shmid = shmget(key, 1024, 0777 | IPC_CREAT);
    if (shmid == -1)
    {
        perror("shmget() error!");
        exit(EXIT_FAILURE);
    }

    void *shmaddr = shmat(shmid, NULL, 0);
    if (shmaddr == (void *)-1)
    {
        perror("shmat() error!");
        exit(EXIT_FAILURE);
    }

    char buff[1025] = {0};
    size_t len = info->si_int < 1024 ? info->si_int : 1024;
    memcpy(buff, shmaddr, len);
    printf("Receive signal: %d. Receive string:%s.\n", sig, buff);
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
