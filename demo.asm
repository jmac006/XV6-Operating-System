
_demo:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
{
   test(n+1);
   return n;
}
int main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp
   int pid=0;
   pid=fork();
    1009:	e8 5c 02 00 00       	call   126a <fork>
   if(pid==0){
    100e:	85 c0                	test   %eax,%eax
    1010:	75 11                	jne    1023 <main+0x23>
#include "stat.h"
#include "user.h"

int test(int n)
{
   test(n+1);
    1012:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
    1019:	e8 12 00 00 00       	call   1030 <test>
   pid=fork();
   if(pid==0){
   //int x=1;
  // printf(1, "address %x\n", &x);
   test(1);
   exit();
    101e:	e8 4f 02 00 00       	call   1272 <exit>
   }
   wait();
    1023:	e8 52 02 00 00       	call   127a <wait>
   exit();
    1028:	e8 45 02 00 00       	call   1272 <exit>
    102d:	66 90                	xchg   %ax,%ax
    102f:	90                   	nop

00001030 <test>:
#include "types.h"
#include "stat.h"
#include "user.h"

int test(int n)
{
    1030:	55                   	push   %ebp
    1031:	89 e5                	mov    %esp,%ebp
    1033:	53                   	push   %ebx
    1034:	83 ec 14             	sub    $0x14,%esp
    1037:	8b 5d 08             	mov    0x8(%ebp),%ebx
   test(n+1);
    103a:	8d 43 01             	lea    0x1(%ebx),%eax
    103d:	89 04 24             	mov    %eax,(%esp)
    1040:	e8 eb ff ff ff       	call   1030 <test>
   return n;
}
    1045:	83 c4 14             	add    $0x14,%esp
    1048:	89 d8                	mov    %ebx,%eax
    104a:	5b                   	pop    %ebx
    104b:	5d                   	pop    %ebp
    104c:	c3                   	ret    
    104d:	66 90                	xchg   %ax,%ax
    104f:	90                   	nop

00001050 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1050:	55                   	push   %ebp
    1051:	89 e5                	mov    %esp,%ebp
    1053:	8b 45 08             	mov    0x8(%ebp),%eax
    1056:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1059:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    105a:	89 c2                	mov    %eax,%edx
    105c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1060:	83 c1 01             	add    $0x1,%ecx
    1063:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1067:	83 c2 01             	add    $0x1,%edx
    106a:	84 db                	test   %bl,%bl
    106c:	88 5a ff             	mov    %bl,-0x1(%edx)
    106f:	75 ef                	jne    1060 <strcpy+0x10>
    ;
  return os;
}
    1071:	5b                   	pop    %ebx
    1072:	5d                   	pop    %ebp
    1073:	c3                   	ret    
    1074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    107a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1080:	55                   	push   %ebp
    1081:	89 e5                	mov    %esp,%ebp
    1083:	8b 55 08             	mov    0x8(%ebp),%edx
    1086:	53                   	push   %ebx
    1087:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    108a:	0f b6 02             	movzbl (%edx),%eax
    108d:	84 c0                	test   %al,%al
    108f:	74 2d                	je     10be <strcmp+0x3e>
    1091:	0f b6 19             	movzbl (%ecx),%ebx
    1094:	38 d8                	cmp    %bl,%al
    1096:	74 0e                	je     10a6 <strcmp+0x26>
    1098:	eb 2b                	jmp    10c5 <strcmp+0x45>
    109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10a0:	38 c8                	cmp    %cl,%al
    10a2:	75 15                	jne    10b9 <strcmp+0x39>
    p++, q++;
    10a4:	89 d9                	mov    %ebx,%ecx
    10a6:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10a9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    10ac:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10af:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
    10b3:	84 c0                	test   %al,%al
    10b5:	75 e9                	jne    10a0 <strcmp+0x20>
    10b7:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10b9:	29 c8                	sub    %ecx,%eax
}
    10bb:	5b                   	pop    %ebx
    10bc:	5d                   	pop    %ebp
    10bd:	c3                   	ret    
    10be:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10c1:	31 c0                	xor    %eax,%eax
    10c3:	eb f4                	jmp    10b9 <strcmp+0x39>
    10c5:	0f b6 cb             	movzbl %bl,%ecx
    10c8:	eb ef                	jmp    10b9 <strcmp+0x39>
    10ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000010d0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(char *s)
{
    10d0:	55                   	push   %ebp
    10d1:	89 e5                	mov    %esp,%ebp
    10d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    10d6:	80 39 00             	cmpb   $0x0,(%ecx)
    10d9:	74 12                	je     10ed <strlen+0x1d>
    10db:	31 d2                	xor    %edx,%edx
    10dd:	8d 76 00             	lea    0x0(%esi),%esi
    10e0:	83 c2 01             	add    $0x1,%edx
    10e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    10e7:	89 d0                	mov    %edx,%eax
    10e9:	75 f5                	jne    10e0 <strlen+0x10>
    ;
  return n;
}
    10eb:	5d                   	pop    %ebp
    10ec:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    10ed:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
    10ef:	5d                   	pop    %ebp
    10f0:	c3                   	ret    
    10f1:	eb 0d                	jmp    1100 <memset>
    10f3:	90                   	nop
    10f4:	90                   	nop
    10f5:	90                   	nop
    10f6:	90                   	nop
    10f7:	90                   	nop
    10f8:	90                   	nop
    10f9:	90                   	nop
    10fa:	90                   	nop
    10fb:	90                   	nop
    10fc:	90                   	nop
    10fd:	90                   	nop
    10fe:	90                   	nop
    10ff:	90                   	nop

00001100 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	8b 55 08             	mov    0x8(%ebp),%edx
    1106:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1107:	8b 4d 10             	mov    0x10(%ebp),%ecx
    110a:	8b 45 0c             	mov    0xc(%ebp),%eax
    110d:	89 d7                	mov    %edx,%edi
    110f:	fc                   	cld    
    1110:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1112:	89 d0                	mov    %edx,%eax
    1114:	5f                   	pop    %edi
    1115:	5d                   	pop    %ebp
    1116:	c3                   	ret    
    1117:	89 f6                	mov    %esi,%esi
    1119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001120 <strchr>:

char*
strchr(const char *s, char c)
{
    1120:	55                   	push   %ebp
    1121:	89 e5                	mov    %esp,%ebp
    1123:	8b 45 08             	mov    0x8(%ebp),%eax
    1126:	53                   	push   %ebx
    1127:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
    112a:	0f b6 18             	movzbl (%eax),%ebx
    112d:	84 db                	test   %bl,%bl
    112f:	74 1d                	je     114e <strchr+0x2e>
    if(*s == c)
    1131:	38 d3                	cmp    %dl,%bl
    1133:	89 d1                	mov    %edx,%ecx
    1135:	75 0d                	jne    1144 <strchr+0x24>
    1137:	eb 17                	jmp    1150 <strchr+0x30>
    1139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1140:	38 ca                	cmp    %cl,%dl
    1142:	74 0c                	je     1150 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1144:	83 c0 01             	add    $0x1,%eax
    1147:	0f b6 10             	movzbl (%eax),%edx
    114a:	84 d2                	test   %dl,%dl
    114c:	75 f2                	jne    1140 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
    114e:	31 c0                	xor    %eax,%eax
}
    1150:	5b                   	pop    %ebx
    1151:	5d                   	pop    %ebp
    1152:	c3                   	ret    
    1153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001160 <gets>:

char*
gets(char *buf, int max)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	57                   	push   %edi
    1164:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1165:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
    1167:	53                   	push   %ebx
    1168:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    116b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    116e:	eb 31                	jmp    11a1 <gets+0x41>
    cc = read(0, &c, 1);
    1170:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1177:	00 
    1178:	89 7c 24 04          	mov    %edi,0x4(%esp)
    117c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1183:	e8 02 01 00 00       	call   128a <read>
    if(cc < 1)
    1188:	85 c0                	test   %eax,%eax
    118a:	7e 1d                	jle    11a9 <gets+0x49>
      break;
    buf[i++] = c;
    118c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1190:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1192:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
    1195:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    1197:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
    119b:	74 0c                	je     11a9 <gets+0x49>
    119d:	3c 0a                	cmp    $0xa,%al
    119f:	74 08                	je     11a9 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a1:	8d 5e 01             	lea    0x1(%esi),%ebx
    11a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    11a7:	7c c7                	jl     1170 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11a9:	8b 45 08             	mov    0x8(%ebp),%eax
    11ac:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
    11b0:	83 c4 2c             	add    $0x2c,%esp
    11b3:	5b                   	pop    %ebx
    11b4:	5e                   	pop    %esi
    11b5:	5f                   	pop    %edi
    11b6:	5d                   	pop    %ebp
    11b7:	c3                   	ret    
    11b8:	90                   	nop
    11b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000011c0 <stat>:

int
stat(char *n, struct stat *st)
{
    11c0:	55                   	push   %ebp
    11c1:	89 e5                	mov    %esp,%ebp
    11c3:	56                   	push   %esi
    11c4:	53                   	push   %ebx
    11c5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11c8:	8b 45 08             	mov    0x8(%ebp),%eax
    11cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11d2:	00 
    11d3:	89 04 24             	mov    %eax,(%esp)
    11d6:	e8 d7 00 00 00       	call   12b2 <open>
  if(fd < 0)
    11db:	85 c0                	test   %eax,%eax
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11dd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
    11df:	78 27                	js     1208 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    11e1:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e4:	89 1c 24             	mov    %ebx,(%esp)
    11e7:	89 44 24 04          	mov    %eax,0x4(%esp)
    11eb:	e8 da 00 00 00       	call   12ca <fstat>
  close(fd);
    11f0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
    11f3:	89 c6                	mov    %eax,%esi
  close(fd);
    11f5:	e8 a0 00 00 00       	call   129a <close>
  return r;
    11fa:	89 f0                	mov    %esi,%eax
}
    11fc:	83 c4 10             	add    $0x10,%esp
    11ff:	5b                   	pop    %ebx
    1200:	5e                   	pop    %esi
    1201:	5d                   	pop    %ebp
    1202:	c3                   	ret    
    1203:	90                   	nop
    1204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
    1208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    120d:	eb ed                	jmp    11fc <stat+0x3c>
    120f:	90                   	nop

00001210 <atoi>:
  return r;
}

int
atoi(const char *s)
{
    1210:	55                   	push   %ebp
    1211:	89 e5                	mov    %esp,%ebp
    1213:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1216:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1217:	0f be 11             	movsbl (%ecx),%edx
    121a:	8d 42 d0             	lea    -0x30(%edx),%eax
    121d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
    121f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1224:	77 17                	ja     123d <atoi+0x2d>
    1226:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
    1228:	83 c1 01             	add    $0x1,%ecx
    122b:	8d 04 80             	lea    (%eax,%eax,4),%eax
    122e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1232:	0f be 11             	movsbl (%ecx),%edx
    1235:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1238:	80 fb 09             	cmp    $0x9,%bl
    123b:	76 eb                	jbe    1228 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
    123d:	5b                   	pop    %ebx
    123e:	5d                   	pop    %ebp
    123f:	c3                   	ret    

00001240 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1240:	55                   	push   %ebp
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1241:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
    1243:	89 e5                	mov    %esp,%ebp
    1245:	56                   	push   %esi
    1246:	8b 45 08             	mov    0x8(%ebp),%eax
    1249:	53                   	push   %ebx
    124a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    124d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1250:	85 db                	test   %ebx,%ebx
    1252:	7e 12                	jle    1266 <memmove+0x26>
    1254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1258:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    125c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    125f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1262:	39 da                	cmp    %ebx,%edx
    1264:	75 f2                	jne    1258 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
    1266:	5b                   	pop    %ebx
    1267:	5e                   	pop    %esi
    1268:	5d                   	pop    %ebp
    1269:	c3                   	ret    

0000126a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    126a:	b8 01 00 00 00       	mov    $0x1,%eax
    126f:	cd 40                	int    $0x40
    1271:	c3                   	ret    

00001272 <exit>:
SYSCALL(exit)
    1272:	b8 02 00 00 00       	mov    $0x2,%eax
    1277:	cd 40                	int    $0x40
    1279:	c3                   	ret    

0000127a <wait>:
SYSCALL(wait)
    127a:	b8 03 00 00 00       	mov    $0x3,%eax
    127f:	cd 40                	int    $0x40
    1281:	c3                   	ret    

00001282 <pipe>:
SYSCALL(pipe)
    1282:	b8 04 00 00 00       	mov    $0x4,%eax
    1287:	cd 40                	int    $0x40
    1289:	c3                   	ret    

0000128a <read>:
SYSCALL(read)
    128a:	b8 05 00 00 00       	mov    $0x5,%eax
    128f:	cd 40                	int    $0x40
    1291:	c3                   	ret    

00001292 <write>:
SYSCALL(write)
    1292:	b8 10 00 00 00       	mov    $0x10,%eax
    1297:	cd 40                	int    $0x40
    1299:	c3                   	ret    

0000129a <close>:
SYSCALL(close)
    129a:	b8 15 00 00 00       	mov    $0x15,%eax
    129f:	cd 40                	int    $0x40
    12a1:	c3                   	ret    

000012a2 <kill>:
SYSCALL(kill)
    12a2:	b8 06 00 00 00       	mov    $0x6,%eax
    12a7:	cd 40                	int    $0x40
    12a9:	c3                   	ret    

000012aa <exec>:
SYSCALL(exec)
    12aa:	b8 07 00 00 00       	mov    $0x7,%eax
    12af:	cd 40                	int    $0x40
    12b1:	c3                   	ret    

000012b2 <open>:
SYSCALL(open)
    12b2:	b8 0f 00 00 00       	mov    $0xf,%eax
    12b7:	cd 40                	int    $0x40
    12b9:	c3                   	ret    

000012ba <mknod>:
SYSCALL(mknod)
    12ba:	b8 11 00 00 00       	mov    $0x11,%eax
    12bf:	cd 40                	int    $0x40
    12c1:	c3                   	ret    

000012c2 <unlink>:
SYSCALL(unlink)
    12c2:	b8 12 00 00 00       	mov    $0x12,%eax
    12c7:	cd 40                	int    $0x40
    12c9:	c3                   	ret    

000012ca <fstat>:
SYSCALL(fstat)
    12ca:	b8 08 00 00 00       	mov    $0x8,%eax
    12cf:	cd 40                	int    $0x40
    12d1:	c3                   	ret    

000012d2 <link>:
SYSCALL(link)
    12d2:	b8 13 00 00 00       	mov    $0x13,%eax
    12d7:	cd 40                	int    $0x40
    12d9:	c3                   	ret    

000012da <mkdir>:
SYSCALL(mkdir)
    12da:	b8 14 00 00 00       	mov    $0x14,%eax
    12df:	cd 40                	int    $0x40
    12e1:	c3                   	ret    

000012e2 <chdir>:
SYSCALL(chdir)
    12e2:	b8 09 00 00 00       	mov    $0x9,%eax
    12e7:	cd 40                	int    $0x40
    12e9:	c3                   	ret    

000012ea <dup>:
SYSCALL(dup)
    12ea:	b8 0a 00 00 00       	mov    $0xa,%eax
    12ef:	cd 40                	int    $0x40
    12f1:	c3                   	ret    

000012f2 <getpid>:
SYSCALL(getpid)
    12f2:	b8 0b 00 00 00       	mov    $0xb,%eax
    12f7:	cd 40                	int    $0x40
    12f9:	c3                   	ret    

000012fa <sbrk>:
SYSCALL(sbrk)
    12fa:	b8 0c 00 00 00       	mov    $0xc,%eax
    12ff:	cd 40                	int    $0x40
    1301:	c3                   	ret    

00001302 <sleep>:
SYSCALL(sleep)
    1302:	b8 0d 00 00 00       	mov    $0xd,%eax
    1307:	cd 40                	int    $0x40
    1309:	c3                   	ret    

0000130a <uptime>:
SYSCALL(uptime)
    130a:	b8 0e 00 00 00       	mov    $0xe,%eax
    130f:	cd 40                	int    $0x40
    1311:	c3                   	ret    

00001312 <shm_open>:
SYSCALL(shm_open)
    1312:	b8 16 00 00 00       	mov    $0x16,%eax
    1317:	cd 40                	int    $0x40
    1319:	c3                   	ret    

0000131a <shm_close>:
SYSCALL(shm_close)	
    131a:	b8 17 00 00 00       	mov    $0x17,%eax
    131f:	cd 40                	int    $0x40
    1321:	c3                   	ret    
    1322:	66 90                	xchg   %ax,%ax
    1324:	66 90                	xchg   %ax,%ax
    1326:	66 90                	xchg   %ax,%ax
    1328:	66 90                	xchg   %ax,%ax
    132a:	66 90                	xchg   %ax,%ax
    132c:	66 90                	xchg   %ax,%ax
    132e:	66 90                	xchg   %ax,%ax

00001330 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1330:	55                   	push   %ebp
    1331:	89 e5                	mov    %esp,%ebp
    1333:	57                   	push   %edi
    1334:	56                   	push   %esi
    1335:	89 c6                	mov    %eax,%esi
    1337:	53                   	push   %ebx
    1338:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    133b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    133e:	85 db                	test   %ebx,%ebx
    1340:	74 09                	je     134b <printint+0x1b>
    1342:	89 d0                	mov    %edx,%eax
    1344:	c1 e8 1f             	shr    $0x1f,%eax
    1347:	84 c0                	test   %al,%al
    1349:	75 75                	jne    13c0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    134b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    134d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1354:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    1357:	31 ff                	xor    %edi,%edi
    1359:	89 ce                	mov    %ecx,%esi
    135b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    135e:	eb 02                	jmp    1362 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
    1360:	89 cf                	mov    %ecx,%edi
    1362:	31 d2                	xor    %edx,%edx
    1364:	f7 f6                	div    %esi
    1366:	8d 4f 01             	lea    0x1(%edi),%ecx
    1369:	0f b6 92 78 17 00 00 	movzbl 0x1778(%edx),%edx
  }while((x /= base) != 0);
    1370:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    1372:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
    1375:	75 e9                	jne    1360 <printint+0x30>
  if(neg)
    1377:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
    137a:	89 c8                	mov    %ecx,%eax
    137c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
    137f:	85 d2                	test   %edx,%edx
    1381:	74 08                	je     138b <printint+0x5b>
    buf[i++] = '-';
    1383:	8d 4f 02             	lea    0x2(%edi),%ecx
    1386:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
    138b:	8d 79 ff             	lea    -0x1(%ecx),%edi
    138e:	66 90                	xchg   %ax,%ax
    1390:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
    1395:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1398:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    139f:	00 
    13a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    13a4:	89 34 24             	mov    %esi,(%esp)
    13a7:	88 45 d7             	mov    %al,-0x29(%ebp)
    13aa:	e8 e3 fe ff ff       	call   1292 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    13af:	83 ff ff             	cmp    $0xffffffff,%edi
    13b2:	75 dc                	jne    1390 <printint+0x60>
    putc(fd, buf[i]);
}
    13b4:	83 c4 4c             	add    $0x4c,%esp
    13b7:	5b                   	pop    %ebx
    13b8:	5e                   	pop    %esi
    13b9:	5f                   	pop    %edi
    13ba:	5d                   	pop    %ebp
    13bb:	c3                   	ret    
    13bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    13c0:	89 d0                	mov    %edx,%eax
    13c2:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    13c4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    13cb:	eb 87                	jmp    1354 <printint+0x24>
    13cd:	8d 76 00             	lea    0x0(%esi),%esi

000013d0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    13d0:	55                   	push   %ebp
    13d1:	89 e5                	mov    %esp,%ebp
    13d3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    13d4:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    13d6:	56                   	push   %esi
    13d7:	53                   	push   %ebx
    13d8:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    13db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    13de:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    13e1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    13e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
    13e7:	0f b6 13             	movzbl (%ebx),%edx
    13ea:	83 c3 01             	add    $0x1,%ebx
    13ed:	84 d2                	test   %dl,%dl
    13ef:	75 39                	jne    142a <printf+0x5a>
    13f1:	e9 c2 00 00 00       	jmp    14b8 <printf+0xe8>
    13f6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    13f8:	83 fa 25             	cmp    $0x25,%edx
    13fb:	0f 84 bf 00 00 00    	je     14c0 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1401:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1404:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    140b:	00 
    140c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1410:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    1413:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1416:	e8 77 fe ff ff       	call   1292 <write>
    141b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    141e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    1422:	84 d2                	test   %dl,%dl
    1424:	0f 84 8e 00 00 00    	je     14b8 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
    142a:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    142c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
    142f:	74 c7                	je     13f8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1431:	83 ff 25             	cmp    $0x25,%edi
    1434:	75 e5                	jne    141b <printf+0x4b>
      if(c == 'd'){
    1436:	83 fa 64             	cmp    $0x64,%edx
    1439:	0f 84 31 01 00 00    	je     1570 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    143f:	25 f7 00 00 00       	and    $0xf7,%eax
    1444:	83 f8 70             	cmp    $0x70,%eax
    1447:	0f 84 83 00 00 00    	je     14d0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    144d:	83 fa 73             	cmp    $0x73,%edx
    1450:	0f 84 a2 00 00 00    	je     14f8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1456:	83 fa 63             	cmp    $0x63,%edx
    1459:	0f 84 35 01 00 00    	je     1594 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    145f:	83 fa 25             	cmp    $0x25,%edx
    1462:	0f 84 e0 00 00 00    	je     1548 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1468:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    146b:	83 c3 01             	add    $0x1,%ebx
    146e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1475:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1476:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1478:	89 44 24 04          	mov    %eax,0x4(%esp)
    147c:	89 34 24             	mov    %esi,(%esp)
    147f:	89 55 d0             	mov    %edx,-0x30(%ebp)
    1482:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
    1486:	e8 07 fe ff ff       	call   1292 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    148b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    148e:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1491:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1498:	00 
    1499:	89 44 24 04          	mov    %eax,0x4(%esp)
    149d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    14a0:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    14a3:	e8 ea fd ff ff       	call   1292 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    14a8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
    14ac:	84 d2                	test   %dl,%dl
    14ae:	0f 85 76 ff ff ff    	jne    142a <printf+0x5a>
    14b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    14b8:	83 c4 3c             	add    $0x3c,%esp
    14bb:	5b                   	pop    %ebx
    14bc:	5e                   	pop    %esi
    14bd:	5f                   	pop    %edi
    14be:	5d                   	pop    %ebp
    14bf:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    14c0:	bf 25 00 00 00       	mov    $0x25,%edi
    14c5:	e9 51 ff ff ff       	jmp    141b <printf+0x4b>
    14ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    14d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    14d3:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    14d8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
    14da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14e1:	8b 10                	mov    (%eax),%edx
    14e3:	89 f0                	mov    %esi,%eax
    14e5:	e8 46 fe ff ff       	call   1330 <printint>
        ap++;
    14ea:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    14ee:	e9 28 ff ff ff       	jmp    141b <printf+0x4b>
    14f3:	90                   	nop
    14f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
    14f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
    14fb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
    14ff:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
    1501:	b8 71 17 00 00       	mov    $0x1771,%eax
    1506:	85 ff                	test   %edi,%edi
    1508:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
    150b:	0f b6 07             	movzbl (%edi),%eax
    150e:	84 c0                	test   %al,%al
    1510:	74 2a                	je     153c <printf+0x16c>
    1512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1518:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    151b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
    151e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1521:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1528:	00 
    1529:	89 44 24 04          	mov    %eax,0x4(%esp)
    152d:	89 34 24             	mov    %esi,(%esp)
    1530:	e8 5d fd ff ff       	call   1292 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1535:	0f b6 07             	movzbl (%edi),%eax
    1538:	84 c0                	test   %al,%al
    153a:	75 dc                	jne    1518 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    153c:	31 ff                	xor    %edi,%edi
    153e:	e9 d8 fe ff ff       	jmp    141b <printf+0x4b>
    1543:	90                   	nop
    1544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    1548:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    154b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    154d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1554:	00 
    1555:	89 44 24 04          	mov    %eax,0x4(%esp)
    1559:	89 34 24             	mov    %esi,(%esp)
    155c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
    1560:	e8 2d fd ff ff       	call   1292 <write>
    1565:	e9 b1 fe ff ff       	jmp    141b <printf+0x4b>
    156a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    1570:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1573:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1578:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
    157b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1582:	8b 10                	mov    (%eax),%edx
    1584:	89 f0                	mov    %esi,%eax
    1586:	e8 a5 fd ff ff       	call   1330 <printint>
        ap++;
    158b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    158f:	e9 87 fe ff ff       	jmp    141b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    1594:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1597:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    1599:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    159b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    15a2:	00 
    15a3:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
    15a6:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
    15a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    15ac:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b0:	e8 dd fc ff ff       	call   1292 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
    15b5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
    15b9:	e9 5d fe ff ff       	jmp    141b <printf+0x4b>
    15be:	66 90                	xchg   %ax,%ax

000015c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15c0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15c1:	a1 54 1a 00 00       	mov    0x1a54,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
    15c6:	89 e5                	mov    %esp,%ebp
    15c8:	57                   	push   %edi
    15c9:	56                   	push   %esi
    15ca:	53                   	push   %ebx
    15cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15ce:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15d0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15d3:	39 d0                	cmp    %edx,%eax
    15d5:	72 11                	jb     15e8 <free+0x28>
    15d7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15d8:	39 c8                	cmp    %ecx,%eax
    15da:	72 04                	jb     15e0 <free+0x20>
    15dc:	39 ca                	cmp    %ecx,%edx
    15de:	72 10                	jb     15f0 <free+0x30>
    15e0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15e2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15e4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15e6:	73 f0                	jae    15d8 <free+0x18>
    15e8:	39 ca                	cmp    %ecx,%edx
    15ea:	72 04                	jb     15f0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15ec:	39 c8                	cmp    %ecx,%eax
    15ee:	72 f0                	jb     15e0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    15f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
    15f3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
    15f6:	39 cf                	cmp    %ecx,%edi
    15f8:	74 1e                	je     1618 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    15fa:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
    15fd:	8b 48 04             	mov    0x4(%eax),%ecx
    1600:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    1603:	39 f2                	cmp    %esi,%edx
    1605:	74 28                	je     162f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1607:	89 10                	mov    %edx,(%eax)
  freep = p;
    1609:	a3 54 1a 00 00       	mov    %eax,0x1a54
}
    160e:	5b                   	pop    %ebx
    160f:	5e                   	pop    %esi
    1610:	5f                   	pop    %edi
    1611:	5d                   	pop    %ebp
    1612:	c3                   	ret    
    1613:	90                   	nop
    1614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1618:	03 71 04             	add    0x4(%ecx),%esi
    161b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    161e:	8b 08                	mov    (%eax),%ecx
    1620:	8b 09                	mov    (%ecx),%ecx
    1622:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1625:	8b 48 04             	mov    0x4(%eax),%ecx
    1628:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
    162b:	39 f2                	cmp    %esi,%edx
    162d:	75 d8                	jne    1607 <free+0x47>
    p->s.size += bp->s.size;
    162f:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
    1632:	a3 54 1a 00 00       	mov    %eax,0x1a54
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1637:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    163a:	8b 53 f8             	mov    -0x8(%ebx),%edx
    163d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
    163f:	5b                   	pop    %ebx
    1640:	5e                   	pop    %esi
    1641:	5f                   	pop    %edi
    1642:	5d                   	pop    %ebp
    1643:	c3                   	ret    
    1644:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    164a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001650 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1650:	55                   	push   %ebp
    1651:	89 e5                	mov    %esp,%ebp
    1653:	57                   	push   %edi
    1654:	56                   	push   %esi
    1655:	53                   	push   %ebx
    1656:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1659:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    165c:	8b 1d 54 1a 00 00    	mov    0x1a54,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1662:	8d 48 07             	lea    0x7(%eax),%ecx
    1665:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
    1668:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    166a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
    166d:	0f 84 9b 00 00 00    	je     170e <malloc+0xbe>
    1673:	8b 13                	mov    (%ebx),%edx
    1675:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1678:	39 fe                	cmp    %edi,%esi
    167a:	76 64                	jbe    16e0 <malloc+0x90>
    167c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    1683:	bb 00 80 00 00       	mov    $0x8000,%ebx
    1688:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    168b:	eb 0e                	jmp    169b <malloc+0x4b>
    168d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1690:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    1692:	8b 78 04             	mov    0x4(%eax),%edi
    1695:	39 fe                	cmp    %edi,%esi
    1697:	76 4f                	jbe    16e8 <malloc+0x98>
    1699:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    169b:	3b 15 54 1a 00 00    	cmp    0x1a54,%edx
    16a1:	75 ed                	jne    1690 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
    16a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16a6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    16ac:	bf 00 10 00 00       	mov    $0x1000,%edi
    16b1:	0f 43 fe             	cmovae %esi,%edi
    16b4:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
    16b7:	89 04 24             	mov    %eax,(%esp)
    16ba:	e8 3b fc ff ff       	call   12fa <sbrk>
  if(p == (char*)-1)
    16bf:	83 f8 ff             	cmp    $0xffffffff,%eax
    16c2:	74 18                	je     16dc <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    16c4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
    16c7:	83 c0 08             	add    $0x8,%eax
    16ca:	89 04 24             	mov    %eax,(%esp)
    16cd:	e8 ee fe ff ff       	call   15c0 <free>
  return freep;
    16d2:	8b 15 54 1a 00 00    	mov    0x1a54,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
    16d8:	85 d2                	test   %edx,%edx
    16da:	75 b4                	jne    1690 <malloc+0x40>
        return 0;
    16dc:	31 c0                	xor    %eax,%eax
    16de:	eb 20                	jmp    1700 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    16e0:	89 d0                	mov    %edx,%eax
    16e2:	89 da                	mov    %ebx,%edx
    16e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    16e8:	39 fe                	cmp    %edi,%esi
    16ea:	74 1c                	je     1708 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    16ec:	29 f7                	sub    %esi,%edi
    16ee:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
    16f1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
    16f4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
    16f7:	89 15 54 1a 00 00    	mov    %edx,0x1a54
      return (void*)(p + 1);
    16fd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1700:	83 c4 1c             	add    $0x1c,%esp
    1703:	5b                   	pop    %ebx
    1704:	5e                   	pop    %esi
    1705:	5f                   	pop    %edi
    1706:	5d                   	pop    %ebp
    1707:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
    1708:	8b 08                	mov    (%eax),%ecx
    170a:	89 0a                	mov    %ecx,(%edx)
    170c:	eb e9                	jmp    16f7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    170e:	c7 05 54 1a 00 00 58 	movl   $0x1a58,0x1a54
    1715:	1a 00 00 
    base.s.size = 0;
    1718:	ba 58 1a 00 00       	mov    $0x1a58,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    171d:	c7 05 58 1a 00 00 58 	movl   $0x1a58,0x1a58
    1724:	1a 00 00 
    base.s.size = 0;
    1727:	c7 05 5c 1a 00 00 00 	movl   $0x0,0x1a5c
    172e:	00 00 00 
    1731:	e9 46 ff ff ff       	jmp    167c <malloc+0x2c>
    1736:	66 90                	xchg   %ax,%ax
    1738:	66 90                	xchg   %ax,%ax
    173a:	66 90                	xchg   %ax,%ax
    173c:	66 90                	xchg   %ax,%ax
    173e:	66 90                	xchg   %ax,%ax

00001740 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1740:	55                   	push   %ebp
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1741:	b9 01 00 00 00       	mov    $0x1,%ecx
    1746:	89 e5                	mov    %esp,%ebp
    1748:	8b 55 08             	mov    0x8(%ebp),%edx
    174b:	90                   	nop
    174c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1750:	89 c8                	mov    %ecx,%eax
    1752:	f0 87 02             	lock xchg %eax,(%edx)
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1755:	85 c0                	test   %eax,%eax
    1757:	75 f7                	jne    1750 <uacquire+0x10>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1759:	0f ae f0             	mfence 
}
    175c:	5d                   	pop    %ebp
    175d:	c3                   	ret    
    175e:	66 90                	xchg   %ax,%ax

00001760 <urelease>:

void urelease (struct uspinlock *lk) {
    1760:	55                   	push   %ebp
    1761:	89 e5                	mov    %esp,%ebp
    1763:	8b 45 08             	mov    0x8(%ebp),%eax
  __sync_synchronize();
    1766:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1769:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    176f:	5d                   	pop    %ebp
    1770:	c3                   	ret    
