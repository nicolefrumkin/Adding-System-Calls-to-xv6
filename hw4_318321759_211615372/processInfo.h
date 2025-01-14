#ifndef PROCESSINFO_H
#define PROCESSINFO_H

struct processInfo {
    int state;      // Process state
    int ppid;       // Parent PID
    int sz;         // Size of process memory
    int nfd;        // Number of open file descriptors
    int nrswitch;   // Number of context switches
};

#endif // PROCESSINFO_H

