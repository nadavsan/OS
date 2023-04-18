
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8e250513          	addi	a0,a0,-1822 # 8f0 <malloc+0xe8>
  16:	00000097          	auipc	ra,0x0
  1a:	3d4080e7          	jalr	980(ra) # 3ea <open>
  1e:	06054863          	bltz	a0,8e <main+0x8e>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3fe080e7          	jalr	1022(ra) # 422 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3f4080e7          	jalr	1012(ra) # 422 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	8c290913          	addi	s2,s2,-1854 # 8f8 <malloc+0xf0>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	70a080e7          	jalr	1802(ra) # 74a <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	35a080e7          	jalr	858(ra) # 3a2 <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	06054263          	bltz	a0,b6 <main+0xb6>
      printf("init: fork failed\n");
      exit(1,"");
    }
    if(pid == 0){
  56:	c149                	beqz	a0,d8 <main+0xd8>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0,0);
  58:	4581                	li	a1,0
  5a:	4501                	li	a0,0
  5c:	00000097          	auipc	ra,0x0
  60:	356080e7          	jalr	854(ra) # 3b2 <wait>
      if(wpid == pid){
  64:	fca48de3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  68:	fe0558e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6c:	00001517          	auipc	a0,0x1
  70:	8e450513          	addi	a0,a0,-1820 # 950 <malloc+0x148>
  74:	00000097          	auipc	ra,0x0
  78:	6d6080e7          	jalr	1750(ra) # 74a <printf>
        exit(1,"");
  7c:	00001597          	auipc	a1,0x1
  80:	8ac58593          	addi	a1,a1,-1876 # 928 <malloc+0x120>
  84:	4505                	li	a0,1
  86:	00000097          	auipc	ra,0x0
  8a:	324080e7          	jalr	804(ra) # 3aa <exit>
    mknod("console", CONSOLE, 0);
  8e:	4601                	li	a2,0
  90:	4585                	li	a1,1
  92:	00001517          	auipc	a0,0x1
  96:	85e50513          	addi	a0,a0,-1954 # 8f0 <malloc+0xe8>
  9a:	00000097          	auipc	ra,0x0
  9e:	358080e7          	jalr	856(ra) # 3f2 <mknod>
    open("console", O_RDWR);
  a2:	4589                	li	a1,2
  a4:	00001517          	auipc	a0,0x1
  a8:	84c50513          	addi	a0,a0,-1972 # 8f0 <malloc+0xe8>
  ac:	00000097          	auipc	ra,0x0
  b0:	33e080e7          	jalr	830(ra) # 3ea <open>
  b4:	b7bd                	j	22 <main+0x22>
      printf("init: fork failed\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	85a50513          	addi	a0,a0,-1958 # 910 <malloc+0x108>
  be:	00000097          	auipc	ra,0x0
  c2:	68c080e7          	jalr	1676(ra) # 74a <printf>
      exit(1,"");
  c6:	00001597          	auipc	a1,0x1
  ca:	86258593          	addi	a1,a1,-1950 # 928 <malloc+0x120>
  ce:	4505                	li	a0,1
  d0:	00000097          	auipc	ra,0x0
  d4:	2da080e7          	jalr	730(ra) # 3aa <exit>
      exec("sh", argv);
  d8:	00001597          	auipc	a1,0x1
  dc:	f2858593          	addi	a1,a1,-216 # 1000 <argv>
  e0:	00001517          	auipc	a0,0x1
  e4:	85050513          	addi	a0,a0,-1968 # 930 <malloc+0x128>
  e8:	00000097          	auipc	ra,0x0
  ec:	2fa080e7          	jalr	762(ra) # 3e2 <exec>
      printf("init: exec sh failed\n");
  f0:	00001517          	auipc	a0,0x1
  f4:	84850513          	addi	a0,a0,-1976 # 938 <malloc+0x130>
  f8:	00000097          	auipc	ra,0x0
  fc:	652080e7          	jalr	1618(ra) # 74a <printf>
      exit(1,"");
 100:	00001597          	auipc	a1,0x1
 104:	82858593          	addi	a1,a1,-2008 # 928 <malloc+0x120>
 108:	4505                	li	a0,1
 10a:	00000097          	auipc	ra,0x0
 10e:	2a0080e7          	jalr	672(ra) # 3aa <exit>

0000000000000112 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  extern int main();
  main();
 11a:	00000097          	auipc	ra,0x0
 11e:	ee6080e7          	jalr	-282(ra) # 0 <main>
  exit(0,"");
 122:	00001597          	auipc	a1,0x1
 126:	80658593          	addi	a1,a1,-2042 # 928 <malloc+0x120>
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	27e080e7          	jalr	638(ra) # 3aa <exit>

0000000000000134 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 134:	1141                	addi	sp,sp,-16
 136:	e422                	sd	s0,8(sp)
 138:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13a:	87aa                	mv	a5,a0
 13c:	0585                	addi	a1,a1,1
 13e:	0785                	addi	a5,a5,1
 140:	fff5c703          	lbu	a4,-1(a1)
 144:	fee78fa3          	sb	a4,-1(a5)
 148:	fb75                	bnez	a4,13c <strcpy+0x8>
    ;
  return os;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret

0000000000000150 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 150:	1141                	addi	sp,sp,-16
 152:	e422                	sd	s0,8(sp)
 154:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cb91                	beqz	a5,16e <strcmp+0x1e>
 15c:	0005c703          	lbu	a4,0(a1)
 160:	00f71763          	bne	a4,a5,16e <strcmp+0x1e>
    p++, q++;
 164:	0505                	addi	a0,a0,1
 166:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbe5                	bnez	a5,15c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16e:	0005c503          	lbu	a0,0(a1)
}
 172:	40a7853b          	subw	a0,a5,a0
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strlen>:

uint
strlen(const char *s)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf91                	beqz	a5,1a2 <strlen+0x26>
 188:	0505                	addi	a0,a0,1
 18a:	87aa                	mv	a5,a0
 18c:	4685                	li	a3,1
 18e:	9e89                	subw	a3,a3,a0
 190:	00f6853b          	addw	a0,a3,a5
 194:	0785                	addi	a5,a5,1
 196:	fff7c703          	lbu	a4,-1(a5)
 19a:	fb7d                	bnez	a4,190 <strlen+0x14>
    ;
  return n;
}
 19c:	6422                	ld	s0,8(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
  for(n = 0; s[n]; n++)
 1a2:	4501                	li	a0,0
 1a4:	bfe5                	j	19c <strlen+0x20>

00000000000001a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ac:	ce09                	beqz	a2,1c6 <memset+0x20>
 1ae:	87aa                	mv	a5,a0
 1b0:	fff6071b          	addiw	a4,a2,-1
 1b4:	1702                	slli	a4,a4,0x20
 1b6:	9301                	srli	a4,a4,0x20
 1b8:	0705                	addi	a4,a4,1
 1ba:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c0:	0785                	addi	a5,a5,1
 1c2:	fee79de3          	bne	a5,a4,1bc <memset+0x16>
  }
  return dst;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strchr>:

char*
strchr(const char *s, char c)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb99                	beqz	a5,1ec <strchr+0x20>
    if(*s == c)
 1d8:	00f58763          	beq	a1,a5,1e6 <strchr+0x1a>
  for(; *s; s++)
 1dc:	0505                	addi	a0,a0,1
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbfd                	bnez	a5,1d8 <strchr+0xc>
      return (char*)s;
  return 0;
 1e4:	4501                	li	a0,0
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
  return 0;
 1ec:	4501                	li	a0,0
 1ee:	bfe5                	j	1e6 <strchr+0x1a>

00000000000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	711d                	addi	sp,sp,-96
 1f2:	ec86                	sd	ra,88(sp)
 1f4:	e8a2                	sd	s0,80(sp)
 1f6:	e4a6                	sd	s1,72(sp)
 1f8:	e0ca                	sd	s2,64(sp)
 1fa:	fc4e                	sd	s3,56(sp)
 1fc:	f852                	sd	s4,48(sp)
 1fe:	f456                	sd	s5,40(sp)
 200:	f05a                	sd	s6,32(sp)
 202:	ec5e                	sd	s7,24(sp)
 204:	1080                	addi	s0,sp,96
 206:	8baa                	mv	s7,a0
 208:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20a:	892a                	mv	s2,a0
 20c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20e:	4aa9                	li	s5,10
 210:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 212:	89a6                	mv	s3,s1
 214:	2485                	addiw	s1,s1,1
 216:	0344d863          	bge	s1,s4,246 <gets+0x56>
    cc = read(0, &c, 1);
 21a:	4605                	li	a2,1
 21c:	faf40593          	addi	a1,s0,-81
 220:	4501                	li	a0,0
 222:	00000097          	auipc	ra,0x0
 226:	1a0080e7          	jalr	416(ra) # 3c2 <read>
    if(cc < 1)
 22a:	00a05e63          	blez	a0,246 <gets+0x56>
    buf[i++] = c;
 22e:	faf44783          	lbu	a5,-81(s0)
 232:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 236:	01578763          	beq	a5,s5,244 <gets+0x54>
 23a:	0905                	addi	s2,s2,1
 23c:	fd679be3          	bne	a5,s6,212 <gets+0x22>
  for(i=0; i+1 < max; ){
 240:	89a6                	mv	s3,s1
 242:	a011                	j	246 <gets+0x56>
 244:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 246:	99de                	add	s3,s3,s7
 248:	00098023          	sb	zero,0(s3)
  return buf;
}
 24c:	855e                	mv	a0,s7
 24e:	60e6                	ld	ra,88(sp)
 250:	6446                	ld	s0,80(sp)
 252:	64a6                	ld	s1,72(sp)
 254:	6906                	ld	s2,64(sp)
 256:	79e2                	ld	s3,56(sp)
 258:	7a42                	ld	s4,48(sp)
 25a:	7aa2                	ld	s5,40(sp)
 25c:	7b02                	ld	s6,32(sp)
 25e:	6be2                	ld	s7,24(sp)
 260:	6125                	addi	sp,sp,96
 262:	8082                	ret

0000000000000264 <stat>:

int
stat(const char *n, struct stat *st)
{
 264:	1101                	addi	sp,sp,-32
 266:	ec06                	sd	ra,24(sp)
 268:	e822                	sd	s0,16(sp)
 26a:	e426                	sd	s1,8(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	4581                	li	a1,0
 274:	00000097          	auipc	ra,0x0
 278:	176080e7          	jalr	374(ra) # 3ea <open>
  if(fd < 0)
 27c:	02054563          	bltz	a0,2a6 <stat+0x42>
 280:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 282:	85ca                	mv	a1,s2
 284:	00000097          	auipc	ra,0x0
 288:	17e080e7          	jalr	382(ra) # 402 <fstat>
 28c:	892a                	mv	s2,a0
  close(fd);
 28e:	8526                	mv	a0,s1
 290:	00000097          	auipc	ra,0x0
 294:	142080e7          	jalr	322(ra) # 3d2 <close>
  return r;
}
 298:	854a                	mv	a0,s2
 29a:	60e2                	ld	ra,24(sp)
 29c:	6442                	ld	s0,16(sp)
 29e:	64a2                	ld	s1,8(sp)
 2a0:	6902                	ld	s2,0(sp)
 2a2:	6105                	addi	sp,sp,32
 2a4:	8082                	ret
    return -1;
 2a6:	597d                	li	s2,-1
 2a8:	bfc5                	j	298 <stat+0x34>

00000000000002aa <atoi>:

int
atoi(const char *s)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b0:	00054603          	lbu	a2,0(a0)
 2b4:	fd06079b          	addiw	a5,a2,-48
 2b8:	0ff7f793          	andi	a5,a5,255
 2bc:	4725                	li	a4,9
 2be:	02f76963          	bltu	a4,a5,2f0 <atoi+0x46>
 2c2:	86aa                	mv	a3,a0
  n = 0;
 2c4:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2c6:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2c8:	0685                	addi	a3,a3,1
 2ca:	0025179b          	slliw	a5,a0,0x2
 2ce:	9fa9                	addw	a5,a5,a0
 2d0:	0017979b          	slliw	a5,a5,0x1
 2d4:	9fb1                	addw	a5,a5,a2
 2d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2da:	0006c603          	lbu	a2,0(a3)
 2de:	fd06071b          	addiw	a4,a2,-48
 2e2:	0ff77713          	andi	a4,a4,255
 2e6:	fee5f1e3          	bgeu	a1,a4,2c8 <atoi+0x1e>
  return n;
}
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  n = 0;
 2f0:	4501                	li	a0,0
 2f2:	bfe5                	j	2ea <atoi+0x40>

00000000000002f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fa:	02b57663          	bgeu	a0,a1,326 <memmove+0x32>
    while(n-- > 0)
 2fe:	02c05163          	blez	a2,320 <memmove+0x2c>
 302:	fff6079b          	addiw	a5,a2,-1
 306:	1782                	slli	a5,a5,0x20
 308:	9381                	srli	a5,a5,0x20
 30a:	0785                	addi	a5,a5,1
 30c:	97aa                	add	a5,a5,a0
  dst = vdst;
 30e:	872a                	mv	a4,a0
      *dst++ = *src++;
 310:	0585                	addi	a1,a1,1
 312:	0705                	addi	a4,a4,1
 314:	fff5c683          	lbu	a3,-1(a1)
 318:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31c:	fee79ae3          	bne	a5,a4,310 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
    dst += n;
 326:	00c50733          	add	a4,a0,a2
    src += n;
 32a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 32c:	fec05ae3          	blez	a2,320 <memmove+0x2c>
 330:	fff6079b          	addiw	a5,a2,-1
 334:	1782                	slli	a5,a5,0x20
 336:	9381                	srli	a5,a5,0x20
 338:	fff7c793          	not	a5,a5
 33c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33e:	15fd                	addi	a1,a1,-1
 340:	177d                	addi	a4,a4,-1
 342:	0005c683          	lbu	a3,0(a1)
 346:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 34a:	fee79ae3          	bne	a5,a4,33e <memmove+0x4a>
 34e:	bfc9                	j	320 <memmove+0x2c>

0000000000000350 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 350:	1141                	addi	sp,sp,-16
 352:	e422                	sd	s0,8(sp)
 354:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 356:	ca05                	beqz	a2,386 <memcmp+0x36>
 358:	fff6069b          	addiw	a3,a2,-1
 35c:	1682                	slli	a3,a3,0x20
 35e:	9281                	srli	a3,a3,0x20
 360:	0685                	addi	a3,a3,1
 362:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 364:	00054783          	lbu	a5,0(a0)
 368:	0005c703          	lbu	a4,0(a1)
 36c:	00e79863          	bne	a5,a4,37c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 370:	0505                	addi	a0,a0,1
    p2++;
 372:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 374:	fed518e3          	bne	a0,a3,364 <memcmp+0x14>
  }
  return 0;
 378:	4501                	li	a0,0
 37a:	a019                	j	380 <memcmp+0x30>
      return *p1 - *p2;
 37c:	40e7853b          	subw	a0,a5,a4
}
 380:	6422                	ld	s0,8(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
  return 0;
 386:	4501                	li	a0,0
 388:	bfe5                	j	380 <memcmp+0x30>

000000000000038a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 392:	00000097          	auipc	ra,0x0
 396:	f62080e7          	jalr	-158(ra) # 2f4 <memmove>
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a2:	4885                	li	a7,1
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3aa:	4889                	li	a7,2
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b2:	488d                	li	a7,3
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ba:	4891                	li	a7,4
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <read>:
.global read
read:
 li a7, SYS_read
 3c2:	4895                	li	a7,5
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <write>:
.global write
write:
 li a7, SYS_write
 3ca:	48c1                	li	a7,16
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <close>:
.global close
close:
 li a7, SYS_close
 3d2:	48d5                	li	a7,21
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kill>:
.global kill
kill:
 li a7, SYS_kill
 3da:	4899                	li	a7,6
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e2:	489d                	li	a7,7
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f2:	48c5                	li	a7,17
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fa:	48c9                	li	a7,18
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 402:	48a1                	li	a7,8
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41a:	48a5                	li	a7,9
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <dup>:
.global dup
dup:
 li a7, SYS_dup
 422:	48a9                	li	a7,10
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42a:	48ad                	li	a7,11
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 432:	48b1                	li	a7,12
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43a:	48b5                	li	a7,13
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 442:	48b9                	li	a7,14
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 44a:	48d9                	li	a7,22
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 452:	48dd                	li	a7,23
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 45a:	48e1                	li	a7,24
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 462:	48e5                	li	a7,25
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 46a:	48e9                	li	a7,26
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 472:	1101                	addi	sp,sp,-32
 474:	ec06                	sd	ra,24(sp)
 476:	e822                	sd	s0,16(sp)
 478:	1000                	addi	s0,sp,32
 47a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47e:	4605                	li	a2,1
 480:	fef40593          	addi	a1,s0,-17
 484:	00000097          	auipc	ra,0x0
 488:	f46080e7          	jalr	-186(ra) # 3ca <write>
}
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	6105                	addi	sp,sp,32
 492:	8082                	ret

0000000000000494 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 494:	7139                	addi	sp,sp,-64
 496:	fc06                	sd	ra,56(sp)
 498:	f822                	sd	s0,48(sp)
 49a:	f426                	sd	s1,40(sp)
 49c:	f04a                	sd	s2,32(sp)
 49e:	ec4e                	sd	s3,24(sp)
 4a0:	0080                	addi	s0,sp,64
 4a2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4a4:	c299                	beqz	a3,4aa <printint+0x16>
 4a6:	0805c863          	bltz	a1,536 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4aa:	2581                	sext.w	a1,a1
  neg = 0;
 4ac:	4881                	li	a7,0
 4ae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4b4:	2601                	sext.w	a2,a2
 4b6:	00000517          	auipc	a0,0x0
 4ba:	4c250513          	addi	a0,a0,1218 # 978 <digits>
 4be:	883a                	mv	a6,a4
 4c0:	2705                	addiw	a4,a4,1
 4c2:	02c5f7bb          	remuw	a5,a1,a2
 4c6:	1782                	slli	a5,a5,0x20
 4c8:	9381                	srli	a5,a5,0x20
 4ca:	97aa                	add	a5,a5,a0
 4cc:	0007c783          	lbu	a5,0(a5)
 4d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4d4:	0005879b          	sext.w	a5,a1
 4d8:	02c5d5bb          	divuw	a1,a1,a2
 4dc:	0685                	addi	a3,a3,1
 4de:	fec7f0e3          	bgeu	a5,a2,4be <printint+0x2a>
  if(neg)
 4e2:	00088b63          	beqz	a7,4f8 <printint+0x64>
    buf[i++] = '-';
 4e6:	fd040793          	addi	a5,s0,-48
 4ea:	973e                	add	a4,a4,a5
 4ec:	02d00793          	li	a5,45
 4f0:	fef70823          	sb	a5,-16(a4)
 4f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4f8:	02e05863          	blez	a4,528 <printint+0x94>
 4fc:	fc040793          	addi	a5,s0,-64
 500:	00e78933          	add	s2,a5,a4
 504:	fff78993          	addi	s3,a5,-1
 508:	99ba                	add	s3,s3,a4
 50a:	377d                	addiw	a4,a4,-1
 50c:	1702                	slli	a4,a4,0x20
 50e:	9301                	srli	a4,a4,0x20
 510:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 514:	fff94583          	lbu	a1,-1(s2)
 518:	8526                	mv	a0,s1
 51a:	00000097          	auipc	ra,0x0
 51e:	f58080e7          	jalr	-168(ra) # 472 <putc>
  while(--i >= 0)
 522:	197d                	addi	s2,s2,-1
 524:	ff3918e3          	bne	s2,s3,514 <printint+0x80>
}
 528:	70e2                	ld	ra,56(sp)
 52a:	7442                	ld	s0,48(sp)
 52c:	74a2                	ld	s1,40(sp)
 52e:	7902                	ld	s2,32(sp)
 530:	69e2                	ld	s3,24(sp)
 532:	6121                	addi	sp,sp,64
 534:	8082                	ret
    x = -xx;
 536:	40b005bb          	negw	a1,a1
    neg = 1;
 53a:	4885                	li	a7,1
    x = -xx;
 53c:	bf8d                	j	4ae <printint+0x1a>

000000000000053e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53e:	7119                	addi	sp,sp,-128
 540:	fc86                	sd	ra,120(sp)
 542:	f8a2                	sd	s0,112(sp)
 544:	f4a6                	sd	s1,104(sp)
 546:	f0ca                	sd	s2,96(sp)
 548:	ecce                	sd	s3,88(sp)
 54a:	e8d2                	sd	s4,80(sp)
 54c:	e4d6                	sd	s5,72(sp)
 54e:	e0da                	sd	s6,64(sp)
 550:	fc5e                	sd	s7,56(sp)
 552:	f862                	sd	s8,48(sp)
 554:	f466                	sd	s9,40(sp)
 556:	f06a                	sd	s10,32(sp)
 558:	ec6e                	sd	s11,24(sp)
 55a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 55c:	0005c903          	lbu	s2,0(a1)
 560:	18090f63          	beqz	s2,6fe <vprintf+0x1c0>
 564:	8aaa                	mv	s5,a0
 566:	8b32                	mv	s6,a2
 568:	00158493          	addi	s1,a1,1
  state = 0;
 56c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 56e:	02500a13          	li	s4,37
      if(c == 'd'){
 572:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 576:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 57a:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 57e:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 582:	00000b97          	auipc	s7,0x0
 586:	3f6b8b93          	addi	s7,s7,1014 # 978 <digits>
 58a:	a839                	j	5a8 <vprintf+0x6a>
        putc(fd, c);
 58c:	85ca                	mv	a1,s2
 58e:	8556                	mv	a0,s5
 590:	00000097          	auipc	ra,0x0
 594:	ee2080e7          	jalr	-286(ra) # 472 <putc>
 598:	a019                	j	59e <vprintf+0x60>
    } else if(state == '%'){
 59a:	01498f63          	beq	s3,s4,5b8 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 59e:	0485                	addi	s1,s1,1
 5a0:	fff4c903          	lbu	s2,-1(s1)
 5a4:	14090d63          	beqz	s2,6fe <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5a8:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5ac:	fe0997e3          	bnez	s3,59a <vprintf+0x5c>
      if(c == '%'){
 5b0:	fd479ee3          	bne	a5,s4,58c <vprintf+0x4e>
        state = '%';
 5b4:	89be                	mv	s3,a5
 5b6:	b7e5                	j	59e <vprintf+0x60>
      if(c == 'd'){
 5b8:	05878063          	beq	a5,s8,5f8 <vprintf+0xba>
      } else if(c == 'l') {
 5bc:	05978c63          	beq	a5,s9,614 <vprintf+0xd6>
      } else if(c == 'x') {
 5c0:	07a78863          	beq	a5,s10,630 <vprintf+0xf2>
      } else if(c == 'p') {
 5c4:	09b78463          	beq	a5,s11,64c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5c8:	07300713          	li	a4,115
 5cc:	0ce78663          	beq	a5,a4,698 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d0:	06300713          	li	a4,99
 5d4:	0ee78e63          	beq	a5,a4,6d0 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5d8:	11478863          	beq	a5,s4,6e8 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5dc:	85d2                	mv	a1,s4
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e92080e7          	jalr	-366(ra) # 472 <putc>
        putc(fd, c);
 5e8:	85ca                	mv	a1,s2
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	e86080e7          	jalr	-378(ra) # 472 <putc>
      }
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b765                	j	59e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 5f8:	008b0913          	addi	s2,s6,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000b2583          	lw	a1,0(s6)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e8e080e7          	jalr	-370(ra) # 494 <printint>
 60e:	8b4a                	mv	s6,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	b771                	j	59e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b0913          	addi	s2,s6,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000b2583          	lw	a1,0(s6)
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e72080e7          	jalr	-398(ra) # 494 <printint>
 62a:	8b4a                	mv	s6,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bf85                	j	59e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 630:	008b0913          	addi	s2,s6,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000b2583          	lw	a1,0(s6)
 63c:	8556                	mv	a0,s5
 63e:	00000097          	auipc	ra,0x0
 642:	e56080e7          	jalr	-426(ra) # 494 <printint>
 646:	8b4a                	mv	s6,s2
      state = 0;
 648:	4981                	li	s3,0
 64a:	bf91                	j	59e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 64c:	008b0793          	addi	a5,s6,8
 650:	f8f43423          	sd	a5,-120(s0)
 654:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 658:	03000593          	li	a1,48
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	e14080e7          	jalr	-492(ra) # 472 <putc>
  putc(fd, 'x');
 666:	85ea                	mv	a1,s10
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e08080e7          	jalr	-504(ra) # 472 <putc>
 672:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 674:	03c9d793          	srli	a5,s3,0x3c
 678:	97de                	add	a5,a5,s7
 67a:	0007c583          	lbu	a1,0(a5)
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	df2080e7          	jalr	-526(ra) # 472 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 688:	0992                	slli	s3,s3,0x4
 68a:	397d                	addiw	s2,s2,-1
 68c:	fe0914e3          	bnez	s2,674 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 690:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 694:	4981                	li	s3,0
 696:	b721                	j	59e <vprintf+0x60>
        s = va_arg(ap, char*);
 698:	008b0993          	addi	s3,s6,8
 69c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6a0:	02090163          	beqz	s2,6c2 <vprintf+0x184>
        while(*s != 0){
 6a4:	00094583          	lbu	a1,0(s2)
 6a8:	c9a1                	beqz	a1,6f8 <vprintf+0x1ba>
          putc(fd, *s);
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dc6080e7          	jalr	-570(ra) # 472 <putc>
          s++;
 6b4:	0905                	addi	s2,s2,1
        while(*s != 0){
 6b6:	00094583          	lbu	a1,0(s2)
 6ba:	f9e5                	bnez	a1,6aa <vprintf+0x16c>
        s = va_arg(ap, char*);
 6bc:	8b4e                	mv	s6,s3
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bdf9                	j	59e <vprintf+0x60>
          s = "(null)";
 6c2:	00000917          	auipc	s2,0x0
 6c6:	2ae90913          	addi	s2,s2,686 # 970 <malloc+0x168>
        while(*s != 0){
 6ca:	02800593          	li	a1,40
 6ce:	bff1                	j	6aa <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6d0:	008b0913          	addi	s2,s6,8
 6d4:	000b4583          	lbu	a1,0(s6)
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	d98080e7          	jalr	-616(ra) # 472 <putc>
 6e2:	8b4a                	mv	s6,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bd65                	j	59e <vprintf+0x60>
        putc(fd, c);
 6e8:	85d2                	mv	a1,s4
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	d86080e7          	jalr	-634(ra) # 472 <putc>
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b565                	j	59e <vprintf+0x60>
        s = va_arg(ap, char*);
 6f8:	8b4e                	mv	s6,s3
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b54d                	j	59e <vprintf+0x60>
    }
  }
}
 6fe:	70e6                	ld	ra,120(sp)
 700:	7446                	ld	s0,112(sp)
 702:	74a6                	ld	s1,104(sp)
 704:	7906                	ld	s2,96(sp)
 706:	69e6                	ld	s3,88(sp)
 708:	6a46                	ld	s4,80(sp)
 70a:	6aa6                	ld	s5,72(sp)
 70c:	6b06                	ld	s6,64(sp)
 70e:	7be2                	ld	s7,56(sp)
 710:	7c42                	ld	s8,48(sp)
 712:	7ca2                	ld	s9,40(sp)
 714:	7d02                	ld	s10,32(sp)
 716:	6de2                	ld	s11,24(sp)
 718:	6109                	addi	sp,sp,128
 71a:	8082                	ret

000000000000071c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71c:	715d                	addi	sp,sp,-80
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e010                	sd	a2,0(s0)
 726:	e414                	sd	a3,8(s0)
 728:	e818                	sd	a4,16(s0)
 72a:	ec1c                	sd	a5,24(s0)
 72c:	03043023          	sd	a6,32(s0)
 730:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 738:	8622                	mv	a2,s0
 73a:	00000097          	auipc	ra,0x0
 73e:	e04080e7          	jalr	-508(ra) # 53e <vprintf>
}
 742:	60e2                	ld	ra,24(sp)
 744:	6442                	ld	s0,16(sp)
 746:	6161                	addi	sp,sp,80
 748:	8082                	ret

000000000000074a <printf>:

void
printf(const char *fmt, ...)
{
 74a:	711d                	addi	sp,sp,-96
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	e40c                	sd	a1,8(s0)
 754:	e810                	sd	a2,16(s0)
 756:	ec14                	sd	a3,24(s0)
 758:	f018                	sd	a4,32(s0)
 75a:	f41c                	sd	a5,40(s0)
 75c:	03043823          	sd	a6,48(s0)
 760:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 764:	00840613          	addi	a2,s0,8
 768:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 76c:	85aa                	mv	a1,a0
 76e:	4505                	li	a0,1
 770:	00000097          	auipc	ra,0x0
 774:	dce080e7          	jalr	-562(ra) # 53e <vprintf>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6125                	addi	sp,sp,96
 77e:	8082                	ret

0000000000000780 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 780:	1141                	addi	sp,sp,-16
 782:	e422                	sd	s0,8(sp)
 784:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 786:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	00001797          	auipc	a5,0x1
 78e:	8867b783          	ld	a5,-1914(a5) # 1010 <freep>
 792:	a805                	j	7c2 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 794:	4618                	lw	a4,8(a2)
 796:	9db9                	addw	a1,a1,a4
 798:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79c:	6398                	ld	a4,0(a5)
 79e:	6318                	ld	a4,0(a4)
 7a0:	fee53823          	sd	a4,-16(a0)
 7a4:	a091                	j	7e8 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a6:	ff852703          	lw	a4,-8(a0)
 7aa:	9e39                	addw	a2,a2,a4
 7ac:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7ae:	ff053703          	ld	a4,-16(a0)
 7b2:	e398                	sd	a4,0(a5)
 7b4:	a099                	j	7fa <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b6:	6398                	ld	a4,0(a5)
 7b8:	00e7e463          	bltu	a5,a4,7c0 <free+0x40>
 7bc:	00e6ea63          	bltu	a3,a4,7d0 <free+0x50>
{
 7c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c2:	fed7fae3          	bgeu	a5,a3,7b6 <free+0x36>
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e6e463          	bltu	a3,a4,7d0 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7cc:	fee7eae3          	bltu	a5,a4,7c0 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7d0:	ff852583          	lw	a1,-8(a0)
 7d4:	6390                	ld	a2,0(a5)
 7d6:	02059713          	slli	a4,a1,0x20
 7da:	9301                	srli	a4,a4,0x20
 7dc:	0712                	slli	a4,a4,0x4
 7de:	9736                	add	a4,a4,a3
 7e0:	fae60ae3          	beq	a2,a4,794 <free+0x14>
    bp->s.ptr = p->s.ptr;
 7e4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7e8:	4790                	lw	a2,8(a5)
 7ea:	02061713          	slli	a4,a2,0x20
 7ee:	9301                	srli	a4,a4,0x20
 7f0:	0712                	slli	a4,a4,0x4
 7f2:	973e                	add	a4,a4,a5
 7f4:	fae689e3          	beq	a3,a4,7a6 <free+0x26>
  } else
    p->s.ptr = bp;
 7f8:	e394                	sd	a3,0(a5)
  freep = p;
 7fa:	00001717          	auipc	a4,0x1
 7fe:	80f73b23          	sd	a5,-2026(a4) # 1010 <freep>
}
 802:	6422                	ld	s0,8(sp)
 804:	0141                	addi	sp,sp,16
 806:	8082                	ret

0000000000000808 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 808:	7139                	addi	sp,sp,-64
 80a:	fc06                	sd	ra,56(sp)
 80c:	f822                	sd	s0,48(sp)
 80e:	f426                	sd	s1,40(sp)
 810:	f04a                	sd	s2,32(sp)
 812:	ec4e                	sd	s3,24(sp)
 814:	e852                	sd	s4,16(sp)
 816:	e456                	sd	s5,8(sp)
 818:	e05a                	sd	s6,0(sp)
 81a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81c:	02051493          	slli	s1,a0,0x20
 820:	9081                	srli	s1,s1,0x20
 822:	04bd                	addi	s1,s1,15
 824:	8091                	srli	s1,s1,0x4
 826:	0014899b          	addiw	s3,s1,1
 82a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 82c:	00000517          	auipc	a0,0x0
 830:	7e453503          	ld	a0,2020(a0) # 1010 <freep>
 834:	c515                	beqz	a0,860 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 836:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 838:	4798                	lw	a4,8(a5)
 83a:	02977f63          	bgeu	a4,s1,878 <malloc+0x70>
 83e:	8a4e                	mv	s4,s3
 840:	0009871b          	sext.w	a4,s3
 844:	6685                	lui	a3,0x1
 846:	00d77363          	bgeu	a4,a3,84c <malloc+0x44>
 84a:	6a05                	lui	s4,0x1
 84c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 850:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 854:	00000917          	auipc	s2,0x0
 858:	7bc90913          	addi	s2,s2,1980 # 1010 <freep>
  if(p == (char*)-1)
 85c:	5afd                	li	s5,-1
 85e:	a88d                	j	8d0 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 860:	00000797          	auipc	a5,0x0
 864:	7c078793          	addi	a5,a5,1984 # 1020 <base>
 868:	00000717          	auipc	a4,0x0
 86c:	7af73423          	sd	a5,1960(a4) # 1010 <freep>
 870:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 872:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 876:	b7e1                	j	83e <malloc+0x36>
      if(p->s.size == nunits)
 878:	02e48b63          	beq	s1,a4,8ae <malloc+0xa6>
        p->s.size -= nunits;
 87c:	4137073b          	subw	a4,a4,s3
 880:	c798                	sw	a4,8(a5)
        p += p->s.size;
 882:	1702                	slli	a4,a4,0x20
 884:	9301                	srli	a4,a4,0x20
 886:	0712                	slli	a4,a4,0x4
 888:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88e:	00000717          	auipc	a4,0x0
 892:	78a73123          	sd	a0,1922(a4) # 1010 <freep>
      return (void*)(p + 1);
 896:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 89a:	70e2                	ld	ra,56(sp)
 89c:	7442                	ld	s0,48(sp)
 89e:	74a2                	ld	s1,40(sp)
 8a0:	7902                	ld	s2,32(sp)
 8a2:	69e2                	ld	s3,24(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
 8aa:	6121                	addi	sp,sp,64
 8ac:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	e118                	sd	a4,0(a0)
 8b2:	bff1                	j	88e <malloc+0x86>
  hp->s.size = nu;
 8b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b8:	0541                	addi	a0,a0,16
 8ba:	00000097          	auipc	ra,0x0
 8be:	ec6080e7          	jalr	-314(ra) # 780 <free>
  return freep;
 8c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c6:	d971                	beqz	a0,89a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ca:	4798                	lw	a4,8(a5)
 8cc:	fa9776e3          	bgeu	a4,s1,878 <malloc+0x70>
    if(p == freep)
 8d0:	00093703          	ld	a4,0(s2)
 8d4:	853e                	mv	a0,a5
 8d6:	fef719e3          	bne	a4,a5,8c8 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8da:	8552                	mv	a0,s4
 8dc:	00000097          	auipc	ra,0x0
 8e0:	b56080e7          	jalr	-1194(ra) # 432 <sbrk>
  if(p == (char*)-1)
 8e4:	fd5518e3          	bne	a0,s5,8b4 <malloc+0xac>
        return 0;
 8e8:	4501                	li	a0,0
 8ea:	bf45                	j	89a <malloc+0x92>
