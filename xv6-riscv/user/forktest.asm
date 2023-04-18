
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	1a8080e7          	jalr	424(ra) # 1b4 <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	3e6080e7          	jalr	998(ra) # 402 <write>
}
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:

void
forktest(void)
{
  2e:	1101                	addi	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	e04a                	sd	s2,0(sp)
  38:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  3a:	00000517          	auipc	a0,0x0
  3e:	47650513          	addi	a0,a0,1142 # 4b0 <set_policy+0xe>
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <print>

  for(n=0; n<N; n++){
  4a:	4481                	li	s1,0
  4c:	3e800913          	li	s2,1000
    pid = fork();
  50:	00000097          	auipc	ra,0x0
  54:	38a080e7          	jalr	906(ra) # 3da <fork>
    if(pid < 0)
  58:	02054f63          	bltz	a0,96 <forktest+0x68>
      break;
    if(pid == 0)
  5c:	c50d                	beqz	a0,86 <forktest+0x58>
  for(n=0; n<N; n++){
  5e:	2485                	addiw	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <forktest+0x22>
      exit(0,"");
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  64:	00000517          	auipc	a0,0x0
  68:	46450513          	addi	a0,a0,1124 # 4c8 <set_policy+0x26>
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <print>
    exit(1,"");
  74:	00000597          	auipc	a1,0x0
  78:	44c58593          	addi	a1,a1,1100 # 4c0 <set_policy+0x1e>
  7c:	4505                	li	a0,1
  7e:	00000097          	auipc	ra,0x0
  82:	364080e7          	jalr	868(ra) # 3e2 <exit>
      exit(0,"");
  86:	00000597          	auipc	a1,0x0
  8a:	43a58593          	addi	a1,a1,1082 # 4c0 <set_policy+0x1e>
  8e:	00000097          	auipc	ra,0x0
  92:	354080e7          	jalr	852(ra) # 3e2 <exit>
  if(n == N){
  96:	3e800793          	li	a5,1000
  9a:	fcf485e3          	beq	s1,a5,64 <forktest+0x36>
  }

  for(; n > 0; n--){
  9e:	00905c63          	blez	s1,b6 <forktest+0x88>
    if(wait(0,0) < 0){
  a2:	4581                	li	a1,0
  a4:	4501                	li	a0,0
  a6:	00000097          	auipc	ra,0x0
  aa:	344080e7          	jalr	836(ra) # 3ea <wait>
  ae:	02054b63          	bltz	a0,e4 <forktest+0xb6>
  for(; n > 0; n--){
  b2:	34fd                	addiw	s1,s1,-1
  b4:	f4fd                	bnez	s1,a2 <forktest+0x74>
      print("wait stopped early\n");
      exit(1,"");
    }
  }

  if(wait(0,0) != -1){
  b6:	4581                	li	a1,0
  b8:	4501                	li	a0,0
  ba:	00000097          	auipc	ra,0x0
  be:	330080e7          	jalr	816(ra) # 3ea <wait>
  c2:	57fd                	li	a5,-1
  c4:	04f51163          	bne	a0,a5,106 <forktest+0xd8>
    print("wait got too many\n");
    exit(1,"");
  }

  print("fork test OK\n");
  c8:	00000517          	auipc	a0,0x0
  cc:	45050513          	addi	a0,a0,1104 # 518 <set_policy+0x76>
  d0:	00000097          	auipc	ra,0x0
  d4:	f30080e7          	jalr	-208(ra) # 0 <print>
}
  d8:	60e2                	ld	ra,24(sp)
  da:	6442                	ld	s0,16(sp)
  dc:	64a2                	ld	s1,8(sp)
  de:	6902                	ld	s2,0(sp)
  e0:	6105                	addi	sp,sp,32
  e2:	8082                	ret
      print("wait stopped early\n");
  e4:	00000517          	auipc	a0,0x0
  e8:	40450513          	addi	a0,a0,1028 # 4e8 <set_policy+0x46>
  ec:	00000097          	auipc	ra,0x0
  f0:	f14080e7          	jalr	-236(ra) # 0 <print>
      exit(1,"");
  f4:	00000597          	auipc	a1,0x0
  f8:	3cc58593          	addi	a1,a1,972 # 4c0 <set_policy+0x1e>
  fc:	4505                	li	a0,1
  fe:	00000097          	auipc	ra,0x0
 102:	2e4080e7          	jalr	740(ra) # 3e2 <exit>
    print("wait got too many\n");
 106:	00000517          	auipc	a0,0x0
 10a:	3fa50513          	addi	a0,a0,1018 # 500 <set_policy+0x5e>
 10e:	00000097          	auipc	ra,0x0
 112:	ef2080e7          	jalr	-270(ra) # 0 <print>
    exit(1,"");
 116:	00000597          	auipc	a1,0x0
 11a:	3aa58593          	addi	a1,a1,938 # 4c0 <set_policy+0x1e>
 11e:	4505                	li	a0,1
 120:	00000097          	auipc	ra,0x0
 124:	2c2080e7          	jalr	706(ra) # 3e2 <exit>

0000000000000128 <main>:

int
main(void)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  forktest();
 130:	00000097          	auipc	ra,0x0
 134:	efe080e7          	jalr	-258(ra) # 2e <forktest>
  exit(0,"");
 138:	00000597          	auipc	a1,0x0
 13c:	38858593          	addi	a1,a1,904 # 4c0 <set_policy+0x1e>
 140:	4501                	li	a0,0
 142:	00000097          	auipc	ra,0x0
 146:	2a0080e7          	jalr	672(ra) # 3e2 <exit>

000000000000014a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  extern int main();
  main();
 152:	00000097          	auipc	ra,0x0
 156:	fd6080e7          	jalr	-42(ra) # 128 <main>
  exit(0,"");
 15a:	00000597          	auipc	a1,0x0
 15e:	36658593          	addi	a1,a1,870 # 4c0 <set_policy+0x1e>
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	27e080e7          	jalr	638(ra) # 3e2 <exit>

000000000000016c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 172:	87aa                	mv	a5,a0
 174:	0585                	addi	a1,a1,1
 176:	0785                	addi	a5,a5,1
 178:	fff5c703          	lbu	a4,-1(a1)
 17c:	fee78fa3          	sb	a4,-1(a5)
 180:	fb75                	bnez	a4,174 <strcpy+0x8>
    ;
  return os;
}
 182:	6422                	ld	s0,8(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret

0000000000000188 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 18e:	00054783          	lbu	a5,0(a0)
 192:	cb91                	beqz	a5,1a6 <strcmp+0x1e>
 194:	0005c703          	lbu	a4,0(a1)
 198:	00f71763          	bne	a4,a5,1a6 <strcmp+0x1e>
    p++, q++;
 19c:	0505                	addi	a0,a0,1
 19e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	fbe5                	bnez	a5,194 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a6:	0005c503          	lbu	a0,0(a1)
}
 1aa:	40a7853b          	subw	a0,a5,a0
 1ae:	6422                	ld	s0,8(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret

00000000000001b4 <strlen>:

uint
strlen(const char *s)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e422                	sd	s0,8(sp)
 1b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ba:	00054783          	lbu	a5,0(a0)
 1be:	cf91                	beqz	a5,1da <strlen+0x26>
 1c0:	0505                	addi	a0,a0,1
 1c2:	87aa                	mv	a5,a0
 1c4:	4685                	li	a3,1
 1c6:	9e89                	subw	a3,a3,a0
 1c8:	00f6853b          	addw	a0,a3,a5
 1cc:	0785                	addi	a5,a5,1
 1ce:	fff7c703          	lbu	a4,-1(a5)
 1d2:	fb7d                	bnez	a4,1c8 <strlen+0x14>
    ;
  return n;
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  for(n = 0; s[n]; n++)
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strlen+0x20>

00000000000001de <memset>:

void*
memset(void *dst, int c, uint n)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e4:	ce09                	beqz	a2,1fe <memset+0x20>
 1e6:	87aa                	mv	a5,a0
 1e8:	fff6071b          	addiw	a4,a2,-1
 1ec:	1702                	slli	a4,a4,0x20
 1ee:	9301                	srli	a4,a4,0x20
 1f0:	0705                	addi	a4,a4,1
 1f2:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f8:	0785                	addi	a5,a5,1
 1fa:	fee79de3          	bne	a5,a4,1f4 <memset+0x16>
  }
  return dst;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret

0000000000000204 <strchr>:

char*
strchr(const char *s, char c)
{
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
  for(; *s; s++)
 20a:	00054783          	lbu	a5,0(a0)
 20e:	cb99                	beqz	a5,224 <strchr+0x20>
    if(*s == c)
 210:	00f58763          	beq	a1,a5,21e <strchr+0x1a>
  for(; *s; s++)
 214:	0505                	addi	a0,a0,1
 216:	00054783          	lbu	a5,0(a0)
 21a:	fbfd                	bnez	a5,210 <strchr+0xc>
      return (char*)s;
  return 0;
 21c:	4501                	li	a0,0
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
  return 0;
 224:	4501                	li	a0,0
 226:	bfe5                	j	21e <strchr+0x1a>

0000000000000228 <gets>:

char*
gets(char *buf, int max)
{
 228:	711d                	addi	sp,sp,-96
 22a:	ec86                	sd	ra,88(sp)
 22c:	e8a2                	sd	s0,80(sp)
 22e:	e4a6                	sd	s1,72(sp)
 230:	e0ca                	sd	s2,64(sp)
 232:	fc4e                	sd	s3,56(sp)
 234:	f852                	sd	s4,48(sp)
 236:	f456                	sd	s5,40(sp)
 238:	f05a                	sd	s6,32(sp)
 23a:	ec5e                	sd	s7,24(sp)
 23c:	1080                	addi	s0,sp,96
 23e:	8baa                	mv	s7,a0
 240:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 242:	892a                	mv	s2,a0
 244:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 246:	4aa9                	li	s5,10
 248:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 24a:	89a6                	mv	s3,s1
 24c:	2485                	addiw	s1,s1,1
 24e:	0344d863          	bge	s1,s4,27e <gets+0x56>
    cc = read(0, &c, 1);
 252:	4605                	li	a2,1
 254:	faf40593          	addi	a1,s0,-81
 258:	4501                	li	a0,0
 25a:	00000097          	auipc	ra,0x0
 25e:	1a0080e7          	jalr	416(ra) # 3fa <read>
    if(cc < 1)
 262:	00a05e63          	blez	a0,27e <gets+0x56>
    buf[i++] = c;
 266:	faf44783          	lbu	a5,-81(s0)
 26a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 26e:	01578763          	beq	a5,s5,27c <gets+0x54>
 272:	0905                	addi	s2,s2,1
 274:	fd679be3          	bne	a5,s6,24a <gets+0x22>
  for(i=0; i+1 < max; ){
 278:	89a6                	mv	s3,s1
 27a:	a011                	j	27e <gets+0x56>
 27c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 27e:	99de                	add	s3,s3,s7
 280:	00098023          	sb	zero,0(s3)
  return buf;
}
 284:	855e                	mv	a0,s7
 286:	60e6                	ld	ra,88(sp)
 288:	6446                	ld	s0,80(sp)
 28a:	64a6                	ld	s1,72(sp)
 28c:	6906                	ld	s2,64(sp)
 28e:	79e2                	ld	s3,56(sp)
 290:	7a42                	ld	s4,48(sp)
 292:	7aa2                	ld	s5,40(sp)
 294:	7b02                	ld	s6,32(sp)
 296:	6be2                	ld	s7,24(sp)
 298:	6125                	addi	sp,sp,96
 29a:	8082                	ret

000000000000029c <stat>:

int
stat(const char *n, struct stat *st)
{
 29c:	1101                	addi	sp,sp,-32
 29e:	ec06                	sd	ra,24(sp)
 2a0:	e822                	sd	s0,16(sp)
 2a2:	e426                	sd	s1,8(sp)
 2a4:	e04a                	sd	s2,0(sp)
 2a6:	1000                	addi	s0,sp,32
 2a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2aa:	4581                	li	a1,0
 2ac:	00000097          	auipc	ra,0x0
 2b0:	176080e7          	jalr	374(ra) # 422 <open>
  if(fd < 0)
 2b4:	02054563          	bltz	a0,2de <stat+0x42>
 2b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ba:	85ca                	mv	a1,s2
 2bc:	00000097          	auipc	ra,0x0
 2c0:	17e080e7          	jalr	382(ra) # 43a <fstat>
 2c4:	892a                	mv	s2,a0
  close(fd);
 2c6:	8526                	mv	a0,s1
 2c8:	00000097          	auipc	ra,0x0
 2cc:	142080e7          	jalr	322(ra) # 40a <close>
  return r;
}
 2d0:	854a                	mv	a0,s2
 2d2:	60e2                	ld	ra,24(sp)
 2d4:	6442                	ld	s0,16(sp)
 2d6:	64a2                	ld	s1,8(sp)
 2d8:	6902                	ld	s2,0(sp)
 2da:	6105                	addi	sp,sp,32
 2dc:	8082                	ret
    return -1;
 2de:	597d                	li	s2,-1
 2e0:	bfc5                	j	2d0 <stat+0x34>

00000000000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e8:	00054603          	lbu	a2,0(a0)
 2ec:	fd06079b          	addiw	a5,a2,-48
 2f0:	0ff7f793          	andi	a5,a5,255
 2f4:	4725                	li	a4,9
 2f6:	02f76963          	bltu	a4,a5,328 <atoi+0x46>
 2fa:	86aa                	mv	a3,a0
  n = 0;
 2fc:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2fe:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 300:	0685                	addi	a3,a3,1
 302:	0025179b          	slliw	a5,a0,0x2
 306:	9fa9                	addw	a5,a5,a0
 308:	0017979b          	slliw	a5,a5,0x1
 30c:	9fb1                	addw	a5,a5,a2
 30e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 312:	0006c603          	lbu	a2,0(a3)
 316:	fd06071b          	addiw	a4,a2,-48
 31a:	0ff77713          	andi	a4,a4,255
 31e:	fee5f1e3          	bgeu	a1,a4,300 <atoi+0x1e>
  return n;
}
 322:	6422                	ld	s0,8(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret
  n = 0;
 328:	4501                	li	a0,0
 32a:	bfe5                	j	322 <atoi+0x40>

000000000000032c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e422                	sd	s0,8(sp)
 330:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 332:	02b57663          	bgeu	a0,a1,35e <memmove+0x32>
    while(n-- > 0)
 336:	02c05163          	blez	a2,358 <memmove+0x2c>
 33a:	fff6079b          	addiw	a5,a2,-1
 33e:	1782                	slli	a5,a5,0x20
 340:	9381                	srli	a5,a5,0x20
 342:	0785                	addi	a5,a5,1
 344:	97aa                	add	a5,a5,a0
  dst = vdst;
 346:	872a                	mv	a4,a0
      *dst++ = *src++;
 348:	0585                	addi	a1,a1,1
 34a:	0705                	addi	a4,a4,1
 34c:	fff5c683          	lbu	a3,-1(a1)
 350:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 354:	fee79ae3          	bne	a5,a4,348 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
    dst += n;
 35e:	00c50733          	add	a4,a0,a2
    src += n;
 362:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 364:	fec05ae3          	blez	a2,358 <memmove+0x2c>
 368:	fff6079b          	addiw	a5,a2,-1
 36c:	1782                	slli	a5,a5,0x20
 36e:	9381                	srli	a5,a5,0x20
 370:	fff7c793          	not	a5,a5
 374:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 376:	15fd                	addi	a1,a1,-1
 378:	177d                	addi	a4,a4,-1
 37a:	0005c683          	lbu	a3,0(a1)
 37e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 382:	fee79ae3          	bne	a5,a4,376 <memmove+0x4a>
 386:	bfc9                	j	358 <memmove+0x2c>

0000000000000388 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 38e:	ca05                	beqz	a2,3be <memcmp+0x36>
 390:	fff6069b          	addiw	a3,a2,-1
 394:	1682                	slli	a3,a3,0x20
 396:	9281                	srli	a3,a3,0x20
 398:	0685                	addi	a3,a3,1
 39a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	0005c703          	lbu	a4,0(a1)
 3a4:	00e79863          	bne	a5,a4,3b4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3a8:	0505                	addi	a0,a0,1
    p2++;
 3aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3ac:	fed518e3          	bne	a0,a3,39c <memcmp+0x14>
  }
  return 0;
 3b0:	4501                	li	a0,0
 3b2:	a019                	j	3b8 <memcmp+0x30>
      return *p1 - *p2;
 3b4:	40e7853b          	subw	a0,a5,a4
}
 3b8:	6422                	ld	s0,8(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret
  return 0;
 3be:	4501                	li	a0,0
 3c0:	bfe5                	j	3b8 <memcmp+0x30>

00000000000003c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e406                	sd	ra,8(sp)
 3c6:	e022                	sd	s0,0(sp)
 3c8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3ca:	00000097          	auipc	ra,0x0
 3ce:	f62080e7          	jalr	-158(ra) # 32c <memmove>
}
 3d2:	60a2                	ld	ra,8(sp)
 3d4:	6402                	ld	s0,0(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret

00000000000003da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3da:	4885                	li	a7,1
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e2:	4889                	li	a7,2
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ea:	488d                	li	a7,3
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f2:	4891                	li	a7,4
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <read>:
.global read
read:
 li a7, SYS_read
 3fa:	4895                	li	a7,5
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <write>:
.global write
write:
 li a7, SYS_write
 402:	48c1                	li	a7,16
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <close>:
.global close
close:
 li a7, SYS_close
 40a:	48d5                	li	a7,21
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <kill>:
.global kill
kill:
 li a7, SYS_kill
 412:	4899                	li	a7,6
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <exec>:
.global exec
exec:
 li a7, SYS_exec
 41a:	489d                	li	a7,7
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <open>:
.global open
open:
 li a7, SYS_open
 422:	48bd                	li	a7,15
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 42a:	48c5                	li	a7,17
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 432:	48c9                	li	a7,18
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 43a:	48a1                	li	a7,8
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <link>:
.global link
link:
 li a7, SYS_link
 442:	48cd                	li	a7,19
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 44a:	48d1                	li	a7,20
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 452:	48a5                	li	a7,9
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <dup>:
.global dup
dup:
 li a7, SYS_dup
 45a:	48a9                	li	a7,10
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 462:	48ad                	li	a7,11
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 46a:	48b1                	li	a7,12
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 472:	48b5                	li	a7,13
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 47a:	48b9                	li	a7,14
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 482:	48d9                	li	a7,22
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 48a:	48dd                	li	a7,23
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 492:	48e1                	li	a7,24
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 49a:	48e5                	li	a7,25
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 4a2:	48e9                	li	a7,26
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret
