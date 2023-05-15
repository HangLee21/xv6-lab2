
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a0013103          	ld	sp,-1536(sp) # 80008a00 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	796050ef          	jal	ra,800057ac <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	09078793          	addi	a5,a5,144 # 800220c0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	a0090913          	addi	s2,s2,-1536 # 80008a50 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	152080e7          	jalr	338(ra) # 800061ac <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1f2080e7          	jalr	498(ra) # 80006260 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	bd8080e7          	jalr	-1064(ra) # 80005c62 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	96450513          	addi	a0,a0,-1692 # 80008a50 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	028080e7          	jalr	40(ra) # 8000611c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	fc050513          	addi	a0,a0,-64 # 800220c0 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	92e48493          	addi	s1,s1,-1746 # 80008a50 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	080080e7          	jalr	128(ra) # 800061ac <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	91650513          	addi	a0,a0,-1770 # 80008a50 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	11c080e7          	jalr	284(ra) # 80006260 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	8ea50513          	addi	a0,a0,-1814 # 80008a50 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	0f2080e7          	jalr	242(ra) # 80006260 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	afe080e7          	jalr	-1282(ra) # 80000e2c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	6ea70713          	addi	a4,a4,1770 # 80008a20 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ae2080e7          	jalr	-1310(ra) # 80000e2c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	950080e7          	jalr	-1712(ra) # 80005cac <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	790080e7          	jalr	1936(ra) # 80001afc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	d8c080e7          	jalr	-628(ra) # 80005100 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fda080e7          	jalr	-38(ra) # 80001356 <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	7f0080e7          	jalr	2032(ra) # 80005b74 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	b06080e7          	jalr	-1274(ra) # 80005e92 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	910080e7          	jalr	-1776(ra) # 80005cac <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	900080e7          	jalr	-1792(ra) # 80005cac <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	8f0080e7          	jalr	-1808(ra) # 80005cac <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	326080e7          	jalr	806(ra) # 800006f2 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	99c080e7          	jalr	-1636(ra) # 80000d78 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6f0080e7          	jalr	1776(ra) # 80001ad4 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	710080e7          	jalr	1808(ra) # 80001afc <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	cf6080e7          	jalr	-778(ra) # 800050ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d04080e7          	jalr	-764(ra) # 80005100 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	eb6080e7          	jalr	-330(ra) # 800022ba <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	55a080e7          	jalr	1370(ra) # 80002966 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	4f8080e7          	jalr	1272(ra) # 8000390c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	dec080e7          	jalr	-532(ra) # 80005208 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d10080e7          	jalr	-752(ra) # 80001134 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	5ef72723          	sw	a5,1518(a4) # 80008a20 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	5e27b783          	ld	a5,1506(a5) # 80008a28 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00005097          	auipc	ra,0x5
    80000496:	7d0080e7          	jalr	2000(ra) # 80005c62 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000562:	c205                	beqz	a2,80000582 <mappages+0x36>
    80000564:	8aaa                	mv	s5,a0
    80000566:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000568:	77fd                	lui	a5,0xfffff
    8000056a:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056e:	15fd                	addi	a1,a1,-1
    80000570:	00c589b3          	add	s3,a1,a2
    80000574:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000578:	8952                	mv	s2,s4
    8000057a:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a015                	j	800005a4 <mappages+0x58>
    panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00005097          	auipc	ra,0x5
    8000058e:	6d8080e7          	jalr	1752(ra) # 80005c62 <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00005097          	auipc	ra,0x5
    8000059e:	6c8080e7          	jalr	1736(ra) # 80005c62 <panic>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
  for(;;){
    800005a4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	4605                	li	a2,1
    800005aa:	85ca                	mv	a1,s2
    800005ac:	8556                	mv	a0,s5
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	eb6080e7          	jalr	-330(ra) # 80000464 <walk>
    800005b6:	cd19                	beqz	a0,800005d4 <mappages+0x88>
    if(*pte & PTE_V)
    800005b8:	611c                	ld	a5,0(a0)
    800005ba:	8b85                	andi	a5,a5,1
    800005bc:	fbf9                	bnez	a5,80000592 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005be:	80b1                	srli	s1,s1,0xc
    800005c0:	04aa                	slli	s1,s1,0xa
    800005c2:	0164e4b3          	or	s1,s1,s6
    800005c6:	0014e493          	ori	s1,s1,1
    800005ca:	e104                	sd	s1,0(a0)
    if(a == last)
    800005cc:	fd391be3          	bne	s2,s3,800005a2 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005d0:	4501                	li	a0,0
    800005d2:	a011                	j	800005d6 <mappages+0x8a>
      return -1;
    800005d4:	557d                	li	a0,-1
}
    800005d6:	60a6                	ld	ra,72(sp)
    800005d8:	6406                	ld	s0,64(sp)
    800005da:	74e2                	ld	s1,56(sp)
    800005dc:	7942                	ld	s2,48(sp)
    800005de:	79a2                	ld	s3,40(sp)
    800005e0:	7a02                	ld	s4,32(sp)
    800005e2:	6ae2                	ld	s5,24(sp)
    800005e4:	6b42                	ld	s6,16(sp)
    800005e6:	6ba2                	ld	s7,8(sp)
    800005e8:	6161                	addi	sp,sp,80
    800005ea:	8082                	ret

00000000800005ec <kvmmap>:
{
    800005ec:	1141                	addi	sp,sp,-16
    800005ee:	e406                	sd	ra,8(sp)
    800005f0:	e022                	sd	s0,0(sp)
    800005f2:	0800                	addi	s0,sp,16
    800005f4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f6:	86b2                	mv	a3,a2
    800005f8:	863e                	mv	a2,a5
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	f52080e7          	jalr	-174(ra) # 8000054c <mappages>
    80000602:	e509                	bnez	a0,8000060c <kvmmap+0x20>
}
    80000604:	60a2                	ld	ra,8(sp)
    80000606:	6402                	ld	s0,0(sp)
    80000608:	0141                	addi	sp,sp,16
    8000060a:	8082                	ret
    panic("kvmmap");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a6c50513          	addi	a0,a0,-1428 # 80008078 <etext+0x78>
    80000614:	00005097          	auipc	ra,0x5
    80000618:	64e080e7          	jalr	1614(ra) # 80005c62 <panic>

000000008000061c <kvmmake>:
{
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	e04a                	sd	s2,0(sp)
    80000626:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	af0080e7          	jalr	-1296(ra) # 80000118 <kalloc>
    80000630:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000632:	6605                	lui	a2,0x1
    80000634:	4581                	li	a1,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	b42080e7          	jalr	-1214(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063e:	4719                	li	a4,6
    80000640:	6685                	lui	a3,0x1
    80000642:	10000637          	lui	a2,0x10000
    80000646:	100005b7          	lui	a1,0x10000
    8000064a:	8526                	mv	a0,s1
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	fa0080e7          	jalr	-96(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10001637          	lui	a2,0x10001
    8000065c:	100015b7          	lui	a1,0x10001
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	f8a080e7          	jalr	-118(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	004006b7          	lui	a3,0x400
    80000670:	0c000637          	lui	a2,0xc000
    80000674:	0c0005b7          	lui	a1,0xc000
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	f72080e7          	jalr	-142(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000682:	00008917          	auipc	s2,0x8
    80000686:	97e90913          	addi	s2,s2,-1666 # 80008000 <etext>
    8000068a:	4729                	li	a4,10
    8000068c:	80008697          	auipc	a3,0x80008
    80000690:	97468693          	addi	a3,a3,-1676 # 8000 <_entry-0x7fff8000>
    80000694:	4605                	li	a2,1
    80000696:	067e                	slli	a2,a2,0x1f
    80000698:	85b2                	mv	a1,a2
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f50080e7          	jalr	-176(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a4:	4719                	li	a4,6
    800006a6:	46c5                	li	a3,17
    800006a8:	06ee                	slli	a3,a3,0x1b
    800006aa:	412686b3          	sub	a3,a3,s2
    800006ae:	864a                	mv	a2,s2
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8526                	mv	a0,s1
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f38080e7          	jalr	-200(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006bc:	4729                	li	a4,10
    800006be:	6685                	lui	a3,0x1
    800006c0:	00007617          	auipc	a2,0x7
    800006c4:	94060613          	addi	a2,a2,-1728 # 80007000 <_trampoline>
    800006c8:	040005b7          	lui	a1,0x4000
    800006cc:	15fd                	addi	a1,a1,-1
    800006ce:	05b2                	slli	a1,a1,0xc
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f1a080e7          	jalr	-230(ra) # 800005ec <kvmmap>
  proc_mapstacks(kpgtbl);
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	606080e7          	jalr	1542(ra) # 80000ce2 <proc_mapstacks>
}
    800006e4:	8526                	mv	a0,s1
    800006e6:	60e2                	ld	ra,24(sp)
    800006e8:	6442                	ld	s0,16(sp)
    800006ea:	64a2                	ld	s1,8(sp)
    800006ec:	6902                	ld	s2,0(sp)
    800006ee:	6105                	addi	sp,sp,32
    800006f0:	8082                	ret

00000000800006f2 <kvminit>:
{
    800006f2:	1141                	addi	sp,sp,-16
    800006f4:	e406                	sd	ra,8(sp)
    800006f6:	e022                	sd	s0,0(sp)
    800006f8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f22080e7          	jalr	-222(ra) # 8000061c <kvmmake>
    80000702:	00008797          	auipc	a5,0x8
    80000706:	32a7b323          	sd	a0,806(a5) # 80008a28 <kernel_pagetable>
}
    8000070a:	60a2                	ld	ra,8(sp)
    8000070c:	6402                	ld	s0,0(sp)
    8000070e:	0141                	addi	sp,sp,16
    80000710:	8082                	ret

0000000080000712 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000712:	715d                	addi	sp,sp,-80
    80000714:	e486                	sd	ra,72(sp)
    80000716:	e0a2                	sd	s0,64(sp)
    80000718:	fc26                	sd	s1,56(sp)
    8000071a:	f84a                	sd	s2,48(sp)
    8000071c:	f44e                	sd	s3,40(sp)
    8000071e:	f052                	sd	s4,32(sp)
    80000720:	ec56                	sd	s5,24(sp)
    80000722:	e85a                	sd	s6,16(sp)
    80000724:	e45e                	sd	s7,8(sp)
    80000726:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000728:	03459793          	slli	a5,a1,0x34
    8000072c:	e795                	bnez	a5,80000758 <uvmunmap+0x46>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	892e                	mv	s2,a1
    80000732:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	0632                	slli	a2,a2,0xc
    80000736:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000073a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000073c:	6b05                	lui	s6,0x1
    8000073e:	0735e863          	bltu	a1,s3,800007ae <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000742:	60a6                	ld	ra,72(sp)
    80000744:	6406                	ld	s0,64(sp)
    80000746:	74e2                	ld	s1,56(sp)
    80000748:	7942                	ld	s2,48(sp)
    8000074a:	79a2                	ld	s3,40(sp)
    8000074c:	7a02                	ld	s4,32(sp)
    8000074e:	6ae2                	ld	s5,24(sp)
    80000750:	6b42                	ld	s6,16(sp)
    80000752:	6ba2                	ld	s7,8(sp)
    80000754:	6161                	addi	sp,sp,80
    80000756:	8082                	ret
    panic("uvmunmap: not aligned");
    80000758:	00008517          	auipc	a0,0x8
    8000075c:	92850513          	addi	a0,a0,-1752 # 80008080 <etext+0x80>
    80000760:	00005097          	auipc	ra,0x5
    80000764:	502080e7          	jalr	1282(ra) # 80005c62 <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	4f2080e7          	jalr	1266(ra) # 80005c62 <panic>
      panic("uvmunmap: not mapped");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	4e2080e7          	jalr	1250(ra) # 80005c62 <panic>
      panic("uvmunmap: not a leaf");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	93850513          	addi	a0,a0,-1736 # 800080c0 <etext+0xc0>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	4d2080e7          	jalr	1234(ra) # 80005c62 <panic>
      uint64 pa = PTE2PA(*pte);
    80000798:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000079a:	0532                	slli	a0,a0,0xc
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	880080e7          	jalr	-1920(ra) # 8000001c <kfree>
    *pte = 0;
    800007a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a8:	995a                	add	s2,s2,s6
    800007aa:	f9397ce3          	bgeu	s2,s3,80000742 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007ae:	4601                	li	a2,0
    800007b0:	85ca                	mv	a1,s2
    800007b2:	8552                	mv	a0,s4
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	cb0080e7          	jalr	-848(ra) # 80000464 <walk>
    800007bc:	84aa                	mv	s1,a0
    800007be:	d54d                	beqz	a0,80000768 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007c0:	6108                	ld	a0,0(a0)
    800007c2:	00157793          	andi	a5,a0,1
    800007c6:	dbcd                	beqz	a5,80000778 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c8:	3ff57793          	andi	a5,a0,1023
    800007cc:	fb778ee3          	beq	a5,s7,80000788 <uvmunmap+0x76>
    if(do_free){
    800007d0:	fc0a8ae3          	beqz	s5,800007a4 <uvmunmap+0x92>
    800007d4:	b7d1                	j	80000798 <uvmunmap+0x86>

00000000800007d6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	938080e7          	jalr	-1736(ra) # 80000118 <kalloc>
    800007e8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007ea:	c519                	beqz	a0,800007f8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ec:	6605                	lui	a2,0x1
    800007ee:	4581                	li	a1,0
    800007f0:	00000097          	auipc	ra,0x0
    800007f4:	988080e7          	jalr	-1656(ra) # 80000178 <memset>
  return pagetable;
}
    800007f8:	8526                	mv	a0,s1
    800007fa:	60e2                	ld	ra,24(sp)
    800007fc:	6442                	ld	s0,16(sp)
    800007fe:	64a2                	ld	s1,8(sp)
    80000800:	6105                	addi	sp,sp,32
    80000802:	8082                	ret

0000000080000804 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000804:	7179                	addi	sp,sp,-48
    80000806:	f406                	sd	ra,40(sp)
    80000808:	f022                	sd	s0,32(sp)
    8000080a:	ec26                	sd	s1,24(sp)
    8000080c:	e84a                	sd	s2,16(sp)
    8000080e:	e44e                	sd	s3,8(sp)
    80000810:	e052                	sd	s4,0(sp)
    80000812:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000814:	6785                	lui	a5,0x1
    80000816:	04f67863          	bgeu	a2,a5,80000866 <uvmfirst+0x62>
    8000081a:	8a2a                	mv	s4,a0
    8000081c:	89ae                	mv	s3,a1
    8000081e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	8f8080e7          	jalr	-1800(ra) # 80000118 <kalloc>
    80000828:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	94a080e7          	jalr	-1718(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000836:	4779                	li	a4,30
    80000838:	86ca                	mv	a3,s2
    8000083a:	6605                	lui	a2,0x1
    8000083c:	4581                	li	a1,0
    8000083e:	8552                	mv	a0,s4
    80000840:	00000097          	auipc	ra,0x0
    80000844:	d0c080e7          	jalr	-756(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    80000848:	8626                	mv	a2,s1
    8000084a:	85ce                	mv	a1,s3
    8000084c:	854a                	mv	a0,s2
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	98a080e7          	jalr	-1654(ra) # 800001d8 <memmove>
}
    80000856:	70a2                	ld	ra,40(sp)
    80000858:	7402                	ld	s0,32(sp)
    8000085a:	64e2                	ld	s1,24(sp)
    8000085c:	6942                	ld	s2,16(sp)
    8000085e:	69a2                	ld	s3,8(sp)
    80000860:	6a02                	ld	s4,0(sp)
    80000862:	6145                	addi	sp,sp,48
    80000864:	8082                	ret
    panic("uvmfirst: more than a page");
    80000866:	00008517          	auipc	a0,0x8
    8000086a:	87250513          	addi	a0,a0,-1934 # 800080d8 <etext+0xd8>
    8000086e:	00005097          	auipc	ra,0x5
    80000872:	3f4080e7          	jalr	1012(ra) # 80005c62 <panic>

0000000080000876 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000876:	1101                	addi	sp,sp,-32
    80000878:	ec06                	sd	ra,24(sp)
    8000087a:	e822                	sd	s0,16(sp)
    8000087c:	e426                	sd	s1,8(sp)
    8000087e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000880:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000882:	00b67d63          	bgeu	a2,a1,8000089c <uvmdealloc+0x26>
    80000886:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000888:	6785                	lui	a5,0x1
    8000088a:	17fd                	addi	a5,a5,-1
    8000088c:	00f60733          	add	a4,a2,a5
    80000890:	767d                	lui	a2,0xfffff
    80000892:	8f71                	and	a4,a4,a2
    80000894:	97ae                	add	a5,a5,a1
    80000896:	8ff1                	and	a5,a5,a2
    80000898:	00f76863          	bltu	a4,a5,800008a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089c:	8526                	mv	a0,s1
    8000089e:	60e2                	ld	ra,24(sp)
    800008a0:	6442                	ld	s0,16(sp)
    800008a2:	64a2                	ld	s1,8(sp)
    800008a4:	6105                	addi	sp,sp,32
    800008a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a8:	8f99                	sub	a5,a5,a4
    800008aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ac:	4685                	li	a3,1
    800008ae:	0007861b          	sext.w	a2,a5
    800008b2:	85ba                	mv	a1,a4
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	e5e080e7          	jalr	-418(ra) # 80000712 <uvmunmap>
    800008bc:	b7c5                	j	8000089c <uvmdealloc+0x26>

00000000800008be <uvmalloc>:
  if(newsz < oldsz)
    800008be:	0ab66563          	bltu	a2,a1,80000968 <uvmalloc+0xaa>
{
    800008c2:	7139                	addi	sp,sp,-64
    800008c4:	fc06                	sd	ra,56(sp)
    800008c6:	f822                	sd	s0,48(sp)
    800008c8:	f426                	sd	s1,40(sp)
    800008ca:	f04a                	sd	s2,32(sp)
    800008cc:	ec4e                	sd	s3,24(sp)
    800008ce:	e852                	sd	s4,16(sp)
    800008d0:	e456                	sd	s5,8(sp)
    800008d2:	e05a                	sd	s6,0(sp)
    800008d4:	0080                	addi	s0,sp,64
    800008d6:	8aaa                	mv	s5,a0
    800008d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008da:	6985                	lui	s3,0x1
    800008dc:	19fd                	addi	s3,s3,-1
    800008de:	95ce                	add	a1,a1,s3
    800008e0:	79fd                	lui	s3,0xfffff
    800008e2:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e6:	08c9f363          	bgeu	s3,a2,8000096c <uvmalloc+0xae>
    800008ea:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008ec:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	828080e7          	jalr	-2008(ra) # 80000118 <kalloc>
    800008f8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008fa:	c51d                	beqz	a0,80000928 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008fc:	6605                	lui	a2,0x1
    800008fe:	4581                	li	a1,0
    80000900:	00000097          	auipc	ra,0x0
    80000904:	878080e7          	jalr	-1928(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000908:	875a                	mv	a4,s6
    8000090a:	86a6                	mv	a3,s1
    8000090c:	6605                	lui	a2,0x1
    8000090e:	85ca                	mv	a1,s2
    80000910:	8556                	mv	a0,s5
    80000912:	00000097          	auipc	ra,0x0
    80000916:	c3a080e7          	jalr	-966(ra) # 8000054c <mappages>
    8000091a:	e90d                	bnez	a0,8000094c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000091c:	6785                	lui	a5,0x1
    8000091e:	993e                	add	s2,s2,a5
    80000920:	fd4968e3          	bltu	s2,s4,800008f0 <uvmalloc+0x32>
  return newsz;
    80000924:	8552                	mv	a0,s4
    80000926:	a809                	j	80000938 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000928:	864e                	mv	a2,s3
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	f48080e7          	jalr	-184(ra) # 80000876 <uvmdealloc>
      return 0;
    80000936:	4501                	li	a0,0
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	74a2                	ld	s1,40(sp)
    8000093e:	7902                	ld	s2,32(sp)
    80000940:	69e2                	ld	s3,24(sp)
    80000942:	6a42                	ld	s4,16(sp)
    80000944:	6aa2                	ld	s5,8(sp)
    80000946:	6b02                	ld	s6,0(sp)
    80000948:	6121                	addi	sp,sp,64
    8000094a:	8082                	ret
      kfree(mem);
    8000094c:	8526                	mv	a0,s1
    8000094e:	fffff097          	auipc	ra,0xfffff
    80000952:	6ce080e7          	jalr	1742(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000956:	864e                	mv	a2,s3
    80000958:	85ca                	mv	a1,s2
    8000095a:	8556                	mv	a0,s5
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	f1a080e7          	jalr	-230(ra) # 80000876 <uvmdealloc>
      return 0;
    80000964:	4501                	li	a0,0
    80000966:	bfc9                	j	80000938 <uvmalloc+0x7a>
    return oldsz;
    80000968:	852e                	mv	a0,a1
}
    8000096a:	8082                	ret
  return newsz;
    8000096c:	8532                	mv	a0,a2
    8000096e:	b7e9                	j	80000938 <uvmalloc+0x7a>

0000000080000970 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000970:	7179                	addi	sp,sp,-48
    80000972:	f406                	sd	ra,40(sp)
    80000974:	f022                	sd	s0,32(sp)
    80000976:	ec26                	sd	s1,24(sp)
    80000978:	e84a                	sd	s2,16(sp)
    8000097a:	e44e                	sd	s3,8(sp)
    8000097c:	e052                	sd	s4,0(sp)
    8000097e:	1800                	addi	s0,sp,48
    80000980:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000982:	84aa                	mv	s1,a0
    80000984:	6905                	lui	s2,0x1
    80000986:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000988:	4985                	li	s3,1
    8000098a:	a821                	j	800009a2 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000098e:	0532                	slli	a0,a0,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fe0080e7          	jalr	-32(ra) # 80000970 <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009a2:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f57793          	andi	a5,a0,15
    800009a8:	ff3782e3          	beq	a5,s3,8000098c <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8905                	andi	a0,a0,1
    800009ae:	d57d                	beqz	a0,8000099c <freewalk+0x2c>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	2aa080e7          	jalr	682(ra) # 80005c62 <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f86080e7          	jalr	-122(ra) # 80000970 <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6605                	lui	a2,0x1
    800009fe:	167d                	addi	a2,a2,-1
    80000a00:	962e                	add	a2,a2,a1
    80000a02:	4685                	li	a3,1
    80000a04:	8231                	srli	a2,a2,0xc
    80000a06:	4581                	li	a1,0
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	d0a080e7          	jalr	-758(ra) # 80000712 <uvmunmap>
    80000a10:	bfe1                	j	800009e8 <uvmfree+0xe>

0000000080000a12 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a12:	c679                	beqz	a2,80000ae0 <uvmcopy+0xce>
{
    80000a14:	715d                	addi	sp,sp,-80
    80000a16:	e486                	sd	ra,72(sp)
    80000a18:	e0a2                	sd	s0,64(sp)
    80000a1a:	fc26                	sd	s1,56(sp)
    80000a1c:	f84a                	sd	s2,48(sp)
    80000a1e:	f44e                	sd	s3,40(sp)
    80000a20:	f052                	sd	s4,32(sp)
    80000a22:	ec56                	sd	s5,24(sp)
    80000a24:	e85a                	sd	s6,16(sp)
    80000a26:	e45e                	sd	s7,8(sp)
    80000a28:	0880                	addi	s0,sp,80
    80000a2a:	8b2a                	mv	s6,a0
    80000a2c:	8aae                	mv	s5,a1
    80000a2e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a30:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a32:	4601                	li	a2,0
    80000a34:	85ce                	mv	a1,s3
    80000a36:	855a                	mv	a0,s6
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	a2c080e7          	jalr	-1492(ra) # 80000464 <walk>
    80000a40:	c531                	beqz	a0,80000a8c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a42:	6118                	ld	a4,0(a0)
    80000a44:	00177793          	andi	a5,a4,1
    80000a48:	cbb1                	beqz	a5,80000a9c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4a:	00a75593          	srli	a1,a4,0xa
    80000a4e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a52:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	6c2080e7          	jalr	1730(ra) # 80000118 <kalloc>
    80000a5e:	892a                	mv	s2,a0
    80000a60:	c939                	beqz	a0,80000ab6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85de                	mv	a1,s7
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	772080e7          	jalr	1906(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6e:	8726                	mv	a4,s1
    80000a70:	86ca                	mv	a3,s2
    80000a72:	6605                	lui	a2,0x1
    80000a74:	85ce                	mv	a1,s3
    80000a76:	8556                	mv	a0,s5
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	ad4080e7          	jalr	-1324(ra) # 8000054c <mappages>
    80000a80:	e515                	bnez	a0,80000aac <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a82:	6785                	lui	a5,0x1
    80000a84:	99be                	add	s3,s3,a5
    80000a86:	fb49e6e3          	bltu	s3,s4,80000a32 <uvmcopy+0x20>
    80000a8a:	a081                	j	80000aca <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8c:	00007517          	auipc	a0,0x7
    80000a90:	67c50513          	addi	a0,a0,1660 # 80008108 <etext+0x108>
    80000a94:	00005097          	auipc	ra,0x5
    80000a98:	1ce080e7          	jalr	462(ra) # 80005c62 <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	1be080e7          	jalr	446(ra) # 80005c62 <panic>
      kfree(mem);
    80000aac:	854a                	mv	a0,s2
    80000aae:	fffff097          	auipc	ra,0xfffff
    80000ab2:	56e080e7          	jalr	1390(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab6:	4685                	li	a3,1
    80000ab8:	00c9d613          	srli	a2,s3,0xc
    80000abc:	4581                	li	a1,0
    80000abe:	8556                	mv	a0,s5
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	c52080e7          	jalr	-942(ra) # 80000712 <uvmunmap>
  return -1;
    80000ac8:	557d                	li	a0,-1
}
    80000aca:	60a6                	ld	ra,72(sp)
    80000acc:	6406                	ld	s0,64(sp)
    80000ace:	74e2                	ld	s1,56(sp)
    80000ad0:	7942                	ld	s2,48(sp)
    80000ad2:	79a2                	ld	s3,40(sp)
    80000ad4:	7a02                	ld	s4,32(sp)
    80000ad6:	6ae2                	ld	s5,24(sp)
    80000ad8:	6b42                	ld	s6,16(sp)
    80000ada:	6ba2                	ld	s7,8(sp)
    80000adc:	6161                	addi	sp,sp,80
    80000ade:	8082                	ret
  return 0;
    80000ae0:	4501                	li	a0,0
}
    80000ae2:	8082                	ret

0000000080000ae4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae4:	1141                	addi	sp,sp,-16
    80000ae6:	e406                	sd	ra,8(sp)
    80000ae8:	e022                	sd	s0,0(sp)
    80000aea:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aec:	4601                	li	a2,0
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	976080e7          	jalr	-1674(ra) # 80000464 <walk>
  if(pte == 0)
    80000af6:	c901                	beqz	a0,80000b06 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af8:	611c                	ld	a5,0(a0)
    80000afa:	9bbd                	andi	a5,a5,-17
    80000afc:	e11c                	sd	a5,0(a0)
}
    80000afe:	60a2                	ld	ra,8(sp)
    80000b00:	6402                	ld	s0,0(sp)
    80000b02:	0141                	addi	sp,sp,16
    80000b04:	8082                	ret
    panic("uvmclear");
    80000b06:	00007517          	auipc	a0,0x7
    80000b0a:	64250513          	addi	a0,a0,1602 # 80008148 <etext+0x148>
    80000b0e:	00005097          	auipc	ra,0x5
    80000b12:	154080e7          	jalr	340(ra) # 80005c62 <panic>

0000000080000b16 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b16:	c6bd                	beqz	a3,80000b84 <copyout+0x6e>
{
    80000b18:	715d                	addi	sp,sp,-80
    80000b1a:	e486                	sd	ra,72(sp)
    80000b1c:	e0a2                	sd	s0,64(sp)
    80000b1e:	fc26                	sd	s1,56(sp)
    80000b20:	f84a                	sd	s2,48(sp)
    80000b22:	f44e                	sd	s3,40(sp)
    80000b24:	f052                	sd	s4,32(sp)
    80000b26:	ec56                	sd	s5,24(sp)
    80000b28:	e85a                	sd	s6,16(sp)
    80000b2a:	e45e                	sd	s7,8(sp)
    80000b2c:	e062                	sd	s8,0(sp)
    80000b2e:	0880                	addi	s0,sp,80
    80000b30:	8b2a                	mv	s6,a0
    80000b32:	8c2e                	mv	s8,a1
    80000b34:	8a32                	mv	s4,a2
    80000b36:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b38:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3a:	6a85                	lui	s5,0x1
    80000b3c:	a015                	j	80000b60 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3e:	9562                	add	a0,a0,s8
    80000b40:	0004861b          	sext.w	a2,s1
    80000b44:	85d2                	mv	a1,s4
    80000b46:	41250533          	sub	a0,a0,s2
    80000b4a:	fffff097          	auipc	ra,0xfffff
    80000b4e:	68e080e7          	jalr	1678(ra) # 800001d8 <memmove>

    len -= n;
    80000b52:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b56:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b58:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5c:	02098263          	beqz	s3,80000b80 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b60:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b64:	85ca                	mv	a1,s2
    80000b66:	855a                	mv	a0,s6
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	9a2080e7          	jalr	-1630(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000b70:	cd01                	beqz	a0,80000b88 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b72:	418904b3          	sub	s1,s2,s8
    80000b76:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b78:	fc99f3e3          	bgeu	s3,s1,80000b3e <copyout+0x28>
    80000b7c:	84ce                	mv	s1,s3
    80000b7e:	b7c1                	j	80000b3e <copyout+0x28>
  }
  return 0;
    80000b80:	4501                	li	a0,0
    80000b82:	a021                	j	80000b8a <copyout+0x74>
    80000b84:	4501                	li	a0,0
}
    80000b86:	8082                	ret
      return -1;
    80000b88:	557d                	li	a0,-1
}
    80000b8a:	60a6                	ld	ra,72(sp)
    80000b8c:	6406                	ld	s0,64(sp)
    80000b8e:	74e2                	ld	s1,56(sp)
    80000b90:	7942                	ld	s2,48(sp)
    80000b92:	79a2                	ld	s3,40(sp)
    80000b94:	7a02                	ld	s4,32(sp)
    80000b96:	6ae2                	ld	s5,24(sp)
    80000b98:	6b42                	ld	s6,16(sp)
    80000b9a:	6ba2                	ld	s7,8(sp)
    80000b9c:	6c02                	ld	s8,0(sp)
    80000b9e:	6161                	addi	sp,sp,80
    80000ba0:	8082                	ret

0000000080000ba2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba2:	c6bd                	beqz	a3,80000c10 <copyin+0x6e>
{
    80000ba4:	715d                	addi	sp,sp,-80
    80000ba6:	e486                	sd	ra,72(sp)
    80000ba8:	e0a2                	sd	s0,64(sp)
    80000baa:	fc26                	sd	s1,56(sp)
    80000bac:	f84a                	sd	s2,48(sp)
    80000bae:	f44e                	sd	s3,40(sp)
    80000bb0:	f052                	sd	s4,32(sp)
    80000bb2:	ec56                	sd	s5,24(sp)
    80000bb4:	e85a                	sd	s6,16(sp)
    80000bb6:	e45e                	sd	s7,8(sp)
    80000bb8:	e062                	sd	s8,0(sp)
    80000bba:	0880                	addi	s0,sp,80
    80000bbc:	8b2a                	mv	s6,a0
    80000bbe:	8a2e                	mv	s4,a1
    80000bc0:	8c32                	mv	s8,a2
    80000bc2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc6:	6a85                	lui	s5,0x1
    80000bc8:	a015                	j	80000bec <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bca:	9562                	add	a0,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412505b3          	sub	a1,a0,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	602080e7          	jalr	1538(ra) # 800001d8 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	916080e7          	jalr	-1770(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c04:	fc99f3e3          	bgeu	s3,s1,80000bca <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	b7c1                	j	80000bca <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x74>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c6c5                	beqz	a3,80000cd6 <copyinstr+0xa8>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a035                	j	80000c7e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	0017b793          	seqz	a5,a5
    80000c5e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c62:	60a6                	ld	ra,72(sp)
    80000c64:	6406                	ld	s0,64(sp)
    80000c66:	74e2                	ld	s1,56(sp)
    80000c68:	7942                	ld	s2,48(sp)
    80000c6a:	79a2                	ld	s3,40(sp)
    80000c6c:	7a02                	ld	s4,32(sp)
    80000c6e:	6ae2                	ld	s5,24(sp)
    80000c70:	6b42                	ld	s6,16(sp)
    80000c72:	6ba2                	ld	s7,8(sp)
    80000c74:	6161                	addi	sp,sp,80
    80000c76:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c78:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7c:	c8a9                	beqz	s1,80000cce <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c7e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c82:	85ca                	mv	a1,s2
    80000c84:	8552                	mv	a0,s4
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	884080e7          	jalr	-1916(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c8e:	c131                	beqz	a0,80000cd2 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c90:	41790833          	sub	a6,s2,s7
    80000c94:	984e                	add	a6,a6,s3
    if(n > max)
    80000c96:	0104f363          	bgeu	s1,a6,80000c9c <copyinstr+0x6e>
    80000c9a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9c:	955e                	add	a0,a0,s7
    80000c9e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca2:	fc080be3          	beqz	a6,80000c78 <copyinstr+0x4a>
    80000ca6:	985a                	add	a6,a6,s6
    80000ca8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000caa:	41650633          	sub	a2,a0,s6
    80000cae:	14fd                	addi	s1,s1,-1
    80000cb0:	9b26                	add	s6,s6,s1
    80000cb2:	00f60733          	add	a4,a2,a5
    80000cb6:	00074703          	lbu	a4,0(a4)
    80000cba:	df49                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cbc:	00e78023          	sb	a4,0(a5)
      --max;
    80000cc0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cc4:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc6:	ff0796e3          	bne	a5,a6,80000cb2 <copyinstr+0x84>
      dst++;
    80000cca:	8b42                	mv	s6,a6
    80000ccc:	b775                	j	80000c78 <copyinstr+0x4a>
    80000cce:	4781                	li	a5,0
    80000cd0:	b769                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd2:	557d                	li	a0,-1
    80000cd4:	b779                	j	80000c62 <copyinstr+0x34>
  int got_null = 0;
    80000cd6:	4781                	li	a5,0
  if(got_null){
    80000cd8:	0017b793          	seqz	a5,a5
    80000cdc:	40f00533          	neg	a0,a5
}
    80000ce0:	8082                	ret

0000000080000ce2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000ce2:	7139                	addi	sp,sp,-64
    80000ce4:	fc06                	sd	ra,56(sp)
    80000ce6:	f822                	sd	s0,48(sp)
    80000ce8:	f426                	sd	s1,40(sp)
    80000cea:	f04a                	sd	s2,32(sp)
    80000cec:	ec4e                	sd	s3,24(sp)
    80000cee:	e852                	sd	s4,16(sp)
    80000cf0:	e456                	sd	s5,8(sp)
    80000cf2:	e05a                	sd	s6,0(sp)
    80000cf4:	0080                	addi	s0,sp,64
    80000cf6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf8:	00008497          	auipc	s1,0x8
    80000cfc:	1a848493          	addi	s1,s1,424 # 80008ea0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d00:	8b26                	mv	s6,s1
    80000d02:	00007a97          	auipc	s5,0x7
    80000d06:	2fea8a93          	addi	s5,s5,766 # 80008000 <etext>
    80000d0a:	04000937          	lui	s2,0x4000
    80000d0e:	197d                	addi	s2,s2,-1
    80000d10:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	0000ea17          	auipc	s4,0xe
    80000d16:	d8ea0a13          	addi	s4,s4,-626 # 8000eaa0 <tickslock>
    char *pa = kalloc();
    80000d1a:	fffff097          	auipc	ra,0xfffff
    80000d1e:	3fe080e7          	jalr	1022(ra) # 80000118 <kalloc>
    80000d22:	862a                	mv	a2,a0
    if(pa == 0)
    80000d24:	c131                	beqz	a0,80000d68 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d26:	416485b3          	sub	a1,s1,s6
    80000d2a:	8591                	srai	a1,a1,0x4
    80000d2c:	000ab783          	ld	a5,0(s5)
    80000d30:	02f585b3          	mul	a1,a1,a5
    80000d34:	2585                	addiw	a1,a1,1
    80000d36:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d3a:	4719                	li	a4,6
    80000d3c:	6685                	lui	a3,0x1
    80000d3e:	40b905b3          	sub	a1,s2,a1
    80000d42:	854e                	mv	a0,s3
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	8a8080e7          	jalr	-1880(ra) # 800005ec <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4c:	17048493          	addi	s1,s1,368
    80000d50:	fd4495e3          	bne	s1,s4,80000d1a <proc_mapstacks+0x38>
  }
}
    80000d54:	70e2                	ld	ra,56(sp)
    80000d56:	7442                	ld	s0,48(sp)
    80000d58:	74a2                	ld	s1,40(sp)
    80000d5a:	7902                	ld	s2,32(sp)
    80000d5c:	69e2                	ld	s3,24(sp)
    80000d5e:	6a42                	ld	s4,16(sp)
    80000d60:	6aa2                	ld	s5,8(sp)
    80000d62:	6b02                	ld	s6,0(sp)
    80000d64:	6121                	addi	sp,sp,64
    80000d66:	8082                	ret
      panic("kalloc");
    80000d68:	00007517          	auipc	a0,0x7
    80000d6c:	3f050513          	addi	a0,a0,1008 # 80008158 <etext+0x158>
    80000d70:	00005097          	auipc	ra,0x5
    80000d74:	ef2080e7          	jalr	-270(ra) # 80005c62 <panic>

0000000080000d78 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d78:	7139                	addi	sp,sp,-64
    80000d7a:	fc06                	sd	ra,56(sp)
    80000d7c:	f822                	sd	s0,48(sp)
    80000d7e:	f426                	sd	s1,40(sp)
    80000d80:	f04a                	sd	s2,32(sp)
    80000d82:	ec4e                	sd	s3,24(sp)
    80000d84:	e852                	sd	s4,16(sp)
    80000d86:	e456                	sd	s5,8(sp)
    80000d88:	e05a                	sd	s6,0(sp)
    80000d8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d8c:	00007597          	auipc	a1,0x7
    80000d90:	3d458593          	addi	a1,a1,980 # 80008160 <etext+0x160>
    80000d94:	00008517          	auipc	a0,0x8
    80000d98:	cdc50513          	addi	a0,a0,-804 # 80008a70 <pid_lock>
    80000d9c:	00005097          	auipc	ra,0x5
    80000da0:	380080e7          	jalr	896(ra) # 8000611c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da4:	00007597          	auipc	a1,0x7
    80000da8:	3c458593          	addi	a1,a1,964 # 80008168 <etext+0x168>
    80000dac:	00008517          	auipc	a0,0x8
    80000db0:	cdc50513          	addi	a0,a0,-804 # 80008a88 <wait_lock>
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	368080e7          	jalr	872(ra) # 8000611c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dbc:	00008497          	auipc	s1,0x8
    80000dc0:	0e448493          	addi	s1,s1,228 # 80008ea0 <proc>
      initlock(&p->lock, "proc");
    80000dc4:	00007b17          	auipc	s6,0x7
    80000dc8:	3b4b0b13          	addi	s6,s6,948 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dcc:	8aa6                	mv	s5,s1
    80000dce:	00007a17          	auipc	s4,0x7
    80000dd2:	232a0a13          	addi	s4,s4,562 # 80008000 <etext>
    80000dd6:	04000937          	lui	s2,0x4000
    80000dda:	197d                	addi	s2,s2,-1
    80000ddc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dde:	0000e997          	auipc	s3,0xe
    80000de2:	cc298993          	addi	s3,s3,-830 # 8000eaa0 <tickslock>
      initlock(&p->lock, "proc");
    80000de6:	85da                	mv	a1,s6
    80000de8:	8526                	mv	a0,s1
    80000dea:	00005097          	auipc	ra,0x5
    80000dee:	332080e7          	jalr	818(ra) # 8000611c <initlock>
      p->state = UNUSED;
    80000df2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df6:	415487b3          	sub	a5,s1,s5
    80000dfa:	8791                	srai	a5,a5,0x4
    80000dfc:	000a3703          	ld	a4,0(s4)
    80000e00:	02e787b3          	mul	a5,a5,a4
    80000e04:	2785                	addiw	a5,a5,1
    80000e06:	00d7979b          	slliw	a5,a5,0xd
    80000e0a:	40f907b3          	sub	a5,s2,a5
    80000e0e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e10:	17048493          	addi	s1,s1,368
    80000e14:	fd3499e3          	bne	s1,s3,80000de6 <procinit+0x6e>
  }
}
    80000e18:	70e2                	ld	ra,56(sp)
    80000e1a:	7442                	ld	s0,48(sp)
    80000e1c:	74a2                	ld	s1,40(sp)
    80000e1e:	7902                	ld	s2,32(sp)
    80000e20:	69e2                	ld	s3,24(sp)
    80000e22:	6a42                	ld	s4,16(sp)
    80000e24:	6aa2                	ld	s5,8(sp)
    80000e26:	6b02                	ld	s6,0(sp)
    80000e28:	6121                	addi	sp,sp,64
    80000e2a:	8082                	ret

0000000080000e2c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e32:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e34:	2501                	sext.w	a0,a0
    80000e36:	6422                	ld	s0,8(sp)
    80000e38:	0141                	addi	sp,sp,16
    80000e3a:	8082                	ret

0000000080000e3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e3c:	1141                	addi	sp,sp,-16
    80000e3e:	e422                	sd	s0,8(sp)
    80000e40:	0800                	addi	s0,sp,16
    80000e42:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e44:	2781                	sext.w	a5,a5
    80000e46:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e48:	00008517          	auipc	a0,0x8
    80000e4c:	c5850513          	addi	a0,a0,-936 # 80008aa0 <cpus>
    80000e50:	953e                	add	a0,a0,a5
    80000e52:	6422                	ld	s0,8(sp)
    80000e54:	0141                	addi	sp,sp,16
    80000e56:	8082                	ret

0000000080000e58 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e58:	1101                	addi	sp,sp,-32
    80000e5a:	ec06                	sd	ra,24(sp)
    80000e5c:	e822                	sd	s0,16(sp)
    80000e5e:	e426                	sd	s1,8(sp)
    80000e60:	1000                	addi	s0,sp,32
  push_off();
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	2fe080e7          	jalr	766(ra) # 80006160 <push_off>
    80000e6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e6c:	2781                	sext.w	a5,a5
    80000e6e:	079e                	slli	a5,a5,0x7
    80000e70:	00008717          	auipc	a4,0x8
    80000e74:	c0070713          	addi	a4,a4,-1024 # 80008a70 <pid_lock>
    80000e78:	97ba                	add	a5,a5,a4
    80000e7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e7c:	00005097          	auipc	ra,0x5
    80000e80:	384080e7          	jalr	900(ra) # 80006200 <pop_off>
  return p;
}
    80000e84:	8526                	mv	a0,s1
    80000e86:	60e2                	ld	ra,24(sp)
    80000e88:	6442                	ld	s0,16(sp)
    80000e8a:	64a2                	ld	s1,8(sp)
    80000e8c:	6105                	addi	sp,sp,32
    80000e8e:	8082                	ret

0000000080000e90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e90:	1141                	addi	sp,sp,-16
    80000e92:	e406                	sd	ra,8(sp)
    80000e94:	e022                	sd	s0,0(sp)
    80000e96:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e98:	00000097          	auipc	ra,0x0
    80000e9c:	fc0080e7          	jalr	-64(ra) # 80000e58 <myproc>
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	3c0080e7          	jalr	960(ra) # 80006260 <release>

  if (first) {
    80000ea8:	00008797          	auipc	a5,0x8
    80000eac:	b087a783          	lw	a5,-1272(a5) # 800089b0 <first.1679>
    80000eb0:	eb89                	bnez	a5,80000ec2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eb2:	00001097          	auipc	ra,0x1
    80000eb6:	c62080e7          	jalr	-926(ra) # 80001b14 <usertrapret>
}
    80000eba:	60a2                	ld	ra,8(sp)
    80000ebc:	6402                	ld	s0,0(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret
    first = 0;
    80000ec2:	00008797          	auipc	a5,0x8
    80000ec6:	ae07a723          	sw	zero,-1298(a5) # 800089b0 <first.1679>
    fsinit(ROOTDEV);
    80000eca:	4505                	li	a0,1
    80000ecc:	00002097          	auipc	ra,0x2
    80000ed0:	a1a080e7          	jalr	-1510(ra) # 800028e6 <fsinit>
    80000ed4:	bff9                	j	80000eb2 <forkret+0x22>

0000000080000ed6 <allocpid>:
{
    80000ed6:	1101                	addi	sp,sp,-32
    80000ed8:	ec06                	sd	ra,24(sp)
    80000eda:	e822                	sd	s0,16(sp)
    80000edc:	e426                	sd	s1,8(sp)
    80000ede:	e04a                	sd	s2,0(sp)
    80000ee0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ee2:	00008917          	auipc	s2,0x8
    80000ee6:	b8e90913          	addi	s2,s2,-1138 # 80008a70 <pid_lock>
    80000eea:	854a                	mv	a0,s2
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	2c0080e7          	jalr	704(ra) # 800061ac <acquire>
  pid = nextpid;
    80000ef4:	00008797          	auipc	a5,0x8
    80000ef8:	ac078793          	addi	a5,a5,-1344 # 800089b4 <nextpid>
    80000efc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efe:	0014871b          	addiw	a4,s1,1
    80000f02:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f04:	854a                	mv	a0,s2
    80000f06:	00005097          	auipc	ra,0x5
    80000f0a:	35a080e7          	jalr	858(ra) # 80006260 <release>
}
    80000f0e:	8526                	mv	a0,s1
    80000f10:	60e2                	ld	ra,24(sp)
    80000f12:	6442                	ld	s0,16(sp)
    80000f14:	64a2                	ld	s1,8(sp)
    80000f16:	6902                	ld	s2,0(sp)
    80000f18:	6105                	addi	sp,sp,32
    80000f1a:	8082                	ret

0000000080000f1c <proc_pagetable>:
{
    80000f1c:	1101                	addi	sp,sp,-32
    80000f1e:	ec06                	sd	ra,24(sp)
    80000f20:	e822                	sd	s0,16(sp)
    80000f22:	e426                	sd	s1,8(sp)
    80000f24:	e04a                	sd	s2,0(sp)
    80000f26:	1000                	addi	s0,sp,32
    80000f28:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f2a:	00000097          	auipc	ra,0x0
    80000f2e:	8ac080e7          	jalr	-1876(ra) # 800007d6 <uvmcreate>
    80000f32:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f34:	c121                	beqz	a0,80000f74 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f36:	4729                	li	a4,10
    80000f38:	00006697          	auipc	a3,0x6
    80000f3c:	0c868693          	addi	a3,a3,200 # 80007000 <_trampoline>
    80000f40:	6605                	lui	a2,0x1
    80000f42:	040005b7          	lui	a1,0x4000
    80000f46:	15fd                	addi	a1,a1,-1
    80000f48:	05b2                	slli	a1,a1,0xc
    80000f4a:	fffff097          	auipc	ra,0xfffff
    80000f4e:	602080e7          	jalr	1538(ra) # 8000054c <mappages>
    80000f52:	02054863          	bltz	a0,80000f82 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f56:	4719                	li	a4,6
    80000f58:	05893683          	ld	a3,88(s2)
    80000f5c:	6605                	lui	a2,0x1
    80000f5e:	020005b7          	lui	a1,0x2000
    80000f62:	15fd                	addi	a1,a1,-1
    80000f64:	05b6                	slli	a1,a1,0xd
    80000f66:	8526                	mv	a0,s1
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	5e4080e7          	jalr	1508(ra) # 8000054c <mappages>
    80000f70:	02054163          	bltz	a0,80000f92 <proc_pagetable+0x76>
}
    80000f74:	8526                	mv	a0,s1
    80000f76:	60e2                	ld	ra,24(sp)
    80000f78:	6442                	ld	s0,16(sp)
    80000f7a:	64a2                	ld	s1,8(sp)
    80000f7c:	6902                	ld	s2,0(sp)
    80000f7e:	6105                	addi	sp,sp,32
    80000f80:	8082                	ret
    uvmfree(pagetable, 0);
    80000f82:	4581                	li	a1,0
    80000f84:	8526                	mv	a0,s1
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	a54080e7          	jalr	-1452(ra) # 800009da <uvmfree>
    return 0;
    80000f8e:	4481                	li	s1,0
    80000f90:	b7d5                	j	80000f74 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f92:	4681                	li	a3,0
    80000f94:	4605                	li	a2,1
    80000f96:	040005b7          	lui	a1,0x4000
    80000f9a:	15fd                	addi	a1,a1,-1
    80000f9c:	05b2                	slli	a1,a1,0xc
    80000f9e:	8526                	mv	a0,s1
    80000fa0:	fffff097          	auipc	ra,0xfffff
    80000fa4:	772080e7          	jalr	1906(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa8:	4581                	li	a1,0
    80000faa:	8526                	mv	a0,s1
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	a2e080e7          	jalr	-1490(ra) # 800009da <uvmfree>
    return 0;
    80000fb4:	4481                	li	s1,0
    80000fb6:	bf7d                	j	80000f74 <proc_pagetable+0x58>

0000000080000fb8 <proc_freepagetable>:
{
    80000fb8:	1101                	addi	sp,sp,-32
    80000fba:	ec06                	sd	ra,24(sp)
    80000fbc:	e822                	sd	s0,16(sp)
    80000fbe:	e426                	sd	s1,8(sp)
    80000fc0:	e04a                	sd	s2,0(sp)
    80000fc2:	1000                	addi	s0,sp,32
    80000fc4:	84aa                	mv	s1,a0
    80000fc6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	040005b7          	lui	a1,0x4000
    80000fd0:	15fd                	addi	a1,a1,-1
    80000fd2:	05b2                	slli	a1,a1,0xc
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	73e080e7          	jalr	1854(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fdc:	4681                	li	a3,0
    80000fde:	4605                	li	a2,1
    80000fe0:	020005b7          	lui	a1,0x2000
    80000fe4:	15fd                	addi	a1,a1,-1
    80000fe6:	05b6                	slli	a1,a1,0xd
    80000fe8:	8526                	mv	a0,s1
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	728080e7          	jalr	1832(ra) # 80000712 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ff2:	85ca                	mv	a1,s2
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	00000097          	auipc	ra,0x0
    80000ffa:	9e4080e7          	jalr	-1564(ra) # 800009da <uvmfree>
}
    80000ffe:	60e2                	ld	ra,24(sp)
    80001000:	6442                	ld	s0,16(sp)
    80001002:	64a2                	ld	s1,8(sp)
    80001004:	6902                	ld	s2,0(sp)
    80001006:	6105                	addi	sp,sp,32
    80001008:	8082                	ret

000000008000100a <freeproc>:
{
    8000100a:	1101                	addi	sp,sp,-32
    8000100c:	ec06                	sd	ra,24(sp)
    8000100e:	e822                	sd	s0,16(sp)
    80001010:	e426                	sd	s1,8(sp)
    80001012:	1000                	addi	s0,sp,32
    80001014:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001016:	6d28                	ld	a0,88(a0)
    80001018:	c509                	beqz	a0,80001022 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	002080e7          	jalr	2(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001022:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001026:	68a8                	ld	a0,80(s1)
    80001028:	c511                	beqz	a0,80001034 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000102a:	64ac                	ld	a1,72(s1)
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	f8c080e7          	jalr	-116(ra) # 80000fb8 <proc_freepagetable>
  p->pagetable = 0;
    80001034:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001038:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000103c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001040:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001044:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001048:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000104c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001050:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001054:	0004ac23          	sw	zero,24(s1)
  p->trace_mask = 0;
    80001058:	1604a423          	sw	zero,360(s1)
}
    8000105c:	60e2                	ld	ra,24(sp)
    8000105e:	6442                	ld	s0,16(sp)
    80001060:	64a2                	ld	s1,8(sp)
    80001062:	6105                	addi	sp,sp,32
    80001064:	8082                	ret

0000000080001066 <allocproc>:
{
    80001066:	1101                	addi	sp,sp,-32
    80001068:	ec06                	sd	ra,24(sp)
    8000106a:	e822                	sd	s0,16(sp)
    8000106c:	e426                	sd	s1,8(sp)
    8000106e:	e04a                	sd	s2,0(sp)
    80001070:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001072:	00008497          	auipc	s1,0x8
    80001076:	e2e48493          	addi	s1,s1,-466 # 80008ea0 <proc>
    8000107a:	0000e917          	auipc	s2,0xe
    8000107e:	a2690913          	addi	s2,s2,-1498 # 8000eaa0 <tickslock>
    acquire(&p->lock);
    80001082:	8526                	mv	a0,s1
    80001084:	00005097          	auipc	ra,0x5
    80001088:	128080e7          	jalr	296(ra) # 800061ac <acquire>
    if(p->state == UNUSED) {
    8000108c:	4c9c                	lw	a5,24(s1)
    8000108e:	cf81                	beqz	a5,800010a6 <allocproc+0x40>
      release(&p->lock);
    80001090:	8526                	mv	a0,s1
    80001092:	00005097          	auipc	ra,0x5
    80001096:	1ce080e7          	jalr	462(ra) # 80006260 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000109a:	17048493          	addi	s1,s1,368
    8000109e:	ff2492e3          	bne	s1,s2,80001082 <allocproc+0x1c>
  return 0;
    800010a2:	4481                	li	s1,0
    800010a4:	a889                	j	800010f6 <allocproc+0x90>
  p->pid = allocpid();
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	e30080e7          	jalr	-464(ra) # 80000ed6 <allocpid>
    800010ae:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010b0:	4785                	li	a5,1
    800010b2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b4:	fffff097          	auipc	ra,0xfffff
    800010b8:	064080e7          	jalr	100(ra) # 80000118 <kalloc>
    800010bc:	892a                	mv	s2,a0
    800010be:	eca8                	sd	a0,88(s1)
    800010c0:	c131                	beqz	a0,80001104 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010c2:	8526                	mv	a0,s1
    800010c4:	00000097          	auipc	ra,0x0
    800010c8:	e58080e7          	jalr	-424(ra) # 80000f1c <proc_pagetable>
    800010cc:	892a                	mv	s2,a0
    800010ce:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010d0:	c531                	beqz	a0,8000111c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010d2:	07000613          	li	a2,112
    800010d6:	4581                	li	a1,0
    800010d8:	06048513          	addi	a0,s1,96
    800010dc:	fffff097          	auipc	ra,0xfffff
    800010e0:	09c080e7          	jalr	156(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010e4:	00000797          	auipc	a5,0x0
    800010e8:	dac78793          	addi	a5,a5,-596 # 80000e90 <forkret>
    800010ec:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ee:	60bc                	ld	a5,64(s1)
    800010f0:	6705                	lui	a4,0x1
    800010f2:	97ba                	add	a5,a5,a4
    800010f4:	f4bc                	sd	a5,104(s1)
}
    800010f6:	8526                	mv	a0,s1
    800010f8:	60e2                	ld	ra,24(sp)
    800010fa:	6442                	ld	s0,16(sp)
    800010fc:	64a2                	ld	s1,8(sp)
    800010fe:	6902                	ld	s2,0(sp)
    80001100:	6105                	addi	sp,sp,32
    80001102:	8082                	ret
    freeproc(p);
    80001104:	8526                	mv	a0,s1
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	f04080e7          	jalr	-252(ra) # 8000100a <freeproc>
    release(&p->lock);
    8000110e:	8526                	mv	a0,s1
    80001110:	00005097          	auipc	ra,0x5
    80001114:	150080e7          	jalr	336(ra) # 80006260 <release>
    return 0;
    80001118:	84ca                	mv	s1,s2
    8000111a:	bff1                	j	800010f6 <allocproc+0x90>
    freeproc(p);
    8000111c:	8526                	mv	a0,s1
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	eec080e7          	jalr	-276(ra) # 8000100a <freeproc>
    release(&p->lock);
    80001126:	8526                	mv	a0,s1
    80001128:	00005097          	auipc	ra,0x5
    8000112c:	138080e7          	jalr	312(ra) # 80006260 <release>
    return 0;
    80001130:	84ca                	mv	s1,s2
    80001132:	b7d1                	j	800010f6 <allocproc+0x90>

0000000080001134 <userinit>:
{
    80001134:	1101                	addi	sp,sp,-32
    80001136:	ec06                	sd	ra,24(sp)
    80001138:	e822                	sd	s0,16(sp)
    8000113a:	e426                	sd	s1,8(sp)
    8000113c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	f28080e7          	jalr	-216(ra) # 80001066 <allocproc>
    80001146:	84aa                	mv	s1,a0
  initproc = p;
    80001148:	00008797          	auipc	a5,0x8
    8000114c:	8ea7b423          	sd	a0,-1816(a5) # 80008a30 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001150:	03400613          	li	a2,52
    80001154:	00008597          	auipc	a1,0x8
    80001158:	86c58593          	addi	a1,a1,-1940 # 800089c0 <initcode>
    8000115c:	6928                	ld	a0,80(a0)
    8000115e:	fffff097          	auipc	ra,0xfffff
    80001162:	6a6080e7          	jalr	1702(ra) # 80000804 <uvmfirst>
  p->sz = PGSIZE;
    80001166:	6785                	lui	a5,0x1
    80001168:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000116a:	6cb8                	ld	a4,88(s1)
    8000116c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001170:	6cb8                	ld	a4,88(s1)
    80001172:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001174:	4641                	li	a2,16
    80001176:	00007597          	auipc	a1,0x7
    8000117a:	00a58593          	addi	a1,a1,10 # 80008180 <etext+0x180>
    8000117e:	15848513          	addi	a0,s1,344
    80001182:	fffff097          	auipc	ra,0xfffff
    80001186:	148080e7          	jalr	328(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000118a:	00007517          	auipc	a0,0x7
    8000118e:	00650513          	addi	a0,a0,6 # 80008190 <etext+0x190>
    80001192:	00002097          	auipc	ra,0x2
    80001196:	176080e7          	jalr	374(ra) # 80003308 <namei>
    8000119a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000119e:	478d                	li	a5,3
    800011a0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011a2:	8526                	mv	a0,s1
    800011a4:	00005097          	auipc	ra,0x5
    800011a8:	0bc080e7          	jalr	188(ra) # 80006260 <release>
}
    800011ac:	60e2                	ld	ra,24(sp)
    800011ae:	6442                	ld	s0,16(sp)
    800011b0:	64a2                	ld	s1,8(sp)
    800011b2:	6105                	addi	sp,sp,32
    800011b4:	8082                	ret

00000000800011b6 <growproc>:
{
    800011b6:	1101                	addi	sp,sp,-32
    800011b8:	ec06                	sd	ra,24(sp)
    800011ba:	e822                	sd	s0,16(sp)
    800011bc:	e426                	sd	s1,8(sp)
    800011be:	e04a                	sd	s2,0(sp)
    800011c0:	1000                	addi	s0,sp,32
    800011c2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011c4:	00000097          	auipc	ra,0x0
    800011c8:	c94080e7          	jalr	-876(ra) # 80000e58 <myproc>
    800011cc:	84aa                	mv	s1,a0
  sz = p->sz;
    800011ce:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011d0:	01204c63          	bgtz	s2,800011e8 <growproc+0x32>
  } else if(n < 0){
    800011d4:	02094663          	bltz	s2,80001200 <growproc+0x4a>
  p->sz = sz;
    800011d8:	e4ac                	sd	a1,72(s1)
  return 0;
    800011da:	4501                	li	a0,0
}
    800011dc:	60e2                	ld	ra,24(sp)
    800011de:	6442                	ld	s0,16(sp)
    800011e0:	64a2                	ld	s1,8(sp)
    800011e2:	6902                	ld	s2,0(sp)
    800011e4:	6105                	addi	sp,sp,32
    800011e6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011e8:	4691                	li	a3,4
    800011ea:	00b90633          	add	a2,s2,a1
    800011ee:	6928                	ld	a0,80(a0)
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	6ce080e7          	jalr	1742(ra) # 800008be <uvmalloc>
    800011f8:	85aa                	mv	a1,a0
    800011fa:	fd79                	bnez	a0,800011d8 <growproc+0x22>
      return -1;
    800011fc:	557d                	li	a0,-1
    800011fe:	bff9                	j	800011dc <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001200:	00b90633          	add	a2,s2,a1
    80001204:	6928                	ld	a0,80(a0)
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	670080e7          	jalr	1648(ra) # 80000876 <uvmdealloc>
    8000120e:	85aa                	mv	a1,a0
    80001210:	b7e1                	j	800011d8 <growproc+0x22>

0000000080001212 <fork>:
{
    80001212:	7179                	addi	sp,sp,-48
    80001214:	f406                	sd	ra,40(sp)
    80001216:	f022                	sd	s0,32(sp)
    80001218:	ec26                	sd	s1,24(sp)
    8000121a:	e84a                	sd	s2,16(sp)
    8000121c:	e44e                	sd	s3,8(sp)
    8000121e:	e052                	sd	s4,0(sp)
    80001220:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001222:	00000097          	auipc	ra,0x0
    80001226:	c36080e7          	jalr	-970(ra) # 80000e58 <myproc>
    8000122a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000122c:	00000097          	auipc	ra,0x0
    80001230:	e3a080e7          	jalr	-454(ra) # 80001066 <allocproc>
    80001234:	10050f63          	beqz	a0,80001352 <fork+0x140>
    80001238:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000123a:	04893603          	ld	a2,72(s2)
    8000123e:	692c                	ld	a1,80(a0)
    80001240:	05093503          	ld	a0,80(s2)
    80001244:	fffff097          	auipc	ra,0xfffff
    80001248:	7ce080e7          	jalr	1998(ra) # 80000a12 <uvmcopy>
    8000124c:	04054663          	bltz	a0,80001298 <fork+0x86>
  np->sz = p->sz;
    80001250:	04893783          	ld	a5,72(s2)
    80001254:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001258:	05893683          	ld	a3,88(s2)
    8000125c:	87b6                	mv	a5,a3
    8000125e:	0589b703          	ld	a4,88(s3)
    80001262:	12068693          	addi	a3,a3,288
    80001266:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000126a:	6788                	ld	a0,8(a5)
    8000126c:	6b8c                	ld	a1,16(a5)
    8000126e:	6f90                	ld	a2,24(a5)
    80001270:	01073023          	sd	a6,0(a4)
    80001274:	e708                	sd	a0,8(a4)
    80001276:	eb0c                	sd	a1,16(a4)
    80001278:	ef10                	sd	a2,24(a4)
    8000127a:	02078793          	addi	a5,a5,32
    8000127e:	02070713          	addi	a4,a4,32
    80001282:	fed792e3          	bne	a5,a3,80001266 <fork+0x54>
  np->trapframe->a0 = 0;
    80001286:	0589b783          	ld	a5,88(s3)
    8000128a:	0607b823          	sd	zero,112(a5)
    8000128e:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001292:	15000a13          	li	s4,336
    80001296:	a03d                	j	800012c4 <fork+0xb2>
    freeproc(np);
    80001298:	854e                	mv	a0,s3
    8000129a:	00000097          	auipc	ra,0x0
    8000129e:	d70080e7          	jalr	-656(ra) # 8000100a <freeproc>
    release(&np->lock);
    800012a2:	854e                	mv	a0,s3
    800012a4:	00005097          	auipc	ra,0x5
    800012a8:	fbc080e7          	jalr	-68(ra) # 80006260 <release>
    return -1;
    800012ac:	5a7d                	li	s4,-1
    800012ae:	a849                	j	80001340 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b0:	00002097          	auipc	ra,0x2
    800012b4:	6ee080e7          	jalr	1774(ra) # 8000399e <filedup>
    800012b8:	009987b3          	add	a5,s3,s1
    800012bc:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012be:	04a1                	addi	s1,s1,8
    800012c0:	01448763          	beq	s1,s4,800012ce <fork+0xbc>
    if(p->ofile[i])
    800012c4:	009907b3          	add	a5,s2,s1
    800012c8:	6388                	ld	a0,0(a5)
    800012ca:	f17d                	bnez	a0,800012b0 <fork+0x9e>
    800012cc:	bfcd                	j	800012be <fork+0xac>
  np->cwd = idup(p->cwd);
    800012ce:	15093503          	ld	a0,336(s2)
    800012d2:	00002097          	auipc	ra,0x2
    800012d6:	852080e7          	jalr	-1966(ra) # 80002b24 <idup>
    800012da:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012de:	4641                	li	a2,16
    800012e0:	15890593          	addi	a1,s2,344
    800012e4:	15898513          	addi	a0,s3,344
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	fe2080e7          	jalr	-30(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012f0:	0309aa03          	lw	s4,48(s3)
  np->trace_mask = p->trace_mask;
    800012f4:	16892783          	lw	a5,360(s2)
    800012f8:	16f9a423          	sw	a5,360(s3)
  release(&np->lock);
    800012fc:	854e                	mv	a0,s3
    800012fe:	00005097          	auipc	ra,0x5
    80001302:	f62080e7          	jalr	-158(ra) # 80006260 <release>
  acquire(&wait_lock);
    80001306:	00007497          	auipc	s1,0x7
    8000130a:	78248493          	addi	s1,s1,1922 # 80008a88 <wait_lock>
    8000130e:	8526                	mv	a0,s1
    80001310:	00005097          	auipc	ra,0x5
    80001314:	e9c080e7          	jalr	-356(ra) # 800061ac <acquire>
  np->parent = p;
    80001318:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000131c:	8526                	mv	a0,s1
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	f42080e7          	jalr	-190(ra) # 80006260 <release>
  acquire(&np->lock);
    80001326:	854e                	mv	a0,s3
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	e84080e7          	jalr	-380(ra) # 800061ac <acquire>
  np->state = RUNNABLE;
    80001330:	478d                	li	a5,3
    80001332:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001336:	854e                	mv	a0,s3
    80001338:	00005097          	auipc	ra,0x5
    8000133c:	f28080e7          	jalr	-216(ra) # 80006260 <release>
}
    80001340:	8552                	mv	a0,s4
    80001342:	70a2                	ld	ra,40(sp)
    80001344:	7402                	ld	s0,32(sp)
    80001346:	64e2                	ld	s1,24(sp)
    80001348:	6942                	ld	s2,16(sp)
    8000134a:	69a2                	ld	s3,8(sp)
    8000134c:	6a02                	ld	s4,0(sp)
    8000134e:	6145                	addi	sp,sp,48
    80001350:	8082                	ret
    return -1;
    80001352:	5a7d                	li	s4,-1
    80001354:	b7f5                	j	80001340 <fork+0x12e>

0000000080001356 <scheduler>:
{
    80001356:	7139                	addi	sp,sp,-64
    80001358:	fc06                	sd	ra,56(sp)
    8000135a:	f822                	sd	s0,48(sp)
    8000135c:	f426                	sd	s1,40(sp)
    8000135e:	f04a                	sd	s2,32(sp)
    80001360:	ec4e                	sd	s3,24(sp)
    80001362:	e852                	sd	s4,16(sp)
    80001364:	e456                	sd	s5,8(sp)
    80001366:	e05a                	sd	s6,0(sp)
    80001368:	0080                	addi	s0,sp,64
    8000136a:	8792                	mv	a5,tp
  int id = r_tp();
    8000136c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000136e:	00779a93          	slli	s5,a5,0x7
    80001372:	00007717          	auipc	a4,0x7
    80001376:	6fe70713          	addi	a4,a4,1790 # 80008a70 <pid_lock>
    8000137a:	9756                	add	a4,a4,s5
    8000137c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001380:	00007717          	auipc	a4,0x7
    80001384:	72870713          	addi	a4,a4,1832 # 80008aa8 <cpus+0x8>
    80001388:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000138a:	498d                	li	s3,3
        p->state = RUNNING;
    8000138c:	4b11                	li	s6,4
        c->proc = p;
    8000138e:	079e                	slli	a5,a5,0x7
    80001390:	00007a17          	auipc	s4,0x7
    80001394:	6e0a0a13          	addi	s4,s4,1760 # 80008a70 <pid_lock>
    80001398:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139a:	0000d917          	auipc	s2,0xd
    8000139e:	70690913          	addi	s2,s2,1798 # 8000eaa0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013aa:	10079073          	csrw	sstatus,a5
    800013ae:	00008497          	auipc	s1,0x8
    800013b2:	af248493          	addi	s1,s1,-1294 # 80008ea0 <proc>
    800013b6:	a03d                	j	800013e4 <scheduler+0x8e>
        p->state = RUNNING;
    800013b8:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013bc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013c0:	06048593          	addi	a1,s1,96
    800013c4:	8556                	mv	a0,s5
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	6a4080e7          	jalr	1700(ra) # 80001a6a <swtch>
        c->proc = 0;
    800013ce:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013d2:	8526                	mv	a0,s1
    800013d4:	00005097          	auipc	ra,0x5
    800013d8:	e8c080e7          	jalr	-372(ra) # 80006260 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013dc:	17048493          	addi	s1,s1,368
    800013e0:	fd2481e3          	beq	s1,s2,800013a2 <scheduler+0x4c>
      acquire(&p->lock);
    800013e4:	8526                	mv	a0,s1
    800013e6:	00005097          	auipc	ra,0x5
    800013ea:	dc6080e7          	jalr	-570(ra) # 800061ac <acquire>
      if(p->state == RUNNABLE) {
    800013ee:	4c9c                	lw	a5,24(s1)
    800013f0:	ff3791e3          	bne	a5,s3,800013d2 <scheduler+0x7c>
    800013f4:	b7d1                	j	800013b8 <scheduler+0x62>

00000000800013f6 <sched>:
{
    800013f6:	7179                	addi	sp,sp,-48
    800013f8:	f406                	sd	ra,40(sp)
    800013fa:	f022                	sd	s0,32(sp)
    800013fc:	ec26                	sd	s1,24(sp)
    800013fe:	e84a                	sd	s2,16(sp)
    80001400:	e44e                	sd	s3,8(sp)
    80001402:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001404:	00000097          	auipc	ra,0x0
    80001408:	a54080e7          	jalr	-1452(ra) # 80000e58 <myproc>
    8000140c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	d24080e7          	jalr	-732(ra) # 80006132 <holding>
    80001416:	c93d                	beqz	a0,8000148c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001418:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000141a:	2781                	sext.w	a5,a5
    8000141c:	079e                	slli	a5,a5,0x7
    8000141e:	00007717          	auipc	a4,0x7
    80001422:	65270713          	addi	a4,a4,1618 # 80008a70 <pid_lock>
    80001426:	97ba                	add	a5,a5,a4
    80001428:	0a87a703          	lw	a4,168(a5)
    8000142c:	4785                	li	a5,1
    8000142e:	06f71763          	bne	a4,a5,8000149c <sched+0xa6>
  if(p->state == RUNNING)
    80001432:	4c98                	lw	a4,24(s1)
    80001434:	4791                	li	a5,4
    80001436:	06f70b63          	beq	a4,a5,800014ac <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000143a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001440:	efb5                	bnez	a5,800014bc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001442:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001444:	00007917          	auipc	s2,0x7
    80001448:	62c90913          	addi	s2,s2,1580 # 80008a70 <pid_lock>
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	97ca                	add	a5,a5,s2
    80001452:	0ac7a983          	lw	s3,172(a5)
    80001456:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001458:	2781                	sext.w	a5,a5
    8000145a:	079e                	slli	a5,a5,0x7
    8000145c:	00007597          	auipc	a1,0x7
    80001460:	64c58593          	addi	a1,a1,1612 # 80008aa8 <cpus+0x8>
    80001464:	95be                	add	a1,a1,a5
    80001466:	06048513          	addi	a0,s1,96
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	600080e7          	jalr	1536(ra) # 80001a6a <swtch>
    80001472:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001474:	2781                	sext.w	a5,a5
    80001476:	079e                	slli	a5,a5,0x7
    80001478:	97ca                	add	a5,a5,s2
    8000147a:	0b37a623          	sw	s3,172(a5)
}
    8000147e:	70a2                	ld	ra,40(sp)
    80001480:	7402                	ld	s0,32(sp)
    80001482:	64e2                	ld	s1,24(sp)
    80001484:	6942                	ld	s2,16(sp)
    80001486:	69a2                	ld	s3,8(sp)
    80001488:	6145                	addi	sp,sp,48
    8000148a:	8082                	ret
    panic("sched p->lock");
    8000148c:	00007517          	auipc	a0,0x7
    80001490:	d0c50513          	addi	a0,a0,-756 # 80008198 <etext+0x198>
    80001494:	00004097          	auipc	ra,0x4
    80001498:	7ce080e7          	jalr	1998(ra) # 80005c62 <panic>
    panic("sched locks");
    8000149c:	00007517          	auipc	a0,0x7
    800014a0:	d0c50513          	addi	a0,a0,-756 # 800081a8 <etext+0x1a8>
    800014a4:	00004097          	auipc	ra,0x4
    800014a8:	7be080e7          	jalr	1982(ra) # 80005c62 <panic>
    panic("sched running");
    800014ac:	00007517          	auipc	a0,0x7
    800014b0:	d0c50513          	addi	a0,a0,-756 # 800081b8 <etext+0x1b8>
    800014b4:	00004097          	auipc	ra,0x4
    800014b8:	7ae080e7          	jalr	1966(ra) # 80005c62 <panic>
    panic("sched interruptible");
    800014bc:	00007517          	auipc	a0,0x7
    800014c0:	d0c50513          	addi	a0,a0,-756 # 800081c8 <etext+0x1c8>
    800014c4:	00004097          	auipc	ra,0x4
    800014c8:	79e080e7          	jalr	1950(ra) # 80005c62 <panic>

00000000800014cc <yield>:
{
    800014cc:	1101                	addi	sp,sp,-32
    800014ce:	ec06                	sd	ra,24(sp)
    800014d0:	e822                	sd	s0,16(sp)
    800014d2:	e426                	sd	s1,8(sp)
    800014d4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	982080e7          	jalr	-1662(ra) # 80000e58 <myproc>
    800014de:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	ccc080e7          	jalr	-820(ra) # 800061ac <acquire>
  p->state = RUNNABLE;
    800014e8:	478d                	li	a5,3
    800014ea:	cc9c                	sw	a5,24(s1)
  sched();
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	f0a080e7          	jalr	-246(ra) # 800013f6 <sched>
  release(&p->lock);
    800014f4:	8526                	mv	a0,s1
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	d6a080e7          	jalr	-662(ra) # 80006260 <release>
}
    800014fe:	60e2                	ld	ra,24(sp)
    80001500:	6442                	ld	s0,16(sp)
    80001502:	64a2                	ld	s1,8(sp)
    80001504:	6105                	addi	sp,sp,32
    80001506:	8082                	ret

0000000080001508 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001508:	7179                	addi	sp,sp,-48
    8000150a:	f406                	sd	ra,40(sp)
    8000150c:	f022                	sd	s0,32(sp)
    8000150e:	ec26                	sd	s1,24(sp)
    80001510:	e84a                	sd	s2,16(sp)
    80001512:	e44e                	sd	s3,8(sp)
    80001514:	1800                	addi	s0,sp,48
    80001516:	89aa                	mv	s3,a0
    80001518:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	93e080e7          	jalr	-1730(ra) # 80000e58 <myproc>
    80001522:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001524:	00005097          	auipc	ra,0x5
    80001528:	c88080e7          	jalr	-888(ra) # 800061ac <acquire>
  release(lk);
    8000152c:	854a                	mv	a0,s2
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	d32080e7          	jalr	-718(ra) # 80006260 <release>

  // Go to sleep.
  p->chan = chan;
    80001536:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000153a:	4789                	li	a5,2
    8000153c:	cc9c                	sw	a5,24(s1)

  sched();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	eb8080e7          	jalr	-328(ra) # 800013f6 <sched>

  // Tidy up.
  p->chan = 0;
    80001546:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	d14080e7          	jalr	-748(ra) # 80006260 <release>
  acquire(lk);
    80001554:	854a                	mv	a0,s2
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	c56080e7          	jalr	-938(ra) # 800061ac <acquire>
}
    8000155e:	70a2                	ld	ra,40(sp)
    80001560:	7402                	ld	s0,32(sp)
    80001562:	64e2                	ld	s1,24(sp)
    80001564:	6942                	ld	s2,16(sp)
    80001566:	69a2                	ld	s3,8(sp)
    80001568:	6145                	addi	sp,sp,48
    8000156a:	8082                	ret

000000008000156c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000156c:	7139                	addi	sp,sp,-64
    8000156e:	fc06                	sd	ra,56(sp)
    80001570:	f822                	sd	s0,48(sp)
    80001572:	f426                	sd	s1,40(sp)
    80001574:	f04a                	sd	s2,32(sp)
    80001576:	ec4e                	sd	s3,24(sp)
    80001578:	e852                	sd	s4,16(sp)
    8000157a:	e456                	sd	s5,8(sp)
    8000157c:	0080                	addi	s0,sp,64
    8000157e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001580:	00008497          	auipc	s1,0x8
    80001584:	92048493          	addi	s1,s1,-1760 # 80008ea0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001588:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000158a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000158c:	0000d917          	auipc	s2,0xd
    80001590:	51490913          	addi	s2,s2,1300 # 8000eaa0 <tickslock>
    80001594:	a821                	j	800015ac <wakeup+0x40>
        p->state = RUNNABLE;
    80001596:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	cc4080e7          	jalr	-828(ra) # 80006260 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015a4:	17048493          	addi	s1,s1,368
    800015a8:	03248463          	beq	s1,s2,800015d0 <wakeup+0x64>
    if(p != myproc()){
    800015ac:	00000097          	auipc	ra,0x0
    800015b0:	8ac080e7          	jalr	-1876(ra) # 80000e58 <myproc>
    800015b4:	fea488e3          	beq	s1,a0,800015a4 <wakeup+0x38>
      acquire(&p->lock);
    800015b8:	8526                	mv	a0,s1
    800015ba:	00005097          	auipc	ra,0x5
    800015be:	bf2080e7          	jalr	-1038(ra) # 800061ac <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015c2:	4c9c                	lw	a5,24(s1)
    800015c4:	fd379be3          	bne	a5,s3,8000159a <wakeup+0x2e>
    800015c8:	709c                	ld	a5,32(s1)
    800015ca:	fd4798e3          	bne	a5,s4,8000159a <wakeup+0x2e>
    800015ce:	b7e1                	j	80001596 <wakeup+0x2a>
    }
  }
}
    800015d0:	70e2                	ld	ra,56(sp)
    800015d2:	7442                	ld	s0,48(sp)
    800015d4:	74a2                	ld	s1,40(sp)
    800015d6:	7902                	ld	s2,32(sp)
    800015d8:	69e2                	ld	s3,24(sp)
    800015da:	6a42                	ld	s4,16(sp)
    800015dc:	6aa2                	ld	s5,8(sp)
    800015de:	6121                	addi	sp,sp,64
    800015e0:	8082                	ret

00000000800015e2 <reparent>:
{
    800015e2:	7179                	addi	sp,sp,-48
    800015e4:	f406                	sd	ra,40(sp)
    800015e6:	f022                	sd	s0,32(sp)
    800015e8:	ec26                	sd	s1,24(sp)
    800015ea:	e84a                	sd	s2,16(sp)
    800015ec:	e44e                	sd	s3,8(sp)
    800015ee:	e052                	sd	s4,0(sp)
    800015f0:	1800                	addi	s0,sp,48
    800015f2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f4:	00008497          	auipc	s1,0x8
    800015f8:	8ac48493          	addi	s1,s1,-1876 # 80008ea0 <proc>
      pp->parent = initproc;
    800015fc:	00007a17          	auipc	s4,0x7
    80001600:	434a0a13          	addi	s4,s4,1076 # 80008a30 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001604:	0000d997          	auipc	s3,0xd
    80001608:	49c98993          	addi	s3,s3,1180 # 8000eaa0 <tickslock>
    8000160c:	a029                	j	80001616 <reparent+0x34>
    8000160e:	17048493          	addi	s1,s1,368
    80001612:	01348d63          	beq	s1,s3,8000162c <reparent+0x4a>
    if(pp->parent == p){
    80001616:	7c9c                	ld	a5,56(s1)
    80001618:	ff279be3          	bne	a5,s2,8000160e <reparent+0x2c>
      pp->parent = initproc;
    8000161c:	000a3503          	ld	a0,0(s4)
    80001620:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001622:	00000097          	auipc	ra,0x0
    80001626:	f4a080e7          	jalr	-182(ra) # 8000156c <wakeup>
    8000162a:	b7d5                	j	8000160e <reparent+0x2c>
}
    8000162c:	70a2                	ld	ra,40(sp)
    8000162e:	7402                	ld	s0,32(sp)
    80001630:	64e2                	ld	s1,24(sp)
    80001632:	6942                	ld	s2,16(sp)
    80001634:	69a2                	ld	s3,8(sp)
    80001636:	6a02                	ld	s4,0(sp)
    80001638:	6145                	addi	sp,sp,48
    8000163a:	8082                	ret

000000008000163c <exit>:
{
    8000163c:	7179                	addi	sp,sp,-48
    8000163e:	f406                	sd	ra,40(sp)
    80001640:	f022                	sd	s0,32(sp)
    80001642:	ec26                	sd	s1,24(sp)
    80001644:	e84a                	sd	s2,16(sp)
    80001646:	e44e                	sd	s3,8(sp)
    80001648:	e052                	sd	s4,0(sp)
    8000164a:	1800                	addi	s0,sp,48
    8000164c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000164e:	00000097          	auipc	ra,0x0
    80001652:	80a080e7          	jalr	-2038(ra) # 80000e58 <myproc>
    80001656:	89aa                	mv	s3,a0
  if(p == initproc)
    80001658:	00007797          	auipc	a5,0x7
    8000165c:	3d87b783          	ld	a5,984(a5) # 80008a30 <initproc>
    80001660:	0d050493          	addi	s1,a0,208
    80001664:	15050913          	addi	s2,a0,336
    80001668:	02a79363          	bne	a5,a0,8000168e <exit+0x52>
    panic("init exiting");
    8000166c:	00007517          	auipc	a0,0x7
    80001670:	b7450513          	addi	a0,a0,-1164 # 800081e0 <etext+0x1e0>
    80001674:	00004097          	auipc	ra,0x4
    80001678:	5ee080e7          	jalr	1518(ra) # 80005c62 <panic>
      fileclose(f);
    8000167c:	00002097          	auipc	ra,0x2
    80001680:	374080e7          	jalr	884(ra) # 800039f0 <fileclose>
      p->ofile[fd] = 0;
    80001684:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001688:	04a1                	addi	s1,s1,8
    8000168a:	01248563          	beq	s1,s2,80001694 <exit+0x58>
    if(p->ofile[fd]){
    8000168e:	6088                	ld	a0,0(s1)
    80001690:	f575                	bnez	a0,8000167c <exit+0x40>
    80001692:	bfdd                	j	80001688 <exit+0x4c>
  begin_op();
    80001694:	00002097          	auipc	ra,0x2
    80001698:	e90080e7          	jalr	-368(ra) # 80003524 <begin_op>
  iput(p->cwd);
    8000169c:	1509b503          	ld	a0,336(s3)
    800016a0:	00001097          	auipc	ra,0x1
    800016a4:	67c080e7          	jalr	1660(ra) # 80002d1c <iput>
  end_op();
    800016a8:	00002097          	auipc	ra,0x2
    800016ac:	efc080e7          	jalr	-260(ra) # 800035a4 <end_op>
  p->cwd = 0;
    800016b0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016b4:	00007497          	auipc	s1,0x7
    800016b8:	3d448493          	addi	s1,s1,980 # 80008a88 <wait_lock>
    800016bc:	8526                	mv	a0,s1
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	aee080e7          	jalr	-1298(ra) # 800061ac <acquire>
  reparent(p);
    800016c6:	854e                	mv	a0,s3
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	f1a080e7          	jalr	-230(ra) # 800015e2 <reparent>
  wakeup(p->parent);
    800016d0:	0389b503          	ld	a0,56(s3)
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	e98080e7          	jalr	-360(ra) # 8000156c <wakeup>
  acquire(&p->lock);
    800016dc:	854e                	mv	a0,s3
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	ace080e7          	jalr	-1330(ra) # 800061ac <acquire>
  p->xstate = status;
    800016e6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016ea:	4795                	li	a5,5
    800016ec:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016f0:	8526                	mv	a0,s1
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	b6e080e7          	jalr	-1170(ra) # 80006260 <release>
  sched();
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	cfc080e7          	jalr	-772(ra) # 800013f6 <sched>
  panic("zombie exit");
    80001702:	00007517          	auipc	a0,0x7
    80001706:	aee50513          	addi	a0,a0,-1298 # 800081f0 <etext+0x1f0>
    8000170a:	00004097          	auipc	ra,0x4
    8000170e:	558080e7          	jalr	1368(ra) # 80005c62 <panic>

0000000080001712 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001712:	7179                	addi	sp,sp,-48
    80001714:	f406                	sd	ra,40(sp)
    80001716:	f022                	sd	s0,32(sp)
    80001718:	ec26                	sd	s1,24(sp)
    8000171a:	e84a                	sd	s2,16(sp)
    8000171c:	e44e                	sd	s3,8(sp)
    8000171e:	1800                	addi	s0,sp,48
    80001720:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001722:	00007497          	auipc	s1,0x7
    80001726:	77e48493          	addi	s1,s1,1918 # 80008ea0 <proc>
    8000172a:	0000d997          	auipc	s3,0xd
    8000172e:	37698993          	addi	s3,s3,886 # 8000eaa0 <tickslock>
    acquire(&p->lock);
    80001732:	8526                	mv	a0,s1
    80001734:	00005097          	auipc	ra,0x5
    80001738:	a78080e7          	jalr	-1416(ra) # 800061ac <acquire>
    if(p->pid == pid){
    8000173c:	589c                	lw	a5,48(s1)
    8000173e:	01278d63          	beq	a5,s2,80001758 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	00005097          	auipc	ra,0x5
    80001748:	b1c080e7          	jalr	-1252(ra) # 80006260 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000174c:	17048493          	addi	s1,s1,368
    80001750:	ff3491e3          	bne	s1,s3,80001732 <kill+0x20>
  }
  return -1;
    80001754:	557d                	li	a0,-1
    80001756:	a829                	j	80001770 <kill+0x5e>
      p->killed = 1;
    80001758:	4785                	li	a5,1
    8000175a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000175c:	4c98                	lw	a4,24(s1)
    8000175e:	4789                	li	a5,2
    80001760:	00f70f63          	beq	a4,a5,8000177e <kill+0x6c>
      release(&p->lock);
    80001764:	8526                	mv	a0,s1
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	afa080e7          	jalr	-1286(ra) # 80006260 <release>
      return 0;
    8000176e:	4501                	li	a0,0
}
    80001770:	70a2                	ld	ra,40(sp)
    80001772:	7402                	ld	s0,32(sp)
    80001774:	64e2                	ld	s1,24(sp)
    80001776:	6942                	ld	s2,16(sp)
    80001778:	69a2                	ld	s3,8(sp)
    8000177a:	6145                	addi	sp,sp,48
    8000177c:	8082                	ret
        p->state = RUNNABLE;
    8000177e:	478d                	li	a5,3
    80001780:	cc9c                	sw	a5,24(s1)
    80001782:	b7cd                	j	80001764 <kill+0x52>

0000000080001784 <setkilled>:

void
setkilled(struct proc *p)
{
    80001784:	1101                	addi	sp,sp,-32
    80001786:	ec06                	sd	ra,24(sp)
    80001788:	e822                	sd	s0,16(sp)
    8000178a:	e426                	sd	s1,8(sp)
    8000178c:	1000                	addi	s0,sp,32
    8000178e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001790:	00005097          	auipc	ra,0x5
    80001794:	a1c080e7          	jalr	-1508(ra) # 800061ac <acquire>
  p->killed = 1;
    80001798:	4785                	li	a5,1
    8000179a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	ac2080e7          	jalr	-1342(ra) # 80006260 <release>
}
    800017a6:	60e2                	ld	ra,24(sp)
    800017a8:	6442                	ld	s0,16(sp)
    800017aa:	64a2                	ld	s1,8(sp)
    800017ac:	6105                	addi	sp,sp,32
    800017ae:	8082                	ret

00000000800017b0 <killed>:

int
killed(struct proc *p)
{
    800017b0:	1101                	addi	sp,sp,-32
    800017b2:	ec06                	sd	ra,24(sp)
    800017b4:	e822                	sd	s0,16(sp)
    800017b6:	e426                	sd	s1,8(sp)
    800017b8:	e04a                	sd	s2,0(sp)
    800017ba:	1000                	addi	s0,sp,32
    800017bc:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	9ee080e7          	jalr	-1554(ra) # 800061ac <acquire>
  k = p->killed;
    800017c6:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017ca:	8526                	mv	a0,s1
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	a94080e7          	jalr	-1388(ra) # 80006260 <release>
  return k;
}
    800017d4:	854a                	mv	a0,s2
    800017d6:	60e2                	ld	ra,24(sp)
    800017d8:	6442                	ld	s0,16(sp)
    800017da:	64a2                	ld	s1,8(sp)
    800017dc:	6902                	ld	s2,0(sp)
    800017de:	6105                	addi	sp,sp,32
    800017e0:	8082                	ret

00000000800017e2 <wait>:
{
    800017e2:	715d                	addi	sp,sp,-80
    800017e4:	e486                	sd	ra,72(sp)
    800017e6:	e0a2                	sd	s0,64(sp)
    800017e8:	fc26                	sd	s1,56(sp)
    800017ea:	f84a                	sd	s2,48(sp)
    800017ec:	f44e                	sd	s3,40(sp)
    800017ee:	f052                	sd	s4,32(sp)
    800017f0:	ec56                	sd	s5,24(sp)
    800017f2:	e85a                	sd	s6,16(sp)
    800017f4:	e45e                	sd	s7,8(sp)
    800017f6:	e062                	sd	s8,0(sp)
    800017f8:	0880                	addi	s0,sp,80
    800017fa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017fc:	fffff097          	auipc	ra,0xfffff
    80001800:	65c080e7          	jalr	1628(ra) # 80000e58 <myproc>
    80001804:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001806:	00007517          	auipc	a0,0x7
    8000180a:	28250513          	addi	a0,a0,642 # 80008a88 <wait_lock>
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	99e080e7          	jalr	-1634(ra) # 800061ac <acquire>
    havekids = 0;
    80001816:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001818:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000181a:	0000d997          	auipc	s3,0xd
    8000181e:	28698993          	addi	s3,s3,646 # 8000eaa0 <tickslock>
        havekids = 1;
    80001822:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001824:	00007c17          	auipc	s8,0x7
    80001828:	264c0c13          	addi	s8,s8,612 # 80008a88 <wait_lock>
    havekids = 0;
    8000182c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000182e:	00007497          	auipc	s1,0x7
    80001832:	67248493          	addi	s1,s1,1650 # 80008ea0 <proc>
    80001836:	a0bd                	j	800018a4 <wait+0xc2>
          pid = pp->pid;
    80001838:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000183c:	000b0e63          	beqz	s6,80001858 <wait+0x76>
    80001840:	4691                	li	a3,4
    80001842:	02c48613          	addi	a2,s1,44
    80001846:	85da                	mv	a1,s6
    80001848:	05093503          	ld	a0,80(s2)
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	2ca080e7          	jalr	714(ra) # 80000b16 <copyout>
    80001854:	02054563          	bltz	a0,8000187e <wait+0x9c>
          freeproc(pp);
    80001858:	8526                	mv	a0,s1
    8000185a:	fffff097          	auipc	ra,0xfffff
    8000185e:	7b0080e7          	jalr	1968(ra) # 8000100a <freeproc>
          release(&pp->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	9fc080e7          	jalr	-1540(ra) # 80006260 <release>
          release(&wait_lock);
    8000186c:	00007517          	auipc	a0,0x7
    80001870:	21c50513          	addi	a0,a0,540 # 80008a88 <wait_lock>
    80001874:	00005097          	auipc	ra,0x5
    80001878:	9ec080e7          	jalr	-1556(ra) # 80006260 <release>
          return pid;
    8000187c:	a0b5                	j	800018e8 <wait+0x106>
            release(&pp->lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	00005097          	auipc	ra,0x5
    80001884:	9e0080e7          	jalr	-1568(ra) # 80006260 <release>
            release(&wait_lock);
    80001888:	00007517          	auipc	a0,0x7
    8000188c:	20050513          	addi	a0,a0,512 # 80008a88 <wait_lock>
    80001890:	00005097          	auipc	ra,0x5
    80001894:	9d0080e7          	jalr	-1584(ra) # 80006260 <release>
            return -1;
    80001898:	59fd                	li	s3,-1
    8000189a:	a0b9                	j	800018e8 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000189c:	17048493          	addi	s1,s1,368
    800018a0:	03348463          	beq	s1,s3,800018c8 <wait+0xe6>
      if(pp->parent == p){
    800018a4:	7c9c                	ld	a5,56(s1)
    800018a6:	ff279be3          	bne	a5,s2,8000189c <wait+0xba>
        acquire(&pp->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	900080e7          	jalr	-1792(ra) # 800061ac <acquire>
        if(pp->state == ZOMBIE){
    800018b4:	4c9c                	lw	a5,24(s1)
    800018b6:	f94781e3          	beq	a5,s4,80001838 <wait+0x56>
        release(&pp->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	9a4080e7          	jalr	-1628(ra) # 80006260 <release>
        havekids = 1;
    800018c4:	8756                	mv	a4,s5
    800018c6:	bfd9                	j	8000189c <wait+0xba>
    if(!havekids || killed(p)){
    800018c8:	c719                	beqz	a4,800018d6 <wait+0xf4>
    800018ca:	854a                	mv	a0,s2
    800018cc:	00000097          	auipc	ra,0x0
    800018d0:	ee4080e7          	jalr	-284(ra) # 800017b0 <killed>
    800018d4:	c51d                	beqz	a0,80001902 <wait+0x120>
      release(&wait_lock);
    800018d6:	00007517          	auipc	a0,0x7
    800018da:	1b250513          	addi	a0,a0,434 # 80008a88 <wait_lock>
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	982080e7          	jalr	-1662(ra) # 80006260 <release>
      return -1;
    800018e6:	59fd                	li	s3,-1
}
    800018e8:	854e                	mv	a0,s3
    800018ea:	60a6                	ld	ra,72(sp)
    800018ec:	6406                	ld	s0,64(sp)
    800018ee:	74e2                	ld	s1,56(sp)
    800018f0:	7942                	ld	s2,48(sp)
    800018f2:	79a2                	ld	s3,40(sp)
    800018f4:	7a02                	ld	s4,32(sp)
    800018f6:	6ae2                	ld	s5,24(sp)
    800018f8:	6b42                	ld	s6,16(sp)
    800018fa:	6ba2                	ld	s7,8(sp)
    800018fc:	6c02                	ld	s8,0(sp)
    800018fe:	6161                	addi	sp,sp,80
    80001900:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001902:	85e2                	mv	a1,s8
    80001904:	854a                	mv	a0,s2
    80001906:	00000097          	auipc	ra,0x0
    8000190a:	c02080e7          	jalr	-1022(ra) # 80001508 <sleep>
    havekids = 0;
    8000190e:	bf39                	j	8000182c <wait+0x4a>

0000000080001910 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001910:	7179                	addi	sp,sp,-48
    80001912:	f406                	sd	ra,40(sp)
    80001914:	f022                	sd	s0,32(sp)
    80001916:	ec26                	sd	s1,24(sp)
    80001918:	e84a                	sd	s2,16(sp)
    8000191a:	e44e                	sd	s3,8(sp)
    8000191c:	e052                	sd	s4,0(sp)
    8000191e:	1800                	addi	s0,sp,48
    80001920:	84aa                	mv	s1,a0
    80001922:	892e                	mv	s2,a1
    80001924:	89b2                	mv	s3,a2
    80001926:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	530080e7          	jalr	1328(ra) # 80000e58 <myproc>
  if(user_dst){
    80001930:	c08d                	beqz	s1,80001952 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001932:	86d2                	mv	a3,s4
    80001934:	864e                	mv	a2,s3
    80001936:	85ca                	mv	a1,s2
    80001938:	6928                	ld	a0,80(a0)
    8000193a:	fffff097          	auipc	ra,0xfffff
    8000193e:	1dc080e7          	jalr	476(ra) # 80000b16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001942:	70a2                	ld	ra,40(sp)
    80001944:	7402                	ld	s0,32(sp)
    80001946:	64e2                	ld	s1,24(sp)
    80001948:	6942                	ld	s2,16(sp)
    8000194a:	69a2                	ld	s3,8(sp)
    8000194c:	6a02                	ld	s4,0(sp)
    8000194e:	6145                	addi	sp,sp,48
    80001950:	8082                	ret
    memmove((char *)dst, src, len);
    80001952:	000a061b          	sext.w	a2,s4
    80001956:	85ce                	mv	a1,s3
    80001958:	854a                	mv	a0,s2
    8000195a:	fffff097          	auipc	ra,0xfffff
    8000195e:	87e080e7          	jalr	-1922(ra) # 800001d8 <memmove>
    return 0;
    80001962:	8526                	mv	a0,s1
    80001964:	bff9                	j	80001942 <either_copyout+0x32>

0000000080001966 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001966:	7179                	addi	sp,sp,-48
    80001968:	f406                	sd	ra,40(sp)
    8000196a:	f022                	sd	s0,32(sp)
    8000196c:	ec26                	sd	s1,24(sp)
    8000196e:	e84a                	sd	s2,16(sp)
    80001970:	e44e                	sd	s3,8(sp)
    80001972:	e052                	sd	s4,0(sp)
    80001974:	1800                	addi	s0,sp,48
    80001976:	892a                	mv	s2,a0
    80001978:	84ae                	mv	s1,a1
    8000197a:	89b2                	mv	s3,a2
    8000197c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	4da080e7          	jalr	1242(ra) # 80000e58 <myproc>
  if(user_src){
    80001986:	c08d                	beqz	s1,800019a8 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001988:	86d2                	mv	a3,s4
    8000198a:	864e                	mv	a2,s3
    8000198c:	85ca                	mv	a1,s2
    8000198e:	6928                	ld	a0,80(a0)
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	212080e7          	jalr	530(ra) # 80000ba2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001998:	70a2                	ld	ra,40(sp)
    8000199a:	7402                	ld	s0,32(sp)
    8000199c:	64e2                	ld	s1,24(sp)
    8000199e:	6942                	ld	s2,16(sp)
    800019a0:	69a2                	ld	s3,8(sp)
    800019a2:	6a02                	ld	s4,0(sp)
    800019a4:	6145                	addi	sp,sp,48
    800019a6:	8082                	ret
    memmove(dst, (char*)src, len);
    800019a8:	000a061b          	sext.w	a2,s4
    800019ac:	85ce                	mv	a1,s3
    800019ae:	854a                	mv	a0,s2
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	828080e7          	jalr	-2008(ra) # 800001d8 <memmove>
    return 0;
    800019b8:	8526                	mv	a0,s1
    800019ba:	bff9                	j	80001998 <either_copyin+0x32>

00000000800019bc <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019bc:	715d                	addi	sp,sp,-80
    800019be:	e486                	sd	ra,72(sp)
    800019c0:	e0a2                	sd	s0,64(sp)
    800019c2:	fc26                	sd	s1,56(sp)
    800019c4:	f84a                	sd	s2,48(sp)
    800019c6:	f44e                	sd	s3,40(sp)
    800019c8:	f052                	sd	s4,32(sp)
    800019ca:	ec56                	sd	s5,24(sp)
    800019cc:	e85a                	sd	s6,16(sp)
    800019ce:	e45e                	sd	s7,8(sp)
    800019d0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019d2:	00006517          	auipc	a0,0x6
    800019d6:	67650513          	addi	a0,a0,1654 # 80008048 <etext+0x48>
    800019da:	00004097          	auipc	ra,0x4
    800019de:	2d2080e7          	jalr	722(ra) # 80005cac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019e2:	00007497          	auipc	s1,0x7
    800019e6:	61648493          	addi	s1,s1,1558 # 80008ff8 <proc+0x158>
    800019ea:	0000d917          	auipc	s2,0xd
    800019ee:	20e90913          	addi	s2,s2,526 # 8000ebf8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019f4:	00007997          	auipc	s3,0x7
    800019f8:	80c98993          	addi	s3,s3,-2036 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019fc:	00007a97          	auipc	s5,0x7
    80001a00:	80ca8a93          	addi	s5,s5,-2036 # 80008208 <etext+0x208>
    printf("\n");
    80001a04:	00006a17          	auipc	s4,0x6
    80001a08:	644a0a13          	addi	s4,s4,1604 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0c:	00007b97          	auipc	s7,0x7
    80001a10:	83cb8b93          	addi	s7,s7,-1988 # 80008248 <states.1723>
    80001a14:	a00d                	j	80001a36 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a16:	ed86a583          	lw	a1,-296(a3)
    80001a1a:	8556                	mv	a0,s5
    80001a1c:	00004097          	auipc	ra,0x4
    80001a20:	290080e7          	jalr	656(ra) # 80005cac <printf>
    printf("\n");
    80001a24:	8552                	mv	a0,s4
    80001a26:	00004097          	auipc	ra,0x4
    80001a2a:	286080e7          	jalr	646(ra) # 80005cac <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2e:	17048493          	addi	s1,s1,368
    80001a32:	03248163          	beq	s1,s2,80001a54 <procdump+0x98>
    if(p->state == UNUSED)
    80001a36:	86a6                	mv	a3,s1
    80001a38:	ec04a783          	lw	a5,-320(s1)
    80001a3c:	dbed                	beqz	a5,80001a2e <procdump+0x72>
      state = "???";
    80001a3e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a40:	fcfb6be3          	bltu	s6,a5,80001a16 <procdump+0x5a>
    80001a44:	1782                	slli	a5,a5,0x20
    80001a46:	9381                	srli	a5,a5,0x20
    80001a48:	078e                	slli	a5,a5,0x3
    80001a4a:	97de                	add	a5,a5,s7
    80001a4c:	6390                	ld	a2,0(a5)
    80001a4e:	f661                	bnez	a2,80001a16 <procdump+0x5a>
      state = "???";
    80001a50:	864e                	mv	a2,s3
    80001a52:	b7d1                	j	80001a16 <procdump+0x5a>
  }
}
    80001a54:	60a6                	ld	ra,72(sp)
    80001a56:	6406                	ld	s0,64(sp)
    80001a58:	74e2                	ld	s1,56(sp)
    80001a5a:	7942                	ld	s2,48(sp)
    80001a5c:	79a2                	ld	s3,40(sp)
    80001a5e:	7a02                	ld	s4,32(sp)
    80001a60:	6ae2                	ld	s5,24(sp)
    80001a62:	6b42                	ld	s6,16(sp)
    80001a64:	6ba2                	ld	s7,8(sp)
    80001a66:	6161                	addi	sp,sp,80
    80001a68:	8082                	ret

0000000080001a6a <swtch>:
    80001a6a:	00153023          	sd	ra,0(a0)
    80001a6e:	00253423          	sd	sp,8(a0)
    80001a72:	e900                	sd	s0,16(a0)
    80001a74:	ed04                	sd	s1,24(a0)
    80001a76:	03253023          	sd	s2,32(a0)
    80001a7a:	03353423          	sd	s3,40(a0)
    80001a7e:	03453823          	sd	s4,48(a0)
    80001a82:	03553c23          	sd	s5,56(a0)
    80001a86:	05653023          	sd	s6,64(a0)
    80001a8a:	05753423          	sd	s7,72(a0)
    80001a8e:	05853823          	sd	s8,80(a0)
    80001a92:	05953c23          	sd	s9,88(a0)
    80001a96:	07a53023          	sd	s10,96(a0)
    80001a9a:	07b53423          	sd	s11,104(a0)
    80001a9e:	0005b083          	ld	ra,0(a1)
    80001aa2:	0085b103          	ld	sp,8(a1)
    80001aa6:	6980                	ld	s0,16(a1)
    80001aa8:	6d84                	ld	s1,24(a1)
    80001aaa:	0205b903          	ld	s2,32(a1)
    80001aae:	0285b983          	ld	s3,40(a1)
    80001ab2:	0305ba03          	ld	s4,48(a1)
    80001ab6:	0385ba83          	ld	s5,56(a1)
    80001aba:	0405bb03          	ld	s6,64(a1)
    80001abe:	0485bb83          	ld	s7,72(a1)
    80001ac2:	0505bc03          	ld	s8,80(a1)
    80001ac6:	0585bc83          	ld	s9,88(a1)
    80001aca:	0605bd03          	ld	s10,96(a1)
    80001ace:	0685bd83          	ld	s11,104(a1)
    80001ad2:	8082                	ret

0000000080001ad4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ad4:	1141                	addi	sp,sp,-16
    80001ad6:	e406                	sd	ra,8(sp)
    80001ad8:	e022                	sd	s0,0(sp)
    80001ada:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001adc:	00006597          	auipc	a1,0x6
    80001ae0:	79c58593          	addi	a1,a1,1948 # 80008278 <states.1723+0x30>
    80001ae4:	0000d517          	auipc	a0,0xd
    80001ae8:	fbc50513          	addi	a0,a0,-68 # 8000eaa0 <tickslock>
    80001aec:	00004097          	auipc	ra,0x4
    80001af0:	630080e7          	jalr	1584(ra) # 8000611c <initlock>
}
    80001af4:	60a2                	ld	ra,8(sp)
    80001af6:	6402                	ld	s0,0(sp)
    80001af8:	0141                	addi	sp,sp,16
    80001afa:	8082                	ret

0000000080001afc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001afc:	1141                	addi	sp,sp,-16
    80001afe:	e422                	sd	s0,8(sp)
    80001b00:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b02:	00003797          	auipc	a5,0x3
    80001b06:	52e78793          	addi	a5,a5,1326 # 80005030 <kernelvec>
    80001b0a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b0e:	6422                	ld	s0,8(sp)
    80001b10:	0141                	addi	sp,sp,16
    80001b12:	8082                	ret

0000000080001b14 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b14:	1141                	addi	sp,sp,-16
    80001b16:	e406                	sd	ra,8(sp)
    80001b18:	e022                	sd	s0,0(sp)
    80001b1a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b1c:	fffff097          	auipc	ra,0xfffff
    80001b20:	33c080e7          	jalr	828(ra) # 80000e58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b28:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b2a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b2e:	00005617          	auipc	a2,0x5
    80001b32:	4d260613          	addi	a2,a2,1234 # 80007000 <_trampoline>
    80001b36:	00005697          	auipc	a3,0x5
    80001b3a:	4ca68693          	addi	a3,a3,1226 # 80007000 <_trampoline>
    80001b3e:	8e91                	sub	a3,a3,a2
    80001b40:	040007b7          	lui	a5,0x4000
    80001b44:	17fd                	addi	a5,a5,-1
    80001b46:	07b2                	slli	a5,a5,0xc
    80001b48:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b4a:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b4e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b50:	180026f3          	csrr	a3,satp
    80001b54:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b56:	6d38                	ld	a4,88(a0)
    80001b58:	6134                	ld	a3,64(a0)
    80001b5a:	6585                	lui	a1,0x1
    80001b5c:	96ae                	add	a3,a3,a1
    80001b5e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b60:	6d38                	ld	a4,88(a0)
    80001b62:	00000697          	auipc	a3,0x0
    80001b66:	13068693          	addi	a3,a3,304 # 80001c92 <usertrap>
    80001b6a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b6c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b6e:	8692                	mv	a3,tp
    80001b70:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b72:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b76:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b7a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b82:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b84:	6f18                	ld	a4,24(a4)
    80001b86:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b8a:	6928                	ld	a0,80(a0)
    80001b8c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b8e:	00005717          	auipc	a4,0x5
    80001b92:	50e70713          	addi	a4,a4,1294 # 8000709c <userret>
    80001b96:	8f11                	sub	a4,a4,a2
    80001b98:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b9a:	577d                	li	a4,-1
    80001b9c:	177e                	slli	a4,a4,0x3f
    80001b9e:	8d59                	or	a0,a0,a4
    80001ba0:	9782                	jalr	a5
}
    80001ba2:	60a2                	ld	ra,8(sp)
    80001ba4:	6402                	ld	s0,0(sp)
    80001ba6:	0141                	addi	sp,sp,16
    80001ba8:	8082                	ret

0000000080001baa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001baa:	1101                	addi	sp,sp,-32
    80001bac:	ec06                	sd	ra,24(sp)
    80001bae:	e822                	sd	s0,16(sp)
    80001bb0:	e426                	sd	s1,8(sp)
    80001bb2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bb4:	0000d497          	auipc	s1,0xd
    80001bb8:	eec48493          	addi	s1,s1,-276 # 8000eaa0 <tickslock>
    80001bbc:	8526                	mv	a0,s1
    80001bbe:	00004097          	auipc	ra,0x4
    80001bc2:	5ee080e7          	jalr	1518(ra) # 800061ac <acquire>
  ticks++;
    80001bc6:	00007517          	auipc	a0,0x7
    80001bca:	e7250513          	addi	a0,a0,-398 # 80008a38 <ticks>
    80001bce:	411c                	lw	a5,0(a0)
    80001bd0:	2785                	addiw	a5,a5,1
    80001bd2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bd4:	00000097          	auipc	ra,0x0
    80001bd8:	998080e7          	jalr	-1640(ra) # 8000156c <wakeup>
  release(&tickslock);
    80001bdc:	8526                	mv	a0,s1
    80001bde:	00004097          	auipc	ra,0x4
    80001be2:	682080e7          	jalr	1666(ra) # 80006260 <release>
}
    80001be6:	60e2                	ld	ra,24(sp)
    80001be8:	6442                	ld	s0,16(sp)
    80001bea:	64a2                	ld	s1,8(sp)
    80001bec:	6105                	addi	sp,sp,32
    80001bee:	8082                	ret

0000000080001bf0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bf0:	1101                	addi	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bfa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bfe:	00074d63          	bltz	a4,80001c18 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c02:	57fd                	li	a5,-1
    80001c04:	17fe                	slli	a5,a5,0x3f
    80001c06:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c08:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c0a:	06f70363          	beq	a4,a5,80001c70 <devintr+0x80>
  }
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6105                	addi	sp,sp,32
    80001c16:	8082                	ret
     (scause & 0xff) == 9){
    80001c18:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c1c:	46a5                	li	a3,9
    80001c1e:	fed792e3          	bne	a5,a3,80001c02 <devintr+0x12>
    int irq = plic_claim();
    80001c22:	00003097          	auipc	ra,0x3
    80001c26:	516080e7          	jalr	1302(ra) # 80005138 <plic_claim>
    80001c2a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c2c:	47a9                	li	a5,10
    80001c2e:	02f50763          	beq	a0,a5,80001c5c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c32:	4785                	li	a5,1
    80001c34:	02f50963          	beq	a0,a5,80001c66 <devintr+0x76>
    return 1;
    80001c38:	4505                	li	a0,1
    } else if(irq){
    80001c3a:	d8f1                	beqz	s1,80001c0e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c3c:	85a6                	mv	a1,s1
    80001c3e:	00006517          	auipc	a0,0x6
    80001c42:	64250513          	addi	a0,a0,1602 # 80008280 <states.1723+0x38>
    80001c46:	00004097          	auipc	ra,0x4
    80001c4a:	066080e7          	jalr	102(ra) # 80005cac <printf>
      plic_complete(irq);
    80001c4e:	8526                	mv	a0,s1
    80001c50:	00003097          	auipc	ra,0x3
    80001c54:	50c080e7          	jalr	1292(ra) # 8000515c <plic_complete>
    return 1;
    80001c58:	4505                	li	a0,1
    80001c5a:	bf55                	j	80001c0e <devintr+0x1e>
      uartintr();
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	470080e7          	jalr	1136(ra) # 800060cc <uartintr>
    80001c64:	b7ed                	j	80001c4e <devintr+0x5e>
      virtio_disk_intr();
    80001c66:	00004097          	auipc	ra,0x4
    80001c6a:	a20080e7          	jalr	-1504(ra) # 80005686 <virtio_disk_intr>
    80001c6e:	b7c5                	j	80001c4e <devintr+0x5e>
    if(cpuid() == 0){
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	1bc080e7          	jalr	444(ra) # 80000e2c <cpuid>
    80001c78:	c901                	beqz	a0,80001c88 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c7a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c80:	14479073          	csrw	sip,a5
    return 2;
    80001c84:	4509                	li	a0,2
    80001c86:	b761                	j	80001c0e <devintr+0x1e>
      clockintr();
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	f22080e7          	jalr	-222(ra) # 80001baa <clockintr>
    80001c90:	b7ed                	j	80001c7a <devintr+0x8a>

0000000080001c92 <usertrap>:
{
    80001c92:	1101                	addi	sp,sp,-32
    80001c94:	ec06                	sd	ra,24(sp)
    80001c96:	e822                	sd	s0,16(sp)
    80001c98:	e426                	sd	s1,8(sp)
    80001c9a:	e04a                	sd	s2,0(sp)
    80001c9c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c9e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ca2:	1007f793          	andi	a5,a5,256
    80001ca6:	e3b1                	bnez	a5,80001cea <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca8:	00003797          	auipc	a5,0x3
    80001cac:	38878793          	addi	a5,a5,904 # 80005030 <kernelvec>
    80001cb0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cb4:	fffff097          	auipc	ra,0xfffff
    80001cb8:	1a4080e7          	jalr	420(ra) # 80000e58 <myproc>
    80001cbc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cbe:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cc0:	14102773          	csrr	a4,sepc
    80001cc4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cca:	47a1                	li	a5,8
    80001ccc:	02f70763          	beq	a4,a5,80001cfa <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	f20080e7          	jalr	-224(ra) # 80001bf0 <devintr>
    80001cd8:	892a                	mv	s2,a0
    80001cda:	c151                	beqz	a0,80001d5e <usertrap+0xcc>
  if(killed(p))
    80001cdc:	8526                	mv	a0,s1
    80001cde:	00000097          	auipc	ra,0x0
    80001ce2:	ad2080e7          	jalr	-1326(ra) # 800017b0 <killed>
    80001ce6:	c929                	beqz	a0,80001d38 <usertrap+0xa6>
    80001ce8:	a099                	j	80001d2e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	5b650513          	addi	a0,a0,1462 # 800082a0 <states.1723+0x58>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	f70080e7          	jalr	-144(ra) # 80005c62 <panic>
    if(killed(p))
    80001cfa:	00000097          	auipc	ra,0x0
    80001cfe:	ab6080e7          	jalr	-1354(ra) # 800017b0 <killed>
    80001d02:	e921                	bnez	a0,80001d52 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d04:	6cb8                	ld	a4,88(s1)
    80001d06:	6f1c                	ld	a5,24(a4)
    80001d08:	0791                	addi	a5,a5,4
    80001d0a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d10:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d14:	10079073          	csrw	sstatus,a5
    syscall();
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	2d4080e7          	jalr	724(ra) # 80001fec <syscall>
  if(killed(p))
    80001d20:	8526                	mv	a0,s1
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	a8e080e7          	jalr	-1394(ra) # 800017b0 <killed>
    80001d2a:	c911                	beqz	a0,80001d3e <usertrap+0xac>
    80001d2c:	4901                	li	s2,0
    exit(-1);
    80001d2e:	557d                	li	a0,-1
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	90c080e7          	jalr	-1780(ra) # 8000163c <exit>
  if(which_dev == 2)
    80001d38:	4789                	li	a5,2
    80001d3a:	04f90f63          	beq	s2,a5,80001d98 <usertrap+0x106>
  usertrapret();
    80001d3e:	00000097          	auipc	ra,0x0
    80001d42:	dd6080e7          	jalr	-554(ra) # 80001b14 <usertrapret>
}
    80001d46:	60e2                	ld	ra,24(sp)
    80001d48:	6442                	ld	s0,16(sp)
    80001d4a:	64a2                	ld	s1,8(sp)
    80001d4c:	6902                	ld	s2,0(sp)
    80001d4e:	6105                	addi	sp,sp,32
    80001d50:	8082                	ret
      exit(-1);
    80001d52:	557d                	li	a0,-1
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	8e8080e7          	jalr	-1816(ra) # 8000163c <exit>
    80001d5c:	b765                	j	80001d04 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d62:	5890                	lw	a2,48(s1)
    80001d64:	00006517          	auipc	a0,0x6
    80001d68:	55c50513          	addi	a0,a0,1372 # 800082c0 <states.1723+0x78>
    80001d6c:	00004097          	auipc	ra,0x4
    80001d70:	f40080e7          	jalr	-192(ra) # 80005cac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d74:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d78:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d7c:	00006517          	auipc	a0,0x6
    80001d80:	57450513          	addi	a0,a0,1396 # 800082f0 <states.1723+0xa8>
    80001d84:	00004097          	auipc	ra,0x4
    80001d88:	f28080e7          	jalr	-216(ra) # 80005cac <printf>
    setkilled(p);
    80001d8c:	8526                	mv	a0,s1
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	9f6080e7          	jalr	-1546(ra) # 80001784 <setkilled>
    80001d96:	b769                	j	80001d20 <usertrap+0x8e>
    yield();
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	734080e7          	jalr	1844(ra) # 800014cc <yield>
    80001da0:	bf79                	j	80001d3e <usertrap+0xac>

0000000080001da2 <kerneltrap>:
{
    80001da2:	7179                	addi	sp,sp,-48
    80001da4:	f406                	sd	ra,40(sp)
    80001da6:	f022                	sd	s0,32(sp)
    80001da8:	ec26                	sd	s1,24(sp)
    80001daa:	e84a                	sd	s2,16(sp)
    80001dac:	e44e                	sd	s3,8(sp)
    80001dae:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db0:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db4:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db8:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001dbc:	1004f793          	andi	a5,s1,256
    80001dc0:	cb85                	beqz	a5,80001df0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dc2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dc6:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dc8:	ef85                	bnez	a5,80001e00 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	e26080e7          	jalr	-474(ra) # 80001bf0 <devintr>
    80001dd2:	cd1d                	beqz	a0,80001e10 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dd4:	4789                	li	a5,2
    80001dd6:	06f50a63          	beq	a0,a5,80001e4a <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dda:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dde:	10049073          	csrw	sstatus,s1
}
    80001de2:	70a2                	ld	ra,40(sp)
    80001de4:	7402                	ld	s0,32(sp)
    80001de6:	64e2                	ld	s1,24(sp)
    80001de8:	6942                	ld	s2,16(sp)
    80001dea:	69a2                	ld	s3,8(sp)
    80001dec:	6145                	addi	sp,sp,48
    80001dee:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	52050513          	addi	a0,a0,1312 # 80008310 <states.1723+0xc8>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	e6a080e7          	jalr	-406(ra) # 80005c62 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	53850513          	addi	a0,a0,1336 # 80008338 <states.1723+0xf0>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	e5a080e7          	jalr	-422(ra) # 80005c62 <panic>
    printf("scause %p\n", scause);
    80001e10:	85ce                	mv	a1,s3
    80001e12:	00006517          	auipc	a0,0x6
    80001e16:	54650513          	addi	a0,a0,1350 # 80008358 <states.1723+0x110>
    80001e1a:	00004097          	auipc	ra,0x4
    80001e1e:	e92080e7          	jalr	-366(ra) # 80005cac <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e22:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e26:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	53e50513          	addi	a0,a0,1342 # 80008368 <states.1723+0x120>
    80001e32:	00004097          	auipc	ra,0x4
    80001e36:	e7a080e7          	jalr	-390(ra) # 80005cac <printf>
    panic("kerneltrap");
    80001e3a:	00006517          	auipc	a0,0x6
    80001e3e:	54650513          	addi	a0,a0,1350 # 80008380 <states.1723+0x138>
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	e20080e7          	jalr	-480(ra) # 80005c62 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e4a:	fffff097          	auipc	ra,0xfffff
    80001e4e:	00e080e7          	jalr	14(ra) # 80000e58 <myproc>
    80001e52:	d541                	beqz	a0,80001dda <kerneltrap+0x38>
    80001e54:	fffff097          	auipc	ra,0xfffff
    80001e58:	004080e7          	jalr	4(ra) # 80000e58 <myproc>
    80001e5c:	4d18                	lw	a4,24(a0)
    80001e5e:	4791                	li	a5,4
    80001e60:	f6f71de3          	bne	a4,a5,80001dda <kerneltrap+0x38>
    yield();
    80001e64:	fffff097          	auipc	ra,0xfffff
    80001e68:	668080e7          	jalr	1640(ra) # 800014cc <yield>
    80001e6c:	b7bd                	j	80001dda <kerneltrap+0x38>

0000000080001e6e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e6e:	1101                	addi	sp,sp,-32
    80001e70:	ec06                	sd	ra,24(sp)
    80001e72:	e822                	sd	s0,16(sp)
    80001e74:	e426                	sd	s1,8(sp)
    80001e76:	1000                	addi	s0,sp,32
    80001e78:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e7a:	fffff097          	auipc	ra,0xfffff
    80001e7e:	fde080e7          	jalr	-34(ra) # 80000e58 <myproc>
  switch (n) {
    80001e82:	4795                	li	a5,5
    80001e84:	0497e163          	bltu	a5,s1,80001ec6 <argraw+0x58>
    80001e88:	048a                	slli	s1,s1,0x2
    80001e8a:	00006717          	auipc	a4,0x6
    80001e8e:	5ee70713          	addi	a4,a4,1518 # 80008478 <states.1723+0x230>
    80001e92:	94ba                	add	s1,s1,a4
    80001e94:	409c                	lw	a5,0(s1)
    80001e96:	97ba                	add	a5,a5,a4
    80001e98:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e9a:	6d3c                	ld	a5,88(a0)
    80001e9c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e9e:	60e2                	ld	ra,24(sp)
    80001ea0:	6442                	ld	s0,16(sp)
    80001ea2:	64a2                	ld	s1,8(sp)
    80001ea4:	6105                	addi	sp,sp,32
    80001ea6:	8082                	ret
    return p->trapframe->a1;
    80001ea8:	6d3c                	ld	a5,88(a0)
    80001eaa:	7fa8                	ld	a0,120(a5)
    80001eac:	bfcd                	j	80001e9e <argraw+0x30>
    return p->trapframe->a2;
    80001eae:	6d3c                	ld	a5,88(a0)
    80001eb0:	63c8                	ld	a0,128(a5)
    80001eb2:	b7f5                	j	80001e9e <argraw+0x30>
    return p->trapframe->a3;
    80001eb4:	6d3c                	ld	a5,88(a0)
    80001eb6:	67c8                	ld	a0,136(a5)
    80001eb8:	b7dd                	j	80001e9e <argraw+0x30>
    return p->trapframe->a4;
    80001eba:	6d3c                	ld	a5,88(a0)
    80001ebc:	6bc8                	ld	a0,144(a5)
    80001ebe:	b7c5                	j	80001e9e <argraw+0x30>
    return p->trapframe->a5;
    80001ec0:	6d3c                	ld	a5,88(a0)
    80001ec2:	6fc8                	ld	a0,152(a5)
    80001ec4:	bfe9                	j	80001e9e <argraw+0x30>
  panic("argraw");
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	4ca50513          	addi	a0,a0,1226 # 80008390 <states.1723+0x148>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	d94080e7          	jalr	-620(ra) # 80005c62 <panic>

0000000080001ed6 <fetchaddr>:
{
    80001ed6:	1101                	addi	sp,sp,-32
    80001ed8:	ec06                	sd	ra,24(sp)
    80001eda:	e822                	sd	s0,16(sp)
    80001edc:	e426                	sd	s1,8(sp)
    80001ede:	e04a                	sd	s2,0(sp)
    80001ee0:	1000                	addi	s0,sp,32
    80001ee2:	84aa                	mv	s1,a0
    80001ee4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ee6:	fffff097          	auipc	ra,0xfffff
    80001eea:	f72080e7          	jalr	-142(ra) # 80000e58 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001eee:	653c                	ld	a5,72(a0)
    80001ef0:	02f4f863          	bgeu	s1,a5,80001f20 <fetchaddr+0x4a>
    80001ef4:	00848713          	addi	a4,s1,8
    80001ef8:	02e7e663          	bltu	a5,a4,80001f24 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001efc:	46a1                	li	a3,8
    80001efe:	8626                	mv	a2,s1
    80001f00:	85ca                	mv	a1,s2
    80001f02:	6928                	ld	a0,80(a0)
    80001f04:	fffff097          	auipc	ra,0xfffff
    80001f08:	c9e080e7          	jalr	-866(ra) # 80000ba2 <copyin>
    80001f0c:	00a03533          	snez	a0,a0
    80001f10:	40a00533          	neg	a0,a0
}
    80001f14:	60e2                	ld	ra,24(sp)
    80001f16:	6442                	ld	s0,16(sp)
    80001f18:	64a2                	ld	s1,8(sp)
    80001f1a:	6902                	ld	s2,0(sp)
    80001f1c:	6105                	addi	sp,sp,32
    80001f1e:	8082                	ret
    return -1;
    80001f20:	557d                	li	a0,-1
    80001f22:	bfcd                	j	80001f14 <fetchaddr+0x3e>
    80001f24:	557d                	li	a0,-1
    80001f26:	b7fd                	j	80001f14 <fetchaddr+0x3e>

0000000080001f28 <fetchstr>:
{
    80001f28:	7179                	addi	sp,sp,-48
    80001f2a:	f406                	sd	ra,40(sp)
    80001f2c:	f022                	sd	s0,32(sp)
    80001f2e:	ec26                	sd	s1,24(sp)
    80001f30:	e84a                	sd	s2,16(sp)
    80001f32:	e44e                	sd	s3,8(sp)
    80001f34:	1800                	addi	s0,sp,48
    80001f36:	892a                	mv	s2,a0
    80001f38:	84ae                	mv	s1,a1
    80001f3a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f3c:	fffff097          	auipc	ra,0xfffff
    80001f40:	f1c080e7          	jalr	-228(ra) # 80000e58 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f44:	86ce                	mv	a3,s3
    80001f46:	864a                	mv	a2,s2
    80001f48:	85a6                	mv	a1,s1
    80001f4a:	6928                	ld	a0,80(a0)
    80001f4c:	fffff097          	auipc	ra,0xfffff
    80001f50:	ce2080e7          	jalr	-798(ra) # 80000c2e <copyinstr>
    80001f54:	00054e63          	bltz	a0,80001f70 <fetchstr+0x48>
  return strlen(buf);
    80001f58:	8526                	mv	a0,s1
    80001f5a:	ffffe097          	auipc	ra,0xffffe
    80001f5e:	3a2080e7          	jalr	930(ra) # 800002fc <strlen>
}
    80001f62:	70a2                	ld	ra,40(sp)
    80001f64:	7402                	ld	s0,32(sp)
    80001f66:	64e2                	ld	s1,24(sp)
    80001f68:	6942                	ld	s2,16(sp)
    80001f6a:	69a2                	ld	s3,8(sp)
    80001f6c:	6145                	addi	sp,sp,48
    80001f6e:	8082                	ret
    return -1;
    80001f70:	557d                	li	a0,-1
    80001f72:	bfc5                	j	80001f62 <fetchstr+0x3a>

0000000080001f74 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f74:	1101                	addi	sp,sp,-32
    80001f76:	ec06                	sd	ra,24(sp)
    80001f78:	e822                	sd	s0,16(sp)
    80001f7a:	e426                	sd	s1,8(sp)
    80001f7c:	1000                	addi	s0,sp,32
    80001f7e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	eee080e7          	jalr	-274(ra) # 80001e6e <argraw>
    80001f88:	c088                	sw	a0,0(s1)
}
    80001f8a:	60e2                	ld	ra,24(sp)
    80001f8c:	6442                	ld	s0,16(sp)
    80001f8e:	64a2                	ld	s1,8(sp)
    80001f90:	6105                	addi	sp,sp,32
    80001f92:	8082                	ret

0000000080001f94 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f94:	1101                	addi	sp,sp,-32
    80001f96:	ec06                	sd	ra,24(sp)
    80001f98:	e822                	sd	s0,16(sp)
    80001f9a:	e426                	sd	s1,8(sp)
    80001f9c:	1000                	addi	s0,sp,32
    80001f9e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fa0:	00000097          	auipc	ra,0x0
    80001fa4:	ece080e7          	jalr	-306(ra) # 80001e6e <argraw>
    80001fa8:	e088                	sd	a0,0(s1)
}
    80001faa:	60e2                	ld	ra,24(sp)
    80001fac:	6442                	ld	s0,16(sp)
    80001fae:	64a2                	ld	s1,8(sp)
    80001fb0:	6105                	addi	sp,sp,32
    80001fb2:	8082                	ret

0000000080001fb4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fb4:	7179                	addi	sp,sp,-48
    80001fb6:	f406                	sd	ra,40(sp)
    80001fb8:	f022                	sd	s0,32(sp)
    80001fba:	ec26                	sd	s1,24(sp)
    80001fbc:	e84a                	sd	s2,16(sp)
    80001fbe:	1800                	addi	s0,sp,48
    80001fc0:	84ae                	mv	s1,a1
    80001fc2:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001fc4:	fd840593          	addi	a1,s0,-40
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	fcc080e7          	jalr	-52(ra) # 80001f94 <argaddr>
  return fetchstr(addr, buf, max);
    80001fd0:	864a                	mv	a2,s2
    80001fd2:	85a6                	mv	a1,s1
    80001fd4:	fd843503          	ld	a0,-40(s0)
    80001fd8:	00000097          	auipc	ra,0x0
    80001fdc:	f50080e7          	jalr	-176(ra) # 80001f28 <fetchstr>
}
    80001fe0:	70a2                	ld	ra,40(sp)
    80001fe2:	7402                	ld	s0,32(sp)
    80001fe4:	64e2                	ld	s1,24(sp)
    80001fe6:	6942                	ld	s2,16(sp)
    80001fe8:	6145                	addi	sp,sp,48
    80001fea:	8082                	ret

0000000080001fec <syscall>:
  "sbrk", "sleep", "uptime", "open", "write", "mknod", "unlink", "link", "mkdir", "close", "trace"
};

void
syscall(void)
{
    80001fec:	7179                	addi	sp,sp,-48
    80001fee:	f406                	sd	ra,40(sp)
    80001ff0:	f022                	sd	s0,32(sp)
    80001ff2:	ec26                	sd	s1,24(sp)
    80001ff4:	e84a                	sd	s2,16(sp)
    80001ff6:	e44e                	sd	s3,8(sp)
    80001ff8:	e052                	sd	s4,0(sp)
    80001ffa:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	e5c080e7          	jalr	-420(ra) # 80000e58 <myproc>
    80002004:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002006:	05853983          	ld	s3,88(a0)
    8000200a:	0a89b783          	ld	a5,168(s3)
    8000200e:	00078a1b          	sext.w	s4,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002012:	37fd                	addiw	a5,a5,-1
    80002014:	4755                	li	a4,21
    80002016:	04f76c63          	bltu	a4,a5,8000206e <syscall+0x82>
    8000201a:	003a1713          	slli	a4,s4,0x3
    8000201e:	00006797          	auipc	a5,0x6
    80002022:	47278793          	addi	a5,a5,1138 # 80008490 <syscalls>
    80002026:	97ba                	add	a5,a5,a4
    80002028:	639c                	ld	a5,0(a5)
    8000202a:	c3b1                	beqz	a5,8000206e <syscall+0x82>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    int trace_mask = p->trace_mask;
    8000202c:	16852903          	lw	s2,360(a0)
    p->trapframe->a0 = syscalls[num]();
    80002030:	9782                	jalr	a5
    80002032:	06a9b823          	sd	a0,112(s3)
    if((trace_mask >> num) & 1){
    80002036:	4149593b          	sraw	s2,s2,s4
    8000203a:	00197913          	andi	s2,s2,1
    8000203e:	04090763          	beqz	s2,8000208c <syscall+0xa0>
      printf("%d syscall %s -> %d\n", p->pid, syscall_names[num - 1], p->trapframe->a0);
    80002042:	6cb8                	ld	a4,88(s1)
    80002044:	3a7d                	addiw	s4,s4,-1
    80002046:	003a1793          	slli	a5,s4,0x3
    8000204a:	00006a17          	auipc	s4,0x6
    8000204e:	446a0a13          	addi	s4,s4,1094 # 80008490 <syscalls>
    80002052:	9a3e                	add	s4,s4,a5
    80002054:	7b34                	ld	a3,112(a4)
    80002056:	0b8a3603          	ld	a2,184(s4)
    8000205a:	588c                	lw	a1,48(s1)
    8000205c:	00006517          	auipc	a0,0x6
    80002060:	33c50513          	addi	a0,a0,828 # 80008398 <states.1723+0x150>
    80002064:	00004097          	auipc	ra,0x4
    80002068:	c48080e7          	jalr	-952(ra) # 80005cac <printf>
    8000206c:	a005                	j	8000208c <syscall+0xa0>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000206e:	86d2                	mv	a3,s4
    80002070:	15848613          	addi	a2,s1,344
    80002074:	588c                	lw	a1,48(s1)
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	33a50513          	addi	a0,a0,826 # 800083b0 <states.1723+0x168>
    8000207e:	00004097          	auipc	ra,0x4
    80002082:	c2e080e7          	jalr	-978(ra) # 80005cac <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002086:	6cbc                	ld	a5,88(s1)
    80002088:	577d                	li	a4,-1
    8000208a:	fbb8                	sd	a4,112(a5)
  }
}
    8000208c:	70a2                	ld	ra,40(sp)
    8000208e:	7402                	ld	s0,32(sp)
    80002090:	64e2                	ld	s1,24(sp)
    80002092:	6942                	ld	s2,16(sp)
    80002094:	69a2                	ld	s3,8(sp)
    80002096:	6a02                	ld	s4,0(sp)
    80002098:	6145                	addi	sp,sp,48
    8000209a:	8082                	ret

000000008000209c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000209c:	1101                	addi	sp,sp,-32
    8000209e:	ec06                	sd	ra,24(sp)
    800020a0:	e822                	sd	s0,16(sp)
    800020a2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020a4:	fec40593          	addi	a1,s0,-20
    800020a8:	4501                	li	a0,0
    800020aa:	00000097          	auipc	ra,0x0
    800020ae:	eca080e7          	jalr	-310(ra) # 80001f74 <argint>
  exit(n);
    800020b2:	fec42503          	lw	a0,-20(s0)
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	586080e7          	jalr	1414(ra) # 8000163c <exit>
  return 0;  // not reached
}
    800020be:	4501                	li	a0,0
    800020c0:	60e2                	ld	ra,24(sp)
    800020c2:	6442                	ld	s0,16(sp)
    800020c4:	6105                	addi	sp,sp,32
    800020c6:	8082                	ret

00000000800020c8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020c8:	1141                	addi	sp,sp,-16
    800020ca:	e406                	sd	ra,8(sp)
    800020cc:	e022                	sd	s0,0(sp)
    800020ce:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	d88080e7          	jalr	-632(ra) # 80000e58 <myproc>
}
    800020d8:	5908                	lw	a0,48(a0)
    800020da:	60a2                	ld	ra,8(sp)
    800020dc:	6402                	ld	s0,0(sp)
    800020de:	0141                	addi	sp,sp,16
    800020e0:	8082                	ret

00000000800020e2 <sys_fork>:

uint64
sys_fork(void)
{
    800020e2:	1141                	addi	sp,sp,-16
    800020e4:	e406                	sd	ra,8(sp)
    800020e6:	e022                	sd	s0,0(sp)
    800020e8:	0800                	addi	s0,sp,16
  return fork();
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	128080e7          	jalr	296(ra) # 80001212 <fork>
}
    800020f2:	60a2                	ld	ra,8(sp)
    800020f4:	6402                	ld	s0,0(sp)
    800020f6:	0141                	addi	sp,sp,16
    800020f8:	8082                	ret

00000000800020fa <sys_wait>:

uint64
sys_wait(void)
{
    800020fa:	1101                	addi	sp,sp,-32
    800020fc:	ec06                	sd	ra,24(sp)
    800020fe:	e822                	sd	s0,16(sp)
    80002100:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002102:	fe840593          	addi	a1,s0,-24
    80002106:	4501                	li	a0,0
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	e8c080e7          	jalr	-372(ra) # 80001f94 <argaddr>
  return wait(p);
    80002110:	fe843503          	ld	a0,-24(s0)
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	6ce080e7          	jalr	1742(ra) # 800017e2 <wait>
}
    8000211c:	60e2                	ld	ra,24(sp)
    8000211e:	6442                	ld	s0,16(sp)
    80002120:	6105                	addi	sp,sp,32
    80002122:	8082                	ret

0000000080002124 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002124:	7179                	addi	sp,sp,-48
    80002126:	f406                	sd	ra,40(sp)
    80002128:	f022                	sd	s0,32(sp)
    8000212a:	ec26                	sd	s1,24(sp)
    8000212c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000212e:	fdc40593          	addi	a1,s0,-36
    80002132:	4501                	li	a0,0
    80002134:	00000097          	auipc	ra,0x0
    80002138:	e40080e7          	jalr	-448(ra) # 80001f74 <argint>
  addr = myproc()->sz;
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	d1c080e7          	jalr	-740(ra) # 80000e58 <myproc>
    80002144:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002146:	fdc42503          	lw	a0,-36(s0)
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	06c080e7          	jalr	108(ra) # 800011b6 <growproc>
    80002152:	00054863          	bltz	a0,80002162 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002156:	8526                	mv	a0,s1
    80002158:	70a2                	ld	ra,40(sp)
    8000215a:	7402                	ld	s0,32(sp)
    8000215c:	64e2                	ld	s1,24(sp)
    8000215e:	6145                	addi	sp,sp,48
    80002160:	8082                	ret
    return -1;
    80002162:	54fd                	li	s1,-1
    80002164:	bfcd                	j	80002156 <sys_sbrk+0x32>

0000000080002166 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002166:	7139                	addi	sp,sp,-64
    80002168:	fc06                	sd	ra,56(sp)
    8000216a:	f822                	sd	s0,48(sp)
    8000216c:	f426                	sd	s1,40(sp)
    8000216e:	f04a                	sd	s2,32(sp)
    80002170:	ec4e                	sd	s3,24(sp)
    80002172:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002174:	fcc40593          	addi	a1,s0,-52
    80002178:	4501                	li	a0,0
    8000217a:	00000097          	auipc	ra,0x0
    8000217e:	dfa080e7          	jalr	-518(ra) # 80001f74 <argint>
  if(n < 0)
    80002182:	fcc42783          	lw	a5,-52(s0)
    80002186:	0607cf63          	bltz	a5,80002204 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000218a:	0000d517          	auipc	a0,0xd
    8000218e:	91650513          	addi	a0,a0,-1770 # 8000eaa0 <tickslock>
    80002192:	00004097          	auipc	ra,0x4
    80002196:	01a080e7          	jalr	26(ra) # 800061ac <acquire>
  ticks0 = ticks;
    8000219a:	00007917          	auipc	s2,0x7
    8000219e:	89e92903          	lw	s2,-1890(s2) # 80008a38 <ticks>
  while(ticks - ticks0 < n){
    800021a2:	fcc42783          	lw	a5,-52(s0)
    800021a6:	cf9d                	beqz	a5,800021e4 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021a8:	0000d997          	auipc	s3,0xd
    800021ac:	8f898993          	addi	s3,s3,-1800 # 8000eaa0 <tickslock>
    800021b0:	00007497          	auipc	s1,0x7
    800021b4:	88848493          	addi	s1,s1,-1912 # 80008a38 <ticks>
    if(killed(myproc())){
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	ca0080e7          	jalr	-864(ra) # 80000e58 <myproc>
    800021c0:	fffff097          	auipc	ra,0xfffff
    800021c4:	5f0080e7          	jalr	1520(ra) # 800017b0 <killed>
    800021c8:	e129                	bnez	a0,8000220a <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800021ca:	85ce                	mv	a1,s3
    800021cc:	8526                	mv	a0,s1
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	33a080e7          	jalr	826(ra) # 80001508 <sleep>
  while(ticks - ticks0 < n){
    800021d6:	409c                	lw	a5,0(s1)
    800021d8:	412787bb          	subw	a5,a5,s2
    800021dc:	fcc42703          	lw	a4,-52(s0)
    800021e0:	fce7ece3          	bltu	a5,a4,800021b8 <sys_sleep+0x52>
  }
  release(&tickslock);
    800021e4:	0000d517          	auipc	a0,0xd
    800021e8:	8bc50513          	addi	a0,a0,-1860 # 8000eaa0 <tickslock>
    800021ec:	00004097          	auipc	ra,0x4
    800021f0:	074080e7          	jalr	116(ra) # 80006260 <release>
  return 0;
    800021f4:	4501                	li	a0,0
}
    800021f6:	70e2                	ld	ra,56(sp)
    800021f8:	7442                	ld	s0,48(sp)
    800021fa:	74a2                	ld	s1,40(sp)
    800021fc:	7902                	ld	s2,32(sp)
    800021fe:	69e2                	ld	s3,24(sp)
    80002200:	6121                	addi	sp,sp,64
    80002202:	8082                	ret
    n = 0;
    80002204:	fc042623          	sw	zero,-52(s0)
    80002208:	b749                	j	8000218a <sys_sleep+0x24>
      release(&tickslock);
    8000220a:	0000d517          	auipc	a0,0xd
    8000220e:	89650513          	addi	a0,a0,-1898 # 8000eaa0 <tickslock>
    80002212:	00004097          	auipc	ra,0x4
    80002216:	04e080e7          	jalr	78(ra) # 80006260 <release>
      return -1;
    8000221a:	557d                	li	a0,-1
    8000221c:	bfe9                	j	800021f6 <sys_sleep+0x90>

000000008000221e <sys_kill>:

uint64
sys_kill(void)
{
    8000221e:	1101                	addi	sp,sp,-32
    80002220:	ec06                	sd	ra,24(sp)
    80002222:	e822                	sd	s0,16(sp)
    80002224:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002226:	fec40593          	addi	a1,s0,-20
    8000222a:	4501                	li	a0,0
    8000222c:	00000097          	auipc	ra,0x0
    80002230:	d48080e7          	jalr	-696(ra) # 80001f74 <argint>
  return kill(pid);
    80002234:	fec42503          	lw	a0,-20(s0)
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	4da080e7          	jalr	1242(ra) # 80001712 <kill>
}
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	6105                	addi	sp,sp,32
    80002246:	8082                	ret

0000000080002248 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002248:	1101                	addi	sp,sp,-32
    8000224a:	ec06                	sd	ra,24(sp)
    8000224c:	e822                	sd	s0,16(sp)
    8000224e:	e426                	sd	s1,8(sp)
    80002250:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002252:	0000d517          	auipc	a0,0xd
    80002256:	84e50513          	addi	a0,a0,-1970 # 8000eaa0 <tickslock>
    8000225a:	00004097          	auipc	ra,0x4
    8000225e:	f52080e7          	jalr	-174(ra) # 800061ac <acquire>
  xticks = ticks;
    80002262:	00006497          	auipc	s1,0x6
    80002266:	7d64a483          	lw	s1,2006(s1) # 80008a38 <ticks>
  release(&tickslock);
    8000226a:	0000d517          	auipc	a0,0xd
    8000226e:	83650513          	addi	a0,a0,-1994 # 8000eaa0 <tickslock>
    80002272:	00004097          	auipc	ra,0x4
    80002276:	fee080e7          	jalr	-18(ra) # 80006260 <release>
  return xticks;
}
    8000227a:	02049513          	slli	a0,s1,0x20
    8000227e:	9101                	srli	a0,a0,0x20
    80002280:	60e2                	ld	ra,24(sp)
    80002282:	6442                	ld	s0,16(sp)
    80002284:	64a2                	ld	s1,8(sp)
    80002286:	6105                	addi	sp,sp,32
    80002288:	8082                	ret

000000008000228a <sys_trace>:


// trace 
uint64
sys_trace(void){
    8000228a:	1101                	addi	sp,sp,-32
    8000228c:	ec06                	sd	ra,24(sp)
    8000228e:	e822                	sd	s0,16(sp)
    80002290:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80002292:	fec40593          	addi	a1,s0,-20
    80002296:	4501                	li	a0,0
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	cdc080e7          	jalr	-804(ra) # 80001f74 <argint>
  struct proc *p = myproc();
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	bb8080e7          	jalr	-1096(ra) # 80000e58 <myproc>
  p->trace_mask = mask;
    800022a8:	fec42783          	lw	a5,-20(s0)
    800022ac:	16f52423          	sw	a5,360(a0)
  return 0;
}
    800022b0:	4501                	li	a0,0
    800022b2:	60e2                	ld	ra,24(sp)
    800022b4:	6442                	ld	s0,16(sp)
    800022b6:	6105                	addi	sp,sp,32
    800022b8:	8082                	ret

00000000800022ba <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022ba:	7179                	addi	sp,sp,-48
    800022bc:	f406                	sd	ra,40(sp)
    800022be:	f022                	sd	s0,32(sp)
    800022c0:	ec26                	sd	s1,24(sp)
    800022c2:	e84a                	sd	s2,16(sp)
    800022c4:	e44e                	sd	s3,8(sp)
    800022c6:	e052                	sd	s4,0(sp)
    800022c8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022ca:	00006597          	auipc	a1,0x6
    800022ce:	32e58593          	addi	a1,a1,814 # 800085f8 <syscall_names+0xb0>
    800022d2:	0000c517          	auipc	a0,0xc
    800022d6:	7e650513          	addi	a0,a0,2022 # 8000eab8 <bcache>
    800022da:	00004097          	auipc	ra,0x4
    800022de:	e42080e7          	jalr	-446(ra) # 8000611c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022e2:	00014797          	auipc	a5,0x14
    800022e6:	7d678793          	addi	a5,a5,2006 # 80016ab8 <bcache+0x8000>
    800022ea:	00015717          	auipc	a4,0x15
    800022ee:	a3670713          	addi	a4,a4,-1482 # 80016d20 <bcache+0x8268>
    800022f2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022f6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022fa:	0000c497          	auipc	s1,0xc
    800022fe:	7d648493          	addi	s1,s1,2006 # 8000ead0 <bcache+0x18>
    b->next = bcache.head.next;
    80002302:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002304:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002306:	00006a17          	auipc	s4,0x6
    8000230a:	2faa0a13          	addi	s4,s4,762 # 80008600 <syscall_names+0xb8>
    b->next = bcache.head.next;
    8000230e:	2b893783          	ld	a5,696(s2)
    80002312:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002314:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002318:	85d2                	mv	a1,s4
    8000231a:	01048513          	addi	a0,s1,16
    8000231e:	00001097          	auipc	ra,0x1
    80002322:	4c4080e7          	jalr	1220(ra) # 800037e2 <initsleeplock>
    bcache.head.next->prev = b;
    80002326:	2b893783          	ld	a5,696(s2)
    8000232a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000232c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002330:	45848493          	addi	s1,s1,1112
    80002334:	fd349de3          	bne	s1,s3,8000230e <binit+0x54>
  }
}
    80002338:	70a2                	ld	ra,40(sp)
    8000233a:	7402                	ld	s0,32(sp)
    8000233c:	64e2                	ld	s1,24(sp)
    8000233e:	6942                	ld	s2,16(sp)
    80002340:	69a2                	ld	s3,8(sp)
    80002342:	6a02                	ld	s4,0(sp)
    80002344:	6145                	addi	sp,sp,48
    80002346:	8082                	ret

0000000080002348 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002348:	7179                	addi	sp,sp,-48
    8000234a:	f406                	sd	ra,40(sp)
    8000234c:	f022                	sd	s0,32(sp)
    8000234e:	ec26                	sd	s1,24(sp)
    80002350:	e84a                	sd	s2,16(sp)
    80002352:	e44e                	sd	s3,8(sp)
    80002354:	1800                	addi	s0,sp,48
    80002356:	89aa                	mv	s3,a0
    80002358:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000235a:	0000c517          	auipc	a0,0xc
    8000235e:	75e50513          	addi	a0,a0,1886 # 8000eab8 <bcache>
    80002362:	00004097          	auipc	ra,0x4
    80002366:	e4a080e7          	jalr	-438(ra) # 800061ac <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000236a:	00015497          	auipc	s1,0x15
    8000236e:	a064b483          	ld	s1,-1530(s1) # 80016d70 <bcache+0x82b8>
    80002372:	00015797          	auipc	a5,0x15
    80002376:	9ae78793          	addi	a5,a5,-1618 # 80016d20 <bcache+0x8268>
    8000237a:	02f48f63          	beq	s1,a5,800023b8 <bread+0x70>
    8000237e:	873e                	mv	a4,a5
    80002380:	a021                	j	80002388 <bread+0x40>
    80002382:	68a4                	ld	s1,80(s1)
    80002384:	02e48a63          	beq	s1,a4,800023b8 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002388:	449c                	lw	a5,8(s1)
    8000238a:	ff379ce3          	bne	a5,s3,80002382 <bread+0x3a>
    8000238e:	44dc                	lw	a5,12(s1)
    80002390:	ff2799e3          	bne	a5,s2,80002382 <bread+0x3a>
      b->refcnt++;
    80002394:	40bc                	lw	a5,64(s1)
    80002396:	2785                	addiw	a5,a5,1
    80002398:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000239a:	0000c517          	auipc	a0,0xc
    8000239e:	71e50513          	addi	a0,a0,1822 # 8000eab8 <bcache>
    800023a2:	00004097          	auipc	ra,0x4
    800023a6:	ebe080e7          	jalr	-322(ra) # 80006260 <release>
      acquiresleep(&b->lock);
    800023aa:	01048513          	addi	a0,s1,16
    800023ae:	00001097          	auipc	ra,0x1
    800023b2:	46e080e7          	jalr	1134(ra) # 8000381c <acquiresleep>
      return b;
    800023b6:	a8b9                	j	80002414 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023b8:	00015497          	auipc	s1,0x15
    800023bc:	9b04b483          	ld	s1,-1616(s1) # 80016d68 <bcache+0x82b0>
    800023c0:	00015797          	auipc	a5,0x15
    800023c4:	96078793          	addi	a5,a5,-1696 # 80016d20 <bcache+0x8268>
    800023c8:	00f48863          	beq	s1,a5,800023d8 <bread+0x90>
    800023cc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023ce:	40bc                	lw	a5,64(s1)
    800023d0:	cf81                	beqz	a5,800023e8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023d2:	64a4                	ld	s1,72(s1)
    800023d4:	fee49de3          	bne	s1,a4,800023ce <bread+0x86>
  panic("bget: no buffers");
    800023d8:	00006517          	auipc	a0,0x6
    800023dc:	23050513          	addi	a0,a0,560 # 80008608 <syscall_names+0xc0>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	882080e7          	jalr	-1918(ra) # 80005c62 <panic>
      b->dev = dev;
    800023e8:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800023ec:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800023f0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023f4:	4785                	li	a5,1
    800023f6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023f8:	0000c517          	auipc	a0,0xc
    800023fc:	6c050513          	addi	a0,a0,1728 # 8000eab8 <bcache>
    80002400:	00004097          	auipc	ra,0x4
    80002404:	e60080e7          	jalr	-416(ra) # 80006260 <release>
      acquiresleep(&b->lock);
    80002408:	01048513          	addi	a0,s1,16
    8000240c:	00001097          	auipc	ra,0x1
    80002410:	410080e7          	jalr	1040(ra) # 8000381c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002414:	409c                	lw	a5,0(s1)
    80002416:	cb89                	beqz	a5,80002428 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002418:	8526                	mv	a0,s1
    8000241a:	70a2                	ld	ra,40(sp)
    8000241c:	7402                	ld	s0,32(sp)
    8000241e:	64e2                	ld	s1,24(sp)
    80002420:	6942                	ld	s2,16(sp)
    80002422:	69a2                	ld	s3,8(sp)
    80002424:	6145                	addi	sp,sp,48
    80002426:	8082                	ret
    virtio_disk_rw(b, 0);
    80002428:	4581                	li	a1,0
    8000242a:	8526                	mv	a0,s1
    8000242c:	00003097          	auipc	ra,0x3
    80002430:	fcc080e7          	jalr	-52(ra) # 800053f8 <virtio_disk_rw>
    b->valid = 1;
    80002434:	4785                	li	a5,1
    80002436:	c09c                	sw	a5,0(s1)
  return b;
    80002438:	b7c5                	j	80002418 <bread+0xd0>

000000008000243a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000243a:	1101                	addi	sp,sp,-32
    8000243c:	ec06                	sd	ra,24(sp)
    8000243e:	e822                	sd	s0,16(sp)
    80002440:	e426                	sd	s1,8(sp)
    80002442:	1000                	addi	s0,sp,32
    80002444:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002446:	0541                	addi	a0,a0,16
    80002448:	00001097          	auipc	ra,0x1
    8000244c:	46e080e7          	jalr	1134(ra) # 800038b6 <holdingsleep>
    80002450:	cd01                	beqz	a0,80002468 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002452:	4585                	li	a1,1
    80002454:	8526                	mv	a0,s1
    80002456:	00003097          	auipc	ra,0x3
    8000245a:	fa2080e7          	jalr	-94(ra) # 800053f8 <virtio_disk_rw>
}
    8000245e:	60e2                	ld	ra,24(sp)
    80002460:	6442                	ld	s0,16(sp)
    80002462:	64a2                	ld	s1,8(sp)
    80002464:	6105                	addi	sp,sp,32
    80002466:	8082                	ret
    panic("bwrite");
    80002468:	00006517          	auipc	a0,0x6
    8000246c:	1b850513          	addi	a0,a0,440 # 80008620 <syscall_names+0xd8>
    80002470:	00003097          	auipc	ra,0x3
    80002474:	7f2080e7          	jalr	2034(ra) # 80005c62 <panic>

0000000080002478 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002478:	1101                	addi	sp,sp,-32
    8000247a:	ec06                	sd	ra,24(sp)
    8000247c:	e822                	sd	s0,16(sp)
    8000247e:	e426                	sd	s1,8(sp)
    80002480:	e04a                	sd	s2,0(sp)
    80002482:	1000                	addi	s0,sp,32
    80002484:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002486:	01050913          	addi	s2,a0,16
    8000248a:	854a                	mv	a0,s2
    8000248c:	00001097          	auipc	ra,0x1
    80002490:	42a080e7          	jalr	1066(ra) # 800038b6 <holdingsleep>
    80002494:	c92d                	beqz	a0,80002506 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002496:	854a                	mv	a0,s2
    80002498:	00001097          	auipc	ra,0x1
    8000249c:	3da080e7          	jalr	986(ra) # 80003872 <releasesleep>

  acquire(&bcache.lock);
    800024a0:	0000c517          	auipc	a0,0xc
    800024a4:	61850513          	addi	a0,a0,1560 # 8000eab8 <bcache>
    800024a8:	00004097          	auipc	ra,0x4
    800024ac:	d04080e7          	jalr	-764(ra) # 800061ac <acquire>
  b->refcnt--;
    800024b0:	40bc                	lw	a5,64(s1)
    800024b2:	37fd                	addiw	a5,a5,-1
    800024b4:	0007871b          	sext.w	a4,a5
    800024b8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024ba:	eb05                	bnez	a4,800024ea <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024bc:	68bc                	ld	a5,80(s1)
    800024be:	64b8                	ld	a4,72(s1)
    800024c0:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800024c2:	64bc                	ld	a5,72(s1)
    800024c4:	68b8                	ld	a4,80(s1)
    800024c6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024c8:	00014797          	auipc	a5,0x14
    800024cc:	5f078793          	addi	a5,a5,1520 # 80016ab8 <bcache+0x8000>
    800024d0:	2b87b703          	ld	a4,696(a5)
    800024d4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024d6:	00015717          	auipc	a4,0x15
    800024da:	84a70713          	addi	a4,a4,-1974 # 80016d20 <bcache+0x8268>
    800024de:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024e0:	2b87b703          	ld	a4,696(a5)
    800024e4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024e6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024ea:	0000c517          	auipc	a0,0xc
    800024ee:	5ce50513          	addi	a0,a0,1486 # 8000eab8 <bcache>
    800024f2:	00004097          	auipc	ra,0x4
    800024f6:	d6e080e7          	jalr	-658(ra) # 80006260 <release>
}
    800024fa:	60e2                	ld	ra,24(sp)
    800024fc:	6442                	ld	s0,16(sp)
    800024fe:	64a2                	ld	s1,8(sp)
    80002500:	6902                	ld	s2,0(sp)
    80002502:	6105                	addi	sp,sp,32
    80002504:	8082                	ret
    panic("brelse");
    80002506:	00006517          	auipc	a0,0x6
    8000250a:	12250513          	addi	a0,a0,290 # 80008628 <syscall_names+0xe0>
    8000250e:	00003097          	auipc	ra,0x3
    80002512:	754080e7          	jalr	1876(ra) # 80005c62 <panic>

0000000080002516 <bpin>:

void
bpin(struct buf *b) {
    80002516:	1101                	addi	sp,sp,-32
    80002518:	ec06                	sd	ra,24(sp)
    8000251a:	e822                	sd	s0,16(sp)
    8000251c:	e426                	sd	s1,8(sp)
    8000251e:	1000                	addi	s0,sp,32
    80002520:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002522:	0000c517          	auipc	a0,0xc
    80002526:	59650513          	addi	a0,a0,1430 # 8000eab8 <bcache>
    8000252a:	00004097          	auipc	ra,0x4
    8000252e:	c82080e7          	jalr	-894(ra) # 800061ac <acquire>
  b->refcnt++;
    80002532:	40bc                	lw	a5,64(s1)
    80002534:	2785                	addiw	a5,a5,1
    80002536:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002538:	0000c517          	auipc	a0,0xc
    8000253c:	58050513          	addi	a0,a0,1408 # 8000eab8 <bcache>
    80002540:	00004097          	auipc	ra,0x4
    80002544:	d20080e7          	jalr	-736(ra) # 80006260 <release>
}
    80002548:	60e2                	ld	ra,24(sp)
    8000254a:	6442                	ld	s0,16(sp)
    8000254c:	64a2                	ld	s1,8(sp)
    8000254e:	6105                	addi	sp,sp,32
    80002550:	8082                	ret

0000000080002552 <bunpin>:

void
bunpin(struct buf *b) {
    80002552:	1101                	addi	sp,sp,-32
    80002554:	ec06                	sd	ra,24(sp)
    80002556:	e822                	sd	s0,16(sp)
    80002558:	e426                	sd	s1,8(sp)
    8000255a:	1000                	addi	s0,sp,32
    8000255c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000255e:	0000c517          	auipc	a0,0xc
    80002562:	55a50513          	addi	a0,a0,1370 # 8000eab8 <bcache>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	c46080e7          	jalr	-954(ra) # 800061ac <acquire>
  b->refcnt--;
    8000256e:	40bc                	lw	a5,64(s1)
    80002570:	37fd                	addiw	a5,a5,-1
    80002572:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002574:	0000c517          	auipc	a0,0xc
    80002578:	54450513          	addi	a0,a0,1348 # 8000eab8 <bcache>
    8000257c:	00004097          	auipc	ra,0x4
    80002580:	ce4080e7          	jalr	-796(ra) # 80006260 <release>
}
    80002584:	60e2                	ld	ra,24(sp)
    80002586:	6442                	ld	s0,16(sp)
    80002588:	64a2                	ld	s1,8(sp)
    8000258a:	6105                	addi	sp,sp,32
    8000258c:	8082                	ret

000000008000258e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000258e:	1101                	addi	sp,sp,-32
    80002590:	ec06                	sd	ra,24(sp)
    80002592:	e822                	sd	s0,16(sp)
    80002594:	e426                	sd	s1,8(sp)
    80002596:	e04a                	sd	s2,0(sp)
    80002598:	1000                	addi	s0,sp,32
    8000259a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000259c:	00d5d59b          	srliw	a1,a1,0xd
    800025a0:	00015797          	auipc	a5,0x15
    800025a4:	bf47a783          	lw	a5,-1036(a5) # 80017194 <sb+0x1c>
    800025a8:	9dbd                	addw	a1,a1,a5
    800025aa:	00000097          	auipc	ra,0x0
    800025ae:	d9e080e7          	jalr	-610(ra) # 80002348 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025b2:	0074f713          	andi	a4,s1,7
    800025b6:	4785                	li	a5,1
    800025b8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025bc:	14ce                	slli	s1,s1,0x33
    800025be:	90d9                	srli	s1,s1,0x36
    800025c0:	00950733          	add	a4,a0,s1
    800025c4:	05874703          	lbu	a4,88(a4)
    800025c8:	00e7f6b3          	and	a3,a5,a4
    800025cc:	c69d                	beqz	a3,800025fa <bfree+0x6c>
    800025ce:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025d0:	94aa                	add	s1,s1,a0
    800025d2:	fff7c793          	not	a5,a5
    800025d6:	8ff9                	and	a5,a5,a4
    800025d8:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800025dc:	00001097          	auipc	ra,0x1
    800025e0:	120080e7          	jalr	288(ra) # 800036fc <log_write>
  brelse(bp);
    800025e4:	854a                	mv	a0,s2
    800025e6:	00000097          	auipc	ra,0x0
    800025ea:	e92080e7          	jalr	-366(ra) # 80002478 <brelse>
}
    800025ee:	60e2                	ld	ra,24(sp)
    800025f0:	6442                	ld	s0,16(sp)
    800025f2:	64a2                	ld	s1,8(sp)
    800025f4:	6902                	ld	s2,0(sp)
    800025f6:	6105                	addi	sp,sp,32
    800025f8:	8082                	ret
    panic("freeing free block");
    800025fa:	00006517          	auipc	a0,0x6
    800025fe:	03650513          	addi	a0,a0,54 # 80008630 <syscall_names+0xe8>
    80002602:	00003097          	auipc	ra,0x3
    80002606:	660080e7          	jalr	1632(ra) # 80005c62 <panic>

000000008000260a <balloc>:
{
    8000260a:	711d                	addi	sp,sp,-96
    8000260c:	ec86                	sd	ra,88(sp)
    8000260e:	e8a2                	sd	s0,80(sp)
    80002610:	e4a6                	sd	s1,72(sp)
    80002612:	e0ca                	sd	s2,64(sp)
    80002614:	fc4e                	sd	s3,56(sp)
    80002616:	f852                	sd	s4,48(sp)
    80002618:	f456                	sd	s5,40(sp)
    8000261a:	f05a                	sd	s6,32(sp)
    8000261c:	ec5e                	sd	s7,24(sp)
    8000261e:	e862                	sd	s8,16(sp)
    80002620:	e466                	sd	s9,8(sp)
    80002622:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002624:	00015797          	auipc	a5,0x15
    80002628:	b587a783          	lw	a5,-1192(a5) # 8001717c <sb+0x4>
    8000262c:	10078163          	beqz	a5,8000272e <balloc+0x124>
    80002630:	8baa                	mv	s7,a0
    80002632:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002634:	00015b17          	auipc	s6,0x15
    80002638:	b44b0b13          	addi	s6,s6,-1212 # 80017178 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000263c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000263e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002640:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002642:	6c89                	lui	s9,0x2
    80002644:	a061                	j	800026cc <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002646:	974a                	add	a4,a4,s2
    80002648:	8fd5                	or	a5,a5,a3
    8000264a:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000264e:	854a                	mv	a0,s2
    80002650:	00001097          	auipc	ra,0x1
    80002654:	0ac080e7          	jalr	172(ra) # 800036fc <log_write>
        brelse(bp);
    80002658:	854a                	mv	a0,s2
    8000265a:	00000097          	auipc	ra,0x0
    8000265e:	e1e080e7          	jalr	-482(ra) # 80002478 <brelse>
  bp = bread(dev, bno);
    80002662:	85a6                	mv	a1,s1
    80002664:	855e                	mv	a0,s7
    80002666:	00000097          	auipc	ra,0x0
    8000266a:	ce2080e7          	jalr	-798(ra) # 80002348 <bread>
    8000266e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002670:	40000613          	li	a2,1024
    80002674:	4581                	li	a1,0
    80002676:	05850513          	addi	a0,a0,88
    8000267a:	ffffe097          	auipc	ra,0xffffe
    8000267e:	afe080e7          	jalr	-1282(ra) # 80000178 <memset>
  log_write(bp);
    80002682:	854a                	mv	a0,s2
    80002684:	00001097          	auipc	ra,0x1
    80002688:	078080e7          	jalr	120(ra) # 800036fc <log_write>
  brelse(bp);
    8000268c:	854a                	mv	a0,s2
    8000268e:	00000097          	auipc	ra,0x0
    80002692:	dea080e7          	jalr	-534(ra) # 80002478 <brelse>
}
    80002696:	8526                	mv	a0,s1
    80002698:	60e6                	ld	ra,88(sp)
    8000269a:	6446                	ld	s0,80(sp)
    8000269c:	64a6                	ld	s1,72(sp)
    8000269e:	6906                	ld	s2,64(sp)
    800026a0:	79e2                	ld	s3,56(sp)
    800026a2:	7a42                	ld	s4,48(sp)
    800026a4:	7aa2                	ld	s5,40(sp)
    800026a6:	7b02                	ld	s6,32(sp)
    800026a8:	6be2                	ld	s7,24(sp)
    800026aa:	6c42                	ld	s8,16(sp)
    800026ac:	6ca2                	ld	s9,8(sp)
    800026ae:	6125                	addi	sp,sp,96
    800026b0:	8082                	ret
    brelse(bp);
    800026b2:	854a                	mv	a0,s2
    800026b4:	00000097          	auipc	ra,0x0
    800026b8:	dc4080e7          	jalr	-572(ra) # 80002478 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026bc:	015c87bb          	addw	a5,s9,s5
    800026c0:	00078a9b          	sext.w	s5,a5
    800026c4:	004b2703          	lw	a4,4(s6)
    800026c8:	06eaf363          	bgeu	s5,a4,8000272e <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800026cc:	41fad79b          	sraiw	a5,s5,0x1f
    800026d0:	0137d79b          	srliw	a5,a5,0x13
    800026d4:	015787bb          	addw	a5,a5,s5
    800026d8:	40d7d79b          	sraiw	a5,a5,0xd
    800026dc:	01cb2583          	lw	a1,28(s6)
    800026e0:	9dbd                	addw	a1,a1,a5
    800026e2:	855e                	mv	a0,s7
    800026e4:	00000097          	auipc	ra,0x0
    800026e8:	c64080e7          	jalr	-924(ra) # 80002348 <bread>
    800026ec:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ee:	004b2503          	lw	a0,4(s6)
    800026f2:	000a849b          	sext.w	s1,s5
    800026f6:	8662                	mv	a2,s8
    800026f8:	faa4fde3          	bgeu	s1,a0,800026b2 <balloc+0xa8>
      m = 1 << (bi % 8);
    800026fc:	41f6579b          	sraiw	a5,a2,0x1f
    80002700:	01d7d69b          	srliw	a3,a5,0x1d
    80002704:	00c6873b          	addw	a4,a3,a2
    80002708:	00777793          	andi	a5,a4,7
    8000270c:	9f95                	subw	a5,a5,a3
    8000270e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002712:	4037571b          	sraiw	a4,a4,0x3
    80002716:	00e906b3          	add	a3,s2,a4
    8000271a:	0586c683          	lbu	a3,88(a3)
    8000271e:	00d7f5b3          	and	a1,a5,a3
    80002722:	d195                	beqz	a1,80002646 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002724:	2605                	addiw	a2,a2,1
    80002726:	2485                	addiw	s1,s1,1
    80002728:	fd4618e3          	bne	a2,s4,800026f8 <balloc+0xee>
    8000272c:	b759                	j	800026b2 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    8000272e:	00006517          	auipc	a0,0x6
    80002732:	f1a50513          	addi	a0,a0,-230 # 80008648 <syscall_names+0x100>
    80002736:	00003097          	auipc	ra,0x3
    8000273a:	576080e7          	jalr	1398(ra) # 80005cac <printf>
  return 0;
    8000273e:	4481                	li	s1,0
    80002740:	bf99                	j	80002696 <balloc+0x8c>

0000000080002742 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002742:	7179                	addi	sp,sp,-48
    80002744:	f406                	sd	ra,40(sp)
    80002746:	f022                	sd	s0,32(sp)
    80002748:	ec26                	sd	s1,24(sp)
    8000274a:	e84a                	sd	s2,16(sp)
    8000274c:	e44e                	sd	s3,8(sp)
    8000274e:	e052                	sd	s4,0(sp)
    80002750:	1800                	addi	s0,sp,48
    80002752:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002754:	47ad                	li	a5,11
    80002756:	02b7e763          	bltu	a5,a1,80002784 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    8000275a:	02059493          	slli	s1,a1,0x20
    8000275e:	9081                	srli	s1,s1,0x20
    80002760:	048a                	slli	s1,s1,0x2
    80002762:	94aa                	add	s1,s1,a0
    80002764:	0504a903          	lw	s2,80(s1)
    80002768:	06091e63          	bnez	s2,800027e4 <bmap+0xa2>
      addr = balloc(ip->dev);
    8000276c:	4108                	lw	a0,0(a0)
    8000276e:	00000097          	auipc	ra,0x0
    80002772:	e9c080e7          	jalr	-356(ra) # 8000260a <balloc>
    80002776:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000277a:	06090563          	beqz	s2,800027e4 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    8000277e:	0524a823          	sw	s2,80(s1)
    80002782:	a08d                	j	800027e4 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002784:	ff45849b          	addiw	s1,a1,-12
    80002788:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000278c:	0ff00793          	li	a5,255
    80002790:	08e7e563          	bltu	a5,a4,8000281a <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002794:	08052903          	lw	s2,128(a0)
    80002798:	00091d63          	bnez	s2,800027b2 <bmap+0x70>
      addr = balloc(ip->dev);
    8000279c:	4108                	lw	a0,0(a0)
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	e6c080e7          	jalr	-404(ra) # 8000260a <balloc>
    800027a6:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027aa:	02090d63          	beqz	s2,800027e4 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800027ae:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800027b2:	85ca                	mv	a1,s2
    800027b4:	0009a503          	lw	a0,0(s3)
    800027b8:	00000097          	auipc	ra,0x0
    800027bc:	b90080e7          	jalr	-1136(ra) # 80002348 <bread>
    800027c0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027c2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027c6:	02049593          	slli	a1,s1,0x20
    800027ca:	9181                	srli	a1,a1,0x20
    800027cc:	058a                	slli	a1,a1,0x2
    800027ce:	00b784b3          	add	s1,a5,a1
    800027d2:	0004a903          	lw	s2,0(s1)
    800027d6:	02090063          	beqz	s2,800027f6 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800027da:	8552                	mv	a0,s4
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	c9c080e7          	jalr	-868(ra) # 80002478 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027e4:	854a                	mv	a0,s2
    800027e6:	70a2                	ld	ra,40(sp)
    800027e8:	7402                	ld	s0,32(sp)
    800027ea:	64e2                	ld	s1,24(sp)
    800027ec:	6942                	ld	s2,16(sp)
    800027ee:	69a2                	ld	s3,8(sp)
    800027f0:	6a02                	ld	s4,0(sp)
    800027f2:	6145                	addi	sp,sp,48
    800027f4:	8082                	ret
      addr = balloc(ip->dev);
    800027f6:	0009a503          	lw	a0,0(s3)
    800027fa:	00000097          	auipc	ra,0x0
    800027fe:	e10080e7          	jalr	-496(ra) # 8000260a <balloc>
    80002802:	0005091b          	sext.w	s2,a0
      if(addr){
    80002806:	fc090ae3          	beqz	s2,800027da <bmap+0x98>
        a[bn] = addr;
    8000280a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000280e:	8552                	mv	a0,s4
    80002810:	00001097          	auipc	ra,0x1
    80002814:	eec080e7          	jalr	-276(ra) # 800036fc <log_write>
    80002818:	b7c9                	j	800027da <bmap+0x98>
  panic("bmap: out of range");
    8000281a:	00006517          	auipc	a0,0x6
    8000281e:	e4650513          	addi	a0,a0,-442 # 80008660 <syscall_names+0x118>
    80002822:	00003097          	auipc	ra,0x3
    80002826:	440080e7          	jalr	1088(ra) # 80005c62 <panic>

000000008000282a <iget>:
{
    8000282a:	7179                	addi	sp,sp,-48
    8000282c:	f406                	sd	ra,40(sp)
    8000282e:	f022                	sd	s0,32(sp)
    80002830:	ec26                	sd	s1,24(sp)
    80002832:	e84a                	sd	s2,16(sp)
    80002834:	e44e                	sd	s3,8(sp)
    80002836:	e052                	sd	s4,0(sp)
    80002838:	1800                	addi	s0,sp,48
    8000283a:	89aa                	mv	s3,a0
    8000283c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000283e:	00015517          	auipc	a0,0x15
    80002842:	95a50513          	addi	a0,a0,-1702 # 80017198 <itable>
    80002846:	00004097          	auipc	ra,0x4
    8000284a:	966080e7          	jalr	-1690(ra) # 800061ac <acquire>
  empty = 0;
    8000284e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002850:	00015497          	auipc	s1,0x15
    80002854:	96048493          	addi	s1,s1,-1696 # 800171b0 <itable+0x18>
    80002858:	00016697          	auipc	a3,0x16
    8000285c:	3e868693          	addi	a3,a3,1000 # 80018c40 <log>
    80002860:	a039                	j	8000286e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002862:	02090b63          	beqz	s2,80002898 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002866:	08848493          	addi	s1,s1,136
    8000286a:	02d48a63          	beq	s1,a3,8000289e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000286e:	449c                	lw	a5,8(s1)
    80002870:	fef059e3          	blez	a5,80002862 <iget+0x38>
    80002874:	4098                	lw	a4,0(s1)
    80002876:	ff3716e3          	bne	a4,s3,80002862 <iget+0x38>
    8000287a:	40d8                	lw	a4,4(s1)
    8000287c:	ff4713e3          	bne	a4,s4,80002862 <iget+0x38>
      ip->ref++;
    80002880:	2785                	addiw	a5,a5,1
    80002882:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002884:	00015517          	auipc	a0,0x15
    80002888:	91450513          	addi	a0,a0,-1772 # 80017198 <itable>
    8000288c:	00004097          	auipc	ra,0x4
    80002890:	9d4080e7          	jalr	-1580(ra) # 80006260 <release>
      return ip;
    80002894:	8926                	mv	s2,s1
    80002896:	a03d                	j	800028c4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002898:	f7f9                	bnez	a5,80002866 <iget+0x3c>
    8000289a:	8926                	mv	s2,s1
    8000289c:	b7e9                	j	80002866 <iget+0x3c>
  if(empty == 0)
    8000289e:	02090c63          	beqz	s2,800028d6 <iget+0xac>
  ip->dev = dev;
    800028a2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028a6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028aa:	4785                	li	a5,1
    800028ac:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028b0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028b4:	00015517          	auipc	a0,0x15
    800028b8:	8e450513          	addi	a0,a0,-1820 # 80017198 <itable>
    800028bc:	00004097          	auipc	ra,0x4
    800028c0:	9a4080e7          	jalr	-1628(ra) # 80006260 <release>
}
    800028c4:	854a                	mv	a0,s2
    800028c6:	70a2                	ld	ra,40(sp)
    800028c8:	7402                	ld	s0,32(sp)
    800028ca:	64e2                	ld	s1,24(sp)
    800028cc:	6942                	ld	s2,16(sp)
    800028ce:	69a2                	ld	s3,8(sp)
    800028d0:	6a02                	ld	s4,0(sp)
    800028d2:	6145                	addi	sp,sp,48
    800028d4:	8082                	ret
    panic("iget: no inodes");
    800028d6:	00006517          	auipc	a0,0x6
    800028da:	da250513          	addi	a0,a0,-606 # 80008678 <syscall_names+0x130>
    800028de:	00003097          	auipc	ra,0x3
    800028e2:	384080e7          	jalr	900(ra) # 80005c62 <panic>

00000000800028e6 <fsinit>:
fsinit(int dev) {
    800028e6:	7179                	addi	sp,sp,-48
    800028e8:	f406                	sd	ra,40(sp)
    800028ea:	f022                	sd	s0,32(sp)
    800028ec:	ec26                	sd	s1,24(sp)
    800028ee:	e84a                	sd	s2,16(sp)
    800028f0:	e44e                	sd	s3,8(sp)
    800028f2:	1800                	addi	s0,sp,48
    800028f4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028f6:	4585                	li	a1,1
    800028f8:	00000097          	auipc	ra,0x0
    800028fc:	a50080e7          	jalr	-1456(ra) # 80002348 <bread>
    80002900:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002902:	00015997          	auipc	s3,0x15
    80002906:	87698993          	addi	s3,s3,-1930 # 80017178 <sb>
    8000290a:	02000613          	li	a2,32
    8000290e:	05850593          	addi	a1,a0,88
    80002912:	854e                	mv	a0,s3
    80002914:	ffffe097          	auipc	ra,0xffffe
    80002918:	8c4080e7          	jalr	-1852(ra) # 800001d8 <memmove>
  brelse(bp);
    8000291c:	8526                	mv	a0,s1
    8000291e:	00000097          	auipc	ra,0x0
    80002922:	b5a080e7          	jalr	-1190(ra) # 80002478 <brelse>
  if(sb.magic != FSMAGIC)
    80002926:	0009a703          	lw	a4,0(s3)
    8000292a:	102037b7          	lui	a5,0x10203
    8000292e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002932:	02f71263          	bne	a4,a5,80002956 <fsinit+0x70>
  initlog(dev, &sb);
    80002936:	00015597          	auipc	a1,0x15
    8000293a:	84258593          	addi	a1,a1,-1982 # 80017178 <sb>
    8000293e:	854a                	mv	a0,s2
    80002940:	00001097          	auipc	ra,0x1
    80002944:	b40080e7          	jalr	-1216(ra) # 80003480 <initlog>
}
    80002948:	70a2                	ld	ra,40(sp)
    8000294a:	7402                	ld	s0,32(sp)
    8000294c:	64e2                	ld	s1,24(sp)
    8000294e:	6942                	ld	s2,16(sp)
    80002950:	69a2                	ld	s3,8(sp)
    80002952:	6145                	addi	sp,sp,48
    80002954:	8082                	ret
    panic("invalid file system");
    80002956:	00006517          	auipc	a0,0x6
    8000295a:	d3250513          	addi	a0,a0,-718 # 80008688 <syscall_names+0x140>
    8000295e:	00003097          	auipc	ra,0x3
    80002962:	304080e7          	jalr	772(ra) # 80005c62 <panic>

0000000080002966 <iinit>:
{
    80002966:	7179                	addi	sp,sp,-48
    80002968:	f406                	sd	ra,40(sp)
    8000296a:	f022                	sd	s0,32(sp)
    8000296c:	ec26                	sd	s1,24(sp)
    8000296e:	e84a                	sd	s2,16(sp)
    80002970:	e44e                	sd	s3,8(sp)
    80002972:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002974:	00006597          	auipc	a1,0x6
    80002978:	d2c58593          	addi	a1,a1,-724 # 800086a0 <syscall_names+0x158>
    8000297c:	00015517          	auipc	a0,0x15
    80002980:	81c50513          	addi	a0,a0,-2020 # 80017198 <itable>
    80002984:	00003097          	auipc	ra,0x3
    80002988:	798080e7          	jalr	1944(ra) # 8000611c <initlock>
  for(i = 0; i < NINODE; i++) {
    8000298c:	00015497          	auipc	s1,0x15
    80002990:	83448493          	addi	s1,s1,-1996 # 800171c0 <itable+0x28>
    80002994:	00016997          	auipc	s3,0x16
    80002998:	2bc98993          	addi	s3,s3,700 # 80018c50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000299c:	00006917          	auipc	s2,0x6
    800029a0:	d0c90913          	addi	s2,s2,-756 # 800086a8 <syscall_names+0x160>
    800029a4:	85ca                	mv	a1,s2
    800029a6:	8526                	mv	a0,s1
    800029a8:	00001097          	auipc	ra,0x1
    800029ac:	e3a080e7          	jalr	-454(ra) # 800037e2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029b0:	08848493          	addi	s1,s1,136
    800029b4:	ff3498e3          	bne	s1,s3,800029a4 <iinit+0x3e>
}
    800029b8:	70a2                	ld	ra,40(sp)
    800029ba:	7402                	ld	s0,32(sp)
    800029bc:	64e2                	ld	s1,24(sp)
    800029be:	6942                	ld	s2,16(sp)
    800029c0:	69a2                	ld	s3,8(sp)
    800029c2:	6145                	addi	sp,sp,48
    800029c4:	8082                	ret

00000000800029c6 <ialloc>:
{
    800029c6:	715d                	addi	sp,sp,-80
    800029c8:	e486                	sd	ra,72(sp)
    800029ca:	e0a2                	sd	s0,64(sp)
    800029cc:	fc26                	sd	s1,56(sp)
    800029ce:	f84a                	sd	s2,48(sp)
    800029d0:	f44e                	sd	s3,40(sp)
    800029d2:	f052                	sd	s4,32(sp)
    800029d4:	ec56                	sd	s5,24(sp)
    800029d6:	e85a                	sd	s6,16(sp)
    800029d8:	e45e                	sd	s7,8(sp)
    800029da:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029dc:	00014717          	auipc	a4,0x14
    800029e0:	7a872703          	lw	a4,1960(a4) # 80017184 <sb+0xc>
    800029e4:	4785                	li	a5,1
    800029e6:	04e7fa63          	bgeu	a5,a4,80002a3a <ialloc+0x74>
    800029ea:	8aaa                	mv	s5,a0
    800029ec:	8bae                	mv	s7,a1
    800029ee:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029f0:	00014a17          	auipc	s4,0x14
    800029f4:	788a0a13          	addi	s4,s4,1928 # 80017178 <sb>
    800029f8:	00048b1b          	sext.w	s6,s1
    800029fc:	0044d593          	srli	a1,s1,0x4
    80002a00:	018a2783          	lw	a5,24(s4)
    80002a04:	9dbd                	addw	a1,a1,a5
    80002a06:	8556                	mv	a0,s5
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	940080e7          	jalr	-1728(ra) # 80002348 <bread>
    80002a10:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a12:	05850993          	addi	s3,a0,88
    80002a16:	00f4f793          	andi	a5,s1,15
    80002a1a:	079a                	slli	a5,a5,0x6
    80002a1c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a1e:	00099783          	lh	a5,0(s3)
    80002a22:	c3a1                	beqz	a5,80002a62 <ialloc+0x9c>
    brelse(bp);
    80002a24:	00000097          	auipc	ra,0x0
    80002a28:	a54080e7          	jalr	-1452(ra) # 80002478 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a2c:	0485                	addi	s1,s1,1
    80002a2e:	00ca2703          	lw	a4,12(s4)
    80002a32:	0004879b          	sext.w	a5,s1
    80002a36:	fce7e1e3          	bltu	a5,a4,800029f8 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002a3a:	00006517          	auipc	a0,0x6
    80002a3e:	c7650513          	addi	a0,a0,-906 # 800086b0 <syscall_names+0x168>
    80002a42:	00003097          	auipc	ra,0x3
    80002a46:	26a080e7          	jalr	618(ra) # 80005cac <printf>
  return 0;
    80002a4a:	4501                	li	a0,0
}
    80002a4c:	60a6                	ld	ra,72(sp)
    80002a4e:	6406                	ld	s0,64(sp)
    80002a50:	74e2                	ld	s1,56(sp)
    80002a52:	7942                	ld	s2,48(sp)
    80002a54:	79a2                	ld	s3,40(sp)
    80002a56:	7a02                	ld	s4,32(sp)
    80002a58:	6ae2                	ld	s5,24(sp)
    80002a5a:	6b42                	ld	s6,16(sp)
    80002a5c:	6ba2                	ld	s7,8(sp)
    80002a5e:	6161                	addi	sp,sp,80
    80002a60:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002a62:	04000613          	li	a2,64
    80002a66:	4581                	li	a1,0
    80002a68:	854e                	mv	a0,s3
    80002a6a:	ffffd097          	auipc	ra,0xffffd
    80002a6e:	70e080e7          	jalr	1806(ra) # 80000178 <memset>
      dip->type = type;
    80002a72:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a76:	854a                	mv	a0,s2
    80002a78:	00001097          	auipc	ra,0x1
    80002a7c:	c84080e7          	jalr	-892(ra) # 800036fc <log_write>
      brelse(bp);
    80002a80:	854a                	mv	a0,s2
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	9f6080e7          	jalr	-1546(ra) # 80002478 <brelse>
      return iget(dev, inum);
    80002a8a:	85da                	mv	a1,s6
    80002a8c:	8556                	mv	a0,s5
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	d9c080e7          	jalr	-612(ra) # 8000282a <iget>
    80002a96:	bf5d                	j	80002a4c <ialloc+0x86>

0000000080002a98 <iupdate>:
{
    80002a98:	1101                	addi	sp,sp,-32
    80002a9a:	ec06                	sd	ra,24(sp)
    80002a9c:	e822                	sd	s0,16(sp)
    80002a9e:	e426                	sd	s1,8(sp)
    80002aa0:	e04a                	sd	s2,0(sp)
    80002aa2:	1000                	addi	s0,sp,32
    80002aa4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aa6:	415c                	lw	a5,4(a0)
    80002aa8:	0047d79b          	srliw	a5,a5,0x4
    80002aac:	00014597          	auipc	a1,0x14
    80002ab0:	6e45a583          	lw	a1,1764(a1) # 80017190 <sb+0x18>
    80002ab4:	9dbd                	addw	a1,a1,a5
    80002ab6:	4108                	lw	a0,0(a0)
    80002ab8:	00000097          	auipc	ra,0x0
    80002abc:	890080e7          	jalr	-1904(ra) # 80002348 <bread>
    80002ac0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ac2:	05850793          	addi	a5,a0,88
    80002ac6:	40c8                	lw	a0,4(s1)
    80002ac8:	893d                	andi	a0,a0,15
    80002aca:	051a                	slli	a0,a0,0x6
    80002acc:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002ace:	04449703          	lh	a4,68(s1)
    80002ad2:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002ad6:	04649703          	lh	a4,70(s1)
    80002ada:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002ade:	04849703          	lh	a4,72(s1)
    80002ae2:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ae6:	04a49703          	lh	a4,74(s1)
    80002aea:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002aee:	44f8                	lw	a4,76(s1)
    80002af0:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002af2:	03400613          	li	a2,52
    80002af6:	05048593          	addi	a1,s1,80
    80002afa:	0531                	addi	a0,a0,12
    80002afc:	ffffd097          	auipc	ra,0xffffd
    80002b00:	6dc080e7          	jalr	1756(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b04:	854a                	mv	a0,s2
    80002b06:	00001097          	auipc	ra,0x1
    80002b0a:	bf6080e7          	jalr	-1034(ra) # 800036fc <log_write>
  brelse(bp);
    80002b0e:	854a                	mv	a0,s2
    80002b10:	00000097          	auipc	ra,0x0
    80002b14:	968080e7          	jalr	-1688(ra) # 80002478 <brelse>
}
    80002b18:	60e2                	ld	ra,24(sp)
    80002b1a:	6442                	ld	s0,16(sp)
    80002b1c:	64a2                	ld	s1,8(sp)
    80002b1e:	6902                	ld	s2,0(sp)
    80002b20:	6105                	addi	sp,sp,32
    80002b22:	8082                	ret

0000000080002b24 <idup>:
{
    80002b24:	1101                	addi	sp,sp,-32
    80002b26:	ec06                	sd	ra,24(sp)
    80002b28:	e822                	sd	s0,16(sp)
    80002b2a:	e426                	sd	s1,8(sp)
    80002b2c:	1000                	addi	s0,sp,32
    80002b2e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b30:	00014517          	auipc	a0,0x14
    80002b34:	66850513          	addi	a0,a0,1640 # 80017198 <itable>
    80002b38:	00003097          	auipc	ra,0x3
    80002b3c:	674080e7          	jalr	1652(ra) # 800061ac <acquire>
  ip->ref++;
    80002b40:	449c                	lw	a5,8(s1)
    80002b42:	2785                	addiw	a5,a5,1
    80002b44:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b46:	00014517          	auipc	a0,0x14
    80002b4a:	65250513          	addi	a0,a0,1618 # 80017198 <itable>
    80002b4e:	00003097          	auipc	ra,0x3
    80002b52:	712080e7          	jalr	1810(ra) # 80006260 <release>
}
    80002b56:	8526                	mv	a0,s1
    80002b58:	60e2                	ld	ra,24(sp)
    80002b5a:	6442                	ld	s0,16(sp)
    80002b5c:	64a2                	ld	s1,8(sp)
    80002b5e:	6105                	addi	sp,sp,32
    80002b60:	8082                	ret

0000000080002b62 <ilock>:
{
    80002b62:	1101                	addi	sp,sp,-32
    80002b64:	ec06                	sd	ra,24(sp)
    80002b66:	e822                	sd	s0,16(sp)
    80002b68:	e426                	sd	s1,8(sp)
    80002b6a:	e04a                	sd	s2,0(sp)
    80002b6c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b6e:	c115                	beqz	a0,80002b92 <ilock+0x30>
    80002b70:	84aa                	mv	s1,a0
    80002b72:	451c                	lw	a5,8(a0)
    80002b74:	00f05f63          	blez	a5,80002b92 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b78:	0541                	addi	a0,a0,16
    80002b7a:	00001097          	auipc	ra,0x1
    80002b7e:	ca2080e7          	jalr	-862(ra) # 8000381c <acquiresleep>
  if(ip->valid == 0){
    80002b82:	40bc                	lw	a5,64(s1)
    80002b84:	cf99                	beqz	a5,80002ba2 <ilock+0x40>
}
    80002b86:	60e2                	ld	ra,24(sp)
    80002b88:	6442                	ld	s0,16(sp)
    80002b8a:	64a2                	ld	s1,8(sp)
    80002b8c:	6902                	ld	s2,0(sp)
    80002b8e:	6105                	addi	sp,sp,32
    80002b90:	8082                	ret
    panic("ilock");
    80002b92:	00006517          	auipc	a0,0x6
    80002b96:	b3650513          	addi	a0,a0,-1226 # 800086c8 <syscall_names+0x180>
    80002b9a:	00003097          	auipc	ra,0x3
    80002b9e:	0c8080e7          	jalr	200(ra) # 80005c62 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ba2:	40dc                	lw	a5,4(s1)
    80002ba4:	0047d79b          	srliw	a5,a5,0x4
    80002ba8:	00014597          	auipc	a1,0x14
    80002bac:	5e85a583          	lw	a1,1512(a1) # 80017190 <sb+0x18>
    80002bb0:	9dbd                	addw	a1,a1,a5
    80002bb2:	4088                	lw	a0,0(s1)
    80002bb4:	fffff097          	auipc	ra,0xfffff
    80002bb8:	794080e7          	jalr	1940(ra) # 80002348 <bread>
    80002bbc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bbe:	05850593          	addi	a1,a0,88
    80002bc2:	40dc                	lw	a5,4(s1)
    80002bc4:	8bbd                	andi	a5,a5,15
    80002bc6:	079a                	slli	a5,a5,0x6
    80002bc8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bca:	00059783          	lh	a5,0(a1)
    80002bce:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bd2:	00259783          	lh	a5,2(a1)
    80002bd6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bda:	00459783          	lh	a5,4(a1)
    80002bde:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002be2:	00659783          	lh	a5,6(a1)
    80002be6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bea:	459c                	lw	a5,8(a1)
    80002bec:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bee:	03400613          	li	a2,52
    80002bf2:	05b1                	addi	a1,a1,12
    80002bf4:	05048513          	addi	a0,s1,80
    80002bf8:	ffffd097          	auipc	ra,0xffffd
    80002bfc:	5e0080e7          	jalr	1504(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c00:	854a                	mv	a0,s2
    80002c02:	00000097          	auipc	ra,0x0
    80002c06:	876080e7          	jalr	-1930(ra) # 80002478 <brelse>
    ip->valid = 1;
    80002c0a:	4785                	li	a5,1
    80002c0c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c0e:	04449783          	lh	a5,68(s1)
    80002c12:	fbb5                	bnez	a5,80002b86 <ilock+0x24>
      panic("ilock: no type");
    80002c14:	00006517          	auipc	a0,0x6
    80002c18:	abc50513          	addi	a0,a0,-1348 # 800086d0 <syscall_names+0x188>
    80002c1c:	00003097          	auipc	ra,0x3
    80002c20:	046080e7          	jalr	70(ra) # 80005c62 <panic>

0000000080002c24 <iunlock>:
{
    80002c24:	1101                	addi	sp,sp,-32
    80002c26:	ec06                	sd	ra,24(sp)
    80002c28:	e822                	sd	s0,16(sp)
    80002c2a:	e426                	sd	s1,8(sp)
    80002c2c:	e04a                	sd	s2,0(sp)
    80002c2e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c30:	c905                	beqz	a0,80002c60 <iunlock+0x3c>
    80002c32:	84aa                	mv	s1,a0
    80002c34:	01050913          	addi	s2,a0,16
    80002c38:	854a                	mv	a0,s2
    80002c3a:	00001097          	auipc	ra,0x1
    80002c3e:	c7c080e7          	jalr	-900(ra) # 800038b6 <holdingsleep>
    80002c42:	cd19                	beqz	a0,80002c60 <iunlock+0x3c>
    80002c44:	449c                	lw	a5,8(s1)
    80002c46:	00f05d63          	blez	a5,80002c60 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c4a:	854a                	mv	a0,s2
    80002c4c:	00001097          	auipc	ra,0x1
    80002c50:	c26080e7          	jalr	-986(ra) # 80003872 <releasesleep>
}
    80002c54:	60e2                	ld	ra,24(sp)
    80002c56:	6442                	ld	s0,16(sp)
    80002c58:	64a2                	ld	s1,8(sp)
    80002c5a:	6902                	ld	s2,0(sp)
    80002c5c:	6105                	addi	sp,sp,32
    80002c5e:	8082                	ret
    panic("iunlock");
    80002c60:	00006517          	auipc	a0,0x6
    80002c64:	a8050513          	addi	a0,a0,-1408 # 800086e0 <syscall_names+0x198>
    80002c68:	00003097          	auipc	ra,0x3
    80002c6c:	ffa080e7          	jalr	-6(ra) # 80005c62 <panic>

0000000080002c70 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c70:	7179                	addi	sp,sp,-48
    80002c72:	f406                	sd	ra,40(sp)
    80002c74:	f022                	sd	s0,32(sp)
    80002c76:	ec26                	sd	s1,24(sp)
    80002c78:	e84a                	sd	s2,16(sp)
    80002c7a:	e44e                	sd	s3,8(sp)
    80002c7c:	e052                	sd	s4,0(sp)
    80002c7e:	1800                	addi	s0,sp,48
    80002c80:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c82:	05050493          	addi	s1,a0,80
    80002c86:	08050913          	addi	s2,a0,128
    80002c8a:	a021                	j	80002c92 <itrunc+0x22>
    80002c8c:	0491                	addi	s1,s1,4
    80002c8e:	01248d63          	beq	s1,s2,80002ca8 <itrunc+0x38>
    if(ip->addrs[i]){
    80002c92:	408c                	lw	a1,0(s1)
    80002c94:	dde5                	beqz	a1,80002c8c <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002c96:	0009a503          	lw	a0,0(s3)
    80002c9a:	00000097          	auipc	ra,0x0
    80002c9e:	8f4080e7          	jalr	-1804(ra) # 8000258e <bfree>
      ip->addrs[i] = 0;
    80002ca2:	0004a023          	sw	zero,0(s1)
    80002ca6:	b7dd                	j	80002c8c <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ca8:	0809a583          	lw	a1,128(s3)
    80002cac:	e185                	bnez	a1,80002ccc <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cae:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cb2:	854e                	mv	a0,s3
    80002cb4:	00000097          	auipc	ra,0x0
    80002cb8:	de4080e7          	jalr	-540(ra) # 80002a98 <iupdate>
}
    80002cbc:	70a2                	ld	ra,40(sp)
    80002cbe:	7402                	ld	s0,32(sp)
    80002cc0:	64e2                	ld	s1,24(sp)
    80002cc2:	6942                	ld	s2,16(sp)
    80002cc4:	69a2                	ld	s3,8(sp)
    80002cc6:	6a02                	ld	s4,0(sp)
    80002cc8:	6145                	addi	sp,sp,48
    80002cca:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ccc:	0009a503          	lw	a0,0(s3)
    80002cd0:	fffff097          	auipc	ra,0xfffff
    80002cd4:	678080e7          	jalr	1656(ra) # 80002348 <bread>
    80002cd8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cda:	05850493          	addi	s1,a0,88
    80002cde:	45850913          	addi	s2,a0,1112
    80002ce2:	a811                	j	80002cf6 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002ce4:	0009a503          	lw	a0,0(s3)
    80002ce8:	00000097          	auipc	ra,0x0
    80002cec:	8a6080e7          	jalr	-1882(ra) # 8000258e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002cf0:	0491                	addi	s1,s1,4
    80002cf2:	01248563          	beq	s1,s2,80002cfc <itrunc+0x8c>
      if(a[j])
    80002cf6:	408c                	lw	a1,0(s1)
    80002cf8:	dde5                	beqz	a1,80002cf0 <itrunc+0x80>
    80002cfa:	b7ed                	j	80002ce4 <itrunc+0x74>
    brelse(bp);
    80002cfc:	8552                	mv	a0,s4
    80002cfe:	fffff097          	auipc	ra,0xfffff
    80002d02:	77a080e7          	jalr	1914(ra) # 80002478 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d06:	0809a583          	lw	a1,128(s3)
    80002d0a:	0009a503          	lw	a0,0(s3)
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	880080e7          	jalr	-1920(ra) # 8000258e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d16:	0809a023          	sw	zero,128(s3)
    80002d1a:	bf51                	j	80002cae <itrunc+0x3e>

0000000080002d1c <iput>:
{
    80002d1c:	1101                	addi	sp,sp,-32
    80002d1e:	ec06                	sd	ra,24(sp)
    80002d20:	e822                	sd	s0,16(sp)
    80002d22:	e426                	sd	s1,8(sp)
    80002d24:	e04a                	sd	s2,0(sp)
    80002d26:	1000                	addi	s0,sp,32
    80002d28:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d2a:	00014517          	auipc	a0,0x14
    80002d2e:	46e50513          	addi	a0,a0,1134 # 80017198 <itable>
    80002d32:	00003097          	auipc	ra,0x3
    80002d36:	47a080e7          	jalr	1146(ra) # 800061ac <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d3a:	4498                	lw	a4,8(s1)
    80002d3c:	4785                	li	a5,1
    80002d3e:	02f70363          	beq	a4,a5,80002d64 <iput+0x48>
  ip->ref--;
    80002d42:	449c                	lw	a5,8(s1)
    80002d44:	37fd                	addiw	a5,a5,-1
    80002d46:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d48:	00014517          	auipc	a0,0x14
    80002d4c:	45050513          	addi	a0,a0,1104 # 80017198 <itable>
    80002d50:	00003097          	auipc	ra,0x3
    80002d54:	510080e7          	jalr	1296(ra) # 80006260 <release>
}
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	64a2                	ld	s1,8(sp)
    80002d5e:	6902                	ld	s2,0(sp)
    80002d60:	6105                	addi	sp,sp,32
    80002d62:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d64:	40bc                	lw	a5,64(s1)
    80002d66:	dff1                	beqz	a5,80002d42 <iput+0x26>
    80002d68:	04a49783          	lh	a5,74(s1)
    80002d6c:	fbf9                	bnez	a5,80002d42 <iput+0x26>
    acquiresleep(&ip->lock);
    80002d6e:	01048913          	addi	s2,s1,16
    80002d72:	854a                	mv	a0,s2
    80002d74:	00001097          	auipc	ra,0x1
    80002d78:	aa8080e7          	jalr	-1368(ra) # 8000381c <acquiresleep>
    release(&itable.lock);
    80002d7c:	00014517          	auipc	a0,0x14
    80002d80:	41c50513          	addi	a0,a0,1052 # 80017198 <itable>
    80002d84:	00003097          	auipc	ra,0x3
    80002d88:	4dc080e7          	jalr	1244(ra) # 80006260 <release>
    itrunc(ip);
    80002d8c:	8526                	mv	a0,s1
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	ee2080e7          	jalr	-286(ra) # 80002c70 <itrunc>
    ip->type = 0;
    80002d96:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d9a:	8526                	mv	a0,s1
    80002d9c:	00000097          	auipc	ra,0x0
    80002da0:	cfc080e7          	jalr	-772(ra) # 80002a98 <iupdate>
    ip->valid = 0;
    80002da4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002da8:	854a                	mv	a0,s2
    80002daa:	00001097          	auipc	ra,0x1
    80002dae:	ac8080e7          	jalr	-1336(ra) # 80003872 <releasesleep>
    acquire(&itable.lock);
    80002db2:	00014517          	auipc	a0,0x14
    80002db6:	3e650513          	addi	a0,a0,998 # 80017198 <itable>
    80002dba:	00003097          	auipc	ra,0x3
    80002dbe:	3f2080e7          	jalr	1010(ra) # 800061ac <acquire>
    80002dc2:	b741                	j	80002d42 <iput+0x26>

0000000080002dc4 <iunlockput>:
{
    80002dc4:	1101                	addi	sp,sp,-32
    80002dc6:	ec06                	sd	ra,24(sp)
    80002dc8:	e822                	sd	s0,16(sp)
    80002dca:	e426                	sd	s1,8(sp)
    80002dcc:	1000                	addi	s0,sp,32
    80002dce:	84aa                	mv	s1,a0
  iunlock(ip);
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	e54080e7          	jalr	-428(ra) # 80002c24 <iunlock>
  iput(ip);
    80002dd8:	8526                	mv	a0,s1
    80002dda:	00000097          	auipc	ra,0x0
    80002dde:	f42080e7          	jalr	-190(ra) # 80002d1c <iput>
}
    80002de2:	60e2                	ld	ra,24(sp)
    80002de4:	6442                	ld	s0,16(sp)
    80002de6:	64a2                	ld	s1,8(sp)
    80002de8:	6105                	addi	sp,sp,32
    80002dea:	8082                	ret

0000000080002dec <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dec:	1141                	addi	sp,sp,-16
    80002dee:	e422                	sd	s0,8(sp)
    80002df0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002df2:	411c                	lw	a5,0(a0)
    80002df4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002df6:	415c                	lw	a5,4(a0)
    80002df8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dfa:	04451783          	lh	a5,68(a0)
    80002dfe:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e02:	04a51783          	lh	a5,74(a0)
    80002e06:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e0a:	04c56783          	lwu	a5,76(a0)
    80002e0e:	e99c                	sd	a5,16(a1)
}
    80002e10:	6422                	ld	s0,8(sp)
    80002e12:	0141                	addi	sp,sp,16
    80002e14:	8082                	ret

0000000080002e16 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e16:	457c                	lw	a5,76(a0)
    80002e18:	0ed7e963          	bltu	a5,a3,80002f0a <readi+0xf4>
{
    80002e1c:	7159                	addi	sp,sp,-112
    80002e1e:	f486                	sd	ra,104(sp)
    80002e20:	f0a2                	sd	s0,96(sp)
    80002e22:	eca6                	sd	s1,88(sp)
    80002e24:	e8ca                	sd	s2,80(sp)
    80002e26:	e4ce                	sd	s3,72(sp)
    80002e28:	e0d2                	sd	s4,64(sp)
    80002e2a:	fc56                	sd	s5,56(sp)
    80002e2c:	f85a                	sd	s6,48(sp)
    80002e2e:	f45e                	sd	s7,40(sp)
    80002e30:	f062                	sd	s8,32(sp)
    80002e32:	ec66                	sd	s9,24(sp)
    80002e34:	e86a                	sd	s10,16(sp)
    80002e36:	e46e                	sd	s11,8(sp)
    80002e38:	1880                	addi	s0,sp,112
    80002e3a:	8b2a                	mv	s6,a0
    80002e3c:	8bae                	mv	s7,a1
    80002e3e:	8a32                	mv	s4,a2
    80002e40:	84b6                	mv	s1,a3
    80002e42:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002e44:	9f35                	addw	a4,a4,a3
    return 0;
    80002e46:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e48:	0ad76063          	bltu	a4,a3,80002ee8 <readi+0xd2>
  if(off + n > ip->size)
    80002e4c:	00e7f463          	bgeu	a5,a4,80002e54 <readi+0x3e>
    n = ip->size - off;
    80002e50:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e54:	0a0a8963          	beqz	s5,80002f06 <readi+0xf0>
    80002e58:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e5a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e5e:	5c7d                	li	s8,-1
    80002e60:	a82d                	j	80002e9a <readi+0x84>
    80002e62:	020d1d93          	slli	s11,s10,0x20
    80002e66:	020ddd93          	srli	s11,s11,0x20
    80002e6a:	05890613          	addi	a2,s2,88
    80002e6e:	86ee                	mv	a3,s11
    80002e70:	963a                	add	a2,a2,a4
    80002e72:	85d2                	mv	a1,s4
    80002e74:	855e                	mv	a0,s7
    80002e76:	fffff097          	auipc	ra,0xfffff
    80002e7a:	a9a080e7          	jalr	-1382(ra) # 80001910 <either_copyout>
    80002e7e:	05850d63          	beq	a0,s8,80002ed8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e82:	854a                	mv	a0,s2
    80002e84:	fffff097          	auipc	ra,0xfffff
    80002e88:	5f4080e7          	jalr	1524(ra) # 80002478 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e8c:	013d09bb          	addw	s3,s10,s3
    80002e90:	009d04bb          	addw	s1,s10,s1
    80002e94:	9a6e                	add	s4,s4,s11
    80002e96:	0559f763          	bgeu	s3,s5,80002ee4 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002e9a:	00a4d59b          	srliw	a1,s1,0xa
    80002e9e:	855a                	mv	a0,s6
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	8a2080e7          	jalr	-1886(ra) # 80002742 <bmap>
    80002ea8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002eac:	cd85                	beqz	a1,80002ee4 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002eae:	000b2503          	lw	a0,0(s6)
    80002eb2:	fffff097          	auipc	ra,0xfffff
    80002eb6:	496080e7          	jalr	1174(ra) # 80002348 <bread>
    80002eba:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ebc:	3ff4f713          	andi	a4,s1,1023
    80002ec0:	40ec87bb          	subw	a5,s9,a4
    80002ec4:	413a86bb          	subw	a3,s5,s3
    80002ec8:	8d3e                	mv	s10,a5
    80002eca:	2781                	sext.w	a5,a5
    80002ecc:	0006861b          	sext.w	a2,a3
    80002ed0:	f8f679e3          	bgeu	a2,a5,80002e62 <readi+0x4c>
    80002ed4:	8d36                	mv	s10,a3
    80002ed6:	b771                	j	80002e62 <readi+0x4c>
      brelse(bp);
    80002ed8:	854a                	mv	a0,s2
    80002eda:	fffff097          	auipc	ra,0xfffff
    80002ede:	59e080e7          	jalr	1438(ra) # 80002478 <brelse>
      tot = -1;
    80002ee2:	59fd                	li	s3,-1
  }
  return tot;
    80002ee4:	0009851b          	sext.w	a0,s3
}
    80002ee8:	70a6                	ld	ra,104(sp)
    80002eea:	7406                	ld	s0,96(sp)
    80002eec:	64e6                	ld	s1,88(sp)
    80002eee:	6946                	ld	s2,80(sp)
    80002ef0:	69a6                	ld	s3,72(sp)
    80002ef2:	6a06                	ld	s4,64(sp)
    80002ef4:	7ae2                	ld	s5,56(sp)
    80002ef6:	7b42                	ld	s6,48(sp)
    80002ef8:	7ba2                	ld	s7,40(sp)
    80002efa:	7c02                	ld	s8,32(sp)
    80002efc:	6ce2                	ld	s9,24(sp)
    80002efe:	6d42                	ld	s10,16(sp)
    80002f00:	6da2                	ld	s11,8(sp)
    80002f02:	6165                	addi	sp,sp,112
    80002f04:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f06:	89d6                	mv	s3,s5
    80002f08:	bff1                	j	80002ee4 <readi+0xce>
    return 0;
    80002f0a:	4501                	li	a0,0
}
    80002f0c:	8082                	ret

0000000080002f0e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f0e:	457c                	lw	a5,76(a0)
    80002f10:	10d7e863          	bltu	a5,a3,80003020 <writei+0x112>
{
    80002f14:	7159                	addi	sp,sp,-112
    80002f16:	f486                	sd	ra,104(sp)
    80002f18:	f0a2                	sd	s0,96(sp)
    80002f1a:	eca6                	sd	s1,88(sp)
    80002f1c:	e8ca                	sd	s2,80(sp)
    80002f1e:	e4ce                	sd	s3,72(sp)
    80002f20:	e0d2                	sd	s4,64(sp)
    80002f22:	fc56                	sd	s5,56(sp)
    80002f24:	f85a                	sd	s6,48(sp)
    80002f26:	f45e                	sd	s7,40(sp)
    80002f28:	f062                	sd	s8,32(sp)
    80002f2a:	ec66                	sd	s9,24(sp)
    80002f2c:	e86a                	sd	s10,16(sp)
    80002f2e:	e46e                	sd	s11,8(sp)
    80002f30:	1880                	addi	s0,sp,112
    80002f32:	8aaa                	mv	s5,a0
    80002f34:	8bae                	mv	s7,a1
    80002f36:	8a32                	mv	s4,a2
    80002f38:	8936                	mv	s2,a3
    80002f3a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f3c:	00e687bb          	addw	a5,a3,a4
    80002f40:	0ed7e263          	bltu	a5,a3,80003024 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f44:	00043737          	lui	a4,0x43
    80002f48:	0ef76063          	bltu	a4,a5,80003028 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f4c:	0c0b0863          	beqz	s6,8000301c <writei+0x10e>
    80002f50:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f52:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f56:	5c7d                	li	s8,-1
    80002f58:	a091                	j	80002f9c <writei+0x8e>
    80002f5a:	020d1d93          	slli	s11,s10,0x20
    80002f5e:	020ddd93          	srli	s11,s11,0x20
    80002f62:	05848513          	addi	a0,s1,88
    80002f66:	86ee                	mv	a3,s11
    80002f68:	8652                	mv	a2,s4
    80002f6a:	85de                	mv	a1,s7
    80002f6c:	953a                	add	a0,a0,a4
    80002f6e:	fffff097          	auipc	ra,0xfffff
    80002f72:	9f8080e7          	jalr	-1544(ra) # 80001966 <either_copyin>
    80002f76:	07850263          	beq	a0,s8,80002fda <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f7a:	8526                	mv	a0,s1
    80002f7c:	00000097          	auipc	ra,0x0
    80002f80:	780080e7          	jalr	1920(ra) # 800036fc <log_write>
    brelse(bp);
    80002f84:	8526                	mv	a0,s1
    80002f86:	fffff097          	auipc	ra,0xfffff
    80002f8a:	4f2080e7          	jalr	1266(ra) # 80002478 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f8e:	013d09bb          	addw	s3,s10,s3
    80002f92:	012d093b          	addw	s2,s10,s2
    80002f96:	9a6e                	add	s4,s4,s11
    80002f98:	0569f663          	bgeu	s3,s6,80002fe4 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80002f9c:	00a9559b          	srliw	a1,s2,0xa
    80002fa0:	8556                	mv	a0,s5
    80002fa2:	fffff097          	auipc	ra,0xfffff
    80002fa6:	7a0080e7          	jalr	1952(ra) # 80002742 <bmap>
    80002faa:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fae:	c99d                	beqz	a1,80002fe4 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80002fb0:	000aa503          	lw	a0,0(s5)
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	394080e7          	jalr	916(ra) # 80002348 <bread>
    80002fbc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fbe:	3ff97713          	andi	a4,s2,1023
    80002fc2:	40ec87bb          	subw	a5,s9,a4
    80002fc6:	413b06bb          	subw	a3,s6,s3
    80002fca:	8d3e                	mv	s10,a5
    80002fcc:	2781                	sext.w	a5,a5
    80002fce:	0006861b          	sext.w	a2,a3
    80002fd2:	f8f674e3          	bgeu	a2,a5,80002f5a <writei+0x4c>
    80002fd6:	8d36                	mv	s10,a3
    80002fd8:	b749                	j	80002f5a <writei+0x4c>
      brelse(bp);
    80002fda:	8526                	mv	a0,s1
    80002fdc:	fffff097          	auipc	ra,0xfffff
    80002fe0:	49c080e7          	jalr	1180(ra) # 80002478 <brelse>
  }

  if(off > ip->size)
    80002fe4:	04caa783          	lw	a5,76(s5)
    80002fe8:	0127f463          	bgeu	a5,s2,80002ff0 <writei+0xe2>
    ip->size = off;
    80002fec:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002ff0:	8556                	mv	a0,s5
    80002ff2:	00000097          	auipc	ra,0x0
    80002ff6:	aa6080e7          	jalr	-1370(ra) # 80002a98 <iupdate>

  return tot;
    80002ffa:	0009851b          	sext.w	a0,s3
}
    80002ffe:	70a6                	ld	ra,104(sp)
    80003000:	7406                	ld	s0,96(sp)
    80003002:	64e6                	ld	s1,88(sp)
    80003004:	6946                	ld	s2,80(sp)
    80003006:	69a6                	ld	s3,72(sp)
    80003008:	6a06                	ld	s4,64(sp)
    8000300a:	7ae2                	ld	s5,56(sp)
    8000300c:	7b42                	ld	s6,48(sp)
    8000300e:	7ba2                	ld	s7,40(sp)
    80003010:	7c02                	ld	s8,32(sp)
    80003012:	6ce2                	ld	s9,24(sp)
    80003014:	6d42                	ld	s10,16(sp)
    80003016:	6da2                	ld	s11,8(sp)
    80003018:	6165                	addi	sp,sp,112
    8000301a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000301c:	89da                	mv	s3,s6
    8000301e:	bfc9                	j	80002ff0 <writei+0xe2>
    return -1;
    80003020:	557d                	li	a0,-1
}
    80003022:	8082                	ret
    return -1;
    80003024:	557d                	li	a0,-1
    80003026:	bfe1                	j	80002ffe <writei+0xf0>
    return -1;
    80003028:	557d                	li	a0,-1
    8000302a:	bfd1                	j	80002ffe <writei+0xf0>

000000008000302c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000302c:	1141                	addi	sp,sp,-16
    8000302e:	e406                	sd	ra,8(sp)
    80003030:	e022                	sd	s0,0(sp)
    80003032:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003034:	4639                	li	a2,14
    80003036:	ffffd097          	auipc	ra,0xffffd
    8000303a:	21a080e7          	jalr	538(ra) # 80000250 <strncmp>
}
    8000303e:	60a2                	ld	ra,8(sp)
    80003040:	6402                	ld	s0,0(sp)
    80003042:	0141                	addi	sp,sp,16
    80003044:	8082                	ret

0000000080003046 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003046:	7139                	addi	sp,sp,-64
    80003048:	fc06                	sd	ra,56(sp)
    8000304a:	f822                	sd	s0,48(sp)
    8000304c:	f426                	sd	s1,40(sp)
    8000304e:	f04a                	sd	s2,32(sp)
    80003050:	ec4e                	sd	s3,24(sp)
    80003052:	e852                	sd	s4,16(sp)
    80003054:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003056:	04451703          	lh	a4,68(a0)
    8000305a:	4785                	li	a5,1
    8000305c:	00f71a63          	bne	a4,a5,80003070 <dirlookup+0x2a>
    80003060:	892a                	mv	s2,a0
    80003062:	89ae                	mv	s3,a1
    80003064:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003066:	457c                	lw	a5,76(a0)
    80003068:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000306a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000306c:	e79d                	bnez	a5,8000309a <dirlookup+0x54>
    8000306e:	a8a5                	j	800030e6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003070:	00005517          	auipc	a0,0x5
    80003074:	67850513          	addi	a0,a0,1656 # 800086e8 <syscall_names+0x1a0>
    80003078:	00003097          	auipc	ra,0x3
    8000307c:	bea080e7          	jalr	-1046(ra) # 80005c62 <panic>
      panic("dirlookup read");
    80003080:	00005517          	auipc	a0,0x5
    80003084:	68050513          	addi	a0,a0,1664 # 80008700 <syscall_names+0x1b8>
    80003088:	00003097          	auipc	ra,0x3
    8000308c:	bda080e7          	jalr	-1062(ra) # 80005c62 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003090:	24c1                	addiw	s1,s1,16
    80003092:	04c92783          	lw	a5,76(s2)
    80003096:	04f4f763          	bgeu	s1,a5,800030e4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000309a:	4741                	li	a4,16
    8000309c:	86a6                	mv	a3,s1
    8000309e:	fc040613          	addi	a2,s0,-64
    800030a2:	4581                	li	a1,0
    800030a4:	854a                	mv	a0,s2
    800030a6:	00000097          	auipc	ra,0x0
    800030aa:	d70080e7          	jalr	-656(ra) # 80002e16 <readi>
    800030ae:	47c1                	li	a5,16
    800030b0:	fcf518e3          	bne	a0,a5,80003080 <dirlookup+0x3a>
    if(de.inum == 0)
    800030b4:	fc045783          	lhu	a5,-64(s0)
    800030b8:	dfe1                	beqz	a5,80003090 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030ba:	fc240593          	addi	a1,s0,-62
    800030be:	854e                	mv	a0,s3
    800030c0:	00000097          	auipc	ra,0x0
    800030c4:	f6c080e7          	jalr	-148(ra) # 8000302c <namecmp>
    800030c8:	f561                	bnez	a0,80003090 <dirlookup+0x4a>
      if(poff)
    800030ca:	000a0463          	beqz	s4,800030d2 <dirlookup+0x8c>
        *poff = off;
    800030ce:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030d2:	fc045583          	lhu	a1,-64(s0)
    800030d6:	00092503          	lw	a0,0(s2)
    800030da:	fffff097          	auipc	ra,0xfffff
    800030de:	750080e7          	jalr	1872(ra) # 8000282a <iget>
    800030e2:	a011                	j	800030e6 <dirlookup+0xa0>
  return 0;
    800030e4:	4501                	li	a0,0
}
    800030e6:	70e2                	ld	ra,56(sp)
    800030e8:	7442                	ld	s0,48(sp)
    800030ea:	74a2                	ld	s1,40(sp)
    800030ec:	7902                	ld	s2,32(sp)
    800030ee:	69e2                	ld	s3,24(sp)
    800030f0:	6a42                	ld	s4,16(sp)
    800030f2:	6121                	addi	sp,sp,64
    800030f4:	8082                	ret

00000000800030f6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030f6:	711d                	addi	sp,sp,-96
    800030f8:	ec86                	sd	ra,88(sp)
    800030fa:	e8a2                	sd	s0,80(sp)
    800030fc:	e4a6                	sd	s1,72(sp)
    800030fe:	e0ca                	sd	s2,64(sp)
    80003100:	fc4e                	sd	s3,56(sp)
    80003102:	f852                	sd	s4,48(sp)
    80003104:	f456                	sd	s5,40(sp)
    80003106:	f05a                	sd	s6,32(sp)
    80003108:	ec5e                	sd	s7,24(sp)
    8000310a:	e862                	sd	s8,16(sp)
    8000310c:	e466                	sd	s9,8(sp)
    8000310e:	1080                	addi	s0,sp,96
    80003110:	84aa                	mv	s1,a0
    80003112:	8b2e                	mv	s6,a1
    80003114:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003116:	00054703          	lbu	a4,0(a0)
    8000311a:	02f00793          	li	a5,47
    8000311e:	02f70363          	beq	a4,a5,80003144 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003122:	ffffe097          	auipc	ra,0xffffe
    80003126:	d36080e7          	jalr	-714(ra) # 80000e58 <myproc>
    8000312a:	15053503          	ld	a0,336(a0)
    8000312e:	00000097          	auipc	ra,0x0
    80003132:	9f6080e7          	jalr	-1546(ra) # 80002b24 <idup>
    80003136:	89aa                	mv	s3,a0
  while(*path == '/')
    80003138:	02f00913          	li	s2,47
  len = path - s;
    8000313c:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000313e:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003140:	4c05                	li	s8,1
    80003142:	a865                	j	800031fa <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003144:	4585                	li	a1,1
    80003146:	4505                	li	a0,1
    80003148:	fffff097          	auipc	ra,0xfffff
    8000314c:	6e2080e7          	jalr	1762(ra) # 8000282a <iget>
    80003150:	89aa                	mv	s3,a0
    80003152:	b7dd                	j	80003138 <namex+0x42>
      iunlockput(ip);
    80003154:	854e                	mv	a0,s3
    80003156:	00000097          	auipc	ra,0x0
    8000315a:	c6e080e7          	jalr	-914(ra) # 80002dc4 <iunlockput>
      return 0;
    8000315e:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003160:	854e                	mv	a0,s3
    80003162:	60e6                	ld	ra,88(sp)
    80003164:	6446                	ld	s0,80(sp)
    80003166:	64a6                	ld	s1,72(sp)
    80003168:	6906                	ld	s2,64(sp)
    8000316a:	79e2                	ld	s3,56(sp)
    8000316c:	7a42                	ld	s4,48(sp)
    8000316e:	7aa2                	ld	s5,40(sp)
    80003170:	7b02                	ld	s6,32(sp)
    80003172:	6be2                	ld	s7,24(sp)
    80003174:	6c42                	ld	s8,16(sp)
    80003176:	6ca2                	ld	s9,8(sp)
    80003178:	6125                	addi	sp,sp,96
    8000317a:	8082                	ret
      iunlock(ip);
    8000317c:	854e                	mv	a0,s3
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	aa6080e7          	jalr	-1370(ra) # 80002c24 <iunlock>
      return ip;
    80003186:	bfe9                	j	80003160 <namex+0x6a>
      iunlockput(ip);
    80003188:	854e                	mv	a0,s3
    8000318a:	00000097          	auipc	ra,0x0
    8000318e:	c3a080e7          	jalr	-966(ra) # 80002dc4 <iunlockput>
      return 0;
    80003192:	89d2                	mv	s3,s4
    80003194:	b7f1                	j	80003160 <namex+0x6a>
  len = path - s;
    80003196:	40b48633          	sub	a2,s1,a1
    8000319a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    8000319e:	094cd463          	bge	s9,s4,80003226 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031a2:	4639                	li	a2,14
    800031a4:	8556                	mv	a0,s5
    800031a6:	ffffd097          	auipc	ra,0xffffd
    800031aa:	032080e7          	jalr	50(ra) # 800001d8 <memmove>
  while(*path == '/')
    800031ae:	0004c783          	lbu	a5,0(s1)
    800031b2:	01279763          	bne	a5,s2,800031c0 <namex+0xca>
    path++;
    800031b6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031b8:	0004c783          	lbu	a5,0(s1)
    800031bc:	ff278de3          	beq	a5,s2,800031b6 <namex+0xc0>
    ilock(ip);
    800031c0:	854e                	mv	a0,s3
    800031c2:	00000097          	auipc	ra,0x0
    800031c6:	9a0080e7          	jalr	-1632(ra) # 80002b62 <ilock>
    if(ip->type != T_DIR){
    800031ca:	04499783          	lh	a5,68(s3)
    800031ce:	f98793e3          	bne	a5,s8,80003154 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800031d2:	000b0563          	beqz	s6,800031dc <namex+0xe6>
    800031d6:	0004c783          	lbu	a5,0(s1)
    800031da:	d3cd                	beqz	a5,8000317c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031dc:	865e                	mv	a2,s7
    800031de:	85d6                	mv	a1,s5
    800031e0:	854e                	mv	a0,s3
    800031e2:	00000097          	auipc	ra,0x0
    800031e6:	e64080e7          	jalr	-412(ra) # 80003046 <dirlookup>
    800031ea:	8a2a                	mv	s4,a0
    800031ec:	dd51                	beqz	a0,80003188 <namex+0x92>
    iunlockput(ip);
    800031ee:	854e                	mv	a0,s3
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	bd4080e7          	jalr	-1068(ra) # 80002dc4 <iunlockput>
    ip = next;
    800031f8:	89d2                	mv	s3,s4
  while(*path == '/')
    800031fa:	0004c783          	lbu	a5,0(s1)
    800031fe:	05279763          	bne	a5,s2,8000324c <namex+0x156>
    path++;
    80003202:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003204:	0004c783          	lbu	a5,0(s1)
    80003208:	ff278de3          	beq	a5,s2,80003202 <namex+0x10c>
  if(*path == 0)
    8000320c:	c79d                	beqz	a5,8000323a <namex+0x144>
    path++;
    8000320e:	85a6                	mv	a1,s1
  len = path - s;
    80003210:	8a5e                	mv	s4,s7
    80003212:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003214:	01278963          	beq	a5,s2,80003226 <namex+0x130>
    80003218:	dfbd                	beqz	a5,80003196 <namex+0xa0>
    path++;
    8000321a:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000321c:	0004c783          	lbu	a5,0(s1)
    80003220:	ff279ce3          	bne	a5,s2,80003218 <namex+0x122>
    80003224:	bf8d                	j	80003196 <namex+0xa0>
    memmove(name, s, len);
    80003226:	2601                	sext.w	a2,a2
    80003228:	8556                	mv	a0,s5
    8000322a:	ffffd097          	auipc	ra,0xffffd
    8000322e:	fae080e7          	jalr	-82(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003232:	9a56                	add	s4,s4,s5
    80003234:	000a0023          	sb	zero,0(s4)
    80003238:	bf9d                	j	800031ae <namex+0xb8>
  if(nameiparent){
    8000323a:	f20b03e3          	beqz	s6,80003160 <namex+0x6a>
    iput(ip);
    8000323e:	854e                	mv	a0,s3
    80003240:	00000097          	auipc	ra,0x0
    80003244:	adc080e7          	jalr	-1316(ra) # 80002d1c <iput>
    return 0;
    80003248:	4981                	li	s3,0
    8000324a:	bf19                	j	80003160 <namex+0x6a>
  if(*path == 0)
    8000324c:	d7fd                	beqz	a5,8000323a <namex+0x144>
  while(*path != '/' && *path != 0)
    8000324e:	0004c783          	lbu	a5,0(s1)
    80003252:	85a6                	mv	a1,s1
    80003254:	b7d1                	j	80003218 <namex+0x122>

0000000080003256 <dirlink>:
{
    80003256:	7139                	addi	sp,sp,-64
    80003258:	fc06                	sd	ra,56(sp)
    8000325a:	f822                	sd	s0,48(sp)
    8000325c:	f426                	sd	s1,40(sp)
    8000325e:	f04a                	sd	s2,32(sp)
    80003260:	ec4e                	sd	s3,24(sp)
    80003262:	e852                	sd	s4,16(sp)
    80003264:	0080                	addi	s0,sp,64
    80003266:	892a                	mv	s2,a0
    80003268:	8a2e                	mv	s4,a1
    8000326a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000326c:	4601                	li	a2,0
    8000326e:	00000097          	auipc	ra,0x0
    80003272:	dd8080e7          	jalr	-552(ra) # 80003046 <dirlookup>
    80003276:	e93d                	bnez	a0,800032ec <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003278:	04c92483          	lw	s1,76(s2)
    8000327c:	c49d                	beqz	s1,800032aa <dirlink+0x54>
    8000327e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003280:	4741                	li	a4,16
    80003282:	86a6                	mv	a3,s1
    80003284:	fc040613          	addi	a2,s0,-64
    80003288:	4581                	li	a1,0
    8000328a:	854a                	mv	a0,s2
    8000328c:	00000097          	auipc	ra,0x0
    80003290:	b8a080e7          	jalr	-1142(ra) # 80002e16 <readi>
    80003294:	47c1                	li	a5,16
    80003296:	06f51163          	bne	a0,a5,800032f8 <dirlink+0xa2>
    if(de.inum == 0)
    8000329a:	fc045783          	lhu	a5,-64(s0)
    8000329e:	c791                	beqz	a5,800032aa <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a0:	24c1                	addiw	s1,s1,16
    800032a2:	04c92783          	lw	a5,76(s2)
    800032a6:	fcf4ede3          	bltu	s1,a5,80003280 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032aa:	4639                	li	a2,14
    800032ac:	85d2                	mv	a1,s4
    800032ae:	fc240513          	addi	a0,s0,-62
    800032b2:	ffffd097          	auipc	ra,0xffffd
    800032b6:	fda080e7          	jalr	-38(ra) # 8000028c <strncpy>
  de.inum = inum;
    800032ba:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032be:	4741                	li	a4,16
    800032c0:	86a6                	mv	a3,s1
    800032c2:	fc040613          	addi	a2,s0,-64
    800032c6:	4581                	li	a1,0
    800032c8:	854a                	mv	a0,s2
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	c44080e7          	jalr	-956(ra) # 80002f0e <writei>
    800032d2:	1541                	addi	a0,a0,-16
    800032d4:	00a03533          	snez	a0,a0
    800032d8:	40a00533          	neg	a0,a0
}
    800032dc:	70e2                	ld	ra,56(sp)
    800032de:	7442                	ld	s0,48(sp)
    800032e0:	74a2                	ld	s1,40(sp)
    800032e2:	7902                	ld	s2,32(sp)
    800032e4:	69e2                	ld	s3,24(sp)
    800032e6:	6a42                	ld	s4,16(sp)
    800032e8:	6121                	addi	sp,sp,64
    800032ea:	8082                	ret
    iput(ip);
    800032ec:	00000097          	auipc	ra,0x0
    800032f0:	a30080e7          	jalr	-1488(ra) # 80002d1c <iput>
    return -1;
    800032f4:	557d                	li	a0,-1
    800032f6:	b7dd                	j	800032dc <dirlink+0x86>
      panic("dirlink read");
    800032f8:	00005517          	auipc	a0,0x5
    800032fc:	41850513          	addi	a0,a0,1048 # 80008710 <syscall_names+0x1c8>
    80003300:	00003097          	auipc	ra,0x3
    80003304:	962080e7          	jalr	-1694(ra) # 80005c62 <panic>

0000000080003308 <namei>:

struct inode*
namei(char *path)
{
    80003308:	1101                	addi	sp,sp,-32
    8000330a:	ec06                	sd	ra,24(sp)
    8000330c:	e822                	sd	s0,16(sp)
    8000330e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003310:	fe040613          	addi	a2,s0,-32
    80003314:	4581                	li	a1,0
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	de0080e7          	jalr	-544(ra) # 800030f6 <namex>
}
    8000331e:	60e2                	ld	ra,24(sp)
    80003320:	6442                	ld	s0,16(sp)
    80003322:	6105                	addi	sp,sp,32
    80003324:	8082                	ret

0000000080003326 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003326:	1141                	addi	sp,sp,-16
    80003328:	e406                	sd	ra,8(sp)
    8000332a:	e022                	sd	s0,0(sp)
    8000332c:	0800                	addi	s0,sp,16
    8000332e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003330:	4585                	li	a1,1
    80003332:	00000097          	auipc	ra,0x0
    80003336:	dc4080e7          	jalr	-572(ra) # 800030f6 <namex>
}
    8000333a:	60a2                	ld	ra,8(sp)
    8000333c:	6402                	ld	s0,0(sp)
    8000333e:	0141                	addi	sp,sp,16
    80003340:	8082                	ret

0000000080003342 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003342:	1101                	addi	sp,sp,-32
    80003344:	ec06                	sd	ra,24(sp)
    80003346:	e822                	sd	s0,16(sp)
    80003348:	e426                	sd	s1,8(sp)
    8000334a:	e04a                	sd	s2,0(sp)
    8000334c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000334e:	00016917          	auipc	s2,0x16
    80003352:	8f290913          	addi	s2,s2,-1806 # 80018c40 <log>
    80003356:	01892583          	lw	a1,24(s2)
    8000335a:	02892503          	lw	a0,40(s2)
    8000335e:	fffff097          	auipc	ra,0xfffff
    80003362:	fea080e7          	jalr	-22(ra) # 80002348 <bread>
    80003366:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003368:	02c92683          	lw	a3,44(s2)
    8000336c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000336e:	02d05763          	blez	a3,8000339c <write_head+0x5a>
    80003372:	00016797          	auipc	a5,0x16
    80003376:	8fe78793          	addi	a5,a5,-1794 # 80018c70 <log+0x30>
    8000337a:	05c50713          	addi	a4,a0,92
    8000337e:	36fd                	addiw	a3,a3,-1
    80003380:	1682                	slli	a3,a3,0x20
    80003382:	9281                	srli	a3,a3,0x20
    80003384:	068a                	slli	a3,a3,0x2
    80003386:	00016617          	auipc	a2,0x16
    8000338a:	8ee60613          	addi	a2,a2,-1810 # 80018c74 <log+0x34>
    8000338e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003390:	4390                	lw	a2,0(a5)
    80003392:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003394:	0791                	addi	a5,a5,4
    80003396:	0711                	addi	a4,a4,4
    80003398:	fed79ce3          	bne	a5,a3,80003390 <write_head+0x4e>
  }
  bwrite(buf);
    8000339c:	8526                	mv	a0,s1
    8000339e:	fffff097          	auipc	ra,0xfffff
    800033a2:	09c080e7          	jalr	156(ra) # 8000243a <bwrite>
  brelse(buf);
    800033a6:	8526                	mv	a0,s1
    800033a8:	fffff097          	auipc	ra,0xfffff
    800033ac:	0d0080e7          	jalr	208(ra) # 80002478 <brelse>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	64a2                	ld	s1,8(sp)
    800033b6:	6902                	ld	s2,0(sp)
    800033b8:	6105                	addi	sp,sp,32
    800033ba:	8082                	ret

00000000800033bc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033bc:	00016797          	auipc	a5,0x16
    800033c0:	8b07a783          	lw	a5,-1872(a5) # 80018c6c <log+0x2c>
    800033c4:	0af05d63          	blez	a5,8000347e <install_trans+0xc2>
{
    800033c8:	7139                	addi	sp,sp,-64
    800033ca:	fc06                	sd	ra,56(sp)
    800033cc:	f822                	sd	s0,48(sp)
    800033ce:	f426                	sd	s1,40(sp)
    800033d0:	f04a                	sd	s2,32(sp)
    800033d2:	ec4e                	sd	s3,24(sp)
    800033d4:	e852                	sd	s4,16(sp)
    800033d6:	e456                	sd	s5,8(sp)
    800033d8:	e05a                	sd	s6,0(sp)
    800033da:	0080                	addi	s0,sp,64
    800033dc:	8b2a                	mv	s6,a0
    800033de:	00016a97          	auipc	s5,0x16
    800033e2:	892a8a93          	addi	s5,s5,-1902 # 80018c70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033e6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033e8:	00016997          	auipc	s3,0x16
    800033ec:	85898993          	addi	s3,s3,-1960 # 80018c40 <log>
    800033f0:	a035                	j	8000341c <install_trans+0x60>
      bunpin(dbuf);
    800033f2:	8526                	mv	a0,s1
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	15e080e7          	jalr	350(ra) # 80002552 <bunpin>
    brelse(lbuf);
    800033fc:	854a                	mv	a0,s2
    800033fe:	fffff097          	auipc	ra,0xfffff
    80003402:	07a080e7          	jalr	122(ra) # 80002478 <brelse>
    brelse(dbuf);
    80003406:	8526                	mv	a0,s1
    80003408:	fffff097          	auipc	ra,0xfffff
    8000340c:	070080e7          	jalr	112(ra) # 80002478 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003410:	2a05                	addiw	s4,s4,1
    80003412:	0a91                	addi	s5,s5,4
    80003414:	02c9a783          	lw	a5,44(s3)
    80003418:	04fa5963          	bge	s4,a5,8000346a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000341c:	0189a583          	lw	a1,24(s3)
    80003420:	014585bb          	addw	a1,a1,s4
    80003424:	2585                	addiw	a1,a1,1
    80003426:	0289a503          	lw	a0,40(s3)
    8000342a:	fffff097          	auipc	ra,0xfffff
    8000342e:	f1e080e7          	jalr	-226(ra) # 80002348 <bread>
    80003432:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003434:	000aa583          	lw	a1,0(s5)
    80003438:	0289a503          	lw	a0,40(s3)
    8000343c:	fffff097          	auipc	ra,0xfffff
    80003440:	f0c080e7          	jalr	-244(ra) # 80002348 <bread>
    80003444:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003446:	40000613          	li	a2,1024
    8000344a:	05890593          	addi	a1,s2,88
    8000344e:	05850513          	addi	a0,a0,88
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	d86080e7          	jalr	-634(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000345a:	8526                	mv	a0,s1
    8000345c:	fffff097          	auipc	ra,0xfffff
    80003460:	fde080e7          	jalr	-34(ra) # 8000243a <bwrite>
    if(recovering == 0)
    80003464:	f80b1ce3          	bnez	s6,800033fc <install_trans+0x40>
    80003468:	b769                	j	800033f2 <install_trans+0x36>
}
    8000346a:	70e2                	ld	ra,56(sp)
    8000346c:	7442                	ld	s0,48(sp)
    8000346e:	74a2                	ld	s1,40(sp)
    80003470:	7902                	ld	s2,32(sp)
    80003472:	69e2                	ld	s3,24(sp)
    80003474:	6a42                	ld	s4,16(sp)
    80003476:	6aa2                	ld	s5,8(sp)
    80003478:	6b02                	ld	s6,0(sp)
    8000347a:	6121                	addi	sp,sp,64
    8000347c:	8082                	ret
    8000347e:	8082                	ret

0000000080003480 <initlog>:
{
    80003480:	7179                	addi	sp,sp,-48
    80003482:	f406                	sd	ra,40(sp)
    80003484:	f022                	sd	s0,32(sp)
    80003486:	ec26                	sd	s1,24(sp)
    80003488:	e84a                	sd	s2,16(sp)
    8000348a:	e44e                	sd	s3,8(sp)
    8000348c:	1800                	addi	s0,sp,48
    8000348e:	892a                	mv	s2,a0
    80003490:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003492:	00015497          	auipc	s1,0x15
    80003496:	7ae48493          	addi	s1,s1,1966 # 80018c40 <log>
    8000349a:	00005597          	auipc	a1,0x5
    8000349e:	28658593          	addi	a1,a1,646 # 80008720 <syscall_names+0x1d8>
    800034a2:	8526                	mv	a0,s1
    800034a4:	00003097          	auipc	ra,0x3
    800034a8:	c78080e7          	jalr	-904(ra) # 8000611c <initlock>
  log.start = sb->logstart;
    800034ac:	0149a583          	lw	a1,20(s3)
    800034b0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034b2:	0109a783          	lw	a5,16(s3)
    800034b6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034b8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034bc:	854a                	mv	a0,s2
    800034be:	fffff097          	auipc	ra,0xfffff
    800034c2:	e8a080e7          	jalr	-374(ra) # 80002348 <bread>
  log.lh.n = lh->n;
    800034c6:	4d3c                	lw	a5,88(a0)
    800034c8:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034ca:	02f05563          	blez	a5,800034f4 <initlog+0x74>
    800034ce:	05c50713          	addi	a4,a0,92
    800034d2:	00015697          	auipc	a3,0x15
    800034d6:	79e68693          	addi	a3,a3,1950 # 80018c70 <log+0x30>
    800034da:	37fd                	addiw	a5,a5,-1
    800034dc:	1782                	slli	a5,a5,0x20
    800034de:	9381                	srli	a5,a5,0x20
    800034e0:	078a                	slli	a5,a5,0x2
    800034e2:	06050613          	addi	a2,a0,96
    800034e6:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800034e8:	4310                	lw	a2,0(a4)
    800034ea:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800034ec:	0711                	addi	a4,a4,4
    800034ee:	0691                	addi	a3,a3,4
    800034f0:	fef71ce3          	bne	a4,a5,800034e8 <initlog+0x68>
  brelse(buf);
    800034f4:	fffff097          	auipc	ra,0xfffff
    800034f8:	f84080e7          	jalr	-124(ra) # 80002478 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034fc:	4505                	li	a0,1
    800034fe:	00000097          	auipc	ra,0x0
    80003502:	ebe080e7          	jalr	-322(ra) # 800033bc <install_trans>
  log.lh.n = 0;
    80003506:	00015797          	auipc	a5,0x15
    8000350a:	7607a323          	sw	zero,1894(a5) # 80018c6c <log+0x2c>
  write_head(); // clear the log
    8000350e:	00000097          	auipc	ra,0x0
    80003512:	e34080e7          	jalr	-460(ra) # 80003342 <write_head>
}
    80003516:	70a2                	ld	ra,40(sp)
    80003518:	7402                	ld	s0,32(sp)
    8000351a:	64e2                	ld	s1,24(sp)
    8000351c:	6942                	ld	s2,16(sp)
    8000351e:	69a2                	ld	s3,8(sp)
    80003520:	6145                	addi	sp,sp,48
    80003522:	8082                	ret

0000000080003524 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003524:	1101                	addi	sp,sp,-32
    80003526:	ec06                	sd	ra,24(sp)
    80003528:	e822                	sd	s0,16(sp)
    8000352a:	e426                	sd	s1,8(sp)
    8000352c:	e04a                	sd	s2,0(sp)
    8000352e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003530:	00015517          	auipc	a0,0x15
    80003534:	71050513          	addi	a0,a0,1808 # 80018c40 <log>
    80003538:	00003097          	auipc	ra,0x3
    8000353c:	c74080e7          	jalr	-908(ra) # 800061ac <acquire>
  while(1){
    if(log.committing){
    80003540:	00015497          	auipc	s1,0x15
    80003544:	70048493          	addi	s1,s1,1792 # 80018c40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003548:	4979                	li	s2,30
    8000354a:	a039                	j	80003558 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000354c:	85a6                	mv	a1,s1
    8000354e:	8526                	mv	a0,s1
    80003550:	ffffe097          	auipc	ra,0xffffe
    80003554:	fb8080e7          	jalr	-72(ra) # 80001508 <sleep>
    if(log.committing){
    80003558:	50dc                	lw	a5,36(s1)
    8000355a:	fbed                	bnez	a5,8000354c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000355c:	509c                	lw	a5,32(s1)
    8000355e:	0017871b          	addiw	a4,a5,1
    80003562:	0007069b          	sext.w	a3,a4
    80003566:	0027179b          	slliw	a5,a4,0x2
    8000356a:	9fb9                	addw	a5,a5,a4
    8000356c:	0017979b          	slliw	a5,a5,0x1
    80003570:	54d8                	lw	a4,44(s1)
    80003572:	9fb9                	addw	a5,a5,a4
    80003574:	00f95963          	bge	s2,a5,80003586 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003578:	85a6                	mv	a1,s1
    8000357a:	8526                	mv	a0,s1
    8000357c:	ffffe097          	auipc	ra,0xffffe
    80003580:	f8c080e7          	jalr	-116(ra) # 80001508 <sleep>
    80003584:	bfd1                	j	80003558 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003586:	00015517          	auipc	a0,0x15
    8000358a:	6ba50513          	addi	a0,a0,1722 # 80018c40 <log>
    8000358e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003590:	00003097          	auipc	ra,0x3
    80003594:	cd0080e7          	jalr	-816(ra) # 80006260 <release>
      break;
    }
  }
}
    80003598:	60e2                	ld	ra,24(sp)
    8000359a:	6442                	ld	s0,16(sp)
    8000359c:	64a2                	ld	s1,8(sp)
    8000359e:	6902                	ld	s2,0(sp)
    800035a0:	6105                	addi	sp,sp,32
    800035a2:	8082                	ret

00000000800035a4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035a4:	7139                	addi	sp,sp,-64
    800035a6:	fc06                	sd	ra,56(sp)
    800035a8:	f822                	sd	s0,48(sp)
    800035aa:	f426                	sd	s1,40(sp)
    800035ac:	f04a                	sd	s2,32(sp)
    800035ae:	ec4e                	sd	s3,24(sp)
    800035b0:	e852                	sd	s4,16(sp)
    800035b2:	e456                	sd	s5,8(sp)
    800035b4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035b6:	00015497          	auipc	s1,0x15
    800035ba:	68a48493          	addi	s1,s1,1674 # 80018c40 <log>
    800035be:	8526                	mv	a0,s1
    800035c0:	00003097          	auipc	ra,0x3
    800035c4:	bec080e7          	jalr	-1044(ra) # 800061ac <acquire>
  log.outstanding -= 1;
    800035c8:	509c                	lw	a5,32(s1)
    800035ca:	37fd                	addiw	a5,a5,-1
    800035cc:	0007891b          	sext.w	s2,a5
    800035d0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035d2:	50dc                	lw	a5,36(s1)
    800035d4:	efb9                	bnez	a5,80003632 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800035d6:	06091663          	bnez	s2,80003642 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800035da:	00015497          	auipc	s1,0x15
    800035de:	66648493          	addi	s1,s1,1638 # 80018c40 <log>
    800035e2:	4785                	li	a5,1
    800035e4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035e6:	8526                	mv	a0,s1
    800035e8:	00003097          	auipc	ra,0x3
    800035ec:	c78080e7          	jalr	-904(ra) # 80006260 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035f0:	54dc                	lw	a5,44(s1)
    800035f2:	06f04763          	bgtz	a5,80003660 <end_op+0xbc>
    acquire(&log.lock);
    800035f6:	00015497          	auipc	s1,0x15
    800035fa:	64a48493          	addi	s1,s1,1610 # 80018c40 <log>
    800035fe:	8526                	mv	a0,s1
    80003600:	00003097          	auipc	ra,0x3
    80003604:	bac080e7          	jalr	-1108(ra) # 800061ac <acquire>
    log.committing = 0;
    80003608:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000360c:	8526                	mv	a0,s1
    8000360e:	ffffe097          	auipc	ra,0xffffe
    80003612:	f5e080e7          	jalr	-162(ra) # 8000156c <wakeup>
    release(&log.lock);
    80003616:	8526                	mv	a0,s1
    80003618:	00003097          	auipc	ra,0x3
    8000361c:	c48080e7          	jalr	-952(ra) # 80006260 <release>
}
    80003620:	70e2                	ld	ra,56(sp)
    80003622:	7442                	ld	s0,48(sp)
    80003624:	74a2                	ld	s1,40(sp)
    80003626:	7902                	ld	s2,32(sp)
    80003628:	69e2                	ld	s3,24(sp)
    8000362a:	6a42                	ld	s4,16(sp)
    8000362c:	6aa2                	ld	s5,8(sp)
    8000362e:	6121                	addi	sp,sp,64
    80003630:	8082                	ret
    panic("log.committing");
    80003632:	00005517          	auipc	a0,0x5
    80003636:	0f650513          	addi	a0,a0,246 # 80008728 <syscall_names+0x1e0>
    8000363a:	00002097          	auipc	ra,0x2
    8000363e:	628080e7          	jalr	1576(ra) # 80005c62 <panic>
    wakeup(&log);
    80003642:	00015497          	auipc	s1,0x15
    80003646:	5fe48493          	addi	s1,s1,1534 # 80018c40 <log>
    8000364a:	8526                	mv	a0,s1
    8000364c:	ffffe097          	auipc	ra,0xffffe
    80003650:	f20080e7          	jalr	-224(ra) # 8000156c <wakeup>
  release(&log.lock);
    80003654:	8526                	mv	a0,s1
    80003656:	00003097          	auipc	ra,0x3
    8000365a:	c0a080e7          	jalr	-1014(ra) # 80006260 <release>
  if(do_commit){
    8000365e:	b7c9                	j	80003620 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003660:	00015a97          	auipc	s5,0x15
    80003664:	610a8a93          	addi	s5,s5,1552 # 80018c70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003668:	00015a17          	auipc	s4,0x15
    8000366c:	5d8a0a13          	addi	s4,s4,1496 # 80018c40 <log>
    80003670:	018a2583          	lw	a1,24(s4)
    80003674:	012585bb          	addw	a1,a1,s2
    80003678:	2585                	addiw	a1,a1,1
    8000367a:	028a2503          	lw	a0,40(s4)
    8000367e:	fffff097          	auipc	ra,0xfffff
    80003682:	cca080e7          	jalr	-822(ra) # 80002348 <bread>
    80003686:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003688:	000aa583          	lw	a1,0(s5)
    8000368c:	028a2503          	lw	a0,40(s4)
    80003690:	fffff097          	auipc	ra,0xfffff
    80003694:	cb8080e7          	jalr	-840(ra) # 80002348 <bread>
    80003698:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000369a:	40000613          	li	a2,1024
    8000369e:	05850593          	addi	a1,a0,88
    800036a2:	05848513          	addi	a0,s1,88
    800036a6:	ffffd097          	auipc	ra,0xffffd
    800036aa:	b32080e7          	jalr	-1230(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800036ae:	8526                	mv	a0,s1
    800036b0:	fffff097          	auipc	ra,0xfffff
    800036b4:	d8a080e7          	jalr	-630(ra) # 8000243a <bwrite>
    brelse(from);
    800036b8:	854e                	mv	a0,s3
    800036ba:	fffff097          	auipc	ra,0xfffff
    800036be:	dbe080e7          	jalr	-578(ra) # 80002478 <brelse>
    brelse(to);
    800036c2:	8526                	mv	a0,s1
    800036c4:	fffff097          	auipc	ra,0xfffff
    800036c8:	db4080e7          	jalr	-588(ra) # 80002478 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036cc:	2905                	addiw	s2,s2,1
    800036ce:	0a91                	addi	s5,s5,4
    800036d0:	02ca2783          	lw	a5,44(s4)
    800036d4:	f8f94ee3          	blt	s2,a5,80003670 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036d8:	00000097          	auipc	ra,0x0
    800036dc:	c6a080e7          	jalr	-918(ra) # 80003342 <write_head>
    install_trans(0); // Now install writes to home locations
    800036e0:	4501                	li	a0,0
    800036e2:	00000097          	auipc	ra,0x0
    800036e6:	cda080e7          	jalr	-806(ra) # 800033bc <install_trans>
    log.lh.n = 0;
    800036ea:	00015797          	auipc	a5,0x15
    800036ee:	5807a123          	sw	zero,1410(a5) # 80018c6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	c50080e7          	jalr	-944(ra) # 80003342 <write_head>
    800036fa:	bdf5                	j	800035f6 <end_op+0x52>

00000000800036fc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036fc:	1101                	addi	sp,sp,-32
    800036fe:	ec06                	sd	ra,24(sp)
    80003700:	e822                	sd	s0,16(sp)
    80003702:	e426                	sd	s1,8(sp)
    80003704:	e04a                	sd	s2,0(sp)
    80003706:	1000                	addi	s0,sp,32
    80003708:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000370a:	00015917          	auipc	s2,0x15
    8000370e:	53690913          	addi	s2,s2,1334 # 80018c40 <log>
    80003712:	854a                	mv	a0,s2
    80003714:	00003097          	auipc	ra,0x3
    80003718:	a98080e7          	jalr	-1384(ra) # 800061ac <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000371c:	02c92603          	lw	a2,44(s2)
    80003720:	47f5                	li	a5,29
    80003722:	06c7c563          	blt	a5,a2,8000378c <log_write+0x90>
    80003726:	00015797          	auipc	a5,0x15
    8000372a:	5367a783          	lw	a5,1334(a5) # 80018c5c <log+0x1c>
    8000372e:	37fd                	addiw	a5,a5,-1
    80003730:	04f65e63          	bge	a2,a5,8000378c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003734:	00015797          	auipc	a5,0x15
    80003738:	52c7a783          	lw	a5,1324(a5) # 80018c60 <log+0x20>
    8000373c:	06f05063          	blez	a5,8000379c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003740:	4781                	li	a5,0
    80003742:	06c05563          	blez	a2,800037ac <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003746:	44cc                	lw	a1,12(s1)
    80003748:	00015717          	auipc	a4,0x15
    8000374c:	52870713          	addi	a4,a4,1320 # 80018c70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003750:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003752:	4314                	lw	a3,0(a4)
    80003754:	04b68c63          	beq	a3,a1,800037ac <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003758:	2785                	addiw	a5,a5,1
    8000375a:	0711                	addi	a4,a4,4
    8000375c:	fef61be3          	bne	a2,a5,80003752 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003760:	0621                	addi	a2,a2,8
    80003762:	060a                	slli	a2,a2,0x2
    80003764:	00015797          	auipc	a5,0x15
    80003768:	4dc78793          	addi	a5,a5,1244 # 80018c40 <log>
    8000376c:	963e                	add	a2,a2,a5
    8000376e:	44dc                	lw	a5,12(s1)
    80003770:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003772:	8526                	mv	a0,s1
    80003774:	fffff097          	auipc	ra,0xfffff
    80003778:	da2080e7          	jalr	-606(ra) # 80002516 <bpin>
    log.lh.n++;
    8000377c:	00015717          	auipc	a4,0x15
    80003780:	4c470713          	addi	a4,a4,1220 # 80018c40 <log>
    80003784:	575c                	lw	a5,44(a4)
    80003786:	2785                	addiw	a5,a5,1
    80003788:	d75c                	sw	a5,44(a4)
    8000378a:	a835                	j	800037c6 <log_write+0xca>
    panic("too big a transaction");
    8000378c:	00005517          	auipc	a0,0x5
    80003790:	fac50513          	addi	a0,a0,-84 # 80008738 <syscall_names+0x1f0>
    80003794:	00002097          	auipc	ra,0x2
    80003798:	4ce080e7          	jalr	1230(ra) # 80005c62 <panic>
    panic("log_write outside of trans");
    8000379c:	00005517          	auipc	a0,0x5
    800037a0:	fb450513          	addi	a0,a0,-76 # 80008750 <syscall_names+0x208>
    800037a4:	00002097          	auipc	ra,0x2
    800037a8:	4be080e7          	jalr	1214(ra) # 80005c62 <panic>
  log.lh.block[i] = b->blockno;
    800037ac:	00878713          	addi	a4,a5,8
    800037b0:	00271693          	slli	a3,a4,0x2
    800037b4:	00015717          	auipc	a4,0x15
    800037b8:	48c70713          	addi	a4,a4,1164 # 80018c40 <log>
    800037bc:	9736                	add	a4,a4,a3
    800037be:	44d4                	lw	a3,12(s1)
    800037c0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037c2:	faf608e3          	beq	a2,a5,80003772 <log_write+0x76>
  }
  release(&log.lock);
    800037c6:	00015517          	auipc	a0,0x15
    800037ca:	47a50513          	addi	a0,a0,1146 # 80018c40 <log>
    800037ce:	00003097          	auipc	ra,0x3
    800037d2:	a92080e7          	jalr	-1390(ra) # 80006260 <release>
}
    800037d6:	60e2                	ld	ra,24(sp)
    800037d8:	6442                	ld	s0,16(sp)
    800037da:	64a2                	ld	s1,8(sp)
    800037dc:	6902                	ld	s2,0(sp)
    800037de:	6105                	addi	sp,sp,32
    800037e0:	8082                	ret

00000000800037e2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037e2:	1101                	addi	sp,sp,-32
    800037e4:	ec06                	sd	ra,24(sp)
    800037e6:	e822                	sd	s0,16(sp)
    800037e8:	e426                	sd	s1,8(sp)
    800037ea:	e04a                	sd	s2,0(sp)
    800037ec:	1000                	addi	s0,sp,32
    800037ee:	84aa                	mv	s1,a0
    800037f0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037f2:	00005597          	auipc	a1,0x5
    800037f6:	f7e58593          	addi	a1,a1,-130 # 80008770 <syscall_names+0x228>
    800037fa:	0521                	addi	a0,a0,8
    800037fc:	00003097          	auipc	ra,0x3
    80003800:	920080e7          	jalr	-1760(ra) # 8000611c <initlock>
  lk->name = name;
    80003804:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003808:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000380c:	0204a423          	sw	zero,40(s1)
}
    80003810:	60e2                	ld	ra,24(sp)
    80003812:	6442                	ld	s0,16(sp)
    80003814:	64a2                	ld	s1,8(sp)
    80003816:	6902                	ld	s2,0(sp)
    80003818:	6105                	addi	sp,sp,32
    8000381a:	8082                	ret

000000008000381c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000381c:	1101                	addi	sp,sp,-32
    8000381e:	ec06                	sd	ra,24(sp)
    80003820:	e822                	sd	s0,16(sp)
    80003822:	e426                	sd	s1,8(sp)
    80003824:	e04a                	sd	s2,0(sp)
    80003826:	1000                	addi	s0,sp,32
    80003828:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000382a:	00850913          	addi	s2,a0,8
    8000382e:	854a                	mv	a0,s2
    80003830:	00003097          	auipc	ra,0x3
    80003834:	97c080e7          	jalr	-1668(ra) # 800061ac <acquire>
  while (lk->locked) {
    80003838:	409c                	lw	a5,0(s1)
    8000383a:	cb89                	beqz	a5,8000384c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000383c:	85ca                	mv	a1,s2
    8000383e:	8526                	mv	a0,s1
    80003840:	ffffe097          	auipc	ra,0xffffe
    80003844:	cc8080e7          	jalr	-824(ra) # 80001508 <sleep>
  while (lk->locked) {
    80003848:	409c                	lw	a5,0(s1)
    8000384a:	fbed                	bnez	a5,8000383c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000384c:	4785                	li	a5,1
    8000384e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003850:	ffffd097          	auipc	ra,0xffffd
    80003854:	608080e7          	jalr	1544(ra) # 80000e58 <myproc>
    80003858:	591c                	lw	a5,48(a0)
    8000385a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000385c:	854a                	mv	a0,s2
    8000385e:	00003097          	auipc	ra,0x3
    80003862:	a02080e7          	jalr	-1534(ra) # 80006260 <release>
}
    80003866:	60e2                	ld	ra,24(sp)
    80003868:	6442                	ld	s0,16(sp)
    8000386a:	64a2                	ld	s1,8(sp)
    8000386c:	6902                	ld	s2,0(sp)
    8000386e:	6105                	addi	sp,sp,32
    80003870:	8082                	ret

0000000080003872 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003872:	1101                	addi	sp,sp,-32
    80003874:	ec06                	sd	ra,24(sp)
    80003876:	e822                	sd	s0,16(sp)
    80003878:	e426                	sd	s1,8(sp)
    8000387a:	e04a                	sd	s2,0(sp)
    8000387c:	1000                	addi	s0,sp,32
    8000387e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003880:	00850913          	addi	s2,a0,8
    80003884:	854a                	mv	a0,s2
    80003886:	00003097          	auipc	ra,0x3
    8000388a:	926080e7          	jalr	-1754(ra) # 800061ac <acquire>
  lk->locked = 0;
    8000388e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003892:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003896:	8526                	mv	a0,s1
    80003898:	ffffe097          	auipc	ra,0xffffe
    8000389c:	cd4080e7          	jalr	-812(ra) # 8000156c <wakeup>
  release(&lk->lk);
    800038a0:	854a                	mv	a0,s2
    800038a2:	00003097          	auipc	ra,0x3
    800038a6:	9be080e7          	jalr	-1602(ra) # 80006260 <release>
}
    800038aa:	60e2                	ld	ra,24(sp)
    800038ac:	6442                	ld	s0,16(sp)
    800038ae:	64a2                	ld	s1,8(sp)
    800038b0:	6902                	ld	s2,0(sp)
    800038b2:	6105                	addi	sp,sp,32
    800038b4:	8082                	ret

00000000800038b6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038b6:	7179                	addi	sp,sp,-48
    800038b8:	f406                	sd	ra,40(sp)
    800038ba:	f022                	sd	s0,32(sp)
    800038bc:	ec26                	sd	s1,24(sp)
    800038be:	e84a                	sd	s2,16(sp)
    800038c0:	e44e                	sd	s3,8(sp)
    800038c2:	1800                	addi	s0,sp,48
    800038c4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038c6:	00850913          	addi	s2,a0,8
    800038ca:	854a                	mv	a0,s2
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	8e0080e7          	jalr	-1824(ra) # 800061ac <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038d4:	409c                	lw	a5,0(s1)
    800038d6:	ef99                	bnez	a5,800038f4 <holdingsleep+0x3e>
    800038d8:	4481                	li	s1,0
  release(&lk->lk);
    800038da:	854a                	mv	a0,s2
    800038dc:	00003097          	auipc	ra,0x3
    800038e0:	984080e7          	jalr	-1660(ra) # 80006260 <release>
  return r;
}
    800038e4:	8526                	mv	a0,s1
    800038e6:	70a2                	ld	ra,40(sp)
    800038e8:	7402                	ld	s0,32(sp)
    800038ea:	64e2                	ld	s1,24(sp)
    800038ec:	6942                	ld	s2,16(sp)
    800038ee:	69a2                	ld	s3,8(sp)
    800038f0:	6145                	addi	sp,sp,48
    800038f2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800038f4:	0284a983          	lw	s3,40(s1)
    800038f8:	ffffd097          	auipc	ra,0xffffd
    800038fc:	560080e7          	jalr	1376(ra) # 80000e58 <myproc>
    80003900:	5904                	lw	s1,48(a0)
    80003902:	413484b3          	sub	s1,s1,s3
    80003906:	0014b493          	seqz	s1,s1
    8000390a:	bfc1                	j	800038da <holdingsleep+0x24>

000000008000390c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000390c:	1141                	addi	sp,sp,-16
    8000390e:	e406                	sd	ra,8(sp)
    80003910:	e022                	sd	s0,0(sp)
    80003912:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003914:	00005597          	auipc	a1,0x5
    80003918:	e6c58593          	addi	a1,a1,-404 # 80008780 <syscall_names+0x238>
    8000391c:	00015517          	auipc	a0,0x15
    80003920:	46c50513          	addi	a0,a0,1132 # 80018d88 <ftable>
    80003924:	00002097          	auipc	ra,0x2
    80003928:	7f8080e7          	jalr	2040(ra) # 8000611c <initlock>
}
    8000392c:	60a2                	ld	ra,8(sp)
    8000392e:	6402                	ld	s0,0(sp)
    80003930:	0141                	addi	sp,sp,16
    80003932:	8082                	ret

0000000080003934 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003934:	1101                	addi	sp,sp,-32
    80003936:	ec06                	sd	ra,24(sp)
    80003938:	e822                	sd	s0,16(sp)
    8000393a:	e426                	sd	s1,8(sp)
    8000393c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000393e:	00015517          	auipc	a0,0x15
    80003942:	44a50513          	addi	a0,a0,1098 # 80018d88 <ftable>
    80003946:	00003097          	auipc	ra,0x3
    8000394a:	866080e7          	jalr	-1946(ra) # 800061ac <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000394e:	00015497          	auipc	s1,0x15
    80003952:	45248493          	addi	s1,s1,1106 # 80018da0 <ftable+0x18>
    80003956:	00016717          	auipc	a4,0x16
    8000395a:	3ea70713          	addi	a4,a4,1002 # 80019d40 <disk>
    if(f->ref == 0){
    8000395e:	40dc                	lw	a5,4(s1)
    80003960:	cf99                	beqz	a5,8000397e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003962:	02848493          	addi	s1,s1,40
    80003966:	fee49ce3          	bne	s1,a4,8000395e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000396a:	00015517          	auipc	a0,0x15
    8000396e:	41e50513          	addi	a0,a0,1054 # 80018d88 <ftable>
    80003972:	00003097          	auipc	ra,0x3
    80003976:	8ee080e7          	jalr	-1810(ra) # 80006260 <release>
  return 0;
    8000397a:	4481                	li	s1,0
    8000397c:	a819                	j	80003992 <filealloc+0x5e>
      f->ref = 1;
    8000397e:	4785                	li	a5,1
    80003980:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003982:	00015517          	auipc	a0,0x15
    80003986:	40650513          	addi	a0,a0,1030 # 80018d88 <ftable>
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	8d6080e7          	jalr	-1834(ra) # 80006260 <release>
}
    80003992:	8526                	mv	a0,s1
    80003994:	60e2                	ld	ra,24(sp)
    80003996:	6442                	ld	s0,16(sp)
    80003998:	64a2                	ld	s1,8(sp)
    8000399a:	6105                	addi	sp,sp,32
    8000399c:	8082                	ret

000000008000399e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000399e:	1101                	addi	sp,sp,-32
    800039a0:	ec06                	sd	ra,24(sp)
    800039a2:	e822                	sd	s0,16(sp)
    800039a4:	e426                	sd	s1,8(sp)
    800039a6:	1000                	addi	s0,sp,32
    800039a8:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039aa:	00015517          	auipc	a0,0x15
    800039ae:	3de50513          	addi	a0,a0,990 # 80018d88 <ftable>
    800039b2:	00002097          	auipc	ra,0x2
    800039b6:	7fa080e7          	jalr	2042(ra) # 800061ac <acquire>
  if(f->ref < 1)
    800039ba:	40dc                	lw	a5,4(s1)
    800039bc:	02f05263          	blez	a5,800039e0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039c0:	2785                	addiw	a5,a5,1
    800039c2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039c4:	00015517          	auipc	a0,0x15
    800039c8:	3c450513          	addi	a0,a0,964 # 80018d88 <ftable>
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	894080e7          	jalr	-1900(ra) # 80006260 <release>
  return f;
}
    800039d4:	8526                	mv	a0,s1
    800039d6:	60e2                	ld	ra,24(sp)
    800039d8:	6442                	ld	s0,16(sp)
    800039da:	64a2                	ld	s1,8(sp)
    800039dc:	6105                	addi	sp,sp,32
    800039de:	8082                	ret
    panic("filedup");
    800039e0:	00005517          	auipc	a0,0x5
    800039e4:	da850513          	addi	a0,a0,-600 # 80008788 <syscall_names+0x240>
    800039e8:	00002097          	auipc	ra,0x2
    800039ec:	27a080e7          	jalr	634(ra) # 80005c62 <panic>

00000000800039f0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039f0:	7139                	addi	sp,sp,-64
    800039f2:	fc06                	sd	ra,56(sp)
    800039f4:	f822                	sd	s0,48(sp)
    800039f6:	f426                	sd	s1,40(sp)
    800039f8:	f04a                	sd	s2,32(sp)
    800039fa:	ec4e                	sd	s3,24(sp)
    800039fc:	e852                	sd	s4,16(sp)
    800039fe:	e456                	sd	s5,8(sp)
    80003a00:	0080                	addi	s0,sp,64
    80003a02:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a04:	00015517          	auipc	a0,0x15
    80003a08:	38450513          	addi	a0,a0,900 # 80018d88 <ftable>
    80003a0c:	00002097          	auipc	ra,0x2
    80003a10:	7a0080e7          	jalr	1952(ra) # 800061ac <acquire>
  if(f->ref < 1)
    80003a14:	40dc                	lw	a5,4(s1)
    80003a16:	06f05163          	blez	a5,80003a78 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a1a:	37fd                	addiw	a5,a5,-1
    80003a1c:	0007871b          	sext.w	a4,a5
    80003a20:	c0dc                	sw	a5,4(s1)
    80003a22:	06e04363          	bgtz	a4,80003a88 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a26:	0004a903          	lw	s2,0(s1)
    80003a2a:	0094ca83          	lbu	s5,9(s1)
    80003a2e:	0104ba03          	ld	s4,16(s1)
    80003a32:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a36:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a3a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a3e:	00015517          	auipc	a0,0x15
    80003a42:	34a50513          	addi	a0,a0,842 # 80018d88 <ftable>
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	81a080e7          	jalr	-2022(ra) # 80006260 <release>

  if(ff.type == FD_PIPE){
    80003a4e:	4785                	li	a5,1
    80003a50:	04f90d63          	beq	s2,a5,80003aaa <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a54:	3979                	addiw	s2,s2,-2
    80003a56:	4785                	li	a5,1
    80003a58:	0527e063          	bltu	a5,s2,80003a98 <fileclose+0xa8>
    begin_op();
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	ac8080e7          	jalr	-1336(ra) # 80003524 <begin_op>
    iput(ff.ip);
    80003a64:	854e                	mv	a0,s3
    80003a66:	fffff097          	auipc	ra,0xfffff
    80003a6a:	2b6080e7          	jalr	694(ra) # 80002d1c <iput>
    end_op();
    80003a6e:	00000097          	auipc	ra,0x0
    80003a72:	b36080e7          	jalr	-1226(ra) # 800035a4 <end_op>
    80003a76:	a00d                	j	80003a98 <fileclose+0xa8>
    panic("fileclose");
    80003a78:	00005517          	auipc	a0,0x5
    80003a7c:	d1850513          	addi	a0,a0,-744 # 80008790 <syscall_names+0x248>
    80003a80:	00002097          	auipc	ra,0x2
    80003a84:	1e2080e7          	jalr	482(ra) # 80005c62 <panic>
    release(&ftable.lock);
    80003a88:	00015517          	auipc	a0,0x15
    80003a8c:	30050513          	addi	a0,a0,768 # 80018d88 <ftable>
    80003a90:	00002097          	auipc	ra,0x2
    80003a94:	7d0080e7          	jalr	2000(ra) # 80006260 <release>
  }
}
    80003a98:	70e2                	ld	ra,56(sp)
    80003a9a:	7442                	ld	s0,48(sp)
    80003a9c:	74a2                	ld	s1,40(sp)
    80003a9e:	7902                	ld	s2,32(sp)
    80003aa0:	69e2                	ld	s3,24(sp)
    80003aa2:	6a42                	ld	s4,16(sp)
    80003aa4:	6aa2                	ld	s5,8(sp)
    80003aa6:	6121                	addi	sp,sp,64
    80003aa8:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003aaa:	85d6                	mv	a1,s5
    80003aac:	8552                	mv	a0,s4
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	34c080e7          	jalr	844(ra) # 80003dfa <pipeclose>
    80003ab6:	b7cd                	j	80003a98 <fileclose+0xa8>

0000000080003ab8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ab8:	715d                	addi	sp,sp,-80
    80003aba:	e486                	sd	ra,72(sp)
    80003abc:	e0a2                	sd	s0,64(sp)
    80003abe:	fc26                	sd	s1,56(sp)
    80003ac0:	f84a                	sd	s2,48(sp)
    80003ac2:	f44e                	sd	s3,40(sp)
    80003ac4:	0880                	addi	s0,sp,80
    80003ac6:	84aa                	mv	s1,a0
    80003ac8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aca:	ffffd097          	auipc	ra,0xffffd
    80003ace:	38e080e7          	jalr	910(ra) # 80000e58 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ad2:	409c                	lw	a5,0(s1)
    80003ad4:	37f9                	addiw	a5,a5,-2
    80003ad6:	4705                	li	a4,1
    80003ad8:	04f76763          	bltu	a4,a5,80003b26 <filestat+0x6e>
    80003adc:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ade:	6c88                	ld	a0,24(s1)
    80003ae0:	fffff097          	auipc	ra,0xfffff
    80003ae4:	082080e7          	jalr	130(ra) # 80002b62 <ilock>
    stati(f->ip, &st);
    80003ae8:	fb840593          	addi	a1,s0,-72
    80003aec:	6c88                	ld	a0,24(s1)
    80003aee:	fffff097          	auipc	ra,0xfffff
    80003af2:	2fe080e7          	jalr	766(ra) # 80002dec <stati>
    iunlock(f->ip);
    80003af6:	6c88                	ld	a0,24(s1)
    80003af8:	fffff097          	auipc	ra,0xfffff
    80003afc:	12c080e7          	jalr	300(ra) # 80002c24 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b00:	46e1                	li	a3,24
    80003b02:	fb840613          	addi	a2,s0,-72
    80003b06:	85ce                	mv	a1,s3
    80003b08:	05093503          	ld	a0,80(s2)
    80003b0c:	ffffd097          	auipc	ra,0xffffd
    80003b10:	00a080e7          	jalr	10(ra) # 80000b16 <copyout>
    80003b14:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b18:	60a6                	ld	ra,72(sp)
    80003b1a:	6406                	ld	s0,64(sp)
    80003b1c:	74e2                	ld	s1,56(sp)
    80003b1e:	7942                	ld	s2,48(sp)
    80003b20:	79a2                	ld	s3,40(sp)
    80003b22:	6161                	addi	sp,sp,80
    80003b24:	8082                	ret
  return -1;
    80003b26:	557d                	li	a0,-1
    80003b28:	bfc5                	j	80003b18 <filestat+0x60>

0000000080003b2a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b2a:	7179                	addi	sp,sp,-48
    80003b2c:	f406                	sd	ra,40(sp)
    80003b2e:	f022                	sd	s0,32(sp)
    80003b30:	ec26                	sd	s1,24(sp)
    80003b32:	e84a                	sd	s2,16(sp)
    80003b34:	e44e                	sd	s3,8(sp)
    80003b36:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b38:	00854783          	lbu	a5,8(a0)
    80003b3c:	c3d5                	beqz	a5,80003be0 <fileread+0xb6>
    80003b3e:	84aa                	mv	s1,a0
    80003b40:	89ae                	mv	s3,a1
    80003b42:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b44:	411c                	lw	a5,0(a0)
    80003b46:	4705                	li	a4,1
    80003b48:	04e78963          	beq	a5,a4,80003b9a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b4c:	470d                	li	a4,3
    80003b4e:	04e78d63          	beq	a5,a4,80003ba8 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b52:	4709                	li	a4,2
    80003b54:	06e79e63          	bne	a5,a4,80003bd0 <fileread+0xa6>
    ilock(f->ip);
    80003b58:	6d08                	ld	a0,24(a0)
    80003b5a:	fffff097          	auipc	ra,0xfffff
    80003b5e:	008080e7          	jalr	8(ra) # 80002b62 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b62:	874a                	mv	a4,s2
    80003b64:	5094                	lw	a3,32(s1)
    80003b66:	864e                	mv	a2,s3
    80003b68:	4585                	li	a1,1
    80003b6a:	6c88                	ld	a0,24(s1)
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	2aa080e7          	jalr	682(ra) # 80002e16 <readi>
    80003b74:	892a                	mv	s2,a0
    80003b76:	00a05563          	blez	a0,80003b80 <fileread+0x56>
      f->off += r;
    80003b7a:	509c                	lw	a5,32(s1)
    80003b7c:	9fa9                	addw	a5,a5,a0
    80003b7e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b80:	6c88                	ld	a0,24(s1)
    80003b82:	fffff097          	auipc	ra,0xfffff
    80003b86:	0a2080e7          	jalr	162(ra) # 80002c24 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003b8a:	854a                	mv	a0,s2
    80003b8c:	70a2                	ld	ra,40(sp)
    80003b8e:	7402                	ld	s0,32(sp)
    80003b90:	64e2                	ld	s1,24(sp)
    80003b92:	6942                	ld	s2,16(sp)
    80003b94:	69a2                	ld	s3,8(sp)
    80003b96:	6145                	addi	sp,sp,48
    80003b98:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b9a:	6908                	ld	a0,16(a0)
    80003b9c:	00000097          	auipc	ra,0x0
    80003ba0:	3ce080e7          	jalr	974(ra) # 80003f6a <piperead>
    80003ba4:	892a                	mv	s2,a0
    80003ba6:	b7d5                	j	80003b8a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ba8:	02451783          	lh	a5,36(a0)
    80003bac:	03079693          	slli	a3,a5,0x30
    80003bb0:	92c1                	srli	a3,a3,0x30
    80003bb2:	4725                	li	a4,9
    80003bb4:	02d76863          	bltu	a4,a3,80003be4 <fileread+0xba>
    80003bb8:	0792                	slli	a5,a5,0x4
    80003bba:	00015717          	auipc	a4,0x15
    80003bbe:	12e70713          	addi	a4,a4,302 # 80018ce8 <devsw>
    80003bc2:	97ba                	add	a5,a5,a4
    80003bc4:	639c                	ld	a5,0(a5)
    80003bc6:	c38d                	beqz	a5,80003be8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003bc8:	4505                	li	a0,1
    80003bca:	9782                	jalr	a5
    80003bcc:	892a                	mv	s2,a0
    80003bce:	bf75                	j	80003b8a <fileread+0x60>
    panic("fileread");
    80003bd0:	00005517          	auipc	a0,0x5
    80003bd4:	bd050513          	addi	a0,a0,-1072 # 800087a0 <syscall_names+0x258>
    80003bd8:	00002097          	auipc	ra,0x2
    80003bdc:	08a080e7          	jalr	138(ra) # 80005c62 <panic>
    return -1;
    80003be0:	597d                	li	s2,-1
    80003be2:	b765                	j	80003b8a <fileread+0x60>
      return -1;
    80003be4:	597d                	li	s2,-1
    80003be6:	b755                	j	80003b8a <fileread+0x60>
    80003be8:	597d                	li	s2,-1
    80003bea:	b745                	j	80003b8a <fileread+0x60>

0000000080003bec <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003bec:	715d                	addi	sp,sp,-80
    80003bee:	e486                	sd	ra,72(sp)
    80003bf0:	e0a2                	sd	s0,64(sp)
    80003bf2:	fc26                	sd	s1,56(sp)
    80003bf4:	f84a                	sd	s2,48(sp)
    80003bf6:	f44e                	sd	s3,40(sp)
    80003bf8:	f052                	sd	s4,32(sp)
    80003bfa:	ec56                	sd	s5,24(sp)
    80003bfc:	e85a                	sd	s6,16(sp)
    80003bfe:	e45e                	sd	s7,8(sp)
    80003c00:	e062                	sd	s8,0(sp)
    80003c02:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c04:	00954783          	lbu	a5,9(a0)
    80003c08:	10078663          	beqz	a5,80003d14 <filewrite+0x128>
    80003c0c:	892a                	mv	s2,a0
    80003c0e:	8aae                	mv	s5,a1
    80003c10:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c12:	411c                	lw	a5,0(a0)
    80003c14:	4705                	li	a4,1
    80003c16:	02e78263          	beq	a5,a4,80003c3a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c1a:	470d                	li	a4,3
    80003c1c:	02e78663          	beq	a5,a4,80003c48 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c20:	4709                	li	a4,2
    80003c22:	0ee79163          	bne	a5,a4,80003d04 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c26:	0ac05d63          	blez	a2,80003ce0 <filewrite+0xf4>
    int i = 0;
    80003c2a:	4981                	li	s3,0
    80003c2c:	6b05                	lui	s6,0x1
    80003c2e:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c32:	6b85                	lui	s7,0x1
    80003c34:	c00b8b9b          	addiw	s7,s7,-1024
    80003c38:	a861                	j	80003cd0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c3a:	6908                	ld	a0,16(a0)
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	22e080e7          	jalr	558(ra) # 80003e6a <pipewrite>
    80003c44:	8a2a                	mv	s4,a0
    80003c46:	a045                	j	80003ce6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c48:	02451783          	lh	a5,36(a0)
    80003c4c:	03079693          	slli	a3,a5,0x30
    80003c50:	92c1                	srli	a3,a3,0x30
    80003c52:	4725                	li	a4,9
    80003c54:	0cd76263          	bltu	a4,a3,80003d18 <filewrite+0x12c>
    80003c58:	0792                	slli	a5,a5,0x4
    80003c5a:	00015717          	auipc	a4,0x15
    80003c5e:	08e70713          	addi	a4,a4,142 # 80018ce8 <devsw>
    80003c62:	97ba                	add	a5,a5,a4
    80003c64:	679c                	ld	a5,8(a5)
    80003c66:	cbdd                	beqz	a5,80003d1c <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003c68:	4505                	li	a0,1
    80003c6a:	9782                	jalr	a5
    80003c6c:	8a2a                	mv	s4,a0
    80003c6e:	a8a5                	j	80003ce6 <filewrite+0xfa>
    80003c70:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003c74:	00000097          	auipc	ra,0x0
    80003c78:	8b0080e7          	jalr	-1872(ra) # 80003524 <begin_op>
      ilock(f->ip);
    80003c7c:	01893503          	ld	a0,24(s2)
    80003c80:	fffff097          	auipc	ra,0xfffff
    80003c84:	ee2080e7          	jalr	-286(ra) # 80002b62 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c88:	8762                	mv	a4,s8
    80003c8a:	02092683          	lw	a3,32(s2)
    80003c8e:	01598633          	add	a2,s3,s5
    80003c92:	4585                	li	a1,1
    80003c94:	01893503          	ld	a0,24(s2)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	276080e7          	jalr	630(ra) # 80002f0e <writei>
    80003ca0:	84aa                	mv	s1,a0
    80003ca2:	00a05763          	blez	a0,80003cb0 <filewrite+0xc4>
        f->off += r;
    80003ca6:	02092783          	lw	a5,32(s2)
    80003caa:	9fa9                	addw	a5,a5,a0
    80003cac:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cb0:	01893503          	ld	a0,24(s2)
    80003cb4:	fffff097          	auipc	ra,0xfffff
    80003cb8:	f70080e7          	jalr	-144(ra) # 80002c24 <iunlock>
      end_op();
    80003cbc:	00000097          	auipc	ra,0x0
    80003cc0:	8e8080e7          	jalr	-1816(ra) # 800035a4 <end_op>

      if(r != n1){
    80003cc4:	009c1f63          	bne	s8,s1,80003ce2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003cc8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ccc:	0149db63          	bge	s3,s4,80003ce2 <filewrite+0xf6>
      int n1 = n - i;
    80003cd0:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003cd4:	84be                	mv	s1,a5
    80003cd6:	2781                	sext.w	a5,a5
    80003cd8:	f8fb5ce3          	bge	s6,a5,80003c70 <filewrite+0x84>
    80003cdc:	84de                	mv	s1,s7
    80003cde:	bf49                	j	80003c70 <filewrite+0x84>
    int i = 0;
    80003ce0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ce2:	013a1f63          	bne	s4,s3,80003d00 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ce6:	8552                	mv	a0,s4
    80003ce8:	60a6                	ld	ra,72(sp)
    80003cea:	6406                	ld	s0,64(sp)
    80003cec:	74e2                	ld	s1,56(sp)
    80003cee:	7942                	ld	s2,48(sp)
    80003cf0:	79a2                	ld	s3,40(sp)
    80003cf2:	7a02                	ld	s4,32(sp)
    80003cf4:	6ae2                	ld	s5,24(sp)
    80003cf6:	6b42                	ld	s6,16(sp)
    80003cf8:	6ba2                	ld	s7,8(sp)
    80003cfa:	6c02                	ld	s8,0(sp)
    80003cfc:	6161                	addi	sp,sp,80
    80003cfe:	8082                	ret
    ret = (i == n ? n : -1);
    80003d00:	5a7d                	li	s4,-1
    80003d02:	b7d5                	j	80003ce6 <filewrite+0xfa>
    panic("filewrite");
    80003d04:	00005517          	auipc	a0,0x5
    80003d08:	aac50513          	addi	a0,a0,-1364 # 800087b0 <syscall_names+0x268>
    80003d0c:	00002097          	auipc	ra,0x2
    80003d10:	f56080e7          	jalr	-170(ra) # 80005c62 <panic>
    return -1;
    80003d14:	5a7d                	li	s4,-1
    80003d16:	bfc1                	j	80003ce6 <filewrite+0xfa>
      return -1;
    80003d18:	5a7d                	li	s4,-1
    80003d1a:	b7f1                	j	80003ce6 <filewrite+0xfa>
    80003d1c:	5a7d                	li	s4,-1
    80003d1e:	b7e1                	j	80003ce6 <filewrite+0xfa>

0000000080003d20 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d20:	7179                	addi	sp,sp,-48
    80003d22:	f406                	sd	ra,40(sp)
    80003d24:	f022                	sd	s0,32(sp)
    80003d26:	ec26                	sd	s1,24(sp)
    80003d28:	e84a                	sd	s2,16(sp)
    80003d2a:	e44e                	sd	s3,8(sp)
    80003d2c:	e052                	sd	s4,0(sp)
    80003d2e:	1800                	addi	s0,sp,48
    80003d30:	84aa                	mv	s1,a0
    80003d32:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d34:	0005b023          	sd	zero,0(a1)
    80003d38:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d3c:	00000097          	auipc	ra,0x0
    80003d40:	bf8080e7          	jalr	-1032(ra) # 80003934 <filealloc>
    80003d44:	e088                	sd	a0,0(s1)
    80003d46:	c551                	beqz	a0,80003dd2 <pipealloc+0xb2>
    80003d48:	00000097          	auipc	ra,0x0
    80003d4c:	bec080e7          	jalr	-1044(ra) # 80003934 <filealloc>
    80003d50:	00aa3023          	sd	a0,0(s4)
    80003d54:	c92d                	beqz	a0,80003dc6 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d56:	ffffc097          	auipc	ra,0xffffc
    80003d5a:	3c2080e7          	jalr	962(ra) # 80000118 <kalloc>
    80003d5e:	892a                	mv	s2,a0
    80003d60:	c125                	beqz	a0,80003dc0 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d62:	4985                	li	s3,1
    80003d64:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d68:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d6c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d70:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d74:	00004597          	auipc	a1,0x4
    80003d78:	67458593          	addi	a1,a1,1652 # 800083e8 <states.1723+0x1a0>
    80003d7c:	00002097          	auipc	ra,0x2
    80003d80:	3a0080e7          	jalr	928(ra) # 8000611c <initlock>
  (*f0)->type = FD_PIPE;
    80003d84:	609c                	ld	a5,0(s1)
    80003d86:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d8a:	609c                	ld	a5,0(s1)
    80003d8c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d90:	609c                	ld	a5,0(s1)
    80003d92:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d96:	609c                	ld	a5,0(s1)
    80003d98:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d9c:	000a3783          	ld	a5,0(s4)
    80003da0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003da4:	000a3783          	ld	a5,0(s4)
    80003da8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dac:	000a3783          	ld	a5,0(s4)
    80003db0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003db4:	000a3783          	ld	a5,0(s4)
    80003db8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003dbc:	4501                	li	a0,0
    80003dbe:	a025                	j	80003de6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dc0:	6088                	ld	a0,0(s1)
    80003dc2:	e501                	bnez	a0,80003dca <pipealloc+0xaa>
    80003dc4:	a039                	j	80003dd2 <pipealloc+0xb2>
    80003dc6:	6088                	ld	a0,0(s1)
    80003dc8:	c51d                	beqz	a0,80003df6 <pipealloc+0xd6>
    fileclose(*f0);
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	c26080e7          	jalr	-986(ra) # 800039f0 <fileclose>
  if(*f1)
    80003dd2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003dd6:	557d                	li	a0,-1
  if(*f1)
    80003dd8:	c799                	beqz	a5,80003de6 <pipealloc+0xc6>
    fileclose(*f1);
    80003dda:	853e                	mv	a0,a5
    80003ddc:	00000097          	auipc	ra,0x0
    80003de0:	c14080e7          	jalr	-1004(ra) # 800039f0 <fileclose>
  return -1;
    80003de4:	557d                	li	a0,-1
}
    80003de6:	70a2                	ld	ra,40(sp)
    80003de8:	7402                	ld	s0,32(sp)
    80003dea:	64e2                	ld	s1,24(sp)
    80003dec:	6942                	ld	s2,16(sp)
    80003dee:	69a2                	ld	s3,8(sp)
    80003df0:	6a02                	ld	s4,0(sp)
    80003df2:	6145                	addi	sp,sp,48
    80003df4:	8082                	ret
  return -1;
    80003df6:	557d                	li	a0,-1
    80003df8:	b7fd                	j	80003de6 <pipealloc+0xc6>

0000000080003dfa <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dfa:	1101                	addi	sp,sp,-32
    80003dfc:	ec06                	sd	ra,24(sp)
    80003dfe:	e822                	sd	s0,16(sp)
    80003e00:	e426                	sd	s1,8(sp)
    80003e02:	e04a                	sd	s2,0(sp)
    80003e04:	1000                	addi	s0,sp,32
    80003e06:	84aa                	mv	s1,a0
    80003e08:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e0a:	00002097          	auipc	ra,0x2
    80003e0e:	3a2080e7          	jalr	930(ra) # 800061ac <acquire>
  if(writable){
    80003e12:	02090d63          	beqz	s2,80003e4c <pipeclose+0x52>
    pi->writeopen = 0;
    80003e16:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e1a:	21848513          	addi	a0,s1,536
    80003e1e:	ffffd097          	auipc	ra,0xffffd
    80003e22:	74e080e7          	jalr	1870(ra) # 8000156c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e26:	2204b783          	ld	a5,544(s1)
    80003e2a:	eb95                	bnez	a5,80003e5e <pipeclose+0x64>
    release(&pi->lock);
    80003e2c:	8526                	mv	a0,s1
    80003e2e:	00002097          	auipc	ra,0x2
    80003e32:	432080e7          	jalr	1074(ra) # 80006260 <release>
    kfree((char*)pi);
    80003e36:	8526                	mv	a0,s1
    80003e38:	ffffc097          	auipc	ra,0xffffc
    80003e3c:	1e4080e7          	jalr	484(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e40:	60e2                	ld	ra,24(sp)
    80003e42:	6442                	ld	s0,16(sp)
    80003e44:	64a2                	ld	s1,8(sp)
    80003e46:	6902                	ld	s2,0(sp)
    80003e48:	6105                	addi	sp,sp,32
    80003e4a:	8082                	ret
    pi->readopen = 0;
    80003e4c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e50:	21c48513          	addi	a0,s1,540
    80003e54:	ffffd097          	auipc	ra,0xffffd
    80003e58:	718080e7          	jalr	1816(ra) # 8000156c <wakeup>
    80003e5c:	b7e9                	j	80003e26 <pipeclose+0x2c>
    release(&pi->lock);
    80003e5e:	8526                	mv	a0,s1
    80003e60:	00002097          	auipc	ra,0x2
    80003e64:	400080e7          	jalr	1024(ra) # 80006260 <release>
}
    80003e68:	bfe1                	j	80003e40 <pipeclose+0x46>

0000000080003e6a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e6a:	7159                	addi	sp,sp,-112
    80003e6c:	f486                	sd	ra,104(sp)
    80003e6e:	f0a2                	sd	s0,96(sp)
    80003e70:	eca6                	sd	s1,88(sp)
    80003e72:	e8ca                	sd	s2,80(sp)
    80003e74:	e4ce                	sd	s3,72(sp)
    80003e76:	e0d2                	sd	s4,64(sp)
    80003e78:	fc56                	sd	s5,56(sp)
    80003e7a:	f85a                	sd	s6,48(sp)
    80003e7c:	f45e                	sd	s7,40(sp)
    80003e7e:	f062                	sd	s8,32(sp)
    80003e80:	ec66                	sd	s9,24(sp)
    80003e82:	1880                	addi	s0,sp,112
    80003e84:	84aa                	mv	s1,a0
    80003e86:	8aae                	mv	s5,a1
    80003e88:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e8a:	ffffd097          	auipc	ra,0xffffd
    80003e8e:	fce080e7          	jalr	-50(ra) # 80000e58 <myproc>
    80003e92:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e94:	8526                	mv	a0,s1
    80003e96:	00002097          	auipc	ra,0x2
    80003e9a:	316080e7          	jalr	790(ra) # 800061ac <acquire>
  while(i < n){
    80003e9e:	0d405463          	blez	s4,80003f66 <pipewrite+0xfc>
    80003ea2:	8ba6                	mv	s7,s1
  int i = 0;
    80003ea4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ea6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ea8:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003eac:	21c48c13          	addi	s8,s1,540
    80003eb0:	a08d                	j	80003f12 <pipewrite+0xa8>
      release(&pi->lock);
    80003eb2:	8526                	mv	a0,s1
    80003eb4:	00002097          	auipc	ra,0x2
    80003eb8:	3ac080e7          	jalr	940(ra) # 80006260 <release>
      return -1;
    80003ebc:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ebe:	854a                	mv	a0,s2
    80003ec0:	70a6                	ld	ra,104(sp)
    80003ec2:	7406                	ld	s0,96(sp)
    80003ec4:	64e6                	ld	s1,88(sp)
    80003ec6:	6946                	ld	s2,80(sp)
    80003ec8:	69a6                	ld	s3,72(sp)
    80003eca:	6a06                	ld	s4,64(sp)
    80003ecc:	7ae2                	ld	s5,56(sp)
    80003ece:	7b42                	ld	s6,48(sp)
    80003ed0:	7ba2                	ld	s7,40(sp)
    80003ed2:	7c02                	ld	s8,32(sp)
    80003ed4:	6ce2                	ld	s9,24(sp)
    80003ed6:	6165                	addi	sp,sp,112
    80003ed8:	8082                	ret
      wakeup(&pi->nread);
    80003eda:	8566                	mv	a0,s9
    80003edc:	ffffd097          	auipc	ra,0xffffd
    80003ee0:	690080e7          	jalr	1680(ra) # 8000156c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ee4:	85de                	mv	a1,s7
    80003ee6:	8562                	mv	a0,s8
    80003ee8:	ffffd097          	auipc	ra,0xffffd
    80003eec:	620080e7          	jalr	1568(ra) # 80001508 <sleep>
    80003ef0:	a839                	j	80003f0e <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ef2:	21c4a783          	lw	a5,540(s1)
    80003ef6:	0017871b          	addiw	a4,a5,1
    80003efa:	20e4ae23          	sw	a4,540(s1)
    80003efe:	1ff7f793          	andi	a5,a5,511
    80003f02:	97a6                	add	a5,a5,s1
    80003f04:	f9f44703          	lbu	a4,-97(s0)
    80003f08:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f0c:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f0e:	05495063          	bge	s2,s4,80003f4e <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003f12:	2204a783          	lw	a5,544(s1)
    80003f16:	dfd1                	beqz	a5,80003eb2 <pipewrite+0x48>
    80003f18:	854e                	mv	a0,s3
    80003f1a:	ffffe097          	auipc	ra,0xffffe
    80003f1e:	896080e7          	jalr	-1898(ra) # 800017b0 <killed>
    80003f22:	f941                	bnez	a0,80003eb2 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f24:	2184a783          	lw	a5,536(s1)
    80003f28:	21c4a703          	lw	a4,540(s1)
    80003f2c:	2007879b          	addiw	a5,a5,512
    80003f30:	faf705e3          	beq	a4,a5,80003eda <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f34:	4685                	li	a3,1
    80003f36:	01590633          	add	a2,s2,s5
    80003f3a:	f9f40593          	addi	a1,s0,-97
    80003f3e:	0509b503          	ld	a0,80(s3)
    80003f42:	ffffd097          	auipc	ra,0xffffd
    80003f46:	c60080e7          	jalr	-928(ra) # 80000ba2 <copyin>
    80003f4a:	fb6514e3          	bne	a0,s6,80003ef2 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f4e:	21848513          	addi	a0,s1,536
    80003f52:	ffffd097          	auipc	ra,0xffffd
    80003f56:	61a080e7          	jalr	1562(ra) # 8000156c <wakeup>
  release(&pi->lock);
    80003f5a:	8526                	mv	a0,s1
    80003f5c:	00002097          	auipc	ra,0x2
    80003f60:	304080e7          	jalr	772(ra) # 80006260 <release>
  return i;
    80003f64:	bfa9                	j	80003ebe <pipewrite+0x54>
  int i = 0;
    80003f66:	4901                	li	s2,0
    80003f68:	b7dd                	j	80003f4e <pipewrite+0xe4>

0000000080003f6a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f6a:	715d                	addi	sp,sp,-80
    80003f6c:	e486                	sd	ra,72(sp)
    80003f6e:	e0a2                	sd	s0,64(sp)
    80003f70:	fc26                	sd	s1,56(sp)
    80003f72:	f84a                	sd	s2,48(sp)
    80003f74:	f44e                	sd	s3,40(sp)
    80003f76:	f052                	sd	s4,32(sp)
    80003f78:	ec56                	sd	s5,24(sp)
    80003f7a:	e85a                	sd	s6,16(sp)
    80003f7c:	0880                	addi	s0,sp,80
    80003f7e:	84aa                	mv	s1,a0
    80003f80:	892e                	mv	s2,a1
    80003f82:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f84:	ffffd097          	auipc	ra,0xffffd
    80003f88:	ed4080e7          	jalr	-300(ra) # 80000e58 <myproc>
    80003f8c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f8e:	8b26                	mv	s6,s1
    80003f90:	8526                	mv	a0,s1
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	21a080e7          	jalr	538(ra) # 800061ac <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f9a:	2184a703          	lw	a4,536(s1)
    80003f9e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fa2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fa6:	02f71763          	bne	a4,a5,80003fd4 <piperead+0x6a>
    80003faa:	2244a783          	lw	a5,548(s1)
    80003fae:	c39d                	beqz	a5,80003fd4 <piperead+0x6a>
    if(killed(pr)){
    80003fb0:	8552                	mv	a0,s4
    80003fb2:	ffffd097          	auipc	ra,0xffffd
    80003fb6:	7fe080e7          	jalr	2046(ra) # 800017b0 <killed>
    80003fba:	e941                	bnez	a0,8000404a <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fbc:	85da                	mv	a1,s6
    80003fbe:	854e                	mv	a0,s3
    80003fc0:	ffffd097          	auipc	ra,0xffffd
    80003fc4:	548080e7          	jalr	1352(ra) # 80001508 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fc8:	2184a703          	lw	a4,536(s1)
    80003fcc:	21c4a783          	lw	a5,540(s1)
    80003fd0:	fcf70de3          	beq	a4,a5,80003faa <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fd4:	09505263          	blez	s5,80004058 <piperead+0xee>
    80003fd8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fda:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80003fdc:	2184a783          	lw	a5,536(s1)
    80003fe0:	21c4a703          	lw	a4,540(s1)
    80003fe4:	02f70d63          	beq	a4,a5,8000401e <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003fe8:	0017871b          	addiw	a4,a5,1
    80003fec:	20e4ac23          	sw	a4,536(s1)
    80003ff0:	1ff7f793          	andi	a5,a5,511
    80003ff4:	97a6                	add	a5,a5,s1
    80003ff6:	0187c783          	lbu	a5,24(a5)
    80003ffa:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ffe:	4685                	li	a3,1
    80004000:	fbf40613          	addi	a2,s0,-65
    80004004:	85ca                	mv	a1,s2
    80004006:	050a3503          	ld	a0,80(s4)
    8000400a:	ffffd097          	auipc	ra,0xffffd
    8000400e:	b0c080e7          	jalr	-1268(ra) # 80000b16 <copyout>
    80004012:	01650663          	beq	a0,s6,8000401e <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004016:	2985                	addiw	s3,s3,1
    80004018:	0905                	addi	s2,s2,1
    8000401a:	fd3a91e3          	bne	s5,s3,80003fdc <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000401e:	21c48513          	addi	a0,s1,540
    80004022:	ffffd097          	auipc	ra,0xffffd
    80004026:	54a080e7          	jalr	1354(ra) # 8000156c <wakeup>
  release(&pi->lock);
    8000402a:	8526                	mv	a0,s1
    8000402c:	00002097          	auipc	ra,0x2
    80004030:	234080e7          	jalr	564(ra) # 80006260 <release>
  return i;
}
    80004034:	854e                	mv	a0,s3
    80004036:	60a6                	ld	ra,72(sp)
    80004038:	6406                	ld	s0,64(sp)
    8000403a:	74e2                	ld	s1,56(sp)
    8000403c:	7942                	ld	s2,48(sp)
    8000403e:	79a2                	ld	s3,40(sp)
    80004040:	7a02                	ld	s4,32(sp)
    80004042:	6ae2                	ld	s5,24(sp)
    80004044:	6b42                	ld	s6,16(sp)
    80004046:	6161                	addi	sp,sp,80
    80004048:	8082                	ret
      release(&pi->lock);
    8000404a:	8526                	mv	a0,s1
    8000404c:	00002097          	auipc	ra,0x2
    80004050:	214080e7          	jalr	532(ra) # 80006260 <release>
      return -1;
    80004054:	59fd                	li	s3,-1
    80004056:	bff9                	j	80004034 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004058:	4981                	li	s3,0
    8000405a:	b7d1                	j	8000401e <piperead+0xb4>

000000008000405c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000405c:	1141                	addi	sp,sp,-16
    8000405e:	e422                	sd	s0,8(sp)
    80004060:	0800                	addi	s0,sp,16
    80004062:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004064:	8905                	andi	a0,a0,1
    80004066:	c111                	beqz	a0,8000406a <flags2perm+0xe>
      perm = PTE_X;
    80004068:	4521                	li	a0,8
    if(flags & 0x2)
    8000406a:	8b89                	andi	a5,a5,2
    8000406c:	c399                	beqz	a5,80004072 <flags2perm+0x16>
      perm |= PTE_W;
    8000406e:	00456513          	ori	a0,a0,4
    return perm;
}
    80004072:	6422                	ld	s0,8(sp)
    80004074:	0141                	addi	sp,sp,16
    80004076:	8082                	ret

0000000080004078 <exec>:

int
exec(char *path, char **argv)
{
    80004078:	df010113          	addi	sp,sp,-528
    8000407c:	20113423          	sd	ra,520(sp)
    80004080:	20813023          	sd	s0,512(sp)
    80004084:	ffa6                	sd	s1,504(sp)
    80004086:	fbca                	sd	s2,496(sp)
    80004088:	f7ce                	sd	s3,488(sp)
    8000408a:	f3d2                	sd	s4,480(sp)
    8000408c:	efd6                	sd	s5,472(sp)
    8000408e:	ebda                	sd	s6,464(sp)
    80004090:	e7de                	sd	s7,456(sp)
    80004092:	e3e2                	sd	s8,448(sp)
    80004094:	ff66                	sd	s9,440(sp)
    80004096:	fb6a                	sd	s10,432(sp)
    80004098:	f76e                	sd	s11,424(sp)
    8000409a:	0c00                	addi	s0,sp,528
    8000409c:	84aa                	mv	s1,a0
    8000409e:	dea43c23          	sd	a0,-520(s0)
    800040a2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	db2080e7          	jalr	-590(ra) # 80000e58 <myproc>
    800040ae:	892a                	mv	s2,a0

  begin_op();
    800040b0:	fffff097          	auipc	ra,0xfffff
    800040b4:	474080e7          	jalr	1140(ra) # 80003524 <begin_op>

  if((ip = namei(path)) == 0){
    800040b8:	8526                	mv	a0,s1
    800040ba:	fffff097          	auipc	ra,0xfffff
    800040be:	24e080e7          	jalr	590(ra) # 80003308 <namei>
    800040c2:	c92d                	beqz	a0,80004134 <exec+0xbc>
    800040c4:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040c6:	fffff097          	auipc	ra,0xfffff
    800040ca:	a9c080e7          	jalr	-1380(ra) # 80002b62 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040ce:	04000713          	li	a4,64
    800040d2:	4681                	li	a3,0
    800040d4:	e5040613          	addi	a2,s0,-432
    800040d8:	4581                	li	a1,0
    800040da:	8526                	mv	a0,s1
    800040dc:	fffff097          	auipc	ra,0xfffff
    800040e0:	d3a080e7          	jalr	-710(ra) # 80002e16 <readi>
    800040e4:	04000793          	li	a5,64
    800040e8:	00f51a63          	bne	a0,a5,800040fc <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800040ec:	e5042703          	lw	a4,-432(s0)
    800040f0:	464c47b7          	lui	a5,0x464c4
    800040f4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040f8:	04f70463          	beq	a4,a5,80004140 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040fc:	8526                	mv	a0,s1
    800040fe:	fffff097          	auipc	ra,0xfffff
    80004102:	cc6080e7          	jalr	-826(ra) # 80002dc4 <iunlockput>
    end_op();
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	49e080e7          	jalr	1182(ra) # 800035a4 <end_op>
  }
  return -1;
    8000410e:	557d                	li	a0,-1
}
    80004110:	20813083          	ld	ra,520(sp)
    80004114:	20013403          	ld	s0,512(sp)
    80004118:	74fe                	ld	s1,504(sp)
    8000411a:	795e                	ld	s2,496(sp)
    8000411c:	79be                	ld	s3,488(sp)
    8000411e:	7a1e                	ld	s4,480(sp)
    80004120:	6afe                	ld	s5,472(sp)
    80004122:	6b5e                	ld	s6,464(sp)
    80004124:	6bbe                	ld	s7,456(sp)
    80004126:	6c1e                	ld	s8,448(sp)
    80004128:	7cfa                	ld	s9,440(sp)
    8000412a:	7d5a                	ld	s10,432(sp)
    8000412c:	7dba                	ld	s11,424(sp)
    8000412e:	21010113          	addi	sp,sp,528
    80004132:	8082                	ret
    end_op();
    80004134:	fffff097          	auipc	ra,0xfffff
    80004138:	470080e7          	jalr	1136(ra) # 800035a4 <end_op>
    return -1;
    8000413c:	557d                	li	a0,-1
    8000413e:	bfc9                	j	80004110 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004140:	854a                	mv	a0,s2
    80004142:	ffffd097          	auipc	ra,0xffffd
    80004146:	dda080e7          	jalr	-550(ra) # 80000f1c <proc_pagetable>
    8000414a:	8baa                	mv	s7,a0
    8000414c:	d945                	beqz	a0,800040fc <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000414e:	e7042983          	lw	s3,-400(s0)
    80004152:	e8845783          	lhu	a5,-376(s0)
    80004156:	c7ad                	beqz	a5,800041c0 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004158:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000415a:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    8000415c:	6c85                	lui	s9,0x1
    8000415e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004162:	def43823          	sd	a5,-528(s0)
    80004166:	ac0d                	j	80004398 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004168:	00004517          	auipc	a0,0x4
    8000416c:	65850513          	addi	a0,a0,1624 # 800087c0 <syscall_names+0x278>
    80004170:	00002097          	auipc	ra,0x2
    80004174:	af2080e7          	jalr	-1294(ra) # 80005c62 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004178:	8756                	mv	a4,s5
    8000417a:	012d86bb          	addw	a3,s11,s2
    8000417e:	4581                	li	a1,0
    80004180:	8526                	mv	a0,s1
    80004182:	fffff097          	auipc	ra,0xfffff
    80004186:	c94080e7          	jalr	-876(ra) # 80002e16 <readi>
    8000418a:	2501                	sext.w	a0,a0
    8000418c:	1aaa9a63          	bne	s5,a0,80004340 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004190:	6785                	lui	a5,0x1
    80004192:	0127893b          	addw	s2,a5,s2
    80004196:	77fd                	lui	a5,0xfffff
    80004198:	01478a3b          	addw	s4,a5,s4
    8000419c:	1f897563          	bgeu	s2,s8,80004386 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800041a0:	02091593          	slli	a1,s2,0x20
    800041a4:	9181                	srli	a1,a1,0x20
    800041a6:	95ea                	add	a1,a1,s10
    800041a8:	855e                	mv	a0,s7
    800041aa:	ffffc097          	auipc	ra,0xffffc
    800041ae:	360080e7          	jalr	864(ra) # 8000050a <walkaddr>
    800041b2:	862a                	mv	a2,a0
    if(pa == 0)
    800041b4:	d955                	beqz	a0,80004168 <exec+0xf0>
      n = PGSIZE;
    800041b6:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800041b8:	fd9a70e3          	bgeu	s4,s9,80004178 <exec+0x100>
      n = sz - i;
    800041bc:	8ad2                	mv	s5,s4
    800041be:	bf6d                	j	80004178 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041c0:	4a01                	li	s4,0
  iunlockput(ip);
    800041c2:	8526                	mv	a0,s1
    800041c4:	fffff097          	auipc	ra,0xfffff
    800041c8:	c00080e7          	jalr	-1024(ra) # 80002dc4 <iunlockput>
  end_op();
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	3d8080e7          	jalr	984(ra) # 800035a4 <end_op>
  p = myproc();
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	c84080e7          	jalr	-892(ra) # 80000e58 <myproc>
    800041dc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041de:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041e2:	6785                	lui	a5,0x1
    800041e4:	17fd                	addi	a5,a5,-1
    800041e6:	9a3e                	add	s4,s4,a5
    800041e8:	757d                	lui	a0,0xfffff
    800041ea:	00aa77b3          	and	a5,s4,a0
    800041ee:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800041f2:	4691                	li	a3,4
    800041f4:	6609                	lui	a2,0x2
    800041f6:	963e                	add	a2,a2,a5
    800041f8:	85be                	mv	a1,a5
    800041fa:	855e                	mv	a0,s7
    800041fc:	ffffc097          	auipc	ra,0xffffc
    80004200:	6c2080e7          	jalr	1730(ra) # 800008be <uvmalloc>
    80004204:	8b2a                	mv	s6,a0
  ip = 0;
    80004206:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004208:	12050c63          	beqz	a0,80004340 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000420c:	75f9                	lui	a1,0xffffe
    8000420e:	95aa                	add	a1,a1,a0
    80004210:	855e                	mv	a0,s7
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	8d2080e7          	jalr	-1838(ra) # 80000ae4 <uvmclear>
  stackbase = sp - PGSIZE;
    8000421a:	7c7d                	lui	s8,0xfffff
    8000421c:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000421e:	e0043783          	ld	a5,-512(s0)
    80004222:	6388                	ld	a0,0(a5)
    80004224:	c535                	beqz	a0,80004290 <exec+0x218>
    80004226:	e9040993          	addi	s3,s0,-368
    8000422a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000422e:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004230:	ffffc097          	auipc	ra,0xffffc
    80004234:	0cc080e7          	jalr	204(ra) # 800002fc <strlen>
    80004238:	2505                	addiw	a0,a0,1
    8000423a:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000423e:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004242:	13896663          	bltu	s2,s8,8000436e <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004246:	e0043d83          	ld	s11,-512(s0)
    8000424a:	000dba03          	ld	s4,0(s11)
    8000424e:	8552                	mv	a0,s4
    80004250:	ffffc097          	auipc	ra,0xffffc
    80004254:	0ac080e7          	jalr	172(ra) # 800002fc <strlen>
    80004258:	0015069b          	addiw	a3,a0,1
    8000425c:	8652                	mv	a2,s4
    8000425e:	85ca                	mv	a1,s2
    80004260:	855e                	mv	a0,s7
    80004262:	ffffd097          	auipc	ra,0xffffd
    80004266:	8b4080e7          	jalr	-1868(ra) # 80000b16 <copyout>
    8000426a:	10054663          	bltz	a0,80004376 <exec+0x2fe>
    ustack[argc] = sp;
    8000426e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004272:	0485                	addi	s1,s1,1
    80004274:	008d8793          	addi	a5,s11,8
    80004278:	e0f43023          	sd	a5,-512(s0)
    8000427c:	008db503          	ld	a0,8(s11)
    80004280:	c911                	beqz	a0,80004294 <exec+0x21c>
    if(argc >= MAXARG)
    80004282:	09a1                	addi	s3,s3,8
    80004284:	fb3c96e3          	bne	s9,s3,80004230 <exec+0x1b8>
  sz = sz1;
    80004288:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000428c:	4481                	li	s1,0
    8000428e:	a84d                	j	80004340 <exec+0x2c8>
  sp = sz;
    80004290:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004292:	4481                	li	s1,0
  ustack[argc] = 0;
    80004294:	00349793          	slli	a5,s1,0x3
    80004298:	f9040713          	addi	a4,s0,-112
    8000429c:	97ba                	add	a5,a5,a4
    8000429e:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042a2:	00148693          	addi	a3,s1,1
    800042a6:	068e                	slli	a3,a3,0x3
    800042a8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042ac:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042b0:	01897663          	bgeu	s2,s8,800042bc <exec+0x244>
  sz = sz1;
    800042b4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042b8:	4481                	li	s1,0
    800042ba:	a059                	j	80004340 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042bc:	e9040613          	addi	a2,s0,-368
    800042c0:	85ca                	mv	a1,s2
    800042c2:	855e                	mv	a0,s7
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	852080e7          	jalr	-1966(ra) # 80000b16 <copyout>
    800042cc:	0a054963          	bltz	a0,8000437e <exec+0x306>
  p->trapframe->a1 = sp;
    800042d0:	058ab783          	ld	a5,88(s5)
    800042d4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042d8:	df843783          	ld	a5,-520(s0)
    800042dc:	0007c703          	lbu	a4,0(a5)
    800042e0:	cf11                	beqz	a4,800042fc <exec+0x284>
    800042e2:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042e4:	02f00693          	li	a3,47
    800042e8:	a039                	j	800042f6 <exec+0x27e>
      last = s+1;
    800042ea:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800042ee:	0785                	addi	a5,a5,1
    800042f0:	fff7c703          	lbu	a4,-1(a5)
    800042f4:	c701                	beqz	a4,800042fc <exec+0x284>
    if(*s == '/')
    800042f6:	fed71ce3          	bne	a4,a3,800042ee <exec+0x276>
    800042fa:	bfc5                	j	800042ea <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800042fc:	4641                	li	a2,16
    800042fe:	df843583          	ld	a1,-520(s0)
    80004302:	158a8513          	addi	a0,s5,344
    80004306:	ffffc097          	auipc	ra,0xffffc
    8000430a:	fc4080e7          	jalr	-60(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    8000430e:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004312:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004316:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000431a:	058ab783          	ld	a5,88(s5)
    8000431e:	e6843703          	ld	a4,-408(s0)
    80004322:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004324:	058ab783          	ld	a5,88(s5)
    80004328:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000432c:	85ea                	mv	a1,s10
    8000432e:	ffffd097          	auipc	ra,0xffffd
    80004332:	c8a080e7          	jalr	-886(ra) # 80000fb8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004336:	0004851b          	sext.w	a0,s1
    8000433a:	bbd9                	j	80004110 <exec+0x98>
    8000433c:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004340:	e0843583          	ld	a1,-504(s0)
    80004344:	855e                	mv	a0,s7
    80004346:	ffffd097          	auipc	ra,0xffffd
    8000434a:	c72080e7          	jalr	-910(ra) # 80000fb8 <proc_freepagetable>
  if(ip){
    8000434e:	da0497e3          	bnez	s1,800040fc <exec+0x84>
  return -1;
    80004352:	557d                	li	a0,-1
    80004354:	bb75                	j	80004110 <exec+0x98>
    80004356:	e1443423          	sd	s4,-504(s0)
    8000435a:	b7dd                	j	80004340 <exec+0x2c8>
    8000435c:	e1443423          	sd	s4,-504(s0)
    80004360:	b7c5                	j	80004340 <exec+0x2c8>
    80004362:	e1443423          	sd	s4,-504(s0)
    80004366:	bfe9                	j	80004340 <exec+0x2c8>
    80004368:	e1443423          	sd	s4,-504(s0)
    8000436c:	bfd1                	j	80004340 <exec+0x2c8>
  sz = sz1;
    8000436e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004372:	4481                	li	s1,0
    80004374:	b7f1                	j	80004340 <exec+0x2c8>
  sz = sz1;
    80004376:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000437a:	4481                	li	s1,0
    8000437c:	b7d1                	j	80004340 <exec+0x2c8>
  sz = sz1;
    8000437e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004382:	4481                	li	s1,0
    80004384:	bf75                	j	80004340 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004386:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000438a:	2b05                	addiw	s6,s6,1
    8000438c:	0389899b          	addiw	s3,s3,56
    80004390:	e8845783          	lhu	a5,-376(s0)
    80004394:	e2fb57e3          	bge	s6,a5,800041c2 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004398:	2981                	sext.w	s3,s3
    8000439a:	03800713          	li	a4,56
    8000439e:	86ce                	mv	a3,s3
    800043a0:	e1840613          	addi	a2,s0,-488
    800043a4:	4581                	li	a1,0
    800043a6:	8526                	mv	a0,s1
    800043a8:	fffff097          	auipc	ra,0xfffff
    800043ac:	a6e080e7          	jalr	-1426(ra) # 80002e16 <readi>
    800043b0:	03800793          	li	a5,56
    800043b4:	f8f514e3          	bne	a0,a5,8000433c <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800043b8:	e1842783          	lw	a5,-488(s0)
    800043bc:	4705                	li	a4,1
    800043be:	fce796e3          	bne	a5,a4,8000438a <exec+0x312>
    if(ph.memsz < ph.filesz)
    800043c2:	e4043903          	ld	s2,-448(s0)
    800043c6:	e3843783          	ld	a5,-456(s0)
    800043ca:	f8f966e3          	bltu	s2,a5,80004356 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043ce:	e2843783          	ld	a5,-472(s0)
    800043d2:	993e                	add	s2,s2,a5
    800043d4:	f8f964e3          	bltu	s2,a5,8000435c <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800043d8:	df043703          	ld	a4,-528(s0)
    800043dc:	8ff9                	and	a5,a5,a4
    800043de:	f3d1                	bnez	a5,80004362 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043e0:	e1c42503          	lw	a0,-484(s0)
    800043e4:	00000097          	auipc	ra,0x0
    800043e8:	c78080e7          	jalr	-904(ra) # 8000405c <flags2perm>
    800043ec:	86aa                	mv	a3,a0
    800043ee:	864a                	mv	a2,s2
    800043f0:	85d2                	mv	a1,s4
    800043f2:	855e                	mv	a0,s7
    800043f4:	ffffc097          	auipc	ra,0xffffc
    800043f8:	4ca080e7          	jalr	1226(ra) # 800008be <uvmalloc>
    800043fc:	e0a43423          	sd	a0,-504(s0)
    80004400:	d525                	beqz	a0,80004368 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004402:	e2843d03          	ld	s10,-472(s0)
    80004406:	e2042d83          	lw	s11,-480(s0)
    8000440a:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000440e:	f60c0ce3          	beqz	s8,80004386 <exec+0x30e>
    80004412:	8a62                	mv	s4,s8
    80004414:	4901                	li	s2,0
    80004416:	b369                	j	800041a0 <exec+0x128>

0000000080004418 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004418:	7179                	addi	sp,sp,-48
    8000441a:	f406                	sd	ra,40(sp)
    8000441c:	f022                	sd	s0,32(sp)
    8000441e:	ec26                	sd	s1,24(sp)
    80004420:	e84a                	sd	s2,16(sp)
    80004422:	1800                	addi	s0,sp,48
    80004424:	892e                	mv	s2,a1
    80004426:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004428:	fdc40593          	addi	a1,s0,-36
    8000442c:	ffffe097          	auipc	ra,0xffffe
    80004430:	b48080e7          	jalr	-1208(ra) # 80001f74 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004434:	fdc42703          	lw	a4,-36(s0)
    80004438:	47bd                	li	a5,15
    8000443a:	02e7eb63          	bltu	a5,a4,80004470 <argfd+0x58>
    8000443e:	ffffd097          	auipc	ra,0xffffd
    80004442:	a1a080e7          	jalr	-1510(ra) # 80000e58 <myproc>
    80004446:	fdc42703          	lw	a4,-36(s0)
    8000444a:	01a70793          	addi	a5,a4,26
    8000444e:	078e                	slli	a5,a5,0x3
    80004450:	953e                	add	a0,a0,a5
    80004452:	611c                	ld	a5,0(a0)
    80004454:	c385                	beqz	a5,80004474 <argfd+0x5c>
    return -1;
  if(pfd)
    80004456:	00090463          	beqz	s2,8000445e <argfd+0x46>
    *pfd = fd;
    8000445a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000445e:	4501                	li	a0,0
  if(pf)
    80004460:	c091                	beqz	s1,80004464 <argfd+0x4c>
    *pf = f;
    80004462:	e09c                	sd	a5,0(s1)
}
    80004464:	70a2                	ld	ra,40(sp)
    80004466:	7402                	ld	s0,32(sp)
    80004468:	64e2                	ld	s1,24(sp)
    8000446a:	6942                	ld	s2,16(sp)
    8000446c:	6145                	addi	sp,sp,48
    8000446e:	8082                	ret
    return -1;
    80004470:	557d                	li	a0,-1
    80004472:	bfcd                	j	80004464 <argfd+0x4c>
    80004474:	557d                	li	a0,-1
    80004476:	b7fd                	j	80004464 <argfd+0x4c>

0000000080004478 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004478:	1101                	addi	sp,sp,-32
    8000447a:	ec06                	sd	ra,24(sp)
    8000447c:	e822                	sd	s0,16(sp)
    8000447e:	e426                	sd	s1,8(sp)
    80004480:	1000                	addi	s0,sp,32
    80004482:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004484:	ffffd097          	auipc	ra,0xffffd
    80004488:	9d4080e7          	jalr	-1580(ra) # 80000e58 <myproc>
    8000448c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000448e:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd010>
    80004492:	4501                	li	a0,0
    80004494:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004496:	6398                	ld	a4,0(a5)
    80004498:	cb19                	beqz	a4,800044ae <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000449a:	2505                	addiw	a0,a0,1
    8000449c:	07a1                	addi	a5,a5,8
    8000449e:	fed51ce3          	bne	a0,a3,80004496 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044a2:	557d                	li	a0,-1
}
    800044a4:	60e2                	ld	ra,24(sp)
    800044a6:	6442                	ld	s0,16(sp)
    800044a8:	64a2                	ld	s1,8(sp)
    800044aa:	6105                	addi	sp,sp,32
    800044ac:	8082                	ret
      p->ofile[fd] = f;
    800044ae:	01a50793          	addi	a5,a0,26
    800044b2:	078e                	slli	a5,a5,0x3
    800044b4:	963e                	add	a2,a2,a5
    800044b6:	e204                	sd	s1,0(a2)
      return fd;
    800044b8:	b7f5                	j	800044a4 <fdalloc+0x2c>

00000000800044ba <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044ba:	715d                	addi	sp,sp,-80
    800044bc:	e486                	sd	ra,72(sp)
    800044be:	e0a2                	sd	s0,64(sp)
    800044c0:	fc26                	sd	s1,56(sp)
    800044c2:	f84a                	sd	s2,48(sp)
    800044c4:	f44e                	sd	s3,40(sp)
    800044c6:	f052                	sd	s4,32(sp)
    800044c8:	ec56                	sd	s5,24(sp)
    800044ca:	e85a                	sd	s6,16(sp)
    800044cc:	0880                	addi	s0,sp,80
    800044ce:	8b2e                	mv	s6,a1
    800044d0:	89b2                	mv	s3,a2
    800044d2:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044d4:	fb040593          	addi	a1,s0,-80
    800044d8:	fffff097          	auipc	ra,0xfffff
    800044dc:	e4e080e7          	jalr	-434(ra) # 80003326 <nameiparent>
    800044e0:	84aa                	mv	s1,a0
    800044e2:	16050063          	beqz	a0,80004642 <create+0x188>
    return 0;

  ilock(dp);
    800044e6:	ffffe097          	auipc	ra,0xffffe
    800044ea:	67c080e7          	jalr	1660(ra) # 80002b62 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044ee:	4601                	li	a2,0
    800044f0:	fb040593          	addi	a1,s0,-80
    800044f4:	8526                	mv	a0,s1
    800044f6:	fffff097          	auipc	ra,0xfffff
    800044fa:	b50080e7          	jalr	-1200(ra) # 80003046 <dirlookup>
    800044fe:	8aaa                	mv	s5,a0
    80004500:	c931                	beqz	a0,80004554 <create+0x9a>
    iunlockput(dp);
    80004502:	8526                	mv	a0,s1
    80004504:	fffff097          	auipc	ra,0xfffff
    80004508:	8c0080e7          	jalr	-1856(ra) # 80002dc4 <iunlockput>
    ilock(ip);
    8000450c:	8556                	mv	a0,s5
    8000450e:	ffffe097          	auipc	ra,0xffffe
    80004512:	654080e7          	jalr	1620(ra) # 80002b62 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004516:	000b059b          	sext.w	a1,s6
    8000451a:	4789                	li	a5,2
    8000451c:	02f59563          	bne	a1,a5,80004546 <create+0x8c>
    80004520:	044ad783          	lhu	a5,68(s5)
    80004524:	37f9                	addiw	a5,a5,-2
    80004526:	17c2                	slli	a5,a5,0x30
    80004528:	93c1                	srli	a5,a5,0x30
    8000452a:	4705                	li	a4,1
    8000452c:	00f76d63          	bltu	a4,a5,80004546 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004530:	8556                	mv	a0,s5
    80004532:	60a6                	ld	ra,72(sp)
    80004534:	6406                	ld	s0,64(sp)
    80004536:	74e2                	ld	s1,56(sp)
    80004538:	7942                	ld	s2,48(sp)
    8000453a:	79a2                	ld	s3,40(sp)
    8000453c:	7a02                	ld	s4,32(sp)
    8000453e:	6ae2                	ld	s5,24(sp)
    80004540:	6b42                	ld	s6,16(sp)
    80004542:	6161                	addi	sp,sp,80
    80004544:	8082                	ret
    iunlockput(ip);
    80004546:	8556                	mv	a0,s5
    80004548:	fffff097          	auipc	ra,0xfffff
    8000454c:	87c080e7          	jalr	-1924(ra) # 80002dc4 <iunlockput>
    return 0;
    80004550:	4a81                	li	s5,0
    80004552:	bff9                	j	80004530 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004554:	85da                	mv	a1,s6
    80004556:	4088                	lw	a0,0(s1)
    80004558:	ffffe097          	auipc	ra,0xffffe
    8000455c:	46e080e7          	jalr	1134(ra) # 800029c6 <ialloc>
    80004560:	8a2a                	mv	s4,a0
    80004562:	c921                	beqz	a0,800045b2 <create+0xf8>
  ilock(ip);
    80004564:	ffffe097          	auipc	ra,0xffffe
    80004568:	5fe080e7          	jalr	1534(ra) # 80002b62 <ilock>
  ip->major = major;
    8000456c:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004570:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004574:	4785                	li	a5,1
    80004576:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    8000457a:	8552                	mv	a0,s4
    8000457c:	ffffe097          	auipc	ra,0xffffe
    80004580:	51c080e7          	jalr	1308(ra) # 80002a98 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004584:	000b059b          	sext.w	a1,s6
    80004588:	4785                	li	a5,1
    8000458a:	02f58b63          	beq	a1,a5,800045c0 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    8000458e:	004a2603          	lw	a2,4(s4)
    80004592:	fb040593          	addi	a1,s0,-80
    80004596:	8526                	mv	a0,s1
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	cbe080e7          	jalr	-834(ra) # 80003256 <dirlink>
    800045a0:	06054f63          	bltz	a0,8000461e <create+0x164>
  iunlockput(dp);
    800045a4:	8526                	mv	a0,s1
    800045a6:	fffff097          	auipc	ra,0xfffff
    800045aa:	81e080e7          	jalr	-2018(ra) # 80002dc4 <iunlockput>
  return ip;
    800045ae:	8ad2                	mv	s5,s4
    800045b0:	b741                	j	80004530 <create+0x76>
    iunlockput(dp);
    800045b2:	8526                	mv	a0,s1
    800045b4:	fffff097          	auipc	ra,0xfffff
    800045b8:	810080e7          	jalr	-2032(ra) # 80002dc4 <iunlockput>
    return 0;
    800045bc:	8ad2                	mv	s5,s4
    800045be:	bf8d                	j	80004530 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045c0:	004a2603          	lw	a2,4(s4)
    800045c4:	00004597          	auipc	a1,0x4
    800045c8:	21c58593          	addi	a1,a1,540 # 800087e0 <syscall_names+0x298>
    800045cc:	8552                	mv	a0,s4
    800045ce:	fffff097          	auipc	ra,0xfffff
    800045d2:	c88080e7          	jalr	-888(ra) # 80003256 <dirlink>
    800045d6:	04054463          	bltz	a0,8000461e <create+0x164>
    800045da:	40d0                	lw	a2,4(s1)
    800045dc:	00004597          	auipc	a1,0x4
    800045e0:	20c58593          	addi	a1,a1,524 # 800087e8 <syscall_names+0x2a0>
    800045e4:	8552                	mv	a0,s4
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	c70080e7          	jalr	-912(ra) # 80003256 <dirlink>
    800045ee:	02054863          	bltz	a0,8000461e <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    800045f2:	004a2603          	lw	a2,4(s4)
    800045f6:	fb040593          	addi	a1,s0,-80
    800045fa:	8526                	mv	a0,s1
    800045fc:	fffff097          	auipc	ra,0xfffff
    80004600:	c5a080e7          	jalr	-934(ra) # 80003256 <dirlink>
    80004604:	00054d63          	bltz	a0,8000461e <create+0x164>
    dp->nlink++;  // for ".."
    80004608:	04a4d783          	lhu	a5,74(s1)
    8000460c:	2785                	addiw	a5,a5,1
    8000460e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004612:	8526                	mv	a0,s1
    80004614:	ffffe097          	auipc	ra,0xffffe
    80004618:	484080e7          	jalr	1156(ra) # 80002a98 <iupdate>
    8000461c:	b761                	j	800045a4 <create+0xea>
  ip->nlink = 0;
    8000461e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004622:	8552                	mv	a0,s4
    80004624:	ffffe097          	auipc	ra,0xffffe
    80004628:	474080e7          	jalr	1140(ra) # 80002a98 <iupdate>
  iunlockput(ip);
    8000462c:	8552                	mv	a0,s4
    8000462e:	ffffe097          	auipc	ra,0xffffe
    80004632:	796080e7          	jalr	1942(ra) # 80002dc4 <iunlockput>
  iunlockput(dp);
    80004636:	8526                	mv	a0,s1
    80004638:	ffffe097          	auipc	ra,0xffffe
    8000463c:	78c080e7          	jalr	1932(ra) # 80002dc4 <iunlockput>
  return 0;
    80004640:	bdc5                	j	80004530 <create+0x76>
    return 0;
    80004642:	8aaa                	mv	s5,a0
    80004644:	b5f5                	j	80004530 <create+0x76>

0000000080004646 <sys_dup>:
{
    80004646:	7179                	addi	sp,sp,-48
    80004648:	f406                	sd	ra,40(sp)
    8000464a:	f022                	sd	s0,32(sp)
    8000464c:	ec26                	sd	s1,24(sp)
    8000464e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004650:	fd840613          	addi	a2,s0,-40
    80004654:	4581                	li	a1,0
    80004656:	4501                	li	a0,0
    80004658:	00000097          	auipc	ra,0x0
    8000465c:	dc0080e7          	jalr	-576(ra) # 80004418 <argfd>
    return -1;
    80004660:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004662:	02054363          	bltz	a0,80004688 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004666:	fd843503          	ld	a0,-40(s0)
    8000466a:	00000097          	auipc	ra,0x0
    8000466e:	e0e080e7          	jalr	-498(ra) # 80004478 <fdalloc>
    80004672:	84aa                	mv	s1,a0
    return -1;
    80004674:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004676:	00054963          	bltz	a0,80004688 <sys_dup+0x42>
  filedup(f);
    8000467a:	fd843503          	ld	a0,-40(s0)
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	320080e7          	jalr	800(ra) # 8000399e <filedup>
  return fd;
    80004686:	87a6                	mv	a5,s1
}
    80004688:	853e                	mv	a0,a5
    8000468a:	70a2                	ld	ra,40(sp)
    8000468c:	7402                	ld	s0,32(sp)
    8000468e:	64e2                	ld	s1,24(sp)
    80004690:	6145                	addi	sp,sp,48
    80004692:	8082                	ret

0000000080004694 <sys_read>:
{
    80004694:	7179                	addi	sp,sp,-48
    80004696:	f406                	sd	ra,40(sp)
    80004698:	f022                	sd	s0,32(sp)
    8000469a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000469c:	fd840593          	addi	a1,s0,-40
    800046a0:	4505                	li	a0,1
    800046a2:	ffffe097          	auipc	ra,0xffffe
    800046a6:	8f2080e7          	jalr	-1806(ra) # 80001f94 <argaddr>
  argint(2, &n);
    800046aa:	fe440593          	addi	a1,s0,-28
    800046ae:	4509                	li	a0,2
    800046b0:	ffffe097          	auipc	ra,0xffffe
    800046b4:	8c4080e7          	jalr	-1852(ra) # 80001f74 <argint>
  if(argfd(0, 0, &f) < 0)
    800046b8:	fe840613          	addi	a2,s0,-24
    800046bc:	4581                	li	a1,0
    800046be:	4501                	li	a0,0
    800046c0:	00000097          	auipc	ra,0x0
    800046c4:	d58080e7          	jalr	-680(ra) # 80004418 <argfd>
    800046c8:	87aa                	mv	a5,a0
    return -1;
    800046ca:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046cc:	0007cc63          	bltz	a5,800046e4 <sys_read+0x50>
  return fileread(f, p, n);
    800046d0:	fe442603          	lw	a2,-28(s0)
    800046d4:	fd843583          	ld	a1,-40(s0)
    800046d8:	fe843503          	ld	a0,-24(s0)
    800046dc:	fffff097          	auipc	ra,0xfffff
    800046e0:	44e080e7          	jalr	1102(ra) # 80003b2a <fileread>
}
    800046e4:	70a2                	ld	ra,40(sp)
    800046e6:	7402                	ld	s0,32(sp)
    800046e8:	6145                	addi	sp,sp,48
    800046ea:	8082                	ret

00000000800046ec <sys_write>:
{
    800046ec:	7179                	addi	sp,sp,-48
    800046ee:	f406                	sd	ra,40(sp)
    800046f0:	f022                	sd	s0,32(sp)
    800046f2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046f4:	fd840593          	addi	a1,s0,-40
    800046f8:	4505                	li	a0,1
    800046fa:	ffffe097          	auipc	ra,0xffffe
    800046fe:	89a080e7          	jalr	-1894(ra) # 80001f94 <argaddr>
  argint(2, &n);
    80004702:	fe440593          	addi	a1,s0,-28
    80004706:	4509                	li	a0,2
    80004708:	ffffe097          	auipc	ra,0xffffe
    8000470c:	86c080e7          	jalr	-1940(ra) # 80001f74 <argint>
  if(argfd(0, 0, &f) < 0)
    80004710:	fe840613          	addi	a2,s0,-24
    80004714:	4581                	li	a1,0
    80004716:	4501                	li	a0,0
    80004718:	00000097          	auipc	ra,0x0
    8000471c:	d00080e7          	jalr	-768(ra) # 80004418 <argfd>
    80004720:	87aa                	mv	a5,a0
    return -1;
    80004722:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004724:	0007cc63          	bltz	a5,8000473c <sys_write+0x50>
  return filewrite(f, p, n);
    80004728:	fe442603          	lw	a2,-28(s0)
    8000472c:	fd843583          	ld	a1,-40(s0)
    80004730:	fe843503          	ld	a0,-24(s0)
    80004734:	fffff097          	auipc	ra,0xfffff
    80004738:	4b8080e7          	jalr	1208(ra) # 80003bec <filewrite>
}
    8000473c:	70a2                	ld	ra,40(sp)
    8000473e:	7402                	ld	s0,32(sp)
    80004740:	6145                	addi	sp,sp,48
    80004742:	8082                	ret

0000000080004744 <sys_close>:
{
    80004744:	1101                	addi	sp,sp,-32
    80004746:	ec06                	sd	ra,24(sp)
    80004748:	e822                	sd	s0,16(sp)
    8000474a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000474c:	fe040613          	addi	a2,s0,-32
    80004750:	fec40593          	addi	a1,s0,-20
    80004754:	4501                	li	a0,0
    80004756:	00000097          	auipc	ra,0x0
    8000475a:	cc2080e7          	jalr	-830(ra) # 80004418 <argfd>
    return -1;
    8000475e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004760:	02054463          	bltz	a0,80004788 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004764:	ffffc097          	auipc	ra,0xffffc
    80004768:	6f4080e7          	jalr	1780(ra) # 80000e58 <myproc>
    8000476c:	fec42783          	lw	a5,-20(s0)
    80004770:	07e9                	addi	a5,a5,26
    80004772:	078e                	slli	a5,a5,0x3
    80004774:	97aa                	add	a5,a5,a0
    80004776:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000477a:	fe043503          	ld	a0,-32(s0)
    8000477e:	fffff097          	auipc	ra,0xfffff
    80004782:	272080e7          	jalr	626(ra) # 800039f0 <fileclose>
  return 0;
    80004786:	4781                	li	a5,0
}
    80004788:	853e                	mv	a0,a5
    8000478a:	60e2                	ld	ra,24(sp)
    8000478c:	6442                	ld	s0,16(sp)
    8000478e:	6105                	addi	sp,sp,32
    80004790:	8082                	ret

0000000080004792 <sys_fstat>:
{
    80004792:	1101                	addi	sp,sp,-32
    80004794:	ec06                	sd	ra,24(sp)
    80004796:	e822                	sd	s0,16(sp)
    80004798:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000479a:	fe040593          	addi	a1,s0,-32
    8000479e:	4505                	li	a0,1
    800047a0:	ffffd097          	auipc	ra,0xffffd
    800047a4:	7f4080e7          	jalr	2036(ra) # 80001f94 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800047a8:	fe840613          	addi	a2,s0,-24
    800047ac:	4581                	li	a1,0
    800047ae:	4501                	li	a0,0
    800047b0:	00000097          	auipc	ra,0x0
    800047b4:	c68080e7          	jalr	-920(ra) # 80004418 <argfd>
    800047b8:	87aa                	mv	a5,a0
    return -1;
    800047ba:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047bc:	0007ca63          	bltz	a5,800047d0 <sys_fstat+0x3e>
  return filestat(f, st);
    800047c0:	fe043583          	ld	a1,-32(s0)
    800047c4:	fe843503          	ld	a0,-24(s0)
    800047c8:	fffff097          	auipc	ra,0xfffff
    800047cc:	2f0080e7          	jalr	752(ra) # 80003ab8 <filestat>
}
    800047d0:	60e2                	ld	ra,24(sp)
    800047d2:	6442                	ld	s0,16(sp)
    800047d4:	6105                	addi	sp,sp,32
    800047d6:	8082                	ret

00000000800047d8 <sys_link>:
{
    800047d8:	7169                	addi	sp,sp,-304
    800047da:	f606                	sd	ra,296(sp)
    800047dc:	f222                	sd	s0,288(sp)
    800047de:	ee26                	sd	s1,280(sp)
    800047e0:	ea4a                	sd	s2,272(sp)
    800047e2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047e4:	08000613          	li	a2,128
    800047e8:	ed040593          	addi	a1,s0,-304
    800047ec:	4501                	li	a0,0
    800047ee:	ffffd097          	auipc	ra,0xffffd
    800047f2:	7c6080e7          	jalr	1990(ra) # 80001fb4 <argstr>
    return -1;
    800047f6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047f8:	10054e63          	bltz	a0,80004914 <sys_link+0x13c>
    800047fc:	08000613          	li	a2,128
    80004800:	f5040593          	addi	a1,s0,-176
    80004804:	4505                	li	a0,1
    80004806:	ffffd097          	auipc	ra,0xffffd
    8000480a:	7ae080e7          	jalr	1966(ra) # 80001fb4 <argstr>
    return -1;
    8000480e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004810:	10054263          	bltz	a0,80004914 <sys_link+0x13c>
  begin_op();
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	d10080e7          	jalr	-752(ra) # 80003524 <begin_op>
  if((ip = namei(old)) == 0){
    8000481c:	ed040513          	addi	a0,s0,-304
    80004820:	fffff097          	auipc	ra,0xfffff
    80004824:	ae8080e7          	jalr	-1304(ra) # 80003308 <namei>
    80004828:	84aa                	mv	s1,a0
    8000482a:	c551                	beqz	a0,800048b6 <sys_link+0xde>
  ilock(ip);
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	336080e7          	jalr	822(ra) # 80002b62 <ilock>
  if(ip->type == T_DIR){
    80004834:	04449703          	lh	a4,68(s1)
    80004838:	4785                	li	a5,1
    8000483a:	08f70463          	beq	a4,a5,800048c2 <sys_link+0xea>
  ip->nlink++;
    8000483e:	04a4d783          	lhu	a5,74(s1)
    80004842:	2785                	addiw	a5,a5,1
    80004844:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004848:	8526                	mv	a0,s1
    8000484a:	ffffe097          	auipc	ra,0xffffe
    8000484e:	24e080e7          	jalr	590(ra) # 80002a98 <iupdate>
  iunlock(ip);
    80004852:	8526                	mv	a0,s1
    80004854:	ffffe097          	auipc	ra,0xffffe
    80004858:	3d0080e7          	jalr	976(ra) # 80002c24 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000485c:	fd040593          	addi	a1,s0,-48
    80004860:	f5040513          	addi	a0,s0,-176
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	ac2080e7          	jalr	-1342(ra) # 80003326 <nameiparent>
    8000486c:	892a                	mv	s2,a0
    8000486e:	c935                	beqz	a0,800048e2 <sys_link+0x10a>
  ilock(dp);
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	2f2080e7          	jalr	754(ra) # 80002b62 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004878:	00092703          	lw	a4,0(s2)
    8000487c:	409c                	lw	a5,0(s1)
    8000487e:	04f71d63          	bne	a4,a5,800048d8 <sys_link+0x100>
    80004882:	40d0                	lw	a2,4(s1)
    80004884:	fd040593          	addi	a1,s0,-48
    80004888:	854a                	mv	a0,s2
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	9cc080e7          	jalr	-1588(ra) # 80003256 <dirlink>
    80004892:	04054363          	bltz	a0,800048d8 <sys_link+0x100>
  iunlockput(dp);
    80004896:	854a                	mv	a0,s2
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	52c080e7          	jalr	1324(ra) # 80002dc4 <iunlockput>
  iput(ip);
    800048a0:	8526                	mv	a0,s1
    800048a2:	ffffe097          	auipc	ra,0xffffe
    800048a6:	47a080e7          	jalr	1146(ra) # 80002d1c <iput>
  end_op();
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	cfa080e7          	jalr	-774(ra) # 800035a4 <end_op>
  return 0;
    800048b2:	4781                	li	a5,0
    800048b4:	a085                	j	80004914 <sys_link+0x13c>
    end_op();
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	cee080e7          	jalr	-786(ra) # 800035a4 <end_op>
    return -1;
    800048be:	57fd                	li	a5,-1
    800048c0:	a891                	j	80004914 <sys_link+0x13c>
    iunlockput(ip);
    800048c2:	8526                	mv	a0,s1
    800048c4:	ffffe097          	auipc	ra,0xffffe
    800048c8:	500080e7          	jalr	1280(ra) # 80002dc4 <iunlockput>
    end_op();
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	cd8080e7          	jalr	-808(ra) # 800035a4 <end_op>
    return -1;
    800048d4:	57fd                	li	a5,-1
    800048d6:	a83d                	j	80004914 <sys_link+0x13c>
    iunlockput(dp);
    800048d8:	854a                	mv	a0,s2
    800048da:	ffffe097          	auipc	ra,0xffffe
    800048de:	4ea080e7          	jalr	1258(ra) # 80002dc4 <iunlockput>
  ilock(ip);
    800048e2:	8526                	mv	a0,s1
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	27e080e7          	jalr	638(ra) # 80002b62 <ilock>
  ip->nlink--;
    800048ec:	04a4d783          	lhu	a5,74(s1)
    800048f0:	37fd                	addiw	a5,a5,-1
    800048f2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048f6:	8526                	mv	a0,s1
    800048f8:	ffffe097          	auipc	ra,0xffffe
    800048fc:	1a0080e7          	jalr	416(ra) # 80002a98 <iupdate>
  iunlockput(ip);
    80004900:	8526                	mv	a0,s1
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	4c2080e7          	jalr	1218(ra) # 80002dc4 <iunlockput>
  end_op();
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	c9a080e7          	jalr	-870(ra) # 800035a4 <end_op>
  return -1;
    80004912:	57fd                	li	a5,-1
}
    80004914:	853e                	mv	a0,a5
    80004916:	70b2                	ld	ra,296(sp)
    80004918:	7412                	ld	s0,288(sp)
    8000491a:	64f2                	ld	s1,280(sp)
    8000491c:	6952                	ld	s2,272(sp)
    8000491e:	6155                	addi	sp,sp,304
    80004920:	8082                	ret

0000000080004922 <sys_unlink>:
{
    80004922:	7151                	addi	sp,sp,-240
    80004924:	f586                	sd	ra,232(sp)
    80004926:	f1a2                	sd	s0,224(sp)
    80004928:	eda6                	sd	s1,216(sp)
    8000492a:	e9ca                	sd	s2,208(sp)
    8000492c:	e5ce                	sd	s3,200(sp)
    8000492e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004930:	08000613          	li	a2,128
    80004934:	f3040593          	addi	a1,s0,-208
    80004938:	4501                	li	a0,0
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	67a080e7          	jalr	1658(ra) # 80001fb4 <argstr>
    80004942:	18054163          	bltz	a0,80004ac4 <sys_unlink+0x1a2>
  begin_op();
    80004946:	fffff097          	auipc	ra,0xfffff
    8000494a:	bde080e7          	jalr	-1058(ra) # 80003524 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000494e:	fb040593          	addi	a1,s0,-80
    80004952:	f3040513          	addi	a0,s0,-208
    80004956:	fffff097          	auipc	ra,0xfffff
    8000495a:	9d0080e7          	jalr	-1584(ra) # 80003326 <nameiparent>
    8000495e:	84aa                	mv	s1,a0
    80004960:	c979                	beqz	a0,80004a36 <sys_unlink+0x114>
  ilock(dp);
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	200080e7          	jalr	512(ra) # 80002b62 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000496a:	00004597          	auipc	a1,0x4
    8000496e:	e7658593          	addi	a1,a1,-394 # 800087e0 <syscall_names+0x298>
    80004972:	fb040513          	addi	a0,s0,-80
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	6b6080e7          	jalr	1718(ra) # 8000302c <namecmp>
    8000497e:	14050a63          	beqz	a0,80004ad2 <sys_unlink+0x1b0>
    80004982:	00004597          	auipc	a1,0x4
    80004986:	e6658593          	addi	a1,a1,-410 # 800087e8 <syscall_names+0x2a0>
    8000498a:	fb040513          	addi	a0,s0,-80
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	69e080e7          	jalr	1694(ra) # 8000302c <namecmp>
    80004996:	12050e63          	beqz	a0,80004ad2 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000499a:	f2c40613          	addi	a2,s0,-212
    8000499e:	fb040593          	addi	a1,s0,-80
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	6a2080e7          	jalr	1698(ra) # 80003046 <dirlookup>
    800049ac:	892a                	mv	s2,a0
    800049ae:	12050263          	beqz	a0,80004ad2 <sys_unlink+0x1b0>
  ilock(ip);
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	1b0080e7          	jalr	432(ra) # 80002b62 <ilock>
  if(ip->nlink < 1)
    800049ba:	04a91783          	lh	a5,74(s2)
    800049be:	08f05263          	blez	a5,80004a42 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049c2:	04491703          	lh	a4,68(s2)
    800049c6:	4785                	li	a5,1
    800049c8:	08f70563          	beq	a4,a5,80004a52 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049cc:	4641                	li	a2,16
    800049ce:	4581                	li	a1,0
    800049d0:	fc040513          	addi	a0,s0,-64
    800049d4:	ffffb097          	auipc	ra,0xffffb
    800049d8:	7a4080e7          	jalr	1956(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049dc:	4741                	li	a4,16
    800049de:	f2c42683          	lw	a3,-212(s0)
    800049e2:	fc040613          	addi	a2,s0,-64
    800049e6:	4581                	li	a1,0
    800049e8:	8526                	mv	a0,s1
    800049ea:	ffffe097          	auipc	ra,0xffffe
    800049ee:	524080e7          	jalr	1316(ra) # 80002f0e <writei>
    800049f2:	47c1                	li	a5,16
    800049f4:	0af51563          	bne	a0,a5,80004a9e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049f8:	04491703          	lh	a4,68(s2)
    800049fc:	4785                	li	a5,1
    800049fe:	0af70863          	beq	a4,a5,80004aae <sys_unlink+0x18c>
  iunlockput(dp);
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	3c0080e7          	jalr	960(ra) # 80002dc4 <iunlockput>
  ip->nlink--;
    80004a0c:	04a95783          	lhu	a5,74(s2)
    80004a10:	37fd                	addiw	a5,a5,-1
    80004a12:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a16:	854a                	mv	a0,s2
    80004a18:	ffffe097          	auipc	ra,0xffffe
    80004a1c:	080080e7          	jalr	128(ra) # 80002a98 <iupdate>
  iunlockput(ip);
    80004a20:	854a                	mv	a0,s2
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	3a2080e7          	jalr	930(ra) # 80002dc4 <iunlockput>
  end_op();
    80004a2a:	fffff097          	auipc	ra,0xfffff
    80004a2e:	b7a080e7          	jalr	-1158(ra) # 800035a4 <end_op>
  return 0;
    80004a32:	4501                	li	a0,0
    80004a34:	a84d                	j	80004ae6 <sys_unlink+0x1c4>
    end_op();
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	b6e080e7          	jalr	-1170(ra) # 800035a4 <end_op>
    return -1;
    80004a3e:	557d                	li	a0,-1
    80004a40:	a05d                	j	80004ae6 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a42:	00004517          	auipc	a0,0x4
    80004a46:	dae50513          	addi	a0,a0,-594 # 800087f0 <syscall_names+0x2a8>
    80004a4a:	00001097          	auipc	ra,0x1
    80004a4e:	218080e7          	jalr	536(ra) # 80005c62 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a52:	04c92703          	lw	a4,76(s2)
    80004a56:	02000793          	li	a5,32
    80004a5a:	f6e7f9e3          	bgeu	a5,a4,800049cc <sys_unlink+0xaa>
    80004a5e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a62:	4741                	li	a4,16
    80004a64:	86ce                	mv	a3,s3
    80004a66:	f1840613          	addi	a2,s0,-232
    80004a6a:	4581                	li	a1,0
    80004a6c:	854a                	mv	a0,s2
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	3a8080e7          	jalr	936(ra) # 80002e16 <readi>
    80004a76:	47c1                	li	a5,16
    80004a78:	00f51b63          	bne	a0,a5,80004a8e <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a7c:	f1845783          	lhu	a5,-232(s0)
    80004a80:	e7a1                	bnez	a5,80004ac8 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a82:	29c1                	addiw	s3,s3,16
    80004a84:	04c92783          	lw	a5,76(s2)
    80004a88:	fcf9ede3          	bltu	s3,a5,80004a62 <sys_unlink+0x140>
    80004a8c:	b781                	j	800049cc <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a8e:	00004517          	auipc	a0,0x4
    80004a92:	d7a50513          	addi	a0,a0,-646 # 80008808 <syscall_names+0x2c0>
    80004a96:	00001097          	auipc	ra,0x1
    80004a9a:	1cc080e7          	jalr	460(ra) # 80005c62 <panic>
    panic("unlink: writei");
    80004a9e:	00004517          	auipc	a0,0x4
    80004aa2:	d8250513          	addi	a0,a0,-638 # 80008820 <syscall_names+0x2d8>
    80004aa6:	00001097          	auipc	ra,0x1
    80004aaa:	1bc080e7          	jalr	444(ra) # 80005c62 <panic>
    dp->nlink--;
    80004aae:	04a4d783          	lhu	a5,74(s1)
    80004ab2:	37fd                	addiw	a5,a5,-1
    80004ab4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ab8:	8526                	mv	a0,s1
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	fde080e7          	jalr	-34(ra) # 80002a98 <iupdate>
    80004ac2:	b781                	j	80004a02 <sys_unlink+0xe0>
    return -1;
    80004ac4:	557d                	li	a0,-1
    80004ac6:	a005                	j	80004ae6 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ac8:	854a                	mv	a0,s2
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	2fa080e7          	jalr	762(ra) # 80002dc4 <iunlockput>
  iunlockput(dp);
    80004ad2:	8526                	mv	a0,s1
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	2f0080e7          	jalr	752(ra) # 80002dc4 <iunlockput>
  end_op();
    80004adc:	fffff097          	auipc	ra,0xfffff
    80004ae0:	ac8080e7          	jalr	-1336(ra) # 800035a4 <end_op>
  return -1;
    80004ae4:	557d                	li	a0,-1
}
    80004ae6:	70ae                	ld	ra,232(sp)
    80004ae8:	740e                	ld	s0,224(sp)
    80004aea:	64ee                	ld	s1,216(sp)
    80004aec:	694e                	ld	s2,208(sp)
    80004aee:	69ae                	ld	s3,200(sp)
    80004af0:	616d                	addi	sp,sp,240
    80004af2:	8082                	ret

0000000080004af4 <sys_open>:

uint64
sys_open(void)
{
    80004af4:	7131                	addi	sp,sp,-192
    80004af6:	fd06                	sd	ra,184(sp)
    80004af8:	f922                	sd	s0,176(sp)
    80004afa:	f526                	sd	s1,168(sp)
    80004afc:	f14a                	sd	s2,160(sp)
    80004afe:	ed4e                	sd	s3,152(sp)
    80004b00:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b02:	f4c40593          	addi	a1,s0,-180
    80004b06:	4505                	li	a0,1
    80004b08:	ffffd097          	auipc	ra,0xffffd
    80004b0c:	46c080e7          	jalr	1132(ra) # 80001f74 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b10:	08000613          	li	a2,128
    80004b14:	f5040593          	addi	a1,s0,-176
    80004b18:	4501                	li	a0,0
    80004b1a:	ffffd097          	auipc	ra,0xffffd
    80004b1e:	49a080e7          	jalr	1178(ra) # 80001fb4 <argstr>
    80004b22:	87aa                	mv	a5,a0
    return -1;
    80004b24:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b26:	0a07c963          	bltz	a5,80004bd8 <sys_open+0xe4>

  begin_op();
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	9fa080e7          	jalr	-1542(ra) # 80003524 <begin_op>

  if(omode & O_CREATE){
    80004b32:	f4c42783          	lw	a5,-180(s0)
    80004b36:	2007f793          	andi	a5,a5,512
    80004b3a:	cfc5                	beqz	a5,80004bf2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b3c:	4681                	li	a3,0
    80004b3e:	4601                	li	a2,0
    80004b40:	4589                	li	a1,2
    80004b42:	f5040513          	addi	a0,s0,-176
    80004b46:	00000097          	auipc	ra,0x0
    80004b4a:	974080e7          	jalr	-1676(ra) # 800044ba <create>
    80004b4e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004b50:	c959                	beqz	a0,80004be6 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b52:	04449703          	lh	a4,68(s1)
    80004b56:	478d                	li	a5,3
    80004b58:	00f71763          	bne	a4,a5,80004b66 <sys_open+0x72>
    80004b5c:	0464d703          	lhu	a4,70(s1)
    80004b60:	47a5                	li	a5,9
    80004b62:	0ce7ed63          	bltu	a5,a4,80004c3c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	dce080e7          	jalr	-562(ra) # 80003934 <filealloc>
    80004b6e:	89aa                	mv	s3,a0
    80004b70:	10050363          	beqz	a0,80004c76 <sys_open+0x182>
    80004b74:	00000097          	auipc	ra,0x0
    80004b78:	904080e7          	jalr	-1788(ra) # 80004478 <fdalloc>
    80004b7c:	892a                	mv	s2,a0
    80004b7e:	0e054763          	bltz	a0,80004c6c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b82:	04449703          	lh	a4,68(s1)
    80004b86:	478d                	li	a5,3
    80004b88:	0cf70563          	beq	a4,a5,80004c52 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b8c:	4789                	li	a5,2
    80004b8e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b92:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b96:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b9a:	f4c42783          	lw	a5,-180(s0)
    80004b9e:	0017c713          	xori	a4,a5,1
    80004ba2:	8b05                	andi	a4,a4,1
    80004ba4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ba8:	0037f713          	andi	a4,a5,3
    80004bac:	00e03733          	snez	a4,a4
    80004bb0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bb4:	4007f793          	andi	a5,a5,1024
    80004bb8:	c791                	beqz	a5,80004bc4 <sys_open+0xd0>
    80004bba:	04449703          	lh	a4,68(s1)
    80004bbe:	4789                	li	a5,2
    80004bc0:	0af70063          	beq	a4,a5,80004c60 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bc4:	8526                	mv	a0,s1
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	05e080e7          	jalr	94(ra) # 80002c24 <iunlock>
  end_op();
    80004bce:	fffff097          	auipc	ra,0xfffff
    80004bd2:	9d6080e7          	jalr	-1578(ra) # 800035a4 <end_op>

  return fd;
    80004bd6:	854a                	mv	a0,s2
}
    80004bd8:	70ea                	ld	ra,184(sp)
    80004bda:	744a                	ld	s0,176(sp)
    80004bdc:	74aa                	ld	s1,168(sp)
    80004bde:	790a                	ld	s2,160(sp)
    80004be0:	69ea                	ld	s3,152(sp)
    80004be2:	6129                	addi	sp,sp,192
    80004be4:	8082                	ret
      end_op();
    80004be6:	fffff097          	auipc	ra,0xfffff
    80004bea:	9be080e7          	jalr	-1602(ra) # 800035a4 <end_op>
      return -1;
    80004bee:	557d                	li	a0,-1
    80004bf0:	b7e5                	j	80004bd8 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bf2:	f5040513          	addi	a0,s0,-176
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	712080e7          	jalr	1810(ra) # 80003308 <namei>
    80004bfe:	84aa                	mv	s1,a0
    80004c00:	c905                	beqz	a0,80004c30 <sys_open+0x13c>
    ilock(ip);
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	f60080e7          	jalr	-160(ra) # 80002b62 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c0a:	04449703          	lh	a4,68(s1)
    80004c0e:	4785                	li	a5,1
    80004c10:	f4f711e3          	bne	a4,a5,80004b52 <sys_open+0x5e>
    80004c14:	f4c42783          	lw	a5,-180(s0)
    80004c18:	d7b9                	beqz	a5,80004b66 <sys_open+0x72>
      iunlockput(ip);
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	1a8080e7          	jalr	424(ra) # 80002dc4 <iunlockput>
      end_op();
    80004c24:	fffff097          	auipc	ra,0xfffff
    80004c28:	980080e7          	jalr	-1664(ra) # 800035a4 <end_op>
      return -1;
    80004c2c:	557d                	li	a0,-1
    80004c2e:	b76d                	j	80004bd8 <sys_open+0xe4>
      end_op();
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	974080e7          	jalr	-1676(ra) # 800035a4 <end_op>
      return -1;
    80004c38:	557d                	li	a0,-1
    80004c3a:	bf79                	j	80004bd8 <sys_open+0xe4>
    iunlockput(ip);
    80004c3c:	8526                	mv	a0,s1
    80004c3e:	ffffe097          	auipc	ra,0xffffe
    80004c42:	186080e7          	jalr	390(ra) # 80002dc4 <iunlockput>
    end_op();
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	95e080e7          	jalr	-1698(ra) # 800035a4 <end_op>
    return -1;
    80004c4e:	557d                	li	a0,-1
    80004c50:	b761                	j	80004bd8 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c52:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c56:	04649783          	lh	a5,70(s1)
    80004c5a:	02f99223          	sh	a5,36(s3)
    80004c5e:	bf25                	j	80004b96 <sys_open+0xa2>
    itrunc(ip);
    80004c60:	8526                	mv	a0,s1
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	00e080e7          	jalr	14(ra) # 80002c70 <itrunc>
    80004c6a:	bfa9                	j	80004bc4 <sys_open+0xd0>
      fileclose(f);
    80004c6c:	854e                	mv	a0,s3
    80004c6e:	fffff097          	auipc	ra,0xfffff
    80004c72:	d82080e7          	jalr	-638(ra) # 800039f0 <fileclose>
    iunlockput(ip);
    80004c76:	8526                	mv	a0,s1
    80004c78:	ffffe097          	auipc	ra,0xffffe
    80004c7c:	14c080e7          	jalr	332(ra) # 80002dc4 <iunlockput>
    end_op();
    80004c80:	fffff097          	auipc	ra,0xfffff
    80004c84:	924080e7          	jalr	-1756(ra) # 800035a4 <end_op>
    return -1;
    80004c88:	557d                	li	a0,-1
    80004c8a:	b7b9                	j	80004bd8 <sys_open+0xe4>

0000000080004c8c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c8c:	7175                	addi	sp,sp,-144
    80004c8e:	e506                	sd	ra,136(sp)
    80004c90:	e122                	sd	s0,128(sp)
    80004c92:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c94:	fffff097          	auipc	ra,0xfffff
    80004c98:	890080e7          	jalr	-1904(ra) # 80003524 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c9c:	08000613          	li	a2,128
    80004ca0:	f7040593          	addi	a1,s0,-144
    80004ca4:	4501                	li	a0,0
    80004ca6:	ffffd097          	auipc	ra,0xffffd
    80004caa:	30e080e7          	jalr	782(ra) # 80001fb4 <argstr>
    80004cae:	02054963          	bltz	a0,80004ce0 <sys_mkdir+0x54>
    80004cb2:	4681                	li	a3,0
    80004cb4:	4601                	li	a2,0
    80004cb6:	4585                	li	a1,1
    80004cb8:	f7040513          	addi	a0,s0,-144
    80004cbc:	fffff097          	auipc	ra,0xfffff
    80004cc0:	7fe080e7          	jalr	2046(ra) # 800044ba <create>
    80004cc4:	cd11                	beqz	a0,80004ce0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004cc6:	ffffe097          	auipc	ra,0xffffe
    80004cca:	0fe080e7          	jalr	254(ra) # 80002dc4 <iunlockput>
  end_op();
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	8d6080e7          	jalr	-1834(ra) # 800035a4 <end_op>
  return 0;
    80004cd6:	4501                	li	a0,0
}
    80004cd8:	60aa                	ld	ra,136(sp)
    80004cda:	640a                	ld	s0,128(sp)
    80004cdc:	6149                	addi	sp,sp,144
    80004cde:	8082                	ret
    end_op();
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	8c4080e7          	jalr	-1852(ra) # 800035a4 <end_op>
    return -1;
    80004ce8:	557d                	li	a0,-1
    80004cea:	b7fd                	j	80004cd8 <sys_mkdir+0x4c>

0000000080004cec <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cec:	7135                	addi	sp,sp,-160
    80004cee:	ed06                	sd	ra,152(sp)
    80004cf0:	e922                	sd	s0,144(sp)
    80004cf2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	830080e7          	jalr	-2000(ra) # 80003524 <begin_op>
  argint(1, &major);
    80004cfc:	f6c40593          	addi	a1,s0,-148
    80004d00:	4505                	li	a0,1
    80004d02:	ffffd097          	auipc	ra,0xffffd
    80004d06:	272080e7          	jalr	626(ra) # 80001f74 <argint>
  argint(2, &minor);
    80004d0a:	f6840593          	addi	a1,s0,-152
    80004d0e:	4509                	li	a0,2
    80004d10:	ffffd097          	auipc	ra,0xffffd
    80004d14:	264080e7          	jalr	612(ra) # 80001f74 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d18:	08000613          	li	a2,128
    80004d1c:	f7040593          	addi	a1,s0,-144
    80004d20:	4501                	li	a0,0
    80004d22:	ffffd097          	auipc	ra,0xffffd
    80004d26:	292080e7          	jalr	658(ra) # 80001fb4 <argstr>
    80004d2a:	02054b63          	bltz	a0,80004d60 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d2e:	f6841683          	lh	a3,-152(s0)
    80004d32:	f6c41603          	lh	a2,-148(s0)
    80004d36:	458d                	li	a1,3
    80004d38:	f7040513          	addi	a0,s0,-144
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	77e080e7          	jalr	1918(ra) # 800044ba <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d44:	cd11                	beqz	a0,80004d60 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d46:	ffffe097          	auipc	ra,0xffffe
    80004d4a:	07e080e7          	jalr	126(ra) # 80002dc4 <iunlockput>
  end_op();
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	856080e7          	jalr	-1962(ra) # 800035a4 <end_op>
  return 0;
    80004d56:	4501                	li	a0,0
}
    80004d58:	60ea                	ld	ra,152(sp)
    80004d5a:	644a                	ld	s0,144(sp)
    80004d5c:	610d                	addi	sp,sp,160
    80004d5e:	8082                	ret
    end_op();
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	844080e7          	jalr	-1980(ra) # 800035a4 <end_op>
    return -1;
    80004d68:	557d                	li	a0,-1
    80004d6a:	b7fd                	j	80004d58 <sys_mknod+0x6c>

0000000080004d6c <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d6c:	7135                	addi	sp,sp,-160
    80004d6e:	ed06                	sd	ra,152(sp)
    80004d70:	e922                	sd	s0,144(sp)
    80004d72:	e526                	sd	s1,136(sp)
    80004d74:	e14a                	sd	s2,128(sp)
    80004d76:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d78:	ffffc097          	auipc	ra,0xffffc
    80004d7c:	0e0080e7          	jalr	224(ra) # 80000e58 <myproc>
    80004d80:	892a                	mv	s2,a0
  
  begin_op();
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	7a2080e7          	jalr	1954(ra) # 80003524 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d8a:	08000613          	li	a2,128
    80004d8e:	f6040593          	addi	a1,s0,-160
    80004d92:	4501                	li	a0,0
    80004d94:	ffffd097          	auipc	ra,0xffffd
    80004d98:	220080e7          	jalr	544(ra) # 80001fb4 <argstr>
    80004d9c:	04054b63          	bltz	a0,80004df2 <sys_chdir+0x86>
    80004da0:	f6040513          	addi	a0,s0,-160
    80004da4:	ffffe097          	auipc	ra,0xffffe
    80004da8:	564080e7          	jalr	1380(ra) # 80003308 <namei>
    80004dac:	84aa                	mv	s1,a0
    80004dae:	c131                	beqz	a0,80004df2 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	db2080e7          	jalr	-590(ra) # 80002b62 <ilock>
  if(ip->type != T_DIR){
    80004db8:	04449703          	lh	a4,68(s1)
    80004dbc:	4785                	li	a5,1
    80004dbe:	04f71063          	bne	a4,a5,80004dfe <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dc2:	8526                	mv	a0,s1
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	e60080e7          	jalr	-416(ra) # 80002c24 <iunlock>
  iput(p->cwd);
    80004dcc:	15093503          	ld	a0,336(s2)
    80004dd0:	ffffe097          	auipc	ra,0xffffe
    80004dd4:	f4c080e7          	jalr	-180(ra) # 80002d1c <iput>
  end_op();
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	7cc080e7          	jalr	1996(ra) # 800035a4 <end_op>
  p->cwd = ip;
    80004de0:	14993823          	sd	s1,336(s2)
  return 0;
    80004de4:	4501                	li	a0,0
}
    80004de6:	60ea                	ld	ra,152(sp)
    80004de8:	644a                	ld	s0,144(sp)
    80004dea:	64aa                	ld	s1,136(sp)
    80004dec:	690a                	ld	s2,128(sp)
    80004dee:	610d                	addi	sp,sp,160
    80004df0:	8082                	ret
    end_op();
    80004df2:	ffffe097          	auipc	ra,0xffffe
    80004df6:	7b2080e7          	jalr	1970(ra) # 800035a4 <end_op>
    return -1;
    80004dfa:	557d                	li	a0,-1
    80004dfc:	b7ed                	j	80004de6 <sys_chdir+0x7a>
    iunlockput(ip);
    80004dfe:	8526                	mv	a0,s1
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	fc4080e7          	jalr	-60(ra) # 80002dc4 <iunlockput>
    end_op();
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	79c080e7          	jalr	1948(ra) # 800035a4 <end_op>
    return -1;
    80004e10:	557d                	li	a0,-1
    80004e12:	bfd1                	j	80004de6 <sys_chdir+0x7a>

0000000080004e14 <sys_exec>:

uint64
sys_exec(void)
{
    80004e14:	7145                	addi	sp,sp,-464
    80004e16:	e786                	sd	ra,456(sp)
    80004e18:	e3a2                	sd	s0,448(sp)
    80004e1a:	ff26                	sd	s1,440(sp)
    80004e1c:	fb4a                	sd	s2,432(sp)
    80004e1e:	f74e                	sd	s3,424(sp)
    80004e20:	f352                	sd	s4,416(sp)
    80004e22:	ef56                	sd	s5,408(sp)
    80004e24:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e26:	e3840593          	addi	a1,s0,-456
    80004e2a:	4505                	li	a0,1
    80004e2c:	ffffd097          	auipc	ra,0xffffd
    80004e30:	168080e7          	jalr	360(ra) # 80001f94 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004e34:	08000613          	li	a2,128
    80004e38:	f4040593          	addi	a1,s0,-192
    80004e3c:	4501                	li	a0,0
    80004e3e:	ffffd097          	auipc	ra,0xffffd
    80004e42:	176080e7          	jalr	374(ra) # 80001fb4 <argstr>
    80004e46:	87aa                	mv	a5,a0
    return -1;
    80004e48:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004e4a:	0c07c263          	bltz	a5,80004f0e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e4e:	10000613          	li	a2,256
    80004e52:	4581                	li	a1,0
    80004e54:	e4040513          	addi	a0,s0,-448
    80004e58:	ffffb097          	auipc	ra,0xffffb
    80004e5c:	320080e7          	jalr	800(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e60:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e64:	89a6                	mv	s3,s1
    80004e66:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e68:	02000a13          	li	s4,32
    80004e6c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e70:	00391513          	slli	a0,s2,0x3
    80004e74:	e3040593          	addi	a1,s0,-464
    80004e78:	e3843783          	ld	a5,-456(s0)
    80004e7c:	953e                	add	a0,a0,a5
    80004e7e:	ffffd097          	auipc	ra,0xffffd
    80004e82:	058080e7          	jalr	88(ra) # 80001ed6 <fetchaddr>
    80004e86:	02054a63          	bltz	a0,80004eba <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004e8a:	e3043783          	ld	a5,-464(s0)
    80004e8e:	c3b9                	beqz	a5,80004ed4 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e90:	ffffb097          	auipc	ra,0xffffb
    80004e94:	288080e7          	jalr	648(ra) # 80000118 <kalloc>
    80004e98:	85aa                	mv	a1,a0
    80004e9a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e9e:	cd11                	beqz	a0,80004eba <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ea0:	6605                	lui	a2,0x1
    80004ea2:	e3043503          	ld	a0,-464(s0)
    80004ea6:	ffffd097          	auipc	ra,0xffffd
    80004eaa:	082080e7          	jalr	130(ra) # 80001f28 <fetchstr>
    80004eae:	00054663          	bltz	a0,80004eba <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004eb2:	0905                	addi	s2,s2,1
    80004eb4:	09a1                	addi	s3,s3,8
    80004eb6:	fb491be3          	bne	s2,s4,80004e6c <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eba:	10048913          	addi	s2,s1,256
    80004ebe:	6088                	ld	a0,0(s1)
    80004ec0:	c531                	beqz	a0,80004f0c <sys_exec+0xf8>
    kfree(argv[i]);
    80004ec2:	ffffb097          	auipc	ra,0xffffb
    80004ec6:	15a080e7          	jalr	346(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eca:	04a1                	addi	s1,s1,8
    80004ecc:	ff2499e3          	bne	s1,s2,80004ebe <sys_exec+0xaa>
  return -1;
    80004ed0:	557d                	li	a0,-1
    80004ed2:	a835                	j	80004f0e <sys_exec+0xfa>
      argv[i] = 0;
    80004ed4:	0a8e                	slli	s5,s5,0x3
    80004ed6:	fc040793          	addi	a5,s0,-64
    80004eda:	9abe                	add	s5,s5,a5
    80004edc:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ee0:	e4040593          	addi	a1,s0,-448
    80004ee4:	f4040513          	addi	a0,s0,-192
    80004ee8:	fffff097          	auipc	ra,0xfffff
    80004eec:	190080e7          	jalr	400(ra) # 80004078 <exec>
    80004ef0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef2:	10048993          	addi	s3,s1,256
    80004ef6:	6088                	ld	a0,0(s1)
    80004ef8:	c901                	beqz	a0,80004f08 <sys_exec+0xf4>
    kfree(argv[i]);
    80004efa:	ffffb097          	auipc	ra,0xffffb
    80004efe:	122080e7          	jalr	290(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f02:	04a1                	addi	s1,s1,8
    80004f04:	ff3499e3          	bne	s1,s3,80004ef6 <sys_exec+0xe2>
  return ret;
    80004f08:	854a                	mv	a0,s2
    80004f0a:	a011                	j	80004f0e <sys_exec+0xfa>
  return -1;
    80004f0c:	557d                	li	a0,-1
}
    80004f0e:	60be                	ld	ra,456(sp)
    80004f10:	641e                	ld	s0,448(sp)
    80004f12:	74fa                	ld	s1,440(sp)
    80004f14:	795a                	ld	s2,432(sp)
    80004f16:	79ba                	ld	s3,424(sp)
    80004f18:	7a1a                	ld	s4,416(sp)
    80004f1a:	6afa                	ld	s5,408(sp)
    80004f1c:	6179                	addi	sp,sp,464
    80004f1e:	8082                	ret

0000000080004f20 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f20:	7139                	addi	sp,sp,-64
    80004f22:	fc06                	sd	ra,56(sp)
    80004f24:	f822                	sd	s0,48(sp)
    80004f26:	f426                	sd	s1,40(sp)
    80004f28:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f2a:	ffffc097          	auipc	ra,0xffffc
    80004f2e:	f2e080e7          	jalr	-210(ra) # 80000e58 <myproc>
    80004f32:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f34:	fd840593          	addi	a1,s0,-40
    80004f38:	4501                	li	a0,0
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	05a080e7          	jalr	90(ra) # 80001f94 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004f42:	fc840593          	addi	a1,s0,-56
    80004f46:	fd040513          	addi	a0,s0,-48
    80004f4a:	fffff097          	auipc	ra,0xfffff
    80004f4e:	dd6080e7          	jalr	-554(ra) # 80003d20 <pipealloc>
    return -1;
    80004f52:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f54:	0c054463          	bltz	a0,8000501c <sys_pipe+0xfc>
  fd0 = -1;
    80004f58:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f5c:	fd043503          	ld	a0,-48(s0)
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	518080e7          	jalr	1304(ra) # 80004478 <fdalloc>
    80004f68:	fca42223          	sw	a0,-60(s0)
    80004f6c:	08054b63          	bltz	a0,80005002 <sys_pipe+0xe2>
    80004f70:	fc843503          	ld	a0,-56(s0)
    80004f74:	fffff097          	auipc	ra,0xfffff
    80004f78:	504080e7          	jalr	1284(ra) # 80004478 <fdalloc>
    80004f7c:	fca42023          	sw	a0,-64(s0)
    80004f80:	06054863          	bltz	a0,80004ff0 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f84:	4691                	li	a3,4
    80004f86:	fc440613          	addi	a2,s0,-60
    80004f8a:	fd843583          	ld	a1,-40(s0)
    80004f8e:	68a8                	ld	a0,80(s1)
    80004f90:	ffffc097          	auipc	ra,0xffffc
    80004f94:	b86080e7          	jalr	-1146(ra) # 80000b16 <copyout>
    80004f98:	02054063          	bltz	a0,80004fb8 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f9c:	4691                	li	a3,4
    80004f9e:	fc040613          	addi	a2,s0,-64
    80004fa2:	fd843583          	ld	a1,-40(s0)
    80004fa6:	0591                	addi	a1,a1,4
    80004fa8:	68a8                	ld	a0,80(s1)
    80004faa:	ffffc097          	auipc	ra,0xffffc
    80004fae:	b6c080e7          	jalr	-1172(ra) # 80000b16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fb2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fb4:	06055463          	bgez	a0,8000501c <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80004fb8:	fc442783          	lw	a5,-60(s0)
    80004fbc:	07e9                	addi	a5,a5,26
    80004fbe:	078e                	slli	a5,a5,0x3
    80004fc0:	97a6                	add	a5,a5,s1
    80004fc2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fc6:	fc042503          	lw	a0,-64(s0)
    80004fca:	0569                	addi	a0,a0,26
    80004fcc:	050e                	slli	a0,a0,0x3
    80004fce:	94aa                	add	s1,s1,a0
    80004fd0:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004fd4:	fd043503          	ld	a0,-48(s0)
    80004fd8:	fffff097          	auipc	ra,0xfffff
    80004fdc:	a18080e7          	jalr	-1512(ra) # 800039f0 <fileclose>
    fileclose(wf);
    80004fe0:	fc843503          	ld	a0,-56(s0)
    80004fe4:	fffff097          	auipc	ra,0xfffff
    80004fe8:	a0c080e7          	jalr	-1524(ra) # 800039f0 <fileclose>
    return -1;
    80004fec:	57fd                	li	a5,-1
    80004fee:	a03d                	j	8000501c <sys_pipe+0xfc>
    if(fd0 >= 0)
    80004ff0:	fc442783          	lw	a5,-60(s0)
    80004ff4:	0007c763          	bltz	a5,80005002 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80004ff8:	07e9                	addi	a5,a5,26
    80004ffa:	078e                	slli	a5,a5,0x3
    80004ffc:	94be                	add	s1,s1,a5
    80004ffe:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005002:	fd043503          	ld	a0,-48(s0)
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	9ea080e7          	jalr	-1558(ra) # 800039f0 <fileclose>
    fileclose(wf);
    8000500e:	fc843503          	ld	a0,-56(s0)
    80005012:	fffff097          	auipc	ra,0xfffff
    80005016:	9de080e7          	jalr	-1570(ra) # 800039f0 <fileclose>
    return -1;
    8000501a:	57fd                	li	a5,-1
}
    8000501c:	853e                	mv	a0,a5
    8000501e:	70e2                	ld	ra,56(sp)
    80005020:	7442                	ld	s0,48(sp)
    80005022:	74a2                	ld	s1,40(sp)
    80005024:	6121                	addi	sp,sp,64
    80005026:	8082                	ret
	...

0000000080005030 <kernelvec>:
    80005030:	7111                	addi	sp,sp,-256
    80005032:	e006                	sd	ra,0(sp)
    80005034:	e40a                	sd	sp,8(sp)
    80005036:	e80e                	sd	gp,16(sp)
    80005038:	ec12                	sd	tp,24(sp)
    8000503a:	f016                	sd	t0,32(sp)
    8000503c:	f41a                	sd	t1,40(sp)
    8000503e:	f81e                	sd	t2,48(sp)
    80005040:	fc22                	sd	s0,56(sp)
    80005042:	e0a6                	sd	s1,64(sp)
    80005044:	e4aa                	sd	a0,72(sp)
    80005046:	e8ae                	sd	a1,80(sp)
    80005048:	ecb2                	sd	a2,88(sp)
    8000504a:	f0b6                	sd	a3,96(sp)
    8000504c:	f4ba                	sd	a4,104(sp)
    8000504e:	f8be                	sd	a5,112(sp)
    80005050:	fcc2                	sd	a6,120(sp)
    80005052:	e146                	sd	a7,128(sp)
    80005054:	e54a                	sd	s2,136(sp)
    80005056:	e94e                	sd	s3,144(sp)
    80005058:	ed52                	sd	s4,152(sp)
    8000505a:	f156                	sd	s5,160(sp)
    8000505c:	f55a                	sd	s6,168(sp)
    8000505e:	f95e                	sd	s7,176(sp)
    80005060:	fd62                	sd	s8,184(sp)
    80005062:	e1e6                	sd	s9,192(sp)
    80005064:	e5ea                	sd	s10,200(sp)
    80005066:	e9ee                	sd	s11,208(sp)
    80005068:	edf2                	sd	t3,216(sp)
    8000506a:	f1f6                	sd	t4,224(sp)
    8000506c:	f5fa                	sd	t5,232(sp)
    8000506e:	f9fe                	sd	t6,240(sp)
    80005070:	d33fc0ef          	jal	ra,80001da2 <kerneltrap>
    80005074:	6082                	ld	ra,0(sp)
    80005076:	6122                	ld	sp,8(sp)
    80005078:	61c2                	ld	gp,16(sp)
    8000507a:	7282                	ld	t0,32(sp)
    8000507c:	7322                	ld	t1,40(sp)
    8000507e:	73c2                	ld	t2,48(sp)
    80005080:	7462                	ld	s0,56(sp)
    80005082:	6486                	ld	s1,64(sp)
    80005084:	6526                	ld	a0,72(sp)
    80005086:	65c6                	ld	a1,80(sp)
    80005088:	6666                	ld	a2,88(sp)
    8000508a:	7686                	ld	a3,96(sp)
    8000508c:	7726                	ld	a4,104(sp)
    8000508e:	77c6                	ld	a5,112(sp)
    80005090:	7866                	ld	a6,120(sp)
    80005092:	688a                	ld	a7,128(sp)
    80005094:	692a                	ld	s2,136(sp)
    80005096:	69ca                	ld	s3,144(sp)
    80005098:	6a6a                	ld	s4,152(sp)
    8000509a:	7a8a                	ld	s5,160(sp)
    8000509c:	7b2a                	ld	s6,168(sp)
    8000509e:	7bca                	ld	s7,176(sp)
    800050a0:	7c6a                	ld	s8,184(sp)
    800050a2:	6c8e                	ld	s9,192(sp)
    800050a4:	6d2e                	ld	s10,200(sp)
    800050a6:	6dce                	ld	s11,208(sp)
    800050a8:	6e6e                	ld	t3,216(sp)
    800050aa:	7e8e                	ld	t4,224(sp)
    800050ac:	7f2e                	ld	t5,232(sp)
    800050ae:	7fce                	ld	t6,240(sp)
    800050b0:	6111                	addi	sp,sp,256
    800050b2:	10200073          	sret
    800050b6:	00000013          	nop
    800050ba:	00000013          	nop
    800050be:	0001                	nop

00000000800050c0 <timervec>:
    800050c0:	34051573          	csrrw	a0,mscratch,a0
    800050c4:	e10c                	sd	a1,0(a0)
    800050c6:	e510                	sd	a2,8(a0)
    800050c8:	e914                	sd	a3,16(a0)
    800050ca:	6d0c                	ld	a1,24(a0)
    800050cc:	7110                	ld	a2,32(a0)
    800050ce:	6194                	ld	a3,0(a1)
    800050d0:	96b2                	add	a3,a3,a2
    800050d2:	e194                	sd	a3,0(a1)
    800050d4:	4589                	li	a1,2
    800050d6:	14459073          	csrw	sip,a1
    800050da:	6914                	ld	a3,16(a0)
    800050dc:	6510                	ld	a2,8(a0)
    800050de:	610c                	ld	a1,0(a0)
    800050e0:	34051573          	csrrw	a0,mscratch,a0
    800050e4:	30200073          	mret
	...

00000000800050ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050ea:	1141                	addi	sp,sp,-16
    800050ec:	e422                	sd	s0,8(sp)
    800050ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050f0:	0c0007b7          	lui	a5,0xc000
    800050f4:	4705                	li	a4,1
    800050f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050f8:	c3d8                	sw	a4,4(a5)
}
    800050fa:	6422                	ld	s0,8(sp)
    800050fc:	0141                	addi	sp,sp,16
    800050fe:	8082                	ret

0000000080005100 <plicinithart>:

void
plicinithart(void)
{
    80005100:	1141                	addi	sp,sp,-16
    80005102:	e406                	sd	ra,8(sp)
    80005104:	e022                	sd	s0,0(sp)
    80005106:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005108:	ffffc097          	auipc	ra,0xffffc
    8000510c:	d24080e7          	jalr	-732(ra) # 80000e2c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005110:	0085171b          	slliw	a4,a0,0x8
    80005114:	0c0027b7          	lui	a5,0xc002
    80005118:	97ba                	add	a5,a5,a4
    8000511a:	40200713          	li	a4,1026
    8000511e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005122:	00d5151b          	slliw	a0,a0,0xd
    80005126:	0c2017b7          	lui	a5,0xc201
    8000512a:	953e                	add	a0,a0,a5
    8000512c:	00052023          	sw	zero,0(a0)
}
    80005130:	60a2                	ld	ra,8(sp)
    80005132:	6402                	ld	s0,0(sp)
    80005134:	0141                	addi	sp,sp,16
    80005136:	8082                	ret

0000000080005138 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005138:	1141                	addi	sp,sp,-16
    8000513a:	e406                	sd	ra,8(sp)
    8000513c:	e022                	sd	s0,0(sp)
    8000513e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005140:	ffffc097          	auipc	ra,0xffffc
    80005144:	cec080e7          	jalr	-788(ra) # 80000e2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005148:	00d5179b          	slliw	a5,a0,0xd
    8000514c:	0c201537          	lui	a0,0xc201
    80005150:	953e                	add	a0,a0,a5
  return irq;
}
    80005152:	4148                	lw	a0,4(a0)
    80005154:	60a2                	ld	ra,8(sp)
    80005156:	6402                	ld	s0,0(sp)
    80005158:	0141                	addi	sp,sp,16
    8000515a:	8082                	ret

000000008000515c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000515c:	1101                	addi	sp,sp,-32
    8000515e:	ec06                	sd	ra,24(sp)
    80005160:	e822                	sd	s0,16(sp)
    80005162:	e426                	sd	s1,8(sp)
    80005164:	1000                	addi	s0,sp,32
    80005166:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	cc4080e7          	jalr	-828(ra) # 80000e2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005170:	00d5151b          	slliw	a0,a0,0xd
    80005174:	0c2017b7          	lui	a5,0xc201
    80005178:	97aa                	add	a5,a5,a0
    8000517a:	c3c4                	sw	s1,4(a5)
}
    8000517c:	60e2                	ld	ra,24(sp)
    8000517e:	6442                	ld	s0,16(sp)
    80005180:	64a2                	ld	s1,8(sp)
    80005182:	6105                	addi	sp,sp,32
    80005184:	8082                	ret

0000000080005186 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005186:	1141                	addi	sp,sp,-16
    80005188:	e406                	sd	ra,8(sp)
    8000518a:	e022                	sd	s0,0(sp)
    8000518c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000518e:	479d                	li	a5,7
    80005190:	04a7cc63          	blt	a5,a0,800051e8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005194:	00015797          	auipc	a5,0x15
    80005198:	bac78793          	addi	a5,a5,-1108 # 80019d40 <disk>
    8000519c:	97aa                	add	a5,a5,a0
    8000519e:	0187c783          	lbu	a5,24(a5)
    800051a2:	ebb9                	bnez	a5,800051f8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051a4:	00451613          	slli	a2,a0,0x4
    800051a8:	00015797          	auipc	a5,0x15
    800051ac:	b9878793          	addi	a5,a5,-1128 # 80019d40 <disk>
    800051b0:	6394                	ld	a3,0(a5)
    800051b2:	96b2                	add	a3,a3,a2
    800051b4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051b8:	6398                	ld	a4,0(a5)
    800051ba:	9732                	add	a4,a4,a2
    800051bc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800051c0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800051c4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800051c8:	953e                	add	a0,a0,a5
    800051ca:	4785                	li	a5,1
    800051cc:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800051d0:	00015517          	auipc	a0,0x15
    800051d4:	b8850513          	addi	a0,a0,-1144 # 80019d58 <disk+0x18>
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	394080e7          	jalr	916(ra) # 8000156c <wakeup>
}
    800051e0:	60a2                	ld	ra,8(sp)
    800051e2:	6402                	ld	s0,0(sp)
    800051e4:	0141                	addi	sp,sp,16
    800051e6:	8082                	ret
    panic("free_desc 1");
    800051e8:	00003517          	auipc	a0,0x3
    800051ec:	64850513          	addi	a0,a0,1608 # 80008830 <syscall_names+0x2e8>
    800051f0:	00001097          	auipc	ra,0x1
    800051f4:	a72080e7          	jalr	-1422(ra) # 80005c62 <panic>
    panic("free_desc 2");
    800051f8:	00003517          	auipc	a0,0x3
    800051fc:	64850513          	addi	a0,a0,1608 # 80008840 <syscall_names+0x2f8>
    80005200:	00001097          	auipc	ra,0x1
    80005204:	a62080e7          	jalr	-1438(ra) # 80005c62 <panic>

0000000080005208 <virtio_disk_init>:
{
    80005208:	1101                	addi	sp,sp,-32
    8000520a:	ec06                	sd	ra,24(sp)
    8000520c:	e822                	sd	s0,16(sp)
    8000520e:	e426                	sd	s1,8(sp)
    80005210:	e04a                	sd	s2,0(sp)
    80005212:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005214:	00003597          	auipc	a1,0x3
    80005218:	63c58593          	addi	a1,a1,1596 # 80008850 <syscall_names+0x308>
    8000521c:	00015517          	auipc	a0,0x15
    80005220:	c4c50513          	addi	a0,a0,-948 # 80019e68 <disk+0x128>
    80005224:	00001097          	auipc	ra,0x1
    80005228:	ef8080e7          	jalr	-264(ra) # 8000611c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000522c:	100017b7          	lui	a5,0x10001
    80005230:	4398                	lw	a4,0(a5)
    80005232:	2701                	sext.w	a4,a4
    80005234:	747277b7          	lui	a5,0x74727
    80005238:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000523c:	14f71e63          	bne	a4,a5,80005398 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005240:	100017b7          	lui	a5,0x10001
    80005244:	43dc                	lw	a5,4(a5)
    80005246:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005248:	4709                	li	a4,2
    8000524a:	14e79763          	bne	a5,a4,80005398 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000524e:	100017b7          	lui	a5,0x10001
    80005252:	479c                	lw	a5,8(a5)
    80005254:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005256:	14e79163          	bne	a5,a4,80005398 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000525a:	100017b7          	lui	a5,0x10001
    8000525e:	47d8                	lw	a4,12(a5)
    80005260:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005262:	554d47b7          	lui	a5,0x554d4
    80005266:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000526a:	12f71763          	bne	a4,a5,80005398 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000526e:	100017b7          	lui	a5,0x10001
    80005272:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005276:	4705                	li	a4,1
    80005278:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000527a:	470d                	li	a4,3
    8000527c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000527e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005280:	c7ffe737          	lui	a4,0xc7ffe
    80005284:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc69f>
    80005288:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000528a:	2701                	sext.w	a4,a4
    8000528c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000528e:	472d                	li	a4,11
    80005290:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005292:	0707a903          	lw	s2,112(a5)
    80005296:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005298:	00897793          	andi	a5,s2,8
    8000529c:	10078663          	beqz	a5,800053a8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052a0:	100017b7          	lui	a5,0x10001
    800052a4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800052a8:	43fc                	lw	a5,68(a5)
    800052aa:	2781                	sext.w	a5,a5
    800052ac:	10079663          	bnez	a5,800053b8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052b0:	100017b7          	lui	a5,0x10001
    800052b4:	5bdc                	lw	a5,52(a5)
    800052b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052b8:	10078863          	beqz	a5,800053c8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800052bc:	471d                	li	a4,7
    800052be:	10f77d63          	bgeu	a4,a5,800053d8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800052c2:	ffffb097          	auipc	ra,0xffffb
    800052c6:	e56080e7          	jalr	-426(ra) # 80000118 <kalloc>
    800052ca:	00015497          	auipc	s1,0x15
    800052ce:	a7648493          	addi	s1,s1,-1418 # 80019d40 <disk>
    800052d2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800052d4:	ffffb097          	auipc	ra,0xffffb
    800052d8:	e44080e7          	jalr	-444(ra) # 80000118 <kalloc>
    800052dc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800052de:	ffffb097          	auipc	ra,0xffffb
    800052e2:	e3a080e7          	jalr	-454(ra) # 80000118 <kalloc>
    800052e6:	87aa                	mv	a5,a0
    800052e8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800052ea:	6088                	ld	a0,0(s1)
    800052ec:	cd75                	beqz	a0,800053e8 <virtio_disk_init+0x1e0>
    800052ee:	00015717          	auipc	a4,0x15
    800052f2:	a5a73703          	ld	a4,-1446(a4) # 80019d48 <disk+0x8>
    800052f6:	cb6d                	beqz	a4,800053e8 <virtio_disk_init+0x1e0>
    800052f8:	cbe5                	beqz	a5,800053e8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800052fa:	6605                	lui	a2,0x1
    800052fc:	4581                	li	a1,0
    800052fe:	ffffb097          	auipc	ra,0xffffb
    80005302:	e7a080e7          	jalr	-390(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005306:	00015497          	auipc	s1,0x15
    8000530a:	a3a48493          	addi	s1,s1,-1478 # 80019d40 <disk>
    8000530e:	6605                	lui	a2,0x1
    80005310:	4581                	li	a1,0
    80005312:	6488                	ld	a0,8(s1)
    80005314:	ffffb097          	auipc	ra,0xffffb
    80005318:	e64080e7          	jalr	-412(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000531c:	6605                	lui	a2,0x1
    8000531e:	4581                	li	a1,0
    80005320:	6888                	ld	a0,16(s1)
    80005322:	ffffb097          	auipc	ra,0xffffb
    80005326:	e56080e7          	jalr	-426(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000532a:	100017b7          	lui	a5,0x10001
    8000532e:	4721                	li	a4,8
    80005330:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005332:	4098                	lw	a4,0(s1)
    80005334:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005338:	40d8                	lw	a4,4(s1)
    8000533a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000533e:	6498                	ld	a4,8(s1)
    80005340:	0007069b          	sext.w	a3,a4
    80005344:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005348:	9701                	srai	a4,a4,0x20
    8000534a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000534e:	6898                	ld	a4,16(s1)
    80005350:	0007069b          	sext.w	a3,a4
    80005354:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005358:	9701                	srai	a4,a4,0x20
    8000535a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000535e:	4685                	li	a3,1
    80005360:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005362:	4705                	li	a4,1
    80005364:	00d48c23          	sb	a3,24(s1)
    80005368:	00e48ca3          	sb	a4,25(s1)
    8000536c:	00e48d23          	sb	a4,26(s1)
    80005370:	00e48da3          	sb	a4,27(s1)
    80005374:	00e48e23          	sb	a4,28(s1)
    80005378:	00e48ea3          	sb	a4,29(s1)
    8000537c:	00e48f23          	sb	a4,30(s1)
    80005380:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005384:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005388:	0727a823          	sw	s2,112(a5)
}
    8000538c:	60e2                	ld	ra,24(sp)
    8000538e:	6442                	ld	s0,16(sp)
    80005390:	64a2                	ld	s1,8(sp)
    80005392:	6902                	ld	s2,0(sp)
    80005394:	6105                	addi	sp,sp,32
    80005396:	8082                	ret
    panic("could not find virtio disk");
    80005398:	00003517          	auipc	a0,0x3
    8000539c:	4c850513          	addi	a0,a0,1224 # 80008860 <syscall_names+0x318>
    800053a0:	00001097          	auipc	ra,0x1
    800053a4:	8c2080e7          	jalr	-1854(ra) # 80005c62 <panic>
    panic("virtio disk FEATURES_OK unset");
    800053a8:	00003517          	auipc	a0,0x3
    800053ac:	4d850513          	addi	a0,a0,1240 # 80008880 <syscall_names+0x338>
    800053b0:	00001097          	auipc	ra,0x1
    800053b4:	8b2080e7          	jalr	-1870(ra) # 80005c62 <panic>
    panic("virtio disk should not be ready");
    800053b8:	00003517          	auipc	a0,0x3
    800053bc:	4e850513          	addi	a0,a0,1256 # 800088a0 <syscall_names+0x358>
    800053c0:	00001097          	auipc	ra,0x1
    800053c4:	8a2080e7          	jalr	-1886(ra) # 80005c62 <panic>
    panic("virtio disk has no queue 0");
    800053c8:	00003517          	auipc	a0,0x3
    800053cc:	4f850513          	addi	a0,a0,1272 # 800088c0 <syscall_names+0x378>
    800053d0:	00001097          	auipc	ra,0x1
    800053d4:	892080e7          	jalr	-1902(ra) # 80005c62 <panic>
    panic("virtio disk max queue too short");
    800053d8:	00003517          	auipc	a0,0x3
    800053dc:	50850513          	addi	a0,a0,1288 # 800088e0 <syscall_names+0x398>
    800053e0:	00001097          	auipc	ra,0x1
    800053e4:	882080e7          	jalr	-1918(ra) # 80005c62 <panic>
    panic("virtio disk kalloc");
    800053e8:	00003517          	auipc	a0,0x3
    800053ec:	51850513          	addi	a0,a0,1304 # 80008900 <syscall_names+0x3b8>
    800053f0:	00001097          	auipc	ra,0x1
    800053f4:	872080e7          	jalr	-1934(ra) # 80005c62 <panic>

00000000800053f8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053f8:	7159                	addi	sp,sp,-112
    800053fa:	f486                	sd	ra,104(sp)
    800053fc:	f0a2                	sd	s0,96(sp)
    800053fe:	eca6                	sd	s1,88(sp)
    80005400:	e8ca                	sd	s2,80(sp)
    80005402:	e4ce                	sd	s3,72(sp)
    80005404:	e0d2                	sd	s4,64(sp)
    80005406:	fc56                	sd	s5,56(sp)
    80005408:	f85a                	sd	s6,48(sp)
    8000540a:	f45e                	sd	s7,40(sp)
    8000540c:	f062                	sd	s8,32(sp)
    8000540e:	ec66                	sd	s9,24(sp)
    80005410:	e86a                	sd	s10,16(sp)
    80005412:	1880                	addi	s0,sp,112
    80005414:	892a                	mv	s2,a0
    80005416:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005418:	00c52c83          	lw	s9,12(a0)
    8000541c:	001c9c9b          	slliw	s9,s9,0x1
    80005420:	1c82                	slli	s9,s9,0x20
    80005422:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005426:	00015517          	auipc	a0,0x15
    8000542a:	a4250513          	addi	a0,a0,-1470 # 80019e68 <disk+0x128>
    8000542e:	00001097          	auipc	ra,0x1
    80005432:	d7e080e7          	jalr	-642(ra) # 800061ac <acquire>
  for(int i = 0; i < 3; i++){
    80005436:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005438:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000543a:	00015b17          	auipc	s6,0x15
    8000543e:	906b0b13          	addi	s6,s6,-1786 # 80019d40 <disk>
  for(int i = 0; i < 3; i++){
    80005442:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005444:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005446:	00015c17          	auipc	s8,0x15
    8000544a:	a22c0c13          	addi	s8,s8,-1502 # 80019e68 <disk+0x128>
    8000544e:	a8b5                	j	800054ca <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005450:	00fb06b3          	add	a3,s6,a5
    80005454:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005458:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000545a:	0207c563          	bltz	a5,80005484 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000545e:	2485                	addiw	s1,s1,1
    80005460:	0711                	addi	a4,a4,4
    80005462:	1f548a63          	beq	s1,s5,80005656 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005466:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005468:	00015697          	auipc	a3,0x15
    8000546c:	8d868693          	addi	a3,a3,-1832 # 80019d40 <disk>
    80005470:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005472:	0186c583          	lbu	a1,24(a3)
    80005476:	fde9                	bnez	a1,80005450 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005478:	2785                	addiw	a5,a5,1
    8000547a:	0685                	addi	a3,a3,1
    8000547c:	ff779be3          	bne	a5,s7,80005472 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005480:	57fd                	li	a5,-1
    80005482:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005484:	02905a63          	blez	s1,800054b8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005488:	f9042503          	lw	a0,-112(s0)
    8000548c:	00000097          	auipc	ra,0x0
    80005490:	cfa080e7          	jalr	-774(ra) # 80005186 <free_desc>
      for(int j = 0; j < i; j++)
    80005494:	4785                	li	a5,1
    80005496:	0297d163          	bge	a5,s1,800054b8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000549a:	f9442503          	lw	a0,-108(s0)
    8000549e:	00000097          	auipc	ra,0x0
    800054a2:	ce8080e7          	jalr	-792(ra) # 80005186 <free_desc>
      for(int j = 0; j < i; j++)
    800054a6:	4789                	li	a5,2
    800054a8:	0097d863          	bge	a5,s1,800054b8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800054ac:	f9842503          	lw	a0,-104(s0)
    800054b0:	00000097          	auipc	ra,0x0
    800054b4:	cd6080e7          	jalr	-810(ra) # 80005186 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054b8:	85e2                	mv	a1,s8
    800054ba:	00015517          	auipc	a0,0x15
    800054be:	89e50513          	addi	a0,a0,-1890 # 80019d58 <disk+0x18>
    800054c2:	ffffc097          	auipc	ra,0xffffc
    800054c6:	046080e7          	jalr	70(ra) # 80001508 <sleep>
  for(int i = 0; i < 3; i++){
    800054ca:	f9040713          	addi	a4,s0,-112
    800054ce:	84ce                	mv	s1,s3
    800054d0:	bf59                	j	80005466 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054d2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800054d6:	00479693          	slli	a3,a5,0x4
    800054da:	00015797          	auipc	a5,0x15
    800054de:	86678793          	addi	a5,a5,-1946 # 80019d40 <disk>
    800054e2:	97b6                	add	a5,a5,a3
    800054e4:	4685                	li	a3,1
    800054e6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054e8:	00015597          	auipc	a1,0x15
    800054ec:	85858593          	addi	a1,a1,-1960 # 80019d40 <disk>
    800054f0:	00a60793          	addi	a5,a2,10
    800054f4:	0792                	slli	a5,a5,0x4
    800054f6:	97ae                	add	a5,a5,a1
    800054f8:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800054fc:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005500:	f6070693          	addi	a3,a4,-160
    80005504:	619c                	ld	a5,0(a1)
    80005506:	97b6                	add	a5,a5,a3
    80005508:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000550a:	6188                	ld	a0,0(a1)
    8000550c:	96aa                	add	a3,a3,a0
    8000550e:	47c1                	li	a5,16
    80005510:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005512:	4785                	li	a5,1
    80005514:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005518:	f9442783          	lw	a5,-108(s0)
    8000551c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005520:	0792                	slli	a5,a5,0x4
    80005522:	953e                	add	a0,a0,a5
    80005524:	05890693          	addi	a3,s2,88
    80005528:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000552a:	6188                	ld	a0,0(a1)
    8000552c:	97aa                	add	a5,a5,a0
    8000552e:	40000693          	li	a3,1024
    80005532:	c794                	sw	a3,8(a5)
  if(write)
    80005534:	100d0d63          	beqz	s10,8000564e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005538:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000553c:	00c7d683          	lhu	a3,12(a5)
    80005540:	0016e693          	ori	a3,a3,1
    80005544:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005548:	f9842583          	lw	a1,-104(s0)
    8000554c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005550:	00014697          	auipc	a3,0x14
    80005554:	7f068693          	addi	a3,a3,2032 # 80019d40 <disk>
    80005558:	00260793          	addi	a5,a2,2
    8000555c:	0792                	slli	a5,a5,0x4
    8000555e:	97b6                	add	a5,a5,a3
    80005560:	587d                	li	a6,-1
    80005562:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005566:	0592                	slli	a1,a1,0x4
    80005568:	952e                	add	a0,a0,a1
    8000556a:	f9070713          	addi	a4,a4,-112
    8000556e:	9736                	add	a4,a4,a3
    80005570:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005572:	6298                	ld	a4,0(a3)
    80005574:	972e                	add	a4,a4,a1
    80005576:	4585                	li	a1,1
    80005578:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000557a:	4509                	li	a0,2
    8000557c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005580:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005584:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005588:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000558c:	6698                	ld	a4,8(a3)
    8000558e:	00275783          	lhu	a5,2(a4)
    80005592:	8b9d                	andi	a5,a5,7
    80005594:	0786                	slli	a5,a5,0x1
    80005596:	97ba                	add	a5,a5,a4
    80005598:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000559c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055a0:	6698                	ld	a4,8(a3)
    800055a2:	00275783          	lhu	a5,2(a4)
    800055a6:	2785                	addiw	a5,a5,1
    800055a8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055ac:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055b0:	100017b7          	lui	a5,0x10001
    800055b4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055b8:	00492703          	lw	a4,4(s2)
    800055bc:	4785                	li	a5,1
    800055be:	02f71163          	bne	a4,a5,800055e0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800055c2:	00015997          	auipc	s3,0x15
    800055c6:	8a698993          	addi	s3,s3,-1882 # 80019e68 <disk+0x128>
  while(b->disk == 1) {
    800055ca:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055cc:	85ce                	mv	a1,s3
    800055ce:	854a                	mv	a0,s2
    800055d0:	ffffc097          	auipc	ra,0xffffc
    800055d4:	f38080e7          	jalr	-200(ra) # 80001508 <sleep>
  while(b->disk == 1) {
    800055d8:	00492783          	lw	a5,4(s2)
    800055dc:	fe9788e3          	beq	a5,s1,800055cc <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800055e0:	f9042903          	lw	s2,-112(s0)
    800055e4:	00290793          	addi	a5,s2,2
    800055e8:	00479713          	slli	a4,a5,0x4
    800055ec:	00014797          	auipc	a5,0x14
    800055f0:	75478793          	addi	a5,a5,1876 # 80019d40 <disk>
    800055f4:	97ba                	add	a5,a5,a4
    800055f6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800055fa:	00014997          	auipc	s3,0x14
    800055fe:	74698993          	addi	s3,s3,1862 # 80019d40 <disk>
    80005602:	00491713          	slli	a4,s2,0x4
    80005606:	0009b783          	ld	a5,0(s3)
    8000560a:	97ba                	add	a5,a5,a4
    8000560c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005610:	854a                	mv	a0,s2
    80005612:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005616:	00000097          	auipc	ra,0x0
    8000561a:	b70080e7          	jalr	-1168(ra) # 80005186 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000561e:	8885                	andi	s1,s1,1
    80005620:	f0ed                	bnez	s1,80005602 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005622:	00015517          	auipc	a0,0x15
    80005626:	84650513          	addi	a0,a0,-1978 # 80019e68 <disk+0x128>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	c36080e7          	jalr	-970(ra) # 80006260 <release>
}
    80005632:	70a6                	ld	ra,104(sp)
    80005634:	7406                	ld	s0,96(sp)
    80005636:	64e6                	ld	s1,88(sp)
    80005638:	6946                	ld	s2,80(sp)
    8000563a:	69a6                	ld	s3,72(sp)
    8000563c:	6a06                	ld	s4,64(sp)
    8000563e:	7ae2                	ld	s5,56(sp)
    80005640:	7b42                	ld	s6,48(sp)
    80005642:	7ba2                	ld	s7,40(sp)
    80005644:	7c02                	ld	s8,32(sp)
    80005646:	6ce2                	ld	s9,24(sp)
    80005648:	6d42                	ld	s10,16(sp)
    8000564a:	6165                	addi	sp,sp,112
    8000564c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000564e:	4689                	li	a3,2
    80005650:	00d79623          	sh	a3,12(a5)
    80005654:	b5e5                	j	8000553c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005656:	f9042603          	lw	a2,-112(s0)
    8000565a:	00a60713          	addi	a4,a2,10
    8000565e:	0712                	slli	a4,a4,0x4
    80005660:	00014517          	auipc	a0,0x14
    80005664:	6e850513          	addi	a0,a0,1768 # 80019d48 <disk+0x8>
    80005668:	953a                	add	a0,a0,a4
  if(write)
    8000566a:	e60d14e3          	bnez	s10,800054d2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000566e:	00a60793          	addi	a5,a2,10
    80005672:	00479693          	slli	a3,a5,0x4
    80005676:	00014797          	auipc	a5,0x14
    8000567a:	6ca78793          	addi	a5,a5,1738 # 80019d40 <disk>
    8000567e:	97b6                	add	a5,a5,a3
    80005680:	0007a423          	sw	zero,8(a5)
    80005684:	b595                	j	800054e8 <virtio_disk_rw+0xf0>

0000000080005686 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005686:	1101                	addi	sp,sp,-32
    80005688:	ec06                	sd	ra,24(sp)
    8000568a:	e822                	sd	s0,16(sp)
    8000568c:	e426                	sd	s1,8(sp)
    8000568e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005690:	00014497          	auipc	s1,0x14
    80005694:	6b048493          	addi	s1,s1,1712 # 80019d40 <disk>
    80005698:	00014517          	auipc	a0,0x14
    8000569c:	7d050513          	addi	a0,a0,2000 # 80019e68 <disk+0x128>
    800056a0:	00001097          	auipc	ra,0x1
    800056a4:	b0c080e7          	jalr	-1268(ra) # 800061ac <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056a8:	10001737          	lui	a4,0x10001
    800056ac:	533c                	lw	a5,96(a4)
    800056ae:	8b8d                	andi	a5,a5,3
    800056b0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056b2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056b6:	689c                	ld	a5,16(s1)
    800056b8:	0204d703          	lhu	a4,32(s1)
    800056bc:	0027d783          	lhu	a5,2(a5)
    800056c0:	04f70863          	beq	a4,a5,80005710 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056c4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c8:	6898                	ld	a4,16(s1)
    800056ca:	0204d783          	lhu	a5,32(s1)
    800056ce:	8b9d                	andi	a5,a5,7
    800056d0:	078e                	slli	a5,a5,0x3
    800056d2:	97ba                	add	a5,a5,a4
    800056d4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056d6:	00278713          	addi	a4,a5,2
    800056da:	0712                	slli	a4,a4,0x4
    800056dc:	9726                	add	a4,a4,s1
    800056de:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056e2:	e721                	bnez	a4,8000572a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056e4:	0789                	addi	a5,a5,2
    800056e6:	0792                	slli	a5,a5,0x4
    800056e8:	97a6                	add	a5,a5,s1
    800056ea:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800056ec:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056f0:	ffffc097          	auipc	ra,0xffffc
    800056f4:	e7c080e7          	jalr	-388(ra) # 8000156c <wakeup>

    disk.used_idx += 1;
    800056f8:	0204d783          	lhu	a5,32(s1)
    800056fc:	2785                	addiw	a5,a5,1
    800056fe:	17c2                	slli	a5,a5,0x30
    80005700:	93c1                	srli	a5,a5,0x30
    80005702:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005706:	6898                	ld	a4,16(s1)
    80005708:	00275703          	lhu	a4,2(a4)
    8000570c:	faf71ce3          	bne	a4,a5,800056c4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005710:	00014517          	auipc	a0,0x14
    80005714:	75850513          	addi	a0,a0,1880 # 80019e68 <disk+0x128>
    80005718:	00001097          	auipc	ra,0x1
    8000571c:	b48080e7          	jalr	-1208(ra) # 80006260 <release>
}
    80005720:	60e2                	ld	ra,24(sp)
    80005722:	6442                	ld	s0,16(sp)
    80005724:	64a2                	ld	s1,8(sp)
    80005726:	6105                	addi	sp,sp,32
    80005728:	8082                	ret
      panic("virtio_disk_intr status");
    8000572a:	00003517          	auipc	a0,0x3
    8000572e:	1ee50513          	addi	a0,a0,494 # 80008918 <syscall_names+0x3d0>
    80005732:	00000097          	auipc	ra,0x0
    80005736:	530080e7          	jalr	1328(ra) # 80005c62 <panic>

000000008000573a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000573a:	1141                	addi	sp,sp,-16
    8000573c:	e422                	sd	s0,8(sp)
    8000573e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005740:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005744:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005748:	0037979b          	slliw	a5,a5,0x3
    8000574c:	02004737          	lui	a4,0x2004
    80005750:	97ba                	add	a5,a5,a4
    80005752:	0200c737          	lui	a4,0x200c
    80005756:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000575a:	000f4637          	lui	a2,0xf4
    8000575e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005762:	95b2                	add	a1,a1,a2
    80005764:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005766:	00269713          	slli	a4,a3,0x2
    8000576a:	9736                	add	a4,a4,a3
    8000576c:	00371693          	slli	a3,a4,0x3
    80005770:	00014717          	auipc	a4,0x14
    80005774:	71070713          	addi	a4,a4,1808 # 80019e80 <timer_scratch>
    80005778:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000577a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000577c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000577e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005782:	00000797          	auipc	a5,0x0
    80005786:	93e78793          	addi	a5,a5,-1730 # 800050c0 <timervec>
    8000578a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000578e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005792:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005796:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000579a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000579e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057a2:	30479073          	csrw	mie,a5
}
    800057a6:	6422                	ld	s0,8(sp)
    800057a8:	0141                	addi	sp,sp,16
    800057aa:	8082                	ret

00000000800057ac <start>:
{
    800057ac:	1141                	addi	sp,sp,-16
    800057ae:	e406                	sd	ra,8(sp)
    800057b0:	e022                	sd	s0,0(sp)
    800057b2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057b4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057b8:	7779                	lui	a4,0xffffe
    800057ba:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc73f>
    800057be:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057c0:	6705                	lui	a4,0x1
    800057c2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057cc:	ffffb797          	auipc	a5,0xffffb
    800057d0:	b5a78793          	addi	a5,a5,-1190 # 80000326 <main>
    800057d4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057d8:	4781                	li	a5,0
    800057da:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057de:	67c1                	lui	a5,0x10
    800057e0:	17fd                	addi	a5,a5,-1
    800057e2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057e6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057ea:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057ee:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057f2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057f6:	57fd                	li	a5,-1
    800057f8:	83a9                	srli	a5,a5,0xa
    800057fa:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057fe:	47bd                	li	a5,15
    80005800:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005804:	00000097          	auipc	ra,0x0
    80005808:	f36080e7          	jalr	-202(ra) # 8000573a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000580c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005810:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80005812:	823e                	mv	tp,a5
  asm volatile("mret");
    80005814:	30200073          	mret
}
    80005818:	60a2                	ld	ra,8(sp)
    8000581a:	6402                	ld	s0,0(sp)
    8000581c:	0141                	addi	sp,sp,16
    8000581e:	8082                	ret

0000000080005820 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005820:	715d                	addi	sp,sp,-80
    80005822:	e486                	sd	ra,72(sp)
    80005824:	e0a2                	sd	s0,64(sp)
    80005826:	fc26                	sd	s1,56(sp)
    80005828:	f84a                	sd	s2,48(sp)
    8000582a:	f44e                	sd	s3,40(sp)
    8000582c:	f052                	sd	s4,32(sp)
    8000582e:	ec56                	sd	s5,24(sp)
    80005830:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005832:	04c05663          	blez	a2,8000587e <consolewrite+0x5e>
    80005836:	8a2a                	mv	s4,a0
    80005838:	84ae                	mv	s1,a1
    8000583a:	89b2                	mv	s3,a2
    8000583c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000583e:	5afd                	li	s5,-1
    80005840:	4685                	li	a3,1
    80005842:	8626                	mv	a2,s1
    80005844:	85d2                	mv	a1,s4
    80005846:	fbf40513          	addi	a0,s0,-65
    8000584a:	ffffc097          	auipc	ra,0xffffc
    8000584e:	11c080e7          	jalr	284(ra) # 80001966 <either_copyin>
    80005852:	01550c63          	beq	a0,s5,8000586a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005856:	fbf44503          	lbu	a0,-65(s0)
    8000585a:	00000097          	auipc	ra,0x0
    8000585e:	794080e7          	jalr	1940(ra) # 80005fee <uartputc>
  for(i = 0; i < n; i++){
    80005862:	2905                	addiw	s2,s2,1
    80005864:	0485                	addi	s1,s1,1
    80005866:	fd299de3          	bne	s3,s2,80005840 <consolewrite+0x20>
  }

  return i;
}
    8000586a:	854a                	mv	a0,s2
    8000586c:	60a6                	ld	ra,72(sp)
    8000586e:	6406                	ld	s0,64(sp)
    80005870:	74e2                	ld	s1,56(sp)
    80005872:	7942                	ld	s2,48(sp)
    80005874:	79a2                	ld	s3,40(sp)
    80005876:	7a02                	ld	s4,32(sp)
    80005878:	6ae2                	ld	s5,24(sp)
    8000587a:	6161                	addi	sp,sp,80
    8000587c:	8082                	ret
  for(i = 0; i < n; i++){
    8000587e:	4901                	li	s2,0
    80005880:	b7ed                	j	8000586a <consolewrite+0x4a>

0000000080005882 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005882:	7119                	addi	sp,sp,-128
    80005884:	fc86                	sd	ra,120(sp)
    80005886:	f8a2                	sd	s0,112(sp)
    80005888:	f4a6                	sd	s1,104(sp)
    8000588a:	f0ca                	sd	s2,96(sp)
    8000588c:	ecce                	sd	s3,88(sp)
    8000588e:	e8d2                	sd	s4,80(sp)
    80005890:	e4d6                	sd	s5,72(sp)
    80005892:	e0da                	sd	s6,64(sp)
    80005894:	fc5e                	sd	s7,56(sp)
    80005896:	f862                	sd	s8,48(sp)
    80005898:	f466                	sd	s9,40(sp)
    8000589a:	f06a                	sd	s10,32(sp)
    8000589c:	ec6e                	sd	s11,24(sp)
    8000589e:	0100                	addi	s0,sp,128
    800058a0:	8b2a                	mv	s6,a0
    800058a2:	8aae                	mv	s5,a1
    800058a4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058a6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058aa:	0001c517          	auipc	a0,0x1c
    800058ae:	71650513          	addi	a0,a0,1814 # 80021fc0 <cons>
    800058b2:	00001097          	auipc	ra,0x1
    800058b6:	8fa080e7          	jalr	-1798(ra) # 800061ac <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058ba:	0001c497          	auipc	s1,0x1c
    800058be:	70648493          	addi	s1,s1,1798 # 80021fc0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058c2:	89a6                	mv	s3,s1
    800058c4:	0001c917          	auipc	s2,0x1c
    800058c8:	79490913          	addi	s2,s2,1940 # 80022058 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800058cc:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ce:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058d0:	4da9                	li	s11,10
  while(n > 0){
    800058d2:	07405b63          	blez	s4,80005948 <consoleread+0xc6>
    while(cons.r == cons.w){
    800058d6:	0984a783          	lw	a5,152(s1)
    800058da:	09c4a703          	lw	a4,156(s1)
    800058de:	02f71763          	bne	a4,a5,8000590c <consoleread+0x8a>
      if(killed(myproc())){
    800058e2:	ffffb097          	auipc	ra,0xffffb
    800058e6:	576080e7          	jalr	1398(ra) # 80000e58 <myproc>
    800058ea:	ffffc097          	auipc	ra,0xffffc
    800058ee:	ec6080e7          	jalr	-314(ra) # 800017b0 <killed>
    800058f2:	e535                	bnez	a0,8000595e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    800058f4:	85ce                	mv	a1,s3
    800058f6:	854a                	mv	a0,s2
    800058f8:	ffffc097          	auipc	ra,0xffffc
    800058fc:	c10080e7          	jalr	-1008(ra) # 80001508 <sleep>
    while(cons.r == cons.w){
    80005900:	0984a783          	lw	a5,152(s1)
    80005904:	09c4a703          	lw	a4,156(s1)
    80005908:	fcf70de3          	beq	a4,a5,800058e2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000590c:	0017871b          	addiw	a4,a5,1
    80005910:	08e4ac23          	sw	a4,152(s1)
    80005914:	07f7f713          	andi	a4,a5,127
    80005918:	9726                	add	a4,a4,s1
    8000591a:	01874703          	lbu	a4,24(a4)
    8000591e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005922:	079c0663          	beq	s8,s9,8000598e <consoleread+0x10c>
    cbuf = c;
    80005926:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000592a:	4685                	li	a3,1
    8000592c:	f8f40613          	addi	a2,s0,-113
    80005930:	85d6                	mv	a1,s5
    80005932:	855a                	mv	a0,s6
    80005934:	ffffc097          	auipc	ra,0xffffc
    80005938:	fdc080e7          	jalr	-36(ra) # 80001910 <either_copyout>
    8000593c:	01a50663          	beq	a0,s10,80005948 <consoleread+0xc6>
    dst++;
    80005940:	0a85                	addi	s5,s5,1
    --n;
    80005942:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005944:	f9bc17e3          	bne	s8,s11,800058d2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005948:	0001c517          	auipc	a0,0x1c
    8000594c:	67850513          	addi	a0,a0,1656 # 80021fc0 <cons>
    80005950:	00001097          	auipc	ra,0x1
    80005954:	910080e7          	jalr	-1776(ra) # 80006260 <release>

  return target - n;
    80005958:	414b853b          	subw	a0,s7,s4
    8000595c:	a811                	j	80005970 <consoleread+0xee>
        release(&cons.lock);
    8000595e:	0001c517          	auipc	a0,0x1c
    80005962:	66250513          	addi	a0,a0,1634 # 80021fc0 <cons>
    80005966:	00001097          	auipc	ra,0x1
    8000596a:	8fa080e7          	jalr	-1798(ra) # 80006260 <release>
        return -1;
    8000596e:	557d                	li	a0,-1
}
    80005970:	70e6                	ld	ra,120(sp)
    80005972:	7446                	ld	s0,112(sp)
    80005974:	74a6                	ld	s1,104(sp)
    80005976:	7906                	ld	s2,96(sp)
    80005978:	69e6                	ld	s3,88(sp)
    8000597a:	6a46                	ld	s4,80(sp)
    8000597c:	6aa6                	ld	s5,72(sp)
    8000597e:	6b06                	ld	s6,64(sp)
    80005980:	7be2                	ld	s7,56(sp)
    80005982:	7c42                	ld	s8,48(sp)
    80005984:	7ca2                	ld	s9,40(sp)
    80005986:	7d02                	ld	s10,32(sp)
    80005988:	6de2                	ld	s11,24(sp)
    8000598a:	6109                	addi	sp,sp,128
    8000598c:	8082                	ret
      if(n < target){
    8000598e:	000a071b          	sext.w	a4,s4
    80005992:	fb777be3          	bgeu	a4,s7,80005948 <consoleread+0xc6>
        cons.r--;
    80005996:	0001c717          	auipc	a4,0x1c
    8000599a:	6cf72123          	sw	a5,1730(a4) # 80022058 <cons+0x98>
    8000599e:	b76d                	j	80005948 <consoleread+0xc6>

00000000800059a0 <consputc>:
{
    800059a0:	1141                	addi	sp,sp,-16
    800059a2:	e406                	sd	ra,8(sp)
    800059a4:	e022                	sd	s0,0(sp)
    800059a6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059a8:	10000793          	li	a5,256
    800059ac:	00f50a63          	beq	a0,a5,800059c0 <consputc+0x20>
    uartputc_sync(c);
    800059b0:	00000097          	auipc	ra,0x0
    800059b4:	564080e7          	jalr	1380(ra) # 80005f14 <uartputc_sync>
}
    800059b8:	60a2                	ld	ra,8(sp)
    800059ba:	6402                	ld	s0,0(sp)
    800059bc:	0141                	addi	sp,sp,16
    800059be:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059c0:	4521                	li	a0,8
    800059c2:	00000097          	auipc	ra,0x0
    800059c6:	552080e7          	jalr	1362(ra) # 80005f14 <uartputc_sync>
    800059ca:	02000513          	li	a0,32
    800059ce:	00000097          	auipc	ra,0x0
    800059d2:	546080e7          	jalr	1350(ra) # 80005f14 <uartputc_sync>
    800059d6:	4521                	li	a0,8
    800059d8:	00000097          	auipc	ra,0x0
    800059dc:	53c080e7          	jalr	1340(ra) # 80005f14 <uartputc_sync>
    800059e0:	bfe1                	j	800059b8 <consputc+0x18>

00000000800059e2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059e2:	1101                	addi	sp,sp,-32
    800059e4:	ec06                	sd	ra,24(sp)
    800059e6:	e822                	sd	s0,16(sp)
    800059e8:	e426                	sd	s1,8(sp)
    800059ea:	e04a                	sd	s2,0(sp)
    800059ec:	1000                	addi	s0,sp,32
    800059ee:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059f0:	0001c517          	auipc	a0,0x1c
    800059f4:	5d050513          	addi	a0,a0,1488 # 80021fc0 <cons>
    800059f8:	00000097          	auipc	ra,0x0
    800059fc:	7b4080e7          	jalr	1972(ra) # 800061ac <acquire>

  switch(c){
    80005a00:	47d5                	li	a5,21
    80005a02:	0af48663          	beq	s1,a5,80005aae <consoleintr+0xcc>
    80005a06:	0297ca63          	blt	a5,s1,80005a3a <consoleintr+0x58>
    80005a0a:	47a1                	li	a5,8
    80005a0c:	0ef48763          	beq	s1,a5,80005afa <consoleintr+0x118>
    80005a10:	47c1                	li	a5,16
    80005a12:	10f49a63          	bne	s1,a5,80005b26 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a16:	ffffc097          	auipc	ra,0xffffc
    80005a1a:	fa6080e7          	jalr	-90(ra) # 800019bc <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a1e:	0001c517          	auipc	a0,0x1c
    80005a22:	5a250513          	addi	a0,a0,1442 # 80021fc0 <cons>
    80005a26:	00001097          	auipc	ra,0x1
    80005a2a:	83a080e7          	jalr	-1990(ra) # 80006260 <release>
}
    80005a2e:	60e2                	ld	ra,24(sp)
    80005a30:	6442                	ld	s0,16(sp)
    80005a32:	64a2                	ld	s1,8(sp)
    80005a34:	6902                	ld	s2,0(sp)
    80005a36:	6105                	addi	sp,sp,32
    80005a38:	8082                	ret
  switch(c){
    80005a3a:	07f00793          	li	a5,127
    80005a3e:	0af48e63          	beq	s1,a5,80005afa <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a42:	0001c717          	auipc	a4,0x1c
    80005a46:	57e70713          	addi	a4,a4,1406 # 80021fc0 <cons>
    80005a4a:	0a072783          	lw	a5,160(a4)
    80005a4e:	09872703          	lw	a4,152(a4)
    80005a52:	9f99                	subw	a5,a5,a4
    80005a54:	07f00713          	li	a4,127
    80005a58:	fcf763e3          	bltu	a4,a5,80005a1e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a5c:	47b5                	li	a5,13
    80005a5e:	0cf48763          	beq	s1,a5,80005b2c <consoleintr+0x14a>
      consputc(c);
    80005a62:	8526                	mv	a0,s1
    80005a64:	00000097          	auipc	ra,0x0
    80005a68:	f3c080e7          	jalr	-196(ra) # 800059a0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a6c:	0001c797          	auipc	a5,0x1c
    80005a70:	55478793          	addi	a5,a5,1364 # 80021fc0 <cons>
    80005a74:	0a07a683          	lw	a3,160(a5)
    80005a78:	0016871b          	addiw	a4,a3,1
    80005a7c:	0007061b          	sext.w	a2,a4
    80005a80:	0ae7a023          	sw	a4,160(a5)
    80005a84:	07f6f693          	andi	a3,a3,127
    80005a88:	97b6                	add	a5,a5,a3
    80005a8a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a8e:	47a9                	li	a5,10
    80005a90:	0cf48563          	beq	s1,a5,80005b5a <consoleintr+0x178>
    80005a94:	4791                	li	a5,4
    80005a96:	0cf48263          	beq	s1,a5,80005b5a <consoleintr+0x178>
    80005a9a:	0001c797          	auipc	a5,0x1c
    80005a9e:	5be7a783          	lw	a5,1470(a5) # 80022058 <cons+0x98>
    80005aa2:	9f1d                	subw	a4,a4,a5
    80005aa4:	08000793          	li	a5,128
    80005aa8:	f6f71be3          	bne	a4,a5,80005a1e <consoleintr+0x3c>
    80005aac:	a07d                	j	80005b5a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aae:	0001c717          	auipc	a4,0x1c
    80005ab2:	51270713          	addi	a4,a4,1298 # 80021fc0 <cons>
    80005ab6:	0a072783          	lw	a5,160(a4)
    80005aba:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005abe:	0001c497          	auipc	s1,0x1c
    80005ac2:	50248493          	addi	s1,s1,1282 # 80021fc0 <cons>
    while(cons.e != cons.w &&
    80005ac6:	4929                	li	s2,10
    80005ac8:	f4f70be3          	beq	a4,a5,80005a1e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005acc:	37fd                	addiw	a5,a5,-1
    80005ace:	07f7f713          	andi	a4,a5,127
    80005ad2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ad4:	01874703          	lbu	a4,24(a4)
    80005ad8:	f52703e3          	beq	a4,s2,80005a1e <consoleintr+0x3c>
      cons.e--;
    80005adc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ae0:	10000513          	li	a0,256
    80005ae4:	00000097          	auipc	ra,0x0
    80005ae8:	ebc080e7          	jalr	-324(ra) # 800059a0 <consputc>
    while(cons.e != cons.w &&
    80005aec:	0a04a783          	lw	a5,160(s1)
    80005af0:	09c4a703          	lw	a4,156(s1)
    80005af4:	fcf71ce3          	bne	a4,a5,80005acc <consoleintr+0xea>
    80005af8:	b71d                	j	80005a1e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005afa:	0001c717          	auipc	a4,0x1c
    80005afe:	4c670713          	addi	a4,a4,1222 # 80021fc0 <cons>
    80005b02:	0a072783          	lw	a5,160(a4)
    80005b06:	09c72703          	lw	a4,156(a4)
    80005b0a:	f0f70ae3          	beq	a4,a5,80005a1e <consoleintr+0x3c>
      cons.e--;
    80005b0e:	37fd                	addiw	a5,a5,-1
    80005b10:	0001c717          	auipc	a4,0x1c
    80005b14:	54f72823          	sw	a5,1360(a4) # 80022060 <cons+0xa0>
      consputc(BACKSPACE);
    80005b18:	10000513          	li	a0,256
    80005b1c:	00000097          	auipc	ra,0x0
    80005b20:	e84080e7          	jalr	-380(ra) # 800059a0 <consputc>
    80005b24:	bded                	j	80005a1e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b26:	ee048ce3          	beqz	s1,80005a1e <consoleintr+0x3c>
    80005b2a:	bf21                	j	80005a42 <consoleintr+0x60>
      consputc(c);
    80005b2c:	4529                	li	a0,10
    80005b2e:	00000097          	auipc	ra,0x0
    80005b32:	e72080e7          	jalr	-398(ra) # 800059a0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b36:	0001c797          	auipc	a5,0x1c
    80005b3a:	48a78793          	addi	a5,a5,1162 # 80021fc0 <cons>
    80005b3e:	0a07a703          	lw	a4,160(a5)
    80005b42:	0017069b          	addiw	a3,a4,1
    80005b46:	0006861b          	sext.w	a2,a3
    80005b4a:	0ad7a023          	sw	a3,160(a5)
    80005b4e:	07f77713          	andi	a4,a4,127
    80005b52:	97ba                	add	a5,a5,a4
    80005b54:	4729                	li	a4,10
    80005b56:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b5a:	0001c797          	auipc	a5,0x1c
    80005b5e:	50c7a123          	sw	a2,1282(a5) # 8002205c <cons+0x9c>
        wakeup(&cons.r);
    80005b62:	0001c517          	auipc	a0,0x1c
    80005b66:	4f650513          	addi	a0,a0,1270 # 80022058 <cons+0x98>
    80005b6a:	ffffc097          	auipc	ra,0xffffc
    80005b6e:	a02080e7          	jalr	-1534(ra) # 8000156c <wakeup>
    80005b72:	b575                	j	80005a1e <consoleintr+0x3c>

0000000080005b74 <consoleinit>:

void
consoleinit(void)
{
    80005b74:	1141                	addi	sp,sp,-16
    80005b76:	e406                	sd	ra,8(sp)
    80005b78:	e022                	sd	s0,0(sp)
    80005b7a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b7c:	00003597          	auipc	a1,0x3
    80005b80:	db458593          	addi	a1,a1,-588 # 80008930 <syscall_names+0x3e8>
    80005b84:	0001c517          	auipc	a0,0x1c
    80005b88:	43c50513          	addi	a0,a0,1084 # 80021fc0 <cons>
    80005b8c:	00000097          	auipc	ra,0x0
    80005b90:	590080e7          	jalr	1424(ra) # 8000611c <initlock>

  uartinit();
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	330080e7          	jalr	816(ra) # 80005ec4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b9c:	00013797          	auipc	a5,0x13
    80005ba0:	14c78793          	addi	a5,a5,332 # 80018ce8 <devsw>
    80005ba4:	00000717          	auipc	a4,0x0
    80005ba8:	cde70713          	addi	a4,a4,-802 # 80005882 <consoleread>
    80005bac:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bae:	00000717          	auipc	a4,0x0
    80005bb2:	c7270713          	addi	a4,a4,-910 # 80005820 <consolewrite>
    80005bb6:	ef98                	sd	a4,24(a5)
}
    80005bb8:	60a2                	ld	ra,8(sp)
    80005bba:	6402                	ld	s0,0(sp)
    80005bbc:	0141                	addi	sp,sp,16
    80005bbe:	8082                	ret

0000000080005bc0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bc0:	7179                	addi	sp,sp,-48
    80005bc2:	f406                	sd	ra,40(sp)
    80005bc4:	f022                	sd	s0,32(sp)
    80005bc6:	ec26                	sd	s1,24(sp)
    80005bc8:	e84a                	sd	s2,16(sp)
    80005bca:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bcc:	c219                	beqz	a2,80005bd2 <printint+0x12>
    80005bce:	08054663          	bltz	a0,80005c5a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bd2:	2501                	sext.w	a0,a0
    80005bd4:	4881                	li	a7,0
    80005bd6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bda:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bdc:	2581                	sext.w	a1,a1
    80005bde:	00003617          	auipc	a2,0x3
    80005be2:	d8260613          	addi	a2,a2,-638 # 80008960 <digits>
    80005be6:	883a                	mv	a6,a4
    80005be8:	2705                	addiw	a4,a4,1
    80005bea:	02b577bb          	remuw	a5,a0,a1
    80005bee:	1782                	slli	a5,a5,0x20
    80005bf0:	9381                	srli	a5,a5,0x20
    80005bf2:	97b2                	add	a5,a5,a2
    80005bf4:	0007c783          	lbu	a5,0(a5)
    80005bf8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bfc:	0005079b          	sext.w	a5,a0
    80005c00:	02b5553b          	divuw	a0,a0,a1
    80005c04:	0685                	addi	a3,a3,1
    80005c06:	feb7f0e3          	bgeu	a5,a1,80005be6 <printint+0x26>

  if(sign)
    80005c0a:	00088b63          	beqz	a7,80005c20 <printint+0x60>
    buf[i++] = '-';
    80005c0e:	fe040793          	addi	a5,s0,-32
    80005c12:	973e                	add	a4,a4,a5
    80005c14:	02d00793          	li	a5,45
    80005c18:	fef70823          	sb	a5,-16(a4)
    80005c1c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c20:	02e05763          	blez	a4,80005c4e <printint+0x8e>
    80005c24:	fd040793          	addi	a5,s0,-48
    80005c28:	00e784b3          	add	s1,a5,a4
    80005c2c:	fff78913          	addi	s2,a5,-1
    80005c30:	993a                	add	s2,s2,a4
    80005c32:	377d                	addiw	a4,a4,-1
    80005c34:	1702                	slli	a4,a4,0x20
    80005c36:	9301                	srli	a4,a4,0x20
    80005c38:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c3c:	fff4c503          	lbu	a0,-1(s1)
    80005c40:	00000097          	auipc	ra,0x0
    80005c44:	d60080e7          	jalr	-672(ra) # 800059a0 <consputc>
  while(--i >= 0)
    80005c48:	14fd                	addi	s1,s1,-1
    80005c4a:	ff2499e3          	bne	s1,s2,80005c3c <printint+0x7c>
}
    80005c4e:	70a2                	ld	ra,40(sp)
    80005c50:	7402                	ld	s0,32(sp)
    80005c52:	64e2                	ld	s1,24(sp)
    80005c54:	6942                	ld	s2,16(sp)
    80005c56:	6145                	addi	sp,sp,48
    80005c58:	8082                	ret
    x = -xx;
    80005c5a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c5e:	4885                	li	a7,1
    x = -xx;
    80005c60:	bf9d                	j	80005bd6 <printint+0x16>

0000000080005c62 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c62:	1101                	addi	sp,sp,-32
    80005c64:	ec06                	sd	ra,24(sp)
    80005c66:	e822                	sd	s0,16(sp)
    80005c68:	e426                	sd	s1,8(sp)
    80005c6a:	1000                	addi	s0,sp,32
    80005c6c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c6e:	0001c797          	auipc	a5,0x1c
    80005c72:	4007a923          	sw	zero,1042(a5) # 80022080 <pr+0x18>
  printf("panic: ");
    80005c76:	00003517          	auipc	a0,0x3
    80005c7a:	cc250513          	addi	a0,a0,-830 # 80008938 <syscall_names+0x3f0>
    80005c7e:	00000097          	auipc	ra,0x0
    80005c82:	02e080e7          	jalr	46(ra) # 80005cac <printf>
  printf(s);
    80005c86:	8526                	mv	a0,s1
    80005c88:	00000097          	auipc	ra,0x0
    80005c8c:	024080e7          	jalr	36(ra) # 80005cac <printf>
  printf("\n");
    80005c90:	00002517          	auipc	a0,0x2
    80005c94:	3b850513          	addi	a0,a0,952 # 80008048 <etext+0x48>
    80005c98:	00000097          	auipc	ra,0x0
    80005c9c:	014080e7          	jalr	20(ra) # 80005cac <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ca0:	4785                	li	a5,1
    80005ca2:	00003717          	auipc	a4,0x3
    80005ca6:	d8f72d23          	sw	a5,-614(a4) # 80008a3c <panicked>
  for(;;)
    80005caa:	a001                	j	80005caa <panic+0x48>

0000000080005cac <printf>:
{
    80005cac:	7131                	addi	sp,sp,-192
    80005cae:	fc86                	sd	ra,120(sp)
    80005cb0:	f8a2                	sd	s0,112(sp)
    80005cb2:	f4a6                	sd	s1,104(sp)
    80005cb4:	f0ca                	sd	s2,96(sp)
    80005cb6:	ecce                	sd	s3,88(sp)
    80005cb8:	e8d2                	sd	s4,80(sp)
    80005cba:	e4d6                	sd	s5,72(sp)
    80005cbc:	e0da                	sd	s6,64(sp)
    80005cbe:	fc5e                	sd	s7,56(sp)
    80005cc0:	f862                	sd	s8,48(sp)
    80005cc2:	f466                	sd	s9,40(sp)
    80005cc4:	f06a                	sd	s10,32(sp)
    80005cc6:	ec6e                	sd	s11,24(sp)
    80005cc8:	0100                	addi	s0,sp,128
    80005cca:	8a2a                	mv	s4,a0
    80005ccc:	e40c                	sd	a1,8(s0)
    80005cce:	e810                	sd	a2,16(s0)
    80005cd0:	ec14                	sd	a3,24(s0)
    80005cd2:	f018                	sd	a4,32(s0)
    80005cd4:	f41c                	sd	a5,40(s0)
    80005cd6:	03043823          	sd	a6,48(s0)
    80005cda:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cde:	0001cd97          	auipc	s11,0x1c
    80005ce2:	3a2dad83          	lw	s11,930(s11) # 80022080 <pr+0x18>
  if(locking)
    80005ce6:	020d9b63          	bnez	s11,80005d1c <printf+0x70>
  if (fmt == 0)
    80005cea:	040a0263          	beqz	s4,80005d2e <printf+0x82>
  va_start(ap, fmt);
    80005cee:	00840793          	addi	a5,s0,8
    80005cf2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cf6:	000a4503          	lbu	a0,0(s4)
    80005cfa:	16050263          	beqz	a0,80005e5e <printf+0x1b2>
    80005cfe:	4481                	li	s1,0
    if(c != '%'){
    80005d00:	02500a93          	li	s5,37
    switch(c){
    80005d04:	07000b13          	li	s6,112
  consputc('x');
    80005d08:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d0a:	00003b97          	auipc	s7,0x3
    80005d0e:	c56b8b93          	addi	s7,s7,-938 # 80008960 <digits>
    switch(c){
    80005d12:	07300c93          	li	s9,115
    80005d16:	06400c13          	li	s8,100
    80005d1a:	a82d                	j	80005d54 <printf+0xa8>
    acquire(&pr.lock);
    80005d1c:	0001c517          	auipc	a0,0x1c
    80005d20:	34c50513          	addi	a0,a0,844 # 80022068 <pr>
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	488080e7          	jalr	1160(ra) # 800061ac <acquire>
    80005d2c:	bf7d                	j	80005cea <printf+0x3e>
    panic("null fmt");
    80005d2e:	00003517          	auipc	a0,0x3
    80005d32:	c1a50513          	addi	a0,a0,-998 # 80008948 <syscall_names+0x400>
    80005d36:	00000097          	auipc	ra,0x0
    80005d3a:	f2c080e7          	jalr	-212(ra) # 80005c62 <panic>
      consputc(c);
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	c62080e7          	jalr	-926(ra) # 800059a0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d46:	2485                	addiw	s1,s1,1
    80005d48:	009a07b3          	add	a5,s4,s1
    80005d4c:	0007c503          	lbu	a0,0(a5)
    80005d50:	10050763          	beqz	a0,80005e5e <printf+0x1b2>
    if(c != '%'){
    80005d54:	ff5515e3          	bne	a0,s5,80005d3e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d58:	2485                	addiw	s1,s1,1
    80005d5a:	009a07b3          	add	a5,s4,s1
    80005d5e:	0007c783          	lbu	a5,0(a5)
    80005d62:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d66:	cfe5                	beqz	a5,80005e5e <printf+0x1b2>
    switch(c){
    80005d68:	05678a63          	beq	a5,s6,80005dbc <printf+0x110>
    80005d6c:	02fb7663          	bgeu	s6,a5,80005d98 <printf+0xec>
    80005d70:	09978963          	beq	a5,s9,80005e02 <printf+0x156>
    80005d74:	07800713          	li	a4,120
    80005d78:	0ce79863          	bne	a5,a4,80005e48 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d7c:	f8843783          	ld	a5,-120(s0)
    80005d80:	00878713          	addi	a4,a5,8
    80005d84:	f8e43423          	sd	a4,-120(s0)
    80005d88:	4605                	li	a2,1
    80005d8a:	85ea                	mv	a1,s10
    80005d8c:	4388                	lw	a0,0(a5)
    80005d8e:	00000097          	auipc	ra,0x0
    80005d92:	e32080e7          	jalr	-462(ra) # 80005bc0 <printint>
      break;
    80005d96:	bf45                	j	80005d46 <printf+0x9a>
    switch(c){
    80005d98:	0b578263          	beq	a5,s5,80005e3c <printf+0x190>
    80005d9c:	0b879663          	bne	a5,s8,80005e48 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005da0:	f8843783          	ld	a5,-120(s0)
    80005da4:	00878713          	addi	a4,a5,8
    80005da8:	f8e43423          	sd	a4,-120(s0)
    80005dac:	4605                	li	a2,1
    80005dae:	45a9                	li	a1,10
    80005db0:	4388                	lw	a0,0(a5)
    80005db2:	00000097          	auipc	ra,0x0
    80005db6:	e0e080e7          	jalr	-498(ra) # 80005bc0 <printint>
      break;
    80005dba:	b771                	j	80005d46 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dbc:	f8843783          	ld	a5,-120(s0)
    80005dc0:	00878713          	addi	a4,a5,8
    80005dc4:	f8e43423          	sd	a4,-120(s0)
    80005dc8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005dcc:	03000513          	li	a0,48
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	bd0080e7          	jalr	-1072(ra) # 800059a0 <consputc>
  consputc('x');
    80005dd8:	07800513          	li	a0,120
    80005ddc:	00000097          	auipc	ra,0x0
    80005de0:	bc4080e7          	jalr	-1084(ra) # 800059a0 <consputc>
    80005de4:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005de6:	03c9d793          	srli	a5,s3,0x3c
    80005dea:	97de                	add	a5,a5,s7
    80005dec:	0007c503          	lbu	a0,0(a5)
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	bb0080e7          	jalr	-1104(ra) # 800059a0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005df8:	0992                	slli	s3,s3,0x4
    80005dfa:	397d                	addiw	s2,s2,-1
    80005dfc:	fe0915e3          	bnez	s2,80005de6 <printf+0x13a>
    80005e00:	b799                	j	80005d46 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e02:	f8843783          	ld	a5,-120(s0)
    80005e06:	00878713          	addi	a4,a5,8
    80005e0a:	f8e43423          	sd	a4,-120(s0)
    80005e0e:	0007b903          	ld	s2,0(a5)
    80005e12:	00090e63          	beqz	s2,80005e2e <printf+0x182>
      for(; *s; s++)
    80005e16:	00094503          	lbu	a0,0(s2)
    80005e1a:	d515                	beqz	a0,80005d46 <printf+0x9a>
        consputc(*s);
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	b84080e7          	jalr	-1148(ra) # 800059a0 <consputc>
      for(; *s; s++)
    80005e24:	0905                	addi	s2,s2,1
    80005e26:	00094503          	lbu	a0,0(s2)
    80005e2a:	f96d                	bnez	a0,80005e1c <printf+0x170>
    80005e2c:	bf29                	j	80005d46 <printf+0x9a>
        s = "(null)";
    80005e2e:	00003917          	auipc	s2,0x3
    80005e32:	b1290913          	addi	s2,s2,-1262 # 80008940 <syscall_names+0x3f8>
      for(; *s; s++)
    80005e36:	02800513          	li	a0,40
    80005e3a:	b7cd                	j	80005e1c <printf+0x170>
      consputc('%');
    80005e3c:	8556                	mv	a0,s5
    80005e3e:	00000097          	auipc	ra,0x0
    80005e42:	b62080e7          	jalr	-1182(ra) # 800059a0 <consputc>
      break;
    80005e46:	b701                	j	80005d46 <printf+0x9a>
      consputc('%');
    80005e48:	8556                	mv	a0,s5
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	b56080e7          	jalr	-1194(ra) # 800059a0 <consputc>
      consputc(c);
    80005e52:	854a                	mv	a0,s2
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	b4c080e7          	jalr	-1204(ra) # 800059a0 <consputc>
      break;
    80005e5c:	b5ed                	j	80005d46 <printf+0x9a>
  if(locking)
    80005e5e:	020d9163          	bnez	s11,80005e80 <printf+0x1d4>
}
    80005e62:	70e6                	ld	ra,120(sp)
    80005e64:	7446                	ld	s0,112(sp)
    80005e66:	74a6                	ld	s1,104(sp)
    80005e68:	7906                	ld	s2,96(sp)
    80005e6a:	69e6                	ld	s3,88(sp)
    80005e6c:	6a46                	ld	s4,80(sp)
    80005e6e:	6aa6                	ld	s5,72(sp)
    80005e70:	6b06                	ld	s6,64(sp)
    80005e72:	7be2                	ld	s7,56(sp)
    80005e74:	7c42                	ld	s8,48(sp)
    80005e76:	7ca2                	ld	s9,40(sp)
    80005e78:	7d02                	ld	s10,32(sp)
    80005e7a:	6de2                	ld	s11,24(sp)
    80005e7c:	6129                	addi	sp,sp,192
    80005e7e:	8082                	ret
    release(&pr.lock);
    80005e80:	0001c517          	auipc	a0,0x1c
    80005e84:	1e850513          	addi	a0,a0,488 # 80022068 <pr>
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	3d8080e7          	jalr	984(ra) # 80006260 <release>
}
    80005e90:	bfc9                	j	80005e62 <printf+0x1b6>

0000000080005e92 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e92:	1101                	addi	sp,sp,-32
    80005e94:	ec06                	sd	ra,24(sp)
    80005e96:	e822                	sd	s0,16(sp)
    80005e98:	e426                	sd	s1,8(sp)
    80005e9a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e9c:	0001c497          	auipc	s1,0x1c
    80005ea0:	1cc48493          	addi	s1,s1,460 # 80022068 <pr>
    80005ea4:	00003597          	auipc	a1,0x3
    80005ea8:	ab458593          	addi	a1,a1,-1356 # 80008958 <syscall_names+0x410>
    80005eac:	8526                	mv	a0,s1
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	26e080e7          	jalr	622(ra) # 8000611c <initlock>
  pr.locking = 1;
    80005eb6:	4785                	li	a5,1
    80005eb8:	cc9c                	sw	a5,24(s1)
}
    80005eba:	60e2                	ld	ra,24(sp)
    80005ebc:	6442                	ld	s0,16(sp)
    80005ebe:	64a2                	ld	s1,8(sp)
    80005ec0:	6105                	addi	sp,sp,32
    80005ec2:	8082                	ret

0000000080005ec4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ec4:	1141                	addi	sp,sp,-16
    80005ec6:	e406                	sd	ra,8(sp)
    80005ec8:	e022                	sd	s0,0(sp)
    80005eca:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ecc:	100007b7          	lui	a5,0x10000
    80005ed0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ed4:	f8000713          	li	a4,-128
    80005ed8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005edc:	470d                	li	a4,3
    80005ede:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ee2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ee6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005eea:	469d                	li	a3,7
    80005eec:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ef0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ef4:	00003597          	auipc	a1,0x3
    80005ef8:	a8458593          	addi	a1,a1,-1404 # 80008978 <digits+0x18>
    80005efc:	0001c517          	auipc	a0,0x1c
    80005f00:	18c50513          	addi	a0,a0,396 # 80022088 <uart_tx_lock>
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	218080e7          	jalr	536(ra) # 8000611c <initlock>
}
    80005f0c:	60a2                	ld	ra,8(sp)
    80005f0e:	6402                	ld	s0,0(sp)
    80005f10:	0141                	addi	sp,sp,16
    80005f12:	8082                	ret

0000000080005f14 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f14:	1101                	addi	sp,sp,-32
    80005f16:	ec06                	sd	ra,24(sp)
    80005f18:	e822                	sd	s0,16(sp)
    80005f1a:	e426                	sd	s1,8(sp)
    80005f1c:	1000                	addi	s0,sp,32
    80005f1e:	84aa                	mv	s1,a0
  push_off();
    80005f20:	00000097          	auipc	ra,0x0
    80005f24:	240080e7          	jalr	576(ra) # 80006160 <push_off>

  if(panicked){
    80005f28:	00003797          	auipc	a5,0x3
    80005f2c:	b147a783          	lw	a5,-1260(a5) # 80008a3c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f30:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f34:	c391                	beqz	a5,80005f38 <uartputc_sync+0x24>
    for(;;)
    80005f36:	a001                	j	80005f36 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f38:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f3c:	0ff7f793          	andi	a5,a5,255
    80005f40:	0207f793          	andi	a5,a5,32
    80005f44:	dbf5                	beqz	a5,80005f38 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f46:	0ff4f793          	andi	a5,s1,255
    80005f4a:	10000737          	lui	a4,0x10000
    80005f4e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	2ae080e7          	jalr	686(ra) # 80006200 <pop_off>
}
    80005f5a:	60e2                	ld	ra,24(sp)
    80005f5c:	6442                	ld	s0,16(sp)
    80005f5e:	64a2                	ld	s1,8(sp)
    80005f60:	6105                	addi	sp,sp,32
    80005f62:	8082                	ret

0000000080005f64 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f64:	00003717          	auipc	a4,0x3
    80005f68:	adc73703          	ld	a4,-1316(a4) # 80008a40 <uart_tx_r>
    80005f6c:	00003797          	auipc	a5,0x3
    80005f70:	adc7b783          	ld	a5,-1316(a5) # 80008a48 <uart_tx_w>
    80005f74:	06e78c63          	beq	a5,a4,80005fec <uartstart+0x88>
{
    80005f78:	7139                	addi	sp,sp,-64
    80005f7a:	fc06                	sd	ra,56(sp)
    80005f7c:	f822                	sd	s0,48(sp)
    80005f7e:	f426                	sd	s1,40(sp)
    80005f80:	f04a                	sd	s2,32(sp)
    80005f82:	ec4e                	sd	s3,24(sp)
    80005f84:	e852                	sd	s4,16(sp)
    80005f86:	e456                	sd	s5,8(sp)
    80005f88:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f8a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f8e:	0001ca17          	auipc	s4,0x1c
    80005f92:	0faa0a13          	addi	s4,s4,250 # 80022088 <uart_tx_lock>
    uart_tx_r += 1;
    80005f96:	00003497          	auipc	s1,0x3
    80005f9a:	aaa48493          	addi	s1,s1,-1366 # 80008a40 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f9e:	00003997          	auipc	s3,0x3
    80005fa2:	aaa98993          	addi	s3,s3,-1366 # 80008a48 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fa6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005faa:	0ff7f793          	andi	a5,a5,255
    80005fae:	0207f793          	andi	a5,a5,32
    80005fb2:	c785                	beqz	a5,80005fda <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fb4:	01f77793          	andi	a5,a4,31
    80005fb8:	97d2                	add	a5,a5,s4
    80005fba:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005fbe:	0705                	addi	a4,a4,1
    80005fc0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fc2:	8526                	mv	a0,s1
    80005fc4:	ffffb097          	auipc	ra,0xffffb
    80005fc8:	5a8080e7          	jalr	1448(ra) # 8000156c <wakeup>
    
    WriteReg(THR, c);
    80005fcc:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fd0:	6098                	ld	a4,0(s1)
    80005fd2:	0009b783          	ld	a5,0(s3)
    80005fd6:	fce798e3          	bne	a5,a4,80005fa6 <uartstart+0x42>
  }
}
    80005fda:	70e2                	ld	ra,56(sp)
    80005fdc:	7442                	ld	s0,48(sp)
    80005fde:	74a2                	ld	s1,40(sp)
    80005fe0:	7902                	ld	s2,32(sp)
    80005fe2:	69e2                	ld	s3,24(sp)
    80005fe4:	6a42                	ld	s4,16(sp)
    80005fe6:	6aa2                	ld	s5,8(sp)
    80005fe8:	6121                	addi	sp,sp,64
    80005fea:	8082                	ret
    80005fec:	8082                	ret

0000000080005fee <uartputc>:
{
    80005fee:	7179                	addi	sp,sp,-48
    80005ff0:	f406                	sd	ra,40(sp)
    80005ff2:	f022                	sd	s0,32(sp)
    80005ff4:	ec26                	sd	s1,24(sp)
    80005ff6:	e84a                	sd	s2,16(sp)
    80005ff8:	e44e                	sd	s3,8(sp)
    80005ffa:	e052                	sd	s4,0(sp)
    80005ffc:	1800                	addi	s0,sp,48
    80005ffe:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006000:	0001c517          	auipc	a0,0x1c
    80006004:	08850513          	addi	a0,a0,136 # 80022088 <uart_tx_lock>
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	1a4080e7          	jalr	420(ra) # 800061ac <acquire>
  if(panicked){
    80006010:	00003797          	auipc	a5,0x3
    80006014:	a2c7a783          	lw	a5,-1492(a5) # 80008a3c <panicked>
    80006018:	e7c9                	bnez	a5,800060a2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000601a:	00003797          	auipc	a5,0x3
    8000601e:	a2e7b783          	ld	a5,-1490(a5) # 80008a48 <uart_tx_w>
    80006022:	00003717          	auipc	a4,0x3
    80006026:	a1e73703          	ld	a4,-1506(a4) # 80008a40 <uart_tx_r>
    8000602a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000602e:	0001ca17          	auipc	s4,0x1c
    80006032:	05aa0a13          	addi	s4,s4,90 # 80022088 <uart_tx_lock>
    80006036:	00003497          	auipc	s1,0x3
    8000603a:	a0a48493          	addi	s1,s1,-1526 # 80008a40 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000603e:	00003917          	auipc	s2,0x3
    80006042:	a0a90913          	addi	s2,s2,-1526 # 80008a48 <uart_tx_w>
    80006046:	00f71f63          	bne	a4,a5,80006064 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000604a:	85d2                	mv	a1,s4
    8000604c:	8526                	mv	a0,s1
    8000604e:	ffffb097          	auipc	ra,0xffffb
    80006052:	4ba080e7          	jalr	1210(ra) # 80001508 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006056:	00093783          	ld	a5,0(s2)
    8000605a:	6098                	ld	a4,0(s1)
    8000605c:	02070713          	addi	a4,a4,32
    80006060:	fef705e3          	beq	a4,a5,8000604a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006064:	0001c497          	auipc	s1,0x1c
    80006068:	02448493          	addi	s1,s1,36 # 80022088 <uart_tx_lock>
    8000606c:	01f7f713          	andi	a4,a5,31
    80006070:	9726                	add	a4,a4,s1
    80006072:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006076:	0785                	addi	a5,a5,1
    80006078:	00003717          	auipc	a4,0x3
    8000607c:	9cf73823          	sd	a5,-1584(a4) # 80008a48 <uart_tx_w>
  uartstart();
    80006080:	00000097          	auipc	ra,0x0
    80006084:	ee4080e7          	jalr	-284(ra) # 80005f64 <uartstart>
  release(&uart_tx_lock);
    80006088:	8526                	mv	a0,s1
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	1d6080e7          	jalr	470(ra) # 80006260 <release>
}
    80006092:	70a2                	ld	ra,40(sp)
    80006094:	7402                	ld	s0,32(sp)
    80006096:	64e2                	ld	s1,24(sp)
    80006098:	6942                	ld	s2,16(sp)
    8000609a:	69a2                	ld	s3,8(sp)
    8000609c:	6a02                	ld	s4,0(sp)
    8000609e:	6145                	addi	sp,sp,48
    800060a0:	8082                	ret
    for(;;)
    800060a2:	a001                	j	800060a2 <uartputc+0xb4>

00000000800060a4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060a4:	1141                	addi	sp,sp,-16
    800060a6:	e422                	sd	s0,8(sp)
    800060a8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060aa:	100007b7          	lui	a5,0x10000
    800060ae:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060b2:	8b85                	andi	a5,a5,1
    800060b4:	cb91                	beqz	a5,800060c8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060b6:	100007b7          	lui	a5,0x10000
    800060ba:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060be:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060c2:	6422                	ld	s0,8(sp)
    800060c4:	0141                	addi	sp,sp,16
    800060c6:	8082                	ret
    return -1;
    800060c8:	557d                	li	a0,-1
    800060ca:	bfe5                	j	800060c2 <uartgetc+0x1e>

00000000800060cc <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060cc:	1101                	addi	sp,sp,-32
    800060ce:	ec06                	sd	ra,24(sp)
    800060d0:	e822                	sd	s0,16(sp)
    800060d2:	e426                	sd	s1,8(sp)
    800060d4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060d6:	54fd                	li	s1,-1
    int c = uartgetc();
    800060d8:	00000097          	auipc	ra,0x0
    800060dc:	fcc080e7          	jalr	-52(ra) # 800060a4 <uartgetc>
    if(c == -1)
    800060e0:	00950763          	beq	a0,s1,800060ee <uartintr+0x22>
      break;
    consoleintr(c);
    800060e4:	00000097          	auipc	ra,0x0
    800060e8:	8fe080e7          	jalr	-1794(ra) # 800059e2 <consoleintr>
  while(1){
    800060ec:	b7f5                	j	800060d8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060ee:	0001c497          	auipc	s1,0x1c
    800060f2:	f9a48493          	addi	s1,s1,-102 # 80022088 <uart_tx_lock>
    800060f6:	8526                	mv	a0,s1
    800060f8:	00000097          	auipc	ra,0x0
    800060fc:	0b4080e7          	jalr	180(ra) # 800061ac <acquire>
  uartstart();
    80006100:	00000097          	auipc	ra,0x0
    80006104:	e64080e7          	jalr	-412(ra) # 80005f64 <uartstart>
  release(&uart_tx_lock);
    80006108:	8526                	mv	a0,s1
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	156080e7          	jalr	342(ra) # 80006260 <release>
}
    80006112:	60e2                	ld	ra,24(sp)
    80006114:	6442                	ld	s0,16(sp)
    80006116:	64a2                	ld	s1,8(sp)
    80006118:	6105                	addi	sp,sp,32
    8000611a:	8082                	ret

000000008000611c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000611c:	1141                	addi	sp,sp,-16
    8000611e:	e422                	sd	s0,8(sp)
    80006120:	0800                	addi	s0,sp,16
  lk->name = name;
    80006122:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006124:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006128:	00053823          	sd	zero,16(a0)
}
    8000612c:	6422                	ld	s0,8(sp)
    8000612e:	0141                	addi	sp,sp,16
    80006130:	8082                	ret

0000000080006132 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006132:	411c                	lw	a5,0(a0)
    80006134:	e399                	bnez	a5,8000613a <holding+0x8>
    80006136:	4501                	li	a0,0
  return r;
}
    80006138:	8082                	ret
{
    8000613a:	1101                	addi	sp,sp,-32
    8000613c:	ec06                	sd	ra,24(sp)
    8000613e:	e822                	sd	s0,16(sp)
    80006140:	e426                	sd	s1,8(sp)
    80006142:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006144:	6904                	ld	s1,16(a0)
    80006146:	ffffb097          	auipc	ra,0xffffb
    8000614a:	cf6080e7          	jalr	-778(ra) # 80000e3c <mycpu>
    8000614e:	40a48533          	sub	a0,s1,a0
    80006152:	00153513          	seqz	a0,a0
}
    80006156:	60e2                	ld	ra,24(sp)
    80006158:	6442                	ld	s0,16(sp)
    8000615a:	64a2                	ld	s1,8(sp)
    8000615c:	6105                	addi	sp,sp,32
    8000615e:	8082                	ret

0000000080006160 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006160:	1101                	addi	sp,sp,-32
    80006162:	ec06                	sd	ra,24(sp)
    80006164:	e822                	sd	s0,16(sp)
    80006166:	e426                	sd	s1,8(sp)
    80006168:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000616a:	100024f3          	csrr	s1,sstatus
    8000616e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006172:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006174:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006178:	ffffb097          	auipc	ra,0xffffb
    8000617c:	cc4080e7          	jalr	-828(ra) # 80000e3c <mycpu>
    80006180:	5d3c                	lw	a5,120(a0)
    80006182:	cf89                	beqz	a5,8000619c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006184:	ffffb097          	auipc	ra,0xffffb
    80006188:	cb8080e7          	jalr	-840(ra) # 80000e3c <mycpu>
    8000618c:	5d3c                	lw	a5,120(a0)
    8000618e:	2785                	addiw	a5,a5,1
    80006190:	dd3c                	sw	a5,120(a0)
}
    80006192:	60e2                	ld	ra,24(sp)
    80006194:	6442                	ld	s0,16(sp)
    80006196:	64a2                	ld	s1,8(sp)
    80006198:	6105                	addi	sp,sp,32
    8000619a:	8082                	ret
    mycpu()->intena = old;
    8000619c:	ffffb097          	auipc	ra,0xffffb
    800061a0:	ca0080e7          	jalr	-864(ra) # 80000e3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061a4:	8085                	srli	s1,s1,0x1
    800061a6:	8885                	andi	s1,s1,1
    800061a8:	dd64                	sw	s1,124(a0)
    800061aa:	bfe9                	j	80006184 <push_off+0x24>

00000000800061ac <acquire>:
{
    800061ac:	1101                	addi	sp,sp,-32
    800061ae:	ec06                	sd	ra,24(sp)
    800061b0:	e822                	sd	s0,16(sp)
    800061b2:	e426                	sd	s1,8(sp)
    800061b4:	1000                	addi	s0,sp,32
    800061b6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	fa8080e7          	jalr	-88(ra) # 80006160 <push_off>
  if(holding(lk))
    800061c0:	8526                	mv	a0,s1
    800061c2:	00000097          	auipc	ra,0x0
    800061c6:	f70080e7          	jalr	-144(ra) # 80006132 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ca:	4705                	li	a4,1
  if(holding(lk))
    800061cc:	e115                	bnez	a0,800061f0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061ce:	87ba                	mv	a5,a4
    800061d0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061d4:	2781                	sext.w	a5,a5
    800061d6:	ffe5                	bnez	a5,800061ce <acquire+0x22>
  __sync_synchronize();
    800061d8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061dc:	ffffb097          	auipc	ra,0xffffb
    800061e0:	c60080e7          	jalr	-928(ra) # 80000e3c <mycpu>
    800061e4:	e888                	sd	a0,16(s1)
}
    800061e6:	60e2                	ld	ra,24(sp)
    800061e8:	6442                	ld	s0,16(sp)
    800061ea:	64a2                	ld	s1,8(sp)
    800061ec:	6105                	addi	sp,sp,32
    800061ee:	8082                	ret
    panic("acquire");
    800061f0:	00002517          	auipc	a0,0x2
    800061f4:	79050513          	addi	a0,a0,1936 # 80008980 <digits+0x20>
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	a6a080e7          	jalr	-1430(ra) # 80005c62 <panic>

0000000080006200 <pop_off>:

void
pop_off(void)
{
    80006200:	1141                	addi	sp,sp,-16
    80006202:	e406                	sd	ra,8(sp)
    80006204:	e022                	sd	s0,0(sp)
    80006206:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006208:	ffffb097          	auipc	ra,0xffffb
    8000620c:	c34080e7          	jalr	-972(ra) # 80000e3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006210:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006214:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006216:	e78d                	bnez	a5,80006240 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006218:	5d3c                	lw	a5,120(a0)
    8000621a:	02f05b63          	blez	a5,80006250 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000621e:	37fd                	addiw	a5,a5,-1
    80006220:	0007871b          	sext.w	a4,a5
    80006224:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006226:	eb09                	bnez	a4,80006238 <pop_off+0x38>
    80006228:	5d7c                	lw	a5,124(a0)
    8000622a:	c799                	beqz	a5,80006238 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000622c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006230:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006234:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006238:	60a2                	ld	ra,8(sp)
    8000623a:	6402                	ld	s0,0(sp)
    8000623c:	0141                	addi	sp,sp,16
    8000623e:	8082                	ret
    panic("pop_off - interruptible");
    80006240:	00002517          	auipc	a0,0x2
    80006244:	74850513          	addi	a0,a0,1864 # 80008988 <digits+0x28>
    80006248:	00000097          	auipc	ra,0x0
    8000624c:	a1a080e7          	jalr	-1510(ra) # 80005c62 <panic>
    panic("pop_off");
    80006250:	00002517          	auipc	a0,0x2
    80006254:	75050513          	addi	a0,a0,1872 # 800089a0 <digits+0x40>
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	a0a080e7          	jalr	-1526(ra) # 80005c62 <panic>

0000000080006260 <release>:
{
    80006260:	1101                	addi	sp,sp,-32
    80006262:	ec06                	sd	ra,24(sp)
    80006264:	e822                	sd	s0,16(sp)
    80006266:	e426                	sd	s1,8(sp)
    80006268:	1000                	addi	s0,sp,32
    8000626a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000626c:	00000097          	auipc	ra,0x0
    80006270:	ec6080e7          	jalr	-314(ra) # 80006132 <holding>
    80006274:	c115                	beqz	a0,80006298 <release+0x38>
  lk->cpu = 0;
    80006276:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000627a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000627e:	0f50000f          	fence	iorw,ow
    80006282:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006286:	00000097          	auipc	ra,0x0
    8000628a:	f7a080e7          	jalr	-134(ra) # 80006200 <pop_off>
}
    8000628e:	60e2                	ld	ra,24(sp)
    80006290:	6442                	ld	s0,16(sp)
    80006292:	64a2                	ld	s1,8(sp)
    80006294:	6105                	addi	sp,sp,32
    80006296:	8082                	ret
    panic("release");
    80006298:	00002517          	auipc	a0,0x2
    8000629c:	71050513          	addi	a0,a0,1808 # 800089a8 <digits+0x48>
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	9c2080e7          	jalr	-1598(ra) # 80005c62 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
