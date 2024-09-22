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
#include <strings.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
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
        printf("Usage: %s <pid> <string>.\n", argv[0]);
        return -1;
    }

    int pid = atoi(argv[1]);

    key_t key = ftok(".", 0x01);
    if (key == -1)
    {
        perror("ftok() error!");
        return -1;
    }

    int shmid = shmget(key, 1024, 0777 | IPC_CREAT);
    if (shmid == -1)
    {
        perror("shmget() error!");
        return -1;
    }

    void *shmaddr = shmat(shmid, NULL, 0);
    if (shmaddr == (void *)-1)
    {
        perror("shmat() error!");
        return -1;
    }

    size_t len = strlen(argv[2]);
    len = len < 1024 ? len : 1024; 
    memcpy(shmaddr, argv[2], len);
    union sigval value;
    value.sival_int = (int)len;

    errno = 0;
    if (-1 == sigqueue(pid, SIGUSR1, value))
    {
        fprintf(stderr, "Error: Send signal(SIGUSR1) error! %s.\n", strerror(errno));
        return -1;
    }

    return 0;
}
