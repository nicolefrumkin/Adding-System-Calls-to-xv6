# xv6: Adding System Calls and User-Space `ps` Command

This project extends the xv6 operating system by introducing three new system calls and a simple `ps` command to display process information and system statistics.

## Features

### New System Calls
1. **`getNumProc()`**: Returns the total number of active processes in the system.
2. **`getMaxPid()`**: Returns the highest PID among all active processes.
3. **`getProcInfo(pid, &processInfo)`**: Provides detailed information about a specific process, including:
   - Process state (e.g., embryo, running, sleeping, zombie)
   - Parent PID
   - Memory size (in bytes)
   - Number of open file descriptors
   - Number of context switches

### `ps` Command
The `ps` command is a user-space program that:
- Displays the total number of active processes and the maximum PID.
- Lists all active processes with details sorted by PID, including:
  - PID
  - State
  - Parent PID
  - Memory size
  - Open file descriptors
  - Context switches

## How to Build and Run
1. Clone the xv6 repository and add the modified files from this project.
2. Build the kernel with `make`.
3. Run xv6 under QEMU with `make qemu-nox`.
4. Use the `ps` command in the xv6 shell to display process information.

## File Changes
- Added new system calls in `sysproc.c` and `syscall.c`.
- Defined the `processInfo` structure in `processInfo.h` and updated `user.h`.
- Modified `proc.c` to implement the system calls.
- Created the `ps.c` user-space program.

---
This project demonstrates adding system calls and creating user-space tools in xv6, offering valuable experience in kernel and OS-level programming.

