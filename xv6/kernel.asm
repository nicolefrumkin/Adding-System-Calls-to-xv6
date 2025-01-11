
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 55 11 80       	mov    $0x801155d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 31 10 80       	mov    $0x80103130,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 75 10 80       	push   $0x80107540
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 05 46 00 00       	call   80104660 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 75 10 80       	push   $0x80107547
80100097:	50                   	push   %eax
80100098:	e8 83 44 00 00       	call   80104520 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 87 47 00 00       	call   80104870 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 4f                	jmp    8010016a <bread+0x9a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 1d                	jne    8010014b <bread+0x7b>
8010012e:	eb 7e                	jmp    801001ae <bread+0xde>
80100130:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100137:	00 
80100138:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010013f:	00 
80100140:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100143:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100149:	74 63                	je     801001ae <bread+0xde>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010014b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010014e:	85 c0                	test   %eax,%eax
80100150:	75 ee                	jne    80100140 <bread+0x70>
80100152:	f6 03 04             	testb  $0x4,(%ebx)
80100155:	75 e9                	jne    80100140 <bread+0x70>
      b->dev = dev;
80100157:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010015a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010015d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100163:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010016a:	83 ec 0c             	sub    $0xc,%esp
8010016d:	68 20 a5 10 80       	push   $0x8010a520
80100172:	e8 99 46 00 00       	call   80104810 <release>
      acquiresleep(&b->lock);
80100177:	8d 43 0c             	lea    0xc(%ebx),%eax
8010017a:	89 04 24             	mov    %eax,(%esp)
8010017d:	e8 de 43 00 00       	call   80104560 <acquiresleep>
      return b;
80100182:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100185:	f6 03 02             	testb  $0x2,(%ebx)
80100188:	74 0e                	je     80100198 <bread+0xc8>
    iderw(b);
  }
  return b;
}
8010018a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010018d:	89 d8                	mov    %ebx,%eax
8010018f:	5b                   	pop    %ebx
80100190:	5e                   	pop    %esi
80100191:	5f                   	pop    %edi
80100192:	5d                   	pop    %ebp
80100193:	c3                   	ret
80100194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100198:	83 ec 0c             	sub    $0xc,%esp
8010019b:	53                   	push   %ebx
8010019c:	e8 9f 21 00 00       	call   80102340 <iderw>
801001a1:	83 c4 10             	add    $0x10,%esp
}
801001a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801001a7:	89 d8                	mov    %ebx,%eax
801001a9:	5b                   	pop    %ebx
801001aa:	5e                   	pop    %esi
801001ab:	5f                   	pop    %edi
801001ac:	5d                   	pop    %ebp
801001ad:	c3                   	ret
  panic("bget: no buffers");
801001ae:	83 ec 0c             	sub    $0xc,%esp
801001b1:	68 4e 75 10 80       	push   $0x8010754e
801001b6:	e8 e5 01 00 00       	call   801003a0 <panic>
801001bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001c0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001c0:	55                   	push   %ebp
801001c1:	89 e5                	mov    %esp,%ebp
801001c3:	53                   	push   %ebx
801001c4:	83 ec 10             	sub    $0x10,%esp
801001c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801001cd:	50                   	push   %eax
801001ce:	e8 2d 44 00 00       	call   80104600 <holdingsleep>
801001d3:	83 c4 10             	add    $0x10,%esp
801001d6:	85 c0                	test   %eax,%eax
801001d8:	74 0f                	je     801001e9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001da:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001dd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001e3:	c9                   	leave
  iderw(b);
801001e4:	e9 57 21 00 00       	jmp    80102340 <iderw>
    panic("bwrite");
801001e9:	83 ec 0c             	sub    $0xc,%esp
801001ec:	68 5f 75 10 80       	push   $0x8010755f
801001f1:	e8 aa 01 00 00       	call   801003a0 <panic>
801001f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001fd:	00 
801001fe:	66 90                	xchg   %ax,%ax

80100200 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100200:	55                   	push   %ebp
80100201:	89 e5                	mov    %esp,%ebp
80100203:	56                   	push   %esi
80100204:	53                   	push   %ebx
80100205:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100208:	8d 73 0c             	lea    0xc(%ebx),%esi
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ec 43 00 00       	call   80104600 <holdingsleep>
80100214:	83 c4 10             	add    $0x10,%esp
80100217:	85 c0                	test   %eax,%eax
80100219:	74 63                	je     8010027e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010021b:	83 ec 0c             	sub    $0xc,%esp
8010021e:	56                   	push   %esi
8010021f:	e8 9c 43 00 00       	call   801045c0 <releasesleep>

  acquire(&bcache.lock);
80100224:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010022b:	e8 40 46 00 00       	call   80104870 <acquire>
  b->refcnt--;
80100230:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100233:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100236:	83 e8 01             	sub    $0x1,%eax
80100239:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 2c                	jne    8010026c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	8b 43 50             	mov    0x50(%ebx),%eax
80100246:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100249:	8b 53 54             	mov    0x54(%ebx),%edx
8010024c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010024f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100254:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010025b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010025e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100263:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100266:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010026c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100273:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100276:	5b                   	pop    %ebx
80100277:	5e                   	pop    %esi
80100278:	5d                   	pop    %ebp
  release(&bcache.lock);
80100279:	e9 92 45 00 00       	jmp    80104810 <release>
    panic("brelse");
8010027e:	83 ec 0c             	sub    $0xc,%esp
80100281:	68 66 75 10 80       	push   $0x80107566
80100286:	e8 15 01 00 00       	call   801003a0 <panic>
8010028b:	66 90                	xchg   %ax,%ax
8010028d:	66 90                	xchg   %ax,%ax
8010028f:	66 90                	xchg   %ax,%ax
80100291:	66 90                	xchg   %ax,%ax
80100293:	66 90                	xchg   %ax,%ax
80100295:	66 90                	xchg   %ax,%ax
80100297:	66 90                	xchg   %ax,%ax
80100299:	66 90                	xchg   %ax,%ax
8010029b:	66 90                	xchg   %ax,%ax
8010029d:	66 90                	xchg   %ax,%ax
8010029f:	90                   	nop

801002a0 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801002a0:	55                   	push   %ebp
801002a1:	89 e5                	mov    %esp,%ebp
801002a3:	57                   	push   %edi
801002a4:	56                   	push   %esi
801002a5:	53                   	push   %ebx
801002a6:	83 ec 18             	sub    $0x18,%esp
801002a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801002af:	ff 75 08             	push   0x8(%ebp)
  target = n;
801002b2:	89 df                	mov    %ebx,%edi
  iunlock(ip);
801002b4:	e8 17 16 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801002b9:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002c0:	e8 ab 45 00 00       	call   80104870 <acquire>
  while(n > 0){
801002c5:	83 c4 10             	add    $0x10,%esp
801002c8:	85 db                	test   %ebx,%ebx
801002ca:	0f 8e 94 00 00 00    	jle    80100364 <consoleread+0xc4>
    while(input.r == input.w){
801002d0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002db:	74 25                	je     80100302 <consoleread+0x62>
801002dd:	eb 59                	jmp    80100338 <consoleread+0x98>
801002df:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002e0:	83 ec 08             	sub    $0x8,%esp
801002e3:	68 20 ef 10 80       	push   $0x8010ef20
801002e8:	68 00 ef 10 80       	push   $0x8010ef00
801002ed:	e8 6e 3e 00 00       	call   80104160 <sleep>
    while(input.r == input.w){
801002f2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002f7:	83 c4 10             	add    $0x10,%esp
801002fa:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100300:	75 36                	jne    80100338 <consoleread+0x98>
      if(myproc()->killed){
80100302:	e8 79 37 00 00       	call   80103a80 <myproc>
80100307:	8b 48 24             	mov    0x24(%eax),%ecx
8010030a:	85 c9                	test   %ecx,%ecx
8010030c:	74 d2                	je     801002e0 <consoleread+0x40>
        release(&cons.lock);
8010030e:	83 ec 0c             	sub    $0xc,%esp
80100311:	68 20 ef 10 80       	push   $0x8010ef20
80100316:	e8 f5 44 00 00       	call   80104810 <release>
        ilock(ip);
8010031b:	5a                   	pop    %edx
8010031c:	ff 75 08             	push   0x8(%ebp)
8010031f:	e8 cc 14 00 00       	call   801017f0 <ilock>
        return -1;
80100324:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100327:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010032a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010032f:	5b                   	pop    %ebx
80100330:	5e                   	pop    %esi
80100331:	5f                   	pop    %edi
80100332:	5d                   	pop    %ebp
80100333:	c3                   	ret
80100334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100338:	8d 50 01             	lea    0x1(%eax),%edx
8010033b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100341:	89 c2                	mov    %eax,%edx
80100343:	83 e2 7f             	and    $0x7f,%edx
80100346:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010034d:	80 f9 04             	cmp    $0x4,%cl
80100350:	74 37                	je     80100389 <consoleread+0xe9>
    *dst++ = c;
80100352:	83 c6 01             	add    $0x1,%esi
    --n;
80100355:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100358:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010035b:	83 f9 0a             	cmp    $0xa,%ecx
8010035e:	0f 85 64 ff ff ff    	jne    801002c8 <consoleread+0x28>
  release(&cons.lock);
80100364:	83 ec 0c             	sub    $0xc,%esp
80100367:	68 20 ef 10 80       	push   $0x8010ef20
8010036c:	e8 9f 44 00 00       	call   80104810 <release>
  ilock(ip);
80100371:	58                   	pop    %eax
80100372:	ff 75 08             	push   0x8(%ebp)
80100375:	e8 76 14 00 00       	call   801017f0 <ilock>
  return target - n;
8010037a:	89 f8                	mov    %edi,%eax
8010037c:	83 c4 10             	add    $0x10,%esp
}
8010037f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100382:	29 d8                	sub    %ebx,%eax
}
80100384:	5b                   	pop    %ebx
80100385:	5e                   	pop    %esi
80100386:	5f                   	pop    %edi
80100387:	5d                   	pop    %ebp
80100388:	c3                   	ret
      if(n < target){
80100389:	39 fb                	cmp    %edi,%ebx
8010038b:	73 d7                	jae    80100364 <consoleread+0xc4>
        input.r--;
8010038d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100392:	eb d0                	jmp    80100364 <consoleread+0xc4>
80100394:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010039b:	00 
8010039c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801003a0 <panic>:
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	53                   	push   %ebx
801003a4:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801003a7:	fa                   	cli
  cons.locking = 0;
801003a8:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
801003af:	00 00 00 
  getcallerpcs(&s, pcs);
801003b2:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
801003b5:	e8 d6 25 00 00       	call   80102990 <lapicid>
801003ba:	83 ec 08             	sub    $0x8,%esp
801003bd:	50                   	push   %eax
801003be:	68 6d 75 10 80       	push   $0x8010756d
801003c3:	e8 08 03 00 00       	call   801006d0 <cprintf>
  cprintf(s);
801003c8:	58                   	pop    %eax
801003c9:	ff 75 08             	push   0x8(%ebp)
801003cc:	e8 ff 02 00 00       	call   801006d0 <cprintf>
  cprintf("\n");
801003d1:	c7 04 24 ef 79 10 80 	movl   $0x801079ef,(%esp)
801003d8:	e8 f3 02 00 00       	call   801006d0 <cprintf>
  getcallerpcs(&s, pcs);
801003dd:	8d 45 08             	lea    0x8(%ebp),%eax
801003e0:	5a                   	pop    %edx
801003e1:	59                   	pop    %ecx
801003e2:	53                   	push   %ebx
801003e3:	50                   	push   %eax
801003e4:	e8 97 42 00 00       	call   80104680 <getcallerpcs>
  for(i=0; i<10; i++)
801003e9:	83 c4 10             	add    $0x10,%esp
801003ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003f0:	83 ec 08             	sub    $0x8,%esp
801003f3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003f5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003f8:	68 81 75 10 80       	push   $0x80107581
801003fd:	e8 ce 02 00 00       	call   801006d0 <cprintf>
  for(i=0; i<10; i++)
80100402:	8d 45 f8             	lea    -0x8(%ebp),%eax
80100405:	83 c4 10             	add    $0x10,%esp
80100408:	39 c3                	cmp    %eax,%ebx
8010040a:	75 e4                	jne    801003f0 <panic+0x50>
  panicked = 1; // freeze other CPU
8010040c:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
80100413:	00 00 00 
  for(;;)
80100416:	eb fe                	jmp    80100416 <panic+0x76>
80100418:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010041f:	00 

80100420 <consputc.part.0>:
consputc(int c)
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
80100429:	3d 00 01 00 00       	cmp    $0x100,%eax
8010042e:	0f 84 cc 00 00 00    	je     80100500 <consputc.part.0+0xe0>
    uartputc(c);
80100434:	83 ec 0c             	sub    $0xc,%esp
80100437:	89 c3                	mov    %eax,%ebx
80100439:	50                   	push   %eax
8010043a:	e8 31 5c 00 00       	call   80106070 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100444:	ba d4 03 00 00       	mov    $0x3d4,%edx
80100449:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044a:	be d5 03 00 00       	mov    $0x3d5,%esi
8010044f:	89 f2                	mov    %esi,%edx
80100451:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100452:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100455:	ba d4 03 00 00       	mov    $0x3d4,%edx
8010045a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010045f:	c1 e1 08             	shl    $0x8,%ecx
80100462:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100463:	89 f2                	mov    %esi,%edx
80100465:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100466:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100469:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010046c:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010046e:	83 fb 0a             	cmp    $0xa,%ebx
80100471:	75 75                	jne    801004e8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100473:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100478:	f7 e2                	mul    %edx
8010047a:	c1 ea 06             	shr    $0x6,%edx
8010047d:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100480:	c1 e0 04             	shl    $0x4,%eax
80100483:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100486:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010048c:	0f 8f 24 01 00 00    	jg     801005b6 <consputc.part.0+0x196>
  if((pos/80) >= 24){  // Scroll up.
80100492:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100498:	0f 8f c2 00 00 00    	jg     80100560 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010049e:	89 f0                	mov    %esi,%eax
  outb(CRTPORT+1, pos);
801004a0:	89 f1                	mov    %esi,%ecx
  crt[pos] = ' ' | 0x0700;
801004a2:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos>>8);
801004a9:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ac:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b1:	ba d4 03 00 00       	mov    $0x3d4,%edx
801004b6:	ee                   	out    %al,(%dx)
801004b7:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801004bc:	89 f8                	mov    %edi,%eax
801004be:	89 da                	mov    %ebx,%edx
801004c0:	ee                   	out    %al,(%dx)
801004c1:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c6:	ba d4 03 00 00       	mov    $0x3d4,%edx
801004cb:	ee                   	out    %al,(%dx)
801004cc:	89 c8                	mov    %ecx,%eax
801004ce:	89 da                	mov    %ebx,%edx
801004d0:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d1:	b8 20 07 00 00       	mov    $0x720,%eax
801004d6:	66 89 06             	mov    %ax,(%esi)
}
801004d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004dc:	5b                   	pop    %ebx
801004dd:	5e                   	pop    %esi
801004de:	5f                   	pop    %edi
801004df:	5d                   	pop    %ebp
801004e0:	c3                   	ret
801004e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004e8:	0f b6 db             	movzbl %bl,%ebx
801004eb:	8d 70 01             	lea    0x1(%eax),%esi
801004ee:	80 cf 07             	or     $0x7,%bh
801004f1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004f8:	80 
801004f9:	eb 8b                	jmp    80100486 <consputc.part.0+0x66>
801004fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 66 5b 00 00       	call   80106070 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 5a 5b 00 00       	call   80106070 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 4e 5b 00 00       	call   80106070 <uartputc>
80100522:	b8 0e 00 00 00       	mov    $0xe,%eax
80100527:	ba d4 03 00 00       	mov    $0x3d4,%edx
8010052c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010052d:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100532:	89 da                	mov    %ebx,%edx
80100534:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100535:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100538:	ba d4 03 00 00       	mov    $0x3d4,%edx
8010053d:	b8 0f 00 00 00       	mov    $0xf,%eax
80100542:	c1 e1 08             	shl    $0x8,%ecx
80100545:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100546:	89 da                	mov    %ebx,%edx
80100548:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100549:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010054c:	83 c4 10             	add    $0x10,%esp
8010054f:	09 ce                	or     %ecx,%esi
80100551:	74 55                	je     801005a8 <consputc.part.0+0x188>
80100553:	83 ee 01             	sub    $0x1,%esi
80100556:	e9 2b ff ff ff       	jmp    80100486 <consputc.part.0+0x66>
8010055b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100560:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100563:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010056d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100572:	68 60 0e 00 00       	push   $0xe60
80100577:	68 a0 80 0b 80       	push   $0x800b80a0
8010057c:	68 00 80 0b 80       	push   $0x800b8000
80100581:	e8 aa 44 00 00       	call   80104a30 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100586:	b8 80 07 00 00       	mov    $0x780,%eax
8010058b:	83 c4 0c             	add    $0xc,%esp
8010058e:	29 d8                	sub    %ebx,%eax
80100590:	01 c0                	add    %eax,%eax
80100592:	50                   	push   %eax
80100593:	6a 00                	push   $0x0
80100595:	56                   	push   %esi
80100596:	e8 05 44 00 00       	call   801049a0 <memset>
  outb(CRTPORT+1, pos);
8010059b:	89 d9                	mov    %ebx,%ecx
8010059d:	83 c4 10             	add    $0x10,%esp
801005a0:	e9 07 ff ff ff       	jmp    801004ac <consputc.part.0+0x8c>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
801005a8:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801005ad:	31 c9                	xor    %ecx,%ecx
801005af:	31 ff                	xor    %edi,%edi
801005b1:	e9 f6 fe ff ff       	jmp    801004ac <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005b6:	83 ec 0c             	sub    $0xc,%esp
801005b9:	68 85 75 10 80       	push   $0x80107585
801005be:	e8 dd fd ff ff       	call   801003a0 <panic>
801005c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801005ca:	00 
801005cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801005d0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 18             	sub    $0x18,%esp
801005d9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005dc:	ff 75 08             	push   0x8(%ebp)
801005df:	e8 ec 12 00 00       	call   801018d0 <iunlock>
  acquire(&cons.lock);
801005e4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005eb:	e8 80 42 00 00       	call   80104870 <acquire>
  for(i = 0; i < n; i++)
801005f0:	83 c4 10             	add    $0x10,%esp
801005f3:	85 f6                	test   %esi,%esi
801005f5:	7e 28                	jle    8010061f <consolewrite+0x4f>
801005f7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005fa:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005fd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100603:	85 d2                	test   %edx,%edx
80100605:	74 09                	je     80100610 <consolewrite+0x40>
  asm volatile("cli");
80100607:	fa                   	cli
    for(;;)
80100608:	eb fe                	jmp    80100608 <consolewrite+0x38>
8010060a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100610:	0f b6 03             	movzbl (%ebx),%eax
  for(i = 0; i < n; i++)
80100613:	83 c3 01             	add    $0x1,%ebx
80100616:	e8 05 fe ff ff       	call   80100420 <consputc.part.0>
8010061b:	39 fb                	cmp    %edi,%ebx
8010061d:	75 de                	jne    801005fd <consolewrite+0x2d>
  release(&cons.lock);
8010061f:	83 ec 0c             	sub    $0xc,%esp
80100622:	68 20 ef 10 80       	push   $0x8010ef20
80100627:	e8 e4 41 00 00       	call   80104810 <release>
  ilock(ip);
8010062c:	58                   	pop    %eax
8010062d:	ff 75 08             	push   0x8(%ebp)
80100630:	e8 bb 11 00 00       	call   801017f0 <ilock>

  return n;
}
80100635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100638:	89 f0                	mov    %esi,%eax
8010063a:	5b                   	pop    %ebx
8010063b:	5e                   	pop    %esi
8010063c:	5f                   	pop    %edi
8010063d:	5d                   	pop    %ebp
8010063e:	c3                   	ret
8010063f:	90                   	nop

80100640 <printint>:
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
80100644:	56                   	push   %esi
80100645:	53                   	push   %ebx
80100646:	89 d3                	mov    %edx,%ebx
80100648:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010064b:	85 c0                	test   %eax,%eax
8010064d:	79 05                	jns    80100654 <printint+0x14>
8010064f:	83 e1 01             	and    $0x1,%ecx
80100652:	75 5f                	jne    801006b3 <printint+0x73>
    x = xx;
80100654:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010065b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010065d:	31 f6                	xor    %esi,%esi
8010065f:	90                   	nop
    buf[i++] = digits[x % base];
80100660:	89 c8                	mov    %ecx,%eax
80100662:	31 d2                	xor    %edx,%edx
80100664:	89 f7                	mov    %esi,%edi
80100666:	f7 f3                	div    %ebx
80100668:	8d 76 01             	lea    0x1(%esi),%esi
8010066b:	0f b6 92 40 7a 10 80 	movzbl -0x7fef85c0(%edx),%edx
80100672:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100676:	89 ca                	mov    %ecx,%edx
80100678:	89 c1                	mov    %eax,%ecx
8010067a:	39 da                	cmp    %ebx,%edx
8010067c:	73 e2                	jae    80100660 <printint+0x20>
  if(sign)
8010067e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100681:	85 d2                	test   %edx,%edx
80100683:	74 07                	je     8010068c <printint+0x4c>
    buf[i++] = '-';
80100685:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
8010068a:	89 f7                	mov    %esi,%edi
  while(--i >= 0)
8010068c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010068f:	01 df                	add    %ebx,%edi
  if(panicked){
80100691:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100696:	85 c0                	test   %eax,%eax
80100698:	74 06                	je     801006a0 <printint+0x60>
8010069a:	fa                   	cli
    for(;;)
8010069b:	eb fe                	jmp    8010069b <printint+0x5b>
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i]);
801006a0:	0f be 07             	movsbl (%edi),%eax
801006a3:	e8 78 fd ff ff       	call   80100420 <consputc.part.0>
  while(--i >= 0)
801006a8:	8d 47 ff             	lea    -0x1(%edi),%eax
801006ab:	39 df                	cmp    %ebx,%edi
801006ad:	74 11                	je     801006c0 <printint+0x80>
801006af:	89 c7                	mov    %eax,%edi
801006b1:	eb de                	jmp    80100691 <printint+0x51>
    x = -xx;
801006b3:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
801006b5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006bc:	89 c1                	mov    %eax,%ecx
801006be:	eb 9d                	jmp    8010065d <printint+0x1d>
}
801006c0:	83 c4 2c             	add    $0x2c,%esp
801006c3:	5b                   	pop    %ebx
801006c4:	5e                   	pop    %esi
801006c5:	5f                   	pop    %edi
801006c6:	5d                   	pop    %ebp
801006c7:	c3                   	ret
801006c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801006cf:	00 

801006d0 <cprintf>:
{
801006d0:	55                   	push   %ebp
801006d1:	89 e5                	mov    %esp,%ebp
801006d3:	57                   	push   %edi
801006d4:	56                   	push   %esi
801006d5:	53                   	push   %ebx
801006d6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006d9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006df:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006e2:	85 ff                	test   %edi,%edi
801006e4:	0f 85 06 01 00 00    	jne    801007f0 <cprintf+0x120>
  if (fmt == 0)
801006ea:	85 f6                	test   %esi,%esi
801006ec:	0f 84 b7 01 00 00    	je     801008a9 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f2:	0f b6 06             	movzbl (%esi),%eax
801006f5:	85 c0                	test   %eax,%eax
801006f7:	74 5f                	je     80100758 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006f9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006ff:	31 db                	xor    %ebx,%ebx
80100701:	89 d7                	mov    %edx,%edi
    if(c != '%'){
80100703:	83 f8 25             	cmp    $0x25,%eax
80100706:	75 58                	jne    80100760 <cprintf+0x90>
    c = fmt[++i] & 0xff;
80100708:	83 c3 01             	add    $0x1,%ebx
8010070b:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
8010070f:	85 c9                	test   %ecx,%ecx
80100711:	74 3a                	je     8010074d <cprintf+0x7d>
    switch(c){
80100713:	83 f9 70             	cmp    $0x70,%ecx
80100716:	0f 84 b4 00 00 00    	je     801007d0 <cprintf+0x100>
8010071c:	7f 72                	jg     80100790 <cprintf+0xc0>
8010071e:	83 f9 25             	cmp    $0x25,%ecx
80100721:	74 4d                	je     80100770 <cprintf+0xa0>
80100723:	83 f9 64             	cmp    $0x64,%ecx
80100726:	75 76                	jne    8010079e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100728:	8d 47 04             	lea    0x4(%edi),%eax
8010072b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100730:	ba 0a 00 00 00       	mov    $0xa,%edx
80100735:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100738:	8b 07                	mov    (%edi),%eax
8010073a:	e8 01 ff ff ff       	call   80100640 <printint>
8010073f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100742:	83 c3 01             	add    $0x1,%ebx
80100745:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100749:	85 c0                	test   %eax,%eax
8010074b:	75 b6                	jne    80100703 <cprintf+0x33>
8010074d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100750:	85 ff                	test   %edi,%edi
80100752:	0f 85 bb 00 00 00    	jne    80100813 <cprintf+0x143>
}
80100758:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010075b:	5b                   	pop    %ebx
8010075c:	5e                   	pop    %esi
8010075d:	5f                   	pop    %edi
8010075e:	5d                   	pop    %ebp
8010075f:	c3                   	ret
  if(panicked){
80100760:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100766:	85 c9                	test   %ecx,%ecx
80100768:	74 19                	je     80100783 <cprintf+0xb3>
8010076a:	fa                   	cli
    for(;;)
8010076b:	eb fe                	jmp    8010076b <cprintf+0x9b>
8010076d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100770:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100776:	85 c9                	test   %ecx,%ecx
80100778:	0f 85 f2 00 00 00    	jne    80100870 <cprintf+0x1a0>
8010077e:	b8 25 00 00 00       	mov    $0x25,%eax
80100783:	e8 98 fc ff ff       	call   80100420 <consputc.part.0>
      break;
80100788:	eb b8                	jmp    80100742 <cprintf+0x72>
8010078a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100790:	83 f9 73             	cmp    $0x73,%ecx
80100793:	0f 84 8f 00 00 00    	je     80100828 <cprintf+0x158>
80100799:	83 f9 78             	cmp    $0x78,%ecx
8010079c:	74 32                	je     801007d0 <cprintf+0x100>
  if(panicked){
8010079e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
801007a4:	85 d2                	test   %edx,%edx
801007a6:	0f 85 b8 00 00 00    	jne    80100864 <cprintf+0x194>
801007ac:	b8 25 00 00 00       	mov    $0x25,%eax
801007b1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801007b4:	e8 67 fc ff ff       	call   80100420 <consputc.part.0>
801007b9:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
801007be:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007c1:	85 c0                	test   %eax,%eax
801007c3:	0f 84 cd 00 00 00    	je     80100896 <cprintf+0x1c6>
801007c9:	fa                   	cli
    for(;;)
801007ca:	eb fe                	jmp    801007ca <cprintf+0xfa>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007d0:	8d 47 04             	lea    0x4(%edi),%eax
801007d3:	31 c9                	xor    %ecx,%ecx
801007d5:	ba 10 00 00 00       	mov    $0x10,%edx
801007da:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007dd:	8b 07                	mov    (%edi),%eax
801007df:	e8 5c fe ff ff       	call   80100640 <printint>
801007e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007e7:	e9 56 ff ff ff       	jmp    80100742 <cprintf+0x72>
801007ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007f0:	83 ec 0c             	sub    $0xc,%esp
801007f3:	68 20 ef 10 80       	push   $0x8010ef20
801007f8:	e8 73 40 00 00       	call   80104870 <acquire>
  if (fmt == 0)
801007fd:	83 c4 10             	add    $0x10,%esp
80100800:	85 f6                	test   %esi,%esi
80100802:	0f 84 a1 00 00 00    	je     801008a9 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100808:	0f b6 06             	movzbl (%esi),%eax
8010080b:	85 c0                	test   %eax,%eax
8010080d:	0f 85 e6 fe ff ff    	jne    801006f9 <cprintf+0x29>
    release(&cons.lock);
80100813:	83 ec 0c             	sub    $0xc,%esp
80100816:	68 20 ef 10 80       	push   $0x8010ef20
8010081b:	e8 f0 3f 00 00       	call   80104810 <release>
80100820:	83 c4 10             	add    $0x10,%esp
80100823:	e9 30 ff ff ff       	jmp    80100758 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100828:	8b 17                	mov    (%edi),%edx
8010082a:	8d 47 04             	lea    0x4(%edi),%eax
8010082d:	85 d2                	test   %edx,%edx
8010082f:	74 27                	je     80100858 <cprintf+0x188>
      for(; *s; s++)
80100831:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100834:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100836:	84 c9                	test   %cl,%cl
80100838:	74 68                	je     801008a2 <cprintf+0x1d2>
8010083a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010083d:	89 fb                	mov    %edi,%ebx
8010083f:	89 f7                	mov    %esi,%edi
80100841:	89 c6                	mov    %eax,%esi
80100843:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100846:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010084c:	85 d2                	test   %edx,%edx
8010084e:	74 28                	je     80100878 <cprintf+0x1a8>
80100850:	fa                   	cli
    for(;;)
80100851:	eb fe                	jmp    80100851 <cprintf+0x181>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010085d:	bf 98 75 10 80       	mov    $0x80107598,%edi
80100862:	eb d6                	jmp    8010083a <cprintf+0x16a>
80100864:	fa                   	cli
    for(;;)
80100865:	eb fe                	jmp    80100865 <cprintf+0x195>
80100867:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010086e:	00 
8010086f:	90                   	nop
80100870:	fa                   	cli
80100871:	eb fe                	jmp    80100871 <cprintf+0x1a1>
80100873:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100878:	e8 a3 fb ff ff       	call   80100420 <consputc.part.0>
      for(; *s; s++)
8010087d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100881:	83 c3 01             	add    $0x1,%ebx
80100884:	84 c0                	test   %al,%al
80100886:	75 be                	jne    80100846 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100888:	89 f0                	mov    %esi,%eax
8010088a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010088d:	89 fe                	mov    %edi,%esi
8010088f:	89 c7                	mov    %eax,%edi
80100891:	e9 ac fe ff ff       	jmp    80100742 <cprintf+0x72>
80100896:	89 c8                	mov    %ecx,%eax
80100898:	e8 83 fb ff ff       	call   80100420 <consputc.part.0>
      break;
8010089d:	e9 a0 fe ff ff       	jmp    80100742 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
801008a2:	89 c7                	mov    %eax,%edi
801008a4:	e9 99 fe ff ff       	jmp    80100742 <cprintf+0x72>
    panic("null fmt");
801008a9:	83 ec 0c             	sub    $0xc,%esp
801008ac:	68 9f 75 10 80       	push   $0x8010759f
801008b1:	e8 ea fa ff ff       	call   801003a0 <panic>
801008b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801008bd:	00 
801008be:	66 90                	xchg   %ax,%ax

801008c0 <consoleintr>:
{
801008c0:	55                   	push   %ebp
801008c1:	89 e5                	mov    %esp,%ebp
801008c3:	57                   	push   %edi
  int c, doprocdump = 0;
801008c4:	31 ff                	xor    %edi,%edi
{
801008c6:	56                   	push   %esi
801008c7:	53                   	push   %ebx
801008c8:	83 ec 18             	sub    $0x18,%esp
801008cb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ce:	68 20 ef 10 80       	push   $0x8010ef20
801008d3:	e8 98 3f 00 00       	call   80104870 <acquire>
  while((c = getc()) >= 0){
801008d8:	83 c4 10             	add    $0x10,%esp
801008db:	ff d6                	call   *%esi
801008dd:	89 c3                	mov    %eax,%ebx
801008df:	85 c0                	test   %eax,%eax
801008e1:	78 22                	js     80100905 <consoleintr+0x45>
    switch(c){
801008e3:	83 fb 15             	cmp    $0x15,%ebx
801008e6:	74 40                	je     80100928 <consoleintr+0x68>
801008e8:	7f 76                	jg     80100960 <consoleintr+0xa0>
801008ea:	83 fb 08             	cmp    $0x8,%ebx
801008ed:	74 76                	je     80100965 <consoleintr+0xa5>
801008ef:	83 fb 10             	cmp    $0x10,%ebx
801008f2:	0f 85 32 01 00 00    	jne    80100a2a <consoleintr+0x16a>
  while((c = getc()) >= 0){
801008f8:	ff d6                	call   *%esi
    switch(c){
801008fa:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008ff:	89 c3                	mov    %eax,%ebx
80100901:	85 c0                	test   %eax,%eax
80100903:	79 de                	jns    801008e3 <consoleintr+0x23>
  release(&cons.lock);
80100905:	83 ec 0c             	sub    $0xc,%esp
80100908:	68 20 ef 10 80       	push   $0x8010ef20
8010090d:	e8 fe 3e 00 00       	call   80104810 <release>
  if(doprocdump) {
80100912:	83 c4 10             	add    $0x10,%esp
80100915:	85 ff                	test   %edi,%edi
80100917:	0f 85 71 01 00 00    	jne    80100a8e <consoleintr+0x1ce>
}
8010091d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100920:	5b                   	pop    %ebx
80100921:	5e                   	pop    %esi
80100922:	5f                   	pop    %edi
80100923:	5d                   	pop    %ebp
80100924:	c3                   	ret
80100925:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100928:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010092d:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
80100933:	74 a6                	je     801008db <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100935:	83 e8 01             	sub    $0x1,%eax
80100938:	89 c2                	mov    %eax,%edx
8010093a:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010093d:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
80100944:	74 95                	je     801008db <consoleintr+0x1b>
  if(panicked){
80100946:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
8010094c:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 3b                	je     80100990 <consoleintr+0xd0>
80100955:	fa                   	cli
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0x96>
80100958:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010095f:	00 
    switch(c){
80100960:	83 fb 7f             	cmp    $0x7f,%ebx
80100963:	75 4b                	jne    801009b0 <consoleintr+0xf0>
      if(input.e != input.w){
80100965:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010096a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100970:	0f 84 65 ff ff ff    	je     801008db <consoleintr+0x1b>
        input.e--;
80100976:	83 e8 01             	sub    $0x1,%eax
80100979:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010097e:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100983:	85 c0                	test   %eax,%eax
80100985:	0f 84 f4 00 00 00    	je     80100a7f <consoleintr+0x1bf>
8010098b:	fa                   	cli
    for(;;)
8010098c:	eb fe                	jmp    8010098c <consoleintr+0xcc>
8010098e:	66 90                	xchg   %ax,%ax
80100990:	b8 00 01 00 00       	mov    $0x100,%eax
80100995:	e8 86 fa ff ff       	call   80100420 <consputc.part.0>
      while(input.e != input.w &&
8010099a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010099f:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801009a5:	75 8e                	jne    80100935 <consoleintr+0x75>
801009a7:	e9 2f ff ff ff       	jmp    801008db <consoleintr+0x1b>
801009ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009b0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009b5:	89 c2                	mov    %eax,%edx
801009b7:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801009bd:	83 fa 7f             	cmp    $0x7f,%edx
801009c0:	0f 87 15 ff ff ff    	ja     801008db <consoleintr+0x1b>
  if(panicked){
801009c6:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009cc:	8d 50 01             	lea    0x1(%eax),%edx
801009cf:	83 e0 7f             	and    $0x7f,%eax
801009d2:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
801009d8:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
801009de:	85 c9                	test   %ecx,%ecx
801009e0:	0f 85 b4 00 00 00    	jne    80100a9a <consoleintr+0x1da>
801009e6:	89 d8                	mov    %ebx,%eax
801009e8:	e8 33 fa ff ff       	call   80100420 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ed:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009f2:	83 fb 0a             	cmp    $0xa,%ebx
801009f5:	74 19                	je     80100a10 <consoleintr+0x150>
801009f7:	83 fb 04             	cmp    $0x4,%ebx
801009fa:	74 14                	je     80100a10 <consoleintr+0x150>
801009fc:	8b 0d 00 ef 10 80    	mov    0x8010ef00,%ecx
80100a02:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
80100a08:	39 c2                	cmp    %eax,%edx
80100a0a:	0f 85 cb fe ff ff    	jne    801008db <consoleintr+0x1b>
          wakeup(&input.r);
80100a10:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a13:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a18:	68 00 ef 10 80       	push   $0x8010ef00
80100a1d:	e8 fe 37 00 00       	call   80104220 <wakeup>
80100a22:	83 c4 10             	add    $0x10,%esp
80100a25:	e9 b1 fe ff ff       	jmp    801008db <consoleintr+0x1b>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a2a:	85 db                	test   %ebx,%ebx
80100a2c:	0f 84 a9 fe ff ff    	je     801008db <consoleintr+0x1b>
80100a32:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a37:	89 c2                	mov    %eax,%edx
80100a39:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100a3f:	83 fa 7f             	cmp    $0x7f,%edx
80100a42:	0f 87 93 fe ff ff    	ja     801008db <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a48:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100a4b:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a51:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a54:	83 fb 0d             	cmp    $0xd,%ebx
80100a57:	0f 85 75 ff ff ff    	jne    801009d2 <consoleintr+0x112>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a5d:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a63:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a6a:	85 c9                	test   %ecx,%ecx
80100a6c:	75 2c                	jne    80100a9a <consoleintr+0x1da>
80100a6e:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a73:	e8 a8 f9 ff ff       	call   80100420 <consputc.part.0>
          input.w = input.e;
80100a78:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100a7d:	eb 91                	jmp    80100a10 <consoleintr+0x150>
80100a7f:	b8 00 01 00 00       	mov    $0x100,%eax
80100a84:	e8 97 f9 ff ff       	call   80100420 <consputc.part.0>
80100a89:	e9 4d fe ff ff       	jmp    801008db <consoleintr+0x1b>
}
80100a8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a91:	5b                   	pop    %ebx
80100a92:	5e                   	pop    %esi
80100a93:	5f                   	pop    %edi
80100a94:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a95:	e9 66 38 00 00       	jmp    80104300 <procdump>
80100a9a:	fa                   	cli
    for(;;)
80100a9b:	eb fe                	jmp    80100a9b <consoleintr+0x1db>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi

80100aa0 <consoleinit>:

void
consoleinit(void)
{
80100aa0:	55                   	push   %ebp
80100aa1:	89 e5                	mov    %esp,%ebp
80100aa3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100aa6:	68 a8 75 10 80       	push   $0x801075a8
80100aab:	68 20 ef 10 80       	push   $0x8010ef20
80100ab0:	e8 ab 3b 00 00       	call   80104660 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ab5:	58                   	pop    %eax
80100ab6:	5a                   	pop    %edx
80100ab7:	6a 00                	push   $0x0
80100ab9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100abb:	c7 05 0c f9 10 80 d0 	movl   $0x801005d0,0x8010f90c
80100ac2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ac5:	c7 05 08 f9 10 80 a0 	movl   $0x801002a0,0x8010f908
80100acc:	02 10 80 
  cons.locking = 1;
80100acf:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100ad6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100ad9:	e8 22 1a 00 00       	call   80102500 <ioapicenable>
}
80100ade:	83 c4 10             	add    $0x10,%esp
80100ae1:	c9                   	leave
80100ae2:	c3                   	ret
80100ae3:	66 90                	xchg   %ax,%ax
80100ae5:	66 90                	xchg   %ax,%ax
80100ae7:	66 90                	xchg   %ax,%ax
80100ae9:	66 90                	xchg   %ax,%ax
80100aeb:	66 90                	xchg   %ax,%ax
80100aed:	66 90                	xchg   %ax,%ax
80100aef:	90                   	nop

80100af0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100af0:	55                   	push   %ebp
80100af1:	89 e5                	mov    %esp,%ebp
80100af3:	57                   	push   %edi
80100af4:	56                   	push   %esi
80100af5:	53                   	push   %ebx
80100af6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100afc:	e8 7f 2f 00 00       	call   80103a80 <myproc>
80100b01:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b07:	e8 34 23 00 00       	call   80102e40 <begin_op>

  if((ip = namei(path)) == 0){
80100b0c:	83 ec 0c             	sub    $0xc,%esp
80100b0f:	ff 75 08             	push   0x8(%ebp)
80100b12:	e8 e9 15 00 00       	call   80102100 <namei>
80100b17:	83 c4 10             	add    $0x10,%esp
80100b1a:	85 c0                	test   %eax,%eax
80100b1c:	0f 84 30 03 00 00    	je     80100e52 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b22:	83 ec 0c             	sub    $0xc,%esp
80100b25:	89 c7                	mov    %eax,%edi
80100b27:	50                   	push   %eax
80100b28:	e8 c3 0c 00 00       	call   801017f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b33:	6a 34                	push   $0x34
80100b35:	6a 00                	push   $0x0
80100b37:	50                   	push   %eax
80100b38:	57                   	push   %edi
80100b39:	e8 c2 0f 00 00       	call   80101b00 <readi>
80100b3e:	83 c4 20             	add    $0x20,%esp
80100b41:	83 f8 34             	cmp    $0x34,%eax
80100b44:	0f 85 01 01 00 00    	jne    80100c4b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b4a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b51:	45 4c 46 
80100b54:	0f 85 f1 00 00 00    	jne    80100c4b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b5a:	e8 a1 66 00 00       	call   80107200 <setupkvm>
80100b5f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b65:	85 c0                	test   %eax,%eax
80100b67:	0f 84 de 00 00 00    	je     80100c4b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b6d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b74:	00 
80100b75:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b7b:	0f 84 a1 02 00 00    	je     80100e22 <exec+0x332>
  sz = 0;
80100b81:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b88:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b8b:	31 db                	xor    %ebx,%ebx
80100b8d:	e9 8c 00 00 00       	jmp    80100c1e <exec+0x12e>
80100b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b98:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b9f:	75 6c                	jne    80100c0d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100ba1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ba7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bad:	0f 82 87 00 00 00    	jb     80100c3a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bb3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bb9:	72 7f                	jb     80100c3a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bbb:	83 ec 04             	sub    $0x4,%esp
80100bbe:	50                   	push   %eax
80100bbf:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bc5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bcb:	e8 60 64 00 00       	call   80107030 <allocuvm>
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bd9:	85 c0                	test   %eax,%eax
80100bdb:	74 5d                	je     80100c3a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bdd:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100be3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100be8:	75 50                	jne    80100c3a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bea:	83 ec 0c             	sub    $0xc,%esp
80100bed:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bf3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bf9:	57                   	push   %edi
80100bfa:	50                   	push   %eax
80100bfb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c01:	e8 5a 63 00 00       	call   80106f60 <loaduvm>
80100c06:	83 c4 20             	add    $0x20,%esp
80100c09:	85 c0                	test   %eax,%eax
80100c0b:	78 2d                	js     80100c3a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c0d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c14:	83 c3 01             	add    $0x1,%ebx
80100c17:	83 c6 20             	add    $0x20,%esi
80100c1a:	39 d8                	cmp    %ebx,%eax
80100c1c:	7e 52                	jle    80100c70 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c1e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c24:	6a 20                	push   $0x20
80100c26:	56                   	push   %esi
80100c27:	50                   	push   %eax
80100c28:	57                   	push   %edi
80100c29:	e8 d2 0e 00 00       	call   80101b00 <readi>
80100c2e:	83 c4 10             	add    $0x10,%esp
80100c31:	83 f8 20             	cmp    $0x20,%eax
80100c34:	0f 84 5e ff ff ff    	je     80100b98 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c3a:	83 ec 0c             	sub    $0xc,%esp
80100c3d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c43:	e8 38 65 00 00       	call   80107180 <freevm>
  if(ip){
80100c48:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c4b:	83 ec 0c             	sub    $0xc,%esp
80100c4e:	57                   	push   %edi
80100c4f:	e8 2c 0e 00 00       	call   80101a80 <iunlockput>
    end_op();
80100c54:	e8 57 22 00 00       	call   80102eb0 <end_op>
80100c59:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c64:	5b                   	pop    %ebx
80100c65:	5e                   	pop    %esi
80100c66:	5f                   	pop    %edi
80100c67:	5d                   	pop    %ebp
80100c68:	c3                   	ret
80100c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c70:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c76:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c7c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c82:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c88:	83 ec 0c             	sub    $0xc,%esp
80100c8b:	57                   	push   %edi
80100c8c:	e8 ef 0d 00 00       	call   80101a80 <iunlockput>
  end_op();
80100c91:	e8 1a 22 00 00       	call   80102eb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c96:	83 c4 0c             	add    $0xc,%esp
80100c99:	53                   	push   %ebx
80100c9a:	56                   	push   %esi
80100c9b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100ca1:	56                   	push   %esi
80100ca2:	e8 89 63 00 00       	call   80107030 <allocuvm>
80100ca7:	83 c4 10             	add    $0x10,%esp
80100caa:	89 c7                	mov    %eax,%edi
80100cac:	85 c0                	test   %eax,%eax
80100cae:	0f 84 86 00 00 00    	je     80100d3a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb4:	83 ec 08             	sub    $0x8,%esp
80100cb7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100cbd:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cbf:	50                   	push   %eax
80100cc0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cc1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc3:	e8 d8 65 00 00       	call   801072a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ccb:	83 c4 10             	add    $0x10,%esp
80100cce:	8b 10                	mov    (%eax),%edx
80100cd0:	85 d2                	test   %edx,%edx
80100cd2:	0f 84 56 01 00 00    	je     80100e2e <exec+0x33e>
80100cd8:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100cde:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ce1:	eb 23                	jmp    80100d06 <exec+0x216>
80100ce3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ce8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100ceb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cf2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cf8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cfb:	85 d2                	test   %edx,%edx
80100cfd:	74 51                	je     80100d50 <exec+0x260>
    if(argc >= MAXARG)
80100cff:	83 f8 20             	cmp    $0x20,%eax
80100d02:	74 36                	je     80100d3a <exec+0x24a>
80100d04:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d06:	83 ec 0c             	sub    $0xc,%esp
80100d09:	52                   	push   %edx
80100d0a:	e8 91 3e 00 00       	call   80104ba0 <strlen>
80100d0f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d11:	58                   	pop    %eax
80100d12:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d15:	83 eb 01             	sub    $0x1,%ebx
80100d18:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d1b:	e8 80 3e 00 00       	call   80104ba0 <strlen>
80100d20:	83 c0 01             	add    $0x1,%eax
80100d23:	50                   	push   %eax
80100d24:	ff 34 b7             	push   (%edi,%esi,4)
80100d27:	53                   	push   %ebx
80100d28:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d2e:	e8 2d 67 00 00       	call   80107460 <copyout>
80100d33:	83 c4 20             	add    $0x20,%esp
80100d36:	85 c0                	test   %eax,%eax
80100d38:	79 ae                	jns    80100ce8 <exec+0x1f8>
    freevm(pgdir);
80100d3a:	83 ec 0c             	sub    $0xc,%esp
80100d3d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d43:	e8 38 64 00 00       	call   80107180 <freevm>
80100d48:	83 c4 10             	add    $0x10,%esp
80100d4b:	e9 0c ff ff ff       	jmp    80100c5c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d50:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d57:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d5d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d63:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d66:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d69:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d70:	00 00 00 00 
  ustack[1] = argc;
80100d74:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d7a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d81:	ff ff ff 
  ustack[1] = argc;
80100d84:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d8a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d8c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d8e:	29 d0                	sub    %edx,%eax
80100d90:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d96:	56                   	push   %esi
80100d97:	51                   	push   %ecx
80100d98:	53                   	push   %ebx
80100d99:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d9f:	e8 bc 66 00 00       	call   80107460 <copyout>
80100da4:	83 c4 10             	add    $0x10,%esp
80100da7:	85 c0                	test   %eax,%eax
80100da9:	78 8f                	js     80100d3a <exec+0x24a>
  for(last=s=path; *s; s++)
80100dab:	8b 45 08             	mov    0x8(%ebp),%eax
80100dae:	8b 55 08             	mov    0x8(%ebp),%edx
80100db1:	0f b6 00             	movzbl (%eax),%eax
80100db4:	84 c0                	test   %al,%al
80100db6:	74 17                	je     80100dcf <exec+0x2df>
80100db8:	89 d1                	mov    %edx,%ecx
80100dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100dc0:	83 c1 01             	add    $0x1,%ecx
80100dc3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100dc5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100dc8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dcb:	84 c0                	test   %al,%al
80100dcd:	75 f1                	jne    80100dc0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dcf:	83 ec 04             	sub    $0x4,%esp
80100dd2:	6a 10                	push   $0x10
80100dd4:	52                   	push   %edx
80100dd5:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100ddb:	8d 46 6c             	lea    0x6c(%esi),%eax
80100dde:	50                   	push   %eax
80100ddf:	e8 7c 3d 00 00       	call   80104b60 <safestrcpy>
  curproc->pgdir = pgdir;
80100de4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dea:	89 f0                	mov    %esi,%eax
80100dec:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100def:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100df1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100df4:	89 c1                	mov    %eax,%ecx
80100df6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dfc:	8b 40 18             	mov    0x18(%eax),%eax
80100dff:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e02:	8b 41 18             	mov    0x18(%ecx),%eax
80100e05:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e08:	89 0c 24             	mov    %ecx,(%esp)
80100e0b:	e8 c0 5f 00 00       	call   80106dd0 <switchuvm>
  freevm(oldpgdir);
80100e10:	89 34 24             	mov    %esi,(%esp)
80100e13:	e8 68 63 00 00       	call   80107180 <freevm>
  return 0;
80100e18:	83 c4 10             	add    $0x10,%esp
80100e1b:	31 c0                	xor    %eax,%eax
80100e1d:	e9 3f fe ff ff       	jmp    80100c61 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e22:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e27:	31 f6                	xor    %esi,%esi
80100e29:	e9 5a fe ff ff       	jmp    80100c88 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e2e:	be 10 00 00 00       	mov    $0x10,%esi
80100e33:	ba 04 00 00 00       	mov    $0x4,%edx
80100e38:	b8 03 00 00 00       	mov    $0x3,%eax
80100e3d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e44:	00 00 00 
80100e47:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e4d:	e9 17 ff ff ff       	jmp    80100d69 <exec+0x279>
    end_op();
80100e52:	e8 59 20 00 00       	call   80102eb0 <end_op>
    cprintf("exec: fail\n");
80100e57:	83 ec 0c             	sub    $0xc,%esp
80100e5a:	68 b0 75 10 80       	push   $0x801075b0
80100e5f:	e8 6c f8 ff ff       	call   801006d0 <cprintf>
    return -1;
80100e64:	83 c4 10             	add    $0x10,%esp
80100e67:	e9 f0 fd ff ff       	jmp    80100c5c <exec+0x16c>
80100e6c:	66 90                	xchg   %ax,%ax
80100e6e:	66 90                	xchg   %ax,%ax
80100e70:	66 90                	xchg   %ax,%ax
80100e72:	66 90                	xchg   %ax,%ax
80100e74:	66 90                	xchg   %ax,%ax
80100e76:	66 90                	xchg   %ax,%ax
80100e78:	66 90                	xchg   %ax,%ax
80100e7a:	66 90                	xchg   %ax,%ax
80100e7c:	66 90                	xchg   %ax,%ax
80100e7e:	66 90                	xchg   %ax,%ax

80100e80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e86:	68 bc 75 10 80       	push   $0x801075bc
80100e8b:	68 60 ef 10 80       	push   $0x8010ef60
80100e90:	e8 cb 37 00 00       	call   80104660 <initlock>
}
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	c9                   	leave
80100e99:	c3                   	ret
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ea0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea4:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100ea9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100eac:	68 60 ef 10 80       	push   $0x8010ef60
80100eb1:	e8 ba 39 00 00       	call   80104870 <acquire>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb 10                	jmp    80100ecb <filealloc+0x2b>
80100ebb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec0:	83 c3 18             	add    $0x18,%ebx
80100ec3:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100ec9:	74 25                	je     80100ef0 <filealloc+0x50>
    if(f->ref == 0){
80100ecb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ece:	85 c0                	test   %eax,%eax
80100ed0:	75 ee                	jne    80100ec0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ed2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ed5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100edc:	68 60 ef 10 80       	push   $0x8010ef60
80100ee1:	e8 2a 39 00 00       	call   80104810 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ee6:	89 d8                	mov    %ebx,%eax
      return f;
80100ee8:	83 c4 10             	add    $0x10,%esp
}
80100eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eee:	c9                   	leave
80100eef:	c3                   	ret
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ef3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ef5:	68 60 ef 10 80       	push   $0x8010ef60
80100efa:	e8 11 39 00 00       	call   80104810 <release>
}
80100eff:	89 d8                	mov    %ebx,%eax
  return 0;
80100f01:	83 c4 10             	add    $0x10,%esp
}
80100f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f07:	c9                   	leave
80100f08:	c3                   	ret
80100f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 10             	sub    $0x10,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f1a:	68 60 ef 10 80       	push   $0x8010ef60
80100f1f:	e8 4c 39 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
80100f24:	8b 43 04             	mov    0x4(%ebx),%eax
80100f27:	83 c4 10             	add    $0x10,%esp
80100f2a:	85 c0                	test   %eax,%eax
80100f2c:	7e 1a                	jle    80100f48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f31:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f37:	68 60 ef 10 80       	push   $0x8010ef60
80100f3c:	e8 cf 38 00 00       	call   80104810 <release>
  return f;
}
80100f41:	89 d8                	mov    %ebx,%eax
80100f43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f46:	c9                   	leave
80100f47:	c3                   	ret
    panic("filedup");
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	68 c3 75 10 80       	push   $0x801075c3
80100f50:	e8 4b f4 ff ff       	call   801003a0 <panic>
80100f55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f5c:	00 
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi

80100f60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 28             	sub    $0x28,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f6c:	68 60 ef 10 80       	push   $0x8010ef60
80100f71:	e8 fa 38 00 00       	call   80104870 <acquire>
  if(f->ref < 1)
80100f76:	8b 53 04             	mov    0x4(%ebx),%edx
80100f79:	83 c4 10             	add    $0x10,%esp
80100f7c:	85 d2                	test   %edx,%edx
80100f7e:	0f 8e a5 00 00 00    	jle    80101029 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f84:	83 ea 01             	sub    $0x1,%edx
80100f87:	89 53 04             	mov    %edx,0x4(%ebx)
80100f8a:	75 44                	jne    80100fd0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f8c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f90:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f93:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f95:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f9b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f9e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fa1:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fa7:	68 60 ef 10 80       	push   $0x8010ef60
80100fac:	e8 5f 38 00 00       	call   80104810 <release>

  if(ff.type == FD_PIPE)
80100fb1:	83 c4 10             	add    $0x10,%esp
80100fb4:	83 ff 01             	cmp    $0x1,%edi
80100fb7:	74 57                	je     80101010 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fb9:	83 ff 02             	cmp    $0x2,%edi
80100fbc:	74 2a                	je     80100fe8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc1:	5b                   	pop    %ebx
80100fc2:	5e                   	pop    %esi
80100fc3:	5f                   	pop    %edi
80100fc4:	5d                   	pop    %ebp
80100fc5:	c3                   	ret
80100fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fcd:	00 
80100fce:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100fd0:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fda:	5b                   	pop    %ebx
80100fdb:	5e                   	pop    %esi
80100fdc:	5f                   	pop    %edi
80100fdd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fde:	e9 2d 38 00 00       	jmp    80104810 <release>
80100fe3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100fe8:	e8 53 1e 00 00       	call   80102e40 <begin_op>
    iput(ff.ip);
80100fed:	83 ec 0c             	sub    $0xc,%esp
80100ff0:	ff 75 e0             	push   -0x20(%ebp)
80100ff3:	e8 28 09 00 00       	call   80101920 <iput>
    end_op();
80100ff8:	83 c4 10             	add    $0x10,%esp
}
80100ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffe:	5b                   	pop    %ebx
80100fff:	5e                   	pop    %esi
80101000:	5f                   	pop    %edi
80101001:	5d                   	pop    %ebp
    end_op();
80101002:	e9 a9 1e 00 00       	jmp    80102eb0 <end_op>
80101007:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010100e:	00 
8010100f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101010:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101014:	83 ec 08             	sub    $0x8,%esp
80101017:	53                   	push   %ebx
80101018:	56                   	push   %esi
80101019:	e8 d2 25 00 00       	call   801035f0 <pipeclose>
8010101e:	83 c4 10             	add    $0x10,%esp
}
80101021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101024:	5b                   	pop    %ebx
80101025:	5e                   	pop    %esi
80101026:	5f                   	pop    %edi
80101027:	5d                   	pop    %ebp
80101028:	c3                   	ret
    panic("fileclose");
80101029:	83 ec 0c             	sub    $0xc,%esp
8010102c:	68 cb 75 10 80       	push   $0x801075cb
80101031:	e8 6a f3 ff ff       	call   801003a0 <panic>
80101036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010103d:	00 
8010103e:	66 90                	xchg   %ax,%ax

80101040 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	53                   	push   %ebx
80101044:	83 ec 04             	sub    $0x4,%esp
80101047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010104a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010104d:	75 31                	jne    80101080 <filestat+0x40>
    ilock(f->ip);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	ff 73 10             	push   0x10(%ebx)
80101055:	e8 96 07 00 00       	call   801017f0 <ilock>
    stati(f->ip, st);
8010105a:	58                   	pop    %eax
8010105b:	5a                   	pop    %edx
8010105c:	ff 75 0c             	push   0xc(%ebp)
8010105f:	ff 73 10             	push   0x10(%ebx)
80101062:	e8 69 0a 00 00       	call   80101ad0 <stati>
    iunlock(f->ip);
80101067:	59                   	pop    %ecx
80101068:	ff 73 10             	push   0x10(%ebx)
8010106b:	e8 60 08 00 00       	call   801018d0 <iunlock>
    return 0;
  }
  return -1;
}
80101070:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101073:	83 c4 10             	add    $0x10,%esp
80101076:	31 c0                	xor    %eax,%eax
}
80101078:	c9                   	leave
80101079:	c3                   	ret
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101080:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101088:	c9                   	leave
80101089:	c3                   	ret
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101090 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 0c             	sub    $0xc,%esp
80101099:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010109c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010109f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010a2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010a6:	74 60                	je     80101108 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010a8:	8b 03                	mov    (%ebx),%eax
801010aa:	83 f8 01             	cmp    $0x1,%eax
801010ad:	74 41                	je     801010f0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010af:	83 f8 02             	cmp    $0x2,%eax
801010b2:	75 5b                	jne    8010110f <fileread+0x7f>
    ilock(f->ip);
801010b4:	83 ec 0c             	sub    $0xc,%esp
801010b7:	ff 73 10             	push   0x10(%ebx)
801010ba:	e8 31 07 00 00       	call   801017f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010bf:	57                   	push   %edi
801010c0:	ff 73 14             	push   0x14(%ebx)
801010c3:	56                   	push   %esi
801010c4:	ff 73 10             	push   0x10(%ebx)
801010c7:	e8 34 0a 00 00       	call   80101b00 <readi>
801010cc:	83 c4 20             	add    $0x20,%esp
801010cf:	89 c6                	mov    %eax,%esi
801010d1:	85 c0                	test   %eax,%eax
801010d3:	7e 03                	jle    801010d8 <fileread+0x48>
      f->off += r;
801010d5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010d8:	83 ec 0c             	sub    $0xc,%esp
801010db:	ff 73 10             	push   0x10(%ebx)
801010de:	e8 ed 07 00 00       	call   801018d0 <iunlock>
    return r;
801010e3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	89 f0                	mov    %esi,%eax
801010eb:	5b                   	pop    %ebx
801010ec:	5e                   	pop    %esi
801010ed:	5f                   	pop    %edi
801010ee:	5d                   	pop    %ebp
801010ef:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010f0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010f3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010f9:	5b                   	pop    %ebx
801010fa:	5e                   	pop    %esi
801010fb:	5f                   	pop    %edi
801010fc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010fd:	e9 ae 26 00 00       	jmp    801037b0 <piperead>
80101102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101108:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010110d:	eb d7                	jmp    801010e6 <fileread+0x56>
  panic("fileread");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 d5 75 10 80       	push   $0x801075d5
80101117:	e8 84 f2 ff ff       	call   801003a0 <panic>
8010111c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101120 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	57                   	push   %edi
80101124:	56                   	push   %esi
80101125:	53                   	push   %ebx
80101126:	83 ec 1c             	sub    $0x1c,%esp
80101129:	8b 7d 08             	mov    0x8(%ebp),%edi
8010112c:	8b 45 10             	mov    0x10(%ebp),%eax
8010112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  int r;

  if(f->writable == 0)
80101132:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80101136:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101139:	0f 84 b6 00 00 00    	je     801011f5 <filewrite+0xd5>
    return -1;
  if(f->type == FD_PIPE)
8010113f:	8b 07                	mov    (%edi),%eax
80101141:	83 f8 01             	cmp    $0x1,%eax
80101144:	0f 84 ba 00 00 00    	je     80101204 <filewrite+0xe4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010114a:	83 f8 02             	cmp    $0x2,%eax
8010114d:	0f 85 c3 00 00 00    	jne    80101216 <filewrite+0xf6>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101156:	31 f6                	xor    %esi,%esi
    while(i < n){
80101158:	85 c0                	test   %eax,%eax
8010115a:	0f 8e 90 00 00 00    	jle    801011f0 <filewrite+0xd0>
    int i = 0;
80101160:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101163:	eb 28                	jmp    8010118d <filewrite+0x6d>
80101165:	8d 76 00             	lea    0x0(%esi),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101168:	01 47 14             	add    %eax,0x14(%edi)
      iunlock(f->ip);
8010116b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010116e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101171:	51                   	push   %ecx
80101172:	e8 59 07 00 00       	call   801018d0 <iunlock>
      end_op();
80101177:	e8 34 1d 00 00       	call   80102eb0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010117c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010117f:	83 c4 10             	add    $0x10,%esp
80101182:	39 d8                	cmp    %ebx,%eax
80101184:	75 5d                	jne    801011e3 <filewrite+0xc3>
        panic("short filewrite");
      i += r;
80101186:	01 c6                	add    %eax,%esi
    while(i < n){
80101188:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010118b:	7e 63                	jle    801011f0 <filewrite+0xd0>
      int n1 = n - i;
8010118d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
      if(n1 > max)
80101190:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101195:	29 f3                	sub    %esi,%ebx
      if(n1 > max)
80101197:	39 c3                	cmp    %eax,%ebx
80101199:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010119c:	e8 9f 1c 00 00       	call   80102e40 <begin_op>
      ilock(f->ip);
801011a1:	83 ec 0c             	sub    $0xc,%esp
801011a4:	ff 77 10             	push   0x10(%edi)
801011a7:	e8 44 06 00 00       	call   801017f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011ac:	53                   	push   %ebx
801011ad:	ff 77 14             	push   0x14(%edi)
801011b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011b3:	01 f0                	add    %esi,%eax
801011b5:	50                   	push   %eax
801011b6:	ff 77 10             	push   0x10(%edi)
801011b9:	e8 42 0a 00 00       	call   80101c00 <writei>
      iunlock(f->ip);
801011be:	8b 4f 10             	mov    0x10(%edi),%ecx
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011c1:	83 c4 20             	add    $0x20,%esp
801011c4:	85 c0                	test   %eax,%eax
801011c6:	7f a0                	jg     80101168 <filewrite+0x48>
      iunlock(f->ip);
801011c8:	83 ec 0c             	sub    $0xc,%esp
801011cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011ce:	51                   	push   %ecx
801011cf:	e8 fc 06 00 00       	call   801018d0 <iunlock>
      end_op();
801011d4:	e8 d7 1c 00 00       	call   80102eb0 <end_op>
      if(r < 0)
801011d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011dc:	83 c4 10             	add    $0x10,%esp
801011df:	85 c0                	test   %eax,%eax
801011e1:	75 0d                	jne    801011f0 <filewrite+0xd0>
        panic("short filewrite");
801011e3:	83 ec 0c             	sub    $0xc,%esp
801011e6:	68 de 75 10 80       	push   $0x801075de
801011eb:	e8 b0 f1 ff ff       	call   801003a0 <panic>
    }
    return i == n ? n : -1;
801011f0:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011f3:	74 05                	je     801011fa <filewrite+0xda>
    return -1;
801011f5:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
80101204:	8b 47 0c             	mov    0xc(%edi),%eax
80101207:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	5b                   	pop    %ebx
8010120e:	5e                   	pop    %esi
8010120f:	5f                   	pop    %edi
80101210:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101211:	e9 7a 24 00 00       	jmp    80103690 <pipewrite>
  panic("filewrite");
80101216:	83 ec 0c             	sub    $0xc,%esp
80101219:	68 e4 75 10 80       	push   $0x801075e4
8010121e:	e8 7d f1 ff ff       	call   801003a0 <panic>
80101223:	66 90                	xchg   %ax,%ax
80101225:	66 90                	xchg   %ax,%ax
80101227:	66 90                	xchg   %ax,%ax
80101229:	66 90                	xchg   %ax,%ax
8010122b:	66 90                	xchg   %ax,%ax
8010122d:	66 90                	xchg   %ax,%ax
8010122f:	90                   	nop

80101230 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
8010123f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 8c 00 00 00    	je     801012d6 <balloc+0xa6>
8010124a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010124c:	89 f8                	mov    %edi,%eax
8010124e:	83 ec 08             	sub    $0x8,%esp
80101251:	89 fe                	mov    %edi,%esi
80101253:	c1 f8 0c             	sar    $0xc,%eax
80101256:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010125c:	50                   	push   %eax
8010125d:	ff 75 dc             	push   -0x24(%ebp)
80101260:	e8 6b ee ff ff       	call   801000d0 <bread>
80101265:	83 c4 10             	add    $0x10,%esp
80101268:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010126b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010126e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101273:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101276:	31 c0                	xor    %eax,%eax
80101278:	eb 32                	jmp    801012ac <balloc+0x7c>
8010127a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 49                	je     801012e8 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 07                	je     801012b3 <balloc+0x83>
801012ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
801012af:	39 d6                	cmp    %edx,%esi
801012b1:	72 cd                	jb     80101280 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012b3:	8b 7d d8             	mov    -0x28(%ebp),%edi
801012b6:	83 ec 0c             	sub    $0xc,%esp
801012b9:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012c2:	e8 39 ef ff ff       	call   80100200 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012c7:	83 c4 10             	add    $0x10,%esp
801012ca:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
801012d0:	0f 82 76 ff ff ff    	jb     8010124c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012d6:	83 ec 0c             	sub    $0xc,%esp
801012d9:	68 ee 75 10 80       	push   $0x801075ee
801012de:	e8 bd f0 ff ff       	call   801003a0 <panic>
801012e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
801012e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012eb:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012ee:	09 da                	or     %ebx,%edx
801012f0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012f4:	57                   	push   %edi
801012f5:	e8 26 1d 00 00       	call   80103020 <log_write>
        brelse(bp);
801012fa:	89 3c 24             	mov    %edi,(%esp)
801012fd:	e8 fe ee ff ff       	call   80100200 <brelse>
  bp = bread(dev, bno);
80101302:	58                   	pop    %eax
80101303:	5a                   	pop    %edx
80101304:	56                   	push   %esi
80101305:	ff 75 dc             	push   -0x24(%ebp)
80101308:	e8 c3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010130d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101310:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101312:	8d 40 5c             	lea    0x5c(%eax),%eax
80101315:	68 00 02 00 00       	push   $0x200
8010131a:	6a 00                	push   $0x0
8010131c:	50                   	push   %eax
8010131d:	e8 7e 36 00 00       	call   801049a0 <memset>
  log_write(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 f6 1c 00 00       	call   80103020 <log_write>
  brelse(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ce ee ff ff       	call   80100200 <brelse>
}
80101332:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101335:	89 f0                	mov    %esi,%eax
80101337:	5b                   	pop    %ebx
80101338:	5e                   	pop    %esi
80101339:	5f                   	pop    %edi
8010133a:	5d                   	pop    %ebp
8010133b:	c3                   	ret
8010133c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101344:	31 ff                	xor    %edi,%edi
{
80101346:	56                   	push   %esi
80101347:	89 c6                	mov    %eax,%esi
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 60 f9 10 80       	push   $0x8010f960
8010135a:	e8 11 35 00 00       	call   80104870 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010136e:	00 
8010136f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 33                	cmp    %esi,(%ebx)
80101372:	74 74                	je     801013e8 <iget+0xa8>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010137a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101380:	74 2e                	je     801013b0 <iget+0x70>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 43 08             	mov    0x8(%ebx),%eax
80101385:	85 c0                	test   %eax,%eax
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 ff                	test   %edi,%edi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	85 c0                	test   %eax,%eax
8010138f:	75 7e                	jne    8010140f <iget+0xcf>
      empty = ip;
80101391:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101393:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101399:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010139f:	75 e1                	jne    80101382 <iget+0x42>
801013a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013a8:	00 
801013a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b0:	85 ff                	test   %edi,%edi
801013b2:	74 79                	je     8010142d <iget+0xed>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013b4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013b7:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801013b9:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801013bc:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801013c3:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013ca:	68 60 f9 10 80       	push   $0x8010f960
801013cf:	e8 3c 34 00 00       	call   80104810 <release>

  return ip;
801013d4:	83 c4 10             	add    $0x10,%esp
}
801013d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013da:	89 f8                	mov    %edi,%eax
801013dc:	5b                   	pop    %ebx
801013dd:	5e                   	pop    %esi
801013de:	5f                   	pop    %edi
801013df:	5d                   	pop    %ebp
801013e0:	c3                   	ret
801013e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e8:	39 53 04             	cmp    %edx,0x4(%ebx)
801013eb:	75 87                	jne    80101374 <iget+0x34>
      ip->ref++;
801013ed:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
801013f0:	83 ec 0c             	sub    $0xc,%esp
      return ip;
801013f3:	89 df                	mov    %ebx,%edi
      ip->ref++;
801013f5:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013f8:	68 60 f9 10 80       	push   $0x8010f960
801013fd:	e8 0e 34 00 00       	call   80104810 <release>
      return ip;
80101402:	83 c4 10             	add    $0x10,%esp
}
80101405:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101408:	89 f8                	mov    %edi,%eax
8010140a:	5b                   	pop    %ebx
8010140b:	5e                   	pop    %esi
8010140c:	5f                   	pop    %edi
8010140d:	5d                   	pop    %ebp
8010140e:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010140f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101415:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010141b:	74 10                	je     8010142d <iget+0xed>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141d:	8b 43 08             	mov    0x8(%ebx),%eax
80101420:	85 c0                	test   %eax,%eax
80101422:	0f 8f 48 ff ff ff    	jg     80101370 <iget+0x30>
80101428:	e9 60 ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010142d:	83 ec 0c             	sub    $0xc,%esp
80101430:	68 04 76 10 80       	push   $0x80107604
80101435:	e8 66 ef ff ff       	call   801003a0 <panic>
8010143a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101440 <bfree>:
{
80101440:	55                   	push   %ebp
80101441:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101443:	89 d0                	mov    %edx,%eax
80101445:	c1 e8 0c             	shr    $0xc,%eax
{
80101448:	89 e5                	mov    %esp,%ebp
8010144a:	56                   	push   %esi
8010144b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010144c:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101452:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101454:	83 ec 08             	sub    $0x8,%esp
80101457:	50                   	push   %eax
80101458:	51                   	push   %ecx
80101459:	e8 72 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010145e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101460:	c1 fb 03             	sar    $0x3,%ebx
80101463:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101466:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101468:	83 e1 07             	and    $0x7,%ecx
8010146b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101470:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101476:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101478:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010147d:	85 c1                	test   %eax,%ecx
8010147f:	74 23                	je     801014a4 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101481:	f7 d0                	not    %eax
  log_write(bp);
80101483:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101486:	21 c8                	and    %ecx,%eax
80101488:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010148c:	56                   	push   %esi
8010148d:	e8 8e 1b 00 00       	call   80103020 <log_write>
  brelse(bp);
80101492:	89 34 24             	mov    %esi,(%esp)
80101495:	e8 66 ed ff ff       	call   80100200 <brelse>
}
8010149a:	83 c4 10             	add    $0x10,%esp
8010149d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014a0:	5b                   	pop    %ebx
801014a1:	5e                   	pop    %esi
801014a2:	5d                   	pop    %ebp
801014a3:	c3                   	ret
    panic("freeing free block");
801014a4:	83 ec 0c             	sub    $0xc,%esp
801014a7:	68 14 76 10 80       	push   $0x80107614
801014ac:	e8 ef ee ff ff       	call   801003a0 <panic>
801014b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014b8:	00 
801014b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	57                   	push   %edi
801014c4:	56                   	push   %esi
801014c5:	89 c6                	mov    %eax,%esi
801014c7:	53                   	push   %ebx
801014c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014cb:	83 fa 0b             	cmp    $0xb,%edx
801014ce:	0f 86 8c 00 00 00    	jbe    80101560 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014d4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014d7:	83 fb 7f             	cmp    $0x7f,%ebx
801014da:	0f 87 a2 00 00 00    	ja     80101582 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014e0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014e6:	85 c0                	test   %eax,%eax
801014e8:	74 5e                	je     80101548 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ea:	83 ec 08             	sub    $0x8,%esp
801014ed:	50                   	push   %eax
801014ee:	ff 36                	push   (%esi)
801014f0:	e8 db eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014f5:	83 c4 10             	add    $0x10,%esp
801014f8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014fc:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014fe:	8b 3b                	mov    (%ebx),%edi
80101500:	85 ff                	test   %edi,%edi
80101502:	74 1c                	je     80101520 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101504:	83 ec 0c             	sub    $0xc,%esp
80101507:	52                   	push   %edx
80101508:	e8 f3 ec ff ff       	call   80100200 <brelse>
8010150d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101510:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101513:	89 f8                	mov    %edi,%eax
80101515:	5b                   	pop    %ebx
80101516:	5e                   	pop    %esi
80101517:	5f                   	pop    %edi
80101518:	5d                   	pop    %ebp
80101519:	c3                   	ret
8010151a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101520:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101523:	8b 06                	mov    (%esi),%eax
80101525:	e8 06 fd ff ff       	call   80101230 <balloc>
      log_write(bp);
8010152a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010152d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101530:	89 03                	mov    %eax,(%ebx)
80101532:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101534:	52                   	push   %edx
80101535:	e8 e6 1a 00 00       	call   80103020 <log_write>
8010153a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010153d:	83 c4 10             	add    $0x10,%esp
80101540:	eb c2                	jmp    80101504 <bmap+0x44>
80101542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101548:	8b 06                	mov    (%esi),%eax
8010154a:	e8 e1 fc ff ff       	call   80101230 <balloc>
8010154f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101555:	eb 93                	jmp    801014ea <bmap+0x2a>
80101557:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010155e:	00 
8010155f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101560:	8d 5a 14             	lea    0x14(%edx),%ebx
80101563:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101567:	85 ff                	test   %edi,%edi
80101569:	75 a5                	jne    80101510 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010156b:	8b 00                	mov    (%eax),%eax
8010156d:	e8 be fc ff ff       	call   80101230 <balloc>
80101572:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101576:	89 c7                	mov    %eax,%edi
}
80101578:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010157b:	5b                   	pop    %ebx
8010157c:	89 f8                	mov    %edi,%eax
8010157e:	5e                   	pop    %esi
8010157f:	5f                   	pop    %edi
80101580:	5d                   	pop    %ebp
80101581:	c3                   	ret
  panic("bmap: out of range");
80101582:	83 ec 0c             	sub    $0xc,%esp
80101585:	68 27 76 10 80       	push   $0x80107627
8010158a:	e8 11 ee ff ff       	call   801003a0 <panic>
8010158f:	90                   	nop

80101590 <readsb>:
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	6a 01                	push   $0x1
8010159d:	ff 75 08             	push   0x8(%ebp)
801015a0:	e8 2b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015a8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015aa:	8d 40 5c             	lea    0x5c(%eax),%eax
801015ad:	6a 1c                	push   $0x1c
801015af:	50                   	push   %eax
801015b0:	56                   	push   %esi
801015b1:	e8 7a 34 00 00       	call   80104a30 <memmove>
  brelse(bp);
801015b6:	83 c4 10             	add    $0x10,%esp
801015b9:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801015bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015bf:	5b                   	pop    %ebx
801015c0:	5e                   	pop    %esi
801015c1:	5d                   	pop    %ebp
  brelse(bp);
801015c2:	e9 39 ec ff ff       	jmp    80100200 <brelse>
801015c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ce:	00 
801015cf:	90                   	nop

801015d0 <iinit>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	53                   	push   %ebx
801015d4:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
801015d9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015dc:	68 3a 76 10 80       	push   $0x8010763a
801015e1:	68 60 f9 10 80       	push   $0x8010f960
801015e6:	e8 75 30 00 00       	call   80104660 <initlock>
  for(i = 0; i < NINODE; i++) {
801015eb:	83 c4 10             	add    $0x10,%esp
801015ee:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015f0:	83 ec 08             	sub    $0x8,%esp
801015f3:	68 41 76 10 80       	push   $0x80107641
801015f8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015f9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015ff:	e8 1c 2f 00 00       	call   80104520 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101604:	83 c4 10             	add    $0x10,%esp
80101607:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
8010160d:	75 e1                	jne    801015f0 <iinit+0x20>
  bp = bread(dev, 1);
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	6a 01                	push   $0x1
80101614:	ff 75 08             	push   0x8(%ebp)
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010161c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010161f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101621:	8d 40 5c             	lea    0x5c(%eax),%eax
80101624:	6a 1c                	push   $0x1c
80101626:	50                   	push   %eax
80101627:	68 b4 15 11 80       	push   $0x801115b4
8010162c:	e8 ff 33 00 00       	call   80104a30 <memmove>
  brelse(bp);
80101631:	89 1c 24             	mov    %ebx,(%esp)
80101634:	e8 c7 eb ff ff       	call   80100200 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101639:	ff 35 cc 15 11 80    	push   0x801115cc
8010163f:	ff 35 c8 15 11 80    	push   0x801115c8
80101645:	ff 35 c4 15 11 80    	push   0x801115c4
8010164b:	ff 35 c0 15 11 80    	push   0x801115c0
80101651:	ff 35 bc 15 11 80    	push   0x801115bc
80101657:	ff 35 b8 15 11 80    	push   0x801115b8
8010165d:	ff 35 b4 15 11 80    	push   0x801115b4
80101663:	68 54 7a 10 80       	push   $0x80107a54
80101668:	e8 63 f0 ff ff       	call   801006d0 <cprintf>
}
8010166d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101670:	83 c4 30             	add    $0x30,%esp
80101673:	c9                   	leave
80101674:	c3                   	ret
80101675:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010167c:	00 
8010167d:	8d 76 00             	lea    0x0(%esi),%esi

80101680 <ialloc>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	57                   	push   %edi
80101684:	56                   	push   %esi
80101685:	53                   	push   %ebx
80101686:	83 ec 1c             	sub    $0x1c,%esp
80101689:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010168c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101693:	8b 75 08             	mov    0x8(%ebp),%esi
80101696:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101699:	0f 86 91 00 00 00    	jbe    80101730 <ialloc+0xb0>
8010169f:	bf 01 00 00 00       	mov    $0x1,%edi
801016a4:	eb 21                	jmp    801016c7 <ialloc+0x47>
801016a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016ad:	00 
801016ae:	66 90                	xchg   %ax,%ax
    brelse(bp);
801016b0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016b3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016b6:	53                   	push   %ebx
801016b7:	e8 44 eb ff ff       	call   80100200 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016bc:	83 c4 10             	add    $0x10,%esp
801016bf:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
801016c5:	73 69                	jae    80101730 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016c7:	89 f8                	mov    %edi,%eax
801016c9:	83 ec 08             	sub    $0x8,%esp
801016cc:	c1 e8 03             	shr    $0x3,%eax
801016cf:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801016d5:	50                   	push   %eax
801016d6:	56                   	push   %esi
801016d7:	e8 f4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016dc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016df:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016e1:	89 f8                	mov    %edi,%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016f1:	75 bd                	jne    801016b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016f3:	83 ec 04             	sub    $0x4,%esp
801016f6:	6a 40                	push   $0x40
801016f8:	6a 00                	push   $0x0
801016fa:	51                   	push   %ecx
801016fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016fe:	e8 9d 32 00 00       	call   801049a0 <memset>
      dip->type = type;
80101703:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101707:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010170a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010170d:	89 1c 24             	mov    %ebx,(%esp)
80101710:	e8 0b 19 00 00       	call   80103020 <log_write>
      brelse(bp);
80101715:	89 1c 24             	mov    %ebx,(%esp)
80101718:	e8 e3 ea ff ff       	call   80100200 <brelse>
      return iget(dev, inum);
8010171d:	83 c4 10             	add    $0x10,%esp
}
80101720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101723:	89 fa                	mov    %edi,%edx
}
80101725:	5b                   	pop    %ebx
      return iget(dev, inum);
80101726:	89 f0                	mov    %esi,%eax
}
80101728:	5e                   	pop    %esi
80101729:	5f                   	pop    %edi
8010172a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010172b:	e9 10 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101730:	83 ec 0c             	sub    $0xc,%esp
80101733:	68 47 76 10 80       	push   $0x80107647
80101738:	e8 63 ec ff ff       	call   801003a0 <panic>
8010173d:	8d 76 00             	lea    0x0(%esi),%esi

80101740 <iupdate>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101748:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010174e:	83 ec 08             	sub    $0x8,%esp
80101751:	c1 e8 03             	shr    $0x3,%eax
80101754:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010175a:	50                   	push   %eax
8010175b:	ff 73 a4             	push   -0x5c(%ebx)
8010175e:	e8 6d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101763:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101779:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010177c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101780:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101783:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101787:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010178b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010178f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101793:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101797:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010179a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010179d:	6a 34                	push   $0x34
8010179f:	53                   	push   %ebx
801017a0:	50                   	push   %eax
801017a1:	e8 8a 32 00 00       	call   80104a30 <memmove>
  log_write(bp);
801017a6:	89 34 24             	mov    %esi,(%esp)
801017a9:	e8 72 18 00 00       	call   80103020 <log_write>
  brelse(bp);
801017ae:	83 c4 10             	add    $0x10,%esp
801017b1:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b7:	5b                   	pop    %ebx
801017b8:	5e                   	pop    %esi
801017b9:	5d                   	pop    %ebp
  brelse(bp);
801017ba:	e9 41 ea ff ff       	jmp    80100200 <brelse>
801017bf:	90                   	nop

801017c0 <idup>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	53                   	push   %ebx
801017c4:	83 ec 10             	sub    $0x10,%esp
801017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ca:	68 60 f9 10 80       	push   $0x8010f960
801017cf:	e8 9c 30 00 00       	call   80104870 <acquire>
  ip->ref++;
801017d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017d8:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801017df:	e8 2c 30 00 00       	call   80104810 <release>
}
801017e4:	89 d8                	mov    %ebx,%eax
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave
801017ea:	c3                   	ret
801017eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017f0 <ilock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	0f 84 b7 00 00 00    	je     801018b7 <ilock+0xc7>
80101800:	8b 53 08             	mov    0x8(%ebx),%edx
80101803:	85 d2                	test   %edx,%edx
80101805:	0f 8e ac 00 00 00    	jle    801018b7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010180b:	83 ec 0c             	sub    $0xc,%esp
8010180e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101811:	50                   	push   %eax
80101812:	e8 49 2d 00 00       	call   80104560 <acquiresleep>
  if(ip->valid == 0){
80101817:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010181a:	83 c4 10             	add    $0x10,%esp
8010181d:	85 c0                	test   %eax,%eax
8010181f:	74 0f                	je     80101830 <ilock+0x40>
}
80101821:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101824:	5b                   	pop    %ebx
80101825:	5e                   	pop    %esi
80101826:	5d                   	pop    %ebp
80101827:	c3                   	ret
80101828:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010182f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101830:	8b 43 04             	mov    0x4(%ebx),%eax
80101833:	83 ec 08             	sub    $0x8,%esp
80101836:	c1 e8 03             	shr    $0x3,%eax
80101839:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010183f:	50                   	push   %eax
80101840:	ff 33                	push   (%ebx)
80101842:	e8 89 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101847:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010184a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010184c:	8b 43 04             	mov    0x4(%ebx),%eax
8010184f:	83 e0 07             	and    $0x7,%eax
80101852:	c1 e0 06             	shl    $0x6,%eax
80101855:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101859:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010185c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010185f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101863:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101867:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010186b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010186f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101873:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101877:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010187b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010187e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101881:	6a 34                	push   $0x34
80101883:	50                   	push   %eax
80101884:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101887:	50                   	push   %eax
80101888:	e8 a3 31 00 00       	call   80104a30 <memmove>
    brelse(bp);
8010188d:	89 34 24             	mov    %esi,(%esp)
80101890:	e8 6b e9 ff ff       	call   80100200 <brelse>
    if(ip->type == 0)
80101895:	83 c4 10             	add    $0x10,%esp
80101898:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010189d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018a4:	0f 85 77 ff ff ff    	jne    80101821 <ilock+0x31>
      panic("ilock: no type");
801018aa:	83 ec 0c             	sub    $0xc,%esp
801018ad:	68 5f 76 10 80       	push   $0x8010765f
801018b2:	e8 e9 ea ff ff       	call   801003a0 <panic>
    panic("ilock");
801018b7:	83 ec 0c             	sub    $0xc,%esp
801018ba:	68 59 76 10 80       	push   $0x80107659
801018bf:	e8 dc ea ff ff       	call   801003a0 <panic>
801018c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018cb:	00 
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iunlock>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	56                   	push   %esi
801018d4:	53                   	push   %ebx
801018d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018d8:	85 db                	test   %ebx,%ebx
801018da:	74 28                	je     80101904 <iunlock+0x34>
801018dc:	83 ec 0c             	sub    $0xc,%esp
801018df:	8d 73 0c             	lea    0xc(%ebx),%esi
801018e2:	56                   	push   %esi
801018e3:	e8 18 2d 00 00       	call   80104600 <holdingsleep>
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 c0                	test   %eax,%eax
801018ed:	74 15                	je     80101904 <iunlock+0x34>
801018ef:	8b 43 08             	mov    0x8(%ebx),%eax
801018f2:	85 c0                	test   %eax,%eax
801018f4:	7e 0e                	jle    80101904 <iunlock+0x34>
  releasesleep(&ip->lock);
801018f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018ff:	e9 bc 2c 00 00       	jmp    801045c0 <releasesleep>
    panic("iunlock");
80101904:	83 ec 0c             	sub    $0xc,%esp
80101907:	68 6e 76 10 80       	push   $0x8010766e
8010190c:	e8 8f ea ff ff       	call   801003a0 <panic>
80101911:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101918:	00 
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101920 <iput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 28             	sub    $0x28,%esp
80101929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010192c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010192f:	57                   	push   %edi
80101930:	e8 2b 2c 00 00       	call   80104560 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101935:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101938:	83 c4 10             	add    $0x10,%esp
8010193b:	85 d2                	test   %edx,%edx
8010193d:	74 07                	je     80101946 <iput+0x26>
8010193f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101944:	74 32                	je     80101978 <iput+0x58>
  releasesleep(&ip->lock);
80101946:	83 ec 0c             	sub    $0xc,%esp
80101949:	57                   	push   %edi
8010194a:	e8 71 2c 00 00       	call   801045c0 <releasesleep>
  acquire(&icache.lock);
8010194f:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101956:	e8 15 2f 00 00       	call   80104870 <acquire>
  ip->ref--;
8010195b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010195f:	83 c4 10             	add    $0x10,%esp
80101962:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101969:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010196c:	5b                   	pop    %ebx
8010196d:	5e                   	pop    %esi
8010196e:	5f                   	pop    %edi
8010196f:	5d                   	pop    %ebp
  release(&icache.lock);
80101970:	e9 9b 2e 00 00       	jmp    80104810 <release>
80101975:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 60 f9 10 80       	push   $0x8010f960
80101980:	e8 eb 2e 00 00       	call   80104870 <acquire>
    int r = ip->ref;
80101985:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101988:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010198f:	e8 7c 2e 00 00       	call   80104810 <release>
    if(r == 1){
80101994:	83 c4 10             	add    $0x10,%esp
80101997:	83 fe 01             	cmp    $0x1,%esi
8010199a:	75 aa                	jne    80101946 <iput+0x26>
8010199c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019a5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019a8:	89 df                	mov    %ebx,%edi
801019aa:	89 cb                	mov    %ecx,%ebx
801019ac:	eb 09                	jmp    801019b7 <iput+0x97>
801019ae:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 de                	cmp    %ebx,%esi
801019b5:	74 19                	je     801019d0 <iput+0xb0>
    if(ip->addrs[i]){
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019bd:	8b 07                	mov    (%edi),%eax
801019bf:	e8 7c fa ff ff       	call   80101440 <bfree>
      ip->addrs[i] = 0;
801019c4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ca:	eb e4                	jmp    801019b0 <iput+0x90>
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019d0:	89 fb                	mov    %edi,%ebx
801019d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019d5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019db:	85 c0                	test   %eax,%eax
801019dd:	75 2d                	jne    80101a0c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019df:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019e9:	53                   	push   %ebx
801019ea:	e8 51 fd ff ff       	call   80101740 <iupdate>
      ip->type = 0;
801019ef:	31 c0                	xor    %eax,%eax
801019f1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019f5:	89 1c 24             	mov    %ebx,(%esp)
801019f8:	e8 43 fd ff ff       	call   80101740 <iupdate>
      ip->valid = 0;
801019fd:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a04:	83 c4 10             	add    $0x10,%esp
80101a07:	e9 3a ff ff ff       	jmp    80101946 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a0c:	83 ec 08             	sub    $0x8,%esp
80101a0f:	50                   	push   %eax
80101a10:	ff 33                	push   (%ebx)
80101a12:	e8 b9 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a17:	83 c4 10             	add    $0x10,%esp
80101a1a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a1d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a26:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a29:	89 cf                	mov    %ecx,%edi
80101a2b:	eb 0a                	jmp    80101a37 <iput+0x117>
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
80101a30:	83 c6 04             	add    $0x4,%esi
80101a33:	39 fe                	cmp    %edi,%esi
80101a35:	74 0f                	je     80101a46 <iput+0x126>
      if(a[j])
80101a37:	8b 16                	mov    (%esi),%edx
80101a39:	85 d2                	test   %edx,%edx
80101a3b:	74 f3                	je     80101a30 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a3d:	8b 03                	mov    (%ebx),%eax
80101a3f:	e8 fc f9 ff ff       	call   80101440 <bfree>
80101a44:	eb ea                	jmp    80101a30 <iput+0x110>
    brelse(bp);
80101a46:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a49:	83 ec 0c             	sub    $0xc,%esp
80101a4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a4f:	50                   	push   %eax
80101a50:	e8 ab e7 ff ff       	call   80100200 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a55:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a5b:	8b 03                	mov    (%ebx),%eax
80101a5d:	e8 de f9 ff ff       	call   80101440 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a62:	83 c4 10             	add    $0x10,%esp
80101a65:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a6c:	00 00 00 
80101a6f:	e9 6b ff ff ff       	jmp    801019df <iput+0xbf>
80101a74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a7b:	00 
80101a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a80 <iunlockput>:
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	56                   	push   %esi
80101a84:	53                   	push   %ebx
80101a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a88:	85 db                	test   %ebx,%ebx
80101a8a:	74 34                	je     80101ac0 <iunlockput+0x40>
80101a8c:	83 ec 0c             	sub    $0xc,%esp
80101a8f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a92:	56                   	push   %esi
80101a93:	e8 68 2b 00 00       	call   80104600 <holdingsleep>
80101a98:	83 c4 10             	add    $0x10,%esp
80101a9b:	85 c0                	test   %eax,%eax
80101a9d:	74 21                	je     80101ac0 <iunlockput+0x40>
80101a9f:	8b 43 08             	mov    0x8(%ebx),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	7e 1a                	jle    80101ac0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101aa6:	83 ec 0c             	sub    $0xc,%esp
80101aa9:	56                   	push   %esi
80101aaa:	e8 11 2b 00 00       	call   801045c0 <releasesleep>
  iput(ip);
80101aaf:	83 c4 10             	add    $0x10,%esp
80101ab2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101ab5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5d                   	pop    %ebp
  iput(ip);
80101abb:	e9 60 fe ff ff       	jmp    80101920 <iput>
    panic("iunlock");
80101ac0:	83 ec 0c             	sub    $0xc,%esp
80101ac3:	68 6e 76 10 80       	push   $0x8010766e
80101ac8:	e8 d3 e8 ff ff       	call   801003a0 <panic>
80101acd:	8d 76 00             	lea    0x0(%esi),%esi

80101ad0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ad9:	8b 0a                	mov    (%edx),%ecx
80101adb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101ade:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ae1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ae4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ae8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aeb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101af3:	8b 52 58             	mov    0x58(%edx),%edx
80101af6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101af9:	5d                   	pop    %ebp
80101afa:	c3                   	ret
80101afb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	57                   	push   %edi
80101b04:	56                   	push   %esi
80101b05:	53                   	push   %ebx
80101b06:	83 ec 1c             	sub    $0x1c,%esp
80101b09:	8b 75 08             	mov    0x8(%ebp),%esi
80101b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b12:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b1a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b20:	0f 84 aa 00 00 00    	je     80101bd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b26:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b29:	8b 56 58             	mov    0x58(%esi),%edx
80101b2c:	39 fa                	cmp    %edi,%edx
80101b2e:	0f 82 bd 00 00 00    	jb     80101bf1 <readi+0xf1>
80101b34:	89 f9                	mov    %edi,%ecx
80101b36:	31 db                	xor    %ebx,%ebx
80101b38:	01 c1                	add    %eax,%ecx
80101b3a:	0f 92 c3             	setb   %bl
80101b3d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b40:	0f 82 ab 00 00 00    	jb     80101bf1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b46:	89 d3                	mov    %edx,%ebx
80101b48:	29 fb                	sub    %edi,%ebx
80101b4a:	39 ca                	cmp    %ecx,%edx
80101b4c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	74 73                	je     80101bc6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b53:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b63:	89 fa                	mov    %edi,%edx
80101b65:	c1 ea 09             	shr    $0x9,%edx
80101b68:	89 d8                	mov    %ebx,%eax
80101b6a:	e8 51 f9 ff ff       	call   801014c0 <bmap>
80101b6f:	83 ec 08             	sub    $0x8,%esp
80101b72:	50                   	push   %eax
80101b73:	ff 33                	push   (%ebx)
80101b75:	e8 56 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b7d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b82:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b84:	89 f8                	mov    %edi,%eax
80101b86:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b8b:	29 f3                	sub    %esi,%ebx
80101b8d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b8f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b93:	39 d9                	cmp    %ebx,%ecx
80101b95:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b98:	83 c4 0c             	add    $0xc,%esp
80101b9b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b9c:	01 de                	add    %ebx,%esi
80101b9e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101ba3:	50                   	push   %eax
80101ba4:	ff 75 e0             	push   -0x20(%ebp)
80101ba7:	e8 84 2e 00 00       	call   80104a30 <memmove>
    brelse(bp);
80101bac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101baf:	89 14 24             	mov    %edx,(%esp)
80101bb2:	e8 49 e6 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bbd:	83 c4 10             	add    $0x10,%esp
80101bc0:	39 de                	cmp    %ebx,%esi
80101bc2:	72 9c                	jb     80101b60 <readi+0x60>
80101bc4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc9:	5b                   	pop    %ebx
80101bca:	5e                   	pop    %esi
80101bcb:	5f                   	pop    %edi
80101bcc:	5d                   	pop    %ebp
80101bcd:	c3                   	ret
80101bce:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bd0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bd4:	66 83 fa 09          	cmp    $0x9,%dx
80101bd8:	77 17                	ja     80101bf1 <readi+0xf1>
80101bda:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101be1:	85 d2                	test   %edx,%edx
80101be3:	74 0c                	je     80101bf1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101be5:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bef:	ff e2                	jmp    *%edx
      return -1;
80101bf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf6:	eb ce                	jmp    80101bc6 <readi+0xc6>
80101bf8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101bff:	00 

80101c00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 1c             	sub    $0x1c,%esp
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c0f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c17:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c1a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c1d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c20:	0f 84 ba 00 00 00    	je     80101ce0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c26:	39 78 58             	cmp    %edi,0x58(%eax)
80101c29:	0f 82 ea 00 00 00    	jb     80101d19 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c2f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c32:	89 f2                	mov    %esi,%edx
80101c34:	01 fa                	add    %edi,%edx
80101c36:	0f 82 dd 00 00 00    	jb     80101d19 <writei+0x119>
80101c3c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c42:	0f 87 d1 00 00 00    	ja     80101d19 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	85 f6                	test   %esi,%esi
80101c4a:	0f 84 85 00 00 00    	je     80101cd5 <writei+0xd5>
80101c50:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c57:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c60:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c63:	89 fa                	mov    %edi,%edx
80101c65:	c1 ea 09             	shr    $0x9,%edx
80101c68:	89 f0                	mov    %esi,%eax
80101c6a:	e8 51 f8 ff ff       	call   801014c0 <bmap>
80101c6f:	83 ec 08             	sub    $0x8,%esp
80101c72:	50                   	push   %eax
80101c73:	ff 36                	push   (%esi)
80101c75:	e8 56 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c7d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c80:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c85:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c87:	89 f8                	mov    %edi,%eax
80101c89:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c8e:	29 d3                	sub    %edx,%ebx
80101c90:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c92:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c96:	39 d9                	cmp    %ebx,%ecx
80101c98:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c9b:	83 c4 0c             	add    $0xc,%esp
80101c9e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c9f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101ca1:	ff 75 dc             	push   -0x24(%ebp)
80101ca4:	50                   	push   %eax
80101ca5:	e8 86 2d 00 00       	call   80104a30 <memmove>
    log_write(bp);
80101caa:	89 34 24             	mov    %esi,(%esp)
80101cad:	e8 6e 13 00 00       	call   80103020 <log_write>
    brelse(bp);
80101cb2:	89 34 24             	mov    %esi,(%esp)
80101cb5:	e8 46 e5 ff ff       	call   80100200 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cba:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cc0:	83 c4 10             	add    $0x10,%esp
80101cc3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cc6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cc9:	39 d8                	cmp    %ebx,%eax
80101ccb:	72 93                	jb     80101c60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ccd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cd0:	39 78 58             	cmp    %edi,0x58(%eax)
80101cd3:	72 33                	jb     80101d08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cdb:	5b                   	pop    %ebx
80101cdc:	5e                   	pop    %esi
80101cdd:	5f                   	pop    %edi
80101cde:	5d                   	pop    %ebp
80101cdf:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ce0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ce4:	66 83 f8 09          	cmp    $0x9,%ax
80101ce8:	77 2f                	ja     80101d19 <writei+0x119>
80101cea:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101cf1:	85 c0                	test   %eax,%eax
80101cf3:	74 24                	je     80101d19 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101cf5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cfb:	5b                   	pop    %ebx
80101cfc:	5e                   	pop    %esi
80101cfd:	5f                   	pop    %edi
80101cfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cff:	ff e0                	jmp    *%eax
80101d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d0b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d0e:	50                   	push   %eax
80101d0f:	e8 2c fa ff ff       	call   80101740 <iupdate>
80101d14:	83 c4 10             	add    $0x10,%esp
80101d17:	eb bc                	jmp    80101cd5 <writei+0xd5>
      return -1;
80101d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d1e:	eb b8                	jmp    80101cd8 <writei+0xd8>

80101d20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d26:	6a 0e                	push   $0xe
80101d28:	ff 75 0c             	push   0xc(%ebp)
80101d2b:	ff 75 08             	push   0x8(%ebp)
80101d2e:	e8 6d 2d 00 00       	call   80104aa0 <strncmp>
}
80101d33:	c9                   	leave
80101d34:	c3                   	ret
80101d35:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d3c:	00 
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi

80101d40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	83 ec 1c             	sub    $0x1c,%esp
80101d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d51:	0f 85 8d 00 00 00    	jne    80101de4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d57:	8b 53 58             	mov    0x58(%ebx),%edx
80101d5a:	31 ff                	xor    %edi,%edi
80101d5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d5f:	85 d2                	test   %edx,%edx
80101d61:	74 46                	je     80101da9 <dirlookup+0x69>
80101d63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d6a:	00 
80101d6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d70:	6a 10                	push   $0x10
80101d72:	57                   	push   %edi
80101d73:	56                   	push   %esi
80101d74:	53                   	push   %ebx
80101d75:	e8 86 fd ff ff       	call   80101b00 <readi>
80101d7a:	83 c4 10             	add    $0x10,%esp
80101d7d:	83 f8 10             	cmp    $0x10,%eax
80101d80:	75 55                	jne    80101dd7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d82:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d87:	74 18                	je     80101da1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d89:	83 ec 04             	sub    $0x4,%esp
80101d8c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d8f:	6a 0e                	push   $0xe
80101d91:	50                   	push   %eax
80101d92:	ff 75 0c             	push   0xc(%ebp)
80101d95:	e8 06 2d 00 00       	call   80104aa0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d9a:	83 c4 10             	add    $0x10,%esp
80101d9d:	85 c0                	test   %eax,%eax
80101d9f:	74 17                	je     80101db8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101da1:	83 c7 10             	add    $0x10,%edi
80101da4:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101da7:	72 c7                	jb     80101d70 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dac:	31 c0                	xor    %eax,%eax
}
80101dae:	5b                   	pop    %ebx
80101daf:	5e                   	pop    %esi
80101db0:	5f                   	pop    %edi
80101db1:	5d                   	pop    %ebp
80101db2:	c3                   	ret
80101db3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101db8:	8b 45 10             	mov    0x10(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	74 05                	je     80101dc4 <dirlookup+0x84>
        *poff = off;
80101dbf:	8b 45 10             	mov    0x10(%ebp),%eax
80101dc2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dc4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101dc8:	8b 03                	mov    (%ebx),%eax
80101dca:	e8 71 f5 ff ff       	call   80101340 <iget>
}
80101dcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd2:	5b                   	pop    %ebx
80101dd3:	5e                   	pop    %esi
80101dd4:	5f                   	pop    %edi
80101dd5:	5d                   	pop    %ebp
80101dd6:	c3                   	ret
      panic("dirlookup read");
80101dd7:	83 ec 0c             	sub    $0xc,%esp
80101dda:	68 88 76 10 80       	push   $0x80107688
80101ddf:	e8 bc e5 ff ff       	call   801003a0 <panic>
    panic("dirlookup not DIR");
80101de4:	83 ec 0c             	sub    $0xc,%esp
80101de7:	68 76 76 10 80       	push   $0x80107676
80101dec:	e8 af e5 ff ff       	call   801003a0 <panic>
80101df1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101df8:	00 
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	89 c3                	mov    %eax,%ebx
80101e08:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e0b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e0e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e14:	0f 84 be 01 00 00    	je     80101fd8 <namex+0x1d8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e1a:	e8 61 1c 00 00       	call   80103a80 <myproc>
  acquire(&icache.lock);
80101e1f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e22:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e25:	68 60 f9 10 80       	push   $0x8010f960
80101e2a:	e8 41 2a 00 00       	call   80104870 <acquire>
  ip->ref++;
80101e2f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e33:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101e3a:	e8 d1 29 00 00       	call   80104810 <release>
80101e3f:	83 c4 10             	add    $0x10,%esp
80101e42:	eb 0f                	jmp    80101e53 <namex+0x53>
80101e44:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e4b:	00 
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e53:	0f b6 03             	movzbl (%ebx),%eax
80101e56:	3c 2f                	cmp    $0x2f,%al
80101e58:	74 f6                	je     80101e50 <namex+0x50>
  if(*path == 0)
80101e5a:	84 c0                	test   %al,%al
80101e5c:	0f 84 1e 01 00 00    	je     80101f80 <namex+0x180>
  while(*path != '/' && *path != 0)
80101e62:	0f b6 03             	movzbl (%ebx),%eax
80101e65:	84 c0                	test   %al,%al
80101e67:	0f 84 28 01 00 00    	je     80101f95 <namex+0x195>
80101e6d:	89 df                	mov    %ebx,%edi
80101e6f:	3c 2f                	cmp    $0x2f,%al
80101e71:	0f 84 1e 01 00 00    	je     80101f95 <namex+0x195>
80101e77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101e7e:	00 
80101e7f:	90                   	nop
80101e80:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e84:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e87:	3c 2f                	cmp    $0x2f,%al
80101e89:	74 04                	je     80101e8f <namex+0x8f>
80101e8b:	84 c0                	test   %al,%al
80101e8d:	75 f1                	jne    80101e80 <namex+0x80>
  len = path - s;
80101e8f:	89 f8                	mov    %edi,%eax
80101e91:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e93:	83 f8 0d             	cmp    $0xd,%eax
80101e96:	0f 8e b4 00 00 00    	jle    80101f50 <namex+0x150>
    memmove(name, s, DIRSIZ);
80101e9c:	83 ec 04             	sub    $0x4,%esp
80101e9f:	6a 0e                	push   $0xe
80101ea1:	53                   	push   %ebx
80101ea2:	89 fb                	mov    %edi,%ebx
80101ea4:	ff 75 e4             	push   -0x1c(%ebp)
80101ea7:	e8 84 2b 00 00       	call   80104a30 <memmove>
80101eac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101eaf:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101eb2:	75 14                	jne    80101ec8 <namex+0xc8>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101ebf:	00 
    path++;
80101ec0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ec3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ec6:	74 f8                	je     80101ec0 <namex+0xc0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	56                   	push   %esi
80101ecc:	e8 1f f9 ff ff       	call   801017f0 <ilock>
    if(ip->type != T_DIR){
80101ed1:	83 c4 10             	add    $0x10,%esp
80101ed4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ed9:	0f 85 bf 00 00 00    	jne    80101f9e <namex+0x19e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101edf:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ee2:	85 c0                	test   %eax,%eax
80101ee4:	74 09                	je     80101eef <namex+0xef>
80101ee6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ee9:	0f 84 ff 00 00 00    	je     80101fee <namex+0x1ee>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eef:	83 ec 04             	sub    $0x4,%esp
80101ef2:	6a 00                	push   $0x0
80101ef4:	ff 75 e4             	push   -0x1c(%ebp)
80101ef7:	56                   	push   %esi
80101ef8:	e8 43 fe ff ff       	call   80101d40 <dirlookup>
80101efd:	83 c4 10             	add    $0x10,%esp
80101f00:	89 c7                	mov    %eax,%edi
80101f02:	85 c0                	test   %eax,%eax
80101f04:	0f 84 94 00 00 00    	je     80101f9e <namex+0x19e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f0a:	83 ec 0c             	sub    $0xc,%esp
80101f0d:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101f10:	51                   	push   %ecx
80101f11:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f14:	e8 e7 26 00 00       	call   80104600 <holdingsleep>
80101f19:	83 c4 10             	add    $0x10,%esp
80101f1c:	85 c0                	test   %eax,%eax
80101f1e:	0f 84 0a 01 00 00    	je     8010202e <namex+0x22e>
80101f24:	8b 56 08             	mov    0x8(%esi),%edx
80101f27:	85 d2                	test   %edx,%edx
80101f29:	0f 8e ff 00 00 00    	jle    8010202e <namex+0x22e>
  releasesleep(&ip->lock);
80101f2f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f32:	83 ec 0c             	sub    $0xc,%esp
80101f35:	51                   	push   %ecx
80101f36:	e8 85 26 00 00       	call   801045c0 <releasesleep>
  iput(ip);
80101f3b:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101f3e:	89 fe                	mov    %edi,%esi
  iput(ip);
80101f40:	e8 db f9 ff ff       	call   80101920 <iput>
80101f45:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f48:	e9 06 ff ff ff       	jmp    80101e53 <namex+0x53>
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f53:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101f56:	83 ec 04             	sub    $0x4,%esp
80101f59:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f5c:	50                   	push   %eax
80101f5d:	53                   	push   %ebx
    name[len] = 0;
80101f5e:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f60:	ff 75 e4             	push   -0x1c(%ebp)
80101f63:	e8 c8 2a 00 00       	call   80104a30 <memmove>
    name[len] = 0;
80101f68:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	c6 01 00             	movb   $0x0,(%ecx)
80101f71:	e9 39 ff ff ff       	jmp    80101eaf <namex+0xaf>
80101f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101f7d:	00 
80101f7e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f80:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f83:	85 c0                	test   %eax,%eax
80101f85:	0f 85 93 00 00 00    	jne    8010201e <namex+0x21e>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f8e:	89 f0                	mov    %esi,%eax
80101f90:	5b                   	pop    %ebx
80101f91:	5e                   	pop    %esi
80101f92:	5f                   	pop    %edi
80101f93:	5d                   	pop    %ebp
80101f94:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f95:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f98:	89 df                	mov    %ebx,%edi
80101f9a:	31 c0                	xor    %eax,%eax
80101f9c:	eb b8                	jmp    80101f56 <namex+0x156>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fa4:	53                   	push   %ebx
80101fa5:	e8 56 26 00 00       	call   80104600 <holdingsleep>
80101faa:	83 c4 10             	add    $0x10,%esp
80101fad:	85 c0                	test   %eax,%eax
80101faf:	74 7d                	je     8010202e <namex+0x22e>
80101fb1:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fb4:	85 c9                	test   %ecx,%ecx
80101fb6:	7e 76                	jle    8010202e <namex+0x22e>
  releasesleep(&ip->lock);
80101fb8:	83 ec 0c             	sub    $0xc,%esp
80101fbb:	53                   	push   %ebx
80101fbc:	e8 ff 25 00 00       	call   801045c0 <releasesleep>
  iput(ip);
80101fc1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fc4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fc6:	e8 55 f9 ff ff       	call   80101920 <iput>
      return 0;
80101fcb:	83 c4 10             	add    $0x10,%esp
}
80101fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd1:	89 f0                	mov    %esi,%eax
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101fd8:	ba 01 00 00 00       	mov    $0x1,%edx
80101fdd:	b8 01 00 00 00       	mov    $0x1,%eax
80101fe2:	e8 59 f3 ff ff       	call   80101340 <iget>
80101fe7:	89 c6                	mov    %eax,%esi
80101fe9:	e9 65 fe ff ff       	jmp    80101e53 <namex+0x53>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fee:	83 ec 0c             	sub    $0xc,%esp
80101ff1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101ff4:	53                   	push   %ebx
80101ff5:	e8 06 26 00 00       	call   80104600 <holdingsleep>
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	85 c0                	test   %eax,%eax
80101fff:	74 2d                	je     8010202e <namex+0x22e>
80102001:	8b 7e 08             	mov    0x8(%esi),%edi
80102004:	85 ff                	test   %edi,%edi
80102006:	7e 26                	jle    8010202e <namex+0x22e>
  releasesleep(&ip->lock);
80102008:	83 ec 0c             	sub    $0xc,%esp
8010200b:	53                   	push   %ebx
8010200c:	e8 af 25 00 00       	call   801045c0 <releasesleep>
}
80102011:	83 c4 10             	add    $0x10,%esp
}
80102014:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102017:	89 f0                	mov    %esi,%eax
80102019:	5b                   	pop    %ebx
8010201a:	5e                   	pop    %esi
8010201b:	5f                   	pop    %edi
8010201c:	5d                   	pop    %ebp
8010201d:	c3                   	ret
    iput(ip);
8010201e:	83 ec 0c             	sub    $0xc,%esp
80102021:	56                   	push   %esi
      return 0;
80102022:	31 f6                	xor    %esi,%esi
    iput(ip);
80102024:	e8 f7 f8 ff ff       	call   80101920 <iput>
    return 0;
80102029:	83 c4 10             	add    $0x10,%esp
8010202c:	eb a0                	jmp    80101fce <namex+0x1ce>
    panic("iunlock");
8010202e:	83 ec 0c             	sub    $0xc,%esp
80102031:	68 6e 76 10 80       	push   $0x8010766e
80102036:	e8 65 e3 ff ff       	call   801003a0 <panic>
8010203b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102040 <dirlink>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 20             	sub    $0x20,%esp
80102049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010204c:	6a 00                	push   $0x0
8010204e:	ff 75 0c             	push   0xc(%ebp)
80102051:	53                   	push   %ebx
80102052:	e8 e9 fc ff ff       	call   80101d40 <dirlookup>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	85 c0                	test   %eax,%eax
8010205c:	75 67                	jne    801020c5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010205e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102061:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102064:	85 ff                	test   %edi,%edi
80102066:	74 29                	je     80102091 <dirlink+0x51>
80102068:	31 ff                	xor    %edi,%edi
8010206a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010206d:	eb 09                	jmp    80102078 <dirlink+0x38>
8010206f:	90                   	nop
80102070:	83 c7 10             	add    $0x10,%edi
80102073:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102076:	73 19                	jae    80102091 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102078:	6a 10                	push   $0x10
8010207a:	57                   	push   %edi
8010207b:	56                   	push   %esi
8010207c:	53                   	push   %ebx
8010207d:	e8 7e fa ff ff       	call   80101b00 <readi>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	83 f8 10             	cmp    $0x10,%eax
80102088:	75 4e                	jne    801020d8 <dirlink+0x98>
    if(de.inum == 0)
8010208a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010208f:	75 df                	jne    80102070 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102091:	83 ec 04             	sub    $0x4,%esp
80102094:	8d 45 da             	lea    -0x26(%ebp),%eax
80102097:	6a 0e                	push   $0xe
80102099:	ff 75 0c             	push   0xc(%ebp)
8010209c:	50                   	push   %eax
8010209d:	e8 4e 2a 00 00       	call   80104af0 <strncpy>
  de.inum = inum;
801020a2:	8b 45 10             	mov    0x10(%ebp),%eax
801020a5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a9:	6a 10                	push   $0x10
801020ab:	57                   	push   %edi
801020ac:	56                   	push   %esi
801020ad:	53                   	push   %ebx
801020ae:	e8 4d fb ff ff       	call   80101c00 <writei>
801020b3:	83 c4 20             	add    $0x20,%esp
801020b6:	83 f8 10             	cmp    $0x10,%eax
801020b9:	75 2a                	jne    801020e5 <dirlink+0xa5>
  return 0;
801020bb:	31 c0                	xor    %eax,%eax
}
801020bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c0:	5b                   	pop    %ebx
801020c1:	5e                   	pop    %esi
801020c2:	5f                   	pop    %edi
801020c3:	5d                   	pop    %ebp
801020c4:	c3                   	ret
    iput(ip);
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	50                   	push   %eax
801020c9:	e8 52 f8 ff ff       	call   80101920 <iput>
    return -1;
801020ce:	83 c4 10             	add    $0x10,%esp
801020d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d6:	eb e5                	jmp    801020bd <dirlink+0x7d>
      panic("dirlink read");
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 97 76 10 80       	push   $0x80107697
801020e0:	e8 bb e2 ff ff       	call   801003a0 <panic>
    panic("dirlink");
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	68 f3 78 10 80       	push   $0x801078f3
801020ed:	e8 ae e2 ff ff       	call   801003a0 <panic>
801020f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020f9:	00 
801020fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102100 <namei>:

struct inode*
namei(char *path)
{
80102100:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102101:	31 d2                	xor    %edx,%edx
{
80102103:	89 e5                	mov    %esp,%ebp
80102105:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010210e:	e8 ed fc ff ff       	call   80101e00 <namex>
}
80102113:	c9                   	leave
80102114:	c3                   	ret
80102115:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010211c:	00 
8010211d:	8d 76 00             	lea    0x0(%esi),%esi

80102120 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102120:	55                   	push   %ebp
  return namex(path, 1, name);
80102121:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102126:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010212e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010212f:	e9 cc fc ff ff       	jmp    80101e00 <namex>
80102134:	66 90                	xchg   %ax,%ax
80102136:	66 90                	xchg   %ax,%ax
80102138:	66 90                	xchg   %ax,%ax
8010213a:	66 90                	xchg   %ax,%ax
8010213c:	66 90                	xchg   %ax,%ax
8010213e:	66 90                	xchg   %ax,%ax

80102140 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102149:	85 c0                	test   %eax,%eax
8010214b:	0f 84 b4 00 00 00    	je     80102205 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102151:	8b 70 08             	mov    0x8(%eax),%esi
80102154:	89 c3                	mov    %eax,%ebx
80102156:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010215c:	0f 87 96 00 00 00    	ja     801021f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102162:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102167:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010216e:	00 
8010216f:	90                   	nop
80102170:	89 ca                	mov    %ecx,%edx
80102172:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102173:	83 e0 c0             	and    $0xffffffc0,%eax
80102176:	3c 40                	cmp    $0x40,%al
80102178:	75 f6                	jne    80102170 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010217a:	31 ff                	xor    %edi,%edi
8010217c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102181:	89 f8                	mov    %edi,%eax
80102183:	ee                   	out    %al,(%dx)
80102184:	b8 01 00 00 00       	mov    $0x1,%eax
80102189:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010218e:	ee                   	out    %al,(%dx)
8010218f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102194:	89 f0                	mov    %esi,%eax
80102196:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102197:	89 f0                	mov    %esi,%eax
80102199:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010219e:	c1 f8 08             	sar    $0x8,%eax
801021a1:	ee                   	out    %al,(%dx)
801021a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021a7:	89 f8                	mov    %edi,%eax
801021a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021b3:	c1 e0 04             	shl    $0x4,%eax
801021b6:	83 e0 10             	and    $0x10,%eax
801021b9:	83 c8 e0             	or     $0xffffffe0,%eax
801021bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021bd:	f6 03 04             	testb  $0x4,(%ebx)
801021c0:	75 16                	jne    801021d8 <idestart+0x98>
801021c2:	b8 20 00 00 00       	mov    $0x20,%eax
801021c7:	89 ca                	mov    %ecx,%edx
801021c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021cd:	5b                   	pop    %ebx
801021ce:	5e                   	pop    %esi
801021cf:	5f                   	pop    %edi
801021d0:	5d                   	pop    %ebp
801021d1:	c3                   	ret
801021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021d8:	b8 30 00 00 00       	mov    $0x30,%eax
801021dd:	89 ca                	mov    %ecx,%edx
801021df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ed:	fc                   	cld
801021ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret
    panic("incorrect blockno");
801021f8:	83 ec 0c             	sub    $0xc,%esp
801021fb:	68 ad 76 10 80       	push   $0x801076ad
80102200:	e8 9b e1 ff ff       	call   801003a0 <panic>
    panic("idestart");
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	68 a4 76 10 80       	push   $0x801076a4
8010220d:	e8 8e e1 ff ff       	call   801003a0 <panic>
80102212:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102219:	00 
8010221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102220 <ideinit>:
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102226:	68 bf 76 10 80       	push   $0x801076bf
8010222b:	68 00 16 11 80       	push   $0x80111600
80102230:	e8 2b 24 00 00       	call   80104660 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102235:	58                   	pop    %eax
80102236:	a1 84 17 11 80       	mov    0x80111784,%eax
8010223b:	5a                   	pop    %edx
8010223c:	83 e8 01             	sub    $0x1,%eax
8010223f:	50                   	push   %eax
80102240:	6a 0e                	push   $0xe
80102242:	e8 b9 02 00 00       	call   80102500 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102247:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010224f:	90                   	nop
80102250:	ec                   	in     (%dx),%al
80102251:	83 e0 c0             	and    $0xffffffc0,%eax
80102254:	3c 40                	cmp    $0x40,%al
80102256:	75 f8                	jne    80102250 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102258:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010225d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102262:	ee                   	out    %al,(%dx)
80102263:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102268:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226d:	eb 06                	jmp    80102275 <ideinit+0x55>
8010226f:	90                   	nop
  for(i=0; i<1000; i++){
80102270:	83 e9 01             	sub    $0x1,%ecx
80102273:	74 0f                	je     80102284 <ideinit+0x64>
80102275:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102276:	84 c0                	test   %al,%al
80102278:	74 f6                	je     80102270 <ideinit+0x50>
      havedisk1 = 1;
8010227a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102281:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102284:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102289:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010228e:	ee                   	out    %al,(%dx)
}
8010228f:	c9                   	leave
80102290:	c3                   	ret
80102291:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102298:	00 
80102299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022a9:	68 00 16 11 80       	push   $0x80111600
801022ae:	e8 bd 25 00 00       	call   80104870 <acquire>

  if((b = idequeue) == 0){
801022b3:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	85 db                	test   %ebx,%ebx
801022be:	74 63                	je     80102323 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022c0:	8b 43 58             	mov    0x58(%ebx),%eax
801022c3:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022c8:	8b 33                	mov    (%ebx),%esi
801022ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022d0:	75 2f                	jne    80102301 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022de:	00 
801022df:	90                   	nop
801022e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e1:	89 c1                	mov    %eax,%ecx
801022e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022e6:	80 f9 40             	cmp    $0x40,%cl
801022e9:	75 f5                	jne    801022e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022eb:	a8 21                	test   $0x21,%al
801022ed:	75 12                	jne    80102301 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022fc:	fc                   	cld
801022fd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022ff:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102301:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102304:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102307:	83 ce 02             	or     $0x2,%esi
8010230a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010230c:	53                   	push   %ebx
8010230d:	e8 0e 1f 00 00       	call   80104220 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102312:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80102317:	83 c4 10             	add    $0x10,%esp
8010231a:	85 c0                	test   %eax,%eax
8010231c:	74 05                	je     80102323 <ideintr+0x83>
    idestart(idequeue);
8010231e:	e8 1d fe ff ff       	call   80102140 <idestart>
    release(&idelock);
80102323:	83 ec 0c             	sub    $0xc,%esp
80102326:	68 00 16 11 80       	push   $0x80111600
8010232b:	e8 e0 24 00 00       	call   80104810 <release>

  release(&idelock);
}
80102330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102333:	5b                   	pop    %ebx
80102334:	5e                   	pop    %esi
80102335:	5f                   	pop    %edi
80102336:	5d                   	pop    %ebp
80102337:	c3                   	ret
80102338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010233f:	00 

80102340 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 10             	sub    $0x10,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010234a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010234d:	50                   	push   %eax
8010234e:	e8 ad 22 00 00       	call   80104600 <holdingsleep>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	0f 84 c3 00 00 00    	je     80102421 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	0f 84 a8 00 00 00    	je     80102414 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010236c:	8b 53 04             	mov    0x4(%ebx),%edx
8010236f:	85 d2                	test   %edx,%edx
80102371:	74 0d                	je     80102380 <iderw+0x40>
80102373:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	0f 84 87 00 00 00    	je     80102407 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 00 16 11 80       	push   $0x80111600
80102388:	e8 e3 24 00 00       	call   80104870 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010238d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102392:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102399:	83 c4 10             	add    $0x10,%esp
8010239c:	85 c0                	test   %eax,%eax
8010239e:	74 60                	je     80102400 <iderw+0xc0>
801023a0:	89 c2                	mov    %eax,%edx
801023a2:	8b 40 58             	mov    0x58(%eax),%eax
801023a5:	85 c0                	test   %eax,%eax
801023a7:	75 f7                	jne    801023a0 <iderw+0x60>
801023a9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023ac:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023ae:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
801023b4:	74 3a                	je     801023f0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023b6:	8b 03                	mov    (%ebx),%eax
801023b8:	83 e0 06             	and    $0x6,%eax
801023bb:	83 f8 02             	cmp    $0x2,%eax
801023be:	74 1b                	je     801023db <iderw+0x9b>
    sleep(b, &idelock);
801023c0:	83 ec 08             	sub    $0x8,%esp
801023c3:	68 00 16 11 80       	push   $0x80111600
801023c8:	53                   	push   %ebx
801023c9:	e8 92 1d 00 00       	call   80104160 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ce:	8b 03                	mov    (%ebx),%eax
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	83 e0 06             	and    $0x6,%eax
801023d6:	83 f8 02             	cmp    $0x2,%eax
801023d9:	75 e5                	jne    801023c0 <iderw+0x80>
  }


  release(&idelock);
801023db:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
801023e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023e5:	c9                   	leave
  release(&idelock);
801023e6:	e9 25 24 00 00       	jmp    80104810 <release>
801023eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023f0:	89 d8                	mov    %ebx,%eax
801023f2:	e8 49 fd ff ff       	call   80102140 <idestart>
801023f7:	eb bd                	jmp    801023b6 <iderw+0x76>
801023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102400:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102405:	eb a5                	jmp    801023ac <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 ee 76 10 80       	push   $0x801076ee
8010240f:	e8 8c df ff ff       	call   801003a0 <panic>
    panic("iderw: nothing to do");
80102414:	83 ec 0c             	sub    $0xc,%esp
80102417:	68 d9 76 10 80       	push   $0x801076d9
8010241c:	e8 7f df ff ff       	call   801003a0 <panic>
    panic("iderw: buf not locked");
80102421:	83 ec 0c             	sub    $0xc,%esp
80102424:	68 c3 76 10 80       	push   $0x801076c3
80102429:	e8 72 df ff ff       	call   801003a0 <panic>
8010242e:	66 90                	xchg   %ax,%ax
80102430:	66 90                	xchg   %ax,%ax
80102432:	66 90                	xchg   %ax,%ax
80102434:	66 90                	xchg   %ax,%ax
80102436:	66 90                	xchg   %ax,%ax
80102438:	66 90                	xchg   %ax,%ax
8010243a:	66 90                	xchg   %ax,%ax
8010243c:	66 90                	xchg   %ax,%ax
8010243e:	66 90                	xchg   %ax,%ax

80102440 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102445:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
8010244c:	00 c0 fe 
  ioapic->reg = reg;
8010244f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102456:	00 00 00 
  return ioapic->data;
80102459:	8b 15 34 16 11 80    	mov    0x80111634,%edx
8010245f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102462:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102468:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010246e:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102475:	c1 ee 10             	shr    $0x10,%esi
80102478:	89 f0                	mov    %esi,%eax
8010247a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010247d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102480:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102483:	39 c2                	cmp    %eax,%edx
80102485:	74 16                	je     8010249d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 a8 7a 10 80       	push   $0x80107aa8
8010248f:	e8 3c e2 ff ff       	call   801006d0 <cprintf>
  ioapic->reg = reg;
80102494:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010249a:	83 c4 10             	add    $0x10,%esp
{
8010249d:	ba 10 00 00 00       	mov    $0x10,%edx
801024a2:	31 c0                	xor    %eax,%eax
801024a4:	eb 1a                	jmp    801024c0 <ioapicinit+0x80>
801024a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024ad:	00 
801024ae:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024b5:	00 
801024b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024bd:	00 
801024be:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801024c0:	89 13                	mov    %edx,(%ebx)
801024c2:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801024c5:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024cb:	83 c0 01             	add    $0x1,%eax
801024ce:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024d4:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024d7:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024da:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024dd:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024df:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
801024e5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024ec:	39 c6                	cmp    %eax,%esi
801024ee:	7d d0                	jge    801024c0 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f3:	5b                   	pop    %ebx
801024f4:	5e                   	pop    %esi
801024f5:	5d                   	pop    %ebp
801024f6:	c3                   	ret
801024f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024fe:	00 
801024ff:	90                   	nop

80102500 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102500:	55                   	push   %ebp
  ioapic->reg = reg;
80102501:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102507:	89 e5                	mov    %esp,%ebp
80102509:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010250c:	8d 50 20             	lea    0x20(%eax),%edx
8010250f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102513:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102515:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010251b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010251e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102521:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102524:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102526:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010252b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010252e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret
80102533:	66 90                	xchg   %ax,%ax
80102535:	66 90                	xchg   %ax,%ax
80102537:	66 90                	xchg   %ax,%ax
80102539:	66 90                	xchg   %ax,%ax
8010253b:	66 90                	xchg   %ax,%ax
8010253d:	66 90                	xchg   %ax,%ax
8010253f:	90                   	nop

80102540 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	83 ec 04             	sub    $0x4,%esp
80102547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010254a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102550:	75 76                	jne    801025c8 <kfree+0x88>
80102552:	81 fb d0 55 11 80    	cmp    $0x801155d0,%ebx
80102558:	72 6e                	jb     801025c8 <kfree+0x88>
8010255a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102560:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102565:	77 61                	ja     801025c8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102567:	83 ec 04             	sub    $0x4,%esp
8010256a:	68 00 10 00 00       	push   $0x1000
8010256f:	6a 01                	push   $0x1
80102571:	53                   	push   %ebx
80102572:	e8 29 24 00 00       	call   801049a0 <memset>

  if(kmem.use_lock)
80102577:	8b 15 74 16 11 80    	mov    0x80111674,%edx
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	85 d2                	test   %edx,%edx
80102582:	75 1c                	jne    801025a0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102584:	a1 78 16 11 80       	mov    0x80111678,%eax
80102589:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010258b:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
80102590:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80102596:	85 c0                	test   %eax,%eax
80102598:	75 1e                	jne    801025b8 <kfree+0x78>
    release(&kmem.lock);
}
8010259a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010259d:	c9                   	leave
8010259e:	c3                   	ret
8010259f:	90                   	nop
    acquire(&kmem.lock);
801025a0:	83 ec 0c             	sub    $0xc,%esp
801025a3:	68 40 16 11 80       	push   $0x80111640
801025a8:	e8 c3 22 00 00       	call   80104870 <acquire>
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	eb d2                	jmp    80102584 <kfree+0x44>
801025b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801025b8:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
801025bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c2:	c9                   	leave
    release(&kmem.lock);
801025c3:	e9 48 22 00 00       	jmp    80104810 <release>
    panic("kfree");
801025c8:	83 ec 0c             	sub    $0xc,%esp
801025cb:	68 0c 77 10 80       	push   $0x8010770c
801025d0:	e8 cb dd ff ff       	call   801003a0 <panic>
801025d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025dc:	00 
801025dd:	8d 76 00             	lea    0x0(%esi),%esi

801025e0 <freerange>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 2b                	jb     8010262c <freerange+0x4c>
80102601:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102608:	00 
80102609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102610:	83 ec 0c             	sub    $0xc,%esp
80102613:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102619:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010261f:	50                   	push   %eax
80102620:	e8 1b ff ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102625:	83 c4 10             	add    $0x10,%esp
80102628:	39 de                	cmp    %ebx,%esi
8010262a:	73 e4                	jae    80102610 <freerange+0x30>
}
8010262c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010262f:	5b                   	pop    %ebx
80102630:	5e                   	pop    %esi
80102631:	5d                   	pop    %ebp
80102632:	c3                   	ret
80102633:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010263a:	00 
8010263b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102640 <kinit2>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	56                   	push   %esi
80102644:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102645:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102648:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010264b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102651:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102657:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265d:	39 de                	cmp    %ebx,%esi
8010265f:	72 2b                	jb     8010268c <kinit2+0x4c>
80102661:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102668:	00 
80102669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102670:	83 ec 0c             	sub    $0xc,%esp
80102673:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102679:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010267f:	50                   	push   %eax
80102680:	e8 bb fe ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102685:	83 c4 10             	add    $0x10,%esp
80102688:	39 de                	cmp    %ebx,%esi
8010268a:	73 e4                	jae    80102670 <kinit2+0x30>
  kmem.use_lock = 1;
8010268c:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
80102693:	00 00 00 
}
80102696:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102699:	5b                   	pop    %ebx
8010269a:	5e                   	pop    %esi
8010269b:	5d                   	pop    %ebp
8010269c:	c3                   	ret
8010269d:	8d 76 00             	lea    0x0(%esi),%esi

801026a0 <kinit1>:
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	56                   	push   %esi
801026a4:	53                   	push   %ebx
801026a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026a8:	83 ec 08             	sub    $0x8,%esp
801026ab:	68 12 77 10 80       	push   $0x80107712
801026b0:	68 40 16 11 80       	push   $0x80111640
801026b5:	e8 a6 1f 00 00       	call   80104660 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026bd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026c0:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
801026c7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ca:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026dc:	39 de                	cmp    %ebx,%esi
801026de:	72 1c                	jb     801026fc <kinit1+0x5c>
    kfree(p);
801026e0:	83 ec 0c             	sub    $0xc,%esp
801026e3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026ef:	50                   	push   %eax
801026f0:	e8 4b fe ff ff       	call   80102540 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f5:	83 c4 10             	add    $0x10,%esp
801026f8:	39 de                	cmp    %ebx,%esi
801026fa:	73 e4                	jae    801026e0 <kinit1+0x40>
}
801026fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026ff:	5b                   	pop    %ebx
80102700:	5e                   	pop    %esi
80102701:	5d                   	pop    %ebp
80102702:	c3                   	ret
80102703:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010270a:	00 
8010270b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102710 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	53                   	push   %ebx
80102714:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102717:	a1 74 16 11 80       	mov    0x80111674,%eax
8010271c:	85 c0                	test   %eax,%eax
8010271e:	75 20                	jne    80102740 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102720:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
80102726:	85 db                	test   %ebx,%ebx
80102728:	74 07                	je     80102731 <kalloc+0x21>
    kmem.freelist = r->next;
8010272a:	8b 03                	mov    (%ebx),%eax
8010272c:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102731:	89 d8                	mov    %ebx,%eax
80102733:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102736:	c9                   	leave
80102737:	c3                   	ret
80102738:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010273f:	00 
    acquire(&kmem.lock);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	68 40 16 11 80       	push   $0x80111640
80102748:	e8 23 21 00 00       	call   80104870 <acquire>
  r = kmem.freelist;
8010274d:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
80102753:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
80102758:	83 c4 10             	add    $0x10,%esp
8010275b:	85 db                	test   %ebx,%ebx
8010275d:	74 08                	je     80102767 <kalloc+0x57>
    kmem.freelist = r->next;
8010275f:	8b 13                	mov    (%ebx),%edx
80102761:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
80102767:	85 c0                	test   %eax,%eax
80102769:	74 c6                	je     80102731 <kalloc+0x21>
    release(&kmem.lock);
8010276b:	83 ec 0c             	sub    $0xc,%esp
8010276e:	68 40 16 11 80       	push   $0x80111640
80102773:	e8 98 20 00 00       	call   80104810 <release>
}
80102778:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010277a:	83 c4 10             	add    $0x10,%esp
}
8010277d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102780:	c9                   	leave
80102781:	c3                   	ret
80102782:	66 90                	xchg   %ax,%ax
80102784:	66 90                	xchg   %ax,%ax
80102786:	66 90                	xchg   %ax,%ax
80102788:	66 90                	xchg   %ax,%ax
8010278a:	66 90                	xchg   %ax,%ax
8010278c:	66 90                	xchg   %ax,%ax
8010278e:	66 90                	xchg   %ax,%ax

80102790 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102790:	ba 64 00 00 00       	mov    $0x64,%edx
80102795:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102796:	a8 01                	test   $0x1,%al
80102798:	0f 84 c2 00 00 00    	je     80102860 <kbdgetc+0xd0>
{
8010279e:	55                   	push   %ebp
8010279f:	ba 60 00 00 00       	mov    $0x60,%edx
801027a4:	89 e5                	mov    %esp,%ebp
801027a6:	53                   	push   %ebx
801027a7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027a8:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
801027ae:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801027b1:	3c e0                	cmp    $0xe0,%al
801027b3:	74 5b                	je     80102810 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801027b5:	89 da                	mov    %ebx,%edx
801027b7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801027ba:	84 c0                	test   %al,%al
801027bc:	78 62                	js     80102820 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027be:	85 d2                	test   %edx,%edx
801027c0:	74 09                	je     801027cb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027c2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027c5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027c8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801027cb:	0f b6 91 00 7d 10 80 	movzbl -0x7fef8300(%ecx),%edx
  shift ^= togglecode[data];
801027d2:	0f b6 81 00 7c 10 80 	movzbl -0x7fef8400(%ecx),%eax
  shift |= shiftcode[data];
801027d9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027db:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027dd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027df:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
801027e5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027e8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027eb:	8b 04 85 e0 7b 10 80 	mov    -0x7fef8420(,%eax,4),%eax
801027f2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027f6:	74 0b                	je     80102803 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027f8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027fb:	83 fa 19             	cmp    $0x19,%edx
801027fe:	77 48                	ja     80102848 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102800:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102803:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102806:	c9                   	leave
80102807:	c3                   	ret
80102808:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010280f:	00 
    shift |= E0ESC;
80102810:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102813:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102815:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010281b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010281e:	c9                   	leave
8010281f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102820:	83 e0 7f             	and    $0x7f,%eax
80102823:	85 d2                	test   %edx,%edx
80102825:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102828:	0f b6 81 00 7d 10 80 	movzbl -0x7fef8300(%ecx),%eax
8010282f:	83 c8 40             	or     $0x40,%eax
80102832:	0f b6 c0             	movzbl %al,%eax
80102835:	f7 d0                	not    %eax
80102837:	21 d8                	and    %ebx,%eax
80102839:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
8010283e:	31 c0                	xor    %eax,%eax
80102840:	eb d9                	jmp    8010281b <kbdgetc+0x8b>
80102842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102848:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010284b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010284e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102851:	c9                   	leave
      c += 'a' - 'A';
80102852:	83 f9 1a             	cmp    $0x1a,%ecx
80102855:	0f 42 c2             	cmovb  %edx,%eax
}
80102858:	c3                   	ret
80102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102865:	c3                   	ret
80102866:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010286d:	00 
8010286e:	66 90                	xchg   %ax,%ax

80102870 <kbdintr>:

void
kbdintr(void)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102876:	68 90 27 10 80       	push   $0x80102790
8010287b:	e8 40 e0 ff ff       	call   801008c0 <consoleintr>
}
80102880:	83 c4 10             	add    $0x10,%esp
80102883:	c9                   	leave
80102884:	c3                   	ret
80102885:	66 90                	xchg   %ax,%ax
80102887:	66 90                	xchg   %ax,%ax
80102889:	66 90                	xchg   %ax,%ax
8010288b:	66 90                	xchg   %ax,%ax
8010288d:	66 90                	xchg   %ax,%ax
8010288f:	90                   	nop

80102890 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102890:	a1 80 16 11 80       	mov    0x80111680,%eax
80102895:	85 c0                	test   %eax,%eax
80102897:	0f 84 cb 00 00 00    	je     80102968 <lapicinit+0xd8>
  lapic[index] = value;
8010289d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028a4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028aa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028b1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028be:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028cb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028db:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028de:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028e5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028e8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028eb:	8b 50 30             	mov    0x30(%eax),%edx
801028ee:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
801028f4:	75 7a                	jne    80102970 <lapicinit+0xe0>
  lapic[index] = value;
801028f6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102900:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102903:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010290a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010290d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102910:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102917:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010291a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102924:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102927:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102931:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102934:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102937:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010293e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102941:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102944:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010294b:	00 
8010294c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102950:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102956:	80 e6 10             	and    $0x10,%dh
80102959:	75 f5                	jne    80102950 <lapicinit+0xc0>
  lapic[index] = value;
8010295b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102962:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102965:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102968:	c3                   	ret
80102969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102970:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102977:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010297a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010297d:	e9 74 ff ff ff       	jmp    801028f6 <lapicinit+0x66>
80102982:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102989:	00 
8010298a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102990 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102990:	a1 80 16 11 80       	mov    0x80111680,%eax
80102995:	85 c0                	test   %eax,%eax
80102997:	74 07                	je     801029a0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102999:	8b 40 20             	mov    0x20(%eax),%eax
8010299c:	c1 e8 18             	shr    $0x18,%eax
8010299f:	c3                   	ret
801029a0:	31 c0                	xor    %eax,%eax
}
801029a2:	c3                   	ret
801029a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029aa:	00 
801029ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801029b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029b0:	a1 80 16 11 80       	mov    0x80111680,%eax
801029b5:	85 c0                	test   %eax,%eax
801029b7:	74 0d                	je     801029c6 <lapiceoi+0x16>
  lapic[index] = value;
801029b9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029c6:	c3                   	ret
801029c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029ce:	00 
801029cf:	90                   	nop

801029d0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029d0:	c3                   	ret
801029d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029d8:	00 
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	53                   	push   %ebx
801029ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029f4:	ee                   	out    %al,(%dx)
801029f5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029fa:	ba 71 00 00 00       	mov    $0x71,%edx
801029ff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a00:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102a02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a0d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102a10:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a12:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a1e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102a23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a6d:	c9                   	leave
80102a6e:	c3                   	ret
80102a6f:	90                   	nop

80102a70 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a70:	55                   	push   %ebp
80102a71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a76:	ba 70 00 00 00       	mov    $0x70,%edx
80102a7b:	89 e5                	mov    %esp,%ebp
80102a7d:	57                   	push   %edi
80102a7e:	56                   	push   %esi
80102a7f:	53                   	push   %ebx
80102a80:	83 ec 4c             	sub    $0x4c,%esp
80102a83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a84:	ba 71 00 00 00       	mov    $0x71,%edx
80102a89:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	88 45 b4             	mov    %al,-0x4c(%ebp)
80102a90:	31 c0                	xor    %eax,%eax
80102a92:	ba 70 00 00 00       	mov    $0x70,%edx
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa0:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa8:	b8 02 00 00 00       	mov    $0x2,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab1:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab6:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab9:	b8 04 00 00 00       	mov    $0x4,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac2:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac7:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aca:	b8 07 00 00 00       	mov    $0x7,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad3:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad8:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ada:	b8 08 00 00 00       	mov    $0x8,%eax
80102adf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae3:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae8:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aea:	b8 09 00 00 00       	mov    $0x9,%eax
80102aef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af0:	89 ca                	mov    %ecx,%edx
80102af2:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af3:	ba 70 00 00 00       	mov    $0x70,%edx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af8:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afb:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b00:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b01:	89 ca                	mov    %ecx,%edx
80102b03:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b04:	84 c0                	test   %al,%al
80102b06:	78 88                	js     80102a90 <cmostime+0x20>
  return inb(CMOS_RETURN);
80102b08:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b0c:	89 fa                	mov    %edi,%edx
80102b0e:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102b11:	0f b6 fa             	movzbl %dl,%edi
80102b14:	89 f2                	mov    %esi,%edx
80102b16:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b19:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b1d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b20:	ba 70 00 00 00       	mov    $0x70,%edx
80102b25:	89 7d c4             	mov    %edi,-0x3c(%ebp)
80102b28:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b2b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b2f:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102b32:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b35:	31 c0                	xor    %eax,%eax
80102b37:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b38:	89 ca                	mov    %ecx,%edx
80102b3a:	ec                   	in     (%dx),%al
80102b3b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3e:	ba 70 00 00 00       	mov    $0x70,%edx
80102b43:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b46:	b8 02 00 00 00       	mov    $0x2,%eax
80102b4b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4c:	89 ca                	mov    %ecx,%edx
80102b4e:	ec                   	in     (%dx),%al
80102b4f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b52:	ba 70 00 00 00       	mov    $0x70,%edx
80102b57:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b5a:	b8 04 00 00 00       	mov    $0x4,%eax
80102b5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b60:	89 ca                	mov    %ecx,%edx
80102b62:	ec                   	in     (%dx),%al
80102b63:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b66:	ba 70 00 00 00       	mov    $0x70,%edx
80102b6b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b6e:	b8 07 00 00 00       	mov    $0x7,%eax
80102b73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b74:	89 ca                	mov    %ecx,%edx
80102b76:	ec                   	in     (%dx),%al
80102b77:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b7a:	ba 70 00 00 00       	mov    $0x70,%edx
80102b7f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b82:	b8 08 00 00 00       	mov    $0x8,%eax
80102b87:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b88:	89 ca                	mov    %ecx,%edx
80102b8a:	ec                   	in     (%dx),%al
80102b8b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b8e:	ba 70 00 00 00       	mov    $0x70,%edx
80102b93:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b96:	b8 09 00 00 00       	mov    $0x9,%eax
80102b9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9c:	89 ca                	mov    %ecx,%edx
80102b9e:	ec                   	in     (%dx),%al
80102b9f:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ba2:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ba5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ba8:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102bab:	6a 18                	push   $0x18
80102bad:	50                   	push   %eax
80102bae:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102bb1:	50                   	push   %eax
80102bb2:	e8 29 1e 00 00       	call   801049e0 <memcmp>
80102bb7:	83 c4 10             	add    $0x10,%esp
80102bba:	85 c0                	test   %eax,%eax
80102bbc:	0f 85 ce fe ff ff    	jne    80102a90 <cmostime+0x20>
      break;
  }

  // convert
  if(bcd) {
80102bc2:	0f b6 75 b4          	movzbl -0x4c(%ebp),%esi
80102bc6:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bc9:	89 f0                	mov    %esi,%eax
80102bcb:	84 c0                	test   %al,%al
80102bcd:	75 78                	jne    80102c47 <cmostime+0x1d7>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bcf:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bd2:	89 c2                	mov    %eax,%edx
80102bd4:	83 e0 0f             	and    $0xf,%eax
80102bd7:	c1 ea 04             	shr    $0x4,%edx
80102bda:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdd:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be0:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102be3:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102be6:	89 c2                	mov    %eax,%edx
80102be8:	83 e0 0f             	and    $0xf,%eax
80102beb:	c1 ea 04             	shr    $0x4,%edx
80102bee:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf1:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf4:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102bf7:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bfa:	89 c2                	mov    %eax,%edx
80102bfc:	83 e0 0f             	and    $0xf,%eax
80102bff:	c1 ea 04             	shr    $0x4,%edx
80102c02:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c05:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c08:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c0b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c0e:	89 c2                	mov    %eax,%edx
80102c10:	83 e0 0f             	and    $0xf,%eax
80102c13:	c1 ea 04             	shr    $0x4,%edx
80102c16:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c19:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c1c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c22:	89 c2                	mov    %eax,%edx
80102c24:	83 e0 0f             	and    $0xf,%eax
80102c27:	c1 ea 04             	shr    $0x4,%edx
80102c2a:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c30:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c33:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c36:	89 c2                	mov    %eax,%edx
80102c38:	83 e0 0f             	and    $0xf,%eax
80102c3b:	c1 ea 04             	shr    $0x4,%edx
80102c3e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c41:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c44:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c47:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c4a:	89 03                	mov    %eax,(%ebx)
80102c4c:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c4f:	89 43 04             	mov    %eax,0x4(%ebx)
80102c52:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c55:	89 43 08             	mov    %eax,0x8(%ebx)
80102c58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c5b:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c5e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c61:	89 43 10             	mov    %eax,0x10(%ebx)
80102c64:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c67:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c6a:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c74:	5b                   	pop    %ebx
80102c75:	5e                   	pop    %esi
80102c76:	5f                   	pop    %edi
80102c77:	5d                   	pop    %ebp
80102c78:	c3                   	ret
80102c79:	66 90                	xchg   %ax,%ax
80102c7b:	66 90                	xchg   %ax,%ax
80102c7d:	66 90                	xchg   %ax,%ax
80102c7f:	90                   	nop

80102c80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c80:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102c86:	85 c9                	test   %ecx,%ecx
80102c88:	0f 8e 8a 00 00 00    	jle    80102d18 <install_trans+0x98>
{
80102c8e:	55                   	push   %ebp
80102c8f:	89 e5                	mov    %esp,%ebp
80102c91:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c92:	31 ff                	xor    %edi,%edi
{
80102c94:	56                   	push   %esi
80102c95:	53                   	push   %ebx
80102c96:	83 ec 0c             	sub    $0xc,%esp
80102c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ca0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102ca5:	83 ec 08             	sub    $0x8,%esp
80102ca8:	01 f8                	add    %edi,%eax
80102caa:	83 c0 01             	add    $0x1,%eax
80102cad:	50                   	push   %eax
80102cae:	ff 35 e4 16 11 80    	push   0x801116e4
80102cb4:	e8 17 d4 ff ff       	call   801000d0 <bread>
80102cb9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cbb:	58                   	pop    %eax
80102cbc:	5a                   	pop    %edx
80102cbd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102cc4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cca:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ccd:	e8 fe d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cd5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cd7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cda:	68 00 02 00 00       	push   $0x200
80102cdf:	50                   	push   %eax
80102ce0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102ce3:	50                   	push   %eax
80102ce4:	e8 47 1d 00 00       	call   80104a30 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ce9:	89 1c 24             	mov    %ebx,(%esp)
80102cec:	e8 cf d4 ff ff       	call   801001c0 <bwrite>
    brelse(lbuf);
80102cf1:	89 34 24             	mov    %esi,(%esp)
80102cf4:	e8 07 d5 ff ff       	call   80100200 <brelse>
    brelse(dbuf);
80102cf9:	89 1c 24             	mov    %ebx,(%esp)
80102cfc:	e8 ff d4 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d01:	83 c4 10             	add    $0x10,%esp
80102d04:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102d0a:	7f 94                	jg     80102ca0 <install_trans+0x20>
  }
}
80102d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d0f:	5b                   	pop    %ebx
80102d10:	5e                   	pop    %esi
80102d11:	5f                   	pop    %edi
80102d12:	5d                   	pop    %ebp
80102d13:	c3                   	ret
80102d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d18:	c3                   	ret
80102d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d27:	ff 35 d4 16 11 80    	push   0x801116d4
80102d2d:	ff 35 e4 16 11 80    	push   0x801116e4
80102d33:	e8 98 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d38:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d3b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d3d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102d42:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d45:	85 c0                	test   %eax,%eax
80102d47:	7e 29                	jle    80102d72 <write_head+0x52>
80102d49:	31 d2                	xor    %edx,%edx
80102d4b:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d52:	00 
80102d53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d5a:	00 
80102d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102d60:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102d67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d6b:	83 c2 01             	add    $0x1,%edx
80102d6e:	39 d0                	cmp    %edx,%eax
80102d70:	75 ee                	jne    80102d60 <write_head+0x40>
  }
  bwrite(buf);
80102d72:	83 ec 0c             	sub    $0xc,%esp
80102d75:	53                   	push   %ebx
80102d76:	e8 45 d4 ff ff       	call   801001c0 <bwrite>
  brelse(buf);
80102d7b:	89 1c 24             	mov    %ebx,(%esp)
80102d7e:	e8 7d d4 ff ff       	call   80100200 <brelse>
}
80102d83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d86:	83 c4 10             	add    $0x10,%esp
80102d89:	c9                   	leave
80102d8a:	c3                   	ret
80102d8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d90 <initlog>:
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 2c             	sub    $0x2c,%esp
80102d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d9a:	68 17 77 10 80       	push   $0x80107717
80102d9f:	68 a0 16 11 80       	push   $0x801116a0
80102da4:	e8 b7 18 00 00       	call   80104660 <initlock>
  readsb(dev, &sb);
80102da9:	58                   	pop    %eax
80102daa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102dad:	5a                   	pop    %edx
80102dae:	50                   	push   %eax
80102daf:	53                   	push   %ebx
80102db0:	e8 db e7 ff ff       	call   80101590 <readsb>
  log.start = sb.logstart;
80102db5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102db8:	59                   	pop    %ecx
  log.dev = dev;
80102db9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102dbf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102dc2:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102dc7:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102dcd:	5a                   	pop    %edx
80102dce:	50                   	push   %eax
80102dcf:	53                   	push   %ebx
80102dd0:	e8 fb d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102dd5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102dd8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ddb:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102de1:	85 db                	test   %ebx,%ebx
80102de3:	7e 2d                	jle    80102e12 <initlog+0x82>
80102de5:	31 d2                	xor    %edx,%edx
80102de7:	eb 17                	jmp    80102e00 <initlog+0x70>
80102de9:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102df0:	00 
80102df1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102df8:	00 
80102df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102e00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102e04:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e0b:	83 c2 01             	add    $0x1,%edx
80102e0e:	39 d3                	cmp    %edx,%ebx
80102e10:	75 ee                	jne    80102e00 <initlog+0x70>
  brelse(buf);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	50                   	push   %eax
80102e16:	e8 e5 d3 ff ff       	call   80100200 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e1b:	e8 60 fe ff ff       	call   80102c80 <install_trans>
  log.lh.n = 0;
80102e20:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102e27:	00 00 00 
  write_head(); // clear the log
80102e2a:	e8 f1 fe ff ff       	call   80102d20 <write_head>
}
80102e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e32:	83 c4 10             	add    $0x10,%esp
80102e35:	c9                   	leave
80102e36:	c3                   	ret
80102e37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e3e:	00 
80102e3f:	90                   	nop

80102e40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e46:	68 a0 16 11 80       	push   $0x801116a0
80102e4b:	e8 20 1a 00 00       	call   80104870 <acquire>
80102e50:	83 c4 10             	add    $0x10,%esp
80102e53:	eb 18                	jmp    80102e6d <begin_op+0x2d>
80102e55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e58:	83 ec 08             	sub    $0x8,%esp
80102e5b:	68 a0 16 11 80       	push   $0x801116a0
80102e60:	68 a0 16 11 80       	push   $0x801116a0
80102e65:	e8 f6 12 00 00       	call   80104160 <sleep>
80102e6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e6d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102e72:	85 c0                	test   %eax,%eax
80102e74:	75 e2                	jne    80102e58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e76:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102e7b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102e81:	83 c0 01             	add    $0x1,%eax
80102e84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e8a:	83 fa 1e             	cmp    $0x1e,%edx
80102e8d:	7f c9                	jg     80102e58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e92:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102e97:	68 a0 16 11 80       	push   $0x801116a0
80102e9c:	e8 6f 19 00 00       	call   80104810 <release>
      break;
    }
  }
}
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	c9                   	leave
80102ea5:	c3                   	ret
80102ea6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ead:	00 
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	57                   	push   %edi
80102eb4:	56                   	push   %esi
80102eb5:	53                   	push   %ebx
80102eb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102eb9:	68 a0 16 11 80       	push   $0x801116a0
80102ebe:	e8 ad 19 00 00       	call   80104870 <acquire>
  log.outstanding -= 1;
80102ec3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102ec8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102ece:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ed1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ed4:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102eda:	85 f6                	test   %esi,%esi
80102edc:	0f 85 22 01 00 00    	jne    80103004 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ee2:	85 db                	test   %ebx,%ebx
80102ee4:	0f 85 f6 00 00 00    	jne    80102fe0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eea:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102ef1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 a0 16 11 80       	push   $0x801116a0
80102efc:	e8 0f 19 00 00       	call   80104810 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f01:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102f07:	83 c4 10             	add    $0x10,%esp
80102f0a:	85 c9                	test   %ecx,%ecx
80102f0c:	7f 42                	jg     80102f50 <end_op+0xa0>
    acquire(&log.lock);
80102f0e:	83 ec 0c             	sub    $0xc,%esp
80102f11:	68 a0 16 11 80       	push   $0x801116a0
80102f16:	e8 55 19 00 00       	call   80104870 <acquire>
    log.committing = 0;
80102f1b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102f22:	00 00 00 
    wakeup(&log);
80102f25:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f2c:	e8 ef 12 00 00       	call   80104220 <wakeup>
    release(&log.lock);
80102f31:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102f38:	e8 d3 18 00 00       	call   80104810 <release>
80102f3d:	83 c4 10             	add    $0x10,%esp
}
80102f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f43:	5b                   	pop    %ebx
80102f44:	5e                   	pop    %esi
80102f45:	5f                   	pop    %edi
80102f46:	5d                   	pop    %ebp
80102f47:	c3                   	ret
80102f48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f4f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f50:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102f55:	83 ec 08             	sub    $0x8,%esp
80102f58:	01 d8                	add    %ebx,%eax
80102f5a:	83 c0 01             	add    $0x1,%eax
80102f5d:	50                   	push   %eax
80102f5e:	ff 35 e4 16 11 80    	push   0x801116e4
80102f64:	e8 67 d1 ff ff       	call   801000d0 <bread>
80102f69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f6b:	58                   	pop    %eax
80102f6c:	5a                   	pop    %edx
80102f6d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102f74:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f7d:	e8 4e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f8a:	68 00 02 00 00       	push   $0x200
80102f8f:	50                   	push   %eax
80102f90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f93:	50                   	push   %eax
80102f94:	e8 97 1a 00 00       	call   80104a30 <memmove>
    bwrite(to);  // write the log
80102f99:	89 34 24             	mov    %esi,(%esp)
80102f9c:	e8 1f d2 ff ff       	call   801001c0 <bwrite>
    brelse(from);
80102fa1:	89 3c 24             	mov    %edi,(%esp)
80102fa4:	e8 57 d2 ff ff       	call   80100200 <brelse>
    brelse(to);
80102fa9:	89 34 24             	mov    %esi,(%esp)
80102fac:	e8 4f d2 ff ff       	call   80100200 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fb1:	83 c4 10             	add    $0x10,%esp
80102fb4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102fba:	7c 94                	jl     80102f50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fbc:	e8 5f fd ff ff       	call   80102d20 <write_head>
    install_trans(); // Now install writes to home locations
80102fc1:	e8 ba fc ff ff       	call   80102c80 <install_trans>
    log.lh.n = 0;
80102fc6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102fcd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fd0:	e8 4b fd ff ff       	call   80102d20 <write_head>
80102fd5:	e9 34 ff ff ff       	jmp    80102f0e <end_op+0x5e>
80102fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fe0:	83 ec 0c             	sub    $0xc,%esp
80102fe3:	68 a0 16 11 80       	push   $0x801116a0
80102fe8:	e8 33 12 00 00       	call   80104220 <wakeup>
  release(&log.lock);
80102fed:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ff4:	e8 17 18 00 00       	call   80104810 <release>
80102ff9:	83 c4 10             	add    $0x10,%esp
}
80102ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fff:	5b                   	pop    %ebx
80103000:	5e                   	pop    %esi
80103001:	5f                   	pop    %edi
80103002:	5d                   	pop    %ebp
80103003:	c3                   	ret
    panic("log.committing");
80103004:	83 ec 0c             	sub    $0xc,%esp
80103007:	68 1b 77 10 80       	push   $0x8010771b
8010300c:	e8 8f d3 ff ff       	call   801003a0 <panic>
80103011:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103018:	00 
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103020 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	53                   	push   %ebx
80103024:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103027:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
8010302d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103030:	83 fa 1d             	cmp    $0x1d,%edx
80103033:	7f 7d                	jg     801030b2 <log_write+0x92>
80103035:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010303a:	83 e8 01             	sub    $0x1,%eax
8010303d:	39 c2                	cmp    %eax,%edx
8010303f:	7d 71                	jge    801030b2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103041:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80103046:	85 c0                	test   %eax,%eax
80103048:	7e 75                	jle    801030bf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010304a:	83 ec 0c             	sub    $0xc,%esp
8010304d:	68 a0 16 11 80       	push   $0x801116a0
80103052:	e8 19 18 00 00       	call   80104870 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103057:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010305a:	83 c4 10             	add    $0x10,%esp
8010305d:	31 c0                	xor    %eax,%eax
8010305f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80103065:	85 d2                	test   %edx,%edx
80103067:	7f 0e                	jg     80103077 <log_write+0x57>
80103069:	eb 15                	jmp    80103080 <log_write+0x60>
8010306b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103070:	83 c0 01             	add    $0x1,%eax
80103073:	39 d0                	cmp    %edx,%eax
80103075:	74 29                	je     801030a0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103077:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
8010307e:	75 f0                	jne    80103070 <log_write+0x50>
  log.lh.block[i] = b->blockno;
80103080:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80103087:	39 c2                	cmp    %eax,%edx
80103089:	74 1c                	je     801030a7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010308b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010308e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103091:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80103098:	c9                   	leave
  release(&log.lock);
80103099:	e9 72 17 00 00       	jmp    80104810 <release>
8010309e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
801030a0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
801030a7:	83 c2 01             	add    $0x1,%edx
801030aa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
801030b0:	eb d9                	jmp    8010308b <log_write+0x6b>
    panic("too big a transaction");
801030b2:	83 ec 0c             	sub    $0xc,%esp
801030b5:	68 2a 77 10 80       	push   $0x8010772a
801030ba:	e8 e1 d2 ff ff       	call   801003a0 <panic>
    panic("log_write outside of trans");
801030bf:	83 ec 0c             	sub    $0xc,%esp
801030c2:	68 40 77 10 80       	push   $0x80107740
801030c7:	e8 d4 d2 ff ff       	call   801003a0 <panic>
801030cc:	66 90                	xchg   %ax,%ax
801030ce:	66 90                	xchg   %ax,%ax

801030d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	53                   	push   %ebx
801030d4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030d7:	e8 84 09 00 00       	call   80103a60 <cpuid>
801030dc:	89 c3                	mov    %eax,%ebx
801030de:	e8 7d 09 00 00       	call   80103a60 <cpuid>
801030e3:	83 ec 04             	sub    $0x4,%esp
801030e6:	53                   	push   %ebx
801030e7:	50                   	push   %eax
801030e8:	68 5b 77 10 80       	push   $0x8010775b
801030ed:	e8 de d5 ff ff       	call   801006d0 <cprintf>
  idtinit();       // load idt register
801030f2:	e8 b9 2b 00 00       	call   80105cb0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030f7:	e8 04 09 00 00       	call   80103a00 <mycpu>
801030fc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030fe:	b8 01 00 00 00       	mov    $0x1,%eax
80103103:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010310a:	e8 21 0c 00 00       	call   80103d30 <scheduler>
8010310f:	90                   	nop

80103110 <mpenter>:
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103116:	e8 a5 3c 00 00       	call   80106dc0 <switchkvm>
  seginit();
8010311b:	e8 10 3c 00 00       	call   80106d30 <seginit>
  lapicinit();
80103120:	e8 6b f7 ff ff       	call   80102890 <lapicinit>
  mpmain();
80103125:	e8 a6 ff ff ff       	call   801030d0 <mpmain>
8010312a:	66 90                	xchg   %ax,%ax
8010312c:	66 90                	xchg   %ax,%ax
8010312e:	66 90                	xchg   %ax,%ax

80103130 <main>:
{
80103130:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103134:	83 e4 f0             	and    $0xfffffff0,%esp
80103137:	ff 71 fc             	push   -0x4(%ecx)
8010313a:	55                   	push   %ebp
8010313b:	89 e5                	mov    %esp,%ebp
8010313d:	53                   	push   %ebx
8010313e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010313f:	83 ec 08             	sub    $0x8,%esp
80103142:	68 00 00 40 80       	push   $0x80400000
80103147:	68 d0 55 11 80       	push   $0x801155d0
8010314c:	e8 4f f5 ff ff       	call   801026a0 <kinit1>
  kvmalloc();      // kernel page table
80103151:	e8 2a 41 00 00       	call   80107280 <kvmalloc>
  mpinit();        // detect other processors
80103156:	e8 85 01 00 00       	call   801032e0 <mpinit>
  lapicinit();     // interrupt controller
8010315b:	e8 30 f7 ff ff       	call   80102890 <lapicinit>
  seginit();       // segment descriptors
80103160:	e8 cb 3b 00 00       	call   80106d30 <seginit>
  picinit();       // disable pic
80103165:	e8 56 03 00 00       	call   801034c0 <picinit>
  ioapicinit();    // another interrupt controller
8010316a:	e8 d1 f2 ff ff       	call   80102440 <ioapicinit>
  consoleinit();   // console hardware
8010316f:	e8 2c d9 ff ff       	call   80100aa0 <consoleinit>
  uartinit();      // serial port
80103174:	e8 17 2e 00 00       	call   80105f90 <uartinit>
  pinit();         // process table
80103179:	e8 62 08 00 00       	call   801039e0 <pinit>
  tvinit();        // trap vectors
8010317e:	e8 7d 2a 00 00       	call   80105c00 <tvinit>
  binit();         // buffer cache
80103183:	e8 b8 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103188:	e8 f3 dc ff ff       	call   80100e80 <fileinit>
  ideinit();       // disk 
8010318d:	e8 8e f0 ff ff       	call   80102220 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103192:	83 c4 0c             	add    $0xc,%esp
80103195:	68 8a 00 00 00       	push   $0x8a
8010319a:	68 8c a4 10 80       	push   $0x8010a48c
8010319f:	68 00 70 00 80       	push   $0x80007000
801031a4:	e8 87 18 00 00       	call   80104a30 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031a9:	83 c4 10             	add    $0x10,%esp
801031ac:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801031b3:	00 00 00 
801031b6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801031bb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801031c0:	76 7e                	jbe    80103240 <main+0x110>
801031c2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801031c7:	eb 20                	jmp    801031e9 <main+0xb9>
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031d0:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801031d7:	00 00 00 
801031da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031e0:	05 a0 17 11 80       	add    $0x801117a0,%eax
801031e5:	39 c3                	cmp    %eax,%ebx
801031e7:	73 57                	jae    80103240 <main+0x110>
    if(c == mycpu())  // We've started already.
801031e9:	e8 12 08 00 00       	call   80103a00 <mycpu>
801031ee:	39 c3                	cmp    %eax,%ebx
801031f0:	74 de                	je     801031d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031f2:	e8 19 f5 ff ff       	call   80102710 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801031fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103110,0x80006ff8
80103201:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103204:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010320b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010320e:	05 00 10 00 00       	add    $0x1000,%eax
80103213:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103218:	0f b6 03             	movzbl (%ebx),%eax
8010321b:	68 00 70 00 00       	push   $0x7000
80103220:	50                   	push   %eax
80103221:	e8 ba f7 ff ff       	call   801029e0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103226:	83 c4 10             	add    $0x10,%esp
80103229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103230:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103236:	85 c0                	test   %eax,%eax
80103238:	74 f6                	je     80103230 <main+0x100>
8010323a:	eb 94                	jmp    801031d0 <main+0xa0>
8010323c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103240:	83 ec 08             	sub    $0x8,%esp
80103243:	68 00 00 00 8e       	push   $0x8e000000
80103248:	68 00 00 40 80       	push   $0x80400000
8010324d:	e8 ee f3 ff ff       	call   80102640 <kinit2>
  userinit();      // first user process
80103252:	e8 59 08 00 00       	call   80103ab0 <userinit>
  mpmain();        // finish this processor's setup
80103257:	e8 74 fe ff ff       	call   801030d0 <mpmain>
8010325c:	66 90                	xchg   %ax,%ax
8010325e:	66 90                	xchg   %ax,%ax

80103260 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	57                   	push   %edi
80103264:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103265:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010326b:	53                   	push   %ebx
  e = addr+len;
8010326c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010326f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103272:	39 de                	cmp    %ebx,%esi
80103274:	72 10                	jb     80103286 <mpsearch1+0x26>
80103276:	eb 58                	jmp    801032d0 <mpsearch1+0x70>
80103278:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010327f:	00 
80103280:	89 fe                	mov    %edi,%esi
80103282:	39 df                	cmp    %ebx,%edi
80103284:	73 4a                	jae    801032d0 <mpsearch1+0x70>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103286:	83 ec 04             	sub    $0x4,%esp
80103289:	8d 7e 10             	lea    0x10(%esi),%edi
8010328c:	6a 04                	push   $0x4
8010328e:	68 6f 77 10 80       	push   $0x8010776f
80103293:	56                   	push   %esi
80103294:	e8 47 17 00 00       	call   801049e0 <memcmp>
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	85 c0                	test   %eax,%eax
8010329e:	75 e0                	jne    80103280 <mpsearch1+0x20>
801032a0:	89 f2                	mov    %esi,%edx
801032a2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032a9:	00 
801032aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801032b0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801032b3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801032b6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032b8:	39 fa                	cmp    %edi,%edx
801032ba:	75 f4                	jne    801032b0 <mpsearch1+0x50>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032bc:	84 c0                	test   %al,%al
801032be:	75 c0                	jne    80103280 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032c3:	89 f0                	mov    %esi,%eax
801032c5:	5b                   	pop    %ebx
801032c6:	5e                   	pop    %esi
801032c7:	5f                   	pop    %edi
801032c8:	5d                   	pop    %ebp
801032c9:	c3                   	ret
801032ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032d3:	31 f6                	xor    %esi,%esi
}
801032d5:	5b                   	pop    %ebx
801032d6:	89 f0                	mov    %esi,%eax
801032d8:	5e                   	pop    %esi
801032d9:	5f                   	pop    %edi
801032da:	5d                   	pop    %ebp
801032db:	c3                   	ret
801032dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
801032e5:	53                   	push   %ebx
801032e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032f7:	c1 e0 08             	shl    $0x8,%eax
801032fa:	09 d0                	or     %edx,%eax
801032fc:	c1 e0 04             	shl    $0x4,%eax
801032ff:	75 1b                	jne    8010331c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103301:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103308:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010330f:	c1 e0 08             	shl    $0x8,%eax
80103312:	09 d0                	or     %edx,%eax
80103314:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103317:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010331c:	ba 00 04 00 00       	mov    $0x400,%edx
80103321:	e8 3a ff ff ff       	call   80103260 <mpsearch1>
80103326:	89 c3                	mov    %eax,%ebx
80103328:	85 c0                	test   %eax,%eax
8010332a:	0f 84 38 01 00 00    	je     80103468 <mpinit+0x188>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103330:	8b 73 04             	mov    0x4(%ebx),%esi
80103333:	85 f6                	test   %esi,%esi
80103335:	0f 84 1d 01 00 00    	je     80103458 <mpinit+0x178>
  if(memcmp(conf, "PCMP", 4) != 0)
8010333b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010333e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103344:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103347:	6a 04                	push   $0x4
80103349:	68 74 77 10 80       	push   $0x80107774
8010334e:	50                   	push   %eax
8010334f:	e8 8c 16 00 00       	call   801049e0 <memcmp>
80103354:	83 c4 10             	add    $0x10,%esp
80103357:	89 c2                	mov    %eax,%edx
80103359:	85 c0                	test   %eax,%eax
8010335b:	0f 85 f7 00 00 00    	jne    80103458 <mpinit+0x178>
  if(conf->version != 1 && conf->version != 4)
80103361:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103368:	3c 01                	cmp    $0x1,%al
8010336a:	74 08                	je     80103374 <mpinit+0x94>
8010336c:	3c 04                	cmp    $0x4,%al
8010336e:	0f 85 e4 00 00 00    	jne    80103458 <mpinit+0x178>
  if(sum((uchar*)conf, conf->length) != 0)
80103374:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
  for(i=0; i<len; i++)
8010337b:	66 85 c9             	test   %cx,%cx
8010337e:	74 28                	je     801033a8 <mpinit+0xc8>
80103380:	89 f0                	mov    %esi,%eax
80103382:	8d 3c 31             	lea    (%ecx,%esi,1),%edi
80103385:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010338c:	00 
8010338d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103390:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
80103397:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
8010339a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010339c:	39 c7                	cmp    %eax,%edi
8010339e:	75 f0                	jne    80103390 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801033a0:	84 d2                	test   %dl,%dl
801033a2:	0f 85 b0 00 00 00    	jne    80103458 <mpinit+0x178>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033a8:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  lapic = (uint*)conf->lapicaddr;
801033b1:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033b6:	0f b7 8e 04 00 00 80 	movzwl -0x7ffffffc(%esi),%ecx
801033bd:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801033c3:	01 cf                	add    %ecx,%edi
801033c5:	89 f9                	mov    %edi,%ecx
801033c7:	39 f8                	cmp    %edi,%eax
801033c9:	72 10                	jb     801033db <mpinit+0xfb>
801033cb:	eb 34                	jmp    80103401 <mpinit+0x121>
801033cd:	8d 76 00             	lea    0x0(%esi),%esi
    switch(*p){
801033d0:	84 d2                	test   %dl,%dl
801033d2:	74 54                	je     80103428 <mpinit+0x148>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033d4:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033d7:	39 c8                	cmp    %ecx,%eax
801033d9:	73 26                	jae    80103401 <mpinit+0x121>
    switch(*p){
801033db:	0f b6 10             	movzbl (%eax),%edx
801033de:	80 fa 02             	cmp    $0x2,%dl
801033e1:	74 0d                	je     801033f0 <mpinit+0x110>
801033e3:	76 eb                	jbe    801033d0 <mpinit+0xf0>
801033e5:	83 ea 03             	sub    $0x3,%edx
801033e8:	80 fa 01             	cmp    $0x1,%dl
801033eb:	76 e7                	jbe    801033d4 <mpinit+0xf4>
801033ed:	eb fe                	jmp    801033ed <mpinit+0x10d>
801033ef:	90                   	nop
      ioapicid = ioapic->apicno;
801033f0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801033f4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033f7:	88 15 80 17 11 80    	mov    %dl,0x80111780
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033fd:	39 c8                	cmp    %ecx,%eax
801033ff:	72 da                	jb     801033db <mpinit+0xfb>
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103401:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103405:	74 15                	je     8010341c <mpinit+0x13c>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103407:	b8 70 00 00 00       	mov    $0x70,%eax
8010340c:	ba 22 00 00 00       	mov    $0x22,%edx
80103411:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103412:	ba 23 00 00 00       	mov    $0x23,%edx
80103417:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103418:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010341b:	ee                   	out    %al,(%dx)
  }
}
8010341c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010341f:	5b                   	pop    %ebx
80103420:	5e                   	pop    %esi
80103421:	5f                   	pop    %edi
80103422:	5d                   	pop    %ebp
80103423:	c3                   	ret
80103424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103428:	8b 35 84 17 11 80    	mov    0x80111784,%esi
8010342e:	83 fe 07             	cmp    $0x7,%esi
80103431:	7f 19                	jg     8010344c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103433:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80103439:	0f b6 50 01          	movzbl 0x1(%eax),%edx
        ncpu++;
8010343d:	83 c6 01             	add    $0x1,%esi
80103440:	89 35 84 17 11 80    	mov    %esi,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103446:	88 97 a0 17 11 80    	mov    %dl,-0x7feee860(%edi)
      p += sizeof(struct mpproc);
8010344c:	83 c0 14             	add    $0x14,%eax
      continue;
8010344f:	eb 86                	jmp    801033d7 <mpinit+0xf7>
80103451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103458:	83 ec 0c             	sub    $0xc,%esp
8010345b:	68 79 77 10 80       	push   $0x80107779
80103460:	e8 3b cf ff ff       	call   801003a0 <panic>
80103465:	8d 76 00             	lea    0x0(%esi),%esi
{
80103468:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010346d:	eb 0b                	jmp    8010347a <mpinit+0x19a>
8010346f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103470:	89 f3                	mov    %esi,%ebx
80103472:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103478:	74 de                	je     80103458 <mpinit+0x178>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010347a:	83 ec 04             	sub    $0x4,%esp
8010347d:	8d 73 10             	lea    0x10(%ebx),%esi
80103480:	6a 04                	push   $0x4
80103482:	68 6f 77 10 80       	push   $0x8010776f
80103487:	53                   	push   %ebx
80103488:	e8 53 15 00 00       	call   801049e0 <memcmp>
8010348d:	83 c4 10             	add    $0x10,%esp
80103490:	85 c0                	test   %eax,%eax
80103492:	75 dc                	jne    80103470 <mpinit+0x190>
80103494:	89 da                	mov    %ebx,%edx
80103496:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010349d:	00 
8010349e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801034a0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034a3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034a6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034a8:	39 d6                	cmp    %edx,%esi
801034aa:	75 f4                	jne    801034a0 <mpinit+0x1c0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ac:	84 c0                	test   %al,%al
801034ae:	75 c0                	jne    80103470 <mpinit+0x190>
801034b0:	e9 7b fe ff ff       	jmp    80103330 <mpinit+0x50>
801034b5:	66 90                	xchg   %ax,%ax
801034b7:	66 90                	xchg   %ax,%ax
801034b9:	66 90                	xchg   %ax,%ax
801034bb:	66 90                	xchg   %ax,%ax
801034bd:	66 90                	xchg   %ax,%ax
801034bf:	90                   	nop

801034c0 <picinit>:
801034c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034c5:	ba 21 00 00 00       	mov    $0x21,%edx
801034ca:	ee                   	out    %al,(%dx)
801034cb:	ba a1 00 00 00       	mov    $0xa1,%edx
801034d0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034d1:	c3                   	ret
801034d2:	66 90                	xchg   %ax,%ax
801034d4:	66 90                	xchg   %ax,%ax
801034d6:	66 90                	xchg   %ax,%ax
801034d8:	66 90                	xchg   %ax,%ax
801034da:	66 90                	xchg   %ax,%ax
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax
801034e0:	66 90                	xchg   %ax,%ax
801034e2:	66 90                	xchg   %ax,%ax
801034e4:	66 90                	xchg   %ax,%ax
801034e6:	66 90                	xchg   %ax,%ax
801034e8:	66 90                	xchg   %ax,%ax
801034ea:	66 90                	xchg   %ax,%ax
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax
801034f0:	66 90                	xchg   %ax,%ax
801034f2:	66 90                	xchg   %ax,%ax
801034f4:	66 90                	xchg   %ax,%ax
801034f6:	66 90                	xchg   %ax,%ax
801034f8:	66 90                	xchg   %ax,%ax
801034fa:	66 90                	xchg   %ax,%ax
801034fc:	66 90                	xchg   %ax,%ax
801034fe:	66 90                	xchg   %ax,%ax

80103500 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010350f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103515:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010351b:	e8 80 d9 ff ff       	call   80100ea0 <filealloc>
80103520:	89 06                	mov    %eax,(%esi)
80103522:	85 c0                	test   %eax,%eax
80103524:	0f 84 a5 00 00 00    	je     801035cf <pipealloc+0xcf>
8010352a:	e8 71 d9 ff ff       	call   80100ea0 <filealloc>
8010352f:	89 07                	mov    %eax,(%edi)
80103531:	85 c0                	test   %eax,%eax
80103533:	0f 84 84 00 00 00    	je     801035bd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103539:	e8 d2 f1 ff ff       	call   80102710 <kalloc>
8010353e:	89 c3                	mov    %eax,%ebx
80103540:	85 c0                	test   %eax,%eax
80103542:	0f 84 a0 00 00 00    	je     801035e8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103548:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010354f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103552:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103555:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010355c:	00 00 00 
  p->nwrite = 0;
8010355f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103566:	00 00 00 
  p->nread = 0;
80103569:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103570:	00 00 00 
  initlock(&p->lock, "pipe");
80103573:	68 91 77 10 80       	push   $0x80107791
80103578:	50                   	push   %eax
80103579:	e8 e2 10 00 00       	call   80104660 <initlock>
  (*f0)->type = FD_PIPE;
8010357e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103580:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103583:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103589:	8b 06                	mov    (%esi),%eax
8010358b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010358f:	8b 06                	mov    (%esi),%eax
80103591:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103595:	8b 06                	mov    (%esi),%eax
80103597:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010359a:	8b 07                	mov    (%edi),%eax
8010359c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035a2:	8b 07                	mov    (%edi),%eax
801035a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035a8:	8b 07                	mov    (%edi),%eax
801035aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035ae:	8b 07                	mov    (%edi),%eax
801035b0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801035b3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b8:	5b                   	pop    %ebx
801035b9:	5e                   	pop    %esi
801035ba:	5f                   	pop    %edi
801035bb:	5d                   	pop    %ebp
801035bc:	c3                   	ret
  if(*f0)
801035bd:	8b 06                	mov    (%esi),%eax
801035bf:	85 c0                	test   %eax,%eax
801035c1:	74 1e                	je     801035e1 <pipealloc+0xe1>
    fileclose(*f0);
801035c3:	83 ec 0c             	sub    $0xc,%esp
801035c6:	50                   	push   %eax
801035c7:	e8 94 d9 ff ff       	call   80100f60 <fileclose>
801035cc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035cf:	8b 07                	mov    (%edi),%eax
801035d1:	85 c0                	test   %eax,%eax
801035d3:	74 0c                	je     801035e1 <pipealloc+0xe1>
    fileclose(*f1);
801035d5:	83 ec 0c             	sub    $0xc,%esp
801035d8:	50                   	push   %eax
801035d9:	e8 82 d9 ff ff       	call   80100f60 <fileclose>
801035de:	83 c4 10             	add    $0x10,%esp
  return -1;
801035e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035e6:	eb cd                	jmp    801035b5 <pipealloc+0xb5>
  if(*f0)
801035e8:	8b 06                	mov    (%esi),%eax
801035ea:	85 c0                	test   %eax,%eax
801035ec:	75 d5                	jne    801035c3 <pipealloc+0xc3>
801035ee:	eb df                	jmp    801035cf <pipealloc+0xcf>

801035f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035fb:	83 ec 0c             	sub    $0xc,%esp
801035fe:	53                   	push   %ebx
801035ff:	e8 6c 12 00 00       	call   80104870 <acquire>
  if(writable){
80103604:	83 c4 10             	add    $0x10,%esp
80103607:	85 f6                	test   %esi,%esi
80103609:	74 45                	je     80103650 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010360b:	83 ec 0c             	sub    $0xc,%esp
8010360e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103614:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010361b:	00 00 00 
    wakeup(&p->nread);
8010361e:	50                   	push   %eax
8010361f:	e8 fc 0b 00 00       	call   80104220 <wakeup>
80103624:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103627:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010362d:	85 d2                	test   %edx,%edx
8010362f:	75 0a                	jne    8010363b <pipeclose+0x4b>
80103631:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103637:	85 c0                	test   %eax,%eax
80103639:	74 35                	je     80103670 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010363b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010363e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103641:	5b                   	pop    %ebx
80103642:	5e                   	pop    %esi
80103643:	5d                   	pop    %ebp
    release(&p->lock);
80103644:	e9 c7 11 00 00       	jmp    80104810 <release>
80103649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103659:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103660:	00 00 00 
    wakeup(&p->nwrite);
80103663:	50                   	push   %eax
80103664:	e8 b7 0b 00 00       	call   80104220 <wakeup>
80103669:	83 c4 10             	add    $0x10,%esp
8010366c:	eb b9                	jmp    80103627 <pipeclose+0x37>
8010366e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	53                   	push   %ebx
80103674:	e8 97 11 00 00       	call   80104810 <release>
    kfree((char*)p);
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010367f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103682:	5b                   	pop    %ebx
80103683:	5e                   	pop    %esi
80103684:	5d                   	pop    %ebp
    kfree((char*)p);
80103685:	e9 b6 ee ff ff       	jmp    80102540 <kfree>
8010368a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103690 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 28             	sub    $0x28,%esp
80103699:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010369c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010369f:	53                   	push   %ebx
801036a0:	e8 cb 11 00 00       	call   80104870 <acquire>
  for(i = 0; i < n; i++){
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	85 ff                	test   %edi,%edi
801036aa:	0f 8e ce 00 00 00    	jle    8010377e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036b0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801036b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801036b9:	89 7d 10             	mov    %edi,0x10(%ebp)
801036bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036bf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801036c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036c5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036cb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036d1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036d7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801036dd:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801036e0:	0f 85 b6 00 00 00    	jne    8010379c <pipewrite+0x10c>
801036e6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036e9:	eb 3b                	jmp    80103726 <pipewrite+0x96>
801036eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801036f0:	e8 8b 03 00 00       	call   80103a80 <myproc>
801036f5:	8b 48 24             	mov    0x24(%eax),%ecx
801036f8:	85 c9                	test   %ecx,%ecx
801036fa:	75 34                	jne    80103730 <pipewrite+0xa0>
      wakeup(&p->nread);
801036fc:	83 ec 0c             	sub    $0xc,%esp
801036ff:	56                   	push   %esi
80103700:	e8 1b 0b 00 00       	call   80104220 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103705:	58                   	pop    %eax
80103706:	5a                   	pop    %edx
80103707:	53                   	push   %ebx
80103708:	57                   	push   %edi
80103709:	e8 52 0a 00 00       	call   80104160 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010370e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103714:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010371a:	83 c4 10             	add    $0x10,%esp
8010371d:	05 00 02 00 00       	add    $0x200,%eax
80103722:	39 c2                	cmp    %eax,%edx
80103724:	75 2a                	jne    80103750 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103726:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010372c:	85 c0                	test   %eax,%eax
8010372e:	75 c0                	jne    801036f0 <pipewrite+0x60>
        release(&p->lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	53                   	push   %ebx
80103734:	e8 d7 10 00 00       	call   80104810 <release>
        return -1;
80103739:	83 c4 10             	add    $0x10,%esp
8010373c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103741:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103744:	5b                   	pop    %ebx
80103745:	5e                   	pop    %esi
80103746:	5f                   	pop    %edi
80103747:	5d                   	pop    %ebp
80103748:	c3                   	ret
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103750:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103753:	8d 42 01             	lea    0x1(%edx),%eax
80103756:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010375c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010375f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103768:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010376c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103770:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103773:	39 c1                	cmp    %eax,%ecx
80103775:	0f 85 50 ff ff ff    	jne    801036cb <pipewrite+0x3b>
8010377b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010377e:	83 ec 0c             	sub    $0xc,%esp
80103781:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103787:	50                   	push   %eax
80103788:	e8 93 0a 00 00       	call   80104220 <wakeup>
  release(&p->lock);
8010378d:	89 1c 24             	mov    %ebx,(%esp)
80103790:	e8 7b 10 00 00       	call   80104810 <release>
  return n;
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	89 f8                	mov    %edi,%eax
8010379a:	eb a5                	jmp    80103741 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010379c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010379f:	eb b2                	jmp    80103753 <pipewrite+0xc3>
801037a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037a8:	00 
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	57                   	push   %edi
801037b4:	56                   	push   %esi
801037b5:	53                   	push   %ebx
801037b6:	83 ec 18             	sub    $0x18,%esp
801037b9:	8b 75 08             	mov    0x8(%ebp),%esi
801037bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037bf:	56                   	push   %esi
801037c0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037c6:	e8 a5 10 00 00       	call   80104870 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037cb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d1:	83 c4 10             	add    $0x10,%esp
801037d4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037da:	74 2f                	je     8010380b <piperead+0x5b>
801037dc:	eb 37                	jmp    80103815 <piperead+0x65>
801037de:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801037e0:	e8 9b 02 00 00       	call   80103a80 <myproc>
801037e5:	8b 40 24             	mov    0x24(%eax),%eax
801037e8:	85 c0                	test   %eax,%eax
801037ea:	0f 85 a0 00 00 00    	jne    80103890 <piperead+0xe0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037f0:	83 ec 08             	sub    $0x8,%esp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
801037f5:	e8 66 09 00 00       	call   80104160 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037fa:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103800:	83 c4 10             	add    $0x10,%esp
80103803:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103809:	75 0a                	jne    80103815 <piperead+0x65>
8010380b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103811:	85 d2                	test   %edx,%edx
80103813:	75 cb                	jne    801037e0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103815:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103818:	31 db                	xor    %ebx,%ebx
8010381a:	85 c9                	test   %ecx,%ecx
8010381c:	7f 46                	jg     80103864 <piperead+0xb4>
8010381e:	eb 4c                	jmp    8010386c <piperead+0xbc>
80103820:	eb 1e                	jmp    80103840 <piperead+0x90>
80103822:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103829:	00 
8010382a:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103831:	00 
80103832:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103839:	00 
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103840:	8d 48 01             	lea    0x1(%eax),%ecx
80103843:	25 ff 01 00 00       	and    $0x1ff,%eax
80103848:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010384e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103853:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103856:	83 c3 01             	add    $0x1,%ebx
80103859:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010385c:	74 0e                	je     8010386c <piperead+0xbc>
8010385e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103864:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010386a:	75 d4                	jne    80103840 <piperead+0x90>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010386c:	83 ec 0c             	sub    $0xc,%esp
8010386f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103875:	50                   	push   %eax
80103876:	e8 a5 09 00 00       	call   80104220 <wakeup>
  release(&p->lock);
8010387b:	89 34 24             	mov    %esi,(%esp)
8010387e:	e8 8d 0f 00 00       	call   80104810 <release>
  return i;
80103883:	83 c4 10             	add    $0x10,%esp
}
80103886:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103889:	89 d8                	mov    %ebx,%eax
8010388b:	5b                   	pop    %ebx
8010388c:	5e                   	pop    %esi
8010388d:	5f                   	pop    %edi
8010388e:	5d                   	pop    %ebp
8010388f:	c3                   	ret
      release(&p->lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103893:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103898:	56                   	push   %esi
80103899:	e8 72 0f 00 00       	call   80104810 <release>
      return -1;
8010389e:	83 c4 10             	add    $0x10,%esp
}
801038a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a4:	89 d8                	mov    %ebx,%eax
801038a6:	5b                   	pop    %ebx
801038a7:	5e                   	pop    %esi
801038a8:	5f                   	pop    %edi
801038a9:	5d                   	pop    %ebp
801038aa:	c3                   	ret
801038ab:	66 90                	xchg   %ax,%ax
801038ad:	66 90                	xchg   %ax,%ax
801038af:	66 90                	xchg   %ax,%ax
801038b1:	66 90                	xchg   %ax,%ax
801038b3:	66 90                	xchg   %ax,%ax
801038b5:	66 90                	xchg   %ax,%ax
801038b7:	66 90                	xchg   %ax,%ax
801038b9:	66 90                	xchg   %ax,%ax
801038bb:	66 90                	xchg   %ax,%ax
801038bd:	66 90                	xchg   %ax,%ax
801038bf:	90                   	nop

801038c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801038c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038cc:	68 20 1d 11 80       	push   $0x80111d20
801038d1:	e8 9a 0f 00 00       	call   80104870 <acquire>
801038d6:	83 c4 10             	add    $0x10,%esp
801038d9:	eb 10                	jmp    801038eb <allocproc+0x2b>
801038db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e0:	83 eb 80             	sub    $0xffffff80,%ebx
801038e3:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
801038e9:	74 75                	je     80103960 <allocproc+0xa0>
    if(p->state == UNUSED)
801038eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801038ee:	85 c0                	test   %eax,%eax
801038f0:	75 ee                	jne    801038e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038f2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801038f7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038fa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103901:	89 43 10             	mov    %eax,0x10(%ebx)
80103904:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103907:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
8010390c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103912:	e8 f9 0e 00 00       	call   80104810 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103917:	e8 f4 ed ff ff       	call   80102710 <kalloc>
8010391c:	83 c4 10             	add    $0x10,%esp
8010391f:	89 43 08             	mov    %eax,0x8(%ebx)
80103922:	85 c0                	test   %eax,%eax
80103924:	74 53                	je     80103979 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103926:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010392c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010392f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103934:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103937:	c7 40 14 df 5b 10 80 	movl   $0x80105bdf,0x14(%eax)
  p->context = (struct context*)sp;
8010393e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103941:	6a 14                	push   $0x14
80103943:	6a 00                	push   $0x0
80103945:	50                   	push   %eax
80103946:	e8 55 10 00 00       	call   801049a0 <memset>
  p->context->eip = (uint)forkret;
8010394b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010394e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103951:	c7 40 10 90 39 10 80 	movl   $0x80103990,0x10(%eax)
}
80103958:	89 d8                	mov    %ebx,%eax
8010395a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010395d:	c9                   	leave
8010395e:	c3                   	ret
8010395f:	90                   	nop
  release(&ptable.lock);
80103960:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103963:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103965:	68 20 1d 11 80       	push   $0x80111d20
8010396a:	e8 a1 0e 00 00       	call   80104810 <release>
  return 0;
8010396f:	83 c4 10             	add    $0x10,%esp
}
80103972:	89 d8                	mov    %ebx,%eax
80103974:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103977:	c9                   	leave
80103978:	c3                   	ret
    p->state = UNUSED;
80103979:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103980:	31 db                	xor    %ebx,%ebx
80103982:	eb ee                	jmp    80103972 <allocproc+0xb2>
80103984:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010398b:	00 
8010398c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103990 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103996:	68 20 1d 11 80       	push   $0x80111d20
8010399b:	e8 70 0e 00 00       	call   80104810 <release>

  if (first) {
801039a0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	85 c0                	test   %eax,%eax
801039aa:	75 04                	jne    801039b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039ac:	c9                   	leave
801039ad:	c3                   	ret
801039ae:	66 90                	xchg   %ax,%ax
    first = 0;
801039b0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801039b7:	00 00 00 
    iinit(ROOTDEV);
801039ba:	83 ec 0c             	sub    $0xc,%esp
801039bd:	6a 01                	push   $0x1
801039bf:	e8 0c dc ff ff       	call   801015d0 <iinit>
    initlog(ROOTDEV);
801039c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039cb:	e8 c0 f3 ff ff       	call   80102d90 <initlog>
}
801039d0:	83 c4 10             	add    $0x10,%esp
801039d3:	c9                   	leave
801039d4:	c3                   	ret
801039d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039dc:	00 
801039dd:	8d 76 00             	lea    0x0(%esi),%esi

801039e0 <pinit>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039e6:	68 96 77 10 80       	push   $0x80107796
801039eb:	68 20 1d 11 80       	push   $0x80111d20
801039f0:	e8 6b 0c 00 00       	call   80104660 <initlock>
}
801039f5:	83 c4 10             	add    $0x10,%esp
801039f8:	c9                   	leave
801039f9:	c3                   	ret
801039fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a00 <mycpu>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a05:	9c                   	pushf
80103a06:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a07:	f6 c4 02             	test   $0x2,%ah
80103a0a:	75 46                	jne    80103a52 <mycpu+0x52>
  apicid = lapicid();
80103a0c:	e8 7f ef ff ff       	call   80102990 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a11:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103a17:	85 f6                	test   %esi,%esi
80103a19:	7e 2a                	jle    80103a45 <mycpu+0x45>
80103a1b:	31 d2                	xor    %edx,%edx
80103a1d:	eb 08                	jmp    80103a27 <mycpu+0x27>
80103a1f:	90                   	nop
80103a20:	83 c2 01             	add    $0x1,%edx
80103a23:	39 f2                	cmp    %esi,%edx
80103a25:	74 1e                	je     80103a45 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a27:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a2d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103a34:	39 c3                	cmp    %eax,%ebx
80103a36:	75 e8                	jne    80103a20 <mycpu+0x20>
}
80103a38:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a3b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103a41:	5b                   	pop    %ebx
80103a42:	5e                   	pop    %esi
80103a43:	5d                   	pop    %ebp
80103a44:	c3                   	ret
  panic("unknown apicid\n");
80103a45:	83 ec 0c             	sub    $0xc,%esp
80103a48:	68 9d 77 10 80       	push   $0x8010779d
80103a4d:	e8 4e c9 ff ff       	call   801003a0 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a52:	83 ec 0c             	sub    $0xc,%esp
80103a55:	68 dc 7a 10 80       	push   $0x80107adc
80103a5a:	e8 41 c9 ff ff       	call   801003a0 <panic>
80103a5f:	90                   	nop

80103a60 <cpuid>:
cpuid() {
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a66:	e8 95 ff ff ff       	call   80103a00 <mycpu>
}
80103a6b:	c9                   	leave
  return mycpu()-cpus;
80103a6c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103a71:	c1 f8 04             	sar    $0x4,%eax
80103a74:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a7a:	c3                   	ret
80103a7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a80 <myproc>:
myproc(void) {
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	53                   	push   %ebx
80103a84:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a87:	e8 94 0c 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103a8c:	e8 6f ff ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103a91:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a97:	e8 d4 0c 00 00       	call   80104770 <popcli>
}
80103a9c:	89 d8                	mov    %ebx,%eax
80103a9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aa1:	c9                   	leave
80103aa2:	c3                   	ret
80103aa3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103aaa:	00 
80103aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ab0 <userinit>:
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
80103ab4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ab7:	e8 04 fe ff ff       	call   801038c0 <allocproc>
80103abc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103abe:	a3 54 3d 11 80       	mov    %eax,0x80113d54
  if((p->pgdir = setupkvm()) == 0)
80103ac3:	e8 38 37 00 00       	call   80107200 <setupkvm>
80103ac8:	89 43 04             	mov    %eax,0x4(%ebx)
80103acb:	85 c0                	test   %eax,%eax
80103acd:	0f 84 bd 00 00 00    	je     80103b90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ad3:	83 ec 04             	sub    $0x4,%esp
80103ad6:	68 2c 00 00 00       	push   $0x2c
80103adb:	68 60 a4 10 80       	push   $0x8010a460
80103ae0:	50                   	push   %eax
80103ae1:	e8 fa 33 00 00       	call   80106ee0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ae6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ae9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103aef:	6a 4c                	push   $0x4c
80103af1:	6a 00                	push   $0x0
80103af3:	ff 73 18             	push   0x18(%ebx)
80103af6:	e8 a5 0e 00 00       	call   801049a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103afb:	8b 43 18             	mov    0x18(%ebx),%eax
80103afe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b03:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b06:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b16:	8b 43 18             	mov    0x18(%ebx),%eax
80103b19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b21:	8b 43 18             	mov    0x18(%ebx),%eax
80103b24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b36:	8b 43 18             	mov    0x18(%ebx),%eax
80103b39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b40:	8b 43 18             	mov    0x18(%ebx),%eax
80103b43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b4d:	6a 10                	push   $0x10
80103b4f:	68 c6 77 10 80       	push   $0x801077c6
80103b54:	50                   	push   %eax
80103b55:	e8 06 10 00 00       	call   80104b60 <safestrcpy>
  p->cwd = namei("/");
80103b5a:	c7 04 24 cf 77 10 80 	movl   $0x801077cf,(%esp)
80103b61:	e8 9a e5 ff ff       	call   80102100 <namei>
80103b66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b69:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b70:	e8 fb 0c 00 00       	call   80104870 <acquire>
  p->state = RUNNABLE;
80103b75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b7c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103b83:	e8 88 0c 00 00       	call   80104810 <release>
}
80103b88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b8b:	83 c4 10             	add    $0x10,%esp
80103b8e:	c9                   	leave
80103b8f:	c3                   	ret
    panic("userinit: out of memory?");
80103b90:	83 ec 0c             	sub    $0xc,%esp
80103b93:	68 ad 77 10 80       	push   $0x801077ad
80103b98:	e8 03 c8 ff ff       	call   801003a0 <panic>
80103b9d:	8d 76 00             	lea    0x0(%esi),%esi

80103ba0 <growproc>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
80103ba5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ba8:	e8 73 0b 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103bad:	e8 4e fe ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103bb2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bb8:	e8 b3 0b 00 00       	call   80104770 <popcli>
  sz = curproc->sz;
80103bbd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bbf:	85 f6                	test   %esi,%esi
80103bc1:	7f 1d                	jg     80103be0 <growproc+0x40>
  } else if(n < 0){
80103bc3:	75 3b                	jne    80103c00 <growproc+0x60>
  switchuvm(curproc);
80103bc5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bc8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bca:	53                   	push   %ebx
80103bcb:	e8 00 32 00 00       	call   80106dd0 <switchuvm>
  return 0;
80103bd0:	83 c4 10             	add    $0x10,%esp
80103bd3:	31 c0                	xor    %eax,%eax
}
80103bd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bd8:	5b                   	pop    %ebx
80103bd9:	5e                   	pop    %esi
80103bda:	5d                   	pop    %ebp
80103bdb:	c3                   	ret
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103be0:	83 ec 04             	sub    $0x4,%esp
80103be3:	01 c6                	add    %eax,%esi
80103be5:	56                   	push   %esi
80103be6:	50                   	push   %eax
80103be7:	ff 73 04             	push   0x4(%ebx)
80103bea:	e8 41 34 00 00       	call   80107030 <allocuvm>
80103bef:	83 c4 10             	add    $0x10,%esp
80103bf2:	85 c0                	test   %eax,%eax
80103bf4:	75 cf                	jne    80103bc5 <growproc+0x25>
      return -1;
80103bf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bfb:	eb d8                	jmp    80103bd5 <growproc+0x35>
80103bfd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c00:	83 ec 04             	sub    $0x4,%esp
80103c03:	01 c6                	add    %eax,%esi
80103c05:	56                   	push   %esi
80103c06:	50                   	push   %eax
80103c07:	ff 73 04             	push   0x4(%ebx)
80103c0a:	e8 41 35 00 00       	call   80107150 <deallocuvm>
80103c0f:	83 c4 10             	add    $0x10,%esp
80103c12:	85 c0                	test   %eax,%eax
80103c14:	75 af                	jne    80103bc5 <growproc+0x25>
80103c16:	eb de                	jmp    80103bf6 <growproc+0x56>
80103c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c1f:	00 

80103c20 <fork>:
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	57                   	push   %edi
80103c24:	56                   	push   %esi
80103c25:	53                   	push   %ebx
80103c26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c29:	e8 f2 0a 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103c2e:	e8 cd fd ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103c33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c39:	e8 32 0b 00 00       	call   80104770 <popcli>
  if((np = allocproc()) == 0){
80103c3e:	e8 7d fc ff ff       	call   801038c0 <allocproc>
80103c43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c46:	85 c0                	test   %eax,%eax
80103c48:	0f 84 d6 00 00 00    	je     80103d24 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c4e:	83 ec 08             	sub    $0x8,%esp
80103c51:	ff 33                	push   (%ebx)
80103c53:	89 c7                	mov    %eax,%edi
80103c55:	ff 73 04             	push   0x4(%ebx)
80103c58:	e8 93 36 00 00       	call   801072f0 <copyuvm>
80103c5d:	83 c4 10             	add    $0x10,%esp
80103c60:	89 47 04             	mov    %eax,0x4(%edi)
80103c63:	85 c0                	test   %eax,%eax
80103c65:	0f 84 9a 00 00 00    	je     80103d05 <fork+0xe5>
  np->sz = curproc->sz;
80103c6b:	8b 03                	mov    (%ebx),%eax
80103c6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c75:	89 c8                	mov    %ecx,%eax
80103c77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c86:	8b 40 18             	mov    0x18(%eax),%eax
80103c89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c94:	85 c0                	test   %eax,%eax
80103c96:	74 13                	je     80103cab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c98:	83 ec 0c             	sub    $0xc,%esp
80103c9b:	50                   	push   %eax
80103c9c:	e8 6f d2 ff ff       	call   80100f10 <filedup>
80103ca1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ca4:	83 c4 10             	add    $0x10,%esp
80103ca7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cab:	83 c6 01             	add    $0x1,%esi
80103cae:	83 fe 10             	cmp    $0x10,%esi
80103cb1:	75 dd                	jne    80103c90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103cb3:	83 ec 0c             	sub    $0xc,%esp
80103cb6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cb9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cbc:	e8 ff da ff ff       	call   801017c0 <idup>
80103cc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cc7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cca:	8d 47 6c             	lea    0x6c(%edi),%eax
80103ccd:	6a 10                	push   $0x10
80103ccf:	53                   	push   %ebx
80103cd0:	50                   	push   %eax
80103cd1:	e8 8a 0e 00 00       	call   80104b60 <safestrcpy>
  pid = np->pid;
80103cd6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103cd9:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103ce0:	e8 8b 0b 00 00       	call   80104870 <acquire>
  np->state = RUNNABLE;
80103ce5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103cec:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103cf3:	e8 18 0b 00 00       	call   80104810 <release>
  return pid;
80103cf8:	83 c4 10             	add    $0x10,%esp
}
80103cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cfe:	89 d8                	mov    %ebx,%eax
80103d00:	5b                   	pop    %ebx
80103d01:	5e                   	pop    %esi
80103d02:	5f                   	pop    %edi
80103d03:	5d                   	pop    %ebp
80103d04:	c3                   	ret
    kfree(np->kstack);
80103d05:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d08:	83 ec 0c             	sub    $0xc,%esp
80103d0b:	ff 73 08             	push   0x8(%ebx)
80103d0e:	e8 2d e8 ff ff       	call   80102540 <kfree>
    np->kstack = 0;
80103d13:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d1a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d1d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d24:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d29:	eb d0                	jmp    80103cfb <fork+0xdb>
80103d2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103d30 <scheduler>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	57                   	push   %edi
80103d34:	56                   	push   %esi
80103d35:	53                   	push   %ebx
80103d36:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d39:	e8 c2 fc ff ff       	call   80103a00 <mycpu>
  c->proc = 0;
80103d3e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d45:	00 00 00 
  struct cpu *c = mycpu();
80103d48:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d4a:	8d 78 04             	lea    0x4(%eax),%edi
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d50:	fb                   	sti
    acquire(&ptable.lock);
80103d51:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d54:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103d59:	68 20 1d 11 80       	push   $0x80111d20
80103d5e:	e8 0d 0b 00 00       	call   80104870 <acquire>
80103d63:	83 c4 10             	add    $0x10,%esp
80103d66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d6d:	00 
80103d6e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103d70:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d74:	75 33                	jne    80103da9 <scheduler+0x79>
      switchuvm(p);
80103d76:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d79:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d7f:	53                   	push   %ebx
80103d80:	e8 4b 30 00 00       	call   80106dd0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d85:	58                   	pop    %eax
80103d86:	5a                   	pop    %edx
80103d87:	ff 73 1c             	push   0x1c(%ebx)
80103d8a:	57                   	push   %edi
      p->state = RUNNING;
80103d8b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d92:	e8 24 0e 00 00       	call   80104bbb <swtch>
      switchkvm();
80103d97:	e8 24 30 00 00       	call   80106dc0 <switchkvm>
      c->proc = 0;
80103d9c:	83 c4 10             	add    $0x10,%esp
80103d9f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103da6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da9:	83 eb 80             	sub    $0xffffff80,%ebx
80103dac:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80103db2:	75 bc                	jne    80103d70 <scheduler+0x40>
    release(&ptable.lock);
80103db4:	83 ec 0c             	sub    $0xc,%esp
80103db7:	68 20 1d 11 80       	push   $0x80111d20
80103dbc:	e8 4f 0a 00 00       	call   80104810 <release>
    sti();
80103dc1:	83 c4 10             	add    $0x10,%esp
80103dc4:	eb 8a                	jmp    80103d50 <scheduler+0x20>
80103dc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dcd:	00 
80103dce:	66 90                	xchg   %ax,%ax

80103dd0 <sched>:
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
  pushcli();
80103dd5:	e8 46 09 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103dda:	e8 21 fc ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103ddf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103de5:	e8 86 09 00 00       	call   80104770 <popcli>
  if(!holding(&ptable.lock))
80103dea:	83 ec 0c             	sub    $0xc,%esp
80103ded:	68 20 1d 11 80       	push   $0x80111d20
80103df2:	e8 d9 09 00 00       	call   801047d0 <holding>
80103df7:	83 c4 10             	add    $0x10,%esp
80103dfa:	85 c0                	test   %eax,%eax
80103dfc:	74 4f                	je     80103e4d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dfe:	e8 fd fb ff ff       	call   80103a00 <mycpu>
80103e03:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e0a:	75 68                	jne    80103e74 <sched+0xa4>
  if(p->state == RUNNING)
80103e0c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e10:	74 55                	je     80103e67 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e12:	9c                   	pushf
80103e13:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e14:	f6 c4 02             	test   $0x2,%ah
80103e17:	75 41                	jne    80103e5a <sched+0x8a>
  intena = mycpu()->intena;
80103e19:	e8 e2 fb ff ff       	call   80103a00 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e1e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e21:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e27:	e8 d4 fb ff ff       	call   80103a00 <mycpu>
80103e2c:	83 ec 08             	sub    $0x8,%esp
80103e2f:	ff 70 04             	push   0x4(%eax)
80103e32:	53                   	push   %ebx
80103e33:	e8 83 0d 00 00       	call   80104bbb <swtch>
  mycpu()->intena = intena;
80103e38:	e8 c3 fb ff ff       	call   80103a00 <mycpu>
}
80103e3d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e40:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e49:	5b                   	pop    %ebx
80103e4a:	5e                   	pop    %esi
80103e4b:	5d                   	pop    %ebp
80103e4c:	c3                   	ret
    panic("sched ptable.lock");
80103e4d:	83 ec 0c             	sub    $0xc,%esp
80103e50:	68 d1 77 10 80       	push   $0x801077d1
80103e55:	e8 46 c5 ff ff       	call   801003a0 <panic>
    panic("sched interruptible");
80103e5a:	83 ec 0c             	sub    $0xc,%esp
80103e5d:	68 fd 77 10 80       	push   $0x801077fd
80103e62:	e8 39 c5 ff ff       	call   801003a0 <panic>
    panic("sched running");
80103e67:	83 ec 0c             	sub    $0xc,%esp
80103e6a:	68 ef 77 10 80       	push   $0x801077ef
80103e6f:	e8 2c c5 ff ff       	call   801003a0 <panic>
    panic("sched locks");
80103e74:	83 ec 0c             	sub    $0xc,%esp
80103e77:	68 e3 77 10 80       	push   $0x801077e3
80103e7c:	e8 1f c5 ff ff       	call   801003a0 <panic>
80103e81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e88:	00 
80103e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e90 <exit>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e99:	e8 e2 fb ff ff       	call   80103a80 <myproc>
  if(curproc == initproc)
80103e9e:	39 05 54 3d 11 80    	cmp    %eax,0x80113d54
80103ea4:	0f 84 0d 01 00 00    	je     80103fb7 <exit+0x127>
80103eaa:	89 c3                	mov    %eax,%ebx
80103eac:	8d 70 28             	lea    0x28(%eax),%esi
80103eaf:	8d 78 68             	lea    0x68(%eax),%edi
80103eb2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103eb9:	00 
80103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ec0:	8b 06                	mov    (%esi),%eax
80103ec2:	85 c0                	test   %eax,%eax
80103ec4:	74 12                	je     80103ed8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103ec6:	83 ec 0c             	sub    $0xc,%esp
80103ec9:	50                   	push   %eax
80103eca:	e8 91 d0 ff ff       	call   80100f60 <fileclose>
      curproc->ofile[fd] = 0;
80103ecf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ed5:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ed8:	83 c6 04             	add    $0x4,%esi
80103edb:	39 f7                	cmp    %esi,%edi
80103edd:	75 e1                	jne    80103ec0 <exit+0x30>
  begin_op();
80103edf:	e8 5c ef ff ff       	call   80102e40 <begin_op>
  iput(curproc->cwd);
80103ee4:	83 ec 0c             	sub    $0xc,%esp
80103ee7:	ff 73 68             	push   0x68(%ebx)
80103eea:	e8 31 da ff ff       	call   80101920 <iput>
  end_op();
80103eef:	e8 bc ef ff ff       	call   80102eb0 <end_op>
  curproc->cwd = 0;
80103ef4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103efb:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103f02:	e8 69 09 00 00       	call   80104870 <acquire>
  wakeup1(curproc->parent);
80103f07:	8b 53 14             	mov    0x14(%ebx),%edx
80103f0a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f0d:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f12:	eb 16                	jmp    80103f2a <exit+0x9a>
80103f14:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f1b:	00 
80103f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f20:	83 e8 80             	sub    $0xffffff80,%eax
80103f23:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103f28:	74 1c                	je     80103f46 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103f2a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f2e:	75 f0                	jne    80103f20 <exit+0x90>
80103f30:	3b 50 20             	cmp    0x20(%eax),%edx
80103f33:	75 eb                	jne    80103f20 <exit+0x90>
      p->state = RUNNABLE;
80103f35:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f3c:	83 e8 80             	sub    $0xffffff80,%eax
80103f3f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103f44:	75 e4                	jne    80103f2a <exit+0x9a>
      p->parent = initproc;
80103f46:	8b 0d 54 3d 11 80    	mov    0x80113d54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f4c:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103f51:	eb 18                	jmp    80103f6b <exit+0xdb>
80103f53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f5a:	00 
80103f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f60:	83 ea 80             	sub    $0xffffff80,%edx
80103f63:	81 fa 54 3d 11 80    	cmp    $0x80113d54,%edx
80103f69:	74 33                	je     80103f9e <exit+0x10e>
    if(p->parent == curproc){
80103f6b:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f6e:	75 f0                	jne    80103f60 <exit+0xd0>
      if(p->state == ZOMBIE)
80103f70:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f74:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f77:	75 e7                	jne    80103f60 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f79:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103f7e:	eb 0a                	jmp    80103f8a <exit+0xfa>
80103f80:	83 e8 80             	sub    $0xffffff80,%eax
80103f83:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80103f88:	74 d6                	je     80103f60 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103f8a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f8e:	75 f0                	jne    80103f80 <exit+0xf0>
80103f90:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f93:	75 eb                	jne    80103f80 <exit+0xf0>
      p->state = RUNNABLE;
80103f95:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f9c:	eb e2                	jmp    80103f80 <exit+0xf0>
  curproc->state = ZOMBIE;
80103f9e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103fa5:	e8 26 fe ff ff       	call   80103dd0 <sched>
  panic("zombie exit");
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 1e 78 10 80       	push   $0x8010781e
80103fb2:	e8 e9 c3 ff ff       	call   801003a0 <panic>
    panic("init exiting");
80103fb7:	83 ec 0c             	sub    $0xc,%esp
80103fba:	68 11 78 10 80       	push   $0x80107811
80103fbf:	e8 dc c3 ff ff       	call   801003a0 <panic>
80103fc4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fcb:	00 
80103fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103fd0 <wait>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
  pushcli();
80103fd5:	e8 46 07 00 00       	call   80104720 <pushcli>
  c = mycpu();
80103fda:	e8 21 fa ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103fdf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fe5:	e8 86 07 00 00       	call   80104770 <popcli>
  acquire(&ptable.lock);
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 20 1d 11 80       	push   $0x80111d20
80103ff2:	e8 79 08 00 00       	call   80104870 <acquire>
80103ff7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103ffa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffc:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80104001:	eb 18                	jmp    8010401b <wait+0x4b>
80104003:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010400a:	00 
8010400b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104010:	83 eb 80             	sub    $0xffffff80,%ebx
80104013:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80104019:	74 1b                	je     80104036 <wait+0x66>
      if(p->parent != curproc)
8010401b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010401e:	75 f0                	jne    80104010 <wait+0x40>
      if(p->state == ZOMBIE){
80104020:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104024:	74 62                	je     80104088 <wait+0xb8>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104026:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104029:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402e:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80104034:	75 e5                	jne    8010401b <wait+0x4b>
    if(!havekids || curproc->killed){
80104036:	85 c0                	test   %eax,%eax
80104038:	0f 84 a0 00 00 00    	je     801040de <wait+0x10e>
8010403e:	8b 46 24             	mov    0x24(%esi),%eax
80104041:	85 c0                	test   %eax,%eax
80104043:	0f 85 95 00 00 00    	jne    801040de <wait+0x10e>
  pushcli();
80104049:	e8 d2 06 00 00       	call   80104720 <pushcli>
  c = mycpu();
8010404e:	e8 ad f9 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80104053:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104059:	e8 12 07 00 00       	call   80104770 <popcli>
  if(p == 0)
8010405e:	85 db                	test   %ebx,%ebx
80104060:	0f 84 8f 00 00 00    	je     801040f5 <wait+0x125>
  p->chan = chan;
80104066:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104069:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104070:	e8 5b fd ff ff       	call   80103dd0 <sched>
  p->chan = 0;
80104075:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010407c:	e9 79 ff ff ff       	jmp    80103ffa <wait+0x2a>
80104081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104088:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
8010408b:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
8010408e:	ff 73 08             	push   0x8(%ebx)
80104091:	e8 aa e4 ff ff       	call   80102540 <kfree>
        p->kstack = 0;
80104096:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010409d:	5a                   	pop    %edx
8010409e:	ff 73 04             	push   0x4(%ebx)
801040a1:	e8 da 30 00 00       	call   80107180 <freevm>
        p->pid = 0;
801040a6:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040ad:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040b4:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040b8:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040bf:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040c6:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040cd:	e8 3e 07 00 00       	call   80104810 <release>
        return pid;
801040d2:	83 c4 10             	add    $0x10,%esp
}
801040d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040d8:	89 f0                	mov    %esi,%eax
801040da:	5b                   	pop    %ebx
801040db:	5e                   	pop    %esi
801040dc:	5d                   	pop    %ebp
801040dd:	c3                   	ret
      release(&ptable.lock);
801040de:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040e1:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040e6:	68 20 1d 11 80       	push   $0x80111d20
801040eb:	e8 20 07 00 00       	call   80104810 <release>
      return -1;
801040f0:	83 c4 10             	add    $0x10,%esp
801040f3:	eb e0                	jmp    801040d5 <wait+0x105>
    panic("sleep");
801040f5:	83 ec 0c             	sub    $0xc,%esp
801040f8:	68 2a 78 10 80       	push   $0x8010782a
801040fd:	e8 9e c2 ff ff       	call   801003a0 <panic>
80104102:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104109:	00 
8010410a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104110 <yield>:
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104117:	68 20 1d 11 80       	push   $0x80111d20
8010411c:	e8 4f 07 00 00       	call   80104870 <acquire>
  pushcli();
80104121:	e8 fa 05 00 00       	call   80104720 <pushcli>
  c = mycpu();
80104126:	e8 d5 f8 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
8010412b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104131:	e8 3a 06 00 00       	call   80104770 <popcli>
  myproc()->state = RUNNABLE;
80104136:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010413d:	e8 8e fc ff ff       	call   80103dd0 <sched>
  release(&ptable.lock);
80104142:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104149:	e8 c2 06 00 00       	call   80104810 <release>
}
8010414e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104151:	83 c4 10             	add    $0x10,%esp
80104154:	c9                   	leave
80104155:	c3                   	ret
80104156:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010415d:	00 
8010415e:	66 90                	xchg   %ax,%ax

80104160 <sleep>:
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	57                   	push   %edi
80104164:	56                   	push   %esi
80104165:	53                   	push   %ebx
80104166:	83 ec 0c             	sub    $0xc,%esp
80104169:	8b 7d 08             	mov    0x8(%ebp),%edi
8010416c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010416f:	e8 ac 05 00 00       	call   80104720 <pushcli>
  c = mycpu();
80104174:	e8 87 f8 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80104179:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010417f:	e8 ec 05 00 00       	call   80104770 <popcli>
  if(p == 0)
80104184:	85 db                	test   %ebx,%ebx
80104186:	0f 84 87 00 00 00    	je     80104213 <sleep+0xb3>
  if(lk == 0)
8010418c:	85 f6                	test   %esi,%esi
8010418e:	74 76                	je     80104206 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104190:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104196:	74 50                	je     801041e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	68 20 1d 11 80       	push   $0x80111d20
801041a0:	e8 cb 06 00 00       	call   80104870 <acquire>
    release(lk);
801041a5:	89 34 24             	mov    %esi,(%esp)
801041a8:	e8 63 06 00 00       	call   80104810 <release>
  p->chan = chan;
801041ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041b7:	e8 14 fc ff ff       	call   80103dd0 <sched>
  p->chan = 0;
801041bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041c3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801041ca:	e8 41 06 00 00       	call   80104810 <release>
    acquire(lk);
801041cf:	83 c4 10             	add    $0x10,%esp
801041d2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041d8:	5b                   	pop    %ebx
801041d9:	5e                   	pop    %esi
801041da:	5f                   	pop    %edi
801041db:	5d                   	pop    %ebp
    acquire(lk);
801041dc:	e9 8f 06 00 00       	jmp    80104870 <acquire>
801041e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801041e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041f2:	e8 d9 fb ff ff       	call   80103dd0 <sched>
  p->chan = 0;
801041f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104201:	5b                   	pop    %ebx
80104202:	5e                   	pop    %esi
80104203:	5f                   	pop    %edi
80104204:	5d                   	pop    %ebp
80104205:	c3                   	ret
    panic("sleep without lk");
80104206:	83 ec 0c             	sub    $0xc,%esp
80104209:	68 30 78 10 80       	push   $0x80107830
8010420e:	e8 8d c1 ff ff       	call   801003a0 <panic>
    panic("sleep");
80104213:	83 ec 0c             	sub    $0xc,%esp
80104216:	68 2a 78 10 80       	push   $0x8010782a
8010421b:	e8 80 c1 ff ff       	call   801003a0 <panic>

80104220 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 10             	sub    $0x10,%esp
80104227:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010422a:	68 20 1d 11 80       	push   $0x80111d20
8010422f:	e8 3c 06 00 00       	call   80104870 <acquire>
80104234:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104237:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010423c:	eb 0c                	jmp    8010424a <wakeup+0x2a>
8010423e:	66 90                	xchg   %ax,%ax
80104240:	83 e8 80             	sub    $0xffffff80,%eax
80104243:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104248:	74 1c                	je     80104266 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010424a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010424e:	75 f0                	jne    80104240 <wakeup+0x20>
80104250:	3b 58 20             	cmp    0x20(%eax),%ebx
80104253:	75 eb                	jne    80104240 <wakeup+0x20>
      p->state = RUNNABLE;
80104255:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010425c:	83 e8 80             	sub    $0xffffff80,%eax
8010425f:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104264:	75 e4                	jne    8010424a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104266:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
8010426d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104270:	c9                   	leave
  release(&ptable.lock);
80104271:	e9 9a 05 00 00       	jmp    80104810 <release>
80104276:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010427d:	00 
8010427e:	66 90                	xchg   %ax,%ax

80104280 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	53                   	push   %ebx
80104284:	83 ec 10             	sub    $0x10,%esp
80104287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010428a:	68 20 1d 11 80       	push   $0x80111d20
8010428f:	e8 dc 05 00 00       	call   80104870 <acquire>
80104294:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104297:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010429c:	eb 0c                	jmp    801042aa <kill+0x2a>
8010429e:	66 90                	xchg   %ax,%ax
801042a0:	83 e8 80             	sub    $0xffffff80,%eax
801042a3:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
801042a8:	74 36                	je     801042e0 <kill+0x60>
    if(p->pid == pid){
801042aa:	39 58 10             	cmp    %ebx,0x10(%eax)
801042ad:	75 f1                	jne    801042a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042af:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042ba:	75 07                	jne    801042c3 <kill+0x43>
        p->state = RUNNABLE;
801042bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042c3:	83 ec 0c             	sub    $0xc,%esp
801042c6:	68 20 1d 11 80       	push   $0x80111d20
801042cb:	e8 40 05 00 00       	call   80104810 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042d3:	83 c4 10             	add    $0x10,%esp
801042d6:	31 c0                	xor    %eax,%eax
}
801042d8:	c9                   	leave
801042d9:	c3                   	ret
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801042e0:	83 ec 0c             	sub    $0xc,%esp
801042e3:	68 20 1d 11 80       	push   $0x80111d20
801042e8:	e8 23 05 00 00       	call   80104810 <release>
}
801042ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801042f0:	83 c4 10             	add    $0x10,%esp
801042f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042f8:	c9                   	leave
801042f9:	c3                   	ret
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104300 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	56                   	push   %esi
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104305:	8d 75 c0             	lea    -0x40(%ebp),%esi
{
80104308:	53                   	push   %ebx
80104309:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010430e:	83 ec 3c             	sub    $0x3c,%esp
80104311:	eb 24                	jmp    80104337 <procdump+0x37>
80104313:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	68 ef 79 10 80       	push   $0x801079ef
80104320:	e8 ab c3 ff ff       	call   801006d0 <cprintf>
80104325:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104328:	83 eb 80             	sub    $0xffffff80,%ebx
8010432b:	81 fb c0 3d 11 80    	cmp    $0x80113dc0,%ebx
80104331:	0f 84 89 00 00 00    	je     801043c0 <procdump+0xc0>
    if(p->state == UNUSED)
80104337:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010433a:	85 c0                	test   %eax,%eax
8010433c:	74 ea                	je     80104328 <procdump+0x28>
      state = "???";
8010433e:	ba 41 78 10 80       	mov    $0x80107841,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104343:	83 f8 05             	cmp    $0x5,%eax
80104346:	77 11                	ja     80104359 <procdump+0x59>
80104348:	8b 14 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%edx
      state = "???";
8010434f:	b8 41 78 10 80       	mov    $0x80107841,%eax
80104354:	85 d2                	test   %edx,%edx
80104356:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104359:	53                   	push   %ebx
8010435a:	52                   	push   %edx
8010435b:	ff 73 a4             	push   -0x5c(%ebx)
8010435e:	68 45 78 10 80       	push   $0x80107845
80104363:	e8 68 c3 ff ff       	call   801006d0 <cprintf>
    if(p->state == SLEEPING){
80104368:	83 c4 10             	add    $0x10,%esp
8010436b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010436f:	75 a7                	jne    80104318 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104371:	83 ec 08             	sub    $0x8,%esp
80104374:	89 f7                	mov    %esi,%edi
80104376:	56                   	push   %esi
80104377:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010437a:	8b 40 0c             	mov    0xc(%eax),%eax
8010437d:	83 c0 08             	add    $0x8,%eax
80104380:	50                   	push   %eax
80104381:	e8 fa 02 00 00       	call   80104680 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104386:	83 c4 10             	add    $0x10,%esp
80104389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104390:	8b 07                	mov    (%edi),%eax
80104392:	85 c0                	test   %eax,%eax
80104394:	74 82                	je     80104318 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104396:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104399:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010439c:	50                   	push   %eax
8010439d:	68 81 75 10 80       	push   $0x80107581
801043a2:	e8 29 c3 ff ff       	call   801006d0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043a7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801043aa:	83 c4 10             	add    $0x10,%esp
801043ad:	39 c7                	cmp    %eax,%edi
801043af:	75 df                	jne    80104390 <procdump+0x90>
801043b1:	e9 62 ff ff ff       	jmp    80104318 <procdump+0x18>
801043b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043bd:	00 
801043be:	66 90                	xchg   %ax,%ax
  }
}
801043c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043c3:	5b                   	pop    %ebx
801043c4:	5e                   	pop    %esi
801043c5:	5f                   	pop    %edi
801043c6:	5d                   	pop    %ebp
801043c7:	c3                   	ret
801043c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043cf:	00 

801043d0 <getNumProc>:

int 
getNumProc(void){
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	53                   	push   %ebx
  struct proc *p;
  int count = 0;
801043d4:	31 db                	xor    %ebx,%ebx
getNumProc(void){
801043d6:	83 ec 10             	sub    $0x10,%esp
  
  // Acquire the ptable lock before accessing
  acquire(&ptable.lock);
801043d9:	68 20 1d 11 80       	push   $0x80111d20
801043de:	e8 8d 04 00 00       	call   80104870 <acquire>
801043e3:	83 c4 10             	add    $0x10,%esp
  
  // Iterate through the process table
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043e6:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801043eb:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043f2:	00 
801043f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043fa:	00 
801043fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    // Count if process exists (state is not UNUSED)
    if(p->state != UNUSED)
      count++;
80104400:	83 78 0c 01          	cmpl   $0x1,0xc(%eax)
80104404:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104407:	83 e8 80             	sub    $0xffffff80,%eax
8010440a:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
8010440f:	75 ef                	jne    80104400 <getNumProc+0x30>
  }
  
  // Release the lock after we're done
  release(&ptable.lock);
80104411:	83 ec 0c             	sub    $0xc,%esp
80104414:	68 20 1d 11 80       	push   $0x80111d20
80104419:	e8 f2 03 00 00       	call   80104810 <release>
  
  return count;
}
8010441e:	89 d8                	mov    %ebx,%eax
80104420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104423:	c9                   	leave
80104424:	c3                   	ret
80104425:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010442c:	00 
8010442d:	8d 76 00             	lea    0x0(%esi),%esi

80104430 <getMaxPid>:

int 
getMaxPid(void) {
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	53                   	push   %ebx
  struct proc *p;
  int max_pid = 0;
80104434:	31 db                	xor    %ebx,%ebx
getMaxPid(void) {
80104436:	83 ec 10             	sub    $0x10,%esp

  acquire(&ptable.lock);
80104439:	68 20 1d 11 80       	push   $0x80111d20
8010443e:	e8 2d 04 00 00       	call   80104870 <acquire>
80104443:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104446:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010444b:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104452:	00 
80104453:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010445a:	00 
8010445b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state != UNUSED && p->pid > max_pid) {
80104460:	8b 50 0c             	mov    0xc(%eax),%edx
80104463:	85 d2                	test   %edx,%edx
80104465:	74 08                	je     8010446f <getMaxPid+0x3f>
80104467:	8b 50 10             	mov    0x10(%eax),%edx
8010446a:	39 d3                	cmp    %edx,%ebx
8010446c:	0f 4c da             	cmovl  %edx,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010446f:	83 e8 80             	sub    $0xffffff80,%eax
80104472:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
80104477:	75 e7                	jne    80104460 <getMaxPid+0x30>
      max_pid = p->pid;
    }
  }
  release(&ptable.lock);
80104479:	83 ec 0c             	sub    $0xc,%esp
8010447c:	68 20 1d 11 80       	push   $0x80111d20
80104481:	e8 8a 03 00 00       	call   80104810 <release>

  return max_pid;
}
80104486:	89 d8                	mov    %ebx,%eax
80104488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010448b:	c9                   	leave
8010448c:	c3                   	ret
8010448d:	8d 76 00             	lea    0x0(%esi),%esi

80104490 <getProcInfo>:

int 
getProcInfo(int pid, struct processInfo* proc_info) {
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104498:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p;
  int found = 0;

  acquire(&ptable.lock);
8010449b:	83 ec 0c             	sub    $0xc,%esp
8010449e:	68 20 1d 11 80       	push   $0x80111d20
801044a3:	e8 c8 03 00 00       	call   80104870 <acquire>
801044a8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801044ab:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801044b0:	eb 18                	jmp    801044ca <getProcInfo+0x3a>
801044b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044b9:	00 
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044c0:	83 e8 80             	sub    $0xffffff80,%eax
801044c3:	3d 54 3d 11 80       	cmp    $0x80113d54,%eax
801044c8:	74 36                	je     80104500 <getProcInfo+0x70>
    if(p->pid == pid) {
801044ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801044cd:	75 f1                	jne    801044c0 <getProcInfo+0x30>
      proc_info->ppid = p->parent ? p->parent->pid : 0;
801044cf:	8b 48 14             	mov    0x14(%eax),%ecx
801044d2:	31 d2                	xor    %edx,%edx
801044d4:	85 c9                	test   %ecx,%ecx
801044d6:	74 03                	je     801044db <getProcInfo+0x4b>
801044d8:	8b 51 10             	mov    0x10(%ecx),%edx
801044db:	89 56 04             	mov    %edx,0x4(%esi)
      proc_info->state = p->state;
801044de:	8b 40 0c             	mov    0xc(%eax),%eax
      found = 1;
      break;
    }
  }
  release(&ptable.lock);
801044e1:	83 ec 0c             	sub    $0xc,%esp
      proc_info->state = p->state;
801044e4:	89 06                	mov    %eax,(%esi)
  release(&ptable.lock);
801044e6:	68 20 1d 11 80       	push   $0x80111d20
801044eb:	e8 20 03 00 00       	call   80104810 <release>
801044f0:	83 c4 10             	add    $0x10,%esp

  return found ? 0 : -1; // Return 0 on success, -1 if the process was not found
}
801044f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return found ? 0 : -1; // Return 0 on success, -1 if the process was not found
801044f6:	31 c0                	xor    %eax,%eax
}
801044f8:	5b                   	pop    %ebx
801044f9:	5e                   	pop    %esi
801044fa:	5d                   	pop    %ebp
801044fb:	c3                   	ret
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	68 20 1d 11 80       	push   $0x80111d20
80104508:	e8 03 03 00 00       	call   80104810 <release>
8010450d:	83 c4 10             	add    $0x10,%esp
}
80104510:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return found ? 0 : -1; // Return 0 on success, -1 if the process was not found
80104513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104518:	5b                   	pop    %ebx
80104519:	5e                   	pop    %esi
8010451a:	5d                   	pop    %ebp
8010451b:	c3                   	ret
8010451c:	66 90                	xchg   %ax,%ax
8010451e:	66 90                	xchg   %ax,%ax

80104520 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 0c             	sub    $0xc,%esp
80104527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010452a:	68 78 78 10 80       	push   $0x80107878
8010452f:	8d 43 04             	lea    0x4(%ebx),%eax
80104532:	50                   	push   %eax
80104533:	e8 28 01 00 00       	call   80104660 <initlock>
  lk->name = name;
80104538:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010453b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104541:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104544:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010454b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010454e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104551:	c9                   	leave
80104552:	c3                   	ret
80104553:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010455a:	00 
8010455b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104560 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104568:	8d 73 04             	lea    0x4(%ebx),%esi
8010456b:	83 ec 0c             	sub    $0xc,%esp
8010456e:	56                   	push   %esi
8010456f:	e8 fc 02 00 00       	call   80104870 <acquire>
  while (lk->locked) {
80104574:	8b 13                	mov    (%ebx),%edx
80104576:	83 c4 10             	add    $0x10,%esp
80104579:	85 d2                	test   %edx,%edx
8010457b:	74 16                	je     80104593 <acquiresleep+0x33>
8010457d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104580:	83 ec 08             	sub    $0x8,%esp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	e8 d6 fb ff ff       	call   80104160 <sleep>
  while (lk->locked) {
8010458a:	8b 03                	mov    (%ebx),%eax
8010458c:	83 c4 10             	add    $0x10,%esp
8010458f:	85 c0                	test   %eax,%eax
80104591:	75 ed                	jne    80104580 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104593:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104599:	e8 e2 f4 ff ff       	call   80103a80 <myproc>
8010459e:	8b 40 10             	mov    0x10(%eax),%eax
801045a1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045a4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045aa:	5b                   	pop    %ebx
801045ab:	5e                   	pop    %esi
801045ac:	5d                   	pop    %ebp
  release(&lk->lk);
801045ad:	e9 5e 02 00 00       	jmp    80104810 <release>
801045b2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801045b9:	00 
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045c8:	8d 73 04             	lea    0x4(%ebx),%esi
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	56                   	push   %esi
801045cf:	e8 9c 02 00 00       	call   80104870 <acquire>
  lk->locked = 0;
801045d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045da:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045e1:	89 1c 24             	mov    %ebx,(%esp)
801045e4:	e8 37 fc ff ff       	call   80104220 <wakeup>
  release(&lk->lk);
801045e9:	83 c4 10             	add    $0x10,%esp
801045ec:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f2:	5b                   	pop    %ebx
801045f3:	5e                   	pop    %esi
801045f4:	5d                   	pop    %ebp
  release(&lk->lk);
801045f5:	e9 16 02 00 00       	jmp    80104810 <release>
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104600 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	31 ff                	xor    %edi,%edi
80104606:	56                   	push   %esi
80104607:	53                   	push   %ebx
80104608:	83 ec 18             	sub    $0x18,%esp
8010460b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010460e:	8d 73 04             	lea    0x4(%ebx),%esi
80104611:	56                   	push   %esi
80104612:	e8 59 02 00 00       	call   80104870 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104617:	8b 03                	mov    (%ebx),%eax
80104619:	83 c4 10             	add    $0x10,%esp
8010461c:	85 c0                	test   %eax,%eax
8010461e:	75 18                	jne    80104638 <holdingsleep+0x38>
  release(&lk->lk);
80104620:	83 ec 0c             	sub    $0xc,%esp
80104623:	56                   	push   %esi
80104624:	e8 e7 01 00 00       	call   80104810 <release>
  return r;
}
80104629:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010462c:	89 f8                	mov    %edi,%eax
8010462e:	5b                   	pop    %ebx
8010462f:	5e                   	pop    %esi
80104630:	5f                   	pop    %edi
80104631:	5d                   	pop    %ebp
80104632:	c3                   	ret
80104633:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104638:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010463b:	e8 40 f4 ff ff       	call   80103a80 <myproc>
80104640:	39 58 10             	cmp    %ebx,0x10(%eax)
80104643:	0f 94 c0             	sete   %al
80104646:	0f b6 c0             	movzbl %al,%eax
80104649:	89 c7                	mov    %eax,%edi
8010464b:	eb d3                	jmp    80104620 <holdingsleep+0x20>
8010464d:	66 90                	xchg   %ax,%ax
8010464f:	66 90                	xchg   %ax,%ax
80104651:	66 90                	xchg   %ax,%ax
80104653:	66 90                	xchg   %ax,%ax
80104655:	66 90                	xchg   %ax,%ax
80104657:	66 90                	xchg   %ax,%ax
80104659:	66 90                	xchg   %ax,%ax
8010465b:	66 90                	xchg   %ax,%ax
8010465d:	66 90                	xchg   %ax,%ax
8010465f:	90                   	nop

80104660 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104666:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010466f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104672:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104679:	5d                   	pop    %ebp
8010467a:	c3                   	ret
8010467b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104680 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104680:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104681:	31 d2                	xor    %edx,%edx
{
80104683:	89 e5                	mov    %esp,%ebp
80104685:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104686:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010468c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010468f:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104696:	00 
80104697:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010469e:	00 
8010469f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046a0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046ac:	77 1a                	ja     801046c8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046ae:	8b 58 04             	mov    0x4(%eax),%ebx
801046b1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046b4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046b7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046b9:	83 fa 0a             	cmp    $0xa,%edx
801046bc:	75 e2                	jne    801046a0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046c1:	c9                   	leave
801046c2:	c3                   	ret
801046c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801046c8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046cb:	83 c1 28             	add    $0x28,%ecx
801046ce:	89 ca                	mov    %ecx,%edx
801046d0:	29 c2                	sub    %eax,%edx
801046d2:	83 e2 04             	and    $0x4,%edx
801046d5:	74 29                	je     80104700 <getcallerpcs+0x80>
    pcs[i] = 0;
801046d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801046dd:	83 c0 04             	add    $0x4,%eax
801046e0:	39 c8                	cmp    %ecx,%eax
801046e2:	74 da                	je     801046be <getcallerpcs+0x3e>
801046e4:	eb 1a                	jmp    80104700 <getcallerpcs+0x80>
801046e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046ed:	00 
801046ee:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046f5:	00 
801046f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046fd:	00 
801046fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104706:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104709:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104710:	39 c8                	cmp    %ecx,%eax
80104712:	75 ec                	jne    80104700 <getcallerpcs+0x80>
80104714:	eb a8                	jmp    801046be <getcallerpcs+0x3e>
80104716:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010471d:	00 
8010471e:	66 90                	xchg   %ax,%ax

80104720 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
80104727:	9c                   	pushf
80104728:	5b                   	pop    %ebx
  asm volatile("cli");
80104729:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010472a:	e8 d1 f2 ff ff       	call   80103a00 <mycpu>
8010472f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104735:	85 c0                	test   %eax,%eax
80104737:	74 17                	je     80104750 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104739:	e8 c2 f2 ff ff       	call   80103a00 <mycpu>
8010473e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104745:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104748:	c9                   	leave
80104749:	c3                   	ret
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104750:	e8 ab f2 ff ff       	call   80103a00 <mycpu>
80104755:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010475b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104761:	eb d6                	jmp    80104739 <pushcli+0x19>
80104763:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010476a:	00 
8010476b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104770 <popcli>:

void
popcli(void)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104776:	9c                   	pushf
80104777:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104778:	f6 c4 02             	test   $0x2,%ah
8010477b:	75 35                	jne    801047b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010477d:	e8 7e f2 ff ff       	call   80103a00 <mycpu>
80104782:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104789:	78 34                	js     801047bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010478b:	e8 70 f2 ff ff       	call   80103a00 <mycpu>
80104790:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104796:	85 d2                	test   %edx,%edx
80104798:	74 06                	je     801047a0 <popcli+0x30>
    sti();
}
8010479a:	c9                   	leave
8010479b:	c3                   	ret
8010479c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047a0:	e8 5b f2 ff ff       	call   80103a00 <mycpu>
801047a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047ab:	85 c0                	test   %eax,%eax
801047ad:	74 eb                	je     8010479a <popcli+0x2a>
  asm volatile("sti");
801047af:	fb                   	sti
}
801047b0:	c9                   	leave
801047b1:	c3                   	ret
    panic("popcli - interruptible");
801047b2:	83 ec 0c             	sub    $0xc,%esp
801047b5:	68 83 78 10 80       	push   $0x80107883
801047ba:	e8 e1 bb ff ff       	call   801003a0 <panic>
    panic("popcli");
801047bf:	83 ec 0c             	sub    $0xc,%esp
801047c2:	68 9a 78 10 80       	push   $0x8010789a
801047c7:	e8 d4 bb ff ff       	call   801003a0 <panic>
801047cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047d0 <holding>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	53                   	push   %ebx
801047d5:	8b 75 08             	mov    0x8(%ebp),%esi
801047d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047da:	e8 41 ff ff ff       	call   80104720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047df:	8b 06                	mov    (%esi),%eax
801047e1:	85 c0                	test   %eax,%eax
801047e3:	75 0b                	jne    801047f0 <holding+0x20>
  popcli();
801047e5:	e8 86 ff ff ff       	call   80104770 <popcli>
}
801047ea:	89 d8                	mov    %ebx,%eax
801047ec:	5b                   	pop    %ebx
801047ed:	5e                   	pop    %esi
801047ee:	5d                   	pop    %ebp
801047ef:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801047f0:	8b 5e 08             	mov    0x8(%esi),%ebx
801047f3:	e8 08 f2 ff ff       	call   80103a00 <mycpu>
801047f8:	39 c3                	cmp    %eax,%ebx
801047fa:	0f 94 c3             	sete   %bl
  popcli();
801047fd:	e8 6e ff ff ff       	call   80104770 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104802:	0f b6 db             	movzbl %bl,%ebx
}
80104805:	89 d8                	mov    %ebx,%eax
80104807:	5b                   	pop    %ebx
80104808:	5e                   	pop    %esi
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret
8010480b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104810 <release>:
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104818:	e8 03 ff ff ff       	call   80104720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010481d:	8b 03                	mov    (%ebx),%eax
8010481f:	85 c0                	test   %eax,%eax
80104821:	75 15                	jne    80104838 <release+0x28>
  popcli();
80104823:	e8 48 ff ff ff       	call   80104770 <popcli>
    panic("release");
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 a1 78 10 80       	push   $0x801078a1
80104830:	e8 6b bb ff ff       	call   801003a0 <panic>
80104835:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104838:	8b 73 08             	mov    0x8(%ebx),%esi
8010483b:	e8 c0 f1 ff ff       	call   80103a00 <mycpu>
80104840:	39 c6                	cmp    %eax,%esi
80104842:	75 df                	jne    80104823 <release+0x13>
  popcli();
80104844:	e8 27 ff ff ff       	call   80104770 <popcli>
  lk->pcs[0] = 0;
80104849:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104850:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104857:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010485c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104862:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104865:	5b                   	pop    %ebx
80104866:	5e                   	pop    %esi
80104867:	5d                   	pop    %ebp
  popcli();
80104868:	e9 03 ff ff ff       	jmp    80104770 <popcli>
8010486d:	8d 76 00             	lea    0x0(%esi),%esi

80104870 <acquire>:
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104877:	e8 a4 fe ff ff       	call   80104720 <pushcli>
  if(holding(lk))
8010487c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010487f:	e8 9c fe ff ff       	call   80104720 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104884:	8b 03                	mov    (%ebx),%eax
80104886:	85 c0                	test   %eax,%eax
80104888:	0f 85 d2 00 00 00    	jne    80104960 <acquire+0xf0>
  popcli();
8010488e:	e8 dd fe ff ff       	call   80104770 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104893:	b9 01 00 00 00       	mov    $0x1,%ecx
80104898:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010489f:	00 
  while(xchg(&lk->locked, 1) != 0)
801048a0:	8b 55 08             	mov    0x8(%ebp),%edx
801048a3:	89 c8                	mov    %ecx,%eax
801048a5:	f0 87 02             	lock xchg %eax,(%edx)
801048a8:	85 c0                	test   %eax,%eax
801048aa:	75 f4                	jne    801048a0 <acquire+0x30>
  __sync_synchronize();
801048ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048b4:	e8 47 f1 ff ff       	call   80103a00 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801048bc:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801048be:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801048c1:	31 c0                	xor    %eax,%eax
801048c3:	eb 1b                	jmp    801048e0 <acquire+0x70>
801048c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048cc:	00 
801048cd:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048d4:	00 
801048d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048dc:	00 
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048ec:	77 1a                	ja     80104908 <acquire+0x98>
    pcs[i] = ebp[1];     // saved %eip
801048ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801048f1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048f5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048f8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048fa:	83 f8 0a             	cmp    $0xa,%eax
801048fd:	75 e1                	jne    801048e0 <acquire+0x70>
}
801048ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104902:	c9                   	leave
80104903:	c3                   	ret
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104908:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010490c:	83 c1 34             	add    $0x34,%ecx
8010490f:	89 ca                	mov    %ecx,%edx
80104911:	29 c2                	sub    %eax,%edx
80104913:	83 e2 04             	and    $0x4,%edx
80104916:	74 28                	je     80104940 <acquire+0xd0>
    pcs[i] = 0;
80104918:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010491e:	83 c0 04             	add    $0x4,%eax
80104921:	39 c8                	cmp    %ecx,%eax
80104923:	74 da                	je     801048ff <acquire+0x8f>
80104925:	eb 19                	jmp    80104940 <acquire+0xd0>
80104927:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010492e:	00 
8010492f:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104936:	00 
80104937:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010493e:	00 
8010493f:	90                   	nop
    pcs[i] = 0;
80104940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104946:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104949:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104950:	39 c8                	cmp    %ecx,%eax
80104952:	75 ec                	jne    80104940 <acquire+0xd0>
80104954:	eb a9                	jmp    801048ff <acquire+0x8f>
80104956:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010495d:	00 
8010495e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104960:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104963:	e8 98 f0 ff ff       	call   80103a00 <mycpu>
80104968:	39 c3                	cmp    %eax,%ebx
8010496a:	0f 85 1e ff ff ff    	jne    8010488e <acquire+0x1e>
  popcli();
80104970:	e8 fb fd ff ff       	call   80104770 <popcli>
    panic("acquire");
80104975:	83 ec 0c             	sub    $0xc,%esp
80104978:	68 a9 78 10 80       	push   $0x801078a9
8010497d:	e8 1e ba ff ff       	call   801003a0 <panic>
80104982:	66 90                	xchg   %ax,%ax
80104984:	66 90                	xchg   %ax,%ax
80104986:	66 90                	xchg   %ax,%ax
80104988:	66 90                	xchg   %ax,%ax
8010498a:	66 90                	xchg   %ax,%ax
8010498c:	66 90                	xchg   %ax,%ax
8010498e:	66 90                	xchg   %ax,%ax
80104990:	66 90                	xchg   %ax,%ax
80104992:	66 90                	xchg   %ax,%ax
80104994:	66 90                	xchg   %ax,%ax
80104996:	66 90                	xchg   %ax,%ax
80104998:	66 90                	xchg   %ax,%ax
8010499a:	66 90                	xchg   %ax,%ax
8010499c:	66 90                	xchg   %ax,%ax
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	57                   	push   %edi
801049a4:	8b 55 08             	mov    0x8(%ebp),%edx
801049a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801049aa:	89 d0                	mov    %edx,%eax
801049ac:	09 c8                	or     %ecx,%eax
801049ae:	a8 03                	test   $0x3,%al
801049b0:	75 1e                	jne    801049d0 <memset+0x30>
    c &= 0xFF;
801049b2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801049b6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801049b9:	89 d7                	mov    %edx,%edi
801049bb:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801049c1:	fc                   	cld
801049c2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801049c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801049c7:	89 d0                	mov    %edx,%eax
801049c9:	c9                   	leave
801049ca:	c3                   	ret
801049cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801049d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801049d3:	89 d7                	mov    %edx,%edi
801049d5:	fc                   	cld
801049d6:	f3 aa                	rep stos %al,%es:(%edi)
801049d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801049db:	89 d0                	mov    %edx,%eax
801049dd:	c9                   	leave
801049de:	c3                   	ret
801049df:	90                   	nop

801049e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	8b 75 10             	mov    0x10(%ebp),%esi
801049e7:	8b 45 08             	mov    0x8(%ebp),%eax
801049ea:	53                   	push   %ebx
801049eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049ee:	85 f6                	test   %esi,%esi
801049f0:	74 2e                	je     80104a20 <memcmp+0x40>
801049f2:	01 c6                	add    %eax,%esi
801049f4:	eb 14                	jmp    80104a0a <memcmp+0x2a>
801049f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049fd:	00 
801049fe:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a00:	83 c0 01             	add    $0x1,%eax
80104a03:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a06:	39 f0                	cmp    %esi,%eax
80104a08:	74 16                	je     80104a20 <memcmp+0x40>
    if(*s1 != *s2)
80104a0a:	0f b6 08             	movzbl (%eax),%ecx
80104a0d:	0f b6 1a             	movzbl (%edx),%ebx
80104a10:	38 d9                	cmp    %bl,%cl
80104a12:	74 ec                	je     80104a00 <memcmp+0x20>
      return *s1 - *s2;
80104a14:	0f b6 c1             	movzbl %cl,%eax
80104a17:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a19:	5b                   	pop    %ebx
80104a1a:	5e                   	pop    %esi
80104a1b:	5d                   	pop    %ebp
80104a1c:	c3                   	ret
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
80104a20:	5b                   	pop    %ebx
  return 0;
80104a21:	31 c0                	xor    %eax,%eax
}
80104a23:	5e                   	pop    %esi
80104a24:	5d                   	pop    %ebp
80104a25:	c3                   	ret
80104a26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a2d:	00 
80104a2e:	66 90                	xchg   %ax,%ax

80104a30 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	8b 55 08             	mov    0x8(%ebp),%edx
80104a37:	8b 45 10             	mov    0x10(%ebp),%eax
80104a3a:	56                   	push   %esi
80104a3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a3e:	39 d6                	cmp    %edx,%esi
80104a40:	73 26                	jae    80104a68 <memmove+0x38>
80104a42:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104a45:	39 ca                	cmp    %ecx,%edx
80104a47:	73 1f                	jae    80104a68 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104a49:	85 c0                	test   %eax,%eax
80104a4b:	74 0f                	je     80104a5c <memmove+0x2c>
80104a4d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104a50:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a54:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a57:	83 e8 01             	sub    $0x1,%eax
80104a5a:	73 f4                	jae    80104a50 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a5c:	5e                   	pop    %esi
80104a5d:	89 d0                	mov    %edx,%eax
80104a5f:	5f                   	pop    %edi
80104a60:	5d                   	pop    %ebp
80104a61:	c3                   	ret
80104a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a68:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104a6b:	89 d7                	mov    %edx,%edi
80104a6d:	85 c0                	test   %eax,%eax
80104a6f:	74 eb                	je     80104a5c <memmove+0x2c>
80104a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a7f:	00 
      *d++ = *s++;
80104a80:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a81:	39 f1                	cmp    %esi,%ecx
80104a83:	75 fb                	jne    80104a80 <memmove+0x50>
}
80104a85:	5e                   	pop    %esi
80104a86:	89 d0                	mov    %edx,%eax
80104a88:	5f                   	pop    %edi
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret
80104a8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104a90 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a90:	eb 9e                	jmp    80104a30 <memmove>
80104a92:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a99:	00 
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104aa0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	8b 55 10             	mov    0x10(%ebp),%edx
80104aa7:	8b 45 08             	mov    0x8(%ebp),%eax
80104aaa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
80104aad:	85 d2                	test   %edx,%edx
80104aaf:	75 16                	jne    80104ac7 <strncmp+0x27>
80104ab1:	eb 2d                	jmp    80104ae0 <strncmp+0x40>
80104ab3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ab8:	3a 19                	cmp    (%ecx),%bl
80104aba:	75 12                	jne    80104ace <strncmp+0x2e>
    n--, p++, q++;
80104abc:	83 c0 01             	add    $0x1,%eax
80104abf:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104ac2:	83 ea 01             	sub    $0x1,%edx
80104ac5:	74 19                	je     80104ae0 <strncmp+0x40>
80104ac7:	0f b6 18             	movzbl (%eax),%ebx
80104aca:	84 db                	test   %bl,%bl
80104acc:	75 ea                	jne    80104ab8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104ace:	0f b6 00             	movzbl (%eax),%eax
80104ad1:	0f b6 11             	movzbl (%ecx),%edx
}
80104ad4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104ad8:	29 d0                	sub    %edx,%eax
}
80104ada:	c3                   	ret
80104adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ae0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104ae3:	31 c0                	xor    %eax,%eax
}
80104ae5:	c9                   	leave
80104ae6:	c3                   	ret
80104ae7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aee:	00 
80104aef:	90                   	nop

80104af0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	56                   	push   %esi
80104af5:	8b 75 08             	mov    0x8(%ebp),%esi
80104af8:	53                   	push   %ebx
80104af9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104afc:	89 f0                	mov    %esi,%eax
80104afe:	eb 15                	jmp    80104b15 <strncpy+0x25>
80104b00:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b04:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b07:	83 c0 01             	add    $0x1,%eax
80104b0a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
80104b0e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104b11:	84 c9                	test   %cl,%cl
80104b13:	74 13                	je     80104b28 <strncpy+0x38>
80104b15:	89 d3                	mov    %edx,%ebx
80104b17:	83 ea 01             	sub    $0x1,%edx
80104b1a:	85 db                	test   %ebx,%ebx
80104b1c:	7f e2                	jg     80104b00 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
80104b1e:	5b                   	pop    %ebx
80104b1f:	89 f0                	mov    %esi,%eax
80104b21:	5e                   	pop    %esi
80104b22:	5f                   	pop    %edi
80104b23:	5d                   	pop    %ebp
80104b24:	c3                   	ret
80104b25:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104b28:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104b2b:	83 e9 01             	sub    $0x1,%ecx
80104b2e:	85 d2                	test   %edx,%edx
80104b30:	74 ec                	je     80104b1e <strncpy+0x2e>
80104b32:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b39:	00 
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104b40:	83 c0 01             	add    $0x1,%eax
80104b43:	89 ca                	mov    %ecx,%edx
80104b45:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104b49:	29 c2                	sub    %eax,%edx
80104b4b:	85 d2                	test   %edx,%edx
80104b4d:	7f f1                	jg     80104b40 <strncpy+0x50>
}
80104b4f:	5b                   	pop    %ebx
80104b50:	89 f0                	mov    %esi,%eax
80104b52:	5e                   	pop    %esi
80104b53:	5f                   	pop    %edi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret
80104b56:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b5d:	00 
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	8b 55 10             	mov    0x10(%ebp),%edx
80104b67:	8b 75 08             	mov    0x8(%ebp),%esi
80104b6a:	53                   	push   %ebx
80104b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b6e:	85 d2                	test   %edx,%edx
80104b70:	7e 25                	jle    80104b97 <safestrcpy+0x37>
80104b72:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b76:	89 f2                	mov    %esi,%edx
80104b78:	eb 16                	jmp    80104b90 <safestrcpy+0x30>
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b80:	0f b6 08             	movzbl (%eax),%ecx
80104b83:	83 c0 01             	add    $0x1,%eax
80104b86:	83 c2 01             	add    $0x1,%edx
80104b89:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b8c:	84 c9                	test   %cl,%cl
80104b8e:	74 04                	je     80104b94 <safestrcpy+0x34>
80104b90:	39 d8                	cmp    %ebx,%eax
80104b92:	75 ec                	jne    80104b80 <safestrcpy+0x20>
    ;
  *s = 0;
80104b94:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b97:	89 f0                	mov    %esi,%eax
80104b99:	5b                   	pop    %ebx
80104b9a:	5e                   	pop    %esi
80104b9b:	5d                   	pop    %ebp
80104b9c:	c3                   	ret
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ba0 <strlen>:

int
strlen(const char *s)
{
80104ba0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ba1:	31 c0                	xor    %eax,%eax
{
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ba8:	80 3a 00             	cmpb   $0x0,(%edx)
80104bab:	74 0c                	je     80104bb9 <strlen+0x19>
80104bad:	8d 76 00             	lea    0x0(%esi),%esi
80104bb0:	83 c0 01             	add    $0x1,%eax
80104bb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bb7:	75 f7                	jne    80104bb0 <strlen+0x10>
    ;
  return n;
}
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret

80104bbb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bbb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bbf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104bc3:	55                   	push   %ebp
  pushl %ebx
80104bc4:	53                   	push   %ebx
  pushl %esi
80104bc5:	56                   	push   %esi
  pushl %edi
80104bc6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bc7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bc9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bcb:	5f                   	pop    %edi
  popl %esi
80104bcc:	5e                   	pop    %esi
  popl %ebx
80104bcd:	5b                   	pop    %ebx
  popl %ebp
80104bce:	5d                   	pop    %ebp
  ret
80104bcf:	c3                   	ret

80104bd0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bda:	e8 a1 ee ff ff       	call   80103a80 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bdf:	8b 00                	mov    (%eax),%eax
80104be1:	39 c3                	cmp    %eax,%ebx
80104be3:	73 1b                	jae    80104c00 <fetchint+0x30>
80104be5:	8d 53 04             	lea    0x4(%ebx),%edx
80104be8:	39 d0                	cmp    %edx,%eax
80104bea:	72 14                	jb     80104c00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bec:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bef:	8b 13                	mov    (%ebx),%edx
80104bf1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bf3:	31 c0                	xor    %eax,%eax
}
80104bf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bf8:	c9                   	leave
80104bf9:	c3                   	ret
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c05:	eb ee                	jmp    80104bf5 <fetchint+0x25>
80104c07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c0e:	00 
80104c0f:	90                   	nop

80104c10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
80104c17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c1a:	e8 61 ee ff ff       	call   80103a80 <myproc>

  if(addr >= curproc->sz)
80104c1f:	3b 18                	cmp    (%eax),%ebx
80104c21:	73 35                	jae    80104c58 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104c23:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c26:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c28:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c2a:	39 d3                	cmp    %edx,%ebx
80104c2c:	73 2a                	jae    80104c58 <fetchstr+0x48>
80104c2e:	89 d8                	mov    %ebx,%eax
80104c30:	eb 15                	jmp    80104c47 <fetchstr+0x37>
80104c32:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c39:	00 
80104c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c40:	83 c0 01             	add    $0x1,%eax
80104c43:	39 d0                	cmp    %edx,%eax
80104c45:	73 11                	jae    80104c58 <fetchstr+0x48>
    if(*s == 0)
80104c47:	80 38 00             	cmpb   $0x0,(%eax)
80104c4a:	75 f4                	jne    80104c40 <fetchstr+0x30>
      return s - *pp;
80104c4c:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c51:	c9                   	leave
80104c52:	c3                   	ret
80104c53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c60:	c9                   	leave
80104c61:	c3                   	ret
80104c62:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c69:	00 
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c75:	e8 06 ee ff ff       	call   80103a80 <myproc>
80104c7a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c7d:	8b 40 18             	mov    0x18(%eax),%eax
80104c80:	8b 40 44             	mov    0x44(%eax),%eax
80104c83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c86:	e8 f5 ed ff ff       	call   80103a80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c8b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c8e:	8b 00                	mov    (%eax),%eax
80104c90:	39 c6                	cmp    %eax,%esi
80104c92:	73 1c                	jae    80104cb0 <argint+0x40>
80104c94:	8d 53 08             	lea    0x8(%ebx),%edx
80104c97:	39 d0                	cmp    %edx,%eax
80104c99:	72 15                	jb     80104cb0 <argint+0x40>
  *ip = *(int*)(addr);
80104c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ca1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cb5:	eb ee                	jmp    80104ca5 <argint+0x35>
80104cb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cbe:	00 
80104cbf:	90                   	nop

80104cc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	53                   	push   %ebx
80104cc6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104cc9:	e8 b2 ed ff ff       	call   80103a80 <myproc>
80104cce:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cd0:	e8 ab ed ff ff       	call   80103a80 <myproc>
80104cd5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cd8:	8b 40 18             	mov    0x18(%eax),%eax
80104cdb:	8b 40 44             	mov    0x44(%eax),%eax
80104cde:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ce1:	e8 9a ed ff ff       	call   80103a80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ce9:	8b 00                	mov    (%eax),%eax
80104ceb:	39 c7                	cmp    %eax,%edi
80104ced:	73 31                	jae    80104d20 <argptr+0x60>
80104cef:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104cf2:	39 c8                	cmp    %ecx,%eax
80104cf4:	72 2a                	jb     80104d20 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cf6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104cf9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104cfc:	85 d2                	test   %edx,%edx
80104cfe:	78 20                	js     80104d20 <argptr+0x60>
80104d00:	8b 16                	mov    (%esi),%edx
80104d02:	39 d0                	cmp    %edx,%eax
80104d04:	73 1a                	jae    80104d20 <argptr+0x60>
80104d06:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d09:	01 c3                	add    %eax,%ebx
80104d0b:	39 da                	cmp    %ebx,%edx
80104d0d:	72 11                	jb     80104d20 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d12:	89 02                	mov    %eax,(%edx)
  return 0;
80104d14:	31 c0                	xor    %eax,%eax
}
80104d16:	83 c4 0c             	add    $0xc,%esp
80104d19:	5b                   	pop    %ebx
80104d1a:	5e                   	pop    %esi
80104d1b:	5f                   	pop    %edi
80104d1c:	5d                   	pop    %ebp
80104d1d:	c3                   	ret
80104d1e:	66 90                	xchg   %ax,%ax
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d25:	eb ef                	jmp    80104d16 <argptr+0x56>
80104d27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d2e:	00 
80104d2f:	90                   	nop

80104d30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d35:	e8 46 ed ff ff       	call   80103a80 <myproc>
80104d3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d3d:	8b 40 18             	mov    0x18(%eax),%eax
80104d40:	8b 40 44             	mov    0x44(%eax),%eax
80104d43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d46:	e8 35 ed ff ff       	call   80103a80 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d4e:	8b 00                	mov    (%eax),%eax
80104d50:	39 c6                	cmp    %eax,%esi
80104d52:	73 44                	jae    80104d98 <argstr+0x68>
80104d54:	8d 53 08             	lea    0x8(%ebx),%edx
80104d57:	39 d0                	cmp    %edx,%eax
80104d59:	72 3d                	jb     80104d98 <argstr+0x68>
  *ip = *(int*)(addr);
80104d5b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d5e:	e8 1d ed ff ff       	call   80103a80 <myproc>
  if(addr >= curproc->sz)
80104d63:	3b 18                	cmp    (%eax),%ebx
80104d65:	73 31                	jae    80104d98 <argstr+0x68>
  *pp = (char*)addr;
80104d67:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d6a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d6c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d6e:	39 d3                	cmp    %edx,%ebx
80104d70:	73 26                	jae    80104d98 <argstr+0x68>
80104d72:	89 d8                	mov    %ebx,%eax
80104d74:	eb 11                	jmp    80104d87 <argstr+0x57>
80104d76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d7d:	00 
80104d7e:	66 90                	xchg   %ax,%ax
80104d80:	83 c0 01             	add    $0x1,%eax
80104d83:	39 d0                	cmp    %edx,%eax
80104d85:	73 11                	jae    80104d98 <argstr+0x68>
    if(*s == 0)
80104d87:	80 38 00             	cmpb   $0x0,(%eax)
80104d8a:	75 f4                	jne    80104d80 <argstr+0x50>
      return s - *pp;
80104d8c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d8e:	5b                   	pop    %ebx
80104d8f:	5e                   	pop    %esi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d98:	5b                   	pop    %ebx
    return -1;
80104d99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d9e:	5e                   	pop    %esi
80104d9f:	5d                   	pop    %ebp
80104da0:	c3                   	ret
80104da1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104da8:	00 
80104da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104db0 <syscall>:
[SYS_getProcInfo] sys_getprocinfo
};

void
syscall(void)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
80104db4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104db7:	e8 c4 ec ff ff       	call   80103a80 <myproc>
80104dbc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104dbe:	8b 40 18             	mov    0x18(%eax),%eax
80104dc1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dc7:	83 fa 17             	cmp    $0x17,%edx
80104dca:	77 24                	ja     80104df0 <syscall+0x40>
80104dcc:	8b 14 85 20 7e 10 80 	mov    -0x7fef81e0(,%eax,4),%edx
80104dd3:	85 d2                	test   %edx,%edx
80104dd5:	74 19                	je     80104df0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104dd7:	ff d2                	call   *%edx
80104dd9:	89 c2                	mov    %eax,%edx
80104ddb:	8b 43 18             	mov    0x18(%ebx),%eax
80104dde:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104de1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104de4:	c9                   	leave
80104de5:	c3                   	ret
80104de6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ded:	00 
80104dee:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104df0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104df1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104df4:	50                   	push   %eax
80104df5:	ff 73 10             	push   0x10(%ebx)
80104df8:	68 b1 78 10 80       	push   $0x801078b1
80104dfd:	e8 ce b8 ff ff       	call   801006d0 <cprintf>
    curproc->tf->eax = -1;
80104e02:	8b 43 18             	mov    0x18(%ebx),%eax
80104e05:	83 c4 10             	add    $0x10,%esp
80104e08:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e12:	c9                   	leave
80104e13:	c3                   	ret
80104e14:	66 90                	xchg   %ax,%ax
80104e16:	66 90                	xchg   %ax,%ax
80104e18:	66 90                	xchg   %ax,%ax
80104e1a:	66 90                	xchg   %ax,%ax
80104e1c:	66 90                	xchg   %ax,%ax
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e25:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e28:	53                   	push   %ebx
80104e29:	83 ec 34             	sub    $0x34,%esp
80104e2c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e32:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e35:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e38:	57                   	push   %edi
80104e39:	50                   	push   %eax
80104e3a:	e8 e1 d2 ff ff       	call   80102120 <nameiparent>
80104e3f:	83 c4 10             	add    $0x10,%esp
80104e42:	85 c0                	test   %eax,%eax
80104e44:	74 5e                	je     80104ea4 <create+0x84>
    return 0;
  ilock(dp);
80104e46:	83 ec 0c             	sub    $0xc,%esp
80104e49:	89 c3                	mov    %eax,%ebx
80104e4b:	50                   	push   %eax
80104e4c:	e8 9f c9 ff ff       	call   801017f0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e51:	83 c4 0c             	add    $0xc,%esp
80104e54:	6a 00                	push   $0x0
80104e56:	57                   	push   %edi
80104e57:	53                   	push   %ebx
80104e58:	e8 e3 ce ff ff       	call   80101d40 <dirlookup>
80104e5d:	83 c4 10             	add    $0x10,%esp
80104e60:	89 c6                	mov    %eax,%esi
80104e62:	85 c0                	test   %eax,%eax
80104e64:	74 4a                	je     80104eb0 <create+0x90>
    iunlockput(dp);
80104e66:	83 ec 0c             	sub    $0xc,%esp
80104e69:	53                   	push   %ebx
80104e6a:	e8 11 cc ff ff       	call   80101a80 <iunlockput>
    ilock(ip);
80104e6f:	89 34 24             	mov    %esi,(%esp)
80104e72:	e8 79 c9 ff ff       	call   801017f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e77:	83 c4 10             	add    $0x10,%esp
80104e7a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e7f:	75 17                	jne    80104e98 <create+0x78>
80104e81:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e86:	75 10                	jne    80104e98 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e8b:	89 f0                	mov    %esi,%eax
80104e8d:	5b                   	pop    %ebx
80104e8e:	5e                   	pop    %esi
80104e8f:	5f                   	pop    %edi
80104e90:	5d                   	pop    %ebp
80104e91:	c3                   	ret
80104e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e98:	83 ec 0c             	sub    $0xc,%esp
80104e9b:	56                   	push   %esi
80104e9c:	e8 df cb ff ff       	call   80101a80 <iunlockput>
    return 0;
80104ea1:	83 c4 10             	add    $0x10,%esp
}
80104ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ea7:	31 f6                	xor    %esi,%esi
}
80104ea9:	5b                   	pop    %ebx
80104eaa:	89 f0                	mov    %esi,%eax
80104eac:	5e                   	pop    %esi
80104ead:	5f                   	pop    %edi
80104eae:	5d                   	pop    %ebp
80104eaf:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104eb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104eb4:	83 ec 08             	sub    $0x8,%esp
80104eb7:	50                   	push   %eax
80104eb8:	ff 33                	push   (%ebx)
80104eba:	e8 c1 c7 ff ff       	call   80101680 <ialloc>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	89 c6                	mov    %eax,%esi
80104ec4:	85 c0                	test   %eax,%eax
80104ec6:	0f 84 af 00 00 00    	je     80104f7b <create+0x15b>
  ilock(ip);
80104ecc:	83 ec 0c             	sub    $0xc,%esp
80104ecf:	50                   	push   %eax
80104ed0:	e8 1b c9 ff ff       	call   801017f0 <ilock>
  ip->major = major;
80104ed5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ed9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104edd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ee1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ee5:	b8 01 00 00 00       	mov    $0x1,%eax
80104eea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104eee:	89 34 24             	mov    %esi,(%esp)
80104ef1:	e8 4a c8 ff ff       	call   80101740 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ef6:	83 c4 10             	add    $0x10,%esp
80104ef9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104efe:	74 30                	je     80104f30 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104f00:	83 ec 04             	sub    $0x4,%esp
80104f03:	ff 76 04             	push   0x4(%esi)
80104f06:	57                   	push   %edi
80104f07:	53                   	push   %ebx
80104f08:	e8 33 d1 ff ff       	call   80102040 <dirlink>
80104f0d:	83 c4 10             	add    $0x10,%esp
80104f10:	85 c0                	test   %eax,%eax
80104f12:	78 74                	js     80104f88 <create+0x168>
  iunlockput(dp);
80104f14:	83 ec 0c             	sub    $0xc,%esp
80104f17:	53                   	push   %ebx
80104f18:	e8 63 cb ff ff       	call   80101a80 <iunlockput>
  return ip;
80104f1d:	83 c4 10             	add    $0x10,%esp
}
80104f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f23:	89 f0                	mov    %esi,%eax
80104f25:	5b                   	pop    %ebx
80104f26:	5e                   	pop    %esi
80104f27:	5f                   	pop    %edi
80104f28:	5d                   	pop    %ebp
80104f29:	c3                   	ret
80104f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f38:	53                   	push   %ebx
80104f39:	e8 02 c8 ff ff       	call   80101740 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f3e:	83 c4 0c             	add    $0xc,%esp
80104f41:	ff 76 04             	push   0x4(%esi)
80104f44:	68 e9 78 10 80       	push   $0x801078e9
80104f49:	56                   	push   %esi
80104f4a:	e8 f1 d0 ff ff       	call   80102040 <dirlink>
80104f4f:	83 c4 10             	add    $0x10,%esp
80104f52:	85 c0                	test   %eax,%eax
80104f54:	78 18                	js     80104f6e <create+0x14e>
80104f56:	83 ec 04             	sub    $0x4,%esp
80104f59:	ff 73 04             	push   0x4(%ebx)
80104f5c:	68 e8 78 10 80       	push   $0x801078e8
80104f61:	56                   	push   %esi
80104f62:	e8 d9 d0 ff ff       	call   80102040 <dirlink>
80104f67:	83 c4 10             	add    $0x10,%esp
80104f6a:	85 c0                	test   %eax,%eax
80104f6c:	79 92                	jns    80104f00 <create+0xe0>
      panic("create dots");
80104f6e:	83 ec 0c             	sub    $0xc,%esp
80104f71:	68 dc 78 10 80       	push   $0x801078dc
80104f76:	e8 25 b4 ff ff       	call   801003a0 <panic>
    panic("create: ialloc");
80104f7b:	83 ec 0c             	sub    $0xc,%esp
80104f7e:	68 cd 78 10 80       	push   $0x801078cd
80104f83:	e8 18 b4 ff ff       	call   801003a0 <panic>
    panic("create: dirlink");
80104f88:	83 ec 0c             	sub    $0xc,%esp
80104f8b:	68 eb 78 10 80       	push   $0x801078eb
80104f90:	e8 0b b4 ff ff       	call   801003a0 <panic>
80104f95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104f9c:	00 
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi

80104fa0 <sys_dup>:
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fa5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fa8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fab:	50                   	push   %eax
80104fac:	6a 00                	push   $0x0
80104fae:	e8 bd fc ff ff       	call   80104c70 <argint>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 36                	js     80104ff0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104fbe:	77 30                	ja     80104ff0 <sys_dup+0x50>
80104fc0:	e8 bb ea ff ff       	call   80103a80 <myproc>
80104fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fc8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104fcc:	85 f6                	test   %esi,%esi
80104fce:	74 20                	je     80104ff0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104fd0:	e8 ab ea ff ff       	call   80103a80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104fd5:	31 db                	xor    %ebx,%ebx
80104fd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fde:	00 
80104fdf:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104fe0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fe4:	85 d2                	test   %edx,%edx
80104fe6:	74 18                	je     80105000 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104fe8:	83 c3 01             	add    $0x1,%ebx
80104feb:	83 fb 10             	cmp    $0x10,%ebx
80104fee:	75 f0                	jne    80104fe0 <sys_dup+0x40>
    return -1;
80104ff0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104ff5:	eb 19                	jmp    80105010 <sys_dup+0x70>
80104ff7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ffe:	00 
80104fff:	90                   	nop
  filedup(f);
80105000:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105003:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105007:	56                   	push   %esi
80105008:	e8 03 bf ff ff       	call   80100f10 <filedup>
  return fd;
8010500d:	83 c4 10             	add    $0x10,%esp
}
80105010:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105013:	89 d8                	mov    %ebx,%eax
80105015:	5b                   	pop    %ebx
80105016:	5e                   	pop    %esi
80105017:	5d                   	pop    %ebp
80105018:	c3                   	ret
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105020 <sys_read>:
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105025:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105028:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010502b:	53                   	push   %ebx
8010502c:	6a 00                	push   $0x0
8010502e:	e8 3d fc ff ff       	call   80104c70 <argint>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 5e                	js     80105098 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010503a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010503e:	77 58                	ja     80105098 <sys_read+0x78>
80105040:	e8 3b ea ff ff       	call   80103a80 <myproc>
80105045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105048:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010504c:	85 f6                	test   %esi,%esi
8010504e:	74 48                	je     80105098 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105050:	83 ec 08             	sub    $0x8,%esp
80105053:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105056:	50                   	push   %eax
80105057:	6a 02                	push   $0x2
80105059:	e8 12 fc ff ff       	call   80104c70 <argint>
8010505e:	83 c4 10             	add    $0x10,%esp
80105061:	85 c0                	test   %eax,%eax
80105063:	78 33                	js     80105098 <sys_read+0x78>
80105065:	83 ec 04             	sub    $0x4,%esp
80105068:	ff 75 f0             	push   -0x10(%ebp)
8010506b:	53                   	push   %ebx
8010506c:	6a 01                	push   $0x1
8010506e:	e8 4d fc ff ff       	call   80104cc0 <argptr>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 1e                	js     80105098 <sys_read+0x78>
  return fileread(f, p, n);
8010507a:	83 ec 04             	sub    $0x4,%esp
8010507d:	ff 75 f0             	push   -0x10(%ebp)
80105080:	ff 75 f4             	push   -0xc(%ebp)
80105083:	56                   	push   %esi
80105084:	e8 07 c0 ff ff       	call   80101090 <fileread>
80105089:	83 c4 10             	add    $0x10,%esp
}
8010508c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010508f:	5b                   	pop    %ebx
80105090:	5e                   	pop    %esi
80105091:	5d                   	pop    %ebp
80105092:	c3                   	ret
80105093:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb ed                	jmp    8010508c <sys_read+0x6c>
8010509f:	90                   	nop

801050a0 <sys_write>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	56                   	push   %esi
801050a4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050a5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801050a8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050ab:	53                   	push   %ebx
801050ac:	6a 00                	push   $0x0
801050ae:	e8 bd fb ff ff       	call   80104c70 <argint>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 5e                	js     80105118 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ba:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050be:	77 58                	ja     80105118 <sys_write+0x78>
801050c0:	e8 bb e9 ff ff       	call   80103a80 <myproc>
801050c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050c8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050cc:	85 f6                	test   %esi,%esi
801050ce:	74 48                	je     80105118 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050d0:	83 ec 08             	sub    $0x8,%esp
801050d3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050d6:	50                   	push   %eax
801050d7:	6a 02                	push   $0x2
801050d9:	e8 92 fb ff ff       	call   80104c70 <argint>
801050de:	83 c4 10             	add    $0x10,%esp
801050e1:	85 c0                	test   %eax,%eax
801050e3:	78 33                	js     80105118 <sys_write+0x78>
801050e5:	83 ec 04             	sub    $0x4,%esp
801050e8:	ff 75 f0             	push   -0x10(%ebp)
801050eb:	53                   	push   %ebx
801050ec:	6a 01                	push   $0x1
801050ee:	e8 cd fb ff ff       	call   80104cc0 <argptr>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	78 1e                	js     80105118 <sys_write+0x78>
  return filewrite(f, p, n);
801050fa:	83 ec 04             	sub    $0x4,%esp
801050fd:	ff 75 f0             	push   -0x10(%ebp)
80105100:	ff 75 f4             	push   -0xc(%ebp)
80105103:	56                   	push   %esi
80105104:	e8 17 c0 ff ff       	call   80101120 <filewrite>
80105109:	83 c4 10             	add    $0x10,%esp
}
8010510c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010510f:	5b                   	pop    %ebx
80105110:	5e                   	pop    %esi
80105111:	5d                   	pop    %ebp
80105112:	c3                   	ret
80105113:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80105118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511d:	eb ed                	jmp    8010510c <sys_write+0x6c>
8010511f:	90                   	nop

80105120 <sys_close>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105125:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105128:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010512b:	50                   	push   %eax
8010512c:	6a 00                	push   $0x0
8010512e:	e8 3d fb ff ff       	call   80104c70 <argint>
80105133:	83 c4 10             	add    $0x10,%esp
80105136:	85 c0                	test   %eax,%eax
80105138:	78 3e                	js     80105178 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010513a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010513e:	77 38                	ja     80105178 <sys_close+0x58>
80105140:	e8 3b e9 ff ff       	call   80103a80 <myproc>
80105145:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105148:	8d 5a 08             	lea    0x8(%edx),%ebx
8010514b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010514f:	85 f6                	test   %esi,%esi
80105151:	74 25                	je     80105178 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105153:	e8 28 e9 ff ff       	call   80103a80 <myproc>
  fileclose(f);
80105158:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010515b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105162:	00 
  fileclose(f);
80105163:	56                   	push   %esi
80105164:	e8 f7 bd ff ff       	call   80100f60 <fileclose>
  return 0;
80105169:	83 c4 10             	add    $0x10,%esp
8010516c:	31 c0                	xor    %eax,%eax
}
8010516e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105171:	5b                   	pop    %ebx
80105172:	5e                   	pop    %esi
80105173:	5d                   	pop    %ebp
80105174:	c3                   	ret
80105175:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517d:	eb ef                	jmp    8010516e <sys_close+0x4e>
8010517f:	90                   	nop

80105180 <sys_fstat>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	56                   	push   %esi
80105184:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105185:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105188:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010518b:	53                   	push   %ebx
8010518c:	6a 00                	push   $0x0
8010518e:	e8 dd fa ff ff       	call   80104c70 <argint>
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	85 c0                	test   %eax,%eax
80105198:	78 46                	js     801051e0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010519a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010519e:	77 40                	ja     801051e0 <sys_fstat+0x60>
801051a0:	e8 db e8 ff ff       	call   80103a80 <myproc>
801051a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801051ac:	85 f6                	test   %esi,%esi
801051ae:	74 30                	je     801051e0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051b0:	83 ec 04             	sub    $0x4,%esp
801051b3:	6a 14                	push   $0x14
801051b5:	53                   	push   %ebx
801051b6:	6a 01                	push   $0x1
801051b8:	e8 03 fb ff ff       	call   80104cc0 <argptr>
801051bd:	83 c4 10             	add    $0x10,%esp
801051c0:	85 c0                	test   %eax,%eax
801051c2:	78 1c                	js     801051e0 <sys_fstat+0x60>
  return filestat(f, st);
801051c4:	83 ec 08             	sub    $0x8,%esp
801051c7:	ff 75 f4             	push   -0xc(%ebp)
801051ca:	56                   	push   %esi
801051cb:	e8 70 be ff ff       	call   80101040 <filestat>
801051d0:	83 c4 10             	add    $0x10,%esp
}
801051d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051d6:	5b                   	pop    %ebx
801051d7:	5e                   	pop    %esi
801051d8:	5d                   	pop    %ebp
801051d9:	c3                   	ret
801051da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801051e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e5:	eb ec                	jmp    801051d3 <sys_fstat+0x53>
801051e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801051ee:	00 
801051ef:	90                   	nop

801051f0 <sys_link>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	57                   	push   %edi
801051f4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051f8:	53                   	push   %ebx
801051f9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051fc:	50                   	push   %eax
801051fd:	6a 00                	push   $0x0
801051ff:	e8 2c fb ff ff       	call   80104d30 <argstr>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	0f 88 fb 00 00 00    	js     8010530a <sys_link+0x11a>
8010520f:	83 ec 08             	sub    $0x8,%esp
80105212:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105215:	50                   	push   %eax
80105216:	6a 01                	push   $0x1
80105218:	e8 13 fb ff ff       	call   80104d30 <argstr>
8010521d:	83 c4 10             	add    $0x10,%esp
80105220:	85 c0                	test   %eax,%eax
80105222:	0f 88 e2 00 00 00    	js     8010530a <sys_link+0x11a>
  begin_op();
80105228:	e8 13 dc ff ff       	call   80102e40 <begin_op>
  if((ip = namei(old)) == 0){
8010522d:	83 ec 0c             	sub    $0xc,%esp
80105230:	ff 75 d4             	push   -0x2c(%ebp)
80105233:	e8 c8 ce ff ff       	call   80102100 <namei>
80105238:	83 c4 10             	add    $0x10,%esp
8010523b:	89 c3                	mov    %eax,%ebx
8010523d:	85 c0                	test   %eax,%eax
8010523f:	0f 84 df 00 00 00    	je     80105324 <sys_link+0x134>
  ilock(ip);
80105245:	83 ec 0c             	sub    $0xc,%esp
80105248:	50                   	push   %eax
80105249:	e8 a2 c5 ff ff       	call   801017f0 <ilock>
  if(ip->type == T_DIR){
8010524e:	83 c4 10             	add    $0x10,%esp
80105251:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105256:	0f 84 b5 00 00 00    	je     80105311 <sys_link+0x121>
  iupdate(ip);
8010525c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010525f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105264:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105267:	53                   	push   %ebx
80105268:	e8 d3 c4 ff ff       	call   80101740 <iupdate>
  iunlock(ip);
8010526d:	89 1c 24             	mov    %ebx,(%esp)
80105270:	e8 5b c6 ff ff       	call   801018d0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105275:	58                   	pop    %eax
80105276:	5a                   	pop    %edx
80105277:	57                   	push   %edi
80105278:	ff 75 d0             	push   -0x30(%ebp)
8010527b:	e8 a0 ce ff ff       	call   80102120 <nameiparent>
80105280:	83 c4 10             	add    $0x10,%esp
80105283:	89 c6                	mov    %eax,%esi
80105285:	85 c0                	test   %eax,%eax
80105287:	74 5b                	je     801052e4 <sys_link+0xf4>
  ilock(dp);
80105289:	83 ec 0c             	sub    $0xc,%esp
8010528c:	50                   	push   %eax
8010528d:	e8 5e c5 ff ff       	call   801017f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105292:	8b 03                	mov    (%ebx),%eax
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	39 06                	cmp    %eax,(%esi)
80105299:	75 3d                	jne    801052d8 <sys_link+0xe8>
8010529b:	83 ec 04             	sub    $0x4,%esp
8010529e:	ff 73 04             	push   0x4(%ebx)
801052a1:	57                   	push   %edi
801052a2:	56                   	push   %esi
801052a3:	e8 98 cd ff ff       	call   80102040 <dirlink>
801052a8:	83 c4 10             	add    $0x10,%esp
801052ab:	85 c0                	test   %eax,%eax
801052ad:	78 29                	js     801052d8 <sys_link+0xe8>
  iunlockput(dp);
801052af:	83 ec 0c             	sub    $0xc,%esp
801052b2:	56                   	push   %esi
801052b3:	e8 c8 c7 ff ff       	call   80101a80 <iunlockput>
  iput(ip);
801052b8:	89 1c 24             	mov    %ebx,(%esp)
801052bb:	e8 60 c6 ff ff       	call   80101920 <iput>
  end_op();
801052c0:	e8 eb db ff ff       	call   80102eb0 <end_op>
  return 0;
801052c5:	83 c4 10             	add    $0x10,%esp
801052c8:	31 c0                	xor    %eax,%eax
}
801052ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052cd:	5b                   	pop    %ebx
801052ce:	5e                   	pop    %esi
801052cf:	5f                   	pop    %edi
801052d0:	5d                   	pop    %ebp
801052d1:	c3                   	ret
801052d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052d8:	83 ec 0c             	sub    $0xc,%esp
801052db:	56                   	push   %esi
801052dc:	e8 9f c7 ff ff       	call   80101a80 <iunlockput>
    goto bad;
801052e1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052e4:	83 ec 0c             	sub    $0xc,%esp
801052e7:	53                   	push   %ebx
801052e8:	e8 03 c5 ff ff       	call   801017f0 <ilock>
  ip->nlink--;
801052ed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052f2:	89 1c 24             	mov    %ebx,(%esp)
801052f5:	e8 46 c4 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
801052fa:	89 1c 24             	mov    %ebx,(%esp)
801052fd:	e8 7e c7 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105302:	e8 a9 db ff ff       	call   80102eb0 <end_op>
  return -1;
80105307:	83 c4 10             	add    $0x10,%esp
    return -1;
8010530a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530f:	eb b9                	jmp    801052ca <sys_link+0xda>
    iunlockput(ip);
80105311:	83 ec 0c             	sub    $0xc,%esp
80105314:	53                   	push   %ebx
80105315:	e8 66 c7 ff ff       	call   80101a80 <iunlockput>
    end_op();
8010531a:	e8 91 db ff ff       	call   80102eb0 <end_op>
    return -1;
8010531f:	83 c4 10             	add    $0x10,%esp
80105322:	eb e6                	jmp    8010530a <sys_link+0x11a>
    end_op();
80105324:	e8 87 db ff ff       	call   80102eb0 <end_op>
    return -1;
80105329:	eb df                	jmp    8010530a <sys_link+0x11a>
8010532b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105330 <sys_unlink>:
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105335:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105338:	53                   	push   %ebx
80105339:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010533c:	50                   	push   %eax
8010533d:	6a 00                	push   $0x0
8010533f:	e8 ec f9 ff ff       	call   80104d30 <argstr>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	85 c0                	test   %eax,%eax
80105349:	0f 88 54 01 00 00    	js     801054a3 <sys_unlink+0x173>
  begin_op();
8010534f:	e8 ec da ff ff       	call   80102e40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105354:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105357:	83 ec 08             	sub    $0x8,%esp
8010535a:	53                   	push   %ebx
8010535b:	ff 75 c0             	push   -0x40(%ebp)
8010535e:	e8 bd cd ff ff       	call   80102120 <nameiparent>
80105363:	83 c4 10             	add    $0x10,%esp
80105366:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105369:	85 c0                	test   %eax,%eax
8010536b:	0f 84 58 01 00 00    	je     801054c9 <sys_unlink+0x199>
  ilock(dp);
80105371:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	57                   	push   %edi
80105378:	e8 73 c4 ff ff       	call   801017f0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010537d:	58                   	pop    %eax
8010537e:	5a                   	pop    %edx
8010537f:	68 e9 78 10 80       	push   $0x801078e9
80105384:	53                   	push   %ebx
80105385:	e8 96 c9 ff ff       	call   80101d20 <namecmp>
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	85 c0                	test   %eax,%eax
8010538f:	0f 84 fb 00 00 00    	je     80105490 <sys_unlink+0x160>
80105395:	83 ec 08             	sub    $0x8,%esp
80105398:	68 e8 78 10 80       	push   $0x801078e8
8010539d:	53                   	push   %ebx
8010539e:	e8 7d c9 ff ff       	call   80101d20 <namecmp>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	0f 84 e2 00 00 00    	je     80105490 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053ae:	83 ec 04             	sub    $0x4,%esp
801053b1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053b4:	50                   	push   %eax
801053b5:	53                   	push   %ebx
801053b6:	57                   	push   %edi
801053b7:	e8 84 c9 ff ff       	call   80101d40 <dirlookup>
801053bc:	83 c4 10             	add    $0x10,%esp
801053bf:	89 c3                	mov    %eax,%ebx
801053c1:	85 c0                	test   %eax,%eax
801053c3:	0f 84 c7 00 00 00    	je     80105490 <sys_unlink+0x160>
  ilock(ip);
801053c9:	83 ec 0c             	sub    $0xc,%esp
801053cc:	50                   	push   %eax
801053cd:	e8 1e c4 ff ff       	call   801017f0 <ilock>
  if(ip->nlink < 1)
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053da:	0f 8e fd 00 00 00    	jle    801054dd <sys_unlink+0x1ad>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053e5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053e8:	74 66                	je     80105450 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053ea:	83 ec 04             	sub    $0x4,%esp
801053ed:	6a 10                	push   $0x10
801053ef:	6a 00                	push   $0x0
801053f1:	57                   	push   %edi
801053f2:	e8 a9 f5 ff ff       	call   801049a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053f7:	6a 10                	push   $0x10
801053f9:	ff 75 c4             	push   -0x3c(%ebp)
801053fc:	57                   	push   %edi
801053fd:	ff 75 b4             	push   -0x4c(%ebp)
80105400:	e8 fb c7 ff ff       	call   80101c00 <writei>
80105405:	83 c4 20             	add    $0x20,%esp
80105408:	83 f8 10             	cmp    $0x10,%eax
8010540b:	0f 85 d9 00 00 00    	jne    801054ea <sys_unlink+0x1ba>
  if(ip->type == T_DIR){
80105411:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105416:	0f 84 94 00 00 00    	je     801054b0 <sys_unlink+0x180>
  iunlockput(dp);
8010541c:	83 ec 0c             	sub    $0xc,%esp
8010541f:	ff 75 b4             	push   -0x4c(%ebp)
80105422:	e8 59 c6 ff ff       	call   80101a80 <iunlockput>
  ip->nlink--;
80105427:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010542c:	89 1c 24             	mov    %ebx,(%esp)
8010542f:	e8 0c c3 ff ff       	call   80101740 <iupdate>
  iunlockput(ip);
80105434:	89 1c 24             	mov    %ebx,(%esp)
80105437:	e8 44 c6 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010543c:	e8 6f da ff ff       	call   80102eb0 <end_op>
  return 0;
80105441:	83 c4 10             	add    $0x10,%esp
80105444:	31 c0                	xor    %eax,%eax
}
80105446:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105449:	5b                   	pop    %ebx
8010544a:	5e                   	pop    %esi
8010544b:	5f                   	pop    %edi
8010544c:	5d                   	pop    %ebp
8010544d:	c3                   	ret
8010544e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105450:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105454:	76 94                	jbe    801053ea <sys_unlink+0xba>
80105456:	be 20 00 00 00       	mov    $0x20,%esi
8010545b:	eb 0b                	jmp    80105468 <sys_unlink+0x138>
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
80105460:	83 c6 10             	add    $0x10,%esi
80105463:	3b 73 58             	cmp    0x58(%ebx),%esi
80105466:	73 82                	jae    801053ea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105468:	6a 10                	push   $0x10
8010546a:	56                   	push   %esi
8010546b:	57                   	push   %edi
8010546c:	53                   	push   %ebx
8010546d:	e8 8e c6 ff ff       	call   80101b00 <readi>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	83 f8 10             	cmp    $0x10,%eax
80105478:	75 56                	jne    801054d0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010547a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010547f:	74 df                	je     80105460 <sys_unlink+0x130>
    iunlockput(ip);
80105481:	83 ec 0c             	sub    $0xc,%esp
80105484:	53                   	push   %ebx
80105485:	e8 f6 c5 ff ff       	call   80101a80 <iunlockput>
    goto bad;
8010548a:	83 c4 10             	add    $0x10,%esp
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	ff 75 b4             	push   -0x4c(%ebp)
80105496:	e8 e5 c5 ff ff       	call   80101a80 <iunlockput>
  end_op();
8010549b:	e8 10 da ff ff       	call   80102eb0 <end_op>
  return -1;
801054a0:	83 c4 10             	add    $0x10,%esp
    return -1;
801054a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054a8:	eb 9c                	jmp    80105446 <sys_unlink+0x116>
801054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801054b0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801054b3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801054b6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801054bb:	50                   	push   %eax
801054bc:	e8 7f c2 ff ff       	call   80101740 <iupdate>
801054c1:	83 c4 10             	add    $0x10,%esp
801054c4:	e9 53 ff ff ff       	jmp    8010541c <sys_unlink+0xec>
    end_op();
801054c9:	e8 e2 d9 ff ff       	call   80102eb0 <end_op>
    return -1;
801054ce:	eb d3                	jmp    801054a3 <sys_unlink+0x173>
      panic("isdirempty: readi");
801054d0:	83 ec 0c             	sub    $0xc,%esp
801054d3:	68 0d 79 10 80       	push   $0x8010790d
801054d8:	e8 c3 ae ff ff       	call   801003a0 <panic>
    panic("unlink: nlink < 1");
801054dd:	83 ec 0c             	sub    $0xc,%esp
801054e0:	68 fb 78 10 80       	push   $0x801078fb
801054e5:	e8 b6 ae ff ff       	call   801003a0 <panic>
    panic("unlink: writei");
801054ea:	83 ec 0c             	sub    $0xc,%esp
801054ed:	68 1f 79 10 80       	push   $0x8010791f
801054f2:	e8 a9 ae ff ff       	call   801003a0 <panic>
801054f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054fe:	00 
801054ff:	90                   	nop

80105500 <sys_open>:

int
sys_open(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	57                   	push   %edi
80105504:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105505:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105508:	53                   	push   %ebx
80105509:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010550c:	50                   	push   %eax
8010550d:	6a 00                	push   $0x0
8010550f:	e8 1c f8 ff ff       	call   80104d30 <argstr>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	0f 88 8e 00 00 00    	js     801055ad <sys_open+0xad>
8010551f:	83 ec 08             	sub    $0x8,%esp
80105522:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105525:	50                   	push   %eax
80105526:	6a 01                	push   $0x1
80105528:	e8 43 f7 ff ff       	call   80104c70 <argint>
8010552d:	83 c4 10             	add    $0x10,%esp
80105530:	85 c0                	test   %eax,%eax
80105532:	78 79                	js     801055ad <sys_open+0xad>
    return -1;

  begin_op();
80105534:	e8 07 d9 ff ff       	call   80102e40 <begin_op>

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(omode & O_CREATE){
8010553c:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105540:	75 76                	jne    801055b8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105542:	83 ec 0c             	sub    $0xc,%esp
80105545:	50                   	push   %eax
80105546:	e8 b5 cb ff ff       	call   80102100 <namei>
8010554b:	83 c4 10             	add    $0x10,%esp
8010554e:	89 c6                	mov    %eax,%esi
80105550:	85 c0                	test   %eax,%eax
80105552:	74 7e                	je     801055d2 <sys_open+0xd2>
      end_op();
      return -1;
    }
    ilock(ip);
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	50                   	push   %eax
80105558:	e8 93 c2 ff ff       	call   801017f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105565:	0f 84 bd 00 00 00    	je     80105628 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010556b:	e8 30 b9 ff ff       	call   80100ea0 <filealloc>
80105570:	89 c7                	mov    %eax,%edi
80105572:	85 c0                	test   %eax,%eax
80105574:	74 26                	je     8010559c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105576:	e8 05 e5 ff ff       	call   80103a80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010557b:	31 db                	xor    %ebx,%ebx
8010557d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105580:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105584:	85 d2                	test   %edx,%edx
80105586:	74 58                	je     801055e0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105588:	83 c3 01             	add    $0x1,%ebx
8010558b:	83 fb 10             	cmp    $0x10,%ebx
8010558e:	75 f0                	jne    80105580 <sys_open+0x80>
    if(f)
      fileclose(f);
80105590:	83 ec 0c             	sub    $0xc,%esp
80105593:	57                   	push   %edi
80105594:	e8 c7 b9 ff ff       	call   80100f60 <fileclose>
80105599:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010559c:	83 ec 0c             	sub    $0xc,%esp
8010559f:	56                   	push   %esi
801055a0:	e8 db c4 ff ff       	call   80101a80 <iunlockput>
    end_op();
801055a5:	e8 06 d9 ff ff       	call   80102eb0 <end_op>
    return -1;
801055aa:	83 c4 10             	add    $0x10,%esp
    return -1;
801055ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055b2:	eb 65                	jmp    80105619 <sys_open+0x119>
801055b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801055b8:	83 ec 0c             	sub    $0xc,%esp
801055bb:	31 c9                	xor    %ecx,%ecx
801055bd:	ba 02 00 00 00       	mov    $0x2,%edx
801055c2:	6a 00                	push   $0x0
801055c4:	e8 57 f8 ff ff       	call   80104e20 <create>
    if(ip == 0){
801055c9:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801055cc:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055ce:	85 c0                	test   %eax,%eax
801055d0:	75 99                	jne    8010556b <sys_open+0x6b>
      end_op();
801055d2:	e8 d9 d8 ff ff       	call   80102eb0 <end_op>
      return -1;
801055d7:	eb d4                	jmp    801055ad <sys_open+0xad>
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055e3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055e7:	56                   	push   %esi
801055e8:	e8 e3 c2 ff ff       	call   801018d0 <iunlock>
  end_op();
801055ed:	e8 be d8 ff ff       	call   80102eb0 <end_op>

  f->type = FD_INODE;
801055f2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055fb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055fe:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105601:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105603:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010560a:	f7 d0                	not    %eax
8010560c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010560f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105612:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105615:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010561c:	89 d8                	mov    %ebx,%eax
8010561e:	5b                   	pop    %ebx
8010561f:	5e                   	pop    %esi
80105620:	5f                   	pop    %edi
80105621:	5d                   	pop    %ebp
80105622:	c3                   	ret
80105623:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105628:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010562b:	85 c9                	test   %ecx,%ecx
8010562d:	0f 84 38 ff ff ff    	je     8010556b <sys_open+0x6b>
80105633:	e9 64 ff ff ff       	jmp    8010559c <sys_open+0x9c>
80105638:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010563f:	00 

80105640 <sys_mkdir>:

int
sys_mkdir(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105646:	e8 f5 d7 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010564b:	83 ec 08             	sub    $0x8,%esp
8010564e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105651:	50                   	push   %eax
80105652:	6a 00                	push   $0x0
80105654:	e8 d7 f6 ff ff       	call   80104d30 <argstr>
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	85 c0                	test   %eax,%eax
8010565e:	78 30                	js     80105690 <sys_mkdir+0x50>
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105666:	31 c9                	xor    %ecx,%ecx
80105668:	ba 01 00 00 00       	mov    $0x1,%edx
8010566d:	6a 00                	push   $0x0
8010566f:	e8 ac f7 ff ff       	call   80104e20 <create>
80105674:	83 c4 10             	add    $0x10,%esp
80105677:	85 c0                	test   %eax,%eax
80105679:	74 15                	je     80105690 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010567b:	83 ec 0c             	sub    $0xc,%esp
8010567e:	50                   	push   %eax
8010567f:	e8 fc c3 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105684:	e8 27 d8 ff ff       	call   80102eb0 <end_op>
  return 0;
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	31 c0                	xor    %eax,%eax
}
8010568e:	c9                   	leave
8010568f:	c3                   	ret
    end_op();
80105690:	e8 1b d8 ff ff       	call   80102eb0 <end_op>
    return -1;
80105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569a:	c9                   	leave
8010569b:	c3                   	ret
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_mknod>:

int
sys_mknod(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801056a6:	e8 95 d7 ff ff       	call   80102e40 <begin_op>
  if((argstr(0, &path)) < 0 ||
801056ab:	83 ec 08             	sub    $0x8,%esp
801056ae:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056b1:	50                   	push   %eax
801056b2:	6a 00                	push   $0x0
801056b4:	e8 77 f6 ff ff       	call   80104d30 <argstr>
801056b9:	83 c4 10             	add    $0x10,%esp
801056bc:	85 c0                	test   %eax,%eax
801056be:	78 60                	js     80105720 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056c0:	83 ec 08             	sub    $0x8,%esp
801056c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056c6:	50                   	push   %eax
801056c7:	6a 01                	push   $0x1
801056c9:	e8 a2 f5 ff ff       	call   80104c70 <argint>
  if((argstr(0, &path)) < 0 ||
801056ce:	83 c4 10             	add    $0x10,%esp
801056d1:	85 c0                	test   %eax,%eax
801056d3:	78 4b                	js     80105720 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056d5:	83 ec 08             	sub    $0x8,%esp
801056d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056db:	50                   	push   %eax
801056dc:	6a 02                	push   $0x2
801056de:	e8 8d f5 ff ff       	call   80104c70 <argint>
     argint(1, &major) < 0 ||
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 c0                	test   %eax,%eax
801056e8:	78 36                	js     80105720 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801056ee:	83 ec 0c             	sub    $0xc,%esp
801056f1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056f5:	ba 03 00 00 00       	mov    $0x3,%edx
801056fa:	50                   	push   %eax
801056fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056fe:	e8 1d f7 ff ff       	call   80104e20 <create>
     argint(2, &minor) < 0 ||
80105703:	83 c4 10             	add    $0x10,%esp
80105706:	85 c0                	test   %eax,%eax
80105708:	74 16                	je     80105720 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010570a:	83 ec 0c             	sub    $0xc,%esp
8010570d:	50                   	push   %eax
8010570e:	e8 6d c3 ff ff       	call   80101a80 <iunlockput>
  end_op();
80105713:	e8 98 d7 ff ff       	call   80102eb0 <end_op>
  return 0;
80105718:	83 c4 10             	add    $0x10,%esp
8010571b:	31 c0                	xor    %eax,%eax
}
8010571d:	c9                   	leave
8010571e:	c3                   	ret
8010571f:	90                   	nop
    end_op();
80105720:	e8 8b d7 ff ff       	call   80102eb0 <end_op>
    return -1;
80105725:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010572a:	c9                   	leave
8010572b:	c3                   	ret
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_chdir>:

int
sys_chdir(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	56                   	push   %esi
80105734:	53                   	push   %ebx
80105735:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105738:	e8 43 e3 ff ff       	call   80103a80 <myproc>
8010573d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010573f:	e8 fc d6 ff ff       	call   80102e40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105744:	83 ec 08             	sub    $0x8,%esp
80105747:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010574a:	50                   	push   %eax
8010574b:	6a 00                	push   $0x0
8010574d:	e8 de f5 ff ff       	call   80104d30 <argstr>
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	85 c0                	test   %eax,%eax
80105757:	78 77                	js     801057d0 <sys_chdir+0xa0>
80105759:	83 ec 0c             	sub    $0xc,%esp
8010575c:	ff 75 f4             	push   -0xc(%ebp)
8010575f:	e8 9c c9 ff ff       	call   80102100 <namei>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	89 c3                	mov    %eax,%ebx
80105769:	85 c0                	test   %eax,%eax
8010576b:	74 63                	je     801057d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010576d:	83 ec 0c             	sub    $0xc,%esp
80105770:	50                   	push   %eax
80105771:	e8 7a c0 ff ff       	call   801017f0 <ilock>
  if(ip->type != T_DIR){
80105776:	83 c4 10             	add    $0x10,%esp
80105779:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010577e:	75 30                	jne    801057b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105780:	83 ec 0c             	sub    $0xc,%esp
80105783:	53                   	push   %ebx
80105784:	e8 47 c1 ff ff       	call   801018d0 <iunlock>
  iput(curproc->cwd);
80105789:	58                   	pop    %eax
8010578a:	ff 76 68             	push   0x68(%esi)
8010578d:	e8 8e c1 ff ff       	call   80101920 <iput>
  end_op();
80105792:	e8 19 d7 ff ff       	call   80102eb0 <end_op>
  curproc->cwd = ip;
80105797:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010579a:	83 c4 10             	add    $0x10,%esp
8010579d:	31 c0                	xor    %eax,%eax
}
8010579f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057a2:	5b                   	pop    %ebx
801057a3:	5e                   	pop    %esi
801057a4:	5d                   	pop    %ebp
801057a5:	c3                   	ret
801057a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057ad:	00 
801057ae:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	53                   	push   %ebx
801057b4:	e8 c7 c2 ff ff       	call   80101a80 <iunlockput>
    end_op();
801057b9:	e8 f2 d6 ff ff       	call   80102eb0 <end_op>
    return -1;
801057be:	83 c4 10             	add    $0x10,%esp
    return -1;
801057c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057c6:	eb d7                	jmp    8010579f <sys_chdir+0x6f>
801057c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057cf:	00 
    end_op();
801057d0:	e8 db d6 ff ff       	call   80102eb0 <end_op>
    return -1;
801057d5:	eb ea                	jmp    801057c1 <sys_chdir+0x91>
801057d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057de:	00 
801057df:	90                   	nop

801057e0 <sys_exec>:

int
sys_exec(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	57                   	push   %edi
801057e4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057e5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057eb:	53                   	push   %ebx
801057ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057f2:	50                   	push   %eax
801057f3:	6a 00                	push   $0x0
801057f5:	e8 36 f5 ff ff       	call   80104d30 <argstr>
801057fa:	83 c4 10             	add    $0x10,%esp
801057fd:	85 c0                	test   %eax,%eax
801057ff:	0f 88 87 00 00 00    	js     8010588c <sys_exec+0xac>
80105805:	83 ec 08             	sub    $0x8,%esp
80105808:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010580e:	50                   	push   %eax
8010580f:	6a 01                	push   $0x1
80105811:	e8 5a f4 ff ff       	call   80104c70 <argint>
80105816:	83 c4 10             	add    $0x10,%esp
80105819:	85 c0                	test   %eax,%eax
8010581b:	78 6f                	js     8010588c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010581d:	83 ec 04             	sub    $0x4,%esp
80105820:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105826:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105828:	68 80 00 00 00       	push   $0x80
8010582d:	6a 00                	push   $0x0
8010582f:	56                   	push   %esi
80105830:	e8 6b f1 ff ff       	call   801049a0 <memset>
80105835:	83 c4 10             	add    $0x10,%esp
80105838:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010583f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105840:	83 ec 08             	sub    $0x8,%esp
80105843:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105849:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105850:	50                   	push   %eax
80105851:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105857:	01 f8                	add    %edi,%eax
80105859:	50                   	push   %eax
8010585a:	e8 71 f3 ff ff       	call   80104bd0 <fetchint>
8010585f:	83 c4 10             	add    $0x10,%esp
80105862:	85 c0                	test   %eax,%eax
80105864:	78 26                	js     8010588c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105866:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010586c:	85 c0                	test   %eax,%eax
8010586e:	74 30                	je     801058a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105870:	83 ec 08             	sub    $0x8,%esp
80105873:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105876:	52                   	push   %edx
80105877:	50                   	push   %eax
80105878:	e8 93 f3 ff ff       	call   80104c10 <fetchstr>
8010587d:	83 c4 10             	add    $0x10,%esp
80105880:	85 c0                	test   %eax,%eax
80105882:	78 08                	js     8010588c <sys_exec+0xac>
  for(i=0;; i++){
80105884:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105887:	83 fb 20             	cmp    $0x20,%ebx
8010588a:	75 b4                	jne    80105840 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010588c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010588f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105894:	5b                   	pop    %ebx
80105895:	5e                   	pop    %esi
80105896:	5f                   	pop    %edi
80105897:	5d                   	pop    %ebp
80105898:	c3                   	ret
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801058a0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801058a7:	00 00 00 00 
  return exec(path, argv);
801058ab:	83 ec 08             	sub    $0x8,%esp
801058ae:	56                   	push   %esi
801058af:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801058b5:	e8 36 b2 ff ff       	call   80100af0 <exec>
801058ba:	83 c4 10             	add    $0x10,%esp
}
801058bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c0:	5b                   	pop    %ebx
801058c1:	5e                   	pop    %esi
801058c2:	5f                   	pop    %edi
801058c3:	5d                   	pop    %ebp
801058c4:	c3                   	ret
801058c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058cc:	00 
801058cd:	8d 76 00             	lea    0x0(%esi),%esi

801058d0 <sys_pipe>:

int
sys_pipe(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058d5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058d8:	53                   	push   %ebx
801058d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058dc:	6a 08                	push   $0x8
801058de:	50                   	push   %eax
801058df:	6a 00                	push   $0x0
801058e1:	e8 da f3 ff ff       	call   80104cc0 <argptr>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	0f 88 93 00 00 00    	js     80105984 <sys_pipe+0xb4>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058f1:	83 ec 08             	sub    $0x8,%esp
801058f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058f7:	50                   	push   %eax
801058f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058fb:	50                   	push   %eax
801058fc:	e8 ff db ff ff       	call   80103500 <pipealloc>
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	85 c0                	test   %eax,%eax
80105906:	78 7c                	js     80105984 <sys_pipe+0xb4>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105908:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010590b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010590d:	e8 6e e1 ff ff       	call   80103a80 <myproc>
    if(curproc->ofile[fd] == 0){
80105912:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105916:	85 f6                	test   %esi,%esi
80105918:	74 16                	je     80105930 <sys_pipe+0x60>
8010591a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105920:	83 c3 01             	add    $0x1,%ebx
80105923:	83 fb 10             	cmp    $0x10,%ebx
80105926:	74 45                	je     8010596d <sys_pipe+0x9d>
    if(curproc->ofile[fd] == 0){
80105928:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010592c:	85 f6                	test   %esi,%esi
8010592e:	75 f0                	jne    80105920 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105930:	8d 73 08             	lea    0x8(%ebx),%esi
80105933:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105937:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010593a:	e8 41 e1 ff ff       	call   80103a80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010593f:	31 d2                	xor    %edx,%edx
80105941:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105948:	00 
80105949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105950:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105954:	85 c9                	test   %ecx,%ecx
80105956:	74 38                	je     80105990 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105958:	83 c2 01             	add    $0x1,%edx
8010595b:	83 fa 10             	cmp    $0x10,%edx
8010595e:	75 f0                	jne    80105950 <sys_pipe+0x80>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105960:	e8 1b e1 ff ff       	call   80103a80 <myproc>
80105965:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010596c:	00 
    fileclose(rf);
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	ff 75 e0             	push   -0x20(%ebp)
80105973:	e8 e8 b5 ff ff       	call   80100f60 <fileclose>
    fileclose(wf);
80105978:	58                   	pop    %eax
80105979:	ff 75 e4             	push   -0x1c(%ebp)
8010597c:	e8 df b5 ff ff       	call   80100f60 <fileclose>
    return -1;
80105981:	83 c4 10             	add    $0x10,%esp
    return -1;
80105984:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105989:	eb 16                	jmp    801059a1 <sys_pipe+0xd1>
8010598b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105990:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105994:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105997:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105999:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010599c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010599f:	31 c0                	xor    %eax,%eax
}
801059a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a4:	5b                   	pop    %ebx
801059a5:	5e                   	pop    %esi
801059a6:	5f                   	pop    %edi
801059a7:	5d                   	pop    %ebp
801059a8:	c3                   	ret
801059a9:	66 90                	xchg   %ax,%ax
801059ab:	66 90                	xchg   %ax,%ax
801059ad:	66 90                	xchg   %ax,%ax
801059af:	90                   	nop

801059b0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801059b0:	e9 6b e2 ff ff       	jmp    80103c20 <fork>
801059b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059bc:	00 
801059bd:	8d 76 00             	lea    0x0(%esi),%esi

801059c0 <sys_exit>:
}

int
sys_exit(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801059c6:	e8 c5 e4 ff ff       	call   80103e90 <exit>
  return 0;  // not reached
}
801059cb:	31 c0                	xor    %eax,%eax
801059cd:	c9                   	leave
801059ce:	c3                   	ret
801059cf:	90                   	nop

801059d0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801059d0:	e9 fb e5 ff ff       	jmp    80103fd0 <wait>
801059d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059dc:	00 
801059dd:	8d 76 00             	lea    0x0(%esi),%esi

801059e0 <sys_kill>:
}

int
sys_kill(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e9:	50                   	push   %eax
801059ea:	6a 00                	push   $0x0
801059ec:	e8 7f f2 ff ff       	call   80104c70 <argint>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	78 18                	js     80105a10 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	ff 75 f4             	push   -0xc(%ebp)
801059fe:	e8 7d e8 ff ff       	call   80104280 <kill>
80105a03:	83 c4 10             	add    $0x10,%esp
}
80105a06:	c9                   	leave
80105a07:	c3                   	ret
80105a08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a0f:	00 
80105a10:	c9                   	leave
    return -1;
80105a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a16:	c3                   	ret
80105a17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a1e:	00 
80105a1f:	90                   	nop

80105a20 <sys_getpid>:

int
sys_getpid(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a26:	e8 55 e0 ff ff       	call   80103a80 <myproc>
80105a2b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a2e:	c9                   	leave
80105a2f:	c3                   	ret

80105a30 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a3a:	50                   	push   %eax
80105a3b:	6a 00                	push   $0x0
80105a3d:	e8 2e f2 ff ff       	call   80104c70 <argint>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	78 27                	js     80105a70 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a49:	e8 32 e0 ff ff       	call   80103a80 <myproc>
  if(growproc(n) < 0)
80105a4e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a51:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a53:	ff 75 f4             	push   -0xc(%ebp)
80105a56:	e8 45 e1 ff ff       	call   80103ba0 <growproc>
80105a5b:	83 c4 10             	add    $0x10,%esp
80105a5e:	85 c0                	test   %eax,%eax
80105a60:	78 0e                	js     80105a70 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a62:	89 d8                	mov    %ebx,%eax
80105a64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a67:	c9                   	leave
80105a68:	c3                   	ret
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a70:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a75:	eb eb                	jmp    80105a62 <sys_sbrk+0x32>
80105a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a7e:	00 
80105a7f:	90                   	nop

80105a80 <sys_sleep>:

int
sys_sleep(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a8a:	50                   	push   %eax
80105a8b:	6a 00                	push   $0x0
80105a8d:	e8 de f1 ff ff       	call   80104c70 <argint>
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	85 c0                	test   %eax,%eax
80105a97:	78 64                	js     80105afd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105a99:	83 ec 0c             	sub    $0xc,%esp
80105a9c:	68 80 3d 11 80       	push   $0x80113d80
80105aa1:	e8 ca ed ff ff       	call   80104870 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105aa9:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  while(ticks - ticks0 < n){
80105aaf:	83 c4 10             	add    $0x10,%esp
80105ab2:	85 d2                	test   %edx,%edx
80105ab4:	75 2b                	jne    80105ae1 <sys_sleep+0x61>
80105ab6:	eb 50                	jmp    80105b08 <sys_sleep+0x88>
80105ab8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105abf:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ac0:	83 ec 08             	sub    $0x8,%esp
80105ac3:	68 80 3d 11 80       	push   $0x80113d80
80105ac8:	68 60 3d 11 80       	push   $0x80113d60
80105acd:	e8 8e e6 ff ff       	call   80104160 <sleep>
  while(ticks - ticks0 < n){
80105ad2:	a1 60 3d 11 80       	mov    0x80113d60,%eax
80105ad7:	83 c4 10             	add    $0x10,%esp
80105ada:	29 d8                	sub    %ebx,%eax
80105adc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105adf:	73 27                	jae    80105b08 <sys_sleep+0x88>
    if(myproc()->killed){
80105ae1:	e8 9a df ff ff       	call   80103a80 <myproc>
80105ae6:	8b 40 24             	mov    0x24(%eax),%eax
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	74 d3                	je     80105ac0 <sys_sleep+0x40>
      release(&tickslock);
80105aed:	83 ec 0c             	sub    $0xc,%esp
80105af0:	68 80 3d 11 80       	push   $0x80113d80
80105af5:	e8 16 ed ff ff       	call   80104810 <release>
      return -1;
80105afa:	83 c4 10             	add    $0x10,%esp
    return -1;
80105afd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b02:	eb 16                	jmp    80105b1a <sys_sleep+0x9a>
80105b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  release(&tickslock);
80105b08:	83 ec 0c             	sub    $0xc,%esp
80105b0b:	68 80 3d 11 80       	push   $0x80113d80
80105b10:	e8 fb ec ff ff       	call   80104810 <release>
  return 0;
80105b15:	83 c4 10             	add    $0x10,%esp
80105b18:	31 c0                	xor    %eax,%eax
}
80105b1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b1d:	c9                   	leave
80105b1e:	c3                   	ret
80105b1f:	90                   	nop

80105b20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	53                   	push   %ebx
80105b24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b27:	68 80 3d 11 80       	push   $0x80113d80
80105b2c:	e8 3f ed ff ff       	call   80104870 <acquire>
  xticks = ticks;
80105b31:	8b 1d 60 3d 11 80    	mov    0x80113d60,%ebx
  release(&tickslock);
80105b37:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80105b3e:	e8 cd ec ff ff       	call   80104810 <release>
  return xticks;
}
80105b43:	89 d8                	mov    %ebx,%eax
80105b45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b48:	c9                   	leave
80105b49:	c3                   	ret
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b50 <sys_getnumproc>:

int 
sys_getnumproc(void){
  return getNumProc();
80105b50:	e9 7b e8 ff ff       	jmp    801043d0 <getNumProc>
80105b55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b5c:	00 
80105b5d:	8d 76 00             	lea    0x0(%esi),%esi

80105b60 <sys_getmaxpid>:
}

int
sys_getmaxpid(void){
  return getMaxPid();
80105b60:	e9 cb e8 ff ff       	jmp    80104430 <getMaxPid>
80105b65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b6c:	00 
80105b6d:	8d 76 00             	lea    0x0(%esi),%esi

80105b70 <sys_getprocinfo>:
}

int
sys_getprocinfo(void) {
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	53                   	push   %ebx
  int pid;
  struct processInfo proc_info;

  if(argint(0, &pid) < 0)
80105b74:	8d 45 e0             	lea    -0x20(%ebp),%eax
sys_getprocinfo(void) {
80105b77:	83 ec 2c             	sub    $0x2c,%esp
  if(argint(0, &pid) < 0)
80105b7a:	50                   	push   %eax
80105b7b:	6a 00                	push   $0x0
80105b7d:	e8 ee f0 ff ff       	call   80104c70 <argint>
80105b82:	83 c4 10             	add    $0x10,%esp
80105b85:	85 c0                	test   %eax,%eax
80105b87:	78 37                	js     80105bc0 <sys_getprocinfo+0x50>
    return -1;

  if(getProcInfo(pid, &proc_info) < 0)
80105b89:	83 ec 08             	sub    $0x8,%esp
80105b8c:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
80105b8f:	53                   	push   %ebx
80105b90:	ff 75 e0             	push   -0x20(%ebp)
80105b93:	e8 f8 e8 ff ff       	call   80104490 <getProcInfo>
80105b98:	83 c4 10             	add    $0x10,%esp
80105b9b:	85 c0                	test   %eax,%eax
80105b9d:	78 21                	js     80105bc0 <sys_getprocinfo+0x50>
    return -1;

  if(argptr(1, (void*)&proc_info, sizeof(proc_info)) < 0)
80105b9f:	83 ec 04             	sub    $0x4,%esp
80105ba2:	6a 14                	push   $0x14
80105ba4:	53                   	push   %ebx
80105ba5:	6a 01                	push   $0x1
80105ba7:	e8 14 f1 ff ff       	call   80104cc0 <argptr>
80105bac:	83 c4 10             	add    $0x10,%esp
80105baf:	c1 f8 1f             	sar    $0x1f,%eax
    return -1;

  return 0;
}
80105bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bb5:	c9                   	leave
80105bb6:	c3                   	ret
80105bb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105bbe:	00 
80105bbf:	90                   	nop
    return -1;
80105bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc5:	eb eb                	jmp    80105bb2 <sys_getprocinfo+0x42>

80105bc7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105bc7:	1e                   	push   %ds
  pushl %es
80105bc8:	06                   	push   %es
  pushl %fs
80105bc9:	0f a0                	push   %fs
  pushl %gs
80105bcb:	0f a8                	push   %gs
  pushal
80105bcd:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105bce:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105bd2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105bd4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105bd6:	54                   	push   %esp
  call trap
80105bd7:	e8 04 01 00 00       	call   80105ce0 <trap>
  addl $4, %esp
80105bdc:	83 c4 04             	add    $0x4,%esp

80105bdf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105bdf:	61                   	popa
  popl %gs
80105be0:	0f a9                	pop    %gs
  popl %fs
80105be2:	0f a1                	pop    %fs
  popl %es
80105be4:	07                   	pop    %es
  popl %ds
80105be5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105be6:	83 c4 08             	add    $0x8,%esp
  iret
80105be9:	cf                   	iret
80105bea:	66 90                	xchg   %ax,%ax
80105bec:	66 90                	xchg   %ax,%ax
80105bee:	66 90                	xchg   %ax,%ax
80105bf0:	66 90                	xchg   %ax,%ax
80105bf2:	66 90                	xchg   %ax,%ax
80105bf4:	66 90                	xchg   %ax,%ax
80105bf6:	66 90                	xchg   %ax,%ax
80105bf8:	66 90                	xchg   %ax,%ax
80105bfa:	66 90                	xchg   %ax,%ax
80105bfc:	66 90                	xchg   %ax,%ax
80105bfe:	66 90                	xchg   %ax,%ax

80105c00 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c00:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c01:	31 c0                	xor    %eax,%eax
{
80105c03:	89 e5                	mov    %esp,%ebp
80105c05:	83 ec 08             	sub    $0x8,%esp
80105c08:	eb 36                	jmp    80105c40 <tvinit+0x40>
80105c0a:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c11:	00 
80105c12:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c19:	00 
80105c1a:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c21:	00 
80105c22:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c29:	00 
80105c2a:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c31:	00 
80105c32:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c39:	00 
80105c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c40:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105c47:	c7 04 c5 c2 3d 11 80 	movl   $0x8e000008,-0x7feec23e(,%eax,8)
80105c4e:	08 00 00 8e 
80105c52:	66 89 14 c5 c0 3d 11 	mov    %dx,-0x7feec240(,%eax,8)
80105c59:	80 
80105c5a:	c1 ea 10             	shr    $0x10,%edx
80105c5d:	66 89 14 c5 c6 3d 11 	mov    %dx,-0x7feec23a(,%eax,8)
80105c64:	80 
  for(i = 0; i < 256; i++)
80105c65:	83 c0 01             	add    $0x1,%eax
80105c68:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c6d:	75 d1                	jne    80105c40 <tvinit+0x40>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105c6f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c72:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105c77:	c7 05 c2 3f 11 80 08 	movl   $0xef000008,0x80113fc2
80105c7e:	00 00 ef 
  initlock(&tickslock, "time");
80105c81:	68 2e 79 10 80       	push   $0x8010792e
80105c86:	68 80 3d 11 80       	push   $0x80113d80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c8b:	66 a3 c0 3f 11 80    	mov    %ax,0x80113fc0
80105c91:	c1 e8 10             	shr    $0x10,%eax
80105c94:	66 a3 c6 3f 11 80    	mov    %ax,0x80113fc6
  initlock(&tickslock, "time");
80105c9a:	e8 c1 e9 ff ff       	call   80104660 <initlock>
}
80105c9f:	83 c4 10             	add    $0x10,%esp
80105ca2:	c9                   	leave
80105ca3:	c3                   	ret
80105ca4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cab:	00 
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <idtinit>:

void
idtinit(void)
{
80105cb0:	55                   	push   %ebp
  pd[0] = size-1;
80105cb1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cb6:	89 e5                	mov    %esp,%ebp
80105cb8:	83 ec 10             	sub    $0x10,%esp
80105cbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cbf:	b8 c0 3d 11 80       	mov    $0x80113dc0,%eax
80105cc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105cc8:	c1 e8 10             	shr    $0x10,%eax
80105ccb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ccf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105cd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105cd5:	c9                   	leave
80105cd6:	c3                   	ret
80105cd7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105cde:	00 
80105cdf:	90                   	nop

80105ce0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	57                   	push   %edi
80105ce4:	56                   	push   %esi
80105ce5:	53                   	push   %ebx
80105ce6:	83 ec 1c             	sub    $0x1c,%esp
80105ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105cec:	8b 43 30             	mov    0x30(%ebx),%eax
80105cef:	83 f8 40             	cmp    $0x40,%eax
80105cf2:	0f 84 58 01 00 00    	je     80105e50 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105cf8:	83 e8 20             	sub    $0x20,%eax
80105cfb:	83 f8 1f             	cmp    $0x1f,%eax
80105cfe:	0f 87 7c 00 00 00    	ja     80105d80 <trap+0xa0>
80105d04:	ff 24 85 84 7e 10 80 	jmp    *-0x7fef817c(,%eax,4)
80105d0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105d10:	e8 8b c5 ff ff       	call   801022a0 <ideintr>
    lapiceoi();
80105d15:	e8 96 cc ff ff       	call   801029b0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d1a:	e8 61 dd ff ff       	call   80103a80 <myproc>
80105d1f:	85 c0                	test   %eax,%eax
80105d21:	74 1a                	je     80105d3d <trap+0x5d>
80105d23:	e8 58 dd ff ff       	call   80103a80 <myproc>
80105d28:	8b 50 24             	mov    0x24(%eax),%edx
80105d2b:	85 d2                	test   %edx,%edx
80105d2d:	74 0e                	je     80105d3d <trap+0x5d>
80105d2f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d33:	f7 d0                	not    %eax
80105d35:	a8 03                	test   $0x3,%al
80105d37:	0f 84 db 01 00 00    	je     80105f18 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105d3d:	e8 3e dd ff ff       	call   80103a80 <myproc>
80105d42:	85 c0                	test   %eax,%eax
80105d44:	74 0f                	je     80105d55 <trap+0x75>
80105d46:	e8 35 dd ff ff       	call   80103a80 <myproc>
80105d4b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d4f:	0f 84 ab 00 00 00    	je     80105e00 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d55:	e8 26 dd ff ff       	call   80103a80 <myproc>
80105d5a:	85 c0                	test   %eax,%eax
80105d5c:	74 1a                	je     80105d78 <trap+0x98>
80105d5e:	e8 1d dd ff ff       	call   80103a80 <myproc>
80105d63:	8b 40 24             	mov    0x24(%eax),%eax
80105d66:	85 c0                	test   %eax,%eax
80105d68:	74 0e                	je     80105d78 <trap+0x98>
80105d6a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105d6e:	f7 d0                	not    %eax
80105d70:	a8 03                	test   $0x3,%al
80105d72:	0f 84 05 01 00 00    	je     80105e7d <trap+0x19d>
    exit();
}
80105d78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d7b:	5b                   	pop    %ebx
80105d7c:	5e                   	pop    %esi
80105d7d:	5f                   	pop    %edi
80105d7e:	5d                   	pop    %ebp
80105d7f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d80:	e8 fb dc ff ff       	call   80103a80 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d85:	8b 7b 38             	mov    0x38(%ebx),%edi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d88:	85 c0                	test   %eax,%eax
80105d8a:	0f 84 a2 01 00 00    	je     80105f32 <trap+0x252>
80105d90:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105d94:	0f 84 98 01 00 00    	je     80105f32 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d9a:	0f 20 d1             	mov    %cr2,%ecx
80105d9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105da0:	e8 bb dc ff ff       	call   80103a60 <cpuid>
80105da5:	8b 73 30             	mov    0x30(%ebx),%esi
80105da8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105dab:	8b 43 34             	mov    0x34(%ebx),%eax
80105dae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105db1:	e8 ca dc ff ff       	call   80103a80 <myproc>
80105db6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105db9:	e8 c2 dc ff ff       	call   80103a80 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dbe:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105dc1:	51                   	push   %ecx
80105dc2:	57                   	push   %edi
80105dc3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105dc6:	52                   	push   %edx
80105dc7:	ff 75 e4             	push   -0x1c(%ebp)
80105dca:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105dcb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105dce:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dd1:	56                   	push   %esi
80105dd2:	ff 70 10             	push   0x10(%eax)
80105dd5:	68 5c 7b 10 80       	push   $0x80107b5c
80105dda:	e8 f1 a8 ff ff       	call   801006d0 <cprintf>
    myproc()->killed = 1;
80105ddf:	83 c4 20             	add    $0x20,%esp
80105de2:	e8 99 dc ff ff       	call   80103a80 <myproc>
80105de7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dee:	e8 8d dc ff ff       	call   80103a80 <myproc>
80105df3:	85 c0                	test   %eax,%eax
80105df5:	0f 85 28 ff ff ff    	jne    80105d23 <trap+0x43>
80105dfb:	e9 3d ff ff ff       	jmp    80105d3d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105e00:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105e04:	0f 85 4b ff ff ff    	jne    80105d55 <trap+0x75>
    yield();
80105e0a:	e8 01 e3 ff ff       	call   80104110 <yield>
80105e0f:	e9 41 ff ff ff       	jmp    80105d55 <trap+0x75>
80105e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105e18:	8b 7b 38             	mov    0x38(%ebx),%edi
80105e1b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105e1f:	e8 3c dc ff ff       	call   80103a60 <cpuid>
80105e24:	57                   	push   %edi
80105e25:	56                   	push   %esi
80105e26:	50                   	push   %eax
80105e27:	68 04 7b 10 80       	push   $0x80107b04
80105e2c:	e8 9f a8 ff ff       	call   801006d0 <cprintf>
    lapiceoi();
80105e31:	e8 7a cb ff ff       	call   801029b0 <lapiceoi>
    break;
80105e36:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e39:	e8 42 dc ff ff       	call   80103a80 <myproc>
80105e3e:	85 c0                	test   %eax,%eax
80105e40:	0f 85 dd fe ff ff    	jne    80105d23 <trap+0x43>
80105e46:	e9 f2 fe ff ff       	jmp    80105d3d <trap+0x5d>
80105e4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105e50:	e8 2b dc ff ff       	call   80103a80 <myproc>
80105e55:	8b 70 24             	mov    0x24(%eax),%esi
80105e58:	85 f6                	test   %esi,%esi
80105e5a:	0f 85 c8 00 00 00    	jne    80105f28 <trap+0x248>
    myproc()->tf = tf;
80105e60:	e8 1b dc ff ff       	call   80103a80 <myproc>
80105e65:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105e68:	e8 43 ef ff ff       	call   80104db0 <syscall>
    if(myproc()->killed)
80105e6d:	e8 0e dc ff ff       	call   80103a80 <myproc>
80105e72:	8b 48 24             	mov    0x24(%eax),%ecx
80105e75:	85 c9                	test   %ecx,%ecx
80105e77:	0f 84 fb fe ff ff    	je     80105d78 <trap+0x98>
}
80105e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e80:	5b                   	pop    %ebx
80105e81:	5e                   	pop    %esi
80105e82:	5f                   	pop    %edi
80105e83:	5d                   	pop    %ebp
      exit();
80105e84:	e9 07 e0 ff ff       	jmp    80103e90 <exit>
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e90:	e8 3b 02 00 00       	call   801060d0 <uartintr>
    lapiceoi();
80105e95:	e8 16 cb ff ff       	call   801029b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e9a:	e8 e1 db ff ff       	call   80103a80 <myproc>
80105e9f:	85 c0                	test   %eax,%eax
80105ea1:	0f 85 7c fe ff ff    	jne    80105d23 <trap+0x43>
80105ea7:	e9 91 fe ff ff       	jmp    80105d3d <trap+0x5d>
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105eb0:	e8 bb c9 ff ff       	call   80102870 <kbdintr>
    lapiceoi();
80105eb5:	e8 f6 ca ff ff       	call   801029b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eba:	e8 c1 db ff ff       	call   80103a80 <myproc>
80105ebf:	85 c0                	test   %eax,%eax
80105ec1:	0f 85 5c fe ff ff    	jne    80105d23 <trap+0x43>
80105ec7:	e9 71 fe ff ff       	jmp    80105d3d <trap+0x5d>
80105ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ed0:	e8 8b db ff ff       	call   80103a60 <cpuid>
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	0f 85 38 fe ff ff    	jne    80105d15 <trap+0x35>
      acquire(&tickslock);
80105edd:	83 ec 0c             	sub    $0xc,%esp
80105ee0:	68 80 3d 11 80       	push   $0x80113d80
80105ee5:	e8 86 e9 ff ff       	call   80104870 <acquire>
      ticks++;
80105eea:	83 05 60 3d 11 80 01 	addl   $0x1,0x80113d60
      wakeup(&ticks);
80105ef1:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80105ef8:	e8 23 e3 ff ff       	call   80104220 <wakeup>
      release(&tickslock);
80105efd:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80105f04:	e8 07 e9 ff ff       	call   80104810 <release>
80105f09:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105f0c:	e9 04 fe ff ff       	jmp    80105d15 <trap+0x35>
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105f18:	e8 73 df ff ff       	call   80103e90 <exit>
80105f1d:	e9 1b fe ff ff       	jmp    80105d3d <trap+0x5d>
80105f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f28:	e8 63 df ff ff       	call   80103e90 <exit>
80105f2d:	e9 2e ff ff ff       	jmp    80105e60 <trap+0x180>
80105f32:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f35:	e8 26 db ff ff       	call   80103a60 <cpuid>
80105f3a:	83 ec 0c             	sub    $0xc,%esp
80105f3d:	56                   	push   %esi
80105f3e:	57                   	push   %edi
80105f3f:	50                   	push   %eax
80105f40:	ff 73 30             	push   0x30(%ebx)
80105f43:	68 28 7b 10 80       	push   $0x80107b28
80105f48:	e8 83 a7 ff ff       	call   801006d0 <cprintf>
      panic("trap");
80105f4d:	83 c4 14             	add    $0x14,%esp
80105f50:	68 33 79 10 80       	push   $0x80107933
80105f55:	e8 46 a4 ff ff       	call   801003a0 <panic>
80105f5a:	66 90                	xchg   %ax,%ax
80105f5c:	66 90                	xchg   %ax,%ax
80105f5e:	66 90                	xchg   %ax,%ax

80105f60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f60:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80105f65:	85 c0                	test   %eax,%eax
80105f67:	74 17                	je     80105f80 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f69:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f6e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f6f:	a8 01                	test   $0x1,%al
80105f71:	74 0d                	je     80105f80 <uartgetc+0x20>
80105f73:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f78:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f79:	0f b6 c0             	movzbl %al,%eax
80105f7c:	c3                   	ret
80105f7d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f85:	c3                   	ret
80105f86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f8d:	00 
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <uartinit>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f90:	31 c9                	xor    %ecx,%ecx
80105f92:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105f97:	89 c8                	mov    %ecx,%eax
80105f99:	ee                   	out    %al,(%dx)
80105f9a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f9f:	ba fb 03 00 00       	mov    $0x3fb,%edx
80105fa4:	ee                   	out    %al,(%dx)
80105fa5:	b8 0c 00 00 00       	mov    $0xc,%eax
80105faa:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105faf:	ee                   	out    %al,(%dx)
80105fb0:	ba f9 03 00 00       	mov    $0x3f9,%edx
80105fb5:	89 c8                	mov    %ecx,%eax
80105fb7:	ee                   	out    %al,(%dx)
80105fb8:	b8 03 00 00 00       	mov    $0x3,%eax
80105fbd:	ba fb 03 00 00       	mov    $0x3fb,%edx
80105fc2:	ee                   	out    %al,(%dx)
80105fc3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105fc8:	89 c8                	mov    %ecx,%eax
80105fca:	ee                   	out    %al,(%dx)
80105fcb:	b8 01 00 00 00       	mov    $0x1,%eax
80105fd0:	ba f9 03 00 00       	mov    $0x3f9,%edx
80105fd5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105fd6:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105fdb:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105fdc:	3c ff                	cmp    $0xff,%al
80105fde:	0f 84 85 00 00 00    	je     80106069 <uartinit+0xd9>
{
80105fe4:	55                   	push   %ebp
80105fe5:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105fea:	89 e5                	mov    %esp,%ebp
80105fec:	57                   	push   %edi
80105fed:	56                   	push   %esi
80105fee:	53                   	push   %ebx
80105fef:	83 ec 24             	sub    $0x24,%esp
  uart = 1;
80105ff2:	c7 05 c0 45 11 80 01 	movl   $0x1,0x801145c0
80105ff9:	00 00 00 
80105ffc:	ec                   	in     (%dx),%al
80105ffd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106002:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106003:	6a 00                	push   $0x0
  for(p="xv6...\n"; *p; p++)
80106005:	bf 38 79 10 80       	mov    $0x80107938,%edi
8010600a:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010600f:	6a 04                	push   $0x4
80106011:	e8 ea c4 ff ff       	call   80102500 <ioapicenable>
80106016:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106019:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
8010601d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80106020:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80106025:	bb 80 00 00 00       	mov    $0x80,%ebx
8010602a:	85 c0                	test   %eax,%eax
8010602c:	75 14                	jne    80106042 <uartinit+0xb2>
8010602e:	eb 23                	jmp    80106053 <uartinit+0xc3>
    microdelay(10);
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	6a 0a                	push   $0xa
80106035:	e8 96 c9 ff ff       	call   801029d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010603a:	83 c4 10             	add    $0x10,%esp
8010603d:	83 eb 01             	sub    $0x1,%ebx
80106040:	74 07                	je     80106049 <uartinit+0xb9>
80106042:	89 f2                	mov    %esi,%edx
80106044:	ec                   	in     (%dx),%al
80106045:	a8 20                	test   $0x20,%al
80106047:	74 e7                	je     80106030 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106049:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010604d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106052:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106053:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106057:	83 c7 01             	add    $0x1,%edi
8010605a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010605d:	84 c0                	test   %al,%al
8010605f:	75 bf                	jne    80106020 <uartinit+0x90>
}
80106061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106064:	5b                   	pop    %ebx
80106065:	5e                   	pop    %esi
80106066:	5f                   	pop    %edi
80106067:	5d                   	pop    %ebp
80106068:	c3                   	ret
80106069:	c3                   	ret
8010606a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106070 <uartputc>:
  if(!uart)
80106070:	a1 c0 45 11 80       	mov    0x801145c0,%eax
80106075:	85 c0                	test   %eax,%eax
80106077:	74 47                	je     801060c0 <uartputc+0x50>
{
80106079:	55                   	push   %ebp
8010607a:	89 e5                	mov    %esp,%ebp
8010607c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010607d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106082:	53                   	push   %ebx
80106083:	bb 80 00 00 00       	mov    $0x80,%ebx
80106088:	eb 18                	jmp    801060a2 <uartputc+0x32>
8010608a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	6a 0a                	push   $0xa
80106095:	e8 36 c9 ff ff       	call   801029d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010609a:	83 c4 10             	add    $0x10,%esp
8010609d:	83 eb 01             	sub    $0x1,%ebx
801060a0:	74 07                	je     801060a9 <uartputc+0x39>
801060a2:	89 f2                	mov    %esi,%edx
801060a4:	ec                   	in     (%dx),%al
801060a5:	a8 20                	test   $0x20,%al
801060a7:	74 e7                	je     80106090 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a9:	8b 45 08             	mov    0x8(%ebp),%eax
801060ac:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060b1:	ee                   	out    %al,(%dx)
}
801060b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060b5:	5b                   	pop    %ebx
801060b6:	5e                   	pop    %esi
801060b7:	5d                   	pop    %ebp
801060b8:	c3                   	ret
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060c0:	c3                   	ret
801060c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801060c8:	00 
801060c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060d0 <uartintr>:

void
uartintr(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060d6:	68 60 5f 10 80       	push   $0x80105f60
801060db:	e8 e0 a7 ff ff       	call   801008c0 <consoleintr>
}
801060e0:	83 c4 10             	add    $0x10,%esp
801060e3:	c9                   	leave
801060e4:	c3                   	ret

801060e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $0
801060e7:	6a 00                	push   $0x0
  jmp alltraps
801060e9:	e9 d9 fa ff ff       	jmp    80105bc7 <alltraps>

801060ee <vector1>:
.globl vector1
vector1:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $1
801060f0:	6a 01                	push   $0x1
  jmp alltraps
801060f2:	e9 d0 fa ff ff       	jmp    80105bc7 <alltraps>

801060f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $2
801060f9:	6a 02                	push   $0x2
  jmp alltraps
801060fb:	e9 c7 fa ff ff       	jmp    80105bc7 <alltraps>

80106100 <vector3>:
.globl vector3
vector3:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $3
80106102:	6a 03                	push   $0x3
  jmp alltraps
80106104:	e9 be fa ff ff       	jmp    80105bc7 <alltraps>

80106109 <vector4>:
.globl vector4
vector4:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $4
8010610b:	6a 04                	push   $0x4
  jmp alltraps
8010610d:	e9 b5 fa ff ff       	jmp    80105bc7 <alltraps>

80106112 <vector5>:
.globl vector5
vector5:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $5
80106114:	6a 05                	push   $0x5
  jmp alltraps
80106116:	e9 ac fa ff ff       	jmp    80105bc7 <alltraps>

8010611b <vector6>:
.globl vector6
vector6:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $6
8010611d:	6a 06                	push   $0x6
  jmp alltraps
8010611f:	e9 a3 fa ff ff       	jmp    80105bc7 <alltraps>

80106124 <vector7>:
.globl vector7
vector7:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $7
80106126:	6a 07                	push   $0x7
  jmp alltraps
80106128:	e9 9a fa ff ff       	jmp    80105bc7 <alltraps>

8010612d <vector8>:
.globl vector8
vector8:
  pushl $8
8010612d:	6a 08                	push   $0x8
  jmp alltraps
8010612f:	e9 93 fa ff ff       	jmp    80105bc7 <alltraps>

80106134 <vector9>:
.globl vector9
vector9:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $9
80106136:	6a 09                	push   $0x9
  jmp alltraps
80106138:	e9 8a fa ff ff       	jmp    80105bc7 <alltraps>

8010613d <vector10>:
.globl vector10
vector10:
  pushl $10
8010613d:	6a 0a                	push   $0xa
  jmp alltraps
8010613f:	e9 83 fa ff ff       	jmp    80105bc7 <alltraps>

80106144 <vector11>:
.globl vector11
vector11:
  pushl $11
80106144:	6a 0b                	push   $0xb
  jmp alltraps
80106146:	e9 7c fa ff ff       	jmp    80105bc7 <alltraps>

8010614b <vector12>:
.globl vector12
vector12:
  pushl $12
8010614b:	6a 0c                	push   $0xc
  jmp alltraps
8010614d:	e9 75 fa ff ff       	jmp    80105bc7 <alltraps>

80106152 <vector13>:
.globl vector13
vector13:
  pushl $13
80106152:	6a 0d                	push   $0xd
  jmp alltraps
80106154:	e9 6e fa ff ff       	jmp    80105bc7 <alltraps>

80106159 <vector14>:
.globl vector14
vector14:
  pushl $14
80106159:	6a 0e                	push   $0xe
  jmp alltraps
8010615b:	e9 67 fa ff ff       	jmp    80105bc7 <alltraps>

80106160 <vector15>:
.globl vector15
vector15:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $15
80106162:	6a 0f                	push   $0xf
  jmp alltraps
80106164:	e9 5e fa ff ff       	jmp    80105bc7 <alltraps>

80106169 <vector16>:
.globl vector16
vector16:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $16
8010616b:	6a 10                	push   $0x10
  jmp alltraps
8010616d:	e9 55 fa ff ff       	jmp    80105bc7 <alltraps>

80106172 <vector17>:
.globl vector17
vector17:
  pushl $17
80106172:	6a 11                	push   $0x11
  jmp alltraps
80106174:	e9 4e fa ff ff       	jmp    80105bc7 <alltraps>

80106179 <vector18>:
.globl vector18
vector18:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $18
8010617b:	6a 12                	push   $0x12
  jmp alltraps
8010617d:	e9 45 fa ff ff       	jmp    80105bc7 <alltraps>

80106182 <vector19>:
.globl vector19
vector19:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $19
80106184:	6a 13                	push   $0x13
  jmp alltraps
80106186:	e9 3c fa ff ff       	jmp    80105bc7 <alltraps>

8010618b <vector20>:
.globl vector20
vector20:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $20
8010618d:	6a 14                	push   $0x14
  jmp alltraps
8010618f:	e9 33 fa ff ff       	jmp    80105bc7 <alltraps>

80106194 <vector21>:
.globl vector21
vector21:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $21
80106196:	6a 15                	push   $0x15
  jmp alltraps
80106198:	e9 2a fa ff ff       	jmp    80105bc7 <alltraps>

8010619d <vector22>:
.globl vector22
vector22:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $22
8010619f:	6a 16                	push   $0x16
  jmp alltraps
801061a1:	e9 21 fa ff ff       	jmp    80105bc7 <alltraps>

801061a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $23
801061a8:	6a 17                	push   $0x17
  jmp alltraps
801061aa:	e9 18 fa ff ff       	jmp    80105bc7 <alltraps>

801061af <vector24>:
.globl vector24
vector24:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $24
801061b1:	6a 18                	push   $0x18
  jmp alltraps
801061b3:	e9 0f fa ff ff       	jmp    80105bc7 <alltraps>

801061b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $25
801061ba:	6a 19                	push   $0x19
  jmp alltraps
801061bc:	e9 06 fa ff ff       	jmp    80105bc7 <alltraps>

801061c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $26
801061c3:	6a 1a                	push   $0x1a
  jmp alltraps
801061c5:	e9 fd f9 ff ff       	jmp    80105bc7 <alltraps>

801061ca <vector27>:
.globl vector27
vector27:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $27
801061cc:	6a 1b                	push   $0x1b
  jmp alltraps
801061ce:	e9 f4 f9 ff ff       	jmp    80105bc7 <alltraps>

801061d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $28
801061d5:	6a 1c                	push   $0x1c
  jmp alltraps
801061d7:	e9 eb f9 ff ff       	jmp    80105bc7 <alltraps>

801061dc <vector29>:
.globl vector29
vector29:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $29
801061de:	6a 1d                	push   $0x1d
  jmp alltraps
801061e0:	e9 e2 f9 ff ff       	jmp    80105bc7 <alltraps>

801061e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $30
801061e7:	6a 1e                	push   $0x1e
  jmp alltraps
801061e9:	e9 d9 f9 ff ff       	jmp    80105bc7 <alltraps>

801061ee <vector31>:
.globl vector31
vector31:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $31
801061f0:	6a 1f                	push   $0x1f
  jmp alltraps
801061f2:	e9 d0 f9 ff ff       	jmp    80105bc7 <alltraps>

801061f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $32
801061f9:	6a 20                	push   $0x20
  jmp alltraps
801061fb:	e9 c7 f9 ff ff       	jmp    80105bc7 <alltraps>

80106200 <vector33>:
.globl vector33
vector33:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $33
80106202:	6a 21                	push   $0x21
  jmp alltraps
80106204:	e9 be f9 ff ff       	jmp    80105bc7 <alltraps>

80106209 <vector34>:
.globl vector34
vector34:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $34
8010620b:	6a 22                	push   $0x22
  jmp alltraps
8010620d:	e9 b5 f9 ff ff       	jmp    80105bc7 <alltraps>

80106212 <vector35>:
.globl vector35
vector35:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $35
80106214:	6a 23                	push   $0x23
  jmp alltraps
80106216:	e9 ac f9 ff ff       	jmp    80105bc7 <alltraps>

8010621b <vector36>:
.globl vector36
vector36:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $36
8010621d:	6a 24                	push   $0x24
  jmp alltraps
8010621f:	e9 a3 f9 ff ff       	jmp    80105bc7 <alltraps>

80106224 <vector37>:
.globl vector37
vector37:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $37
80106226:	6a 25                	push   $0x25
  jmp alltraps
80106228:	e9 9a f9 ff ff       	jmp    80105bc7 <alltraps>

8010622d <vector38>:
.globl vector38
vector38:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $38
8010622f:	6a 26                	push   $0x26
  jmp alltraps
80106231:	e9 91 f9 ff ff       	jmp    80105bc7 <alltraps>

80106236 <vector39>:
.globl vector39
vector39:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $39
80106238:	6a 27                	push   $0x27
  jmp alltraps
8010623a:	e9 88 f9 ff ff       	jmp    80105bc7 <alltraps>

8010623f <vector40>:
.globl vector40
vector40:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $40
80106241:	6a 28                	push   $0x28
  jmp alltraps
80106243:	e9 7f f9 ff ff       	jmp    80105bc7 <alltraps>

80106248 <vector41>:
.globl vector41
vector41:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $41
8010624a:	6a 29                	push   $0x29
  jmp alltraps
8010624c:	e9 76 f9 ff ff       	jmp    80105bc7 <alltraps>

80106251 <vector42>:
.globl vector42
vector42:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $42
80106253:	6a 2a                	push   $0x2a
  jmp alltraps
80106255:	e9 6d f9 ff ff       	jmp    80105bc7 <alltraps>

8010625a <vector43>:
.globl vector43
vector43:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $43
8010625c:	6a 2b                	push   $0x2b
  jmp alltraps
8010625e:	e9 64 f9 ff ff       	jmp    80105bc7 <alltraps>

80106263 <vector44>:
.globl vector44
vector44:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $44
80106265:	6a 2c                	push   $0x2c
  jmp alltraps
80106267:	e9 5b f9 ff ff       	jmp    80105bc7 <alltraps>

8010626c <vector45>:
.globl vector45
vector45:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $45
8010626e:	6a 2d                	push   $0x2d
  jmp alltraps
80106270:	e9 52 f9 ff ff       	jmp    80105bc7 <alltraps>

80106275 <vector46>:
.globl vector46
vector46:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $46
80106277:	6a 2e                	push   $0x2e
  jmp alltraps
80106279:	e9 49 f9 ff ff       	jmp    80105bc7 <alltraps>

8010627e <vector47>:
.globl vector47
vector47:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $47
80106280:	6a 2f                	push   $0x2f
  jmp alltraps
80106282:	e9 40 f9 ff ff       	jmp    80105bc7 <alltraps>

80106287 <vector48>:
.globl vector48
vector48:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $48
80106289:	6a 30                	push   $0x30
  jmp alltraps
8010628b:	e9 37 f9 ff ff       	jmp    80105bc7 <alltraps>

80106290 <vector49>:
.globl vector49
vector49:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $49
80106292:	6a 31                	push   $0x31
  jmp alltraps
80106294:	e9 2e f9 ff ff       	jmp    80105bc7 <alltraps>

80106299 <vector50>:
.globl vector50
vector50:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $50
8010629b:	6a 32                	push   $0x32
  jmp alltraps
8010629d:	e9 25 f9 ff ff       	jmp    80105bc7 <alltraps>

801062a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $51
801062a4:	6a 33                	push   $0x33
  jmp alltraps
801062a6:	e9 1c f9 ff ff       	jmp    80105bc7 <alltraps>

801062ab <vector52>:
.globl vector52
vector52:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $52
801062ad:	6a 34                	push   $0x34
  jmp alltraps
801062af:	e9 13 f9 ff ff       	jmp    80105bc7 <alltraps>

801062b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $53
801062b6:	6a 35                	push   $0x35
  jmp alltraps
801062b8:	e9 0a f9 ff ff       	jmp    80105bc7 <alltraps>

801062bd <vector54>:
.globl vector54
vector54:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $54
801062bf:	6a 36                	push   $0x36
  jmp alltraps
801062c1:	e9 01 f9 ff ff       	jmp    80105bc7 <alltraps>

801062c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $55
801062c8:	6a 37                	push   $0x37
  jmp alltraps
801062ca:	e9 f8 f8 ff ff       	jmp    80105bc7 <alltraps>

801062cf <vector56>:
.globl vector56
vector56:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $56
801062d1:	6a 38                	push   $0x38
  jmp alltraps
801062d3:	e9 ef f8 ff ff       	jmp    80105bc7 <alltraps>

801062d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $57
801062da:	6a 39                	push   $0x39
  jmp alltraps
801062dc:	e9 e6 f8 ff ff       	jmp    80105bc7 <alltraps>

801062e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $58
801062e3:	6a 3a                	push   $0x3a
  jmp alltraps
801062e5:	e9 dd f8 ff ff       	jmp    80105bc7 <alltraps>

801062ea <vector59>:
.globl vector59
vector59:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $59
801062ec:	6a 3b                	push   $0x3b
  jmp alltraps
801062ee:	e9 d4 f8 ff ff       	jmp    80105bc7 <alltraps>

801062f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $60
801062f5:	6a 3c                	push   $0x3c
  jmp alltraps
801062f7:	e9 cb f8 ff ff       	jmp    80105bc7 <alltraps>

801062fc <vector61>:
.globl vector61
vector61:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $61
801062fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106300:	e9 c2 f8 ff ff       	jmp    80105bc7 <alltraps>

80106305 <vector62>:
.globl vector62
vector62:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $62
80106307:	6a 3e                	push   $0x3e
  jmp alltraps
80106309:	e9 b9 f8 ff ff       	jmp    80105bc7 <alltraps>

8010630e <vector63>:
.globl vector63
vector63:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $63
80106310:	6a 3f                	push   $0x3f
  jmp alltraps
80106312:	e9 b0 f8 ff ff       	jmp    80105bc7 <alltraps>

80106317 <vector64>:
.globl vector64
vector64:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $64
80106319:	6a 40                	push   $0x40
  jmp alltraps
8010631b:	e9 a7 f8 ff ff       	jmp    80105bc7 <alltraps>

80106320 <vector65>:
.globl vector65
vector65:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $65
80106322:	6a 41                	push   $0x41
  jmp alltraps
80106324:	e9 9e f8 ff ff       	jmp    80105bc7 <alltraps>

80106329 <vector66>:
.globl vector66
vector66:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $66
8010632b:	6a 42                	push   $0x42
  jmp alltraps
8010632d:	e9 95 f8 ff ff       	jmp    80105bc7 <alltraps>

80106332 <vector67>:
.globl vector67
vector67:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $67
80106334:	6a 43                	push   $0x43
  jmp alltraps
80106336:	e9 8c f8 ff ff       	jmp    80105bc7 <alltraps>

8010633b <vector68>:
.globl vector68
vector68:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $68
8010633d:	6a 44                	push   $0x44
  jmp alltraps
8010633f:	e9 83 f8 ff ff       	jmp    80105bc7 <alltraps>

80106344 <vector69>:
.globl vector69
vector69:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $69
80106346:	6a 45                	push   $0x45
  jmp alltraps
80106348:	e9 7a f8 ff ff       	jmp    80105bc7 <alltraps>

8010634d <vector70>:
.globl vector70
vector70:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $70
8010634f:	6a 46                	push   $0x46
  jmp alltraps
80106351:	e9 71 f8 ff ff       	jmp    80105bc7 <alltraps>

80106356 <vector71>:
.globl vector71
vector71:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $71
80106358:	6a 47                	push   $0x47
  jmp alltraps
8010635a:	e9 68 f8 ff ff       	jmp    80105bc7 <alltraps>

8010635f <vector72>:
.globl vector72
vector72:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $72
80106361:	6a 48                	push   $0x48
  jmp alltraps
80106363:	e9 5f f8 ff ff       	jmp    80105bc7 <alltraps>

80106368 <vector73>:
.globl vector73
vector73:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $73
8010636a:	6a 49                	push   $0x49
  jmp alltraps
8010636c:	e9 56 f8 ff ff       	jmp    80105bc7 <alltraps>

80106371 <vector74>:
.globl vector74
vector74:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $74
80106373:	6a 4a                	push   $0x4a
  jmp alltraps
80106375:	e9 4d f8 ff ff       	jmp    80105bc7 <alltraps>

8010637a <vector75>:
.globl vector75
vector75:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $75
8010637c:	6a 4b                	push   $0x4b
  jmp alltraps
8010637e:	e9 44 f8 ff ff       	jmp    80105bc7 <alltraps>

80106383 <vector76>:
.globl vector76
vector76:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $76
80106385:	6a 4c                	push   $0x4c
  jmp alltraps
80106387:	e9 3b f8 ff ff       	jmp    80105bc7 <alltraps>

8010638c <vector77>:
.globl vector77
vector77:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $77
8010638e:	6a 4d                	push   $0x4d
  jmp alltraps
80106390:	e9 32 f8 ff ff       	jmp    80105bc7 <alltraps>

80106395 <vector78>:
.globl vector78
vector78:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $78
80106397:	6a 4e                	push   $0x4e
  jmp alltraps
80106399:	e9 29 f8 ff ff       	jmp    80105bc7 <alltraps>

8010639e <vector79>:
.globl vector79
vector79:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $79
801063a0:	6a 4f                	push   $0x4f
  jmp alltraps
801063a2:	e9 20 f8 ff ff       	jmp    80105bc7 <alltraps>

801063a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $80
801063a9:	6a 50                	push   $0x50
  jmp alltraps
801063ab:	e9 17 f8 ff ff       	jmp    80105bc7 <alltraps>

801063b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $81
801063b2:	6a 51                	push   $0x51
  jmp alltraps
801063b4:	e9 0e f8 ff ff       	jmp    80105bc7 <alltraps>

801063b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $82
801063bb:	6a 52                	push   $0x52
  jmp alltraps
801063bd:	e9 05 f8 ff ff       	jmp    80105bc7 <alltraps>

801063c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $83
801063c4:	6a 53                	push   $0x53
  jmp alltraps
801063c6:	e9 fc f7 ff ff       	jmp    80105bc7 <alltraps>

801063cb <vector84>:
.globl vector84
vector84:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $84
801063cd:	6a 54                	push   $0x54
  jmp alltraps
801063cf:	e9 f3 f7 ff ff       	jmp    80105bc7 <alltraps>

801063d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $85
801063d6:	6a 55                	push   $0x55
  jmp alltraps
801063d8:	e9 ea f7 ff ff       	jmp    80105bc7 <alltraps>

801063dd <vector86>:
.globl vector86
vector86:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $86
801063df:	6a 56                	push   $0x56
  jmp alltraps
801063e1:	e9 e1 f7 ff ff       	jmp    80105bc7 <alltraps>

801063e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $87
801063e8:	6a 57                	push   $0x57
  jmp alltraps
801063ea:	e9 d8 f7 ff ff       	jmp    80105bc7 <alltraps>

801063ef <vector88>:
.globl vector88
vector88:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $88
801063f1:	6a 58                	push   $0x58
  jmp alltraps
801063f3:	e9 cf f7 ff ff       	jmp    80105bc7 <alltraps>

801063f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $89
801063fa:	6a 59                	push   $0x59
  jmp alltraps
801063fc:	e9 c6 f7 ff ff       	jmp    80105bc7 <alltraps>

80106401 <vector90>:
.globl vector90
vector90:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $90
80106403:	6a 5a                	push   $0x5a
  jmp alltraps
80106405:	e9 bd f7 ff ff       	jmp    80105bc7 <alltraps>

8010640a <vector91>:
.globl vector91
vector91:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $91
8010640c:	6a 5b                	push   $0x5b
  jmp alltraps
8010640e:	e9 b4 f7 ff ff       	jmp    80105bc7 <alltraps>

80106413 <vector92>:
.globl vector92
vector92:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $92
80106415:	6a 5c                	push   $0x5c
  jmp alltraps
80106417:	e9 ab f7 ff ff       	jmp    80105bc7 <alltraps>

8010641c <vector93>:
.globl vector93
vector93:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $93
8010641e:	6a 5d                	push   $0x5d
  jmp alltraps
80106420:	e9 a2 f7 ff ff       	jmp    80105bc7 <alltraps>

80106425 <vector94>:
.globl vector94
vector94:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $94
80106427:	6a 5e                	push   $0x5e
  jmp alltraps
80106429:	e9 99 f7 ff ff       	jmp    80105bc7 <alltraps>

8010642e <vector95>:
.globl vector95
vector95:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $95
80106430:	6a 5f                	push   $0x5f
  jmp alltraps
80106432:	e9 90 f7 ff ff       	jmp    80105bc7 <alltraps>

80106437 <vector96>:
.globl vector96
vector96:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $96
80106439:	6a 60                	push   $0x60
  jmp alltraps
8010643b:	e9 87 f7 ff ff       	jmp    80105bc7 <alltraps>

80106440 <vector97>:
.globl vector97
vector97:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $97
80106442:	6a 61                	push   $0x61
  jmp alltraps
80106444:	e9 7e f7 ff ff       	jmp    80105bc7 <alltraps>

80106449 <vector98>:
.globl vector98
vector98:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $98
8010644b:	6a 62                	push   $0x62
  jmp alltraps
8010644d:	e9 75 f7 ff ff       	jmp    80105bc7 <alltraps>

80106452 <vector99>:
.globl vector99
vector99:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $99
80106454:	6a 63                	push   $0x63
  jmp alltraps
80106456:	e9 6c f7 ff ff       	jmp    80105bc7 <alltraps>

8010645b <vector100>:
.globl vector100
vector100:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $100
8010645d:	6a 64                	push   $0x64
  jmp alltraps
8010645f:	e9 63 f7 ff ff       	jmp    80105bc7 <alltraps>

80106464 <vector101>:
.globl vector101
vector101:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $101
80106466:	6a 65                	push   $0x65
  jmp alltraps
80106468:	e9 5a f7 ff ff       	jmp    80105bc7 <alltraps>

8010646d <vector102>:
.globl vector102
vector102:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $102
8010646f:	6a 66                	push   $0x66
  jmp alltraps
80106471:	e9 51 f7 ff ff       	jmp    80105bc7 <alltraps>

80106476 <vector103>:
.globl vector103
vector103:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $103
80106478:	6a 67                	push   $0x67
  jmp alltraps
8010647a:	e9 48 f7 ff ff       	jmp    80105bc7 <alltraps>

8010647f <vector104>:
.globl vector104
vector104:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $104
80106481:	6a 68                	push   $0x68
  jmp alltraps
80106483:	e9 3f f7 ff ff       	jmp    80105bc7 <alltraps>

80106488 <vector105>:
.globl vector105
vector105:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $105
8010648a:	6a 69                	push   $0x69
  jmp alltraps
8010648c:	e9 36 f7 ff ff       	jmp    80105bc7 <alltraps>

80106491 <vector106>:
.globl vector106
vector106:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $106
80106493:	6a 6a                	push   $0x6a
  jmp alltraps
80106495:	e9 2d f7 ff ff       	jmp    80105bc7 <alltraps>

8010649a <vector107>:
.globl vector107
vector107:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $107
8010649c:	6a 6b                	push   $0x6b
  jmp alltraps
8010649e:	e9 24 f7 ff ff       	jmp    80105bc7 <alltraps>

801064a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $108
801064a5:	6a 6c                	push   $0x6c
  jmp alltraps
801064a7:	e9 1b f7 ff ff       	jmp    80105bc7 <alltraps>

801064ac <vector109>:
.globl vector109
vector109:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $109
801064ae:	6a 6d                	push   $0x6d
  jmp alltraps
801064b0:	e9 12 f7 ff ff       	jmp    80105bc7 <alltraps>

801064b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $110
801064b7:	6a 6e                	push   $0x6e
  jmp alltraps
801064b9:	e9 09 f7 ff ff       	jmp    80105bc7 <alltraps>

801064be <vector111>:
.globl vector111
vector111:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $111
801064c0:	6a 6f                	push   $0x6f
  jmp alltraps
801064c2:	e9 00 f7 ff ff       	jmp    80105bc7 <alltraps>

801064c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $112
801064c9:	6a 70                	push   $0x70
  jmp alltraps
801064cb:	e9 f7 f6 ff ff       	jmp    80105bc7 <alltraps>

801064d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $113
801064d2:	6a 71                	push   $0x71
  jmp alltraps
801064d4:	e9 ee f6 ff ff       	jmp    80105bc7 <alltraps>

801064d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $114
801064db:	6a 72                	push   $0x72
  jmp alltraps
801064dd:	e9 e5 f6 ff ff       	jmp    80105bc7 <alltraps>

801064e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $115
801064e4:	6a 73                	push   $0x73
  jmp alltraps
801064e6:	e9 dc f6 ff ff       	jmp    80105bc7 <alltraps>

801064eb <vector116>:
.globl vector116
vector116:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $116
801064ed:	6a 74                	push   $0x74
  jmp alltraps
801064ef:	e9 d3 f6 ff ff       	jmp    80105bc7 <alltraps>

801064f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $117
801064f6:	6a 75                	push   $0x75
  jmp alltraps
801064f8:	e9 ca f6 ff ff       	jmp    80105bc7 <alltraps>

801064fd <vector118>:
.globl vector118
vector118:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $118
801064ff:	6a 76                	push   $0x76
  jmp alltraps
80106501:	e9 c1 f6 ff ff       	jmp    80105bc7 <alltraps>

80106506 <vector119>:
.globl vector119
vector119:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $119
80106508:	6a 77                	push   $0x77
  jmp alltraps
8010650a:	e9 b8 f6 ff ff       	jmp    80105bc7 <alltraps>

8010650f <vector120>:
.globl vector120
vector120:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $120
80106511:	6a 78                	push   $0x78
  jmp alltraps
80106513:	e9 af f6 ff ff       	jmp    80105bc7 <alltraps>

80106518 <vector121>:
.globl vector121
vector121:
  pushl $0
80106518:	6a 00                	push   $0x0
  pushl $121
8010651a:	6a 79                	push   $0x79
  jmp alltraps
8010651c:	e9 a6 f6 ff ff       	jmp    80105bc7 <alltraps>

80106521 <vector122>:
.globl vector122
vector122:
  pushl $0
80106521:	6a 00                	push   $0x0
  pushl $122
80106523:	6a 7a                	push   $0x7a
  jmp alltraps
80106525:	e9 9d f6 ff ff       	jmp    80105bc7 <alltraps>

8010652a <vector123>:
.globl vector123
vector123:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $123
8010652c:	6a 7b                	push   $0x7b
  jmp alltraps
8010652e:	e9 94 f6 ff ff       	jmp    80105bc7 <alltraps>

80106533 <vector124>:
.globl vector124
vector124:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $124
80106535:	6a 7c                	push   $0x7c
  jmp alltraps
80106537:	e9 8b f6 ff ff       	jmp    80105bc7 <alltraps>

8010653c <vector125>:
.globl vector125
vector125:
  pushl $0
8010653c:	6a 00                	push   $0x0
  pushl $125
8010653e:	6a 7d                	push   $0x7d
  jmp alltraps
80106540:	e9 82 f6 ff ff       	jmp    80105bc7 <alltraps>

80106545 <vector126>:
.globl vector126
vector126:
  pushl $0
80106545:	6a 00                	push   $0x0
  pushl $126
80106547:	6a 7e                	push   $0x7e
  jmp alltraps
80106549:	e9 79 f6 ff ff       	jmp    80105bc7 <alltraps>

8010654e <vector127>:
.globl vector127
vector127:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $127
80106550:	6a 7f                	push   $0x7f
  jmp alltraps
80106552:	e9 70 f6 ff ff       	jmp    80105bc7 <alltraps>

80106557 <vector128>:
.globl vector128
vector128:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $128
80106559:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010655e:	e9 64 f6 ff ff       	jmp    80105bc7 <alltraps>

80106563 <vector129>:
.globl vector129
vector129:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $129
80106565:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010656a:	e9 58 f6 ff ff       	jmp    80105bc7 <alltraps>

8010656f <vector130>:
.globl vector130
vector130:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $130
80106571:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106576:	e9 4c f6 ff ff       	jmp    80105bc7 <alltraps>

8010657b <vector131>:
.globl vector131
vector131:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $131
8010657d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106582:	e9 40 f6 ff ff       	jmp    80105bc7 <alltraps>

80106587 <vector132>:
.globl vector132
vector132:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $132
80106589:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010658e:	e9 34 f6 ff ff       	jmp    80105bc7 <alltraps>

80106593 <vector133>:
.globl vector133
vector133:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $133
80106595:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010659a:	e9 28 f6 ff ff       	jmp    80105bc7 <alltraps>

8010659f <vector134>:
.globl vector134
vector134:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $134
801065a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065a6:	e9 1c f6 ff ff       	jmp    80105bc7 <alltraps>

801065ab <vector135>:
.globl vector135
vector135:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $135
801065ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065b2:	e9 10 f6 ff ff       	jmp    80105bc7 <alltraps>

801065b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $136
801065b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065be:	e9 04 f6 ff ff       	jmp    80105bc7 <alltraps>

801065c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $137
801065c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065ca:	e9 f8 f5 ff ff       	jmp    80105bc7 <alltraps>

801065cf <vector138>:
.globl vector138
vector138:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $138
801065d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801065d6:	e9 ec f5 ff ff       	jmp    80105bc7 <alltraps>

801065db <vector139>:
.globl vector139
vector139:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $139
801065dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801065e2:	e9 e0 f5 ff ff       	jmp    80105bc7 <alltraps>

801065e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $140
801065e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801065ee:	e9 d4 f5 ff ff       	jmp    80105bc7 <alltraps>

801065f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $141
801065f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801065fa:	e9 c8 f5 ff ff       	jmp    80105bc7 <alltraps>

801065ff <vector142>:
.globl vector142
vector142:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $142
80106601:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106606:	e9 bc f5 ff ff       	jmp    80105bc7 <alltraps>

8010660b <vector143>:
.globl vector143
vector143:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $143
8010660d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106612:	e9 b0 f5 ff ff       	jmp    80105bc7 <alltraps>

80106617 <vector144>:
.globl vector144
vector144:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $144
80106619:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010661e:	e9 a4 f5 ff ff       	jmp    80105bc7 <alltraps>

80106623 <vector145>:
.globl vector145
vector145:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $145
80106625:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010662a:	e9 98 f5 ff ff       	jmp    80105bc7 <alltraps>

8010662f <vector146>:
.globl vector146
vector146:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $146
80106631:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106636:	e9 8c f5 ff ff       	jmp    80105bc7 <alltraps>

8010663b <vector147>:
.globl vector147
vector147:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $147
8010663d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106642:	e9 80 f5 ff ff       	jmp    80105bc7 <alltraps>

80106647 <vector148>:
.globl vector148
vector148:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $148
80106649:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010664e:	e9 74 f5 ff ff       	jmp    80105bc7 <alltraps>

80106653 <vector149>:
.globl vector149
vector149:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $149
80106655:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010665a:	e9 68 f5 ff ff       	jmp    80105bc7 <alltraps>

8010665f <vector150>:
.globl vector150
vector150:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $150
80106661:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106666:	e9 5c f5 ff ff       	jmp    80105bc7 <alltraps>

8010666b <vector151>:
.globl vector151
vector151:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $151
8010666d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106672:	e9 50 f5 ff ff       	jmp    80105bc7 <alltraps>

80106677 <vector152>:
.globl vector152
vector152:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $152
80106679:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010667e:	e9 44 f5 ff ff       	jmp    80105bc7 <alltraps>

80106683 <vector153>:
.globl vector153
vector153:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $153
80106685:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010668a:	e9 38 f5 ff ff       	jmp    80105bc7 <alltraps>

8010668f <vector154>:
.globl vector154
vector154:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $154
80106691:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106696:	e9 2c f5 ff ff       	jmp    80105bc7 <alltraps>

8010669b <vector155>:
.globl vector155
vector155:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $155
8010669d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066a2:	e9 20 f5 ff ff       	jmp    80105bc7 <alltraps>

801066a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $156
801066a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066ae:	e9 14 f5 ff ff       	jmp    80105bc7 <alltraps>

801066b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $157
801066b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066ba:	e9 08 f5 ff ff       	jmp    80105bc7 <alltraps>

801066bf <vector158>:
.globl vector158
vector158:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $158
801066c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066c6:	e9 fc f4 ff ff       	jmp    80105bc7 <alltraps>

801066cb <vector159>:
.globl vector159
vector159:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $159
801066cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801066d2:	e9 f0 f4 ff ff       	jmp    80105bc7 <alltraps>

801066d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $160
801066d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066de:	e9 e4 f4 ff ff       	jmp    80105bc7 <alltraps>

801066e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $161
801066e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801066ea:	e9 d8 f4 ff ff       	jmp    80105bc7 <alltraps>

801066ef <vector162>:
.globl vector162
vector162:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $162
801066f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801066f6:	e9 cc f4 ff ff       	jmp    80105bc7 <alltraps>

801066fb <vector163>:
.globl vector163
vector163:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $163
801066fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106702:	e9 c0 f4 ff ff       	jmp    80105bc7 <alltraps>

80106707 <vector164>:
.globl vector164
vector164:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $164
80106709:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010670e:	e9 b4 f4 ff ff       	jmp    80105bc7 <alltraps>

80106713 <vector165>:
.globl vector165
vector165:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $165
80106715:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010671a:	e9 a8 f4 ff ff       	jmp    80105bc7 <alltraps>

8010671f <vector166>:
.globl vector166
vector166:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $166
80106721:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106726:	e9 9c f4 ff ff       	jmp    80105bc7 <alltraps>

8010672b <vector167>:
.globl vector167
vector167:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $167
8010672d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106732:	e9 90 f4 ff ff       	jmp    80105bc7 <alltraps>

80106737 <vector168>:
.globl vector168
vector168:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $168
80106739:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010673e:	e9 84 f4 ff ff       	jmp    80105bc7 <alltraps>

80106743 <vector169>:
.globl vector169
vector169:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $169
80106745:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010674a:	e9 78 f4 ff ff       	jmp    80105bc7 <alltraps>

8010674f <vector170>:
.globl vector170
vector170:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $170
80106751:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106756:	e9 6c f4 ff ff       	jmp    80105bc7 <alltraps>

8010675b <vector171>:
.globl vector171
vector171:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $171
8010675d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106762:	e9 60 f4 ff ff       	jmp    80105bc7 <alltraps>

80106767 <vector172>:
.globl vector172
vector172:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $172
80106769:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010676e:	e9 54 f4 ff ff       	jmp    80105bc7 <alltraps>

80106773 <vector173>:
.globl vector173
vector173:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $173
80106775:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010677a:	e9 48 f4 ff ff       	jmp    80105bc7 <alltraps>

8010677f <vector174>:
.globl vector174
vector174:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $174
80106781:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106786:	e9 3c f4 ff ff       	jmp    80105bc7 <alltraps>

8010678b <vector175>:
.globl vector175
vector175:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $175
8010678d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106792:	e9 30 f4 ff ff       	jmp    80105bc7 <alltraps>

80106797 <vector176>:
.globl vector176
vector176:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $176
80106799:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010679e:	e9 24 f4 ff ff       	jmp    80105bc7 <alltraps>

801067a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $177
801067a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067aa:	e9 18 f4 ff ff       	jmp    80105bc7 <alltraps>

801067af <vector178>:
.globl vector178
vector178:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $178
801067b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067b6:	e9 0c f4 ff ff       	jmp    80105bc7 <alltraps>

801067bb <vector179>:
.globl vector179
vector179:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $179
801067bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067c2:	e9 00 f4 ff ff       	jmp    80105bc7 <alltraps>

801067c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $180
801067c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067ce:	e9 f4 f3 ff ff       	jmp    80105bc7 <alltraps>

801067d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $181
801067d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801067da:	e9 e8 f3 ff ff       	jmp    80105bc7 <alltraps>

801067df <vector182>:
.globl vector182
vector182:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $182
801067e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801067e6:	e9 dc f3 ff ff       	jmp    80105bc7 <alltraps>

801067eb <vector183>:
.globl vector183
vector183:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $183
801067ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801067f2:	e9 d0 f3 ff ff       	jmp    80105bc7 <alltraps>

801067f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $184
801067f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801067fe:	e9 c4 f3 ff ff       	jmp    80105bc7 <alltraps>

80106803 <vector185>:
.globl vector185
vector185:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $185
80106805:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010680a:	e9 b8 f3 ff ff       	jmp    80105bc7 <alltraps>

8010680f <vector186>:
.globl vector186
vector186:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $186
80106811:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106816:	e9 ac f3 ff ff       	jmp    80105bc7 <alltraps>

8010681b <vector187>:
.globl vector187
vector187:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $187
8010681d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106822:	e9 a0 f3 ff ff       	jmp    80105bc7 <alltraps>

80106827 <vector188>:
.globl vector188
vector188:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $188
80106829:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010682e:	e9 94 f3 ff ff       	jmp    80105bc7 <alltraps>

80106833 <vector189>:
.globl vector189
vector189:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $189
80106835:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010683a:	e9 88 f3 ff ff       	jmp    80105bc7 <alltraps>

8010683f <vector190>:
.globl vector190
vector190:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $190
80106841:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106846:	e9 7c f3 ff ff       	jmp    80105bc7 <alltraps>

8010684b <vector191>:
.globl vector191
vector191:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $191
8010684d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106852:	e9 70 f3 ff ff       	jmp    80105bc7 <alltraps>

80106857 <vector192>:
.globl vector192
vector192:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $192
80106859:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010685e:	e9 64 f3 ff ff       	jmp    80105bc7 <alltraps>

80106863 <vector193>:
.globl vector193
vector193:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $193
80106865:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010686a:	e9 58 f3 ff ff       	jmp    80105bc7 <alltraps>

8010686f <vector194>:
.globl vector194
vector194:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $194
80106871:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106876:	e9 4c f3 ff ff       	jmp    80105bc7 <alltraps>

8010687b <vector195>:
.globl vector195
vector195:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $195
8010687d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106882:	e9 40 f3 ff ff       	jmp    80105bc7 <alltraps>

80106887 <vector196>:
.globl vector196
vector196:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $196
80106889:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010688e:	e9 34 f3 ff ff       	jmp    80105bc7 <alltraps>

80106893 <vector197>:
.globl vector197
vector197:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $197
80106895:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010689a:	e9 28 f3 ff ff       	jmp    80105bc7 <alltraps>

8010689f <vector198>:
.globl vector198
vector198:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $198
801068a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068a6:	e9 1c f3 ff ff       	jmp    80105bc7 <alltraps>

801068ab <vector199>:
.globl vector199
vector199:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $199
801068ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068b2:	e9 10 f3 ff ff       	jmp    80105bc7 <alltraps>

801068b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $200
801068b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068be:	e9 04 f3 ff ff       	jmp    80105bc7 <alltraps>

801068c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $201
801068c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068ca:	e9 f8 f2 ff ff       	jmp    80105bc7 <alltraps>

801068cf <vector202>:
.globl vector202
vector202:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $202
801068d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801068d6:	e9 ec f2 ff ff       	jmp    80105bc7 <alltraps>

801068db <vector203>:
.globl vector203
vector203:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $203
801068dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801068e2:	e9 e0 f2 ff ff       	jmp    80105bc7 <alltraps>

801068e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $204
801068e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801068ee:	e9 d4 f2 ff ff       	jmp    80105bc7 <alltraps>

801068f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $205
801068f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801068fa:	e9 c8 f2 ff ff       	jmp    80105bc7 <alltraps>

801068ff <vector206>:
.globl vector206
vector206:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $206
80106901:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106906:	e9 bc f2 ff ff       	jmp    80105bc7 <alltraps>

8010690b <vector207>:
.globl vector207
vector207:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $207
8010690d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106912:	e9 b0 f2 ff ff       	jmp    80105bc7 <alltraps>

80106917 <vector208>:
.globl vector208
vector208:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $208
80106919:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010691e:	e9 a4 f2 ff ff       	jmp    80105bc7 <alltraps>

80106923 <vector209>:
.globl vector209
vector209:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $209
80106925:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010692a:	e9 98 f2 ff ff       	jmp    80105bc7 <alltraps>

8010692f <vector210>:
.globl vector210
vector210:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $210
80106931:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106936:	e9 8c f2 ff ff       	jmp    80105bc7 <alltraps>

8010693b <vector211>:
.globl vector211
vector211:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $211
8010693d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106942:	e9 80 f2 ff ff       	jmp    80105bc7 <alltraps>

80106947 <vector212>:
.globl vector212
vector212:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $212
80106949:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010694e:	e9 74 f2 ff ff       	jmp    80105bc7 <alltraps>

80106953 <vector213>:
.globl vector213
vector213:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $213
80106955:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010695a:	e9 68 f2 ff ff       	jmp    80105bc7 <alltraps>

8010695f <vector214>:
.globl vector214
vector214:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $214
80106961:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106966:	e9 5c f2 ff ff       	jmp    80105bc7 <alltraps>

8010696b <vector215>:
.globl vector215
vector215:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $215
8010696d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106972:	e9 50 f2 ff ff       	jmp    80105bc7 <alltraps>

80106977 <vector216>:
.globl vector216
vector216:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $216
80106979:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010697e:	e9 44 f2 ff ff       	jmp    80105bc7 <alltraps>

80106983 <vector217>:
.globl vector217
vector217:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $217
80106985:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010698a:	e9 38 f2 ff ff       	jmp    80105bc7 <alltraps>

8010698f <vector218>:
.globl vector218
vector218:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $218
80106991:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106996:	e9 2c f2 ff ff       	jmp    80105bc7 <alltraps>

8010699b <vector219>:
.globl vector219
vector219:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $219
8010699d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069a2:	e9 20 f2 ff ff       	jmp    80105bc7 <alltraps>

801069a7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $220
801069a9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069ae:	e9 14 f2 ff ff       	jmp    80105bc7 <alltraps>

801069b3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $221
801069b5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069ba:	e9 08 f2 ff ff       	jmp    80105bc7 <alltraps>

801069bf <vector222>:
.globl vector222
vector222:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $222
801069c1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069c6:	e9 fc f1 ff ff       	jmp    80105bc7 <alltraps>

801069cb <vector223>:
.globl vector223
vector223:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $223
801069cd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801069d2:	e9 f0 f1 ff ff       	jmp    80105bc7 <alltraps>

801069d7 <vector224>:
.globl vector224
vector224:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $224
801069d9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069de:	e9 e4 f1 ff ff       	jmp    80105bc7 <alltraps>

801069e3 <vector225>:
.globl vector225
vector225:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $225
801069e5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801069ea:	e9 d8 f1 ff ff       	jmp    80105bc7 <alltraps>

801069ef <vector226>:
.globl vector226
vector226:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $226
801069f1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801069f6:	e9 cc f1 ff ff       	jmp    80105bc7 <alltraps>

801069fb <vector227>:
.globl vector227
vector227:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $227
801069fd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a02:	e9 c0 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a07 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $228
80106a09:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a0e:	e9 b4 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a13 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $229
80106a15:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a1a:	e9 a8 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a1f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $230
80106a21:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a26:	e9 9c f1 ff ff       	jmp    80105bc7 <alltraps>

80106a2b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $231
80106a2d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a32:	e9 90 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a37 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $232
80106a39:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a3e:	e9 84 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a43 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $233
80106a45:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a4a:	e9 78 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a4f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $234
80106a51:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a56:	e9 6c f1 ff ff       	jmp    80105bc7 <alltraps>

80106a5b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $235
80106a5d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a62:	e9 60 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a67 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $236
80106a69:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a6e:	e9 54 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a73 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $237
80106a75:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a7a:	e9 48 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a7f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $238
80106a81:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106a86:	e9 3c f1 ff ff       	jmp    80105bc7 <alltraps>

80106a8b <vector239>:
.globl vector239
vector239:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $239
80106a8d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106a92:	e9 30 f1 ff ff       	jmp    80105bc7 <alltraps>

80106a97 <vector240>:
.globl vector240
vector240:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $240
80106a99:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106a9e:	e9 24 f1 ff ff       	jmp    80105bc7 <alltraps>

80106aa3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $241
80106aa5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106aaa:	e9 18 f1 ff ff       	jmp    80105bc7 <alltraps>

80106aaf <vector242>:
.globl vector242
vector242:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $242
80106ab1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ab6:	e9 0c f1 ff ff       	jmp    80105bc7 <alltraps>

80106abb <vector243>:
.globl vector243
vector243:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $243
80106abd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ac2:	e9 00 f1 ff ff       	jmp    80105bc7 <alltraps>

80106ac7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $244
80106ac9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ace:	e9 f4 f0 ff ff       	jmp    80105bc7 <alltraps>

80106ad3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $245
80106ad5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106ada:	e9 e8 f0 ff ff       	jmp    80105bc7 <alltraps>

80106adf <vector246>:
.globl vector246
vector246:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $246
80106ae1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ae6:	e9 dc f0 ff ff       	jmp    80105bc7 <alltraps>

80106aeb <vector247>:
.globl vector247
vector247:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $247
80106aed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106af2:	e9 d0 f0 ff ff       	jmp    80105bc7 <alltraps>

80106af7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $248
80106af9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106afe:	e9 c4 f0 ff ff       	jmp    80105bc7 <alltraps>

80106b03 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $249
80106b05:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b0a:	e9 b8 f0 ff ff       	jmp    80105bc7 <alltraps>

80106b0f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $250
80106b11:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b16:	e9 ac f0 ff ff       	jmp    80105bc7 <alltraps>

80106b1b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $251
80106b1d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b22:	e9 a0 f0 ff ff       	jmp    80105bc7 <alltraps>

80106b27 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $252
80106b29:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b2e:	e9 94 f0 ff ff       	jmp    80105bc7 <alltraps>

80106b33 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $253
80106b35:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b3a:	e9 88 f0 ff ff       	jmp    80105bc7 <alltraps>

80106b3f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $254
80106b41:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b46:	e9 7c f0 ff ff       	jmp    80105bc7 <alltraps>

80106b4b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $255
80106b4d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b52:	e9 70 f0 ff ff       	jmp    80105bc7 <alltraps>
80106b57:	66 90                	xchg   %ax,%ax
80106b59:	66 90                	xchg   %ax,%ax
80106b5b:	66 90                	xchg   %ax,%ax
80106b5d:	66 90                	xchg   %ax,%ax
80106b5f:	90                   	nop

80106b60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b66:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106b6c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b72:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106b75:	39 d3                	cmp    %edx,%ebx
80106b77:	73 6e                	jae    80106be7 <deallocuvm.part.0+0x87>
80106b79:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106b7c:	89 c6                	mov    %eax,%esi
80106b7e:	89 d7                	mov    %edx,%edi
80106b80:	eb 2a                	jmp    80106bac <deallocuvm.part.0+0x4c>
80106b82:	eb 1c                	jmp    80106ba0 <deallocuvm.part.0+0x40>
80106b84:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b8b:	00 
80106b8c:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b93:	00 
80106b94:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b9b:	00 
80106b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ba0:	83 c2 01             	add    $0x1,%edx
80106ba3:	89 d3                	mov    %edx,%ebx
80106ba5:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ba8:	39 fb                	cmp    %edi,%ebx
80106baa:	73 38                	jae    80106be4 <deallocuvm.part.0+0x84>
  pde = &pgdir[PDX(va)];
80106bac:	89 da                	mov    %ebx,%edx
80106bae:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106bb1:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106bb4:	a8 01                	test   $0x1,%al
80106bb6:	74 e8                	je     80106ba0 <deallocuvm.part.0+0x40>
  return &pgtab[PTX(va)];
80106bb8:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106bba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106bbf:	c1 e9 0a             	shr    $0xa,%ecx
80106bc2:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106bc8:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106bcf:	85 c0                	test   %eax,%eax
80106bd1:	74 cd                	je     80106ba0 <deallocuvm.part.0+0x40>
    else if((*pte & PTE_P) != 0){
80106bd3:	8b 10                	mov    (%eax),%edx
80106bd5:	f6 c2 01             	test   $0x1,%dl
80106bd8:	75 1e                	jne    80106bf8 <deallocuvm.part.0+0x98>
  for(; a  < oldsz; a += PGSIZE){
80106bda:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106be0:	39 fb                	cmp    %edi,%ebx
80106be2:	72 c8                	jb     80106bac <deallocuvm.part.0+0x4c>
80106be4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bea:	89 c8                	mov    %ecx,%eax
80106bec:	5b                   	pop    %ebx
80106bed:	5e                   	pop    %esi
80106bee:	5f                   	pop    %edi
80106bef:	5d                   	pop    %ebp
80106bf0:	c3                   	ret
80106bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106bf8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106bfe:	74 26                	je     80106c26 <deallocuvm.part.0+0xc6>
      kfree(v);
80106c00:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c03:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106c0c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106c12:	52                   	push   %edx
80106c13:	e8 28 b9 ff ff       	call   80102540 <kfree>
      *pte = 0;
80106c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106c1b:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106c1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106c24:	eb 82                	jmp    80106ba8 <deallocuvm.part.0+0x48>
        panic("kfree");
80106c26:	83 ec 0c             	sub    $0xc,%esp
80106c29:	68 0c 77 10 80       	push   $0x8010770c
80106c2e:	e8 6d 97 ff ff       	call   801003a0 <panic>
80106c33:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c3a:	00 
80106c3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106c40 <mappages>:
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106c46:	89 d3                	mov    %edx,%ebx
80106c48:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c4e:	83 ec 1c             	sub    $0x1c,%esp
80106c51:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c54:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c60:	8b 45 08             	mov    0x8(%ebp),%eax
80106c63:	29 d8                	sub    %ebx,%eax
80106c65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c68:	eb 3f                	jmp    80106ca9 <mappages+0x69>
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106c70:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106c77:	c1 ea 0a             	shr    $0xa,%edx
80106c7a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c80:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c87:	85 c0                	test   %eax,%eax
80106c89:	74 75                	je     80106d00 <mappages+0xc0>
    if(*pte & PTE_P)
80106c8b:	f6 00 01             	testb  $0x1,(%eax)
80106c8e:	0f 85 86 00 00 00    	jne    80106d1a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106c94:	0b 75 0c             	or     0xc(%ebp),%esi
80106c97:	83 ce 01             	or     $0x1,%esi
80106c9a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106c9f:	39 c3                	cmp    %eax,%ebx
80106ca1:	74 6d                	je     80106d10 <mappages+0xd0>
    a += PGSIZE;
80106ca3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106cac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106caf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106cb2:	89 d8                	mov    %ebx,%eax
80106cb4:	c1 e8 16             	shr    $0x16,%eax
80106cb7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106cba:	8b 07                	mov    (%edi),%eax
80106cbc:	a8 01                	test   $0x1,%al
80106cbe:	75 b0                	jne    80106c70 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106cc0:	e8 4b ba ff ff       	call   80102710 <kalloc>
80106cc5:	85 c0                	test   %eax,%eax
80106cc7:	74 37                	je     80106d00 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106cc9:	83 ec 04             	sub    $0x4,%esp
80106ccc:	68 00 10 00 00       	push   $0x1000
80106cd1:	6a 00                	push   $0x0
80106cd3:	50                   	push   %eax
80106cd4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106cd7:	e8 c4 dc ff ff       	call   801049a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106cdc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106cdf:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ce2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106ce8:	83 c8 07             	or     $0x7,%eax
80106ceb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106ced:	89 d8                	mov    %ebx,%eax
80106cef:	c1 e8 0a             	shr    $0xa,%eax
80106cf2:	25 fc 0f 00 00       	and    $0xffc,%eax
80106cf7:	01 d0                	add    %edx,%eax
80106cf9:	eb 90                	jmp    80106c8b <mappages+0x4b>
80106cfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d08:	5b                   	pop    %ebx
80106d09:	5e                   	pop    %esi
80106d0a:	5f                   	pop    %edi
80106d0b:	5d                   	pop    %ebp
80106d0c:	c3                   	ret
80106d0d:	8d 76 00             	lea    0x0(%esi),%esi
80106d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d13:	31 c0                	xor    %eax,%eax
}
80106d15:	5b                   	pop    %ebx
80106d16:	5e                   	pop    %esi
80106d17:	5f                   	pop    %edi
80106d18:	5d                   	pop    %ebp
80106d19:	c3                   	ret
      panic("remap");
80106d1a:	83 ec 0c             	sub    $0xc,%esp
80106d1d:	68 40 79 10 80       	push   $0x80107940
80106d22:	e8 79 96 ff ff       	call   801003a0 <panic>
80106d27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d2e:	00 
80106d2f:	90                   	nop

80106d30 <seginit>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d36:	e8 25 cd ff ff       	call   80103a60 <cpuid>
  pd[0] = size-1;
80106d3b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d40:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106d46:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106d4d:	ff 00 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d50:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106d57:	ff 00 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d5a:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106d61:	ff 00 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d64:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106d6b:	ff 00 00 
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d6e:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106d75:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d78:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106d7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d82:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106d89:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d8c:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106d93:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d96:	05 10 18 11 80       	add    $0x80111810,%eax
80106d9b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106d9f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106da3:	c1 e8 10             	shr    $0x10,%eax
80106da6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106daa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106dad:	0f 01 10             	lgdtl  (%eax)
}
80106db0:	c9                   	leave
80106db1:	c3                   	ret
80106db2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106db9:	00 
80106dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dc0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dc0:	a1 c4 45 11 80       	mov    0x801145c4,%eax
80106dc5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106dca:	0f 22 d8             	mov    %eax,%cr3
}
80106dcd:	c3                   	ret
80106dce:	66 90                	xchg   %ax,%ax

80106dd0 <switchuvm>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106ddc:	85 f6                	test   %esi,%esi
80106dde:	0f 84 cb 00 00 00    	je     80106eaf <switchuvm+0xdf>
  if(p->kstack == 0)
80106de4:	8b 46 08             	mov    0x8(%esi),%eax
80106de7:	85 c0                	test   %eax,%eax
80106de9:	0f 84 da 00 00 00    	je     80106ec9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106def:	8b 46 04             	mov    0x4(%esi),%eax
80106df2:	85 c0                	test   %eax,%eax
80106df4:	0f 84 c2 00 00 00    	je     80106ebc <switchuvm+0xec>
  pushcli();
80106dfa:	e8 21 d9 ff ff       	call   80104720 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106dff:	e8 fc cb ff ff       	call   80103a00 <mycpu>
80106e04:	89 c3                	mov    %eax,%ebx
80106e06:	e8 f5 cb ff ff       	call   80103a00 <mycpu>
80106e0b:	89 c7                	mov    %eax,%edi
80106e0d:	e8 ee cb ff ff       	call   80103a00 <mycpu>
80106e12:	83 c7 08             	add    $0x8,%edi
80106e15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e18:	e8 e3 cb ff ff       	call   80103a00 <mycpu>
80106e1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e20:	ba 67 00 00 00       	mov    $0x67,%edx
80106e25:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106e2c:	83 c0 08             	add    $0x8,%eax
80106e2f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e36:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e3b:	83 c1 08             	add    $0x8,%ecx
80106e3e:	c1 e8 18             	shr    $0x18,%eax
80106e41:	c1 e9 10             	shr    $0x10,%ecx
80106e44:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106e4a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106e50:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e55:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e5c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106e61:	e8 9a cb ff ff       	call   80103a00 <mycpu>
80106e66:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e6d:	e8 8e cb ff ff       	call   80103a00 <mycpu>
80106e72:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e76:	8b 5e 08             	mov    0x8(%esi),%ebx
80106e79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e7f:	e8 7c cb ff ff       	call   80103a00 <mycpu>
80106e84:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e87:	e8 74 cb ff ff       	call   80103a00 <mycpu>
80106e8c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106e90:	b8 28 00 00 00       	mov    $0x28,%eax
80106e95:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106e98:	8b 46 04             	mov    0x4(%esi),%eax
80106e9b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ea0:	0f 22 d8             	mov    %eax,%cr3
}
80106ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea6:	5b                   	pop    %ebx
80106ea7:	5e                   	pop    %esi
80106ea8:	5f                   	pop    %edi
80106ea9:	5d                   	pop    %ebp
  popcli();
80106eaa:	e9 c1 d8 ff ff       	jmp    80104770 <popcli>
    panic("switchuvm: no process");
80106eaf:	83 ec 0c             	sub    $0xc,%esp
80106eb2:	68 46 79 10 80       	push   $0x80107946
80106eb7:	e8 e4 94 ff ff       	call   801003a0 <panic>
    panic("switchuvm: no pgdir");
80106ebc:	83 ec 0c             	sub    $0xc,%esp
80106ebf:	68 71 79 10 80       	push   $0x80107971
80106ec4:	e8 d7 94 ff ff       	call   801003a0 <panic>
    panic("switchuvm: no kstack");
80106ec9:	83 ec 0c             	sub    $0xc,%esp
80106ecc:	68 5c 79 10 80       	push   $0x8010795c
80106ed1:	e8 ca 94 ff ff       	call   801003a0 <panic>
80106ed6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106edd:	00 
80106ede:	66 90                	xchg   %ax,%ax

80106ee0 <inituvm>:
{
80106ee0:	55                   	push   %ebp
80106ee1:	89 e5                	mov    %esp,%ebp
80106ee3:	57                   	push   %edi
80106ee4:	56                   	push   %esi
80106ee5:	53                   	push   %ebx
80106ee6:	83 ec 1c             	sub    $0x1c,%esp
80106ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80106eec:	8b 75 10             	mov    0x10(%ebp),%esi
80106eef:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106ef2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ef5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106efb:	77 49                	ja     80106f46 <inituvm+0x66>
  mem = kalloc();
80106efd:	e8 0e b8 ff ff       	call   80102710 <kalloc>
  memset(mem, 0, PGSIZE);
80106f02:	83 ec 04             	sub    $0x4,%esp
80106f05:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106f0a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f0c:	6a 00                	push   $0x0
80106f0e:	50                   	push   %eax
80106f0f:	e8 8c da ff ff       	call   801049a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f14:	58                   	pop    %eax
80106f15:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f1b:	5a                   	pop    %edx
80106f1c:	6a 06                	push   $0x6
80106f1e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f23:	31 d2                	xor    %edx,%edx
80106f25:	50                   	push   %eax
80106f26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f29:	e8 12 fd ff ff       	call   80106c40 <mappages>
  memmove(mem, init, sz);
80106f2e:	83 c4 10             	add    $0x10,%esp
80106f31:	89 75 10             	mov    %esi,0x10(%ebp)
80106f34:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f37:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f3d:	5b                   	pop    %ebx
80106f3e:	5e                   	pop    %esi
80106f3f:	5f                   	pop    %edi
80106f40:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f41:	e9 ea da ff ff       	jmp    80104a30 <memmove>
    panic("inituvm: more than a page");
80106f46:	83 ec 0c             	sub    $0xc,%esp
80106f49:	68 85 79 10 80       	push   $0x80107985
80106f4e:	e8 4d 94 ff ff       	call   801003a0 <panic>
80106f53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f5a:	00 
80106f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106f60 <loaduvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106f69:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106f6c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106f6f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106f75:	0f 85 a2 00 00 00    	jne    8010701d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106f7b:	85 ff                	test   %edi,%edi
80106f7d:	74 7d                	je     80106ffc <loaduvm+0x9c>
80106f7f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106f83:	8b 55 08             	mov    0x8(%ebp),%edx
80106f86:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106f88:	89 c1                	mov    %eax,%ecx
80106f8a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106f8d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106f90:	f6 c1 01             	test   $0x1,%cl
80106f93:	75 13                	jne    80106fa8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106f95:	83 ec 0c             	sub    $0xc,%esp
80106f98:	68 9f 79 10 80       	push   $0x8010799f
80106f9d:	e8 fe 93 ff ff       	call   801003a0 <panic>
80106fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106fa8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106fb1:	25 fc 0f 00 00       	and    $0xffc,%eax
80106fb6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fbd:	85 c9                	test   %ecx,%ecx
80106fbf:	74 d4                	je     80106f95 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106fc1:	89 fb                	mov    %edi,%ebx
80106fc3:	b8 00 10 00 00       	mov    $0x1000,%eax
80106fc8:	29 f3                	sub    %esi,%ebx
80106fca:	39 c3                	cmp    %eax,%ebx
80106fcc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fcf:	53                   	push   %ebx
80106fd0:	8b 45 14             	mov    0x14(%ebp),%eax
80106fd3:	01 f0                	add    %esi,%eax
80106fd5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106fd6:	8b 01                	mov    (%ecx),%eax
80106fd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fdd:	05 00 00 00 80       	add    $0x80000000,%eax
80106fe2:	50                   	push   %eax
80106fe3:	ff 75 10             	push   0x10(%ebp)
80106fe6:	e8 15 ab ff ff       	call   80101b00 <readi>
80106feb:	83 c4 10             	add    $0x10,%esp
80106fee:	39 d8                	cmp    %ebx,%eax
80106ff0:	75 1e                	jne    80107010 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106ff2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ff8:	39 fe                	cmp    %edi,%esi
80106ffa:	72 84                	jb     80106f80 <loaduvm+0x20>
}
80106ffc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fff:	31 c0                	xor    %eax,%eax
}
80107001:	5b                   	pop    %ebx
80107002:	5e                   	pop    %esi
80107003:	5f                   	pop    %edi
80107004:	5d                   	pop    %ebp
80107005:	c3                   	ret
80107006:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010700d:	00 
8010700e:	66 90                	xchg   %ax,%ax
80107010:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107018:	5b                   	pop    %ebx
80107019:	5e                   	pop    %esi
8010701a:	5f                   	pop    %edi
8010701b:	5d                   	pop    %ebp
8010701c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
8010701d:	83 ec 0c             	sub    $0xc,%esp
80107020:	68 a0 7b 10 80       	push   $0x80107ba0
80107025:	e8 76 93 ff ff       	call   801003a0 <panic>
8010702a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107030 <allocuvm>:
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
80107039:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
8010703c:	85 f6                	test   %esi,%esi
8010703e:	0f 88 99 00 00 00    	js     801070dd <allocuvm+0xad>
80107044:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80107046:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107049:	0f 82 a1 00 00 00    	jb     801070f0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010704f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107052:	05 ff 0f 00 00       	add    $0xfff,%eax
80107057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010705c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
8010705e:	39 f0                	cmp    %esi,%eax
80107060:	0f 83 8d 00 00 00    	jae    801070f3 <allocuvm+0xc3>
80107066:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80107069:	eb 45                	jmp    801070b0 <allocuvm+0x80>
8010706b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107070:	83 ec 04             	sub    $0x4,%esp
80107073:	68 00 10 00 00       	push   $0x1000
80107078:	6a 00                	push   $0x0
8010707a:	50                   	push   %eax
8010707b:	e8 20 d9 ff ff       	call   801049a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107080:	58                   	pop    %eax
80107081:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107087:	5a                   	pop    %edx
80107088:	6a 06                	push   $0x6
8010708a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010708f:	89 fa                	mov    %edi,%edx
80107091:	50                   	push   %eax
80107092:	8b 45 08             	mov    0x8(%ebp),%eax
80107095:	e8 a6 fb ff ff       	call   80106c40 <mappages>
8010709a:	83 c4 10             	add    $0x10,%esp
8010709d:	83 f8 ff             	cmp    $0xffffffff,%eax
801070a0:	74 5e                	je     80107100 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
801070a2:	81 c7 00 10 00 00    	add    $0x1000,%edi
801070a8:	39 f7                	cmp    %esi,%edi
801070aa:	0f 83 88 00 00 00    	jae    80107138 <allocuvm+0x108>
    mem = kalloc();
801070b0:	e8 5b b6 ff ff       	call   80102710 <kalloc>
801070b5:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801070b7:	85 c0                	test   %eax,%eax
801070b9:	75 b5                	jne    80107070 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070bb:	83 ec 0c             	sub    $0xc,%esp
801070be:	68 bd 79 10 80       	push   $0x801079bd
801070c3:	e8 08 96 ff ff       	call   801006d0 <cprintf>
  if(newsz >= oldsz)
801070c8:	83 c4 10             	add    $0x10,%esp
801070cb:	3b 75 0c             	cmp    0xc(%ebp),%esi
801070ce:	74 0d                	je     801070dd <allocuvm+0xad>
801070d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070d3:	8b 45 08             	mov    0x8(%ebp),%eax
801070d6:	89 f2                	mov    %esi,%edx
801070d8:	e8 83 fa ff ff       	call   80106b60 <deallocuvm.part.0>
    return 0;
801070dd:	31 d2                	xor    %edx,%edx
}
801070df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e2:	89 d0                	mov    %edx,%eax
801070e4:	5b                   	pop    %ebx
801070e5:	5e                   	pop    %esi
801070e6:	5f                   	pop    %edi
801070e7:	5d                   	pop    %ebp
801070e8:	c3                   	ret
801070e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801070f0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801070f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070f6:	89 d0                	mov    %edx,%eax
801070f8:	5b                   	pop    %ebx
801070f9:	5e                   	pop    %esi
801070fa:	5f                   	pop    %edi
801070fb:	5d                   	pop    %ebp
801070fc:	c3                   	ret
801070fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107100:	83 ec 0c             	sub    $0xc,%esp
80107103:	68 d5 79 10 80       	push   $0x801079d5
80107108:	e8 c3 95 ff ff       	call   801006d0 <cprintf>
  if(newsz >= oldsz)
8010710d:	83 c4 10             	add    $0x10,%esp
80107110:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107113:	74 0d                	je     80107122 <allocuvm+0xf2>
80107115:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107118:	8b 45 08             	mov    0x8(%ebp),%eax
8010711b:	89 f2                	mov    %esi,%edx
8010711d:	e8 3e fa ff ff       	call   80106b60 <deallocuvm.part.0>
      kfree(mem);
80107122:	83 ec 0c             	sub    $0xc,%esp
80107125:	53                   	push   %ebx
80107126:	e8 15 b4 ff ff       	call   80102540 <kfree>
      return 0;
8010712b:	83 c4 10             	add    $0x10,%esp
    return 0;
8010712e:	31 d2                	xor    %edx,%edx
80107130:	eb ad                	jmp    801070df <allocuvm+0xaf>
80107132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107138:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
8010713b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010713e:	5b                   	pop    %ebx
8010713f:	5e                   	pop    %esi
80107140:	89 d0                	mov    %edx,%eax
80107142:	5f                   	pop    %edi
80107143:	5d                   	pop    %ebp
80107144:	c3                   	ret
80107145:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010714c:	00 
8010714d:	8d 76 00             	lea    0x0(%esi),%esi

80107150 <deallocuvm>:
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	8b 55 0c             	mov    0xc(%ebp),%edx
80107156:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107159:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010715c:	39 d1                	cmp    %edx,%ecx
8010715e:	73 10                	jae    80107170 <deallocuvm+0x20>
}
80107160:	5d                   	pop    %ebp
80107161:	e9 fa f9 ff ff       	jmp    80106b60 <deallocuvm.part.0>
80107166:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010716d:	00 
8010716e:	66 90                	xchg   %ax,%ax
80107170:	89 d0                	mov    %edx,%eax
80107172:	5d                   	pop    %ebp
80107173:	c3                   	ret
80107174:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010717b:	00 
8010717c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107180 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 0c             	sub    $0xc,%esp
80107189:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010718c:	85 f6                	test   %esi,%esi
8010718e:	74 59                	je     801071e9 <freevm+0x69>
  if(newsz >= oldsz)
80107190:	31 c9                	xor    %ecx,%ecx
80107192:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107197:	89 f0                	mov    %esi,%eax
80107199:	89 f3                	mov    %esi,%ebx
8010719b:	e8 c0 f9 ff ff       	call   80106b60 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071a6:	eb 0f                	jmp    801071b7 <freevm+0x37>
801071a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071af:	00 
801071b0:	83 c3 04             	add    $0x4,%ebx
801071b3:	39 fb                	cmp    %edi,%ebx
801071b5:	74 23                	je     801071da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071b7:	8b 03                	mov    (%ebx),%eax
801071b9:	a8 01                	test   $0x1,%al
801071bb:	74 f3                	je     801071b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071c2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071cd:	50                   	push   %eax
801071ce:	e8 6d b3 ff ff       	call   80102540 <kfree>
801071d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071d6:	39 fb                	cmp    %edi,%ebx
801071d8:	75 dd                	jne    801071b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e0:	5b                   	pop    %ebx
801071e1:	5e                   	pop    %esi
801071e2:	5f                   	pop    %edi
801071e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801071e4:	e9 57 b3 ff ff       	jmp    80102540 <kfree>
    panic("freevm: no pgdir");
801071e9:	83 ec 0c             	sub    $0xc,%esp
801071ec:	68 f1 79 10 80       	push   $0x801079f1
801071f1:	e8 aa 91 ff ff       	call   801003a0 <panic>
801071f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071fd:	00 
801071fe:	66 90                	xchg   %ax,%ax

80107200 <setupkvm>:
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	56                   	push   %esi
80107204:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107205:	e8 06 b5 ff ff       	call   80102710 <kalloc>
8010720a:	85 c0                	test   %eax,%eax
8010720c:	74 5e                	je     8010726c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010720e:	83 ec 04             	sub    $0x4,%esp
80107211:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107213:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107218:	68 00 10 00 00       	push   $0x1000
8010721d:	6a 00                	push   $0x0
8010721f:	50                   	push   %eax
80107220:	e8 7b d7 ff ff       	call   801049a0 <memset>
80107225:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107228:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010722b:	83 ec 08             	sub    $0x8,%esp
8010722e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107231:	8b 13                	mov    (%ebx),%edx
80107233:	ff 73 0c             	push   0xc(%ebx)
80107236:	50                   	push   %eax
80107237:	29 c1                	sub    %eax,%ecx
80107239:	89 f0                	mov    %esi,%eax
8010723b:	e8 00 fa ff ff       	call   80106c40 <mappages>
80107240:	83 c4 10             	add    $0x10,%esp
80107243:	83 f8 ff             	cmp    $0xffffffff,%eax
80107246:	74 18                	je     80107260 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107248:	83 c3 10             	add    $0x10,%ebx
8010724b:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107251:	75 d5                	jne    80107228 <setupkvm+0x28>
}
80107253:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107256:	89 f0                	mov    %esi,%eax
80107258:	5b                   	pop    %ebx
80107259:	5e                   	pop    %esi
8010725a:	5d                   	pop    %ebp
8010725b:	c3                   	ret
8010725c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107260:	83 ec 0c             	sub    $0xc,%esp
80107263:	56                   	push   %esi
80107264:	e8 17 ff ff ff       	call   80107180 <freevm>
      return 0;
80107269:	83 c4 10             	add    $0x10,%esp
}
8010726c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010726f:	31 f6                	xor    %esi,%esi
}
80107271:	89 f0                	mov    %esi,%eax
80107273:	5b                   	pop    %ebx
80107274:	5e                   	pop    %esi
80107275:	5d                   	pop    %ebp
80107276:	c3                   	ret
80107277:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010727e:	00 
8010727f:	90                   	nop

80107280 <kvmalloc>:
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107286:	e8 75 ff ff ff       	call   80107200 <setupkvm>
8010728b:	a3 c4 45 11 80       	mov    %eax,0x801145c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107290:	05 00 00 00 80       	add    $0x80000000,%eax
80107295:	0f 22 d8             	mov    %eax,%cr3
}
80107298:	c9                   	leave
80107299:	c3                   	ret
8010729a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	83 ec 08             	sub    $0x8,%esp
801072a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072a9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072ac:	89 c1                	mov    %eax,%ecx
801072ae:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072b1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072b4:	f6 c2 01             	test   $0x1,%dl
801072b7:	75 17                	jne    801072d0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801072b9:	83 ec 0c             	sub    $0xc,%esp
801072bc:	68 02 7a 10 80       	push   $0x80107a02
801072c1:	e8 da 90 ff ff       	call   801003a0 <panic>
801072c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801072cd:	00 
801072ce:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801072d0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072d3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801072d9:	25 fc 0f 00 00       	and    $0xffc,%eax
801072de:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801072e5:	85 c0                	test   %eax,%eax
801072e7:	74 d0                	je     801072b9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801072e9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072ec:	c9                   	leave
801072ed:	c3                   	ret
801072ee:	66 90                	xchg   %ax,%ax

801072f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801072f9:	e8 02 ff ff ff       	call   80107200 <setupkvm>
801072fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107301:	85 c0                	test   %eax,%eax
80107303:	0f 84 e9 00 00 00    	je     801073f2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107309:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010730c:	85 c9                	test   %ecx,%ecx
8010730e:	0f 84 b3 00 00 00    	je     801073c7 <copyuvm+0xd7>
80107314:	31 f6                	xor    %esi,%esi
80107316:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010731d:	00 
8010731e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107320:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107323:	89 f0                	mov    %esi,%eax
80107325:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107328:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010732b:	a8 01                	test   $0x1,%al
8010732d:	75 11                	jne    80107340 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010732f:	83 ec 0c             	sub    $0xc,%esp
80107332:	68 0c 7a 10 80       	push   $0x80107a0c
80107337:	e8 64 90 ff ff       	call   801003a0 <panic>
8010733c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107340:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107342:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107347:	c1 ea 0a             	shr    $0xa,%edx
8010734a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107350:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107357:	85 c0                	test   %eax,%eax
80107359:	74 d4                	je     8010732f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010735b:	8b 00                	mov    (%eax),%eax
8010735d:	a8 01                	test   $0x1,%al
8010735f:	0f 84 96 00 00 00    	je     801073fb <copyuvm+0x10b>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107365:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107367:	25 ff 0f 00 00       	and    $0xfff,%eax
8010736c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010736f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107375:	e8 96 b3 ff ff       	call   80102710 <kalloc>
8010737a:	89 c3                	mov    %eax,%ebx
8010737c:	85 c0                	test   %eax,%eax
8010737e:	74 64                	je     801073e4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107380:	83 ec 04             	sub    $0x4,%esp
80107383:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107389:	68 00 10 00 00       	push   $0x1000
8010738e:	57                   	push   %edi
8010738f:	50                   	push   %eax
80107390:	e8 9b d6 ff ff       	call   80104a30 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107395:	58                   	pop    %eax
80107396:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010739c:	5a                   	pop    %edx
8010739d:	ff 75 e4             	push   -0x1c(%ebp)
801073a0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073a5:	89 f2                	mov    %esi,%edx
801073a7:	50                   	push   %eax
801073a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ab:	e8 90 f8 ff ff       	call   80106c40 <mappages>
801073b0:	83 c4 10             	add    $0x10,%esp
801073b3:	83 f8 ff             	cmp    $0xffffffff,%eax
801073b6:	74 20                	je     801073d8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801073b8:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073be:	3b 75 0c             	cmp    0xc(%ebp),%esi
801073c1:	0f 82 59 ff ff ff    	jb     80107320 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801073c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073cd:	5b                   	pop    %ebx
801073ce:	5e                   	pop    %esi
801073cf:	5f                   	pop    %edi
801073d0:	5d                   	pop    %ebp
801073d1:	c3                   	ret
801073d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      kfree(mem);
801073d8:	83 ec 0c             	sub    $0xc,%esp
801073db:	53                   	push   %ebx
801073dc:	e8 5f b1 ff ff       	call   80102540 <kfree>
      goto bad;
801073e1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801073e4:	83 ec 0c             	sub    $0xc,%esp
801073e7:	ff 75 e0             	push   -0x20(%ebp)
801073ea:	e8 91 fd ff ff       	call   80107180 <freevm>
  return 0;
801073ef:	83 c4 10             	add    $0x10,%esp
    return 0;
801073f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801073f9:	eb cc                	jmp    801073c7 <copyuvm+0xd7>
      panic("copyuvm: page not present");
801073fb:	83 ec 0c             	sub    $0xc,%esp
801073fe:	68 26 7a 10 80       	push   $0x80107a26
80107403:	e8 98 8f ff ff       	call   801003a0 <panic>
80107408:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010740f:	00 

80107410 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107416:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107419:	89 c1                	mov    %eax,%ecx
8010741b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010741e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107421:	f6 c2 01             	test   $0x1,%dl
80107424:	0f 84 f0 00 00 00    	je     8010751a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010742a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010742d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107433:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107434:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107439:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107440:	89 d0                	mov    %edx,%eax
80107442:	f7 d2                	not    %edx
80107444:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107449:	05 00 00 00 80       	add    $0x80000000,%eax
8010744e:	83 e2 05             	and    $0x5,%edx
80107451:	ba 00 00 00 00       	mov    $0x0,%edx
80107456:	0f 45 c2             	cmovne %edx,%eax
}
80107459:	c3                   	ret
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107460 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	57                   	push   %edi
80107464:	56                   	push   %esi
80107465:	53                   	push   %ebx
80107466:	83 ec 0c             	sub    $0xc,%esp
80107469:	8b 75 14             	mov    0x14(%ebp),%esi
8010746c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010746f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107472:	85 f6                	test   %esi,%esi
80107474:	75 49                	jne    801074bf <copyout+0x5f>
80107476:	e9 95 00 00 00       	jmp    80107510 <copyout+0xb0>
8010747b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107480:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107485:	05 00 00 00 80       	add    $0x80000000,%eax
8010748a:	74 6e                	je     801074fa <copyout+0x9a>
      return -1;
    n = PGSIZE - (va - va0);
8010748c:	89 fb                	mov    %edi,%ebx
8010748e:	29 cb                	sub    %ecx,%ebx
80107490:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107496:	39 f3                	cmp    %esi,%ebx
80107498:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010749b:	29 f9                	sub    %edi,%ecx
8010749d:	83 ec 04             	sub    $0x4,%esp
801074a0:	01 c8                	add    %ecx,%eax
801074a2:	53                   	push   %ebx
801074a3:	52                   	push   %edx
801074a4:	89 55 10             	mov    %edx,0x10(%ebp)
801074a7:	50                   	push   %eax
801074a8:	e8 83 d5 ff ff       	call   80104a30 <memmove>
    len -= n;
    buf += n;
801074ad:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801074b0:	8d 8f 00 10 00 00    	lea    0x1000(%edi),%ecx
  while(len > 0){
801074b6:	83 c4 10             	add    $0x10,%esp
    buf += n;
801074b9:	01 da                	add    %ebx,%edx
  while(len > 0){
801074bb:	29 de                	sub    %ebx,%esi
801074bd:	74 51                	je     80107510 <copyout+0xb0>
  if(*pde & PTE_P){
801074bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801074c2:	89 c8                	mov    %ecx,%eax
    va0 = (uint)PGROUNDDOWN(va);
801074c4:	89 cf                	mov    %ecx,%edi
  pde = &pgdir[PDX(va)];
801074c6:	c1 e8 16             	shr    $0x16,%eax
    va0 = (uint)PGROUNDDOWN(va);
801074c9:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801074cf:	8b 04 83             	mov    (%ebx,%eax,4),%eax
801074d2:	a8 01                	test   $0x1,%al
801074d4:	0f 84 47 00 00 00    	je     80107521 <copyout.cold>
  return &pgtab[PTX(va)];
801074da:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801074e1:	c1 eb 0c             	shr    $0xc,%ebx
801074e4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801074ea:	8b 84 98 00 00 00 80 	mov    -0x80000000(%eax,%ebx,4),%eax
  if((*pte & PTE_U) == 0)
801074f1:	89 c3                	mov    %eax,%ebx
801074f3:	f7 d3                	not    %ebx
801074f5:	83 e3 05             	and    $0x5,%ebx
801074f8:	74 86                	je     80107480 <copyout+0x20>
  }
  return 0;
}
801074fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107502:	5b                   	pop    %ebx
80107503:	5e                   	pop    %esi
80107504:	5f                   	pop    %edi
80107505:	5d                   	pop    %ebp
80107506:	c3                   	ret
80107507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010750e:	00 
8010750f:	90                   	nop
80107510:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107513:	31 c0                	xor    %eax,%eax
}
80107515:	5b                   	pop    %ebx
80107516:	5e                   	pop    %esi
80107517:	5f                   	pop    %edi
80107518:	5d                   	pop    %ebp
80107519:	c3                   	ret

8010751a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
8010751a:	a1 00 00 00 00       	mov    0x0,%eax
8010751f:	0f 0b                	ud2

80107521 <copyout.cold>:
80107521:	a1 00 00 00 00       	mov    0x0,%eax
80107526:	0f 0b                	ud2
