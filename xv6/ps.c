#include "types.h"
#include "stat.h"
#include "user.h"
#include "processInfo.h"

void printProcessInfo(int pid) {
    struct processInfo* pinfo = malloc(sizeof(struct processInfo));
    pinfo->nfd =1;
    pinfo->nrswitch = 4;
    pinfo->ppid = 69;
    pinfo->sz = 420;
    pinfo->state = getProcInfo(pid, pinfo);


    //printf(1,"pinfo->state: %d\n", pinfo.state); // for debug
    // Print process information
    char *state;

    switch (pinfo->state) {
        case 0: state = "EMBRYO"; break;
        case 1: state = "RUNNING"; break;
        case 2: state = "RUNNABLE"; break;
        case 3: state = "SLEEPING"; break;
        case 4: state = "ZOMBIE"; break;
        default: state = "UNKNOWN"; break;
    }
    printf(1, "%d\t%s\t%d\t%d\t%d\t%d\n",
           pid, state, pinfo->ppid, pinfo->sz, pinfo->nfd, pinfo->nrswitch);
    free(pinfo);
}

int main(int argc, char *argv[]) {
    int totalProcesses = getNumProc();
    int maxPid = getMaxPid();

    if (totalProcesses < 0 || maxPid < 0) {
        printf(1, "Error: Failed to retrieve system information\n");
        exit();
    }

    // Print header information
    printf(1, "Total number of active processes: %d\n", totalProcesses);
    printf(1, "Maximum PID: %d\n\n", maxPid);

    // Print table header
    printf(1, "PID\tSTATE\tPPID\tSZ\tNFD\tNRSWITCH\n");

    // Iterate through all possible PIDs and print process info
    for (int pid = 1; pid <= maxPid; pid++) {
        printProcessInfo(pid);
    }

    exit();
}
