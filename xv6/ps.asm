
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

void itoa(int num, char *str, int base);
void printPaddedString(const char *str, int width);
void printPaddedInt(int num, int width);

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
    int totalProcesses = getNumProc();
  14:	e8 da 05 00 00       	call   5f3 <getNumProc>
  19:	89 c3                	mov    %eax,%ebx
    int maxPid = getMaxPid();
  1b:	e8 db 05 00 00       	call   5fb <getMaxPid>
  20:	89 c7                	mov    %eax,%edi

    if (totalProcesses < 0 || maxPid < 0) {
  22:	89 d8                	mov    %ebx,%eax
  24:	09 f8                	or     %edi,%eax
  26:	79 13                	jns    3b <main+0x3b>
        printf(1, "Error: Failed to retrieve system information\n");
  28:	50                   	push   %eax
  29:	50                   	push   %eax
  2a:	68 84 0a 00 00       	push   $0xa84
  2f:	6a 01                	push   $0x1
  31:	e8 aa 06 00 00       	call   6e0 <printf>
        exit();
  36:	e8 18 05 00 00       	call   553 <exit>
    }

    // Print header information
    printf(1, "\nTotal number of active processes: %d\n", totalProcesses);
  3b:	51                   	push   %ecx
  3c:	53                   	push   %ebx
  3d:	68 b4 0a 00 00       	push   $0xab4
  42:	6a 01                	push   $0x1
  44:	e8 97 06 00 00       	call   6e0 <printf>
    printf(1, "Maximum PID: %d\n\n", maxPid);
  49:	83 c4 0c             	add    $0xc,%esp
  4c:	57                   	push   %edi
  4d:	68 4d 0a 00 00       	push   $0xa4d
  52:	6a 01                	push   $0x1
  54:	e8 87 06 00 00       	call   6e0 <printf>

    // Print table header
        printPaddedString("PID", 10);
  59:	5b                   	pop    %ebx
  5a:	5e                   	pop    %esi
  5b:	6a 0a                	push   $0xa
  5d:	68 66 0a 00 00       	push   $0xa66
  62:	e8 69 01 00 00       	call   1d0 <printPaddedString>
        printPaddedString("STATE", 10);
  67:	58                   	pop    %eax
  68:	5a                   	pop    %edx
  69:	6a 0a                	push   $0xa
  6b:	68 5f 0a 00 00       	push   $0xa5f
  70:	e8 5b 01 00 00       	call   1d0 <printPaddedString>
        printPaddedString("PPID", 10);
  75:	59                   	pop    %ecx
  76:	5b                   	pop    %ebx
  77:	6a 0a                	push   $0xa
  79:	68 65 0a 00 00       	push   $0xa65
  7e:	e8 4d 01 00 00       	call   1d0 <printPaddedString>
        printPaddedString("SZ", 10);
  83:	5e                   	pop    %esi
  84:	58                   	pop    %eax
  85:	6a 0a                	push   $0xa
  87:	68 6a 0a 00 00       	push   $0xa6a
  8c:	e8 3f 01 00 00       	call   1d0 <printPaddedString>
        printPaddedString("NFD", 10);
  91:	58                   	pop    %eax
  92:	5a                   	pop    %edx
  93:	6a 0a                	push   $0xa
  95:	68 6d 0a 00 00       	push   $0xa6d
  9a:	e8 31 01 00 00       	call   1d0 <printPaddedString>
        printPaddedString("NRSWITCH", 10);
  9f:	59                   	pop    %ecx
  a0:	5b                   	pop    %ebx
  a1:	6a 0a                	push   $0xa
  a3:	68 71 0a 00 00       	push   $0xa71
  a8:	e8 23 01 00 00       	call   1d0 <printPaddedString>
        printf(1, "\n");
  ad:	5e                   	pop    %esi
  ae:	58                   	pop    %eax
  af:	68 5d 0a 00 00       	push   $0xa5d
  b4:	6a 01                	push   $0x1
  b6:	e8 25 06 00 00       	call   6e0 <printf>

    // Iterate through all possible PIDs and print process info
    for (int pid = 1; pid <= maxPid; pid++) {
  bb:	83 c4 10             	add    $0x10,%esp
  be:	85 ff                	test   %edi,%edi
  c0:	7e 35                	jle    f7 <main+0xf7>
  c2:	be 01 00 00 00       	mov    $0x1,%esi
  c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  ce:	00 
  cf:	90                   	nop
        struct processInfo* pinfo = malloc(sizeof(struct processInfo));
  d0:	83 ec 0c             	sub    $0xc,%esp
  d3:	6a 14                	push   $0x14
  d5:	e8 86 08 00 00       	call   960 <malloc>
  da:	89 c3                	mov    %eax,%ebx
        getProcInfo(pid, pinfo);
  dc:	58                   	pop    %eax
  dd:	5a                   	pop    %edx
  de:	53                   	push   %ebx
  df:	56                   	push   %esi
    for (int pid = 1; pid <= maxPid; pid++) {
  e0:	83 c6 01             	add    $0x1,%esi
        getProcInfo(pid, pinfo);
  e3:	e8 1b 05 00 00       	call   603 <getProcInfo>
        free(pinfo);
  e8:	89 1c 24             	mov    %ebx,(%esp)
  eb:	e8 d0 07 00 00       	call   8c0 <free>
    for (int pid = 1; pid <= maxPid; pid++) {
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	39 f7                	cmp    %esi,%edi
  f5:	7d d9                	jge    d0 <main+0xd0>
    }

    exit();
  f7:	e8 57 04 00 00       	call   553 <exit>
  fc:	66 90                	xchg   %ax,%ax
  fe:	66 90                	xchg   %ax,%ax

00000100 <itoa.part.0>:
    itoa(num, buffer, 10); // Convert integer to string
    printPaddedString(buffer, width);
}

// Minimal implementation of `itoa` for xv6
void itoa(int num, char *str, int base) {
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	57                   	push   %edi
 104:	56                   	push   %esi
 105:	53                   	push   %ebx
 106:	89 d3                	mov    %edx,%ebx
 108:	83 ec 08             	sub    $0x8,%esp
 10b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
        str[i++] = '0';
        str[i] = '\0';
        return;
    }

    if (num < 0 && base == 10) {
 10e:	85 c0                	test   %eax,%eax
 110:	0f 89 aa 00 00 00    	jns    1c0 <itoa.part.0+0xc0>
 116:	83 f9 0a             	cmp    $0xa,%ecx
 119:	0f 85 a1 00 00 00    	jne    1c0 <itoa.part.0+0xc0>
        isNegative = 1;
        num = -num;
 11f:	f7 d8                	neg    %eax
        isNegative = 1;
 121:	bf 01 00 00 00       	mov    $0x1,%edi
    }

    while (num != 0) {
 126:	89 7d ec             	mov    %edi,-0x14(%ebp)
void itoa(int num, char *str, int base) {
 129:	31 f6                	xor    %esi,%esi
 12b:	eb 15                	jmp    142 <itoa.part.0+0x42>
 12d:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 134:	00 
 135:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 13c:	00 
 13d:	8d 76 00             	lea    0x0(%esi),%esi
        int rem = num % base;
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
 140:	89 d6                	mov    %edx,%esi
        int rem = num % base;
 142:	99                   	cltd
 143:	f7 7d f0             	idivl  -0x10(%ebp)
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
 146:	8d 7a 57             	lea    0x57(%edx),%edi
 149:	8d 4a 30             	lea    0x30(%edx),%ecx
 14c:	83 fa 0a             	cmp    $0xa,%edx
 14f:	0f 4d cf             	cmovge %edi,%ecx
 152:	8d 56 01             	lea    0x1(%esi),%edx
 155:	88 4c 13 ff          	mov    %cl,-0x1(%ebx,%edx,1)
    while (num != 0) {
 159:	85 c0                	test   %eax,%eax
 15b:	75 e3                	jne    140 <itoa.part.0+0x40>
 15d:	8b 7d ec             	mov    -0x14(%ebp),%edi
        num = num / base;
    }

    if (isNegative) {
        str[i++] = '-';
 160:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
    if (isNegative) {
 163:	85 ff                	test   %edi,%edi
 165:	74 41                	je     1a8 <itoa.part.0+0xa8>
        str[i++] = '-';
 167:	c6 01 2d             	movb   $0x2d,(%ecx)
 16a:	8d 56 02             	lea    0x2(%esi),%edx
    }

    str[i] = '\0';
 16d:	c6 44 33 02 00       	movb   $0x0,0x2(%ebx,%esi,1)

    for (int j = 0; j < i / 2; j++) {
 172:	d1 fe                	sar    $1,%esi
 174:	83 c6 01             	add    $0x1,%esi
 177:	8d 54 13 ff          	lea    -0x1(%ebx,%edx,1),%edx
 17b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        char temp = str[j];
 180:	0f b6 3c 03          	movzbl (%ebx,%eax,1),%edi
        str[j] = str[i - j - 1];
 184:	0f b6 0a             	movzbl (%edx),%ecx
    for (int j = 0; j < i / 2; j++) {
 187:	83 ea 01             	sub    $0x1,%edx
        str[j] = str[i - j - 1];
 18a:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
        str[i - j - 1] = temp;
 18d:	89 f9                	mov    %edi,%ecx
    for (int j = 0; j < i / 2; j++) {
 18f:	83 c0 01             	add    $0x1,%eax
        str[i - j - 1] = temp;
 192:	88 4a 01             	mov    %cl,0x1(%edx)
    for (int j = 0; j < i / 2; j++) {
 195:	39 f0                	cmp    %esi,%eax
 197:	7c e7                	jl     180 <itoa.part.0+0x80>
    }
 199:	83 c4 08             	add    $0x8,%esp
 19c:	5b                   	pop    %ebx
 19d:	5e                   	pop    %esi
 19e:	5f                   	pop    %edi
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret
 1a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (int j = 0; j < i / 2; j++) {
 1a8:	89 d6                	mov    %edx,%esi
    str[i] = '\0';
 1aa:	c6 01 00             	movb   $0x0,(%ecx)
    for (int j = 0; j < i / 2; j++) {
 1ad:	d1 fe                	sar    $1,%esi
 1af:	75 c6                	jne    177 <itoa.part.0+0x77>
 1b1:	83 c4 08             	add    $0x8,%esp
 1b4:	5b                   	pop    %ebx
 1b5:	5e                   	pop    %esi
 1b6:	5f                   	pop    %edi
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    int isNegative = 0;
 1c0:	31 ff                	xor    %edi,%edi
 1c2:	e9 5f ff ff ff       	jmp    126 <itoa.part.0+0x26>
 1c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1ce:	00 
 1cf:	90                   	nop

000001d0 <printPaddedString>:
void printPaddedString(const char *str, int width) {
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
 1d5:	53                   	push   %ebx
 1d6:	83 ec 18             	sub    $0x18,%esp
 1d9:	8b 7d 08             	mov    0x8(%ebp),%edi
 1dc:	8b 75 0c             	mov    0xc(%ebp),%esi
    int len = strlen(str);
 1df:	57                   	push   %edi
 1e0:	e8 bb 01 00 00       	call   3a0 <strlen>
    printf(1, "%s", str);
 1e5:	83 c4 0c             	add    $0xc,%esp
 1e8:	57                   	push   %edi
    int len = strlen(str);
 1e9:	89 c3                	mov    %eax,%ebx
    printf(1, "%s", str);
 1eb:	68 48 0a 00 00       	push   $0xa48
 1f0:	6a 01                	push   $0x1
 1f2:	e8 e9 04 00 00       	call   6e0 <printf>
    for (int i = len; i < width; i++) {
 1f7:	83 c4 10             	add    $0x10,%esp
 1fa:	39 f3                	cmp    %esi,%ebx
 1fc:	7d 1b                	jge    219 <printPaddedString+0x49>
 1fe:	66 90                	xchg   %ax,%ax
        printf(1, " ");
 200:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 203:	83 c3 01             	add    $0x1,%ebx
        printf(1, " ");
 206:	68 4b 0a 00 00       	push   $0xa4b
 20b:	6a 01                	push   $0x1
 20d:	e8 ce 04 00 00       	call   6e0 <printf>
    for (int i = len; i < width; i++) {
 212:	83 c4 10             	add    $0x10,%esp
 215:	39 de                	cmp    %ebx,%esi
 217:	75 e7                	jne    200 <printPaddedString+0x30>
}
 219:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21c:	5b                   	pop    %ebx
 21d:	5e                   	pop    %esi
 21e:	5f                   	pop    %edi
 21f:	5d                   	pop    %ebp
 220:	c3                   	ret
 221:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 228:	00 
 229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000230 <printPaddedInt>:
void printPaddedInt(int num, int width) {
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	53                   	push   %ebx
 236:	83 ec 1c             	sub    $0x1c,%esp
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	8b 75 0c             	mov    0xc(%ebp),%esi
    if (num == 0) {
 23f:	85 c0                	test   %eax,%eax
 241:	74 65                	je     2a8 <printPaddedInt+0x78>
 243:	8d 7d d8             	lea    -0x28(%ebp),%edi
 246:	b9 0a 00 00 00       	mov    $0xa,%ecx
 24b:	89 fa                	mov    %edi,%edx
 24d:	e8 ae fe ff ff       	call   100 <itoa.part.0>
    int len = strlen(str);
 252:	83 ec 0c             	sub    $0xc,%esp
 255:	57                   	push   %edi
 256:	e8 45 01 00 00       	call   3a0 <strlen>
    printf(1, "%s", str);
 25b:	83 c4 0c             	add    $0xc,%esp
 25e:	57                   	push   %edi
    int len = strlen(str);
 25f:	89 c3                	mov    %eax,%ebx
    printf(1, "%s", str);
 261:	68 48 0a 00 00       	push   $0xa48
 266:	6a 01                	push   $0x1
 268:	e8 73 04 00 00       	call   6e0 <printf>
    for (int i = len; i < width; i++) {
 26d:	83 c4 10             	add    $0x10,%esp
 270:	39 de                	cmp    %ebx,%esi
 272:	7e 25                	jle    299 <printPaddedInt+0x69>
 274:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27b:	00 
 27c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, " ");
 280:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 283:	83 c3 01             	add    $0x1,%ebx
        printf(1, " ");
 286:	68 4b 0a 00 00       	push   $0xa4b
 28b:	6a 01                	push   $0x1
 28d:	e8 4e 04 00 00       	call   6e0 <printf>
    for (int i = len; i < width; i++) {
 292:	83 c4 10             	add    $0x10,%esp
 295:	39 de                	cmp    %ebx,%esi
 297:	75 e7                	jne    280 <printPaddedInt+0x50>
}
 299:	8d 65 f4             	lea    -0xc(%ebp),%esp
 29c:	5b                   	pop    %ebx
 29d:	5e                   	pop    %esi
 29e:	5f                   	pop    %edi
 29f:	5d                   	pop    %ebp
 2a0:	c3                   	ret
 2a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        str[i++] = '0';
 2a8:	b8 30 00 00 00       	mov    $0x30,%eax
 2ad:	8d 7d d8             	lea    -0x28(%ebp),%edi
 2b0:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
        return;
 2b4:	eb 9c                	jmp    252 <printPaddedInt+0x22>
 2b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2bd:	00 
 2be:	66 90                	xchg   %ax,%ax

000002c0 <itoa>:
void itoa(int num, char *str, int base) {
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 2c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if (num == 0) {
 2cc:	85 c0                	test   %eax,%eax
 2ce:	74 10                	je     2e0 <itoa+0x20>
 2d0:	5d                   	pop    %ebp
 2d1:	e9 2a fe ff ff       	jmp    100 <itoa.part.0>
 2d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2dd:	00 
 2de:	66 90                	xchg   %ax,%ax
        str[i++] = '0';
 2e0:	b8 30 00 00 00       	mov    $0x30,%eax
 2e5:	66 89 02             	mov    %ax,(%edx)
 2e8:	5d                   	pop    %ebp
 2e9:	c3                   	ret
 2ea:	66 90                	xchg   %ax,%ax
 2ec:	66 90                	xchg   %ax,%ax
 2ee:	66 90                	xchg   %ax,%ax
 2f0:	66 90                	xchg   %ax,%ax
 2f2:	66 90                	xchg   %ax,%ax
 2f4:	66 90                	xchg   %ax,%ax
 2f6:	66 90                	xchg   %ax,%ax
 2f8:	66 90                	xchg   %ax,%ax
 2fa:	66 90                	xchg   %ax,%ax
 2fc:	66 90                	xchg   %ax,%ax
 2fe:	66 90                	xchg   %ax,%ax

00000300 <strcpy>:
#include "x86.h"
#include "processInfo.h"

char*
strcpy(char *s, const char *t)
{
 300:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 301:	31 c0                	xor    %eax,%eax
{
 303:	89 e5                	mov    %esp,%ebp
 305:	53                   	push   %ebx
 306:	8b 4d 08             	mov    0x8(%ebp),%ecx
 309:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 310:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 314:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 317:	83 c0 01             	add    $0x1,%eax
 31a:	84 d2                	test   %dl,%dl
 31c:	75 f2                	jne    310 <strcpy+0x10>
    ;
  return os;
}
 31e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 321:	89 c8                	mov    %ecx,%eax
 323:	c9                   	leave
 324:	c3                   	ret
 325:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 32c:	00 
 32d:	8d 76 00             	lea    0x0(%esi),%esi

00000330 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	53                   	push   %ebx
 334:	8b 55 08             	mov    0x8(%ebp),%edx
 337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 33a:	0f b6 02             	movzbl (%edx),%eax
 33d:	84 c0                	test   %al,%al
 33f:	75 2f                	jne    370 <strcmp+0x40>
 341:	eb 4a                	jmp    38d <strcmp+0x5d>
 343:	eb 1b                	jmp    360 <strcmp+0x30>
 345:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 34c:	00 
 34d:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 354:	00 
 355:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 35c:	00 
 35d:	8d 76 00             	lea    0x0(%esi),%esi
 360:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 364:	83 c2 01             	add    $0x1,%edx
 367:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 36a:	84 c0                	test   %al,%al
 36c:	74 12                	je     380 <strcmp+0x50>
 36e:	89 d9                	mov    %ebx,%ecx
 370:	0f b6 19             	movzbl (%ecx),%ebx
 373:	38 c3                	cmp    %al,%bl
 375:	74 e9                	je     360 <strcmp+0x30>
  return (uchar)*p - (uchar)*q;
 377:	29 d8                	sub    %ebx,%eax
}
 379:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 37c:	c9                   	leave
 37d:	c3                   	ret
 37e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 380:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 384:	31 c0                	xor    %eax,%eax
 386:	29 d8                	sub    %ebx,%eax
}
 388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 38b:	c9                   	leave
 38c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 38d:	0f b6 19             	movzbl (%ecx),%ebx
 390:	31 c0                	xor    %eax,%eax
 392:	eb e3                	jmp    377 <strcmp+0x47>
 394:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 39b:	00 
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003a0 <strlen>:

uint
strlen(const char *s)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3a6:	80 3a 00             	cmpb   $0x0,(%edx)
 3a9:	74 15                	je     3c0 <strlen+0x20>
 3ab:	31 c0                	xor    %eax,%eax
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
 3b0:	83 c0 01             	add    $0x1,%eax
 3b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3b7:	89 c1                	mov    %eax,%ecx
 3b9:	75 f5                	jne    3b0 <strlen+0x10>
    ;
  return n;
}
 3bb:	89 c8                	mov    %ecx,%eax
 3bd:	5d                   	pop    %ebp
 3be:	c3                   	ret
 3bf:	90                   	nop
  for(n = 0; s[n]; n++)
 3c0:	31 c9                	xor    %ecx,%ecx
}
 3c2:	5d                   	pop    %ebp
 3c3:	89 c8                	mov    %ecx,%eax
 3c5:	c3                   	ret
 3c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3cd:	00 
 3ce:	66 90                	xchg   %ax,%ax

000003d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3da:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dd:	89 d7                	mov    %edx,%edi
 3df:	fc                   	cld
 3e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3e2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 3e5:	89 d0                	mov    %edx,%eax
 3e7:	c9                   	leave
 3e8:	c3                   	ret
 3e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003f0 <strchr>:

char*
strchr(const char *s, char c)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3fa:	0f b6 10             	movzbl (%eax),%edx
 3fd:	84 d2                	test   %dl,%dl
 3ff:	75 1a                	jne    41b <strchr+0x2b>
 401:	eb 25                	jmp    428 <strchr+0x38>
 403:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 40a:	00 
 40b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 410:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 414:	83 c0 01             	add    $0x1,%eax
 417:	84 d2                	test   %dl,%dl
 419:	74 0d                	je     428 <strchr+0x38>
    if(*s == c)
 41b:	38 d1                	cmp    %dl,%cl
 41d:	75 f1                	jne    410 <strchr+0x20>
      return (char*)s;
  return 0;
}
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 428:	31 c0                	xor    %eax,%eax
}
 42a:	5d                   	pop    %ebp
 42b:	c3                   	ret
 42c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000430 <gets>:

char*
gets(char *buf, int max)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 435:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 438:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 439:	31 db                	xor    %ebx,%ebx
{
 43b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 43e:	eb 27                	jmp    467 <gets+0x37>
    cc = read(0, &c, 1);
 440:	83 ec 04             	sub    $0x4,%esp
 443:	6a 01                	push   $0x1
 445:	56                   	push   %esi
 446:	6a 00                	push   $0x0
 448:	e8 1e 01 00 00       	call   56b <read>
    if(cc < 1)
 44d:	83 c4 10             	add    $0x10,%esp
 450:	85 c0                	test   %eax,%eax
 452:	7e 1d                	jle    471 <gets+0x41>
      break;
    buf[i++] = c;
 454:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 458:	8b 55 08             	mov    0x8(%ebp),%edx
 45b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 45f:	3c 0a                	cmp    $0xa,%al
 461:	74 10                	je     473 <gets+0x43>
 463:	3c 0d                	cmp    $0xd,%al
 465:	74 0c                	je     473 <gets+0x43>
  for(i=0; i+1 < max; ){
 467:	89 df                	mov    %ebx,%edi
 469:	83 c3 01             	add    $0x1,%ebx
 46c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 46f:	7c cf                	jl     440 <gets+0x10>
 471:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 47a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47d:	5b                   	pop    %ebx
 47e:	5e                   	pop    %esi
 47f:	5f                   	pop    %edi
 480:	5d                   	pop    %ebp
 481:	c3                   	ret
 482:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 489:	00 
 48a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000490 <stat>:

int
stat(const char *n, struct stat *st)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	56                   	push   %esi
 494:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 495:	83 ec 08             	sub    $0x8,%esp
 498:	6a 00                	push   $0x0
 49a:	ff 75 08             	push   0x8(%ebp)
 49d:	e8 f1 00 00 00       	call   593 <open>
  if(fd < 0)
 4a2:	83 c4 10             	add    $0x10,%esp
 4a5:	85 c0                	test   %eax,%eax
 4a7:	78 27                	js     4d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4a9:	83 ec 08             	sub    $0x8,%esp
 4ac:	ff 75 0c             	push   0xc(%ebp)
 4af:	89 c3                	mov    %eax,%ebx
 4b1:	50                   	push   %eax
 4b2:	e8 f4 00 00 00       	call   5ab <fstat>
  close(fd);
 4b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ba:	89 c6                	mov    %eax,%esi
  close(fd);
 4bc:	e8 ba 00 00 00       	call   57b <close>
  return r;
 4c1:	83 c4 10             	add    $0x10,%esp
}
 4c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4c7:	89 f0                	mov    %esi,%eax
 4c9:	5b                   	pop    %ebx
 4ca:	5e                   	pop    %esi
 4cb:	5d                   	pop    %ebp
 4cc:	c3                   	ret
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4d5:	eb ed                	jmp    4c4 <stat+0x34>
 4d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4de:	00 
 4df:	90                   	nop

000004e0 <atoi>:

int
atoi(const char *s)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	53                   	push   %ebx
 4e4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4e7:	0f be 02             	movsbl (%edx),%eax
 4ea:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4ed:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4f5:	77 1e                	ja     515 <atoi+0x35>
 4f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4fe:	00 
 4ff:	90                   	nop
    n = n*10 + *s++ - '0';
 500:	83 c2 01             	add    $0x1,%edx
 503:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 506:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 50a:	0f be 02             	movsbl (%edx),%eax
 50d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 510:	80 fb 09             	cmp    $0x9,%bl
 513:	76 eb                	jbe    500 <atoi+0x20>
  return n;
}
 515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 518:	89 c8                	mov    %ecx,%eax
 51a:	c9                   	leave
 51b:	c3                   	ret
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000520 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	8b 45 10             	mov    0x10(%ebp),%eax
 527:	8b 55 08             	mov    0x8(%ebp),%edx
 52a:	56                   	push   %esi
 52b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 52e:	85 c0                	test   %eax,%eax
 530:	7e 13                	jle    545 <memmove+0x25>
 532:	01 d0                	add    %edx,%eax
  dst = vdst;
 534:	89 d7                	mov    %edx,%edi
 536:	66 90                	xchg   %ax,%ax
 538:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 53f:	00 
    *dst++ = *src++;
 540:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 541:	39 f8                	cmp    %edi,%eax
 543:	75 fb                	jne    540 <memmove+0x20>
  return vdst;
}
 545:	5e                   	pop    %esi
 546:	89 d0                	mov    %edx,%eax
 548:	5f                   	pop    %edi
 549:	5d                   	pop    %ebp
 54a:	c3                   	ret

0000054b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 54b:	b8 01 00 00 00       	mov    $0x1,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <exit>:
SYSCALL(exit)
 553:	b8 02 00 00 00       	mov    $0x2,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <wait>:
SYSCALL(wait)
 55b:	b8 03 00 00 00       	mov    $0x3,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <pipe>:
SYSCALL(pipe)
 563:	b8 04 00 00 00       	mov    $0x4,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <read>:
SYSCALL(read)
 56b:	b8 05 00 00 00       	mov    $0x5,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <write>:
SYSCALL(write)
 573:	b8 10 00 00 00       	mov    $0x10,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <close>:
SYSCALL(close)
 57b:	b8 15 00 00 00       	mov    $0x15,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <kill>:
SYSCALL(kill)
 583:	b8 06 00 00 00       	mov    $0x6,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <exec>:
SYSCALL(exec)
 58b:	b8 07 00 00 00       	mov    $0x7,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <open>:
SYSCALL(open)
 593:	b8 0f 00 00 00       	mov    $0xf,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <mknod>:
SYSCALL(mknod)
 59b:	b8 11 00 00 00       	mov    $0x11,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <unlink>:
SYSCALL(unlink)
 5a3:	b8 12 00 00 00       	mov    $0x12,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <fstat>:
SYSCALL(fstat)
 5ab:	b8 08 00 00 00       	mov    $0x8,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <link>:
SYSCALL(link)
 5b3:	b8 13 00 00 00       	mov    $0x13,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <mkdir>:
SYSCALL(mkdir)
 5bb:	b8 14 00 00 00       	mov    $0x14,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <chdir>:
SYSCALL(chdir)
 5c3:	b8 09 00 00 00       	mov    $0x9,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret

000005cb <dup>:
SYSCALL(dup)
 5cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret

000005d3 <getpid>:
SYSCALL(getpid)
 5d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret

000005db <sbrk>:
SYSCALL(sbrk)
 5db:	b8 0c 00 00 00       	mov    $0xc,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret

000005e3 <sleep>:
SYSCALL(sleep)
 5e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret

000005eb <uptime>:
SYSCALL(uptime)
 5eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret

000005f3 <getNumProc>:
SYSCALL(getNumProc)
 5f3:	b8 16 00 00 00       	mov    $0x16,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret

000005fb <getMaxPid>:
SYSCALL(getMaxPid)
 5fb:	b8 17 00 00 00       	mov    $0x17,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret

00000603 <getProcInfo>:
SYSCALL(getProcInfo)
 603:	b8 18 00 00 00       	mov    $0x18,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret
 60b:	66 90                	xchg   %ax,%ax
 60d:	66 90                	xchg   %ax,%ax
 60f:	66 90                	xchg   %ax,%ax
 611:	66 90                	xchg   %ax,%ax
 613:	66 90                	xchg   %ax,%ax
 615:	66 90                	xchg   %ax,%ax
 617:	66 90                	xchg   %ax,%ax
 619:	66 90                	xchg   %ax,%ax
 61b:	66 90                	xchg   %ax,%ax
 61d:	66 90                	xchg   %ax,%ax
 61f:	90                   	nop

00000620 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 628:	89 d1                	mov    %edx,%ecx
{
 62a:	83 ec 3c             	sub    $0x3c,%esp
 62d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  if(sgn && xx < 0){
 630:	85 d2                	test   %edx,%edx
 632:	0f 89 98 00 00 00    	jns    6d0 <printint+0xb0>
 638:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 63c:	0f 84 8e 00 00 00    	je     6d0 <printint+0xb0>
    x = -xx;
 642:	f7 d9                	neg    %ecx
    neg = 1;
 644:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 649:	89 45 c0             	mov    %eax,-0x40(%ebp)
 64c:	31 f6                	xor    %esi,%esi
 64e:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 655:	00 
 656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 65d:	00 
 65e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 660:	89 c8                	mov    %ecx,%eax
 662:	31 d2                	xor    %edx,%edx
 664:	89 f7                	mov    %esi,%edi
 666:	f7 f3                	div    %ebx
 668:	8d 76 01             	lea    0x1(%esi),%esi
 66b:	0f b6 92 34 0b 00 00 	movzbl 0xb34(%edx),%edx
 672:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 676:	89 ca                	mov    %ecx,%edx
 678:	89 c1                	mov    %eax,%ecx
 67a:	39 da                	cmp    %ebx,%edx
 67c:	73 e2                	jae    660 <printint+0x40>
  if(neg)
 67e:	8b 45 c0             	mov    -0x40(%ebp),%eax
 681:	85 c0                	test   %eax,%eax
 683:	74 07                	je     68c <printint+0x6c>
    buf[i++] = '-';
 685:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 68a:	89 f7                	mov    %esi,%edi

  while(--i >= 0)
 68c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 68f:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 692:	01 df                	add    %ebx,%edi
 694:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 69b:	00 
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 6a0:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 6a3:	83 ec 04             	sub    $0x4,%esp
 6a6:	88 45 d7             	mov    %al,-0x29(%ebp)
 6a9:	8d 45 d7             	lea    -0x29(%ebp),%eax
 6ac:	6a 01                	push   $0x1
 6ae:	50                   	push   %eax
 6af:	56                   	push   %esi
 6b0:	e8 be fe ff ff       	call   573 <write>
  while(--i >= 0)
 6b5:	89 f8                	mov    %edi,%eax
 6b7:	83 c4 10             	add    $0x10,%esp
 6ba:	83 ef 01             	sub    $0x1,%edi
 6bd:	39 d8                	cmp    %ebx,%eax
 6bf:	75 df                	jne    6a0 <printint+0x80>
}
 6c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c4:	5b                   	pop    %ebx
 6c5:	5e                   	pop    %esi
 6c6:	5f                   	pop    %edi
 6c7:	5d                   	pop    %ebp
 6c8:	c3                   	ret
 6c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6d0:	31 c0                	xor    %eax,%eax
 6d2:	e9 72 ff ff ff       	jmp    649 <printint+0x29>
 6d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6de:	00 
 6df:	90                   	nop

000006e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 6ec:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 6ef:	0f b6 13             	movzbl (%ebx),%edx
 6f2:	83 c3 01             	add    $0x1,%ebx
 6f5:	84 d2                	test   %dl,%dl
 6f7:	0f 84 a0 00 00 00    	je     79d <printf+0xbd>
 6fd:	8d 45 10             	lea    0x10(%ebp),%eax
 700:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 703:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 706:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 709:	eb 28                	jmp    733 <printf+0x53>
 70b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 710:	83 ec 04             	sub    $0x4,%esp
 713:	8d 45 e7             	lea    -0x19(%ebp),%eax
 716:	88 55 e7             	mov    %dl,-0x19(%ebp)
  for(i = 0; fmt[i]; i++){
 719:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 71c:	6a 01                	push   $0x1
 71e:	50                   	push   %eax
 71f:	56                   	push   %esi
 720:	e8 4e fe ff ff       	call   573 <write>
  for(i = 0; fmt[i]; i++){
 725:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 729:	83 c4 10             	add    $0x10,%esp
 72c:	84 d2                	test   %dl,%dl
 72e:	74 6d                	je     79d <printf+0xbd>
    c = fmt[i] & 0xff;
 730:	0f b6 c2             	movzbl %dl,%eax
      if(c == '%'){
 733:	83 f8 25             	cmp    $0x25,%eax
 736:	75 d8                	jne    710 <printf+0x30>
  for(i = 0; fmt[i]; i++){
 738:	0f b6 13             	movzbl (%ebx),%edx
 73b:	84 d2                	test   %dl,%dl
 73d:	74 5e                	je     79d <printf+0xbd>
    c = fmt[i] & 0xff;
 73f:	0f b6 c2             	movzbl %dl,%eax
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
 742:	80 fa 25             	cmp    $0x25,%dl
 745:	0f 84 1d 01 00 00    	je     868 <printf+0x188>
 74b:	83 e8 63             	sub    $0x63,%eax
 74e:	83 f8 15             	cmp    $0x15,%eax
 751:	77 0d                	ja     760 <printf+0x80>
 753:	ff 24 85 dc 0a 00 00 	jmp    *0xadc(,%eax,4)
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 760:	83 ec 04             	sub    $0x4,%esp
 763:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 766:	88 55 d0             	mov    %dl,-0x30(%ebp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 769:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 76d:	6a 01                	push   $0x1
 76f:	51                   	push   %ecx
 770:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 773:	56                   	push   %esi
 774:	e8 fa fd ff ff       	call   573 <write>
        putc(fd, c);
 779:	0f b6 55 d0          	movzbl -0x30(%ebp),%edx
  write(fd, &c, 1);
 77d:	83 c4 0c             	add    $0xc,%esp
 780:	88 55 e7             	mov    %dl,-0x19(%ebp)
 783:	6a 01                	push   $0x1
 785:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 788:	51                   	push   %ecx
 789:	56                   	push   %esi
 78a:	e8 e4 fd ff ff       	call   573 <write>
  for(i = 0; fmt[i]; i++){
 78f:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 793:	83 c3 02             	add    $0x2,%ebx
 796:	83 c4 10             	add    $0x10,%esp
 799:	84 d2                	test   %dl,%dl
 79b:	75 93                	jne    730 <printf+0x50>
      }
      state = 0;
    }
  }
}
 79d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7a0:	5b                   	pop    %ebx
 7a1:	5e                   	pop    %esi
 7a2:	5f                   	pop    %edi
 7a3:	5d                   	pop    %ebp
 7a4:	c3                   	ret
 7a5:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7a8:	83 ec 0c             	sub    $0xc,%esp
 7ab:	8b 17                	mov    (%edi),%edx
 7ad:	b9 10 00 00 00       	mov    $0x10,%ecx
 7b2:	89 f0                	mov    %esi,%eax
 7b4:	6a 00                	push   $0x0
        ap++;
 7b6:	83 c7 04             	add    $0x4,%edi
        printint(fd, *ap, 16, 0);
 7b9:	e8 62 fe ff ff       	call   620 <printint>
  for(i = 0; fmt[i]; i++){
 7be:	eb cf                	jmp    78f <printf+0xaf>
        s = (char*)*ap;
 7c0:	8b 07                	mov    (%edi),%eax
        ap++;
 7c2:	83 c7 04             	add    $0x4,%edi
        if(s == 0)
 7c5:	85 c0                	test   %eax,%eax
 7c7:	0f 84 b3 00 00 00    	je     880 <printf+0x1a0>
        while(*s != 0){
 7cd:	0f b6 10             	movzbl (%eax),%edx
 7d0:	84 d2                	test   %dl,%dl
 7d2:	0f 84 ba 00 00 00    	je     892 <printf+0x1b2>
 7d8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7db:	89 c7                	mov    %eax,%edi
 7dd:	89 d0                	mov    %edx,%eax
 7df:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 7e2:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7e5:	89 fb                	mov    %edi,%ebx
 7e7:	89 cf                	mov    %ecx,%edi
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 7f0:	83 ec 04             	sub    $0x4,%esp
 7f3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 7f6:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 7f9:	6a 01                	push   $0x1
 7fb:	57                   	push   %edi
 7fc:	56                   	push   %esi
 7fd:	e8 71 fd ff ff       	call   573 <write>
        while(*s != 0){
 802:	0f b6 03             	movzbl (%ebx),%eax
 805:	83 c4 10             	add    $0x10,%esp
 808:	84 c0                	test   %al,%al
 80a:	75 e4                	jne    7f0 <printf+0x110>
 80c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 80f:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 813:	83 c3 02             	add    $0x2,%ebx
 816:	84 d2                	test   %dl,%dl
 818:	0f 85 e5 fe ff ff    	jne    703 <printf+0x23>
 81e:	e9 7a ff ff ff       	jmp    79d <printf+0xbd>
 823:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 828:	83 ec 0c             	sub    $0xc,%esp
 82b:	8b 17                	mov    (%edi),%edx
 82d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 832:	89 f0                	mov    %esi,%eax
 834:	6a 01                	push   $0x1
        ap++;
 836:	83 c7 04             	add    $0x4,%edi
        printint(fd, *ap, 10, 1);
 839:	e8 e2 fd ff ff       	call   620 <printint>
  for(i = 0; fmt[i]; i++){
 83e:	e9 4c ff ff ff       	jmp    78f <printf+0xaf>
 843:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 848:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 84a:	83 ec 04             	sub    $0x4,%esp
 84d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
        ap++;
 850:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 853:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 856:	6a 01                	push   $0x1
 858:	51                   	push   %ecx
 859:	56                   	push   %esi
 85a:	e8 14 fd ff ff       	call   573 <write>
  for(i = 0; fmt[i]; i++){
 85f:	e9 2b ff ff ff       	jmp    78f <printf+0xaf>
 864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 868:	83 ec 04             	sub    $0x4,%esp
 86b:	88 55 e7             	mov    %dl,-0x19(%ebp)
 86e:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 871:	6a 01                	push   $0x1
 873:	e9 10 ff ff ff       	jmp    788 <printf+0xa8>
 878:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 87f:	00 
          s = "(null)";
 880:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 883:	b8 28 00 00 00       	mov    $0x28,%eax
 888:	bf 7a 0a 00 00       	mov    $0xa7a,%edi
 88d:	e9 4d ff ff ff       	jmp    7df <printf+0xff>
  for(i = 0; fmt[i]; i++){
 892:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 896:	83 c3 02             	add    $0x2,%ebx
 899:	84 d2                	test   %dl,%dl
 89b:	0f 85 8f fe ff ff    	jne    730 <printf+0x50>
 8a1:	e9 f7 fe ff ff       	jmp    79d <printf+0xbd>
 8a6:	66 90                	xchg   %ax,%ax
 8a8:	66 90                	xchg   %ax,%ax
 8aa:	66 90                	xchg   %ax,%ax
 8ac:	66 90                	xchg   %ax,%ax
 8ae:	66 90                	xchg   %ax,%ax
 8b0:	66 90                	xchg   %ax,%ax
 8b2:	66 90                	xchg   %ax,%ax
 8b4:	66 90                	xchg   %ax,%ax
 8b6:	66 90                	xchg   %ax,%ax
 8b8:	66 90                	xchg   %ax,%ax
 8ba:	66 90                	xchg   %ax,%ax
 8bc:	66 90                	xchg   %ax,%ax
 8be:	66 90                	xchg   %ax,%ax

000008c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c1:	a1 a0 0e 00 00       	mov    0xea0,%eax
{
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	57                   	push   %edi
 8c9:	56                   	push   %esi
 8ca:	53                   	push   %ebx
 8cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 8ce:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 8d8:	00 
 8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8e0:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e2:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e4:	39 ca                	cmp    %ecx,%edx
 8e6:	73 30                	jae    918 <free+0x58>
 8e8:	39 c1                	cmp    %eax,%ecx
 8ea:	72 04                	jb     8f0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ec:	39 c2                	cmp    %eax,%edx
 8ee:	72 f0                	jb     8e0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8f3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8f6:	39 f8                	cmp    %edi,%eax
 8f8:	74 36                	je     930 <free+0x70>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8fa:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8fd:	8b 42 04             	mov    0x4(%edx),%eax
 900:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 903:	39 f1                	cmp    %esi,%ecx
 905:	74 40                	je     947 <free+0x87>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 907:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 909:	5b                   	pop    %ebx
  freep = p;
 90a:	89 15 a0 0e 00 00    	mov    %edx,0xea0
}
 910:	5e                   	pop    %esi
 911:	5f                   	pop    %edi
 912:	5d                   	pop    %ebp
 913:	c3                   	ret
 914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 918:	39 c2                	cmp    %eax,%edx
 91a:	72 c4                	jb     8e0 <free+0x20>
 91c:	39 c1                	cmp    %eax,%ecx
 91e:	73 c0                	jae    8e0 <free+0x20>
  if(bp + bp->s.size == p->s.ptr){
 920:	8b 73 fc             	mov    -0x4(%ebx),%esi
 923:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 926:	39 f8                	cmp    %edi,%eax
 928:	75 d0                	jne    8fa <free+0x3a>
 92a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 930:	03 70 04             	add    0x4(%eax),%esi
 933:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 936:	8b 02                	mov    (%edx),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 93d:	8b 42 04             	mov    0x4(%edx),%eax
 940:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 943:	39 f1                	cmp    %esi,%ecx
 945:	75 c0                	jne    907 <free+0x47>
    p->s.size += bp->s.size;
 947:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 94a:	89 15 a0 0e 00 00    	mov    %edx,0xea0
    p->s.size += bp->s.size;
 950:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 953:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 956:	89 0a                	mov    %ecx,(%edx)
}
 958:	5b                   	pop    %ebx
 959:	5e                   	pop    %esi
 95a:	5f                   	pop    %edi
 95b:	5d                   	pop    %ebp
 95c:	c3                   	ret
 95d:	8d 76 00             	lea    0x0(%esi),%esi

00000960 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 960:	55                   	push   %ebp
 961:	89 e5                	mov    %esp,%ebp
 963:	57                   	push   %edi
 964:	56                   	push   %esi
 965:	53                   	push   %ebx
 966:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 969:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 96c:	8b 15 a0 0e 00 00    	mov    0xea0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 972:	8d 78 07             	lea    0x7(%eax),%edi
 975:	c1 ef 03             	shr    $0x3,%edi
 978:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 97b:	85 d2                	test   %edx,%edx
 97d:	0f 84 8d 00 00 00    	je     a10 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 983:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 985:	8b 48 04             	mov    0x4(%eax),%ecx
 988:	39 f9                	cmp    %edi,%ecx
 98a:	73 64                	jae    9f0 <malloc+0x90>
  if(nu < 4096)
 98c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 991:	39 df                	cmp    %ebx,%edi
 993:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 996:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 99d:	eb 0a                	jmp    9a9 <malloc+0x49>
 99f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9a2:	8b 48 04             	mov    0x4(%eax),%ecx
 9a5:	39 f9                	cmp    %edi,%ecx
 9a7:	73 47                	jae    9f0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a9:	89 c2                	mov    %eax,%edx
 9ab:	39 05 a0 0e 00 00    	cmp    %eax,0xea0
 9b1:	75 ed                	jne    9a0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 9b3:	83 ec 0c             	sub    $0xc,%esp
 9b6:	56                   	push   %esi
 9b7:	e8 1f fc ff ff       	call   5db <sbrk>
  if(p == (char*)-1)
 9bc:	83 c4 10             	add    $0x10,%esp
 9bf:	83 f8 ff             	cmp    $0xffffffff,%eax
 9c2:	74 1c                	je     9e0 <malloc+0x80>
  hp->s.size = nu;
 9c4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9c7:	83 ec 0c             	sub    $0xc,%esp
 9ca:	83 c0 08             	add    $0x8,%eax
 9cd:	50                   	push   %eax
 9ce:	e8 ed fe ff ff       	call   8c0 <free>
  return freep;
 9d3:	8b 15 a0 0e 00 00    	mov    0xea0,%edx
      if((p = morecore(nunits)) == 0)
 9d9:	83 c4 10             	add    $0x10,%esp
 9dc:	85 d2                	test   %edx,%edx
 9de:	75 c0                	jne    9a0 <malloc+0x40>
        return 0;
  }
}
 9e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9e3:	31 c0                	xor    %eax,%eax
}
 9e5:	5b                   	pop    %ebx
 9e6:	5e                   	pop    %esi
 9e7:	5f                   	pop    %edi
 9e8:	5d                   	pop    %ebp
 9e9:	c3                   	ret
 9ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9f0:	39 cf                	cmp    %ecx,%edi
 9f2:	74 4c                	je     a40 <malloc+0xe0>
        p->s.size -= nunits;
 9f4:	29 f9                	sub    %edi,%ecx
 9f6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9f9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9fc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 9ff:	89 15 a0 0e 00 00    	mov    %edx,0xea0
}
 a05:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a08:	83 c0 08             	add    $0x8,%eax
}
 a0b:	5b                   	pop    %ebx
 a0c:	5e                   	pop    %esi
 a0d:	5f                   	pop    %edi
 a0e:	5d                   	pop    %ebp
 a0f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 a10:	c7 05 a0 0e 00 00 a4 	movl   $0xea4,0xea0
 a17:	0e 00 00 
    base.s.size = 0;
 a1a:	b8 a4 0e 00 00       	mov    $0xea4,%eax
    base.s.ptr = freep = prevp = &base;
 a1f:	c7 05 a4 0e 00 00 a4 	movl   $0xea4,0xea4
 a26:	0e 00 00 
    base.s.size = 0;
 a29:	c7 05 a8 0e 00 00 00 	movl   $0x0,0xea8
 a30:	00 00 00 
    if(p->s.size >= nunits){
 a33:	e9 54 ff ff ff       	jmp    98c <malloc+0x2c>
 a38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 a3f:	00 
        prevp->s.ptr = p->s.ptr;
 a40:	8b 08                	mov    (%eax),%ecx
 a42:	89 0a                	mov    %ecx,(%edx)
 a44:	eb b9                	jmp    9ff <malloc+0x9f>
