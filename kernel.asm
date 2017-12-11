
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2d 10 80       	mov    $0x80102de0,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 c0 6e 10 	movl   $0x80106ec0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 10 40 00 00       	call   80104070 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 c7 6e 10 	movl   $0x80106ec7,0x4(%esp)
8010009b:	80 
8010009c:	e8 bf 3e 00 00       	call   80103f60 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 75 40 00 00       	call   80104160 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
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
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ea 40 00 00       	call   80104250 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 2f 3e 00 00       	call   80103fa0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 92 1f 00 00       	call   80102110 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 ce 6e 10 80 	movl   $0x80106ece,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 8b 3e 00 00       	call   80104040 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 47 1f 00 00       	jmp    80102110 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 df 6e 10 80 	movl   $0x80106edf,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 4a 3e 00 00       	call   80104040 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 fe 3d 00 00       	call   80104000 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 52 3f 00 00       	call   80104160 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 fb 3f 00 00       	jmp    80104250 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 e6 6e 10 80 	movl   $0x80106ee6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 f9 14 00 00       	call   80101780 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 cd 3e 00 00       	call   80104160 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 e3 33 00 00       	call   80103690 <myproc>
801002ad:	8b 40 2c             	mov    0x2c(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 38 39 00 00       	call   80103c00 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 3a 3f 00 00       	call   80104250 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 82 13 00 00       	call   801016a0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 1c 3f 00 00       	call   80104250 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 64 13 00 00       	call   801016a0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 d5 23 00 00       	call   80102750 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 ed 6e 10 80 	movl   $0x80106eed,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 b7 78 10 80 	movl   $0x801078b7,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 dc 3c 00 00       	call   80104090 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 01 6f 10 80 	movl   $0x80106f01,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 92 54 00 00       	call   801058a0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 e2 53 00 00       	call   801058a0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 d6 53 00 00       	call   801058a0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ca 53 00 00       	call   801058a0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 3f 3e 00 00       	call   80104340 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 82 3d 00 00       	call   801042a0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 05 6f 10 80 	movl   $0x80106f05,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 30 6f 10 80 	movzbl -0x7fef90d0(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 79 11 00 00       	call   80101780 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 4d 3b 00 00       	call   80104160 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 15 3c 00 00       	call   80104250 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 5a 10 00 00       	call   801016a0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 58 3b 00 00       	call   80104250 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 18 6f 10 80       	mov    $0x80106f18,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 c4 39 00 00       	call   80104160 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 1f 6f 10 80 	movl   $0x80106f1f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 96 39 00 00       	call   80104160 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 24 3a 00 00       	call   80104250 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 e9 34 00 00       	call   80103da0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 64 35 00 00       	jmp    80103e90 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 28 6f 10 	movl   $0x80106f28,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 06 37 00 00       	call   80104070 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100997:	e8 04 19 00 00       	call   801022a0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 df 2c 00 00       	call   80103690 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 44 21 00 00       	call   80102b00 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 29 15 00 00       	call   80101ef0 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 4f 02 00 00    	je     80100c20 <exec+0x280>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 c7 0c 00 00       	call   801016a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 55 0f 00 00       	call   80101950 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 f8 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a08:	e8 63 21 00 00       	call   80102b70 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 9f 60 00 00       	call   80106ad0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
    goto bad;

  // Load program into memory.
  sz = 0;
  //sp = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  //sp = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 bd 0e 00 00       	call   80101950 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 39 5e 00 00       	call   80106910 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 38 5d 00 00       	call   80106850 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 22 5f 00 00       	call   80106a50 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 c5 0d 00 00       	call   80101900 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 2b 20 00 00       	call   80102b70 <end_op>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE)); 
  sp = sz;*/

  //Allocate a page right under KERNBASE to become the new stack
  //curproc->stackTop = allocuvm(pgdir, KERNBASE - PGSIZE, KERNBASE - 4);
  curproc->pageNum = 1;
80100b45:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100b4b:	c7 40 1c 01 00 00 00 	movl   $0x1,0x1c(%eax)

  //KERNBASE defined in memlayout.h
  //PGSIZE defined in mmu.h
  userstack_top = KERNBASE - 2*PGSIZE;
  if((sp = allocuvm(pgdir, userstack_top, KERNBASE))==0)
80100b52:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b58:	c7 44 24 08 00 00 00 	movl   $0x80000000,0x8(%esp)
80100b5f:	80 
80100b60:	c7 44 24 04 00 e0 ff 	movl   $0x7fffe000,0x4(%esp)
80100b67:	7f 
80100b68:	89 04 24             	mov    %eax,(%esp)
80100b6b:	e8 a0 5d 00 00       	call   80106910 <allocuvm>
80100b70:	85 c0                	test   %eax,%eax
80100b72:	89 c3                	mov    %eax,%ebx
80100b74:	0f 84 8e 00 00 00    	je     80100c08 <exec+0x268>
    goto bad;
  //clearpteu(pgdir, (char*)(userstack_top)); //Old bug: NEEDS parenthesis around userstack_top


  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b7d:	8b 00                	mov    (%eax),%eax
80100b7f:	85 c0                	test   %eax,%eax
80100b81:	0f 84 92 01 00 00    	je     80100d19 <exec+0x379>
80100b87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b8a:	31 d2                	xor    %edx,%edx
80100b8c:	8d 71 04             	lea    0x4(%ecx),%esi
80100b8f:	89 cf                	mov    %ecx,%edi
80100b91:	89 f1                	mov    %esi,%ecx
80100b93:	89 d6                	mov    %edx,%esi
80100b95:	89 ca                	mov    %ecx,%edx
80100b97:	eb 2d                	jmp    80100bc6 <exec+0x226>
80100b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ba0:	8b 95 e8 fe ff ff    	mov    -0x118(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100ba6:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100bac:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
    goto bad;
  //clearpteu(pgdir, (char*)(userstack_top)); //Old bug: NEEDS parenthesis around userstack_top


  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb3:	83 c6 01             	add    $0x1,%esi
80100bb6:	8b 02                	mov    (%edx),%eax
80100bb8:	89 d7                	mov    %edx,%edi
80100bba:	85 c0                	test   %eax,%eax
80100bbc:	74 7d                	je     80100c3b <exec+0x29b>
80100bbe:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bc1:	83 fe 20             	cmp    $0x20,%esi
80100bc4:	74 42                	je     80100c08 <exec+0x268>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bc6:	89 04 24             	mov    %eax,(%esp)
80100bc9:	89 95 e8 fe ff ff    	mov    %edx,-0x118(%ebp)
80100bcf:	e8 ec 38 00 00       	call   801044c0 <strlen>
80100bd4:	f7 d0                	not    %eax
80100bd6:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bd8:	8b 07                	mov    (%edi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bda:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bdd:	89 04 24             	mov    %eax,(%esp)
80100be0:	e8 db 38 00 00       	call   801044c0 <strlen>
80100be5:	83 c0 01             	add    $0x1,%eax
80100be8:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bec:	8b 07                	mov    (%edi),%eax
80100bee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100bf2:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bf6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bfc:	89 04 24             	mov    %eax,(%esp)
80100bff:	e8 ac 61 00 00       	call   80106db0 <copyout>
80100c04:	85 c0                	test   %eax,%eax
80100c06:	79 98                	jns    80100ba0 <exec+0x200>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c08:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c0e:	89 04 24             	mov    %eax,(%esp)
80100c11:	e8 3a 5e 00 00       	call   80106a50 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c1b:	e9 f2 fd ff ff       	jmp    80100a12 <exec+0x72>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c20:	e8 4b 1f 00 00       	call   80102b70 <end_op>
    cprintf("exec: fail\n");
80100c25:	c7 04 24 41 6f 10 80 	movl   $0x80106f41,(%esp)
80100c2c:	e8 1f fa ff ff       	call   80100650 <cprintf>
    return -1;
80100c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c36:	e9 d7 fd ff ff       	jmp    80100a12 <exec+0x72>
80100c3b:	89 f2                	mov    %esi,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c3d:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c44:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c48:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100c4f:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c55:	89 da                	mov    %ebx,%edx
80100c57:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100c59:	83 c0 0c             	add    $0xc,%eax
80100c5c:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c5e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c62:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c68:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c6c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c70:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c77:	ff ff ff 
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7a:	89 04 24             	mov    %eax,(%esp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c7d:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c83:	e8 28 61 00 00       	call   80106db0 <copyout>
80100c88:	85 c0                	test   %eax,%eax
80100c8a:	0f 88 78 ff ff ff    	js     80100c08 <exec+0x268>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c90:	8b 45 08             	mov    0x8(%ebp),%eax
80100c93:	0f b6 10             	movzbl (%eax),%edx
80100c96:	84 d2                	test   %dl,%dl
80100c98:	74 19                	je     80100cb3 <exec+0x313>
80100c9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c9d:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100ca0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ca6:	0f 44 c8             	cmove  %eax,%ecx
80100ca9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cac:	84 d2                	test   %dl,%dl
80100cae:	75 f0                	jne    80100ca0 <exec+0x300>
80100cb0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cb3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80100cbc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100cc3:	00 
80100cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc8:	89 f8                	mov    %edi,%eax
80100cca:	83 c0 74             	add    $0x74,%eax
80100ccd:	89 04 24             	mov    %eax,(%esp)
80100cd0:	e8 ab 37 00 00       	call   80104480 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100cd5:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cdb:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->userstack_top = userstack_top;
80100cde:	c7 47 18 00 e0 ff 7f 	movl   $0x7fffe000,0x18(%edi)
  curproc->tf->eip = elf.entry;  // main
80100ce5:	8b 47 20             	mov    0x20(%edi),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100ce8:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100ceb:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100cf1:	89 0f                	mov    %ecx,(%edi)
  curproc->userstack_top = userstack_top;
  curproc->tf->eip = elf.entry;  // main
80100cf3:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100cf9:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100cfc:	8b 47 20             	mov    0x20(%edi),%eax
80100cff:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d02:	89 3c 24             	mov    %edi,(%esp)
80100d05:	e8 a6 59 00 00       	call   801066b0 <switchuvm>
  freevm(oldpgdir);
80100d0a:	89 34 24             	mov    %esi,(%esp)
80100d0d:	e8 3e 5d 00 00       	call   80106a50 <freevm>
  return 0;
80100d12:	31 c0                	xor    %eax,%eax
80100d14:	e9 f9 fc ff ff       	jmp    80100a12 <exec+0x72>
    goto bad;
  //clearpteu(pgdir, (char*)(userstack_top)); //Old bug: NEEDS parenthesis around userstack_top


  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d19:	31 d2                	xor    %edx,%edx
80100d1b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d21:	e9 17 ff ff ff       	jmp    80100c3d <exec+0x29d>
80100d26:	66 90                	xchg   %ax,%ax
80100d28:	66 90                	xchg   %ax,%ax
80100d2a:	66 90                	xchg   %ax,%ax
80100d2c:	66 90                	xchg   %ax,%ax
80100d2e:	66 90                	xchg   %ax,%ax

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	c7 44 24 04 4d 6f 10 	movl   $0x80106f4d,0x4(%esp)
80100d3d:	80 
80100d3e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d45:	e8 26 33 00 00       	call   80104070 <initlock>
}
80100d4a:	c9                   	leave  
80100d4b:	c3                   	ret    
80100d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d59:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d5c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d63:	e8 f8 33 00 00       	call   80104160 <acquire>
80100d68:	eb 11                	jmp    80100d7b <filealloc+0x2b>
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d79:	74 25                	je     80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d89:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d90:	e8 bb 34 00 00       	call   80104250 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d95:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100d98:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d9a:	5b                   	pop    %ebx
80100d9b:	5d                   	pop    %ebp
80100d9c:	c3                   	ret    
80100d9d:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100da0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100da7:	e8 a4 34 00 00       	call   80104250 <release>
  return 0;
}
80100dac:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100daf:	31 c0                	xor    %eax,%eax
}
80100db1:	5b                   	pop    %ebx
80100db2:	5d                   	pop    %ebp
80100db3:	c3                   	ret    
80100db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 14             	sub    $0x14,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dd1:	e8 8a 33 00 00       	call   80104160 <acquire>
  if(f->ref < 1)
80100dd6:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd9:	85 c0                	test   %eax,%eax
80100ddb:	7e 1a                	jle    80100df7 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100ddd:	83 c0 01             	add    $0x1,%eax
80100de0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de3:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dea:	e8 61 34 00 00       	call   80104250 <release>
  return f;
}
80100def:	83 c4 14             	add    $0x14,%esp
80100df2:	89 d8                	mov    %ebx,%eax
80100df4:	5b                   	pop    %ebx
80100df5:	5d                   	pop    %ebp
80100df6:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100df7:	c7 04 24 54 6f 10 80 	movl   $0x80106f54,(%esp)
80100dfe:	e8 5d f5 ff ff       	call   80100360 <panic>
80100e03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 1c             	sub    $0x1c,%esp
80100e19:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e23:	e8 38 33 00 00       	call   80104160 <acquire>
  if(f->ref < 1)
80100e28:	8b 57 04             	mov    0x4(%edi),%edx
80100e2b:	85 d2                	test   %edx,%edx
80100e2d:	0f 8e 89 00 00 00    	jle    80100ebc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e33:	83 ea 01             	sub    $0x1,%edx
80100e36:	85 d2                	test   %edx,%edx
80100e38:	89 57 04             	mov    %edx,0x4(%edi)
80100e3b:	74 13                	je     80100e50 <fileclose+0x40>
    release(&ftable.lock);
80100e3d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e44:	83 c4 1c             	add    $0x1c,%esp
80100e47:	5b                   	pop    %ebx
80100e48:	5e                   	pop    %esi
80100e49:	5f                   	pop    %edi
80100e4a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e4b:	e9 00 34 00 00       	jmp    80104250 <release>
    return;
  }
  ff = *f;
80100e50:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e54:	8b 37                	mov    (%edi),%esi
80100e56:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e59:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e5f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e62:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e65:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e6f:	e8 dc 33 00 00       	call   80104250 <release>

  if(ff.type == FD_PIPE)
80100e74:	83 fe 01             	cmp    $0x1,%esi
80100e77:	74 0f                	je     80100e88 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e79:	83 fe 02             	cmp    $0x2,%esi
80100e7c:	74 22                	je     80100ea0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e7e:	83 c4 1c             	add    $0x1c,%esp
80100e81:	5b                   	pop    %ebx
80100e82:	5e                   	pop    %esi
80100e83:	5f                   	pop    %edi
80100e84:	5d                   	pop    %ebp
80100e85:	c3                   	ret    
80100e86:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e88:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100e8c:	89 1c 24             	mov    %ebx,(%esp)
80100e8f:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e93:	e8 b8 23 00 00       	call   80103250 <pipeclose>
80100e98:	eb e4                	jmp    80100e7e <fileclose+0x6e>
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ea0:	e8 5b 1c 00 00       	call   80102b00 <begin_op>
    iput(ff.ip);
80100ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ea8:	89 04 24             	mov    %eax,(%esp)
80100eab:	e8 10 09 00 00       	call   801017c0 <iput>
    end_op();
  }
}
80100eb0:	83 c4 1c             	add    $0x1c,%esp
80100eb3:	5b                   	pop    %ebx
80100eb4:	5e                   	pop    %esi
80100eb5:	5f                   	pop    %edi
80100eb6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eb7:	e9 b4 1c 00 00       	jmp    80102b70 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ebc:	c7 04 24 5c 6f 10 80 	movl   $0x80106f5c,(%esp)
80100ec3:	e8 98 f4 ff ff       	call   80100360 <panic>
80100ec8:	90                   	nop
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	53                   	push   %ebx
80100ed4:	83 ec 14             	sub    $0x14,%esp
80100ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100edd:	75 31                	jne    80100f10 <filestat+0x40>
    ilock(f->ip);
80100edf:	8b 43 10             	mov    0x10(%ebx),%eax
80100ee2:	89 04 24             	mov    %eax,(%esp)
80100ee5:	e8 b6 07 00 00       	call   801016a0 <ilock>
    stati(f->ip, st);
80100eea:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eed:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ef1:	8b 43 10             	mov    0x10(%ebx),%eax
80100ef4:	89 04 24             	mov    %eax,(%esp)
80100ef7:	e8 24 0a 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100efc:	8b 43 10             	mov    0x10(%ebx),%eax
80100eff:	89 04 24             	mov    %eax,(%esp)
80100f02:	e8 79 08 00 00       	call   80101780 <iunlock>
    return 0;
  }
  return -1;
}
80100f07:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f0a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f0c:	5b                   	pop    %ebx
80100f0d:	5d                   	pop    %ebp
80100f0e:	c3                   	ret    
80100f0f:	90                   	nop
80100f10:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f18:	5b                   	pop    %ebx
80100f19:	5d                   	pop    %ebp
80100f1a:	c3                   	ret    
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f20 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	83 ec 1c             	sub    $0x1c,%esp
80100f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f32:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f36:	74 68                	je     80100fa0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f38:	8b 03                	mov    (%ebx),%eax
80100f3a:	83 f8 01             	cmp    $0x1,%eax
80100f3d:	74 49                	je     80100f88 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f3f:	83 f8 02             	cmp    $0x2,%eax
80100f42:	75 63                	jne    80100fa7 <fileread+0x87>
    ilock(f->ip);
80100f44:	8b 43 10             	mov    0x10(%ebx),%eax
80100f47:	89 04 24             	mov    %eax,(%esp)
80100f4a:	e8 51 07 00 00       	call   801016a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f4f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f53:	8b 43 14             	mov    0x14(%ebx),%eax
80100f56:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f5a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f5e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f61:	89 04 24             	mov    %eax,(%esp)
80100f64:	e8 e7 09 00 00       	call   80101950 <readi>
80100f69:	85 c0                	test   %eax,%eax
80100f6b:	89 c6                	mov    %eax,%esi
80100f6d:	7e 03                	jle    80100f72 <fileread+0x52>
      f->off += r;
80100f6f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f72:	8b 43 10             	mov    0x10(%ebx),%eax
80100f75:	89 04 24             	mov    %eax,(%esp)
80100f78:	e8 03 08 00 00       	call   80101780 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f7f:	83 c4 1c             	add    $0x1c,%esp
80100f82:	5b                   	pop    %ebx
80100f83:	5e                   	pop    %esi
80100f84:	5f                   	pop    %edi
80100f85:	5d                   	pop    %ebp
80100f86:	c3                   	ret    
80100f87:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f88:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f8b:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f8e:	83 c4 1c             	add    $0x1c,%esp
80100f91:	5b                   	pop    %ebx
80100f92:	5e                   	pop    %esi
80100f93:	5f                   	pop    %edi
80100f94:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f95:	e9 36 24 00 00       	jmp    801033d0 <piperead>
80100f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fa5:	eb d8                	jmp    80100f7f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fa7:	c7 04 24 66 6f 10 80 	movl   $0x80106f66,(%esp)
80100fae:	e8 ad f3 ff ff       	call   80100360 <panic>
80100fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 2c             	sub    $0x2c,%esp
80100fc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fcc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fcf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fd5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fdc:	0f 84 ae 00 00 00    	je     80101090 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 07                	mov    (%edi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c2 00 00 00    	je     801010af <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d7 00 00 00    	jne    801010cd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff9:	31 db                	xor    %ebx,%ebx
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 31                	jg     80101030 <filewrite+0x70>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101008:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010100b:	01 47 14             	add    %eax,0x14(%edi)
8010100e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101011:	89 0c 24             	mov    %ecx,(%esp)
80101014:	e8 67 07 00 00       	call   80101780 <iunlock>
      end_op();
80101019:	e8 52 1b 00 00       	call   80102b70 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101021:	39 f0                	cmp    %esi,%eax
80101023:	0f 85 98 00 00 00    	jne    801010c1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101029:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010102b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010102e:	7e 70                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101030:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101033:	b8 00 1a 00 00       	mov    $0x1a00,%eax
80101038:	29 de                	sub    %ebx,%esi
8010103a:	81 fe 00 1a 00 00    	cmp    $0x1a00,%esi
80101040:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101043:	e8 b8 1a 00 00       	call   80102b00 <begin_op>
      ilock(f->ip);
80101048:	8b 47 10             	mov    0x10(%edi),%eax
8010104b:	89 04 24             	mov    %eax,(%esp)
8010104e:	e8 4d 06 00 00       	call   801016a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101053:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101057:	8b 47 14             	mov    0x14(%edi),%eax
8010105a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010105e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101061:	01 d8                	add    %ebx,%eax
80101063:	89 44 24 04          	mov    %eax,0x4(%esp)
80101067:	8b 47 10             	mov    0x10(%edi),%eax
8010106a:	89 04 24             	mov    %eax,(%esp)
8010106d:	e8 de 09 00 00       	call   80101a50 <writei>
80101072:	85 c0                	test   %eax,%eax
80101074:	7f 92                	jg     80101008 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101076:	8b 4f 10             	mov    0x10(%edi),%ecx
80101079:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010107c:	89 0c 24             	mov    %ecx,(%esp)
8010107f:	e8 fc 06 00 00       	call   80101780 <iunlock>
      end_op();
80101084:	e8 e7 1a 00 00       	call   80102b70 <end_op>

      if(r < 0)
80101089:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010108c:	85 c0                	test   %eax,%eax
8010108e:	74 91                	je     80101021 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101090:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
80101093:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101098:	5b                   	pop    %ebx
80101099:	5e                   	pop    %esi
8010109a:	5f                   	pop    %edi
8010109b:	5d                   	pop    %ebp
8010109c:	c3                   	ret    
8010109d:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010a0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010a3:	89 d8                	mov    %ebx,%eax
801010a5:	75 e9                	jne    80101090 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010a7:	83 c4 2c             	add    $0x2c,%esp
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010af:	8b 47 0c             	mov    0xc(%edi),%eax
801010b2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b5:	83 c4 2c             	add    $0x2c,%esp
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bc:	e9 1f 22 00 00       	jmp    801032e0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010c1:	c7 04 24 6f 6f 10 80 	movl   $0x80106f6f,(%esp)
801010c8:	e8 93 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010cd:	c7 04 24 75 6f 10 80 	movl   $0x80106f75,(%esp)
801010d4:	e8 87 f2 ff ff       	call   80100360 <panic>
801010d9:	66 90                	xchg   %ax,%ax
801010db:	66 90                	xchg   %ax,%ax
801010dd:	66 90                	xchg   %ax,%ax
801010df:	90                   	nop

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 2c             	sub    $0x2c,%esp
801010e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010ec:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801010f1:	85 c0                	test   %eax,%eax
801010f3:	0f 84 8c 00 00 00    	je     80101185 <balloc+0xa5>
801010f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101100:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101103:	89 f0                	mov    %esi,%eax
80101105:	c1 f8 0c             	sar    $0xc,%eax
80101108:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010110e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101112:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101115:	89 04 24             	mov    %eax,(%esp)
80101118:	e8 b3 ef ff ff       	call   801000d0 <bread>
8010111d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101120:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101125:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101128:	31 c0                	xor    %eax,%eax
8010112a:	eb 33                	jmp    8010115f <balloc+0x7f>
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101130:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101133:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101135:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101137:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	bf 01 00 00 00       	mov    $0x1,%edi
80101142:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101144:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101149:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010114b:	0f b6 fb             	movzbl %bl,%edi
8010114e:	85 cf                	test   %ecx,%edi
80101150:	74 46                	je     80101198 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101152:	83 c0 01             	add    $0x1,%eax
80101155:	83 c6 01             	add    $0x1,%esi
80101158:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010115d:	74 05                	je     80101164 <balloc+0x84>
8010115f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101162:	72 cc                	jb     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101167:	89 04 24             	mov    %eax,(%esp)
8010116a:	e8 71 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010116f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101176:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101179:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010117f:	0f 82 7b ff ff ff    	jb     80101100 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101185:	c7 04 24 7f 6f 10 80 	movl   $0x80106f7f,(%esp)
8010118c:	e8 cf f1 ff ff       	call   80100360 <panic>
80101191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101198:	09 d9                	or     %ebx,%ecx
8010119a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010119d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011a1:	89 1c 24             	mov    %ebx,(%esp)
801011a4:	e8 f7 1a 00 00       	call   80102ca0 <log_write>
        brelse(bp);
801011a9:	89 1c 24             	mov    %ebx,(%esp)
801011ac:	e8 2f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011b4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011b8:	89 04 24             	mov    %eax,(%esp)
801011bb:	e8 10 ef ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011c7:	00 
801011c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011cf:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011d0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011d5:	89 04 24             	mov    %eax,(%esp)
801011d8:	e8 c3 30 00 00       	call   801042a0 <memset>
  log_write(bp);
801011dd:	89 1c 24             	mov    %ebx,(%esp)
801011e0:	e8 bb 1a 00 00       	call   80102ca0 <log_write>
  brelse(bp);
801011e5:	89 1c 24             	mov    %ebx,(%esp)
801011e8:	e8 f3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011ed:	83 c4 2c             	add    $0x2c,%esp
801011f0:	89 f0                	mov    %esi,%eax
801011f2:	5b                   	pop    %ebx
801011f3:	5e                   	pop    %esi
801011f4:	5f                   	pop    %edi
801011f5:	5d                   	pop    %ebp
801011f6:	c3                   	ret    
801011f7:	89 f6                	mov    %esi,%esi
801011f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101200 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	89 c7                	mov    %eax,%edi
80101206:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101207:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101209:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010120f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101212:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101219:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010121c:	e8 3f 2f 00 00       	call   80104160 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101224:	eb 14                	jmp    8010123a <iget+0x3a>
80101226:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101228:	85 f6                	test   %esi,%esi
8010122a:	74 3c                	je     80101268 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101232:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101238:	74 46                	je     80101280 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010123a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010123d:	85 c9                	test   %ecx,%ecx
8010123f:	7e e7                	jle    80101228 <iget+0x28>
80101241:	39 3b                	cmp    %edi,(%ebx)
80101243:	75 e3                	jne    80101228 <iget+0x28>
80101245:	39 53 04             	cmp    %edx,0x4(%ebx)
80101248:	75 de                	jne    80101228 <iget+0x28>
      ip->ref++;
8010124a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010124d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010124f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101256:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101259:	e8 f2 2f 00 00       	call   80104250 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010125e:	83 c4 1c             	add    $0x1c,%esp
80101261:	89 f0                	mov    %esi,%eax
80101263:	5b                   	pop    %ebx
80101264:	5e                   	pop    %esi
80101265:	5f                   	pop    %edi
80101266:	5d                   	pop    %ebp
80101267:	c3                   	ret    
80101268:	85 c9                	test   %ecx,%ecx
8010126a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101273:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101279:	75 bf                	jne    8010123a <iget+0x3a>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 29                	je     801012ad <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101284:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101286:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101289:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101290:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101297:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010129e:	e8 ad 2f 00 00       	call   80104250 <release>

  return ip;
}
801012a3:	83 c4 1c             	add    $0x1c,%esp
801012a6:	89 f0                	mov    %esi,%eax
801012a8:	5b                   	pop    %ebx
801012a9:	5e                   	pop    %esi
801012aa:	5f                   	pop    %edi
801012ab:	5d                   	pop    %ebp
801012ac:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012ad:	c7 04 24 95 6f 10 80 	movl   $0x80106f95,(%esp)
801012b4:	e8 a7 f0 ff ff       	call   80100360 <panic>
801012b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c3                	mov    %eax,%ebx
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012d6:	85 c0                	test   %eax,%eax
801012d8:	74 66                	je     80101340 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	83 c4 1c             	add    $0x1c,%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012e8:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
801012eb:	83 fe 7f             	cmp    $0x7f,%esi
801012ee:	77 77                	ja     80101367 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 5e                	je     80101358 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801012fe:	8b 03                	mov    (%ebx),%eax
80101300:	89 04 24             	mov    %eax,(%esp)
80101303:	e8 c8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101308:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010130c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010130e:	8b 32                	mov    (%edx),%esi
80101310:	85 f6                	test   %esi,%esi
80101312:	75 19                	jne    8010132d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101314:	8b 03                	mov    (%ebx),%eax
80101316:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101319:	e8 c2 fd ff ff       	call   801010e0 <balloc>
8010131e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101321:	89 02                	mov    %eax,(%edx)
80101323:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101325:	89 3c 24             	mov    %edi,(%esp)
80101328:	e8 73 19 00 00       	call   80102ca0 <log_write>
    }
    brelse(bp);
8010132d:	89 3c 24             	mov    %edi,(%esp)
80101330:	e8 ab ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101335:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101338:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010133a:	5b                   	pop    %ebx
8010133b:	5e                   	pop    %esi
8010133c:	5f                   	pop    %edi
8010133d:	5d                   	pop    %ebp
8010133e:	c3                   	ret    
8010133f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101340:	8b 03                	mov    (%ebx),%eax
80101342:	e8 99 fd ff ff       	call   801010e0 <balloc>
80101347:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	83 c4 1c             	add    $0x1c,%esp
8010134d:	5b                   	pop    %ebx
8010134e:	5e                   	pop    %esi
8010134f:	5f                   	pop    %edi
80101350:	5d                   	pop    %ebp
80101351:	c3                   	ret    
80101352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101358:	8b 03                	mov    (%ebx),%eax
8010135a:	e8 81 fd ff ff       	call   801010e0 <balloc>
8010135f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101365:	eb 93                	jmp    801012fa <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101367:	c7 04 24 a5 6f 10 80 	movl   $0x80106fa5,(%esp)
8010136e:	e8 ed ef ff ff       	call   80100360 <panic>
80101373:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101380 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	56                   	push   %esi
80101384:	53                   	push   %ebx
80101385:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101388:	8b 45 08             	mov    0x8(%ebp),%eax
8010138b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101392:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101393:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101396:	89 04 24             	mov    %eax,(%esp)
80101399:	e8 32 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010139e:	89 34 24             	mov    %esi,(%esp)
801013a1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013a8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013a9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013ab:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ae:	89 44 24 04          	mov    %eax,0x4(%esp)
801013b2:	e8 89 2f 00 00       	call   80104340 <memmove>
  brelse(bp);
801013b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013ba:	83 c4 10             	add    $0x10,%esp
801013bd:	5b                   	pop    %ebx
801013be:	5e                   	pop    %esi
801013bf:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013c0:	e9 1b ee ff ff       	jmp    801001e0 <brelse>
801013c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	57                   	push   %edi
801013d4:	89 d7                	mov    %edx,%edi
801013d6:	56                   	push   %esi
801013d7:	53                   	push   %ebx
801013d8:	89 c3                	mov    %eax,%ebx
801013da:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013dd:	89 04 24             	mov    %eax,(%esp)
801013e0:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801013e7:	80 
801013e8:	e8 93 ff ff ff       	call   80101380 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013ed:	89 fa                	mov    %edi,%edx
801013ef:	c1 ea 0c             	shr    $0xc,%edx
801013f2:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801013f8:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
801013fb:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101400:	89 54 24 04          	mov    %edx,0x4(%esp)
80101404:	e8 c7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101409:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010140b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101411:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101413:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101416:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101419:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010141b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010141d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101422:	0f b6 c8             	movzbl %al,%ecx
80101425:	85 d9                	test   %ebx,%ecx
80101427:	74 20                	je     80101449 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101429:	f7 d3                	not    %ebx
8010142b:	21 c3                	and    %eax,%ebx
8010142d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 67 18 00 00       	call   80102ca0 <log_write>
  brelse(bp);
80101439:	89 34 24             	mov    %esi,(%esp)
8010143c:	e8 9f ed ff ff       	call   801001e0 <brelse>
}
80101441:	83 c4 1c             	add    $0x1c,%esp
80101444:	5b                   	pop    %ebx
80101445:	5e                   	pop    %esi
80101446:	5f                   	pop    %edi
80101447:	5d                   	pop    %ebp
80101448:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101449:	c7 04 24 b8 6f 10 80 	movl   $0x80106fb8,(%esp)
80101450:	e8 0b ef ff ff       	call   80100360 <panic>
80101455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101460 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101469:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010146c:	c7 44 24 04 cb 6f 10 	movl   $0x80106fcb,0x4(%esp)
80101473:	80 
80101474:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010147b:	e8 f0 2b 00 00       	call   80104070 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101480:	89 1c 24             	mov    %ebx,(%esp)
80101483:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101489:	c7 44 24 04 d2 6f 10 	movl   $0x80106fd2,0x4(%esp)
80101490:	80 
80101491:	e8 ca 2a 00 00       	call   80103f60 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101496:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010149c:	75 e2                	jne    80101480 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010149e:	8b 45 08             	mov    0x8(%ebp),%eax
801014a1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014a8:	80 
801014a9:	89 04 24             	mov    %eax,(%esp)
801014ac:	e8 cf fe ff ff       	call   80101380 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014b1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014b6:	c7 04 24 38 70 10 80 	movl   $0x80107038,(%esp)
801014bd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014c1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014c6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ca:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014cf:	89 44 24 14          	mov    %eax,0x14(%esp)
801014d3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014d8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014dc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801014e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801014e5:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801014ea:	89 44 24 08          	mov    %eax,0x8(%esp)
801014ee:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801014f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801014f7:	e8 54 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014fc:	83 c4 24             	add    $0x24,%esp
801014ff:	5b                   	pop    %ebx
80101500:	5d                   	pop    %ebp
80101501:	c3                   	ret    
80101502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101510 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	57                   	push   %edi
80101514:	56                   	push   %esi
80101515:	53                   	push   %ebx
80101516:	83 ec 2c             	sub    $0x2c,%esp
80101519:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010151c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101523:	8b 7d 08             	mov    0x8(%ebp),%edi
80101526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	0f 86 a2 00 00 00    	jbe    801015d1 <ialloc+0xc1>
8010152f:	be 01 00 00 00       	mov    $0x1,%esi
80101534:	bb 01 00 00 00       	mov    $0x1,%ebx
80101539:	eb 1a                	jmp    80101555 <ialloc+0x45>
8010153b:	90                   	nop
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101540:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101543:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101546:	e8 95 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010154b:	89 de                	mov    %ebx,%esi
8010154d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101553:	73 7c                	jae    801015d1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101555:	89 f0                	mov    %esi,%eax
80101557:	c1 e8 03             	shr    $0x3,%eax
8010155a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101560:	89 3c 24             	mov    %edi,(%esp)
80101563:	89 44 24 04          	mov    %eax,0x4(%esp)
80101567:	e8 64 eb ff ff       	call   801000d0 <bread>
8010156c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010156e:	89 f0                	mov    %esi,%eax
80101570:	83 e0 07             	and    $0x7,%eax
80101573:	c1 e0 06             	shl    $0x6,%eax
80101576:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010157a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010157e:	75 c0                	jne    80101540 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101580:	89 0c 24             	mov    %ecx,(%esp)
80101583:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010158a:	00 
8010158b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101592:	00 
80101593:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	e8 02 2d 00 00       	call   801042a0 <memset>
      dip->type = type;
8010159e:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015a2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015ab:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ae:	89 14 24             	mov    %edx,(%esp)
801015b1:	e8 ea 16 00 00       	call   80102ca0 <log_write>
      brelse(bp);
801015b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015b9:	89 14 24             	mov    %edx,(%esp)
801015bc:	e8 1f ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015c1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015c4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015c6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015c7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015c9:	5e                   	pop    %esi
801015ca:	5f                   	pop    %edi
801015cb:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015cc:	e9 2f fc ff ff       	jmp    80101200 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015d1:	c7 04 24 d8 6f 10 80 	movl   $0x80106fd8,(%esp)
801015d8:	e8 83 ed ff ff       	call   80100360 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	83 ec 10             	sub    $0x10,%esp
801015e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801015fe:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101601:	89 04 24             	mov    %eax,(%esp)
80101604:	e8 c7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101609:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010160c:	83 e2 07             	and    $0x7,%edx
8010160f:	c1 e2 06             	shl    $0x6,%edx
80101612:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101616:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101618:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010161f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101623:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101627:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010162b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010162f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101633:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101637:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010163b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010163e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101641:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101645:	89 14 24             	mov    %edx,(%esp)
80101648:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010164f:	00 
80101650:	e8 eb 2c 00 00       	call   80104340 <memmove>
  log_write(bp);
80101655:	89 34 24             	mov    %esi,(%esp)
80101658:	e8 43 16 00 00       	call   80102ca0 <log_write>
  brelse(bp);
8010165d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101660:	83 c4 10             	add    $0x10,%esp
80101663:	5b                   	pop    %ebx
80101664:	5e                   	pop    %esi
80101665:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101666:	e9 75 eb ff ff       	jmp    801001e0 <brelse>
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	83 ec 14             	sub    $0x14,%esp
80101677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010167a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101681:	e8 da 2a 00 00       	call   80104160 <acquire>
  ip->ref++;
80101686:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010168a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101691:	e8 ba 2b 00 00       	call   80104250 <release>
  return ip;
}
80101696:	83 c4 14             	add    $0x14,%esp
80101699:	89 d8                	mov    %ebx,%eax
8010169b:	5b                   	pop    %ebx
8010169c:	5d                   	pop    %ebp
8010169d:	c3                   	ret    
8010169e:	66 90                	xchg   %ax,%ax

801016a0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	83 ec 10             	sub    $0x10,%esp
801016a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016ab:	85 db                	test   %ebx,%ebx
801016ad:	0f 84 b3 00 00 00    	je     80101766 <ilock+0xc6>
801016b3:	8b 53 08             	mov    0x8(%ebx),%edx
801016b6:	85 d2                	test   %edx,%edx
801016b8:	0f 8e a8 00 00 00    	jle    80101766 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016be:	8d 43 0c             	lea    0xc(%ebx),%eax
801016c1:	89 04 24             	mov    %eax,(%esp)
801016c4:	e8 d7 28 00 00       	call   80103fa0 <acquiresleep>

  if(ip->valid == 0){
801016c9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016cc:	85 c0                	test   %eax,%eax
801016ce:	74 08                	je     801016d8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016d0:	83 c4 10             	add    $0x10,%esp
801016d3:	5b                   	pop    %ebx
801016d4:	5e                   	pop    %esi
801016d5:	5d                   	pop    %ebp
801016d6:	c3                   	ret    
801016d7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
801016db:	c1 e8 03             	shr    $0x3,%eax
801016de:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801016e8:	8b 03                	mov    (%ebx),%eax
801016ea:	89 04 24             	mov    %eax,(%esp)
801016ed:	e8 de e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f2:	8b 53 04             	mov    0x4(%ebx),%edx
801016f5:	83 e2 07             	and    $0x7,%edx
801016f8:	c1 e2 06             	shl    $0x6,%edx
801016fb:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ff:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101701:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101704:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101707:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010170b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010170f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101713:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101717:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010171b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010171f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101723:	8b 42 fc             	mov    -0x4(%edx),%eax
80101726:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101729:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010172c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101730:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101737:	00 
80101738:	89 04 24             	mov    %eax,(%esp)
8010173b:	e8 00 2c 00 00       	call   80104340 <memmove>
    brelse(bp);
80101740:	89 34 24             	mov    %esi,(%esp)
80101743:	e8 98 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101748:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010174d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101754:	0f 85 76 ff ff ff    	jne    801016d0 <ilock+0x30>
      panic("ilock: no type");
8010175a:	c7 04 24 f0 6f 10 80 	movl   $0x80106ff0,(%esp)
80101761:	e8 fa eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101766:	c7 04 24 ea 6f 10 80 	movl   $0x80106fea,(%esp)
8010176d:	e8 ee eb ff ff       	call   80100360 <panic>
80101772:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101780 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010178b:	85 db                	test   %ebx,%ebx
8010178d:	74 24                	je     801017b3 <iunlock+0x33>
8010178f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101792:	89 34 24             	mov    %esi,(%esp)
80101795:	e8 a6 28 00 00       	call   80104040 <holdingsleep>
8010179a:	85 c0                	test   %eax,%eax
8010179c:	74 15                	je     801017b3 <iunlock+0x33>
8010179e:	8b 43 08             	mov    0x8(%ebx),%eax
801017a1:	85 c0                	test   %eax,%eax
801017a3:	7e 0e                	jle    801017b3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017a5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	5b                   	pop    %ebx
801017ac:	5e                   	pop    %esi
801017ad:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ae:	e9 4d 28 00 00       	jmp    80104000 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017b3:	c7 04 24 ff 6f 10 80 	movl   $0x80106fff,(%esp)
801017ba:	e8 a1 eb ff ff       	call   80100360 <panic>
801017bf:	90                   	nop

801017c0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 1c             	sub    $0x1c,%esp
801017c9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017cc:	8d 7e 0c             	lea    0xc(%esi),%edi
801017cf:	89 3c 24             	mov    %edi,(%esp)
801017d2:	e8 c9 27 00 00       	call   80103fa0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017da:	85 d2                	test   %edx,%edx
801017dc:	74 07                	je     801017e5 <iput+0x25>
801017de:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017e3:	74 2b                	je     80101810 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017e5:	89 3c 24             	mov    %edi,(%esp)
801017e8:	e8 13 28 00 00       	call   80104000 <releasesleep>

  acquire(&icache.lock);
801017ed:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f4:	e8 67 29 00 00       	call   80104160 <acquire>
  ip->ref--;
801017f9:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017fd:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101804:	83 c4 1c             	add    $0x1c,%esp
80101807:	5b                   	pop    %ebx
80101808:	5e                   	pop    %esi
80101809:	5f                   	pop    %edi
8010180a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010180b:	e9 40 2a 00 00       	jmp    80104250 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101810:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101817:	e8 44 29 00 00       	call   80104160 <acquire>
    int r = ip->ref;
8010181c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010181f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101826:	e8 25 2a 00 00       	call   80104250 <release>
    if(r == 1){
8010182b:	83 fb 01             	cmp    $0x1,%ebx
8010182e:	75 b5                	jne    801017e5 <iput+0x25>
80101830:	8d 4e 30             	lea    0x30(%esi),%ecx
80101833:	89 f3                	mov    %esi,%ebx
80101835:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101838:	89 cf                	mov    %ecx,%edi
8010183a:	eb 0b                	jmp    80101847 <iput+0x87>
8010183c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101840:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101843:	39 fb                	cmp    %edi,%ebx
80101845:	74 19                	je     80101860 <iput+0xa0>
    if(ip->addrs[i]){
80101847:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010184a:	85 d2                	test   %edx,%edx
8010184c:	74 f2                	je     80101840 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010184e:	8b 06                	mov    (%esi),%eax
80101850:	e8 7b fb ff ff       	call   801013d0 <bfree>
      ip->addrs[i] = 0;
80101855:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010185c:	eb e2                	jmp    80101840 <iput+0x80>
8010185e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101860:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101866:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101869:	85 c0                	test   %eax,%eax
8010186b:	75 2b                	jne    80101898 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010186d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101874:	89 34 24             	mov    %esi,(%esp)
80101877:	e8 64 fd ff ff       	call   801015e0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010187c:	31 c0                	xor    %eax,%eax
8010187e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101882:	89 34 24             	mov    %esi,(%esp)
80101885:	e8 56 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010188a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101891:	e9 4f ff ff ff       	jmp    801017e5 <iput+0x25>
80101896:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101898:	89 44 24 04          	mov    %eax,0x4(%esp)
8010189c:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
8010189e:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018a0:	89 04 24             	mov    %eax,(%esp)
801018a3:	e8 28 e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018a8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018ab:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018b1:	89 cf                	mov    %ecx,%edi
801018b3:	31 c0                	xor    %eax,%eax
801018b5:	eb 0e                	jmp    801018c5 <iput+0x105>
801018b7:	90                   	nop
801018b8:	83 c3 01             	add    $0x1,%ebx
801018bb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018c1:	89 d8                	mov    %ebx,%eax
801018c3:	74 10                	je     801018d5 <iput+0x115>
      if(a[j])
801018c5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018c8:	85 d2                	test   %edx,%edx
801018ca:	74 ec                	je     801018b8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018cc:	8b 06                	mov    (%esi),%eax
801018ce:	e8 fd fa ff ff       	call   801013d0 <bfree>
801018d3:	eb e3                	jmp    801018b8 <iput+0xf8>
    }
    brelse(bp);
801018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018db:	89 04 24             	mov    %eax,(%esp)
801018de:	e8 fd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018e3:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e9:	8b 06                	mov    (%esi),%eax
801018eb:	e8 e0 fa ff ff       	call   801013d0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018f0:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f7:	00 00 00 
801018fa:	e9 6e ff ff ff       	jmp    8010186d <iput+0xad>
801018ff:	90                   	nop

80101900 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 14             	sub    $0x14,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	89 1c 24             	mov    %ebx,(%esp)
8010190d:	e8 6e fe ff ff       	call   80101780 <iunlock>
  iput(ip);
80101912:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101915:	83 c4 14             	add    $0x14,%esp
80101918:	5b                   	pop    %ebx
80101919:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010191a:	e9 a1 fe ff ff       	jmp    801017c0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 2c             	sub    $0x2c,%esp
80101959:	8b 45 0c             	mov    0xc(%ebp),%eax
8010195c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
80101962:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101965:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101968:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010196d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101970:	0f 84 aa 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101976:	8b 47 58             	mov    0x58(%edi),%eax
80101979:	39 f0                	cmp    %esi,%eax
8010197b:	0f 82 c7 00 00 00    	jb     80101a48 <readi+0xf8>
80101981:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101984:	89 da                	mov    %ebx,%edx
80101986:	01 f2                	add    %esi,%edx
80101988:	0f 82 ba 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010198e:	89 c1                	mov    %eax,%ecx
80101990:	29 f1                	sub    %esi,%ecx
80101992:	39 d0                	cmp    %edx,%eax
80101994:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101997:	31 c0                	xor    %eax,%eax
80101999:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010199b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199e:	74 70                	je     80101a10 <readi+0xc0>
801019a0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019a3:	89 c7                	mov    %eax,%edi
801019a5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019a8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019ab:	89 f2                	mov    %esi,%edx
801019ad:	c1 ea 09             	shr    $0x9,%edx
801019b0:	89 d8                	mov    %ebx,%eax
801019b2:	e8 09 f9 ff ff       	call   801012c0 <bmap>
801019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019bb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019bd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c2:	89 04 24             	mov    %eax,(%esp)
801019c5:	e8 06 e7 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019cd:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	89 f0                	mov    %esi,%eax
801019d3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019d8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019da:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019de:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801019e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019e7:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ea:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ee:	01 df                	add    %ebx,%edi
801019f0:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
801019f5:	89 04 24             	mov    %eax,(%esp)
801019f8:	e8 43 29 00 00       	call   80104340 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a0e:	77 98                	ja     801019a8 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a13:	83 c4 2c             	add    $0x2c,%esp
80101a16:	5b                   	pop    %ebx
80101a17:	5e                   	pop    %esi
80101a18:	5f                   	pop    %edi
80101a19:	5d                   	pop    %ebp
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a35:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a38:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a3b:	83 c4 2c             	add    $0x2c,%esp
80101a3e:	5b                   	pop    %ebx
80101a3f:	5e                   	pop    %esi
80101a40:	5f                   	pop    %edi
80101a41:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a42:	ff e0                	jmp    *%eax
80101a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c4                	jmp    80101a13 <readi+0xc3>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 2c             	sub    $0x2c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a6d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a70:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 e3 00 00 00    	jb     80101b68 <writei+0x118>
80101a85:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101a88:	89 c8                	mov    %ecx,%eax
80101a8a:	01 f0                	add    %esi,%eax
80101a8c:	0f 82 d6 00 00 00    	jb     80101b68 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a92:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a97:	0f 87 cb 00 00 00    	ja     80101b68 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9d:	85 c9                	test   %ecx,%ecx
80101a9f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa6:	74 77                	je     80101b1f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aab:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aad:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab2:	c1 ea 09             	shr    $0x9,%edx
80101ab5:	89 f8                	mov    %edi,%eax
80101ab7:	e8 04 f8 ff ff       	call   801012c0 <bmap>
80101abc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ac0:	8b 07                	mov    (%edi),%eax
80101ac2:	89 04 24             	mov    %eax,(%esp)
80101ac5:	e8 06 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aca:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101acd:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ad0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad5:	89 f0                	mov    %esi,%eax
80101ad7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101adc:	29 c3                	sub    %eax,%ebx
80101ade:	39 cb                	cmp    %ecx,%ebx
80101ae0:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae7:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101aed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101af1:	89 04 24             	mov    %eax,(%esp)
80101af4:	e8 47 28 00 00       	call   80104340 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 9f 11 00 00       	call   80102ca0 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b0f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b12:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b15:	77 91                	ja     80101aa8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b17:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b1d:	72 39                	jb     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b22:	83 c4 2c             	add    $0x2c,%esp
80101b25:	5b                   	pop    %ebx
80101b26:	5e                   	pop    %esi
80101b27:	5f                   	pop    %edi
80101b28:	5d                   	pop    %ebp
80101b29:	c3                   	ret    
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 2e                	ja     80101b68 <writei+0x118>
80101b3a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 23                	je     80101b68 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b48:	83 c4 2c             	add    $0x2c,%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b5e:	89 04 24             	mov    %eax,(%esp)
80101b61:	e8 7a fa ff ff       	call   801015e0 <iupdate>
80101b66:	eb b7                	jmp    80101b1f <writei+0xcf>
  }
  return n;
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b70:	5b                   	pop    %ebx
80101b71:	5e                   	pop    %esi
80101b72:	5f                   	pop    %edi
80101b73:	5d                   	pop    %ebp
80101b74:	c3                   	ret    
80101b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b89:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b90:	00 
80101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b95:	8b 45 08             	mov    0x8(%ebp),%eax
80101b98:	89 04 24             	mov    %eax,(%esp)
80101b9b:	e8 20 28 00 00       	call   801043c0 <strncmp>
}
80101ba0:	c9                   	leave  
80101ba1:	c3                   	ret    
80101ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 2c             	sub    $0x2c,%esp
80101bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bbc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bc1:	0f 85 97 00 00 00    	jne    80101c5e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bc7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bca:	31 ff                	xor    %edi,%edi
80101bcc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bcf:	85 d2                	test   %edx,%edx
80101bd1:	75 0d                	jne    80101be0 <dirlookup+0x30>
80101bd3:	eb 73                	jmp    80101c48 <dirlookup+0x98>
80101bd5:	8d 76 00             	lea    0x0(%esi),%esi
80101bd8:	83 c7 10             	add    $0x10,%edi
80101bdb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bde:	76 68                	jbe    80101c48 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101be7:	00 
80101be8:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101bec:	89 74 24 04          	mov    %esi,0x4(%esp)
80101bf0:	89 1c 24             	mov    %ebx,(%esp)
80101bf3:	e8 58 fd ff ff       	call   80101950 <readi>
80101bf8:	83 f8 10             	cmp    $0x10,%eax
80101bfb:	75 55                	jne    80101c52 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfd:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c02:	74 d4                	je     80101bd8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c04:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c0e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c15:	00 
80101c16:	89 04 24             	mov    %eax,(%esp)
80101c19:	e8 a2 27 00 00       	call   801043c0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c1e:	85 c0                	test   %eax,%eax
80101c20:	75 b6                	jne    80101bd8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c22:	8b 45 10             	mov    0x10(%ebp),%eax
80101c25:	85 c0                	test   %eax,%eax
80101c27:	74 05                	je     80101c2e <dirlookup+0x7e>
        *poff = off;
80101c29:	8b 45 10             	mov    0x10(%ebp),%eax
80101c2c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c2e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c32:	8b 03                	mov    (%ebx),%eax
80101c34:	e8 c7 f5 ff ff       	call   80101200 <iget>
    }
  }

  return 0;
}
80101c39:	83 c4 2c             	add    $0x2c,%esp
80101c3c:	5b                   	pop    %ebx
80101c3d:	5e                   	pop    %esi
80101c3e:	5f                   	pop    %edi
80101c3f:	5d                   	pop    %ebp
80101c40:	c3                   	ret    
80101c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c48:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c4b:	31 c0                	xor    %eax,%eax
}
80101c4d:	5b                   	pop    %ebx
80101c4e:	5e                   	pop    %esi
80101c4f:	5f                   	pop    %edi
80101c50:	5d                   	pop    %ebp
80101c51:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c52:	c7 04 24 19 70 10 80 	movl   $0x80107019,(%esp)
80101c59:	e8 02 e7 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c5e:	c7 04 24 07 70 10 80 	movl   $0x80107007,(%esp)
80101c65:	e8 f6 e6 ff ff       	call   80100360 <panic>
80101c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	89 cf                	mov    %ecx,%edi
80101c76:	56                   	push   %esi
80101c77:	53                   	push   %ebx
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c83:	0f 84 51 01 00 00    	je     80101dda <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 02 1a 00 00       	call   80103690 <myproc>
80101c8e:	8b 70 70             	mov    0x70(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c91:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c98:	e8 c3 24 00 00       	call   80104160 <acquire>
  ip->ref++;
80101c9d:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca8:	e8 a3 25 00 00       	call   80104250 <release>
80101cad:	eb 04                	jmp    80101cb3 <namex+0x43>
80101caf:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cb0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cb3:	0f b6 03             	movzbl (%ebx),%eax
80101cb6:	3c 2f                	cmp    $0x2f,%al
80101cb8:	74 f6                	je     80101cb0 <namex+0x40>
    path++;
  if(*path == 0)
80101cba:	84 c0                	test   %al,%al
80101cbc:	0f 84 ed 00 00 00    	je     80101daf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cc2:	0f b6 03             	movzbl (%ebx),%eax
80101cc5:	89 da                	mov    %ebx,%edx
80101cc7:	84 c0                	test   %al,%al
80101cc9:	0f 84 b1 00 00 00    	je     80101d80 <namex+0x110>
80101ccf:	3c 2f                	cmp    $0x2f,%al
80101cd1:	75 0f                	jne    80101ce2 <namex+0x72>
80101cd3:	e9 a8 00 00 00       	jmp    80101d80 <namex+0x110>
80101cd8:	3c 2f                	cmp    $0x2f,%al
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101ce0:	74 0a                	je     80101cec <namex+0x7c>
    path++;
80101ce2:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101ce5:	0f b6 02             	movzbl (%edx),%eax
80101ce8:	84 c0                	test   %al,%al
80101cea:	75 ec                	jne    80101cd8 <namex+0x68>
80101cec:	89 d1                	mov    %edx,%ecx
80101cee:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cf0:	83 f9 0d             	cmp    $0xd,%ecx
80101cf3:	0f 8e 8f 00 00 00    	jle    80101d88 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cf9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101cfd:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d04:	00 
80101d05:	89 3c 24             	mov    %edi,(%esp)
80101d08:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d0b:	e8 30 26 00 00       	call   80104340 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d13:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d15:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d18:	75 0e                	jne    80101d28 <namex+0xb8>
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	89 34 24             	mov    %esi,(%esp)
80101d2b:	e8 70 f9 ff ff       	call   801016a0 <ilock>
    if(ip->type != T_DIR){
80101d30:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d35:	0f 85 85 00 00 00    	jne    80101dc0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d3e:	85 d2                	test   %edx,%edx
80101d40:	74 09                	je     80101d4b <namex+0xdb>
80101d42:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d45:	0f 84 a5 00 00 00    	je     80101df0 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d52:	00 
80101d53:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d57:	89 34 24             	mov    %esi,(%esp)
80101d5a:	e8 51 fe ff ff       	call   80101bb0 <dirlookup>
80101d5f:	85 c0                	test   %eax,%eax
80101d61:	74 5d                	je     80101dc0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d63:	89 34 24             	mov    %esi,(%esp)
80101d66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d69:	e8 12 fa ff ff       	call   80101780 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	89 c6                	mov    %eax,%esi
80101d7b:	e9 33 ff ff ff       	jmp    80101cb3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d80:	31 c9                	xor    %ecx,%ecx
80101d82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d88:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101d8c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d90:	89 3c 24             	mov    %edi,(%esp)
80101d93:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d96:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d99:	e8 a2 25 00 00       	call   80104340 <memmove>
    name[len] = 0;
80101d9e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101da8:	89 d3                	mov    %edx,%ebx
80101daa:	e9 66 ff ff ff       	jmp    80101d15 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101daf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101db2:	85 c0                	test   %eax,%eax
80101db4:	75 4c                	jne    80101e02 <namex+0x192>
80101db6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101db8:	83 c4 2c             	add    $0x2c,%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
80101dbf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dc0:	89 34 24             	mov    %esi,(%esp)
80101dc3:	e8 b8 f9 ff ff       	call   80101780 <iunlock>
  iput(ip);
80101dc8:	89 34 24             	mov    %esi,(%esp)
80101dcb:	e8 f0 f9 ff ff       	call   801017c0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101dd3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd5:	5b                   	pop    %ebx
80101dd6:	5e                   	pop    %esi
80101dd7:	5f                   	pop    %edi
80101dd8:	5d                   	pop    %ebp
80101dd9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dda:	ba 01 00 00 00       	mov    $0x1,%edx
80101ddf:	b8 01 00 00 00       	mov    $0x1,%eax
80101de4:	e8 17 f4 ff ff       	call   80101200 <iget>
80101de9:	89 c6                	mov    %eax,%esi
80101deb:	e9 c3 fe ff ff       	jmp    80101cb3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101df0:	89 34 24             	mov    %esi,(%esp)
80101df3:	e8 88 f9 ff ff       	call   80101780 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101df8:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dfb:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dfd:	5b                   	pop    %ebx
80101dfe:	5e                   	pop    %esi
80101dff:	5f                   	pop    %edi
80101e00:	5d                   	pop    %ebp
80101e01:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e02:	89 34 24             	mov    %esi,(%esp)
80101e05:	e8 b6 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e0a:	31 c0                	xor    %eax,%eax
80101e0c:	eb aa                	jmp    80101db8 <namex+0x148>
80101e0e:	66 90                	xchg   %ax,%ax

80101e10 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 2c             	sub    $0x2c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e26:	00 
80101e27:	89 1c 24             	mov    %ebx,(%esp)
80101e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e2e:	e8 7d fd ff ff       	call   80101bb0 <dirlookup>
80101e33:	85 c0                	test   %eax,%eax
80101e35:	0f 85 8b 00 00 00    	jne    80101ec6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e3b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e3e:	31 ff                	xor    %edi,%edi
80101e40:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e43:	85 c0                	test   %eax,%eax
80101e45:	75 13                	jne    80101e5a <dirlink+0x4a>
80101e47:	eb 35                	jmp    80101e7e <dirlink+0x6e>
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e50:	8d 57 10             	lea    0x10(%edi),%edx
80101e53:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e56:	89 d7                	mov    %edx,%edi
80101e58:	76 24                	jbe    80101e7e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e5a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e61:	00 
80101e62:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e66:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e6a:	89 1c 24             	mov    %ebx,(%esp)
80101e6d:	e8 de fa ff ff       	call   80101950 <readi>
80101e72:	83 f8 10             	cmp    $0x10,%eax
80101e75:	75 5e                	jne    80101ed5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e77:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7c:	75 d2                	jne    80101e50 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e81:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101e88:	00 
80101e89:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e8d:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e90:	89 04 24             	mov    %eax,(%esp)
80101e93:	e8 98 25 00 00       	call   80104430 <strncpy>
  de.inum = inum;
80101e98:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ea2:	00 
80101ea3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ea7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eab:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101eae:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb2:	e8 99 fb ff ff       	call   80101a50 <writei>
80101eb7:	83 f8 10             	cmp    $0x10,%eax
80101eba:	75 25                	jne    80101ee1 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101ebc:	31 c0                	xor    %eax,%eax
}
80101ebe:	83 c4 2c             	add    $0x2c,%esp
80101ec1:	5b                   	pop    %ebx
80101ec2:	5e                   	pop    %esi
80101ec3:	5f                   	pop    %edi
80101ec4:	5d                   	pop    %ebp
80101ec5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ec6:	89 04 24             	mov    %eax,(%esp)
80101ec9:	e8 f2 f8 ff ff       	call   801017c0 <iput>
    return -1;
80101ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ed3:	eb e9                	jmp    80101ebe <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ed5:	c7 04 24 28 70 10 80 	movl   $0x80107028,(%esp)
80101edc:	e8 7f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ee1:	c7 04 24 26 76 10 80 	movl   $0x80107626,(%esp)
80101ee8:	e8 73 e4 ff ff       	call   80100360 <panic>
80101eed:	8d 76 00             	lea    0x0(%esi),%esi

80101ef0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	56                   	push   %esi
80101f34:	89 c6                	mov    %eax,%esi
80101f36:	53                   	push   %ebx
80101f37:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f3a:	85 c0                	test   %eax,%eax
80101f3c:	0f 84 99 00 00 00    	je     80101fdb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f42:	8b 48 08             	mov    0x8(%eax),%ecx
80101f45:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f4b:	0f 87 7e 00 00 00    	ja     80101fcf <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f51:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f56:	66 90                	xchg   %ax,%ax
80101f58:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f59:	83 e0 c0             	and    $0xffffffc0,%eax
80101f5c:	3c 40                	cmp    $0x40,%al
80101f5e:	75 f8                	jne    80101f58 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f60:	31 db                	xor    %ebx,%ebx
80101f62:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f67:	89 d8                	mov    %ebx,%eax
80101f69:	ee                   	out    %al,(%dx)
80101f6a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f6f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f74:	ee                   	out    %al,(%dx)
80101f75:	0f b6 c1             	movzbl %cl,%eax
80101f78:	b2 f3                	mov    $0xf3,%dl
80101f7a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f7b:	89 c8                	mov    %ecx,%eax
80101f7d:	b2 f4                	mov    $0xf4,%dl
80101f7f:	c1 f8 08             	sar    $0x8,%eax
80101f82:	ee                   	out    %al,(%dx)
80101f83:	b2 f5                	mov    $0xf5,%dl
80101f85:	89 d8                	mov    %ebx,%eax
80101f87:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f88:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f8c:	b2 f6                	mov    $0xf6,%dl
80101f8e:	83 e0 01             	and    $0x1,%eax
80101f91:	c1 e0 04             	shl    $0x4,%eax
80101f94:	83 c8 e0             	or     $0xffffffe0,%eax
80101f97:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101f98:	f6 06 04             	testb  $0x4,(%esi)
80101f9b:	75 13                	jne    80101fb0 <idestart+0x80>
80101f9d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fa2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fa7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fa8:	83 c4 10             	add    $0x10,%esp
80101fab:	5b                   	pop    %ebx
80101fac:	5e                   	pop    %esi
80101fad:	5d                   	pop    %ebp
80101fae:	c3                   	ret    
80101faf:	90                   	nop
80101fb0:	b2 f7                	mov    $0xf7,%dl
80101fb2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fb7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fb8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fbd:	83 c6 5c             	add    $0x5c,%esi
80101fc0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fc5:	fc                   	cld    
80101fc6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fcf:	c7 04 24 94 70 10 80 	movl   $0x80107094,(%esp)
80101fd6:	e8 85 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fdb:	c7 04 24 8b 70 10 80 	movl   $0x8010708b,(%esp)
80101fe2:	e8 79 e3 ff ff       	call   80100360 <panic>
80101fe7:	89 f6                	mov    %esi,%esi
80101fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ff0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80101ff6:	c7 44 24 04 a6 70 10 	movl   $0x801070a6,0x4(%esp)
80101ffd:	80 
80101ffe:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102005:	e8 66 20 00 00       	call   80104070 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010200a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010200f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102016:	83 e8 01             	sub    $0x1,%eax
80102019:	89 44 24 04          	mov    %eax,0x4(%esp)
8010201d:	e8 7e 02 00 00       	call   801022a0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102022:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102027:	90                   	nop
80102028:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102029:	83 e0 c0             	and    $0xffffffc0,%eax
8010202c:	3c 40                	cmp    $0x40,%al
8010202e:	75 f8                	jne    80102028 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102030:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102035:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010203a:	ee                   	out    %al,(%dx)
8010203b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102040:	b2 f7                	mov    $0xf7,%dl
80102042:	eb 09                	jmp    8010204d <ideinit+0x5d>
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102048:	83 e9 01             	sub    $0x1,%ecx
8010204b:	74 0f                	je     8010205c <ideinit+0x6c>
8010204d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010204e:	84 c0                	test   %al,%al
80102050:	74 f6                	je     80102048 <ideinit+0x58>
      havedisk1 = 1;
80102052:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102059:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010205c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102061:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102066:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102079:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102080:	e8 db 20 00 00       	call   80104160 <acquire>

  if((b = idequeue) == 0){
80102085:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010208b:	85 db                	test   %ebx,%ebx
8010208d:	74 30                	je     801020bf <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
8010208f:	8b 43 58             	mov    0x58(%ebx),%eax
80102092:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102097:	8b 33                	mov    (%ebx),%esi
80102099:	f7 c6 04 00 00 00    	test   $0x4,%esi
8010209f:	74 37                	je     801020d8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020a1:	83 e6 fb             	and    $0xfffffffb,%esi
801020a4:	83 ce 02             	or     $0x2,%esi
801020a7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020a9:	89 1c 24             	mov    %ebx,(%esp)
801020ac:	e8 ef 1c 00 00       	call   80103da0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020b1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020b6:	85 c0                	test   %eax,%eax
801020b8:	74 05                	je     801020bf <ideintr+0x4f>
    idestart(idequeue);
801020ba:	e8 71 fe ff ff       	call   80101f30 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020bf:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c6:	e8 85 21 00 00       	call   80104250 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020cb:	83 c4 1c             	add    $0x1c,%esp
801020ce:	5b                   	pop    %ebx
801020cf:	5e                   	pop    %esi
801020d0:	5f                   	pop    %edi
801020d1:	5d                   	pop    %ebp
801020d2:	c3                   	ret    
801020d3:	90                   	nop
801020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020d8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020dd:	8d 76 00             	lea    0x0(%esi),%esi
801020e0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	89 c1                	mov    %eax,%ecx
801020e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801020e6:	80 f9 40             	cmp    $0x40,%cl
801020e9:	75 f5                	jne    801020e0 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020eb:	a8 21                	test   $0x21,%al
801020ed:	75 b2                	jne    801020a1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801020f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020fc:	fc                   	cld    
801020fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801020ff:	8b 33                	mov    (%ebx),%esi
80102101:	eb 9e                	jmp    801020a1 <ideintr+0x31>
80102103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102110 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	53                   	push   %ebx
80102114:	83 ec 14             	sub    $0x14,%esp
80102117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010211a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010211d:	89 04 24             	mov    %eax,(%esp)
80102120:	e8 1b 1f 00 00       	call   80104040 <holdingsleep>
80102125:	85 c0                	test   %eax,%eax
80102127:	0f 84 9e 00 00 00    	je     801021cb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010212d:	8b 03                	mov    (%ebx),%eax
8010212f:	83 e0 06             	and    $0x6,%eax
80102132:	83 f8 02             	cmp    $0x2,%eax
80102135:	0f 84 a8 00 00 00    	je     801021e3 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010213b:	8b 53 04             	mov    0x4(%ebx),%edx
8010213e:	85 d2                	test   %edx,%edx
80102140:	74 0d                	je     8010214f <iderw+0x3f>
80102142:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102147:	85 c0                	test   %eax,%eax
80102149:	0f 84 88 00 00 00    	je     801021d7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010214f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102156:	e8 05 20 00 00       	call   80104160 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010215b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102160:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102167:	85 c0                	test   %eax,%eax
80102169:	75 07                	jne    80102172 <iderw+0x62>
8010216b:	eb 4e                	jmp    801021bb <iderw+0xab>
8010216d:	8d 76 00             	lea    0x0(%esi),%esi
80102170:	89 d0                	mov    %edx,%eax
80102172:	8b 50 58             	mov    0x58(%eax),%edx
80102175:	85 d2                	test   %edx,%edx
80102177:	75 f7                	jne    80102170 <iderw+0x60>
80102179:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010217c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010217e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80102184:	74 3c                	je     801021c2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102186:	8b 03                	mov    (%ebx),%eax
80102188:	83 e0 06             	and    $0x6,%eax
8010218b:	83 f8 02             	cmp    $0x2,%eax
8010218e:	74 1a                	je     801021aa <iderw+0x9a>
    sleep(b, &idelock);
80102190:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
80102197:	80 
80102198:	89 1c 24             	mov    %ebx,(%esp)
8010219b:	e8 60 1a 00 00       	call   80103c00 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a0:	8b 13                	mov    (%ebx),%edx
801021a2:	83 e2 06             	and    $0x6,%edx
801021a5:	83 fa 02             	cmp    $0x2,%edx
801021a8:	75 e6                	jne    80102190 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
801021aa:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021b1:	83 c4 14             	add    $0x14,%esp
801021b4:	5b                   	pop    %ebx
801021b5:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021b6:	e9 95 20 00 00       	jmp    80104250 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021bb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021c0:	eb ba                	jmp    8010217c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021c2:	89 d8                	mov    %ebx,%eax
801021c4:	e8 67 fd ff ff       	call   80101f30 <idestart>
801021c9:	eb bb                	jmp    80102186 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021cb:	c7 04 24 aa 70 10 80 	movl   $0x801070aa,(%esp)
801021d2:	e8 89 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021d7:	c7 04 24 d5 70 10 80 	movl   $0x801070d5,(%esp)
801021de:	e8 7d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021e3:	c7 04 24 c0 70 10 80 	movl   $0x801070c0,(%esp)
801021ea:	e8 71 e1 ff ff       	call   80100360 <panic>
801021ef:	90                   	nop

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	56                   	push   %esi
801021f4:	53                   	push   %ebx
801021f5:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f8:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021ff:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102202:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102209:	00 00 00 
  return ioapic->data;
8010220c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102212:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102215:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010221b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102221:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102228:	c1 e8 10             	shr    $0x10,%eax
8010222b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010222e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
80102231:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102234:	39 c2                	cmp    %eax,%edx
80102236:	74 12                	je     8010224a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102238:	c7 04 24 f4 70 10 80 	movl   $0x801070f4,(%esp)
8010223f:	e8 0c e4 ff ff       	call   80100650 <cprintf>
80102244:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010224a:	ba 10 00 00 00       	mov    $0x10,%edx
8010224f:	31 c0                	xor    %eax,%eax
80102251:	eb 07                	jmp    8010225a <ioapicinit+0x6a>
80102253:	90                   	nop
80102254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102258:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010225a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010225c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102262:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102265:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226b:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010226e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102271:	8d 4a 01             	lea    0x1(%edx),%ecx
80102274:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102277:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102279:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227f:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102281:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102288:	7d ce                	jge    80102258 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228a:	83 c4 10             	add    $0x10,%esp
8010228d:	5b                   	pop    %ebx
8010228e:	5e                   	pop    %esi
8010228f:	5d                   	pop    %ebp
80102290:	c3                   	ret    
80102291:	eb 0d                	jmp    801022a0 <ioapicenable>
80102293:	90                   	nop
80102294:	90                   	nop
80102295:	90                   	nop
80102296:	90                   	nop
80102297:	90                   	nop
80102298:	90                   	nop
80102299:	90                   	nop
8010229a:	90                   	nop
8010229b:	90                   	nop
8010229c:	90                   	nop
8010229d:	90                   	nop
8010229e:	90                   	nop
8010229f:	90                   	nop

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	8b 55 08             	mov    0x8(%ebp),%edx
801022a6:	53                   	push   %ebx
801022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022aa:	8d 5a 20             	lea    0x20(%edx),%ebx
801022ad:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b7:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ba:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022bc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c2:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022c5:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ca:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022d0:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d3:	5b                   	pop    %ebx
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	66 90                	xchg   %ax,%ax
801022d8:	66 90                	xchg   %ax,%ax
801022da:	66 90                	xchg   %ax,%ax
801022dc:	66 90                	xchg   %ax,%ax
801022de:	66 90                	xchg   %ax,%ax

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 14             	sub    $0x14,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 7c                	jne    8010236e <kfree+0x8e>
801022f2:	81 fb 14 5a 11 80    	cmp    $0x80115a14,%ebx
801022f8:	72 74                	jb     8010236e <kfree+0x8e>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 67                	ja     8010236e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010230e:	00 
8010230f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102316:	00 
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 81 1f 00 00       	call   801042a0 <memset>

  if(kmem.use_lock)
8010231f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102325:	85 d2                	test   %edx,%edx
80102327:	75 37                	jne    80102360 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102329:	a1 78 26 11 80       	mov    0x80112678,%eax
8010232e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102330:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102335:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010233b:	85 c0                	test   %eax,%eax
8010233d:	75 09                	jne    80102348 <kfree+0x68>
    release(&kmem.lock);
}
8010233f:	83 c4 14             	add    $0x14,%esp
80102342:	5b                   	pop    %ebx
80102343:	5d                   	pop    %ebp
80102344:	c3                   	ret    
80102345:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102348:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010234f:	83 c4 14             	add    $0x14,%esp
80102352:	5b                   	pop    %ebx
80102353:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102354:	e9 f7 1e 00 00       	jmp    80104250 <release>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102360:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102367:	e8 f4 1d 00 00       	call   80104160 <acquire>
8010236c:	eb bb                	jmp    80102329 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010236e:	c7 04 24 26 71 10 80 	movl   $0x80107126,(%esp)
80102375:	e8 e6 df ff ff       	call   80100360 <panic>
8010237a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102380 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102388:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
8010238b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010238e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102394:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023a0:	39 de                	cmp    %ebx,%esi
801023a2:	73 08                	jae    801023ac <freerange+0x2c>
801023a4:	eb 18                	jmp    801023be <freerange+0x3e>
801023a6:	66 90                	xchg   %ax,%ax
801023a8:	89 da                	mov    %ebx,%edx
801023aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ac:	89 14 24             	mov    %edx,(%esp)
801023af:	e8 2c ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023ba:	39 f0                	cmp    %esi,%eax
801023bc:	76 ea                	jbe    801023a8 <freerange+0x28>
    kfree(p);
}
801023be:	83 c4 10             	add    $0x10,%esp
801023c1:	5b                   	pop    %ebx
801023c2:	5e                   	pop    %esi
801023c3:	5d                   	pop    %ebp
801023c4:	c3                   	ret    
801023c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	56                   	push   %esi
801023d4:	53                   	push   %ebx
801023d5:	83 ec 10             	sub    $0x10,%esp
801023d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023db:	c7 44 24 04 2c 71 10 	movl   $0x8010712c,0x4(%esp)
801023e2:	80 
801023e3:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023ea:	e8 81 1c 00 00       	call   80104070 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ef:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023f2:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023f9:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fc:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102402:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102408:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010240e:	39 de                	cmp    %ebx,%esi
80102410:	73 0a                	jae    8010241c <kinit1+0x4c>
80102412:	eb 1a                	jmp    8010242e <kinit1+0x5e>
80102414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102418:	89 da                	mov    %ebx,%edx
8010241a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010241c:	89 14 24             	mov    %edx,(%esp)
8010241f:	e8 bc fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102424:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010242a:	39 c6                	cmp    %eax,%esi
8010242c:	73 ea                	jae    80102418 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	5b                   	pop    %ebx
80102432:	5e                   	pop    %esi
80102433:	5d                   	pop    %ebp
80102434:	c3                   	ret    
80102435:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102440 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
80102445:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010244b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102454:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010245a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102460:	39 de                	cmp    %ebx,%esi
80102462:	73 08                	jae    8010246c <kinit2+0x2c>
80102464:	eb 18                	jmp    8010247e <kinit2+0x3e>
80102466:	66 90                	xchg   %ax,%ax
80102468:	89 da                	mov    %ebx,%edx
8010246a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010246c:	89 14 24             	mov    %edx,(%esp)
8010246f:	e8 6c fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102474:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010247a:	39 c6                	cmp    %eax,%esi
8010247c:	73 ea                	jae    80102468 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010247e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102485:	00 00 00 
}
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	5b                   	pop    %ebx
8010248c:	5e                   	pop    %esi
8010248d:	5d                   	pop    %ebp
8010248e:	c3                   	ret    
8010248f:	90                   	nop

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 74 26 11 80       	mov    0x80112674,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 08                	je     801024b2 <kalloc+0x22>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 0c                	je     801024c2 <kalloc+0x32>
    release(&kmem.lock);
801024b6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024bd:	e8 8e 1d 00 00       	call   80104250 <release>
  return (char*)r;
}
801024c2:	83 c4 14             	add    $0x14,%esp
801024c5:	89 d8                	mov    %ebx,%eax
801024c7:	5b                   	pop    %ebx
801024c8:	5d                   	pop    %ebp
801024c9:	c3                   	ret    
801024ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024d7:	e8 84 1c 00 00       	call   80104160 <acquire>
801024dc:	a1 74 26 11 80       	mov    0x80112674,%eax
801024e1:	eb bd                	jmp    801024a0 <kalloc+0x10>
801024e3:	66 90                	xchg   %ax,%ax
801024e5:	66 90                	xchg   %ax,%ax
801024e7:	66 90                	xchg   %ax,%ax
801024e9:	66 90                	xchg   %ax,%ax
801024eb:	66 90                	xchg   %ax,%ax
801024ed:	66 90                	xchg   %ax,%ax
801024ef:	90                   	nop

801024f0 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba 64 00 00 00       	mov    $0x64,%edx
801024f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024f6:	a8 01                	test   $0x1,%al
801024f8:	0f 84 ba 00 00 00    	je     801025b8 <kbdgetc+0xc8>
801024fe:	b2 60                	mov    $0x60,%dl
80102500:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102501:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102504:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010250a:	0f 84 88 00 00 00    	je     80102598 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102510:	84 c0                	test   %al,%al
80102512:	79 2c                	jns    80102540 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102514:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010251a:	f6 c2 40             	test   $0x40,%dl
8010251d:	75 05                	jne    80102524 <kbdgetc+0x34>
8010251f:	89 c1                	mov    %eax,%ecx
80102521:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102524:	0f b6 81 60 72 10 80 	movzbl -0x7fef8da0(%ecx),%eax
8010252b:	83 c8 40             	or     $0x40,%eax
8010252e:	0f b6 c0             	movzbl %al,%eax
80102531:	f7 d0                	not    %eax
80102533:	21 d0                	and    %edx,%eax
80102535:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010253a:	31 c0                	xor    %eax,%eax
8010253c:	c3                   	ret    
8010253d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010254a:	f6 c3 40             	test   $0x40,%bl
8010254d:	74 09                	je     80102558 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010254f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102552:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102558:	0f b6 91 60 72 10 80 	movzbl -0x7fef8da0(%ecx),%edx
  shift ^= togglecode[data];
8010255f:	0f b6 81 60 71 10 80 	movzbl -0x7fef8ea0(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102566:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102568:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010256a:	89 d0                	mov    %edx,%eax
8010256c:	83 e0 03             	and    $0x3,%eax
8010256f:	8b 04 85 40 71 10 80 	mov    -0x7fef8ec0(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102576:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010257c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102583:	74 0b                	je     80102590 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
80102585:	8d 50 9f             	lea    -0x61(%eax),%edx
80102588:	83 fa 19             	cmp    $0x19,%edx
8010258b:	77 1b                	ja     801025a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
8010258d:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102590:	5b                   	pop    %ebx
80102591:	5d                   	pop    %ebp
80102592:	c3                   	ret    
80102593:	90                   	nop
80102594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102598:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010259f:	31 c0                	xor    %eax,%eax
801025a1:	c3                   	ret    
801025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025ab:	8d 50 20             	lea    0x20(%eax),%edx
801025ae:	83 f9 19             	cmp    $0x19,%ecx
801025b1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025b4:	eb da                	jmp    80102590 <kbdgetc+0xa0>
801025b6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax

801025c0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025c6:	c7 04 24 f0 24 10 80 	movl   $0x801024f0,(%esp)
801025cd:	e8 de e1 ff ff       	call   801007b0 <consoleintr>
}
801025d2:	c9                   	leave  
801025d3:	c3                   	ret    
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801025e0:	55                   	push   %ebp
801025e1:	89 c1                	mov    %eax,%ecx
801025e3:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025e5:	ba 70 00 00 00       	mov    $0x70,%edx
801025ea:	53                   	push   %ebx
801025eb:	31 c0                	xor    %eax,%eax
801025ed:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025ee:	bb 71 00 00 00       	mov    $0x71,%ebx
801025f3:	89 da                	mov    %ebx,%edx
801025f5:	ec                   	in     (%dx),%al
static uint cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801025f6:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025f9:	b2 70                	mov    $0x70,%dl
801025fb:	89 01                	mov    %eax,(%ecx)
801025fd:	b8 02 00 00 00       	mov    $0x2,%eax
80102602:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102603:	89 da                	mov    %ebx,%edx
80102605:	ec                   	in     (%dx),%al
80102606:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102609:	b2 70                	mov    $0x70,%dl
8010260b:	89 41 04             	mov    %eax,0x4(%ecx)
8010260e:	b8 04 00 00 00       	mov    $0x4,%eax
80102613:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102614:	89 da                	mov    %ebx,%edx
80102616:	ec                   	in     (%dx),%al
80102617:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261a:	b2 70                	mov    $0x70,%dl
8010261c:	89 41 08             	mov    %eax,0x8(%ecx)
8010261f:	b8 07 00 00 00       	mov    $0x7,%eax
80102624:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102625:	89 da                	mov    %ebx,%edx
80102627:	ec                   	in     (%dx),%al
80102628:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010262b:	b2 70                	mov    $0x70,%dl
8010262d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102630:	b8 08 00 00 00       	mov    $0x8,%eax
80102635:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102636:	89 da                	mov    %ebx,%edx
80102638:	ec                   	in     (%dx),%al
80102639:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263c:	b2 70                	mov    $0x70,%dl
8010263e:	89 41 10             	mov    %eax,0x10(%ecx)
80102641:	b8 09 00 00 00       	mov    $0x9,%eax
80102646:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102647:	89 da                	mov    %ebx,%edx
80102649:	ec                   	in     (%dx),%al
8010264a:	0f b6 d8             	movzbl %al,%ebx
8010264d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102650:	5b                   	pop    %ebx
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    
80102653:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102660:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102665:	55                   	push   %ebp
80102666:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102668:	85 c0                	test   %eax,%eax
8010266a:	0f 84 c0 00 00 00    	je     80102730 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102670:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102677:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102684:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102687:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102691:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102694:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102697:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010269e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026a1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ae:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026be:	8b 50 30             	mov    0x30(%eax),%edx
801026c1:	c1 ea 10             	shr    $0x10,%edx
801026c4:	80 fa 03             	cmp    $0x3,%dl
801026c7:	77 6f                	ja     80102738 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026d3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ed:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102711:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
80102717:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102718:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010271e:	80 e6 10             	and    $0x10,%dh
80102721:	75 f5                	jne    80102718 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102723:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102730:	5d                   	pop    %ebp
80102731:	c3                   	ret    
80102732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102738:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010273f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102742:	8b 50 20             	mov    0x20(%eax),%edx
80102745:	eb 82                	jmp    801026c9 <lapicinit+0x69>
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102750:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102755:	55                   	push   %ebp
80102756:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102758:	85 c0                	test   %eax,%eax
8010275a:	74 0c                	je     80102768 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010275c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010275f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102760:	c1 e8 18             	shr    $0x18,%eax
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102768:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010276a:	5d                   	pop    %ebp
8010276b:	c3                   	ret    
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102770 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027a0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	ba 70 00 00 00       	mov    $0x70,%edx
801027a6:	89 e5                	mov    %esp,%ebp
801027a8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027ba:	b2 71                	mov    $0x71,%dl
801027bc:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027bd:	31 c0                	xor    %eax,%eax
801027bf:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027c5:	89 d8                	mov    %ebx,%eax
801027c7:	c1 e8 04             	shr    $0x4,%eax
801027ca:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027d5:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d8:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027db:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027e4:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027eb:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ee:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f1:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f8:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fb:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fe:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102804:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102807:	89 da                	mov    %ebx,%edx
80102809:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102812:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102815:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102827:	5b                   	pop    %ebx
80102828:	5d                   	pop    %ebp
80102829:	c3                   	ret    
8010282a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102830 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	89 e5                	mov    %esp,%ebp
80102838:	b8 0b 00 00 00       	mov    $0xb,%eax
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	b2 71                	mov    $0x71,%dl
80102846:	ec                   	in     (%dx),%al
80102847:	88 45 b7             	mov    %al,-0x49(%ebp)
8010284a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010284d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102851:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010285d:	89 d8                	mov    %ebx,%eax
8010285f:	e8 7c fd ff ff       	call   801025e0 <fill_rtcdate>
80102864:	b8 0a 00 00 00       	mov    $0xa,%eax
80102869:	89 f2                	mov    %esi,%edx
8010286b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286c:	ba 71 00 00 00       	mov    $0x71,%edx
80102871:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102872:	84 c0                	test   %al,%al
80102874:	78 e7                	js     8010285d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102876:	89 f8                	mov    %edi,%eax
80102878:	e8 63 fd ff ff       	call   801025e0 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010287d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80102884:	00 
80102885:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102889:	89 1c 24             	mov    %ebx,(%esp)
8010288c:	e8 5f 1a 00 00       	call   801042f0 <memcmp>
80102891:	85 c0                	test   %eax,%eax
80102893:	75 c3                	jne    80102858 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102895:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102899:	75 78                	jne    80102913 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010289b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010289e:	89 c2                	mov    %eax,%edx
801028a0:	83 e0 0f             	and    $0xf,%eax
801028a3:	c1 ea 04             	shr    $0x4,%edx
801028a6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028a9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ac:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028af:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028b2:	89 c2                	mov    %eax,%edx
801028b4:	83 e0 0f             	and    $0xf,%eax
801028b7:	c1 ea 04             	shr    $0x4,%edx
801028ba:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028bd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028c0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028c6:	89 c2                	mov    %eax,%edx
801028c8:	83 e0 0f             	and    $0xf,%eax
801028cb:	c1 ea 04             	shr    $0x4,%edx
801028ce:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028d4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028da:	89 c2                	mov    %eax,%edx
801028dc:	83 e0 0f             	and    $0xf,%eax
801028df:	c1 ea 04             	shr    $0x4,%edx
801028e2:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801028eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
801028ee:	89 c2                	mov    %eax,%edx
801028f0:	83 e0 0f             	and    $0xf,%eax
801028f3:	c1 ea 04             	shr    $0x4,%edx
801028f6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801028ff:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102902:	89 c2                	mov    %eax,%edx
80102904:	83 e0 0f             	and    $0xf,%eax
80102907:	c1 ea 04             	shr    $0x4,%edx
8010290a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010290d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102910:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102913:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102916:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102919:	89 01                	mov    %eax,(%ecx)
8010291b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010291e:	89 41 04             	mov    %eax,0x4(%ecx)
80102921:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102924:	89 41 08             	mov    %eax,0x8(%ecx)
80102927:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010292a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010292d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102930:	89 41 10             	mov    %eax,0x10(%ecx)
80102933:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102936:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102939:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102940:	83 c4 4c             	add    $0x4c,%esp
80102943:	5b                   	pop    %ebx
80102944:	5e                   	pop    %esi
80102945:	5f                   	pop    %edi
80102946:	5d                   	pop    %ebp
80102947:	c3                   	ret    
80102948:	66 90                	xchg   %ax,%ax
8010294a:	66 90                	xchg   %ax,%ax
8010294c:	66 90                	xchg   %ax,%ax
8010294e:	66 90                	xchg   %ax,%ax

80102950 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	57                   	push   %edi
80102954:	56                   	push   %esi
80102955:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102956:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102958:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010295b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102960:	85 c0                	test   %eax,%eax
80102962:	7e 78                	jle    801029dc <install_trans+0x8c>
80102964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102968:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010296d:	01 d8                	add    %ebx,%eax
8010296f:	83 c0 01             	add    $0x1,%eax
80102972:	89 44 24 04          	mov    %eax,0x4(%esp)
80102976:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010297b:	89 04 24             	mov    %eax,(%esp)
8010297e:	e8 4d d7 ff ff       	call   801000d0 <bread>
80102983:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102985:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010298c:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010298f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102993:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102998:	89 04 24             	mov    %eax,(%esp)
8010299b:	e8 30 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029a0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029a7:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029aa:	8d 47 5c             	lea    0x5c(%edi),%eax
801029ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029b4:	89 04 24             	mov    %eax,(%esp)
801029b7:	e8 84 19 00 00       	call   80104340 <memmove>
    bwrite(dbuf);  // write dst to disk
801029bc:	89 34 24             	mov    %esi,(%esp)
801029bf:	e8 dc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029c4:	89 3c 24             	mov    %edi,(%esp)
801029c7:	e8 14 d8 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029cc:	89 34 24             	mov    %esi,(%esp)
801029cf:	e8 0c d8 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029d4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029da:	7f 8c                	jg     80102968 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801029dc:	83 c4 1c             	add    $0x1c,%esp
801029df:	5b                   	pop    %ebx
801029e0:	5e                   	pop    %esi
801029e1:	5f                   	pop    %edi
801029e2:	5d                   	pop    %ebp
801029e3:	c3                   	ret    
801029e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801029ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801029f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	57                   	push   %edi
801029f4:	56                   	push   %esi
801029f5:	53                   	push   %ebx
801029f6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
801029f9:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a02:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a07:	89 04 24             	mov    %eax,(%esp)
80102a0a:	e8 c1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a0f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a15:	31 d2                	xor    %edx,%edx
80102a17:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a19:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a1b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a1e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a21:	7e 17                	jle    80102a3a <write_head+0x4a>
80102a23:	90                   	nop
80102a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a28:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a2f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a33:	83 c2 01             	add    $0x1,%edx
80102a36:	39 da                	cmp    %ebx,%edx
80102a38:	75 ee                	jne    80102a28 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a3a:	89 3c 24             	mov    %edi,(%esp)
80102a3d:	e8 5e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a42:	89 3c 24             	mov    %edi,(%esp)
80102a45:	e8 96 d7 ff ff       	call   801001e0 <brelse>
}
80102a4a:	83 c4 1c             	add    $0x1c,%esp
80102a4d:	5b                   	pop    %ebx
80102a4e:	5e                   	pop    %esi
80102a4f:	5f                   	pop    %edi
80102a50:	5d                   	pop    %ebp
80102a51:	c3                   	ret    
80102a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a60 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	56                   	push   %esi
80102a64:	53                   	push   %ebx
80102a65:	83 ec 30             	sub    $0x30,%esp
80102a68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a6b:	c7 44 24 04 60 73 10 	movl   $0x80107360,0x4(%esp)
80102a72:	80 
80102a73:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a7a:	e8 f1 15 00 00       	call   80104070 <initlock>
  readsb(dev, &sb);
80102a7f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a82:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a86:	89 1c 24             	mov    %ebx,(%esp)
80102a89:	e8 f2 e8 ff ff       	call   80101380 <readsb>
  log.start = sb.logstart;
80102a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102a91:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a94:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102a97:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a9d:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102aa1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102aa7:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aac:	e8 1f d6 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ab1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ab3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ab6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ab9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102abb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ac1:	7e 17                	jle    80102ada <initlog+0x7a>
80102ac3:	90                   	nop
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ac8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102acc:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ad3:	83 c2 01             	add    $0x1,%edx
80102ad6:	39 da                	cmp    %ebx,%edx
80102ad8:	75 ee                	jne    80102ac8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102ada:	89 04 24             	mov    %eax,(%esp)
80102add:	e8 fe d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ae2:	e8 69 fe ff ff       	call   80102950 <install_trans>
  log.lh.n = 0;
80102ae7:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102aee:	00 00 00 
  write_head(); // clear the log
80102af1:	e8 fa fe ff ff       	call   801029f0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102af6:	83 c4 30             	add    $0x30,%esp
80102af9:	5b                   	pop    %ebx
80102afa:	5e                   	pop    %esi
80102afb:	5d                   	pop    %ebp
80102afc:	c3                   	ret    
80102afd:	8d 76 00             	lea    0x0(%esi),%esi

80102b00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b06:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b0d:	e8 4e 16 00 00       	call   80104160 <acquire>
80102b12:	eb 18                	jmp    80102b2c <begin_op+0x2c>
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b18:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b1f:	80 
80102b20:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b27:	e8 d4 10 00 00       	call   80103c00 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b2c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b31:	85 c0                	test   %eax,%eax
80102b33:	75 e3                	jne    80102b18 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b35:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b3a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b40:	83 c0 01             	add    $0x1,%eax
80102b43:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b46:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b49:	83 fa 1e             	cmp    $0x1e,%edx
80102b4c:	7f ca                	jg     80102b18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b4e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b55:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b5a:	e8 f1 16 00 00       	call   80104250 <release>
      break;
    }
  }
}
80102b5f:	c9                   	leave  
80102b60:	c3                   	ret    
80102b61:	eb 0d                	jmp    80102b70 <end_op>
80102b63:	90                   	nop
80102b64:	90                   	nop
80102b65:	90                   	nop
80102b66:	90                   	nop
80102b67:	90                   	nop
80102b68:	90                   	nop
80102b69:	90                   	nop
80102b6a:	90                   	nop
80102b6b:	90                   	nop
80102b6c:	90                   	nop
80102b6d:	90                   	nop
80102b6e:	90                   	nop
80102b6f:	90                   	nop

80102b70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	57                   	push   %edi
80102b74:	56                   	push   %esi
80102b75:	53                   	push   %ebx
80102b76:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b79:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b80:	e8 db 15 00 00       	call   80104160 <acquire>
  log.outstanding -= 1;
80102b85:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102b8a:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102b90:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102b93:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102b95:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102b9a:	0f 85 f3 00 00 00    	jne    80102c93 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102ba0:	85 c0                	test   %eax,%eax
80102ba2:	0f 85 cb 00 00 00    	jne    80102c73 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ba8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102baf:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bb1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bb8:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bbb:	e8 90 16 00 00       	call   80104250 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bc0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bc5:	85 c0                	test   %eax,%eax
80102bc7:	0f 8e 90 00 00 00    	jle    80102c5d <end_op+0xed>
80102bcd:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bd0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bd5:	01 d8                	add    %ebx,%eax
80102bd7:	83 c0 01             	add    $0x1,%eax
80102bda:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bde:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102be3:	89 04 24             	mov    %eax,(%esp)
80102be6:	e8 e5 d4 ff ff       	call   801000d0 <bread>
80102beb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bed:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf4:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfb:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c00:	89 04 24             	mov    %eax,(%esp)
80102c03:	e8 c8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c08:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c0f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c10:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c12:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c15:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c19:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1c:	89 04 24             	mov    %eax,(%esp)
80102c1f:	e8 1c 17 00 00       	call   80104340 <memmove>
    bwrite(to);  // write the log
80102c24:	89 34 24             	mov    %esi,(%esp)
80102c27:	e8 74 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c2c:	89 3c 24             	mov    %edi,(%esp)
80102c2f:	e8 ac d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c34:	89 34 24             	mov    %esi,(%esp)
80102c37:	e8 a4 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c3c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c42:	7c 8c                	jl     80102bd0 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c44:	e8 a7 fd ff ff       	call   801029f0 <write_head>
    install_trans(); // Now install writes to home locations
80102c49:	e8 02 fd ff ff       	call   80102950 <install_trans>
    log.lh.n = 0;
80102c4e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c55:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c58:	e8 93 fd ff ff       	call   801029f0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c5d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c64:	e8 f7 14 00 00       	call   80104160 <acquire>
    log.committing = 0;
80102c69:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c70:	00 00 00 
    wakeup(&log);
80102c73:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c7a:	e8 21 11 00 00       	call   80103da0 <wakeup>
    release(&log.lock);
80102c7f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c86:	e8 c5 15 00 00       	call   80104250 <release>
  }
}
80102c8b:	83 c4 1c             	add    $0x1c,%esp
80102c8e:	5b                   	pop    %ebx
80102c8f:	5e                   	pop    %esi
80102c90:	5f                   	pop    %edi
80102c91:	5d                   	pop    %ebp
80102c92:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102c93:	c7 04 24 64 73 10 80 	movl   $0x80107364,(%esp)
80102c9a:	e8 c1 d6 ff ff       	call   80100360 <panic>
80102c9f:	90                   	nop

80102ca0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ca7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102caf:	83 f8 1d             	cmp    $0x1d,%eax
80102cb2:	0f 8f 98 00 00 00    	jg     80102d50 <log_write+0xb0>
80102cb8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cbe:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102cc1:	39 d0                	cmp    %edx,%eax
80102cc3:	0f 8d 87 00 00 00    	jge    80102d50 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102cc9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	0f 8e 86 00 00 00    	jle    80102d5c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cd6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cdd:	e8 7e 14 00 00       	call   80104160 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ce2:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102ce8:	83 fa 00             	cmp    $0x0,%edx
80102ceb:	7e 54                	jle    80102d41 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ced:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102cf0:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102cf2:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102cf8:	75 0f                	jne    80102d09 <log_write+0x69>
80102cfa:	eb 3c                	jmp    80102d38 <log_write+0x98>
80102cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d00:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d07:	74 2f                	je     80102d38 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d09:	83 c0 01             	add    $0x1,%eax
80102d0c:	39 d0                	cmp    %edx,%eax
80102d0e:	75 f0                	jne    80102d00 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d10:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d17:	83 c2 01             	add    $0x1,%edx
80102d1a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d20:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d23:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d2a:	83 c4 14             	add    $0x14,%esp
80102d2d:	5b                   	pop    %ebx
80102d2e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d2f:	e9 1c 15 00 00       	jmp    80104250 <release>
80102d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d38:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d3f:	eb df                	jmp    80102d20 <log_write+0x80>
80102d41:	8b 43 08             	mov    0x8(%ebx),%eax
80102d44:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d49:	75 d5                	jne    80102d20 <log_write+0x80>
80102d4b:	eb ca                	jmp    80102d17 <log_write+0x77>
80102d4d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102d50:	c7 04 24 73 73 10 80 	movl   $0x80107373,(%esp)
80102d57:	e8 04 d6 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102d5c:	c7 04 24 89 73 10 80 	movl   $0x80107389,(%esp)
80102d63:	e8 f8 d5 ff ff       	call   80100360 <panic>
80102d68:	66 90                	xchg   %ax,%ax
80102d6a:	66 90                	xchg   %ax,%ax
80102d6c:	66 90                	xchg   %ax,%ax
80102d6e:	66 90                	xchg   %ax,%ax

80102d70 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d77:	e8 f4 08 00 00       	call   80103670 <cpuid>
80102d7c:	89 c3                	mov    %eax,%ebx
80102d7e:	e8 ed 08 00 00       	call   80103670 <cpuid>
80102d83:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102d87:	c7 04 24 a4 73 10 80 	movl   $0x801073a4,(%esp)
80102d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102d92:	e8 b9 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102d97:	e8 64 27 00 00       	call   80105500 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102d9c:	e8 4f 08 00 00       	call   801035f0 <mycpu>
80102da1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102da3:	b8 01 00 00 00       	mov    $0x1,%eax
80102da8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102daf:	e8 9c 0b 00 00       	call   80103950 <scheduler>
80102db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102dc0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102dc6:	e8 c5 38 00 00       	call   80106690 <switchkvm>
  seginit();
80102dcb:	e8 80 37 00 00       	call   80106550 <seginit>
  lapicinit();
80102dd0:	e8 8b f8 ff ff       	call   80102660 <lapicinit>
  mpmain();
80102dd5:	e8 96 ff ff ff       	call   80102d70 <mpmain>
80102dda:	66 90                	xchg   %ax,%ax
80102ddc:	66 90                	xchg   %ax,%ax
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102de4:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102de9:	83 e4 f0             	and    $0xfffffff0,%esp
80102dec:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102def:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102df6:	80 
80102df7:	c7 04 24 14 5a 11 80 	movl   $0x80115a14,(%esp)
80102dfe:	e8 cd f5 ff ff       	call   801023d0 <kinit1>
  kvmalloc();      // kernel page table
80102e03:	e8 58 3d 00 00       	call   80106b60 <kvmalloc>
  mpinit();        // detect other processors
80102e08:	e8 73 01 00 00       	call   80102f80 <mpinit>
80102e0d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e10:	e8 4b f8 ff ff       	call   80102660 <lapicinit>
  seginit();       // segment descriptors
80102e15:	e8 36 37 00 00       	call   80106550 <seginit>
  picinit();       // disable pic
80102e1a:	e8 21 03 00 00       	call   80103140 <picinit>
80102e1f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e20:	e8 cb f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102e25:	e8 26 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e2a:	e8 c1 2a 00 00       	call   801058f0 <uartinit>
80102e2f:	90                   	nop
  pinit();         // process table
80102e30:	e8 9b 07 00 00       	call   801035d0 <pinit>
  shminit();       // shared memory
80102e35:	e8 06 40 00 00       	call   80106e40 <shminit>
  tvinit();        // trap vectors
80102e3a:	e8 21 26 00 00       	call   80105460 <tvinit>
80102e3f:	90                   	nop
  binit();         // buffer cache
80102e40:	e8 fb d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e45:	e8 e6 de ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk 
80102e4a:	e8 a1 f1 ff ff       	call   80101ff0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e4f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e56:	00 
80102e57:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e5e:	80 
80102e5f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e66:	e8 d5 14 00 00       	call   80104340 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e6b:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e72:	00 00 00 
80102e75:	05 80 27 11 80       	add    $0x80112780,%eax
80102e7a:	39 d8                	cmp    %ebx,%eax
80102e7c:	76 65                	jbe    80102ee3 <main+0x103>
80102e7e:	66 90                	xchg   %ax,%ax
    if(c == mycpu())  // We've started already.
80102e80:	e8 6b 07 00 00       	call   801035f0 <mycpu>
80102e85:	39 d8                	cmp    %ebx,%eax
80102e87:	74 41                	je     80102eca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102e89:	e8 02 f6 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
80102e8e:	c7 05 f8 6f 00 80 c0 	movl   $0x80102dc0,0x80006ff8
80102e95:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102e98:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102e9f:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ea2:	05 00 10 00 00       	add    $0x1000,%eax
80102ea7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102eac:	0f b6 03             	movzbl (%ebx),%eax
80102eaf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102eb6:	00 
80102eb7:	89 04 24             	mov    %eax,(%esp)
80102eba:	e8 e1 f8 ff ff       	call   801027a0 <lapicstartap>
80102ebf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ec0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ec6:	85 c0                	test   %eax,%eax
80102ec8:	74 f6                	je     80102ec0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102eca:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ed1:	00 00 00 
80102ed4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102eda:	05 80 27 11 80       	add    $0x80112780,%eax
80102edf:	39 c3                	cmp    %eax,%ebx
80102ee1:	72 9d                	jb     80102e80 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ee3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102eea:	8e 
80102eeb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102ef2:	e8 49 f5 ff ff       	call   80102440 <kinit2>
  userinit();      // first user process
80102ef7:	e8 c4 07 00 00       	call   801036c0 <userinit>
  mpmain();        // finish this processor's setup
80102efc:	e8 6f fe ff ff       	call   80102d70 <mpmain>
80102f01:	66 90                	xchg   %ax,%ax
80102f03:	66 90                	xchg   %ax,%ax
80102f05:	66 90                	xchg   %ax,%ax
80102f07:	66 90                	xchg   %ax,%ax
80102f09:	66 90                	xchg   %ax,%ax
80102f0b:	66 90                	xchg   %ax,%ax
80102f0d:	66 90                	xchg   %ax,%ax
80102f0f:	90                   	nop

80102f10 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f14:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f1a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f1b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f1e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f21:	39 de                	cmp    %ebx,%esi
80102f23:	73 3c                	jae    80102f61 <mpsearch1+0x51>
80102f25:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f28:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f2f:	00 
80102f30:	c7 44 24 04 b8 73 10 	movl   $0x801073b8,0x4(%esp)
80102f37:	80 
80102f38:	89 34 24             	mov    %esi,(%esp)
80102f3b:	e8 b0 13 00 00       	call   801042f0 <memcmp>
80102f40:	85 c0                	test   %eax,%eax
80102f42:	75 16                	jne    80102f5a <mpsearch1+0x4a>
80102f44:	31 c9                	xor    %ecx,%ecx
80102f46:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f48:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f4c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f4f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f51:	83 fa 10             	cmp    $0x10,%edx
80102f54:	75 f2                	jne    80102f48 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f56:	84 c9                	test   %cl,%cl
80102f58:	74 10                	je     80102f6a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f5a:	83 c6 10             	add    $0x10,%esi
80102f5d:	39 f3                	cmp    %esi,%ebx
80102f5f:	77 c7                	ja     80102f28 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102f61:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102f64:	31 c0                	xor    %eax,%eax
}
80102f66:	5b                   	pop    %ebx
80102f67:	5e                   	pop    %esi
80102f68:	5d                   	pop    %ebp
80102f69:	c3                   	ret    
80102f6a:	83 c4 10             	add    $0x10,%esp
80102f6d:	89 f0                	mov    %esi,%eax
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5d                   	pop    %ebp
80102f72:	c3                   	ret    
80102f73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f80 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
80102f85:	53                   	push   %ebx
80102f86:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102f89:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102f90:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102f97:	c1 e0 08             	shl    $0x8,%eax
80102f9a:	09 d0                	or     %edx,%eax
80102f9c:	c1 e0 04             	shl    $0x4,%eax
80102f9f:	85 c0                	test   %eax,%eax
80102fa1:	75 1b                	jne    80102fbe <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fa3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102faa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fb1:	c1 e0 08             	shl    $0x8,%eax
80102fb4:	09 d0                	or     %edx,%eax
80102fb6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fb9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102fbe:	ba 00 04 00 00       	mov    $0x400,%edx
80102fc3:	e8 48 ff ff ff       	call   80102f10 <mpsearch1>
80102fc8:	85 c0                	test   %eax,%eax
80102fca:	89 c7                	mov    %eax,%edi
80102fcc:	0f 84 22 01 00 00    	je     801030f4 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102fd2:	8b 77 04             	mov    0x4(%edi),%esi
80102fd5:	85 f6                	test   %esi,%esi
80102fd7:	0f 84 30 01 00 00    	je     8010310d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102fdd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80102fe3:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102fea:	00 
80102feb:	c7 44 24 04 bd 73 10 	movl   $0x801073bd,0x4(%esp)
80102ff2:	80 
80102ff3:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ff6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102ff9:	e8 f2 12 00 00       	call   801042f0 <memcmp>
80102ffe:	85 c0                	test   %eax,%eax
80103000:	0f 85 07 01 00 00    	jne    8010310d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103006:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010300d:	3c 04                	cmp    $0x4,%al
8010300f:	0f 85 0b 01 00 00    	jne    80103120 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103015:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010301c:	85 c0                	test   %eax,%eax
8010301e:	74 21                	je     80103041 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103020:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103022:	31 d2                	xor    %edx,%edx
80103024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103028:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010302f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103030:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103033:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103035:	39 d0                	cmp    %edx,%eax
80103037:	7f ef                	jg     80103028 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103039:	84 c9                	test   %cl,%cl
8010303b:	0f 85 cc 00 00 00    	jne    8010310d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103044:	85 c0                	test   %eax,%eax
80103046:	0f 84 c1 00 00 00    	je     8010310d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010304c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103052:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103057:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010305c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103063:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103069:	03 55 e4             	add    -0x1c(%ebp),%edx
8010306c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103070:	39 c2                	cmp    %eax,%edx
80103072:	76 1b                	jbe    8010308f <mpinit+0x10f>
80103074:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103077:	80 f9 04             	cmp    $0x4,%cl
8010307a:	77 74                	ja     801030f0 <mpinit+0x170>
8010307c:	ff 24 8d fc 73 10 80 	jmp    *-0x7fef8c04(,%ecx,4)
80103083:	90                   	nop
80103084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103088:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010308b:	39 c2                	cmp    %eax,%edx
8010308d:	77 e5                	ja     80103074 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010308f:	85 db                	test   %ebx,%ebx
80103091:	0f 84 93 00 00 00    	je     8010312a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103097:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010309b:	74 12                	je     801030af <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010309d:	ba 22 00 00 00       	mov    $0x22,%edx
801030a2:	b8 70 00 00 00       	mov    $0x70,%eax
801030a7:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a8:	b2 23                	mov    $0x23,%dl
801030aa:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030ab:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ae:	ee                   	out    %al,(%dx)
  }
}
801030af:	83 c4 1c             	add    $0x1c,%esp
801030b2:	5b                   	pop    %ebx
801030b3:	5e                   	pop    %esi
801030b4:	5f                   	pop    %edi
801030b5:	5d                   	pop    %ebp
801030b6:	c3                   	ret    
801030b7:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801030b8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030be:	83 fe 07             	cmp    $0x7,%esi
801030c1:	7f 17                	jg     801030da <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030c3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030c7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030cd:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030d4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801030da:	83 c0 14             	add    $0x14,%eax
      continue;
801030dd:	eb 91                	jmp    80103070 <mpinit+0xf0>
801030df:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801030e0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801030e4:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801030e7:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
801030ed:	eb 81                	jmp    80103070 <mpinit+0xf0>
801030ef:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801030f0:	31 db                	xor    %ebx,%ebx
801030f2:	eb 83                	jmp    80103077 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801030f4:	ba 00 00 01 00       	mov    $0x10000,%edx
801030f9:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801030fe:	e8 0d fe ff ff       	call   80102f10 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103103:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103105:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103107:	0f 85 c5 fe ff ff    	jne    80102fd2 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010310d:	c7 04 24 c2 73 10 80 	movl   $0x801073c2,(%esp)
80103114:	e8 47 d2 ff ff       	call   80100360 <panic>
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103120:	3c 01                	cmp    $0x1,%al
80103122:	0f 84 ed fe ff ff    	je     80103015 <mpinit+0x95>
80103128:	eb e3                	jmp    8010310d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010312a:	c7 04 24 dc 73 10 80 	movl   $0x801073dc,(%esp)
80103131:	e8 2a d2 ff ff       	call   80100360 <panic>
80103136:	66 90                	xchg   %ax,%ax
80103138:	66 90                	xchg   %ax,%ax
8010313a:	66 90                	xchg   %ax,%ax
8010313c:	66 90                	xchg   %ax,%ax
8010313e:	66 90                	xchg   %ax,%ax

80103140 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103140:	55                   	push   %ebp
80103141:	ba 21 00 00 00       	mov    $0x21,%edx
80103146:	89 e5                	mov    %esp,%ebp
80103148:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010314d:	ee                   	out    %al,(%dx)
8010314e:	b2 a1                	mov    $0xa1,%dl
80103150:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103151:	5d                   	pop    %ebp
80103152:	c3                   	ret    
80103153:	66 90                	xchg   %ax,%ax
80103155:	66 90                	xchg   %ax,%ax
80103157:	66 90                	xchg   %ax,%ax
80103159:	66 90                	xchg   %ax,%ax
8010315b:	66 90                	xchg   %ax,%ax
8010315d:	66 90                	xchg   %ax,%ax
8010315f:	90                   	nop

80103160 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
80103165:	53                   	push   %ebx
80103166:	83 ec 1c             	sub    $0x1c,%esp
80103169:	8b 75 08             	mov    0x8(%ebp),%esi
8010316c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010316f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103175:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010317b:	e8 d0 db ff ff       	call   80100d50 <filealloc>
80103180:	85 c0                	test   %eax,%eax
80103182:	89 06                	mov    %eax,(%esi)
80103184:	0f 84 a4 00 00 00    	je     8010322e <pipealloc+0xce>
8010318a:	e8 c1 db ff ff       	call   80100d50 <filealloc>
8010318f:	85 c0                	test   %eax,%eax
80103191:	89 03                	mov    %eax,(%ebx)
80103193:	0f 84 87 00 00 00    	je     80103220 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103199:	e8 f2 f2 ff ff       	call   80102490 <kalloc>
8010319e:	85 c0                	test   %eax,%eax
801031a0:	89 c7                	mov    %eax,%edi
801031a2:	74 7c                	je     80103220 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031a4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031ab:	00 00 00 
  p->writeopen = 1;
801031ae:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031b5:	00 00 00 
  p->nwrite = 0;
801031b8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031bf:	00 00 00 
  p->nread = 0;
801031c2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031c9:	00 00 00 
  initlock(&p->lock, "pipe");
801031cc:	89 04 24             	mov    %eax,(%esp)
801031cf:	c7 44 24 04 10 74 10 	movl   $0x80107410,0x4(%esp)
801031d6:	80 
801031d7:	e8 94 0e 00 00       	call   80104070 <initlock>
  (*f0)->type = FD_PIPE;
801031dc:	8b 06                	mov    (%esi),%eax
801031de:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801031e4:	8b 06                	mov    (%esi),%eax
801031e6:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801031ea:	8b 06                	mov    (%esi),%eax
801031ec:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801031f0:	8b 06                	mov    (%esi),%eax
801031f2:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801031f5:	8b 03                	mov    (%ebx),%eax
801031f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801031fd:	8b 03                	mov    (%ebx),%eax
801031ff:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103203:	8b 03                	mov    (%ebx),%eax
80103205:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103209:	8b 03                	mov    (%ebx),%eax
  return 0;
8010320b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010320d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103210:	83 c4 1c             	add    $0x1c,%esp
80103213:	89 d8                	mov    %ebx,%eax
80103215:	5b                   	pop    %ebx
80103216:	5e                   	pop    %esi
80103217:	5f                   	pop    %edi
80103218:	5d                   	pop    %ebp
80103219:	c3                   	ret    
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103220:	8b 06                	mov    (%esi),%eax
80103222:	85 c0                	test   %eax,%eax
80103224:	74 08                	je     8010322e <pipealloc+0xce>
    fileclose(*f0);
80103226:	89 04 24             	mov    %eax,(%esp)
80103229:	e8 e2 db ff ff       	call   80100e10 <fileclose>
  if(*f1)
8010322e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103230:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103235:	85 c0                	test   %eax,%eax
80103237:	74 d7                	je     80103210 <pipealloc+0xb0>
    fileclose(*f1);
80103239:	89 04 24             	mov    %eax,(%esp)
8010323c:	e8 cf db ff ff       	call   80100e10 <fileclose>
  return -1;
}
80103241:	83 c4 1c             	add    $0x1c,%esp
80103244:	89 d8                	mov    %ebx,%eax
80103246:	5b                   	pop    %ebx
80103247:	5e                   	pop    %esi
80103248:	5f                   	pop    %edi
80103249:	5d                   	pop    %ebp
8010324a:	c3                   	ret    
8010324b:	90                   	nop
8010324c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103250 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	56                   	push   %esi
80103254:	53                   	push   %ebx
80103255:	83 ec 10             	sub    $0x10,%esp
80103258:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010325e:	89 1c 24             	mov    %ebx,(%esp)
80103261:	e8 fa 0e 00 00       	call   80104160 <acquire>
  if(writable){
80103266:	85 f6                	test   %esi,%esi
80103268:	74 3e                	je     801032a8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010326a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103270:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103277:	00 00 00 
    wakeup(&p->nread);
8010327a:	89 04 24             	mov    %eax,(%esp)
8010327d:	e8 1e 0b 00 00       	call   80103da0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103282:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103288:	85 d2                	test   %edx,%edx
8010328a:	75 0a                	jne    80103296 <pipeclose+0x46>
8010328c:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	74 32                	je     801032c8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103296:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103299:	83 c4 10             	add    $0x10,%esp
8010329c:	5b                   	pop    %ebx
8010329d:	5e                   	pop    %esi
8010329e:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010329f:	e9 ac 0f 00 00       	jmp    80104250 <release>
801032a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801032a8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801032ae:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032b5:	00 00 00 
    wakeup(&p->nwrite);
801032b8:	89 04 24             	mov    %eax,(%esp)
801032bb:	e8 e0 0a 00 00       	call   80103da0 <wakeup>
801032c0:	eb c0                	jmp    80103282 <pipeclose+0x32>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801032c8:	89 1c 24             	mov    %ebx,(%esp)
801032cb:	e8 80 0f 00 00       	call   80104250 <release>
    kfree((char*)p);
801032d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
801032d3:	83 c4 10             	add    $0x10,%esp
801032d6:	5b                   	pop    %ebx
801032d7:	5e                   	pop    %esi
801032d8:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801032d9:	e9 02 f0 ff ff       	jmp    801022e0 <kfree>
801032de:	66 90                	xchg   %ax,%ax

801032e0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	57                   	push   %edi
801032e4:	56                   	push   %esi
801032e5:	53                   	push   %ebx
801032e6:	83 ec 1c             	sub    $0x1c,%esp
801032e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801032ec:	89 1c 24             	mov    %ebx,(%esp)
801032ef:	e8 6c 0e 00 00       	call   80104160 <acquire>
  for(i = 0; i < n; i++){
801032f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
801032f7:	85 c9                	test   %ecx,%ecx
801032f9:	0f 8e b2 00 00 00    	jle    801033b1 <pipewrite+0xd1>
801032ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103302:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103308:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010330e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103314:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103317:	03 4d 10             	add    0x10(%ebp),%ecx
8010331a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010331d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103323:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103329:	39 c8                	cmp    %ecx,%eax
8010332b:	74 38                	je     80103365 <pipewrite+0x85>
8010332d:	eb 55                	jmp    80103384 <pipewrite+0xa4>
8010332f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103330:	e8 5b 03 00 00       	call   80103690 <myproc>
80103335:	8b 40 2c             	mov    0x2c(%eax),%eax
80103338:	85 c0                	test   %eax,%eax
8010333a:	75 33                	jne    8010336f <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010333c:	89 3c 24             	mov    %edi,(%esp)
8010333f:	e8 5c 0a 00 00       	call   80103da0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103344:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103348:	89 34 24             	mov    %esi,(%esp)
8010334b:	e8 b0 08 00 00       	call   80103c00 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103350:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103356:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010335c:	05 00 02 00 00       	add    $0x200,%eax
80103361:	39 c2                	cmp    %eax,%edx
80103363:	75 23                	jne    80103388 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103365:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010336b:	85 d2                	test   %edx,%edx
8010336d:	75 c1                	jne    80103330 <pipewrite+0x50>
        release(&p->lock);
8010336f:	89 1c 24             	mov    %ebx,(%esp)
80103372:	e8 d9 0e 00 00       	call   80104250 <release>
        return -1;
80103377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010337c:	83 c4 1c             	add    $0x1c,%esp
8010337f:	5b                   	pop    %ebx
80103380:	5e                   	pop    %esi
80103381:	5f                   	pop    %edi
80103382:	5d                   	pop    %ebp
80103383:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103384:	89 c2                	mov    %eax,%edx
80103386:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103388:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010338b:	8d 42 01             	lea    0x1(%edx),%eax
8010338e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103394:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
8010339a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010339e:	0f b6 09             	movzbl (%ecx),%ecx
801033a1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801033a5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033a8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033ab:	0f 85 6c ff ff ff    	jne    8010331d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033b1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b7:	89 04 24             	mov    %eax,(%esp)
801033ba:	e8 e1 09 00 00       	call   80103da0 <wakeup>
  release(&p->lock);
801033bf:	89 1c 24             	mov    %ebx,(%esp)
801033c2:	e8 89 0e 00 00       	call   80104250 <release>
  return n;
801033c7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ca:	eb b0                	jmp    8010337c <pipewrite+0x9c>
801033cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033d0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801033d0:	55                   	push   %ebp
801033d1:	89 e5                	mov    %esp,%ebp
801033d3:	57                   	push   %edi
801033d4:	56                   	push   %esi
801033d5:	53                   	push   %ebx
801033d6:	83 ec 1c             	sub    $0x1c,%esp
801033d9:	8b 75 08             	mov    0x8(%ebp),%esi
801033dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033df:	89 34 24             	mov    %esi,(%esp)
801033e2:	e8 79 0d 00 00       	call   80104160 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801033e7:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801033ed:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801033f3:	75 5b                	jne    80103450 <piperead+0x80>
801033f5:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801033fb:	85 db                	test   %ebx,%ebx
801033fd:	74 51                	je     80103450 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801033ff:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103405:	eb 25                	jmp    8010342c <piperead+0x5c>
80103407:	90                   	nop
80103408:	89 74 24 04          	mov    %esi,0x4(%esp)
8010340c:	89 1c 24             	mov    %ebx,(%esp)
8010340f:	e8 ec 07 00 00       	call   80103c00 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103414:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010341a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103420:	75 2e                	jne    80103450 <piperead+0x80>
80103422:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103428:	85 d2                	test   %edx,%edx
8010342a:	74 24                	je     80103450 <piperead+0x80>
    if(myproc()->killed){
8010342c:	e8 5f 02 00 00       	call   80103690 <myproc>
80103431:	8b 48 2c             	mov    0x2c(%eax),%ecx
80103434:	85 c9                	test   %ecx,%ecx
80103436:	74 d0                	je     80103408 <piperead+0x38>
      release(&p->lock);
80103438:	89 34 24             	mov    %esi,(%esp)
8010343b:	e8 10 0e 00 00       	call   80104250 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103440:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103448:	5b                   	pop    %ebx
80103449:	5e                   	pop    %esi
8010344a:	5f                   	pop    %edi
8010344b:	5d                   	pop    %ebp
8010344c:	c3                   	ret    
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103450:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103453:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103455:	85 d2                	test   %edx,%edx
80103457:	7f 2b                	jg     80103484 <piperead+0xb4>
80103459:	eb 31                	jmp    8010348c <piperead+0xbc>
8010345b:	90                   	nop
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103460:	8d 48 01             	lea    0x1(%eax),%ecx
80103463:	25 ff 01 00 00       	and    $0x1ff,%eax
80103468:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010346e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103473:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103476:	83 c3 01             	add    $0x1,%ebx
80103479:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010347c:	74 0e                	je     8010348c <piperead+0xbc>
    if(p->nread == p->nwrite)
8010347e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103484:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010348a:	75 d4                	jne    80103460 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010348c:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103492:	89 04 24             	mov    %eax,(%esp)
80103495:	e8 06 09 00 00       	call   80103da0 <wakeup>
  release(&p->lock);
8010349a:	89 34 24             	mov    %esi,(%esp)
8010349d:	e8 ae 0d 00 00       	call   80104250 <release>
  return i;
}
801034a2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801034a5:	89 d8                	mov    %ebx,%eax
}
801034a7:	5b                   	pop    %ebx
801034a8:	5e                   	pop    %esi
801034a9:	5f                   	pop    %edi
801034aa:	5d                   	pop    %ebp
801034ab:	c3                   	ret    
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034b9:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801034bc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034c3:	e8 98 0c 00 00       	call   80104160 <acquire>
801034c8:	eb 14                	jmp    801034de <allocproc+0x2e>
801034ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801034d6:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801034dc:	74 7a                	je     80103558 <allocproc+0xa8>
    if(p->state == UNUSED)
801034de:	8b 43 0c             	mov    0xc(%ebx),%eax
801034e1:	85 c0                	test   %eax,%eax
801034e3:	75 eb                	jne    801034d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801034e5:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801034ea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801034f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801034f8:	8d 50 01             	lea    0x1(%eax),%edx
801034fb:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103501:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103504:	e8 47 0d 00 00       	call   80104250 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103509:	e8 82 ef ff ff       	call   80102490 <kalloc>
8010350e:	85 c0                	test   %eax,%eax
80103510:	89 43 08             	mov    %eax,0x8(%ebx)
80103513:	74 57                	je     8010356c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103515:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010351b:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103520:	89 53 20             	mov    %edx,0x20(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103523:	c7 40 14 55 54 10 80 	movl   $0x80105455,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010352a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103531:	00 
80103532:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103539:	00 
8010353a:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010353d:	89 43 24             	mov    %eax,0x24(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103540:	e8 5b 0d 00 00       	call   801042a0 <memset>
  p->context->eip = (uint)forkret;
80103545:	8b 43 24             	mov    0x24(%ebx),%eax
80103548:	c7 40 10 80 35 10 80 	movl   $0x80103580,0x10(%eax)

  return p;
8010354f:	89 d8                	mov    %ebx,%eax
}
80103551:	83 c4 14             	add    $0x14,%esp
80103554:	5b                   	pop    %ebx
80103555:	5d                   	pop    %ebp
80103556:	c3                   	ret    
80103557:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103558:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010355f:	e8 ec 0c 00 00       	call   80104250 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103564:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103567:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103569:	5b                   	pop    %ebx
8010356a:	5d                   	pop    %ebp
8010356b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010356c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103573:	eb dc                	jmp    80103551 <allocproc+0xa1>
80103575:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103580 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103586:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010358d:	e8 be 0c 00 00       	call   80104250 <release>

  if (first) {
80103592:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103597:	85 c0                	test   %eax,%eax
80103599:	75 05                	jne    801035a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010359b:	c9                   	leave  
8010359c:	c3                   	ret    
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801035a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801035a7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ae:	00 00 00 
    iinit(ROOTDEV);
801035b1:	e8 aa de ff ff       	call   80101460 <iinit>
    initlog(ROOTDEV);
801035b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035bd:	e8 9e f4 ff ff       	call   80102a60 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035c2:	c9                   	leave  
801035c3:	c3                   	ret    
801035c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035d0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801035d6:	c7 44 24 04 15 74 10 	movl   $0x80107415,0x4(%esp)
801035dd:	80 
801035de:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035e5:	e8 86 0a 00 00       	call   80104070 <initlock>
}
801035ea:	c9                   	leave  
801035eb:	c3                   	ret    
801035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801035f0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035f8:	9c                   	pushf  
801035f9:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801035fa:	f6 c4 02             	test   $0x2,%ah
801035fd:	75 57                	jne    80103656 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801035ff:	e8 4c f1 ff ff       	call   80102750 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103604:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010360a:	85 f6                	test   %esi,%esi
8010360c:	7e 3c                	jle    8010364a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010360e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103615:	39 c2                	cmp    %eax,%edx
80103617:	74 2d                	je     80103646 <mycpu+0x56>
80103619:	b9 30 28 11 80       	mov    $0x80112830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010361e:	31 d2                	xor    %edx,%edx
80103620:	83 c2 01             	add    $0x1,%edx
80103623:	39 f2                	cmp    %esi,%edx
80103625:	74 23                	je     8010364a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103627:	0f b6 19             	movzbl (%ecx),%ebx
8010362a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103630:	39 c3                	cmp    %eax,%ebx
80103632:	75 ec                	jne    80103620 <mycpu+0x30>
      return &cpus[i];
80103634:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010363a:	83 c4 10             	add    $0x10,%esp
8010363d:	5b                   	pop    %ebx
8010363e:	5e                   	pop    %esi
8010363f:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103640:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103645:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103646:	31 d2                	xor    %edx,%edx
80103648:	eb ea                	jmp    80103634 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010364a:	c7 04 24 1c 74 10 80 	movl   $0x8010741c,(%esp)
80103651:	e8 0a cd ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103656:	c7 04 24 f8 74 10 80 	movl   $0x801074f8,(%esp)
8010365d:	e8 fe cc ff ff       	call   80100360 <panic>
80103662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103670 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103676:	e8 75 ff ff ff       	call   801035f0 <mycpu>
}
8010367b:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
8010367c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103681:	c1 f8 04             	sar    $0x4,%eax
80103684:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010368a:	c3                   	ret    
8010368b:	90                   	nop
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103690 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	53                   	push   %ebx
80103694:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103697:	e8 84 0a 00 00       	call   80104120 <pushcli>
  c = mycpu();
8010369c:	e8 4f ff ff ff       	call   801035f0 <mycpu>
  p = c->proc;
801036a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036a7:	e8 34 0b 00 00       	call   801041e0 <popcli>
  return p;
}
801036ac:	83 c4 04             	add    $0x4,%esp
801036af:	89 d8                	mov    %ebx,%eax
801036b1:	5b                   	pop    %ebx
801036b2:	5d                   	pop    %ebp
801036b3:	c3                   	ret    
801036b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036c0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801036c7:	e8 e4 fd ff ff       	call   801034b0 <allocproc>
801036cc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801036ce:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036d3:	e8 f8 33 00 00       	call   80106ad0 <setupkvm>
801036d8:	85 c0                	test   %eax,%eax
801036da:	89 43 04             	mov    %eax,0x4(%ebx)
801036dd:	0f 84 db 00 00 00    	je     801037be <userinit+0xfe>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801036e3:	89 04 24             	mov    %eax,(%esp)
801036e6:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801036ed:	00 
801036ee:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801036f5:	80 
801036f6:	e8 c5 30 00 00       	call   801067c0 <inituvm>
  p->sz = PGSIZE;
801036fb:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  p->userstack_top = 0;
80103701:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103708:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010370f:	00 
80103710:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103717:	00 
80103718:	8b 43 20             	mov    0x20(%ebx),%eax
8010371b:	89 04 24             	mov    %eax,(%esp)
8010371e:	e8 7d 0b 00 00       	call   801042a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103723:	8b 43 20             	mov    0x20(%ebx),%eax
80103726:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010372b:	b9 23 00 00 00       	mov    $0x23,%ecx
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  p->userstack_top = 0;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103730:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103734:	8b 43 20             	mov    0x20(%ebx),%eax
80103737:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010373b:	8b 43 20             	mov    0x20(%ebx),%eax
8010373e:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103742:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103746:	8b 43 20             	mov    0x20(%ebx),%eax
80103749:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010374d:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103751:	8b 43 20             	mov    0x20(%ebx),%eax
80103754:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010375b:	8b 43 20             	mov    0x20(%ebx),%eax
8010375e:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103765:	8b 43 20             	mov    0x20(%ebx),%eax
80103768:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010376f:	8d 43 74             	lea    0x74(%ebx),%eax
80103772:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103779:	00 
8010377a:	c7 44 24 04 45 74 10 	movl   $0x80107445,0x4(%esp)
80103781:	80 
80103782:	89 04 24             	mov    %eax,(%esp)
80103785:	e8 f6 0c 00 00       	call   80104480 <safestrcpy>
  p->cwd = namei("/");
8010378a:	c7 04 24 4e 74 10 80 	movl   $0x8010744e,(%esp)
80103791:	e8 5a e7 ff ff       	call   80101ef0 <namei>
80103796:	89 43 70             	mov    %eax,0x70(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103799:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037a0:	e8 bb 09 00 00       	call   80104160 <acquire>

  p->state = RUNNABLE;
801037a5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801037ac:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037b3:	e8 98 0a 00 00       	call   80104250 <release>
}
801037b8:	83 c4 14             	add    $0x14,%esp
801037bb:	5b                   	pop    %ebx
801037bc:	5d                   	pop    %ebp
801037bd:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801037be:	c7 04 24 2c 74 10 80 	movl   $0x8010742c,(%esp)
801037c5:	e8 96 cb ff ff       	call   80100360 <panic>
801037ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037d0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	56                   	push   %esi
801037d4:	53                   	push   %ebx
801037d5:	83 ec 10             	sub    $0x10,%esp
801037d8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
801037db:	e8 b0 fe ff ff       	call   80103690 <myproc>

  sz = curproc->sz;
  if(n > 0){
801037e0:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
801037e3:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
801037e5:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801037e7:	7e 2f                	jle    80103818 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801037e9:	01 c6                	add    %eax,%esi
801037eb:	89 74 24 08          	mov    %esi,0x8(%esp)
801037ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801037f3:	8b 43 04             	mov    0x4(%ebx),%eax
801037f6:	89 04 24             	mov    %eax,(%esp)
801037f9:	e8 12 31 00 00       	call   80106910 <allocuvm>
801037fe:	85 c0                	test   %eax,%eax
80103800:	74 36                	je     80103838 <growproc+0x68>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103802:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103804:	89 1c 24             	mov    %ebx,(%esp)
80103807:	e8 a4 2e 00 00       	call   801066b0 <switchuvm>
  return 0;
8010380c:	31 c0                	xor    %eax,%eax
}
8010380e:	83 c4 10             	add    $0x10,%esp
80103811:	5b                   	pop    %ebx
80103812:	5e                   	pop    %esi
80103813:	5d                   	pop    %ebp
80103814:	c3                   	ret    
80103815:	8d 76 00             	lea    0x0(%esi),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103818:	74 e8                	je     80103802 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010381a:	01 c6                	add    %eax,%esi
8010381c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103820:	89 44 24 04          	mov    %eax,0x4(%esp)
80103824:	8b 43 04             	mov    0x4(%ebx),%eax
80103827:	89 04 24             	mov    %eax,(%esp)
8010382a:	e8 01 32 00 00       	call   80106a30 <deallocuvm>
8010382f:	85 c0                	test   %eax,%eax
80103831:	75 cf                	jne    80103802 <growproc+0x32>
80103833:	90                   	nop
80103834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103838:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010383d:	eb cf                	jmp    8010380e <growproc+0x3e>
8010383f:	90                   	nop

80103840 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103849:	e8 42 fe ff ff       	call   80103690 <myproc>
8010384e:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
80103850:	e8 5b fc ff ff       	call   801034b0 <allocproc>
80103855:	85 c0                	test   %eax,%eax
80103857:	89 c7                	mov    %eax,%edi
80103859:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010385c:	0f 84 c4 00 00 00    	je     80103926 <fork+0xe6>
    return -1;
  }

  // Copy process state from proc.
  //if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->userstack_top)) == 0){
80103862:	8b 43 18             	mov    0x18(%ebx),%eax
80103865:	89 44 24 08          	mov    %eax,0x8(%esp)
80103869:	8b 03                	mov    (%ebx),%eax
8010386b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010386f:	8b 43 04             	mov    0x4(%ebx),%eax
80103872:	89 04 24             	mov    %eax,(%esp)
80103875:	e8 36 33 00 00       	call   80106bb0 <copyuvm>
8010387a:	85 c0                	test   %eax,%eax
8010387c:	89 47 04             	mov    %eax,0x4(%edi)
8010387f:	0f 84 a8 00 00 00    	je     8010392d <fork+0xed>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103885:	8b 03                	mov    (%ebx),%eax
80103887:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010388a:	89 01                	mov    %eax,(%ecx)
  np->userstack_top = curproc->userstack_top;
8010388c:	8b 43 18             	mov    0x18(%ebx),%eax
  np->parent = curproc;
  *np->tf = *curproc->tf;
8010388f:	8b 79 20             	mov    0x20(%ecx),%edi
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->userstack_top = curproc->userstack_top;
  np->parent = curproc;
80103892:	89 59 14             	mov    %ebx,0x14(%ecx)
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->userstack_top = curproc->userstack_top;
80103895:	89 41 18             	mov    %eax,0x18(%ecx)
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103898:	8b 73 20             	mov    0x20(%ebx),%esi
8010389b:	89 c8                	mov    %ecx,%eax
8010389d:	b9 13 00 00 00       	mov    $0x13,%ecx
801038a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038a4:	31 f6                	xor    %esi,%esi
  np->userstack_top = curproc->userstack_top;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801038a6:	8b 40 20             	mov    0x20(%eax),%eax
801038a9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801038b0:	8b 44 b3 30          	mov    0x30(%ebx,%esi,4),%eax
801038b4:	85 c0                	test   %eax,%eax
801038b6:	74 0f                	je     801038c7 <fork+0x87>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038b8:	89 04 24             	mov    %eax,(%esp)
801038bb:	e8 00 d5 ff ff       	call   80100dc0 <filedup>
801038c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038c3:	89 44 b2 30          	mov    %eax,0x30(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038c7:	83 c6 01             	add    $0x1,%esi
801038ca:	83 fe 10             	cmp    $0x10,%esi
801038cd:	75 e1                	jne    801038b0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038cf:	8b 43 70             	mov    0x70(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038d2:	83 c3 74             	add    $0x74,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038d5:	89 04 24             	mov    %eax,(%esp)
801038d8:	e8 93 dd ff ff       	call   80101670 <idup>
801038dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038e0:	89 47 70             	mov    %eax,0x70(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038e3:	8d 47 74             	lea    0x74(%edi),%eax
801038e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801038ea:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801038f1:	00 
801038f2:	89 04 24             	mov    %eax,(%esp)
801038f5:	e8 86 0b 00 00       	call   80104480 <safestrcpy>

  pid = np->pid;
801038fa:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
801038fd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103904:	e8 57 08 00 00       	call   80104160 <acquire>

  np->state = RUNNABLE;
80103909:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103910:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103917:	e8 34 09 00 00       	call   80104250 <release>

  return pid;
8010391c:	89 d8                	mov    %ebx,%eax
}
8010391e:	83 c4 1c             	add    $0x1c,%esp
80103921:	5b                   	pop    %ebx
80103922:	5e                   	pop    %esi
80103923:	5f                   	pop    %edi
80103924:	5d                   	pop    %ebp
80103925:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103926:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010392b:	eb f1                	jmp    8010391e <fork+0xde>
  }

  // Copy process state from proc.
  //if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->userstack_top)) == 0){
    kfree(np->kstack);
8010392d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103930:	8b 47 08             	mov    0x8(%edi),%eax
80103933:	89 04 24             	mov    %eax,(%esp)
80103936:	e8 a5 e9 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
8010393b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  // Copy process state from proc.
  //if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->userstack_top)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103940:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103947:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
8010394e:	eb ce                	jmp    8010391e <fork+0xde>

80103950 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	57                   	push   %edi
80103954:	56                   	push   %esi
80103955:	53                   	push   %ebx
80103956:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103959:	e8 92 fc ff ff       	call   801035f0 <mycpu>
8010395e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103960:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103967:	00 00 00 
8010396a:	8d 78 04             	lea    0x4(%eax),%edi
8010396d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103970:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103971:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103978:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010397d:	e8 de 07 00 00       	call   80104160 <acquire>
80103982:	eb 12                	jmp    80103996 <scheduler+0x46>
80103984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103988:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010398e:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103994:	74 4a                	je     801039e0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103996:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010399a:	75 ec                	jne    80103988 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
8010399c:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039a2:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a5:	81 c3 84 00 00 00    	add    $0x84,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
801039ab:	e8 00 2d 00 00       	call   801066b0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
801039b0:	8b 43 a0             	mov    -0x60(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
801039b3:	c7 43 88 04 00 00 00 	movl   $0x4,-0x78(%ebx)

      swtch(&(c->scheduler), p->context);
801039ba:	89 3c 24             	mov    %edi,(%esp)
801039bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801039c1:	e8 15 0b 00 00       	call   801044db <swtch>
      switchkvm();
801039c6:	e8 c5 2c 00 00       	call   80106690 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039cb:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
801039d1:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801039d8:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039db:	75 b9                	jne    80103996 <scheduler+0x46>
801039dd:	8d 76 00             	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
801039e0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039e7:	e8 64 08 00 00       	call   80104250 <release>

  }
801039ec:	eb 82                	jmp    80103970 <scheduler+0x20>
801039ee:	66 90                	xchg   %ax,%ax

801039f0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
801039f5:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
801039f8:	e8 93 fc ff ff       	call   80103690 <myproc>

  if(!holding(&ptable.lock))
801039fd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103a04:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103a06:	e8 e5 06 00 00       	call   801040f0 <holding>
80103a0b:	85 c0                	test   %eax,%eax
80103a0d:	74 4f                	je     80103a5e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103a0f:	e8 dc fb ff ff       	call   801035f0 <mycpu>
80103a14:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a1b:	75 65                	jne    80103a82 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103a1d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a21:	74 53                	je     80103a76 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a23:	9c                   	pushf  
80103a24:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103a25:	f6 c4 02             	test   $0x2,%ah
80103a28:	75 40                	jne    80103a6a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a2a:	e8 c1 fb ff ff       	call   801035f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a2f:	83 c3 24             	add    $0x24,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a32:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a38:	e8 b3 fb ff ff       	call   801035f0 <mycpu>
80103a3d:	8b 40 04             	mov    0x4(%eax),%eax
80103a40:	89 1c 24             	mov    %ebx,(%esp)
80103a43:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a47:	e8 8f 0a 00 00       	call   801044db <swtch>
  mycpu()->intena = intena;
80103a4c:	e8 9f fb ff ff       	call   801035f0 <mycpu>
80103a51:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a57:	83 c4 10             	add    $0x10,%esp
80103a5a:	5b                   	pop    %ebx
80103a5b:	5e                   	pop    %esi
80103a5c:	5d                   	pop    %ebp
80103a5d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103a5e:	c7 04 24 50 74 10 80 	movl   $0x80107450,(%esp)
80103a65:	e8 f6 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103a6a:	c7 04 24 7c 74 10 80 	movl   $0x8010747c,(%esp)
80103a71:	e8 ea c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103a76:	c7 04 24 6e 74 10 80 	movl   $0x8010746e,(%esp)
80103a7d:	e8 de c8 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103a82:	c7 04 24 62 74 10 80 	movl   $0x80107462,(%esp)
80103a89:	e8 d2 c8 ff ff       	call   80100360 <panic>
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103a94:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103a96:	53                   	push   %ebx
80103a97:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103a9a:	e8 f1 fb ff ff       	call   80103690 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103a9f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103aa5:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103aa7:	0f 84 fd 00 00 00    	je     80103baa <exit+0x11a>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103ab0:	8b 44 b3 30          	mov    0x30(%ebx,%esi,4),%eax
80103ab4:	85 c0                	test   %eax,%eax
80103ab6:	74 10                	je     80103ac8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ab8:	89 04 24             	mov    %eax,(%esp)
80103abb:	e8 50 d3 ff ff       	call   80100e10 <fileclose>
      curproc->ofile[fd] = 0;
80103ac0:	c7 44 b3 30 00 00 00 	movl   $0x0,0x30(%ebx,%esi,4)
80103ac7:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ac8:	83 c6 01             	add    $0x1,%esi
80103acb:	83 fe 10             	cmp    $0x10,%esi
80103ace:	75 e0                	jne    80103ab0 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103ad0:	e8 2b f0 ff ff       	call   80102b00 <begin_op>
  iput(curproc->cwd);
80103ad5:	8b 43 70             	mov    0x70(%ebx),%eax
80103ad8:	89 04 24             	mov    %eax,(%esp)
80103adb:	e8 e0 dc ff ff       	call   801017c0 <iput>
  end_op();
80103ae0:	e8 8b f0 ff ff       	call   80102b70 <end_op>
  curproc->cwd = 0;
80103ae5:	c7 43 70 00 00 00 00 	movl   $0x0,0x70(%ebx)

  acquire(&ptable.lock);
80103aec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103af3:	e8 68 06 00 00       	call   80104160 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103af8:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103afb:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b00:	eb 14                	jmp    80103b16 <exit+0x86>
80103b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b08:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b0e:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b14:	74 20                	je     80103b36 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103b16:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b1a:	75 ec                	jne    80103b08 <exit+0x78>
80103b1c:	3b 42 28             	cmp    0x28(%edx),%eax
80103b1f:	75 e7                	jne    80103b08 <exit+0x78>
      p->state = RUNNABLE;
80103b21:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b28:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b2e:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b34:	75 e0                	jne    80103b16 <exit+0x86>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103b36:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b3b:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b40:	eb 14                	jmp    80103b56 <exit+0xc6>
80103b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b48:	81 c1 84 00 00 00    	add    $0x84,%ecx
80103b4e:	81 f9 54 4e 11 80    	cmp    $0x80114e54,%ecx
80103b54:	74 3c                	je     80103b92 <exit+0x102>
    if(p->parent == curproc){
80103b56:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b59:	75 ed                	jne    80103b48 <exit+0xb8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103b5b:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103b5f:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103b62:	75 e4                	jne    80103b48 <exit+0xb8>
80103b64:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b69:	eb 13                	jmp    80103b7e <exit+0xee>
80103b6b:	90                   	nop
80103b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b70:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b76:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b7c:	74 ca                	je     80103b48 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103b7e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b82:	75 ec                	jne    80103b70 <exit+0xe0>
80103b84:	3b 42 28             	cmp    0x28(%edx),%eax
80103b87:	75 e7                	jne    80103b70 <exit+0xe0>
      p->state = RUNNABLE;
80103b89:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103b90:	eb de                	jmp    80103b70 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103b92:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103b99:	e8 52 fe ff ff       	call   801039f0 <sched>
  panic("zombie exit");
80103b9e:	c7 04 24 9d 74 10 80 	movl   $0x8010749d,(%esp)
80103ba5:	e8 b6 c7 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103baa:	c7 04 24 90 74 10 80 	movl   $0x80107490,(%esp)
80103bb1:	e8 aa c7 ff ff       	call   80100360 <panic>
80103bb6:	8d 76 00             	lea    0x0(%esi),%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103bc6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bcd:	e8 8e 05 00 00       	call   80104160 <acquire>
  myproc()->state = RUNNABLE;
80103bd2:	e8 b9 fa ff ff       	call   80103690 <myproc>
80103bd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103bde:	e8 0d fe ff ff       	call   801039f0 <sched>
  release(&ptable.lock);
80103be3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bea:	e8 61 06 00 00       	call   80104250 <release>
}
80103bef:	c9                   	leave  
80103bf0:	c3                   	ret    
80103bf1:	eb 0d                	jmp    80103c00 <sleep>
80103bf3:	90                   	nop
80103bf4:	90                   	nop
80103bf5:	90                   	nop
80103bf6:	90                   	nop
80103bf7:	90                   	nop
80103bf8:	90                   	nop
80103bf9:	90                   	nop
80103bfa:	90                   	nop
80103bfb:	90                   	nop
80103bfc:	90                   	nop
80103bfd:	90                   	nop
80103bfe:	90                   	nop
80103bff:	90                   	nop

80103c00 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	57                   	push   %edi
80103c04:	56                   	push   %esi
80103c05:	53                   	push   %ebx
80103c06:	83 ec 1c             	sub    $0x1c,%esp
80103c09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c0f:	e8 7c fa ff ff       	call   80103690 <myproc>
  
  if(p == 0)
80103c14:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103c16:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103c18:	0f 84 7c 00 00 00    	je     80103c9a <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103c1e:	85 f6                	test   %esi,%esi
80103c20:	74 6c                	je     80103c8e <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c22:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c28:	74 46                	je     80103c70 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c2a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c31:	e8 2a 05 00 00       	call   80104160 <acquire>
    release(lk);
80103c36:	89 34 24             	mov    %esi,(%esp)
80103c39:	e8 12 06 00 00       	call   80104250 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103c3e:	89 7b 28             	mov    %edi,0x28(%ebx)
  p->state = SLEEPING;
80103c41:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103c48:	e8 a3 fd ff ff       	call   801039f0 <sched>

  // Tidy up.
  p->chan = 0;
80103c4d:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103c54:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c5b:	e8 f0 05 00 00       	call   80104250 <release>
    acquire(lk);
80103c60:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103c63:	83 c4 1c             	add    $0x1c,%esp
80103c66:	5b                   	pop    %ebx
80103c67:	5e                   	pop    %esi
80103c68:	5f                   	pop    %edi
80103c69:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103c6a:	e9 f1 04 00 00       	jmp    80104160 <acquire>
80103c6f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103c70:	89 78 28             	mov    %edi,0x28(%eax)
  p->state = SLEEPING;
80103c73:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103c7a:	e8 71 fd ff ff       	call   801039f0 <sched>

  // Tidy up.
  p->chan = 0;
80103c7f:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103c86:	83 c4 1c             	add    $0x1c,%esp
80103c89:	5b                   	pop    %ebx
80103c8a:	5e                   	pop    %esi
80103c8b:	5f                   	pop    %edi
80103c8c:	5d                   	pop    %ebp
80103c8d:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103c8e:	c7 04 24 af 74 10 80 	movl   $0x801074af,(%esp)
80103c95:	e8 c6 c6 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103c9a:	c7 04 24 a9 74 10 80 	movl   $0x801074a9,(%esp)
80103ca1:	e8 ba c6 ff ff       	call   80100360 <panic>
80103ca6:	8d 76 00             	lea    0x0(%esi),%esi
80103ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cb0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	56                   	push   %esi
80103cb4:	53                   	push   %ebx
80103cb5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103cb8:	e8 d3 f9 ff ff       	call   80103690 <myproc>
  
  acquire(&ptable.lock);
80103cbd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103cc4:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103cc6:	e8 95 04 00 00       	call   80104160 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103ccb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ccd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103cd2:	eb 12                	jmp    80103ce6 <wait+0x36>
80103cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cd8:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103cde:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103ce4:	74 22                	je     80103d08 <wait+0x58>
      if(p->parent != curproc)
80103ce6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ce9:	75 ed                	jne    80103cd8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103ceb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103cef:	74 34                	je     80103d25 <wait+0x75>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf1:	81 c3 84 00 00 00    	add    $0x84,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103cf7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cfc:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103d02:	75 e2                	jne    80103ce6 <wait+0x36>
80103d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103d08:	85 c0                	test   %eax,%eax
80103d0a:	74 6e                	je     80103d7a <wait+0xca>
80103d0c:	8b 46 2c             	mov    0x2c(%esi),%eax
80103d0f:	85 c0                	test   %eax,%eax
80103d11:	75 67                	jne    80103d7a <wait+0xca>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d13:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d1a:	80 
80103d1b:	89 34 24             	mov    %esi,(%esp)
80103d1e:	e8 dd fe ff ff       	call   80103c00 <sleep>
  }
80103d23:	eb a6                	jmp    80103ccb <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103d25:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103d28:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d2b:	89 04 24             	mov    %eax,(%esp)
80103d2e:	e8 ad e5 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103d33:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103d36:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d3d:	89 04 24             	mov    %eax,(%esp)
80103d40:	e8 0b 2d 00 00       	call   80106a50 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103d45:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103d4c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d53:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d5a:	c6 43 74 00          	movb   $0x0,0x74(%ebx)
        p->killed = 0;
80103d5e:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->state = UNUSED;
80103d65:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103d6c:	e8 df 04 00 00       	call   80104250 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d71:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103d74:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d76:	5b                   	pop    %ebx
80103d77:	5e                   	pop    %esi
80103d78:	5d                   	pop    %ebp
80103d79:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103d7a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d81:	e8 ca 04 00 00       	call   80104250 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d86:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103d89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103d8e:	5b                   	pop    %ebx
80103d8f:	5e                   	pop    %esi
80103d90:	5d                   	pop    %ebp
80103d91:	c3                   	ret    
80103d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103da0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	53                   	push   %ebx
80103da4:	83 ec 14             	sub    $0x14,%esp
80103da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103daa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103db1:	e8 aa 03 00 00       	call   80104160 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103db6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dbb:	eb 0f                	jmp    80103dcc <wakeup+0x2c>
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
80103dc0:	05 84 00 00 00       	add    $0x84,%eax
80103dc5:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103dca:	74 24                	je     80103df0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103dcc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dd0:	75 ee                	jne    80103dc0 <wakeup+0x20>
80103dd2:	3b 58 28             	cmp    0x28(%eax),%ebx
80103dd5:	75 e9                	jne    80103dc0 <wakeup+0x20>
      p->state = RUNNABLE;
80103dd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dde:	05 84 00 00 00       	add    $0x84,%eax
80103de3:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103de8:	75 e2                	jne    80103dcc <wakeup+0x2c>
80103dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103df0:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103df7:	83 c4 14             	add    $0x14,%esp
80103dfa:	5b                   	pop    %ebx
80103dfb:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103dfc:	e9 4f 04 00 00       	jmp    80104250 <release>
80103e01:	eb 0d                	jmp    80103e10 <kill>
80103e03:	90                   	nop
80103e04:	90                   	nop
80103e05:	90                   	nop
80103e06:	90                   	nop
80103e07:	90                   	nop
80103e08:	90                   	nop
80103e09:	90                   	nop
80103e0a:	90                   	nop
80103e0b:	90                   	nop
80103e0c:	90                   	nop
80103e0d:	90                   	nop
80103e0e:	90                   	nop
80103e0f:	90                   	nop

80103e10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
80103e14:	83 ec 14             	sub    $0x14,%esp
80103e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e1a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e21:	e8 3a 03 00 00       	call   80104160 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e26:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e2b:	eb 0f                	jmp    80103e3c <kill+0x2c>
80103e2d:	8d 76 00             	lea    0x0(%esi),%esi
80103e30:	05 84 00 00 00       	add    $0x84,%eax
80103e35:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103e3a:	74 3c                	je     80103e78 <kill+0x68>
    if(p->pid == pid){
80103e3c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e3f:	75 ef                	jne    80103e30 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e41:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103e45:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e4c:	74 1a                	je     80103e68 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e4e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e55:	e8 f6 03 00 00       	call   80104250 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e5a:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103e5d:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e5f:	5b                   	pop    %ebx
80103e60:	5d                   	pop    %ebp
80103e61:	c3                   	ret    
80103e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103e68:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e6f:	eb dd                	jmp    80103e4e <kill+0x3e>
80103e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103e78:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e7f:	e8 cc 03 00 00       	call   80104250 <release>
  return -1;
}
80103e84:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103e87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e8c:	5b                   	pop    %ebx
80103e8d:	5d                   	pop    %ebp
80103e8e:	c3                   	ret    
80103e8f:	90                   	nop

80103e90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	bb c8 2d 11 80       	mov    $0x80112dc8,%ebx
80103e9b:	83 ec 4c             	sub    $0x4c,%esp
80103e9e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ea1:	eb 23                	jmp    80103ec6 <procdump+0x36>
80103ea3:	90                   	nop
80103ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ea8:	c7 04 24 b7 78 10 80 	movl   $0x801078b7,(%esp)
80103eaf:	e8 9c c7 ff ff       	call   80100650 <cprintf>
80103eb4:	81 c3 84 00 00 00    	add    $0x84,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eba:	81 fb c8 4e 11 80    	cmp    $0x80114ec8,%ebx
80103ec0:	0f 84 8a 00 00 00    	je     80103f50 <procdump+0xc0>
    if(p->state == UNUSED)
80103ec6:	8b 43 98             	mov    -0x68(%ebx),%eax
80103ec9:	85 c0                	test   %eax,%eax
80103ecb:	74 e7                	je     80103eb4 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ecd:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103ed0:	ba c0 74 10 80       	mov    $0x801074c0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ed5:	77 11                	ja     80103ee8 <procdump+0x58>
80103ed7:	8b 14 85 20 75 10 80 	mov    -0x7fef8ae0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103ede:	b8 c0 74 10 80       	mov    $0x801074c0,%eax
80103ee3:	85 d2                	test   %edx,%edx
80103ee5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103ee8:	8b 43 9c             	mov    -0x64(%ebx),%eax
80103eeb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103eef:	89 54 24 08          	mov    %edx,0x8(%esp)
80103ef3:	c7 04 24 c4 74 10 80 	movl   $0x801074c4,(%esp)
80103efa:	89 44 24 04          	mov    %eax,0x4(%esp)
80103efe:	e8 4d c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f03:	83 7b 98 02          	cmpl   $0x2,-0x68(%ebx)
80103f07:	75 9f                	jne    80103ea8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f09:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f10:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f13:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f16:	8b 40 0c             	mov    0xc(%eax),%eax
80103f19:	83 c0 08             	add    $0x8,%eax
80103f1c:	89 04 24             	mov    %eax,(%esp)
80103f1f:	e8 6c 01 00 00       	call   80104090 <getcallerpcs>
80103f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f28:	8b 17                	mov    (%edi),%edx
80103f2a:	85 d2                	test   %edx,%edx
80103f2c:	0f 84 76 ff ff ff    	je     80103ea8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f32:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f36:	83 c7 04             	add    $0x4,%edi
80103f39:	c7 04 24 01 6f 10 80 	movl   $0x80106f01,(%esp)
80103f40:	e8 0b c7 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103f45:	39 f7                	cmp    %esi,%edi
80103f47:	75 df                	jne    80103f28 <procdump+0x98>
80103f49:	e9 5a ff ff ff       	jmp    80103ea8 <procdump+0x18>
80103f4e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103f50:	83 c4 4c             	add    $0x4c,%esp
80103f53:	5b                   	pop    %ebx
80103f54:	5e                   	pop    %esi
80103f55:	5f                   	pop    %edi
80103f56:	5d                   	pop    %ebp
80103f57:	c3                   	ret    
80103f58:	66 90                	xchg   %ax,%ax
80103f5a:	66 90                	xchg   %ax,%ax
80103f5c:	66 90                	xchg   %ax,%ax
80103f5e:	66 90                	xchg   %ax,%ax

80103f60 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	53                   	push   %ebx
80103f64:	83 ec 14             	sub    $0x14,%esp
80103f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f6a:	c7 44 24 04 38 75 10 	movl   $0x80107538,0x4(%esp)
80103f71:	80 
80103f72:	8d 43 04             	lea    0x4(%ebx),%eax
80103f75:	89 04 24             	mov    %eax,(%esp)
80103f78:	e8 f3 00 00 00       	call   80104070 <initlock>
  lk->name = name;
80103f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103f80:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f86:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80103f8d:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80103f90:	83 c4 14             	add    $0x14,%esp
80103f93:	5b                   	pop    %ebx
80103f94:	5d                   	pop    %ebp
80103f95:	c3                   	ret    
80103f96:	8d 76 00             	lea    0x0(%esi),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
80103fa5:	83 ec 10             	sub    $0x10,%esp
80103fa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fab:	8d 73 04             	lea    0x4(%ebx),%esi
80103fae:	89 34 24             	mov    %esi,(%esp)
80103fb1:	e8 aa 01 00 00       	call   80104160 <acquire>
  while (lk->locked) {
80103fb6:	8b 13                	mov    (%ebx),%edx
80103fb8:	85 d2                	test   %edx,%edx
80103fba:	74 16                	je     80103fd2 <acquiresleep+0x32>
80103fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103fc0:	89 74 24 04          	mov    %esi,0x4(%esp)
80103fc4:	89 1c 24             	mov    %ebx,(%esp)
80103fc7:	e8 34 fc ff ff       	call   80103c00 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80103fcc:	8b 03                	mov    (%ebx),%eax
80103fce:	85 c0                	test   %eax,%eax
80103fd0:	75 ee                	jne    80103fc0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80103fd2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103fd8:	e8 b3 f6 ff ff       	call   80103690 <myproc>
80103fdd:	8b 40 10             	mov    0x10(%eax),%eax
80103fe0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103fe3:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103fe6:	83 c4 10             	add    $0x10,%esp
80103fe9:	5b                   	pop    %ebx
80103fea:	5e                   	pop    %esi
80103feb:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80103fec:	e9 5f 02 00 00       	jmp    80104250 <release>
80103ff1:	eb 0d                	jmp    80104000 <releasesleep>
80103ff3:	90                   	nop
80103ff4:	90                   	nop
80103ff5:	90                   	nop
80103ff6:	90                   	nop
80103ff7:	90                   	nop
80103ff8:	90                   	nop
80103ff9:	90                   	nop
80103ffa:	90                   	nop
80103ffb:	90                   	nop
80103ffc:	90                   	nop
80103ffd:	90                   	nop
80103ffe:	90                   	nop
80103fff:	90                   	nop

80104000 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
80104005:	83 ec 10             	sub    $0x10,%esp
80104008:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010400b:	8d 73 04             	lea    0x4(%ebx),%esi
8010400e:	89 34 24             	mov    %esi,(%esp)
80104011:	e8 4a 01 00 00       	call   80104160 <acquire>
  lk->locked = 0;
80104016:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010401c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104023:	89 1c 24             	mov    %ebx,(%esp)
80104026:	e8 75 fd ff ff       	call   80103da0 <wakeup>
  release(&lk->lk);
8010402b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010402e:	83 c4 10             	add    $0x10,%esp
80104031:	5b                   	pop    %ebx
80104032:	5e                   	pop    %esi
80104033:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104034:	e9 17 02 00 00       	jmp    80104250 <release>
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	56                   	push   %esi
80104044:	53                   	push   %ebx
80104045:	83 ec 10             	sub    $0x10,%esp
80104048:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010404b:	8d 73 04             	lea    0x4(%ebx),%esi
8010404e:	89 34 24             	mov    %esi,(%esp)
80104051:	e8 0a 01 00 00       	call   80104160 <acquire>
  r = lk->locked;
80104056:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80104058:	89 34 24             	mov    %esi,(%esp)
8010405b:	e8 f0 01 00 00       	call   80104250 <release>
  return r;
}
80104060:	83 c4 10             	add    $0x10,%esp
80104063:	89 d8                	mov    %ebx,%eax
80104065:	5b                   	pop    %ebx
80104066:	5e                   	pop    %esi
80104067:	5d                   	pop    %ebp
80104068:	c3                   	ret    
80104069:	66 90                	xchg   %ax,%ax
8010406b:	66 90                	xchg   %ax,%ax
8010406d:	66 90                	xchg   %ax,%ax
8010406f:	90                   	nop

80104070 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104076:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104079:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010407f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104082:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104089:	5d                   	pop    %ebp
8010408a:	c3                   	ret    
8010408b:	90                   	nop
8010408c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104090 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104093:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104099:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010409a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010409d:	31 c0                	xor    %eax,%eax
8010409f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040ac:	77 1a                	ja     801040c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801040b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801040b4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801040b7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801040b9:	83 f8 0a             	cmp    $0xa,%eax
801040bc:	75 e2                	jne    801040a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801040be:	5b                   	pop    %ebx
801040bf:	5d                   	pop    %ebp
801040c0:	c3                   	ret    
801040c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801040c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801040cf:	83 c0 01             	add    $0x1,%eax
801040d2:	83 f8 0a             	cmp    $0xa,%eax
801040d5:	74 e7                	je     801040be <getcallerpcs+0x2e>
    pcs[i] = 0;
801040d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801040de:	83 c0 01             	add    $0x1,%eax
801040e1:	83 f8 0a             	cmp    $0xa,%eax
801040e4:	75 e2                	jne    801040c8 <getcallerpcs+0x38>
801040e6:	eb d6                	jmp    801040be <getcallerpcs+0x2e>
801040e8:	90                   	nop
801040e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040f0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040f0:	55                   	push   %ebp
  return lock->locked && lock->cpu == mycpu();
801040f1:	31 c0                	xor    %eax,%eax
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801040f3:	89 e5                	mov    %esp,%ebp
801040f5:	53                   	push   %ebx
801040f6:	83 ec 04             	sub    $0x4,%esp
801040f9:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801040fc:	8b 0a                	mov    (%edx),%ecx
801040fe:	85 c9                	test   %ecx,%ecx
80104100:	74 10                	je     80104112 <holding+0x22>
80104102:	8b 5a 08             	mov    0x8(%edx),%ebx
80104105:	e8 e6 f4 ff ff       	call   801035f0 <mycpu>
8010410a:	39 c3                	cmp    %eax,%ebx
8010410c:	0f 94 c0             	sete   %al
8010410f:	0f b6 c0             	movzbl %al,%eax
}
80104112:	83 c4 04             	add    $0x4,%esp
80104115:	5b                   	pop    %ebx
80104116:	5d                   	pop    %ebp
80104117:	c3                   	ret    
80104118:	90                   	nop
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	53                   	push   %ebx
80104124:	83 ec 04             	sub    $0x4,%esp
80104127:	9c                   	pushf  
80104128:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104129:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010412a:	e8 c1 f4 ff ff       	call   801035f0 <mycpu>
8010412f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104135:	85 c0                	test   %eax,%eax
80104137:	75 11                	jne    8010414a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104139:	e8 b2 f4 ff ff       	call   801035f0 <mycpu>
8010413e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104144:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010414a:	e8 a1 f4 ff ff       	call   801035f0 <mycpu>
8010414f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104156:	83 c4 04             	add    $0x4,%esp
80104159:	5b                   	pop    %ebx
8010415a:	5d                   	pop    %ebp
8010415b:	c3                   	ret    
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104160 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104167:	e8 b4 ff ff ff       	call   80104120 <pushcli>
  if(holding(lk))
8010416c:	8b 55 08             	mov    0x8(%ebp),%edx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010416f:	8b 02                	mov    (%edx),%eax
80104171:	85 c0                	test   %eax,%eax
80104173:	75 43                	jne    801041b8 <acquire+0x58>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104175:	b9 01 00 00 00       	mov    $0x1,%ecx
8010417a:	eb 07                	jmp    80104183 <acquire+0x23>
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104180:	8b 55 08             	mov    0x8(%ebp),%edx
80104183:	89 c8                	mov    %ecx,%eax
80104185:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104188:	85 c0                	test   %eax,%eax
8010418a:	75 f4                	jne    80104180 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010418c:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010418f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104192:	e8 59 f4 ff ff       	call   801035f0 <mycpu>
80104197:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010419a:	8b 45 08             	mov    0x8(%ebp),%eax
8010419d:	83 c0 0c             	add    $0xc,%eax
801041a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801041a4:	8d 45 08             	lea    0x8(%ebp),%eax
801041a7:	89 04 24             	mov    %eax,(%esp)
801041aa:	e8 e1 fe ff ff       	call   80104090 <getcallerpcs>
}
801041af:	83 c4 14             	add    $0x14,%esp
801041b2:	5b                   	pop    %ebx
801041b3:	5d                   	pop    %ebp
801041b4:	c3                   	ret    
801041b5:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801041b8:	8b 5a 08             	mov    0x8(%edx),%ebx
801041bb:	e8 30 f4 ff ff       	call   801035f0 <mycpu>
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801041c0:	39 c3                	cmp    %eax,%ebx
801041c2:	74 05                	je     801041c9 <acquire+0x69>
801041c4:	8b 55 08             	mov    0x8(%ebp),%edx
801041c7:	eb ac                	jmp    80104175 <acquire+0x15>
    panic("acquire");
801041c9:	c7 04 24 43 75 10 80 	movl   $0x80107543,(%esp)
801041d0:	e8 8b c1 ff ff       	call   80100360 <panic>
801041d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041e6:	9c                   	pushf  
801041e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041e8:	f6 c4 02             	test   $0x2,%ah
801041eb:	75 49                	jne    80104236 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801041ed:	e8 fe f3 ff ff       	call   801035f0 <mycpu>
801041f2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801041f8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801041fb:	85 d2                	test   %edx,%edx
801041fd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104203:	78 25                	js     8010422a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104205:	e8 e6 f3 ff ff       	call   801035f0 <mycpu>
8010420a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104210:	85 d2                	test   %edx,%edx
80104212:	74 04                	je     80104218 <popcli+0x38>
    sti();
}
80104214:	c9                   	leave  
80104215:	c3                   	ret    
80104216:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104218:	e8 d3 f3 ff ff       	call   801035f0 <mycpu>
8010421d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104223:	85 c0                	test   %eax,%eax
80104225:	74 ed                	je     80104214 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104227:	fb                   	sti    
    sti();
}
80104228:	c9                   	leave  
80104229:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
8010422a:	c7 04 24 62 75 10 80 	movl   $0x80107562,(%esp)
80104231:	e8 2a c1 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104236:	c7 04 24 4b 75 10 80 	movl   $0x8010754b,(%esp)
8010423d:	e8 1e c1 ff ff       	call   80100360 <panic>
80104242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
80104255:	83 ec 10             	sub    $0x10,%esp
80104258:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010425b:	8b 03                	mov    (%ebx),%eax
8010425d:	85 c0                	test   %eax,%eax
8010425f:	75 0f                	jne    80104270 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104261:	c7 04 24 69 75 10 80 	movl   $0x80107569,(%esp)
80104268:	e8 f3 c0 ff ff       	call   80100360 <panic>
8010426d:	8d 76 00             	lea    0x0(%esi),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104270:	8b 73 08             	mov    0x8(%ebx),%esi
80104273:	e8 78 f3 ff ff       	call   801035f0 <mycpu>

// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
80104278:	39 c6                	cmp    %eax,%esi
8010427a:	75 e5                	jne    80104261 <release+0x11>
    panic("release");

  lk->pcs[0] = 0;
8010427c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104283:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010428a:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010428d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104293:	83 c4 10             	add    $0x10,%esp
80104296:	5b                   	pop    %ebx
80104297:	5e                   	pop    %esi
80104298:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104299:	e9 42 ff ff ff       	jmp    801041e0 <popcli>
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	8b 55 08             	mov    0x8(%ebp),%edx
801042a6:	57                   	push   %edi
801042a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801042aa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801042ab:	f6 c2 03             	test   $0x3,%dl
801042ae:	75 05                	jne    801042b5 <memset+0x15>
801042b0:	f6 c1 03             	test   $0x3,%cl
801042b3:	74 13                	je     801042c8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801042b5:	89 d7                	mov    %edx,%edi
801042b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801042ba:	fc                   	cld    
801042bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801042bd:	5b                   	pop    %ebx
801042be:	89 d0                	mov    %edx,%eax
801042c0:	5f                   	pop    %edi
801042c1:	5d                   	pop    %ebp
801042c2:	c3                   	ret    
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801042c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801042cc:	c1 e9 02             	shr    $0x2,%ecx
801042cf:	89 f8                	mov    %edi,%eax
801042d1:	89 fb                	mov    %edi,%ebx
801042d3:	c1 e0 18             	shl    $0x18,%eax
801042d6:	c1 e3 10             	shl    $0x10,%ebx
801042d9:	09 d8                	or     %ebx,%eax
801042db:	09 f8                	or     %edi,%eax
801042dd:	c1 e7 08             	shl    $0x8,%edi
801042e0:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801042e2:	89 d7                	mov    %edx,%edi
801042e4:	fc                   	cld    
801042e5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801042e7:	5b                   	pop    %ebx
801042e8:	89 d0                	mov    %edx,%eax
801042ea:	5f                   	pop    %edi
801042eb:	5d                   	pop    %ebp
801042ec:	c3                   	ret    
801042ed:	8d 76 00             	lea    0x0(%esi),%esi

801042f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	8b 45 10             	mov    0x10(%ebp),%eax
801042f6:	57                   	push   %edi
801042f7:	56                   	push   %esi
801042f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801042fb:	53                   	push   %ebx
801042fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801042ff:	85 c0                	test   %eax,%eax
80104301:	8d 78 ff             	lea    -0x1(%eax),%edi
80104304:	74 26                	je     8010432c <memcmp+0x3c>
    if(*s1 != *s2)
80104306:	0f b6 03             	movzbl (%ebx),%eax
80104309:	31 d2                	xor    %edx,%edx
8010430b:	0f b6 0e             	movzbl (%esi),%ecx
8010430e:	38 c8                	cmp    %cl,%al
80104310:	74 16                	je     80104328 <memcmp+0x38>
80104312:	eb 24                	jmp    80104338 <memcmp+0x48>
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104318:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010431d:	83 c2 01             	add    $0x1,%edx
80104320:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104324:	38 c8                	cmp    %cl,%al
80104326:	75 10                	jne    80104338 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104328:	39 fa                	cmp    %edi,%edx
8010432a:	75 ec                	jne    80104318 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010432c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010432d:	31 c0                	xor    %eax,%eax
}
8010432f:	5e                   	pop    %esi
80104330:	5f                   	pop    %edi
80104331:	5d                   	pop    %ebp
80104332:	c3                   	ret    
80104333:	90                   	nop
80104334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104338:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104339:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010433b:	5e                   	pop    %esi
8010433c:	5f                   	pop    %edi
8010433d:	5d                   	pop    %ebp
8010433e:	c3                   	ret    
8010433f:	90                   	nop

80104340 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	8b 45 08             	mov    0x8(%ebp),%eax
80104347:	56                   	push   %esi
80104348:	8b 75 0c             	mov    0xc(%ebp),%esi
8010434b:	53                   	push   %ebx
8010434c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010434f:	39 c6                	cmp    %eax,%esi
80104351:	73 35                	jae    80104388 <memmove+0x48>
80104353:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104356:	39 c8                	cmp    %ecx,%eax
80104358:	73 2e                	jae    80104388 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010435a:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
8010435c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010435f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104362:	74 1b                	je     8010437f <memmove+0x3f>
80104364:	f7 db                	neg    %ebx
80104366:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104369:	01 fb                	add    %edi,%ebx
8010436b:	90                   	nop
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104370:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104374:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104377:	83 ea 01             	sub    $0x1,%edx
8010437a:	83 fa ff             	cmp    $0xffffffff,%edx
8010437d:	75 f1                	jne    80104370 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010437f:	5b                   	pop    %ebx
80104380:	5e                   	pop    %esi
80104381:	5f                   	pop    %edi
80104382:	5d                   	pop    %ebp
80104383:	c3                   	ret    
80104384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104388:	31 d2                	xor    %edx,%edx
8010438a:	85 db                	test   %ebx,%ebx
8010438c:	74 f1                	je     8010437f <memmove+0x3f>
8010438e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104390:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104394:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104397:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010439a:	39 da                	cmp    %ebx,%edx
8010439c:	75 f2                	jne    80104390 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010439e:	5b                   	pop    %ebx
8010439f:	5e                   	pop    %esi
801043a0:	5f                   	pop    %edi
801043a1:	5d                   	pop    %ebp
801043a2:	c3                   	ret    
801043a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801043b3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801043b4:	e9 87 ff ff ff       	jmp    80104340 <memmove>
801043b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	56                   	push   %esi
801043c4:	8b 75 10             	mov    0x10(%ebp),%esi
801043c7:	53                   	push   %ebx
801043c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801043cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801043ce:	85 f6                	test   %esi,%esi
801043d0:	74 30                	je     80104402 <strncmp+0x42>
801043d2:	0f b6 01             	movzbl (%ecx),%eax
801043d5:	84 c0                	test   %al,%al
801043d7:	74 2f                	je     80104408 <strncmp+0x48>
801043d9:	0f b6 13             	movzbl (%ebx),%edx
801043dc:	38 d0                	cmp    %dl,%al
801043de:	75 46                	jne    80104426 <strncmp+0x66>
801043e0:	8d 51 01             	lea    0x1(%ecx),%edx
801043e3:	01 ce                	add    %ecx,%esi
801043e5:	eb 14                	jmp    801043fb <strncmp+0x3b>
801043e7:	90                   	nop
801043e8:	0f b6 02             	movzbl (%edx),%eax
801043eb:	84 c0                	test   %al,%al
801043ed:	74 31                	je     80104420 <strncmp+0x60>
801043ef:	0f b6 19             	movzbl (%ecx),%ebx
801043f2:	83 c2 01             	add    $0x1,%edx
801043f5:	38 d8                	cmp    %bl,%al
801043f7:	75 17                	jne    80104410 <strncmp+0x50>
    n--, p++, q++;
801043f9:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801043fb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801043fd:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104400:	75 e6                	jne    801043e8 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104402:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104403:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104405:	5e                   	pop    %esi
80104406:	5d                   	pop    %ebp
80104407:	c3                   	ret    
80104408:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010440b:	31 c0                	xor    %eax,%eax
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104410:	0f b6 d3             	movzbl %bl,%edx
80104413:	29 d0                	sub    %edx,%eax
}
80104415:	5b                   	pop    %ebx
80104416:	5e                   	pop    %esi
80104417:	5d                   	pop    %ebp
80104418:	c3                   	ret    
80104419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104420:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104424:	eb ea                	jmp    80104410 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104426:	89 d3                	mov    %edx,%ebx
80104428:	eb e6                	jmp    80104410 <strncmp+0x50>
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	8b 45 08             	mov    0x8(%ebp),%eax
80104436:	56                   	push   %esi
80104437:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010443a:	53                   	push   %ebx
8010443b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010443e:	89 c2                	mov    %eax,%edx
80104440:	eb 19                	jmp    8010445b <strncpy+0x2b>
80104442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104448:	83 c3 01             	add    $0x1,%ebx
8010444b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010444f:	83 c2 01             	add    $0x1,%edx
80104452:	84 c9                	test   %cl,%cl
80104454:	88 4a ff             	mov    %cl,-0x1(%edx)
80104457:	74 09                	je     80104462 <strncpy+0x32>
80104459:	89 f1                	mov    %esi,%ecx
8010445b:	85 c9                	test   %ecx,%ecx
8010445d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104460:	7f e6                	jg     80104448 <strncpy+0x18>
    ;
  while(n-- > 0)
80104462:	31 c9                	xor    %ecx,%ecx
80104464:	85 f6                	test   %esi,%esi
80104466:	7e 0f                	jle    80104477 <strncpy+0x47>
    *s++ = 0;
80104468:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010446c:	89 f3                	mov    %esi,%ebx
8010446e:	83 c1 01             	add    $0x1,%ecx
80104471:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104473:	85 db                	test   %ebx,%ebx
80104475:	7f f1                	jg     80104468 <strncpy+0x38>
    *s++ = 0;
  return os;
}
80104477:	5b                   	pop    %ebx
80104478:	5e                   	pop    %esi
80104479:	5d                   	pop    %ebp
8010447a:	c3                   	ret    
8010447b:	90                   	nop
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104486:	56                   	push   %esi
80104487:	8b 45 08             	mov    0x8(%ebp),%eax
8010448a:	53                   	push   %ebx
8010448b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010448e:	85 c9                	test   %ecx,%ecx
80104490:	7e 26                	jle    801044b8 <safestrcpy+0x38>
80104492:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104496:	89 c1                	mov    %eax,%ecx
80104498:	eb 17                	jmp    801044b1 <safestrcpy+0x31>
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044a0:	83 c2 01             	add    $0x1,%edx
801044a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801044a7:	83 c1 01             	add    $0x1,%ecx
801044aa:	84 db                	test   %bl,%bl
801044ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044af:	74 04                	je     801044b5 <safestrcpy+0x35>
801044b1:	39 f2                	cmp    %esi,%edx
801044b3:	75 eb                	jne    801044a0 <safestrcpy+0x20>
    ;
  *s = 0;
801044b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801044b8:	5b                   	pop    %ebx
801044b9:	5e                   	pop    %esi
801044ba:	5d                   	pop    %ebp
801044bb:	c3                   	ret    
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <strlen>:

int
strlen(const char *s)
{
801044c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801044c1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801044c3:	89 e5                	mov    %esp,%ebp
801044c5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801044c8:	80 3a 00             	cmpb   $0x0,(%edx)
801044cb:	74 0c                	je     801044d9 <strlen+0x19>
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
801044d0:	83 c0 01             	add    $0x1,%eax
801044d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801044d7:	75 f7                	jne    801044d0 <strlen+0x10>
    ;
  return n;
}
801044d9:	5d                   	pop    %ebp
801044da:	c3                   	ret    

801044db <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801044db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801044df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801044e3:	55                   	push   %ebp
  pushl %ebx
801044e4:	53                   	push   %ebx
  pushl %esi
801044e5:	56                   	push   %esi
  pushl %edi
801044e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801044e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801044e9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801044eb:	5f                   	pop    %edi
  popl %esi
801044ec:	5e                   	pop    %esi
  popl %ebx
801044ed:	5b                   	pop    %ebx
  popl %ebp
801044ee:	5d                   	pop    %ebp
  ret
801044ef:	c3                   	ret    

801044f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	8b 45 08             	mov    0x8(%ebp),%eax
  //struct proc *curproc = myproc();

  if(addr >= KERNBASE || addr+4 > KERNBASE)
801044f6:	3d fc ff ff 7f       	cmp    $0x7ffffffc,%eax
801044fb:	77 0b                	ja     80104508 <fetchint+0x18>
    return -1;
  *ip = *(int*)(addr);
801044fd:	8b 10                	mov    (%eax),%edx
801044ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104502:	89 10                	mov    %edx,(%eax)
  return 0;
80104504:	31 c0                	xor    %eax,%eax
}
80104506:	5d                   	pop    %ebp
80104507:	c3                   	ret    
fetchint(uint addr, int *ip)
{
  //struct proc *curproc = myproc();

  if(addr >= KERNBASE || addr+4 > KERNBASE)
    return -1;
80104508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010450d:	5d                   	pop    %ebp
8010450e:	c3                   	ret    
8010450f:	90                   	nop

80104510 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  if(addr >= KERNBASE)
80104516:	85 d2                	test   %edx,%edx
80104518:	78 25                	js     8010453f <fetchstr+0x2f>
    return -1;
  *pp = (char*)addr;
8010451a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  //ep = (char*)curproc->sz;
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++){
8010451d:	81 fa ff ff ff 7f    	cmp    $0x7fffffff,%edx
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  if(addr >= KERNBASE)
    return -1;
  *pp = (char*)addr;
80104523:	89 d0                	mov    %edx,%eax
80104525:	89 11                	mov    %edx,(%ecx)
  //ep = (char*)curproc->sz;
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++){
80104527:	77 16                	ja     8010453f <fetchstr+0x2f>
    if(*s == 0)
80104529:	80 3a 00             	cmpb   $0x0,(%edx)
8010452c:	75 07                	jne    80104535 <fetchstr+0x25>
8010452e:	eb 18                	jmp    80104548 <fetchstr+0x38>
80104530:	80 38 00             	cmpb   $0x0,(%eax)
80104533:	74 13                	je     80104548 <fetchstr+0x38>
  if(addr >= KERNBASE)
    return -1;
  *pp = (char*)addr;
  //ep = (char*)curproc->sz;
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++){
80104535:	83 c0 01             	add    $0x1,%eax
80104538:	3d 00 00 00 80       	cmp    $0x80000000,%eax
8010453d:	75 f1                	jne    80104530 <fetchstr+0x20>
  char *s, *ep;
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  if(addr >= KERNBASE)
    return -1;
8010453f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104544:	5d                   	pop    %ebp
80104545:	c3                   	ret    
80104546:	66 90                	xchg   %ax,%ax
  *pp = (char*)addr;
  //ep = (char*)curproc->sz;
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104548:	29 d0                	sub    %edx,%eax
  }
  return -1;
}
8010454a:	5d                   	pop    %ebp
8010454b:	c3                   	ret    
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104550 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104556:	e8 35 f1 ff ff       	call   80103690 <myproc>
8010455b:	8b 55 08             	mov    0x8(%ebp),%edx
8010455e:	8b 40 20             	mov    0x20(%eax),%eax
80104561:	8b 40 44             	mov    0x44(%eax),%eax
80104564:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
int
fetchint(uint addr, int *ip)
{
  //struct proc *curproc = myproc();

  if(addr >= KERNBASE || addr+4 > KERNBASE)
80104568:	3d fc ff ff 7f       	cmp    $0x7ffffffc,%eax
8010456d:	77 11                	ja     80104580 <argint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010456f:	8b 10                	mov    (%eax),%edx
80104571:	8b 45 0c             	mov    0xc(%ebp),%eax
80104574:	89 10                	mov    %edx,(%eax)
  return 0;
80104576:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104578:	c9                   	leave  
80104579:	c3                   	ret    
8010457a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fetchint(uint addr, int *ip)
{
  //struct proc *curproc = myproc();

  if(addr >= KERNBASE || addr+4 > KERNBASE)
    return -1;
80104580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104585:	c9                   	leave  
80104586:	c3                   	ret    
80104587:	89 f6                	mov    %esi,%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 24             	sub    $0x24,%esp
80104597:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  //struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
8010459a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010459d:	89 44 24 04          	mov    %eax,0x4(%esp)
801045a1:	8b 45 08             	mov    0x8(%ebp),%eax
801045a4:	89 04 24             	mov    %eax,(%esp)
801045a7:	e8 a4 ff ff ff       	call   80104550 <argint>
801045ac:	85 c0                	test   %eax,%eax
801045ae:	78 28                	js     801045d8 <argptr+0x48>
    return -1;
  //if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz) old
  if(size < 0 || (uint)i >= KERNBASE || (uint)i+size > KERNBASE)
801045b0:	85 db                	test   %ebx,%ebx
801045b2:	78 24                	js     801045d8 <argptr+0x48>
801045b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b7:	85 c0                	test   %eax,%eax
801045b9:	78 1d                	js     801045d8 <argptr+0x48>
801045bb:	01 c3                	add    %eax,%ebx
801045bd:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801045c3:	77 13                	ja     801045d8 <argptr+0x48>
    return -1;
  *pp = (char*)i;
801045c5:	8b 55 0c             	mov    0xc(%ebp),%edx
801045c8:	89 02                	mov    %eax,(%edx)
  return 0;
801045ca:	31 c0                	xor    %eax,%eax
}
801045cc:	83 c4 24             	add    $0x24,%esp
801045cf:	5b                   	pop    %ebx
801045d0:	5d                   	pop    %ebp
801045d1:	c3                   	ret    
801045d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int i;
  //struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
801045d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045dd:	eb ed                	jmp    801045cc <argptr+0x3c>
801045df:	90                   	nop

801045e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801045e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801045e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801045ed:	8b 45 08             	mov    0x8(%ebp),%eax
801045f0:	89 04 24             	mov    %eax,(%esp)
801045f3:	e8 58 ff ff ff       	call   80104550 <argint>
801045f8:	85 c0                	test   %eax,%eax
801045fa:	78 2e                	js     8010462a <argstr+0x4a>
    return -1;
  return fetchstr(addr, pp);
801045fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
{
  char *s, *ep;
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  if(addr >= KERNBASE)
801045ff:	85 d2                	test   %edx,%edx
80104601:	78 27                	js     8010462a <argstr+0x4a>
    return -1;
  *pp = (char*)addr;
80104603:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  //ep = (char*)curproc->sz;
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++){
80104606:	81 fa ff ff ff 7f    	cmp    $0x7fffffff,%edx
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  if(addr >= KERNBASE)
    return -1;
  *pp = (char*)addr;
8010460c:	89 d0                	mov    %edx,%eax
8010460e:	89 11                	mov    %edx,(%ecx)
  //ep = (char*)curproc->sz;
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++){
80104610:	77 18                	ja     8010462a <argstr+0x4a>
    if(*s == 0)
80104612:	80 3a 00             	cmpb   $0x0,(%edx)
80104615:	75 0e                	jne    80104625 <argstr+0x45>
80104617:	eb 1f                	jmp    80104638 <argstr+0x58>
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104620:	80 38 00             	cmpb   $0x0,(%eax)
80104623:	74 13                	je     80104638 <argstr+0x58>
  if(addr >= KERNBASE)
    return -1;
  *pp = (char*)addr;
  //ep = (char*)curproc->sz;
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++){
80104625:	83 c0 01             	add    $0x1,%eax
80104628:	79 f6                	jns    80104620 <argstr+0x40>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
8010462a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
8010462f:	c9                   	leave  
80104630:	c3                   	ret    
80104631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  *pp = (char*)addr;
  //ep = (char*)curproc->sz;
  ep = (char*)KERNBASE;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104638:	29 d0                	sub    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010463a:	c9                   	leave  
8010463b:	c3                   	ret    
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104648:	e8 43 f0 ff ff       	call   80103690 <myproc>

  num = curproc->tf->eax;
8010464d:	8b 70 20             	mov    0x20(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104650:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104652:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104655:	8d 50 ff             	lea    -0x1(%eax),%edx
80104658:	83 fa 16             	cmp    $0x16,%edx
8010465b:	77 1b                	ja     80104678 <syscall+0x38>
8010465d:	8b 14 85 a0 75 10 80 	mov    -0x7fef8a60(,%eax,4),%edx
80104664:	85 d2                	test   %edx,%edx
80104666:	74 10                	je     80104678 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104668:	ff d2                	call   *%edx
8010466a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010466d:	83 c4 10             	add    $0x10,%esp
80104670:	5b                   	pop    %ebx
80104671:	5e                   	pop    %esi
80104672:	5d                   	pop    %ebp
80104673:	c3                   	ret    
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104678:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010467c:	8d 43 74             	lea    0x74(%ebx),%eax
8010467f:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104683:	8b 43 10             	mov    0x10(%ebx),%eax
80104686:	c7 04 24 71 75 10 80 	movl   $0x80107571,(%esp)
8010468d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104691:	e8 ba bf ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104696:	8b 43 20             	mov    0x20(%ebx),%eax
80104699:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801046a0:	83 c4 10             	add    $0x10,%esp
801046a3:	5b                   	pop    %ebx
801046a4:	5e                   	pop    %esi
801046a5:	5d                   	pop    %ebp
801046a6:	c3                   	ret    
801046a7:	66 90                	xchg   %ax,%ax
801046a9:	66 90                	xchg   %ax,%ax
801046ab:	66 90                	xchg   %ax,%ax
801046ad:	66 90                	xchg   %ax,%ax
801046af:	90                   	nop

801046b0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	89 c3                	mov    %eax,%ebx
801046b6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801046b9:	e8 d2 ef ff ff       	call   80103690 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801046be:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801046c0:	8b 4c 90 30          	mov    0x30(%eax,%edx,4),%ecx
801046c4:	85 c9                	test   %ecx,%ecx
801046c6:	74 18                	je     801046e0 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801046c8:	83 c2 01             	add    $0x1,%edx
801046cb:	83 fa 10             	cmp    $0x10,%edx
801046ce:	75 f0                	jne    801046c0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801046d0:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801046d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046d8:	5b                   	pop    %ebx
801046d9:	5d                   	pop    %ebp
801046da:	c3                   	ret    
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801046e0:	89 5c 90 30          	mov    %ebx,0x30(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
801046e4:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
801046e7:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
801046e9:	5b                   	pop    %ebx
801046ea:	5d                   	pop    %ebp
801046eb:	c3                   	ret    
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	56                   	push   %esi
801046f5:	53                   	push   %ebx
801046f6:	83 ec 4c             	sub    $0x4c,%esp
801046f9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801046fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801046ff:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104702:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104706:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104709:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010470c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010470f:	e8 fc d7 ff ff       	call   80101f10 <nameiparent>
80104714:	85 c0                	test   %eax,%eax
80104716:	89 c7                	mov    %eax,%edi
80104718:	0f 84 da 00 00 00    	je     801047f8 <create+0x108>
    return 0;
  ilock(dp);
8010471e:	89 04 24             	mov    %eax,(%esp)
80104721:	e8 7a cf ff ff       	call   801016a0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104726:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104729:	89 44 24 08          	mov    %eax,0x8(%esp)
8010472d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104731:	89 3c 24             	mov    %edi,(%esp)
80104734:	e8 77 d4 ff ff       	call   80101bb0 <dirlookup>
80104739:	85 c0                	test   %eax,%eax
8010473b:	89 c6                	mov    %eax,%esi
8010473d:	74 41                	je     80104780 <create+0x90>
    iunlockput(dp);
8010473f:	89 3c 24             	mov    %edi,(%esp)
80104742:	e8 b9 d1 ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104747:	89 34 24             	mov    %esi,(%esp)
8010474a:	e8 51 cf ff ff       	call   801016a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010474f:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104754:	75 12                	jne    80104768 <create+0x78>
80104756:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010475b:	89 f0                	mov    %esi,%eax
8010475d:	75 09                	jne    80104768 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010475f:	83 c4 4c             	add    $0x4c,%esp
80104762:	5b                   	pop    %ebx
80104763:	5e                   	pop    %esi
80104764:	5f                   	pop    %edi
80104765:	5d                   	pop    %ebp
80104766:	c3                   	ret    
80104767:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104768:	89 34 24             	mov    %esi,(%esp)
8010476b:	e8 90 d1 ff ff       	call   80101900 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104770:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104773:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104775:	5b                   	pop    %ebx
80104776:	5e                   	pop    %esi
80104777:	5f                   	pop    %edi
80104778:	5d                   	pop    %ebp
80104779:	c3                   	ret    
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104780:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104784:	89 44 24 04          	mov    %eax,0x4(%esp)
80104788:	8b 07                	mov    (%edi),%eax
8010478a:	89 04 24             	mov    %eax,(%esp)
8010478d:	e8 7e cd ff ff       	call   80101510 <ialloc>
80104792:	85 c0                	test   %eax,%eax
80104794:	89 c6                	mov    %eax,%esi
80104796:	0f 84 bf 00 00 00    	je     8010485b <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
8010479c:	89 04 24             	mov    %eax,(%esp)
8010479f:	e8 fc ce ff ff       	call   801016a0 <ilock>
  ip->major = major;
801047a4:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801047a8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801047ac:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801047b0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801047b4:	b8 01 00 00 00       	mov    $0x1,%eax
801047b9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801047bd:	89 34 24             	mov    %esi,(%esp)
801047c0:	e8 1b ce ff ff       	call   801015e0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801047c5:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801047ca:	74 34                	je     80104800 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801047cc:	8b 46 04             	mov    0x4(%esi),%eax
801047cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047d3:	89 3c 24             	mov    %edi,(%esp)
801047d6:	89 44 24 08          	mov    %eax,0x8(%esp)
801047da:	e8 31 d6 ff ff       	call   80101e10 <dirlink>
801047df:	85 c0                	test   %eax,%eax
801047e1:	78 6c                	js     8010484f <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
801047e3:	89 3c 24             	mov    %edi,(%esp)
801047e6:	e8 15 d1 ff ff       	call   80101900 <iunlockput>

  return ip;
}
801047eb:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801047ee:	89 f0                	mov    %esi,%eax
}
801047f0:	5b                   	pop    %ebx
801047f1:	5e                   	pop    %esi
801047f2:	5f                   	pop    %edi
801047f3:	5d                   	pop    %ebp
801047f4:	c3                   	ret    
801047f5:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801047f8:	31 c0                	xor    %eax,%eax
801047fa:	e9 60 ff ff ff       	jmp    8010475f <create+0x6f>
801047ff:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104800:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104805:	89 3c 24             	mov    %edi,(%esp)
80104808:	e8 d3 cd ff ff       	call   801015e0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010480d:	8b 46 04             	mov    0x4(%esi),%eax
80104810:	c7 44 24 04 1c 76 10 	movl   $0x8010761c,0x4(%esp)
80104817:	80 
80104818:	89 34 24             	mov    %esi,(%esp)
8010481b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010481f:	e8 ec d5 ff ff       	call   80101e10 <dirlink>
80104824:	85 c0                	test   %eax,%eax
80104826:	78 1b                	js     80104843 <create+0x153>
80104828:	8b 47 04             	mov    0x4(%edi),%eax
8010482b:	c7 44 24 04 1b 76 10 	movl   $0x8010761b,0x4(%esp)
80104832:	80 
80104833:	89 34 24             	mov    %esi,(%esp)
80104836:	89 44 24 08          	mov    %eax,0x8(%esp)
8010483a:	e8 d1 d5 ff ff       	call   80101e10 <dirlink>
8010483f:	85 c0                	test   %eax,%eax
80104841:	79 89                	jns    801047cc <create+0xdc>
      panic("create dots");
80104843:	c7 04 24 0f 76 10 80 	movl   $0x8010760f,(%esp)
8010484a:	e8 11 bb ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010484f:	c7 04 24 1e 76 10 80 	movl   $0x8010761e,(%esp)
80104856:	e8 05 bb ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
8010485b:	c7 04 24 00 76 10 80 	movl   $0x80107600,(%esp)
80104862:	e8 f9 ba ff ff       	call   80100360 <panic>
80104867:	89 f6                	mov    %esi,%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	89 c6                	mov    %eax,%esi
80104876:	53                   	push   %ebx
80104877:	89 d3                	mov    %edx,%ebx
80104879:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010487c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010487f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104883:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010488a:	e8 c1 fc ff ff       	call   80104550 <argint>
8010488f:	85 c0                	test   %eax,%eax
80104891:	78 2d                	js     801048c0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104893:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104897:	77 27                	ja     801048c0 <argfd.constprop.0+0x50>
80104899:	e8 f2 ed ff ff       	call   80103690 <myproc>
8010489e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048a1:	8b 44 90 30          	mov    0x30(%eax,%edx,4),%eax
801048a5:	85 c0                	test   %eax,%eax
801048a7:	74 17                	je     801048c0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801048a9:	85 f6                	test   %esi,%esi
801048ab:	74 02                	je     801048af <argfd.constprop.0+0x3f>
    *pfd = fd;
801048ad:	89 16                	mov    %edx,(%esi)
  if(pf)
801048af:	85 db                	test   %ebx,%ebx
801048b1:	74 1d                	je     801048d0 <argfd.constprop.0+0x60>
    *pf = f;
801048b3:	89 03                	mov    %eax,(%ebx)
  return 0;
801048b5:	31 c0                	xor    %eax,%eax
}
801048b7:	83 c4 20             	add    $0x20,%esp
801048ba:	5b                   	pop    %ebx
801048bb:	5e                   	pop    %esi
801048bc:	5d                   	pop    %ebp
801048bd:	c3                   	ret    
801048be:	66 90                	xchg   %ax,%ax
801048c0:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801048c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801048c8:	5b                   	pop    %ebx
801048c9:	5e                   	pop    %esi
801048ca:	5d                   	pop    %ebp
801048cb:	c3                   	ret    
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801048d0:	31 c0                	xor    %eax,%eax
801048d2:	eb e3                	jmp    801048b7 <argfd.constprop.0+0x47>
801048d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048e0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801048e0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801048e1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801048e3:	89 e5                	mov    %esp,%ebp
801048e5:	53                   	push   %ebx
801048e6:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801048e9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801048ec:	e8 7f ff ff ff       	call   80104870 <argfd.constprop.0>
801048f1:	85 c0                	test   %eax,%eax
801048f3:	78 23                	js     80104918 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
801048f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f8:	e8 b3 fd ff ff       	call   801046b0 <fdalloc>
801048fd:	85 c0                	test   %eax,%eax
801048ff:	89 c3                	mov    %eax,%ebx
80104901:	78 15                	js     80104918 <sys_dup+0x38>
    return -1;
  filedup(f);
80104903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104906:	89 04 24             	mov    %eax,(%esp)
80104909:	e8 b2 c4 ff ff       	call   80100dc0 <filedup>
  return fd;
8010490e:	89 d8                	mov    %ebx,%eax
}
80104910:	83 c4 24             	add    $0x24,%esp
80104913:	5b                   	pop    %ebx
80104914:	5d                   	pop    %ebp
80104915:	c3                   	ret    
80104916:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104918:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010491d:	eb f1                	jmp    80104910 <sys_dup+0x30>
8010491f:	90                   	nop

80104920 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104920:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104921:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104923:	89 e5                	mov    %esp,%ebp
80104925:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104928:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010492b:	e8 40 ff ff ff       	call   80104870 <argfd.constprop.0>
80104930:	85 c0                	test   %eax,%eax
80104932:	78 54                	js     80104988 <sys_read+0x68>
80104934:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104937:	89 44 24 04          	mov    %eax,0x4(%esp)
8010493b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104942:	e8 09 fc ff ff       	call   80104550 <argint>
80104947:	85 c0                	test   %eax,%eax
80104949:	78 3d                	js     80104988 <sys_read+0x68>
8010494b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010494e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104955:	89 44 24 08          	mov    %eax,0x8(%esp)
80104959:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010495c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104960:	e8 2b fc ff ff       	call   80104590 <argptr>
80104965:	85 c0                	test   %eax,%eax
80104967:	78 1f                	js     80104988 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
80104969:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010496c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104973:	89 44 24 04          	mov    %eax,0x4(%esp)
80104977:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010497a:	89 04 24             	mov    %eax,(%esp)
8010497d:	e8 9e c5 ff ff       	call   80100f20 <fileread>
}
80104982:	c9                   	leave  
80104983:	c3                   	ret    
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
8010498d:	c9                   	leave  
8010498e:	c3                   	ret    
8010498f:	90                   	nop

80104990 <sys_write>:

int
sys_write(void)
{
80104990:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104991:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104993:	89 e5                	mov    %esp,%ebp
80104995:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104998:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010499b:	e8 d0 fe ff ff       	call   80104870 <argfd.constprop.0>
801049a0:	85 c0                	test   %eax,%eax
801049a2:	78 54                	js     801049f8 <sys_write+0x68>
801049a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049ab:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801049b2:	e8 99 fb ff ff       	call   80104550 <argint>
801049b7:	85 c0                	test   %eax,%eax
801049b9:	78 3d                	js     801049f8 <sys_write+0x68>
801049bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049c5:	89 44 24 08          	mov    %eax,0x8(%esp)
801049c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801049d0:	e8 bb fb ff ff       	call   80104590 <argptr>
801049d5:	85 c0                	test   %eax,%eax
801049d7:	78 1f                	js     801049f8 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
801049d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049dc:	89 44 24 08          	mov    %eax,0x8(%esp)
801049e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ea:	89 04 24             	mov    %eax,(%esp)
801049ed:	e8 ce c5 ff ff       	call   80100fc0 <filewrite>
}
801049f2:	c9                   	leave  
801049f3:	c3                   	ret    
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801049f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
801049fd:	c9                   	leave  
801049fe:	c3                   	ret    
801049ff:	90                   	nop

80104a00 <sys_close>:

int
sys_close(void)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104a06:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a09:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a0c:	e8 5f fe ff ff       	call   80104870 <argfd.constprop.0>
80104a11:	85 c0                	test   %eax,%eax
80104a13:	78 23                	js     80104a38 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
80104a15:	e8 76 ec ff ff       	call   80103690 <myproc>
80104a1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a1d:	c7 44 90 30 00 00 00 	movl   $0x0,0x30(%eax,%edx,4)
80104a24:	00 
  fileclose(f);
80104a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a28:	89 04 24             	mov    %eax,(%esp)
80104a2b:	e8 e0 c3 ff ff       	call   80100e10 <fileclose>
  return 0;
80104a30:	31 c0                	xor    %eax,%eax
}
80104a32:	c9                   	leave  
80104a33:	c3                   	ret    
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104a3d:	c9                   	leave  
80104a3e:	c3                   	ret    
80104a3f:	90                   	nop

80104a40 <sys_fstat>:

int
sys_fstat(void)
{
80104a40:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a41:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104a48:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104a4b:	e8 20 fe ff ff       	call   80104870 <argfd.constprop.0>
80104a50:	85 c0                	test   %eax,%eax
80104a52:	78 34                	js     80104a88 <sys_fstat+0x48>
80104a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a57:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104a5e:	00 
80104a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a6a:	e8 21 fb ff ff       	call   80104590 <argptr>
80104a6f:	85 c0                	test   %eax,%eax
80104a71:	78 15                	js     80104a88 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a76:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a7d:	89 04 24             	mov    %eax,(%esp)
80104a80:	e8 4b c4 ff ff       	call   80100ed0 <filestat>
}
80104a85:	c9                   	leave  
80104a86:	c3                   	ret    
80104a87:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104a8d:	c9                   	leave  
80104a8e:	c3                   	ret    
80104a8f:	90                   	nop

80104a90 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	53                   	push   %ebx
80104a96:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104a99:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aa0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104aa7:	e8 34 fb ff ff       	call   801045e0 <argstr>
80104aac:	85 c0                	test   %eax,%eax
80104aae:	0f 88 e6 00 00 00    	js     80104b9a <sys_link+0x10a>
80104ab4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104abb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ac2:	e8 19 fb ff ff       	call   801045e0 <argstr>
80104ac7:	85 c0                	test   %eax,%eax
80104ac9:	0f 88 cb 00 00 00    	js     80104b9a <sys_link+0x10a>
    return -1;

  begin_op();
80104acf:	e8 2c e0 ff ff       	call   80102b00 <begin_op>
  if((ip = namei(old)) == 0){
80104ad4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104ad7:	89 04 24             	mov    %eax,(%esp)
80104ada:	e8 11 d4 ff ff       	call   80101ef0 <namei>
80104adf:	85 c0                	test   %eax,%eax
80104ae1:	89 c3                	mov    %eax,%ebx
80104ae3:	0f 84 ac 00 00 00    	je     80104b95 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104ae9:	89 04 24             	mov    %eax,(%esp)
80104aec:	e8 af cb ff ff       	call   801016a0 <ilock>
  if(ip->type == T_DIR){
80104af1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104af6:	0f 84 91 00 00 00    	je     80104b8d <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104afc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104b01:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104b04:	89 1c 24             	mov    %ebx,(%esp)
80104b07:	e8 d4 ca ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104b0c:	89 1c 24             	mov    %ebx,(%esp)
80104b0f:	e8 6c cc ff ff       	call   80101780 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104b14:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b17:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b1b:	89 04 24             	mov    %eax,(%esp)
80104b1e:	e8 ed d3 ff ff       	call   80101f10 <nameiparent>
80104b23:	85 c0                	test   %eax,%eax
80104b25:	89 c6                	mov    %eax,%esi
80104b27:	74 4f                	je     80104b78 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104b29:	89 04 24             	mov    %eax,(%esp)
80104b2c:	e8 6f cb ff ff       	call   801016a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104b31:	8b 03                	mov    (%ebx),%eax
80104b33:	39 06                	cmp    %eax,(%esi)
80104b35:	75 39                	jne    80104b70 <sys_link+0xe0>
80104b37:	8b 43 04             	mov    0x4(%ebx),%eax
80104b3a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b3e:	89 34 24             	mov    %esi,(%esp)
80104b41:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b45:	e8 c6 d2 ff ff       	call   80101e10 <dirlink>
80104b4a:	85 c0                	test   %eax,%eax
80104b4c:	78 22                	js     80104b70 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104b4e:	89 34 24             	mov    %esi,(%esp)
80104b51:	e8 aa cd ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104b56:	89 1c 24             	mov    %ebx,(%esp)
80104b59:	e8 62 cc ff ff       	call   801017c0 <iput>

  end_op();
80104b5e:	e8 0d e0 ff ff       	call   80102b70 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104b63:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104b66:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104b68:	5b                   	pop    %ebx
80104b69:	5e                   	pop    %esi
80104b6a:	5f                   	pop    %edi
80104b6b:	5d                   	pop    %ebp
80104b6c:	c3                   	ret    
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104b70:	89 34 24             	mov    %esi,(%esp)
80104b73:	e8 88 cd ff ff       	call   80101900 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104b78:	89 1c 24             	mov    %ebx,(%esp)
80104b7b:	e8 20 cb ff ff       	call   801016a0 <ilock>
  ip->nlink--;
80104b80:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104b85:	89 1c 24             	mov    %ebx,(%esp)
80104b88:	e8 53 ca ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104b8d:	89 1c 24             	mov    %ebx,(%esp)
80104b90:	e8 6b cd ff ff       	call   80101900 <iunlockput>
  end_op();
80104b95:	e8 d6 df ff ff       	call   80102b70 <end_op>
  return -1;
}
80104b9a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ba2:	5b                   	pop    %ebx
80104ba3:	5e                   	pop    %esi
80104ba4:	5f                   	pop    %edi
80104ba5:	5d                   	pop    %ebp
80104ba6:	c3                   	ret    
80104ba7:	89 f6                	mov    %esi,%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104bb9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bc7:	e8 14 fa ff ff       	call   801045e0 <argstr>
80104bcc:	85 c0                	test   %eax,%eax
80104bce:	0f 88 76 01 00 00    	js     80104d4a <sys_unlink+0x19a>
    return -1;

  begin_op();
80104bd4:	e8 27 df ff ff       	call   80102b00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104bd9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104bdc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104bdf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104be3:	89 04 24             	mov    %eax,(%esp)
80104be6:	e8 25 d3 ff ff       	call   80101f10 <nameiparent>
80104beb:	85 c0                	test   %eax,%eax
80104bed:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104bf0:	0f 84 4f 01 00 00    	je     80104d45 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104bf6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104bf9:	89 34 24             	mov    %esi,(%esp)
80104bfc:	e8 9f ca ff ff       	call   801016a0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104c01:	c7 44 24 04 1c 76 10 	movl   $0x8010761c,0x4(%esp)
80104c08:	80 
80104c09:	89 1c 24             	mov    %ebx,(%esp)
80104c0c:	e8 6f cf ff ff       	call   80101b80 <namecmp>
80104c11:	85 c0                	test   %eax,%eax
80104c13:	0f 84 21 01 00 00    	je     80104d3a <sys_unlink+0x18a>
80104c19:	c7 44 24 04 1b 76 10 	movl   $0x8010761b,0x4(%esp)
80104c20:	80 
80104c21:	89 1c 24             	mov    %ebx,(%esp)
80104c24:	e8 57 cf ff ff       	call   80101b80 <namecmp>
80104c29:	85 c0                	test   %eax,%eax
80104c2b:	0f 84 09 01 00 00    	je     80104d3a <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104c31:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104c34:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c38:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c3c:	89 34 24             	mov    %esi,(%esp)
80104c3f:	e8 6c cf ff ff       	call   80101bb0 <dirlookup>
80104c44:	85 c0                	test   %eax,%eax
80104c46:	89 c3                	mov    %eax,%ebx
80104c48:	0f 84 ec 00 00 00    	je     80104d3a <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104c4e:	89 04 24             	mov    %eax,(%esp)
80104c51:	e8 4a ca ff ff       	call   801016a0 <ilock>

  if(ip->nlink < 1)
80104c56:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104c5b:	0f 8e 24 01 00 00    	jle    80104d85 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c66:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104c69:	74 7d                	je     80104ce8 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104c6b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104c72:	00 
80104c73:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c7a:	00 
80104c7b:	89 34 24             	mov    %esi,(%esp)
80104c7e:	e8 1d f6 ff ff       	call   801042a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104c83:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c86:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104c8d:	00 
80104c8e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104c92:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c96:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104c99:	89 04 24             	mov    %eax,(%esp)
80104c9c:	e8 af cd ff ff       	call   80101a50 <writei>
80104ca1:	83 f8 10             	cmp    $0x10,%eax
80104ca4:	0f 85 cf 00 00 00    	jne    80104d79 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104caa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104caf:	0f 84 a3 00 00 00    	je     80104d58 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104cb5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104cb8:	89 04 24             	mov    %eax,(%esp)
80104cbb:	e8 40 cc ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
80104cc0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cc5:	89 1c 24             	mov    %ebx,(%esp)
80104cc8:	e8 13 c9 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104ccd:	89 1c 24             	mov    %ebx,(%esp)
80104cd0:	e8 2b cc ff ff       	call   80101900 <iunlockput>

  end_op();
80104cd5:	e8 96 de ff ff       	call   80102b70 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104cda:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104cdd:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104cdf:	5b                   	pop    %ebx
80104ce0:	5e                   	pop    %esi
80104ce1:	5f                   	pop    %edi
80104ce2:	5d                   	pop    %ebp
80104ce3:	c3                   	ret    
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104ce8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104cec:	0f 86 79 ff ff ff    	jbe    80104c6b <sys_unlink+0xbb>
80104cf2:	bf 20 00 00 00       	mov    $0x20,%edi
80104cf7:	eb 15                	jmp    80104d0e <sys_unlink+0x15e>
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d00:	8d 57 10             	lea    0x10(%edi),%edx
80104d03:	3b 53 58             	cmp    0x58(%ebx),%edx
80104d06:	0f 83 5f ff ff ff    	jae    80104c6b <sys_unlink+0xbb>
80104d0c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d0e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d15:	00 
80104d16:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104d1a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d1e:	89 1c 24             	mov    %ebx,(%esp)
80104d21:	e8 2a cc ff ff       	call   80101950 <readi>
80104d26:	83 f8 10             	cmp    $0x10,%eax
80104d29:	75 42                	jne    80104d6d <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104d2b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104d30:	74 ce                	je     80104d00 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104d32:	89 1c 24             	mov    %ebx,(%esp)
80104d35:	e8 c6 cb ff ff       	call   80101900 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104d3a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d3d:	89 04 24             	mov    %eax,(%esp)
80104d40:	e8 bb cb ff ff       	call   80101900 <iunlockput>
  end_op();
80104d45:	e8 26 de ff ff       	call   80102b70 <end_op>
  return -1;
}
80104d4a:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104d4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d52:	5b                   	pop    %ebx
80104d53:	5e                   	pop    %esi
80104d54:	5f                   	pop    %edi
80104d55:	5d                   	pop    %ebp
80104d56:	c3                   	ret    
80104d57:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104d58:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d5b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104d60:	89 04 24             	mov    %eax,(%esp)
80104d63:	e8 78 c8 ff ff       	call   801015e0 <iupdate>
80104d68:	e9 48 ff ff ff       	jmp    80104cb5 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104d6d:	c7 04 24 40 76 10 80 	movl   $0x80107640,(%esp)
80104d74:	e8 e7 b5 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104d79:	c7 04 24 52 76 10 80 	movl   $0x80107652,(%esp)
80104d80:	e8 db b5 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104d85:	c7 04 24 2e 76 10 80 	movl   $0x8010762e,(%esp)
80104d8c:	e8 cf b5 ff ff       	call   80100360 <panic>
80104d91:	eb 0d                	jmp    80104da0 <sys_open>
80104d93:	90                   	nop
80104d94:	90                   	nop
80104d95:	90                   	nop
80104d96:	90                   	nop
80104d97:	90                   	nop
80104d98:	90                   	nop
80104d99:	90                   	nop
80104d9a:	90                   	nop
80104d9b:	90                   	nop
80104d9c:	90                   	nop
80104d9d:	90                   	nop
80104d9e:	90                   	nop
80104d9f:	90                   	nop

80104da0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
80104da5:	53                   	push   %ebx
80104da6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104da9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104dac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104db0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104db7:	e8 24 f8 ff ff       	call   801045e0 <argstr>
80104dbc:	85 c0                	test   %eax,%eax
80104dbe:	0f 88 d1 00 00 00    	js     80104e95 <sys_open+0xf5>
80104dc4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dcb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104dd2:	e8 79 f7 ff ff       	call   80104550 <argint>
80104dd7:	85 c0                	test   %eax,%eax
80104dd9:	0f 88 b6 00 00 00    	js     80104e95 <sys_open+0xf5>
    return -1;

  begin_op();
80104ddf:	e8 1c dd ff ff       	call   80102b00 <begin_op>

  if(omode & O_CREATE){
80104de4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104de8:	0f 85 82 00 00 00    	jne    80104e70 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104dee:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104df1:	89 04 24             	mov    %eax,(%esp)
80104df4:	e8 f7 d0 ff ff       	call   80101ef0 <namei>
80104df9:	85 c0                	test   %eax,%eax
80104dfb:	89 c6                	mov    %eax,%esi
80104dfd:	0f 84 8d 00 00 00    	je     80104e90 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104e03:	89 04 24             	mov    %eax,(%esp)
80104e06:	e8 95 c8 ff ff       	call   801016a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e0b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e10:	0f 84 92 00 00 00    	je     80104ea8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104e16:	e8 35 bf ff ff       	call   80100d50 <filealloc>
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	89 c3                	mov    %eax,%ebx
80104e1f:	0f 84 93 00 00 00    	je     80104eb8 <sys_open+0x118>
80104e25:	e8 86 f8 ff ff       	call   801046b0 <fdalloc>
80104e2a:	85 c0                	test   %eax,%eax
80104e2c:	89 c7                	mov    %eax,%edi
80104e2e:	0f 88 94 00 00 00    	js     80104ec8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104e34:	89 34 24             	mov    %esi,(%esp)
80104e37:	e8 44 c9 ff ff       	call   80101780 <iunlock>
  end_op();
80104e3c:	e8 2f dd ff ff       	call   80102b70 <end_op>

  f->type = FD_INODE;
80104e41:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104e4a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104e4d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104e54:	89 c2                	mov    %eax,%edx
80104e56:	83 e2 01             	and    $0x1,%edx
80104e59:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e5c:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104e5e:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104e61:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104e63:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104e67:	83 c4 2c             	add    $0x2c,%esp
80104e6a:	5b                   	pop    %ebx
80104e6b:	5e                   	pop    %esi
80104e6c:	5f                   	pop    %edi
80104e6d:	5d                   	pop    %ebp
80104e6e:	c3                   	ret    
80104e6f:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e73:	31 c9                	xor    %ecx,%ecx
80104e75:	ba 02 00 00 00       	mov    $0x2,%edx
80104e7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e81:	e8 6a f8 ff ff       	call   801046f0 <create>
    if(ip == 0){
80104e86:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104e88:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104e8a:	75 8a                	jne    80104e16 <sys_open+0x76>
80104e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
80104e90:	e8 db dc ff ff       	call   80102b70 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104e95:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104e98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104e9d:	5b                   	pop    %ebx
80104e9e:	5e                   	pop    %esi
80104e9f:	5f                   	pop    %edi
80104ea0:	5d                   	pop    %ebp
80104ea1:	c3                   	ret    
80104ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104eab:	85 c0                	test   %eax,%eax
80104ead:	0f 84 63 ff ff ff    	je     80104e16 <sys_open+0x76>
80104eb3:	90                   	nop
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
80104eb8:	89 34 24             	mov    %esi,(%esp)
80104ebb:	e8 40 ca ff ff       	call   80101900 <iunlockput>
80104ec0:	eb ce                	jmp    80104e90 <sys_open+0xf0>
80104ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104ec8:	89 1c 24             	mov    %ebx,(%esp)
80104ecb:	e8 40 bf ff ff       	call   80100e10 <fileclose>
80104ed0:	eb e6                	jmp    80104eb8 <sys_open+0x118>
80104ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104ee6:	e8 15 dc ff ff       	call   80102b00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eee:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ef2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ef9:	e8 e2 f6 ff ff       	call   801045e0 <argstr>
80104efe:	85 c0                	test   %eax,%eax
80104f00:	78 2e                	js     80104f30 <sys_mkdir+0x50>
80104f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f05:	31 c9                	xor    %ecx,%ecx
80104f07:	ba 01 00 00 00       	mov    $0x1,%edx
80104f0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f13:	e8 d8 f7 ff ff       	call   801046f0 <create>
80104f18:	85 c0                	test   %eax,%eax
80104f1a:	74 14                	je     80104f30 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f1c:	89 04 24             	mov    %eax,(%esp)
80104f1f:	e8 dc c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104f24:	e8 47 dc ff ff       	call   80102b70 <end_op>
  return 0;
80104f29:	31 c0                	xor    %eax,%eax
}
80104f2b:	c9                   	leave  
80104f2c:	c3                   	ret    
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80104f30:	e8 3b dc ff ff       	call   80102b70 <end_op>
    return -1;
80104f35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80104f3a:	c9                   	leave  
80104f3b:	c3                   	ret    
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f40 <sys_mknod>:

int
sys_mknod(void)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104f46:	e8 b5 db ff ff       	call   80102b00 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104f4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104f4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f59:	e8 82 f6 ff ff       	call   801045e0 <argstr>
80104f5e:	85 c0                	test   %eax,%eax
80104f60:	78 5e                	js     80104fc0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104f62:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f65:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f70:	e8 db f5 ff ff       	call   80104550 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80104f75:	85 c0                	test   %eax,%eax
80104f77:	78 47                	js     80104fc0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80104f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f80:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f87:	e8 c4 f5 ff ff       	call   80104550 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80104f8c:	85 c0                	test   %eax,%eax
80104f8e:	78 30                	js     80104fc0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f90:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80104f94:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80104f99:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104f9d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80104fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fa3:	e8 48 f7 ff ff       	call   801046f0 <create>
80104fa8:	85 c0                	test   %eax,%eax
80104faa:	74 14                	je     80104fc0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80104fac:	89 04 24             	mov    %eax,(%esp)
80104faf:	e8 4c c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104fb4:	e8 b7 db ff ff       	call   80102b70 <end_op>
  return 0;
80104fb9:	31 c0                	xor    %eax,%eax
}
80104fbb:	c9                   	leave  
80104fbc:	c3                   	ret    
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80104fc0:	e8 ab db ff ff       	call   80102b70 <end_op>
    return -1;
80104fc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80104fca:	c9                   	leave  
80104fcb:	c3                   	ret    
80104fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fd0 <sys_chdir>:

int
sys_chdir(void)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
80104fd5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104fd8:	e8 b3 e6 ff ff       	call   80103690 <myproc>
80104fdd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104fdf:	e8 1c db ff ff       	call   80102b00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104fe4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fe7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104feb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ff2:	e8 e9 f5 ff ff       	call   801045e0 <argstr>
80104ff7:	85 c0                	test   %eax,%eax
80104ff9:	78 4a                	js     80105045 <sys_chdir+0x75>
80104ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffe:	89 04 24             	mov    %eax,(%esp)
80105001:	e8 ea ce ff ff       	call   80101ef0 <namei>
80105006:	85 c0                	test   %eax,%eax
80105008:	89 c3                	mov    %eax,%ebx
8010500a:	74 39                	je     80105045 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010500c:	89 04 24             	mov    %eax,(%esp)
8010500f:	e8 8c c6 ff ff       	call   801016a0 <ilock>
  if(ip->type != T_DIR){
80105014:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105019:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
8010501c:	75 22                	jne    80105040 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010501e:	e8 5d c7 ff ff       	call   80101780 <iunlock>
  iput(curproc->cwd);
80105023:	8b 46 70             	mov    0x70(%esi),%eax
80105026:	89 04 24             	mov    %eax,(%esp)
80105029:	e8 92 c7 ff ff       	call   801017c0 <iput>
  end_op();
8010502e:	e8 3d db ff ff       	call   80102b70 <end_op>
  curproc->cwd = ip;
  return 0;
80105033:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
80105035:	89 5e 70             	mov    %ebx,0x70(%esi)
  return 0;
}
80105038:	83 c4 20             	add    $0x20,%esp
8010503b:	5b                   	pop    %ebx
8010503c:	5e                   	pop    %esi
8010503d:	5d                   	pop    %ebp
8010503e:	c3                   	ret    
8010503f:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105040:	e8 bb c8 ff ff       	call   80101900 <iunlockput>
    end_op();
80105045:	e8 26 db ff ff       	call   80102b70 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
8010504a:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
8010504d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
80105052:	5b                   	pop    %ebx
80105053:	5e                   	pop    %esi
80105054:	5d                   	pop    %ebp
80105055:	c3                   	ret    
80105056:	8d 76 00             	lea    0x0(%esi),%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <sys_exec>:

int
sys_exec(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	53                   	push   %ebx
80105066:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010506c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105072:	89 44 24 04          	mov    %eax,0x4(%esp)
80105076:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010507d:	e8 5e f5 ff ff       	call   801045e0 <argstr>
80105082:	85 c0                	test   %eax,%eax
80105084:	0f 88 84 00 00 00    	js     8010510e <sys_exec+0xae>
8010508a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105090:	89 44 24 04          	mov    %eax,0x4(%esp)
80105094:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010509b:	e8 b0 f4 ff ff       	call   80104550 <argint>
801050a0:	85 c0                	test   %eax,%eax
801050a2:	78 6a                	js     8010510e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801050a4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801050aa:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801050ac:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801050b3:	00 
801050b4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801050ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801050c1:	00 
801050c2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801050c8:	89 04 24             	mov    %eax,(%esp)
801050cb:	e8 d0 f1 ff ff       	call   801042a0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801050d0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801050d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801050da:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801050dd:	89 04 24             	mov    %eax,(%esp)
801050e0:	e8 0b f4 ff ff       	call   801044f0 <fetchint>
801050e5:	85 c0                	test   %eax,%eax
801050e7:	78 25                	js     8010510e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801050e9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801050ef:	85 c0                	test   %eax,%eax
801050f1:	74 2d                	je     80105120 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801050f3:	89 74 24 04          	mov    %esi,0x4(%esp)
801050f7:	89 04 24             	mov    %eax,(%esp)
801050fa:	e8 11 f4 ff ff       	call   80104510 <fetchstr>
801050ff:	85 c0                	test   %eax,%eax
80105101:	78 0b                	js     8010510e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105103:	83 c3 01             	add    $0x1,%ebx
80105106:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105109:	83 fb 20             	cmp    $0x20,%ebx
8010510c:	75 c2                	jne    801050d0 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010510e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105114:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105119:	5b                   	pop    %ebx
8010511a:	5e                   	pop    %esi
8010511b:	5f                   	pop    %edi
8010511c:	5d                   	pop    %ebp
8010511d:	c3                   	ret    
8010511e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105120:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105126:	89 44 24 04          	mov    %eax,0x4(%esp)
8010512a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105130:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105137:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010513b:	89 04 24             	mov    %eax,(%esp)
8010513e:	e8 5d b8 ff ff       	call   801009a0 <exec>
}
80105143:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105149:	5b                   	pop    %ebx
8010514a:	5e                   	pop    %esi
8010514b:	5f                   	pop    %edi
8010514c:	5d                   	pop    %ebp
8010514d:	c3                   	ret    
8010514e:	66 90                	xchg   %ax,%ax

80105150 <sys_pipe>:

int
sys_pipe(void)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	53                   	push   %ebx
80105154:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105157:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010515a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105161:	00 
80105162:	89 44 24 04          	mov    %eax,0x4(%esp)
80105166:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010516d:	e8 1e f4 ff ff       	call   80104590 <argptr>
80105172:	85 c0                	test   %eax,%eax
80105174:	78 6d                	js     801051e3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105176:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105179:	89 44 24 04          	mov    %eax,0x4(%esp)
8010517d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105180:	89 04 24             	mov    %eax,(%esp)
80105183:	e8 d8 df ff ff       	call   80103160 <pipealloc>
80105188:	85 c0                	test   %eax,%eax
8010518a:	78 57                	js     801051e3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010518c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010518f:	e8 1c f5 ff ff       	call   801046b0 <fdalloc>
80105194:	85 c0                	test   %eax,%eax
80105196:	89 c3                	mov    %eax,%ebx
80105198:	78 33                	js     801051cd <sys_pipe+0x7d>
8010519a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519d:	e8 0e f5 ff ff       	call   801046b0 <fdalloc>
801051a2:	85 c0                	test   %eax,%eax
801051a4:	78 1a                	js     801051c0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801051a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051a9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801051ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
801051ae:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801051b1:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801051b4:	31 c0                	xor    %eax,%eax
}
801051b6:	5b                   	pop    %ebx
801051b7:	5d                   	pop    %ebp
801051b8:	c3                   	ret    
801051b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801051c0:	e8 cb e4 ff ff       	call   80103690 <myproc>
801051c5:	c7 44 98 30 00 00 00 	movl   $0x0,0x30(%eax,%ebx,4)
801051cc:	00 
    fileclose(rf);
801051cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051d0:	89 04 24             	mov    %eax,(%esp)
801051d3:	e8 38 bc ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
801051d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051db:	89 04 24             	mov    %eax,(%esp)
801051de:	e8 2d bc ff ff       	call   80100e10 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801051e3:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801051e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801051eb:	5b                   	pop    %ebx
801051ec:	5d                   	pop    %ebp
801051ed:	c3                   	ret    
801051ee:	66 90                	xchg   %ax,%ax

801051f0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801051f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105204:	e8 47 f3 ff ff       	call   80104550 <argint>
80105209:	85 c0                	test   %eax,%eax
8010520b:	78 33                	js     80105240 <sys_shm_open+0x50>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
8010520d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105210:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105217:	00 
80105218:	89 44 24 04          	mov    %eax,0x4(%esp)
8010521c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105223:	e8 68 f3 ff ff       	call   80104590 <argptr>
80105228:	85 c0                	test   %eax,%eax
8010522a:	78 14                	js     80105240 <sys_shm_open+0x50>
    return -1;
  return shm_open(id, pointer);
8010522c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010522f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105233:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105236:	89 04 24             	mov    %eax,(%esp)
80105239:	e8 62 1c 00 00       	call   80106ea0 <shm_open>
}
8010523e:	c9                   	leave  
8010523f:	c3                   	ret    
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_shm_close>:

int sys_shm_close(void) {
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
80105256:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105259:	89 44 24 04          	mov    %eax,0x4(%esp)
8010525d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105264:	e8 e7 f2 ff ff       	call   80104550 <argint>
80105269:	85 c0                	test   %eax,%eax
8010526b:	78 13                	js     80105280 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
8010526d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105270:	89 04 24             	mov    %eax,(%esp)
80105273:	e8 38 1c 00 00       	call   80106eb0 <shm_close>
}
80105278:	c9                   	leave  
80105279:	c3                   	ret    
8010527a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_fork>:

int
sys_fork(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105293:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105294:	e9 a7 e5 ff ff       	jmp    80103840 <fork>
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_exit>:
}

int
sys_exit(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801052a6:	e8 e5 e7 ff ff       	call   80103a90 <exit>
  return 0;  // not reached
}
801052ab:	31 c0                	xor    %eax,%eax
801052ad:	c9                   	leave  
801052ae:	c3                   	ret    
801052af:	90                   	nop

801052b0 <sys_wait>:

int
sys_wait(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801052b3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801052b4:	e9 f7 e9 ff ff       	jmp    80103cb0 <wait>
801052b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801052c0 <sys_kill>:
}

int
sys_kill(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
801052c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801052cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052d4:	e8 77 f2 ff ff       	call   80104550 <argint>
801052d9:	85 c0                	test   %eax,%eax
801052db:	78 13                	js     801052f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801052dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e0:	89 04 24             	mov    %eax,(%esp)
801052e3:	e8 28 eb ff ff       	call   80103e10 <kill>
}
801052e8:	c9                   	leave  
801052e9:	c3                   	ret    
801052ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801052f5:	c9                   	leave  
801052f6:	c3                   	ret    
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <sys_getpid>:

int
sys_getpid(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105306:	e8 85 e3 ff ff       	call   80103690 <myproc>
8010530b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010530e:	c9                   	leave  
8010530f:	c3                   	ret    

80105310 <sys_sbrk>:

int
sys_sbrk(void)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	53                   	push   %ebx
80105314:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105317:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010531a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105325:	e8 26 f2 ff ff       	call   80104550 <argint>
8010532a:	85 c0                	test   %eax,%eax
8010532c:	78 22                	js     80105350 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010532e:	e8 5d e3 ff ff       	call   80103690 <myproc>
  if(growproc(n) < 0)
80105333:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105336:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105338:	89 14 24             	mov    %edx,(%esp)
8010533b:	e8 90 e4 ff ff       	call   801037d0 <growproc>
80105340:	85 c0                	test   %eax,%eax
80105342:	78 0c                	js     80105350 <sys_sbrk+0x40>
    return -1;
  return addr;
80105344:	89 d8                	mov    %ebx,%eax
}
80105346:	83 c4 24             	add    $0x24,%esp
80105349:	5b                   	pop    %ebx
8010534a:	5d                   	pop    %ebp
8010534b:	c3                   	ret    
8010534c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105355:	eb ef                	jmp    80105346 <sys_sbrk+0x36>
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105360 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	53                   	push   %ebx
80105364:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105367:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010536a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010536e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105375:	e8 d6 f1 ff ff       	call   80104550 <argint>
8010537a:	85 c0                	test   %eax,%eax
8010537c:	78 7e                	js     801053fc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010537e:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
80105385:	e8 d6 ed ff ff       	call   80104160 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010538a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010538d:	8b 1d c0 56 11 80    	mov    0x801156c0,%ebx
  while(ticks - ticks0 < n){
80105393:	85 d2                	test   %edx,%edx
80105395:	75 29                	jne    801053c0 <sys_sleep+0x60>
80105397:	eb 4f                	jmp    801053e8 <sys_sleep+0x88>
80105399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801053a0:	c7 44 24 04 80 4e 11 	movl   $0x80114e80,0x4(%esp)
801053a7:	80 
801053a8:	c7 04 24 c0 56 11 80 	movl   $0x801156c0,(%esp)
801053af:	e8 4c e8 ff ff       	call   80103c00 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801053b4:	a1 c0 56 11 80       	mov    0x801156c0,%eax
801053b9:	29 d8                	sub    %ebx,%eax
801053bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801053be:	73 28                	jae    801053e8 <sys_sleep+0x88>
    if(myproc()->killed){
801053c0:	e8 cb e2 ff ff       	call   80103690 <myproc>
801053c5:	8b 40 2c             	mov    0x2c(%eax),%eax
801053c8:	85 c0                	test   %eax,%eax
801053ca:	74 d4                	je     801053a0 <sys_sleep+0x40>
      release(&tickslock);
801053cc:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
801053d3:	e8 78 ee ff ff       	call   80104250 <release>
      return -1;
801053d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801053dd:	83 c4 24             	add    $0x24,%esp
801053e0:	5b                   	pop    %ebx
801053e1:	5d                   	pop    %ebp
801053e2:	c3                   	ret    
801053e3:	90                   	nop
801053e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801053e8:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
801053ef:	e8 5c ee ff ff       	call   80104250 <release>
  return 0;
}
801053f4:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
801053f7:	31 c0                	xor    %eax,%eax
}
801053f9:	5b                   	pop    %ebx
801053fa:	5d                   	pop    %ebp
801053fb:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801053fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105401:	eb da                	jmp    801053dd <sys_sleep+0x7d>
80105403:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	53                   	push   %ebx
80105414:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105417:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
8010541e:	e8 3d ed ff ff       	call   80104160 <acquire>
  xticks = ticks;
80105423:	8b 1d c0 56 11 80    	mov    0x801156c0,%ebx
  release(&tickslock);
80105429:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
80105430:	e8 1b ee ff ff       	call   80104250 <release>
  return xticks;
}
80105435:	83 c4 14             	add    $0x14,%esp
80105438:	89 d8                	mov    %ebx,%eax
8010543a:	5b                   	pop    %ebx
8010543b:	5d                   	pop    %ebp
8010543c:	c3                   	ret    

8010543d <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010543d:	1e                   	push   %ds
  pushl %es
8010543e:	06                   	push   %es
  pushl %fs
8010543f:	0f a0                	push   %fs
  pushl %gs
80105441:	0f a8                	push   %gs
  pushal
80105443:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105444:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105448:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010544a:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010544c:	54                   	push   %esp
  call trap
8010544d:	e8 de 00 00 00       	call   80105530 <trap>
  addl $4, %esp
80105452:	83 c4 04             	add    $0x4,%esp

80105455 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105455:	61                   	popa   
  popl %gs
80105456:	0f a9                	pop    %gs
  popl %fs
80105458:	0f a1                	pop    %fs
  popl %es
8010545a:	07                   	pop    %es
  popl %ds
8010545b:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010545c:	83 c4 08             	add    $0x8,%esp
  iret
8010545f:	cf                   	iret   

80105460 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105460:	31 c0                	xor    %eax,%eax
80105462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105468:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010546f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105474:	66 89 0c c5 c2 4e 11 	mov    %cx,-0x7feeb13e(,%eax,8)
8010547b:	80 
8010547c:	c6 04 c5 c4 4e 11 80 	movb   $0x0,-0x7feeb13c(,%eax,8)
80105483:	00 
80105484:	c6 04 c5 c5 4e 11 80 	movb   $0x8e,-0x7feeb13b(,%eax,8)
8010548b:	8e 
8010548c:	66 89 14 c5 c0 4e 11 	mov    %dx,-0x7feeb140(,%eax,8)
80105493:	80 
80105494:	c1 ea 10             	shr    $0x10,%edx
80105497:	66 89 14 c5 c6 4e 11 	mov    %dx,-0x7feeb13a(,%eax,8)
8010549e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010549f:	83 c0 01             	add    $0x1,%eax
801054a2:	3d 00 01 00 00       	cmp    $0x100,%eax
801054a7:	75 bf                	jne    80105468 <tvinit+0x8>
struct spinlock tickslock;
uint ticks, base;

void
tvinit(void)
{
801054a9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054aa:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks, base;

void
tvinit(void)
{
801054af:	89 e5                	mov    %esp,%ebp
801054b1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054b4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801054b9:	c7 44 24 04 61 76 10 	movl   $0x80107661,0x4(%esp)
801054c0:	80 
801054c1:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801054c8:	66 89 15 c2 50 11 80 	mov    %dx,0x801150c2
801054cf:	66 a3 c0 50 11 80    	mov    %ax,0x801150c0
801054d5:	c1 e8 10             	shr    $0x10,%eax
801054d8:	c6 05 c4 50 11 80 00 	movb   $0x0,0x801150c4
801054df:	c6 05 c5 50 11 80 ef 	movb   $0xef,0x801150c5
801054e6:	66 a3 c6 50 11 80    	mov    %ax,0x801150c6

  initlock(&tickslock, "time");
801054ec:	e8 7f eb ff ff       	call   80104070 <initlock>
}
801054f1:	c9                   	leave  
801054f2:	c3                   	ret    
801054f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <idtinit>:

void
idtinit(void)
{
80105500:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105501:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105506:	89 e5                	mov    %esp,%ebp
80105508:	83 ec 10             	sub    $0x10,%esp
8010550b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010550f:	b8 c0 4e 11 80       	mov    $0x80114ec0,%eax
80105514:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105518:	c1 e8 10             	shr    $0x10,%eax
8010551b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010551f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105522:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	53                   	push   %ebx
80105536:	83 ec 3c             	sub    $0x3c,%esp
80105539:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010553c:	8b 43 30             	mov    0x30(%ebx),%eax
8010553f:	83 f8 40             	cmp    $0x40,%eax
80105542:	0f 84 10 02 00 00    	je     80105758 <trap+0x228>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105548:	83 e8 0e             	sub    $0xe,%eax
8010554b:	83 f8 31             	cmp    $0x31,%eax
8010554e:	77 08                	ja     80105558 <trap+0x28>
80105550:	ff 24 85 38 77 10 80 	jmp    *-0x7fef88c8(,%eax,4)
80105557:	90                   	nop
	        myproc()->killed = 1;

  break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105558:	e8 33 e1 ff ff       	call   80103690 <myproc>
8010555d:	85 c0                	test   %eax,%eax
8010555f:	90                   	nop
80105560:	0f 84 d2 02 00 00    	je     80105838 <trap+0x308>
80105566:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010556a:	0f 84 c8 02 00 00    	je     80105838 <trap+0x308>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105570:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105573:	8b 53 38             	mov    0x38(%ebx),%edx
80105576:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105579:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010557c:	e8 ef e0 ff ff       	call   80103670 <cpuid>
80105581:	8b 73 30             	mov    0x30(%ebx),%esi
80105584:	89 c7                	mov    %eax,%edi
80105586:	8b 43 34             	mov    0x34(%ebx),%eax
80105589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010558c:	e8 ff e0 ff ff       	call   80103690 <myproc>
80105591:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105594:	e8 f7 e0 ff ff       	call   80103690 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105599:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010559c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801055a0:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055a3:	8b 55 dc             	mov    -0x24(%ebp),%edx
801055a6:	89 7c 24 14          	mov    %edi,0x14(%esp)
801055aa:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
801055ae:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801055b1:	83 c6 74             	add    $0x74,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055b4:	89 54 24 18          	mov    %edx,0x18(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801055b8:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055bc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801055c0:	8b 40 10             	mov    0x10(%eax),%eax
801055c3:	c7 04 24 f4 76 10 80 	movl   $0x801076f4,(%esp)
801055ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ce:	e8 7d b0 ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801055d3:	e8 b8 e0 ff ff       	call   80103690 <myproc>
801055d8:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
801055df:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801055e0:	e8 ab e0 ff ff       	call   80103690 <myproc>
801055e5:	85 c0                	test   %eax,%eax
801055e7:	74 0c                	je     801055f5 <trap+0xc5>
801055e9:	e8 a2 e0 ff ff       	call   80103690 <myproc>
801055ee:	8b 50 2c             	mov    0x2c(%eax),%edx
801055f1:	85 d2                	test   %edx,%edx
801055f3:	75 4b                	jne    80105640 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801055f5:	e8 96 e0 ff ff       	call   80103690 <myproc>
801055fa:	85 c0                	test   %eax,%eax
801055fc:	74 0d                	je     8010560b <trap+0xdb>
801055fe:	66 90                	xchg   %ax,%ax
80105600:	e8 8b e0 ff ff       	call   80103690 <myproc>
80105605:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105609:	74 4d                	je     80105658 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010560b:	e8 80 e0 ff ff       	call   80103690 <myproc>
80105610:	85 c0                	test   %eax,%eax
80105612:	74 1d                	je     80105631 <trap+0x101>
80105614:	e8 77 e0 ff ff       	call   80103690 <myproc>
80105619:	8b 40 2c             	mov    0x2c(%eax),%eax
8010561c:	85 c0                	test   %eax,%eax
8010561e:	74 11                	je     80105631 <trap+0x101>
80105620:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105624:	83 e0 03             	and    $0x3,%eax
80105627:	66 83 f8 03          	cmp    $0x3,%ax
8010562b:	0f 84 5c 01 00 00    	je     8010578d <trap+0x25d>
    exit();
}
80105631:	83 c4 3c             	add    $0x3c,%esp
80105634:	5b                   	pop    %ebx
80105635:	5e                   	pop    %esi
80105636:	5f                   	pop    %edi
80105637:	5d                   	pop    %ebp
80105638:	c3                   	ret    
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105640:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105644:	83 e0 03             	and    $0x3,%eax
80105647:	66 83 f8 03          	cmp    $0x3,%ax
8010564b:	75 a8                	jne    801055f5 <trap+0xc5>
    exit();
8010564d:	e8 3e e4 ff ff       	call   80103a90 <exit>
80105652:	eb a1                	jmp    801055f5 <trap+0xc5>
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105658:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010565c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105660:	75 a9                	jne    8010560b <trap+0xdb>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105662:	e8 59 e5 ff ff       	call   80103bc0 <yield>
80105667:	eb a2                	jmp    8010560b <trap+0xdb>
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;
  case T_PGFLT:
    //cprintf("stack is growing\n");
    myproc()->pageNum += 1;
80105670:	e8 1b e0 ff ff       	call   80103690 <myproc>
80105675:	83 40 1c 01          	addl   $0x1,0x1c(%eax)
80105679:	0f 20 d6             	mov    %cr2,%esi
    if(rcr2() < myproc()->userstack_top && rcr2() > (myproc()->userstack_top - PGSIZE)){  
8010567c:	e8 0f e0 ff ff       	call   80103690 <myproc>
80105681:	39 70 18             	cmp    %esi,0x18(%eax)
80105684:	76 18                	jbe    8010569e <trap+0x16e>
80105686:	0f 20 d6             	mov    %cr2,%esi
80105689:	e8 02 e0 ff ff       	call   80103690 <myproc>
8010568e:	8b 40 18             	mov    0x18(%eax),%eax
80105691:	2d 00 10 00 00       	sub    $0x1000,%eax
80105696:	39 f0                	cmp    %esi,%eax
80105698:	0f 82 02 01 00 00    	jb     801057a0 <trap+0x270>
      //cprintf("stack located at :0x%x\n", myproc()->userstack_top);
      break;
    }
  PageFault:
	  cprintf("page fault! top user stack 0x%x\nNum Pages: %d\n",
		        myproc()->userstack_top, myproc()->pageNum);
8010569e:	e8 ed df ff ff       	call   80103690 <myproc>
      myproc()->userstack_top = base;
      //cprintf("stack located at :0x%x\n", myproc()->userstack_top);
      break;
    }
  PageFault:
	  cprintf("page fault! top user stack 0x%x\nNum Pages: %d\n",
801056a3:	8b 70 1c             	mov    0x1c(%eax),%esi
		        myproc()->userstack_top, myproc()->pageNum);
801056a6:	e8 e5 df ff ff       	call   80103690 <myproc>
      myproc()->userstack_top = base;
      //cprintf("stack located at :0x%x\n", myproc()->userstack_top);
      break;
    }
  PageFault:
	  cprintf("page fault! top user stack 0x%x\nNum Pages: %d\n",
801056ab:	89 74 24 08          	mov    %esi,0x8(%esp)
801056af:	8b 40 18             	mov    0x18(%eax),%eax
801056b2:	c7 04 24 90 76 10 80 	movl   $0x80107690,(%esp)
801056b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801056bd:	e8 8e af ff ff       	call   80100650 <cprintf>
		        myproc()->userstack_top, myproc()->pageNum);
	        myproc()->killed = 1;
801056c2:	e8 c9 df ff ff       	call   80103690 <myproc>
801056c7:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)

  break;
801056ce:	e9 0d ff ff ff       	jmp    801055e0 <trap+0xb0>
801056d3:	90                   	nop
801056d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801056d8:	e8 93 df ff ff       	call   80103670 <cpuid>
801056dd:	85 c0                	test   %eax,%eax
801056df:	0f 84 23 01 00 00    	je     80105808 <trap+0x2d8>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801056e5:	e8 86 d0 ff ff       	call   80102770 <lapiceoi>
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
801056f0:	e9 eb fe ff ff       	jmp    801055e0 <trap+0xb0>
801056f5:	8d 76 00             	lea    0x0(%esi),%esi
801056f8:	90                   	nop
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105700:	e8 bb ce ff ff       	call   801025c0 <kbdintr>
    lapiceoi();
80105705:	e8 66 d0 ff ff       	call   80102770 <lapiceoi>
    break;
8010570a:	e9 d1 fe ff ff       	jmp    801055e0 <trap+0xb0>
8010570f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105710:	e8 7b 02 00 00       	call   80105990 <uartintr>
    lapiceoi();
80105715:	e8 56 d0 ff ff       	call   80102770 <lapiceoi>
    break;
8010571a:	e9 c1 fe ff ff       	jmp    801055e0 <trap+0xb0>
8010571f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105720:	8b 7b 38             	mov    0x38(%ebx),%edi
80105723:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105727:	e8 44 df ff ff       	call   80103670 <cpuid>
8010572c:	c7 04 24 6c 76 10 80 	movl   $0x8010766c,(%esp)
80105733:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105737:	89 74 24 08          	mov    %esi,0x8(%esp)
8010573b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010573f:	e8 0c af ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105744:	e8 27 d0 ff ff       	call   80102770 <lapiceoi>
    break;
80105749:	e9 92 fe ff ff       	jmp    801055e0 <trap+0xb0>
8010574e:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105750:	e8 1b c9 ff ff       	call   80102070 <ideintr>
80105755:	eb 8e                	jmp    801056e5 <trap+0x1b5>
80105757:	90                   	nop
80105758:	90                   	nop
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105760:	e8 2b df ff ff       	call   80103690 <myproc>
80105765:	8b 70 2c             	mov    0x2c(%eax),%esi
80105768:	85 f6                	test   %esi,%esi
8010576a:	0f 85 88 00 00 00    	jne    801057f8 <trap+0x2c8>
      exit();
    myproc()->tf = tf;
80105770:	e8 1b df ff ff       	call   80103690 <myproc>
80105775:	89 58 20             	mov    %ebx,0x20(%eax)
    syscall();
80105778:	e8 c3 ee ff ff       	call   80104640 <syscall>
    if(myproc()->killed)
8010577d:	e8 0e df ff ff       	call   80103690 <myproc>
80105782:	8b 48 2c             	mov    0x2c(%eax),%ecx
80105785:	85 c9                	test   %ecx,%ecx
80105787:	0f 84 a4 fe ff ff    	je     80105631 <trap+0x101>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010578d:	83 c4 3c             	add    $0x3c,%esp
80105790:	5b                   	pop    %ebx
80105791:	5e                   	pop    %esi
80105792:	5f                   	pop    %edi
80105793:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105794:	e9 f7 e2 ff ff       	jmp    80103a90 <exit>
80105799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    break;
  case T_PGFLT:
    //cprintf("stack is growing\n");
    myproc()->pageNum += 1;
    if(rcr2() < myproc()->userstack_top && rcr2() > (myproc()->userstack_top - PGSIZE)){  
      base = (myproc()->userstack_top - PGSIZE); 
801057a0:	e8 eb de ff ff       	call   80103690 <myproc>
801057a5:	8b 40 18             	mov    0x18(%eax),%eax
801057a8:	2d 00 10 00 00       	sub    $0x1000,%eax
801057ad:	a3 60 4e 11 80       	mov    %eax,0x80114e60
      //allocate new page
      if(allocuvm(myproc()->pgdir,base, myproc()->userstack_top) == 0){
801057b2:	e8 d9 de ff ff       	call   80103690 <myproc>
801057b7:	8b 35 60 4e 11 80    	mov    0x80114e60,%esi
801057bd:	8b 78 18             	mov    0x18(%eax),%edi
801057c0:	e8 cb de ff ff       	call   80103690 <myproc>
801057c5:	89 74 24 04          	mov    %esi,0x4(%esp)
801057c9:	89 7c 24 08          	mov    %edi,0x8(%esp)
801057cd:	8b 40 04             	mov    0x4(%eax),%eax
801057d0:	89 04 24             	mov    %eax,(%esp)
801057d3:	e8 38 11 00 00       	call   80106910 <allocuvm>
801057d8:	85 c0                	test   %eax,%eax
801057da:	0f 84 be fe ff ff    	je     8010569e <trap+0x16e>
  	    goto PageFault;  
  	  }
      //record position of stack
      myproc()->userstack_top = base;
801057e0:	e8 ab de ff ff       	call   80103690 <myproc>
801057e5:	8b 15 60 4e 11 80    	mov    0x80114e60,%edx
801057eb:	89 50 18             	mov    %edx,0x18(%eax)
      //cprintf("stack located at :0x%x\n", myproc()->userstack_top);
      break;
801057ee:	e9 ed fd ff ff       	jmp    801055e0 <trap+0xb0>
801057f3:	90                   	nop
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801057f8:	e8 93 e2 ff ff       	call   80103a90 <exit>
801057fd:	e9 6e ff ff ff       	jmp    80105770 <trap+0x240>
80105802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105808:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
8010580f:	e8 4c e9 ff ff       	call   80104160 <acquire>
      ticks++;
      wakeup(&ticks);
80105814:	c7 04 24 c0 56 11 80 	movl   $0x801156c0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
8010581b:	83 05 c0 56 11 80 01 	addl   $0x1,0x801156c0
      wakeup(&ticks);
80105822:	e8 79 e5 ff ff       	call   80103da0 <wakeup>
      release(&tickslock);
80105827:	c7 04 24 80 4e 11 80 	movl   $0x80114e80,(%esp)
8010582e:	e8 1d ea ff ff       	call   80104250 <release>
80105833:	e9 ad fe ff ff       	jmp    801056e5 <trap+0x1b5>
80105838:	0f 20 d7             	mov    %cr2,%edi
  break;
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010583b:	8b 73 38             	mov    0x38(%ebx),%esi
8010583e:	e8 2d de ff ff       	call   80103670 <cpuid>
80105843:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105847:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010584b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010584f:	8b 43 30             	mov    0x30(%ebx),%eax
80105852:	c7 04 24 c0 76 10 80 	movl   $0x801076c0,(%esp)
80105859:	89 44 24 04          	mov    %eax,0x4(%esp)
8010585d:	e8 ee ad ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105862:	c7 04 24 66 76 10 80 	movl   $0x80107666,(%esp)
80105869:	e8 f2 aa ff ff       	call   80100360 <panic>
8010586e:	66 90                	xchg   %ax,%ax

80105870 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105870:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105875:	55                   	push   %ebp
80105876:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105878:	85 c0                	test   %eax,%eax
8010587a:	74 14                	je     80105890 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010587c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105881:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105882:	a8 01                	test   $0x1,%al
80105884:	74 0a                	je     80105890 <uartgetc+0x20>
80105886:	b2 f8                	mov    $0xf8,%dl
80105888:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105889:	0f b6 c0             	movzbl %al,%eax
}
8010588c:	5d                   	pop    %ebp
8010588d:	c3                   	ret    
8010588e:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105895:	5d                   	pop    %ebp
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801058a0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
801058a5:	85 c0                	test   %eax,%eax
801058a7:	74 3f                	je     801058e8 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
801058a9:	55                   	push   %ebp
801058aa:	89 e5                	mov    %esp,%ebp
801058ac:	56                   	push   %esi
801058ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801058b2:	53                   	push   %ebx
  int i;

  if(!uart)
801058b3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
801058b8:	83 ec 10             	sub    $0x10,%esp
801058bb:	eb 14                	jmp    801058d1 <uartputc+0x31>
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
801058c0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801058c7:	e8 c4 ce ff ff       	call   80102790 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801058cc:	83 eb 01             	sub    $0x1,%ebx
801058cf:	74 07                	je     801058d8 <uartputc+0x38>
801058d1:	89 f2                	mov    %esi,%edx
801058d3:	ec                   	in     (%dx),%al
801058d4:	a8 20                	test   $0x20,%al
801058d6:	74 e8                	je     801058c0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
801058d8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801058dc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058e1:	ee                   	out    %al,(%dx)
}
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	5b                   	pop    %ebx
801058e6:	5e                   	pop    %esi
801058e7:	5d                   	pop    %ebp
801058e8:	f3 c3                	repz ret 
801058ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058f0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801058f0:	55                   	push   %ebp
801058f1:	31 c9                	xor    %ecx,%ecx
801058f3:	89 e5                	mov    %esp,%ebp
801058f5:	89 c8                	mov    %ecx,%eax
801058f7:	57                   	push   %edi
801058f8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801058fd:	56                   	push   %esi
801058fe:	89 fa                	mov    %edi,%edx
80105900:	53                   	push   %ebx
80105901:	83 ec 1c             	sub    $0x1c,%esp
80105904:	ee                   	out    %al,(%dx)
80105905:	be fb 03 00 00       	mov    $0x3fb,%esi
8010590a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010590f:	89 f2                	mov    %esi,%edx
80105911:	ee                   	out    %al,(%dx)
80105912:	b8 0c 00 00 00       	mov    $0xc,%eax
80105917:	b2 f8                	mov    $0xf8,%dl
80105919:	ee                   	out    %al,(%dx)
8010591a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010591f:	89 c8                	mov    %ecx,%eax
80105921:	89 da                	mov    %ebx,%edx
80105923:	ee                   	out    %al,(%dx)
80105924:	b8 03 00 00 00       	mov    $0x3,%eax
80105929:	89 f2                	mov    %esi,%edx
8010592b:	ee                   	out    %al,(%dx)
8010592c:	b2 fc                	mov    $0xfc,%dl
8010592e:	89 c8                	mov    %ecx,%eax
80105930:	ee                   	out    %al,(%dx)
80105931:	b8 01 00 00 00       	mov    $0x1,%eax
80105936:	89 da                	mov    %ebx,%edx
80105938:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105939:	b2 fd                	mov    $0xfd,%dl
8010593b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010593c:	3c ff                	cmp    $0xff,%al
8010593e:	74 42                	je     80105982 <uartinit+0x92>
    return;
  uart = 1;
80105940:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105947:	00 00 00 
8010594a:	89 fa                	mov    %edi,%edx
8010594c:	ec                   	in     (%dx),%al
8010594d:	b2 f8                	mov    $0xf8,%dl
8010594f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105950:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105957:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105958:	bb 00 78 10 80       	mov    $0x80107800,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010595d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105964:	e8 37 c9 ff ff       	call   801022a0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105969:	b8 78 00 00 00       	mov    $0x78,%eax
8010596e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105970:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105973:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105976:	e8 25 ff ff ff       	call   801058a0 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010597b:	0f be 03             	movsbl (%ebx),%eax
8010597e:	84 c0                	test   %al,%al
80105980:	75 ee                	jne    80105970 <uartinit+0x80>
    uartputc(*p);
}
80105982:	83 c4 1c             	add    $0x1c,%esp
80105985:	5b                   	pop    %ebx
80105986:	5e                   	pop    %esi
80105987:	5f                   	pop    %edi
80105988:	5d                   	pop    %ebp
80105989:	c3                   	ret    
8010598a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105990 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105996:	c7 04 24 70 58 10 80 	movl   $0x80105870,(%esp)
8010599d:	e8 0e ae ff ff       	call   801007b0 <consoleintr>
}
801059a2:	c9                   	leave  
801059a3:	c3                   	ret    

801059a4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801059a4:	6a 00                	push   $0x0
  pushl $0
801059a6:	6a 00                	push   $0x0
  jmp alltraps
801059a8:	e9 90 fa ff ff       	jmp    8010543d <alltraps>

801059ad <vector1>:
.globl vector1
vector1:
  pushl $0
801059ad:	6a 00                	push   $0x0
  pushl $1
801059af:	6a 01                	push   $0x1
  jmp alltraps
801059b1:	e9 87 fa ff ff       	jmp    8010543d <alltraps>

801059b6 <vector2>:
.globl vector2
vector2:
  pushl $0
801059b6:	6a 00                	push   $0x0
  pushl $2
801059b8:	6a 02                	push   $0x2
  jmp alltraps
801059ba:	e9 7e fa ff ff       	jmp    8010543d <alltraps>

801059bf <vector3>:
.globl vector3
vector3:
  pushl $0
801059bf:	6a 00                	push   $0x0
  pushl $3
801059c1:	6a 03                	push   $0x3
  jmp alltraps
801059c3:	e9 75 fa ff ff       	jmp    8010543d <alltraps>

801059c8 <vector4>:
.globl vector4
vector4:
  pushl $0
801059c8:	6a 00                	push   $0x0
  pushl $4
801059ca:	6a 04                	push   $0x4
  jmp alltraps
801059cc:	e9 6c fa ff ff       	jmp    8010543d <alltraps>

801059d1 <vector5>:
.globl vector5
vector5:
  pushl $0
801059d1:	6a 00                	push   $0x0
  pushl $5
801059d3:	6a 05                	push   $0x5
  jmp alltraps
801059d5:	e9 63 fa ff ff       	jmp    8010543d <alltraps>

801059da <vector6>:
.globl vector6
vector6:
  pushl $0
801059da:	6a 00                	push   $0x0
  pushl $6
801059dc:	6a 06                	push   $0x6
  jmp alltraps
801059de:	e9 5a fa ff ff       	jmp    8010543d <alltraps>

801059e3 <vector7>:
.globl vector7
vector7:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $7
801059e5:	6a 07                	push   $0x7
  jmp alltraps
801059e7:	e9 51 fa ff ff       	jmp    8010543d <alltraps>

801059ec <vector8>:
.globl vector8
vector8:
  pushl $8
801059ec:	6a 08                	push   $0x8
  jmp alltraps
801059ee:	e9 4a fa ff ff       	jmp    8010543d <alltraps>

801059f3 <vector9>:
.globl vector9
vector9:
  pushl $0
801059f3:	6a 00                	push   $0x0
  pushl $9
801059f5:	6a 09                	push   $0x9
  jmp alltraps
801059f7:	e9 41 fa ff ff       	jmp    8010543d <alltraps>

801059fc <vector10>:
.globl vector10
vector10:
  pushl $10
801059fc:	6a 0a                	push   $0xa
  jmp alltraps
801059fe:	e9 3a fa ff ff       	jmp    8010543d <alltraps>

80105a03 <vector11>:
.globl vector11
vector11:
  pushl $11
80105a03:	6a 0b                	push   $0xb
  jmp alltraps
80105a05:	e9 33 fa ff ff       	jmp    8010543d <alltraps>

80105a0a <vector12>:
.globl vector12
vector12:
  pushl $12
80105a0a:	6a 0c                	push   $0xc
  jmp alltraps
80105a0c:	e9 2c fa ff ff       	jmp    8010543d <alltraps>

80105a11 <vector13>:
.globl vector13
vector13:
  pushl $13
80105a11:	6a 0d                	push   $0xd
  jmp alltraps
80105a13:	e9 25 fa ff ff       	jmp    8010543d <alltraps>

80105a18 <vector14>:
.globl vector14
vector14:
  pushl $14
80105a18:	6a 0e                	push   $0xe
  jmp alltraps
80105a1a:	e9 1e fa ff ff       	jmp    8010543d <alltraps>

80105a1f <vector15>:
.globl vector15
vector15:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $15
80105a21:	6a 0f                	push   $0xf
  jmp alltraps
80105a23:	e9 15 fa ff ff       	jmp    8010543d <alltraps>

80105a28 <vector16>:
.globl vector16
vector16:
  pushl $0
80105a28:	6a 00                	push   $0x0
  pushl $16
80105a2a:	6a 10                	push   $0x10
  jmp alltraps
80105a2c:	e9 0c fa ff ff       	jmp    8010543d <alltraps>

80105a31 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a31:	6a 11                	push   $0x11
  jmp alltraps
80105a33:	e9 05 fa ff ff       	jmp    8010543d <alltraps>

80105a38 <vector18>:
.globl vector18
vector18:
  pushl $0
80105a38:	6a 00                	push   $0x0
  pushl $18
80105a3a:	6a 12                	push   $0x12
  jmp alltraps
80105a3c:	e9 fc f9 ff ff       	jmp    8010543d <alltraps>

80105a41 <vector19>:
.globl vector19
vector19:
  pushl $0
80105a41:	6a 00                	push   $0x0
  pushl $19
80105a43:	6a 13                	push   $0x13
  jmp alltraps
80105a45:	e9 f3 f9 ff ff       	jmp    8010543d <alltraps>

80105a4a <vector20>:
.globl vector20
vector20:
  pushl $0
80105a4a:	6a 00                	push   $0x0
  pushl $20
80105a4c:	6a 14                	push   $0x14
  jmp alltraps
80105a4e:	e9 ea f9 ff ff       	jmp    8010543d <alltraps>

80105a53 <vector21>:
.globl vector21
vector21:
  pushl $0
80105a53:	6a 00                	push   $0x0
  pushl $21
80105a55:	6a 15                	push   $0x15
  jmp alltraps
80105a57:	e9 e1 f9 ff ff       	jmp    8010543d <alltraps>

80105a5c <vector22>:
.globl vector22
vector22:
  pushl $0
80105a5c:	6a 00                	push   $0x0
  pushl $22
80105a5e:	6a 16                	push   $0x16
  jmp alltraps
80105a60:	e9 d8 f9 ff ff       	jmp    8010543d <alltraps>

80105a65 <vector23>:
.globl vector23
vector23:
  pushl $0
80105a65:	6a 00                	push   $0x0
  pushl $23
80105a67:	6a 17                	push   $0x17
  jmp alltraps
80105a69:	e9 cf f9 ff ff       	jmp    8010543d <alltraps>

80105a6e <vector24>:
.globl vector24
vector24:
  pushl $0
80105a6e:	6a 00                	push   $0x0
  pushl $24
80105a70:	6a 18                	push   $0x18
  jmp alltraps
80105a72:	e9 c6 f9 ff ff       	jmp    8010543d <alltraps>

80105a77 <vector25>:
.globl vector25
vector25:
  pushl $0
80105a77:	6a 00                	push   $0x0
  pushl $25
80105a79:	6a 19                	push   $0x19
  jmp alltraps
80105a7b:	e9 bd f9 ff ff       	jmp    8010543d <alltraps>

80105a80 <vector26>:
.globl vector26
vector26:
  pushl $0
80105a80:	6a 00                	push   $0x0
  pushl $26
80105a82:	6a 1a                	push   $0x1a
  jmp alltraps
80105a84:	e9 b4 f9 ff ff       	jmp    8010543d <alltraps>

80105a89 <vector27>:
.globl vector27
vector27:
  pushl $0
80105a89:	6a 00                	push   $0x0
  pushl $27
80105a8b:	6a 1b                	push   $0x1b
  jmp alltraps
80105a8d:	e9 ab f9 ff ff       	jmp    8010543d <alltraps>

80105a92 <vector28>:
.globl vector28
vector28:
  pushl $0
80105a92:	6a 00                	push   $0x0
  pushl $28
80105a94:	6a 1c                	push   $0x1c
  jmp alltraps
80105a96:	e9 a2 f9 ff ff       	jmp    8010543d <alltraps>

80105a9b <vector29>:
.globl vector29
vector29:
  pushl $0
80105a9b:	6a 00                	push   $0x0
  pushl $29
80105a9d:	6a 1d                	push   $0x1d
  jmp alltraps
80105a9f:	e9 99 f9 ff ff       	jmp    8010543d <alltraps>

80105aa4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105aa4:	6a 00                	push   $0x0
  pushl $30
80105aa6:	6a 1e                	push   $0x1e
  jmp alltraps
80105aa8:	e9 90 f9 ff ff       	jmp    8010543d <alltraps>

80105aad <vector31>:
.globl vector31
vector31:
  pushl $0
80105aad:	6a 00                	push   $0x0
  pushl $31
80105aaf:	6a 1f                	push   $0x1f
  jmp alltraps
80105ab1:	e9 87 f9 ff ff       	jmp    8010543d <alltraps>

80105ab6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105ab6:	6a 00                	push   $0x0
  pushl $32
80105ab8:	6a 20                	push   $0x20
  jmp alltraps
80105aba:	e9 7e f9 ff ff       	jmp    8010543d <alltraps>

80105abf <vector33>:
.globl vector33
vector33:
  pushl $0
80105abf:	6a 00                	push   $0x0
  pushl $33
80105ac1:	6a 21                	push   $0x21
  jmp alltraps
80105ac3:	e9 75 f9 ff ff       	jmp    8010543d <alltraps>

80105ac8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ac8:	6a 00                	push   $0x0
  pushl $34
80105aca:	6a 22                	push   $0x22
  jmp alltraps
80105acc:	e9 6c f9 ff ff       	jmp    8010543d <alltraps>

80105ad1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ad1:	6a 00                	push   $0x0
  pushl $35
80105ad3:	6a 23                	push   $0x23
  jmp alltraps
80105ad5:	e9 63 f9 ff ff       	jmp    8010543d <alltraps>

80105ada <vector36>:
.globl vector36
vector36:
  pushl $0
80105ada:	6a 00                	push   $0x0
  pushl $36
80105adc:	6a 24                	push   $0x24
  jmp alltraps
80105ade:	e9 5a f9 ff ff       	jmp    8010543d <alltraps>

80105ae3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ae3:	6a 00                	push   $0x0
  pushl $37
80105ae5:	6a 25                	push   $0x25
  jmp alltraps
80105ae7:	e9 51 f9 ff ff       	jmp    8010543d <alltraps>

80105aec <vector38>:
.globl vector38
vector38:
  pushl $0
80105aec:	6a 00                	push   $0x0
  pushl $38
80105aee:	6a 26                	push   $0x26
  jmp alltraps
80105af0:	e9 48 f9 ff ff       	jmp    8010543d <alltraps>

80105af5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105af5:	6a 00                	push   $0x0
  pushl $39
80105af7:	6a 27                	push   $0x27
  jmp alltraps
80105af9:	e9 3f f9 ff ff       	jmp    8010543d <alltraps>

80105afe <vector40>:
.globl vector40
vector40:
  pushl $0
80105afe:	6a 00                	push   $0x0
  pushl $40
80105b00:	6a 28                	push   $0x28
  jmp alltraps
80105b02:	e9 36 f9 ff ff       	jmp    8010543d <alltraps>

80105b07 <vector41>:
.globl vector41
vector41:
  pushl $0
80105b07:	6a 00                	push   $0x0
  pushl $41
80105b09:	6a 29                	push   $0x29
  jmp alltraps
80105b0b:	e9 2d f9 ff ff       	jmp    8010543d <alltraps>

80105b10 <vector42>:
.globl vector42
vector42:
  pushl $0
80105b10:	6a 00                	push   $0x0
  pushl $42
80105b12:	6a 2a                	push   $0x2a
  jmp alltraps
80105b14:	e9 24 f9 ff ff       	jmp    8010543d <alltraps>

80105b19 <vector43>:
.globl vector43
vector43:
  pushl $0
80105b19:	6a 00                	push   $0x0
  pushl $43
80105b1b:	6a 2b                	push   $0x2b
  jmp alltraps
80105b1d:	e9 1b f9 ff ff       	jmp    8010543d <alltraps>

80105b22 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b22:	6a 00                	push   $0x0
  pushl $44
80105b24:	6a 2c                	push   $0x2c
  jmp alltraps
80105b26:	e9 12 f9 ff ff       	jmp    8010543d <alltraps>

80105b2b <vector45>:
.globl vector45
vector45:
  pushl $0
80105b2b:	6a 00                	push   $0x0
  pushl $45
80105b2d:	6a 2d                	push   $0x2d
  jmp alltraps
80105b2f:	e9 09 f9 ff ff       	jmp    8010543d <alltraps>

80105b34 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b34:	6a 00                	push   $0x0
  pushl $46
80105b36:	6a 2e                	push   $0x2e
  jmp alltraps
80105b38:	e9 00 f9 ff ff       	jmp    8010543d <alltraps>

80105b3d <vector47>:
.globl vector47
vector47:
  pushl $0
80105b3d:	6a 00                	push   $0x0
  pushl $47
80105b3f:	6a 2f                	push   $0x2f
  jmp alltraps
80105b41:	e9 f7 f8 ff ff       	jmp    8010543d <alltraps>

80105b46 <vector48>:
.globl vector48
vector48:
  pushl $0
80105b46:	6a 00                	push   $0x0
  pushl $48
80105b48:	6a 30                	push   $0x30
  jmp alltraps
80105b4a:	e9 ee f8 ff ff       	jmp    8010543d <alltraps>

80105b4f <vector49>:
.globl vector49
vector49:
  pushl $0
80105b4f:	6a 00                	push   $0x0
  pushl $49
80105b51:	6a 31                	push   $0x31
  jmp alltraps
80105b53:	e9 e5 f8 ff ff       	jmp    8010543d <alltraps>

80105b58 <vector50>:
.globl vector50
vector50:
  pushl $0
80105b58:	6a 00                	push   $0x0
  pushl $50
80105b5a:	6a 32                	push   $0x32
  jmp alltraps
80105b5c:	e9 dc f8 ff ff       	jmp    8010543d <alltraps>

80105b61 <vector51>:
.globl vector51
vector51:
  pushl $0
80105b61:	6a 00                	push   $0x0
  pushl $51
80105b63:	6a 33                	push   $0x33
  jmp alltraps
80105b65:	e9 d3 f8 ff ff       	jmp    8010543d <alltraps>

80105b6a <vector52>:
.globl vector52
vector52:
  pushl $0
80105b6a:	6a 00                	push   $0x0
  pushl $52
80105b6c:	6a 34                	push   $0x34
  jmp alltraps
80105b6e:	e9 ca f8 ff ff       	jmp    8010543d <alltraps>

80105b73 <vector53>:
.globl vector53
vector53:
  pushl $0
80105b73:	6a 00                	push   $0x0
  pushl $53
80105b75:	6a 35                	push   $0x35
  jmp alltraps
80105b77:	e9 c1 f8 ff ff       	jmp    8010543d <alltraps>

80105b7c <vector54>:
.globl vector54
vector54:
  pushl $0
80105b7c:	6a 00                	push   $0x0
  pushl $54
80105b7e:	6a 36                	push   $0x36
  jmp alltraps
80105b80:	e9 b8 f8 ff ff       	jmp    8010543d <alltraps>

80105b85 <vector55>:
.globl vector55
vector55:
  pushl $0
80105b85:	6a 00                	push   $0x0
  pushl $55
80105b87:	6a 37                	push   $0x37
  jmp alltraps
80105b89:	e9 af f8 ff ff       	jmp    8010543d <alltraps>

80105b8e <vector56>:
.globl vector56
vector56:
  pushl $0
80105b8e:	6a 00                	push   $0x0
  pushl $56
80105b90:	6a 38                	push   $0x38
  jmp alltraps
80105b92:	e9 a6 f8 ff ff       	jmp    8010543d <alltraps>

80105b97 <vector57>:
.globl vector57
vector57:
  pushl $0
80105b97:	6a 00                	push   $0x0
  pushl $57
80105b99:	6a 39                	push   $0x39
  jmp alltraps
80105b9b:	e9 9d f8 ff ff       	jmp    8010543d <alltraps>

80105ba0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105ba0:	6a 00                	push   $0x0
  pushl $58
80105ba2:	6a 3a                	push   $0x3a
  jmp alltraps
80105ba4:	e9 94 f8 ff ff       	jmp    8010543d <alltraps>

80105ba9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105ba9:	6a 00                	push   $0x0
  pushl $59
80105bab:	6a 3b                	push   $0x3b
  jmp alltraps
80105bad:	e9 8b f8 ff ff       	jmp    8010543d <alltraps>

80105bb2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105bb2:	6a 00                	push   $0x0
  pushl $60
80105bb4:	6a 3c                	push   $0x3c
  jmp alltraps
80105bb6:	e9 82 f8 ff ff       	jmp    8010543d <alltraps>

80105bbb <vector61>:
.globl vector61
vector61:
  pushl $0
80105bbb:	6a 00                	push   $0x0
  pushl $61
80105bbd:	6a 3d                	push   $0x3d
  jmp alltraps
80105bbf:	e9 79 f8 ff ff       	jmp    8010543d <alltraps>

80105bc4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105bc4:	6a 00                	push   $0x0
  pushl $62
80105bc6:	6a 3e                	push   $0x3e
  jmp alltraps
80105bc8:	e9 70 f8 ff ff       	jmp    8010543d <alltraps>

80105bcd <vector63>:
.globl vector63
vector63:
  pushl $0
80105bcd:	6a 00                	push   $0x0
  pushl $63
80105bcf:	6a 3f                	push   $0x3f
  jmp alltraps
80105bd1:	e9 67 f8 ff ff       	jmp    8010543d <alltraps>

80105bd6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105bd6:	6a 00                	push   $0x0
  pushl $64
80105bd8:	6a 40                	push   $0x40
  jmp alltraps
80105bda:	e9 5e f8 ff ff       	jmp    8010543d <alltraps>

80105bdf <vector65>:
.globl vector65
vector65:
  pushl $0
80105bdf:	6a 00                	push   $0x0
  pushl $65
80105be1:	6a 41                	push   $0x41
  jmp alltraps
80105be3:	e9 55 f8 ff ff       	jmp    8010543d <alltraps>

80105be8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105be8:	6a 00                	push   $0x0
  pushl $66
80105bea:	6a 42                	push   $0x42
  jmp alltraps
80105bec:	e9 4c f8 ff ff       	jmp    8010543d <alltraps>

80105bf1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105bf1:	6a 00                	push   $0x0
  pushl $67
80105bf3:	6a 43                	push   $0x43
  jmp alltraps
80105bf5:	e9 43 f8 ff ff       	jmp    8010543d <alltraps>

80105bfa <vector68>:
.globl vector68
vector68:
  pushl $0
80105bfa:	6a 00                	push   $0x0
  pushl $68
80105bfc:	6a 44                	push   $0x44
  jmp alltraps
80105bfe:	e9 3a f8 ff ff       	jmp    8010543d <alltraps>

80105c03 <vector69>:
.globl vector69
vector69:
  pushl $0
80105c03:	6a 00                	push   $0x0
  pushl $69
80105c05:	6a 45                	push   $0x45
  jmp alltraps
80105c07:	e9 31 f8 ff ff       	jmp    8010543d <alltraps>

80105c0c <vector70>:
.globl vector70
vector70:
  pushl $0
80105c0c:	6a 00                	push   $0x0
  pushl $70
80105c0e:	6a 46                	push   $0x46
  jmp alltraps
80105c10:	e9 28 f8 ff ff       	jmp    8010543d <alltraps>

80105c15 <vector71>:
.globl vector71
vector71:
  pushl $0
80105c15:	6a 00                	push   $0x0
  pushl $71
80105c17:	6a 47                	push   $0x47
  jmp alltraps
80105c19:	e9 1f f8 ff ff       	jmp    8010543d <alltraps>

80105c1e <vector72>:
.globl vector72
vector72:
  pushl $0
80105c1e:	6a 00                	push   $0x0
  pushl $72
80105c20:	6a 48                	push   $0x48
  jmp alltraps
80105c22:	e9 16 f8 ff ff       	jmp    8010543d <alltraps>

80105c27 <vector73>:
.globl vector73
vector73:
  pushl $0
80105c27:	6a 00                	push   $0x0
  pushl $73
80105c29:	6a 49                	push   $0x49
  jmp alltraps
80105c2b:	e9 0d f8 ff ff       	jmp    8010543d <alltraps>

80105c30 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c30:	6a 00                	push   $0x0
  pushl $74
80105c32:	6a 4a                	push   $0x4a
  jmp alltraps
80105c34:	e9 04 f8 ff ff       	jmp    8010543d <alltraps>

80105c39 <vector75>:
.globl vector75
vector75:
  pushl $0
80105c39:	6a 00                	push   $0x0
  pushl $75
80105c3b:	6a 4b                	push   $0x4b
  jmp alltraps
80105c3d:	e9 fb f7 ff ff       	jmp    8010543d <alltraps>

80105c42 <vector76>:
.globl vector76
vector76:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $76
80105c44:	6a 4c                	push   $0x4c
  jmp alltraps
80105c46:	e9 f2 f7 ff ff       	jmp    8010543d <alltraps>

80105c4b <vector77>:
.globl vector77
vector77:
  pushl $0
80105c4b:	6a 00                	push   $0x0
  pushl $77
80105c4d:	6a 4d                	push   $0x4d
  jmp alltraps
80105c4f:	e9 e9 f7 ff ff       	jmp    8010543d <alltraps>

80105c54 <vector78>:
.globl vector78
vector78:
  pushl $0
80105c54:	6a 00                	push   $0x0
  pushl $78
80105c56:	6a 4e                	push   $0x4e
  jmp alltraps
80105c58:	e9 e0 f7 ff ff       	jmp    8010543d <alltraps>

80105c5d <vector79>:
.globl vector79
vector79:
  pushl $0
80105c5d:	6a 00                	push   $0x0
  pushl $79
80105c5f:	6a 4f                	push   $0x4f
  jmp alltraps
80105c61:	e9 d7 f7 ff ff       	jmp    8010543d <alltraps>

80105c66 <vector80>:
.globl vector80
vector80:
  pushl $0
80105c66:	6a 00                	push   $0x0
  pushl $80
80105c68:	6a 50                	push   $0x50
  jmp alltraps
80105c6a:	e9 ce f7 ff ff       	jmp    8010543d <alltraps>

80105c6f <vector81>:
.globl vector81
vector81:
  pushl $0
80105c6f:	6a 00                	push   $0x0
  pushl $81
80105c71:	6a 51                	push   $0x51
  jmp alltraps
80105c73:	e9 c5 f7 ff ff       	jmp    8010543d <alltraps>

80105c78 <vector82>:
.globl vector82
vector82:
  pushl $0
80105c78:	6a 00                	push   $0x0
  pushl $82
80105c7a:	6a 52                	push   $0x52
  jmp alltraps
80105c7c:	e9 bc f7 ff ff       	jmp    8010543d <alltraps>

80105c81 <vector83>:
.globl vector83
vector83:
  pushl $0
80105c81:	6a 00                	push   $0x0
  pushl $83
80105c83:	6a 53                	push   $0x53
  jmp alltraps
80105c85:	e9 b3 f7 ff ff       	jmp    8010543d <alltraps>

80105c8a <vector84>:
.globl vector84
vector84:
  pushl $0
80105c8a:	6a 00                	push   $0x0
  pushl $84
80105c8c:	6a 54                	push   $0x54
  jmp alltraps
80105c8e:	e9 aa f7 ff ff       	jmp    8010543d <alltraps>

80105c93 <vector85>:
.globl vector85
vector85:
  pushl $0
80105c93:	6a 00                	push   $0x0
  pushl $85
80105c95:	6a 55                	push   $0x55
  jmp alltraps
80105c97:	e9 a1 f7 ff ff       	jmp    8010543d <alltraps>

80105c9c <vector86>:
.globl vector86
vector86:
  pushl $0
80105c9c:	6a 00                	push   $0x0
  pushl $86
80105c9e:	6a 56                	push   $0x56
  jmp alltraps
80105ca0:	e9 98 f7 ff ff       	jmp    8010543d <alltraps>

80105ca5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ca5:	6a 00                	push   $0x0
  pushl $87
80105ca7:	6a 57                	push   $0x57
  jmp alltraps
80105ca9:	e9 8f f7 ff ff       	jmp    8010543d <alltraps>

80105cae <vector88>:
.globl vector88
vector88:
  pushl $0
80105cae:	6a 00                	push   $0x0
  pushl $88
80105cb0:	6a 58                	push   $0x58
  jmp alltraps
80105cb2:	e9 86 f7 ff ff       	jmp    8010543d <alltraps>

80105cb7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105cb7:	6a 00                	push   $0x0
  pushl $89
80105cb9:	6a 59                	push   $0x59
  jmp alltraps
80105cbb:	e9 7d f7 ff ff       	jmp    8010543d <alltraps>

80105cc0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105cc0:	6a 00                	push   $0x0
  pushl $90
80105cc2:	6a 5a                	push   $0x5a
  jmp alltraps
80105cc4:	e9 74 f7 ff ff       	jmp    8010543d <alltraps>

80105cc9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105cc9:	6a 00                	push   $0x0
  pushl $91
80105ccb:	6a 5b                	push   $0x5b
  jmp alltraps
80105ccd:	e9 6b f7 ff ff       	jmp    8010543d <alltraps>

80105cd2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $92
80105cd4:	6a 5c                	push   $0x5c
  jmp alltraps
80105cd6:	e9 62 f7 ff ff       	jmp    8010543d <alltraps>

80105cdb <vector93>:
.globl vector93
vector93:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $93
80105cdd:	6a 5d                	push   $0x5d
  jmp alltraps
80105cdf:	e9 59 f7 ff ff       	jmp    8010543d <alltraps>

80105ce4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105ce4:	6a 00                	push   $0x0
  pushl $94
80105ce6:	6a 5e                	push   $0x5e
  jmp alltraps
80105ce8:	e9 50 f7 ff ff       	jmp    8010543d <alltraps>

80105ced <vector95>:
.globl vector95
vector95:
  pushl $0
80105ced:	6a 00                	push   $0x0
  pushl $95
80105cef:	6a 5f                	push   $0x5f
  jmp alltraps
80105cf1:	e9 47 f7 ff ff       	jmp    8010543d <alltraps>

80105cf6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $96
80105cf8:	6a 60                	push   $0x60
  jmp alltraps
80105cfa:	e9 3e f7 ff ff       	jmp    8010543d <alltraps>

80105cff <vector97>:
.globl vector97
vector97:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $97
80105d01:	6a 61                	push   $0x61
  jmp alltraps
80105d03:	e9 35 f7 ff ff       	jmp    8010543d <alltraps>

80105d08 <vector98>:
.globl vector98
vector98:
  pushl $0
80105d08:	6a 00                	push   $0x0
  pushl $98
80105d0a:	6a 62                	push   $0x62
  jmp alltraps
80105d0c:	e9 2c f7 ff ff       	jmp    8010543d <alltraps>

80105d11 <vector99>:
.globl vector99
vector99:
  pushl $0
80105d11:	6a 00                	push   $0x0
  pushl $99
80105d13:	6a 63                	push   $0x63
  jmp alltraps
80105d15:	e9 23 f7 ff ff       	jmp    8010543d <alltraps>

80105d1a <vector100>:
.globl vector100
vector100:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $100
80105d1c:	6a 64                	push   $0x64
  jmp alltraps
80105d1e:	e9 1a f7 ff ff       	jmp    8010543d <alltraps>

80105d23 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $101
80105d25:	6a 65                	push   $0x65
  jmp alltraps
80105d27:	e9 11 f7 ff ff       	jmp    8010543d <alltraps>

80105d2c <vector102>:
.globl vector102
vector102:
  pushl $0
80105d2c:	6a 00                	push   $0x0
  pushl $102
80105d2e:	6a 66                	push   $0x66
  jmp alltraps
80105d30:	e9 08 f7 ff ff       	jmp    8010543d <alltraps>

80105d35 <vector103>:
.globl vector103
vector103:
  pushl $0
80105d35:	6a 00                	push   $0x0
  pushl $103
80105d37:	6a 67                	push   $0x67
  jmp alltraps
80105d39:	e9 ff f6 ff ff       	jmp    8010543d <alltraps>

80105d3e <vector104>:
.globl vector104
vector104:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $104
80105d40:	6a 68                	push   $0x68
  jmp alltraps
80105d42:	e9 f6 f6 ff ff       	jmp    8010543d <alltraps>

80105d47 <vector105>:
.globl vector105
vector105:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $105
80105d49:	6a 69                	push   $0x69
  jmp alltraps
80105d4b:	e9 ed f6 ff ff       	jmp    8010543d <alltraps>

80105d50 <vector106>:
.globl vector106
vector106:
  pushl $0
80105d50:	6a 00                	push   $0x0
  pushl $106
80105d52:	6a 6a                	push   $0x6a
  jmp alltraps
80105d54:	e9 e4 f6 ff ff       	jmp    8010543d <alltraps>

80105d59 <vector107>:
.globl vector107
vector107:
  pushl $0
80105d59:	6a 00                	push   $0x0
  pushl $107
80105d5b:	6a 6b                	push   $0x6b
  jmp alltraps
80105d5d:	e9 db f6 ff ff       	jmp    8010543d <alltraps>

80105d62 <vector108>:
.globl vector108
vector108:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $108
80105d64:	6a 6c                	push   $0x6c
  jmp alltraps
80105d66:	e9 d2 f6 ff ff       	jmp    8010543d <alltraps>

80105d6b <vector109>:
.globl vector109
vector109:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $109
80105d6d:	6a 6d                	push   $0x6d
  jmp alltraps
80105d6f:	e9 c9 f6 ff ff       	jmp    8010543d <alltraps>

80105d74 <vector110>:
.globl vector110
vector110:
  pushl $0
80105d74:	6a 00                	push   $0x0
  pushl $110
80105d76:	6a 6e                	push   $0x6e
  jmp alltraps
80105d78:	e9 c0 f6 ff ff       	jmp    8010543d <alltraps>

80105d7d <vector111>:
.globl vector111
vector111:
  pushl $0
80105d7d:	6a 00                	push   $0x0
  pushl $111
80105d7f:	6a 6f                	push   $0x6f
  jmp alltraps
80105d81:	e9 b7 f6 ff ff       	jmp    8010543d <alltraps>

80105d86 <vector112>:
.globl vector112
vector112:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $112
80105d88:	6a 70                	push   $0x70
  jmp alltraps
80105d8a:	e9 ae f6 ff ff       	jmp    8010543d <alltraps>

80105d8f <vector113>:
.globl vector113
vector113:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $113
80105d91:	6a 71                	push   $0x71
  jmp alltraps
80105d93:	e9 a5 f6 ff ff       	jmp    8010543d <alltraps>

80105d98 <vector114>:
.globl vector114
vector114:
  pushl $0
80105d98:	6a 00                	push   $0x0
  pushl $114
80105d9a:	6a 72                	push   $0x72
  jmp alltraps
80105d9c:	e9 9c f6 ff ff       	jmp    8010543d <alltraps>

80105da1 <vector115>:
.globl vector115
vector115:
  pushl $0
80105da1:	6a 00                	push   $0x0
  pushl $115
80105da3:	6a 73                	push   $0x73
  jmp alltraps
80105da5:	e9 93 f6 ff ff       	jmp    8010543d <alltraps>

80105daa <vector116>:
.globl vector116
vector116:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $116
80105dac:	6a 74                	push   $0x74
  jmp alltraps
80105dae:	e9 8a f6 ff ff       	jmp    8010543d <alltraps>

80105db3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $117
80105db5:	6a 75                	push   $0x75
  jmp alltraps
80105db7:	e9 81 f6 ff ff       	jmp    8010543d <alltraps>

80105dbc <vector118>:
.globl vector118
vector118:
  pushl $0
80105dbc:	6a 00                	push   $0x0
  pushl $118
80105dbe:	6a 76                	push   $0x76
  jmp alltraps
80105dc0:	e9 78 f6 ff ff       	jmp    8010543d <alltraps>

80105dc5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105dc5:	6a 00                	push   $0x0
  pushl $119
80105dc7:	6a 77                	push   $0x77
  jmp alltraps
80105dc9:	e9 6f f6 ff ff       	jmp    8010543d <alltraps>

80105dce <vector120>:
.globl vector120
vector120:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $120
80105dd0:	6a 78                	push   $0x78
  jmp alltraps
80105dd2:	e9 66 f6 ff ff       	jmp    8010543d <alltraps>

80105dd7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $121
80105dd9:	6a 79                	push   $0x79
  jmp alltraps
80105ddb:	e9 5d f6 ff ff       	jmp    8010543d <alltraps>

80105de0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105de0:	6a 00                	push   $0x0
  pushl $122
80105de2:	6a 7a                	push   $0x7a
  jmp alltraps
80105de4:	e9 54 f6 ff ff       	jmp    8010543d <alltraps>

80105de9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105de9:	6a 00                	push   $0x0
  pushl $123
80105deb:	6a 7b                	push   $0x7b
  jmp alltraps
80105ded:	e9 4b f6 ff ff       	jmp    8010543d <alltraps>

80105df2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $124
80105df4:	6a 7c                	push   $0x7c
  jmp alltraps
80105df6:	e9 42 f6 ff ff       	jmp    8010543d <alltraps>

80105dfb <vector125>:
.globl vector125
vector125:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $125
80105dfd:	6a 7d                	push   $0x7d
  jmp alltraps
80105dff:	e9 39 f6 ff ff       	jmp    8010543d <alltraps>

80105e04 <vector126>:
.globl vector126
vector126:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $126
80105e06:	6a 7e                	push   $0x7e
  jmp alltraps
80105e08:	e9 30 f6 ff ff       	jmp    8010543d <alltraps>

80105e0d <vector127>:
.globl vector127
vector127:
  pushl $0
80105e0d:	6a 00                	push   $0x0
  pushl $127
80105e0f:	6a 7f                	push   $0x7f
  jmp alltraps
80105e11:	e9 27 f6 ff ff       	jmp    8010543d <alltraps>

80105e16 <vector128>:
.globl vector128
vector128:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $128
80105e18:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105e1d:	e9 1b f6 ff ff       	jmp    8010543d <alltraps>

80105e22 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $129
80105e24:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e29:	e9 0f f6 ff ff       	jmp    8010543d <alltraps>

80105e2e <vector130>:
.globl vector130
vector130:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $130
80105e30:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e35:	e9 03 f6 ff ff       	jmp    8010543d <alltraps>

80105e3a <vector131>:
.globl vector131
vector131:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $131
80105e3c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105e41:	e9 f7 f5 ff ff       	jmp    8010543d <alltraps>

80105e46 <vector132>:
.globl vector132
vector132:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $132
80105e48:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105e4d:	e9 eb f5 ff ff       	jmp    8010543d <alltraps>

80105e52 <vector133>:
.globl vector133
vector133:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $133
80105e54:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105e59:	e9 df f5 ff ff       	jmp    8010543d <alltraps>

80105e5e <vector134>:
.globl vector134
vector134:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $134
80105e60:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105e65:	e9 d3 f5 ff ff       	jmp    8010543d <alltraps>

80105e6a <vector135>:
.globl vector135
vector135:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $135
80105e6c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105e71:	e9 c7 f5 ff ff       	jmp    8010543d <alltraps>

80105e76 <vector136>:
.globl vector136
vector136:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $136
80105e78:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105e7d:	e9 bb f5 ff ff       	jmp    8010543d <alltraps>

80105e82 <vector137>:
.globl vector137
vector137:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $137
80105e84:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105e89:	e9 af f5 ff ff       	jmp    8010543d <alltraps>

80105e8e <vector138>:
.globl vector138
vector138:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $138
80105e90:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105e95:	e9 a3 f5 ff ff       	jmp    8010543d <alltraps>

80105e9a <vector139>:
.globl vector139
vector139:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $139
80105e9c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105ea1:	e9 97 f5 ff ff       	jmp    8010543d <alltraps>

80105ea6 <vector140>:
.globl vector140
vector140:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $140
80105ea8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105ead:	e9 8b f5 ff ff       	jmp    8010543d <alltraps>

80105eb2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $141
80105eb4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105eb9:	e9 7f f5 ff ff       	jmp    8010543d <alltraps>

80105ebe <vector142>:
.globl vector142
vector142:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $142
80105ec0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105ec5:	e9 73 f5 ff ff       	jmp    8010543d <alltraps>

80105eca <vector143>:
.globl vector143
vector143:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $143
80105ecc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105ed1:	e9 67 f5 ff ff       	jmp    8010543d <alltraps>

80105ed6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $144
80105ed8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105edd:	e9 5b f5 ff ff       	jmp    8010543d <alltraps>

80105ee2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $145
80105ee4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105ee9:	e9 4f f5 ff ff       	jmp    8010543d <alltraps>

80105eee <vector146>:
.globl vector146
vector146:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $146
80105ef0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105ef5:	e9 43 f5 ff ff       	jmp    8010543d <alltraps>

80105efa <vector147>:
.globl vector147
vector147:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $147
80105efc:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105f01:	e9 37 f5 ff ff       	jmp    8010543d <alltraps>

80105f06 <vector148>:
.globl vector148
vector148:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $148
80105f08:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105f0d:	e9 2b f5 ff ff       	jmp    8010543d <alltraps>

80105f12 <vector149>:
.globl vector149
vector149:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $149
80105f14:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105f19:	e9 1f f5 ff ff       	jmp    8010543d <alltraps>

80105f1e <vector150>:
.globl vector150
vector150:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $150
80105f20:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f25:	e9 13 f5 ff ff       	jmp    8010543d <alltraps>

80105f2a <vector151>:
.globl vector151
vector151:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $151
80105f2c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f31:	e9 07 f5 ff ff       	jmp    8010543d <alltraps>

80105f36 <vector152>:
.globl vector152
vector152:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $152
80105f38:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105f3d:	e9 fb f4 ff ff       	jmp    8010543d <alltraps>

80105f42 <vector153>:
.globl vector153
vector153:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $153
80105f44:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105f49:	e9 ef f4 ff ff       	jmp    8010543d <alltraps>

80105f4e <vector154>:
.globl vector154
vector154:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $154
80105f50:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105f55:	e9 e3 f4 ff ff       	jmp    8010543d <alltraps>

80105f5a <vector155>:
.globl vector155
vector155:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $155
80105f5c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105f61:	e9 d7 f4 ff ff       	jmp    8010543d <alltraps>

80105f66 <vector156>:
.globl vector156
vector156:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $156
80105f68:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105f6d:	e9 cb f4 ff ff       	jmp    8010543d <alltraps>

80105f72 <vector157>:
.globl vector157
vector157:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $157
80105f74:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105f79:	e9 bf f4 ff ff       	jmp    8010543d <alltraps>

80105f7e <vector158>:
.globl vector158
vector158:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $158
80105f80:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105f85:	e9 b3 f4 ff ff       	jmp    8010543d <alltraps>

80105f8a <vector159>:
.globl vector159
vector159:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $159
80105f8c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105f91:	e9 a7 f4 ff ff       	jmp    8010543d <alltraps>

80105f96 <vector160>:
.globl vector160
vector160:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $160
80105f98:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105f9d:	e9 9b f4 ff ff       	jmp    8010543d <alltraps>

80105fa2 <vector161>:
.globl vector161
vector161:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $161
80105fa4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105fa9:	e9 8f f4 ff ff       	jmp    8010543d <alltraps>

80105fae <vector162>:
.globl vector162
vector162:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $162
80105fb0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105fb5:	e9 83 f4 ff ff       	jmp    8010543d <alltraps>

80105fba <vector163>:
.globl vector163
vector163:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $163
80105fbc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105fc1:	e9 77 f4 ff ff       	jmp    8010543d <alltraps>

80105fc6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $164
80105fc8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105fcd:	e9 6b f4 ff ff       	jmp    8010543d <alltraps>

80105fd2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $165
80105fd4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105fd9:	e9 5f f4 ff ff       	jmp    8010543d <alltraps>

80105fde <vector166>:
.globl vector166
vector166:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $166
80105fe0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105fe5:	e9 53 f4 ff ff       	jmp    8010543d <alltraps>

80105fea <vector167>:
.globl vector167
vector167:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $167
80105fec:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105ff1:	e9 47 f4 ff ff       	jmp    8010543d <alltraps>

80105ff6 <vector168>:
.globl vector168
vector168:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $168
80105ff8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105ffd:	e9 3b f4 ff ff       	jmp    8010543d <alltraps>

80106002 <vector169>:
.globl vector169
vector169:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $169
80106004:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106009:	e9 2f f4 ff ff       	jmp    8010543d <alltraps>

8010600e <vector170>:
.globl vector170
vector170:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $170
80106010:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106015:	e9 23 f4 ff ff       	jmp    8010543d <alltraps>

8010601a <vector171>:
.globl vector171
vector171:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $171
8010601c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106021:	e9 17 f4 ff ff       	jmp    8010543d <alltraps>

80106026 <vector172>:
.globl vector172
vector172:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $172
80106028:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010602d:	e9 0b f4 ff ff       	jmp    8010543d <alltraps>

80106032 <vector173>:
.globl vector173
vector173:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $173
80106034:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106039:	e9 ff f3 ff ff       	jmp    8010543d <alltraps>

8010603e <vector174>:
.globl vector174
vector174:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $174
80106040:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106045:	e9 f3 f3 ff ff       	jmp    8010543d <alltraps>

8010604a <vector175>:
.globl vector175
vector175:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $175
8010604c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106051:	e9 e7 f3 ff ff       	jmp    8010543d <alltraps>

80106056 <vector176>:
.globl vector176
vector176:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $176
80106058:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010605d:	e9 db f3 ff ff       	jmp    8010543d <alltraps>

80106062 <vector177>:
.globl vector177
vector177:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $177
80106064:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106069:	e9 cf f3 ff ff       	jmp    8010543d <alltraps>

8010606e <vector178>:
.globl vector178
vector178:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $178
80106070:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106075:	e9 c3 f3 ff ff       	jmp    8010543d <alltraps>

8010607a <vector179>:
.globl vector179
vector179:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $179
8010607c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106081:	e9 b7 f3 ff ff       	jmp    8010543d <alltraps>

80106086 <vector180>:
.globl vector180
vector180:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $180
80106088:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010608d:	e9 ab f3 ff ff       	jmp    8010543d <alltraps>

80106092 <vector181>:
.globl vector181
vector181:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $181
80106094:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106099:	e9 9f f3 ff ff       	jmp    8010543d <alltraps>

8010609e <vector182>:
.globl vector182
vector182:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $182
801060a0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801060a5:	e9 93 f3 ff ff       	jmp    8010543d <alltraps>

801060aa <vector183>:
.globl vector183
vector183:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $183
801060ac:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801060b1:	e9 87 f3 ff ff       	jmp    8010543d <alltraps>

801060b6 <vector184>:
.globl vector184
vector184:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $184
801060b8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801060bd:	e9 7b f3 ff ff       	jmp    8010543d <alltraps>

801060c2 <vector185>:
.globl vector185
vector185:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $185
801060c4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801060c9:	e9 6f f3 ff ff       	jmp    8010543d <alltraps>

801060ce <vector186>:
.globl vector186
vector186:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $186
801060d0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801060d5:	e9 63 f3 ff ff       	jmp    8010543d <alltraps>

801060da <vector187>:
.globl vector187
vector187:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $187
801060dc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801060e1:	e9 57 f3 ff ff       	jmp    8010543d <alltraps>

801060e6 <vector188>:
.globl vector188
vector188:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $188
801060e8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801060ed:	e9 4b f3 ff ff       	jmp    8010543d <alltraps>

801060f2 <vector189>:
.globl vector189
vector189:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $189
801060f4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801060f9:	e9 3f f3 ff ff       	jmp    8010543d <alltraps>

801060fe <vector190>:
.globl vector190
vector190:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $190
80106100:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106105:	e9 33 f3 ff ff       	jmp    8010543d <alltraps>

8010610a <vector191>:
.globl vector191
vector191:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $191
8010610c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106111:	e9 27 f3 ff ff       	jmp    8010543d <alltraps>

80106116 <vector192>:
.globl vector192
vector192:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $192
80106118:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010611d:	e9 1b f3 ff ff       	jmp    8010543d <alltraps>

80106122 <vector193>:
.globl vector193
vector193:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $193
80106124:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106129:	e9 0f f3 ff ff       	jmp    8010543d <alltraps>

8010612e <vector194>:
.globl vector194
vector194:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $194
80106130:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106135:	e9 03 f3 ff ff       	jmp    8010543d <alltraps>

8010613a <vector195>:
.globl vector195
vector195:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $195
8010613c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106141:	e9 f7 f2 ff ff       	jmp    8010543d <alltraps>

80106146 <vector196>:
.globl vector196
vector196:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $196
80106148:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010614d:	e9 eb f2 ff ff       	jmp    8010543d <alltraps>

80106152 <vector197>:
.globl vector197
vector197:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $197
80106154:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106159:	e9 df f2 ff ff       	jmp    8010543d <alltraps>

8010615e <vector198>:
.globl vector198
vector198:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $198
80106160:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106165:	e9 d3 f2 ff ff       	jmp    8010543d <alltraps>

8010616a <vector199>:
.globl vector199
vector199:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $199
8010616c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106171:	e9 c7 f2 ff ff       	jmp    8010543d <alltraps>

80106176 <vector200>:
.globl vector200
vector200:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $200
80106178:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010617d:	e9 bb f2 ff ff       	jmp    8010543d <alltraps>

80106182 <vector201>:
.globl vector201
vector201:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $201
80106184:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106189:	e9 af f2 ff ff       	jmp    8010543d <alltraps>

8010618e <vector202>:
.globl vector202
vector202:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $202
80106190:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106195:	e9 a3 f2 ff ff       	jmp    8010543d <alltraps>

8010619a <vector203>:
.globl vector203
vector203:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $203
8010619c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801061a1:	e9 97 f2 ff ff       	jmp    8010543d <alltraps>

801061a6 <vector204>:
.globl vector204
vector204:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $204
801061a8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801061ad:	e9 8b f2 ff ff       	jmp    8010543d <alltraps>

801061b2 <vector205>:
.globl vector205
vector205:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $205
801061b4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801061b9:	e9 7f f2 ff ff       	jmp    8010543d <alltraps>

801061be <vector206>:
.globl vector206
vector206:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $206
801061c0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801061c5:	e9 73 f2 ff ff       	jmp    8010543d <alltraps>

801061ca <vector207>:
.globl vector207
vector207:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $207
801061cc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801061d1:	e9 67 f2 ff ff       	jmp    8010543d <alltraps>

801061d6 <vector208>:
.globl vector208
vector208:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $208
801061d8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801061dd:	e9 5b f2 ff ff       	jmp    8010543d <alltraps>

801061e2 <vector209>:
.globl vector209
vector209:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $209
801061e4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801061e9:	e9 4f f2 ff ff       	jmp    8010543d <alltraps>

801061ee <vector210>:
.globl vector210
vector210:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $210
801061f0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801061f5:	e9 43 f2 ff ff       	jmp    8010543d <alltraps>

801061fa <vector211>:
.globl vector211
vector211:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $211
801061fc:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106201:	e9 37 f2 ff ff       	jmp    8010543d <alltraps>

80106206 <vector212>:
.globl vector212
vector212:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $212
80106208:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010620d:	e9 2b f2 ff ff       	jmp    8010543d <alltraps>

80106212 <vector213>:
.globl vector213
vector213:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $213
80106214:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106219:	e9 1f f2 ff ff       	jmp    8010543d <alltraps>

8010621e <vector214>:
.globl vector214
vector214:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $214
80106220:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106225:	e9 13 f2 ff ff       	jmp    8010543d <alltraps>

8010622a <vector215>:
.globl vector215
vector215:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $215
8010622c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106231:	e9 07 f2 ff ff       	jmp    8010543d <alltraps>

80106236 <vector216>:
.globl vector216
vector216:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $216
80106238:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010623d:	e9 fb f1 ff ff       	jmp    8010543d <alltraps>

80106242 <vector217>:
.globl vector217
vector217:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $217
80106244:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106249:	e9 ef f1 ff ff       	jmp    8010543d <alltraps>

8010624e <vector218>:
.globl vector218
vector218:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $218
80106250:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106255:	e9 e3 f1 ff ff       	jmp    8010543d <alltraps>

8010625a <vector219>:
.globl vector219
vector219:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $219
8010625c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106261:	e9 d7 f1 ff ff       	jmp    8010543d <alltraps>

80106266 <vector220>:
.globl vector220
vector220:
  pushl $0
80106266:	6a 00                	push   $0x0
  pushl $220
80106268:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010626d:	e9 cb f1 ff ff       	jmp    8010543d <alltraps>

80106272 <vector221>:
.globl vector221
vector221:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $221
80106274:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106279:	e9 bf f1 ff ff       	jmp    8010543d <alltraps>

8010627e <vector222>:
.globl vector222
vector222:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $222
80106280:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106285:	e9 b3 f1 ff ff       	jmp    8010543d <alltraps>

8010628a <vector223>:
.globl vector223
vector223:
  pushl $0
8010628a:	6a 00                	push   $0x0
  pushl $223
8010628c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106291:	e9 a7 f1 ff ff       	jmp    8010543d <alltraps>

80106296 <vector224>:
.globl vector224
vector224:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $224
80106298:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010629d:	e9 9b f1 ff ff       	jmp    8010543d <alltraps>

801062a2 <vector225>:
.globl vector225
vector225:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $225
801062a4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801062a9:	e9 8f f1 ff ff       	jmp    8010543d <alltraps>

801062ae <vector226>:
.globl vector226
vector226:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $226
801062b0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801062b5:	e9 83 f1 ff ff       	jmp    8010543d <alltraps>

801062ba <vector227>:
.globl vector227
vector227:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $227
801062bc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801062c1:	e9 77 f1 ff ff       	jmp    8010543d <alltraps>

801062c6 <vector228>:
.globl vector228
vector228:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $228
801062c8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801062cd:	e9 6b f1 ff ff       	jmp    8010543d <alltraps>

801062d2 <vector229>:
.globl vector229
vector229:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $229
801062d4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801062d9:	e9 5f f1 ff ff       	jmp    8010543d <alltraps>

801062de <vector230>:
.globl vector230
vector230:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $230
801062e0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801062e5:	e9 53 f1 ff ff       	jmp    8010543d <alltraps>

801062ea <vector231>:
.globl vector231
vector231:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $231
801062ec:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801062f1:	e9 47 f1 ff ff       	jmp    8010543d <alltraps>

801062f6 <vector232>:
.globl vector232
vector232:
  pushl $0
801062f6:	6a 00                	push   $0x0
  pushl $232
801062f8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801062fd:	e9 3b f1 ff ff       	jmp    8010543d <alltraps>

80106302 <vector233>:
.globl vector233
vector233:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $233
80106304:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106309:	e9 2f f1 ff ff       	jmp    8010543d <alltraps>

8010630e <vector234>:
.globl vector234
vector234:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $234
80106310:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106315:	e9 23 f1 ff ff       	jmp    8010543d <alltraps>

8010631a <vector235>:
.globl vector235
vector235:
  pushl $0
8010631a:	6a 00                	push   $0x0
  pushl $235
8010631c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106321:	e9 17 f1 ff ff       	jmp    8010543d <alltraps>

80106326 <vector236>:
.globl vector236
vector236:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $236
80106328:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010632d:	e9 0b f1 ff ff       	jmp    8010543d <alltraps>

80106332 <vector237>:
.globl vector237
vector237:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $237
80106334:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106339:	e9 ff f0 ff ff       	jmp    8010543d <alltraps>

8010633e <vector238>:
.globl vector238
vector238:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $238
80106340:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106345:	e9 f3 f0 ff ff       	jmp    8010543d <alltraps>

8010634a <vector239>:
.globl vector239
vector239:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $239
8010634c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106351:	e9 e7 f0 ff ff       	jmp    8010543d <alltraps>

80106356 <vector240>:
.globl vector240
vector240:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $240
80106358:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010635d:	e9 db f0 ff ff       	jmp    8010543d <alltraps>

80106362 <vector241>:
.globl vector241
vector241:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $241
80106364:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106369:	e9 cf f0 ff ff       	jmp    8010543d <alltraps>

8010636e <vector242>:
.globl vector242
vector242:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $242
80106370:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106375:	e9 c3 f0 ff ff       	jmp    8010543d <alltraps>

8010637a <vector243>:
.globl vector243
vector243:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $243
8010637c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106381:	e9 b7 f0 ff ff       	jmp    8010543d <alltraps>

80106386 <vector244>:
.globl vector244
vector244:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $244
80106388:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010638d:	e9 ab f0 ff ff       	jmp    8010543d <alltraps>

80106392 <vector245>:
.globl vector245
vector245:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $245
80106394:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106399:	e9 9f f0 ff ff       	jmp    8010543d <alltraps>

8010639e <vector246>:
.globl vector246
vector246:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $246
801063a0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801063a5:	e9 93 f0 ff ff       	jmp    8010543d <alltraps>

801063aa <vector247>:
.globl vector247
vector247:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $247
801063ac:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801063b1:	e9 87 f0 ff ff       	jmp    8010543d <alltraps>

801063b6 <vector248>:
.globl vector248
vector248:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $248
801063b8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801063bd:	e9 7b f0 ff ff       	jmp    8010543d <alltraps>

801063c2 <vector249>:
.globl vector249
vector249:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $249
801063c4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801063c9:	e9 6f f0 ff ff       	jmp    8010543d <alltraps>

801063ce <vector250>:
.globl vector250
vector250:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $250
801063d0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801063d5:	e9 63 f0 ff ff       	jmp    8010543d <alltraps>

801063da <vector251>:
.globl vector251
vector251:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $251
801063dc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801063e1:	e9 57 f0 ff ff       	jmp    8010543d <alltraps>

801063e6 <vector252>:
.globl vector252
vector252:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $252
801063e8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801063ed:	e9 4b f0 ff ff       	jmp    8010543d <alltraps>

801063f2 <vector253>:
.globl vector253
vector253:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $253
801063f4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801063f9:	e9 3f f0 ff ff       	jmp    8010543d <alltraps>

801063fe <vector254>:
.globl vector254
vector254:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $254
80106400:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106405:	e9 33 f0 ff ff       	jmp    8010543d <alltraps>

8010640a <vector255>:
.globl vector255
vector255:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $255
8010640c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106411:	e9 27 f0 ff ff       	jmp    8010543d <alltraps>
80106416:	66 90                	xchg   %ax,%ax
80106418:	66 90                	xchg   %ax,%ax
8010641a:	66 90                	xchg   %ax,%ax
8010641c:	66 90                	xchg   %ax,%ax
8010641e:	66 90                	xchg   %ax,%ax

80106420 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	57                   	push   %edi
80106424:	56                   	push   %esi
80106425:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106427:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010642a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010642b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010642e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106431:	8b 1f                	mov    (%edi),%ebx
80106433:	f6 c3 01             	test   $0x1,%bl
80106436:	74 28                	je     80106460 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106438:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010643e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106444:	c1 ee 0a             	shr    $0xa,%esi
}
80106447:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010644a:	89 f2                	mov    %esi,%edx
8010644c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106452:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106455:	5b                   	pop    %ebx
80106456:	5e                   	pop    %esi
80106457:	5f                   	pop    %edi
80106458:	5d                   	pop    %ebp
80106459:	c3                   	ret    
8010645a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106460:	85 c9                	test   %ecx,%ecx
80106462:	74 34                	je     80106498 <walkpgdir+0x78>
80106464:	e8 27 c0 ff ff       	call   80102490 <kalloc>
80106469:	85 c0                	test   %eax,%eax
8010646b:	89 c3                	mov    %eax,%ebx
8010646d:	74 29                	je     80106498 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010646f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106476:	00 
80106477:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010647e:	00 
8010647f:	89 04 24             	mov    %eax,(%esp)
80106482:	e8 19 de ff ff       	call   801042a0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106487:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010648d:	83 c8 07             	or     $0x7,%eax
80106490:	89 07                	mov    %eax,(%edi)
80106492:	eb b0                	jmp    80106444 <walkpgdir+0x24>
80106494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
80106498:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
8010649b:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
8010649d:	5b                   	pop    %ebx
8010649e:	5e                   	pop    %esi
8010649f:	5f                   	pop    %edi
801064a0:	5d                   	pop    %ebp
801064a1:	c3                   	ret    
801064a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	57                   	push   %edi
801064b4:	89 c7                	mov    %eax,%edi
801064b6:	56                   	push   %esi
801064b7:	89 d6                	mov    %edx,%esi
801064b9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801064ba:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064c0:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801064c3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801064c9:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801064cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801064ce:	72 3b                	jb     8010650b <deallocuvm.part.0+0x5b>
801064d0:	eb 5e                	jmp    80106530 <deallocuvm.part.0+0x80>
801064d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801064d8:	8b 10                	mov    (%eax),%edx
801064da:	f6 c2 01             	test   $0x1,%dl
801064dd:	74 22                	je     80106501 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801064df:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801064e5:	74 54                	je     8010653b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
801064e7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801064ed:	89 14 24             	mov    %edx,(%esp)
801064f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801064f3:	e8 e8 bd ff ff       	call   801022e0 <kfree>
      *pte = 0;
801064f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106501:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106507:	39 f3                	cmp    %esi,%ebx
80106509:	73 25                	jae    80106530 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010650b:	31 c9                	xor    %ecx,%ecx
8010650d:	89 da                	mov    %ebx,%edx
8010650f:	89 f8                	mov    %edi,%eax
80106511:	e8 0a ff ff ff       	call   80106420 <walkpgdir>
    if(!pte)
80106516:	85 c0                	test   %eax,%eax
80106518:	75 be                	jne    801064d8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010651a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106520:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106526:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010652c:	39 f3                	cmp    %esi,%ebx
8010652e:	72 db                	jb     8010650b <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106530:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106533:	83 c4 1c             	add    $0x1c,%esp
80106536:	5b                   	pop    %ebx
80106537:	5e                   	pop    %esi
80106538:	5f                   	pop    %edi
80106539:	5d                   	pop    %ebp
8010653a:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010653b:	c7 04 24 26 71 10 80 	movl   $0x80107126,(%esp)
80106542:	e8 19 9e ff ff       	call   80100360 <panic>
80106547:	89 f6                	mov    %esi,%esi
80106549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106550 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106556:	e8 15 d1 ff ff       	call   80103670 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010655b:	31 c9                	xor    %ecx,%ecx
8010655d:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106562:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106568:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010656d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106571:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106576:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106579:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010657d:	31 c9                	xor    %ecx,%ecx
8010657f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106583:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106588:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010658c:	31 c9                	xor    %ecx,%ecx
8010658e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106592:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106597:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010659b:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010659d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801065a1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065a5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801065a9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065ad:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
801065b1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065b5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
801065b9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
801065bd:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801065c1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065c6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
801065ca:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065ce:	c6 40 14 00          	movb   $0x0,0x14(%eax)
801065d2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065d6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
801065da:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801065de:	66 89 48 22          	mov    %cx,0x22(%eax)
801065e2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
801065e6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
801065ea:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801065ee:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801065f2:	c1 e8 10             	shr    $0x10,%eax
801065f5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801065f9:	8d 45 f2             	lea    -0xe(%ebp),%eax
801065fc:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
801065ff:	c9                   	leave  
80106600:	c3                   	ret    
80106601:	eb 0d                	jmp    80106610 <mappages>
80106603:	90                   	nop
80106604:	90                   	nop
80106605:	90                   	nop
80106606:	90                   	nop
80106607:	90                   	nop
80106608:	90                   	nop
80106609:	90                   	nop
8010660a:	90                   	nop
8010660b:	90                   	nop
8010660c:	90                   	nop
8010660d:	90                   	nop
8010660e:	90                   	nop
8010660f:	90                   	nop

80106610 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106610:	55                   	push   %ebp
80106611:	89 e5                	mov    %esp,%ebp
80106613:	57                   	push   %edi
80106614:	56                   	push   %esi
80106615:	53                   	push   %ebx
80106616:	83 ec 1c             	sub    $0x1c,%esp
80106619:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010661c:	8b 55 10             	mov    0x10(%ebp),%edx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010661f:	8b 7d 14             	mov    0x14(%ebp),%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106622:	83 4d 18 01          	orl    $0x1,0x18(%ebp)
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106626:	89 c3                	mov    %eax,%ebx
80106628:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010662e:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
80106632:	29 df                	sub    %ebx,%edi
80106634:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106637:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
8010663e:	eb 15                	jmp    80106655 <mappages+0x45>
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106640:	f6 00 01             	testb  $0x1,(%eax)
80106643:	75 3d                	jne    80106682 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106645:	0b 75 18             	or     0x18(%ebp),%esi
    if(a == last)
80106648:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010664b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010664d:	74 29                	je     80106678 <mappages+0x68>
      break;
    a += PGSIZE;
8010664f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106655:	8b 45 08             	mov    0x8(%ebp),%eax
80106658:	b9 01 00 00 00       	mov    $0x1,%ecx
8010665d:	89 da                	mov    %ebx,%edx
8010665f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106662:	e8 b9 fd ff ff       	call   80106420 <walkpgdir>
80106667:	85 c0                	test   %eax,%eax
80106669:	75 d5                	jne    80106640 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010666b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010666e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106673:	5b                   	pop    %ebx
80106674:	5e                   	pop    %esi
80106675:	5f                   	pop    %edi
80106676:	5d                   	pop    %ebp
80106677:	c3                   	ret    
80106678:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010667b:	31 c0                	xor    %eax,%eax
}
8010667d:	5b                   	pop    %ebx
8010667e:	5e                   	pop    %esi
8010667f:	5f                   	pop    %edi
80106680:	5d                   	pop    %ebp
80106681:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106682:	c7 04 24 08 78 10 80 	movl   $0x80107808,(%esp)
80106689:	e8 d2 9c ff ff       	call   80100360 <panic>
8010668e:	66 90                	xchg   %ax,%ax

80106690 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106690:	a1 c4 56 11 80       	mov    0x801156c4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106695:	55                   	push   %ebp
80106696:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106698:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010669d:	0f 22 d8             	mov    %eax,%cr3
}
801066a0:	5d                   	pop    %ebp
801066a1:	c3                   	ret    
801066a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066b0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	57                   	push   %edi
801066b4:	56                   	push   %esi
801066b5:	53                   	push   %ebx
801066b6:	83 ec 1c             	sub    $0x1c,%esp
801066b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801066bc:	85 f6                	test   %esi,%esi
801066be:	0f 84 cd 00 00 00    	je     80106791 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801066c4:	8b 46 08             	mov    0x8(%esi),%eax
801066c7:	85 c0                	test   %eax,%eax
801066c9:	0f 84 da 00 00 00    	je     801067a9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801066cf:	8b 7e 04             	mov    0x4(%esi),%edi
801066d2:	85 ff                	test   %edi,%edi
801066d4:	0f 84 c3 00 00 00    	je     8010679d <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
801066da:	e8 41 da ff ff       	call   80104120 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801066df:	e8 0c cf ff ff       	call   801035f0 <mycpu>
801066e4:	89 c3                	mov    %eax,%ebx
801066e6:	e8 05 cf ff ff       	call   801035f0 <mycpu>
801066eb:	89 c7                	mov    %eax,%edi
801066ed:	e8 fe ce ff ff       	call   801035f0 <mycpu>
801066f2:	83 c7 08             	add    $0x8,%edi
801066f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066f8:	e8 f3 ce ff ff       	call   801035f0 <mycpu>
801066fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106700:	ba 67 00 00 00       	mov    $0x67,%edx
80106705:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
8010670c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106713:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010671a:	83 c1 08             	add    $0x8,%ecx
8010671d:	c1 e9 10             	shr    $0x10,%ecx
80106720:	83 c0 08             	add    $0x8,%eax
80106723:	c1 e8 18             	shr    $0x18,%eax
80106726:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010672c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106733:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106739:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010673e:	e8 ad ce ff ff       	call   801035f0 <mycpu>
80106743:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010674a:	e8 a1 ce ff ff       	call   801035f0 <mycpu>
8010674f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106754:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106758:	e8 93 ce ff ff       	call   801035f0 <mycpu>
8010675d:	8b 56 08             	mov    0x8(%esi),%edx
80106760:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106766:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106769:	e8 82 ce ff ff       	call   801035f0 <mycpu>
8010676e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106772:	b8 28 00 00 00       	mov    $0x28,%eax
80106777:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010677a:	8b 46 04             	mov    0x4(%esi),%eax
8010677d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106782:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106785:	83 c4 1c             	add    $0x1c,%esp
80106788:	5b                   	pop    %ebx
80106789:	5e                   	pop    %esi
8010678a:	5f                   	pop    %edi
8010678b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010678c:	e9 4f da ff ff       	jmp    801041e0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106791:	c7 04 24 0e 78 10 80 	movl   $0x8010780e,(%esp)
80106798:	e8 c3 9b ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010679d:	c7 04 24 39 78 10 80 	movl   $0x80107839,(%esp)
801067a4:	e8 b7 9b ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801067a9:	c7 04 24 24 78 10 80 	movl   $0x80107824,(%esp)
801067b0:	e8 ab 9b ff ff       	call   80100360 <panic>
801067b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067c0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	57                   	push   %edi
801067c4:	56                   	push   %esi
801067c5:	53                   	push   %ebx
801067c6:	83 ec 2c             	sub    $0x2c,%esp
801067c9:	8b 75 10             	mov    0x10(%ebp),%esi
801067cc:	8b 55 08             	mov    0x8(%ebp),%edx
801067cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801067d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801067d8:	77 64                	ja     8010683e <inituvm+0x7e>
801067da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
801067dd:	e8 ae bc ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
801067e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801067e9:	00 
801067ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067f1:	00 
801067f2:	89 04 24             	mov    %eax,(%esp)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801067f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801067f7:	e8 a4 da ff ff       	call   801042a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801067fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801067ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106805:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010680c:	00 
8010680d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106811:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106818:	00 
80106819:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106820:	00 
80106821:	89 14 24             	mov    %edx,(%esp)
80106824:	e8 e7 fd ff ff       	call   80106610 <mappages>
  memmove(mem, init, sz);
80106829:	89 75 10             	mov    %esi,0x10(%ebp)
8010682c:	89 7d 0c             	mov    %edi,0xc(%ebp)
8010682f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106832:	83 c4 2c             	add    $0x2c,%esp
80106835:	5b                   	pop    %ebx
80106836:	5e                   	pop    %esi
80106837:	5f                   	pop    %edi
80106838:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106839:	e9 02 db ff ff       	jmp    80104340 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
8010683e:	c7 04 24 4d 78 10 80 	movl   $0x8010784d,(%esp)
80106845:	e8 16 9b ff ff       	call   80100360 <panic>
8010684a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106850 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	57                   	push   %edi
80106854:	56                   	push   %esi
80106855:	53                   	push   %ebx
80106856:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106859:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106860:	0f 85 98 00 00 00    	jne    801068fe <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106866:	8b 75 18             	mov    0x18(%ebp),%esi
80106869:	31 db                	xor    %ebx,%ebx
8010686b:	85 f6                	test   %esi,%esi
8010686d:	75 1a                	jne    80106889 <loaduvm+0x39>
8010686f:	eb 77                	jmp    801068e8 <loaduvm+0x98>
80106871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106878:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010687e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106884:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106887:	76 5f                	jbe    801068e8 <loaduvm+0x98>
80106889:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010688c:	31 c9                	xor    %ecx,%ecx
8010688e:	8b 45 08             	mov    0x8(%ebp),%eax
80106891:	01 da                	add    %ebx,%edx
80106893:	e8 88 fb ff ff       	call   80106420 <walkpgdir>
80106898:	85 c0                	test   %eax,%eax
8010689a:	74 56                	je     801068f2 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010689c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010689e:	bf 00 10 00 00       	mov    $0x1000,%edi
801068a3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801068a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
801068ab:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801068b1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801068b4:	05 00 00 00 80       	add    $0x80000000,%eax
801068b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801068bd:	8b 45 10             	mov    0x10(%ebp),%eax
801068c0:	01 d9                	add    %ebx,%ecx
801068c2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801068c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801068ca:	89 04 24             	mov    %eax,(%esp)
801068cd:	e8 7e b0 ff ff       	call   80101950 <readi>
801068d2:	39 f8                	cmp    %edi,%eax
801068d4:	74 a2                	je     80106878 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801068d6:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
801068d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801068de:	5b                   	pop    %ebx
801068df:	5e                   	pop    %esi
801068e0:	5f                   	pop    %edi
801068e1:	5d                   	pop    %ebp
801068e2:	c3                   	ret    
801068e3:	90                   	nop
801068e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068e8:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801068eb:	31 c0                	xor    %eax,%eax
}
801068ed:	5b                   	pop    %ebx
801068ee:	5e                   	pop    %esi
801068ef:	5f                   	pop    %edi
801068f0:	5d                   	pop    %ebp
801068f1:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801068f2:	c7 04 24 67 78 10 80 	movl   $0x80107867,(%esp)
801068f9:	e8 62 9a ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801068fe:	c7 04 24 08 79 10 80 	movl   $0x80107908,(%esp)
80106905:	e8 56 9a ff ff       	call   80100360 <panic>
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106910 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 2c             	sub    $0x2c,%esp
80106919:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz > KERNBASE)
8010691c:	81 ff 00 00 00 80    	cmp    $0x80000000,%edi
80106922:	0f 87 98 00 00 00    	ja     801069c0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
80106928:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
8010692b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz > KERNBASE)
    return 0;
  if(newsz < oldsz)
8010692e:	0f 82 8e 00 00 00    	jb     801069c2 <allocuvm+0xb2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106934:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010693a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106940:	39 df                	cmp    %ebx,%edi
80106942:	77 5b                	ja     8010699f <allocuvm+0x8f>
80106944:	e9 87 00 00 00       	jmp    801069d0 <allocuvm+0xc0>
80106949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106950:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106957:	00 
80106958:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010695f:	00 
80106960:	89 04 24             	mov    %eax,(%esp)
80106963:	e8 38 d9 ff ff       	call   801042a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106968:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010696e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106972:	8b 45 08             	mov    0x8(%ebp),%eax
80106975:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010697c:	00 
8010697d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106984:	00 
80106985:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106989:	89 04 24             	mov    %eax,(%esp)
8010698c:	e8 7f fc ff ff       	call   80106610 <mappages>
80106991:	85 c0                	test   %eax,%eax
80106993:	78 4b                	js     801069e0 <allocuvm+0xd0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106995:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010699b:	39 df                	cmp    %ebx,%edi
8010699d:	76 31                	jbe    801069d0 <allocuvm+0xc0>
    mem = kalloc();
8010699f:	e8 ec ba ff ff       	call   80102490 <kalloc>
    if(mem == 0){
801069a4:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
801069a6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801069a8:	75 a6                	jne    80106950 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801069aa:	c7 04 24 85 78 10 80 	movl   $0x80107885,(%esp)
801069b1:	e8 9a 9c ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801069b6:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069b9:	77 55                	ja     80106a10 <allocuvm+0x100>
801069bb:	90                   	nop
801069bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801069c0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801069c2:	83 c4 2c             	add    $0x2c,%esp
801069c5:	5b                   	pop    %ebx
801069c6:	5e                   	pop    %esi
801069c7:	5f                   	pop    %edi
801069c8:	5d                   	pop    %ebp
801069c9:	c3                   	ret    
801069ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801069d0:	83 c4 2c             	add    $0x2c,%esp
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
  }
  return newsz;
801069d3:	89 f8                	mov    %edi,%eax
}
801069d5:	5b                   	pop    %ebx
801069d6:	5e                   	pop    %esi
801069d7:	5f                   	pop    %edi
801069d8:	5d                   	pop    %ebp
801069d9:	c3                   	ret    
801069da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801069e0:	c7 04 24 9d 78 10 80 	movl   $0x8010789d,(%esp)
801069e7:	e8 64 9c ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801069ec:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069ef:	76 0d                	jbe    801069fe <allocuvm+0xee>
801069f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069f4:	89 fa                	mov    %edi,%edx
801069f6:	8b 45 08             	mov    0x8(%ebp),%eax
801069f9:	e8 b2 fa ff ff       	call   801064b0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801069fe:	89 34 24             	mov    %esi,(%esp)
80106a01:	e8 da b8 ff ff       	call   801022e0 <kfree>
      return 0;
    }
  }
  return newsz;
}
80106a06:	83 c4 2c             	add    $0x2c,%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106a09:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106a0b:	5b                   	pop    %ebx
80106a0c:	5e                   	pop    %esi
80106a0d:	5f                   	pop    %edi
80106a0e:	5d                   	pop    %ebp
80106a0f:	c3                   	ret    
80106a10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a13:	89 fa                	mov    %edi,%edx
80106a15:	8b 45 08             	mov    0x8(%ebp),%eax
80106a18:	e8 93 fa ff ff       	call   801064b0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106a1d:	31 c0                	xor    %eax,%eax
80106a1f:	eb a1                	jmp    801069c2 <allocuvm+0xb2>
80106a21:	eb 0d                	jmp    80106a30 <deallocuvm>
80106a23:	90                   	nop
80106a24:	90                   	nop
80106a25:	90                   	nop
80106a26:	90                   	nop
80106a27:	90                   	nop
80106a28:	90                   	nop
80106a29:	90                   	nop
80106a2a:	90                   	nop
80106a2b:	90                   	nop
80106a2c:	90                   	nop
80106a2d:	90                   	nop
80106a2e:	90                   	nop
80106a2f:	90                   	nop

80106a30 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a36:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106a39:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106a3c:	39 d1                	cmp    %edx,%ecx
80106a3e:	73 08                	jae    80106a48 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a40:	5d                   	pop    %ebp
80106a41:	e9 6a fa ff ff       	jmp    801064b0 <deallocuvm.part.0>
80106a46:	66 90                	xchg   %ax,%ax
80106a48:	89 d0                	mov    %edx,%eax
80106a4a:	5d                   	pop    %ebp
80106a4b:	c3                   	ret    
80106a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a50 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	56                   	push   %esi
80106a54:	53                   	push   %ebx
80106a55:	83 ec 10             	sub    $0x10,%esp
80106a58:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106a5b:	85 f6                	test   %esi,%esi
80106a5d:	74 59                	je     80106ab8 <freevm+0x68>
80106a5f:	31 c9                	xor    %ecx,%ecx
80106a61:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106a66:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a68:	31 db                	xor    %ebx,%ebx
80106a6a:	e8 41 fa ff ff       	call   801064b0 <deallocuvm.part.0>
80106a6f:	eb 12                	jmp    80106a83 <freevm+0x33>
80106a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a78:	83 c3 01             	add    $0x1,%ebx
80106a7b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106a81:	74 27                	je     80106aaa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106a83:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106a86:	f6 c2 01             	test   $0x1,%dl
80106a89:	74 ed                	je     80106a78 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a8b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a91:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a94:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106a9a:	89 14 24             	mov    %edx,(%esp)
80106a9d:	e8 3e b8 ff ff       	call   801022e0 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106aa2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106aa8:	75 d9                	jne    80106a83 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106aaa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106aad:	83 c4 10             	add    $0x10,%esp
80106ab0:	5b                   	pop    %ebx
80106ab1:	5e                   	pop    %esi
80106ab2:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106ab3:	e9 28 b8 ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106ab8:	c7 04 24 b9 78 10 80 	movl   $0x801078b9,(%esp)
80106abf:	e8 9c 98 ff ff       	call   80100360 <panic>
80106ac4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106aca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ad0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	56                   	push   %esi
80106ad4:	53                   	push   %ebx
80106ad5:	83 ec 20             	sub    $0x20,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106ad8:	e8 b3 b9 ff ff       	call   80102490 <kalloc>
80106add:	85 c0                	test   %eax,%eax
80106adf:	89 c6                	mov    %eax,%esi
80106ae1:	74 75                	je     80106b58 <setupkvm+0x88>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106ae3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106aea:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106aeb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106af0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106af7:	00 
80106af8:	89 04 24             	mov    %eax,(%esp)
80106afb:	e8 a0 d7 ff ff       	call   801042a0 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106b00:	8b 53 0c             	mov    0xc(%ebx),%edx
80106b03:	8b 43 04             	mov    0x4(%ebx),%eax
80106b06:	89 34 24             	mov    %esi,(%esp)
80106b09:	89 54 24 10          	mov    %edx,0x10(%esp)
80106b0d:	8b 53 08             	mov    0x8(%ebx),%edx
80106b10:	89 44 24 0c          	mov    %eax,0xc(%esp)
80106b14:	29 c2                	sub    %eax,%edx
80106b16:	8b 03                	mov    (%ebx),%eax
80106b18:	89 54 24 08          	mov    %edx,0x8(%esp)
80106b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b20:	e8 eb fa ff ff       	call   80106610 <mappages>
80106b25:	85 c0                	test   %eax,%eax
80106b27:	78 17                	js     80106b40 <setupkvm+0x70>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b29:	83 c3 10             	add    $0x10,%ebx
80106b2c:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106b32:	72 cc                	jb     80106b00 <setupkvm+0x30>
80106b34:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106b36:	83 c4 20             	add    $0x20,%esp
80106b39:	5b                   	pop    %ebx
80106b3a:	5e                   	pop    %esi
80106b3b:	5d                   	pop    %ebp
80106b3c:	c3                   	ret    
80106b3d:	8d 76 00             	lea    0x0(%esi),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106b40:	89 34 24             	mov    %esi,(%esp)
80106b43:	e8 08 ff ff ff       	call   80106a50 <freevm>
      return 0;
    }
  return pgdir;
}
80106b48:	83 c4 20             	add    $0x20,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106b4b:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106b4d:	5b                   	pop    %ebx
80106b4e:	5e                   	pop    %esi
80106b4f:	5d                   	pop    %ebp
80106b50:	c3                   	ret    
80106b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106b58:	31 c0                	xor    %eax,%eax
80106b5a:	eb da                	jmp    80106b36 <setupkvm+0x66>
80106b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b60 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106b66:	e8 65 ff ff ff       	call   80106ad0 <setupkvm>
80106b6b:	a3 c4 56 11 80       	mov    %eax,0x801156c4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b70:	05 00 00 00 80       	add    $0x80000000,%eax
80106b75:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106b78:	c9                   	leave  
80106b79:	c3                   	ret    
80106b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b80 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b80:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b81:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b83:	89 e5                	mov    %esp,%ebp
80106b85:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b88:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b8e:	e8 8d f8 ff ff       	call   80106420 <walkpgdir>
  if(pte == 0)
80106b93:	85 c0                	test   %eax,%eax
80106b95:	74 05                	je     80106b9c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106b97:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106b9a:	c9                   	leave  
80106b9b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106b9c:	c7 04 24 ca 78 10 80 	movl   $0x801078ca,(%esp)
80106ba3:	e8 b8 97 ff ff       	call   80100360 <panic>
80106ba8:	90                   	nop
80106ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106bb0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint userstack_top)
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	57                   	push   %edi
80106bb4:	56                   	push   %esi
80106bb5:	53                   	push   %ebx
80106bb6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106bb9:	e8 12 ff ff ff       	call   80106ad0 <setupkvm>
80106bbe:	85 c0                	test   %eax,%eax
80106bc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106bc3:	0f 84 62 01 00 00    	je     80106d2b <copyuvm+0x17b>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106bcc:	85 d2                	test   %edx,%edx
80106bce:	0f 84 ac 00 00 00    	je     80106c80 <copyuvm+0xd0>
80106bd4:	31 db                	xor    %ebx,%ebx
80106bd6:	eb 51                	jmp    80106c29 <copyuvm+0x79>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106bd8:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106bde:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106be5:	00 
80106be6:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106bea:	89 04 24             	mov    %eax,(%esp)
80106bed:	e8 4e d7 ff ff       	call   80104340 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106bf2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bf5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106bfb:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106bff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c06:	00 
80106c07:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106c0b:	89 44 24 10          	mov    %eax,0x10(%esp)
80106c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c12:	89 04 24             	mov    %eax,(%esp)
80106c15:	e8 f6 f9 ff ff       	call   80106610 <mappages>
80106c1a:	85 c0                	test   %eax,%eax
80106c1c:	78 4d                	js     80106c6b <copyuvm+0xbb>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106c1e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c24:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80106c27:	76 57                	jbe    80106c80 <copyuvm+0xd0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106c29:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2c:	31 c9                	xor    %ecx,%ecx
80106c2e:	89 da                	mov    %ebx,%edx
80106c30:	e8 eb f7 ff ff       	call   80106420 <walkpgdir>
80106c35:	85 c0                	test   %eax,%eax
80106c37:	0f 84 01 01 00 00    	je     80106d3e <copyuvm+0x18e>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106c3d:	8b 30                	mov    (%eax),%esi
80106c3f:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106c45:	0f 84 e7 00 00 00    	je     80106d32 <copyuvm+0x182>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106c4b:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106c4d:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c53:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106c56:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106c5c:	e8 2f b8 ff ff       	call   80102490 <kalloc>
80106c61:	85 c0                	test   %eax,%eax
80106c63:	89 c6                	mov    %eax,%esi
80106c65:	0f 85 6d ff ff ff    	jne    80106bd8 <copyuvm+0x28>

  return d;


bad:
  freevm(d);
80106c6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c6e:	89 04 24             	mov    %eax,(%esp)
80106c71:	e8 da fd ff ff       	call   80106a50 <freevm>
  return 0;
80106c76:	31 c0                	xor    %eax,%eax
}
80106c78:	83 c4 2c             	add    $0x2c,%esp
80106c7b:	5b                   	pop    %ebx
80106c7c:	5e                   	pop    %esi
80106c7d:	5f                   	pop    %edi
80106c7e:	5d                   	pop    %ebp
80106c7f:	c3                   	ret    
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }

  if(userstack_top == 0) {
80106c80:	8b 45 10             	mov    0x10(%ebp),%eax
80106c83:	8b 5d 10             	mov    0x10(%ebp),%ebx
80106c86:	85 c0                	test   %eax,%eax
80106c88:	7f 54                	jg     80106cde <copyuvm+0x12e>
80106c8a:	e9 91 00 00 00       	jmp    80106d20 <copyuvm+0x170>
80106c8f:	90                   	nop
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0) {
      goto bad;
    }
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106c90:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106c96:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c9d:	00 
80106c9e:	89 7c 24 04          	mov    %edi,0x4(%esp)
80106ca2:	89 04 24             	mov    %eax,(%esp)
80106ca5:	e8 96 d6 ff ff       	call   80104340 <memmove>
    
    //map new copy to child address space by adding PTE to its page table
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106caa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cad:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
80106cb3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80106cb7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106cbe:	00 
80106cbf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106cc3:	89 44 24 10          	mov    %eax,0x10(%esp)
80106cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cca:	89 04 24             	mov    %eax,(%esp)
80106ccd:	e8 3e f9 ff ff       	call   80106610 <mappages>
80106cd2:	85 c0                	test   %eax,%eax
80106cd4:	78 95                	js     80106c6b <copyuvm+0xbb>
  if(userstack_top == 0) {
    return d;
  }

  //Need for loop traversing from top stack to bottom (before KERNBASE), copy the stack
  for(i = userstack_top; i < KERNBASE; i+= PGSIZE) {
80106cd6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106cdc:	78 42                	js     80106d20 <copyuvm+0x170>
    if((pte = walkpgdir(pgdir, (void*)i, 0)) == 0) {
80106cde:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce1:	31 c9                	xor    %ecx,%ecx
80106ce3:	89 da                	mov    %ebx,%edx
80106ce5:	e8 36 f7 ff ff       	call   80106420 <walkpgdir>
80106cea:	85 c0                	test   %eax,%eax
80106cec:	74 5c                	je     80106d4a <copyuvm+0x19a>
      panic("copyuvm error... can't find pte");
    }
    if(!(*pte & PTE_P)) {
80106cee:	8b 30                	mov    (%eax),%esi
80106cf0:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106cf6:	74 5e                	je     80106d56 <copyuvm+0x1a6>
      panic("copyuvm error... page not available on stack");
    }
    pa = PTE_ADDR(*pte);
80106cf8:	89 f7                	mov    %esi,%edi
    flags = PTE_FLAGS(*pte);
80106cfa:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106d00:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      panic("copyuvm error... can't find pte");
    }
    if(!(*pte & PTE_P)) {
      panic("copyuvm error... page not available on stack");
    }
    pa = PTE_ADDR(*pte);
80106d03:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0) {
80106d09:	e8 82 b7 ff ff       	call   80102490 <kalloc>
80106d0e:	85 c0                	test   %eax,%eax
80106d10:	89 c6                	mov    %eax,%esi
80106d12:	0f 85 78 ff ff ff    	jne    80106c90 <copyuvm+0xe0>
80106d18:	e9 4e ff ff ff       	jmp    80106c6b <copyuvm+0xbb>
80106d1d:	8d 76 00             	lea    0x0(%esi),%esi
80106d20:	8b 45 e0             	mov    -0x20(%ebp),%eax


bad:
  freevm(d);
  return 0;
}
80106d23:	83 c4 2c             	add    $0x2c,%esp
80106d26:	5b                   	pop    %ebx
80106d27:	5e                   	pop    %esi
80106d28:	5f                   	pop    %edi
80106d29:	5d                   	pop    %ebp
80106d2a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106d2b:	31 c0                	xor    %eax,%eax
80106d2d:	e9 46 ff ff ff       	jmp    80106c78 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106d32:	c7 04 24 ee 78 10 80 	movl   $0x801078ee,(%esp)
80106d39:	e8 22 96 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106d3e:	c7 04 24 d4 78 10 80 	movl   $0x801078d4,(%esp)
80106d45:	e8 16 96 ff ff       	call   80100360 <panic>
  }

  //Need for loop traversing from top stack to bottom (before KERNBASE), copy the stack
  for(i = userstack_top; i < KERNBASE; i+= PGSIZE) {
    if((pte = walkpgdir(pgdir, (void*)i, 0)) == 0) {
      panic("copyuvm error... can't find pte");
80106d4a:	c7 04 24 2c 79 10 80 	movl   $0x8010792c,(%esp)
80106d51:	e8 0a 96 ff ff       	call   80100360 <panic>
    }
    if(!(*pte & PTE_P)) {
      panic("copyuvm error... page not available on stack");
80106d56:	c7 04 24 4c 79 10 80 	movl   $0x8010794c,(%esp)
80106d5d:	e8 fe 95 ff ff       	call   80100360 <panic>
80106d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d71:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d73:	89 e5                	mov    %esp,%ebp
80106d75:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d78:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d7e:	e8 9d f6 ff ff       	call   80106420 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106d83:	8b 00                	mov    (%eax),%eax
80106d85:	89 c2                	mov    %eax,%edx
80106d87:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106d8a:	83 fa 05             	cmp    $0x5,%edx
80106d8d:	75 11                	jne    80106da0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106d8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d94:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106d99:	c9                   	leave  
80106d9a:	c3                   	ret    
80106d9b:	90                   	nop
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106da0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106da2:	c9                   	leave  
80106da3:	c3                   	ret    
80106da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106db0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	57                   	push   %edi
80106db4:	56                   	push   %esi
80106db5:	53                   	push   %ebx
80106db6:	83 ec 1c             	sub    $0x1c,%esp
80106db9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106dbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dbf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106dc2:	85 db                	test   %ebx,%ebx
80106dc4:	75 3a                	jne    80106e00 <copyout+0x50>
80106dc6:	eb 68                	jmp    80106e30 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106dc8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106dcb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106dcd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106dd1:	29 ca                	sub    %ecx,%edx
80106dd3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106dd9:	39 da                	cmp    %ebx,%edx
80106ddb:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106dde:	29 f1                	sub    %esi,%ecx
80106de0:	01 c8                	add    %ecx,%eax
80106de2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106de6:	89 04 24             	mov    %eax,(%esp)
80106de9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106dec:	e8 4f d5 ff ff       	call   80104340 <memmove>
    len -= n;
    buf += n;
80106df1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106df4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106dfa:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106dfc:	29 d3                	sub    %edx,%ebx
80106dfe:	74 30                	je     80106e30 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80106e00:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106e03:	89 ce                	mov    %ecx,%esi
80106e05:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106e0b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106e0f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106e12:	89 04 24             	mov    %eax,(%esp)
80106e15:	e8 56 ff ff ff       	call   80106d70 <uva2ka>
    if(pa0 == 0)
80106e1a:	85 c0                	test   %eax,%eax
80106e1c:	75 aa                	jne    80106dc8 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106e1e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106e26:	5b                   	pop    %ebx
80106e27:	5e                   	pop    %esi
80106e28:	5f                   	pop    %edi
80106e29:	5d                   	pop    %ebp
80106e2a:	c3                   	ret    
80106e2b:	90                   	nop
80106e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e30:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106e33:	31 c0                	xor    %eax,%eax
}
80106e35:	5b                   	pop    %ebx
80106e36:	5e                   	pop    %esi
80106e37:	5f                   	pop    %edi
80106e38:	5d                   	pop    %ebp
80106e39:	c3                   	ret    
80106e3a:	66 90                	xchg   %ax,%ax
80106e3c:	66 90                	xchg   %ax,%ax
80106e3e:	66 90                	xchg   %ax,%ax

80106e40 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 18             	sub    $0x18,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106e46:	c7 44 24 04 7c 79 10 	movl   $0x8010797c,0x4(%esp)
80106e4d:	80 
80106e4e:	c7 04 24 e0 56 11 80 	movl   $0x801156e0,(%esp)
80106e55:	e8 16 d2 ff ff       	call   80104070 <initlock>
  acquire(&(shm_table.lock));
80106e5a:	c7 04 24 e0 56 11 80 	movl   $0x801156e0,(%esp)
80106e61:	e8 fa d2 ff ff       	call   80104160 <acquire>
80106e66:	b8 14 57 11 80       	mov    $0x80115714,%eax
80106e6b:	90                   	nop
80106e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106e70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106e76:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].frame =0;
80106e79:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    shm_table.shm_pages[i].refcnt =0;
80106e80:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
80106e87:	3d 14 5a 11 80       	cmp    $0x80115a14,%eax
80106e8c:	75 e2                	jne    80106e70 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
80106e8e:	c7 04 24 e0 56 11 80 	movl   $0x801156e0,(%esp)
80106e95:	e8 b6 d3 ff ff       	call   80104250 <release>
}
80106e9a:	c9                   	leave  
80106e9b:	c3                   	ret    
80106e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ea0 <shm_open>:


int shm_open(int id, char **pointer) {
80106ea0:	55                   	push   %ebp
  return 0;
}
80106ea1:	31 c0                	xor    %eax,%eax
  }
  release(&(shm_table.lock));
}


int shm_open(int id, char **pointer) {
80106ea3:	89 e5                	mov    %esp,%ebp
  return 0;
}
80106ea5:	5d                   	pop    %ebp
80106ea6:	c3                   	ret    
80106ea7:	89 f6                	mov    %esi,%esi
80106ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106eb0 <shm_close>:


int shm_close(int id) {
80106eb0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106eb1:	31 c0                	xor    %eax,%eax
int shm_open(int id, char **pointer) {
  return 0;
}


int shm_close(int id) {
80106eb3:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106eb5:	5d                   	pop    %ebp
80106eb6:	c3                   	ret    
