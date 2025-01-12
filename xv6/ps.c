#include "types.h"
#include "stat.h"
#include "user.h"
#include "processInfo.h"

void itoa(int num, char *str, int base);
void printPaddedString(const char *str, int width);
void printPaddedInt(int num, int width);

int main(int argc, char *argv[]) {
    int totalProcesses = getNumProc();
    int maxPid = getMaxPid();

    if (totalProcesses < 0 || maxPid < 0) {
        printf(1, "Error: Failed to retrieve system information\n");
        exit();
    }

    // Print header information
    printf(1, "\nTotal number of active processes: %d\n", totalProcesses);
    printf(1, "Maximum PID: %d\n\n", maxPid);

    // Print table header
        printPaddedString("PID", 10);
        printPaddedString("STATE", 10);
        printPaddedString("PPID", 10);
        printPaddedString("SZ", 10);
        printPaddedString("NFD", 10);
        printPaddedString("NRSWITCH", 10);
        printf(1, "\n");

    // Iterate through all possible PIDs and print process info
    for (int pid = 1; pid <= maxPid; pid++) {
        struct processInfo* pinfo = malloc(sizeof(struct processInfo));
        getProcInfo(pid, pinfo);
        free(pinfo);
    }

    exit();
}

void printPaddedString(const char *str, int width) {
    int len = strlen(str);
    printf(1, "%s", str);
    for (int i = len; i < width; i++) {
        printf(1, " ");
    }
}

void printPaddedInt(int num, int width) {
    char buffer[16];
    itoa(num, buffer, 10); // Convert integer to string
    printPaddedString(buffer, width);
}

// Minimal implementation of `itoa` for xv6
void itoa(int num, char *str, int base) {
    int i = 0;
    int isNegative = 0;

    if (num == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return;
    }

    if (num < 0 && base == 10) {
        isNegative = 1;
        num = -num;
    }

    while (num != 0) {
        int rem = num % base;
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
        num = num / base;
    }

    if (isNegative) {
        str[i++] = '-';
    }

    str[i] = '\0';

    for (int j = 0; j < i / 2; j++) {
        char temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }
}