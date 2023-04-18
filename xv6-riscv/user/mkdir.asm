
user/_mkdir:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	1902                	slli	s2,s2,0x20
  1e:	02095913          	srli	s2,s2,0x20
  22:	090e                	slli	s2,s2,0x3
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1,"");
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	35e080e7          	jalr	862(ra) # 388 <mkdir>
  32:	02054863          	bltz	a0,62 <main+0x62>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a82d                	j	76 <main+0x76>
    fprintf(2, "Usage: mkdir files...\n");
  3e:	00001597          	auipc	a1,0x1
  42:	83258593          	addi	a1,a1,-1998 # 870 <malloc+0xf2>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	64a080e7          	jalr	1610(ra) # 692 <fprintf>
    exit(1,"");
  50:	00001597          	auipc	a1,0x1
  54:	83858593          	addi	a1,a1,-1992 # 888 <malloc+0x10a>
  58:	4505                	li	a0,1
  5a:	00000097          	auipc	ra,0x0
  5e:	2c6080e7          	jalr	710(ra) # 320 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  62:	6090                	ld	a2,0(s1)
  64:	00001597          	auipc	a1,0x1
  68:	82c58593          	addi	a1,a1,-2004 # 890 <malloc+0x112>
  6c:	4509                	li	a0,2
  6e:	00000097          	auipc	ra,0x0
  72:	624080e7          	jalr	1572(ra) # 692 <fprintf>
      break;
    }
  }

  exit(0,"");
  76:	00001597          	auipc	a1,0x1
  7a:	81258593          	addi	a1,a1,-2030 # 888 <malloc+0x10a>
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	2a0080e7          	jalr	672(ra) # 320 <exit>

0000000000000088 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  88:	1141                	addi	sp,sp,-16
  8a:	e406                	sd	ra,8(sp)
  8c:	e022                	sd	s0,0(sp)
  8e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  90:	00000097          	auipc	ra,0x0
  94:	f70080e7          	jalr	-144(ra) # 0 <main>
  exit(0,"");
  98:	00000597          	auipc	a1,0x0
  9c:	7f058593          	addi	a1,a1,2032 # 888 <malloc+0x10a>
  a0:	4501                	li	a0,0
  a2:	00000097          	auipc	ra,0x0
  a6:	27e080e7          	jalr	638(ra) # 320 <exit>

00000000000000aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b0:	87aa                	mv	a5,a0
  b2:	0585                	addi	a1,a1,1
  b4:	0785                	addi	a5,a5,1
  b6:	fff5c703          	lbu	a4,-1(a1)
  ba:	fee78fa3          	sb	a4,-1(a5)
  be:	fb75                	bnez	a4,b2 <strcpy+0x8>
    ;
  return os;
}
  c0:	6422                	ld	s0,8(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e422                	sd	s0,8(sp)
  ca:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cb91                	beqz	a5,e4 <strcmp+0x1e>
  d2:	0005c703          	lbu	a4,0(a1)
  d6:	00f71763          	bne	a4,a5,e4 <strcmp+0x1e>
    p++, q++;
  da:	0505                	addi	a0,a0,1
  dc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  de:	00054783          	lbu	a5,0(a0)
  e2:	fbe5                	bnez	a5,d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e4:	0005c503          	lbu	a0,0(a1)
}
  e8:	40a7853b          	subw	a0,a5,a0
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strlen>:

uint
strlen(const char *s)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cf91                	beqz	a5,118 <strlen+0x26>
  fe:	0505                	addi	a0,a0,1
 100:	87aa                	mv	a5,a0
 102:	4685                	li	a3,1
 104:	9e89                	subw	a3,a3,a0
 106:	00f6853b          	addw	a0,a3,a5
 10a:	0785                	addi	a5,a5,1
 10c:	fff7c703          	lbu	a4,-1(a5)
 110:	fb7d                	bnez	a4,106 <strlen+0x14>
    ;
  return n;
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret
  for(n = 0; s[n]; n++)
 118:	4501                	li	a0,0
 11a:	bfe5                	j	112 <strlen+0x20>

000000000000011c <memset>:

void*
memset(void *dst, int c, uint n)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 122:	ce09                	beqz	a2,13c <memset+0x20>
 124:	87aa                	mv	a5,a0
 126:	fff6071b          	addiw	a4,a2,-1
 12a:	1702                	slli	a4,a4,0x20
 12c:	9301                	srli	a4,a4,0x20
 12e:	0705                	addi	a4,a4,1
 130:	972a                	add	a4,a4,a0
    cdst[i] = c;
 132:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 136:	0785                	addi	a5,a5,1
 138:	fee79de3          	bne	a5,a4,132 <memset+0x16>
  }
  return dst;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strchr>:

char*
strchr(const char *s, char c)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  for(; *s; s++)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb99                	beqz	a5,162 <strchr+0x20>
    if(*s == c)
 14e:	00f58763          	beq	a1,a5,15c <strchr+0x1a>
  for(; *s; s++)
 152:	0505                	addi	a0,a0,1
 154:	00054783          	lbu	a5,0(a0)
 158:	fbfd                	bnez	a5,14e <strchr+0xc>
      return (char*)s;
  return 0;
 15a:	4501                	li	a0,0
}
 15c:	6422                	ld	s0,8(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfe5                	j	15c <strchr+0x1a>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	1080                	addi	s0,sp,96
 17c:	8baa                	mv	s7,a0
 17e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	892a                	mv	s2,a0
 182:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 184:	4aa9                	li	s5,10
 186:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 188:	89a6                	mv	s3,s1
 18a:	2485                	addiw	s1,s1,1
 18c:	0344d863          	bge	s1,s4,1bc <gets+0x56>
    cc = read(0, &c, 1);
 190:	4605                	li	a2,1
 192:	faf40593          	addi	a1,s0,-81
 196:	4501                	li	a0,0
 198:	00000097          	auipc	ra,0x0
 19c:	1a0080e7          	jalr	416(ra) # 338 <read>
    if(cc < 1)
 1a0:	00a05e63          	blez	a0,1bc <gets+0x56>
    buf[i++] = c;
 1a4:	faf44783          	lbu	a5,-81(s0)
 1a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ac:	01578763          	beq	a5,s5,1ba <gets+0x54>
 1b0:	0905                	addi	s2,s2,1
 1b2:	fd679be3          	bne	a5,s6,188 <gets+0x22>
  for(i=0; i+1 < max; ){
 1b6:	89a6                	mv	s3,s1
 1b8:	a011                	j	1bc <gets+0x56>
 1ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1bc:	99de                	add	s3,s3,s7
 1be:	00098023          	sb	zero,0(s3)
  return buf;
}
 1c2:	855e                	mv	a0,s7
 1c4:	60e6                	ld	ra,88(sp)
 1c6:	6446                	ld	s0,80(sp)
 1c8:	64a6                	ld	s1,72(sp)
 1ca:	6906                	ld	s2,64(sp)
 1cc:	79e2                	ld	s3,56(sp)
 1ce:	7a42                	ld	s4,48(sp)
 1d0:	7aa2                	ld	s5,40(sp)
 1d2:	7b02                	ld	s6,32(sp)
 1d4:	6be2                	ld	s7,24(sp)
 1d6:	6125                	addi	sp,sp,96
 1d8:	8082                	ret

00000000000001da <stat>:

int
stat(const char *n, struct stat *st)
{
 1da:	1101                	addi	sp,sp,-32
 1dc:	ec06                	sd	ra,24(sp)
 1de:	e822                	sd	s0,16(sp)
 1e0:	e426                	sd	s1,8(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	00000097          	auipc	ra,0x0
 1ee:	176080e7          	jalr	374(ra) # 360 <open>
  if(fd < 0)
 1f2:	02054563          	bltz	a0,21c <stat+0x42>
 1f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f8:	85ca                	mv	a1,s2
 1fa:	00000097          	auipc	ra,0x0
 1fe:	17e080e7          	jalr	382(ra) # 378 <fstat>
 202:	892a                	mv	s2,a0
  close(fd);
 204:	8526                	mv	a0,s1
 206:	00000097          	auipc	ra,0x0
 20a:	142080e7          	jalr	322(ra) # 348 <close>
  return r;
}
 20e:	854a                	mv	a0,s2
 210:	60e2                	ld	ra,24(sp)
 212:	6442                	ld	s0,16(sp)
 214:	64a2                	ld	s1,8(sp)
 216:	6902                	ld	s2,0(sp)
 218:	6105                	addi	sp,sp,32
 21a:	8082                	ret
    return -1;
 21c:	597d                	li	s2,-1
 21e:	bfc5                	j	20e <stat+0x34>

0000000000000220 <atoi>:

int
atoi(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 226:	00054603          	lbu	a2,0(a0)
 22a:	fd06079b          	addiw	a5,a2,-48
 22e:	0ff7f793          	andi	a5,a5,255
 232:	4725                	li	a4,9
 234:	02f76963          	bltu	a4,a5,266 <atoi+0x46>
 238:	86aa                	mv	a3,a0
  n = 0;
 23a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 23c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 23e:	0685                	addi	a3,a3,1
 240:	0025179b          	slliw	a5,a0,0x2
 244:	9fa9                	addw	a5,a5,a0
 246:	0017979b          	slliw	a5,a5,0x1
 24a:	9fb1                	addw	a5,a5,a2
 24c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 250:	0006c603          	lbu	a2,0(a3)
 254:	fd06071b          	addiw	a4,a2,-48
 258:	0ff77713          	andi	a4,a4,255
 25c:	fee5f1e3          	bgeu	a1,a4,23e <atoi+0x1e>
  return n;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
  n = 0;
 266:	4501                	li	a0,0
 268:	bfe5                	j	260 <atoi+0x40>

000000000000026a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 26a:	1141                	addi	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 270:	02b57663          	bgeu	a0,a1,29c <memmove+0x32>
    while(n-- > 0)
 274:	02c05163          	blez	a2,296 <memmove+0x2c>
 278:	fff6079b          	addiw	a5,a2,-1
 27c:	1782                	slli	a5,a5,0x20
 27e:	9381                	srli	a5,a5,0x20
 280:	0785                	addi	a5,a5,1
 282:	97aa                	add	a5,a5,a0
  dst = vdst;
 284:	872a                	mv	a4,a0
      *dst++ = *src++;
 286:	0585                	addi	a1,a1,1
 288:	0705                	addi	a4,a4,1
 28a:	fff5c683          	lbu	a3,-1(a1)
 28e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 292:	fee79ae3          	bne	a5,a4,286 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
    dst += n;
 29c:	00c50733          	add	a4,a0,a2
    src += n;
 2a0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a2:	fec05ae3          	blez	a2,296 <memmove+0x2c>
 2a6:	fff6079b          	addiw	a5,a2,-1
 2aa:	1782                	slli	a5,a5,0x20
 2ac:	9381                	srli	a5,a5,0x20
 2ae:	fff7c793          	not	a5,a5
 2b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b4:	15fd                	addi	a1,a1,-1
 2b6:	177d                	addi	a4,a4,-1
 2b8:	0005c683          	lbu	a3,0(a1)
 2bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2c0:	fee79ae3          	bne	a5,a4,2b4 <memmove+0x4a>
 2c4:	bfc9                	j	296 <memmove+0x2c>

00000000000002c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2cc:	ca05                	beqz	a2,2fc <memcmp+0x36>
 2ce:	fff6069b          	addiw	a3,a2,-1
 2d2:	1682                	slli	a3,a3,0x20
 2d4:	9281                	srli	a3,a3,0x20
 2d6:	0685                	addi	a3,a3,1
 2d8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2da:	00054783          	lbu	a5,0(a0)
 2de:	0005c703          	lbu	a4,0(a1)
 2e2:	00e79863          	bne	a5,a4,2f2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2e6:	0505                	addi	a0,a0,1
    p2++;
 2e8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ea:	fed518e3          	bne	a0,a3,2da <memcmp+0x14>
  }
  return 0;
 2ee:	4501                	li	a0,0
 2f0:	a019                	j	2f6 <memcmp+0x30>
      return *p1 - *p2;
 2f2:	40e7853b          	subw	a0,a5,a4
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
  return 0;
 2fc:	4501                	li	a0,0
 2fe:	bfe5                	j	2f6 <memcmp+0x30>

0000000000000300 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 308:	00000097          	auipc	ra,0x0
 30c:	f62080e7          	jalr	-158(ra) # 26a <memmove>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 318:	4885                	li	a7,1
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exit>:
.global exit
exit:
 li a7, SYS_exit
 320:	4889                	li	a7,2
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <wait>:
.global wait
wait:
 li a7, SYS_wait
 328:	488d                	li	a7,3
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 330:	4891                	li	a7,4
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <read>:
.global read
read:
 li a7, SYS_read
 338:	4895                	li	a7,5
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <write>:
.global write
write:
 li a7, SYS_write
 340:	48c1                	li	a7,16
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <close>:
.global close
close:
 li a7, SYS_close
 348:	48d5                	li	a7,21
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <kill>:
.global kill
kill:
 li a7, SYS_kill
 350:	4899                	li	a7,6
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exec>:
.global exec
exec:
 li a7, SYS_exec
 358:	489d                	li	a7,7
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <open>:
.global open
open:
 li a7, SYS_open
 360:	48bd                	li	a7,15
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 368:	48c5                	li	a7,17
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 370:	48c9                	li	a7,18
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 378:	48a1                	li	a7,8
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <link>:
.global link
link:
 li a7, SYS_link
 380:	48cd                	li	a7,19
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 388:	48d1                	li	a7,20
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 390:	48a5                	li	a7,9
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <dup>:
.global dup
dup:
 li a7, SYS_dup
 398:	48a9                	li	a7,10
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a0:	48ad                	li	a7,11
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3a8:	48b1                	li	a7,12
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b0:	48b5                	li	a7,13
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b8:	48b9                	li	a7,14
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 3c0:	48d9                	li	a7,22
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 3c8:	48dd                	li	a7,23
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 3d0:	48e1                	li	a7,24
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 3d8:	48e5                	li	a7,25
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 3e0:	48e9                	li	a7,26
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e8:	1101                	addi	sp,sp,-32
 3ea:	ec06                	sd	ra,24(sp)
 3ec:	e822                	sd	s0,16(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f4:	4605                	li	a2,1
 3f6:	fef40593          	addi	a1,s0,-17
 3fa:	00000097          	auipc	ra,0x0
 3fe:	f46080e7          	jalr	-186(ra) # 340 <write>
}
 402:	60e2                	ld	ra,24(sp)
 404:	6442                	ld	s0,16(sp)
 406:	6105                	addi	sp,sp,32
 408:	8082                	ret

000000000000040a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40a:	7139                	addi	sp,sp,-64
 40c:	fc06                	sd	ra,56(sp)
 40e:	f822                	sd	s0,48(sp)
 410:	f426                	sd	s1,40(sp)
 412:	f04a                	sd	s2,32(sp)
 414:	ec4e                	sd	s3,24(sp)
 416:	0080                	addi	s0,sp,64
 418:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41a:	c299                	beqz	a3,420 <printint+0x16>
 41c:	0805c863          	bltz	a1,4ac <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 420:	2581                	sext.w	a1,a1
  neg = 0;
 422:	4881                	li	a7,0
 424:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 428:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 42a:	2601                	sext.w	a2,a2
 42c:	00000517          	auipc	a0,0x0
 430:	48c50513          	addi	a0,a0,1164 # 8b8 <digits>
 434:	883a                	mv	a6,a4
 436:	2705                	addiw	a4,a4,1
 438:	02c5f7bb          	remuw	a5,a1,a2
 43c:	1782                	slli	a5,a5,0x20
 43e:	9381                	srli	a5,a5,0x20
 440:	97aa                	add	a5,a5,a0
 442:	0007c783          	lbu	a5,0(a5)
 446:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 44a:	0005879b          	sext.w	a5,a1
 44e:	02c5d5bb          	divuw	a1,a1,a2
 452:	0685                	addi	a3,a3,1
 454:	fec7f0e3          	bgeu	a5,a2,434 <printint+0x2a>
  if(neg)
 458:	00088b63          	beqz	a7,46e <printint+0x64>
    buf[i++] = '-';
 45c:	fd040793          	addi	a5,s0,-48
 460:	973e                	add	a4,a4,a5
 462:	02d00793          	li	a5,45
 466:	fef70823          	sb	a5,-16(a4)
 46a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 46e:	02e05863          	blez	a4,49e <printint+0x94>
 472:	fc040793          	addi	a5,s0,-64
 476:	00e78933          	add	s2,a5,a4
 47a:	fff78993          	addi	s3,a5,-1
 47e:	99ba                	add	s3,s3,a4
 480:	377d                	addiw	a4,a4,-1
 482:	1702                	slli	a4,a4,0x20
 484:	9301                	srli	a4,a4,0x20
 486:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48a:	fff94583          	lbu	a1,-1(s2)
 48e:	8526                	mv	a0,s1
 490:	00000097          	auipc	ra,0x0
 494:	f58080e7          	jalr	-168(ra) # 3e8 <putc>
  while(--i >= 0)
 498:	197d                	addi	s2,s2,-1
 49a:	ff3918e3          	bne	s2,s3,48a <printint+0x80>
}
 49e:	70e2                	ld	ra,56(sp)
 4a0:	7442                	ld	s0,48(sp)
 4a2:	74a2                	ld	s1,40(sp)
 4a4:	7902                	ld	s2,32(sp)
 4a6:	69e2                	ld	s3,24(sp)
 4a8:	6121                	addi	sp,sp,64
 4aa:	8082                	ret
    x = -xx;
 4ac:	40b005bb          	negw	a1,a1
    neg = 1;
 4b0:	4885                	li	a7,1
    x = -xx;
 4b2:	bf8d                	j	424 <printint+0x1a>

00000000000004b4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b4:	7119                	addi	sp,sp,-128
 4b6:	fc86                	sd	ra,120(sp)
 4b8:	f8a2                	sd	s0,112(sp)
 4ba:	f4a6                	sd	s1,104(sp)
 4bc:	f0ca                	sd	s2,96(sp)
 4be:	ecce                	sd	s3,88(sp)
 4c0:	e8d2                	sd	s4,80(sp)
 4c2:	e4d6                	sd	s5,72(sp)
 4c4:	e0da                	sd	s6,64(sp)
 4c6:	fc5e                	sd	s7,56(sp)
 4c8:	f862                	sd	s8,48(sp)
 4ca:	f466                	sd	s9,40(sp)
 4cc:	f06a                	sd	s10,32(sp)
 4ce:	ec6e                	sd	s11,24(sp)
 4d0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4d2:	0005c903          	lbu	s2,0(a1)
 4d6:	18090f63          	beqz	s2,674 <vprintf+0x1c0>
 4da:	8aaa                	mv	s5,a0
 4dc:	8b32                	mv	s6,a2
 4de:	00158493          	addi	s1,a1,1
  state = 0;
 4e2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e4:	02500a13          	li	s4,37
      if(c == 'd'){
 4e8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4ec:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4f0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4f4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4f8:	00000b97          	auipc	s7,0x0
 4fc:	3c0b8b93          	addi	s7,s7,960 # 8b8 <digits>
 500:	a839                	j	51e <vprintf+0x6a>
        putc(fd, c);
 502:	85ca                	mv	a1,s2
 504:	8556                	mv	a0,s5
 506:	00000097          	auipc	ra,0x0
 50a:	ee2080e7          	jalr	-286(ra) # 3e8 <putc>
 50e:	a019                	j	514 <vprintf+0x60>
    } else if(state == '%'){
 510:	01498f63          	beq	s3,s4,52e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 514:	0485                	addi	s1,s1,1
 516:	fff4c903          	lbu	s2,-1(s1)
 51a:	14090d63          	beqz	s2,674 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 51e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 522:	fe0997e3          	bnez	s3,510 <vprintf+0x5c>
      if(c == '%'){
 526:	fd479ee3          	bne	a5,s4,502 <vprintf+0x4e>
        state = '%';
 52a:	89be                	mv	s3,a5
 52c:	b7e5                	j	514 <vprintf+0x60>
      if(c == 'd'){
 52e:	05878063          	beq	a5,s8,56e <vprintf+0xba>
      } else if(c == 'l') {
 532:	05978c63          	beq	a5,s9,58a <vprintf+0xd6>
      } else if(c == 'x') {
 536:	07a78863          	beq	a5,s10,5a6 <vprintf+0xf2>
      } else if(c == 'p') {
 53a:	09b78463          	beq	a5,s11,5c2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 53e:	07300713          	li	a4,115
 542:	0ce78663          	beq	a5,a4,60e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 546:	06300713          	li	a4,99
 54a:	0ee78e63          	beq	a5,a4,646 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 54e:	11478863          	beq	a5,s4,65e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 552:	85d2                	mv	a1,s4
 554:	8556                	mv	a0,s5
 556:	00000097          	auipc	ra,0x0
 55a:	e92080e7          	jalr	-366(ra) # 3e8 <putc>
        putc(fd, c);
 55e:	85ca                	mv	a1,s2
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e86080e7          	jalr	-378(ra) # 3e8 <putc>
      }
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b765                	j	514 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 56e:	008b0913          	addi	s2,s6,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000b2583          	lw	a1,0(s6)
 57a:	8556                	mv	a0,s5
 57c:	00000097          	auipc	ra,0x0
 580:	e8e080e7          	jalr	-370(ra) # 40a <printint>
 584:	8b4a                	mv	s6,s2
      state = 0;
 586:	4981                	li	s3,0
 588:	b771                	j	514 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	008b0913          	addi	s2,s6,8
 58e:	4681                	li	a3,0
 590:	4629                	li	a2,10
 592:	000b2583          	lw	a1,0(s6)
 596:	8556                	mv	a0,s5
 598:	00000097          	auipc	ra,0x0
 59c:	e72080e7          	jalr	-398(ra) # 40a <printint>
 5a0:	8b4a                	mv	s6,s2
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bf85                	j	514 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5a6:	008b0913          	addi	s2,s6,8
 5aa:	4681                	li	a3,0
 5ac:	4641                	li	a2,16
 5ae:	000b2583          	lw	a1,0(s6)
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e56080e7          	jalr	-426(ra) # 40a <printint>
 5bc:	8b4a                	mv	s6,s2
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bf91                	j	514 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5c2:	008b0793          	addi	a5,s6,8
 5c6:	f8f43423          	sd	a5,-120(s0)
 5ca:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ce:	03000593          	li	a1,48
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e14080e7          	jalr	-492(ra) # 3e8 <putc>
  putc(fd, 'x');
 5dc:	85ea                	mv	a1,s10
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e08080e7          	jalr	-504(ra) # 3e8 <putc>
 5e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ea:	03c9d793          	srli	a5,s3,0x3c
 5ee:	97de                	add	a5,a5,s7
 5f0:	0007c583          	lbu	a1,0(a5)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	df2080e7          	jalr	-526(ra) # 3e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5fe:	0992                	slli	s3,s3,0x4
 600:	397d                	addiw	s2,s2,-1
 602:	fe0914e3          	bnez	s2,5ea <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 606:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b721                	j	514 <vprintf+0x60>
        s = va_arg(ap, char*);
 60e:	008b0993          	addi	s3,s6,8
 612:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 616:	02090163          	beqz	s2,638 <vprintf+0x184>
        while(*s != 0){
 61a:	00094583          	lbu	a1,0(s2)
 61e:	c9a1                	beqz	a1,66e <vprintf+0x1ba>
          putc(fd, *s);
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	dc6080e7          	jalr	-570(ra) # 3e8 <putc>
          s++;
 62a:	0905                	addi	s2,s2,1
        while(*s != 0){
 62c:	00094583          	lbu	a1,0(s2)
 630:	f9e5                	bnez	a1,620 <vprintf+0x16c>
        s = va_arg(ap, char*);
 632:	8b4e                	mv	s6,s3
      state = 0;
 634:	4981                	li	s3,0
 636:	bdf9                	j	514 <vprintf+0x60>
          s = "(null)";
 638:	00000917          	auipc	s2,0x0
 63c:	27890913          	addi	s2,s2,632 # 8b0 <malloc+0x132>
        while(*s != 0){
 640:	02800593          	li	a1,40
 644:	bff1                	j	620 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 646:	008b0913          	addi	s2,s6,8
 64a:	000b4583          	lbu	a1,0(s6)
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	d98080e7          	jalr	-616(ra) # 3e8 <putc>
 658:	8b4a                	mv	s6,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	bd65                	j	514 <vprintf+0x60>
        putc(fd, c);
 65e:	85d2                	mv	a1,s4
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	d86080e7          	jalr	-634(ra) # 3e8 <putc>
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b565                	j	514 <vprintf+0x60>
        s = va_arg(ap, char*);
 66e:	8b4e                	mv	s6,s3
      state = 0;
 670:	4981                	li	s3,0
 672:	b54d                	j	514 <vprintf+0x60>
    }
  }
}
 674:	70e6                	ld	ra,120(sp)
 676:	7446                	ld	s0,112(sp)
 678:	74a6                	ld	s1,104(sp)
 67a:	7906                	ld	s2,96(sp)
 67c:	69e6                	ld	s3,88(sp)
 67e:	6a46                	ld	s4,80(sp)
 680:	6aa6                	ld	s5,72(sp)
 682:	6b06                	ld	s6,64(sp)
 684:	7be2                	ld	s7,56(sp)
 686:	7c42                	ld	s8,48(sp)
 688:	7ca2                	ld	s9,40(sp)
 68a:	7d02                	ld	s10,32(sp)
 68c:	6de2                	ld	s11,24(sp)
 68e:	6109                	addi	sp,sp,128
 690:	8082                	ret

0000000000000692 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 692:	715d                	addi	sp,sp,-80
 694:	ec06                	sd	ra,24(sp)
 696:	e822                	sd	s0,16(sp)
 698:	1000                	addi	s0,sp,32
 69a:	e010                	sd	a2,0(s0)
 69c:	e414                	sd	a3,8(s0)
 69e:	e818                	sd	a4,16(s0)
 6a0:	ec1c                	sd	a5,24(s0)
 6a2:	03043023          	sd	a6,32(s0)
 6a6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6aa:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ae:	8622                	mv	a2,s0
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e04080e7          	jalr	-508(ra) # 4b4 <vprintf>
}
 6b8:	60e2                	ld	ra,24(sp)
 6ba:	6442                	ld	s0,16(sp)
 6bc:	6161                	addi	sp,sp,80
 6be:	8082                	ret

00000000000006c0 <printf>:

void
printf(const char *fmt, ...)
{
 6c0:	711d                	addi	sp,sp,-96
 6c2:	ec06                	sd	ra,24(sp)
 6c4:	e822                	sd	s0,16(sp)
 6c6:	1000                	addi	s0,sp,32
 6c8:	e40c                	sd	a1,8(s0)
 6ca:	e810                	sd	a2,16(s0)
 6cc:	ec14                	sd	a3,24(s0)
 6ce:	f018                	sd	a4,32(s0)
 6d0:	f41c                	sd	a5,40(s0)
 6d2:	03043823          	sd	a6,48(s0)
 6d6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6da:	00840613          	addi	a2,s0,8
 6de:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e2:	85aa                	mv	a1,a0
 6e4:	4505                	li	a0,1
 6e6:	00000097          	auipc	ra,0x0
 6ea:	dce080e7          	jalr	-562(ra) # 4b4 <vprintf>
}
 6ee:	60e2                	ld	ra,24(sp)
 6f0:	6442                	ld	s0,16(sp)
 6f2:	6125                	addi	sp,sp,96
 6f4:	8082                	ret

00000000000006f6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f6:	1141                	addi	sp,sp,-16
 6f8:	e422                	sd	s0,8(sp)
 6fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	00001797          	auipc	a5,0x1
 704:	9007b783          	ld	a5,-1792(a5) # 1000 <freep>
 708:	a805                	j	738 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70a:	4618                	lw	a4,8(a2)
 70c:	9db9                	addw	a1,a1,a4
 70e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 712:	6398                	ld	a4,0(a5)
 714:	6318                	ld	a4,0(a4)
 716:	fee53823          	sd	a4,-16(a0)
 71a:	a091                	j	75e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71c:	ff852703          	lw	a4,-8(a0)
 720:	9e39                	addw	a2,a2,a4
 722:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 724:	ff053703          	ld	a4,-16(a0)
 728:	e398                	sd	a4,0(a5)
 72a:	a099                	j	770 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	6398                	ld	a4,0(a5)
 72e:	00e7e463          	bltu	a5,a4,736 <free+0x40>
 732:	00e6ea63          	bltu	a3,a4,746 <free+0x50>
{
 736:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	fed7fae3          	bgeu	a5,a3,72c <free+0x36>
 73c:	6398                	ld	a4,0(a5)
 73e:	00e6e463          	bltu	a3,a4,746 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	fee7eae3          	bltu	a5,a4,736 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 746:	ff852583          	lw	a1,-8(a0)
 74a:	6390                	ld	a2,0(a5)
 74c:	02059713          	slli	a4,a1,0x20
 750:	9301                	srli	a4,a4,0x20
 752:	0712                	slli	a4,a4,0x4
 754:	9736                	add	a4,a4,a3
 756:	fae60ae3          	beq	a2,a4,70a <free+0x14>
    bp->s.ptr = p->s.ptr;
 75a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75e:	4790                	lw	a2,8(a5)
 760:	02061713          	slli	a4,a2,0x20
 764:	9301                	srli	a4,a4,0x20
 766:	0712                	slli	a4,a4,0x4
 768:	973e                	add	a4,a4,a5
 76a:	fae689e3          	beq	a3,a4,71c <free+0x26>
  } else
    p->s.ptr = bp;
 76e:	e394                	sd	a3,0(a5)
  freep = p;
 770:	00001717          	auipc	a4,0x1
 774:	88f73823          	sd	a5,-1904(a4) # 1000 <freep>
}
 778:	6422                	ld	s0,8(sp)
 77a:	0141                	addi	sp,sp,16
 77c:	8082                	ret

000000000000077e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77e:	7139                	addi	sp,sp,-64
 780:	fc06                	sd	ra,56(sp)
 782:	f822                	sd	s0,48(sp)
 784:	f426                	sd	s1,40(sp)
 786:	f04a                	sd	s2,32(sp)
 788:	ec4e                	sd	s3,24(sp)
 78a:	e852                	sd	s4,16(sp)
 78c:	e456                	sd	s5,8(sp)
 78e:	e05a                	sd	s6,0(sp)
 790:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 792:	02051493          	slli	s1,a0,0x20
 796:	9081                	srli	s1,s1,0x20
 798:	04bd                	addi	s1,s1,15
 79a:	8091                	srli	s1,s1,0x4
 79c:	0014899b          	addiw	s3,s1,1
 7a0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a2:	00001517          	auipc	a0,0x1
 7a6:	85e53503          	ld	a0,-1954(a0) # 1000 <freep>
 7aa:	c515                	beqz	a0,7d6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ae:	4798                	lw	a4,8(a5)
 7b0:	02977f63          	bgeu	a4,s1,7ee <malloc+0x70>
 7b4:	8a4e                	mv	s4,s3
 7b6:	0009871b          	sext.w	a4,s3
 7ba:	6685                	lui	a3,0x1
 7bc:	00d77363          	bgeu	a4,a3,7c2 <malloc+0x44>
 7c0:	6a05                	lui	s4,0x1
 7c2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ca:	00001917          	auipc	s2,0x1
 7ce:	83690913          	addi	s2,s2,-1994 # 1000 <freep>
  if(p == (char*)-1)
 7d2:	5afd                	li	s5,-1
 7d4:	a88d                	j	846 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7d6:	00001797          	auipc	a5,0x1
 7da:	83a78793          	addi	a5,a5,-1990 # 1010 <base>
 7de:	00001717          	auipc	a4,0x1
 7e2:	82f73123          	sd	a5,-2014(a4) # 1000 <freep>
 7e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7e8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ec:	b7e1                	j	7b4 <malloc+0x36>
      if(p->s.size == nunits)
 7ee:	02e48b63          	beq	s1,a4,824 <malloc+0xa6>
        p->s.size -= nunits;
 7f2:	4137073b          	subw	a4,a4,s3
 7f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7f8:	1702                	slli	a4,a4,0x20
 7fa:	9301                	srli	a4,a4,0x20
 7fc:	0712                	slli	a4,a4,0x4
 7fe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 800:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 804:	00000717          	auipc	a4,0x0
 808:	7ea73e23          	sd	a0,2044(a4) # 1000 <freep>
      return (void*)(p + 1);
 80c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 810:	70e2                	ld	ra,56(sp)
 812:	7442                	ld	s0,48(sp)
 814:	74a2                	ld	s1,40(sp)
 816:	7902                	ld	s2,32(sp)
 818:	69e2                	ld	s3,24(sp)
 81a:	6a42                	ld	s4,16(sp)
 81c:	6aa2                	ld	s5,8(sp)
 81e:	6b02                	ld	s6,0(sp)
 820:	6121                	addi	sp,sp,64
 822:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 824:	6398                	ld	a4,0(a5)
 826:	e118                	sd	a4,0(a0)
 828:	bff1                	j	804 <malloc+0x86>
  hp->s.size = nu;
 82a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82e:	0541                	addi	a0,a0,16
 830:	00000097          	auipc	ra,0x0
 834:	ec6080e7          	jalr	-314(ra) # 6f6 <free>
  return freep;
 838:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83c:	d971                	beqz	a0,810 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 840:	4798                	lw	a4,8(a5)
 842:	fa9776e3          	bgeu	a4,s1,7ee <malloc+0x70>
    if(p == freep)
 846:	00093703          	ld	a4,0(s2)
 84a:	853e                	mv	a0,a5
 84c:	fef719e3          	bne	a4,a5,83e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 850:	8552                	mv	a0,s4
 852:	00000097          	auipc	ra,0x0
 856:	b56080e7          	jalr	-1194(ra) # 3a8 <sbrk>
  if(p == (char*)-1)
 85a:	fd5518e3          	bne	a0,s5,82a <malloc+0xac>
        return 0;
 85e:	4501                	li	a0,0
 860:	bf45                	j	810 <malloc+0x92>
