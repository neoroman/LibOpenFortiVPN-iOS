//
//  posix_spawn.c
//  libopenfortivpn
//
//  Created by Henry Kim on 2021/06/05.
//
#include <stdio.h>
#include <spawn.h>
#include <sys/wait.h>

extern char **environ;

int run_cmd(char *cmd)
{
    pid_t pid;
    char *argv[] = {"sh", "-c", cmd, NULL};
    int status;
    
    status = posix_spawn(&pid, "/bin/sh", NULL, NULL, argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
    return status;
}
