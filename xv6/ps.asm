
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        printPaddedInt(pinfo->nrswitch, 10);
        printf(1, "\n");
    free(pinfo);
}

int main(int argc, char *argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
    int totalProcesses = getNumProc();
  13:	e8 bb 08 00 00       	call   8d3 <getNumProc>
  18:	89 c3                	mov    %eax,%ebx
    int maxPid = getMaxPid();
  1a:	e8 bc 08 00 00       	call   8db <getMaxPid>
  1f:	89 c6                	mov    %eax,%esi

    if (totalProcesses < 0 || maxPid < 0) {
  21:	89 d8                	mov    %ebx,%eax
  23:	09 f0                	or     %esi,%eax
  25:	79 13                	jns    3a <main+0x3a>
        printf(1, "Error: Failed to retrieve system information\n");
  27:	51                   	push   %ecx
  28:	51                   	push   %ecx
  29:	68 94 0d 00 00       	push   $0xd94
  2e:	6a 01                	push   $0x1
  30:	e8 8b 09 00 00       	call   9c0 <printf>
        exit();
  35:	e8 f9 07 00 00       	call   833 <exit>
    }

    // Print header information
    printf(1, "\nTotal number of active processes: %d\n", totalProcesses);
  3a:	50                   	push   %eax
  3b:	53                   	push   %ebx
  3c:	68 c4 0d 00 00       	push   $0xdc4
  41:	6a 01                	push   $0x1
  43:	e8 78 09 00 00       	call   9c0 <printf>
    printf(1, "Maximum PID: %d\n\n", maxPid);
  48:	83 c4 0c             	add    $0xc,%esp
  4b:	56                   	push   %esi
  4c:	68 35 0d 00 00       	push   $0xd35
  51:	6a 01                	push   $0x1
  53:	e8 68 09 00 00       	call   9c0 <printf>

    // Print table header
        printPaddedString("PID", 10);
  58:	5a                   	pop    %edx
  59:	59                   	pop    %ecx
  5a:	6a 0a                	push   $0xa
  5c:	68 4e 0d 00 00       	push   $0xd4e
  61:	e8 5a 04 00 00       	call   4c0 <printPaddedString>
        printPaddedString("STATE", 10);
  66:	5b                   	pop    %ebx
  67:	58                   	pop    %eax
  68:	6a 0a                	push   $0xa
  6a:	68 47 0d 00 00       	push   $0xd47
  6f:	e8 4c 04 00 00       	call   4c0 <printPaddedString>
        printPaddedString("PPID", 10);
  74:	58                   	pop    %eax
  75:	5a                   	pop    %edx
  76:	6a 0a                	push   $0xa
  78:	68 4d 0d 00 00       	push   $0xd4d
  7d:	e8 3e 04 00 00       	call   4c0 <printPaddedString>
        printPaddedString("SZ", 10);
  82:	59                   	pop    %ecx
  83:	5b                   	pop    %ebx
  84:	6a 0a                	push   $0xa
  86:	68 52 0d 00 00       	push   $0xd52
  8b:	e8 30 04 00 00       	call   4c0 <printPaddedString>
        printPaddedString("NFD", 10);
  90:	58                   	pop    %eax
  91:	5a                   	pop    %edx
  92:	6a 0a                	push   $0xa
  94:	68 55 0d 00 00       	push   $0xd55
  99:	e8 22 04 00 00       	call   4c0 <printPaddedString>
        printPaddedString("NRSWITCH", 10);
  9e:	59                   	pop    %ecx
  9f:	5b                   	pop    %ebx
  a0:	6a 0a                	push   $0xa
  a2:	68 59 0d 00 00       	push   $0xd59
  a7:	e8 14 04 00 00       	call   4c0 <printPaddedString>
        printf(1, "\n");
  ac:	58                   	pop    %eax
  ad:	5a                   	pop    %edx
  ae:	68 45 0d 00 00       	push   $0xd45
  b3:	6a 01                	push   $0x1
  b5:	e8 06 09 00 00       	call   9c0 <printf>

    // Iterate through all possible PIDs and print process info
    for (int pid = 1; pid <= maxPid; pid++) {
  ba:	83 c4 10             	add    $0x10,%esp
  bd:	85 f6                	test   %esi,%esi
  bf:	7e 22                	jle    e3 <main+0xe3>
  c1:	bb 01 00 00 00       	mov    $0x1,%ebx
  c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  cd:	00 
  ce:	66 90                	xchg   %ax,%ax
        printProcessInfo(pid);
  d0:	83 ec 0c             	sub    $0xc,%esp
  d3:	53                   	push   %ebx
    for (int pid = 1; pid <= maxPid; pid++) {
  d4:	83 c3 01             	add    $0x1,%ebx
        printProcessInfo(pid);
  d7:	e8 f4 00 00 00       	call   1d0 <printProcessInfo>
    for (int pid = 1; pid <= maxPid; pid++) {
  dc:	83 c4 10             	add    $0x10,%esp
  df:	39 de                	cmp    %ebx,%esi
  e1:	7d ed                	jge    d0 <main+0xd0>
    }

    exit();
  e3:	e8 4b 07 00 00       	call   833 <exit>
  e8:	66 90                	xchg   %ax,%ax
  ea:	66 90                	xchg   %ax,%ax
  ec:	66 90                	xchg   %ax,%ax
  ee:	66 90                	xchg   %ax,%ax
  f0:	66 90                	xchg   %ax,%ax
  f2:	66 90                	xchg   %ax,%ax
  f4:	66 90                	xchg   %ax,%ax
  f6:	66 90                	xchg   %ax,%ax
  f8:	66 90                	xchg   %ax,%ax
  fa:	66 90                	xchg   %ax,%ax
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

000001d0 <printProcessInfo>:
void printProcessInfo(int pid) {
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
 1d5:	53                   	push   %ebx
 1d6:	83 ec 38             	sub    $0x38,%esp
 1d9:	8b 7d 08             	mov    0x8(%ebp),%edi
    struct processInfo* pinfo = malloc(sizeof(struct processInfo));
 1dc:	6a 14                	push   $0x14
 1de:	e8 5d 0a 00 00       	call   c40 <malloc>
    getProcInfo(pid, pinfo);
 1e3:	5a                   	pop    %edx
 1e4:	59                   	pop    %ecx
 1e5:	50                   	push   %eax
    struct processInfo* pinfo = malloc(sizeof(struct processInfo));
 1e6:	89 c6                	mov    %eax,%esi
    getProcInfo(pid, pinfo);
 1e8:	57                   	push   %edi
 1e9:	e8 f5 06 00 00       	call   8e3 <getProcInfo>
    switch (pinfo->state) {
 1ee:	8b 06                	mov    (%esi),%eax
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	c7 45 d4 28 0d 00 00 	movl   $0xd28,-0x2c(%ebp)
 1fa:	83 f8 04             	cmp    $0x4,%eax
 1fd:	77 0a                	ja     209 <printProcessInfo+0x39>
 1ff:	8b 04 85 ec 0d 00 00 	mov    0xdec(,%eax,4),%eax
 206:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    if (num == 0) {
 209:	85 ff                	test   %edi,%edi
 20b:	0f 84 4f 02 00 00    	je     460 <printProcessInfo+0x290>
 211:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 214:	b9 0a 00 00 00       	mov    $0xa,%ecx
 219:	89 f8                	mov    %edi,%eax
 21b:	89 da                	mov    %ebx,%edx
 21d:	e8 de fe ff ff       	call   100 <itoa.part.0>
    int len = strlen(str);
 222:	83 ec 0c             	sub    $0xc,%esp
 225:	53                   	push   %ebx
 226:	e8 55 04 00 00       	call   680 <strlen>
    printf(1, "%s", str);
 22b:	83 c4 0c             	add    $0xc,%esp
 22e:	53                   	push   %ebx
    int len = strlen(str);
 22f:	89 c7                	mov    %eax,%edi
    printf(1, "%s", str);
 231:	68 30 0d 00 00       	push   $0xd30
 236:	6a 01                	push   $0x1
 238:	e8 83 07 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 23d:	83 c4 10             	add    $0x10,%esp
 240:	83 ff 09             	cmp    $0x9,%edi
 243:	7f 25                	jg     26a <printProcessInfo+0x9a>
 245:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 24c:	00 
 24d:	8d 76 00             	lea    0x0(%esi),%esi
        printf(1, " ");
 250:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 253:	83 c7 01             	add    $0x1,%edi
        printf(1, " ");
 256:	68 33 0d 00 00       	push   $0xd33
 25b:	6a 01                	push   $0x1
 25d:	e8 5e 07 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 262:	83 c4 10             	add    $0x10,%esp
 265:	83 ff 0a             	cmp    $0xa,%edi
 268:	75 e6                	jne    250 <printProcessInfo+0x80>
    int len = strlen(str);
 26a:	83 ec 0c             	sub    $0xc,%esp
 26d:	ff 75 d4             	push   -0x2c(%ebp)
 270:	e8 0b 04 00 00       	call   680 <strlen>
    printf(1, "%s", str);
 275:	83 c4 0c             	add    $0xc,%esp
 278:	ff 75 d4             	push   -0x2c(%ebp)
 27b:	68 30 0d 00 00       	push   $0xd30
    int len = strlen(str);
 280:	89 c7                	mov    %eax,%edi
    printf(1, "%s", str);
 282:	6a 01                	push   $0x1
 284:	e8 37 07 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 289:	83 c4 10             	add    $0x10,%esp
 28c:	83 ff 09             	cmp    $0x9,%edi
 28f:	7f 29                	jg     2ba <printProcessInfo+0xea>
 291:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 298:	00 
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(1, " ");
 2a0:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 2a3:	83 c7 01             	add    $0x1,%edi
        printf(1, " ");
 2a6:	68 33 0d 00 00       	push   $0xd33
 2ab:	6a 01                	push   $0x1
 2ad:	e8 0e 07 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	83 ff 0a             	cmp    $0xa,%edi
 2b8:	75 e6                	jne    2a0 <printProcessInfo+0xd0>
        printPaddedInt(pinfo->ppid, 10);
 2ba:	8b 46 04             	mov    0x4(%esi),%eax
    if (num == 0) {
 2bd:	85 c0                	test   %eax,%eax
 2bf:	0f 84 eb 01 00 00    	je     4b0 <printProcessInfo+0x2e0>
 2c5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2ca:	89 da                	mov    %ebx,%edx
 2cc:	e8 2f fe ff ff       	call   100 <itoa.part.0>
    int len = strlen(str);
 2d1:	83 ec 0c             	sub    $0xc,%esp
 2d4:	53                   	push   %ebx
 2d5:	e8 a6 03 00 00       	call   680 <strlen>
    printf(1, "%s", str);
 2da:	83 c4 0c             	add    $0xc,%esp
 2dd:	53                   	push   %ebx
    int len = strlen(str);
 2de:	89 c7                	mov    %eax,%edi
    printf(1, "%s", str);
 2e0:	68 30 0d 00 00       	push   $0xd30
 2e5:	6a 01                	push   $0x1
 2e7:	e8 d4 06 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 2ec:	83 c4 10             	add    $0x10,%esp
 2ef:	83 ff 09             	cmp    $0x9,%edi
 2f2:	7f 26                	jg     31a <printProcessInfo+0x14a>
 2f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2fb:	00 
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, " ");
 300:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 303:	83 c7 01             	add    $0x1,%edi
        printf(1, " ");
 306:	68 33 0d 00 00       	push   $0xd33
 30b:	6a 01                	push   $0x1
 30d:	e8 ae 06 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 312:	83 c4 10             	add    $0x10,%esp
 315:	83 ff 0a             	cmp    $0xa,%edi
 318:	75 e6                	jne    300 <printProcessInfo+0x130>
        printPaddedInt(pinfo->sz, 10);
 31a:	8b 46 08             	mov    0x8(%esi),%eax
    if (num == 0) {
 31d:	85 c0                	test   %eax,%eax
 31f:	0f 84 7b 01 00 00    	je     4a0 <printProcessInfo+0x2d0>
 325:	b9 0a 00 00 00       	mov    $0xa,%ecx
 32a:	89 da                	mov    %ebx,%edx
 32c:	e8 cf fd ff ff       	call   100 <itoa.part.0>
    int len = strlen(str);
 331:	83 ec 0c             	sub    $0xc,%esp
 334:	53                   	push   %ebx
 335:	e8 46 03 00 00       	call   680 <strlen>
    printf(1, "%s", str);
 33a:	83 c4 0c             	add    $0xc,%esp
 33d:	53                   	push   %ebx
    int len = strlen(str);
 33e:	89 c7                	mov    %eax,%edi
    printf(1, "%s", str);
 340:	68 30 0d 00 00       	push   $0xd30
 345:	6a 01                	push   $0x1
 347:	e8 74 06 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 34c:	83 c4 10             	add    $0x10,%esp
 34f:	83 ff 09             	cmp    $0x9,%edi
 352:	7f 26                	jg     37a <printProcessInfo+0x1aa>
 354:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 35b:	00 
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, " ");
 360:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 363:	83 c7 01             	add    $0x1,%edi
        printf(1, " ");
 366:	68 33 0d 00 00       	push   $0xd33
 36b:	6a 01                	push   $0x1
 36d:	e8 4e 06 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 372:	83 c4 10             	add    $0x10,%esp
 375:	83 ff 0a             	cmp    $0xa,%edi
 378:	75 e6                	jne    360 <printProcessInfo+0x190>
        printPaddedInt(pinfo->nfd, 10);
 37a:	8b 46 0c             	mov    0xc(%esi),%eax
    if (num == 0) {
 37d:	85 c0                	test   %eax,%eax
 37f:	0f 84 0b 01 00 00    	je     490 <printProcessInfo+0x2c0>
 385:	b9 0a 00 00 00       	mov    $0xa,%ecx
 38a:	89 da                	mov    %ebx,%edx
 38c:	e8 6f fd ff ff       	call   100 <itoa.part.0>
    int len = strlen(str);
 391:	83 ec 0c             	sub    $0xc,%esp
 394:	53                   	push   %ebx
 395:	e8 e6 02 00 00       	call   680 <strlen>
    printf(1, "%s", str);
 39a:	83 c4 0c             	add    $0xc,%esp
 39d:	53                   	push   %ebx
    int len = strlen(str);
 39e:	89 c7                	mov    %eax,%edi
    printf(1, "%s", str);
 3a0:	68 30 0d 00 00       	push   $0xd30
 3a5:	6a 01                	push   $0x1
 3a7:	e8 14 06 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 3ac:	83 c4 10             	add    $0x10,%esp
 3af:	83 ff 09             	cmp    $0x9,%edi
 3b2:	7f 26                	jg     3da <printProcessInfo+0x20a>
 3b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3bb:	00 
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, " ");
 3c0:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 3c3:	83 c7 01             	add    $0x1,%edi
        printf(1, " ");
 3c6:	68 33 0d 00 00       	push   $0xd33
 3cb:	6a 01                	push   $0x1
 3cd:	e8 ee 05 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 3d2:	83 c4 10             	add    $0x10,%esp
 3d5:	83 ff 0a             	cmp    $0xa,%edi
 3d8:	75 e6                	jne    3c0 <printProcessInfo+0x1f0>
        printPaddedInt(pinfo->nrswitch, 10);
 3da:	8b 46 10             	mov    0x10(%esi),%eax
    if (num == 0) {
 3dd:	85 c0                	test   %eax,%eax
 3df:	0f 84 93 00 00 00    	je     478 <printProcessInfo+0x2a8>
 3e5:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3ea:	89 da                	mov    %ebx,%edx
 3ec:	e8 0f fd ff ff       	call   100 <itoa.part.0>
    int len = strlen(str);
 3f1:	83 ec 0c             	sub    $0xc,%esp
 3f4:	53                   	push   %ebx
 3f5:	e8 86 02 00 00       	call   680 <strlen>
    printf(1, "%s", str);
 3fa:	83 c4 0c             	add    $0xc,%esp
 3fd:	53                   	push   %ebx
    int len = strlen(str);
 3fe:	89 c7                	mov    %eax,%edi
    printf(1, "%s", str);
 400:	68 30 0d 00 00       	push   $0xd30
 405:	6a 01                	push   $0x1
 407:	e8 b4 05 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 40c:	83 c4 10             	add    $0x10,%esp
 40f:	83 ff 09             	cmp    $0x9,%edi
 412:	7f 26                	jg     43a <printProcessInfo+0x26a>
 414:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 41b:	00 
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, " ");
 420:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 423:	83 c7 01             	add    $0x1,%edi
        printf(1, " ");
 426:	68 33 0d 00 00       	push   $0xd33
 42b:	6a 01                	push   $0x1
 42d:	e8 8e 05 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 432:	83 c4 10             	add    $0x10,%esp
 435:	83 ff 0a             	cmp    $0xa,%edi
 438:	75 e6                	jne    420 <printProcessInfo+0x250>
        printf(1, "\n");
 43a:	83 ec 08             	sub    $0x8,%esp
 43d:	68 45 0d 00 00       	push   $0xd45
 442:	6a 01                	push   $0x1
 444:	e8 77 05 00 00       	call   9c0 <printf>
    free(pinfo);
 449:	83 c4 10             	add    $0x10,%esp
 44c:	89 75 08             	mov    %esi,0x8(%ebp)
}
 44f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 452:	5b                   	pop    %ebx
 453:	5e                   	pop    %esi
 454:	5f                   	pop    %edi
 455:	5d                   	pop    %ebp
    free(pinfo);
 456:	e9 45 07 00 00       	jmp    ba0 <free>
 45b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        str[i++] = '0';
 460:	b8 30 00 00 00       	mov    $0x30,%eax
 465:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 468:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
        return;
 46c:	e9 b1 fd ff ff       	jmp    222 <printProcessInfo+0x52>
 471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        str[i++] = '0';
 478:	b8 30 00 00 00       	mov    $0x30,%eax
 47d:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
        return;
 481:	e9 6b ff ff ff       	jmp    3f1 <printProcessInfo+0x221>
 486:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 48d:	00 
 48e:	66 90                	xchg   %ax,%ax
        str[i++] = '0';
 490:	ba 30 00 00 00       	mov    $0x30,%edx
 495:	66 89 55 d8          	mov    %dx,-0x28(%ebp)
        return;
 499:	e9 f3 fe ff ff       	jmp    391 <printProcessInfo+0x1c1>
 49e:	66 90                	xchg   %ax,%ax
        str[i++] = '0';
 4a0:	b9 30 00 00 00       	mov    $0x30,%ecx
 4a5:	66 89 4d d8          	mov    %cx,-0x28(%ebp)
        return;
 4a9:	e9 83 fe ff ff       	jmp    331 <printProcessInfo+0x161>
 4ae:	66 90                	xchg   %ax,%ax
        str[i++] = '0';
 4b0:	bf 30 00 00 00       	mov    $0x30,%edi
 4b5:	66 89 7d d8          	mov    %di,-0x28(%ebp)
        return;
 4b9:	e9 13 fe ff ff       	jmp    2d1 <printProcessInfo+0x101>
 4be:	66 90                	xchg   %ax,%ax

000004c0 <printPaddedString>:
void printPaddedString(const char *str, int width) {
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	57                   	push   %edi
 4c4:	56                   	push   %esi
 4c5:	53                   	push   %ebx
 4c6:	83 ec 18             	sub    $0x18,%esp
 4c9:	8b 7d 08             	mov    0x8(%ebp),%edi
 4cc:	8b 75 0c             	mov    0xc(%ebp),%esi
    int len = strlen(str);
 4cf:	57                   	push   %edi
 4d0:	e8 ab 01 00 00       	call   680 <strlen>
    printf(1, "%s", str);
 4d5:	83 c4 0c             	add    $0xc,%esp
 4d8:	57                   	push   %edi
    int len = strlen(str);
 4d9:	89 c3                	mov    %eax,%ebx
    printf(1, "%s", str);
 4db:	68 30 0d 00 00       	push   $0xd30
 4e0:	6a 01                	push   $0x1
 4e2:	e8 d9 04 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 4e7:	83 c4 10             	add    $0x10,%esp
 4ea:	39 f3                	cmp    %esi,%ebx
 4ec:	7d 1b                	jge    509 <printPaddedString+0x49>
 4ee:	66 90                	xchg   %ax,%ax
        printf(1, " ");
 4f0:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 4f3:	83 c3 01             	add    $0x1,%ebx
        printf(1, " ");
 4f6:	68 33 0d 00 00       	push   $0xd33
 4fb:	6a 01                	push   $0x1
 4fd:	e8 be 04 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 502:	83 c4 10             	add    $0x10,%esp
 505:	39 de                	cmp    %ebx,%esi
 507:	75 e7                	jne    4f0 <printPaddedString+0x30>
}
 509:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50c:	5b                   	pop    %ebx
 50d:	5e                   	pop    %esi
 50e:	5f                   	pop    %edi
 50f:	5d                   	pop    %ebp
 510:	c3                   	ret
 511:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 518:	00 
 519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000520 <printPaddedInt>:
void printPaddedInt(int num, int width) {
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	57                   	push   %edi
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	83 ec 1c             	sub    $0x1c,%esp
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	8b 75 0c             	mov    0xc(%ebp),%esi
    if (num == 0) {
 52f:	85 c0                	test   %eax,%eax
 531:	74 65                	je     598 <printPaddedInt+0x78>
 533:	8d 7d d8             	lea    -0x28(%ebp),%edi
 536:	b9 0a 00 00 00       	mov    $0xa,%ecx
 53b:	89 fa                	mov    %edi,%edx
 53d:	e8 be fb ff ff       	call   100 <itoa.part.0>
    int len = strlen(str);
 542:	83 ec 0c             	sub    $0xc,%esp
 545:	57                   	push   %edi
 546:	e8 35 01 00 00       	call   680 <strlen>
    printf(1, "%s", str);
 54b:	83 c4 0c             	add    $0xc,%esp
 54e:	57                   	push   %edi
    int len = strlen(str);
 54f:	89 c3                	mov    %eax,%ebx
    printf(1, "%s", str);
 551:	68 30 0d 00 00       	push   $0xd30
 556:	6a 01                	push   $0x1
 558:	e8 63 04 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 55d:	83 c4 10             	add    $0x10,%esp
 560:	39 de                	cmp    %ebx,%esi
 562:	7e 25                	jle    589 <printPaddedInt+0x69>
 564:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 56b:	00 
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, " ");
 570:	83 ec 08             	sub    $0x8,%esp
    for (int i = len; i < width; i++) {
 573:	83 c3 01             	add    $0x1,%ebx
        printf(1, " ");
 576:	68 33 0d 00 00       	push   $0xd33
 57b:	6a 01                	push   $0x1
 57d:	e8 3e 04 00 00       	call   9c0 <printf>
    for (int i = len; i < width; i++) {
 582:	83 c4 10             	add    $0x10,%esp
 585:	39 de                	cmp    %ebx,%esi
 587:	75 e7                	jne    570 <printPaddedInt+0x50>
}
 589:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58c:	5b                   	pop    %ebx
 58d:	5e                   	pop    %esi
 58e:	5f                   	pop    %edi
 58f:	5d                   	pop    %ebp
 590:	c3                   	ret
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        str[i++] = '0';
 598:	b8 30 00 00 00       	mov    $0x30,%eax
 59d:	8d 7d d8             	lea    -0x28(%ebp),%edi
 5a0:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
        return;
 5a4:	eb 9c                	jmp    542 <printPaddedInt+0x22>
 5a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 5ad:	00 
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <itoa>:
void itoa(int num, char *str, int base) {
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	8b 45 08             	mov    0x8(%ebp),%eax
 5b6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if (num == 0) {
 5bc:	85 c0                	test   %eax,%eax
 5be:	74 10                	je     5d0 <itoa+0x20>
 5c0:	5d                   	pop    %ebp
 5c1:	e9 3a fb ff ff       	jmp    100 <itoa.part.0>
 5c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 5cd:	00 
 5ce:	66 90                	xchg   %ax,%ax
        str[i++] = '0';
 5d0:	b8 30 00 00 00       	mov    $0x30,%eax
 5d5:	66 89 02             	mov    %ax,(%edx)
 5d8:	5d                   	pop    %ebp
 5d9:	c3                   	ret
 5da:	66 90                	xchg   %ax,%ax
 5dc:	66 90                	xchg   %ax,%ax
 5de:	66 90                	xchg   %ax,%ax

000005e0 <strcpy>:
#include "x86.h"
#include "processInfo.h"

char*
strcpy(char *s, const char *t)
{
 5e0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5e1:	31 c0                	xor    %eax,%eax
{
 5e3:	89 e5                	mov    %esp,%ebp
 5e5:	53                   	push   %ebx
 5e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 5ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 5f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 5f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 5f7:	83 c0 01             	add    $0x1,%eax
 5fa:	84 d2                	test   %dl,%dl
 5fc:	75 f2                	jne    5f0 <strcpy+0x10>
    ;
  return os;
}
 5fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 601:	89 c8                	mov    %ecx,%eax
 603:	c9                   	leave
 604:	c3                   	ret
 605:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 60c:	00 
 60d:	8d 76 00             	lea    0x0(%esi),%esi

00000610 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	53                   	push   %ebx
 614:	8b 55 08             	mov    0x8(%ebp),%edx
 617:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 61a:	0f b6 02             	movzbl (%edx),%eax
 61d:	84 c0                	test   %al,%al
 61f:	75 2f                	jne    650 <strcmp+0x40>
 621:	eb 4a                	jmp    66d <strcmp+0x5d>
 623:	eb 1b                	jmp    640 <strcmp+0x30>
 625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 62c:	00 
 62d:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 634:	00 
 635:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 63c:	00 
 63d:	8d 76 00             	lea    0x0(%esi),%esi
 640:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 644:	83 c2 01             	add    $0x1,%edx
 647:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 64a:	84 c0                	test   %al,%al
 64c:	74 12                	je     660 <strcmp+0x50>
 64e:	89 d9                	mov    %ebx,%ecx
 650:	0f b6 19             	movzbl (%ecx),%ebx
 653:	38 c3                	cmp    %al,%bl
 655:	74 e9                	je     640 <strcmp+0x30>
  return (uchar)*p - (uchar)*q;
 657:	29 d8                	sub    %ebx,%eax
}
 659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 65c:	c9                   	leave
 65d:	c3                   	ret
 65e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 660:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 664:	31 c0                	xor    %eax,%eax
 666:	29 d8                	sub    %ebx,%eax
}
 668:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 66b:	c9                   	leave
 66c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 66d:	0f b6 19             	movzbl (%ecx),%ebx
 670:	31 c0                	xor    %eax,%eax
 672:	eb e3                	jmp    657 <strcmp+0x47>
 674:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 67b:	00 
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000680 <strlen>:

uint
strlen(const char *s)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 686:	80 3a 00             	cmpb   $0x0,(%edx)
 689:	74 15                	je     6a0 <strlen+0x20>
 68b:	31 c0                	xor    %eax,%eax
 68d:	8d 76 00             	lea    0x0(%esi),%esi
 690:	83 c0 01             	add    $0x1,%eax
 693:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 697:	89 c1                	mov    %eax,%ecx
 699:	75 f5                	jne    690 <strlen+0x10>
    ;
  return n;
}
 69b:	89 c8                	mov    %ecx,%eax
 69d:	5d                   	pop    %ebp
 69e:	c3                   	ret
 69f:	90                   	nop
  for(n = 0; s[n]; n++)
 6a0:	31 c9                	xor    %ecx,%ecx
}
 6a2:	5d                   	pop    %ebp
 6a3:	89 c8                	mov    %ecx,%eax
 6a5:	c3                   	ret
 6a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ad:	00 
 6ae:	66 90                	xchg   %ax,%ax

000006b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 6b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bd:	89 d7                	mov    %edx,%edi
 6bf:	fc                   	cld
 6c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 6c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
 6c5:	89 d0                	mov    %edx,%eax
 6c7:	c9                   	leave
 6c8:	c3                   	ret
 6c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000006d0 <strchr>:

char*
strchr(const char *s, char c)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 6da:	0f b6 10             	movzbl (%eax),%edx
 6dd:	84 d2                	test   %dl,%dl
 6df:	75 1a                	jne    6fb <strchr+0x2b>
 6e1:	eb 25                	jmp    708 <strchr+0x38>
 6e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 6ea:	00 
 6eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 6f0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 6f4:	83 c0 01             	add    $0x1,%eax
 6f7:	84 d2                	test   %dl,%dl
 6f9:	74 0d                	je     708 <strchr+0x38>
    if(*s == c)
 6fb:	38 d1                	cmp    %dl,%cl
 6fd:	75 f1                	jne    6f0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 6ff:	5d                   	pop    %ebp
 700:	c3                   	ret
 701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 708:	31 c0                	xor    %eax,%eax
}
 70a:	5d                   	pop    %ebp
 70b:	c3                   	ret
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000710 <gets>:

char*
gets(char *buf, int max)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 715:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 718:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 719:	31 db                	xor    %ebx,%ebx
{
 71b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 71e:	eb 27                	jmp    747 <gets+0x37>
    cc = read(0, &c, 1);
 720:	83 ec 04             	sub    $0x4,%esp
 723:	6a 01                	push   $0x1
 725:	56                   	push   %esi
 726:	6a 00                	push   $0x0
 728:	e8 1e 01 00 00       	call   84b <read>
    if(cc < 1)
 72d:	83 c4 10             	add    $0x10,%esp
 730:	85 c0                	test   %eax,%eax
 732:	7e 1d                	jle    751 <gets+0x41>
      break;
    buf[i++] = c;
 734:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 738:	8b 55 08             	mov    0x8(%ebp),%edx
 73b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 73f:	3c 0a                	cmp    $0xa,%al
 741:	74 10                	je     753 <gets+0x43>
 743:	3c 0d                	cmp    $0xd,%al
 745:	74 0c                	je     753 <gets+0x43>
  for(i=0; i+1 < max; ){
 747:	89 df                	mov    %ebx,%edi
 749:	83 c3 01             	add    $0x1,%ebx
 74c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 74f:	7c cf                	jl     720 <gets+0x10>
 751:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 753:	8b 45 08             	mov    0x8(%ebp),%eax
 756:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 75a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 75d:	5b                   	pop    %ebx
 75e:	5e                   	pop    %esi
 75f:	5f                   	pop    %edi
 760:	5d                   	pop    %ebp
 761:	c3                   	ret
 762:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 769:	00 
 76a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000770 <stat>:

int
stat(const char *n, struct stat *st)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	56                   	push   %esi
 774:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 775:	83 ec 08             	sub    $0x8,%esp
 778:	6a 00                	push   $0x0
 77a:	ff 75 08             	push   0x8(%ebp)
 77d:	e8 f1 00 00 00       	call   873 <open>
  if(fd < 0)
 782:	83 c4 10             	add    $0x10,%esp
 785:	85 c0                	test   %eax,%eax
 787:	78 27                	js     7b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 789:	83 ec 08             	sub    $0x8,%esp
 78c:	ff 75 0c             	push   0xc(%ebp)
 78f:	89 c3                	mov    %eax,%ebx
 791:	50                   	push   %eax
 792:	e8 f4 00 00 00       	call   88b <fstat>
  close(fd);
 797:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 79a:	89 c6                	mov    %eax,%esi
  close(fd);
 79c:	e8 ba 00 00 00       	call   85b <close>
  return r;
 7a1:	83 c4 10             	add    $0x10,%esp
}
 7a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 7a7:	89 f0                	mov    %esi,%eax
 7a9:	5b                   	pop    %ebx
 7aa:	5e                   	pop    %esi
 7ab:	5d                   	pop    %ebp
 7ac:	c3                   	ret
 7ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 7b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 7b5:	eb ed                	jmp    7a4 <stat+0x34>
 7b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7be:	00 
 7bf:	90                   	nop

000007c0 <atoi>:

int
atoi(const char *s)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	53                   	push   %ebx
 7c4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7c7:	0f be 02             	movsbl (%edx),%eax
 7ca:	8d 48 d0             	lea    -0x30(%eax),%ecx
 7cd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 7d0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 7d5:	77 1e                	ja     7f5 <atoi+0x35>
 7d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 7de:	00 
 7df:	90                   	nop
    n = n*10 + *s++ - '0';
 7e0:	83 c2 01             	add    $0x1,%edx
 7e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 7e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 7ea:	0f be 02             	movsbl (%edx),%eax
 7ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 7f0:	80 fb 09             	cmp    $0x9,%bl
 7f3:	76 eb                	jbe    7e0 <atoi+0x20>
  return n;
}
 7f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7f8:	89 c8                	mov    %ecx,%eax
 7fa:	c9                   	leave
 7fb:	c3                   	ret
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000800 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	8b 45 10             	mov    0x10(%ebp),%eax
 807:	8b 55 08             	mov    0x8(%ebp),%edx
 80a:	56                   	push   %esi
 80b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 80e:	85 c0                	test   %eax,%eax
 810:	7e 13                	jle    825 <memmove+0x25>
 812:	01 d0                	add    %edx,%eax
  dst = vdst;
 814:	89 d7                	mov    %edx,%edi
 816:	66 90                	xchg   %ax,%ax
 818:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 81f:	00 
    *dst++ = *src++;
 820:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 821:	39 f8                	cmp    %edi,%eax
 823:	75 fb                	jne    820 <memmove+0x20>
  return vdst;
}
 825:	5e                   	pop    %esi
 826:	89 d0                	mov    %edx,%eax
 828:	5f                   	pop    %edi
 829:	5d                   	pop    %ebp
 82a:	c3                   	ret

0000082b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 82b:	b8 01 00 00 00       	mov    $0x1,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret

00000833 <exit>:
SYSCALL(exit)
 833:	b8 02 00 00 00       	mov    $0x2,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret

0000083b <wait>:
SYSCALL(wait)
 83b:	b8 03 00 00 00       	mov    $0x3,%eax
 840:	cd 40                	int    $0x40
 842:	c3                   	ret

00000843 <pipe>:
SYSCALL(pipe)
 843:	b8 04 00 00 00       	mov    $0x4,%eax
 848:	cd 40                	int    $0x40
 84a:	c3                   	ret

0000084b <read>:
SYSCALL(read)
 84b:	b8 05 00 00 00       	mov    $0x5,%eax
 850:	cd 40                	int    $0x40
 852:	c3                   	ret

00000853 <write>:
SYSCALL(write)
 853:	b8 10 00 00 00       	mov    $0x10,%eax
 858:	cd 40                	int    $0x40
 85a:	c3                   	ret

0000085b <close>:
SYSCALL(close)
 85b:	b8 15 00 00 00       	mov    $0x15,%eax
 860:	cd 40                	int    $0x40
 862:	c3                   	ret

00000863 <kill>:
SYSCALL(kill)
 863:	b8 06 00 00 00       	mov    $0x6,%eax
 868:	cd 40                	int    $0x40
 86a:	c3                   	ret

0000086b <exec>:
SYSCALL(exec)
 86b:	b8 07 00 00 00       	mov    $0x7,%eax
 870:	cd 40                	int    $0x40
 872:	c3                   	ret

00000873 <open>:
SYSCALL(open)
 873:	b8 0f 00 00 00       	mov    $0xf,%eax
 878:	cd 40                	int    $0x40
 87a:	c3                   	ret

0000087b <mknod>:
SYSCALL(mknod)
 87b:	b8 11 00 00 00       	mov    $0x11,%eax
 880:	cd 40                	int    $0x40
 882:	c3                   	ret

00000883 <unlink>:
SYSCALL(unlink)
 883:	b8 12 00 00 00       	mov    $0x12,%eax
 888:	cd 40                	int    $0x40
 88a:	c3                   	ret

0000088b <fstat>:
SYSCALL(fstat)
 88b:	b8 08 00 00 00       	mov    $0x8,%eax
 890:	cd 40                	int    $0x40
 892:	c3                   	ret

00000893 <link>:
SYSCALL(link)
 893:	b8 13 00 00 00       	mov    $0x13,%eax
 898:	cd 40                	int    $0x40
 89a:	c3                   	ret

0000089b <mkdir>:
SYSCALL(mkdir)
 89b:	b8 14 00 00 00       	mov    $0x14,%eax
 8a0:	cd 40                	int    $0x40
 8a2:	c3                   	ret

000008a3 <chdir>:
SYSCALL(chdir)
 8a3:	b8 09 00 00 00       	mov    $0x9,%eax
 8a8:	cd 40                	int    $0x40
 8aa:	c3                   	ret

000008ab <dup>:
SYSCALL(dup)
 8ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 8b0:	cd 40                	int    $0x40
 8b2:	c3                   	ret

000008b3 <getpid>:
SYSCALL(getpid)
 8b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 8b8:	cd 40                	int    $0x40
 8ba:	c3                   	ret

000008bb <sbrk>:
SYSCALL(sbrk)
 8bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 8c0:	cd 40                	int    $0x40
 8c2:	c3                   	ret

000008c3 <sleep>:
SYSCALL(sleep)
 8c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 8c8:	cd 40                	int    $0x40
 8ca:	c3                   	ret

000008cb <uptime>:
SYSCALL(uptime)
 8cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 8d0:	cd 40                	int    $0x40
 8d2:	c3                   	ret

000008d3 <getNumProc>:
SYSCALL(getNumProc)
 8d3:	b8 16 00 00 00       	mov    $0x16,%eax
 8d8:	cd 40                	int    $0x40
 8da:	c3                   	ret

000008db <getMaxPid>:
SYSCALL(getMaxPid)
 8db:	b8 17 00 00 00       	mov    $0x17,%eax
 8e0:	cd 40                	int    $0x40
 8e2:	c3                   	ret

000008e3 <getProcInfo>:
SYSCALL(getProcInfo)
 8e3:	b8 18 00 00 00       	mov    $0x18,%eax
 8e8:	cd 40                	int    $0x40
 8ea:	c3                   	ret
 8eb:	66 90                	xchg   %ax,%ax
 8ed:	66 90                	xchg   %ax,%ax
 8ef:	66 90                	xchg   %ax,%ax
 8f1:	66 90                	xchg   %ax,%ax
 8f3:	66 90                	xchg   %ax,%ax
 8f5:	66 90                	xchg   %ax,%ax
 8f7:	66 90                	xchg   %ax,%ax
 8f9:	66 90                	xchg   %ax,%ax
 8fb:	66 90                	xchg   %ax,%ax
 8fd:	66 90                	xchg   %ax,%ax
 8ff:	90                   	nop

00000900 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	57                   	push   %edi
 904:	56                   	push   %esi
 905:	53                   	push   %ebx
 906:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 908:	89 d1                	mov    %edx,%ecx
{
 90a:	83 ec 3c             	sub    $0x3c,%esp
 90d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  if(sgn && xx < 0){
 910:	85 d2                	test   %edx,%edx
 912:	0f 89 98 00 00 00    	jns    9b0 <printint+0xb0>
 918:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 91c:	0f 84 8e 00 00 00    	je     9b0 <printint+0xb0>
    x = -xx;
 922:	f7 d9                	neg    %ecx
    neg = 1;
 924:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 929:	89 45 c0             	mov    %eax,-0x40(%ebp)
 92c:	31 f6                	xor    %esi,%esi
 92e:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 935:	00 
 936:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 93d:	00 
 93e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
 940:	89 c8                	mov    %ecx,%eax
 942:	31 d2                	xor    %edx,%edx
 944:	89 f7                	mov    %esi,%edi
 946:	f7 f3                	div    %ebx
 948:	8d 76 01             	lea    0x1(%esi),%esi
 94b:	0f b6 92 58 0e 00 00 	movzbl 0xe58(%edx),%edx
 952:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 956:	89 ca                	mov    %ecx,%edx
 958:	89 c1                	mov    %eax,%ecx
 95a:	39 da                	cmp    %ebx,%edx
 95c:	73 e2                	jae    940 <printint+0x40>
  if(neg)
 95e:	8b 45 c0             	mov    -0x40(%ebp),%eax
 961:	85 c0                	test   %eax,%eax
 963:	74 07                	je     96c <printint+0x6c>
    buf[i++] = '-';
 965:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
 96a:	89 f7                	mov    %esi,%edi

  while(--i >= 0)
 96c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 96f:	8b 75 c4             	mov    -0x3c(%ebp),%esi
 972:	01 df                	add    %ebx,%edi
 974:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 97b:	00 
 97c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 980:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 983:	83 ec 04             	sub    $0x4,%esp
 986:	88 45 d7             	mov    %al,-0x29(%ebp)
 989:	8d 45 d7             	lea    -0x29(%ebp),%eax
 98c:	6a 01                	push   $0x1
 98e:	50                   	push   %eax
 98f:	56                   	push   %esi
 990:	e8 be fe ff ff       	call   853 <write>
  while(--i >= 0)
 995:	89 f8                	mov    %edi,%eax
 997:	83 c4 10             	add    $0x10,%esp
 99a:	83 ef 01             	sub    $0x1,%edi
 99d:	39 d8                	cmp    %ebx,%eax
 99f:	75 df                	jne    980 <printint+0x80>
}
 9a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9a4:	5b                   	pop    %ebx
 9a5:	5e                   	pop    %esi
 9a6:	5f                   	pop    %edi
 9a7:	5d                   	pop    %ebp
 9a8:	c3                   	ret
 9a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 9b0:	31 c0                	xor    %eax,%eax
 9b2:	e9 72 ff ff ff       	jmp    929 <printint+0x29>
 9b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 9be:	00 
 9bf:	90                   	nop

000009c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	57                   	push   %edi
 9c4:	56                   	push   %esi
 9c5:	53                   	push   %ebx
 9c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 9cc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 9cf:	0f b6 13             	movzbl (%ebx),%edx
 9d2:	83 c3 01             	add    $0x1,%ebx
 9d5:	84 d2                	test   %dl,%dl
 9d7:	0f 84 a0 00 00 00    	je     a7d <printf+0xbd>
 9dd:	8d 45 10             	lea    0x10(%ebp),%eax
 9e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    c = fmt[i] & 0xff;
 9e3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 9e6:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 9e9:	eb 28                	jmp    a13 <printf+0x53>
 9eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 9f0:	83 ec 04             	sub    $0x4,%esp
 9f3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 9f6:	88 55 e7             	mov    %dl,-0x19(%ebp)
  for(i = 0; fmt[i]; i++){
 9f9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 9fc:	6a 01                	push   $0x1
 9fe:	50                   	push   %eax
 9ff:	56                   	push   %esi
 a00:	e8 4e fe ff ff       	call   853 <write>
  for(i = 0; fmt[i]; i++){
 a05:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 a09:	83 c4 10             	add    $0x10,%esp
 a0c:	84 d2                	test   %dl,%dl
 a0e:	74 6d                	je     a7d <printf+0xbd>
    c = fmt[i] & 0xff;
 a10:	0f b6 c2             	movzbl %dl,%eax
      if(c == '%'){
 a13:	83 f8 25             	cmp    $0x25,%eax
 a16:	75 d8                	jne    9f0 <printf+0x30>
  for(i = 0; fmt[i]; i++){
 a18:	0f b6 13             	movzbl (%ebx),%edx
 a1b:	84 d2                	test   %dl,%dl
 a1d:	74 5e                	je     a7d <printf+0xbd>
    c = fmt[i] & 0xff;
 a1f:	0f b6 c2             	movzbl %dl,%eax
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
 a22:	80 fa 25             	cmp    $0x25,%dl
 a25:	0f 84 1d 01 00 00    	je     b48 <printf+0x188>
 a2b:	83 e8 63             	sub    $0x63,%eax
 a2e:	83 f8 15             	cmp    $0x15,%eax
 a31:	77 0d                	ja     a40 <printf+0x80>
 a33:	ff 24 85 00 0e 00 00 	jmp    *0xe00(,%eax,4)
 a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 a40:	83 ec 04             	sub    $0x4,%esp
 a43:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 a46:	88 55 d0             	mov    %dl,-0x30(%ebp)
        ap++;
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a49:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 a4d:	6a 01                	push   $0x1
 a4f:	51                   	push   %ecx
 a50:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
 a53:	56                   	push   %esi
 a54:	e8 fa fd ff ff       	call   853 <write>
        putc(fd, c);
 a59:	0f b6 55 d0          	movzbl -0x30(%ebp),%edx
  write(fd, &c, 1);
 a5d:	83 c4 0c             	add    $0xc,%esp
 a60:	88 55 e7             	mov    %dl,-0x19(%ebp)
 a63:	6a 01                	push   $0x1
 a65:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 a68:	51                   	push   %ecx
 a69:	56                   	push   %esi
 a6a:	e8 e4 fd ff ff       	call   853 <write>
  for(i = 0; fmt[i]; i++){
 a6f:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 a73:	83 c3 02             	add    $0x2,%ebx
 a76:	83 c4 10             	add    $0x10,%esp
 a79:	84 d2                	test   %dl,%dl
 a7b:	75 93                	jne    a10 <printf+0x50>
      }
      state = 0;
    }
  }
}
 a7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a80:	5b                   	pop    %ebx
 a81:	5e                   	pop    %esi
 a82:	5f                   	pop    %edi
 a83:	5d                   	pop    %ebp
 a84:	c3                   	ret
 a85:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 a88:	83 ec 0c             	sub    $0xc,%esp
 a8b:	8b 17                	mov    (%edi),%edx
 a8d:	b9 10 00 00 00       	mov    $0x10,%ecx
 a92:	89 f0                	mov    %esi,%eax
 a94:	6a 00                	push   $0x0
        ap++;
 a96:	83 c7 04             	add    $0x4,%edi
        printint(fd, *ap, 16, 0);
 a99:	e8 62 fe ff ff       	call   900 <printint>
  for(i = 0; fmt[i]; i++){
 a9e:	eb cf                	jmp    a6f <printf+0xaf>
        s = (char*)*ap;
 aa0:	8b 07                	mov    (%edi),%eax
        ap++;
 aa2:	83 c7 04             	add    $0x4,%edi
        if(s == 0)
 aa5:	85 c0                	test   %eax,%eax
 aa7:	0f 84 b3 00 00 00    	je     b60 <printf+0x1a0>
        while(*s != 0){
 aad:	0f b6 10             	movzbl (%eax),%edx
 ab0:	84 d2                	test   %dl,%dl
 ab2:	0f 84 ba 00 00 00    	je     b72 <printf+0x1b2>
 ab8:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 abb:	89 c7                	mov    %eax,%edi
 abd:	89 d0                	mov    %edx,%eax
 abf:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 ac2:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 ac5:	89 fb                	mov    %edi,%ebx
 ac7:	89 cf                	mov    %ecx,%edi
 ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 ad0:	83 ec 04             	sub    $0x4,%esp
 ad3:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 ad6:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 ad9:	6a 01                	push   $0x1
 adb:	57                   	push   %edi
 adc:	56                   	push   %esi
 add:	e8 71 fd ff ff       	call   853 <write>
        while(*s != 0){
 ae2:	0f b6 03             	movzbl (%ebx),%eax
 ae5:	83 c4 10             	add    $0x10,%esp
 ae8:	84 c0                	test   %al,%al
 aea:	75 e4                	jne    ad0 <printf+0x110>
 aec:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  for(i = 0; fmt[i]; i++){
 aef:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 af3:	83 c3 02             	add    $0x2,%ebx
 af6:	84 d2                	test   %dl,%dl
 af8:	0f 85 e5 fe ff ff    	jne    9e3 <printf+0x23>
 afe:	e9 7a ff ff ff       	jmp    a7d <printf+0xbd>
 b03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 b08:	83 ec 0c             	sub    $0xc,%esp
 b0b:	8b 17                	mov    (%edi),%edx
 b0d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 b12:	89 f0                	mov    %esi,%eax
 b14:	6a 01                	push   $0x1
        ap++;
 b16:	83 c7 04             	add    $0x4,%edi
        printint(fd, *ap, 10, 1);
 b19:	e8 e2 fd ff ff       	call   900 <printint>
  for(i = 0; fmt[i]; i++){
 b1e:	e9 4c ff ff ff       	jmp    a6f <printf+0xaf>
 b23:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 b28:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 b2a:	83 ec 04             	sub    $0x4,%esp
 b2d:	8d 4d e7             	lea    -0x19(%ebp),%ecx
        ap++;
 b30:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 b33:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 b36:	6a 01                	push   $0x1
 b38:	51                   	push   %ecx
 b39:	56                   	push   %esi
 b3a:	e8 14 fd ff ff       	call   853 <write>
  for(i = 0; fmt[i]; i++){
 b3f:	e9 2b ff ff ff       	jmp    a6f <printf+0xaf>
 b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 b48:	83 ec 04             	sub    $0x4,%esp
 b4b:	88 55 e7             	mov    %dl,-0x19(%ebp)
 b4e:	8d 4d e7             	lea    -0x19(%ebp),%ecx
 b51:	6a 01                	push   $0x1
 b53:	e9 10 ff ff ff       	jmp    a68 <printf+0xa8>
 b58:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 b5f:	00 
          s = "(null)";
 b60:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 b63:	b8 28 00 00 00       	mov    $0x28,%eax
 b68:	bf 8a 0d 00 00       	mov    $0xd8a,%edi
 b6d:	e9 4d ff ff ff       	jmp    abf <printf+0xff>
  for(i = 0; fmt[i]; i++){
 b72:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
 b76:	83 c3 02             	add    $0x2,%ebx
 b79:	84 d2                	test   %dl,%dl
 b7b:	0f 85 8f fe ff ff    	jne    a10 <printf+0x50>
 b81:	e9 f7 fe ff ff       	jmp    a7d <printf+0xbd>
 b86:	66 90                	xchg   %ax,%ax
 b88:	66 90                	xchg   %ax,%ax
 b8a:	66 90                	xchg   %ax,%ax
 b8c:	66 90                	xchg   %ax,%ax
 b8e:	66 90                	xchg   %ax,%ax
 b90:	66 90                	xchg   %ax,%ax
 b92:	66 90                	xchg   %ax,%ax
 b94:	66 90                	xchg   %ax,%ax
 b96:	66 90                	xchg   %ax,%ax
 b98:	66 90                	xchg   %ax,%ax
 b9a:	66 90                	xchg   %ax,%ax
 b9c:	66 90                	xchg   %ax,%ax
 b9e:	66 90                	xchg   %ax,%ax

00000ba0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ba0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ba1:	a1 f0 11 00 00       	mov    0x11f0,%eax
{
 ba6:	89 e5                	mov    %esp,%ebp
 ba8:	57                   	push   %edi
 ba9:	56                   	push   %esi
 baa:	53                   	push   %ebx
 bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 bae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 bb8:	00 
 bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 bc0:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc2:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc4:	39 ca                	cmp    %ecx,%edx
 bc6:	73 30                	jae    bf8 <free+0x58>
 bc8:	39 c1                	cmp    %eax,%ecx
 bca:	72 04                	jb     bd0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bcc:	39 c2                	cmp    %eax,%edx
 bce:	72 f0                	jb     bc0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 bd0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 bd3:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 bd6:	39 f8                	cmp    %edi,%eax
 bd8:	74 36                	je     c10 <free+0x70>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 bda:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 bdd:	8b 42 04             	mov    0x4(%edx),%eax
 be0:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 be3:	39 f1                	cmp    %esi,%ecx
 be5:	74 40                	je     c27 <free+0x87>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 be7:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 be9:	5b                   	pop    %ebx
  freep = p;
 bea:	89 15 f0 11 00 00    	mov    %edx,0x11f0
}
 bf0:	5e                   	pop    %esi
 bf1:	5f                   	pop    %edi
 bf2:	5d                   	pop    %ebp
 bf3:	c3                   	ret
 bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bf8:	39 c2                	cmp    %eax,%edx
 bfa:	72 c4                	jb     bc0 <free+0x20>
 bfc:	39 c1                	cmp    %eax,%ecx
 bfe:	73 c0                	jae    bc0 <free+0x20>
  if(bp + bp->s.size == p->s.ptr){
 c00:	8b 73 fc             	mov    -0x4(%ebx),%esi
 c03:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 c06:	39 f8                	cmp    %edi,%eax
 c08:	75 d0                	jne    bda <free+0x3a>
 c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 c10:	03 70 04             	add    0x4(%eax),%esi
 c13:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 c16:	8b 02                	mov    (%edx),%eax
 c18:	8b 00                	mov    (%eax),%eax
 c1a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 c1d:	8b 42 04             	mov    0x4(%edx),%eax
 c20:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 c23:	39 f1                	cmp    %esi,%ecx
 c25:	75 c0                	jne    be7 <free+0x47>
    p->s.size += bp->s.size;
 c27:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 c2a:	89 15 f0 11 00 00    	mov    %edx,0x11f0
    p->s.size += bp->s.size;
 c30:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 c33:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 c36:	89 0a                	mov    %ecx,(%edx)
}
 c38:	5b                   	pop    %ebx
 c39:	5e                   	pop    %esi
 c3a:	5f                   	pop    %edi
 c3b:	5d                   	pop    %ebp
 c3c:	c3                   	ret
 c3d:	8d 76 00             	lea    0x0(%esi),%esi

00000c40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c40:	55                   	push   %ebp
 c41:	89 e5                	mov    %esp,%ebp
 c43:	57                   	push   %edi
 c44:	56                   	push   %esi
 c45:	53                   	push   %ebx
 c46:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c49:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 c4c:	8b 15 f0 11 00 00    	mov    0x11f0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c52:	8d 78 07             	lea    0x7(%eax),%edi
 c55:	c1 ef 03             	shr    $0x3,%edi
 c58:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 c5b:	85 d2                	test   %edx,%edx
 c5d:	0f 84 8d 00 00 00    	je     cf0 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c63:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 c65:	8b 48 04             	mov    0x4(%eax),%ecx
 c68:	39 f9                	cmp    %edi,%ecx
 c6a:	73 64                	jae    cd0 <malloc+0x90>
  if(nu < 4096)
 c6c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 c71:	39 df                	cmp    %ebx,%edi
 c73:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 c76:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 c7d:	eb 0a                	jmp    c89 <malloc+0x49>
 c7f:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c80:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 c82:	8b 48 04             	mov    0x4(%eax),%ecx
 c85:	39 f9                	cmp    %edi,%ecx
 c87:	73 47                	jae    cd0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c89:	89 c2                	mov    %eax,%edx
 c8b:	39 05 f0 11 00 00    	cmp    %eax,0x11f0
 c91:	75 ed                	jne    c80 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 c93:	83 ec 0c             	sub    $0xc,%esp
 c96:	56                   	push   %esi
 c97:	e8 1f fc ff ff       	call   8bb <sbrk>
  if(p == (char*)-1)
 c9c:	83 c4 10             	add    $0x10,%esp
 c9f:	83 f8 ff             	cmp    $0xffffffff,%eax
 ca2:	74 1c                	je     cc0 <malloc+0x80>
  hp->s.size = nu;
 ca4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 ca7:	83 ec 0c             	sub    $0xc,%esp
 caa:	83 c0 08             	add    $0x8,%eax
 cad:	50                   	push   %eax
 cae:	e8 ed fe ff ff       	call   ba0 <free>
  return freep;
 cb3:	8b 15 f0 11 00 00    	mov    0x11f0,%edx
      if((p = morecore(nunits)) == 0)
 cb9:	83 c4 10             	add    $0x10,%esp
 cbc:	85 d2                	test   %edx,%edx
 cbe:	75 c0                	jne    c80 <malloc+0x40>
        return 0;
  }
}
 cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 cc3:	31 c0                	xor    %eax,%eax
}
 cc5:	5b                   	pop    %ebx
 cc6:	5e                   	pop    %esi
 cc7:	5f                   	pop    %edi
 cc8:	5d                   	pop    %ebp
 cc9:	c3                   	ret
 cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 cd0:	39 cf                	cmp    %ecx,%edi
 cd2:	74 4c                	je     d20 <malloc+0xe0>
        p->s.size -= nunits;
 cd4:	29 f9                	sub    %edi,%ecx
 cd6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 cd9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 cdc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 cdf:	89 15 f0 11 00 00    	mov    %edx,0x11f0
}
 ce5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 ce8:	83 c0 08             	add    $0x8,%eax
}
 ceb:	5b                   	pop    %ebx
 cec:	5e                   	pop    %esi
 ced:	5f                   	pop    %edi
 cee:	5d                   	pop    %ebp
 cef:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 cf0:	c7 05 f0 11 00 00 f4 	movl   $0x11f4,0x11f0
 cf7:	11 00 00 
    base.s.size = 0;
 cfa:	b8 f4 11 00 00       	mov    $0x11f4,%eax
    base.s.ptr = freep = prevp = &base;
 cff:	c7 05 f4 11 00 00 f4 	movl   $0x11f4,0x11f4
 d06:	11 00 00 
    base.s.size = 0;
 d09:	c7 05 f8 11 00 00 00 	movl   $0x0,0x11f8
 d10:	00 00 00 
    if(p->s.size >= nunits){
 d13:	e9 54 ff ff ff       	jmp    c6c <malloc+0x2c>
 d18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 d1f:	00 
        prevp->s.ptr = p->s.ptr;
 d20:	8b 08                	mov    (%eax),%ecx
 d22:	89 0a                	mov    %ecx,(%edx)
 d24:	eb b9                	jmp    cdf <malloc+0x9f>
