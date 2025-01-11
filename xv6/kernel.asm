
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
80100028:	bc d0 56 11 80       	mov    $0x801156d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 30 10 80       	mov    $0x80103030,%eax
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
8010004c:	68 60 73 10 80       	push   $0x80107360
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 d5 44 00 00       	call   80104530 <initlock>
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
80100092:	68 67 73 10 80       	push   $0x80107367
80100097:	50                   	push   %eax
80100098:	e8 63 43 00 00       	call   80104400 <initsleeplock>
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
801000e4:	e8 37 46 00 00       	call   80104720 <acquire>
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
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 59 45 00 00       	call   801046c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 42 00 00       	call   80104440 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 3f 21 00 00       	call   801022d0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 6e 73 10 80       	push   $0x8010736e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 1d 43 00 00       	call   801044e0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 f7 20 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 7f 73 10 80       	push   $0x8010737f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 42 00 00       	call   801044e0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 42 00 00       	call   801044a0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 00 45 00 00       	call   80104720 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 52 44 00 00       	jmp    801046c0 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 86 73 10 80       	push   $0x80107386
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 7b 44 00 00       	call   80104720 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ef 10 80       	push   $0x8010ef20
801002c8:	68 00 ef 10 80       	push   $0x8010ef00
801002cd:	e8 8e 3d 00 00       	call   80104060 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 99 36 00 00       	call   80103980 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 c5 43 00 00       	call   801046c0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 ee 10 80 	movsbl -0x7fef1180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ef 10 80       	push   $0x8010ef20
8010034c:	e8 6f 43 00 00       	call   801046c0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 32 25 00 00       	call   801028d0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 73 10 80       	push   $0x8010738d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 0f 78 10 80 	movl   $0x8010780f,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 83 41 00 00       	call   80104550 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 73 10 80       	push   $0x801073a1
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 8c 5a 00 00       	call   80105eb0 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 c1 59 00 00       	call   80105eb0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 b5 59 00 00       	call   80105eb0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 a9 59 00 00       	call   80105eb0 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 4a 43 00 00       	call   801048b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 a5 42 00 00       	call   80104820 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 a5 73 10 80       	push   $0x801073a5
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 50 41 00 00       	call   80104720 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 b7 40 00 00       	call   801046c0 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 11 00 00       	call   801017a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 60 78 10 80 	movzbl -0x7fef87a0(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ef 10 80       	push   $0x8010ef20
801007d8:	e8 43 3f 00 00       	call   80104720 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ef 10 80       	push   $0x8010ef20
801007fb:	e8 c0 3e 00 00       	call   801046c0 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf b8 73 10 80       	mov    $0x801073b8,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 bf 73 10 80       	push   $0x801073bf
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ef 10 80       	push   $0x8010ef20
801008b3:	e8 68 3e 00 00       	call   80104720 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ef 10 80       	push   $0x8010ef20
801008ed:	e8 ce 3d 00 00       	call   801046c0 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100914:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100933:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010094a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010095e:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100998:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a05:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a27:	68 00 ef 10 80       	push   $0x8010ef00
80100a2c:	e8 ef 36 00 00       	call   80104120 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 ac 37 00 00       	jmp    80104200 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 c8 73 10 80       	push   $0x801073c8
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 bb 3a 00 00       	call   80104530 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 19 00 00       	call   80102460 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 bf 2e 00 00       	call   80103980 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 74 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 a9 15 00 00       	call   80102080 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 30 03 00 00    	je     80100e12 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 01 65 00 00       	call   80107020 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 a1 02 00 00    	je     80100de2 <exec+0x332>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 c0 62 00 00       	call   80106e50 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 ba 61 00 00       	call   80106d80 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 c2 0e 00 00       	call   80101ab0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 98 63 00 00       	call   80106fa0 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 1c 0e 00 00       	call   80101a30 <iunlockput>
    end_op();
80100c14:	e8 97 21 00 00       	call   80102db0 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 5a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 e9 61 00 00       	call   80106e50 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 38 64 00 00       	call   801070c0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 56 01 00 00    	je     80100dee <exec+0x33e>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 41 3d 00 00       	call   80104a10 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 30 3d 00 00       	call   80104a10 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 9d 65 00 00       	call   80107290 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 98 62 00 00       	call   80106fa0 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 2c 65 00 00       	call   80107290 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 2c 3c 00 00       	call   801049d0 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 20 5e 00 00       	call   80106bf0 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 c8 61 00 00       	call   80106fa0 <freevm>
  return 0;
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	31 c0                	xor    %eax,%eax
80100ddd:	e9 3f fe ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100de7:	31 f6                	xor    %esi,%esi
80100de9:	e9 5a fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100dee:	be 10 00 00 00       	mov    $0x10,%esi
80100df3:	ba 04 00 00 00       	mov    $0x4,%edx
80100df8:	b8 03 00 00 00       	mov    $0x3,%eax
80100dfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e04:	00 00 00 
80100e07:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0d:	e9 17 ff ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e12:	e8 99 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100e17:	83 ec 0c             	sub    $0xc,%esp
80100e1a:	68 d0 73 10 80       	push   $0x801073d0
80100e1f:	e8 8c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e24:	83 c4 10             	add    $0x10,%esp
80100e27:	e9 f0 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 dc 73 10 80       	push   $0x801073dc
80100e3b:	68 60 ef 10 80       	push   $0x8010ef60
80100e40:	e8 eb 36 00 00       	call   80104530 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave
80100e49:	c3                   	ret
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 ef 10 80       	push   $0x8010ef60
80100e61:	e8 ba 38 00 00       	call   80104720 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 ef 10 80       	push   $0x8010ef60
80100e91:	e8 2a 38 00 00       	call   801046c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave
80100e9f:	c3                   	ret
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 ef 10 80       	push   $0x8010ef60
80100eaa:	e8 11 38 00 00       	call   801046c0 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave
80100eb8:	c3                   	ret
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 ef 10 80       	push   $0x8010ef60
80100ecf:	e8 4c 38 00 00       	call   80104720 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 ef 10 80       	push   $0x8010ef60
80100eec:	e8 cf 37 00 00       	call   801046c0 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave
80100ef7:	c3                   	ret
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 e3 73 10 80       	push   $0x801073e3
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f0c:	00 
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 ef 10 80       	push   $0x8010ef60
80100f21:	e8 fa 37 00 00       	call   80104720 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f57:	68 60 ef 10 80       	push   $0x8010ef60
80100f5c:	e8 5f 37 00 00       	call   801046c0 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret
80100f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7d:	00 
80100f7e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100f80:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 2d 37 00 00       	jmp    801046c0 <release>
80100f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f98:	e8 a3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 f9 1d 00 00       	jmp    80102db0 <end_op>
80100fb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fbe:	00 
80100fbf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 32 25 00 00       	call   80103500 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 eb 73 10 80       	push   $0x801073eb
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave
80101029:	c3                   	ret
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave
80101039:	c3                   	ret
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 0e 26 00 00       	jmp    801036c0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 f5 73 10 80       	push   $0x801073f5
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bb 00 00 00    	je     801011ad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010111e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101121:	ff 73 10             	push   0x10(%ebx)
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 82 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101147:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 ed 1b 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	57                   	push   %edi
8010115f:	ff 73 14             	push   0x14(%ebx)
80101162:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
80101177:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	ff 73 10             	push   0x10(%ebx)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 26 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
8010118a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 14                	jne    801011a8 <filewrite+0xd8>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 fe 73 10 80       	push   $0x801073fe
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	74 05                	je     801011b2 <filewrite+0xe2>
801011ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	89 f0                	mov    %esi,%eax
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 d2 23 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 04 74 10 80       	push   $0x80107404
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 8c 00 00 00    	je     80101286 <balloc+0xa6>
801011fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801011fc:	89 f8                	mov    %edi,%eax
801011fe:	83 ec 08             	sub    $0x8,%esp
80101201:	89 fe                	mov    %edi,%esi
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010120c:	50                   	push   %eax
8010120d:	ff 75 dc             	push   -0x24(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	83 c4 10             	add    $0x10,%esp
80101218:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101223:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101226:	31 c0                	xor    %eax,%eax
80101228:	eb 32                	jmp    8010125c <balloc+0x7c>
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101249:	89 fa                	mov    %edi,%edx
8010124b:	85 df                	test   %ebx,%edi
8010124d:	74 49                	je     80101298 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 07                	je     80101263 <balloc+0x83>
8010125c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010125f:	39 d6                	cmp    %edx,%esi
80101261:	72 cd                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101263:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101272:	e8 79 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
80101280:	0f 82 76 ff ff ff    	jb     801011fc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 0e 74 10 80       	push   $0x8010740e
8010128e:	e8 ed f0 ff ff       	call   80100380 <panic>
80101293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010129e:	09 da                	or     %ebx,%edx
801012a0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012a4:	57                   	push   %edi
801012a5:	e8 76 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
801012aa:	89 3c 24             	mov    %edi,(%esp)
801012ad:	e8 3e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012b2:	58                   	pop    %eax
801012b3:	5a                   	pop    %edx
801012b4:	56                   	push   %esi
801012b5:	ff 75 dc             	push   -0x24(%ebp)
801012b8:	e8 13 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012bd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c5:	68 00 02 00 00       	push   $0x200
801012ca:	6a 00                	push   $0x0
801012cc:	50                   	push   %eax
801012cd:	e8 4e 35 00 00       	call   80104820 <memset>
  log_write(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 46 1c 00 00       	call   80102f20 <log_write>
  brelse(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	89 f0                	mov    %esi,%eax
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f4:	31 ff                	xor    %edi,%edi
{
801012f6:	56                   	push   %esi
801012f7:	89 c6                	mov    %eax,%esi
801012f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 60 f9 10 80       	push   $0x8010f960
8010130a:	e8 11 34 00 00       	call   80104720 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	eb 1b                	jmp    80101332 <iget+0x42>
80101317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010131e:	00 
8010131f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101320:	39 33                	cmp    %esi,(%ebx)
80101322:	74 6c                	je     80101390 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010132a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101330:	74 26                	je     80101358 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101332:	8b 43 08             	mov    0x8(%ebx),%eax
80101335:	85 c0                	test   %eax,%eax
80101337:	7f e7                	jg     80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 ff                	test   %edi,%edi
8010133b:	75 e7                	jne    80101324 <iget+0x34>
8010133d:	85 c0                	test   %eax,%eax
8010133f:	75 76                	jne    801013b7 <iget+0xc7>
      empty = ip;
80101341:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101343:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101349:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010134f:	75 e1                	jne    80101332 <iget+0x42>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101358:	85 ff                	test   %edi,%edi
8010135a:	74 79                	je     801013d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010135c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010135f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101361:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101364:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010136b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101372:	68 60 f9 10 80       	push   $0x8010f960
80101377:	e8 44 33 00 00       	call   801046c0 <release>

  return ip;
8010137c:	83 c4 10             	add    $0x10,%esp
}
8010137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101382:	89 f8                	mov    %edi,%eax
80101384:	5b                   	pop    %ebx
80101385:	5e                   	pop    %esi
80101386:	5f                   	pop    %edi
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 53 04             	cmp    %edx,0x4(%ebx)
80101393:	75 8f                	jne    80101324 <iget+0x34>
      ip->ref++;
80101395:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101398:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010139b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010139d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013a0:	68 60 f9 10 80       	push   $0x8010f960
801013a5:	e8 16 33 00 00       	call   801046c0 <release>
      return ip;
801013aa:	83 c4 10             	add    $0x10,%esp
}
801013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b0:	89 f8                	mov    %edi,%eax
801013b2:	5b                   	pop    %ebx
801013b3:	5e                   	pop    %esi
801013b4:	5f                   	pop    %edi
801013b5:	5d                   	pop    %ebp
801013b6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bd:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013c3:	74 10                	je     801013d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c5:	8b 43 08             	mov    0x8(%ebx),%eax
801013c8:	85 c0                	test   %eax,%eax
801013ca:	0f 8f 50 ff ff ff    	jg     80101320 <iget+0x30>
801013d0:	e9 68 ff ff ff       	jmp    8010133d <iget+0x4d>
    panic("iget: no inodes");
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	68 24 74 10 80       	push   $0x80107424
801013dd:	e8 9e ef ff ff       	call   80100380 <panic>
801013e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013e9:	00 
801013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
{
801013f8:	89 e5                	mov    %esp,%ebp
801013fa:	56                   	push   %esi
801013fb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801013fc:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 de 1a 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 34 74 10 80       	push   $0x80107434
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101468:	00 
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 06 fd ff ff       	call   801011e0 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 36 1a 00 00       	call   80102f20 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 e1 fc ff ff       	call   801011e0 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010150e:	00 
8010150f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 be fc ff ff       	call   801011e0 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 47 74 10 80       	push   $0x80107447
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 4a 33 00 00       	call   801048b0 <memmove>
  brelse(bp);
80101566:	83 c4 10             	add    $0x10,%esp
80101569:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 5a 74 10 80       	push   $0x8010745a
80101591:	68 60 f9 10 80       	push   $0x8010f960
80101596:	e8 95 2f 00 00       	call   80104530 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 61 74 10 80       	push   $0x80107461
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 4c 2e 00 00       	call   80104400 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 15 11 80       	push   $0x801115b4
801015dc:	e8 cf 32 00 00       	call   801048b0 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 15 11 80    	push   0x801115cc
801015ef:	ff 35 c8 15 11 80    	push   0x801115c8
801015f5:	ff 35 c4 15 11 80    	push   0x801115c4
801015fb:	ff 35 c0 15 11 80    	push   0x801115c0
80101601:	ff 35 bc 15 11 80    	push   0x801115bc
80101607:	ff 35 b8 15 11 80    	push   0x801115b8
8010160d:	ff 35 b4 15 11 80    	push   0x801115b4
80101613:	68 74 78 10 80       	push   $0x80107874
80101618:	e8 93 f0 ff ff       	call   801006b0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave
80101624:	c3                   	ret
80101625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010162c:	00 
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165d:	00 
8010165e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	6a 40                	push   $0x40
801016a8:	6a 00                	push   $0x0
801016aa:	51                   	push   %ecx
801016ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ae:	e8 6d 31 00 00       	call   80104820 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 5b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 10 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 67 74 10 80       	push   $0x80107467
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 5a 31 00 00       	call   801048b0 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 c2 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 f9 10 80       	push   $0x8010f960
8010177f:	e8 9c 2f 00 00       	call   80104720 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010178f:	e8 2c 2f 00 00       	call   801046c0 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave
8010179a:	c3                   	ret
8010179b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 79 2c 00 00       	call   80104440 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret
801017d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 73 30 00 00       	call   801048b0 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 7f 74 10 80       	push   $0x8010747f
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 79 74 10 80       	push   $0x80107479
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010187b:	00 
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 48 2c 00 00       	call   801044e0 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 ec 2b 00 00       	jmp    801044a0 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 8e 74 10 80       	push   $0x8010748e
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018c8:	00 
801018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 5b 2b 00 00       	call   80104440 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 a1 2b 00 00       	call   801044a0 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101906:	e8 15 2e 00 00       	call   80104720 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 9b 2d 00 00       	jmp    801046c0 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 f9 10 80       	push   $0x8010f960
80101930:	e8 eb 2d 00 00       	call   80104720 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010193f:	e8 7c 2d 00 00       	call   801046c0 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 df                	mov    %ebx,%edi
8010195a:	89 cb                	mov    %ecx,%ebx
8010195c:	eb 09                	jmp    80101967 <iput+0x97>
8010195e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 de                	cmp    %ebx,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 07                	mov    (%edi),%eax
8010196f:	e8 7c fa ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	89 fb                	mov    %edi,%ebx
80101982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101985:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198b:	85 c0                	test   %eax,%eax
8010198d:	75 2d                	jne    801019bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101999:	53                   	push   %ebx
8010199a:	e8 51 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199f:	31 c0                	xor    %eax,%eax
801019a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	e9 3a ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	50                   	push   %eax
801019c0:	ff 33                	push   (%ebx)
801019c2:	e8 09 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019c7:	83 c4 10             	add    $0x10,%esp
801019ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d9:	89 cf                	mov    %ecx,%edi
801019db:	eb 0a                	jmp    801019e7 <iput+0x117>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 fe                	cmp    %edi,%esi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 fc f9 ff ff       	call   801013f0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ff:	50                   	push   %eax
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a05:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0b:	8b 03                	mov    (%ebx),%eax
80101a0d:	e8 de f9 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1c:	00 00 00 
80101a1f:	e9 6b ff ff ff       	jmp    8010198f <iput+0xbf>
80101a24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a2b:	00 
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 98 2a 00 00       	call   801044e0 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 41 2a 00 00       	call   801044a0 <releasesleep>
  iput(ip);
80101a5f:	83 c4 10             	add    $0x10,%esp
80101a62:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 8e 74 10 80       	push   $0x8010748e
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret
80101aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80101abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101acd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ad0:	0f 84 aa 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ad9:	8b 56 58             	mov    0x58(%esi),%edx
80101adc:	39 fa                	cmp    %edi,%edx
80101ade:	0f 82 bd 00 00 00    	jb     80101ba1 <readi+0xf1>
80101ae4:	89 f9                	mov    %edi,%ecx
80101ae6:	31 db                	xor    %ebx,%ebx
80101ae8:	01 c1                	add    %eax,%ecx
80101aea:	0f 92 c3             	setb   %bl
80101aed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101af0:	0f 82 ab 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101af6:	89 d3                	mov    %edx,%ebx
80101af8:	29 fb                	sub    %edi,%ebx
80101afa:	39 ca                	cmp    %ecx,%edx
80101afc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	85 c0                	test   %eax,%eax
80101b01:	74 73                	je     80101b76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 fa                	mov    %edi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f8                	mov    %edi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 f3                	sub    %esi,%ebx
80101b3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	39 d9                	cmp    %ebx,%ecx
80101b45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b48:	83 c4 0c             	add    $0xc,%esp
80101b4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4c:	01 de                	add    %ebx,%esi
80101b4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 54 2d 00 00       	call   801048b0 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	83 c4 10             	add    $0x10,%esp
80101b70:	39 de                	cmp    %ebx,%esi
80101b72:	72 9c                	jb     80101b10 <readi+0x60>
80101b74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
80101b7d:	c3                   	ret
80101b7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101b84:	66 83 fa 09          	cmp    $0x9,%dx
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e2                	jmp    *%edx
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb ce                	jmp    80101b76 <readi+0xc6>
80101ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101baf:	00 

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bcd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bd0:	0f 84 ba 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bd9:	0f 82 ea 00 00 00    	jb     80101cc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101be2:	89 f2                	mov    %esi,%edx
80101be4:	01 fa                	add    %edi,%edx
80101be6:	0f 82 dd 00 00 00    	jb     80101cc9 <writei+0x119>
80101bec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101bf2:	0f 87 d1 00 00 00    	ja     80101cc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	0f 84 85 00 00 00    	je     80101c85 <writei+0xd5>
80101c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f0                	mov    %esi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 36                	push   (%esi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 d3                	sub    %edx,%ebx
80101c40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c46:	39 d9                	cmp    %ebx,%ecx
80101c48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c51:	ff 75 dc             	push   -0x24(%ebp)
80101c54:	50                   	push   %eax
80101c55:	e8 56 2c 00 00       	call   801048b0 <memmove>
    log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 be 12 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c79:	39 d8                	cmp    %ebx,%eax
80101c7b:	72 93                	jb     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c80:	39 78 58             	cmp    %edi,0x58(%eax)
80101c83:	72 33                	jb     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 2f                	ja     80101cc9 <writei+0x119>
80101c9a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 24                	je     80101cc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cbe:	50                   	push   %eax
80101cbf:	e8 2c fa ff ff       	call   801016f0 <iupdate>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	eb bc                	jmp    80101c85 <writei+0xd5>
      return -1;
80101cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cce:	eb b8                	jmp    80101c88 <writei+0xd8>

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 3d 2c 00 00       	call   80104920 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cec:	00 
80101ced:	8d 76 00             	lea    0x0(%esi),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 8e fd ff ff       	call   80101ab0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 de 2b 00 00       	call   80104920 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 79 f5 ff ff       	call   801012f0 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 a8 74 10 80       	push   $0x801074a8
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 96 74 10 80       	push   $0x80107496
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 9e 01 00 00    	je     80101f58 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 c1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 f9 10 80       	push   $0x8010f960
80101dca:	e8 51 29 00 00       	call   80104720 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dda:	e8 e1 28 00 00       	call   801046c0 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
80101e32:	89 fb                	mov    %edi,%ebx
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 74 2a 00 00       	call   801048b0 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 47 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 b7 00 00 00    	jne    80101f1e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 f7 00 00 00    	je     80101f6e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c7                	mov    %eax,%edi
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	0f 84 8c 00 00 00    	je     80101f1e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e92:	83 ec 0c             	sub    $0xc,%esp
80101e95:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101e98:	51                   	push   %ecx
80101e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e9c:	e8 3f 26 00 00       	call   801044e0 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 02 01 00 00    	je     80101fae <namex+0x20e>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e f7 00 00 00    	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	51                   	push   %ecx
80101ebe:	e8 dd 25 00 00       	call   801044a0 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ec6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ec8:	e8 03 fa ff ff       	call   801018d0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101edb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 c0 29 00 00       	call   801048b0 <memmove>
    name[len] = 0;
80101ef0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 01 00             	movb   $0x0,(%ecx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 93 00 00 00    	jne    80101f9e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f24:	53                   	push   %ebx
80101f25:	e8 b6 25 00 00       	call   801044e0 <holdingsleep>
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 7d                	je     80101fae <namex+0x20e>
80101f31:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f34:	85 c9                	test   %ecx,%ecx
80101f36:	7e 76                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	53                   	push   %ebx
80101f3c:	e8 5f 25 00 00       	call   801044a0 <releasesleep>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 85 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f58:	ba 01 00 00 00       	mov    $0x1,%edx
80101f5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f62:	e8 89 f3 ff ff       	call   801012f0 <iget>
80101f67:	89 c6                	mov    %eax,%esi
80101f69:	e9 7d fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 66 25 00 00       	call   801044e0 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 2d                	je     80101fae <namex+0x20e>
80101f81:	8b 7e 08             	mov    0x8(%esi),%edi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	7e 26                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 0f 25 00 00       	call   801044a0 <releasesleep>
}
80101f91:	83 c4 10             	add    $0x10,%esp
}
80101f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5f                   	pop    %edi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret
    iput(ip);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	56                   	push   %esi
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa4:	e8 27 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	eb a0                	jmp    80101f4e <namex+0x1ae>
    panic("iunlock");
80101fae:	83 ec 0c             	sub    $0xc,%esp
80101fb1:	68 8e 74 10 80       	push   $0x8010748e
80101fb6:	e8 c5 e3 ff ff       	call   80100380 <panic>
80101fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101fc0 <dirlink>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 20             	sub    $0x20,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fcc:	6a 00                	push   $0x0
80101fce:	ff 75 0c             	push   0xc(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	e8 19 fd ff ff       	call   80101cf0 <dirlookup>
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	75 67                	jne    80102045 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe4:	85 ff                	test   %edi,%edi
80101fe6:	74 29                	je     80102011 <dirlink+0x51>
80101fe8:	31 ff                	xor    %edi,%edi
80101fea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fed:	eb 09                	jmp    80101ff8 <dirlink+0x38>
80101fef:	90                   	nop
80101ff0:	83 c7 10             	add    $0x10,%edi
80101ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ff6:	73 19                	jae    80102011 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 ae fa ff ff       	call   80101ab0 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 4e                	jne    80102058 <dirlink+0x98>
    if(de.inum == 0)
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	75 df                	jne    80101ff0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102011:	83 ec 04             	sub    $0x4,%esp
80102014:	8d 45 da             	lea    -0x26(%ebp),%eax
80102017:	6a 0e                	push   $0xe
80102019:	ff 75 0c             	push   0xc(%ebp)
8010201c:	50                   	push   %eax
8010201d:	e8 4e 29 00 00       	call   80104970 <strncpy>
  de.inum = inum;
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102029:	6a 10                	push   $0x10
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	e8 7d fb ff ff       	call   80101bb0 <writei>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	83 f8 10             	cmp    $0x10,%eax
80102039:	75 2a                	jne    80102065 <dirlink+0xa5>
  return 0;
8010203b:	31 c0                	xor    %eax,%eax
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    iput(ip);
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	50                   	push   %eax
80102049:	e8 82 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	eb e5                	jmp    8010203d <dirlink+0x7d>
      panic("dirlink read");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 b7 74 10 80       	push   $0x801074b7
80102060:	e8 1b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 13 77 10 80       	push   $0x80107713
8010206d:	e8 0e e3 ff ff       	call   80100380 <panic>
80102072:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102079:	00 
8010207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 0d fd ff ff       	call   80101da0 <namex>
}
80102093:	c9                   	leave
80102094:	c3                   	ret
80102095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010209c:	00 
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 ec fc ff ff       	jmp    80101da0 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020c9:	85 c0                	test   %eax,%eax
801020cb:	0f 84 b4 00 00 00    	je     80102185 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d1:	8b 70 08             	mov    0x8(%eax),%esi
801020d4:	89 c3                	mov    %eax,%ebx
801020d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020dc:	0f 87 96 00 00 00    	ja     80102178 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020ee:	00 
801020ef:	90                   	nop
801020f0:	89 ca                	mov    %ecx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	83 e0 c0             	and    $0xffffffc0,%eax
801020f6:	3c 40                	cmp    $0x40,%al
801020f8:	75 f6                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fa:	31 ff                	xor    %edi,%edi
801020fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102101:	89 f8                	mov    %edi,%eax
80102103:	ee                   	out    %al,(%dx)
80102104:	b8 01 00 00 00       	mov    $0x1,%eax
80102109:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210e:	ee                   	out    %al,(%dx)
8010210f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102114:	89 f0                	mov    %esi,%eax
80102116:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102117:	89 f0                	mov    %esi,%eax
80102119:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010211e:	c1 f8 08             	sar    $0x8,%eax
80102121:	ee                   	out    %al,(%dx)
80102122:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102127:	89 f8                	mov    %edi,%eax
80102129:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010212a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010212e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102133:	c1 e0 04             	shl    $0x4,%eax
80102136:	83 e0 10             	and    $0x10,%eax
80102139:	83 c8 e0             	or     $0xffffffe0,%eax
8010213c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010213d:	f6 03 04             	testb  $0x4,(%ebx)
80102140:	75 16                	jne    80102158 <idestart+0x98>
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	89 ca                	mov    %ecx,%edx
80102149:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214d:	5b                   	pop    %ebx
8010214e:	5e                   	pop    %esi
8010214f:	5f                   	pop    %edi
80102150:	5d                   	pop    %ebp
80102151:	c3                   	ret
80102152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102158:	b8 30 00 00 00       	mov    $0x30,%eax
8010215d:	89 ca                	mov    %ecx,%edx
8010215f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102160:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102165:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102168:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216d:	fc                   	cld
8010216e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret
    panic("incorrect blockno");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 cd 74 10 80       	push   $0x801074cd
80102180:	e8 fb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 c4 74 10 80       	push   $0x801074c4
8010218d:	e8 ee e1 ff ff       	call   80100380 <panic>
80102192:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102199:	00 
8010219a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021a0 <ideinit>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021a6:	68 df 74 10 80       	push   $0x801074df
801021ab:	68 00 16 11 80       	push   $0x80111600
801021b0:	e8 7b 23 00 00       	call   80104530 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b5:	58                   	pop    %eax
801021b6:	a1 84 17 11 80       	mov    0x80111784,%eax
801021bb:	5a                   	pop    %edx
801021bc:	83 e8 01             	sub    $0x1,%eax
801021bf:	50                   	push   %eax
801021c0:	6a 0e                	push   $0xe
801021c2:	e8 99 02 00 00       	call   80102460 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021cf:	90                   	nop
801021d0:	89 ca                	mov    %ecx,%edx
801021d2:	ec                   	in     (%dx),%al
801021d3:	83 e0 c0             	and    $0xffffffc0,%eax
801021d6:	3c 40                	cmp    $0x40,%al
801021d8:	75 f6                	jne    801021d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e5:	89 ca                	mov    %ecx,%edx
801021e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e8:	84 c0                	test   %al,%al
801021ea:	75 1e                	jne    8010220a <ideinit+0x6a>
801021ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801021f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021fd:	00 
801021fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x74>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x60>
      havedisk1 = 1;
8010220a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave
80102220:	c3                   	ret
80102221:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102228:	00 
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102239:	68 00 16 11 80       	push   $0x80111600
8010223e:	e8 dd 24 00 00       	call   80104720 <acquire>

  if((b = idequeue) == 0){
80102243:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 db                	test   %ebx,%ebx
8010224e:	74 63                	je     801022b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102250:	8b 43 58             	mov    0x58(%ebx),%eax
80102253:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102258:	8b 33                	mov    (%ebx),%esi
8010225a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102260:	75 2f                	jne    80102291 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226e:	00 
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c1                	mov    %eax,%ecx
80102273:	83 e1 c0             	and    $0xffffffc0,%ecx
80102276:	80 f9 40             	cmp    $0x40,%cl
80102279:	75 f5                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227b:	a8 21                	test   $0x21,%al
8010227d:	75 12                	jne    80102291 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010227f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102282:	b9 80 00 00 00       	mov    $0x80,%ecx
80102287:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228c:	fc                   	cld
8010228d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010228f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102291:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102294:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102297:	83 ce 02             	or     $0x2,%esi
8010229a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010229c:	53                   	push   %ebx
8010229d:	e8 7e 1e 00 00       	call   80104120 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	74 05                	je     801022b3 <ideintr+0x83>
    idestart(idequeue);
801022ae:	e8 0d fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	68 00 16 11 80       	push   $0x80111600
801022bb:	e8 00 24 00 00       	call   801046c0 <release>

  release(&idelock);
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret
801022c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022cf:	00 

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 10             	sub    $0x10,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022da:	8d 43 0c             	lea    0xc(%ebx),%eax
801022dd:	50                   	push   %eax
801022de:	e8 fd 21 00 00       	call   801044e0 <holdingsleep>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	85 c0                	test   %eax,%eax
801022e8:	0f 84 c3 00 00 00    	je     801023b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ee:	8b 03                	mov    (%ebx),%eax
801022f0:	83 e0 06             	and    $0x6,%eax
801022f3:	83 f8 02             	cmp    $0x2,%eax
801022f6:	0f 84 a8 00 00 00    	je     801023a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022fc:	8b 53 04             	mov    0x4(%ebx),%edx
801022ff:	85 d2                	test   %edx,%edx
80102301:	74 0d                	je     80102310 <iderw+0x40>
80102303:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102308:	85 c0                	test   %eax,%eax
8010230a:	0f 84 87 00 00 00    	je     80102397 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 00 16 11 80       	push   $0x80111600
80102318:	e8 03 24 00 00       	call   80104720 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102322:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102329:	83 c4 10             	add    $0x10,%esp
8010232c:	85 c0                	test   %eax,%eax
8010232e:	74 60                	je     80102390 <iderw+0xc0>
80102330:	89 c2                	mov    %eax,%edx
80102332:	8b 40 58             	mov    0x58(%eax),%eax
80102335:	85 c0                	test   %eax,%eax
80102337:	75 f7                	jne    80102330 <iderw+0x60>
80102339:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010233c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010233e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102344:	74 3a                	je     80102380 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102346:	8b 03                	mov    (%ebx),%eax
80102348:	83 e0 06             	and    $0x6,%eax
8010234b:	83 f8 02             	cmp    $0x2,%eax
8010234e:	74 1b                	je     8010236b <iderw+0x9b>
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 00 16 11 80       	push   $0x80111600
80102358:	53                   	push   %ebx
80102359:	e8 02 1d 00 00       	call   80104060 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x80>
  }


  release(&idelock);
8010236b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave
  release(&idelock);
80102376:	e9 45 23 00 00       	jmp    801046c0 <release>
8010237b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 39 fd ff ff       	call   801020c0 <idestart>
80102387:	eb bd                	jmp    80102346 <iderw+0x76>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102395:	eb a5                	jmp    8010233c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 0e 75 10 80       	push   $0x8010750e
8010239f:	e8 dc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 f9 74 10 80       	push   $0x801074f9
801023ac:	e8 cf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 e3 74 10 80       	push   $0x801074e3
801023b9:	e8 c2 df ff ff       	call   80100380 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c5:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023cc:	00 c0 fe 
  ioapic->reg = reg;
801023cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023d6:	00 00 00 
  return ioapic->data;
801023d9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023e8:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ee:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f5:	c1 ee 10             	shr    $0x10,%esi
801023f8:	89 f0                	mov    %esi,%eax
801023fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102400:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102403:	39 c2                	cmp    %eax,%edx
80102405:	74 16                	je     8010241d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 c8 78 10 80       	push   $0x801078c8
8010240f:	e8 9c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102414:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010241a:	83 c4 10             	add    $0x10,%esp
{
8010241d:	ba 10 00 00 00       	mov    $0x10,%edx
80102422:	31 c0                	xor    %eax,%eax
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102428:	89 13                	mov    %edx,(%ebx)
8010242a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010242d:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102433:	83 c0 01             	add    $0x1,%eax
80102436:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010243c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010243f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102442:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102445:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102447:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010244d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102454:	39 c6                	cmp    %eax,%esi
80102456:	7d d0                	jge    80102428 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245b:	5b                   	pop    %ebx
8010245c:	5e                   	pop    %esi
8010245d:	5d                   	pop    %ebp
8010245e:	c3                   	ret
8010245f:	90                   	nop

80102460 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102460:	55                   	push   %ebp
  ioapic->reg = reg;
80102461:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102467:	89 e5                	mov    %esp,%ebp
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010246c:	8d 50 20             	lea    0x20(%eax),%edx
8010246f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102473:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102475:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010247e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102481:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102484:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102486:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010248e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret
80102493:	66 90                	xchg   %ax,%ax
80102495:	66 90                	xchg   %ax,%ax
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 04             	sub    $0x4,%esp
801024a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024b0:	75 76                	jne    80102528 <kfree+0x88>
801024b2:	81 fb d0 56 11 80    	cmp    $0x801156d0,%ebx
801024b8:	72 6e                	jb     80102528 <kfree+0x88>
801024ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024c5:	77 61                	ja     80102528 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024c7:	83 ec 04             	sub    $0x4,%esp
801024ca:	68 00 10 00 00       	push   $0x1000
801024cf:	6a 01                	push   $0x1
801024d1:	53                   	push   %ebx
801024d2:	e8 49 23 00 00       	call   80104820 <memset>

  if(kmem.use_lock)
801024d7:	8b 15 74 16 11 80    	mov    0x80111674,%edx
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	85 d2                	test   %edx,%edx
801024e2:	75 1c                	jne    80102500 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024e4:	a1 78 16 11 80       	mov    0x80111678,%eax
801024e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024eb:	a1 74 16 11 80       	mov    0x80111674,%eax
  kmem.freelist = r;
801024f0:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
801024f6:	85 c0                	test   %eax,%eax
801024f8:	75 1e                	jne    80102518 <kfree+0x78>
    release(&kmem.lock);
}
801024fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fd:	c9                   	leave
801024fe:	c3                   	ret
801024ff:	90                   	nop
    acquire(&kmem.lock);
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 40 16 11 80       	push   $0x80111640
80102508:	e8 13 22 00 00       	call   80104720 <acquire>
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	eb d2                	jmp    801024e4 <kfree+0x44>
80102512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102518:	c7 45 08 40 16 11 80 	movl   $0x80111640,0x8(%ebp)
}
8010251f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102522:	c9                   	leave
    release(&kmem.lock);
80102523:	e9 98 21 00 00       	jmp    801046c0 <release>
    panic("kfree");
80102528:	83 ec 0c             	sub    $0xc,%esp
8010252b:	68 2c 75 10 80       	push   $0x8010752c
80102530:	e8 4b de ff ff       	call   80100380 <panic>
80102535:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010253c:	00 
8010253d:	8d 76 00             	lea    0x0(%esi),%esi

80102540 <freerange>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
80102544:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102545:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102548:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <freerange+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 23 ff ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <freerange+0x28>
}
80102584:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102587:	5b                   	pop    %ebx
80102588:	5e                   	pop    %esi
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret
8010258b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102590 <kinit2>:
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	56                   	push   %esi
80102594:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102595:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102598:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010259b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025ad:	39 de                	cmp    %ebx,%esi
801025af:	72 23                	jb     801025d4 <kinit2+0x44>
801025b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 d3 fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit2+0x28>
  kmem.use_lock = 1;
801025d4:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
801025db:	00 00 00 
}
801025de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e1:	5b                   	pop    %ebx
801025e2:	5e                   	pop    %esi
801025e3:	5d                   	pop    %ebp
801025e4:	c3                   	ret
801025e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ec:	00 
801025ed:	8d 76 00             	lea    0x0(%esi),%esi

801025f0 <kinit1>:
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	56                   	push   %esi
801025f4:	53                   	push   %ebx
801025f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025f8:	83 ec 08             	sub    $0x8,%esp
801025fb:	68 32 75 10 80       	push   $0x80107532
80102600:	68 40 16 11 80       	push   $0x80111640
80102605:	e8 26 1f 00 00       	call   80104530 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010260a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102610:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
80102617:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010261a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102620:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102626:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262c:	39 de                	cmp    %ebx,%esi
8010262e:	72 1c                	jb     8010264c <kinit1+0x5c>
    kfree(p);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102639:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010263f:	50                   	push   %eax
80102640:	e8 5b fe ff ff       	call   801024a0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	39 de                	cmp    %ebx,%esi
8010264a:	73 e4                	jae    80102630 <kinit1+0x40>
}
8010264c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010264f:	5b                   	pop    %ebx
80102650:	5e                   	pop    %esi
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret
80102653:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265a:	00 
8010265b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102660 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	53                   	push   %ebx
80102664:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102667:	a1 74 16 11 80       	mov    0x80111674,%eax
8010266c:	85 c0                	test   %eax,%eax
8010266e:	75 20                	jne    80102690 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102670:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
80102676:	85 db                	test   %ebx,%ebx
80102678:	74 07                	je     80102681 <kalloc+0x21>
    kmem.freelist = r->next;
8010267a:	8b 03                	mov    (%ebx),%eax
8010267c:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102681:	89 d8                	mov    %ebx,%eax
80102683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102686:	c9                   	leave
80102687:	c3                   	ret
80102688:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268f:	00 
    acquire(&kmem.lock);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	68 40 16 11 80       	push   $0x80111640
80102698:	e8 83 20 00 00       	call   80104720 <acquire>
  r = kmem.freelist;
8010269d:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(kmem.use_lock)
801026a3:	a1 74 16 11 80       	mov    0x80111674,%eax
  if(r)
801026a8:	83 c4 10             	add    $0x10,%esp
801026ab:	85 db                	test   %ebx,%ebx
801026ad:	74 08                	je     801026b7 <kalloc+0x57>
    kmem.freelist = r->next;
801026af:	8b 13                	mov    (%ebx),%edx
801026b1:	89 15 78 16 11 80    	mov    %edx,0x80111678
  if(kmem.use_lock)
801026b7:	85 c0                	test   %eax,%eax
801026b9:	74 c6                	je     80102681 <kalloc+0x21>
    release(&kmem.lock);
801026bb:	83 ec 0c             	sub    $0xc,%esp
801026be:	68 40 16 11 80       	push   $0x80111640
801026c3:	e8 f8 1f 00 00       	call   801046c0 <release>
}
801026c8:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
801026ca:	83 c4 10             	add    $0x10,%esp
}
801026cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026d0:	c9                   	leave
801026d1:	c3                   	ret
801026d2:	66 90                	xchg   %ax,%ax
801026d4:	66 90                	xchg   %ax,%ax
801026d6:	66 90                	xchg   %ax,%ax
801026d8:	66 90                	xchg   %ax,%ax
801026da:	66 90                	xchg   %ax,%ax
801026dc:	66 90                	xchg   %ax,%ax
801026de:	66 90                	xchg   %ax,%ax

801026e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e0:	ba 64 00 00 00       	mov    $0x64,%edx
801026e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026e6:	a8 01                	test   $0x1,%al
801026e8:	0f 84 c2 00 00 00    	je     801027b0 <kbdgetc+0xd0>
{
801026ee:	55                   	push   %ebp
801026ef:	ba 60 00 00 00       	mov    $0x60,%edx
801026f4:	89 e5                	mov    %esp,%ebp
801026f6:	53                   	push   %ebx
801026f7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801026f8:	8b 1d 7c 16 11 80    	mov    0x8011167c,%ebx
  data = inb(KBDATAP);
801026fe:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102701:	3c e0                	cmp    $0xe0,%al
80102703:	74 5b                	je     80102760 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102705:	89 da                	mov    %ebx,%edx
80102707:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010270a:	84 c0                	test   %al,%al
8010270c:	78 62                	js     80102770 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010270e:	85 d2                	test   %edx,%edx
80102710:	74 09                	je     8010271b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102712:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102715:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102718:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010271b:	0f b6 91 40 7b 10 80 	movzbl -0x7fef84c0(%ecx),%edx
  shift ^= togglecode[data];
80102722:	0f b6 81 40 7a 10 80 	movzbl -0x7fef85c0(%ecx),%eax
  shift |= shiftcode[data];
80102729:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010272b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010272d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010272f:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102735:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102738:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273b:	8b 04 85 20 7a 10 80 	mov    -0x7fef85e0(,%eax,4),%eax
80102742:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102746:	74 0b                	je     80102753 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102748:	8d 50 9f             	lea    -0x61(%eax),%edx
8010274b:	83 fa 19             	cmp    $0x19,%edx
8010274e:	77 48                	ja     80102798 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102750:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102756:	c9                   	leave
80102757:	c3                   	ret
80102758:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010275f:	00 
    shift |= E0ESC;
80102760:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102763:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102765:	89 1d 7c 16 11 80    	mov    %ebx,0x8011167c
}
8010276b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010276e:	c9                   	leave
8010276f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102770:	83 e0 7f             	and    $0x7f,%eax
80102773:	85 d2                	test   %edx,%edx
80102775:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102778:	0f b6 81 40 7b 10 80 	movzbl -0x7fef84c0(%ecx),%eax
8010277f:	83 c8 40             	or     $0x40,%eax
80102782:	0f b6 c0             	movzbl %al,%eax
80102785:	f7 d0                	not    %eax
80102787:	21 d8                	and    %ebx,%eax
80102789:	a3 7c 16 11 80       	mov    %eax,0x8011167c
    return 0;
8010278e:	31 c0                	xor    %eax,%eax
80102790:	eb d9                	jmp    8010276b <kbdgetc+0x8b>
80102792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102798:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010279b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010279e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027a1:	c9                   	leave
      c += 'a' - 'A';
801027a2:	83 f9 1a             	cmp    $0x1a,%ecx
801027a5:	0f 42 c2             	cmovb  %edx,%eax
}
801027a8:	c3                   	ret
801027a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027b5:	c3                   	ret
801027b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027bd:	00 
801027be:	66 90                	xchg   %ax,%ax

801027c0 <kbdintr>:

void
kbdintr(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027c6:	68 e0 26 10 80       	push   $0x801026e0
801027cb:	e8 d0 e0 ff ff       	call   801008a0 <consoleintr>
}
801027d0:	83 c4 10             	add    $0x10,%esp
801027d3:	c9                   	leave
801027d4:	c3                   	ret
801027d5:	66 90                	xchg   %ax,%ax
801027d7:	66 90                	xchg   %ax,%ax
801027d9:	66 90                	xchg   %ax,%ax
801027db:	66 90                	xchg   %ax,%ax
801027dd:	66 90                	xchg   %ax,%ax
801027df:	90                   	nop

801027e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027e0:	a1 80 16 11 80       	mov    0x80111680,%eax
801027e5:	85 c0                	test   %eax,%eax
801027e7:	0f 84 c3 00 00 00    	je     801028b0 <lapicinit+0xd0>
  lapic[index] = value;
801027ed:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027f4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102801:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102807:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010280e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102811:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102814:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010281b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102821:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102828:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102835:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102838:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010283b:	8b 50 30             	mov    0x30(%eax),%edx
8010283e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102844:	75 72                	jne    801028b8 <lapicinit+0xd8>
  lapic[index] = value;
80102846:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010284d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102850:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102853:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102860:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102867:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010288e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102898:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010289e:	80 e6 10             	and    $0x10,%dh
801028a1:	75 f5                	jne    80102898 <lapicinit+0xb8>
  lapic[index] = value;
801028a3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028b0:	c3                   	ret
801028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028b8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028bf:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028c2:	8b 50 20             	mov    0x20(%eax),%edx
}
801028c5:	e9 7c ff ff ff       	jmp    80102846 <lapicinit+0x66>
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028d0:	a1 80 16 11 80       	mov    0x80111680,%eax
801028d5:	85 c0                	test   %eax,%eax
801028d7:	74 07                	je     801028e0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028d9:	8b 40 20             	mov    0x20(%eax),%eax
801028dc:	c1 e8 18             	shr    $0x18,%eax
801028df:	c3                   	ret
    return 0;
801028e0:	31 c0                	xor    %eax,%eax
}
801028e2:	c3                   	ret
801028e3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028ea:	00 
801028eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801028f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801028f0:	a1 80 16 11 80       	mov    0x80111680,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 0d                	je     80102906 <lapiceoi+0x16>
  lapic[index] = value;
801028f9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102900:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102903:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102906:	c3                   	ret
80102907:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010290e:	00 
8010290f:	90                   	nop

80102910 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102910:	c3                   	ret
80102911:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102918:	00 
80102919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102920 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102920:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102921:	b8 0f 00 00 00       	mov    $0xf,%eax
80102926:	ba 70 00 00 00       	mov    $0x70,%edx
8010292b:	89 e5                	mov    %esp,%ebp
8010292d:	53                   	push   %ebx
8010292e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102931:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102934:	ee                   	out    %al,(%dx)
80102935:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293a:	ba 71 00 00 00       	mov    $0x71,%edx
8010293f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102940:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102942:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102945:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010294b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010294d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102950:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102952:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102955:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102958:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010295e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102963:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102973:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102976:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102979:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102980:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102983:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102986:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102995:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102998:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ad:	c9                   	leave
801029ae:	c3                   	ret
801029af:	90                   	nop

801029b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029b0:	55                   	push   %ebp
801029b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029b6:	ba 70 00 00 00       	mov    $0x70,%edx
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	57                   	push   %edi
801029be:	56                   	push   %esi
801029bf:	53                   	push   %ebx
801029c0:	83 ec 4c             	sub    $0x4c,%esp
801029c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c4:	ba 71 00 00 00       	mov    $0x71,%edx
801029c9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029cd:	bf 70 00 00 00       	mov    $0x70,%edi
801029d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d5:	8d 76 00             	lea    0x0(%esi),%esi
801029d8:	31 c0                	xor    %eax,%eax
801029da:	89 fa                	mov    %edi,%edx
801029dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801029e2:	89 ca                	mov    %ecx,%edx
801029e4:	ec                   	in     (%dx),%al
801029e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e8:	89 fa                	mov    %edi,%edx
801029ea:	b8 02 00 00 00       	mov    $0x2,%eax
801029ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f0:	89 ca                	mov    %ecx,%edx
801029f2:	ec                   	in     (%dx),%al
801029f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f6:	89 fa                	mov    %edi,%edx
801029f8:	b8 04 00 00 00       	mov    $0x4,%eax
801029fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fe:	89 ca                	mov    %ecx,%edx
80102a00:	ec                   	in     (%dx),%al
80102a01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a04:	89 fa                	mov    %edi,%edx
80102a06:	b8 07 00 00 00       	mov    $0x7,%eax
80102a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0c:	89 ca                	mov    %ecx,%edx
80102a0e:	ec                   	in     (%dx),%al
80102a0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a12:	89 fa                	mov    %edi,%edx
80102a14:	b8 08 00 00 00       	mov    $0x8,%eax
80102a19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1f:	89 fa                	mov    %edi,%edx
80102a21:	b8 09 00 00 00       	mov    $0x9,%eax
80102a26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a27:	89 ca                	mov    %ecx,%edx
80102a29:	ec                   	in     (%dx),%al
80102a2a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2d:	89 fa                	mov    %edi,%edx
80102a2f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a35:	89 ca                	mov    %ecx,%edx
80102a37:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a38:	84 c0                	test   %al,%al
80102a3a:	78 9c                	js     801029d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a3c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a40:	89 f2                	mov    %esi,%edx
80102a42:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 fa                	mov    %edi,%edx
80102a4a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a4d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a51:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102a54:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a57:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a62:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a65:	31 c0                	xor    %eax,%eax
80102a67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a68:	89 ca                	mov    %ecx,%edx
80102a6a:	ec                   	in     (%dx),%al
80102a6b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6e:	89 fa                	mov    %edi,%edx
80102a70:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a73:	b8 02 00 00 00       	mov    $0x2,%eax
80102a78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a79:	89 ca                	mov    %ecx,%edx
80102a7b:	ec                   	in     (%dx),%al
80102a7c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7f:	89 fa                	mov    %edi,%edx
80102a81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a84:	b8 04 00 00 00       	mov    $0x4,%eax
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 ca                	mov    %ecx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a90:	89 fa                	mov    %edi,%edx
80102a92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a95:	b8 07 00 00 00       	mov    $0x7,%eax
80102a9a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9b:	89 ca                	mov    %ecx,%edx
80102a9d:	ec                   	in     (%dx),%al
80102a9e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa1:	89 fa                	mov    %edi,%edx
80102aa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa6:	b8 08 00 00 00       	mov    $0x8,%eax
80102aab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aac:	89 ca                	mov    %ecx,%edx
80102aae:	ec                   	in     (%dx),%al
80102aaf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab2:	89 fa                	mov    %edi,%edx
80102ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab7:	b8 09 00 00 00       	mov    $0x9,%eax
80102abc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abd:	89 ca                	mov    %ecx,%edx
80102abf:	ec                   	in     (%dx),%al
80102ac0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102acc:	6a 18                	push   $0x18
80102ace:	50                   	push   %eax
80102acf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ad2:	50                   	push   %eax
80102ad3:	e8 88 1d 00 00       	call   80104860 <memcmp>
80102ad8:	83 c4 10             	add    $0x10,%esp
80102adb:	85 c0                	test   %eax,%eax
80102add:	0f 85 f5 fe ff ff    	jne    801029d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ae3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102aea:	89 f0                	mov    %esi,%eax
80102aec:	84 c0                	test   %al,%al
80102aee:	75 78                	jne    80102b68 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102af0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af3:	89 c2                	mov    %eax,%edx
80102af5:	83 e0 0f             	and    $0xf,%eax
80102af8:	c1 ea 04             	shr    $0x4,%edx
80102afb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102afe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b01:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b04:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b07:	89 c2                	mov    %eax,%edx
80102b09:	83 e0 0f             	and    $0xf,%eax
80102b0c:	c1 ea 04             	shr    $0x4,%edx
80102b0f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b12:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b18:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b1b:	89 c2                	mov    %eax,%edx
80102b1d:	83 e0 0f             	and    $0xf,%eax
80102b20:	c1 ea 04             	shr    $0x4,%edx
80102b23:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b26:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b29:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b2c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b2f:	89 c2                	mov    %eax,%edx
80102b31:	83 e0 0f             	and    $0xf,%eax
80102b34:	c1 ea 04             	shr    $0x4,%edx
80102b37:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b40:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b43:	89 c2                	mov    %eax,%edx
80102b45:	83 e0 0f             	and    $0xf,%eax
80102b48:	c1 ea 04             	shr    $0x4,%edx
80102b4b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b4e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b51:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b54:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b57:	89 c2                	mov    %eax,%edx
80102b59:	83 e0 0f             	and    $0xf,%eax
80102b5c:	c1 ea 04             	shr    $0x4,%edx
80102b5f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b62:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b65:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6b:	89 03                	mov    %eax,(%ebx)
80102b6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b70:	89 43 04             	mov    %eax,0x4(%ebx)
80102b73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b76:	89 43 08             	mov    %eax,0x8(%ebx)
80102b79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b7c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102b7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b82:	89 43 10             	mov    %eax,0x10(%ebx)
80102b85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b88:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102b8b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 e4 16 11 80    	push   0x801116e4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd ec 16 11 80 	push   -0x7feee914(,%edi,4)
80102be4:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 a7 1c 00 00       	call   801048b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d e8 16 11 80    	cmp    %edi,0x801116e8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 d4 16 11 80    	push   0x801116d4
80102c4d:	ff 35 e4 16 11 80    	push   0x801116e4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 e8 16 11 80       	mov    0x801116e8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 ec 16 11 80 	mov    -0x7feee914(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave
80102c9a:	c3                   	ret
80102c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102ca0 <initlog>:
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102caa:	68 37 75 10 80       	push   $0x80107537
80102caf:	68 a0 16 11 80       	push   $0x801116a0
80102cb4:	e8 77 18 00 00       	call   80104530 <initlock>
  readsb(dev, &sb);
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 7b e8 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cc8:	59                   	pop    %ecx
  log.dev = dev;
80102cc9:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  log.size = sb.nlog;
80102ccf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd2:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102cd7:	89 15 d8 16 11 80    	mov    %edx,0x801116d8
  struct buf *buf = bread(log.dev, log.start);
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 eb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102ce8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ceb:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102cf1:	85 db                	test   %ebx,%ebx
80102cf3:	7e 1d                	jle    80102d12 <initlog+0x72>
80102cf5:	31 d2                	xor    %edx,%edx
80102cf7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102cfe:	00 
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d04:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d3                	cmp    %edx,%ebx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave
80102d36:	c3                   	ret
80102d37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d3e:	00 
80102d3f:	90                   	nop

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d46:	68 a0 16 11 80       	push   $0x801116a0
80102d4b:	e8 d0 19 00 00       	call   80104720 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 a0 16 11 80       	push   $0x801116a0
80102d60:	68 a0 16 11 80       	push   $0x801116a0
80102d65:	e8 f6 12 00 00       	call   80104060 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d6d:	a1 e0 16 11 80       	mov    0x801116e0,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d76:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102d7b:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d92:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
80102d97:	68 a0 16 11 80       	push   $0x801116a0
80102d9c:	e8 1f 19 00 00       	call   801046c0 <release>
      break;
    }
  }
}
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave
80102da5:	c3                   	ret
80102da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dad:	00 
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102db9:	68 a0 16 11 80       	push   $0x801116a0
80102dbe:	e8 5d 19 00 00       	call   80104720 <acquire>
  log.outstanding -= 1;
80102dc3:	a1 dc 16 11 80       	mov    0x801116dc,%eax
  if(log.committing)
80102dc8:	8b 35 e0 16 11 80    	mov    0x801116e0,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd4:	89 1d dc 16 11 80    	mov    %ebx,0x801116dc
  if(log.committing)
80102dda:	85 f6                	test   %esi,%esi
80102ddc:	0f 85 22 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 f6 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dea:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
80102df1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df4:	83 ec 0c             	sub    $0xc,%esp
80102df7:	68 a0 16 11 80       	push   $0x801116a0
80102dfc:	e8 bf 18 00 00       	call   801046c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e01:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	7f 42                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e0e:	83 ec 0c             	sub    $0xc,%esp
80102e11:	68 a0 16 11 80       	push   $0x801116a0
80102e16:	e8 05 19 00 00       	call   80104720 <acquire>
    log.committing = 0;
80102e1b:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102e22:	00 00 00 
    wakeup(&log);
80102e25:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e2c:	e8 ef 12 00 00       	call   80104120 <wakeup>
    release(&log.lock);
80102e31:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102e38:	e8 83 18 00 00       	call   801046c0 <release>
80102e3d:	83 c4 10             	add    $0x10,%esp
}
80102e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e43:	5b                   	pop    %ebx
80102e44:	5e                   	pop    %esi
80102e45:	5f                   	pop    %edi
80102e46:	5d                   	pop    %ebp
80102e47:	c3                   	ret
80102e48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e4f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 d4 16 11 80       	mov    0x801116d4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 e4 16 11 80    	push   0x801116e4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d ec 16 11 80 	push   -0x7feee914(,%ebx,4)
80102e74:	ff 35 e4 16 11 80    	push   0x801116e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 17 1a 00 00       	call   801048b0 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d e8 16 11 80    	cmp    0x801116e8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 34 ff ff ff       	jmp    80102e0e <end_op+0x5e>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 a0 16 11 80       	push   $0x801116a0
80102ee8:	e8 33 12 00 00       	call   80104120 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102ef4:	e8 c7 17 00 00       	call   801046c0 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 3b 75 10 80       	push   $0x8010753b
80102f0c:	e8 6f d4 ff ff       	call   80100380 <panic>
80102f11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f18:	00 
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f27:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
{
80102f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f30:	83 fa 1d             	cmp    $0x1d,%edx
80102f33:	7f 7d                	jg     80102fb2 <log_write+0x92>
80102f35:	a1 d8 16 11 80       	mov    0x801116d8,%eax
80102f3a:	83 e8 01             	sub    $0x1,%eax
80102f3d:	39 c2                	cmp    %eax,%edx
80102f3f:	7d 71                	jge    80102fb2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f41:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	7e 75                	jle    80102fbf <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 a0 16 11 80       	push   $0x801116a0
80102f52:	e8 c9 17 00 00       	call   80104720 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f57:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f5a:	83 c4 10             	add    $0x10,%esp
80102f5d:	31 c0                	xor    %eax,%eax
80102f5f:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102f65:	85 d2                	test   %edx,%edx
80102f67:	7f 0e                	jg     80102f77 <log_write+0x57>
80102f69:	eb 15                	jmp    80102f80 <log_write+0x60>
80102f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102f87:	39 c2                	cmp    %eax,%edx
80102f89:	74 1c                	je     80102fa7 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f8b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f91:	c7 45 08 a0 16 11 80 	movl   $0x801116a0,0x8(%ebp)
}
80102f98:	c9                   	leave
  release(&log.lock);
80102f99:	e9 22 17 00 00       	jmp    801046c0 <release>
80102f9e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
80102fb0:	eb d9                	jmp    80102f8b <log_write+0x6b>
    panic("too big a transaction");
80102fb2:	83 ec 0c             	sub    $0xc,%esp
80102fb5:	68 4a 75 10 80       	push   $0x8010754a
80102fba:	e8 c1 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102fbf:	83 ec 0c             	sub    $0xc,%esp
80102fc2:	68 60 75 10 80       	push   $0x80107560
80102fc7:	e8 b4 d3 ff ff       	call   80100380 <panic>
80102fcc:	66 90                	xchg   %ax,%ax
80102fce:	66 90                	xchg   %ax,%ax

80102fd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fd7:	e8 84 09 00 00       	call   80103960 <cpuid>
80102fdc:	89 c3                	mov    %eax,%ebx
80102fde:	e8 7d 09 00 00       	call   80103960 <cpuid>
80102fe3:	83 ec 04             	sub    $0x4,%esp
80102fe6:	53                   	push   %ebx
80102fe7:	50                   	push   %eax
80102fe8:	68 7b 75 10 80       	push   $0x8010757b
80102fed:	e8 be d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102ff2:	e8 e9 2a 00 00       	call   80105ae0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ff7:	e8 04 09 00 00       	call   80103900 <mycpu>
80102ffc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ffe:	b8 01 00 00 00       	mov    $0x1,%eax
80103003:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010300a:	e8 31 0c 00 00       	call   80103c40 <scheduler>
8010300f:	90                   	nop

80103010 <mpenter>:
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103016:	e8 c5 3b 00 00       	call   80106be0 <switchkvm>
  seginit();
8010301b:	e8 30 3b 00 00       	call   80106b50 <seginit>
  lapicinit();
80103020:	e8 bb f7 ff ff       	call   801027e0 <lapicinit>
  mpmain();
80103025:	e8 a6 ff ff ff       	call   80102fd0 <mpmain>
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <main>:
{
80103030:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103034:	83 e4 f0             	and    $0xfffffff0,%esp
80103037:	ff 71 fc             	push   -0x4(%ecx)
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	53                   	push   %ebx
8010303e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	68 00 00 40 80       	push   $0x80400000
80103047:	68 d0 56 11 80       	push   $0x801156d0
8010304c:	e8 9f f5 ff ff       	call   801025f0 <kinit1>
  kvmalloc();      // kernel page table
80103051:	e8 4a 40 00 00       	call   801070a0 <kvmalloc>
  mpinit();        // detect other processors
80103056:	e8 85 01 00 00       	call   801031e0 <mpinit>
  lapicinit();     // interrupt controller
8010305b:	e8 80 f7 ff ff       	call   801027e0 <lapicinit>
  seginit();       // segment descriptors
80103060:	e8 eb 3a 00 00       	call   80106b50 <seginit>
  picinit();       // disable pic
80103065:	e8 86 03 00 00       	call   801033f0 <picinit>
  ioapicinit();    // another interrupt controller
8010306a:	e8 51 f3 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
8010306f:	e8 ec d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103074:	e8 47 2d 00 00       	call   80105dc0 <uartinit>
  pinit();         // process table
80103079:	e8 62 08 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
8010307e:	e8 dd 29 00 00       	call   80105a60 <tvinit>
  binit();         // buffer cache
80103083:	e8 b8 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103088:	e8 a3 dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
8010308d:	e8 0e f1 ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103092:	83 c4 0c             	add    $0xc,%esp
80103095:	68 8a 00 00 00       	push   $0x8a
8010309a:	68 8c a4 10 80       	push   $0x8010a48c
8010309f:	68 00 70 00 80       	push   $0x80007000
801030a4:	e8 07 18 00 00       	call   801048b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030b3:	00 00 00 
801030b6:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030bb:	3d a0 17 11 80       	cmp    $0x801117a0,%eax
801030c0:	76 7e                	jbe    80103140 <main+0x110>
801030c2:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
801030c7:	eb 20                	jmp    801030e9 <main+0xb9>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d0:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
801030d7:	00 00 00 
801030da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030e0:	05 a0 17 11 80       	add    $0x801117a0,%eax
801030e5:	39 c3                	cmp    %eax,%ebx
801030e7:	73 57                	jae    80103140 <main+0x110>
    if(c == mycpu())  // We've started already.
801030e9:	e8 12 08 00 00       	call   80103900 <mycpu>
801030ee:	39 c3                	cmp    %eax,%ebx
801030f0:	74 de                	je     801030d0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030f2:	e8 69 f5 ff ff       	call   80102660 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030f7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801030fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103010,0x80006ff8
80103101:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103104:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010310b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010310e:	05 00 10 00 00       	add    $0x1000,%eax
80103113:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103118:	0f b6 03             	movzbl (%ebx),%eax
8010311b:	68 00 70 00 00       	push   $0x7000
80103120:	50                   	push   %eax
80103121:	e8 fa f7 ff ff       	call   80102920 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x100>
8010313a:	eb 94                	jmp    801030d0 <main+0xa0>
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103140:	83 ec 08             	sub    $0x8,%esp
80103143:	68 00 00 00 8e       	push   $0x8e000000
80103148:	68 00 00 40 80       	push   $0x80400000
8010314d:	e8 3e f4 ff ff       	call   80102590 <kinit2>
  userinit();      // first user process
80103152:	e8 59 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103157:	e8 74 fe ff ff       	call   80102fd0 <mpmain>
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010317f:	00 
80103180:	89 fe                	mov    %edi,%esi
80103182:	39 df                	cmp    %ebx,%edi
80103184:	73 42                	jae    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 8f 75 10 80       	push   $0x8010758f
80103193:	56                   	push   %esi
80103194:	e8 c7 16 00 00       	call   80104860 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f2                	mov    %esi,%edx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031b0:	39 fa                	cmp    %edi,%edx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	5b                   	pop    %ebx
801031ce:	89 f0                	mov    %esi,%eax
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret
801031d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031db:	00 
801031dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	75 1b                	jne    8010321c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103201:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103208:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010320f:	c1 e0 08             	shl    $0x8,%eax
80103212:	09 d0                	or     %edx,%eax
80103214:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103217:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321c:	ba 00 04 00 00       	mov    $0x400,%edx
80103221:	e8 3a ff ff ff       	call   80103160 <mpsearch1>
80103226:	89 c3                	mov    %eax,%ebx
80103228:	85 c0                	test   %eax,%eax
8010322a:	0f 84 58 01 00 00    	je     80103388 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103230:	8b 73 04             	mov    0x4(%ebx),%esi
80103233:	85 f6                	test   %esi,%esi
80103235:	0f 84 3d 01 00 00    	je     80103378 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010323b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010323e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103244:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103247:	6a 04                	push   $0x4
80103249:	68 94 75 10 80       	push   $0x80107594
8010324e:	50                   	push   %eax
8010324f:	e8 0c 16 00 00       	call   80104860 <memcmp>
80103254:	83 c4 10             	add    $0x10,%esp
80103257:	85 c0                	test   %eax,%eax
80103259:	0f 85 19 01 00 00    	jne    80103378 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010325f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103266:	3c 01                	cmp    $0x1,%al
80103268:	74 08                	je     80103272 <mpinit+0x92>
8010326a:	3c 04                	cmp    $0x4,%al
8010326c:	0f 85 06 01 00 00    	jne    80103378 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103272:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103279:	66 85 d2             	test   %dx,%dx
8010327c:	74 22                	je     801032a0 <mpinit+0xc0>
8010327e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103281:	89 f0                	mov    %esi,%eax
  sum = 0;
80103283:	31 d2                	xor    %edx,%edx
80103285:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103288:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010328f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103292:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103294:	39 f8                	cmp    %edi,%eax
80103296:	75 f0                	jne    80103288 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103298:	84 d2                	test   %dl,%dl
8010329a:	0f 85 d8 00 00 00    	jne    80103378 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032a0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801032a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
801032ac:	a3 80 16 11 80       	mov    %eax,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032b1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032b8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801032be:	01 d7                	add    %edx,%edi
801032c0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801032c2:	bf 01 00 00 00       	mov    $0x1,%edi
801032c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032ce:	00 
801032cf:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d0:	39 d0                	cmp    %edx,%eax
801032d2:	73 19                	jae    801032ed <mpinit+0x10d>
    switch(*p){
801032d4:	0f b6 08             	movzbl (%eax),%ecx
801032d7:	80 f9 02             	cmp    $0x2,%cl
801032da:	0f 84 80 00 00 00    	je     80103360 <mpinit+0x180>
801032e0:	77 6e                	ja     80103350 <mpinit+0x170>
801032e2:	84 c9                	test   %cl,%cl
801032e4:	74 3a                	je     80103320 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032e6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e9:	39 d0                	cmp    %edx,%eax
801032eb:	72 e7                	jb     801032d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032ed:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801032f0:	85 ff                	test   %edi,%edi
801032f2:	0f 84 dd 00 00 00    	je     801033d5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032f8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801032fc:	74 15                	je     80103313 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032fe:	b8 70 00 00 00       	mov    $0x70,%eax
80103303:	ba 22 00 00 00       	mov    $0x22,%edx
80103308:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103309:	ba 23 00 00 00       	mov    $0x23,%edx
8010330e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010330f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103312:	ee                   	out    %al,(%dx)
  }
}
80103313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103316:	5b                   	pop    %ebx
80103317:	5e                   	pop    %esi
80103318:	5f                   	pop    %edi
80103319:	5d                   	pop    %ebp
8010331a:	c3                   	ret
8010331b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103320:	8b 0d 84 17 11 80    	mov    0x80111784,%ecx
80103326:	83 f9 07             	cmp    $0x7,%ecx
80103329:	7f 19                	jg     80103344 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010332b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103331:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103335:	83 c1 01             	add    $0x1,%ecx
80103338:	89 0d 84 17 11 80    	mov    %ecx,0x80111784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010333e:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
      p += sizeof(struct mpproc);
80103344:	83 c0 14             	add    $0x14,%eax
      continue;
80103347:	eb 87                	jmp    801032d0 <mpinit+0xf0>
80103349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 8e                	jbe    801032e6 <mpinit+0x106>
80103358:	31 ff                	xor    %edi,%edi
8010335a:	e9 71 ff ff ff       	jmp    801032d0 <mpinit+0xf0>
8010335f:	90                   	nop
      ioapicid = ioapic->apicno;
80103360:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103364:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103367:	88 0d 80 17 11 80    	mov    %cl,0x80111780
      continue;
8010336d:	e9 5e ff ff ff       	jmp    801032d0 <mpinit+0xf0>
80103372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103378:	83 ec 0c             	sub    $0xc,%esp
8010337b:	68 99 75 10 80       	push   $0x80107599
80103380:	e8 fb cf ff ff       	call   80100380 <panic>
80103385:	8d 76 00             	lea    0x0(%esi),%esi
{
80103388:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010338d:	eb 0b                	jmp    8010339a <mpinit+0x1ba>
8010338f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103390:	89 f3                	mov    %esi,%ebx
80103392:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103398:	74 de                	je     80103378 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010339a:	83 ec 04             	sub    $0x4,%esp
8010339d:	8d 73 10             	lea    0x10(%ebx),%esi
801033a0:	6a 04                	push   $0x4
801033a2:	68 8f 75 10 80       	push   $0x8010758f
801033a7:	53                   	push   %ebx
801033a8:	e8 b3 14 00 00       	call   80104860 <memcmp>
801033ad:	83 c4 10             	add    $0x10,%esp
801033b0:	85 c0                	test   %eax,%eax
801033b2:	75 dc                	jne    80103390 <mpinit+0x1b0>
801033b4:	89 da                	mov    %ebx,%edx
801033b6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033bd:	00 
801033be:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801033c0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033c3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033c6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033c8:	39 d6                	cmp    %edx,%esi
801033ca:	75 f4                	jne    801033c0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033cc:	84 c0                	test   %al,%al
801033ce:	75 c0                	jne    80103390 <mpinit+0x1b0>
801033d0:	e9 5b fe ff ff       	jmp    80103230 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033d5:	83 ec 0c             	sub    $0xc,%esp
801033d8:	68 fc 78 10 80       	push   $0x801078fc
801033dd:	e8 9e cf ff ff       	call   80100380 <panic>
801033e2:	66 90                	xchg   %ax,%ax
801033e4:	66 90                	xchg   %ax,%ax
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <picinit>:
801033f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033f5:	ba 21 00 00 00       	mov    $0x21,%edx
801033fa:	ee                   	out    %al,(%dx)
801033fb:	ba a1 00 00 00       	mov    $0xa1,%edx
80103400:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103401:	c3                   	ret
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 0c             	sub    $0xc,%esp
80103419:	8b 75 08             	mov    0x8(%ebp),%esi
8010341c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010341f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103425:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010342b:	e8 20 da ff ff       	call   80100e50 <filealloc>
80103430:	89 06                	mov    %eax,(%esi)
80103432:	85 c0                	test   %eax,%eax
80103434:	0f 84 a5 00 00 00    	je     801034df <pipealloc+0xcf>
8010343a:	e8 11 da ff ff       	call   80100e50 <filealloc>
8010343f:	89 07                	mov    %eax,(%edi)
80103441:	85 c0                	test   %eax,%eax
80103443:	0f 84 84 00 00 00    	je     801034cd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103449:	e8 12 f2 ff ff       	call   80102660 <kalloc>
8010344e:	89 c3                	mov    %eax,%ebx
80103450:	85 c0                	test   %eax,%eax
80103452:	0f 84 a0 00 00 00    	je     801034f8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103458:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010345f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103462:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103465:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010346c:	00 00 00 
  p->nwrite = 0;
8010346f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103476:	00 00 00 
  p->nread = 0;
80103479:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103480:	00 00 00 
  initlock(&p->lock, "pipe");
80103483:	68 b1 75 10 80       	push   $0x801075b1
80103488:	50                   	push   %eax
80103489:	e8 a2 10 00 00       	call   80104530 <initlock>
  (*f0)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103490:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103493:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103499:	8b 06                	mov    (%esi),%eax
8010349b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010349f:	8b 06                	mov    (%esi),%eax
801034a1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034a5:	8b 06                	mov    (%esi),%eax
801034a7:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034aa:	8b 07                	mov    (%edi),%eax
801034ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034b2:	8b 07                	mov    (%edi),%eax
801034b4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034b8:	8b 07                	mov    (%edi),%eax
801034ba:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034be:	8b 07                	mov    (%edi),%eax
801034c0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801034c3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c8:	5b                   	pop    %ebx
801034c9:	5e                   	pop    %esi
801034ca:	5f                   	pop    %edi
801034cb:	5d                   	pop    %ebp
801034cc:	c3                   	ret
  if(*f0)
801034cd:	8b 06                	mov    (%esi),%eax
801034cf:	85 c0                	test   %eax,%eax
801034d1:	74 1e                	je     801034f1 <pipealloc+0xe1>
    fileclose(*f0);
801034d3:	83 ec 0c             	sub    $0xc,%esp
801034d6:	50                   	push   %eax
801034d7:	e8 34 da ff ff       	call   80100f10 <fileclose>
801034dc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034df:	8b 07                	mov    (%edi),%eax
801034e1:	85 c0                	test   %eax,%eax
801034e3:	74 0c                	je     801034f1 <pipealloc+0xe1>
    fileclose(*f1);
801034e5:	83 ec 0c             	sub    $0xc,%esp
801034e8:	50                   	push   %eax
801034e9:	e8 22 da ff ff       	call   80100f10 <fileclose>
801034ee:	83 c4 10             	add    $0x10,%esp
  return -1;
801034f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034f6:	eb cd                	jmp    801034c5 <pipealloc+0xb5>
  if(*f0)
801034f8:	8b 06                	mov    (%esi),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	75 d5                	jne    801034d3 <pipealloc+0xc3>
801034fe:	eb df                	jmp    801034df <pipealloc+0xcf>

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	56                   	push   %esi
80103504:	53                   	push   %ebx
80103505:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103508:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350b:	83 ec 0c             	sub    $0xc,%esp
8010350e:	53                   	push   %ebx
8010350f:	e8 0c 12 00 00       	call   80104720 <acquire>
  if(writable){
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	85 f6                	test   %esi,%esi
80103519:	74 65                	je     80103580 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351b:	83 ec 0c             	sub    $0xc,%esp
8010351e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103524:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352b:	00 00 00 
    wakeup(&p->nread);
8010352e:	50                   	push   %eax
8010352f:	e8 ec 0b 00 00       	call   80104120 <wakeup>
80103534:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103537:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010353d:	85 d2                	test   %edx,%edx
8010353f:	75 0a                	jne    8010354b <pipeclose+0x4b>
80103541:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103547:	85 c0                	test   %eax,%eax
80103549:	74 15                	je     80103560 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010354e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103551:	5b                   	pop    %ebx
80103552:	5e                   	pop    %esi
80103553:	5d                   	pop    %ebp
    release(&p->lock);
80103554:	e9 67 11 00 00       	jmp    801046c0 <release>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	53                   	push   %ebx
80103564:	e8 57 11 00 00       	call   801046c0 <release>
    kfree((char*)p);
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010356f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103572:	5b                   	pop    %ebx
80103573:	5e                   	pop    %esi
80103574:	5d                   	pop    %ebp
    kfree((char*)p);
80103575:	e9 26 ef ff ff       	jmp    801024a0 <kfree>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 87 0b 00 00       	call   80104120 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb 99                	jmp    80103537 <pipeclose+0x37>
8010359e:	66 90                	xchg   %ax,%ax

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 28             	sub    $0x28,%esp
801035a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ac:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
801035af:	53                   	push   %ebx
801035b0:	e8 6b 11 00 00       	call   80104720 <acquire>
  for(i = 0; i < n; i++){
801035b5:	83 c4 10             	add    $0x10,%esp
801035b8:	85 ff                	test   %edi,%edi
801035ba:	0f 8e ce 00 00 00    	jle    8010368e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801035c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035c9:	89 7d 10             	mov    %edi,0x10(%ebp)
801035cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035cf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801035d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035d5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035db:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801035ed:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801035f0:	0f 85 b6 00 00 00    	jne    801036ac <pipewrite+0x10c>
801035f6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035f9:	eb 3b                	jmp    80103636 <pipewrite+0x96>
801035fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103600:	e8 7b 03 00 00       	call   80103980 <myproc>
80103605:	8b 48 24             	mov    0x24(%eax),%ecx
80103608:	85 c9                	test   %ecx,%ecx
8010360a:	75 34                	jne    80103640 <pipewrite+0xa0>
      wakeup(&p->nread);
8010360c:	83 ec 0c             	sub    $0xc,%esp
8010360f:	56                   	push   %esi
80103610:	e8 0b 0b 00 00       	call   80104120 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103615:	58                   	pop    %eax
80103616:	5a                   	pop    %edx
80103617:	53                   	push   %ebx
80103618:	57                   	push   %edi
80103619:	e8 42 0a 00 00       	call   80104060 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010361e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103624:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010362a:	83 c4 10             	add    $0x10,%esp
8010362d:	05 00 02 00 00       	add    $0x200,%eax
80103632:	39 c2                	cmp    %eax,%edx
80103634:	75 2a                	jne    80103660 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103636:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010363c:	85 c0                	test   %eax,%eax
8010363e:	75 c0                	jne    80103600 <pipewrite+0x60>
        release(&p->lock);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	53                   	push   %ebx
80103644:	e8 77 10 00 00       	call   801046c0 <release>
        return -1;
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103654:	5b                   	pop    %ebx
80103655:	5e                   	pop    %esi
80103656:	5f                   	pop    %edi
80103657:	5d                   	pop    %ebp
80103658:	c3                   	ret
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103660:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103663:	8d 42 01             	lea    0x1(%edx),%eax
80103666:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010366c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010366f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103675:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103678:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010367c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103680:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103683:	39 c1                	cmp    %eax,%ecx
80103685:	0f 85 50 ff ff ff    	jne    801035db <pipewrite+0x3b>
8010368b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010368e:	83 ec 0c             	sub    $0xc,%esp
80103691:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103697:	50                   	push   %eax
80103698:	e8 83 0a 00 00       	call   80104120 <wakeup>
  release(&p->lock);
8010369d:	89 1c 24             	mov    %ebx,(%esp)
801036a0:	e8 1b 10 00 00       	call   801046c0 <release>
  return n;
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	89 f8                	mov    %edi,%eax
801036aa:	eb a5                	jmp    80103651 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801036af:	eb b2                	jmp    80103663 <pipewrite+0xc3>
801036b1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801036b8:	00 
801036b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	57                   	push   %edi
801036c4:	56                   	push   %esi
801036c5:	53                   	push   %ebx
801036c6:	83 ec 18             	sub    $0x18,%esp
801036c9:	8b 75 08             	mov    0x8(%ebp),%esi
801036cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036cf:	56                   	push   %esi
801036d0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036d6:	e8 45 10 00 00       	call   80104720 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036db:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036e1:	83 c4 10             	add    $0x10,%esp
801036e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801036ea:	74 2f                	je     8010371b <piperead+0x5b>
801036ec:	eb 37                	jmp    80103725 <piperead+0x65>
801036ee:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801036f0:	e8 8b 02 00 00       	call   80103980 <myproc>
801036f5:	8b 40 24             	mov    0x24(%eax),%eax
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 85 80 00 00 00    	jne    80103780 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103700:	83 ec 08             	sub    $0x8,%esp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx
80103705:	e8 56 09 00 00       	call   80104060 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103710:	83 c4 10             	add    $0x10,%esp
80103713:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103719:	75 0a                	jne    80103725 <piperead+0x65>
8010371b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103721:	85 d2                	test   %edx,%edx
80103723:	75 cb                	jne    801036f0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103725:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103728:	31 db                	xor    %ebx,%ebx
8010372a:	85 c9                	test   %ecx,%ecx
8010372c:	7f 26                	jg     80103754 <piperead+0x94>
8010372e:	eb 2c                	jmp    8010375c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0x9c>
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 b5 09 00 00       	call   80104120 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 4d 0f 00 00       	call   801046c0 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 32 0f 00 00       	call   801046c0 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 1d 11 80       	push   $0x80111d20
801037b1:	e8 6a 0f 00 00       	call   80104720 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 17                	jmp    801037d2 <allocproc+0x32>
801037bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801037c6:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
801037cc:	0f 84 8e 00 00 00    	je     80103860 <allocproc+0xc0>
    if(p->state == UNUSED)
801037d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037d5:	85 c0                	test   %eax,%eax
801037d7:	75 e7                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d9:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->nrswitch = 0;
  p->nfd = 0;

  release(&ptable.lock);
801037de:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->nrswitch = 0;
801037e8:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
801037ef:	89 43 10             	mov    %eax,0x10(%ebx)
801037f2:	8d 50 01             	lea    0x1(%eax),%edx
  p->nfd = 0;
801037f5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801037fc:	00 00 00 
  release(&ptable.lock);
801037ff:	68 20 1d 11 80       	push   $0x80111d20
  p->pid = nextpid++;
80103804:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010380a:	e8 b1 0e 00 00       	call   801046c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010380f:	e8 4c ee ff ff       	call   80102660 <kalloc>
80103814:	83 c4 10             	add    $0x10,%esp
80103817:	89 43 08             	mov    %eax,0x8(%ebx)
8010381a:	85 c0                	test   %eax,%eax
8010381c:	74 5b                	je     80103879 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010381e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103824:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103827:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010382c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010382f:	c7 40 14 4f 5a 10 80 	movl   $0x80105a4f,0x14(%eax)
  p->context = (struct context*)sp;
80103836:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103839:	6a 14                	push   $0x14
8010383b:	6a 00                	push   $0x0
8010383d:	50                   	push   %eax
8010383e:	e8 dd 0f 00 00       	call   80104820 <memset>
  p->context->eip = (uint)forkret;
80103843:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103846:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103849:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)
}
80103850:	89 d8                	mov    %ebx,%eax
80103852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103855:	c9                   	leave
80103856:	c3                   	ret
80103857:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010385e:	00 
8010385f:	90                   	nop
  release(&ptable.lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103863:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103865:	68 20 1d 11 80       	push   $0x80111d20
8010386a:	e8 51 0e 00 00       	call   801046c0 <release>
  return 0;
8010386f:	83 c4 10             	add    $0x10,%esp
}
80103872:	89 d8                	mov    %ebx,%eax
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave
80103878:	c3                   	ret
    p->state = UNUSED;
80103879:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103880:	31 db                	xor    %ebx,%ebx
80103882:	eb ee                	jmp    80103872 <allocproc+0xd2>
80103884:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010388b:	00 
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103896:	68 20 1d 11 80       	push   $0x80111d20
8010389b:	e8 20 0e 00 00       	call   801046c0 <release>

  if (first) {
801038a0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	85 c0                	test   %eax,%eax
801038aa:	75 04                	jne    801038b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038ac:	c9                   	leave
801038ad:	c3                   	ret
801038ae:	66 90                	xchg   %ax,%ax
    first = 0;
801038b0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038b7:	00 00 00 
    iinit(ROOTDEV);
801038ba:	83 ec 0c             	sub    $0xc,%esp
801038bd:	6a 01                	push   $0x1
801038bf:	e8 bc dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801038c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038cb:	e8 d0 f3 ff ff       	call   80102ca0 <initlog>
}
801038d0:	83 c4 10             	add    $0x10,%esp
801038d3:	c9                   	leave
801038d4:	c3                   	ret
801038d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038dc:	00 
801038dd:	8d 76 00             	lea    0x0(%esi),%esi

801038e0 <pinit>:
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038e6:	68 b6 75 10 80       	push   $0x801075b6
801038eb:	68 20 1d 11 80       	push   $0x80111d20
801038f0:	e8 3b 0c 00 00       	call   80104530 <initlock>
}
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	c9                   	leave
801038f9:	c3                   	ret
801038fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103900 <mycpu>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103905:	9c                   	pushf
80103906:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103907:	f6 c4 02             	test   $0x2,%ah
8010390a:	75 46                	jne    80103952 <mycpu+0x52>
  apicid = lapicid();
8010390c:	e8 bf ef ff ff       	call   801028d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103911:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80103917:	85 f6                	test   %esi,%esi
80103919:	7e 2a                	jle    80103945 <mycpu+0x45>
8010391b:	31 d2                	xor    %edx,%edx
8010391d:	eb 08                	jmp    80103927 <mycpu+0x27>
8010391f:	90                   	nop
80103920:	83 c2 01             	add    $0x1,%edx
80103923:	39 f2                	cmp    %esi,%edx
80103925:	74 1e                	je     80103945 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103927:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010392d:	0f b6 99 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ebx
80103934:	39 c3                	cmp    %eax,%ebx
80103936:	75 e8                	jne    80103920 <mycpu+0x20>
}
80103938:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010393b:	8d 81 a0 17 11 80    	lea    -0x7feee860(%ecx),%eax
}
80103941:	5b                   	pop    %ebx
80103942:	5e                   	pop    %esi
80103943:	5d                   	pop    %ebp
80103944:	c3                   	ret
  panic("unknown apicid\n");
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	68 bd 75 10 80       	push   $0x801075bd
8010394d:	e8 2e ca ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103952:	83 ec 0c             	sub    $0xc,%esp
80103955:	68 1c 79 10 80       	push   $0x8010791c
8010395a:	e8 21 ca ff ff       	call   80100380 <panic>
8010395f:	90                   	nop

80103960 <cpuid>:
cpuid() {
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103966:	e8 95 ff ff ff       	call   80103900 <mycpu>
}
8010396b:	c9                   	leave
  return mycpu()-cpus;
8010396c:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103971:	c1 f8 04             	sar    $0x4,%eax
80103974:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397a:	c3                   	ret
8010397b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103980 <myproc>:
myproc(void) {
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	53                   	push   %ebx
80103984:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103987:	e8 44 0c 00 00       	call   801045d0 <pushcli>
  c = mycpu();
8010398c:	e8 6f ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103991:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103997:	e8 84 0c 00 00       	call   80104620 <popcli>
}
8010399c:	89 d8                	mov    %ebx,%eax
8010399e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039a1:	c9                   	leave
801039a2:	c3                   	ret
801039a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039aa:	00 
801039ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039b7:	e8 e4 fd ff ff       	call   801037a0 <allocproc>
801039bc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039be:	a3 54 3e 11 80       	mov    %eax,0x80113e54
  if((p->pgdir = setupkvm()) == 0)
801039c3:	e8 58 36 00 00       	call   80107020 <setupkvm>
801039c8:	89 43 04             	mov    %eax,0x4(%ebx)
801039cb:	85 c0                	test   %eax,%eax
801039cd:	0f 84 bd 00 00 00    	je     80103a90 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d3:	83 ec 04             	sub    $0x4,%esp
801039d6:	68 2c 00 00 00       	push   $0x2c
801039db:	68 60 a4 10 80       	push   $0x8010a460
801039e0:	50                   	push   %eax
801039e1:	e8 1a 33 00 00       	call   80106d00 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039e6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039e9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ef:	6a 4c                	push   $0x4c
801039f1:	6a 00                	push   $0x0
801039f3:	ff 73 18             	push   0x18(%ebx)
801039f6:	e8 25 0e 00 00       	call   80104820 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039fb:	8b 43 18             	mov    0x18(%ebx),%eax
801039fe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a03:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a06:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a16:	8b 43 18             	mov    0x18(%ebx),%eax
80103a19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a21:	8b 43 18             	mov    0x18(%ebx),%eax
80103a24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a36:	8b 43 18             	mov    0x18(%ebx),%eax
80103a39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	68 e6 75 10 80       	push   $0x801075e6
80103a54:	50                   	push   %eax
80103a55:	e8 76 0f 00 00       	call   801049d0 <safestrcpy>
  p->cwd = namei("/");
80103a5a:	c7 04 24 ef 75 10 80 	movl   $0x801075ef,(%esp)
80103a61:	e8 1a e6 ff ff       	call   80102080 <namei>
80103a66:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a69:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a70:	e8 ab 0c 00 00       	call   80104720 <acquire>
  p->state = RUNNABLE;
80103a75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a7c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103a83:	e8 38 0c 00 00       	call   801046c0 <release>
}
80103a88:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8b:	83 c4 10             	add    $0x10,%esp
80103a8e:	c9                   	leave
80103a8f:	c3                   	ret
    panic("userinit: out of memory?");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 cd 75 10 80       	push   $0x801075cd
80103a98:	e8 e3 c8 ff ff       	call   80100380 <panic>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi

80103aa0 <growproc>:
{
80103aa0:	55                   	push   %ebp
80103aa1:	89 e5                	mov    %esp,%ebp
80103aa3:	56                   	push   %esi
80103aa4:	53                   	push   %ebx
80103aa5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aa8:	e8 23 0b 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103aad:	e8 4e fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ab2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ab8:	e8 63 0b 00 00       	call   80104620 <popcli>
  sz = curproc->sz;
80103abd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103abf:	85 f6                	test   %esi,%esi
80103ac1:	7f 1d                	jg     80103ae0 <growproc+0x40>
  } else if(n < 0){
80103ac3:	75 3b                	jne    80103b00 <growproc+0x60>
  switchuvm(curproc);
80103ac5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ac8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103aca:	53                   	push   %ebx
80103acb:	e8 20 31 00 00       	call   80106bf0 <switchuvm>
  return 0;
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	31 c0                	xor    %eax,%eax
}
80103ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad8:	5b                   	pop    %ebx
80103ad9:	5e                   	pop    %esi
80103ada:	5d                   	pop    %ebp
80103adb:	c3                   	ret
80103adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ae0:	83 ec 04             	sub    $0x4,%esp
80103ae3:	01 c6                	add    %eax,%esi
80103ae5:	56                   	push   %esi
80103ae6:	50                   	push   %eax
80103ae7:	ff 73 04             	push   0x4(%ebx)
80103aea:	e8 61 33 00 00       	call   80106e50 <allocuvm>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	85 c0                	test   %eax,%eax
80103af4:	75 cf                	jne    80103ac5 <growproc+0x25>
      return -1;
80103af6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103afb:	eb d8                	jmp    80103ad5 <growproc+0x35>
80103afd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b00:	83 ec 04             	sub    $0x4,%esp
80103b03:	01 c6                	add    %eax,%esi
80103b05:	56                   	push   %esi
80103b06:	50                   	push   %eax
80103b07:	ff 73 04             	push   0x4(%ebx)
80103b0a:	e8 61 34 00 00       	call   80106f70 <deallocuvm>
80103b0f:	83 c4 10             	add    $0x10,%esp
80103b12:	85 c0                	test   %eax,%eax
80103b14:	75 af                	jne    80103ac5 <growproc+0x25>
80103b16:	eb de                	jmp    80103af6 <growproc+0x56>
80103b18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103b1f:	00 

80103b20 <fork>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	57                   	push   %edi
80103b24:	56                   	push   %esi
80103b25:	53                   	push   %ebx
80103b26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b29:	e8 a2 0a 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103b2e:	e8 cd fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b39:	e8 e2 0a 00 00       	call   80104620 <popcli>
  if((np = allocproc()) == 0){
80103b3e:	e8 5d fc ff ff       	call   801037a0 <allocproc>
80103b43:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b46:	85 c0                	test   %eax,%eax
80103b48:	0f 84 e2 00 00 00    	je     80103c30 <fork+0x110>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b4e:	83 ec 08             	sub    $0x8,%esp
80103b51:	ff 33                	push   (%ebx)
80103b53:	89 c7                	mov    %eax,%edi
80103b55:	ff 73 04             	push   0x4(%ebx)
80103b58:	e8 b3 35 00 00       	call   80107110 <copyuvm>
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	89 47 04             	mov    %eax,0x4(%edi)
80103b63:	85 c0                	test   %eax,%eax
80103b65:	0f 84 a6 00 00 00    	je     80103c11 <fork+0xf1>
  np->sz = curproc->sz;
80103b6b:	8b 03                	mov    (%ebx),%eax
80103b6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b70:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b72:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b75:	89 c8                	mov    %ecx,%eax
80103b77:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b7a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b7f:	8b 73 18             	mov    0x18(%ebx),%esi
80103b82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b86:	8b 40 18             	mov    0x18(%eax),%eax
80103b89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i]){
80103b90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b94:	85 c0                	test   %eax,%eax
80103b96:	74 13                	je     80103bab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b98:	83 ec 0c             	sub    $0xc,%esp
80103b9b:	50                   	push   %eax
80103b9c:	e8 1f d3 ff ff       	call   80100ec0 <filedup>
80103ba1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ba4:	83 c4 10             	add    $0x10,%esp
80103ba7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bab:	83 c6 01             	add    $0x1,%esi
80103bae:	83 fe 10             	cmp    $0x10,%esi
80103bb1:	75 dd                	jne    80103b90 <fork+0x70>
  np->nfd = curproc->nfd; // taking for new process the number of file descriptors from the parent process
80103bb3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103bb6:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  np->cwd = idup(curproc->cwd);
80103bbc:	83 ec 0c             	sub    $0xc,%esp
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bbf:	83 c3 6c             	add    $0x6c,%ebx
  np->nfd = curproc->nfd; // taking for new process the number of file descriptors from the parent process
80103bc2:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  np->cwd = idup(curproc->cwd);
80103bc8:	ff 73 fc             	push   -0x4(%ebx)
80103bcb:	e8 a0 db ff ff       	call   80101770 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd0:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bd3:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd6:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bd9:	6a 10                	push   $0x10
80103bdb:	53                   	push   %ebx
80103bdc:	50                   	push   %eax
80103bdd:	e8 ee 0d 00 00       	call   801049d0 <safestrcpy>
  pid = np->pid;
80103be2:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103be5:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bec:	e8 2f 0b 00 00       	call   80104720 <acquire>
  np->state = RUNNABLE;
80103bf1:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103bf8:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103bff:	e8 bc 0a 00 00       	call   801046c0 <release>
  return pid;
80103c04:	83 c4 10             	add    $0x10,%esp
}
80103c07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c0a:	89 d8                	mov    %ebx,%eax
80103c0c:	5b                   	pop    %ebx
80103c0d:	5e                   	pop    %esi
80103c0e:	5f                   	pop    %edi
80103c0f:	5d                   	pop    %ebp
80103c10:	c3                   	ret
    kfree(np->kstack);
80103c11:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c14:	83 ec 0c             	sub    $0xc,%esp
80103c17:	ff 73 08             	push   0x8(%ebx)
80103c1a:	e8 81 e8 ff ff       	call   801024a0 <kfree>
    np->kstack = 0;
80103c1f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c26:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c35:	eb d0                	jmp    80103c07 <fork+0xe7>
80103c37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c3e:	00 
80103c3f:	90                   	nop

80103c40 <scheduler>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c49:	e8 b2 fc ff ff       	call   80103900 <mycpu>
  c->proc = 0;
80103c4e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c55:	00 00 00 
  struct cpu *c = mycpu();
80103c58:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c5a:	8d 78 04             	lea    0x4(%eax),%edi
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103c60:	fb                   	sti
    acquire(&ptable.lock);
80103c61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c64:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
    acquire(&ptable.lock);
80103c69:	68 20 1d 11 80       	push   $0x80111d20
80103c6e:	e8 ad 0a 00 00       	call   80104720 <acquire>
80103c73:	83 c4 10             	add    $0x10,%esp
80103c76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c7d:	00 
80103c7e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c84:	75 33                	jne    80103cb9 <scheduler+0x79>
      switchuvm(p);
80103c86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c8f:	53                   	push   %ebx
80103c90:	e8 5b 2f 00 00       	call   80106bf0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c95:	58                   	pop    %eax
80103c96:	5a                   	pop    %edx
80103c97:	ff 73 1c             	push   0x1c(%ebx)
80103c9a:	57                   	push   %edi
      p->state = RUNNING;
80103c9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ca2:	e8 84 0d 00 00       	call   80104a2b <swtch>
      switchkvm();
80103ca7:	e8 34 2f 00 00       	call   80106be0 <switchkvm>
      c->proc = 0;
80103cac:	83 c4 10             	add    $0x10,%esp
80103caf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cb6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb9:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103cbf:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80103cc5:	75 b9                	jne    80103c80 <scheduler+0x40>
    release(&ptable.lock);
80103cc7:	83 ec 0c             	sub    $0xc,%esp
80103cca:	68 20 1d 11 80       	push   $0x80111d20
80103ccf:	e8 ec 09 00 00       	call   801046c0 <release>
    sti();
80103cd4:	83 c4 10             	add    $0x10,%esp
80103cd7:	eb 87                	jmp    80103c60 <scheduler+0x20>
80103cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ce0 <sched>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
  pushcli();
80103ce5:	e8 e6 08 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103cea:	e8 11 fc ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103cef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cf5:	e8 26 09 00 00       	call   80104620 <popcli>
  if(!holding(&ptable.lock))
80103cfa:	83 ec 0c             	sub    $0xc,%esp
  p->nrswitch++; // added for counting number of context switches
80103cfd:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
  if(!holding(&ptable.lock))
80103d01:	68 20 1d 11 80       	push   $0x80111d20
80103d06:	e8 75 09 00 00       	call   80104680 <holding>
80103d0b:	83 c4 10             	add    $0x10,%esp
80103d0e:	85 c0                	test   %eax,%eax
80103d10:	74 4f                	je     80103d61 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d12:	e8 e9 fb ff ff       	call   80103900 <mycpu>
80103d17:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d1e:	75 68                	jne    80103d88 <sched+0xa8>
  if(p->state == RUNNING)
80103d20:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d24:	74 55                	je     80103d7b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d26:	9c                   	pushf
80103d27:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d28:	f6 c4 02             	test   $0x2,%ah
80103d2b:	75 41                	jne    80103d6e <sched+0x8e>
  intena = mycpu()->intena;
80103d2d:	e8 ce fb ff ff       	call   80103900 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d32:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d35:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d3b:	e8 c0 fb ff ff       	call   80103900 <mycpu>
80103d40:	83 ec 08             	sub    $0x8,%esp
80103d43:	ff 70 04             	push   0x4(%eax)
80103d46:	53                   	push   %ebx
80103d47:	e8 df 0c 00 00       	call   80104a2b <swtch>
  mycpu()->intena = intena;
80103d4c:	e8 af fb ff ff       	call   80103900 <mycpu>
}
80103d51:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d54:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d5d:	5b                   	pop    %ebx
80103d5e:	5e                   	pop    %esi
80103d5f:	5d                   	pop    %ebp
80103d60:	c3                   	ret
    panic("sched ptable.lock");
80103d61:	83 ec 0c             	sub    $0xc,%esp
80103d64:	68 f1 75 10 80       	push   $0x801075f1
80103d69:	e8 12 c6 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103d6e:	83 ec 0c             	sub    $0xc,%esp
80103d71:	68 1d 76 10 80       	push   $0x8010761d
80103d76:	e8 05 c6 ff ff       	call   80100380 <panic>
    panic("sched running");
80103d7b:	83 ec 0c             	sub    $0xc,%esp
80103d7e:	68 0f 76 10 80       	push   $0x8010760f
80103d83:	e8 f8 c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103d88:	83 ec 0c             	sub    $0xc,%esp
80103d8b:	68 03 76 10 80       	push   $0x80107603
80103d90:	e8 eb c5 ff ff       	call   80100380 <panic>
80103d95:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d9c:	00 
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi

80103da0 <exit>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103da9:	e8 d2 fb ff ff       	call   80103980 <myproc>
  if(curproc == initproc)
80103dae:	39 05 54 3e 11 80    	cmp    %eax,0x80113e54
80103db4:	0f 84 17 01 00 00    	je     80103ed1 <exit+0x131>
80103dba:	89 c3                	mov    %eax,%ebx
80103dbc:	8d 70 28             	lea    0x28(%eax),%esi
80103dbf:	8d 78 68             	lea    0x68(%eax),%edi
80103dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103dc8:	8b 06                	mov    (%esi),%eax
80103dca:	85 c0                	test   %eax,%eax
80103dcc:	74 12                	je     80103de0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103dce:	83 ec 0c             	sub    $0xc,%esp
80103dd1:	50                   	push   %eax
80103dd2:	e8 39 d1 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80103dd7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ddd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103de0:	83 c6 04             	add    $0x4,%esi
80103de3:	39 f7                	cmp    %esi,%edi
80103de5:	75 e1                	jne    80103dc8 <exit+0x28>
  p->nfd = 0; // setting the number of file descriptors to 0  
80103de7:	c7 05 80 00 00 00 00 	movl   $0x0,0x80
80103dee:	00 00 00 
  begin_op();
80103df1:	e8 4a ef ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103df6:	83 ec 0c             	sub    $0xc,%esp
80103df9:	ff 73 68             	push   0x68(%ebx)
80103dfc:	e8 cf da ff ff       	call   801018d0 <iput>
  end_op();
80103e01:	e8 aa ef ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103e06:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e0d:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103e14:	e8 07 09 00 00       	call   80104720 <acquire>
  wakeup1(curproc->parent);
80103e19:	8b 53 14             	mov    0x14(%ebx),%edx
80103e1c:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e1f:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e24:	eb 16                	jmp    80103e3c <exit+0x9c>
80103e26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e2d:	00 
80103e2e:	66 90                	xchg   %ax,%ax
80103e30:	05 84 00 00 00       	add    $0x84,%eax
80103e35:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80103e3a:	74 1e                	je     80103e5a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103e3c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e40:	75 ee                	jne    80103e30 <exit+0x90>
80103e42:	3b 50 20             	cmp    0x20(%eax),%edx
80103e45:	75 e9                	jne    80103e30 <exit+0x90>
      p->state = RUNNABLE;
80103e47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e4e:	05 84 00 00 00       	add    $0x84,%eax
80103e53:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80103e58:	75 e2                	jne    80103e3c <exit+0x9c>
      p->parent = initproc;
80103e5a:	8b 0d 54 3e 11 80    	mov    0x80113e54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e60:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103e65:	eb 17                	jmp    80103e7e <exit+0xde>
80103e67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e6e:	00 
80103e6f:	90                   	nop
80103e70:	81 c2 84 00 00 00    	add    $0x84,%edx
80103e76:	81 fa 54 3e 11 80    	cmp    $0x80113e54,%edx
80103e7c:	74 3a                	je     80103eb8 <exit+0x118>
    if(p->parent == curproc){
80103e7e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e81:	75 ed                	jne    80103e70 <exit+0xd0>
      if(p->state == ZOMBIE)
80103e83:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e87:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e8a:	75 e4                	jne    80103e70 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e8c:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103e91:	eb 11                	jmp    80103ea4 <exit+0x104>
80103e93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e98:	05 84 00 00 00       	add    $0x84,%eax
80103e9d:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80103ea2:	74 cc                	je     80103e70 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103ea4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ea8:	75 ee                	jne    80103e98 <exit+0xf8>
80103eaa:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ead:	75 e9                	jne    80103e98 <exit+0xf8>
      p->state = RUNNABLE;
80103eaf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103eb6:	eb e0                	jmp    80103e98 <exit+0xf8>
  curproc->state = ZOMBIE;
80103eb8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103ebf:	e8 1c fe ff ff       	call   80103ce0 <sched>
  panic("zombie exit");
80103ec4:	83 ec 0c             	sub    $0xc,%esp
80103ec7:	68 3e 76 10 80       	push   $0x8010763e
80103ecc:	e8 af c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ed1:	83 ec 0c             	sub    $0xc,%esp
80103ed4:	68 31 76 10 80       	push   $0x80107631
80103ed9:	e8 a2 c4 ff ff       	call   80100380 <panic>
80103ede:	66 90                	xchg   %ax,%ax

80103ee0 <wait>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 e6 06 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103eea:	e8 11 fa ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103eef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ef5:	e8 26 07 00 00       	call   80104620 <popcli>
  acquire(&ptable.lock);
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 20 1d 11 80       	push   $0x80111d20
80103f02:	e8 19 08 00 00       	call   80104720 <acquire>
80103f07:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f0a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0c:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103f11:	eb 13                	jmp    80103f26 <wait+0x46>
80103f13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f18:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103f1e:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80103f24:	74 1e                	je     80103f44 <wait+0x64>
      if(p->parent != curproc)
80103f26:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f29:	75 ed                	jne    80103f18 <wait+0x38>
      if(p->state == ZOMBIE){
80103f2b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f2f:	74 5f                	je     80103f90 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f31:	81 c3 84 00 00 00    	add    $0x84,%ebx
      havekids = 1;
80103f37:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3c:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80103f42:	75 e2                	jne    80103f26 <wait+0x46>
    if(!havekids || curproc->killed){
80103f44:	85 c0                	test   %eax,%eax
80103f46:	0f 84 9a 00 00 00    	je     80103fe6 <wait+0x106>
80103f4c:	8b 46 24             	mov    0x24(%esi),%eax
80103f4f:	85 c0                	test   %eax,%eax
80103f51:	0f 85 8f 00 00 00    	jne    80103fe6 <wait+0x106>
  pushcli();
80103f57:	e8 74 06 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80103f5c:	e8 9f f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103f61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f67:	e8 b4 06 00 00       	call   80104620 <popcli>
  if(p == 0)
80103f6c:	85 db                	test   %ebx,%ebx
80103f6e:	0f 84 89 00 00 00    	je     80103ffd <wait+0x11d>
  p->chan = chan;
80103f74:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80103f77:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f7e:	e8 5d fd ff ff       	call   80103ce0 <sched>
  p->chan = 0;
80103f83:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f8a:	e9 7b ff ff ff       	jmp    80103f0a <wait+0x2a>
80103f8f:	90                   	nop
        kfree(p->kstack);
80103f90:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103f93:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f96:	ff 73 08             	push   0x8(%ebx)
80103f99:	e8 02 e5 ff ff       	call   801024a0 <kfree>
        p->kstack = 0;
80103f9e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fa5:	5a                   	pop    %edx
80103fa6:	ff 73 04             	push   0x4(%ebx)
80103fa9:	e8 f2 2f 00 00       	call   80106fa0 <freevm>
        p->pid = 0;
80103fae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fb5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fbc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fc0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fc7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fce:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103fd5:	e8 e6 06 00 00       	call   801046c0 <release>
        return pid;
80103fda:	83 c4 10             	add    $0x10,%esp
}
80103fdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fe0:	89 f0                	mov    %esi,%eax
80103fe2:	5b                   	pop    %ebx
80103fe3:	5e                   	pop    %esi
80103fe4:	5d                   	pop    %ebp
80103fe5:	c3                   	ret
      release(&ptable.lock);
80103fe6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fe9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fee:	68 20 1d 11 80       	push   $0x80111d20
80103ff3:	e8 c8 06 00 00       	call   801046c0 <release>
      return -1;
80103ff8:	83 c4 10             	add    $0x10,%esp
80103ffb:	eb e0                	jmp    80103fdd <wait+0xfd>
    panic("sleep");
80103ffd:	83 ec 0c             	sub    $0xc,%esp
80104000:	68 4a 76 10 80       	push   $0x8010764a
80104005:	e8 76 c3 ff ff       	call   80100380 <panic>
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104010 <yield>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104017:	68 20 1d 11 80       	push   $0x80111d20
8010401c:	e8 ff 06 00 00       	call   80104720 <acquire>
  pushcli();
80104021:	e8 aa 05 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80104026:	e8 d5 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010402b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104031:	e8 ea 05 00 00       	call   80104620 <popcli>
  myproc()->state = RUNNABLE;
80104036:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010403d:	e8 9e fc ff ff       	call   80103ce0 <sched>
  release(&ptable.lock);
80104042:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80104049:	e8 72 06 00 00       	call   801046c0 <release>
}
8010404e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104051:	83 c4 10             	add    $0x10,%esp
80104054:	c9                   	leave
80104055:	c3                   	ret
80104056:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010405d:	00 
8010405e:	66 90                	xchg   %ax,%ax

80104060 <sleep>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	83 ec 0c             	sub    $0xc,%esp
80104069:	8b 7d 08             	mov    0x8(%ebp),%edi
8010406c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010406f:	e8 5c 05 00 00       	call   801045d0 <pushcli>
  c = mycpu();
80104074:	e8 87 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80104079:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010407f:	e8 9c 05 00 00       	call   80104620 <popcli>
  if(p == 0)
80104084:	85 db                	test   %ebx,%ebx
80104086:	0f 84 87 00 00 00    	je     80104113 <sleep+0xb3>
  if(lk == 0)
8010408c:	85 f6                	test   %esi,%esi
8010408e:	74 76                	je     80104106 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104090:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80104096:	74 50                	je     801040e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	68 20 1d 11 80       	push   $0x80111d20
801040a0:	e8 7b 06 00 00       	call   80104720 <acquire>
    release(lk);
801040a5:	89 34 24             	mov    %esi,(%esp)
801040a8:	e8 13 06 00 00       	call   801046c0 <release>
  p->chan = chan;
801040ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040b7:	e8 24 fc ff ff       	call   80103ce0 <sched>
  p->chan = 0;
801040bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801040c3:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801040ca:	e8 f1 05 00 00       	call   801046c0 <release>
    acquire(lk);
801040cf:	83 c4 10             	add    $0x10,%esp
801040d2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040d8:	5b                   	pop    %ebx
801040d9:	5e                   	pop    %esi
801040da:	5f                   	pop    %edi
801040db:	5d                   	pop    %ebp
    acquire(lk);
801040dc:	e9 3f 06 00 00       	jmp    80104720 <acquire>
801040e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040f2:	e8 e9 fb ff ff       	call   80103ce0 <sched>
  p->chan = 0;
801040f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104101:	5b                   	pop    %ebx
80104102:	5e                   	pop    %esi
80104103:	5f                   	pop    %edi
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret
    panic("sleep without lk");
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	68 50 76 10 80       	push   $0x80107650
8010410e:	e8 6d c2 ff ff       	call   80100380 <panic>
    panic("sleep");
80104113:	83 ec 0c             	sub    $0xc,%esp
80104116:	68 4a 76 10 80       	push   $0x8010764a
8010411b:	e8 60 c2 ff ff       	call   80100380 <panic>

80104120 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 10             	sub    $0x10,%esp
80104127:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010412a:	68 20 1d 11 80       	push   $0x80111d20
8010412f:	e8 ec 05 00 00       	call   80104720 <acquire>
80104134:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104137:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010413c:	eb 0e                	jmp    8010414c <wakeup+0x2c>
8010413e:	66 90                	xchg   %ax,%ax
80104140:	05 84 00 00 00       	add    $0x84,%eax
80104145:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
8010414a:	74 1e                	je     8010416a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010414c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104150:	75 ee                	jne    80104140 <wakeup+0x20>
80104152:	3b 58 20             	cmp    0x20(%eax),%ebx
80104155:	75 e9                	jne    80104140 <wakeup+0x20>
      p->state = RUNNABLE;
80104157:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010415e:	05 84 00 00 00       	add    $0x84,%eax
80104163:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80104168:	75 e2                	jne    8010414c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010416a:	c7 45 08 20 1d 11 80 	movl   $0x80111d20,0x8(%ebp)
}
80104171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104174:	c9                   	leave
  release(&ptable.lock);
80104175:	e9 46 05 00 00       	jmp    801046c0 <release>
8010417a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104180 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 10             	sub    $0x10,%esp
80104187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010418a:	68 20 1d 11 80       	push   $0x80111d20
8010418f:	e8 8c 05 00 00       	call   80104720 <acquire>
80104194:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104197:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010419c:	eb 0e                	jmp    801041ac <kill+0x2c>
8010419e:	66 90                	xchg   %ax,%ax
801041a0:	05 84 00 00 00       	add    $0x84,%eax
801041a5:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
801041aa:	74 34                	je     801041e0 <kill+0x60>
    if(p->pid == pid){
801041ac:	39 58 10             	cmp    %ebx,0x10(%eax)
801041af:	75 ef                	jne    801041a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041b1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041b5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041bc:	75 07                	jne    801041c5 <kill+0x45>
        p->state = RUNNABLE;
801041be:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041c5:	83 ec 0c             	sub    $0xc,%esp
801041c8:	68 20 1d 11 80       	push   $0x80111d20
801041cd:	e8 ee 04 00 00       	call   801046c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041d5:	83 c4 10             	add    $0x10,%esp
801041d8:	31 c0                	xor    %eax,%eax
}
801041da:	c9                   	leave
801041db:	c3                   	ret
801041dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801041e0:	83 ec 0c             	sub    $0xc,%esp
801041e3:	68 20 1d 11 80       	push   $0x80111d20
801041e8:	e8 d3 04 00 00       	call   801046c0 <release>
}
801041ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041f0:	83 c4 10             	add    $0x10,%esp
801041f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041f8:	c9                   	leave
801041f9:	c3                   	ret
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104200 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	57                   	push   %edi
80104204:	56                   	push   %esi
80104205:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104208:	53                   	push   %ebx
80104209:	bb c0 1d 11 80       	mov    $0x80111dc0,%ebx
8010420e:	83 ec 3c             	sub    $0x3c,%esp
80104211:	eb 27                	jmp    8010423a <procdump+0x3a>
80104213:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104218:	83 ec 0c             	sub    $0xc,%esp
8010421b:	68 0f 78 10 80       	push   $0x8010780f
80104220:	e8 8b c4 ff ff       	call   801006b0 <cprintf>
80104225:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104228:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010422e:	81 fb c0 3e 11 80    	cmp    $0x80113ec0,%ebx
80104234:	0f 84 7e 00 00 00    	je     801042b8 <procdump+0xb8>
    if(p->state == UNUSED)
8010423a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010423d:	85 c0                	test   %eax,%eax
8010423f:	74 e7                	je     80104228 <procdump+0x28>
      state = "???";
80104241:	ba 61 76 10 80       	mov    $0x80107661,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104246:	83 f8 05             	cmp    $0x5,%eax
80104249:	77 11                	ja     8010425c <procdump+0x5c>
8010424b:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
      state = "???";
80104252:	b8 61 76 10 80       	mov    $0x80107661,%eax
80104257:	85 d2                	test   %edx,%edx
80104259:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010425c:	53                   	push   %ebx
8010425d:	52                   	push   %edx
8010425e:	ff 73 a4             	push   -0x5c(%ebx)
80104261:	68 65 76 10 80       	push   $0x80107665
80104266:	e8 45 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
8010426b:	83 c4 10             	add    $0x10,%esp
8010426e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104272:	75 a4                	jne    80104218 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104274:	83 ec 08             	sub    $0x8,%esp
80104277:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010427a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010427d:	50                   	push   %eax
8010427e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104281:	8b 40 0c             	mov    0xc(%eax),%eax
80104284:	83 c0 08             	add    $0x8,%eax
80104287:	50                   	push   %eax
80104288:	e8 c3 02 00 00       	call   80104550 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010428d:	83 c4 10             	add    $0x10,%esp
80104290:	8b 17                	mov    (%edi),%edx
80104292:	85 d2                	test   %edx,%edx
80104294:	74 82                	je     80104218 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104296:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104299:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010429c:	52                   	push   %edx
8010429d:	68 a1 73 10 80       	push   $0x801073a1
801042a2:	e8 09 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042a7:	83 c4 10             	add    $0x10,%esp
801042aa:	39 f7                	cmp    %esi,%edi
801042ac:	75 e2                	jne    80104290 <procdump+0x90>
801042ae:	e9 65 ff ff ff       	jmp    80104218 <procdump+0x18>
801042b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801042b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042bb:	5b                   	pop    %ebx
801042bc:	5e                   	pop    %esi
801042bd:	5f                   	pop    %edi
801042be:	5d                   	pop    %ebp
801042bf:	c3                   	ret

801042c0 <getNumProc>:

int 
getNumProc(void){
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
  struct proc *p;
  int count = 0;
801042c4:	31 db                	xor    %ebx,%ebx
getNumProc(void){
801042c6:	83 ec 10             	sub    $0x10,%esp
  
  // Acquire the ptable lock before accessing
  acquire(&ptable.lock);
801042c9:	68 20 1d 11 80       	push   $0x80111d20
801042ce:	e8 4d 04 00 00       	call   80104720 <acquire>
801042d3:	83 c4 10             	add    $0x10,%esp
  
  // Iterate through the process table
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042d6:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801042db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    // Count if process exists (state is not UNUSED)
    if(p->state != UNUSED)
      count++;
801042e0:	83 78 0c 01          	cmpl   $0x1,0xc(%eax)
801042e4:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042e7:	05 84 00 00 00       	add    $0x84,%eax
801042ec:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
801042f1:	75 ed                	jne    801042e0 <getNumProc+0x20>
  }
  
  // Release the lock after we're done
  release(&ptable.lock);
801042f3:	83 ec 0c             	sub    $0xc,%esp
801042f6:	68 20 1d 11 80       	push   $0x80111d20
801042fb:	e8 c0 03 00 00       	call   801046c0 <release>
  
  return count;
}
80104300:	89 d8                	mov    %ebx,%eax
80104302:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104305:	c9                   	leave
80104306:	c3                   	ret
80104307:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010430e:	00 
8010430f:	90                   	nop

80104310 <getMaxPid>:

int 
getMaxPid(void) {
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
  struct proc *p;
  int max_pid = 0;
80104314:	31 db                	xor    %ebx,%ebx
getMaxPid(void) {
80104316:	83 ec 10             	sub    $0x10,%esp

  acquire(&ptable.lock);
80104319:	68 20 1d 11 80       	push   $0x80111d20
8010431e:	e8 fd 03 00 00       	call   80104720 <acquire>
80104323:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104326:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
8010432b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state != UNUSED && p->pid > max_pid) {
80104330:	8b 50 0c             	mov    0xc(%eax),%edx
80104333:	85 d2                	test   %edx,%edx
80104335:	74 08                	je     8010433f <getMaxPid+0x2f>
80104337:	8b 50 10             	mov    0x10(%eax),%edx
8010433a:	39 d3                	cmp    %edx,%ebx
8010433c:	0f 4c da             	cmovl  %edx,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010433f:	05 84 00 00 00       	add    $0x84,%eax
80104344:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80104349:	75 e5                	jne    80104330 <getMaxPid+0x20>
      max_pid = p->pid;
    }
  }
  release(&ptable.lock);
8010434b:	83 ec 0c             	sub    $0xc,%esp
8010434e:	68 20 1d 11 80       	push   $0x80111d20
80104353:	e8 68 03 00 00       	call   801046c0 <release>

  return max_pid;
}
80104358:	89 d8                	mov    %ebx,%eax
8010435a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010435d:	c9                   	leave
8010435e:	c3                   	ret
8010435f:	90                   	nop

80104360 <getProcInfo>:

int getProcInfo(int pid, struct processInfo* proc_info) {
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	56                   	push   %esi
80104364:	53                   	push   %ebx
80104365:	8b 75 08             	mov    0x8(%ebp),%esi
80104368:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct proc *p;
  int found = 0;

  acquire(&ptable.lock);
8010436b:	83 ec 0c             	sub    $0xc,%esp
8010436e:	68 20 1d 11 80       	push   $0x80111d20
80104373:	e8 a8 03 00 00       	call   80104720 <acquire>
80104378:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010437b:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80104380:	eb 12                	jmp    80104394 <getProcInfo+0x34>
80104382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104388:	05 84 00 00 00       	add    $0x84,%eax
8010438d:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80104392:	74 5c                	je     801043f0 <getProcInfo+0x90>
    if(p->pid == pid) {
80104394:	39 70 10             	cmp    %esi,0x10(%eax)
80104397:	75 ef                	jne    80104388 <getProcInfo+0x28>

      proc_info->state = p->state;
80104399:	8b 50 0c             	mov    0xc(%eax),%edx
8010439c:	89 13                	mov    %edx,(%ebx)
      proc_info->ppid = p->parent ? p->parent->pid : 0;
8010439e:	8b 48 14             	mov    0x14(%eax),%ecx
801043a1:	31 d2                	xor    %edx,%edx
801043a3:	85 c9                	test   %ecx,%ecx
801043a5:	74 03                	je     801043aa <getProcInfo+0x4a>
801043a7:	8b 51 10             	mov    0x10(%ecx),%edx
801043aa:	89 53 04             	mov    %edx,0x4(%ebx)
      proc_info->sz = p->sz;
801043ad:	8b 10                	mov    (%eax),%edx
801043af:	89 53 08             	mov    %edx,0x8(%ebx)
      proc_info->nrswitch = p->nrswitch; //FIXME -to do
801043b2:	8b 50 7c             	mov    0x7c(%eax),%edx
801043b5:	89 53 10             	mov    %edx,0x10(%ebx)
      found = 1;
      for(int i = 0; i<NOFILE; i++) {
801043b8:	8d 50 28             	lea    0x28(%eax),%edx
801043bb:	83 c0 68             	add    $0x68,%eax
801043be:	66 90                	xchg   %ax,%ax
        if (p->ofile[i] != 0){
801043c0:	8b 0a                	mov    (%edx),%ecx
801043c2:	85 c9                	test   %ecx,%ecx
801043c4:	74 04                	je     801043ca <getProcInfo+0x6a>
          proc_info->nfd++;
801043c6:	83 43 0c 01          	addl   $0x1,0xc(%ebx)
      for(int i = 0; i<NOFILE; i++) {
801043ca:	83 c2 04             	add    $0x4,%edx
801043cd:	39 c2                	cmp    %eax,%edx
801043cf:	75 ef                	jne    801043c0 <getProcInfo+0x60>
801043d1:	31 db                	xor    %ebx,%ebx
        }    
     }
      break;
    }
  }
  release(&ptable.lock);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	68 20 1d 11 80       	push   $0x80111d20
801043db:	e8 e0 02 00 00       	call   801046c0 <release>

  return found ? 0 : -1; // Return 0 on success, -1 if the process was not found
}
801043e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043e3:	89 d8                	mov    %ebx,%eax
801043e5:	5b                   	pop    %ebx
801043e6:	5e                   	pop    %esi
801043e7:	5d                   	pop    %ebp
801043e8:	c3                   	ret
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043f5:	eb dc                	jmp    801043d3 <getProcInfo+0x73>
801043f7:	66 90                	xchg   %ax,%ax
801043f9:	66 90                	xchg   %ax,%ax
801043fb:	66 90                	xchg   %ax,%ax
801043fd:	66 90                	xchg   %ax,%ax
801043ff:	90                   	nop

80104400 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010440a:	68 98 76 10 80       	push   $0x80107698
8010440f:	8d 43 04             	lea    0x4(%ebx),%eax
80104412:	50                   	push   %eax
80104413:	e8 18 01 00 00       	call   80104530 <initlock>
  lk->name = name;
80104418:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010441b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104421:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104424:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010442b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010442e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104431:	c9                   	leave
80104432:	c3                   	ret
80104433:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010443a:	00 
8010443b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104440 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	56                   	push   %esi
80104444:	53                   	push   %ebx
80104445:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104448:	8d 73 04             	lea    0x4(%ebx),%esi
8010444b:	83 ec 0c             	sub    $0xc,%esp
8010444e:	56                   	push   %esi
8010444f:	e8 cc 02 00 00       	call   80104720 <acquire>
  while (lk->locked) {
80104454:	8b 13                	mov    (%ebx),%edx
80104456:	83 c4 10             	add    $0x10,%esp
80104459:	85 d2                	test   %edx,%edx
8010445b:	74 16                	je     80104473 <acquiresleep+0x33>
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104460:	83 ec 08             	sub    $0x8,%esp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	e8 f6 fb ff ff       	call   80104060 <sleep>
  while (lk->locked) {
8010446a:	8b 03                	mov    (%ebx),%eax
8010446c:	83 c4 10             	add    $0x10,%esp
8010446f:	85 c0                	test   %eax,%eax
80104471:	75 ed                	jne    80104460 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104473:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104479:	e8 02 f5 ff ff       	call   80103980 <myproc>
8010447e:	8b 40 10             	mov    0x10(%eax),%eax
80104481:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104484:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104487:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010448a:	5b                   	pop    %ebx
8010448b:	5e                   	pop    %esi
8010448c:	5d                   	pop    %ebp
  release(&lk->lk);
8010448d:	e9 2e 02 00 00       	jmp    801046c0 <release>
80104492:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104499:	00 
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044a8:	8d 73 04             	lea    0x4(%ebx),%esi
801044ab:	83 ec 0c             	sub    $0xc,%esp
801044ae:	56                   	push   %esi
801044af:	e8 6c 02 00 00       	call   80104720 <acquire>
  lk->locked = 0;
801044b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801044ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801044c1:	89 1c 24             	mov    %ebx,(%esp)
801044c4:	e8 57 fc ff ff       	call   80104120 <wakeup>
  release(&lk->lk);
801044c9:	83 c4 10             	add    $0x10,%esp
801044cc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044d2:	5b                   	pop    %ebx
801044d3:	5e                   	pop    %esi
801044d4:	5d                   	pop    %ebp
  release(&lk->lk);
801044d5:	e9 e6 01 00 00       	jmp    801046c0 <release>
801044da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	31 ff                	xor    %edi,%edi
801044e6:	56                   	push   %esi
801044e7:	53                   	push   %ebx
801044e8:	83 ec 18             	sub    $0x18,%esp
801044eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044ee:	8d 73 04             	lea    0x4(%ebx),%esi
801044f1:	56                   	push   %esi
801044f2:	e8 29 02 00 00       	call   80104720 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044f7:	8b 03                	mov    (%ebx),%eax
801044f9:	83 c4 10             	add    $0x10,%esp
801044fc:	85 c0                	test   %eax,%eax
801044fe:	75 18                	jne    80104518 <holdingsleep+0x38>
  release(&lk->lk);
80104500:	83 ec 0c             	sub    $0xc,%esp
80104503:	56                   	push   %esi
80104504:	e8 b7 01 00 00       	call   801046c0 <release>
  return r;
}
80104509:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010450c:	89 f8                	mov    %edi,%eax
8010450e:	5b                   	pop    %ebx
8010450f:	5e                   	pop    %esi
80104510:	5f                   	pop    %edi
80104511:	5d                   	pop    %ebp
80104512:	c3                   	ret
80104513:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104518:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010451b:	e8 60 f4 ff ff       	call   80103980 <myproc>
80104520:	39 58 10             	cmp    %ebx,0x10(%eax)
80104523:	0f 94 c0             	sete   %al
80104526:	0f b6 c0             	movzbl %al,%eax
80104529:	89 c7                	mov    %eax,%edi
8010452b:	eb d3                	jmp    80104500 <holdingsleep+0x20>
8010452d:	66 90                	xchg   %ax,%ax
8010452f:	90                   	nop

80104530 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104536:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010453f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104542:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104549:	5d                   	pop    %ebp
8010454a:	c3                   	ret
8010454b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104550 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	8b 45 08             	mov    0x8(%ebp),%eax
80104557:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010455a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010455d:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
80104562:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
80104567:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010456c:	76 10                	jbe    8010457e <getcallerpcs+0x2e>
8010456e:	eb 28                	jmp    80104598 <getcallerpcs+0x48>
80104570:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104576:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010457c:	77 1a                	ja     80104598 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010457e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104581:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104584:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104587:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104589:	83 f8 0a             	cmp    $0xa,%eax
8010458c:	75 e2                	jne    80104570 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010458e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104591:	c9                   	leave
80104592:	c3                   	ret
80104593:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104598:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010459b:	83 c1 28             	add    $0x28,%ecx
8010459e:	89 ca                	mov    %ecx,%edx
801045a0:	29 c2                	sub    %eax,%edx
801045a2:	83 e2 04             	and    $0x4,%edx
801045a5:	74 11                	je     801045b8 <getcallerpcs+0x68>
    pcs[i] = 0;
801045a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045ad:	83 c0 04             	add    $0x4,%eax
801045b0:	39 c1                	cmp    %eax,%ecx
801045b2:	74 da                	je     8010458e <getcallerpcs+0x3e>
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801045b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045be:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801045c1:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801045c8:	39 c1                	cmp    %eax,%ecx
801045ca:	75 ec                	jne    801045b8 <getcallerpcs+0x68>
801045cc:	eb c0                	jmp    8010458e <getcallerpcs+0x3e>
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 04             	sub    $0x4,%esp
801045d7:	9c                   	pushf
801045d8:	5b                   	pop    %ebx
  asm volatile("cli");
801045d9:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801045da:	e8 21 f3 ff ff       	call   80103900 <mycpu>
801045df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801045e5:	85 c0                	test   %eax,%eax
801045e7:	74 17                	je     80104600 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801045e9:	e8 12 f3 ff ff       	call   80103900 <mycpu>
801045ee:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f8:	c9                   	leave
801045f9:	c3                   	ret
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104600:	e8 fb f2 ff ff       	call   80103900 <mycpu>
80104605:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010460b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104611:	eb d6                	jmp    801045e9 <pushcli+0x19>
80104613:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010461a:	00 
8010461b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104620 <popcli>:

void
popcli(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104626:	9c                   	pushf
80104627:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104628:	f6 c4 02             	test   $0x2,%ah
8010462b:	75 35                	jne    80104662 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010462d:	e8 ce f2 ff ff       	call   80103900 <mycpu>
80104632:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104639:	78 34                	js     8010466f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010463b:	e8 c0 f2 ff ff       	call   80103900 <mycpu>
80104640:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104646:	85 d2                	test   %edx,%edx
80104648:	74 06                	je     80104650 <popcli+0x30>
    sti();
}
8010464a:	c9                   	leave
8010464b:	c3                   	ret
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104650:	e8 ab f2 ff ff       	call   80103900 <mycpu>
80104655:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010465b:	85 c0                	test   %eax,%eax
8010465d:	74 eb                	je     8010464a <popcli+0x2a>
  asm volatile("sti");
8010465f:	fb                   	sti
}
80104660:	c9                   	leave
80104661:	c3                   	ret
    panic("popcli - interruptible");
80104662:	83 ec 0c             	sub    $0xc,%esp
80104665:	68 a3 76 10 80       	push   $0x801076a3
8010466a:	e8 11 bd ff ff       	call   80100380 <panic>
    panic("popcli");
8010466f:	83 ec 0c             	sub    $0xc,%esp
80104672:	68 ba 76 10 80       	push   $0x801076ba
80104677:	e8 04 bd ff ff       	call   80100380 <panic>
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104680 <holding>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 75 08             	mov    0x8(%ebp),%esi
80104688:	31 db                	xor    %ebx,%ebx
  pushcli();
8010468a:	e8 41 ff ff ff       	call   801045d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010468f:	8b 06                	mov    (%esi),%eax
80104691:	85 c0                	test   %eax,%eax
80104693:	75 0b                	jne    801046a0 <holding+0x20>
  popcli();
80104695:	e8 86 ff ff ff       	call   80104620 <popcli>
}
8010469a:	89 d8                	mov    %ebx,%eax
8010469c:	5b                   	pop    %ebx
8010469d:	5e                   	pop    %esi
8010469e:	5d                   	pop    %ebp
8010469f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
801046a0:	8b 5e 08             	mov    0x8(%esi),%ebx
801046a3:	e8 58 f2 ff ff       	call   80103900 <mycpu>
801046a8:	39 c3                	cmp    %eax,%ebx
801046aa:	0f 94 c3             	sete   %bl
  popcli();
801046ad:	e8 6e ff ff ff       	call   80104620 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801046b2:	0f b6 db             	movzbl %bl,%ebx
}
801046b5:	89 d8                	mov    %ebx,%eax
801046b7:	5b                   	pop    %ebx
801046b8:	5e                   	pop    %esi
801046b9:	5d                   	pop    %ebp
801046ba:	c3                   	ret
801046bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801046c0 <release>:
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046c8:	e8 03 ff ff ff       	call   801045d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046cd:	8b 03                	mov    (%ebx),%eax
801046cf:	85 c0                	test   %eax,%eax
801046d1:	75 15                	jne    801046e8 <release+0x28>
  popcli();
801046d3:	e8 48 ff ff ff       	call   80104620 <popcli>
    panic("release");
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	68 c1 76 10 80       	push   $0x801076c1
801046e0:	e8 9b bc ff ff       	call   80100380 <panic>
801046e5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801046e8:	8b 73 08             	mov    0x8(%ebx),%esi
801046eb:	e8 10 f2 ff ff       	call   80103900 <mycpu>
801046f0:	39 c6                	cmp    %eax,%esi
801046f2:	75 df                	jne    801046d3 <release+0x13>
  popcli();
801046f4:	e8 27 ff ff ff       	call   80104620 <popcli>
  lk->pcs[0] = 0;
801046f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104700:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104707:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010470c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104712:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104715:	5b                   	pop    %ebx
80104716:	5e                   	pop    %esi
80104717:	5d                   	pop    %ebp
  popcli();
80104718:	e9 03 ff ff ff       	jmp    80104620 <popcli>
8010471d:	8d 76 00             	lea    0x0(%esi),%esi

80104720 <acquire>:
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104727:	e8 a4 fe ff ff       	call   801045d0 <pushcli>
  if(holding(lk))
8010472c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010472f:	e8 9c fe ff ff       	call   801045d0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104734:	8b 03                	mov    (%ebx),%eax
80104736:	85 c0                	test   %eax,%eax
80104738:	0f 85 b2 00 00 00    	jne    801047f0 <acquire+0xd0>
  popcli();
8010473e:	e8 dd fe ff ff       	call   80104620 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104743:	b9 01 00 00 00       	mov    $0x1,%ecx
80104748:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010474f:	00 
  while(xchg(&lk->locked, 1) != 0)
80104750:	8b 55 08             	mov    0x8(%ebp),%edx
80104753:	89 c8                	mov    %ecx,%eax
80104755:	f0 87 02             	lock xchg %eax,(%edx)
80104758:	85 c0                	test   %eax,%eax
8010475a:	75 f4                	jne    80104750 <acquire+0x30>
  __sync_synchronize();
8010475c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104761:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104764:	e8 97 f1 ff ff       	call   80103900 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104769:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
8010476c:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
8010476e:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104771:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
80104777:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
8010477c:	77 32                	ja     801047b0 <acquire+0x90>
  ebp = (uint*)v - 2;
8010477e:	89 e8                	mov    %ebp,%eax
80104780:	eb 14                	jmp    80104796 <acquire+0x76>
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104788:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010478e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104794:	77 1a                	ja     801047b0 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104796:	8b 58 04             	mov    0x4(%eax),%ebx
80104799:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010479d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047a0:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047a2:	83 fa 0a             	cmp    $0xa,%edx
801047a5:	75 e1                	jne    80104788 <acquire+0x68>
}
801047a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047aa:	c9                   	leave
801047ab:	c3                   	ret
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047b0:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
801047b4:	83 c1 34             	add    $0x34,%ecx
801047b7:	89 ca                	mov    %ecx,%edx
801047b9:	29 c2                	sub    %eax,%edx
801047bb:	83 e2 04             	and    $0x4,%edx
801047be:	74 10                	je     801047d0 <acquire+0xb0>
    pcs[i] = 0;
801047c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047c6:	83 c0 04             	add    $0x4,%eax
801047c9:	39 c1                	cmp    %eax,%ecx
801047cb:	74 da                	je     801047a7 <acquire+0x87>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801047d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047d6:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
801047d9:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
801047e0:	39 c1                	cmp    %eax,%ecx
801047e2:	75 ec                	jne    801047d0 <acquire+0xb0>
801047e4:	eb c1                	jmp    801047a7 <acquire+0x87>
801047e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047ed:	00 
801047ee:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
801047f0:	8b 5b 08             	mov    0x8(%ebx),%ebx
801047f3:	e8 08 f1 ff ff       	call   80103900 <mycpu>
801047f8:	39 c3                	cmp    %eax,%ebx
801047fa:	0f 85 3e ff ff ff    	jne    8010473e <acquire+0x1e>
  popcli();
80104800:	e8 1b fe ff ff       	call   80104620 <popcli>
    panic("acquire");
80104805:	83 ec 0c             	sub    $0xc,%esp
80104808:	68 c9 76 10 80       	push   $0x801076c9
8010480d:	e8 6e bb ff ff       	call   80100380 <panic>
80104812:	66 90                	xchg   %ax,%ax
80104814:	66 90                	xchg   %ax,%ax
80104816:	66 90                	xchg   %ax,%ax
80104818:	66 90                	xchg   %ax,%ax
8010481a:	66 90                	xchg   %ax,%ax
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	8b 55 08             	mov    0x8(%ebp),%edx
80104827:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010482a:	89 d0                	mov    %edx,%eax
8010482c:	09 c8                	or     %ecx,%eax
8010482e:	a8 03                	test   $0x3,%al
80104830:	75 1e                	jne    80104850 <memset+0x30>
    c &= 0xFF;
80104832:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104836:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104839:	89 d7                	mov    %edx,%edi
8010483b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
80104841:	fc                   	cld
80104842:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104844:	8b 7d fc             	mov    -0x4(%ebp),%edi
80104847:	89 d0                	mov    %edx,%eax
80104849:	c9                   	leave
8010484a:	c3                   	ret
8010484b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104850:	8b 45 0c             	mov    0xc(%ebp),%eax
80104853:	89 d7                	mov    %edx,%edi
80104855:	fc                   	cld
80104856:	f3 aa                	rep stos %al,%es:(%edi)
80104858:	8b 7d fc             	mov    -0x4(%ebp),%edi
8010485b:	89 d0                	mov    %edx,%eax
8010485d:	c9                   	leave
8010485e:	c3                   	ret
8010485f:	90                   	nop

80104860 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	8b 75 10             	mov    0x10(%ebp),%esi
80104867:	8b 45 08             	mov    0x8(%ebp),%eax
8010486a:	53                   	push   %ebx
8010486b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010486e:	85 f6                	test   %esi,%esi
80104870:	74 2e                	je     801048a0 <memcmp+0x40>
80104872:	01 c6                	add    %eax,%esi
80104874:	eb 14                	jmp    8010488a <memcmp+0x2a>
80104876:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010487d:	00 
8010487e:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104880:	83 c0 01             	add    $0x1,%eax
80104883:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104886:	39 f0                	cmp    %esi,%eax
80104888:	74 16                	je     801048a0 <memcmp+0x40>
    if(*s1 != *s2)
8010488a:	0f b6 08             	movzbl (%eax),%ecx
8010488d:	0f b6 1a             	movzbl (%edx),%ebx
80104890:	38 d9                	cmp    %bl,%cl
80104892:	74 ec                	je     80104880 <memcmp+0x20>
      return *s1 - *s2;
80104894:	0f b6 c1             	movzbl %cl,%eax
80104897:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104899:	5b                   	pop    %ebx
8010489a:	5e                   	pop    %esi
8010489b:	5d                   	pop    %ebp
8010489c:	c3                   	ret
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
801048a0:	5b                   	pop    %ebx
  return 0;
801048a1:	31 c0                	xor    %eax,%eax
}
801048a3:	5e                   	pop    %esi
801048a4:	5d                   	pop    %ebp
801048a5:	c3                   	ret
801048a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ad:	00 
801048ae:	66 90                	xchg   %ax,%ax

801048b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	57                   	push   %edi
801048b4:	8b 55 08             	mov    0x8(%ebp),%edx
801048b7:	8b 45 10             	mov    0x10(%ebp),%eax
801048ba:	56                   	push   %esi
801048bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801048be:	39 d6                	cmp    %edx,%esi
801048c0:	73 26                	jae    801048e8 <memmove+0x38>
801048c2:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048c5:	39 ca                	cmp    %ecx,%edx
801048c7:	73 1f                	jae    801048e8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801048c9:	85 c0                	test   %eax,%eax
801048cb:	74 0f                	je     801048dc <memmove+0x2c>
801048cd:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
801048d0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801048d4:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801048d7:	83 e8 01             	sub    $0x1,%eax
801048da:	73 f4                	jae    801048d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048dc:	5e                   	pop    %esi
801048dd:	89 d0                	mov    %edx,%eax
801048df:	5f                   	pop    %edi
801048e0:	5d                   	pop    %ebp
801048e1:	c3                   	ret
801048e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
801048e8:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
801048eb:	89 d7                	mov    %edx,%edi
801048ed:	85 c0                	test   %eax,%eax
801048ef:	74 eb                	je     801048dc <memmove+0x2c>
801048f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801048f8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801048f9:	39 ce                	cmp    %ecx,%esi
801048fb:	75 fb                	jne    801048f8 <memmove+0x48>
}
801048fd:	5e                   	pop    %esi
801048fe:	89 d0                	mov    %edx,%eax
80104900:	5f                   	pop    %edi
80104901:	5d                   	pop    %ebp
80104902:	c3                   	ret
80104903:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010490a:	00 
8010490b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104910 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104910:	eb 9e                	jmp    801048b0 <memmove>
80104912:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104919:	00 
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104920 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	8b 55 10             	mov    0x10(%ebp),%edx
80104927:	8b 45 08             	mov    0x8(%ebp),%eax
8010492a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010492d:	85 d2                	test   %edx,%edx
8010492f:	75 16                	jne    80104947 <strncmp+0x27>
80104931:	eb 2d                	jmp    80104960 <strncmp+0x40>
80104933:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104938:	3a 19                	cmp    (%ecx),%bl
8010493a:	75 12                	jne    8010494e <strncmp+0x2e>
    n--, p++, q++;
8010493c:	83 c0 01             	add    $0x1,%eax
8010493f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104942:	83 ea 01             	sub    $0x1,%edx
80104945:	74 19                	je     80104960 <strncmp+0x40>
80104947:	0f b6 18             	movzbl (%eax),%ebx
8010494a:	84 db                	test   %bl,%bl
8010494c:	75 ea                	jne    80104938 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010494e:	0f b6 00             	movzbl (%eax),%eax
80104951:	0f b6 11             	movzbl (%ecx),%edx
}
80104954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104957:	c9                   	leave
  return (uchar)*p - (uchar)*q;
80104958:	29 d0                	sub    %edx,%eax
}
8010495a:	c3                   	ret
8010495b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80104963:	31 c0                	xor    %eax,%eax
}
80104965:	c9                   	leave
80104966:	c3                   	ret
80104967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010496e:	00 
8010496f:	90                   	nop

80104970 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	57                   	push   %edi
80104974:	56                   	push   %esi
80104975:	8b 75 08             	mov    0x8(%ebp),%esi
80104978:	53                   	push   %ebx
80104979:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010497c:	89 f0                	mov    %esi,%eax
8010497e:	eb 15                	jmp    80104995 <strncpy+0x25>
80104980:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104984:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104987:	83 c0 01             	add    $0x1,%eax
8010498a:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
8010498e:	88 48 ff             	mov    %cl,-0x1(%eax)
80104991:	84 c9                	test   %cl,%cl
80104993:	74 13                	je     801049a8 <strncpy+0x38>
80104995:	89 d3                	mov    %edx,%ebx
80104997:	83 ea 01             	sub    $0x1,%edx
8010499a:	85 db                	test   %ebx,%ebx
8010499c:	7f e2                	jg     80104980 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010499e:	5b                   	pop    %ebx
8010499f:	89 f0                	mov    %esi,%eax
801049a1:	5e                   	pop    %esi
801049a2:	5f                   	pop    %edi
801049a3:	5d                   	pop    %ebp
801049a4:	c3                   	ret
801049a5:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
801049a8:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
801049ab:	83 e9 01             	sub    $0x1,%ecx
801049ae:	85 d2                	test   %edx,%edx
801049b0:	74 ec                	je     8010499e <strncpy+0x2e>
801049b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
801049b8:	83 c0 01             	add    $0x1,%eax
801049bb:	89 ca                	mov    %ecx,%edx
801049bd:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
801049c1:	29 c2                	sub    %eax,%edx
801049c3:	85 d2                	test   %edx,%edx
801049c5:	7f f1                	jg     801049b8 <strncpy+0x48>
}
801049c7:	5b                   	pop    %ebx
801049c8:	89 f0                	mov    %esi,%eax
801049ca:	5e                   	pop    %esi
801049cb:	5f                   	pop    %edi
801049cc:	5d                   	pop    %ebp
801049cd:	c3                   	ret
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	8b 55 10             	mov    0x10(%ebp),%edx
801049d7:	8b 75 08             	mov    0x8(%ebp),%esi
801049da:	53                   	push   %ebx
801049db:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801049de:	85 d2                	test   %edx,%edx
801049e0:	7e 25                	jle    80104a07 <safestrcpy+0x37>
801049e2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801049e6:	89 f2                	mov    %esi,%edx
801049e8:	eb 16                	jmp    80104a00 <safestrcpy+0x30>
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049f0:	0f b6 08             	movzbl (%eax),%ecx
801049f3:	83 c0 01             	add    $0x1,%eax
801049f6:	83 c2 01             	add    $0x1,%edx
801049f9:	88 4a ff             	mov    %cl,-0x1(%edx)
801049fc:	84 c9                	test   %cl,%cl
801049fe:	74 04                	je     80104a04 <safestrcpy+0x34>
80104a00:	39 d8                	cmp    %ebx,%eax
80104a02:	75 ec                	jne    801049f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104a04:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a07:	89 f0                	mov    %esi,%eax
80104a09:	5b                   	pop    %ebx
80104a0a:	5e                   	pop    %esi
80104a0b:	5d                   	pop    %ebp
80104a0c:	c3                   	ret
80104a0d:	8d 76 00             	lea    0x0(%esi),%esi

80104a10 <strlen>:

int
strlen(const char *s)
{
80104a10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a11:	31 c0                	xor    %eax,%eax
{
80104a13:	89 e5                	mov    %esp,%ebp
80104a15:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a18:	80 3a 00             	cmpb   $0x0,(%edx)
80104a1b:	74 0c                	je     80104a29 <strlen+0x19>
80104a1d:	8d 76 00             	lea    0x0(%esi),%esi
80104a20:	83 c0 01             	add    $0x1,%eax
80104a23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a27:	75 f7                	jne    80104a20 <strlen+0x10>
    ;
  return n;
}
80104a29:	5d                   	pop    %ebp
80104a2a:	c3                   	ret

80104a2b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a33:	55                   	push   %ebp
  pushl %ebx
80104a34:	53                   	push   %ebx
  pushl %esi
80104a35:	56                   	push   %esi
  pushl %edi
80104a36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a39:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a3b:	5f                   	pop    %edi
  popl %esi
80104a3c:	5e                   	pop    %esi
  popl %ebx
80104a3d:	5b                   	pop    %ebx
  popl %ebp
80104a3e:	5d                   	pop    %ebp
  ret
80104a3f:	c3                   	ret

80104a40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 04             	sub    $0x4,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a4a:	e8 31 ef ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a4f:	8b 00                	mov    (%eax),%eax
80104a51:	39 c3                	cmp    %eax,%ebx
80104a53:	73 1b                	jae    80104a70 <fetchint+0x30>
80104a55:	8d 53 04             	lea    0x4(%ebx),%edx
80104a58:	39 d0                	cmp    %edx,%eax
80104a5a:	72 14                	jb     80104a70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a5f:	8b 13                	mov    (%ebx),%edx
80104a61:	89 10                	mov    %edx,(%eax)
  return 0;
80104a63:	31 c0                	xor    %eax,%eax
}
80104a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a68:	c9                   	leave
80104a69:	c3                   	ret
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a75:	eb ee                	jmp    80104a65 <fetchint+0x25>
80104a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a7e:	00 
80104a7f:	90                   	nop

80104a80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 04             	sub    $0x4,%esp
80104a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a8a:	e8 f1 ee ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
80104a8f:	3b 18                	cmp    (%eax),%ebx
80104a91:	73 2d                	jae    80104ac0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a93:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a96:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a98:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a9a:	39 d3                	cmp    %edx,%ebx
80104a9c:	73 22                	jae    80104ac0 <fetchstr+0x40>
80104a9e:	89 d8                	mov    %ebx,%eax
80104aa0:	eb 0d                	jmp    80104aaf <fetchstr+0x2f>
80104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa8:	83 c0 01             	add    $0x1,%eax
80104aab:	39 d0                	cmp    %edx,%eax
80104aad:	73 11                	jae    80104ac0 <fetchstr+0x40>
    if(*s == 0)
80104aaf:	80 38 00             	cmpb   $0x0,(%eax)
80104ab2:	75 f4                	jne    80104aa8 <fetchstr+0x28>
      return s - *pp;
80104ab4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104ab6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab9:	c9                   	leave
80104aba:	c3                   	ret
80104abb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ac0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104ac3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ac8:	c9                   	leave
80104ac9:	c3                   	ret
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ad5:	e8 a6 ee ff ff       	call   80103980 <myproc>
80104ada:	8b 55 08             	mov    0x8(%ebp),%edx
80104add:	8b 40 18             	mov    0x18(%eax),%eax
80104ae0:	8b 40 44             	mov    0x44(%eax),%eax
80104ae3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ae6:	e8 95 ee ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aeb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aee:	8b 00                	mov    (%eax),%eax
80104af0:	39 c6                	cmp    %eax,%esi
80104af2:	73 1c                	jae    80104b10 <argint+0x40>
80104af4:	8d 53 08             	lea    0x8(%ebx),%edx
80104af7:	39 d0                	cmp    %edx,%eax
80104af9:	72 15                	jb     80104b10 <argint+0x40>
  *ip = *(int*)(addr);
80104afb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104afe:	8b 53 04             	mov    0x4(%ebx),%edx
80104b01:	89 10                	mov    %edx,(%eax)
  return 0;
80104b03:	31 c0                	xor    %eax,%eax
}
80104b05:	5b                   	pop    %ebx
80104b06:	5e                   	pop    %esi
80104b07:	5d                   	pop    %ebp
80104b08:	c3                   	ret
80104b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b15:	eb ee                	jmp    80104b05 <argint+0x35>
80104b17:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b1e:	00 
80104b1f:	90                   	nop

80104b20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	57                   	push   %edi
80104b24:	56                   	push   %esi
80104b25:	53                   	push   %ebx
80104b26:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b29:	e8 52 ee ff ff       	call   80103980 <myproc>
80104b2e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b30:	e8 4b ee ff ff       	call   80103980 <myproc>
80104b35:	8b 55 08             	mov    0x8(%ebp),%edx
80104b38:	8b 40 18             	mov    0x18(%eax),%eax
80104b3b:	8b 40 44             	mov    0x44(%eax),%eax
80104b3e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b41:	e8 3a ee ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b46:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b49:	8b 00                	mov    (%eax),%eax
80104b4b:	39 c7                	cmp    %eax,%edi
80104b4d:	73 31                	jae    80104b80 <argptr+0x60>
80104b4f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104b52:	39 c8                	cmp    %ecx,%eax
80104b54:	72 2a                	jb     80104b80 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b56:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104b59:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b5c:	85 d2                	test   %edx,%edx
80104b5e:	78 20                	js     80104b80 <argptr+0x60>
80104b60:	8b 16                	mov    (%esi),%edx
80104b62:	39 d0                	cmp    %edx,%eax
80104b64:	73 1a                	jae    80104b80 <argptr+0x60>
80104b66:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b69:	01 c3                	add    %eax,%ebx
80104b6b:	39 da                	cmp    %ebx,%edx
80104b6d:	72 11                	jb     80104b80 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b72:	89 02                	mov    %eax,(%edx)
  return 0;
80104b74:	31 c0                	xor    %eax,%eax
}
80104b76:	83 c4 0c             	add    $0xc,%esp
80104b79:	5b                   	pop    %ebx
80104b7a:	5e                   	pop    %esi
80104b7b:	5f                   	pop    %edi
80104b7c:	5d                   	pop    %ebp
80104b7d:	c3                   	ret
80104b7e:	66 90                	xchg   %ax,%ax
    return -1;
80104b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b85:	eb ef                	jmp    80104b76 <argptr+0x56>
80104b87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b8e:	00 
80104b8f:	90                   	nop

80104b90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b95:	e8 e6 ed ff ff       	call   80103980 <myproc>
80104b9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ba0:	8b 40 44             	mov    0x44(%eax),%eax
80104ba3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ba6:	e8 d5 ed ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bae:	8b 00                	mov    (%eax),%eax
80104bb0:	39 c6                	cmp    %eax,%esi
80104bb2:	73 44                	jae    80104bf8 <argstr+0x68>
80104bb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bb7:	39 d0                	cmp    %edx,%eax
80104bb9:	72 3d                	jb     80104bf8 <argstr+0x68>
  *ip = *(int*)(addr);
80104bbb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104bbe:	e8 bd ed ff ff       	call   80103980 <myproc>
  if(addr >= curproc->sz)
80104bc3:	3b 18                	cmp    (%eax),%ebx
80104bc5:	73 31                	jae    80104bf8 <argstr+0x68>
  *pp = (char*)addr;
80104bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bca:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bcc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bce:	39 d3                	cmp    %edx,%ebx
80104bd0:	73 26                	jae    80104bf8 <argstr+0x68>
80104bd2:	89 d8                	mov    %ebx,%eax
80104bd4:	eb 11                	jmp    80104be7 <argstr+0x57>
80104bd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bdd:	00 
80104bde:	66 90                	xchg   %ax,%ax
80104be0:	83 c0 01             	add    $0x1,%eax
80104be3:	39 d0                	cmp    %edx,%eax
80104be5:	73 11                	jae    80104bf8 <argstr+0x68>
    if(*s == 0)
80104be7:	80 38 00             	cmpb   $0x0,(%eax)
80104bea:	75 f4                	jne    80104be0 <argstr+0x50>
      return s - *pp;
80104bec:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104bee:	5b                   	pop    %ebx
80104bef:	5e                   	pop    %esi
80104bf0:	5d                   	pop    %ebp
80104bf1:	c3                   	ret
80104bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf8:	5b                   	pop    %ebx
    return -1;
80104bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bfe:	5e                   	pop    %esi
80104bff:	5d                   	pop    %ebp
80104c00:	c3                   	ret
80104c01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c08:	00 
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c10 <syscall>:
[SYS_getProcInfo] sys_getprocinfo
};

void
syscall(void)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	53                   	push   %ebx
80104c14:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c17:	e8 64 ed ff ff       	call   80103980 <myproc>
80104c1c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c1e:	8b 40 18             	mov    0x18(%eax),%eax
80104c21:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c24:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c27:	83 fa 17             	cmp    $0x17,%edx
80104c2a:	77 24                	ja     80104c50 <syscall+0x40>
80104c2c:	8b 14 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%edx
80104c33:	85 d2                	test   %edx,%edx
80104c35:	74 19                	je     80104c50 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c37:	ff d2                	call   *%edx
80104c39:	89 c2                	mov    %eax,%edx
80104c3b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c3e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c44:	c9                   	leave
80104c45:	c3                   	ret
80104c46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c4d:	00 
80104c4e:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104c50:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c51:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c54:	50                   	push   %eax
80104c55:	ff 73 10             	push   0x10(%ebx)
80104c58:	68 d1 76 10 80       	push   $0x801076d1
80104c5d:	e8 4e ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104c62:	8b 43 18             	mov    0x18(%ebx),%eax
80104c65:	83 c4 10             	add    $0x10,%esp
80104c68:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c72:	c9                   	leave
80104c73:	c3                   	ret
80104c74:	66 90                	xchg   %ax,%ax
80104c76:	66 90                	xchg   %ax,%ax
80104c78:	66 90                	xchg   %ax,%ax
80104c7a:	66 90                	xchg   %ax,%ax
80104c7c:	66 90                	xchg   %ax,%ax
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c85:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c88:	53                   	push   %ebx
80104c89:	83 ec 34             	sub    $0x34,%esp
80104c8c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c92:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c95:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c98:	57                   	push   %edi
80104c99:	50                   	push   %eax
80104c9a:	e8 01 d4 ff ff       	call   801020a0 <nameiparent>
80104c9f:	83 c4 10             	add    $0x10,%esp
80104ca2:	85 c0                	test   %eax,%eax
80104ca4:	74 5e                	je     80104d04 <create+0x84>
    return 0;
  ilock(dp);
80104ca6:	83 ec 0c             	sub    $0xc,%esp
80104ca9:	89 c3                	mov    %eax,%ebx
80104cab:	50                   	push   %eax
80104cac:	e8 ef ca ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cb1:	83 c4 0c             	add    $0xc,%esp
80104cb4:	6a 00                	push   $0x0
80104cb6:	57                   	push   %edi
80104cb7:	53                   	push   %ebx
80104cb8:	e8 33 d0 ff ff       	call   80101cf0 <dirlookup>
80104cbd:	83 c4 10             	add    $0x10,%esp
80104cc0:	89 c6                	mov    %eax,%esi
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	74 4a                	je     80104d10 <create+0x90>
    iunlockput(dp);
80104cc6:	83 ec 0c             	sub    $0xc,%esp
80104cc9:	53                   	push   %ebx
80104cca:	e8 61 cd ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104ccf:	89 34 24             	mov    %esi,(%esp)
80104cd2:	e8 c9 ca ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104cd7:	83 c4 10             	add    $0x10,%esp
80104cda:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104cdf:	75 17                	jne    80104cf8 <create+0x78>
80104ce1:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104ce6:	75 10                	jne    80104cf8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ceb:	89 f0                	mov    %esi,%eax
80104ced:	5b                   	pop    %ebx
80104cee:	5e                   	pop    %esi
80104cef:	5f                   	pop    %edi
80104cf0:	5d                   	pop    %ebp
80104cf1:	c3                   	ret
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104cf8:	83 ec 0c             	sub    $0xc,%esp
80104cfb:	56                   	push   %esi
80104cfc:	e8 2f cd ff ff       	call   80101a30 <iunlockput>
    return 0;
80104d01:	83 c4 10             	add    $0x10,%esp
}
80104d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d07:	31 f6                	xor    %esi,%esi
}
80104d09:	5b                   	pop    %ebx
80104d0a:	89 f0                	mov    %esi,%eax
80104d0c:	5e                   	pop    %esi
80104d0d:	5f                   	pop    %edi
80104d0e:	5d                   	pop    %ebp
80104d0f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104d10:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d14:	83 ec 08             	sub    $0x8,%esp
80104d17:	50                   	push   %eax
80104d18:	ff 33                	push   (%ebx)
80104d1a:	e8 11 c9 ff ff       	call   80101630 <ialloc>
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	89 c6                	mov    %eax,%esi
80104d24:	85 c0                	test   %eax,%eax
80104d26:	0f 84 bc 00 00 00    	je     80104de8 <create+0x168>
  ilock(ip);
80104d2c:	83 ec 0c             	sub    $0xc,%esp
80104d2f:	50                   	push   %eax
80104d30:	e8 6b ca ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104d35:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d39:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d3d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d41:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d45:	b8 01 00 00 00       	mov    $0x1,%eax
80104d4a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d4e:	89 34 24             	mov    %esi,(%esp)
80104d51:	e8 9a c9 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d5e:	74 30                	je     80104d90 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104d60:	83 ec 04             	sub    $0x4,%esp
80104d63:	ff 76 04             	push   0x4(%esi)
80104d66:	57                   	push   %edi
80104d67:	53                   	push   %ebx
80104d68:	e8 53 d2 ff ff       	call   80101fc0 <dirlink>
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	85 c0                	test   %eax,%eax
80104d72:	78 67                	js     80104ddb <create+0x15b>
  iunlockput(dp);
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	53                   	push   %ebx
80104d78:	e8 b3 cc ff ff       	call   80101a30 <iunlockput>
  return ip;
80104d7d:	83 c4 10             	add    $0x10,%esp
}
80104d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d83:	89 f0                	mov    %esi,%eax
80104d85:	5b                   	pop    %ebx
80104d86:	5e                   	pop    %esi
80104d87:	5f                   	pop    %edi
80104d88:	5d                   	pop    %ebp
80104d89:	c3                   	ret
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d90:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d93:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d98:	53                   	push   %ebx
80104d99:	e8 52 c9 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d9e:	83 c4 0c             	add    $0xc,%esp
80104da1:	ff 76 04             	push   0x4(%esi)
80104da4:	68 09 77 10 80       	push   $0x80107709
80104da9:	56                   	push   %esi
80104daa:	e8 11 d2 ff ff       	call   80101fc0 <dirlink>
80104daf:	83 c4 10             	add    $0x10,%esp
80104db2:	85 c0                	test   %eax,%eax
80104db4:	78 18                	js     80104dce <create+0x14e>
80104db6:	83 ec 04             	sub    $0x4,%esp
80104db9:	ff 73 04             	push   0x4(%ebx)
80104dbc:	68 08 77 10 80       	push   $0x80107708
80104dc1:	56                   	push   %esi
80104dc2:	e8 f9 d1 ff ff       	call   80101fc0 <dirlink>
80104dc7:	83 c4 10             	add    $0x10,%esp
80104dca:	85 c0                	test   %eax,%eax
80104dcc:	79 92                	jns    80104d60 <create+0xe0>
      panic("create dots");
80104dce:	83 ec 0c             	sub    $0xc,%esp
80104dd1:	68 fc 76 10 80       	push   $0x801076fc
80104dd6:	e8 a5 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104ddb:	83 ec 0c             	sub    $0xc,%esp
80104dde:	68 0b 77 10 80       	push   $0x8010770b
80104de3:	e8 98 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104de8:	83 ec 0c             	sub    $0xc,%esp
80104deb:	68 ed 76 10 80       	push   $0x801076ed
80104df0:	e8 8b b5 ff ff       	call   80100380 <panic>
80104df5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dfc:	00 
80104dfd:	8d 76 00             	lea    0x0(%esi),%esi

80104e00 <sys_dup>:
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e0b:	50                   	push   %eax
80104e0c:	6a 00                	push   $0x0
80104e0e:	e8 bd fc ff ff       	call   80104ad0 <argint>
80104e13:	83 c4 10             	add    $0x10,%esp
80104e16:	85 c0                	test   %eax,%eax
80104e18:	78 36                	js     80104e50 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e1e:	77 30                	ja     80104e50 <sys_dup+0x50>
80104e20:	e8 5b eb ff ff       	call   80103980 <myproc>
80104e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e2c:	85 f6                	test   %esi,%esi
80104e2e:	74 20                	je     80104e50 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e30:	e8 4b eb ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e35:	31 db                	xor    %ebx,%ebx
80104e37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e3e:	00 
80104e3f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104e40:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e44:	85 d2                	test   %edx,%edx
80104e46:	74 18                	je     80104e60 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104e48:	83 c3 01             	add    $0x1,%ebx
80104e4b:	83 fb 10             	cmp    $0x10,%ebx
80104e4e:	75 f0                	jne    80104e40 <sys_dup+0x40>
}
80104e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e53:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e58:	89 d8                	mov    %ebx,%eax
80104e5a:	5b                   	pop    %ebx
80104e5b:	5e                   	pop    %esi
80104e5c:	5d                   	pop    %ebp
80104e5d:	c3                   	ret
80104e5e:	66 90                	xchg   %ax,%ax
  filedup(f);
80104e60:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104e63:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e67:	56                   	push   %esi
80104e68:	e8 53 c0 ff ff       	call   80100ec0 <filedup>
  return fd;
80104e6d:	83 c4 10             	add    $0x10,%esp
}
80104e70:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e73:	89 d8                	mov    %ebx,%eax
80104e75:	5b                   	pop    %ebx
80104e76:	5e                   	pop    %esi
80104e77:	5d                   	pop    %ebp
80104e78:	c3                   	ret
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e80 <sys_read>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e85:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e8b:	53                   	push   %ebx
80104e8c:	6a 00                	push   $0x0
80104e8e:	e8 3d fc ff ff       	call   80104ad0 <argint>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 5e                	js     80104ef8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e9e:	77 58                	ja     80104ef8 <sys_read+0x78>
80104ea0:	e8 db ea ff ff       	call   80103980 <myproc>
80104ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ea8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104eac:	85 f6                	test   %esi,%esi
80104eae:	74 48                	je     80104ef8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104eb0:	83 ec 08             	sub    $0x8,%esp
80104eb3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104eb6:	50                   	push   %eax
80104eb7:	6a 02                	push   $0x2
80104eb9:	e8 12 fc ff ff       	call   80104ad0 <argint>
80104ebe:	83 c4 10             	add    $0x10,%esp
80104ec1:	85 c0                	test   %eax,%eax
80104ec3:	78 33                	js     80104ef8 <sys_read+0x78>
80104ec5:	83 ec 04             	sub    $0x4,%esp
80104ec8:	ff 75 f0             	push   -0x10(%ebp)
80104ecb:	53                   	push   %ebx
80104ecc:	6a 01                	push   $0x1
80104ece:	e8 4d fc ff ff       	call   80104b20 <argptr>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	78 1e                	js     80104ef8 <sys_read+0x78>
  return fileread(f, p, n);
80104eda:	83 ec 04             	sub    $0x4,%esp
80104edd:	ff 75 f0             	push   -0x10(%ebp)
80104ee0:	ff 75 f4             	push   -0xc(%ebp)
80104ee3:	56                   	push   %esi
80104ee4:	e8 57 c1 ff ff       	call   80101040 <fileread>
80104ee9:	83 c4 10             	add    $0x10,%esp
}
80104eec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eef:	5b                   	pop    %ebx
80104ef0:	5e                   	pop    %esi
80104ef1:	5d                   	pop    %ebp
80104ef2:	c3                   	ret
80104ef3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104efd:	eb ed                	jmp    80104eec <sys_read+0x6c>
80104eff:	90                   	nop

80104f00 <sys_write>:
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f05:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f08:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f0b:	53                   	push   %ebx
80104f0c:	6a 00                	push   $0x0
80104f0e:	e8 bd fb ff ff       	call   80104ad0 <argint>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	78 5e                	js     80104f78 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f1a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f1e:	77 58                	ja     80104f78 <sys_write+0x78>
80104f20:	e8 5b ea ff ff       	call   80103980 <myproc>
80104f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f28:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f2c:	85 f6                	test   %esi,%esi
80104f2e:	74 48                	je     80104f78 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f30:	83 ec 08             	sub    $0x8,%esp
80104f33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f36:	50                   	push   %eax
80104f37:	6a 02                	push   $0x2
80104f39:	e8 92 fb ff ff       	call   80104ad0 <argint>
80104f3e:	83 c4 10             	add    $0x10,%esp
80104f41:	85 c0                	test   %eax,%eax
80104f43:	78 33                	js     80104f78 <sys_write+0x78>
80104f45:	83 ec 04             	sub    $0x4,%esp
80104f48:	ff 75 f0             	push   -0x10(%ebp)
80104f4b:	53                   	push   %ebx
80104f4c:	6a 01                	push   $0x1
80104f4e:	e8 cd fb ff ff       	call   80104b20 <argptr>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 1e                	js     80104f78 <sys_write+0x78>
  return filewrite(f, p, n);
80104f5a:	83 ec 04             	sub    $0x4,%esp
80104f5d:	ff 75 f0             	push   -0x10(%ebp)
80104f60:	ff 75 f4             	push   -0xc(%ebp)
80104f63:	56                   	push   %esi
80104f64:	e8 67 c1 ff ff       	call   801010d0 <filewrite>
80104f69:	83 c4 10             	add    $0x10,%esp
}
80104f6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f6f:	5b                   	pop    %ebx
80104f70:	5e                   	pop    %esi
80104f71:	5d                   	pop    %ebp
80104f72:	c3                   	ret
80104f73:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f7d:	eb ed                	jmp    80104f6c <sys_write+0x6c>
80104f7f:	90                   	nop

80104f80 <sys_close>:
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f85:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f88:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f8b:	50                   	push   %eax
80104f8c:	6a 00                	push   $0x0
80104f8e:	e8 3d fb ff ff       	call   80104ad0 <argint>
80104f93:	83 c4 10             	add    $0x10,%esp
80104f96:	85 c0                	test   %eax,%eax
80104f98:	78 3e                	js     80104fd8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f9a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f9e:	77 38                	ja     80104fd8 <sys_close+0x58>
80104fa0:	e8 db e9 ff ff       	call   80103980 <myproc>
80104fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104fa8:	8d 5a 08             	lea    0x8(%edx),%ebx
80104fab:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104faf:	85 f6                	test   %esi,%esi
80104fb1:	74 25                	je     80104fd8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104fb3:	e8 c8 e9 ff ff       	call   80103980 <myproc>
  fileclose(f);
80104fb8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104fbb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104fc2:	00 
  fileclose(f);
80104fc3:	56                   	push   %esi
80104fc4:	e8 47 bf ff ff       	call   80100f10 <fileclose>
  return 0;
80104fc9:	83 c4 10             	add    $0x10,%esp
80104fcc:	31 c0                	xor    %eax,%eax
}
80104fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd1:	5b                   	pop    %ebx
80104fd2:	5e                   	pop    %esi
80104fd3:	5d                   	pop    %ebp
80104fd4:	c3                   	ret
80104fd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb ef                	jmp    80104fce <sys_close+0x4e>
80104fdf:	90                   	nop

80104fe0 <sys_fstat>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fe5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104feb:	53                   	push   %ebx
80104fec:	6a 00                	push   $0x0
80104fee:	e8 dd fa ff ff       	call   80104ad0 <argint>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 46                	js     80105040 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ffe:	77 40                	ja     80105040 <sys_fstat+0x60>
80105000:	e8 7b e9 ff ff       	call   80103980 <myproc>
80105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105008:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010500c:	85 f6                	test   %esi,%esi
8010500e:	74 30                	je     80105040 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105010:	83 ec 04             	sub    $0x4,%esp
80105013:	6a 14                	push   $0x14
80105015:	53                   	push   %ebx
80105016:	6a 01                	push   $0x1
80105018:	e8 03 fb ff ff       	call   80104b20 <argptr>
8010501d:	83 c4 10             	add    $0x10,%esp
80105020:	85 c0                	test   %eax,%eax
80105022:	78 1c                	js     80105040 <sys_fstat+0x60>
  return filestat(f, st);
80105024:	83 ec 08             	sub    $0x8,%esp
80105027:	ff 75 f4             	push   -0xc(%ebp)
8010502a:	56                   	push   %esi
8010502b:	e8 c0 bf ff ff       	call   80100ff0 <filestat>
80105030:	83 c4 10             	add    $0x10,%esp
}
80105033:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105036:	5b                   	pop    %ebx
80105037:	5e                   	pop    %esi
80105038:	5d                   	pop    %ebp
80105039:	c3                   	ret
8010503a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105045:	eb ec                	jmp    80105033 <sys_fstat+0x53>
80105047:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010504e:	00 
8010504f:	90                   	nop

80105050 <sys_link>:
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	57                   	push   %edi
80105054:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105055:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105058:	53                   	push   %ebx
80105059:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010505c:	50                   	push   %eax
8010505d:	6a 00                	push   $0x0
8010505f:	e8 2c fb ff ff       	call   80104b90 <argstr>
80105064:	83 c4 10             	add    $0x10,%esp
80105067:	85 c0                	test   %eax,%eax
80105069:	0f 88 fb 00 00 00    	js     8010516a <sys_link+0x11a>
8010506f:	83 ec 08             	sub    $0x8,%esp
80105072:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105075:	50                   	push   %eax
80105076:	6a 01                	push   $0x1
80105078:	e8 13 fb ff ff       	call   80104b90 <argstr>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	0f 88 e2 00 00 00    	js     8010516a <sys_link+0x11a>
  begin_op();
80105088:	e8 b3 dc ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
8010508d:	83 ec 0c             	sub    $0xc,%esp
80105090:	ff 75 d4             	push   -0x2c(%ebp)
80105093:	e8 e8 cf ff ff       	call   80102080 <namei>
80105098:	83 c4 10             	add    $0x10,%esp
8010509b:	89 c3                	mov    %eax,%ebx
8010509d:	85 c0                	test   %eax,%eax
8010509f:	0f 84 df 00 00 00    	je     80105184 <sys_link+0x134>
  ilock(ip);
801050a5:	83 ec 0c             	sub    $0xc,%esp
801050a8:	50                   	push   %eax
801050a9:	e8 f2 c6 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
801050ae:	83 c4 10             	add    $0x10,%esp
801050b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050b6:	0f 84 b5 00 00 00    	je     80105171 <sys_link+0x121>
  iupdate(ip);
801050bc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801050bf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801050c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801050c7:	53                   	push   %ebx
801050c8:	e8 23 c6 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
801050cd:	89 1c 24             	mov    %ebx,(%esp)
801050d0:	e8 ab c7 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050d5:	58                   	pop    %eax
801050d6:	5a                   	pop    %edx
801050d7:	57                   	push   %edi
801050d8:	ff 75 d0             	push   -0x30(%ebp)
801050db:	e8 c0 cf ff ff       	call   801020a0 <nameiparent>
801050e0:	83 c4 10             	add    $0x10,%esp
801050e3:	89 c6                	mov    %eax,%esi
801050e5:	85 c0                	test   %eax,%eax
801050e7:	74 5b                	je     80105144 <sys_link+0xf4>
  ilock(dp);
801050e9:	83 ec 0c             	sub    $0xc,%esp
801050ec:	50                   	push   %eax
801050ed:	e8 ae c6 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801050f2:	8b 03                	mov    (%ebx),%eax
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	39 06                	cmp    %eax,(%esi)
801050f9:	75 3d                	jne    80105138 <sys_link+0xe8>
801050fb:	83 ec 04             	sub    $0x4,%esp
801050fe:	ff 73 04             	push   0x4(%ebx)
80105101:	57                   	push   %edi
80105102:	56                   	push   %esi
80105103:	e8 b8 ce ff ff       	call   80101fc0 <dirlink>
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	85 c0                	test   %eax,%eax
8010510d:	78 29                	js     80105138 <sys_link+0xe8>
  iunlockput(dp);
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	56                   	push   %esi
80105113:	e8 18 c9 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80105118:	89 1c 24             	mov    %ebx,(%esp)
8010511b:	e8 b0 c7 ff ff       	call   801018d0 <iput>
  end_op();
80105120:	e8 8b dc ff ff       	call   80102db0 <end_op>
  return 0;
80105125:	83 c4 10             	add    $0x10,%esp
80105128:	31 c0                	xor    %eax,%eax
}
8010512a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010512d:	5b                   	pop    %ebx
8010512e:	5e                   	pop    %esi
8010512f:	5f                   	pop    %edi
80105130:	5d                   	pop    %ebp
80105131:	c3                   	ret
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105138:	83 ec 0c             	sub    $0xc,%esp
8010513b:	56                   	push   %esi
8010513c:	e8 ef c8 ff ff       	call   80101a30 <iunlockput>
    goto bad;
80105141:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	53                   	push   %ebx
80105148:	e8 53 c6 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
8010514d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105152:	89 1c 24             	mov    %ebx,(%esp)
80105155:	e8 96 c5 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
8010515a:	89 1c 24             	mov    %ebx,(%esp)
8010515d:	e8 ce c8 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105162:	e8 49 dc ff ff       	call   80102db0 <end_op>
  return -1;
80105167:	83 c4 10             	add    $0x10,%esp
    return -1;
8010516a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516f:	eb b9                	jmp    8010512a <sys_link+0xda>
    iunlockput(ip);
80105171:	83 ec 0c             	sub    $0xc,%esp
80105174:	53                   	push   %ebx
80105175:	e8 b6 c8 ff ff       	call   80101a30 <iunlockput>
    end_op();
8010517a:	e8 31 dc ff ff       	call   80102db0 <end_op>
    return -1;
8010517f:	83 c4 10             	add    $0x10,%esp
80105182:	eb e6                	jmp    8010516a <sys_link+0x11a>
    end_op();
80105184:	e8 27 dc ff ff       	call   80102db0 <end_op>
    return -1;
80105189:	eb df                	jmp    8010516a <sys_link+0x11a>
8010518b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105190 <sys_unlink>:
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	57                   	push   %edi
80105194:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105195:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105198:	53                   	push   %ebx
80105199:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010519c:	50                   	push   %eax
8010519d:	6a 00                	push   $0x0
8010519f:	e8 ec f9 ff ff       	call   80104b90 <argstr>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
801051a9:	0f 88 54 01 00 00    	js     80105303 <sys_unlink+0x173>
  begin_op();
801051af:	e8 8c db ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051b4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801051b7:	83 ec 08             	sub    $0x8,%esp
801051ba:	53                   	push   %ebx
801051bb:	ff 75 c0             	push   -0x40(%ebp)
801051be:	e8 dd ce ff ff       	call   801020a0 <nameiparent>
801051c3:	83 c4 10             	add    $0x10,%esp
801051c6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801051c9:	85 c0                	test   %eax,%eax
801051cb:	0f 84 58 01 00 00    	je     80105329 <sys_unlink+0x199>
  ilock(dp);
801051d1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801051d4:	83 ec 0c             	sub    $0xc,%esp
801051d7:	57                   	push   %edi
801051d8:	e8 c3 c5 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801051dd:	58                   	pop    %eax
801051de:	5a                   	pop    %edx
801051df:	68 09 77 10 80       	push   $0x80107709
801051e4:	53                   	push   %ebx
801051e5:	e8 e6 ca ff ff       	call   80101cd0 <namecmp>
801051ea:	83 c4 10             	add    $0x10,%esp
801051ed:	85 c0                	test   %eax,%eax
801051ef:	0f 84 fb 00 00 00    	je     801052f0 <sys_unlink+0x160>
801051f5:	83 ec 08             	sub    $0x8,%esp
801051f8:	68 08 77 10 80       	push   $0x80107708
801051fd:	53                   	push   %ebx
801051fe:	e8 cd ca ff ff       	call   80101cd0 <namecmp>
80105203:	83 c4 10             	add    $0x10,%esp
80105206:	85 c0                	test   %eax,%eax
80105208:	0f 84 e2 00 00 00    	je     801052f0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010520e:	83 ec 04             	sub    $0x4,%esp
80105211:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105214:	50                   	push   %eax
80105215:	53                   	push   %ebx
80105216:	57                   	push   %edi
80105217:	e8 d4 ca ff ff       	call   80101cf0 <dirlookup>
8010521c:	83 c4 10             	add    $0x10,%esp
8010521f:	89 c3                	mov    %eax,%ebx
80105221:	85 c0                	test   %eax,%eax
80105223:	0f 84 c7 00 00 00    	je     801052f0 <sys_unlink+0x160>
  ilock(ip);
80105229:	83 ec 0c             	sub    $0xc,%esp
8010522c:	50                   	push   %eax
8010522d:	e8 6e c5 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
80105232:	83 c4 10             	add    $0x10,%esp
80105235:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010523a:	0f 8e 0a 01 00 00    	jle    8010534a <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105240:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105245:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105248:	74 66                	je     801052b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010524a:	83 ec 04             	sub    $0x4,%esp
8010524d:	6a 10                	push   $0x10
8010524f:	6a 00                	push   $0x0
80105251:	57                   	push   %edi
80105252:	e8 c9 f5 ff ff       	call   80104820 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105257:	6a 10                	push   $0x10
80105259:	ff 75 c4             	push   -0x3c(%ebp)
8010525c:	57                   	push   %edi
8010525d:	ff 75 b4             	push   -0x4c(%ebp)
80105260:	e8 4b c9 ff ff       	call   80101bb0 <writei>
80105265:	83 c4 20             	add    $0x20,%esp
80105268:	83 f8 10             	cmp    $0x10,%eax
8010526b:	0f 85 cc 00 00 00    	jne    8010533d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
80105271:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105276:	0f 84 94 00 00 00    	je     80105310 <sys_unlink+0x180>
  iunlockput(dp);
8010527c:	83 ec 0c             	sub    $0xc,%esp
8010527f:	ff 75 b4             	push   -0x4c(%ebp)
80105282:	e8 a9 c7 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
80105287:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010528c:	89 1c 24             	mov    %ebx,(%esp)
8010528f:	e8 5c c4 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105294:	89 1c 24             	mov    %ebx,(%esp)
80105297:	e8 94 c7 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010529c:	e8 0f db ff ff       	call   80102db0 <end_op>
  return 0;
801052a1:	83 c4 10             	add    $0x10,%esp
801052a4:	31 c0                	xor    %eax,%eax
}
801052a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052a9:	5b                   	pop    %ebx
801052aa:	5e                   	pop    %esi
801052ab:	5f                   	pop    %edi
801052ac:	5d                   	pop    %ebp
801052ad:	c3                   	ret
801052ae:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052b4:	76 94                	jbe    8010524a <sys_unlink+0xba>
801052b6:	be 20 00 00 00       	mov    $0x20,%esi
801052bb:	eb 0b                	jmp    801052c8 <sys_unlink+0x138>
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
801052c0:	83 c6 10             	add    $0x10,%esi
801052c3:	3b 73 58             	cmp    0x58(%ebx),%esi
801052c6:	73 82                	jae    8010524a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052c8:	6a 10                	push   $0x10
801052ca:	56                   	push   %esi
801052cb:	57                   	push   %edi
801052cc:	53                   	push   %ebx
801052cd:	e8 de c7 ff ff       	call   80101ab0 <readi>
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	83 f8 10             	cmp    $0x10,%eax
801052d8:	75 56                	jne    80105330 <sys_unlink+0x1a0>
    if(de.inum != 0)
801052da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801052df:	74 df                	je     801052c0 <sys_unlink+0x130>
    iunlockput(ip);
801052e1:	83 ec 0c             	sub    $0xc,%esp
801052e4:	53                   	push   %ebx
801052e5:	e8 46 c7 ff ff       	call   80101a30 <iunlockput>
    goto bad;
801052ea:	83 c4 10             	add    $0x10,%esp
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	ff 75 b4             	push   -0x4c(%ebp)
801052f6:	e8 35 c7 ff ff       	call   80101a30 <iunlockput>
  end_op();
801052fb:	e8 b0 da ff ff       	call   80102db0 <end_op>
  return -1;
80105300:	83 c4 10             	add    $0x10,%esp
    return -1;
80105303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105308:	eb 9c                	jmp    801052a6 <sys_unlink+0x116>
8010530a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105310:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105313:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105316:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010531b:	50                   	push   %eax
8010531c:	e8 cf c3 ff ff       	call   801016f0 <iupdate>
80105321:	83 c4 10             	add    $0x10,%esp
80105324:	e9 53 ff ff ff       	jmp    8010527c <sys_unlink+0xec>
    end_op();
80105329:	e8 82 da ff ff       	call   80102db0 <end_op>
    return -1;
8010532e:	eb d3                	jmp    80105303 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	68 2d 77 10 80       	push   $0x8010772d
80105338:	e8 43 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010533d:	83 ec 0c             	sub    $0xc,%esp
80105340:	68 3f 77 10 80       	push   $0x8010773f
80105345:	e8 36 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010534a:	83 ec 0c             	sub    $0xc,%esp
8010534d:	68 1b 77 10 80       	push   $0x8010771b
80105352:	e8 29 b0 ff ff       	call   80100380 <panic>
80105357:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010535e:	00 
8010535f:	90                   	nop

80105360 <sys_open>:

int
sys_open(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105365:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105368:	53                   	push   %ebx
80105369:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010536c:	50                   	push   %eax
8010536d:	6a 00                	push   $0x0
8010536f:	e8 1c f8 ff ff       	call   80104b90 <argstr>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	0f 88 8e 00 00 00    	js     8010540d <sys_open+0xad>
8010537f:	83 ec 08             	sub    $0x8,%esp
80105382:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105385:	50                   	push   %eax
80105386:	6a 01                	push   $0x1
80105388:	e8 43 f7 ff ff       	call   80104ad0 <argint>
8010538d:	83 c4 10             	add    $0x10,%esp
80105390:	85 c0                	test   %eax,%eax
80105392:	78 79                	js     8010540d <sys_open+0xad>
    return -1;

  begin_op();
80105394:	e8 a7 d9 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
80105399:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010539d:	75 79                	jne    80105418 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	ff 75 e0             	push   -0x20(%ebp)
801053a5:	e8 d6 cc ff ff       	call   80102080 <namei>
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	89 c6                	mov    %eax,%esi
801053af:	85 c0                	test   %eax,%eax
801053b1:	0f 84 7e 00 00 00    	je     80105435 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801053b7:	83 ec 0c             	sub    $0xc,%esp
801053ba:	50                   	push   %eax
801053bb:	e8 e0 c3 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801053c0:	83 c4 10             	add    $0x10,%esp
801053c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801053c8:	0f 84 ba 00 00 00    	je     80105488 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801053ce:	e8 7d ba ff ff       	call   80100e50 <filealloc>
801053d3:	89 c7                	mov    %eax,%edi
801053d5:	85 c0                	test   %eax,%eax
801053d7:	74 23                	je     801053fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801053d9:	e8 a2 e5 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801053de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801053e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801053e4:	85 d2                	test   %edx,%edx
801053e6:	74 58                	je     80105440 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
801053e8:	83 c3 01             	add    $0x1,%ebx
801053eb:	83 fb 10             	cmp    $0x10,%ebx
801053ee:	75 f0                	jne    801053e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	57                   	push   %edi
801053f4:	e8 17 bb ff ff       	call   80100f10 <fileclose>
801053f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	56                   	push   %esi
80105400:	e8 2b c6 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105405:	e8 a6 d9 ff ff       	call   80102db0 <end_op>
    return -1;
8010540a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010540d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105412:	eb 65                	jmp    80105479 <sys_open+0x119>
80105414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105418:	83 ec 0c             	sub    $0xc,%esp
8010541b:	31 c9                	xor    %ecx,%ecx
8010541d:	ba 02 00 00 00       	mov    $0x2,%edx
80105422:	6a 00                	push   $0x0
80105424:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105427:	e8 54 f8 ff ff       	call   80104c80 <create>
    if(ip == 0){
8010542c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010542f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105431:	85 c0                	test   %eax,%eax
80105433:	75 99                	jne    801053ce <sys_open+0x6e>
      end_op();
80105435:	e8 76 d9 ff ff       	call   80102db0 <end_op>
      return -1;
8010543a:	eb d1                	jmp    8010540d <sys_open+0xad>
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105440:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105443:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105447:	56                   	push   %esi
80105448:	e8 33 c4 ff ff       	call   80101880 <iunlock>
  end_op();
8010544d:	e8 5e d9 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
80105452:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105458:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010545b:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
8010545e:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105461:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105463:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010546a:	f7 d0                	not    %eax
8010546c:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010546f:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105472:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105475:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105479:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010547c:	89 d8                	mov    %ebx,%eax
8010547e:	5b                   	pop    %ebx
8010547f:	5e                   	pop    %esi
80105480:	5f                   	pop    %edi
80105481:	5d                   	pop    %ebp
80105482:	c3                   	ret
80105483:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105488:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010548b:	85 c9                	test   %ecx,%ecx
8010548d:	0f 84 3b ff ff ff    	je     801053ce <sys_open+0x6e>
80105493:	e9 64 ff ff ff       	jmp    801053fc <sys_open+0x9c>
80105498:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010549f:	00 

801054a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054a6:	e8 95 d8 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054ab:	83 ec 08             	sub    $0x8,%esp
801054ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054b1:	50                   	push   %eax
801054b2:	6a 00                	push   $0x0
801054b4:	e8 d7 f6 ff ff       	call   80104b90 <argstr>
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	85 c0                	test   %eax,%eax
801054be:	78 30                	js     801054f0 <sys_mkdir+0x50>
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054c6:	31 c9                	xor    %ecx,%ecx
801054c8:	ba 01 00 00 00       	mov    $0x1,%edx
801054cd:	6a 00                	push   $0x0
801054cf:	e8 ac f7 ff ff       	call   80104c80 <create>
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	85 c0                	test   %eax,%eax
801054d9:	74 15                	je     801054f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054db:	83 ec 0c             	sub    $0xc,%esp
801054de:	50                   	push   %eax
801054df:	e8 4c c5 ff ff       	call   80101a30 <iunlockput>
  end_op();
801054e4:	e8 c7 d8 ff ff       	call   80102db0 <end_op>
  return 0;
801054e9:	83 c4 10             	add    $0x10,%esp
801054ec:	31 c0                	xor    %eax,%eax
}
801054ee:	c9                   	leave
801054ef:	c3                   	ret
    end_op();
801054f0:	e8 bb d8 ff ff       	call   80102db0 <end_op>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fa:	c9                   	leave
801054fb:	c3                   	ret
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_mknod>:

int
sys_mknod(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105506:	e8 35 d8 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010550b:	83 ec 08             	sub    $0x8,%esp
8010550e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105511:	50                   	push   %eax
80105512:	6a 00                	push   $0x0
80105514:	e8 77 f6 ff ff       	call   80104b90 <argstr>
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	85 c0                	test   %eax,%eax
8010551e:	78 60                	js     80105580 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105520:	83 ec 08             	sub    $0x8,%esp
80105523:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105526:	50                   	push   %eax
80105527:	6a 01                	push   $0x1
80105529:	e8 a2 f5 ff ff       	call   80104ad0 <argint>
  if((argstr(0, &path)) < 0 ||
8010552e:	83 c4 10             	add    $0x10,%esp
80105531:	85 c0                	test   %eax,%eax
80105533:	78 4b                	js     80105580 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105535:	83 ec 08             	sub    $0x8,%esp
80105538:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553b:	50                   	push   %eax
8010553c:	6a 02                	push   $0x2
8010553e:	e8 8d f5 ff ff       	call   80104ad0 <argint>
     argint(1, &major) < 0 ||
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	78 36                	js     80105580 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010554a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010554e:	83 ec 0c             	sub    $0xc,%esp
80105551:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105555:	ba 03 00 00 00       	mov    $0x3,%edx
8010555a:	50                   	push   %eax
8010555b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010555e:	e8 1d f7 ff ff       	call   80104c80 <create>
     argint(2, &minor) < 0 ||
80105563:	83 c4 10             	add    $0x10,%esp
80105566:	85 c0                	test   %eax,%eax
80105568:	74 16                	je     80105580 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010556a:	83 ec 0c             	sub    $0xc,%esp
8010556d:	50                   	push   %eax
8010556e:	e8 bd c4 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105573:	e8 38 d8 ff ff       	call   80102db0 <end_op>
  return 0;
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	31 c0                	xor    %eax,%eax
}
8010557d:	c9                   	leave
8010557e:	c3                   	ret
8010557f:	90                   	nop
    end_op();
80105580:	e8 2b d8 ff ff       	call   80102db0 <end_op>
    return -1;
80105585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010558a:	c9                   	leave
8010558b:	c3                   	ret
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_chdir>:

int
sys_chdir(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	56                   	push   %esi
80105594:	53                   	push   %ebx
80105595:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105598:	e8 e3 e3 ff ff       	call   80103980 <myproc>
8010559d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010559f:	e8 9c d7 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801055a4:	83 ec 08             	sub    $0x8,%esp
801055a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055aa:	50                   	push   %eax
801055ab:	6a 00                	push   $0x0
801055ad:	e8 de f5 ff ff       	call   80104b90 <argstr>
801055b2:	83 c4 10             	add    $0x10,%esp
801055b5:	85 c0                	test   %eax,%eax
801055b7:	78 77                	js     80105630 <sys_chdir+0xa0>
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	ff 75 f4             	push   -0xc(%ebp)
801055bf:	e8 bc ca ff ff       	call   80102080 <namei>
801055c4:	83 c4 10             	add    $0x10,%esp
801055c7:	89 c3                	mov    %eax,%ebx
801055c9:	85 c0                	test   %eax,%eax
801055cb:	74 63                	je     80105630 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801055cd:	83 ec 0c             	sub    $0xc,%esp
801055d0:	50                   	push   %eax
801055d1:	e8 ca c1 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055de:	75 30                	jne    80105610 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	53                   	push   %ebx
801055e4:	e8 97 c2 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
801055e9:	58                   	pop    %eax
801055ea:	ff 76 68             	push   0x68(%esi)
801055ed:	e8 de c2 ff ff       	call   801018d0 <iput>
  end_op();
801055f2:	e8 b9 d7 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
801055f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055fa:	83 c4 10             	add    $0x10,%esp
801055fd:	31 c0                	xor    %eax,%eax
}
801055ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105602:	5b                   	pop    %ebx
80105603:	5e                   	pop    %esi
80105604:	5d                   	pop    %ebp
80105605:	c3                   	ret
80105606:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010560d:	00 
8010560e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	53                   	push   %ebx
80105614:	e8 17 c4 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105619:	e8 92 d7 ff ff       	call   80102db0 <end_op>
    return -1;
8010561e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105626:	eb d7                	jmp    801055ff <sys_chdir+0x6f>
80105628:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010562f:	00 
    end_op();
80105630:	e8 7b d7 ff ff       	call   80102db0 <end_op>
    return -1;
80105635:	eb ea                	jmp    80105621 <sys_chdir+0x91>
80105637:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010563e:	00 
8010563f:	90                   	nop

80105640 <sys_exec>:

int
sys_exec(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105645:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010564b:	53                   	push   %ebx
8010564c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105652:	50                   	push   %eax
80105653:	6a 00                	push   $0x0
80105655:	e8 36 f5 ff ff       	call   80104b90 <argstr>
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	85 c0                	test   %eax,%eax
8010565f:	0f 88 87 00 00 00    	js     801056ec <sys_exec+0xac>
80105665:	83 ec 08             	sub    $0x8,%esp
80105668:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010566e:	50                   	push   %eax
8010566f:	6a 01                	push   $0x1
80105671:	e8 5a f4 ff ff       	call   80104ad0 <argint>
80105676:	83 c4 10             	add    $0x10,%esp
80105679:	85 c0                	test   %eax,%eax
8010567b:	78 6f                	js     801056ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010567d:	83 ec 04             	sub    $0x4,%esp
80105680:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105686:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105688:	68 80 00 00 00       	push   $0x80
8010568d:	6a 00                	push   $0x0
8010568f:	56                   	push   %esi
80105690:	e8 8b f1 ff ff       	call   80104820 <memset>
80105695:	83 c4 10             	add    $0x10,%esp
80105698:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010569f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801056a0:	83 ec 08             	sub    $0x8,%esp
801056a3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801056a9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801056b0:	50                   	push   %eax
801056b1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801056b7:	01 f8                	add    %edi,%eax
801056b9:	50                   	push   %eax
801056ba:	e8 81 f3 ff ff       	call   80104a40 <fetchint>
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	85 c0                	test   %eax,%eax
801056c4:	78 26                	js     801056ec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801056c6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801056cc:	85 c0                	test   %eax,%eax
801056ce:	74 30                	je     80105700 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801056d0:	83 ec 08             	sub    $0x8,%esp
801056d3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801056d6:	52                   	push   %edx
801056d7:	50                   	push   %eax
801056d8:	e8 a3 f3 ff ff       	call   80104a80 <fetchstr>
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	85 c0                	test   %eax,%eax
801056e2:	78 08                	js     801056ec <sys_exec+0xac>
  for(i=0;; i++){
801056e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056e7:	83 fb 20             	cmp    $0x20,%ebx
801056ea:	75 b4                	jne    801056a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801056ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f4:	5b                   	pop    %ebx
801056f5:	5e                   	pop    %esi
801056f6:	5f                   	pop    %edi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105700:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105707:	00 00 00 00 
  return exec(path, argv);
8010570b:	83 ec 08             	sub    $0x8,%esp
8010570e:	56                   	push   %esi
8010570f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105715:	e8 96 b3 ff ff       	call   80100ab0 <exec>
8010571a:	83 c4 10             	add    $0x10,%esp
}
8010571d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105720:	5b                   	pop    %ebx
80105721:	5e                   	pop    %esi
80105722:	5f                   	pop    %edi
80105723:	5d                   	pop    %ebp
80105724:	c3                   	ret
80105725:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010572c:	00 
8010572d:	8d 76 00             	lea    0x0(%esi),%esi

80105730 <sys_pipe>:

int
sys_pipe(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	57                   	push   %edi
80105734:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105735:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105738:	53                   	push   %ebx
80105739:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010573c:	6a 08                	push   $0x8
8010573e:	50                   	push   %eax
8010573f:	6a 00                	push   $0x0
80105741:	e8 da f3 ff ff       	call   80104b20 <argptr>
80105746:	83 c4 10             	add    $0x10,%esp
80105749:	85 c0                	test   %eax,%eax
8010574b:	0f 88 8b 00 00 00    	js     801057dc <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105751:	83 ec 08             	sub    $0x8,%esp
80105754:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105757:	50                   	push   %eax
80105758:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010575b:	50                   	push   %eax
8010575c:	e8 af dc ff ff       	call   80103410 <pipealloc>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	85 c0                	test   %eax,%eax
80105766:	78 74                	js     801057dc <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105768:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010576b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010576d:	e8 0e e2 ff ff       	call   80103980 <myproc>
    if(curproc->ofile[fd] == 0){
80105772:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105776:	85 f6                	test   %esi,%esi
80105778:	74 16                	je     80105790 <sys_pipe+0x60>
8010577a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105780:	83 c3 01             	add    $0x1,%ebx
80105783:	83 fb 10             	cmp    $0x10,%ebx
80105786:	74 3d                	je     801057c5 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
80105788:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010578c:	85 f6                	test   %esi,%esi
8010578e:	75 f0                	jne    80105780 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105790:	8d 73 08             	lea    0x8(%ebx),%esi
80105793:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105797:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010579a:	e8 e1 e1 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010579f:	31 d2                	xor    %edx,%edx
801057a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801057a8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801057ac:	85 c9                	test   %ecx,%ecx
801057ae:	74 38                	je     801057e8 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
801057b0:	83 c2 01             	add    $0x1,%edx
801057b3:	83 fa 10             	cmp    $0x10,%edx
801057b6:	75 f0                	jne    801057a8 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801057b8:	e8 c3 e1 ff ff       	call   80103980 <myproc>
801057bd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801057c4:	00 
    fileclose(rf);
801057c5:	83 ec 0c             	sub    $0xc,%esp
801057c8:	ff 75 e0             	push   -0x20(%ebp)
801057cb:	e8 40 b7 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
801057d0:	58                   	pop    %eax
801057d1:	ff 75 e4             	push   -0x1c(%ebp)
801057d4:	e8 37 b7 ff ff       	call   80100f10 <fileclose>
    return -1;
801057d9:	83 c4 10             	add    $0x10,%esp
    return -1;
801057dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e1:	eb 16                	jmp    801057f9 <sys_pipe+0xc9>
801057e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801057e8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057ef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057f4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057f7:	31 c0                	xor    %eax,%eax
}
801057f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057fc:	5b                   	pop    %ebx
801057fd:	5e                   	pop    %esi
801057fe:	5f                   	pop    %edi
801057ff:	5d                   	pop    %ebp
80105800:	c3                   	ret
80105801:	66 90                	xchg   %ax,%ax
80105803:	66 90                	xchg   %ax,%ax
80105805:	66 90                	xchg   %ax,%ax
80105807:	66 90                	xchg   %ax,%ax
80105809:	66 90                	xchg   %ax,%ax
8010580b:	66 90                	xchg   %ax,%ax
8010580d:	66 90                	xchg   %ax,%ax
8010580f:	90                   	nop

80105810 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105810:	e9 0b e3 ff ff       	jmp    80103b20 <fork>
80105815:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010581c:	00 
8010581d:	8d 76 00             	lea    0x0(%esi),%esi

80105820 <sys_exit>:
}

int
sys_exit(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	83 ec 08             	sub    $0x8,%esp
  exit();
80105826:	e8 75 e5 ff ff       	call   80103da0 <exit>
  return 0;  // not reached
}
8010582b:	31 c0                	xor    %eax,%eax
8010582d:	c9                   	leave
8010582e:	c3                   	ret
8010582f:	90                   	nop

80105830 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105830:	e9 ab e6 ff ff       	jmp    80103ee0 <wait>
80105835:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010583c:	00 
8010583d:	8d 76 00             	lea    0x0(%esi),%esi

80105840 <sys_kill>:
}

int
sys_kill(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105846:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105849:	50                   	push   %eax
8010584a:	6a 00                	push   $0x0
8010584c:	e8 7f f2 ff ff       	call   80104ad0 <argint>
80105851:	83 c4 10             	add    $0x10,%esp
80105854:	85 c0                	test   %eax,%eax
80105856:	78 18                	js     80105870 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105858:	83 ec 0c             	sub    $0xc,%esp
8010585b:	ff 75 f4             	push   -0xc(%ebp)
8010585e:	e8 1d e9 ff ff       	call   80104180 <kill>
80105863:	83 c4 10             	add    $0x10,%esp
}
80105866:	c9                   	leave
80105867:	c3                   	ret
80105868:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010586f:	00 
80105870:	c9                   	leave
    return -1;
80105871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105876:	c3                   	ret
80105877:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010587e:	00 
8010587f:	90                   	nop

80105880 <sys_getpid>:

int
sys_getpid(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105886:	e8 f5 e0 ff ff       	call   80103980 <myproc>
8010588b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010588e:	c9                   	leave
8010588f:	c3                   	ret

80105890 <sys_sbrk>:

int
sys_sbrk(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105894:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105897:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010589a:	50                   	push   %eax
8010589b:	6a 00                	push   $0x0
8010589d:	e8 2e f2 ff ff       	call   80104ad0 <argint>
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	85 c0                	test   %eax,%eax
801058a7:	78 27                	js     801058d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801058a9:	e8 d2 e0 ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
801058ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801058b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801058b3:	ff 75 f4             	push   -0xc(%ebp)
801058b6:	e8 e5 e1 ff ff       	call   80103aa0 <growproc>
801058bb:	83 c4 10             	add    $0x10,%esp
801058be:	85 c0                	test   %eax,%eax
801058c0:	78 0e                	js     801058d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801058c2:	89 d8                	mov    %ebx,%eax
801058c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c7:	c9                   	leave
801058c8:	c3                   	ret
801058c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058d5:	eb eb                	jmp    801058c2 <sys_sbrk+0x32>
801058d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058de:	00 
801058df:	90                   	nop

801058e0 <sys_sleep>:

int
sys_sleep(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ea:	50                   	push   %eax
801058eb:	6a 00                	push   $0x0
801058ed:	e8 de f1 ff ff       	call   80104ad0 <argint>
801058f2:	83 c4 10             	add    $0x10,%esp
801058f5:	85 c0                	test   %eax,%eax
801058f7:	78 64                	js     8010595d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
801058f9:	83 ec 0c             	sub    $0xc,%esp
801058fc:	68 80 3e 11 80       	push   $0x80113e80
80105901:	e8 1a ee ff ff       	call   80104720 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105906:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105909:	8b 1d 60 3e 11 80    	mov    0x80113e60,%ebx
  while(ticks - ticks0 < n){
8010590f:	83 c4 10             	add    $0x10,%esp
80105912:	85 d2                	test   %edx,%edx
80105914:	75 2b                	jne    80105941 <sys_sleep+0x61>
80105916:	eb 58                	jmp    80105970 <sys_sleep+0x90>
80105918:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010591f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105920:	83 ec 08             	sub    $0x8,%esp
80105923:	68 80 3e 11 80       	push   $0x80113e80
80105928:	68 60 3e 11 80       	push   $0x80113e60
8010592d:	e8 2e e7 ff ff       	call   80104060 <sleep>
  while(ticks - ticks0 < n){
80105932:	a1 60 3e 11 80       	mov    0x80113e60,%eax
80105937:	83 c4 10             	add    $0x10,%esp
8010593a:	29 d8                	sub    %ebx,%eax
8010593c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010593f:	73 2f                	jae    80105970 <sys_sleep+0x90>
    if(myproc()->killed){
80105941:	e8 3a e0 ff ff       	call   80103980 <myproc>
80105946:	8b 40 24             	mov    0x24(%eax),%eax
80105949:	85 c0                	test   %eax,%eax
8010594b:	74 d3                	je     80105920 <sys_sleep+0x40>
      release(&tickslock);
8010594d:	83 ec 0c             	sub    $0xc,%esp
80105950:	68 80 3e 11 80       	push   $0x80113e80
80105955:	e8 66 ed ff ff       	call   801046c0 <release>
      return -1;
8010595a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010595d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105965:	c9                   	leave
80105966:	c3                   	ret
80105967:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010596e:	00 
8010596f:	90                   	nop
  release(&tickslock);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	68 80 3e 11 80       	push   $0x80113e80
80105978:	e8 43 ed ff ff       	call   801046c0 <release>
}
8010597d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
80105980:	83 c4 10             	add    $0x10,%esp
80105983:	31 c0                	xor    %eax,%eax
}
80105985:	c9                   	leave
80105986:	c3                   	ret
80105987:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010598e:	00 
8010598f:	90                   	nop

80105990 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	53                   	push   %ebx
80105994:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105997:	68 80 3e 11 80       	push   $0x80113e80
8010599c:	e8 7f ed ff ff       	call   80104720 <acquire>
  xticks = ticks;
801059a1:	8b 1d 60 3e 11 80    	mov    0x80113e60,%ebx
  release(&tickslock);
801059a7:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
801059ae:	e8 0d ed ff ff       	call   801046c0 <release>
  return xticks;
}
801059b3:	89 d8                	mov    %ebx,%eax
801059b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059b8:	c9                   	leave
801059b9:	c3                   	ret
801059ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059c0 <sys_getnumproc>:

int 
sys_getnumproc(void){
  return getNumProc();
801059c0:	e9 fb e8 ff ff       	jmp    801042c0 <getNumProc>
801059c5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059cc:	00 
801059cd:	8d 76 00             	lea    0x0(%esi),%esi

801059d0 <sys_getmaxpid>:
}

int
sys_getmaxpid(void){
  return getMaxPid();
801059d0:	e9 3b e9 ff ff       	jmp    80104310 <getMaxPid>
801059d5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059dc:	00 
801059dd:	8d 76 00             	lea    0x0(%esi),%esi

801059e0 <sys_getprocinfo>:
}

int
sys_getprocinfo(void) {
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	53                   	push   %ebx
  int pid;
  struct processInfo proc_info;

  if(argint(0, &pid) < 0)
801059e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
sys_getprocinfo(void) {
801059e7:	83 ec 2c             	sub    $0x2c,%esp
  if(argint(0, &pid) < 0)
801059ea:	50                   	push   %eax
801059eb:	6a 00                	push   $0x0
801059ed:	e8 de f0 ff ff       	call   80104ad0 <argint>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 37                	js     80105a30 <sys_getprocinfo+0x50>
    return -1;

  if(getProcInfo(pid, &proc_info) < 0)
801059f9:	83 ec 08             	sub    $0x8,%esp
801059fc:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
801059ff:	53                   	push   %ebx
80105a00:	ff 75 e0             	push   -0x20(%ebp)
80105a03:	e8 58 e9 ff ff       	call   80104360 <getProcInfo>
80105a08:	83 c4 10             	add    $0x10,%esp
80105a0b:	85 c0                	test   %eax,%eax
80105a0d:	78 21                	js     80105a30 <sys_getprocinfo+0x50>
    return -1;

  if(argptr(1, (void*)&proc_info, sizeof(proc_info)) < 0)
80105a0f:	83 ec 04             	sub    $0x4,%esp
80105a12:	6a 14                	push   $0x14
80105a14:	53                   	push   %ebx
80105a15:	6a 01                	push   $0x1
80105a17:	e8 04 f1 ff ff       	call   80104b20 <argptr>
80105a1c:	83 c4 10             	add    $0x10,%esp
80105a1f:	c1 f8 1f             	sar    $0x1f,%eax
    return -1;

  return 0;
}
80105a22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a25:	c9                   	leave
80105a26:	c3                   	ret
80105a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a2e:	00 
80105a2f:	90                   	nop
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a35:	eb eb                	jmp    80105a22 <sys_getprocinfo+0x42>

80105a37 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a37:	1e                   	push   %ds
  pushl %es
80105a38:	06                   	push   %es
  pushl %fs
80105a39:	0f a0                	push   %fs
  pushl %gs
80105a3b:	0f a8                	push   %gs
  pushal
80105a3d:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a3e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a42:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a44:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a46:	54                   	push   %esp
  call trap
80105a47:	e8 c4 00 00 00       	call   80105b10 <trap>
  addl $4, %esp
80105a4c:	83 c4 04             	add    $0x4,%esp

80105a4f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a4f:	61                   	popa
  popl %gs
80105a50:	0f a9                	pop    %gs
  popl %fs
80105a52:	0f a1                	pop    %fs
  popl %es
80105a54:	07                   	pop    %es
  popl %ds
80105a55:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a56:	83 c4 08             	add    $0x8,%esp
  iret
80105a59:	cf                   	iret
80105a5a:	66 90                	xchg   %ax,%ax
80105a5c:	66 90                	xchg   %ax,%ax
80105a5e:	66 90                	xchg   %ax,%ax

80105a60 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a60:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a61:	31 c0                	xor    %eax,%eax
{
80105a63:	89 e5                	mov    %esp,%ebp
80105a65:	83 ec 08             	sub    $0x8,%esp
80105a68:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a6f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a70:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a77:	c7 04 c5 c2 3e 11 80 	movl   $0x8e000008,-0x7feec13e(,%eax,8)
80105a7e:	08 00 00 8e 
80105a82:	66 89 14 c5 c0 3e 11 	mov    %dx,-0x7feec140(,%eax,8)
80105a89:	80 
80105a8a:	c1 ea 10             	shr    $0x10,%edx
80105a8d:	66 89 14 c5 c6 3e 11 	mov    %dx,-0x7feec13a(,%eax,8)
80105a94:	80 
  for(i = 0; i < 256; i++)
80105a95:	83 c0 01             	add    $0x1,%eax
80105a98:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a9d:	75 d1                	jne    80105a70 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105a9f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105aa2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105aa7:	c7 05 c2 40 11 80 08 	movl   $0xef000008,0x801140c2
80105aae:	00 00 ef 
  initlock(&tickslock, "time");
80105ab1:	68 4e 77 10 80       	push   $0x8010774e
80105ab6:	68 80 3e 11 80       	push   $0x80113e80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105abb:	66 a3 c0 40 11 80    	mov    %ax,0x801140c0
80105ac1:	c1 e8 10             	shr    $0x10,%eax
80105ac4:	66 a3 c6 40 11 80    	mov    %ax,0x801140c6
  initlock(&tickslock, "time");
80105aca:	e8 61 ea ff ff       	call   80104530 <initlock>
}
80105acf:	83 c4 10             	add    $0x10,%esp
80105ad2:	c9                   	leave
80105ad3:	c3                   	ret
80105ad4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105adb:	00 
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <idtinit>:

void
idtinit(void)
{
80105ae0:	55                   	push   %ebp
  pd[0] = size-1;
80105ae1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ae6:	89 e5                	mov    %esp,%ebp
80105ae8:	83 ec 10             	sub    $0x10,%esp
80105aeb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105aef:	b8 c0 3e 11 80       	mov    $0x80113ec0,%eax
80105af4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105af8:	c1 e8 10             	shr    $0x10,%eax
80105afb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105aff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b02:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b05:	c9                   	leave
80105b06:	c3                   	ret
80105b07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b0e:	00 
80105b0f:	90                   	nop

80105b10 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	56                   	push   %esi
80105b15:	53                   	push   %ebx
80105b16:	83 ec 1c             	sub    $0x1c,%esp
80105b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b1c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b1f:	83 f8 40             	cmp    $0x40,%eax
80105b22:	0f 84 58 01 00 00    	je     80105c80 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b28:	83 e8 20             	sub    $0x20,%eax
80105b2b:	83 f8 1f             	cmp    $0x1f,%eax
80105b2e:	0f 87 7c 00 00 00    	ja     80105bb0 <trap+0xa0>
80105b34:	ff 24 85 c4 7c 10 80 	jmp    *-0x7fef833c(,%eax,4)
80105b3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105b40:	e8 eb c6 ff ff       	call   80102230 <ideintr>
    lapiceoi();
80105b45:	e8 a6 cd ff ff       	call   801028f0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b4a:	e8 31 de ff ff       	call   80103980 <myproc>
80105b4f:	85 c0                	test   %eax,%eax
80105b51:	74 1a                	je     80105b6d <trap+0x5d>
80105b53:	e8 28 de ff ff       	call   80103980 <myproc>
80105b58:	8b 50 24             	mov    0x24(%eax),%edx
80105b5b:	85 d2                	test   %edx,%edx
80105b5d:	74 0e                	je     80105b6d <trap+0x5d>
80105b5f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b63:	f7 d0                	not    %eax
80105b65:	a8 03                	test   $0x3,%al
80105b67:	0f 84 db 01 00 00    	je     80105d48 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b6d:	e8 0e de ff ff       	call   80103980 <myproc>
80105b72:	85 c0                	test   %eax,%eax
80105b74:	74 0f                	je     80105b85 <trap+0x75>
80105b76:	e8 05 de ff ff       	call   80103980 <myproc>
80105b7b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b7f:	0f 84 ab 00 00 00    	je     80105c30 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b85:	e8 f6 dd ff ff       	call   80103980 <myproc>
80105b8a:	85 c0                	test   %eax,%eax
80105b8c:	74 1a                	je     80105ba8 <trap+0x98>
80105b8e:	e8 ed dd ff ff       	call   80103980 <myproc>
80105b93:	8b 40 24             	mov    0x24(%eax),%eax
80105b96:	85 c0                	test   %eax,%eax
80105b98:	74 0e                	je     80105ba8 <trap+0x98>
80105b9a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b9e:	f7 d0                	not    %eax
80105ba0:	a8 03                	test   $0x3,%al
80105ba2:	0f 84 05 01 00 00    	je     80105cad <trap+0x19d>
    exit();
}
80105ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bab:	5b                   	pop    %ebx
80105bac:	5e                   	pop    %esi
80105bad:	5f                   	pop    %edi
80105bae:	5d                   	pop    %ebp
80105baf:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105bb0:	e8 cb dd ff ff       	call   80103980 <myproc>
80105bb5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bb8:	85 c0                	test   %eax,%eax
80105bba:	0f 84 a2 01 00 00    	je     80105d62 <trap+0x252>
80105bc0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105bc4:	0f 84 98 01 00 00    	je     80105d62 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105bca:	0f 20 d1             	mov    %cr2,%ecx
80105bcd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bd0:	e8 8b dd ff ff       	call   80103960 <cpuid>
80105bd5:	8b 73 30             	mov    0x30(%ebx),%esi
80105bd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105bdb:	8b 43 34             	mov    0x34(%ebx),%eax
80105bde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105be1:	e8 9a dd ff ff       	call   80103980 <myproc>
80105be6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105be9:	e8 92 dd ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105bf1:	51                   	push   %ecx
80105bf2:	57                   	push   %edi
80105bf3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105bf6:	52                   	push   %edx
80105bf7:	ff 75 e4             	push   -0x1c(%ebp)
80105bfa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105bfb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105bfe:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c01:	56                   	push   %esi
80105c02:	ff 70 10             	push   0x10(%eax)
80105c05:	68 9c 79 10 80       	push   $0x8010799c
80105c0a:	e8 a1 aa ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105c0f:	83 c4 20             	add    $0x20,%esp
80105c12:	e8 69 dd ff ff       	call   80103980 <myproc>
80105c17:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c1e:	e8 5d dd ff ff       	call   80103980 <myproc>
80105c23:	85 c0                	test   %eax,%eax
80105c25:	0f 85 28 ff ff ff    	jne    80105b53 <trap+0x43>
80105c2b:	e9 3d ff ff ff       	jmp    80105b6d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105c30:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c34:	0f 85 4b ff ff ff    	jne    80105b85 <trap+0x75>
    yield();
80105c3a:	e8 d1 e3 ff ff       	call   80104010 <yield>
80105c3f:	e9 41 ff ff ff       	jmp    80105b85 <trap+0x75>
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c48:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c4b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105c4f:	e8 0c dd ff ff       	call   80103960 <cpuid>
80105c54:	57                   	push   %edi
80105c55:	56                   	push   %esi
80105c56:	50                   	push   %eax
80105c57:	68 44 79 10 80       	push   $0x80107944
80105c5c:	e8 4f aa ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105c61:	e8 8a cc ff ff       	call   801028f0 <lapiceoi>
    break;
80105c66:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c69:	e8 12 dd ff ff       	call   80103980 <myproc>
80105c6e:	85 c0                	test   %eax,%eax
80105c70:	0f 85 dd fe ff ff    	jne    80105b53 <trap+0x43>
80105c76:	e9 f2 fe ff ff       	jmp    80105b6d <trap+0x5d>
80105c7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105c80:	e8 fb dc ff ff       	call   80103980 <myproc>
80105c85:	8b 70 24             	mov    0x24(%eax),%esi
80105c88:	85 f6                	test   %esi,%esi
80105c8a:	0f 85 c8 00 00 00    	jne    80105d58 <trap+0x248>
    myproc()->tf = tf;
80105c90:	e8 eb dc ff ff       	call   80103980 <myproc>
80105c95:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c98:	e8 73 ef ff ff       	call   80104c10 <syscall>
    if(myproc()->killed)
80105c9d:	e8 de dc ff ff       	call   80103980 <myproc>
80105ca2:	8b 48 24             	mov    0x24(%eax),%ecx
80105ca5:	85 c9                	test   %ecx,%ecx
80105ca7:	0f 84 fb fe ff ff    	je     80105ba8 <trap+0x98>
}
80105cad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cb0:	5b                   	pop    %ebx
80105cb1:	5e                   	pop    %esi
80105cb2:	5f                   	pop    %edi
80105cb3:	5d                   	pop    %ebp
      exit();
80105cb4:	e9 e7 e0 ff ff       	jmp    80103da0 <exit>
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105cc0:	e8 4b 02 00 00       	call   80105f10 <uartintr>
    lapiceoi();
80105cc5:	e8 26 cc ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cca:	e8 b1 dc ff ff       	call   80103980 <myproc>
80105ccf:	85 c0                	test   %eax,%eax
80105cd1:	0f 85 7c fe ff ff    	jne    80105b53 <trap+0x43>
80105cd7:	e9 91 fe ff ff       	jmp    80105b6d <trap+0x5d>
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ce0:	e8 db ca ff ff       	call   801027c0 <kbdintr>
    lapiceoi();
80105ce5:	e8 06 cc ff ff       	call   801028f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cea:	e8 91 dc ff ff       	call   80103980 <myproc>
80105cef:	85 c0                	test   %eax,%eax
80105cf1:	0f 85 5c fe ff ff    	jne    80105b53 <trap+0x43>
80105cf7:	e9 71 fe ff ff       	jmp    80105b6d <trap+0x5d>
80105cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105d00:	e8 5b dc ff ff       	call   80103960 <cpuid>
80105d05:	85 c0                	test   %eax,%eax
80105d07:	0f 85 38 fe ff ff    	jne    80105b45 <trap+0x35>
      acquire(&tickslock);
80105d0d:	83 ec 0c             	sub    $0xc,%esp
80105d10:	68 80 3e 11 80       	push   $0x80113e80
80105d15:	e8 06 ea ff ff       	call   80104720 <acquire>
      ticks++;
80105d1a:	83 05 60 3e 11 80 01 	addl   $0x1,0x80113e60
      wakeup(&ticks);
80105d21:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
80105d28:	e8 f3 e3 ff ff       	call   80104120 <wakeup>
      release(&tickslock);
80105d2d:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
80105d34:	e8 87 e9 ff ff       	call   801046c0 <release>
80105d39:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d3c:	e9 04 fe ff ff       	jmp    80105b45 <trap+0x35>
80105d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105d48:	e8 53 e0 ff ff       	call   80103da0 <exit>
80105d4d:	e9 1b fe ff ff       	jmp    80105b6d <trap+0x5d>
80105d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d58:	e8 43 e0 ff ff       	call   80103da0 <exit>
80105d5d:	e9 2e ff ff ff       	jmp    80105c90 <trap+0x180>
80105d62:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d65:	e8 f6 db ff ff       	call   80103960 <cpuid>
80105d6a:	83 ec 0c             	sub    $0xc,%esp
80105d6d:	56                   	push   %esi
80105d6e:	57                   	push   %edi
80105d6f:	50                   	push   %eax
80105d70:	ff 73 30             	push   0x30(%ebx)
80105d73:	68 68 79 10 80       	push   $0x80107968
80105d78:	e8 33 a9 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105d7d:	83 c4 14             	add    $0x14,%esp
80105d80:	68 53 77 10 80       	push   $0x80107753
80105d85:	e8 f6 a5 ff ff       	call   80100380 <panic>
80105d8a:	66 90                	xchg   %ax,%ax
80105d8c:	66 90                	xchg   %ax,%ax
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d90:	a1 c0 46 11 80       	mov    0x801146c0,%eax
80105d95:	85 c0                	test   %eax,%eax
80105d97:	74 17                	je     80105db0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d99:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d9e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d9f:	a8 01                	test   $0x1,%al
80105da1:	74 0d                	je     80105db0 <uartgetc+0x20>
80105da3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105da8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105da9:	0f b6 c0             	movzbl %al,%eax
80105dac:	c3                   	ret
80105dad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105db5:	c3                   	ret
80105db6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dbd:	00 
80105dbe:	66 90                	xchg   %ax,%ax

80105dc0 <uartinit>:
{
80105dc0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dc1:	31 c9                	xor    %ecx,%ecx
80105dc3:	89 c8                	mov    %ecx,%eax
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	57                   	push   %edi
80105dc8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105dcd:	56                   	push   %esi
80105dce:	89 fa                	mov    %edi,%edx
80105dd0:	53                   	push   %ebx
80105dd1:	83 ec 1c             	sub    $0x1c,%esp
80105dd4:	ee                   	out    %al,(%dx)
80105dd5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105dda:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105ddf:	89 f2                	mov    %esi,%edx
80105de1:	ee                   	out    %al,(%dx)
80105de2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105de7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dec:	ee                   	out    %al,(%dx)
80105ded:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105df2:	89 c8                	mov    %ecx,%eax
80105df4:	89 da                	mov    %ebx,%edx
80105df6:	ee                   	out    %al,(%dx)
80105df7:	b8 03 00 00 00       	mov    $0x3,%eax
80105dfc:	89 f2                	mov    %esi,%edx
80105dfe:	ee                   	out    %al,(%dx)
80105dff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e04:	89 c8                	mov    %ecx,%eax
80105e06:	ee                   	out    %al,(%dx)
80105e07:	b8 01 00 00 00       	mov    $0x1,%eax
80105e0c:	89 da                	mov    %ebx,%edx
80105e0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e0f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e14:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e15:	3c ff                	cmp    $0xff,%al
80105e17:	0f 84 7c 00 00 00    	je     80105e99 <uartinit+0xd9>
  uart = 1;
80105e1d:	c7 05 c0 46 11 80 01 	movl   $0x1,0x801146c0
80105e24:	00 00 00 
80105e27:	89 fa                	mov    %edi,%edx
80105e29:	ec                   	in     (%dx),%al
80105e2a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e2f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e30:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e33:	bf 58 77 10 80       	mov    $0x80107758,%edi
80105e38:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105e3d:	6a 00                	push   $0x0
80105e3f:	6a 04                	push   $0x4
80105e41:	e8 1a c6 ff ff       	call   80102460 <ioapicenable>
80105e46:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105e49:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105e50:	a1 c0 46 11 80       	mov    0x801146c0,%eax
80105e55:	85 c0                	test   %eax,%eax
80105e57:	74 32                	je     80105e8b <uartinit+0xcb>
80105e59:	89 f2                	mov    %esi,%edx
80105e5b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e5c:	a8 20                	test   $0x20,%al
80105e5e:	75 21                	jne    80105e81 <uartinit+0xc1>
80105e60:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e65:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105e68:	83 ec 0c             	sub    $0xc,%esp
80105e6b:	6a 0a                	push   $0xa
80105e6d:	e8 9e ca ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e72:	83 c4 10             	add    $0x10,%esp
80105e75:	83 eb 01             	sub    $0x1,%ebx
80105e78:	74 07                	je     80105e81 <uartinit+0xc1>
80105e7a:	89 f2                	mov    %esi,%edx
80105e7c:	ec                   	in     (%dx),%al
80105e7d:	a8 20                	test   $0x20,%al
80105e7f:	74 e7                	je     80105e68 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e81:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e86:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105e8a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105e8b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105e8f:	83 c7 01             	add    $0x1,%edi
80105e92:	88 45 e7             	mov    %al,-0x19(%ebp)
80105e95:	84 c0                	test   %al,%al
80105e97:	75 b7                	jne    80105e50 <uartinit+0x90>
}
80105e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e9c:	5b                   	pop    %ebx
80105e9d:	5e                   	pop    %esi
80105e9e:	5f                   	pop    %edi
80105e9f:	5d                   	pop    %ebp
80105ea0:	c3                   	ret
80105ea1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ea8:	00 
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <uartputc>:
  if(!uart)
80105eb0:	a1 c0 46 11 80       	mov    0x801146c0,%eax
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	74 4f                	je     80105f08 <uartputc+0x58>
{
80105eb9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eba:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ebf:	89 e5                	mov    %esp,%ebp
80105ec1:	56                   	push   %esi
80105ec2:	53                   	push   %ebx
80105ec3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ec4:	a8 20                	test   $0x20,%al
80105ec6:	75 29                	jne    80105ef1 <uartputc+0x41>
80105ec8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ecd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105ed8:	83 ec 0c             	sub    $0xc,%esp
80105edb:	6a 0a                	push   $0xa
80105edd:	e8 2e ca ff ff       	call   80102910 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	83 eb 01             	sub    $0x1,%ebx
80105ee8:	74 07                	je     80105ef1 <uartputc+0x41>
80105eea:	89 f2                	mov    %esi,%edx
80105eec:	ec                   	in     (%dx),%al
80105eed:	a8 20                	test   $0x20,%al
80105eef:	74 e7                	je     80105ed8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80105ef4:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ef9:	ee                   	out    %al,(%dx)
}
80105efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105efd:	5b                   	pop    %ebx
80105efe:	5e                   	pop    %esi
80105eff:	5d                   	pop    %ebp
80105f00:	c3                   	ret
80105f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f08:	c3                   	ret
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f10 <uartintr>:

void
uartintr(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f16:	68 90 5d 10 80       	push   $0x80105d90
80105f1b:	e8 80 a9 ff ff       	call   801008a0 <consoleintr>
}
80105f20:	83 c4 10             	add    $0x10,%esp
80105f23:	c9                   	leave
80105f24:	c3                   	ret

80105f25 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f25:	6a 00                	push   $0x0
  pushl $0
80105f27:	6a 00                	push   $0x0
  jmp alltraps
80105f29:	e9 09 fb ff ff       	jmp    80105a37 <alltraps>

80105f2e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $1
80105f30:	6a 01                	push   $0x1
  jmp alltraps
80105f32:	e9 00 fb ff ff       	jmp    80105a37 <alltraps>

80105f37 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $2
80105f39:	6a 02                	push   $0x2
  jmp alltraps
80105f3b:	e9 f7 fa ff ff       	jmp    80105a37 <alltraps>

80105f40 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $3
80105f42:	6a 03                	push   $0x3
  jmp alltraps
80105f44:	e9 ee fa ff ff       	jmp    80105a37 <alltraps>

80105f49 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $4
80105f4b:	6a 04                	push   $0x4
  jmp alltraps
80105f4d:	e9 e5 fa ff ff       	jmp    80105a37 <alltraps>

80105f52 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $5
80105f54:	6a 05                	push   $0x5
  jmp alltraps
80105f56:	e9 dc fa ff ff       	jmp    80105a37 <alltraps>

80105f5b <vector6>:
.globl vector6
vector6:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $6
80105f5d:	6a 06                	push   $0x6
  jmp alltraps
80105f5f:	e9 d3 fa ff ff       	jmp    80105a37 <alltraps>

80105f64 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $7
80105f66:	6a 07                	push   $0x7
  jmp alltraps
80105f68:	e9 ca fa ff ff       	jmp    80105a37 <alltraps>

80105f6d <vector8>:
.globl vector8
vector8:
  pushl $8
80105f6d:	6a 08                	push   $0x8
  jmp alltraps
80105f6f:	e9 c3 fa ff ff       	jmp    80105a37 <alltraps>

80105f74 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $9
80105f76:	6a 09                	push   $0x9
  jmp alltraps
80105f78:	e9 ba fa ff ff       	jmp    80105a37 <alltraps>

80105f7d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f7d:	6a 0a                	push   $0xa
  jmp alltraps
80105f7f:	e9 b3 fa ff ff       	jmp    80105a37 <alltraps>

80105f84 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f84:	6a 0b                	push   $0xb
  jmp alltraps
80105f86:	e9 ac fa ff ff       	jmp    80105a37 <alltraps>

80105f8b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f8b:	6a 0c                	push   $0xc
  jmp alltraps
80105f8d:	e9 a5 fa ff ff       	jmp    80105a37 <alltraps>

80105f92 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f92:	6a 0d                	push   $0xd
  jmp alltraps
80105f94:	e9 9e fa ff ff       	jmp    80105a37 <alltraps>

80105f99 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f99:	6a 0e                	push   $0xe
  jmp alltraps
80105f9b:	e9 97 fa ff ff       	jmp    80105a37 <alltraps>

80105fa0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $15
80105fa2:	6a 0f                	push   $0xf
  jmp alltraps
80105fa4:	e9 8e fa ff ff       	jmp    80105a37 <alltraps>

80105fa9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $16
80105fab:	6a 10                	push   $0x10
  jmp alltraps
80105fad:	e9 85 fa ff ff       	jmp    80105a37 <alltraps>

80105fb2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105fb2:	6a 11                	push   $0x11
  jmp alltraps
80105fb4:	e9 7e fa ff ff       	jmp    80105a37 <alltraps>

80105fb9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $18
80105fbb:	6a 12                	push   $0x12
  jmp alltraps
80105fbd:	e9 75 fa ff ff       	jmp    80105a37 <alltraps>

80105fc2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $19
80105fc4:	6a 13                	push   $0x13
  jmp alltraps
80105fc6:	e9 6c fa ff ff       	jmp    80105a37 <alltraps>

80105fcb <vector20>:
.globl vector20
vector20:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $20
80105fcd:	6a 14                	push   $0x14
  jmp alltraps
80105fcf:	e9 63 fa ff ff       	jmp    80105a37 <alltraps>

80105fd4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $21
80105fd6:	6a 15                	push   $0x15
  jmp alltraps
80105fd8:	e9 5a fa ff ff       	jmp    80105a37 <alltraps>

80105fdd <vector22>:
.globl vector22
vector22:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $22
80105fdf:	6a 16                	push   $0x16
  jmp alltraps
80105fe1:	e9 51 fa ff ff       	jmp    80105a37 <alltraps>

80105fe6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $23
80105fe8:	6a 17                	push   $0x17
  jmp alltraps
80105fea:	e9 48 fa ff ff       	jmp    80105a37 <alltraps>

80105fef <vector24>:
.globl vector24
vector24:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $24
80105ff1:	6a 18                	push   $0x18
  jmp alltraps
80105ff3:	e9 3f fa ff ff       	jmp    80105a37 <alltraps>

80105ff8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $25
80105ffa:	6a 19                	push   $0x19
  jmp alltraps
80105ffc:	e9 36 fa ff ff       	jmp    80105a37 <alltraps>

80106001 <vector26>:
.globl vector26
vector26:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $26
80106003:	6a 1a                	push   $0x1a
  jmp alltraps
80106005:	e9 2d fa ff ff       	jmp    80105a37 <alltraps>

8010600a <vector27>:
.globl vector27
vector27:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $27
8010600c:	6a 1b                	push   $0x1b
  jmp alltraps
8010600e:	e9 24 fa ff ff       	jmp    80105a37 <alltraps>

80106013 <vector28>:
.globl vector28
vector28:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $28
80106015:	6a 1c                	push   $0x1c
  jmp alltraps
80106017:	e9 1b fa ff ff       	jmp    80105a37 <alltraps>

8010601c <vector29>:
.globl vector29
vector29:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $29
8010601e:	6a 1d                	push   $0x1d
  jmp alltraps
80106020:	e9 12 fa ff ff       	jmp    80105a37 <alltraps>

80106025 <vector30>:
.globl vector30
vector30:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $30
80106027:	6a 1e                	push   $0x1e
  jmp alltraps
80106029:	e9 09 fa ff ff       	jmp    80105a37 <alltraps>

8010602e <vector31>:
.globl vector31
vector31:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $31
80106030:	6a 1f                	push   $0x1f
  jmp alltraps
80106032:	e9 00 fa ff ff       	jmp    80105a37 <alltraps>

80106037 <vector32>:
.globl vector32
vector32:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $32
80106039:	6a 20                	push   $0x20
  jmp alltraps
8010603b:	e9 f7 f9 ff ff       	jmp    80105a37 <alltraps>

80106040 <vector33>:
.globl vector33
vector33:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $33
80106042:	6a 21                	push   $0x21
  jmp alltraps
80106044:	e9 ee f9 ff ff       	jmp    80105a37 <alltraps>

80106049 <vector34>:
.globl vector34
vector34:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $34
8010604b:	6a 22                	push   $0x22
  jmp alltraps
8010604d:	e9 e5 f9 ff ff       	jmp    80105a37 <alltraps>

80106052 <vector35>:
.globl vector35
vector35:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $35
80106054:	6a 23                	push   $0x23
  jmp alltraps
80106056:	e9 dc f9 ff ff       	jmp    80105a37 <alltraps>

8010605b <vector36>:
.globl vector36
vector36:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $36
8010605d:	6a 24                	push   $0x24
  jmp alltraps
8010605f:	e9 d3 f9 ff ff       	jmp    80105a37 <alltraps>

80106064 <vector37>:
.globl vector37
vector37:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $37
80106066:	6a 25                	push   $0x25
  jmp alltraps
80106068:	e9 ca f9 ff ff       	jmp    80105a37 <alltraps>

8010606d <vector38>:
.globl vector38
vector38:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $38
8010606f:	6a 26                	push   $0x26
  jmp alltraps
80106071:	e9 c1 f9 ff ff       	jmp    80105a37 <alltraps>

80106076 <vector39>:
.globl vector39
vector39:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $39
80106078:	6a 27                	push   $0x27
  jmp alltraps
8010607a:	e9 b8 f9 ff ff       	jmp    80105a37 <alltraps>

8010607f <vector40>:
.globl vector40
vector40:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $40
80106081:	6a 28                	push   $0x28
  jmp alltraps
80106083:	e9 af f9 ff ff       	jmp    80105a37 <alltraps>

80106088 <vector41>:
.globl vector41
vector41:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $41
8010608a:	6a 29                	push   $0x29
  jmp alltraps
8010608c:	e9 a6 f9 ff ff       	jmp    80105a37 <alltraps>

80106091 <vector42>:
.globl vector42
vector42:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $42
80106093:	6a 2a                	push   $0x2a
  jmp alltraps
80106095:	e9 9d f9 ff ff       	jmp    80105a37 <alltraps>

8010609a <vector43>:
.globl vector43
vector43:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $43
8010609c:	6a 2b                	push   $0x2b
  jmp alltraps
8010609e:	e9 94 f9 ff ff       	jmp    80105a37 <alltraps>

801060a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $44
801060a5:	6a 2c                	push   $0x2c
  jmp alltraps
801060a7:	e9 8b f9 ff ff       	jmp    80105a37 <alltraps>

801060ac <vector45>:
.globl vector45
vector45:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $45
801060ae:	6a 2d                	push   $0x2d
  jmp alltraps
801060b0:	e9 82 f9 ff ff       	jmp    80105a37 <alltraps>

801060b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $46
801060b7:	6a 2e                	push   $0x2e
  jmp alltraps
801060b9:	e9 79 f9 ff ff       	jmp    80105a37 <alltraps>

801060be <vector47>:
.globl vector47
vector47:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $47
801060c0:	6a 2f                	push   $0x2f
  jmp alltraps
801060c2:	e9 70 f9 ff ff       	jmp    80105a37 <alltraps>

801060c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $48
801060c9:	6a 30                	push   $0x30
  jmp alltraps
801060cb:	e9 67 f9 ff ff       	jmp    80105a37 <alltraps>

801060d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $49
801060d2:	6a 31                	push   $0x31
  jmp alltraps
801060d4:	e9 5e f9 ff ff       	jmp    80105a37 <alltraps>

801060d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $50
801060db:	6a 32                	push   $0x32
  jmp alltraps
801060dd:	e9 55 f9 ff ff       	jmp    80105a37 <alltraps>

801060e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $51
801060e4:	6a 33                	push   $0x33
  jmp alltraps
801060e6:	e9 4c f9 ff ff       	jmp    80105a37 <alltraps>

801060eb <vector52>:
.globl vector52
vector52:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $52
801060ed:	6a 34                	push   $0x34
  jmp alltraps
801060ef:	e9 43 f9 ff ff       	jmp    80105a37 <alltraps>

801060f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $53
801060f6:	6a 35                	push   $0x35
  jmp alltraps
801060f8:	e9 3a f9 ff ff       	jmp    80105a37 <alltraps>

801060fd <vector54>:
.globl vector54
vector54:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $54
801060ff:	6a 36                	push   $0x36
  jmp alltraps
80106101:	e9 31 f9 ff ff       	jmp    80105a37 <alltraps>

80106106 <vector55>:
.globl vector55
vector55:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $55
80106108:	6a 37                	push   $0x37
  jmp alltraps
8010610a:	e9 28 f9 ff ff       	jmp    80105a37 <alltraps>

8010610f <vector56>:
.globl vector56
vector56:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $56
80106111:	6a 38                	push   $0x38
  jmp alltraps
80106113:	e9 1f f9 ff ff       	jmp    80105a37 <alltraps>

80106118 <vector57>:
.globl vector57
vector57:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $57
8010611a:	6a 39                	push   $0x39
  jmp alltraps
8010611c:	e9 16 f9 ff ff       	jmp    80105a37 <alltraps>

80106121 <vector58>:
.globl vector58
vector58:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $58
80106123:	6a 3a                	push   $0x3a
  jmp alltraps
80106125:	e9 0d f9 ff ff       	jmp    80105a37 <alltraps>

8010612a <vector59>:
.globl vector59
vector59:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $59
8010612c:	6a 3b                	push   $0x3b
  jmp alltraps
8010612e:	e9 04 f9 ff ff       	jmp    80105a37 <alltraps>

80106133 <vector60>:
.globl vector60
vector60:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $60
80106135:	6a 3c                	push   $0x3c
  jmp alltraps
80106137:	e9 fb f8 ff ff       	jmp    80105a37 <alltraps>

8010613c <vector61>:
.globl vector61
vector61:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $61
8010613e:	6a 3d                	push   $0x3d
  jmp alltraps
80106140:	e9 f2 f8 ff ff       	jmp    80105a37 <alltraps>

80106145 <vector62>:
.globl vector62
vector62:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $62
80106147:	6a 3e                	push   $0x3e
  jmp alltraps
80106149:	e9 e9 f8 ff ff       	jmp    80105a37 <alltraps>

8010614e <vector63>:
.globl vector63
vector63:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $63
80106150:	6a 3f                	push   $0x3f
  jmp alltraps
80106152:	e9 e0 f8 ff ff       	jmp    80105a37 <alltraps>

80106157 <vector64>:
.globl vector64
vector64:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $64
80106159:	6a 40                	push   $0x40
  jmp alltraps
8010615b:	e9 d7 f8 ff ff       	jmp    80105a37 <alltraps>

80106160 <vector65>:
.globl vector65
vector65:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $65
80106162:	6a 41                	push   $0x41
  jmp alltraps
80106164:	e9 ce f8 ff ff       	jmp    80105a37 <alltraps>

80106169 <vector66>:
.globl vector66
vector66:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $66
8010616b:	6a 42                	push   $0x42
  jmp alltraps
8010616d:	e9 c5 f8 ff ff       	jmp    80105a37 <alltraps>

80106172 <vector67>:
.globl vector67
vector67:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $67
80106174:	6a 43                	push   $0x43
  jmp alltraps
80106176:	e9 bc f8 ff ff       	jmp    80105a37 <alltraps>

8010617b <vector68>:
.globl vector68
vector68:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $68
8010617d:	6a 44                	push   $0x44
  jmp alltraps
8010617f:	e9 b3 f8 ff ff       	jmp    80105a37 <alltraps>

80106184 <vector69>:
.globl vector69
vector69:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $69
80106186:	6a 45                	push   $0x45
  jmp alltraps
80106188:	e9 aa f8 ff ff       	jmp    80105a37 <alltraps>

8010618d <vector70>:
.globl vector70
vector70:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $70
8010618f:	6a 46                	push   $0x46
  jmp alltraps
80106191:	e9 a1 f8 ff ff       	jmp    80105a37 <alltraps>

80106196 <vector71>:
.globl vector71
vector71:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $71
80106198:	6a 47                	push   $0x47
  jmp alltraps
8010619a:	e9 98 f8 ff ff       	jmp    80105a37 <alltraps>

8010619f <vector72>:
.globl vector72
vector72:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $72
801061a1:	6a 48                	push   $0x48
  jmp alltraps
801061a3:	e9 8f f8 ff ff       	jmp    80105a37 <alltraps>

801061a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $73
801061aa:	6a 49                	push   $0x49
  jmp alltraps
801061ac:	e9 86 f8 ff ff       	jmp    80105a37 <alltraps>

801061b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $74
801061b3:	6a 4a                	push   $0x4a
  jmp alltraps
801061b5:	e9 7d f8 ff ff       	jmp    80105a37 <alltraps>

801061ba <vector75>:
.globl vector75
vector75:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $75
801061bc:	6a 4b                	push   $0x4b
  jmp alltraps
801061be:	e9 74 f8 ff ff       	jmp    80105a37 <alltraps>

801061c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $76
801061c5:	6a 4c                	push   $0x4c
  jmp alltraps
801061c7:	e9 6b f8 ff ff       	jmp    80105a37 <alltraps>

801061cc <vector77>:
.globl vector77
vector77:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $77
801061ce:	6a 4d                	push   $0x4d
  jmp alltraps
801061d0:	e9 62 f8 ff ff       	jmp    80105a37 <alltraps>

801061d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $78
801061d7:	6a 4e                	push   $0x4e
  jmp alltraps
801061d9:	e9 59 f8 ff ff       	jmp    80105a37 <alltraps>

801061de <vector79>:
.globl vector79
vector79:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $79
801061e0:	6a 4f                	push   $0x4f
  jmp alltraps
801061e2:	e9 50 f8 ff ff       	jmp    80105a37 <alltraps>

801061e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $80
801061e9:	6a 50                	push   $0x50
  jmp alltraps
801061eb:	e9 47 f8 ff ff       	jmp    80105a37 <alltraps>

801061f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $81
801061f2:	6a 51                	push   $0x51
  jmp alltraps
801061f4:	e9 3e f8 ff ff       	jmp    80105a37 <alltraps>

801061f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $82
801061fb:	6a 52                	push   $0x52
  jmp alltraps
801061fd:	e9 35 f8 ff ff       	jmp    80105a37 <alltraps>

80106202 <vector83>:
.globl vector83
vector83:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $83
80106204:	6a 53                	push   $0x53
  jmp alltraps
80106206:	e9 2c f8 ff ff       	jmp    80105a37 <alltraps>

8010620b <vector84>:
.globl vector84
vector84:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $84
8010620d:	6a 54                	push   $0x54
  jmp alltraps
8010620f:	e9 23 f8 ff ff       	jmp    80105a37 <alltraps>

80106214 <vector85>:
.globl vector85
vector85:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $85
80106216:	6a 55                	push   $0x55
  jmp alltraps
80106218:	e9 1a f8 ff ff       	jmp    80105a37 <alltraps>

8010621d <vector86>:
.globl vector86
vector86:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $86
8010621f:	6a 56                	push   $0x56
  jmp alltraps
80106221:	e9 11 f8 ff ff       	jmp    80105a37 <alltraps>

80106226 <vector87>:
.globl vector87
vector87:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $87
80106228:	6a 57                	push   $0x57
  jmp alltraps
8010622a:	e9 08 f8 ff ff       	jmp    80105a37 <alltraps>

8010622f <vector88>:
.globl vector88
vector88:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $88
80106231:	6a 58                	push   $0x58
  jmp alltraps
80106233:	e9 ff f7 ff ff       	jmp    80105a37 <alltraps>

80106238 <vector89>:
.globl vector89
vector89:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $89
8010623a:	6a 59                	push   $0x59
  jmp alltraps
8010623c:	e9 f6 f7 ff ff       	jmp    80105a37 <alltraps>

80106241 <vector90>:
.globl vector90
vector90:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $90
80106243:	6a 5a                	push   $0x5a
  jmp alltraps
80106245:	e9 ed f7 ff ff       	jmp    80105a37 <alltraps>

8010624a <vector91>:
.globl vector91
vector91:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $91
8010624c:	6a 5b                	push   $0x5b
  jmp alltraps
8010624e:	e9 e4 f7 ff ff       	jmp    80105a37 <alltraps>

80106253 <vector92>:
.globl vector92
vector92:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $92
80106255:	6a 5c                	push   $0x5c
  jmp alltraps
80106257:	e9 db f7 ff ff       	jmp    80105a37 <alltraps>

8010625c <vector93>:
.globl vector93
vector93:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $93
8010625e:	6a 5d                	push   $0x5d
  jmp alltraps
80106260:	e9 d2 f7 ff ff       	jmp    80105a37 <alltraps>

80106265 <vector94>:
.globl vector94
vector94:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $94
80106267:	6a 5e                	push   $0x5e
  jmp alltraps
80106269:	e9 c9 f7 ff ff       	jmp    80105a37 <alltraps>

8010626e <vector95>:
.globl vector95
vector95:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $95
80106270:	6a 5f                	push   $0x5f
  jmp alltraps
80106272:	e9 c0 f7 ff ff       	jmp    80105a37 <alltraps>

80106277 <vector96>:
.globl vector96
vector96:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $96
80106279:	6a 60                	push   $0x60
  jmp alltraps
8010627b:	e9 b7 f7 ff ff       	jmp    80105a37 <alltraps>

80106280 <vector97>:
.globl vector97
vector97:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $97
80106282:	6a 61                	push   $0x61
  jmp alltraps
80106284:	e9 ae f7 ff ff       	jmp    80105a37 <alltraps>

80106289 <vector98>:
.globl vector98
vector98:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $98
8010628b:	6a 62                	push   $0x62
  jmp alltraps
8010628d:	e9 a5 f7 ff ff       	jmp    80105a37 <alltraps>

80106292 <vector99>:
.globl vector99
vector99:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $99
80106294:	6a 63                	push   $0x63
  jmp alltraps
80106296:	e9 9c f7 ff ff       	jmp    80105a37 <alltraps>

8010629b <vector100>:
.globl vector100
vector100:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $100
8010629d:	6a 64                	push   $0x64
  jmp alltraps
8010629f:	e9 93 f7 ff ff       	jmp    80105a37 <alltraps>

801062a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $101
801062a6:	6a 65                	push   $0x65
  jmp alltraps
801062a8:	e9 8a f7 ff ff       	jmp    80105a37 <alltraps>

801062ad <vector102>:
.globl vector102
vector102:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $102
801062af:	6a 66                	push   $0x66
  jmp alltraps
801062b1:	e9 81 f7 ff ff       	jmp    80105a37 <alltraps>

801062b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $103
801062b8:	6a 67                	push   $0x67
  jmp alltraps
801062ba:	e9 78 f7 ff ff       	jmp    80105a37 <alltraps>

801062bf <vector104>:
.globl vector104
vector104:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $104
801062c1:	6a 68                	push   $0x68
  jmp alltraps
801062c3:	e9 6f f7 ff ff       	jmp    80105a37 <alltraps>

801062c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $105
801062ca:	6a 69                	push   $0x69
  jmp alltraps
801062cc:	e9 66 f7 ff ff       	jmp    80105a37 <alltraps>

801062d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $106
801062d3:	6a 6a                	push   $0x6a
  jmp alltraps
801062d5:	e9 5d f7 ff ff       	jmp    80105a37 <alltraps>

801062da <vector107>:
.globl vector107
vector107:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $107
801062dc:	6a 6b                	push   $0x6b
  jmp alltraps
801062de:	e9 54 f7 ff ff       	jmp    80105a37 <alltraps>

801062e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $108
801062e5:	6a 6c                	push   $0x6c
  jmp alltraps
801062e7:	e9 4b f7 ff ff       	jmp    80105a37 <alltraps>

801062ec <vector109>:
.globl vector109
vector109:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $109
801062ee:	6a 6d                	push   $0x6d
  jmp alltraps
801062f0:	e9 42 f7 ff ff       	jmp    80105a37 <alltraps>

801062f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $110
801062f7:	6a 6e                	push   $0x6e
  jmp alltraps
801062f9:	e9 39 f7 ff ff       	jmp    80105a37 <alltraps>

801062fe <vector111>:
.globl vector111
vector111:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $111
80106300:	6a 6f                	push   $0x6f
  jmp alltraps
80106302:	e9 30 f7 ff ff       	jmp    80105a37 <alltraps>

80106307 <vector112>:
.globl vector112
vector112:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $112
80106309:	6a 70                	push   $0x70
  jmp alltraps
8010630b:	e9 27 f7 ff ff       	jmp    80105a37 <alltraps>

80106310 <vector113>:
.globl vector113
vector113:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $113
80106312:	6a 71                	push   $0x71
  jmp alltraps
80106314:	e9 1e f7 ff ff       	jmp    80105a37 <alltraps>

80106319 <vector114>:
.globl vector114
vector114:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $114
8010631b:	6a 72                	push   $0x72
  jmp alltraps
8010631d:	e9 15 f7 ff ff       	jmp    80105a37 <alltraps>

80106322 <vector115>:
.globl vector115
vector115:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $115
80106324:	6a 73                	push   $0x73
  jmp alltraps
80106326:	e9 0c f7 ff ff       	jmp    80105a37 <alltraps>

8010632b <vector116>:
.globl vector116
vector116:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $116
8010632d:	6a 74                	push   $0x74
  jmp alltraps
8010632f:	e9 03 f7 ff ff       	jmp    80105a37 <alltraps>

80106334 <vector117>:
.globl vector117
vector117:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $117
80106336:	6a 75                	push   $0x75
  jmp alltraps
80106338:	e9 fa f6 ff ff       	jmp    80105a37 <alltraps>

8010633d <vector118>:
.globl vector118
vector118:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $118
8010633f:	6a 76                	push   $0x76
  jmp alltraps
80106341:	e9 f1 f6 ff ff       	jmp    80105a37 <alltraps>

80106346 <vector119>:
.globl vector119
vector119:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $119
80106348:	6a 77                	push   $0x77
  jmp alltraps
8010634a:	e9 e8 f6 ff ff       	jmp    80105a37 <alltraps>

8010634f <vector120>:
.globl vector120
vector120:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $120
80106351:	6a 78                	push   $0x78
  jmp alltraps
80106353:	e9 df f6 ff ff       	jmp    80105a37 <alltraps>

80106358 <vector121>:
.globl vector121
vector121:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $121
8010635a:	6a 79                	push   $0x79
  jmp alltraps
8010635c:	e9 d6 f6 ff ff       	jmp    80105a37 <alltraps>

80106361 <vector122>:
.globl vector122
vector122:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $122
80106363:	6a 7a                	push   $0x7a
  jmp alltraps
80106365:	e9 cd f6 ff ff       	jmp    80105a37 <alltraps>

8010636a <vector123>:
.globl vector123
vector123:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $123
8010636c:	6a 7b                	push   $0x7b
  jmp alltraps
8010636e:	e9 c4 f6 ff ff       	jmp    80105a37 <alltraps>

80106373 <vector124>:
.globl vector124
vector124:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $124
80106375:	6a 7c                	push   $0x7c
  jmp alltraps
80106377:	e9 bb f6 ff ff       	jmp    80105a37 <alltraps>

8010637c <vector125>:
.globl vector125
vector125:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $125
8010637e:	6a 7d                	push   $0x7d
  jmp alltraps
80106380:	e9 b2 f6 ff ff       	jmp    80105a37 <alltraps>

80106385 <vector126>:
.globl vector126
vector126:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $126
80106387:	6a 7e                	push   $0x7e
  jmp alltraps
80106389:	e9 a9 f6 ff ff       	jmp    80105a37 <alltraps>

8010638e <vector127>:
.globl vector127
vector127:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $127
80106390:	6a 7f                	push   $0x7f
  jmp alltraps
80106392:	e9 a0 f6 ff ff       	jmp    80105a37 <alltraps>

80106397 <vector128>:
.globl vector128
vector128:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $128
80106399:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010639e:	e9 94 f6 ff ff       	jmp    80105a37 <alltraps>

801063a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $129
801063a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801063aa:	e9 88 f6 ff ff       	jmp    80105a37 <alltraps>

801063af <vector130>:
.globl vector130
vector130:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $130
801063b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801063b6:	e9 7c f6 ff ff       	jmp    80105a37 <alltraps>

801063bb <vector131>:
.globl vector131
vector131:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $131
801063bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063c2:	e9 70 f6 ff ff       	jmp    80105a37 <alltraps>

801063c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $132
801063c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063ce:	e9 64 f6 ff ff       	jmp    80105a37 <alltraps>

801063d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $133
801063d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063da:	e9 58 f6 ff ff       	jmp    80105a37 <alltraps>

801063df <vector134>:
.globl vector134
vector134:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $134
801063e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801063e6:	e9 4c f6 ff ff       	jmp    80105a37 <alltraps>

801063eb <vector135>:
.globl vector135
vector135:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $135
801063ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801063f2:	e9 40 f6 ff ff       	jmp    80105a37 <alltraps>

801063f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $136
801063f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801063fe:	e9 34 f6 ff ff       	jmp    80105a37 <alltraps>

80106403 <vector137>:
.globl vector137
vector137:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $137
80106405:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010640a:	e9 28 f6 ff ff       	jmp    80105a37 <alltraps>

8010640f <vector138>:
.globl vector138
vector138:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $138
80106411:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106416:	e9 1c f6 ff ff       	jmp    80105a37 <alltraps>

8010641b <vector139>:
.globl vector139
vector139:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $139
8010641d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106422:	e9 10 f6 ff ff       	jmp    80105a37 <alltraps>

80106427 <vector140>:
.globl vector140
vector140:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $140
80106429:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010642e:	e9 04 f6 ff ff       	jmp    80105a37 <alltraps>

80106433 <vector141>:
.globl vector141
vector141:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $141
80106435:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010643a:	e9 f8 f5 ff ff       	jmp    80105a37 <alltraps>

8010643f <vector142>:
.globl vector142
vector142:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $142
80106441:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106446:	e9 ec f5 ff ff       	jmp    80105a37 <alltraps>

8010644b <vector143>:
.globl vector143
vector143:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $143
8010644d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106452:	e9 e0 f5 ff ff       	jmp    80105a37 <alltraps>

80106457 <vector144>:
.globl vector144
vector144:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $144
80106459:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010645e:	e9 d4 f5 ff ff       	jmp    80105a37 <alltraps>

80106463 <vector145>:
.globl vector145
vector145:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $145
80106465:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010646a:	e9 c8 f5 ff ff       	jmp    80105a37 <alltraps>

8010646f <vector146>:
.globl vector146
vector146:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $146
80106471:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106476:	e9 bc f5 ff ff       	jmp    80105a37 <alltraps>

8010647b <vector147>:
.globl vector147
vector147:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $147
8010647d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106482:	e9 b0 f5 ff ff       	jmp    80105a37 <alltraps>

80106487 <vector148>:
.globl vector148
vector148:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $148
80106489:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010648e:	e9 a4 f5 ff ff       	jmp    80105a37 <alltraps>

80106493 <vector149>:
.globl vector149
vector149:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $149
80106495:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010649a:	e9 98 f5 ff ff       	jmp    80105a37 <alltraps>

8010649f <vector150>:
.globl vector150
vector150:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $150
801064a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801064a6:	e9 8c f5 ff ff       	jmp    80105a37 <alltraps>

801064ab <vector151>:
.globl vector151
vector151:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $151
801064ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801064b2:	e9 80 f5 ff ff       	jmp    80105a37 <alltraps>

801064b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $152
801064b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801064be:	e9 74 f5 ff ff       	jmp    80105a37 <alltraps>

801064c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $153
801064c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064ca:	e9 68 f5 ff ff       	jmp    80105a37 <alltraps>

801064cf <vector154>:
.globl vector154
vector154:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $154
801064d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064d6:	e9 5c f5 ff ff       	jmp    80105a37 <alltraps>

801064db <vector155>:
.globl vector155
vector155:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $155
801064dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801064e2:	e9 50 f5 ff ff       	jmp    80105a37 <alltraps>

801064e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $156
801064e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801064ee:	e9 44 f5 ff ff       	jmp    80105a37 <alltraps>

801064f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $157
801064f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801064fa:	e9 38 f5 ff ff       	jmp    80105a37 <alltraps>

801064ff <vector158>:
.globl vector158
vector158:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $158
80106501:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106506:	e9 2c f5 ff ff       	jmp    80105a37 <alltraps>

8010650b <vector159>:
.globl vector159
vector159:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $159
8010650d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106512:	e9 20 f5 ff ff       	jmp    80105a37 <alltraps>

80106517 <vector160>:
.globl vector160
vector160:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $160
80106519:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010651e:	e9 14 f5 ff ff       	jmp    80105a37 <alltraps>

80106523 <vector161>:
.globl vector161
vector161:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $161
80106525:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010652a:	e9 08 f5 ff ff       	jmp    80105a37 <alltraps>

8010652f <vector162>:
.globl vector162
vector162:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $162
80106531:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106536:	e9 fc f4 ff ff       	jmp    80105a37 <alltraps>

8010653b <vector163>:
.globl vector163
vector163:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $163
8010653d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106542:	e9 f0 f4 ff ff       	jmp    80105a37 <alltraps>

80106547 <vector164>:
.globl vector164
vector164:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $164
80106549:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010654e:	e9 e4 f4 ff ff       	jmp    80105a37 <alltraps>

80106553 <vector165>:
.globl vector165
vector165:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $165
80106555:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010655a:	e9 d8 f4 ff ff       	jmp    80105a37 <alltraps>

8010655f <vector166>:
.globl vector166
vector166:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $166
80106561:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106566:	e9 cc f4 ff ff       	jmp    80105a37 <alltraps>

8010656b <vector167>:
.globl vector167
vector167:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $167
8010656d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106572:	e9 c0 f4 ff ff       	jmp    80105a37 <alltraps>

80106577 <vector168>:
.globl vector168
vector168:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $168
80106579:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010657e:	e9 b4 f4 ff ff       	jmp    80105a37 <alltraps>

80106583 <vector169>:
.globl vector169
vector169:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $169
80106585:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010658a:	e9 a8 f4 ff ff       	jmp    80105a37 <alltraps>

8010658f <vector170>:
.globl vector170
vector170:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $170
80106591:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106596:	e9 9c f4 ff ff       	jmp    80105a37 <alltraps>

8010659b <vector171>:
.globl vector171
vector171:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $171
8010659d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801065a2:	e9 90 f4 ff ff       	jmp    80105a37 <alltraps>

801065a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $172
801065a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801065ae:	e9 84 f4 ff ff       	jmp    80105a37 <alltraps>

801065b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $173
801065b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801065ba:	e9 78 f4 ff ff       	jmp    80105a37 <alltraps>

801065bf <vector174>:
.globl vector174
vector174:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $174
801065c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065c6:	e9 6c f4 ff ff       	jmp    80105a37 <alltraps>

801065cb <vector175>:
.globl vector175
vector175:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $175
801065cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065d2:	e9 60 f4 ff ff       	jmp    80105a37 <alltraps>

801065d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $176
801065d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065de:	e9 54 f4 ff ff       	jmp    80105a37 <alltraps>

801065e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $177
801065e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801065ea:	e9 48 f4 ff ff       	jmp    80105a37 <alltraps>

801065ef <vector178>:
.globl vector178
vector178:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $178
801065f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801065f6:	e9 3c f4 ff ff       	jmp    80105a37 <alltraps>

801065fb <vector179>:
.globl vector179
vector179:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $179
801065fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106602:	e9 30 f4 ff ff       	jmp    80105a37 <alltraps>

80106607 <vector180>:
.globl vector180
vector180:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $180
80106609:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010660e:	e9 24 f4 ff ff       	jmp    80105a37 <alltraps>

80106613 <vector181>:
.globl vector181
vector181:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $181
80106615:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010661a:	e9 18 f4 ff ff       	jmp    80105a37 <alltraps>

8010661f <vector182>:
.globl vector182
vector182:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $182
80106621:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106626:	e9 0c f4 ff ff       	jmp    80105a37 <alltraps>

8010662b <vector183>:
.globl vector183
vector183:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $183
8010662d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106632:	e9 00 f4 ff ff       	jmp    80105a37 <alltraps>

80106637 <vector184>:
.globl vector184
vector184:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $184
80106639:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010663e:	e9 f4 f3 ff ff       	jmp    80105a37 <alltraps>

80106643 <vector185>:
.globl vector185
vector185:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $185
80106645:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010664a:	e9 e8 f3 ff ff       	jmp    80105a37 <alltraps>

8010664f <vector186>:
.globl vector186
vector186:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $186
80106651:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106656:	e9 dc f3 ff ff       	jmp    80105a37 <alltraps>

8010665b <vector187>:
.globl vector187
vector187:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $187
8010665d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106662:	e9 d0 f3 ff ff       	jmp    80105a37 <alltraps>

80106667 <vector188>:
.globl vector188
vector188:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $188
80106669:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010666e:	e9 c4 f3 ff ff       	jmp    80105a37 <alltraps>

80106673 <vector189>:
.globl vector189
vector189:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $189
80106675:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010667a:	e9 b8 f3 ff ff       	jmp    80105a37 <alltraps>

8010667f <vector190>:
.globl vector190
vector190:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $190
80106681:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106686:	e9 ac f3 ff ff       	jmp    80105a37 <alltraps>

8010668b <vector191>:
.globl vector191
vector191:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $191
8010668d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106692:	e9 a0 f3 ff ff       	jmp    80105a37 <alltraps>

80106697 <vector192>:
.globl vector192
vector192:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $192
80106699:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010669e:	e9 94 f3 ff ff       	jmp    80105a37 <alltraps>

801066a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $193
801066a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801066aa:	e9 88 f3 ff ff       	jmp    80105a37 <alltraps>

801066af <vector194>:
.globl vector194
vector194:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $194
801066b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801066b6:	e9 7c f3 ff ff       	jmp    80105a37 <alltraps>

801066bb <vector195>:
.globl vector195
vector195:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $195
801066bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066c2:	e9 70 f3 ff ff       	jmp    80105a37 <alltraps>

801066c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $196
801066c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066ce:	e9 64 f3 ff ff       	jmp    80105a37 <alltraps>

801066d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $197
801066d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066da:	e9 58 f3 ff ff       	jmp    80105a37 <alltraps>

801066df <vector198>:
.globl vector198
vector198:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $198
801066e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801066e6:	e9 4c f3 ff ff       	jmp    80105a37 <alltraps>

801066eb <vector199>:
.globl vector199
vector199:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $199
801066ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801066f2:	e9 40 f3 ff ff       	jmp    80105a37 <alltraps>

801066f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $200
801066f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801066fe:	e9 34 f3 ff ff       	jmp    80105a37 <alltraps>

80106703 <vector201>:
.globl vector201
vector201:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $201
80106705:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010670a:	e9 28 f3 ff ff       	jmp    80105a37 <alltraps>

8010670f <vector202>:
.globl vector202
vector202:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $202
80106711:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106716:	e9 1c f3 ff ff       	jmp    80105a37 <alltraps>

8010671b <vector203>:
.globl vector203
vector203:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $203
8010671d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106722:	e9 10 f3 ff ff       	jmp    80105a37 <alltraps>

80106727 <vector204>:
.globl vector204
vector204:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $204
80106729:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010672e:	e9 04 f3 ff ff       	jmp    80105a37 <alltraps>

80106733 <vector205>:
.globl vector205
vector205:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $205
80106735:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010673a:	e9 f8 f2 ff ff       	jmp    80105a37 <alltraps>

8010673f <vector206>:
.globl vector206
vector206:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $206
80106741:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106746:	e9 ec f2 ff ff       	jmp    80105a37 <alltraps>

8010674b <vector207>:
.globl vector207
vector207:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $207
8010674d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106752:	e9 e0 f2 ff ff       	jmp    80105a37 <alltraps>

80106757 <vector208>:
.globl vector208
vector208:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $208
80106759:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010675e:	e9 d4 f2 ff ff       	jmp    80105a37 <alltraps>

80106763 <vector209>:
.globl vector209
vector209:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $209
80106765:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010676a:	e9 c8 f2 ff ff       	jmp    80105a37 <alltraps>

8010676f <vector210>:
.globl vector210
vector210:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $210
80106771:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106776:	e9 bc f2 ff ff       	jmp    80105a37 <alltraps>

8010677b <vector211>:
.globl vector211
vector211:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $211
8010677d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106782:	e9 b0 f2 ff ff       	jmp    80105a37 <alltraps>

80106787 <vector212>:
.globl vector212
vector212:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $212
80106789:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010678e:	e9 a4 f2 ff ff       	jmp    80105a37 <alltraps>

80106793 <vector213>:
.globl vector213
vector213:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $213
80106795:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010679a:	e9 98 f2 ff ff       	jmp    80105a37 <alltraps>

8010679f <vector214>:
.globl vector214
vector214:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $214
801067a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801067a6:	e9 8c f2 ff ff       	jmp    80105a37 <alltraps>

801067ab <vector215>:
.globl vector215
vector215:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $215
801067ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801067b2:	e9 80 f2 ff ff       	jmp    80105a37 <alltraps>

801067b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $216
801067b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801067be:	e9 74 f2 ff ff       	jmp    80105a37 <alltraps>

801067c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $217
801067c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067ca:	e9 68 f2 ff ff       	jmp    80105a37 <alltraps>

801067cf <vector218>:
.globl vector218
vector218:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $218
801067d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067d6:	e9 5c f2 ff ff       	jmp    80105a37 <alltraps>

801067db <vector219>:
.globl vector219
vector219:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $219
801067dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801067e2:	e9 50 f2 ff ff       	jmp    80105a37 <alltraps>

801067e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $220
801067e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801067ee:	e9 44 f2 ff ff       	jmp    80105a37 <alltraps>

801067f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $221
801067f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801067fa:	e9 38 f2 ff ff       	jmp    80105a37 <alltraps>

801067ff <vector222>:
.globl vector222
vector222:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $222
80106801:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106806:	e9 2c f2 ff ff       	jmp    80105a37 <alltraps>

8010680b <vector223>:
.globl vector223
vector223:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $223
8010680d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106812:	e9 20 f2 ff ff       	jmp    80105a37 <alltraps>

80106817 <vector224>:
.globl vector224
vector224:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $224
80106819:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010681e:	e9 14 f2 ff ff       	jmp    80105a37 <alltraps>

80106823 <vector225>:
.globl vector225
vector225:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $225
80106825:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010682a:	e9 08 f2 ff ff       	jmp    80105a37 <alltraps>

8010682f <vector226>:
.globl vector226
vector226:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $226
80106831:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106836:	e9 fc f1 ff ff       	jmp    80105a37 <alltraps>

8010683b <vector227>:
.globl vector227
vector227:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $227
8010683d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106842:	e9 f0 f1 ff ff       	jmp    80105a37 <alltraps>

80106847 <vector228>:
.globl vector228
vector228:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $228
80106849:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010684e:	e9 e4 f1 ff ff       	jmp    80105a37 <alltraps>

80106853 <vector229>:
.globl vector229
vector229:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $229
80106855:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010685a:	e9 d8 f1 ff ff       	jmp    80105a37 <alltraps>

8010685f <vector230>:
.globl vector230
vector230:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $230
80106861:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106866:	e9 cc f1 ff ff       	jmp    80105a37 <alltraps>

8010686b <vector231>:
.globl vector231
vector231:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $231
8010686d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106872:	e9 c0 f1 ff ff       	jmp    80105a37 <alltraps>

80106877 <vector232>:
.globl vector232
vector232:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $232
80106879:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010687e:	e9 b4 f1 ff ff       	jmp    80105a37 <alltraps>

80106883 <vector233>:
.globl vector233
vector233:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $233
80106885:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010688a:	e9 a8 f1 ff ff       	jmp    80105a37 <alltraps>

8010688f <vector234>:
.globl vector234
vector234:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $234
80106891:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106896:	e9 9c f1 ff ff       	jmp    80105a37 <alltraps>

8010689b <vector235>:
.globl vector235
vector235:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $235
8010689d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801068a2:	e9 90 f1 ff ff       	jmp    80105a37 <alltraps>

801068a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $236
801068a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801068ae:	e9 84 f1 ff ff       	jmp    80105a37 <alltraps>

801068b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $237
801068b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801068ba:	e9 78 f1 ff ff       	jmp    80105a37 <alltraps>

801068bf <vector238>:
.globl vector238
vector238:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $238
801068c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068c6:	e9 6c f1 ff ff       	jmp    80105a37 <alltraps>

801068cb <vector239>:
.globl vector239
vector239:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $239
801068cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068d2:	e9 60 f1 ff ff       	jmp    80105a37 <alltraps>

801068d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $240
801068d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068de:	e9 54 f1 ff ff       	jmp    80105a37 <alltraps>

801068e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $241
801068e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801068ea:	e9 48 f1 ff ff       	jmp    80105a37 <alltraps>

801068ef <vector242>:
.globl vector242
vector242:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $242
801068f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801068f6:	e9 3c f1 ff ff       	jmp    80105a37 <alltraps>

801068fb <vector243>:
.globl vector243
vector243:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $243
801068fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106902:	e9 30 f1 ff ff       	jmp    80105a37 <alltraps>

80106907 <vector244>:
.globl vector244
vector244:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $244
80106909:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010690e:	e9 24 f1 ff ff       	jmp    80105a37 <alltraps>

80106913 <vector245>:
.globl vector245
vector245:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $245
80106915:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010691a:	e9 18 f1 ff ff       	jmp    80105a37 <alltraps>

8010691f <vector246>:
.globl vector246
vector246:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $246
80106921:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106926:	e9 0c f1 ff ff       	jmp    80105a37 <alltraps>

8010692b <vector247>:
.globl vector247
vector247:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $247
8010692d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106932:	e9 00 f1 ff ff       	jmp    80105a37 <alltraps>

80106937 <vector248>:
.globl vector248
vector248:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $248
80106939:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010693e:	e9 f4 f0 ff ff       	jmp    80105a37 <alltraps>

80106943 <vector249>:
.globl vector249
vector249:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $249
80106945:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010694a:	e9 e8 f0 ff ff       	jmp    80105a37 <alltraps>

8010694f <vector250>:
.globl vector250
vector250:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $250
80106951:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106956:	e9 dc f0 ff ff       	jmp    80105a37 <alltraps>

8010695b <vector251>:
.globl vector251
vector251:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $251
8010695d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106962:	e9 d0 f0 ff ff       	jmp    80105a37 <alltraps>

80106967 <vector252>:
.globl vector252
vector252:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $252
80106969:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010696e:	e9 c4 f0 ff ff       	jmp    80105a37 <alltraps>

80106973 <vector253>:
.globl vector253
vector253:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $253
80106975:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010697a:	e9 b8 f0 ff ff       	jmp    80105a37 <alltraps>

8010697f <vector254>:
.globl vector254
vector254:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $254
80106981:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106986:	e9 ac f0 ff ff       	jmp    80105a37 <alltraps>

8010698b <vector255>:
.globl vector255
vector255:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $255
8010698d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106992:	e9 a0 f0 ff ff       	jmp    80105a37 <alltraps>
80106997:	66 90                	xchg   %ax,%ax
80106999:	66 90                	xchg   %ax,%ax
8010699b:	66 90                	xchg   %ax,%ax
8010699d:	66 90                	xchg   %ax,%ax
8010699f:	90                   	nop

801069a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	57                   	push   %edi
801069a4:	56                   	push   %esi
801069a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069b2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
801069b5:	39 d3                	cmp    %edx,%ebx
801069b7:	73 56                	jae    80106a0f <deallocuvm.part.0+0x6f>
801069b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801069bc:	89 c6                	mov    %eax,%esi
801069be:	89 d7                	mov    %edx,%edi
801069c0:	eb 12                	jmp    801069d4 <deallocuvm.part.0+0x34>
801069c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069c8:	83 c2 01             	add    $0x1,%edx
801069cb:	89 d3                	mov    %edx,%ebx
801069cd:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801069d0:	39 fb                	cmp    %edi,%ebx
801069d2:	73 38                	jae    80106a0c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
801069d4:	89 da                	mov    %ebx,%edx
801069d6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801069d9:	8b 04 96             	mov    (%esi,%edx,4),%eax
801069dc:	a8 01                	test   $0x1,%al
801069de:	74 e8                	je     801069c8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
801069e0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801069e7:	c1 e9 0a             	shr    $0xa,%ecx
801069ea:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801069f0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801069f7:	85 c0                	test   %eax,%eax
801069f9:	74 cd                	je     801069c8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801069fb:	8b 10                	mov    (%eax),%edx
801069fd:	f6 c2 01             	test   $0x1,%dl
80106a00:	75 1e                	jne    80106a20 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106a02:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a08:	39 fb                	cmp    %edi,%ebx
80106a0a:	72 c8                	jb     801069d4 <deallocuvm.part.0+0x34>
80106a0c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a12:	89 c8                	mov    %ecx,%eax
80106a14:	5b                   	pop    %ebx
80106a15:	5e                   	pop    %esi
80106a16:	5f                   	pop    %edi
80106a17:	5d                   	pop    %ebp
80106a18:	c3                   	ret
80106a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106a20:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a26:	74 26                	je     80106a4e <deallocuvm.part.0+0xae>
      kfree(v);
80106a28:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a2b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a34:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106a3a:	52                   	push   %edx
80106a3b:	e8 60 ba ff ff       	call   801024a0 <kfree>
      *pte = 0;
80106a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106a43:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106a46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106a4c:	eb 82                	jmp    801069d0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106a4e:	83 ec 0c             	sub    $0xc,%esp
80106a51:	68 2c 75 10 80       	push   $0x8010752c
80106a56:	e8 25 99 ff ff       	call   80100380 <panic>
80106a5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106a60 <mappages>:
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106a66:	89 d3                	mov    %edx,%ebx
80106a68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a6e:	83 ec 1c             	sub    $0x1c,%esp
80106a71:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a74:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a80:	8b 45 08             	mov    0x8(%ebp),%eax
80106a83:	29 d8                	sub    %ebx,%eax
80106a85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a88:	eb 3f                	jmp    80106ac9 <mappages+0x69>
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106a90:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a97:	c1 ea 0a             	shr    $0xa,%edx
80106a9a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106aa0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106aa7:	85 c0                	test   %eax,%eax
80106aa9:	74 75                	je     80106b20 <mappages+0xc0>
    if(*pte & PTE_P)
80106aab:	f6 00 01             	testb  $0x1,(%eax)
80106aae:	0f 85 86 00 00 00    	jne    80106b3a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ab4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ab7:	83 ce 01             	or     $0x1,%esi
80106aba:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106abc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106abf:	39 c3                	cmp    %eax,%ebx
80106ac1:	74 6d                	je     80106b30 <mappages+0xd0>
    a += PGSIZE;
80106ac3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106acc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106acf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106ad2:	89 d8                	mov    %ebx,%eax
80106ad4:	c1 e8 16             	shr    $0x16,%eax
80106ad7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106ada:	8b 07                	mov    (%edi),%eax
80106adc:	a8 01                	test   $0x1,%al
80106ade:	75 b0                	jne    80106a90 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ae0:	e8 7b bb ff ff       	call   80102660 <kalloc>
80106ae5:	85 c0                	test   %eax,%eax
80106ae7:	74 37                	je     80106b20 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106ae9:	83 ec 04             	sub    $0x4,%esp
80106aec:	68 00 10 00 00       	push   $0x1000
80106af1:	6a 00                	push   $0x0
80106af3:	50                   	push   %eax
80106af4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106af7:	e8 24 dd ff ff       	call   80104820 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106afc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106aff:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b02:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b08:	83 c8 07             	or     $0x7,%eax
80106b0b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b0d:	89 d8                	mov    %ebx,%eax
80106b0f:	c1 e8 0a             	shr    $0xa,%eax
80106b12:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b17:	01 d0                	add    %edx,%eax
80106b19:	eb 90                	jmp    80106aab <mappages+0x4b>
80106b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b28:	5b                   	pop    %ebx
80106b29:	5e                   	pop    %esi
80106b2a:	5f                   	pop    %edi
80106b2b:	5d                   	pop    %ebp
80106b2c:	c3                   	ret
80106b2d:	8d 76 00             	lea    0x0(%esi),%esi
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b33:	31 c0                	xor    %eax,%eax
}
80106b35:	5b                   	pop    %ebx
80106b36:	5e                   	pop    %esi
80106b37:	5f                   	pop    %edi
80106b38:	5d                   	pop    %ebp
80106b39:	c3                   	ret
      panic("remap");
80106b3a:	83 ec 0c             	sub    $0xc,%esp
80106b3d:	68 60 77 10 80       	push   $0x80107760
80106b42:	e8 39 98 ff ff       	call   80100380 <panic>
80106b47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b4e:	00 
80106b4f:	90                   	nop

80106b50 <seginit>:
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b56:	e8 05 ce ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
80106b5b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b60:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b66:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106b6a:	c7 80 18 18 11 80 ff 	movl   $0xffff,-0x7feee7e8(%eax)
80106b71:	ff 00 00 
80106b74:	c7 80 1c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7e4(%eax)
80106b7b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b7e:	c7 80 20 18 11 80 ff 	movl   $0xffff,-0x7feee7e0(%eax)
80106b85:	ff 00 00 
80106b88:	c7 80 24 18 11 80 00 	movl   $0xcf9200,-0x7feee7dc(%eax)
80106b8f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b92:	c7 80 28 18 11 80 ff 	movl   $0xffff,-0x7feee7d8(%eax)
80106b99:	ff 00 00 
80106b9c:	c7 80 2c 18 11 80 00 	movl   $0xcffa00,-0x7feee7d4(%eax)
80106ba3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ba6:	c7 80 30 18 11 80 ff 	movl   $0xffff,-0x7feee7d0(%eax)
80106bad:	ff 00 00 
80106bb0:	c7 80 34 18 11 80 00 	movl   $0xcff200,-0x7feee7cc(%eax)
80106bb7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106bba:	05 10 18 11 80       	add    $0x80111810,%eax
  pd[1] = (uint)p;
80106bbf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106bc3:	c1 e8 10             	shr    $0x10,%eax
80106bc6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106bca:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bcd:	0f 01 10             	lgdtl  (%eax)
}
80106bd0:	c9                   	leave
80106bd1:	c3                   	ret
80106bd2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bd9:	00 
80106bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106be0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106be0:	a1 c4 46 11 80       	mov    0x801146c4,%eax
80106be5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bea:	0f 22 d8             	mov    %eax,%cr3
}
80106bed:	c3                   	ret
80106bee:	66 90                	xchg   %ax,%ax

80106bf0 <switchuvm>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 1c             	sub    $0x1c,%esp
80106bf9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106bfc:	85 f6                	test   %esi,%esi
80106bfe:	0f 84 cb 00 00 00    	je     80106ccf <switchuvm+0xdf>
  if(p->kstack == 0)
80106c04:	8b 46 08             	mov    0x8(%esi),%eax
80106c07:	85 c0                	test   %eax,%eax
80106c09:	0f 84 da 00 00 00    	je     80106ce9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c0f:	8b 46 04             	mov    0x4(%esi),%eax
80106c12:	85 c0                	test   %eax,%eax
80106c14:	0f 84 c2 00 00 00    	je     80106cdc <switchuvm+0xec>
  pushcli();
80106c1a:	e8 b1 d9 ff ff       	call   801045d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c1f:	e8 dc cc ff ff       	call   80103900 <mycpu>
80106c24:	89 c3                	mov    %eax,%ebx
80106c26:	e8 d5 cc ff ff       	call   80103900 <mycpu>
80106c2b:	89 c7                	mov    %eax,%edi
80106c2d:	e8 ce cc ff ff       	call   80103900 <mycpu>
80106c32:	83 c7 08             	add    $0x8,%edi
80106c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c38:	e8 c3 cc ff ff       	call   80103900 <mycpu>
80106c3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c40:	ba 67 00 00 00       	mov    $0x67,%edx
80106c45:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c4c:	83 c0 08             	add    $0x8,%eax
80106c4f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c56:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c5b:	83 c1 08             	add    $0x8,%ecx
80106c5e:	c1 e8 18             	shr    $0x18,%eax
80106c61:	c1 e9 10             	shr    $0x10,%ecx
80106c64:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106c6a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c75:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c7c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c81:	e8 7a cc ff ff       	call   80103900 <mycpu>
80106c86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c8d:	e8 6e cc ff ff       	call   80103900 <mycpu>
80106c92:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c96:	8b 5e 08             	mov    0x8(%esi),%ebx
80106c99:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c9f:	e8 5c cc ff ff       	call   80103900 <mycpu>
80106ca4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ca7:	e8 54 cc ff ff       	call   80103900 <mycpu>
80106cac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106cb0:	b8 28 00 00 00       	mov    $0x28,%eax
80106cb5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106cb8:	8b 46 04             	mov    0x4(%esi),%eax
80106cbb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cc0:	0f 22 d8             	mov    %eax,%cr3
}
80106cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cc6:	5b                   	pop    %ebx
80106cc7:	5e                   	pop    %esi
80106cc8:	5f                   	pop    %edi
80106cc9:	5d                   	pop    %ebp
  popcli();
80106cca:	e9 51 d9 ff ff       	jmp    80104620 <popcli>
    panic("switchuvm: no process");
80106ccf:	83 ec 0c             	sub    $0xc,%esp
80106cd2:	68 66 77 10 80       	push   $0x80107766
80106cd7:	e8 a4 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106cdc:	83 ec 0c             	sub    $0xc,%esp
80106cdf:	68 91 77 10 80       	push   $0x80107791
80106ce4:	e8 97 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106ce9:	83 ec 0c             	sub    $0xc,%esp
80106cec:	68 7c 77 10 80       	push   $0x8010777c
80106cf1:	e8 8a 96 ff ff       	call   80100380 <panic>
80106cf6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106cfd:	00 
80106cfe:	66 90                	xchg   %ax,%ax

80106d00 <inituvm>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 1c             	sub    $0x1c,%esp
80106d09:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d0f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106d12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d15:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d1b:	77 49                	ja     80106d66 <inituvm+0x66>
  mem = kalloc();
80106d1d:	e8 3e b9 ff ff       	call   80102660 <kalloc>
  memset(mem, 0, PGSIZE);
80106d22:	83 ec 04             	sub    $0x4,%esp
80106d25:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d2a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d2c:	6a 00                	push   $0x0
80106d2e:	50                   	push   %eax
80106d2f:	e8 ec da ff ff       	call   80104820 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d34:	58                   	pop    %eax
80106d35:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d3b:	5a                   	pop    %edx
80106d3c:	6a 06                	push   $0x6
80106d3e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d43:	31 d2                	xor    %edx,%edx
80106d45:	50                   	push   %eax
80106d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d49:	e8 12 fd ff ff       	call   80106a60 <mappages>
  memmove(mem, init, sz);
80106d4e:	83 c4 10             	add    $0x10,%esp
80106d51:	89 75 10             	mov    %esi,0x10(%ebp)
80106d54:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106d57:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106d5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d5d:	5b                   	pop    %ebx
80106d5e:	5e                   	pop    %esi
80106d5f:	5f                   	pop    %edi
80106d60:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d61:	e9 4a db ff ff       	jmp    801048b0 <memmove>
    panic("inituvm: more than a page");
80106d66:	83 ec 0c             	sub    $0xc,%esp
80106d69:	68 a5 77 10 80       	push   $0x801077a5
80106d6e:	e8 0d 96 ff ff       	call   80100380 <panic>
80106d73:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d7a:	00 
80106d7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106d80 <loaduvm>:
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	53                   	push   %ebx
80106d86:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106d89:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106d8c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106d8f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106d95:	0f 85 a2 00 00 00    	jne    80106e3d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106d9b:	85 ff                	test   %edi,%edi
80106d9d:	74 7d                	je     80106e1c <loaduvm+0x9c>
80106d9f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106da3:	8b 55 08             	mov    0x8(%ebp),%edx
80106da6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106da8:	89 c1                	mov    %eax,%ecx
80106daa:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106dad:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106db0:	f6 c1 01             	test   $0x1,%cl
80106db3:	75 13                	jne    80106dc8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106db5:	83 ec 0c             	sub    $0xc,%esp
80106db8:	68 bf 77 10 80       	push   $0x801077bf
80106dbd:	e8 be 95 ff ff       	call   80100380 <panic>
80106dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106dc8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dcb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106dd1:	25 fc 0f 00 00       	and    $0xffc,%eax
80106dd6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ddd:	85 c9                	test   %ecx,%ecx
80106ddf:	74 d4                	je     80106db5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106de1:	89 fb                	mov    %edi,%ebx
80106de3:	b8 00 10 00 00       	mov    $0x1000,%eax
80106de8:	29 f3                	sub    %esi,%ebx
80106dea:	39 c3                	cmp    %eax,%ebx
80106dec:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106def:	53                   	push   %ebx
80106df0:	8b 45 14             	mov    0x14(%ebp),%eax
80106df3:	01 f0                	add    %esi,%eax
80106df5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106df6:	8b 01                	mov    (%ecx),%eax
80106df8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dfd:	05 00 00 00 80       	add    $0x80000000,%eax
80106e02:	50                   	push   %eax
80106e03:	ff 75 10             	push   0x10(%ebp)
80106e06:	e8 a5 ac ff ff       	call   80101ab0 <readi>
80106e0b:	83 c4 10             	add    $0x10,%esp
80106e0e:	39 d8                	cmp    %ebx,%eax
80106e10:	75 1e                	jne    80106e30 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106e12:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e18:	39 fe                	cmp    %edi,%esi
80106e1a:	72 84                	jb     80106da0 <loaduvm+0x20>
}
80106e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e1f:	31 c0                	xor    %eax,%eax
}
80106e21:	5b                   	pop    %ebx
80106e22:	5e                   	pop    %esi
80106e23:	5f                   	pop    %edi
80106e24:	5d                   	pop    %ebp
80106e25:	c3                   	ret
80106e26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e2d:	00 
80106e2e:	66 90                	xchg   %ax,%ax
80106e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e38:	5b                   	pop    %ebx
80106e39:	5e                   	pop    %esi
80106e3a:	5f                   	pop    %edi
80106e3b:	5d                   	pop    %ebp
80106e3c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106e3d:	83 ec 0c             	sub    $0xc,%esp
80106e40:	68 e0 79 10 80       	push   $0x801079e0
80106e45:	e8 36 95 ff ff       	call   80100380 <panic>
80106e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e50 <allocuvm>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 1c             	sub    $0x1c,%esp
80106e59:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106e5c:	85 f6                	test   %esi,%esi
80106e5e:	0f 88 98 00 00 00    	js     80106efc <allocuvm+0xac>
80106e64:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106e66:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106e69:	0f 82 a1 00 00 00    	jb     80106f10 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e72:	05 ff 0f 00 00       	add    $0xfff,%eax
80106e77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e7c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106e7e:	39 f0                	cmp    %esi,%eax
80106e80:	0f 83 8d 00 00 00    	jae    80106f13 <allocuvm+0xc3>
80106e86:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106e89:	eb 44                	jmp    80106ecf <allocuvm+0x7f>
80106e8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106e90:	83 ec 04             	sub    $0x4,%esp
80106e93:	68 00 10 00 00       	push   $0x1000
80106e98:	6a 00                	push   $0x0
80106e9a:	50                   	push   %eax
80106e9b:	e8 80 d9 ff ff       	call   80104820 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ea0:	58                   	pop    %eax
80106ea1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ea7:	5a                   	pop    %edx
80106ea8:	6a 06                	push   $0x6
80106eaa:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106eaf:	89 fa                	mov    %edi,%edx
80106eb1:	50                   	push   %eax
80106eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb5:	e8 a6 fb ff ff       	call   80106a60 <mappages>
80106eba:	83 c4 10             	add    $0x10,%esp
80106ebd:	85 c0                	test   %eax,%eax
80106ebf:	78 5f                	js     80106f20 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106ec1:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ec7:	39 f7                	cmp    %esi,%edi
80106ec9:	0f 83 89 00 00 00    	jae    80106f58 <allocuvm+0x108>
    mem = kalloc();
80106ecf:	e8 8c b7 ff ff       	call   80102660 <kalloc>
80106ed4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106ed6:	85 c0                	test   %eax,%eax
80106ed8:	75 b6                	jne    80106e90 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106eda:	83 ec 0c             	sub    $0xc,%esp
80106edd:	68 dd 77 10 80       	push   $0x801077dd
80106ee2:	e8 c9 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106ee7:	83 c4 10             	add    $0x10,%esp
80106eea:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106eed:	74 0d                	je     80106efc <allocuvm+0xac>
80106eef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef5:	89 f2                	mov    %esi,%edx
80106ef7:	e8 a4 fa ff ff       	call   801069a0 <deallocuvm.part.0>
    return 0;
80106efc:	31 d2                	xor    %edx,%edx
}
80106efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f01:	89 d0                	mov    %edx,%eax
80106f03:	5b                   	pop    %ebx
80106f04:	5e                   	pop    %esi
80106f05:	5f                   	pop    %edi
80106f06:	5d                   	pop    %ebp
80106f07:	c3                   	ret
80106f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f0f:	00 
    return oldsz;
80106f10:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f16:	89 d0                	mov    %edx,%eax
80106f18:	5b                   	pop    %ebx
80106f19:	5e                   	pop    %esi
80106f1a:	5f                   	pop    %edi
80106f1b:	5d                   	pop    %ebp
80106f1c:	c3                   	ret
80106f1d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	68 f5 77 10 80       	push   $0x801077f5
80106f28:	e8 83 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f2d:	83 c4 10             	add    $0x10,%esp
80106f30:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f33:	74 0d                	je     80106f42 <allocuvm+0xf2>
80106f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f38:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3b:	89 f2                	mov    %esi,%edx
80106f3d:	e8 5e fa ff ff       	call   801069a0 <deallocuvm.part.0>
      kfree(mem);
80106f42:	83 ec 0c             	sub    $0xc,%esp
80106f45:	53                   	push   %ebx
80106f46:	e8 55 b5 ff ff       	call   801024a0 <kfree>
      return 0;
80106f4b:	83 c4 10             	add    $0x10,%esp
    return 0;
80106f4e:	31 d2                	xor    %edx,%edx
80106f50:	eb ac                	jmp    80106efe <allocuvm+0xae>
80106f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f5e:	5b                   	pop    %ebx
80106f5f:	5e                   	pop    %esi
80106f60:	89 d0                	mov    %edx,%eax
80106f62:	5f                   	pop    %edi
80106f63:	5d                   	pop    %ebp
80106f64:	c3                   	ret
80106f65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f6c:	00 
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi

80106f70 <deallocuvm>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f76:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f79:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106f7c:	39 d1                	cmp    %edx,%ecx
80106f7e:	73 10                	jae    80106f90 <deallocuvm+0x20>
}
80106f80:	5d                   	pop    %ebp
80106f81:	e9 1a fa ff ff       	jmp    801069a0 <deallocuvm.part.0>
80106f86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f8d:	00 
80106f8e:	66 90                	xchg   %ax,%ax
80106f90:	89 d0                	mov    %edx,%eax
80106f92:	5d                   	pop    %ebp
80106f93:	c3                   	ret
80106f94:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f9b:	00 
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106fa0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	57                   	push   %edi
80106fa4:	56                   	push   %esi
80106fa5:	53                   	push   %ebx
80106fa6:	83 ec 0c             	sub    $0xc,%esp
80106fa9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106fac:	85 f6                	test   %esi,%esi
80106fae:	74 59                	je     80107009 <freevm+0x69>
  if(newsz >= oldsz)
80106fb0:	31 c9                	xor    %ecx,%ecx
80106fb2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106fb7:	89 f0                	mov    %esi,%eax
80106fb9:	89 f3                	mov    %esi,%ebx
80106fbb:	e8 e0 f9 ff ff       	call   801069a0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106fc0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106fc6:	eb 0f                	jmp    80106fd7 <freevm+0x37>
80106fc8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fcf:	00 
80106fd0:	83 c3 04             	add    $0x4,%ebx
80106fd3:	39 fb                	cmp    %edi,%ebx
80106fd5:	74 23                	je     80106ffa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106fd7:	8b 03                	mov    (%ebx),%eax
80106fd9:	a8 01                	test   $0x1,%al
80106fdb:	74 f3                	je     80106fd0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106fe2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106fe5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fe8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106fed:	50                   	push   %eax
80106fee:	e8 ad b4 ff ff       	call   801024a0 <kfree>
80106ff3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ff6:	39 fb                	cmp    %edi,%ebx
80106ff8:	75 dd                	jne    80106fd7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106ffa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107000:	5b                   	pop    %ebx
80107001:	5e                   	pop    %esi
80107002:	5f                   	pop    %edi
80107003:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107004:	e9 97 b4 ff ff       	jmp    801024a0 <kfree>
    panic("freevm: no pgdir");
80107009:	83 ec 0c             	sub    $0xc,%esp
8010700c:	68 11 78 10 80       	push   $0x80107811
80107011:	e8 6a 93 ff ff       	call   80100380 <panic>
80107016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010701d:	00 
8010701e:	66 90                	xchg   %ax,%ax

80107020 <setupkvm>:
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	56                   	push   %esi
80107024:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107025:	e8 36 b6 ff ff       	call   80102660 <kalloc>
8010702a:	85 c0                	test   %eax,%eax
8010702c:	74 5e                	je     8010708c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010702e:	83 ec 04             	sub    $0x4,%esp
80107031:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107033:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107038:	68 00 10 00 00       	push   $0x1000
8010703d:	6a 00                	push   $0x0
8010703f:	50                   	push   %eax
80107040:	e8 db d7 ff ff       	call   80104820 <memset>
80107045:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107048:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010704b:	83 ec 08             	sub    $0x8,%esp
8010704e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107051:	8b 13                	mov    (%ebx),%edx
80107053:	ff 73 0c             	push   0xc(%ebx)
80107056:	50                   	push   %eax
80107057:	29 c1                	sub    %eax,%ecx
80107059:	89 f0                	mov    %esi,%eax
8010705b:	e8 00 fa ff ff       	call   80106a60 <mappages>
80107060:	83 c4 10             	add    $0x10,%esp
80107063:	85 c0                	test   %eax,%eax
80107065:	78 19                	js     80107080 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107067:	83 c3 10             	add    $0x10,%ebx
8010706a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107070:	75 d6                	jne    80107048 <setupkvm+0x28>
}
80107072:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107075:	89 f0                	mov    %esi,%eax
80107077:	5b                   	pop    %ebx
80107078:	5e                   	pop    %esi
80107079:	5d                   	pop    %ebp
8010707a:	c3                   	ret
8010707b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107080:	83 ec 0c             	sub    $0xc,%esp
80107083:	56                   	push   %esi
80107084:	e8 17 ff ff ff       	call   80106fa0 <freevm>
      return 0;
80107089:	83 c4 10             	add    $0x10,%esp
}
8010708c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010708f:	31 f6                	xor    %esi,%esi
}
80107091:	89 f0                	mov    %esi,%eax
80107093:	5b                   	pop    %ebx
80107094:	5e                   	pop    %esi
80107095:	5d                   	pop    %ebp
80107096:	c3                   	ret
80107097:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010709e:	00 
8010709f:	90                   	nop

801070a0 <kvmalloc>:
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801070a6:	e8 75 ff ff ff       	call   80107020 <setupkvm>
801070ab:	a3 c4 46 11 80       	mov    %eax,0x801146c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070b0:	05 00 00 00 80       	add    $0x80000000,%eax
801070b5:	0f 22 d8             	mov    %eax,%cr3
}
801070b8:	c9                   	leave
801070b9:	c3                   	ret
801070ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	83 ec 08             	sub    $0x8,%esp
801070c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801070c9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801070cc:	89 c1                	mov    %eax,%ecx
801070ce:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801070d1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801070d4:	f6 c2 01             	test   $0x1,%dl
801070d7:	75 17                	jne    801070f0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801070d9:	83 ec 0c             	sub    $0xc,%esp
801070dc:	68 22 78 10 80       	push   $0x80107822
801070e1:	e8 9a 92 ff ff       	call   80100380 <panic>
801070e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070ed:	00 
801070ee:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
801070f0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070f3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801070f9:	25 fc 0f 00 00       	and    $0xffc,%eax
801070fe:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107105:	85 c0                	test   %eax,%eax
80107107:	74 d0                	je     801070d9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107109:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010710c:	c9                   	leave
8010710d:	c3                   	ret
8010710e:	66 90                	xchg   %ax,%ax

80107110 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
80107116:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107119:	e8 02 ff ff ff       	call   80107020 <setupkvm>
8010711e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107121:	85 c0                	test   %eax,%eax
80107123:	0f 84 e9 00 00 00    	je     80107212 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107129:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010712c:	85 c9                	test   %ecx,%ecx
8010712e:	0f 84 b2 00 00 00    	je     801071e6 <copyuvm+0xd6>
80107134:	31 f6                	xor    %esi,%esi
80107136:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010713d:	00 
8010713e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107140:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107143:	89 f0                	mov    %esi,%eax
80107145:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107148:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010714b:	a8 01                	test   $0x1,%al
8010714d:	75 11                	jne    80107160 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010714f:	83 ec 0c             	sub    $0xc,%esp
80107152:	68 2c 78 10 80       	push   $0x8010782c
80107157:	e8 24 92 ff ff       	call   80100380 <panic>
8010715c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107160:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107167:	c1 ea 0a             	shr    $0xa,%edx
8010716a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107170:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107177:	85 c0                	test   %eax,%eax
80107179:	74 d4                	je     8010714f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010717b:	8b 00                	mov    (%eax),%eax
8010717d:	a8 01                	test   $0x1,%al
8010717f:	0f 84 9f 00 00 00    	je     80107224 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107185:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107187:	25 ff 0f 00 00       	and    $0xfff,%eax
8010718c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010718f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107195:	e8 c6 b4 ff ff       	call   80102660 <kalloc>
8010719a:	89 c3                	mov    %eax,%ebx
8010719c:	85 c0                	test   %eax,%eax
8010719e:	74 64                	je     80107204 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801071a0:	83 ec 04             	sub    $0x4,%esp
801071a3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801071a9:	68 00 10 00 00       	push   $0x1000
801071ae:	57                   	push   %edi
801071af:	50                   	push   %eax
801071b0:	e8 fb d6 ff ff       	call   801048b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801071b5:	58                   	pop    %eax
801071b6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071bc:	5a                   	pop    %edx
801071bd:	ff 75 e4             	push   -0x1c(%ebp)
801071c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071c5:	89 f2                	mov    %esi,%edx
801071c7:	50                   	push   %eax
801071c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071cb:	e8 90 f8 ff ff       	call   80106a60 <mappages>
801071d0:	83 c4 10             	add    $0x10,%esp
801071d3:	85 c0                	test   %eax,%eax
801071d5:	78 21                	js     801071f8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801071d7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801071dd:	3b 75 0c             	cmp    0xc(%ebp),%esi
801071e0:	0f 82 5a ff ff ff    	jb     80107140 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801071e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ec:	5b                   	pop    %ebx
801071ed:	5e                   	pop    %esi
801071ee:	5f                   	pop    %edi
801071ef:	5d                   	pop    %ebp
801071f0:	c3                   	ret
801071f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801071f8:	83 ec 0c             	sub    $0xc,%esp
801071fb:	53                   	push   %ebx
801071fc:	e8 9f b2 ff ff       	call   801024a0 <kfree>
      goto bad;
80107201:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107204:	83 ec 0c             	sub    $0xc,%esp
80107207:	ff 75 e0             	push   -0x20(%ebp)
8010720a:	e8 91 fd ff ff       	call   80106fa0 <freevm>
  return 0;
8010720f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107212:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107219:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010721c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010721f:	5b                   	pop    %ebx
80107220:	5e                   	pop    %esi
80107221:	5f                   	pop    %edi
80107222:	5d                   	pop    %ebp
80107223:	c3                   	ret
      panic("copyuvm: page not present");
80107224:	83 ec 0c             	sub    $0xc,%esp
80107227:	68 46 78 10 80       	push   $0x80107846
8010722c:	e8 4f 91 ff ff       	call   80100380 <panic>
80107231:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107238:	00 
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107240 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107246:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107249:	89 c1                	mov    %eax,%ecx
8010724b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010724e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107251:	f6 c2 01             	test   $0x1,%dl
80107254:	0f 84 f8 00 00 00    	je     80107352 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010725a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010725d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107263:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107264:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107269:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107270:	89 d0                	mov    %edx,%eax
80107272:	f7 d2                	not    %edx
80107274:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107279:	05 00 00 00 80       	add    $0x80000000,%eax
8010727e:	83 e2 05             	and    $0x5,%edx
80107281:	ba 00 00 00 00       	mov    $0x0,%edx
80107286:	0f 45 c2             	cmovne %edx,%eax
}
80107289:	c3                   	ret
8010728a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107290 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	57                   	push   %edi
80107294:	56                   	push   %esi
80107295:	53                   	push   %ebx
80107296:	83 ec 0c             	sub    $0xc,%esp
80107299:	8b 75 14             	mov    0x14(%ebp),%esi
8010729c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010729f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072a2:	85 f6                	test   %esi,%esi
801072a4:	75 51                	jne    801072f7 <copyout+0x67>
801072a6:	e9 9d 00 00 00       	jmp    80107348 <copyout+0xb8>
801072ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801072b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801072b6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801072bc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801072c2:	74 74                	je     80107338 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801072c4:	89 fb                	mov    %edi,%ebx
801072c6:	29 c3                	sub    %eax,%ebx
801072c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801072ce:	39 f3                	cmp    %esi,%ebx
801072d0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801072d3:	29 f8                	sub    %edi,%eax
801072d5:	83 ec 04             	sub    $0x4,%esp
801072d8:	01 c1                	add    %eax,%ecx
801072da:	53                   	push   %ebx
801072db:	52                   	push   %edx
801072dc:	89 55 10             	mov    %edx,0x10(%ebp)
801072df:	51                   	push   %ecx
801072e0:	e8 cb d5 ff ff       	call   801048b0 <memmove>
    len -= n;
    buf += n;
801072e5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801072e8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801072ee:	83 c4 10             	add    $0x10,%esp
    buf += n;
801072f1:	01 da                	add    %ebx,%edx
  while(len > 0){
801072f3:	29 de                	sub    %ebx,%esi
801072f5:	74 51                	je     80107348 <copyout+0xb8>
  if(*pde & PTE_P){
801072f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801072fa:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801072fc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801072fe:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107301:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107307:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010730a:	f6 c1 01             	test   $0x1,%cl
8010730d:	0f 84 46 00 00 00    	je     80107359 <copyout.cold>
  return &pgtab[PTX(va)];
80107313:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107315:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010731b:	c1 eb 0c             	shr    $0xc,%ebx
8010731e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107324:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010732b:	89 d9                	mov    %ebx,%ecx
8010732d:	f7 d1                	not    %ecx
8010732f:	83 e1 05             	and    $0x5,%ecx
80107332:	0f 84 78 ff ff ff    	je     801072b0 <copyout+0x20>
  }
  return 0;
}
80107338:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010733b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107340:	5b                   	pop    %ebx
80107341:	5e                   	pop    %esi
80107342:	5f                   	pop    %edi
80107343:	5d                   	pop    %ebp
80107344:	c3                   	ret
80107345:	8d 76 00             	lea    0x0(%esi),%esi
80107348:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010734b:	31 c0                	xor    %eax,%eax
}
8010734d:	5b                   	pop    %ebx
8010734e:	5e                   	pop    %esi
8010734f:	5f                   	pop    %edi
80107350:	5d                   	pop    %ebp
80107351:	c3                   	ret

80107352 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107352:	a1 00 00 00 00       	mov    0x0,%eax
80107357:	0f 0b                	ud2

80107359 <copyout.cold>:
80107359:	a1 00 00 00 00       	mov    0x0,%eax
8010735e:	0f 0b                	ud2
