# Adding System Calls in xv6

## Overview

This project involves adding three new system calls to the xv6 operating system: `getNumProc`, `getMaxPid`, and `getProcInfo`. These system calls provide valuable information about the processes in the system and enable the creation of a program similar to the Linux `ps` command.

---

## System Calls Implemented

### 1. `getNumProc()`
#### **What it does:**
Counts and returns the total number of active processes in the system.

#### **How it works:**
- Iterates through the process table (`ptable`) and counts processes that are not in the `UNUSED` state.
- Locks the process table while accessing it to prevent concurrency issues.

---

### 2. `getMaxPid()`
#### **What it does:**
Finds and returns the highest PID (Process ID) among all active processes.

#### **How it works:**
- Scans the process table and keeps track of the largest PID encountered.
- Uses a lock on the process table for safety.

---

### 3. `getProcInfo(pid, &processInfo)`
#### **What it does:**
Retrieves detailed information about a specific process, given its PID.
The following fields are updated in the `processInfo` structure:
- **Process state:** Current state (e.g., running, sleeping, etc.).
- **Parent PID (PPID):** The PID of the parent process (0 for the `init` process).
- **Memory size:** Total memory used by the process (in bytes).
- **Number of open file descriptors (NFD):** Total open file descriptors.
- **Number of context switches (NRSWITCH):** Total context switches for the process.

#### **How it works:**
- Accepts a PID and a pointer to a `processInfo` structure to store the details.
- Returns `0` on success or `-1` if no process with the given PID exists.

---

## Changes Made

### 1. **Created `processInfo.h`**
- Defined the `processInfo` structure for transferring process details between kernel and user space.
- Included `processInfo.h` in `user.h` and `proc.c`.

---

### 2. **Updated System Call Definitions**
- Added definitions for the new system calls in `syscall.h`.
- Registered the system calls in `syscall.c` to handle them in the kernel.

---

### 3. **Added System Call Code**
- Implemented the `getNumProc`, `getMaxPid`, and `getProcInfo` functions in `proc.c`.
- Used locks to ensure safe access to the process table.

---

### 4. **Connected to User Space**
- Declared the system call functions in `user.h` for use in user programs.
- Added corresponding entries in `usys.S` to link kernel calls to user-space calls.

---

### 5. **Modifications in `proc.c`**
- Incremented `p->nrswitch++` in the scheduler function each time the process is switched.
- Calculated `nfd` by counting the number of open file descriptors in `p->ofile`.

---

### 6. **Makefile Modifications**
- Added `_ps` to the `UPROGS` list in the Makefile to ensure the `ps` program is included in the build process.

---

## Example Usage

### **1. `ps` Program**
A new program called `ps` was created to list process information using the new system calls. The output includes:
- PID
- State
- Parent PID (PPID)
- Memory size (SZ)
- Open file descriptors (NFD)
- Number of context switches (NRSWITCH)

#### Example Output:
```plaintext
Total number of active processes: 5
Maximum PID: 10

PID     STATE       PPID    SZ      NFD     NRSWITCH
1       RUNNING     0       1024    3       20
2       SLEEPING    1       2048    2       15
3       RUNNABLE    1       1024    1       12
4       ZOMBIE      2       0       0       8
5       SLEEPING    1       4096    4       18
```

---

## How to Build and Run

1. **Clone the Repository**
   ```bash
   git clone https://github.com/nicolefrumkin/Adding-System-Calls-to-xv6
   cd Adding-System-Calls-to-xv6
   ```

2. **Build the xv6 Kernel**
   ```bash
   make clean
   make
   ```

3. **Run xv6 in QEMU**
   ```bash
   make qemu-nox
   ```

4. **Use the `ps` Command**
   - Run the `ps` program in the xv6 shell to list process information.

---

## Contributors
- **Nicole Frumkin**
- **Yaron Silberstein**
