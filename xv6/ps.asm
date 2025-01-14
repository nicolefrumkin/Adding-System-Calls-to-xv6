
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
  14:	e8 9a 05 00 00       	call   5b3 <getNumProc>
  19:	89 c3                	mov    %eax,%ebx
    int maxPid = getMaxPid();
  1b:	e8 9b 05 00 00       	call   5bb <getMaxPid>
  20:	89 c7                	mov    %eax,%edi

    if (totalProcesses < 0 || maxPid < 0) {
  22:	89 d8                	mov    %ebx,%eax
  24:	09 f8                	or     %edi,%eax
  26:	79 13                	jns    3b <main+0x3b>
        printf(1, "Error: Failed to retrieve system information\n");
  28:	50                   	push   %eax
  29:	50                   	push   %eax
  2a:	68 b4 09 00 00       	push   $0x9b4
  2f:	6a 01                	push   $0x1
  31:	e8 3a 06 00 00       	call   670 <printf>
        exit();
  36:	e8 d8 04 00 00       	call   513 <exit>
    }

    // Print header information
    printf(1, "\nTotal number of active processes: %d\n", totalProcesses);
  3b:	51                   	push   %ecx
  3c:	53                   	push   %ebx
  3d:	68 e4 09 00 00       	push   $0x9e4
  42:	6a 01                	push   $0x1
  44:	e8 27 06 00 00       	call   670 <printf>
    printf(1, "Maximum PID: %d\n\n", maxPid);
  49:	83 c4 0c             	add    $0xc,%esp
  4c:	57                   	push   %edi
  4d:	68 7d 09 00 00       	push   $0x97d
  52:	6a 01                	push   $0x1
  54:	e8 17 06 00 00       	call   670 <printf>

    // Print table header
        printPaddedString("PID", 10);
  59:	5b                   	pop    %ebx
  5a:	5e                   	pop    %esi
  5b:	6a 0a                	push   $0xa
  5d:	68 96 09 00 00       	push   $0x996
  62:	e8 59 01 00 00       	call   1c0 <printPaddedString>
        printPaddedString("STATE", 10);
  67:	58                   	pop    %eax
  68:	5a                   	pop    %edx
  69:	6a 0a                	push   $0xa
  6b:	68 8f 09 00 00       	push   $0x98f
  70:	e8 4b 01 00 00       	call   1c0 <printPaddedString>
        printPaddedString("PPID", 10);
  75:	59                   	pop    %ecx
  76:	5b                   	pop    %ebx
  77:	6a 0a                	push   $0xa
  79:	68 95 09 00 00       	push   $0x995
  7e:	e8 3d 01 00 00       	call   1c0 <printPaddedString>
        printPaddedString("SZ", 10);
  83:	5e                   	pop    %esi
  84:	58                   	pop    %eax
  85:	6a 0a                	push   $0xa
  87:	68 9a 09 00 00       	push   $0x99a
  8c:	e8 2f 01 00 00       	call   1c0 <printPaddedString>
        printPaddedString("NFD", 10);
  91:	58                   	pop    %eax
  92:	5a                   	pop    %edx
  93:	6a 0a                	push   $0xa
  95:	68 9d 09 00 00       	push   $0x99d
  9a:	e8 21 01 00 00       	call   1c0 <printPaddedString>
        printPaddedString("NRSWITCH", 10);
  9f:	59                   	pop    %ecx
  a0:	5b                   	pop    %ebx
  a1:	6a 0a                	push   $0xa
  a3:	68 a1 09 00 00       	push   $0x9a1
  a8:	e8 13 01 00 00       	call   1c0 <printPaddedString>
        printf(1, "\n");
  ad:	5e                   	pop    %esi
  ae:	58                   	pop    %eax
  af:	68 8d 09 00 00       	push   $0x98d
  b4:	6a 01                	push   $0x1
  b6:	e8 b5 05 00 00       	call   670 <printf>

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
  d5:	e8 b6 07 00 00       	call   890 <malloc>
  da:	89 c3                	mov    %eax,%ebx
        getProcInfo(pid, pinfo);
  dc:	58                   	pop    %eax
  dd:	5a                   	pop    %edx
  de:	53                   	push   %ebx
  df:	56                   	push   %esi
    for (int pid = 1; pid <= maxPid; pid++) {
  e0:	83 c6 01             	add    $0x1,%esi
        getProcInfo(pid, pinfo);
  e3:	e8 db 04 00 00       	call   5c3 <getProcInfo>
        free(pinfo);
  e8:	89 1c 24             	mov    %ebx,(%esp)
  eb:	e8 10 07 00 00       	call   800 <free>
    for (int pid = 1; pid <= maxPid; pid++) {
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	39 f7                	cmp    %esi,%edi
  f5:	7d d9                	jge    d0 <main+0xd0>
    }

    exit();
  f7:	e8 17 04 00 00       	call   513 <exit>
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
 110:	79 7e                	jns    190 <itoa.part.0+0x90>
 112:	83 f9 0a             	cmp    $0xa,%ecx
 115:	75 79                	jne    190 <itoa.part.0+0x90>
        isNegative = 1;
        num = -num;
 117:	f7 d8                	neg    %eax
        isNegative = 1;
 119:	bf 01 00 00 00       	mov    $0x1,%edi
 11e:	89 7d ec             	mov    %edi,-0x14(%ebp)
 121:	31 c9                	xor    %ecx,%ecx
 123:	eb 05                	jmp    12a <itoa.part.0+0x2a>
 125:	8d 76 00             	lea    0x0(%esi),%esi
    }

    while (num != 0) {
        int rem = num % base;
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
 128:	89 f9                	mov    %edi,%ecx
        int rem = num % base;
 12a:	99                   	cltd
 12b:	f7 7d f0             	idivl  -0x10(%ebp)
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
 12e:	8d 7a 30             	lea    0x30(%edx),%edi
 131:	8d 72 57             	lea    0x57(%edx),%esi
 134:	83 fa 0a             	cmp    $0xa,%edx
 137:	0f 4c f7             	cmovl  %edi,%esi
 13a:	8d 79 01             	lea    0x1(%ecx),%edi
 13d:	89 f2                	mov    %esi,%edx
 13f:	89 fe                	mov    %edi,%esi
 141:	88 54 3b ff          	mov    %dl,-0x1(%ebx,%edi,1)
    while (num != 0) {
 145:	85 c0                	test   %eax,%eax
 147:	75 df                	jne    128 <itoa.part.0+0x28>
 149:	8b 7d ec             	mov    -0x14(%ebp),%edi
        num = num / base;
    }

    if (isNegative) {
 14c:	85 ff                	test   %edi,%edi
 14e:	74 58                	je     1a8 <itoa.part.0+0xa8>
        str[i++] = '-';
 150:	c6 04 33 2d          	movb   $0x2d,(%ebx,%esi,1)
    }

    str[i] = '\0';
 154:	8d 71 02             	lea    0x2(%ecx),%esi
 157:	c6 44 0b 02 00       	movb   $0x0,0x2(%ebx,%ecx,1)

    for (int j = 0; j < i / 2; j++) {
 15c:	89 f2                	mov    %esi,%edx
 15e:	d1 fa                	sar    $1,%edx
 160:	8d 44 1e ff          	lea    -0x1(%esi,%ebx,1),%eax
 164:	8d 34 13             	lea    (%ebx,%edx,1),%esi
 167:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 16e:	00 
 16f:	90                   	nop
        char temp = str[j];
        str[j] = str[i - j - 1];
 170:	0f b6 08             	movzbl (%eax),%ecx
        char temp = str[j];
 173:	0f b6 13             	movzbl (%ebx),%edx
    for (int j = 0; j < i / 2; j++) {
 176:	83 c3 01             	add    $0x1,%ebx
 179:	83 e8 01             	sub    $0x1,%eax
        str[j] = str[i - j - 1];
 17c:	88 4b ff             	mov    %cl,-0x1(%ebx)
        str[i - j - 1] = temp;
 17f:	88 50 01             	mov    %dl,0x1(%eax)
    for (int j = 0; j < i / 2; j++) {
 182:	39 de                	cmp    %ebx,%esi
 184:	75 ea                	jne    170 <itoa.part.0+0x70>
    }
 186:	83 c4 08             	add    $0x8,%esp
 189:	5b                   	pop    %ebx
 18a:	5e                   	pop    %esi
 18b:	5f                   	pop    %edi
 18c:	5d                   	pop    %ebp
 18d:	c3                   	ret
 18e:	66 90                	xchg   %ax,%ax
    while (num != 0) {
 190:	31 ff                	xor    %edi,%edi
 192:	85 c0                	test   %eax,%eax
 194:	75 88                	jne    11e <itoa.part.0+0x1e>
    str[i] = '\0';
 196:	c6 03 00             	movb   $0x0,(%ebx)
 199:	83 c4 08             	add    $0x8,%esp
 19c:	5b                   	pop    %ebx
 19d:	5e                   	pop    %esi
 19e:	5f                   	pop    %edi
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret
 1a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (int j = 0; j < i / 2; j++) {
 1a8:	89 f2                	mov    %esi,%edx
    str[i] = '\0';
 1aa:	c6 04 33 00          	movb   $0x0,(%ebx,%esi,1)
    for (int j = 0; j < i / 2; j++) {
 1ae:	d1 fa                	sar    $1,%edx
 1b0:	75 ae                	jne    160 <itoa.part.0+0x60>
 1b2:	eb d2                	jmp    186 <itoa.part.0+0x86>
 1b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1bb:	00 
 1bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001c0 <printPaddedString>:
void printPaddedString(const char *str, int width) {
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
 1c6:	83 ec 18             	sub    $0x18,%esp
 1c9:	8b 7d 08             	mov    0x8(%ebp),%edi
 1cc:	8b 75 0c             	mov    0xc(%ebp),%esi
    int len = strlen(str);
 1cf:	57                   	push   %edi
 1d0:	e8 8b 01 00 00       	call   360 <strlen>
    printf(1, "%s", str);
 1d5:	83 c4 0c             	add    $0xc,%esp
 1d8:	57                   	push   %edi
    int len = strlen(str);
 1d9:	89 c3                	mov    %eax,%ebx
    printf(1, "%s", str);
 1db:	68 78 09 00 00       	push   $0x978
 1e0:	6a 01                	push   $0x1
 1e2:	e8 89 04 00 00       	call   670 <printf>
    for (int i = len; i < width; i++) {
 1e7:	83 c4 10             	add    $0x10,%esp
 1ea:	39 f3                	cmp    %esi,%ebx
 1ec:	7d 1b                	jge    209 <printPaddedString+0x49>
 1ee:	66 90                	xchg   %ax,%ax
        printf(1, " ");
 1f0:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 1f3:	83 c3 01             	add    $0x1,%ebx
        printf(1, " ");
 1f6:	68 7b 09 00 00       	push   $0x97b
 1fb:	6a 01                	push   $0x1
 1fd:	e8 6e 04 00 00       	call   670 <printf>
    for (int i = len; i < width; i++) {
 202:	83 c4 10             	add    $0x10,%esp
 205:	39 de                	cmp    %ebx,%esi
 207:	75 e7                	jne    1f0 <printPaddedString+0x30>
}
 209:	8d 65 f4             	lea    -0xc(%ebp),%esp
 20c:	5b                   	pop    %ebx
 20d:	5e                   	pop    %esi
 20e:	5f                   	pop    %edi
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret
 211:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 218:	00 
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000220 <printPaddedInt>:
void printPaddedInt(int num, int width) {
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	53                   	push   %ebx
 226:	83 ec 1c             	sub    $0x1c,%esp
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	8b 75 0c             	mov    0xc(%ebp),%esi
    if (num == 0) {
 22f:	85 c0                	test   %eax,%eax
 231:	74 5d                	je     290 <printPaddedInt+0x70>
 233:	8d 7d d8             	lea    -0x28(%ebp),%edi
 236:	b9 0a 00 00 00       	mov    $0xa,%ecx
 23b:	89 fa                	mov    %edi,%edx
 23d:	e8 be fe ff ff       	call   100 <itoa.part.0>
    int len = strlen(str);
 242:	83 ec 0c             	sub    $0xc,%esp
 245:	57                   	push   %edi
 246:	e8 15 01 00 00       	call   360 <strlen>
    printf(1, "%s", str);
 24b:	83 c4 0c             	add    $0xc,%esp
 24e:	57                   	push   %edi
    int len = strlen(str);
 24f:	89 c3                	mov    %eax,%ebx
    printf(1, "%s", str);
 251:	68 78 09 00 00       	push   $0x978
 256:	6a 01                	push   $0x1
 258:	e8 13 04 00 00       	call   670 <printf>
    for (int i = len; i < width; i++) {
 25d:	83 c4 10             	add    $0x10,%esp
 260:	39 de                	cmp    %ebx,%esi
 262:	7e 1d                	jle    281 <printPaddedInt+0x61>
 264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, " ");
 268:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 26b:	83 c3 01             	add    $0x1,%ebx
        printf(1, " ");
 26e:	68 7b 09 00 00       	push   $0x97b
 273:	6a 01                	push   $0x1
 275:	e8 f6 03 00 00       	call   670 <printf>
    for (int i = len; i < width; i++) {
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	39 de                	cmp    %ebx,%esi
 27f:	75 e7                	jne    268 <printPaddedInt+0x48>
}
 281:	8d 65 f4             	lea    -0xc(%ebp),%esp
 284:	5b                   	pop    %ebx
 285:	5e                   	pop    %esi
 286:	5f                   	pop    %edi
 287:	5d                   	pop    %ebp
 288:	c3                   	ret
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        str[i++] = '0';
 290:	b8 30 00 00 00       	mov    $0x30,%eax
 295:	8d 7d d8             	lea    -0x28(%ebp),%edi
 298:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
        return;
 29c:	eb a4                	jmp    242 <printPaddedInt+0x22>
 29e:	66 90                	xchg   %ax,%ax

000002a0 <itoa>:
void itoa(int num, char *str, int base) {
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 2a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if (num == 0) {
 2ac:	85 c0                	test   %eax,%eax
 2ae:	74 10                	je     2c0 <itoa+0x20>
 2b0:	5d                   	pop    %ebp
 2b1:	e9 4a fe ff ff       	jmp    100 <itoa.part.0>
 2b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2bd:	00 
 2be:	66 90                	xchg   %ax,%ax
        str[i++] = '0';
 2c0:	b8 30 00 00 00       	mov    $0x30,%eax
 2c5:	66 89 02             	mov    %ax,(%edx)
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret
 2ca:	66 90                	xchg   %ax,%ax
 2cc:	66 90                	xchg   %ax,%ax
 2ce:	66 90                	xchg   %ax,%ax

000002d0 <strcpy>:
#include "x86.h"
#include "processInfo.h"

char*
strcpy(char *s, const char *t)
{
 2d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2d1:	31 c0                	xor    %eax,%eax
{
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	53                   	push   %ebx
 2d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 2e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2e7:	83 c0 01             	add    $0x1,%eax
 2ea:	84 d2                	test   %dl,%dl
 2ec:	75 f2                	jne    2e0 <strcpy+0x10>
    ;
  return os;
}
 2ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2f1:	89 c8                	mov    %ecx,%eax
 2f3:	c9                   	leave
 2f4:	c3                   	ret
 2f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2fc:	00 
 2fd:	8d 76 00             	lea    0x0(%esi),%esi

00000300 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	53                   	push   %ebx
 304:	8b 55 08             	mov    0x8(%ebp),%edx
 307:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 30a:	0f b6 02             	movzbl (%edx),%eax
 30d:	84 c0                	test   %al,%al
 30f:	75 17                	jne    328 <strcmp+0x28>
 311:	eb 3a                	jmp    34d <strcmp+0x4d>
 313:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 318:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 31c:	83 c2 01             	add    $0x1,%edx
 31f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 322:	84 c0                	test   %al,%al
 324:	74 1a                	je     340 <strcmp+0x40>
 326:	89 d9                	mov    %ebx,%ecx
 328:	0f b6 19             	movzbl (%ecx),%ebx
 32b:	38 c3                	cmp    %al,%bl
 32d:	74 e9                	je     318 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 32f:	29 d8                	sub    %ebx,%eax
}
 331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 334:	c9                   	leave
 335:	c3                   	ret
 336:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 33d:	00 
 33e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 340:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 344:	31 c0                	xor    %eax,%eax
 346:	29 d8                	sub    %ebx,%eax
}
 348:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 34b:	c9                   	leave
 34c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 34d:	0f b6 19             	movzbl (%ecx),%ebx
 350:	31 c0                	xor    %eax,%eax
 352:	eb db                	jmp    32f <strcmp+0x2f>
 354:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 35b:	00 
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000360 <strlen>:

uint
strlen(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 366:	80 3a 00             	cmpb   $0x0,(%edx)
 369:	74 15                	je     380 <strlen+0x20>
 36b:	31 c0                	xor    %eax,%eax
 36d:	8d 76 00             	lea    0x0(%esi),%esi
 370:	83 c0 01             	add    $0x1,%eax
 373:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 377:	89 c1                	mov    %eax,%ecx
 379:	75 f5                	jne    370 <strlen+0x10>
    ;
  return n;
}
 37b:	89 c8                	mov    %ecx,%eax
 37d:	5d                   	pop    %ebp
 37e:	c3                   	ret
 37f:	90                   	nop
  for(n = 0; s[n]; n++)
 380:	31 c9                	xor    %ecx,%ecx
}
 382:	5d                   	pop    %ebp
 383:	89 c8                	mov    %ecx,%eax
 385:	c3                   	ret
 386:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 38d:	00 
 38e:	66 90                	xchg   %ax,%ax

00000390 <memset>:

void*
memset(void *dst, int c, uint n)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 397:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	89 d7                	mov    %edx,%edi
 39f:	fc                   	cld
 3a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3a2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 3a5:	89 d0                	mov    %edx,%eax
 3a7:	c9                   	leave
 3a8:	c3                   	ret
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003b0 <strchr>:

char*
strchr(const char *s, char c)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3ba:	0f b6 10             	movzbl (%eax),%edx
 3bd:	84 d2                	test   %dl,%dl
 3bf:	75 12                	jne    3d3 <strchr+0x23>
 3c1:	eb 1d                	jmp    3e0 <strchr+0x30>
 3c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 3c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3cc:	83 c0 01             	add    $0x1,%eax
 3cf:	84 d2                	test   %dl,%dl
 3d1:	74 0d                	je     3e0 <strchr+0x30>
    if(*s == c)
 3d3:	38 d1                	cmp    %dl,%cl
 3d5:	75 f1                	jne    3c8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 3d7:	5d                   	pop    %ebp
 3d8:	c3                   	ret
 3d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3e0:	31 c0                	xor    %eax,%eax
}
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret
 3e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3eb:	00 
 3ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003f0 <gets>:

char*
gets(char *buf, int max)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 3f5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 3f8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 3f9:	31 db                	xor    %ebx,%ebx
{
 3fb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 3fe:	eb 27                	jmp    427 <gets+0x37>
    cc = read(0, &c, 1);
 400:	83 ec 04             	sub    $0x4,%esp
 403:	6a 01                	push   $0x1
 405:	56                   	push   %esi
 406:	6a 00                	push   $0x0
 408:	e8 1e 01 00 00       	call   52b <read>
    if(cc < 1)
 40d:	83 c4 10             	add    $0x10,%esp
 410:	85 c0                	test   %eax,%eax
 412:	7e 1d                	jle    431 <gets+0x41>
      break;
    buf[i++] = c;
 414:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 418:	8b 55 08             	mov    0x8(%ebp),%edx
 41b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 41f:	3c 0a                	cmp    $0xa,%al
 421:	74 10                	je     433 <gets+0x43>
 423:	3c 0d                	cmp    $0xd,%al
 425:	74 0c                	je     433 <gets+0x43>
  for(i=0; i+1 < max; ){
 427:	89 df                	mov    %ebx,%edi
 429:	83 c3 01             	add    $0x1,%ebx
 42c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 42f:	7c cf                	jl     400 <gets+0x10>
 431:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 43a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43d:	5b                   	pop    %ebx
 43e:	5e                   	pop    %esi
 43f:	5f                   	pop    %edi
 440:	5d                   	pop    %ebp
 441:	c3                   	ret
 442:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 449:	00 
 44a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000450 <stat>:

int
stat(const char *n, struct stat *st)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	56                   	push   %esi
 454:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 455:	83 ec 08             	sub    $0x8,%esp
 458:	6a 00                	push   $0x0
 45a:	ff 75 08             	push   0x8(%ebp)
 45d:	e8 f1 00 00 00       	call   553 <open>
  if(fd < 0)
 462:	83 c4 10             	add    $0x10,%esp
 465:	85 c0                	test   %eax,%eax
 467:	78 27                	js     490 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 469:	83 ec 08             	sub    $0x8,%esp
 46c:	ff 75 0c             	push   0xc(%ebp)
 46f:	89 c3                	mov    %eax,%ebx
 471:	50                   	push   %eax
 472:	e8 f4 00 00 00       	call   56b <fstat>
  close(fd);
 477:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 47a:	89 c6                	mov    %eax,%esi
  close(fd);
 47c:	e8 ba 00 00 00       	call   53b <close>
  return r;
 481:	83 c4 10             	add    $0x10,%esp
}
 484:	8d 65 f8             	lea    -0x8(%ebp),%esp
 487:	89 f0                	mov    %esi,%eax
 489:	5b                   	pop    %ebx
 48a:	5e                   	pop    %esi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret
 48d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 490:	be ff ff ff ff       	mov    $0xffffffff,%esi
 495:	eb ed                	jmp    484 <stat+0x34>
 497:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 49e:	00 
 49f:	90                   	nop

000004a0 <atoi>:

int
atoi(const char *s)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	53                   	push   %ebx
 4a4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a7:	0f be 02             	movsbl (%edx),%eax
 4aa:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4ad:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4b5:	77 1e                	ja     4d5 <atoi+0x35>
 4b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4be:	00 
 4bf:	90                   	nop
    n = n*10 + *s++ - '0';
 4c0:	83 c2 01             	add    $0x1,%edx
 4c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4ca:	0f be 02             	movsbl (%edx),%eax
 4cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4d0:	80 fb 09             	cmp    $0x9,%bl
 4d3:	76 eb                	jbe    4c0 <atoi+0x20>
  return n;
}
 4d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4d8:	89 c8                	mov    %ecx,%eax
 4da:	c9                   	leave
 4db:	c3                   	ret
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	8b 45 10             	mov    0x10(%ebp),%eax
 4e7:	8b 55 08             	mov    0x8(%ebp),%edx
 4ea:	56                   	push   %esi
 4eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ee:	85 c0                	test   %eax,%eax
 4f0:	7e 13                	jle    505 <memmove+0x25>
 4f2:	01 d0                	add    %edx,%eax
  dst = vdst;
 4f4:	89 d7                	mov    %edx,%edi
 4f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 4fd:	00 
 4fe:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 500:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 501:	39 f8                	cmp    %edi,%eax
 503:	75 fb                	jne    500 <memmove+0x20>
  return vdst;
}
 505:	5e                   	pop    %esi
 506:	89 d0                	mov    %edx,%eax
 508:	5f                   	pop    %edi
 509:	5d                   	pop    %ebp
 50a:	c3                   	ret

0000050b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 50b:	b8 01 00 00 00       	mov    $0x1,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret

00000513 <exit>:
SYSCALL(exit)
 513:	b8 02 00 00 00       	mov    $0x2,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret

0000051b <wait>:
SYSCALL(wait)
 51b:	b8 03 00 00 00       	mov    $0x3,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret

00000523 <pipe>:
SYSCALL(pipe)
 523:	b8 04 00 00 00       	mov    $0x4,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret

0000052b <read>:
SYSCALL(read)
 52b:	b8 05 00 00 00       	mov    $0x5,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret

00000533 <write>:
SYSCALL(write)
 533:	b8 10 00 00 00       	mov    $0x10,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret

0000053b <close>:
SYSCALL(close)
 53b:	b8 15 00 00 00       	mov    $0x15,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret

00000543 <kill>:
SYSCALL(kill)
 543:	b8 06 00 00 00       	mov    $0x6,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret

0000054b <exec>:
SYSCALL(exec)
 54b:	b8 07 00 00 00       	mov    $0x7,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret

00000553 <open>:
SYSCALL(open)
 553:	b8 0f 00 00 00       	mov    $0xf,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret

0000055b <mknod>:
SYSCALL(mknod)
 55b:	b8 11 00 00 00       	mov    $0x11,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret

00000563 <unlink>:
SYSCALL(unlink)
 563:	b8 12 00 00 00       	mov    $0x12,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret

0000056b <fstat>:
SYSCALL(fstat)
 56b:	b8 08 00 00 00       	mov    $0x8,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret

00000573 <link>:
SYSCALL(link)
 573:	b8 13 00 00 00       	mov    $0x13,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret

0000057b <mkdir>:
SYSCALL(mkdir)
 57b:	b8 14 00 00 00       	mov    $0x14,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret

00000583 <chdir>:
SYSCALL(chdir)
 583:	b8 09 00 00 00       	mov    $0x9,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret

0000058b <dup>:
SYSCALL(dup)
 58b:	b8 0a 00 00 00       	mov    $0xa,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret

00000593 <getpid>:
SYSCALL(getpid)
 593:	b8 0b 00 00 00       	mov    $0xb,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret

0000059b <sbrk>:
SYSCALL(sbrk)
 59b:	b8 0c 00 00 00       	mov    $0xc,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret

000005a3 <sleep>:
SYSCALL(sleep)
 5a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret

000005ab <uptime>:
SYSCALL(uptime)
 5ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret

000005b3 <getNumProc>:
SYSCALL(getNumProc)
 5b3:	b8 16 00 00 00       	mov    $0x16,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret

000005bb <getMaxPid>:
SYSCALL(getMaxPid)
 5bb:	b8 17 00 00 00       	mov    $0x17,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret

000005c3 <getProcInfo>:
SYSCALL(getProcInfo)
 5c3:	b8 18 00 00 00       	mov    $0x18,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret
 5cb:	66 90                	xchg   %ax,%ax
 5cd:	66 90                	xchg   %ax,%ax
 5cf:	90                   	nop

000005d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5d8:	89 d1                	mov    %edx,%ecx
{
 5da:	83 ec 3c             	sub    $0x3c,%esp
 5dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 5e0:	85 d2                	test   %edx,%edx
 5e2:	0f 89 80 00 00 00    	jns    668 <printint+0x98>
 5e8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5ec:	74 7a                	je     668 <printint+0x98>
    x = -xx;
 5ee:	f7 d9                	neg    %ecx
    neg = 1;
 5f0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 5f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 5f8:	31 f6                	xor    %esi,%esi
 5fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 600:	89 c8                	mov    %ecx,%eax
 602:	31 d2                	xor    %edx,%edx
 604:	89 f7                	mov    %esi,%edi
 606:	f7 f3                	div    %ebx
 608:	8d 76 01             	lea    0x1(%esi),%esi
 60b:	0f b6 92 64 0a 00 00 	movzbl 0xa64(%edx),%edx
 612:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 616:	89 ca                	mov    %ecx,%edx
 618:	89 c1                	mov    %eax,%ecx
 61a:	39 da                	cmp    %ebx,%edx
 61c:	73 e2                	jae    600 <printint+0x30>
  if(neg)
 61e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 621:	85 c0                	test   %eax,%eax
 623:	74 07                	je     62c <printint+0x5c>
    buf[i++] = '-';
 625:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 62a:	89 f7                	mov    %esi,%edi
 62c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 62f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 632:	01 df                	add    %ebx,%edi
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 638:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 63b:	83 ec 04             	sub    $0x4,%esp
 63e:	88 45 d7             	mov    %al,-0x29(%ebp)
 641:	8d 45 d7             	lea    -0x29(%ebp),%eax
 644:	6a 01                	push   $0x1
 646:	50                   	push   %eax
 647:	56                   	push   %esi
 648:	e8 e6 fe ff ff       	call   533 <write>
  while(--i >= 0)
 64d:	89 f8                	mov    %edi,%eax
 64f:	83 c4 10             	add    $0x10,%esp
 652:	83 ef 01             	sub    $0x1,%edi
 655:	39 c3                	cmp    %eax,%ebx
 657:	75 df                	jne    638 <printint+0x68>
}
 659:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65c:	5b                   	pop    %ebx
 65d:	5e                   	pop    %esi
 65e:	5f                   	pop    %edi
 65f:	5d                   	pop    %ebp
 660:	c3                   	ret
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 668:	31 c0                	xor    %eax,%eax
 66a:	eb 89                	jmp    5f5 <printint+0x25>
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
 676:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 679:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 67c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 67f:	0f b6 1e             	movzbl (%esi),%ebx
 682:	83 c6 01             	add    $0x1,%esi
 685:	84 db                	test   %bl,%bl
 687:	74 67                	je     6f0 <printf+0x80>
 689:	8d 4d 10             	lea    0x10(%ebp),%ecx
 68c:	31 d2                	xor    %edx,%edx
 68e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 691:	eb 34                	jmp    6c7 <printf+0x57>
 693:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 698:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 69b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6a0:	83 f8 25             	cmp    $0x25,%eax
 6a3:	74 18                	je     6bd <printf+0x4d>
  write(fd, &c, 1);
 6a5:	83 ec 04             	sub    $0x4,%esp
 6a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6ab:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6ae:	6a 01                	push   $0x1
 6b0:	50                   	push   %eax
 6b1:	57                   	push   %edi
 6b2:	e8 7c fe ff ff       	call   533 <write>
 6b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6ba:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6bd:	0f b6 1e             	movzbl (%esi),%ebx
 6c0:	83 c6 01             	add    $0x1,%esi
 6c3:	84 db                	test   %bl,%bl
 6c5:	74 29                	je     6f0 <printf+0x80>
    c = fmt[i] & 0xff;
 6c7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6ca:	85 d2                	test   %edx,%edx
 6cc:	74 ca                	je     698 <printf+0x28>
      }
    } else if(state == '%'){
 6ce:	83 fa 25             	cmp    $0x25,%edx
 6d1:	75 ea                	jne    6bd <printf+0x4d>
      if(c == 'd'){
 6d3:	83 f8 25             	cmp    $0x25,%eax
 6d6:	0f 84 04 01 00 00    	je     7e0 <printf+0x170>
 6dc:	83 e8 63             	sub    $0x63,%eax
 6df:	83 f8 15             	cmp    $0x15,%eax
 6e2:	77 1c                	ja     700 <printf+0x90>
 6e4:	ff 24 85 0c 0a 00 00 	jmp    *0xa0c(,%eax,4)
 6eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6f3:	5b                   	pop    %ebx
 6f4:	5e                   	pop    %esi
 6f5:	5f                   	pop    %edi
 6f6:	5d                   	pop    %ebp
 6f7:	c3                   	ret
 6f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ff:	00 
  write(fd, &c, 1);
 700:	83 ec 04             	sub    $0x4,%esp
 703:	8d 55 e7             	lea    -0x19(%ebp),%edx
 706:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 70a:	6a 01                	push   $0x1
 70c:	52                   	push   %edx
 70d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 710:	57                   	push   %edi
 711:	e8 1d fe ff ff       	call   533 <write>
 716:	83 c4 0c             	add    $0xc,%esp
 719:	88 5d e7             	mov    %bl,-0x19(%ebp)
 71c:	6a 01                	push   $0x1
 71e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 721:	52                   	push   %edx
 722:	57                   	push   %edi
 723:	e8 0b fe ff ff       	call   533 <write>
        putc(fd, c);
 728:	83 c4 10             	add    $0x10,%esp
      state = 0;
 72b:	31 d2                	xor    %edx,%edx
 72d:	eb 8e                	jmp    6bd <printf+0x4d>
 72f:	90                   	nop
        printint(fd, *ap, 16, 0);
 730:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 733:	83 ec 0c             	sub    $0xc,%esp
 736:	b9 10 00 00 00       	mov    $0x10,%ecx
 73b:	8b 13                	mov    (%ebx),%edx
 73d:	6a 00                	push   $0x0
 73f:	89 f8                	mov    %edi,%eax
        ap++;
 741:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 744:	e8 87 fe ff ff       	call   5d0 <printint>
        ap++;
 749:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 74c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 74f:	31 d2                	xor    %edx,%edx
 751:	e9 67 ff ff ff       	jmp    6bd <printf+0x4d>
        s = (char*)*ap;
 756:	8b 45 d0             	mov    -0x30(%ebp),%eax
 759:	8b 18                	mov    (%eax),%ebx
        ap++;
 75b:	83 c0 04             	add    $0x4,%eax
 75e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 761:	85 db                	test   %ebx,%ebx
 763:	0f 84 87 00 00 00    	je     7f0 <printf+0x180>
        while(*s != 0){
 769:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 76c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 76e:	84 c0                	test   %al,%al
 770:	0f 84 47 ff ff ff    	je     6bd <printf+0x4d>
 776:	8d 55 e7             	lea    -0x19(%ebp),%edx
 779:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 77c:	89 de                	mov    %ebx,%esi
 77e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 780:	83 ec 04             	sub    $0x4,%esp
 783:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 786:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 789:	6a 01                	push   $0x1
 78b:	53                   	push   %ebx
 78c:	57                   	push   %edi
 78d:	e8 a1 fd ff ff       	call   533 <write>
        while(*s != 0){
 792:	0f b6 06             	movzbl (%esi),%eax
 795:	83 c4 10             	add    $0x10,%esp
 798:	84 c0                	test   %al,%al
 79a:	75 e4                	jne    780 <printf+0x110>
      state = 0;
 79c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 79f:	31 d2                	xor    %edx,%edx
 7a1:	e9 17 ff ff ff       	jmp    6bd <printf+0x4d>
        printint(fd, *ap, 10, 1);
 7a6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7a9:	83 ec 0c             	sub    $0xc,%esp
 7ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7b1:	8b 13                	mov    (%ebx),%edx
 7b3:	6a 01                	push   $0x1
 7b5:	eb 88                	jmp    73f <printf+0xcf>
        putc(fd, *ap);
 7b7:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7ba:	83 ec 04             	sub    $0x4,%esp
 7bd:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 7c0:	8b 03                	mov    (%ebx),%eax
        ap++;
 7c2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 7c5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7c8:	6a 01                	push   $0x1
 7ca:	52                   	push   %edx
 7cb:	57                   	push   %edi
 7cc:	e8 62 fd ff ff       	call   533 <write>
        ap++;
 7d1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7d4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7d7:	31 d2                	xor    %edx,%edx
 7d9:	e9 df fe ff ff       	jmp    6bd <printf+0x4d>
 7de:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 7e0:	83 ec 04             	sub    $0x4,%esp
 7e3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7e6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 7e9:	6a 01                	push   $0x1
 7eb:	e9 31 ff ff ff       	jmp    721 <printf+0xb1>
 7f0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 7f5:	bb aa 09 00 00       	mov    $0x9aa,%ebx
 7fa:	e9 77 ff ff ff       	jmp    776 <printf+0x106>
 7ff:	90                   	nop

00000800 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 800:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 801:	a1 d0 0d 00 00       	mov    0xdd0,%eax
{
 806:	89 e5                	mov    %esp,%ebp
 808:	57                   	push   %edi
 809:	56                   	push   %esi
 80a:	53                   	push   %ebx
 80b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 80e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	39 c8                	cmp    %ecx,%eax
 81c:	73 32                	jae    850 <free+0x50>
 81e:	39 d1                	cmp    %edx,%ecx
 820:	72 04                	jb     826 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 822:	39 d0                	cmp    %edx,%eax
 824:	72 32                	jb     858 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 826:	8b 73 fc             	mov    -0x4(%ebx),%esi
 829:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 82c:	39 fa                	cmp    %edi,%edx
 82e:	74 30                	je     860 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 833:	8b 50 04             	mov    0x4(%eax),%edx
 836:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 839:	39 f1                	cmp    %esi,%ecx
 83b:	74 3a                	je     877 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 83d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 83f:	5b                   	pop    %ebx
  freep = p;
 840:	a3 d0 0d 00 00       	mov    %eax,0xdd0
}
 845:	5e                   	pop    %esi
 846:	5f                   	pop    %edi
 847:	5d                   	pop    %ebp
 848:	c3                   	ret
 849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 850:	39 d0                	cmp    %edx,%eax
 852:	72 04                	jb     858 <free+0x58>
 854:	39 d1                	cmp    %edx,%ecx
 856:	72 ce                	jb     826 <free+0x26>
{
 858:	89 d0                	mov    %edx,%eax
 85a:	eb bc                	jmp    818 <free+0x18>
 85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 860:	03 72 04             	add    0x4(%edx),%esi
 863:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	8b 10                	mov    (%eax),%edx
 868:	8b 12                	mov    (%edx),%edx
 86a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 86d:	8b 50 04             	mov    0x4(%eax),%edx
 870:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 873:	39 f1                	cmp    %esi,%ecx
 875:	75 c6                	jne    83d <free+0x3d>
    p->s.size += bp->s.size;
 877:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 87a:	a3 d0 0d 00 00       	mov    %eax,0xdd0
    p->s.size += bp->s.size;
 87f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 882:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 885:	89 08                	mov    %ecx,(%eax)
}
 887:	5b                   	pop    %ebx
 888:	5e                   	pop    %esi
 889:	5f                   	pop    %edi
 88a:	5d                   	pop    %ebp
 88b:	c3                   	ret
 88c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000890 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	57                   	push   %edi
 894:	56                   	push   %esi
 895:	53                   	push   %ebx
 896:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 899:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 89c:	8b 15 d0 0d 00 00    	mov    0xdd0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a2:	8d 78 07             	lea    0x7(%eax),%edi
 8a5:	c1 ef 03             	shr    $0x3,%edi
 8a8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8ab:	85 d2                	test   %edx,%edx
 8ad:	0f 84 8d 00 00 00    	je     940 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8b5:	8b 48 04             	mov    0x4(%eax),%ecx
 8b8:	39 f9                	cmp    %edi,%ecx
 8ba:	73 64                	jae    920 <malloc+0x90>
  if(nu < 4096)
 8bc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8c1:	39 df                	cmp    %ebx,%edi
 8c3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8c6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8cd:	eb 0a                	jmp    8d9 <malloc+0x49>
 8cf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8d2:	8b 48 04             	mov    0x4(%eax),%ecx
 8d5:	39 f9                	cmp    %edi,%ecx
 8d7:	73 47                	jae    920 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d9:	89 c2                	mov    %eax,%edx
 8db:	3b 05 d0 0d 00 00    	cmp    0xdd0,%eax
 8e1:	75 ed                	jne    8d0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 8e3:	83 ec 0c             	sub    $0xc,%esp
 8e6:	56                   	push   %esi
 8e7:	e8 af fc ff ff       	call   59b <sbrk>
  if(p == (char*)-1)
 8ec:	83 c4 10             	add    $0x10,%esp
 8ef:	83 f8 ff             	cmp    $0xffffffff,%eax
 8f2:	74 1c                	je     910 <malloc+0x80>
  hp->s.size = nu;
 8f4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8f7:	83 ec 0c             	sub    $0xc,%esp
 8fa:	83 c0 08             	add    $0x8,%eax
 8fd:	50                   	push   %eax
 8fe:	e8 fd fe ff ff       	call   800 <free>
  return freep;
 903:	8b 15 d0 0d 00 00    	mov    0xdd0,%edx
      if((p = morecore(nunits)) == 0)
 909:	83 c4 10             	add    $0x10,%esp
 90c:	85 d2                	test   %edx,%edx
 90e:	75 c0                	jne    8d0 <malloc+0x40>
        return 0;
  }
}
 910:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 913:	31 c0                	xor    %eax,%eax
}
 915:	5b                   	pop    %ebx
 916:	5e                   	pop    %esi
 917:	5f                   	pop    %edi
 918:	5d                   	pop    %ebp
 919:	c3                   	ret
 91a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 920:	39 cf                	cmp    %ecx,%edi
 922:	74 4c                	je     970 <malloc+0xe0>
        p->s.size -= nunits;
 924:	29 f9                	sub    %edi,%ecx
 926:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 929:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 92c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 92f:	89 15 d0 0d 00 00    	mov    %edx,0xdd0
}
 935:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 938:	83 c0 08             	add    $0x8,%eax
}
 93b:	5b                   	pop    %ebx
 93c:	5e                   	pop    %esi
 93d:	5f                   	pop    %edi
 93e:	5d                   	pop    %ebp
 93f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 940:	c7 05 d0 0d 00 00 d4 	movl   $0xdd4,0xdd0
 947:	0d 00 00 
    base.s.size = 0;
 94a:	b8 d4 0d 00 00       	mov    $0xdd4,%eax
    base.s.ptr = freep = prevp = &base;
 94f:	c7 05 d4 0d 00 00 d4 	movl   $0xdd4,0xdd4
 956:	0d 00 00 
    base.s.size = 0;
 959:	c7 05 d8 0d 00 00 00 	movl   $0x0,0xdd8
 960:	00 00 00 
    if(p->s.size >= nunits){
 963:	e9 54 ff ff ff       	jmp    8bc <malloc+0x2c>
 968:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 96f:	00 
        prevp->s.ptr = p->s.ptr;
 970:	8b 08                	mov    (%eax),%ecx
 972:	89 0a                	mov    %ecx,(%edx)
 974:	eb b9                	jmp    92f <malloc+0x9f>
