/**
 * @file hello_world_app.c
 * @author panxingyuan (panxingyuan1@163.com)
 * @brief The "hello world" application which is used to test "hello world driver".
 * @version 0.1
 * @date 2022-06-25 18:19:04
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(void)
{
    int fd = open("/dev/hello_world_drv_dev", O_RDWR);
    if (-1 == fd)
    {
        fprintf(stderr, "Error: failed to open the file!\n");
        return -EXIT_FAILURE;
    }

    if (-1 == write(fd, "aa", sizeof("aa")))
    {
        fprintf(stderr, "Error: write error! write count:%lu\n", sizeof("aa"));
        perror("");
    }

    close(fd);

    return 0;
}
