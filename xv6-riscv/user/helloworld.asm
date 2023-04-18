
user/_helloworld:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  write(1, "Hello World xv6\n", 16);
   8:	4641                	li	a2,16
   a:	00000597          	auipc	a1,0x0
   e:	7f658593          	addi	a1,a1,2038 # 800 <malloc+0xe4>
  12:	4505                	li	a0,1
  14:	00000097          	auipc	ra,0x0
  18:	2ca080e7          	jalr	714(ra) # 2de <write>
  return 0;
}
  1c:	4501                	li	a0,0
  1e:	60a2                	ld	ra,8(sp)
  20:	6402                	ld	s0,0(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  2e:	00000097          	auipc	ra,0x0
  32:	fd2080e7          	jalr	-46(ra) # 0 <main>
  exit(0,"");
  36:	00000597          	auipc	a1,0x0
  3a:	7da58593          	addi	a1,a1,2010 # 810 <malloc+0xf4>
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	27e080e7          	jalr	638(ra) # 2be <exit>

0000000000000048 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  48:	1141                	addi	sp,sp,-16
  4a:	e422                	sd	s0,8(sp)
  4c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4e:	87aa                	mv	a5,a0
  50:	0585                	addi	a1,a1,1
  52:	0785                	addi	a5,a5,1
  54:	fff5c703          	lbu	a4,-1(a1)
  58:	fee78fa3          	sb	a4,-1(a5)
  5c:	fb75                	bnez	a4,50 <strcpy+0x8>
    ;
  return os;
}
  5e:	6422                	ld	s0,8(sp)
  60:	0141                	addi	sp,sp,16
  62:	8082                	ret

0000000000000064 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	cb91                	beqz	a5,82 <strcmp+0x1e>
  70:	0005c703          	lbu	a4,0(a1)
  74:	00f71763          	bne	a4,a5,82 <strcmp+0x1e>
    p++, q++;
  78:	0505                	addi	a0,a0,1
  7a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  7c:	00054783          	lbu	a5,0(a0)
  80:	fbe5                	bnez	a5,70 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  82:	0005c503          	lbu	a0,0(a1)
}
  86:	40a7853b          	subw	a0,a5,a0
  8a:	6422                	ld	s0,8(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret

0000000000000090 <strlen>:

uint
strlen(const char *s)
{
  90:	1141                	addi	sp,sp,-16
  92:	e422                	sd	s0,8(sp)
  94:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  96:	00054783          	lbu	a5,0(a0)
  9a:	cf91                	beqz	a5,b6 <strlen+0x26>
  9c:	0505                	addi	a0,a0,1
  9e:	87aa                	mv	a5,a0
  a0:	4685                	li	a3,1
  a2:	9e89                	subw	a3,a3,a0
  a4:	00f6853b          	addw	a0,a3,a5
  a8:	0785                	addi	a5,a5,1
  aa:	fff7c703          	lbu	a4,-1(a5)
  ae:	fb7d                	bnez	a4,a4 <strlen+0x14>
    ;
  return n;
}
  b0:	6422                	ld	s0,8(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret
  for(n = 0; s[n]; n++)
  b6:	4501                	li	a0,0
  b8:	bfe5                	j	b0 <strlen+0x20>

00000000000000ba <memset>:

void*
memset(void *dst, int c, uint n)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e422                	sd	s0,8(sp)
  be:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  c0:	ce09                	beqz	a2,da <memset+0x20>
  c2:	87aa                	mv	a5,a0
  c4:	fff6071b          	addiw	a4,a2,-1
  c8:	1702                	slli	a4,a4,0x20
  ca:	9301                	srli	a4,a4,0x20
  cc:	0705                	addi	a4,a4,1
  ce:	972a                	add	a4,a4,a0
    cdst[i] = c;
  d0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  d4:	0785                	addi	a5,a5,1
  d6:	fee79de3          	bne	a5,a4,d0 <memset+0x16>
  }
  return dst;
}
  da:	6422                	ld	s0,8(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret

00000000000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	1141                	addi	sp,sp,-16
  e2:	e422                	sd	s0,8(sp)
  e4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  e6:	00054783          	lbu	a5,0(a0)
  ea:	cb99                	beqz	a5,100 <strchr+0x20>
    if(*s == c)
  ec:	00f58763          	beq	a1,a5,fa <strchr+0x1a>
  for(; *s; s++)
  f0:	0505                	addi	a0,a0,1
  f2:	00054783          	lbu	a5,0(a0)
  f6:	fbfd                	bnez	a5,ec <strchr+0xc>
      return (char*)s;
  return 0;
  f8:	4501                	li	a0,0
}
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret
  return 0;
 100:	4501                	li	a0,0
 102:	bfe5                	j	fa <strchr+0x1a>

0000000000000104 <gets>:

char*
gets(char *buf, int max)
{
 104:	711d                	addi	sp,sp,-96
 106:	ec86                	sd	ra,88(sp)
 108:	e8a2                	sd	s0,80(sp)
 10a:	e4a6                	sd	s1,72(sp)
 10c:	e0ca                	sd	s2,64(sp)
 10e:	fc4e                	sd	s3,56(sp)
 110:	f852                	sd	s4,48(sp)
 112:	f456                	sd	s5,40(sp)
 114:	f05a                	sd	s6,32(sp)
 116:	ec5e                	sd	s7,24(sp)
 118:	1080                	addi	s0,sp,96
 11a:	8baa                	mv	s7,a0
 11c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11e:	892a                	mv	s2,a0
 120:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 122:	4aa9                	li	s5,10
 124:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 126:	89a6                	mv	s3,s1
 128:	2485                	addiw	s1,s1,1
 12a:	0344d863          	bge	s1,s4,15a <gets+0x56>
    cc = read(0, &c, 1);
 12e:	4605                	li	a2,1
 130:	faf40593          	addi	a1,s0,-81
 134:	4501                	li	a0,0
 136:	00000097          	auipc	ra,0x0
 13a:	1a0080e7          	jalr	416(ra) # 2d6 <read>
    if(cc < 1)
 13e:	00a05e63          	blez	a0,15a <gets+0x56>
    buf[i++] = c;
 142:	faf44783          	lbu	a5,-81(s0)
 146:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 14a:	01578763          	beq	a5,s5,158 <gets+0x54>
 14e:	0905                	addi	s2,s2,1
 150:	fd679be3          	bne	a5,s6,126 <gets+0x22>
  for(i=0; i+1 < max; ){
 154:	89a6                	mv	s3,s1
 156:	a011                	j	15a <gets+0x56>
 158:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 15a:	99de                	add	s3,s3,s7
 15c:	00098023          	sb	zero,0(s3)
  return buf;
}
 160:	855e                	mv	a0,s7
 162:	60e6                	ld	ra,88(sp)
 164:	6446                	ld	s0,80(sp)
 166:	64a6                	ld	s1,72(sp)
 168:	6906                	ld	s2,64(sp)
 16a:	79e2                	ld	s3,56(sp)
 16c:	7a42                	ld	s4,48(sp)
 16e:	7aa2                	ld	s5,40(sp)
 170:	7b02                	ld	s6,32(sp)
 172:	6be2                	ld	s7,24(sp)
 174:	6125                	addi	sp,sp,96
 176:	8082                	ret

0000000000000178 <stat>:

int
stat(const char *n, struct stat *st)
{
 178:	1101                	addi	sp,sp,-32
 17a:	ec06                	sd	ra,24(sp)
 17c:	e822                	sd	s0,16(sp)
 17e:	e426                	sd	s1,8(sp)
 180:	e04a                	sd	s2,0(sp)
 182:	1000                	addi	s0,sp,32
 184:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 186:	4581                	li	a1,0
 188:	00000097          	auipc	ra,0x0
 18c:	176080e7          	jalr	374(ra) # 2fe <open>
  if(fd < 0)
 190:	02054563          	bltz	a0,1ba <stat+0x42>
 194:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 196:	85ca                	mv	a1,s2
 198:	00000097          	auipc	ra,0x0
 19c:	17e080e7          	jalr	382(ra) # 316 <fstat>
 1a0:	892a                	mv	s2,a0
  close(fd);
 1a2:	8526                	mv	a0,s1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	142080e7          	jalr	322(ra) # 2e6 <close>
  return r;
}
 1ac:	854a                	mv	a0,s2
 1ae:	60e2                	ld	ra,24(sp)
 1b0:	6442                	ld	s0,16(sp)
 1b2:	64a2                	ld	s1,8(sp)
 1b4:	6902                	ld	s2,0(sp)
 1b6:	6105                	addi	sp,sp,32
 1b8:	8082                	ret
    return -1;
 1ba:	597d                	li	s2,-1
 1bc:	bfc5                	j	1ac <stat+0x34>

00000000000001be <atoi>:

int
atoi(const char *s)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e422                	sd	s0,8(sp)
 1c2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c4:	00054603          	lbu	a2,0(a0)
 1c8:	fd06079b          	addiw	a5,a2,-48
 1cc:	0ff7f793          	andi	a5,a5,255
 1d0:	4725                	li	a4,9
 1d2:	02f76963          	bltu	a4,a5,204 <atoi+0x46>
 1d6:	86aa                	mv	a3,a0
  n = 0;
 1d8:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1da:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1dc:	0685                	addi	a3,a3,1
 1de:	0025179b          	slliw	a5,a0,0x2
 1e2:	9fa9                	addw	a5,a5,a0
 1e4:	0017979b          	slliw	a5,a5,0x1
 1e8:	9fb1                	addw	a5,a5,a2
 1ea:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ee:	0006c603          	lbu	a2,0(a3)
 1f2:	fd06071b          	addiw	a4,a2,-48
 1f6:	0ff77713          	andi	a4,a4,255
 1fa:	fee5f1e3          	bgeu	a1,a4,1dc <atoi+0x1e>
  return n;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
  n = 0;
 204:	4501                	li	a0,0
 206:	bfe5                	j	1fe <atoi+0x40>

0000000000000208 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20e:	02b57663          	bgeu	a0,a1,23a <memmove+0x32>
    while(n-- > 0)
 212:	02c05163          	blez	a2,234 <memmove+0x2c>
 216:	fff6079b          	addiw	a5,a2,-1
 21a:	1782                	slli	a5,a5,0x20
 21c:	9381                	srli	a5,a5,0x20
 21e:	0785                	addi	a5,a5,1
 220:	97aa                	add	a5,a5,a0
  dst = vdst;
 222:	872a                	mv	a4,a0
      *dst++ = *src++;
 224:	0585                	addi	a1,a1,1
 226:	0705                	addi	a4,a4,1
 228:	fff5c683          	lbu	a3,-1(a1)
 22c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 230:	fee79ae3          	bne	a5,a4,224 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 234:	6422                	ld	s0,8(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret
    dst += n;
 23a:	00c50733          	add	a4,a0,a2
    src += n;
 23e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 240:	fec05ae3          	blez	a2,234 <memmove+0x2c>
 244:	fff6079b          	addiw	a5,a2,-1
 248:	1782                	slli	a5,a5,0x20
 24a:	9381                	srli	a5,a5,0x20
 24c:	fff7c793          	not	a5,a5
 250:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 252:	15fd                	addi	a1,a1,-1
 254:	177d                	addi	a4,a4,-1
 256:	0005c683          	lbu	a3,0(a1)
 25a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25e:	fee79ae3          	bne	a5,a4,252 <memmove+0x4a>
 262:	bfc9                	j	234 <memmove+0x2c>

0000000000000264 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 264:	1141                	addi	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26a:	ca05                	beqz	a2,29a <memcmp+0x36>
 26c:	fff6069b          	addiw	a3,a2,-1
 270:	1682                	slli	a3,a3,0x20
 272:	9281                	srli	a3,a3,0x20
 274:	0685                	addi	a3,a3,1
 276:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 278:	00054783          	lbu	a5,0(a0)
 27c:	0005c703          	lbu	a4,0(a1)
 280:	00e79863          	bne	a5,a4,290 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 284:	0505                	addi	a0,a0,1
    p2++;
 286:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 288:	fed518e3          	bne	a0,a3,278 <memcmp+0x14>
  }
  return 0;
 28c:	4501                	li	a0,0
 28e:	a019                	j	294 <memcmp+0x30>
      return *p1 - *p2;
 290:	40e7853b          	subw	a0,a5,a4
}
 294:	6422                	ld	s0,8(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
  return 0;
 29a:	4501                	li	a0,0
 29c:	bfe5                	j	294 <memcmp+0x30>

000000000000029e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a6:	00000097          	auipc	ra,0x0
 2aa:	f62080e7          	jalr	-158(ra) # 208 <memmove>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b6:	4885                	li	a7,1
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <exit>:
.global exit
exit:
 li a7, SYS_exit
 2be:	4889                	li	a7,2
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c6:	488d                	li	a7,3
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ce:	4891                	li	a7,4
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <read>:
.global read
read:
 li a7, SYS_read
 2d6:	4895                	li	a7,5
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <write>:
.global write
write:
 li a7, SYS_write
 2de:	48c1                	li	a7,16
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <close>:
.global close
close:
 li a7, SYS_close
 2e6:	48d5                	li	a7,21
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ee:	4899                	li	a7,6
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f6:	489d                	li	a7,7
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <open>:
.global open
open:
 li a7, SYS_open
 2fe:	48bd                	li	a7,15
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 306:	48c5                	li	a7,17
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30e:	48c9                	li	a7,18
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 316:	48a1                	li	a7,8
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <link>:
.global link
link:
 li a7, SYS_link
 31e:	48cd                	li	a7,19
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 326:	48d1                	li	a7,20
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32e:	48a5                	li	a7,9
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <dup>:
.global dup
dup:
 li a7, SYS_dup
 336:	48a9                	li	a7,10
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33e:	48ad                	li	a7,11
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 346:	48b1                	li	a7,12
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34e:	48b5                	li	a7,13
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 356:	48b9                	li	a7,14
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 35e:	48d9                	li	a7,22
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 366:	48dd                	li	a7,23
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 36e:	48e1                	li	a7,24
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 376:	48e5                	li	a7,25
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 37e:	48e9                	li	a7,26
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 386:	1101                	addi	sp,sp,-32
 388:	ec06                	sd	ra,24(sp)
 38a:	e822                	sd	s0,16(sp)
 38c:	1000                	addi	s0,sp,32
 38e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 392:	4605                	li	a2,1
 394:	fef40593          	addi	a1,s0,-17
 398:	00000097          	auipc	ra,0x0
 39c:	f46080e7          	jalr	-186(ra) # 2de <write>
}
 3a0:	60e2                	ld	ra,24(sp)
 3a2:	6442                	ld	s0,16(sp)
 3a4:	6105                	addi	sp,sp,32
 3a6:	8082                	ret

00000000000003a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a8:	7139                	addi	sp,sp,-64
 3aa:	fc06                	sd	ra,56(sp)
 3ac:	f822                	sd	s0,48(sp)
 3ae:	f426                	sd	s1,40(sp)
 3b0:	f04a                	sd	s2,32(sp)
 3b2:	ec4e                	sd	s3,24(sp)
 3b4:	0080                	addi	s0,sp,64
 3b6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b8:	c299                	beqz	a3,3be <printint+0x16>
 3ba:	0805c863          	bltz	a1,44a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3be:	2581                	sext.w	a1,a1
  neg = 0;
 3c0:	4881                	li	a7,0
 3c2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c8:	2601                	sext.w	a2,a2
 3ca:	00000517          	auipc	a0,0x0
 3ce:	45650513          	addi	a0,a0,1110 # 820 <digits>
 3d2:	883a                	mv	a6,a4
 3d4:	2705                	addiw	a4,a4,1
 3d6:	02c5f7bb          	remuw	a5,a1,a2
 3da:	1782                	slli	a5,a5,0x20
 3dc:	9381                	srli	a5,a5,0x20
 3de:	97aa                	add	a5,a5,a0
 3e0:	0007c783          	lbu	a5,0(a5)
 3e4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e8:	0005879b          	sext.w	a5,a1
 3ec:	02c5d5bb          	divuw	a1,a1,a2
 3f0:	0685                	addi	a3,a3,1
 3f2:	fec7f0e3          	bgeu	a5,a2,3d2 <printint+0x2a>
  if(neg)
 3f6:	00088b63          	beqz	a7,40c <printint+0x64>
    buf[i++] = '-';
 3fa:	fd040793          	addi	a5,s0,-48
 3fe:	973e                	add	a4,a4,a5
 400:	02d00793          	li	a5,45
 404:	fef70823          	sb	a5,-16(a4)
 408:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 40c:	02e05863          	blez	a4,43c <printint+0x94>
 410:	fc040793          	addi	a5,s0,-64
 414:	00e78933          	add	s2,a5,a4
 418:	fff78993          	addi	s3,a5,-1
 41c:	99ba                	add	s3,s3,a4
 41e:	377d                	addiw	a4,a4,-1
 420:	1702                	slli	a4,a4,0x20
 422:	9301                	srli	a4,a4,0x20
 424:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 428:	fff94583          	lbu	a1,-1(s2)
 42c:	8526                	mv	a0,s1
 42e:	00000097          	auipc	ra,0x0
 432:	f58080e7          	jalr	-168(ra) # 386 <putc>
  while(--i >= 0)
 436:	197d                	addi	s2,s2,-1
 438:	ff3918e3          	bne	s2,s3,428 <printint+0x80>
}
 43c:	70e2                	ld	ra,56(sp)
 43e:	7442                	ld	s0,48(sp)
 440:	74a2                	ld	s1,40(sp)
 442:	7902                	ld	s2,32(sp)
 444:	69e2                	ld	s3,24(sp)
 446:	6121                	addi	sp,sp,64
 448:	8082                	ret
    x = -xx;
 44a:	40b005bb          	negw	a1,a1
    neg = 1;
 44e:	4885                	li	a7,1
    x = -xx;
 450:	bf8d                	j	3c2 <printint+0x1a>

0000000000000452 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 452:	7119                	addi	sp,sp,-128
 454:	fc86                	sd	ra,120(sp)
 456:	f8a2                	sd	s0,112(sp)
 458:	f4a6                	sd	s1,104(sp)
 45a:	f0ca                	sd	s2,96(sp)
 45c:	ecce                	sd	s3,88(sp)
 45e:	e8d2                	sd	s4,80(sp)
 460:	e4d6                	sd	s5,72(sp)
 462:	e0da                	sd	s6,64(sp)
 464:	fc5e                	sd	s7,56(sp)
 466:	f862                	sd	s8,48(sp)
 468:	f466                	sd	s9,40(sp)
 46a:	f06a                	sd	s10,32(sp)
 46c:	ec6e                	sd	s11,24(sp)
 46e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 470:	0005c903          	lbu	s2,0(a1)
 474:	18090f63          	beqz	s2,612 <vprintf+0x1c0>
 478:	8aaa                	mv	s5,a0
 47a:	8b32                	mv	s6,a2
 47c:	00158493          	addi	s1,a1,1
  state = 0;
 480:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 482:	02500a13          	li	s4,37
      if(c == 'd'){
 486:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 48a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 48e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 492:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 496:	00000b97          	auipc	s7,0x0
 49a:	38ab8b93          	addi	s7,s7,906 # 820 <digits>
 49e:	a839                	j	4bc <vprintf+0x6a>
        putc(fd, c);
 4a0:	85ca                	mv	a1,s2
 4a2:	8556                	mv	a0,s5
 4a4:	00000097          	auipc	ra,0x0
 4a8:	ee2080e7          	jalr	-286(ra) # 386 <putc>
 4ac:	a019                	j	4b2 <vprintf+0x60>
    } else if(state == '%'){
 4ae:	01498f63          	beq	s3,s4,4cc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4b2:	0485                	addi	s1,s1,1
 4b4:	fff4c903          	lbu	s2,-1(s1)
 4b8:	14090d63          	beqz	s2,612 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4bc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4c0:	fe0997e3          	bnez	s3,4ae <vprintf+0x5c>
      if(c == '%'){
 4c4:	fd479ee3          	bne	a5,s4,4a0 <vprintf+0x4e>
        state = '%';
 4c8:	89be                	mv	s3,a5
 4ca:	b7e5                	j	4b2 <vprintf+0x60>
      if(c == 'd'){
 4cc:	05878063          	beq	a5,s8,50c <vprintf+0xba>
      } else if(c == 'l') {
 4d0:	05978c63          	beq	a5,s9,528 <vprintf+0xd6>
      } else if(c == 'x') {
 4d4:	07a78863          	beq	a5,s10,544 <vprintf+0xf2>
      } else if(c == 'p') {
 4d8:	09b78463          	beq	a5,s11,560 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4dc:	07300713          	li	a4,115
 4e0:	0ce78663          	beq	a5,a4,5ac <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4e4:	06300713          	li	a4,99
 4e8:	0ee78e63          	beq	a5,a4,5e4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4ec:	11478863          	beq	a5,s4,5fc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4f0:	85d2                	mv	a1,s4
 4f2:	8556                	mv	a0,s5
 4f4:	00000097          	auipc	ra,0x0
 4f8:	e92080e7          	jalr	-366(ra) # 386 <putc>
        putc(fd, c);
 4fc:	85ca                	mv	a1,s2
 4fe:	8556                	mv	a0,s5
 500:	00000097          	auipc	ra,0x0
 504:	e86080e7          	jalr	-378(ra) # 386 <putc>
      }
      state = 0;
 508:	4981                	li	s3,0
 50a:	b765                	j	4b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 50c:	008b0913          	addi	s2,s6,8
 510:	4685                	li	a3,1
 512:	4629                	li	a2,10
 514:	000b2583          	lw	a1,0(s6)
 518:	8556                	mv	a0,s5
 51a:	00000097          	auipc	ra,0x0
 51e:	e8e080e7          	jalr	-370(ra) # 3a8 <printint>
 522:	8b4a                	mv	s6,s2
      state = 0;
 524:	4981                	li	s3,0
 526:	b771                	j	4b2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 528:	008b0913          	addi	s2,s6,8
 52c:	4681                	li	a3,0
 52e:	4629                	li	a2,10
 530:	000b2583          	lw	a1,0(s6)
 534:	8556                	mv	a0,s5
 536:	00000097          	auipc	ra,0x0
 53a:	e72080e7          	jalr	-398(ra) # 3a8 <printint>
 53e:	8b4a                	mv	s6,s2
      state = 0;
 540:	4981                	li	s3,0
 542:	bf85                	j	4b2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 544:	008b0913          	addi	s2,s6,8
 548:	4681                	li	a3,0
 54a:	4641                	li	a2,16
 54c:	000b2583          	lw	a1,0(s6)
 550:	8556                	mv	a0,s5
 552:	00000097          	auipc	ra,0x0
 556:	e56080e7          	jalr	-426(ra) # 3a8 <printint>
 55a:	8b4a                	mv	s6,s2
      state = 0;
 55c:	4981                	li	s3,0
 55e:	bf91                	j	4b2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 560:	008b0793          	addi	a5,s6,8
 564:	f8f43423          	sd	a5,-120(s0)
 568:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 56c:	03000593          	li	a1,48
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	e14080e7          	jalr	-492(ra) # 386 <putc>
  putc(fd, 'x');
 57a:	85ea                	mv	a1,s10
 57c:	8556                	mv	a0,s5
 57e:	00000097          	auipc	ra,0x0
 582:	e08080e7          	jalr	-504(ra) # 386 <putc>
 586:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 588:	03c9d793          	srli	a5,s3,0x3c
 58c:	97de                	add	a5,a5,s7
 58e:	0007c583          	lbu	a1,0(a5)
 592:	8556                	mv	a0,s5
 594:	00000097          	auipc	ra,0x0
 598:	df2080e7          	jalr	-526(ra) # 386 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 59c:	0992                	slli	s3,s3,0x4
 59e:	397d                	addiw	s2,s2,-1
 5a0:	fe0914e3          	bnez	s2,588 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5a4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	b721                	j	4b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 5ac:	008b0993          	addi	s3,s6,8
 5b0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5b4:	02090163          	beqz	s2,5d6 <vprintf+0x184>
        while(*s != 0){
 5b8:	00094583          	lbu	a1,0(s2)
 5bc:	c9a1                	beqz	a1,60c <vprintf+0x1ba>
          putc(fd, *s);
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	dc6080e7          	jalr	-570(ra) # 386 <putc>
          s++;
 5c8:	0905                	addi	s2,s2,1
        while(*s != 0){
 5ca:	00094583          	lbu	a1,0(s2)
 5ce:	f9e5                	bnez	a1,5be <vprintf+0x16c>
        s = va_arg(ap, char*);
 5d0:	8b4e                	mv	s6,s3
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	bdf9                	j	4b2 <vprintf+0x60>
          s = "(null)";
 5d6:	00000917          	auipc	s2,0x0
 5da:	24290913          	addi	s2,s2,578 # 818 <malloc+0xfc>
        while(*s != 0){
 5de:	02800593          	li	a1,40
 5e2:	bff1                	j	5be <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5e4:	008b0913          	addi	s2,s6,8
 5e8:	000b4583          	lbu	a1,0(s6)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	d98080e7          	jalr	-616(ra) # 386 <putc>
 5f6:	8b4a                	mv	s6,s2
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	bd65                	j	4b2 <vprintf+0x60>
        putc(fd, c);
 5fc:	85d2                	mv	a1,s4
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	d86080e7          	jalr	-634(ra) # 386 <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	b565                	j	4b2 <vprintf+0x60>
        s = va_arg(ap, char*);
 60c:	8b4e                	mv	s6,s3
      state = 0;
 60e:	4981                	li	s3,0
 610:	b54d                	j	4b2 <vprintf+0x60>
    }
  }
}
 612:	70e6                	ld	ra,120(sp)
 614:	7446                	ld	s0,112(sp)
 616:	74a6                	ld	s1,104(sp)
 618:	7906                	ld	s2,96(sp)
 61a:	69e6                	ld	s3,88(sp)
 61c:	6a46                	ld	s4,80(sp)
 61e:	6aa6                	ld	s5,72(sp)
 620:	6b06                	ld	s6,64(sp)
 622:	7be2                	ld	s7,56(sp)
 624:	7c42                	ld	s8,48(sp)
 626:	7ca2                	ld	s9,40(sp)
 628:	7d02                	ld	s10,32(sp)
 62a:	6de2                	ld	s11,24(sp)
 62c:	6109                	addi	sp,sp,128
 62e:	8082                	ret

0000000000000630 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 630:	715d                	addi	sp,sp,-80
 632:	ec06                	sd	ra,24(sp)
 634:	e822                	sd	s0,16(sp)
 636:	1000                	addi	s0,sp,32
 638:	e010                	sd	a2,0(s0)
 63a:	e414                	sd	a3,8(s0)
 63c:	e818                	sd	a4,16(s0)
 63e:	ec1c                	sd	a5,24(s0)
 640:	03043023          	sd	a6,32(s0)
 644:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 648:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 64c:	8622                	mv	a2,s0
 64e:	00000097          	auipc	ra,0x0
 652:	e04080e7          	jalr	-508(ra) # 452 <vprintf>
}
 656:	60e2                	ld	ra,24(sp)
 658:	6442                	ld	s0,16(sp)
 65a:	6161                	addi	sp,sp,80
 65c:	8082                	ret

000000000000065e <printf>:

void
printf(const char *fmt, ...)
{
 65e:	711d                	addi	sp,sp,-96
 660:	ec06                	sd	ra,24(sp)
 662:	e822                	sd	s0,16(sp)
 664:	1000                	addi	s0,sp,32
 666:	e40c                	sd	a1,8(s0)
 668:	e810                	sd	a2,16(s0)
 66a:	ec14                	sd	a3,24(s0)
 66c:	f018                	sd	a4,32(s0)
 66e:	f41c                	sd	a5,40(s0)
 670:	03043823          	sd	a6,48(s0)
 674:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 678:	00840613          	addi	a2,s0,8
 67c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 680:	85aa                	mv	a1,a0
 682:	4505                	li	a0,1
 684:	00000097          	auipc	ra,0x0
 688:	dce080e7          	jalr	-562(ra) # 452 <vprintf>
}
 68c:	60e2                	ld	ra,24(sp)
 68e:	6442                	ld	s0,16(sp)
 690:	6125                	addi	sp,sp,96
 692:	8082                	ret

0000000000000694 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 694:	1141                	addi	sp,sp,-16
 696:	e422                	sd	s0,8(sp)
 698:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 69a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69e:	00001797          	auipc	a5,0x1
 6a2:	9627b783          	ld	a5,-1694(a5) # 1000 <freep>
 6a6:	a805                	j	6d6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6a8:	4618                	lw	a4,8(a2)
 6aa:	9db9                	addw	a1,a1,a4
 6ac:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6b0:	6398                	ld	a4,0(a5)
 6b2:	6318                	ld	a4,0(a4)
 6b4:	fee53823          	sd	a4,-16(a0)
 6b8:	a091                	j	6fc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ba:	ff852703          	lw	a4,-8(a0)
 6be:	9e39                	addw	a2,a2,a4
 6c0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6c2:	ff053703          	ld	a4,-16(a0)
 6c6:	e398                	sd	a4,0(a5)
 6c8:	a099                	j	70e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ca:	6398                	ld	a4,0(a5)
 6cc:	00e7e463          	bltu	a5,a4,6d4 <free+0x40>
 6d0:	00e6ea63          	bltu	a3,a4,6e4 <free+0x50>
{
 6d4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d6:	fed7fae3          	bgeu	a5,a3,6ca <free+0x36>
 6da:	6398                	ld	a4,0(a5)
 6dc:	00e6e463          	bltu	a3,a4,6e4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e0:	fee7eae3          	bltu	a5,a4,6d4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6e4:	ff852583          	lw	a1,-8(a0)
 6e8:	6390                	ld	a2,0(a5)
 6ea:	02059713          	slli	a4,a1,0x20
 6ee:	9301                	srli	a4,a4,0x20
 6f0:	0712                	slli	a4,a4,0x4
 6f2:	9736                	add	a4,a4,a3
 6f4:	fae60ae3          	beq	a2,a4,6a8 <free+0x14>
    bp->s.ptr = p->s.ptr;
 6f8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6fc:	4790                	lw	a2,8(a5)
 6fe:	02061713          	slli	a4,a2,0x20
 702:	9301                	srli	a4,a4,0x20
 704:	0712                	slli	a4,a4,0x4
 706:	973e                	add	a4,a4,a5
 708:	fae689e3          	beq	a3,a4,6ba <free+0x26>
  } else
    p->s.ptr = bp;
 70c:	e394                	sd	a3,0(a5)
  freep = p;
 70e:	00001717          	auipc	a4,0x1
 712:	8ef73923          	sd	a5,-1806(a4) # 1000 <freep>
}
 716:	6422                	ld	s0,8(sp)
 718:	0141                	addi	sp,sp,16
 71a:	8082                	ret

000000000000071c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 71c:	7139                	addi	sp,sp,-64
 71e:	fc06                	sd	ra,56(sp)
 720:	f822                	sd	s0,48(sp)
 722:	f426                	sd	s1,40(sp)
 724:	f04a                	sd	s2,32(sp)
 726:	ec4e                	sd	s3,24(sp)
 728:	e852                	sd	s4,16(sp)
 72a:	e456                	sd	s5,8(sp)
 72c:	e05a                	sd	s6,0(sp)
 72e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 730:	02051493          	slli	s1,a0,0x20
 734:	9081                	srli	s1,s1,0x20
 736:	04bd                	addi	s1,s1,15
 738:	8091                	srli	s1,s1,0x4
 73a:	0014899b          	addiw	s3,s1,1
 73e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 740:	00001517          	auipc	a0,0x1
 744:	8c053503          	ld	a0,-1856(a0) # 1000 <freep>
 748:	c515                	beqz	a0,774 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 74c:	4798                	lw	a4,8(a5)
 74e:	02977f63          	bgeu	a4,s1,78c <malloc+0x70>
 752:	8a4e                	mv	s4,s3
 754:	0009871b          	sext.w	a4,s3
 758:	6685                	lui	a3,0x1
 75a:	00d77363          	bgeu	a4,a3,760 <malloc+0x44>
 75e:	6a05                	lui	s4,0x1
 760:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 764:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 768:	00001917          	auipc	s2,0x1
 76c:	89890913          	addi	s2,s2,-1896 # 1000 <freep>
  if(p == (char*)-1)
 770:	5afd                	li	s5,-1
 772:	a88d                	j	7e4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 774:	00001797          	auipc	a5,0x1
 778:	89c78793          	addi	a5,a5,-1892 # 1010 <base>
 77c:	00001717          	auipc	a4,0x1
 780:	88f73223          	sd	a5,-1916(a4) # 1000 <freep>
 784:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 786:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 78a:	b7e1                	j	752 <malloc+0x36>
      if(p->s.size == nunits)
 78c:	02e48b63          	beq	s1,a4,7c2 <malloc+0xa6>
        p->s.size -= nunits;
 790:	4137073b          	subw	a4,a4,s3
 794:	c798                	sw	a4,8(a5)
        p += p->s.size;
 796:	1702                	slli	a4,a4,0x20
 798:	9301                	srli	a4,a4,0x20
 79a:	0712                	slli	a4,a4,0x4
 79c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 79e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7a2:	00001717          	auipc	a4,0x1
 7a6:	84a73f23          	sd	a0,-1954(a4) # 1000 <freep>
      return (void*)(p + 1);
 7aa:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7ae:	70e2                	ld	ra,56(sp)
 7b0:	7442                	ld	s0,48(sp)
 7b2:	74a2                	ld	s1,40(sp)
 7b4:	7902                	ld	s2,32(sp)
 7b6:	69e2                	ld	s3,24(sp)
 7b8:	6a42                	ld	s4,16(sp)
 7ba:	6aa2                	ld	s5,8(sp)
 7bc:	6b02                	ld	s6,0(sp)
 7be:	6121                	addi	sp,sp,64
 7c0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7c2:	6398                	ld	a4,0(a5)
 7c4:	e118                	sd	a4,0(a0)
 7c6:	bff1                	j	7a2 <malloc+0x86>
  hp->s.size = nu;
 7c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7cc:	0541                	addi	a0,a0,16
 7ce:	00000097          	auipc	ra,0x0
 7d2:	ec6080e7          	jalr	-314(ra) # 694 <free>
  return freep;
 7d6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7da:	d971                	beqz	a0,7ae <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7de:	4798                	lw	a4,8(a5)
 7e0:	fa9776e3          	bgeu	a4,s1,78c <malloc+0x70>
    if(p == freep)
 7e4:	00093703          	ld	a4,0(s2)
 7e8:	853e                	mv	a0,a5
 7ea:	fef719e3          	bne	a4,a5,7dc <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7ee:	8552                	mv	a0,s4
 7f0:	00000097          	auipc	ra,0x0
 7f4:	b56080e7          	jalr	-1194(ra) # 346 <sbrk>
  if(p == (char*)-1)
 7f8:	fd5518e3          	bne	a0,s5,7c8 <malloc+0xac>
        return 0;
 7fc:	4501                	li	a0,0
 7fe:	bf45                	j	7ae <malloc+0x92>
