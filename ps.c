/*
    STATES:
    EMBRYO: A baby process that's still being born/created in the system.
    RUNNING: The process is actively being executed by the CPU right now.
    RUNNABLE: The process is ready to run and just waiting for its turn on the CPU.
    SLEEPING: The process is taking a nap while waiting for something it needs (like a file or network data).
    ZOMBIE: A process that's finished running but its parent process hasn't acknowledged its death yet.   

    PPID (Parent Process ID): The PID of the process that created this process. 

    SZ (Size): The total size of the process in memory pages. 
    This includes code, data, and stack segments. 
    On most systems, a page is 4KB, 
    so multiplying SZ by 4 gives you the approximate size in kilobytes.

    NFD (Number of File Descriptors):
    The count of open file descriptors (files, pipes, sockets, etc.) 
    that the process is currently using. 
    Each open file or network connection consumes a file descriptor.

    NRSWITCH (Number of Context Switches): 
    The number of times the CPU has switched between this process and another one. 
    There are two types:
    - Voluntary: When a process willingly gives up CPU (e.g., waiting for I/O)
    - Involuntary: When the operating system forces a switch to another process
*/
int main() {
    printf("Total number of active processes: %d\n", active_processes);
    printf("Maximum PID: %d\n", max_pid);
    printf("PID    STATE    PPID    SZ    NFD    NRSWITCH");
    return 0;
}