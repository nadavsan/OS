
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4981                	li	s3,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  2e:	00001d97          	auipc	s11,0x1
  32:	fe3d8d93          	addi	s11,s11,-29 # 1011 <buf+0x1>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	958a0a13          	addi	s4,s4,-1704 # 990 <malloc+0xe4>
        inword = 0;
  40:	4b01                	li	s6,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	22a080e7          	jalr	554(ra) # 270 <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	89da                	mv	s3,s6
    for(i=0; i<n; i++){
  52:	0485                	addi	s1,s1,1
  54:	01248d63          	beq	s1,s2,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2b85                	addiw	s7,s7,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0997e3          	bnez	s3,52 <wc+0x52>
        w++;
  68:	2c05                	addiw	s8,s8,1
        inword = 1;
  6a:	4985                	li	s3,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ac8cbb          	addw	s9,s9,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	00001597          	auipc	a1,0x1
  7a:	f9a58593          	addi	a1,a1,-102 # 1010 <buf>
  7e:	f8843503          	ld	a0,-120(s0)
  82:	00000097          	auipc	ra,0x0
  86:	3e4080e7          	jalr	996(ra) # 466 <read>
  8a:	00a05f63          	blez	a0,a8 <wc+0xa8>
    for(i=0; i<n; i++){
  8e:	00001497          	auipc	s1,0x1
  92:	f8248493          	addi	s1,s1,-126 # 1010 <buf>
  96:	00050d1b          	sext.w	s10,a0
  9a:	fff5091b          	addiw	s2,a0,-1
  9e:	1902                	slli	s2,s2,0x20
  a0:	02095913          	srli	s2,s2,0x20
  a4:	996e                	add	s2,s2,s11
  a6:	bf4d                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  a8:	02054e63          	bltz	a0,e4 <wc+0xe4>
    printf("wc: read error\n");
    exit(1,"");
  }
  printf("%d %d %d %s\n", l, w, c, name);
  ac:	f8043703          	ld	a4,-128(s0)
  b0:	86e6                	mv	a3,s9
  b2:	8662                	mv	a2,s8
  b4:	85de                	mv	a1,s7
  b6:	00001517          	auipc	a0,0x1
  ba:	8fa50513          	addi	a0,a0,-1798 # 9b0 <malloc+0x104>
  be:	00000097          	auipc	ra,0x0
  c2:	730080e7          	jalr	1840(ra) # 7ee <printf>
}
  c6:	70e6                	ld	ra,120(sp)
  c8:	7446                	ld	s0,112(sp)
  ca:	74a6                	ld	s1,104(sp)
  cc:	7906                	ld	s2,96(sp)
  ce:	69e6                	ld	s3,88(sp)
  d0:	6a46                	ld	s4,80(sp)
  d2:	6aa6                	ld	s5,72(sp)
  d4:	6b06                	ld	s6,64(sp)
  d6:	7be2                	ld	s7,56(sp)
  d8:	7c42                	ld	s8,48(sp)
  da:	7ca2                	ld	s9,40(sp)
  dc:	7d02                	ld	s10,32(sp)
  de:	6de2                	ld	s11,24(sp)
  e0:	6109                	addi	sp,sp,128
  e2:	8082                	ret
    printf("wc: read error\n");
  e4:	00001517          	auipc	a0,0x1
  e8:	8b450513          	addi	a0,a0,-1868 # 998 <malloc+0xec>
  ec:	00000097          	auipc	ra,0x0
  f0:	702080e7          	jalr	1794(ra) # 7ee <printf>
    exit(1,"");
  f4:	00001597          	auipc	a1,0x1
  f8:	8b458593          	addi	a1,a1,-1868 # 9a8 <malloc+0xfc>
  fc:	4505                	li	a0,1
  fe:	00000097          	auipc	ra,0x0
 102:	350080e7          	jalr	848(ra) # 44e <exit>

0000000000000106 <main>:

int
main(int argc, char *argv[])
{
 106:	7179                	addi	sp,sp,-48
 108:	f406                	sd	ra,40(sp)
 10a:	f022                	sd	s0,32(sp)
 10c:	ec26                	sd	s1,24(sp)
 10e:	e84a                	sd	s2,16(sp)
 110:	e44e                	sd	s3,8(sp)
 112:	e052                	sd	s4,0(sp)
 114:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 116:	4785                	li	a5,1
 118:	04a7db63          	bge	a5,a0,16e <main+0x68>
 11c:	00858493          	addi	s1,a1,8
 120:	ffe5099b          	addiw	s3,a0,-2
 124:	1982                	slli	s3,s3,0x20
 126:	0209d993          	srli	s3,s3,0x20
 12a:	098e                	slli	s3,s3,0x3
 12c:	05c1                	addi	a1,a1,16
 12e:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0,"");
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 130:	4581                	li	a1,0
 132:	6088                	ld	a0,0(s1)
 134:	00000097          	auipc	ra,0x0
 138:	35a080e7          	jalr	858(ra) # 48e <open>
 13c:	892a                	mv	s2,a0
 13e:	04054a63          	bltz	a0,192 <main+0x8c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1,"");
    }
    wc(fd, argv[i]);
 142:	608c                	ld	a1,0(s1)
 144:	00000097          	auipc	ra,0x0
 148:	ebc080e7          	jalr	-324(ra) # 0 <wc>
    close(fd);
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	328080e7          	jalr	808(ra) # 476 <close>
  for(i = 1; i < argc; i++){
 156:	04a1                	addi	s1,s1,8
 158:	fd349ce3          	bne	s1,s3,130 <main+0x2a>
  }
  exit(0,"");
 15c:	00001597          	auipc	a1,0x1
 160:	84c58593          	addi	a1,a1,-1972 # 9a8 <malloc+0xfc>
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	2e8080e7          	jalr	744(ra) # 44e <exit>
    wc(0, "");
 16e:	00001597          	auipc	a1,0x1
 172:	83a58593          	addi	a1,a1,-1990 # 9a8 <malloc+0xfc>
 176:	4501                	li	a0,0
 178:	00000097          	auipc	ra,0x0
 17c:	e88080e7          	jalr	-376(ra) # 0 <wc>
    exit(0,"");
 180:	00001597          	auipc	a1,0x1
 184:	82858593          	addi	a1,a1,-2008 # 9a8 <malloc+0xfc>
 188:	4501                	li	a0,0
 18a:	00000097          	auipc	ra,0x0
 18e:	2c4080e7          	jalr	708(ra) # 44e <exit>
      printf("wc: cannot open %s\n", argv[i]);
 192:	608c                	ld	a1,0(s1)
 194:	00001517          	auipc	a0,0x1
 198:	82c50513          	addi	a0,a0,-2004 # 9c0 <malloc+0x114>
 19c:	00000097          	auipc	ra,0x0
 1a0:	652080e7          	jalr	1618(ra) # 7ee <printf>
      exit(1,"");
 1a4:	00001597          	auipc	a1,0x1
 1a8:	80458593          	addi	a1,a1,-2044 # 9a8 <malloc+0xfc>
 1ac:	4505                	li	a0,1
 1ae:	00000097          	auipc	ra,0x0
 1b2:	2a0080e7          	jalr	672(ra) # 44e <exit>

00000000000001b6 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1be:	00000097          	auipc	ra,0x0
 1c2:	f48080e7          	jalr	-184(ra) # 106 <main>
  exit(0,"");
 1c6:	00000597          	auipc	a1,0x0
 1ca:	7e258593          	addi	a1,a1,2018 # 9a8 <malloc+0xfc>
 1ce:	4501                	li	a0,0
 1d0:	00000097          	auipc	ra,0x0
 1d4:	27e080e7          	jalr	638(ra) # 44e <exit>

00000000000001d8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1de:	87aa                	mv	a5,a0
 1e0:	0585                	addi	a1,a1,1
 1e2:	0785                	addi	a5,a5,1
 1e4:	fff5c703          	lbu	a4,-1(a1)
 1e8:	fee78fa3          	sb	a4,-1(a5)
 1ec:	fb75                	bnez	a4,1e0 <strcpy+0x8>
    ;
  return os;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret

00000000000001f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1fa:	00054783          	lbu	a5,0(a0)
 1fe:	cb91                	beqz	a5,212 <strcmp+0x1e>
 200:	0005c703          	lbu	a4,0(a1)
 204:	00f71763          	bne	a4,a5,212 <strcmp+0x1e>
    p++, q++;
 208:	0505                	addi	a0,a0,1
 20a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 20c:	00054783          	lbu	a5,0(a0)
 210:	fbe5                	bnez	a5,200 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 212:	0005c503          	lbu	a0,0(a1)
}
 216:	40a7853b          	subw	a0,a5,a0
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strlen>:

uint
strlen(const char *s)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cf91                	beqz	a5,246 <strlen+0x26>
 22c:	0505                	addi	a0,a0,1
 22e:	87aa                	mv	a5,a0
 230:	4685                	li	a3,1
 232:	9e89                	subw	a3,a3,a0
 234:	00f6853b          	addw	a0,a3,a5
 238:	0785                	addi	a5,a5,1
 23a:	fff7c703          	lbu	a4,-1(a5)
 23e:	fb7d                	bnez	a4,234 <strlen+0x14>
    ;
  return n;
}
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
  for(n = 0; s[n]; n++)
 246:	4501                	li	a0,0
 248:	bfe5                	j	240 <strlen+0x20>

000000000000024a <memset>:

void*
memset(void *dst, int c, uint n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 250:	ce09                	beqz	a2,26a <memset+0x20>
 252:	87aa                	mv	a5,a0
 254:	fff6071b          	addiw	a4,a2,-1
 258:	1702                	slli	a4,a4,0x20
 25a:	9301                	srli	a4,a4,0x20
 25c:	0705                	addi	a4,a4,1
 25e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 260:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 264:	0785                	addi	a5,a5,1
 266:	fee79de3          	bne	a5,a4,260 <memset+0x16>
  }
  return dst;
}
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret

0000000000000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	1141                	addi	sp,sp,-16
 272:	e422                	sd	s0,8(sp)
 274:	0800                	addi	s0,sp,16
  for(; *s; s++)
 276:	00054783          	lbu	a5,0(a0)
 27a:	cb99                	beqz	a5,290 <strchr+0x20>
    if(*s == c)
 27c:	00f58763          	beq	a1,a5,28a <strchr+0x1a>
  for(; *s; s++)
 280:	0505                	addi	a0,a0,1
 282:	00054783          	lbu	a5,0(a0)
 286:	fbfd                	bnez	a5,27c <strchr+0xc>
      return (char*)s;
  return 0;
 288:	4501                	li	a0,0
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  return 0;
 290:	4501                	li	a0,0
 292:	bfe5                	j	28a <strchr+0x1a>

0000000000000294 <gets>:

char*
gets(char *buf, int max)
{
 294:	711d                	addi	sp,sp,-96
 296:	ec86                	sd	ra,88(sp)
 298:	e8a2                	sd	s0,80(sp)
 29a:	e4a6                	sd	s1,72(sp)
 29c:	e0ca                	sd	s2,64(sp)
 29e:	fc4e                	sd	s3,56(sp)
 2a0:	f852                	sd	s4,48(sp)
 2a2:	f456                	sd	s5,40(sp)
 2a4:	f05a                	sd	s6,32(sp)
 2a6:	ec5e                	sd	s7,24(sp)
 2a8:	1080                	addi	s0,sp,96
 2aa:	8baa                	mv	s7,a0
 2ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ae:	892a                	mv	s2,a0
 2b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2b2:	4aa9                	li	s5,10
 2b4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2b6:	89a6                	mv	s3,s1
 2b8:	2485                	addiw	s1,s1,1
 2ba:	0344d863          	bge	s1,s4,2ea <gets+0x56>
    cc = read(0, &c, 1);
 2be:	4605                	li	a2,1
 2c0:	faf40593          	addi	a1,s0,-81
 2c4:	4501                	li	a0,0
 2c6:	00000097          	auipc	ra,0x0
 2ca:	1a0080e7          	jalr	416(ra) # 466 <read>
    if(cc < 1)
 2ce:	00a05e63          	blez	a0,2ea <gets+0x56>
    buf[i++] = c;
 2d2:	faf44783          	lbu	a5,-81(s0)
 2d6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2da:	01578763          	beq	a5,s5,2e8 <gets+0x54>
 2de:	0905                	addi	s2,s2,1
 2e0:	fd679be3          	bne	a5,s6,2b6 <gets+0x22>
  for(i=0; i+1 < max; ){
 2e4:	89a6                	mv	s3,s1
 2e6:	a011                	j	2ea <gets+0x56>
 2e8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ea:	99de                	add	s3,s3,s7
 2ec:	00098023          	sb	zero,0(s3)
  return buf;
}
 2f0:	855e                	mv	a0,s7
 2f2:	60e6                	ld	ra,88(sp)
 2f4:	6446                	ld	s0,80(sp)
 2f6:	64a6                	ld	s1,72(sp)
 2f8:	6906                	ld	s2,64(sp)
 2fa:	79e2                	ld	s3,56(sp)
 2fc:	7a42                	ld	s4,48(sp)
 2fe:	7aa2                	ld	s5,40(sp)
 300:	7b02                	ld	s6,32(sp)
 302:	6be2                	ld	s7,24(sp)
 304:	6125                	addi	sp,sp,96
 306:	8082                	ret

0000000000000308 <stat>:

int
stat(const char *n, struct stat *st)
{
 308:	1101                	addi	sp,sp,-32
 30a:	ec06                	sd	ra,24(sp)
 30c:	e822                	sd	s0,16(sp)
 30e:	e426                	sd	s1,8(sp)
 310:	e04a                	sd	s2,0(sp)
 312:	1000                	addi	s0,sp,32
 314:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 316:	4581                	li	a1,0
 318:	00000097          	auipc	ra,0x0
 31c:	176080e7          	jalr	374(ra) # 48e <open>
  if(fd < 0)
 320:	02054563          	bltz	a0,34a <stat+0x42>
 324:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 326:	85ca                	mv	a1,s2
 328:	00000097          	auipc	ra,0x0
 32c:	17e080e7          	jalr	382(ra) # 4a6 <fstat>
 330:	892a                	mv	s2,a0
  close(fd);
 332:	8526                	mv	a0,s1
 334:	00000097          	auipc	ra,0x0
 338:	142080e7          	jalr	322(ra) # 476 <close>
  return r;
}
 33c:	854a                	mv	a0,s2
 33e:	60e2                	ld	ra,24(sp)
 340:	6442                	ld	s0,16(sp)
 342:	64a2                	ld	s1,8(sp)
 344:	6902                	ld	s2,0(sp)
 346:	6105                	addi	sp,sp,32
 348:	8082                	ret
    return -1;
 34a:	597d                	li	s2,-1
 34c:	bfc5                	j	33c <stat+0x34>

000000000000034e <atoi>:

int
atoi(const char *s)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e422                	sd	s0,8(sp)
 352:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 354:	00054603          	lbu	a2,0(a0)
 358:	fd06079b          	addiw	a5,a2,-48
 35c:	0ff7f793          	andi	a5,a5,255
 360:	4725                	li	a4,9
 362:	02f76963          	bltu	a4,a5,394 <atoi+0x46>
 366:	86aa                	mv	a3,a0
  n = 0;
 368:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 36a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 36c:	0685                	addi	a3,a3,1
 36e:	0025179b          	slliw	a5,a0,0x2
 372:	9fa9                	addw	a5,a5,a0
 374:	0017979b          	slliw	a5,a5,0x1
 378:	9fb1                	addw	a5,a5,a2
 37a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37e:	0006c603          	lbu	a2,0(a3)
 382:	fd06071b          	addiw	a4,a2,-48
 386:	0ff77713          	andi	a4,a4,255
 38a:	fee5f1e3          	bgeu	a1,a4,36c <atoi+0x1e>
  return n;
}
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret
  n = 0;
 394:	4501                	li	a0,0
 396:	bfe5                	j	38e <atoi+0x40>

0000000000000398 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 398:	1141                	addi	sp,sp,-16
 39a:	e422                	sd	s0,8(sp)
 39c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 39e:	02b57663          	bgeu	a0,a1,3ca <memmove+0x32>
    while(n-- > 0)
 3a2:	02c05163          	blez	a2,3c4 <memmove+0x2c>
 3a6:	fff6079b          	addiw	a5,a2,-1
 3aa:	1782                	slli	a5,a5,0x20
 3ac:	9381                	srli	a5,a5,0x20
 3ae:	0785                	addi	a5,a5,1
 3b0:	97aa                	add	a5,a5,a0
  dst = vdst;
 3b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b4:	0585                	addi	a1,a1,1
 3b6:	0705                	addi	a4,a4,1
 3b8:	fff5c683          	lbu	a3,-1(a1)
 3bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3c0:	fee79ae3          	bne	a5,a4,3b4 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c4:	6422                	ld	s0,8(sp)
 3c6:	0141                	addi	sp,sp,16
 3c8:	8082                	ret
    dst += n;
 3ca:	00c50733          	add	a4,a0,a2
    src += n;
 3ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3d0:	fec05ae3          	blez	a2,3c4 <memmove+0x2c>
 3d4:	fff6079b          	addiw	a5,a2,-1
 3d8:	1782                	slli	a5,a5,0x20
 3da:	9381                	srli	a5,a5,0x20
 3dc:	fff7c793          	not	a5,a5
 3e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3e2:	15fd                	addi	a1,a1,-1
 3e4:	177d                	addi	a4,a4,-1
 3e6:	0005c683          	lbu	a3,0(a1)
 3ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ee:	fee79ae3          	bne	a5,a4,3e2 <memmove+0x4a>
 3f2:	bfc9                	j	3c4 <memmove+0x2c>

00000000000003f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e422                	sd	s0,8(sp)
 3f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3fa:	ca05                	beqz	a2,42a <memcmp+0x36>
 3fc:	fff6069b          	addiw	a3,a2,-1
 400:	1682                	slli	a3,a3,0x20
 402:	9281                	srli	a3,a3,0x20
 404:	0685                	addi	a3,a3,1
 406:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 408:	00054783          	lbu	a5,0(a0)
 40c:	0005c703          	lbu	a4,0(a1)
 410:	00e79863          	bne	a5,a4,420 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 414:	0505                	addi	a0,a0,1
    p2++;
 416:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 418:	fed518e3          	bne	a0,a3,408 <memcmp+0x14>
  }
  return 0;
 41c:	4501                	li	a0,0
 41e:	a019                	j	424 <memcmp+0x30>
      return *p1 - *p2;
 420:	40e7853b          	subw	a0,a5,a4
}
 424:	6422                	ld	s0,8(sp)
 426:	0141                	addi	sp,sp,16
 428:	8082                	ret
  return 0;
 42a:	4501                	li	a0,0
 42c:	bfe5                	j	424 <memcmp+0x30>

000000000000042e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42e:	1141                	addi	sp,sp,-16
 430:	e406                	sd	ra,8(sp)
 432:	e022                	sd	s0,0(sp)
 434:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 436:	00000097          	auipc	ra,0x0
 43a:	f62080e7          	jalr	-158(ra) # 398 <memmove>
}
 43e:	60a2                	ld	ra,8(sp)
 440:	6402                	ld	s0,0(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret

0000000000000446 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 446:	4885                	li	a7,1
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <exit>:
.global exit
exit:
 li a7, SYS_exit
 44e:	4889                	li	a7,2
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <wait>:
.global wait
wait:
 li a7, SYS_wait
 456:	488d                	li	a7,3
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45e:	4891                	li	a7,4
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <read>:
.global read
read:
 li a7, SYS_read
 466:	4895                	li	a7,5
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <write>:
.global write
write:
 li a7, SYS_write
 46e:	48c1                	li	a7,16
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <close>:
.global close
close:
 li a7, SYS_close
 476:	48d5                	li	a7,21
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <kill>:
.global kill
kill:
 li a7, SYS_kill
 47e:	4899                	li	a7,6
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <exec>:
.global exec
exec:
 li a7, SYS_exec
 486:	489d                	li	a7,7
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <open>:
.global open
open:
 li a7, SYS_open
 48e:	48bd                	li	a7,15
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 496:	48c5                	li	a7,17
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49e:	48c9                	li	a7,18
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a6:	48a1                	li	a7,8
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <link>:
.global link
link:
 li a7, SYS_link
 4ae:	48cd                	li	a7,19
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b6:	48d1                	li	a7,20
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4be:	48a5                	li	a7,9
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c6:	48a9                	li	a7,10
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ce:	48ad                	li	a7,11
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d6:	48b1                	li	a7,12
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4de:	48b5                	li	a7,13
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e6:	48b9                	li	a7,14
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 4ee:	48d9                	li	a7,22
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 4f6:	48dd                	li	a7,23
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 4fe:	48e1                	li	a7,24
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 506:	48e5                	li	a7,25
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 50e:	48e9                	li	a7,26
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 516:	1101                	addi	sp,sp,-32
 518:	ec06                	sd	ra,24(sp)
 51a:	e822                	sd	s0,16(sp)
 51c:	1000                	addi	s0,sp,32
 51e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 522:	4605                	li	a2,1
 524:	fef40593          	addi	a1,s0,-17
 528:	00000097          	auipc	ra,0x0
 52c:	f46080e7          	jalr	-186(ra) # 46e <write>
}
 530:	60e2                	ld	ra,24(sp)
 532:	6442                	ld	s0,16(sp)
 534:	6105                	addi	sp,sp,32
 536:	8082                	ret

0000000000000538 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 538:	7139                	addi	sp,sp,-64
 53a:	fc06                	sd	ra,56(sp)
 53c:	f822                	sd	s0,48(sp)
 53e:	f426                	sd	s1,40(sp)
 540:	f04a                	sd	s2,32(sp)
 542:	ec4e                	sd	s3,24(sp)
 544:	0080                	addi	s0,sp,64
 546:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 548:	c299                	beqz	a3,54e <printint+0x16>
 54a:	0805c863          	bltz	a1,5da <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 54e:	2581                	sext.w	a1,a1
  neg = 0;
 550:	4881                	li	a7,0
 552:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 556:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 558:	2601                	sext.w	a2,a2
 55a:	00000517          	auipc	a0,0x0
 55e:	48650513          	addi	a0,a0,1158 # 9e0 <digits>
 562:	883a                	mv	a6,a4
 564:	2705                	addiw	a4,a4,1
 566:	02c5f7bb          	remuw	a5,a1,a2
 56a:	1782                	slli	a5,a5,0x20
 56c:	9381                	srli	a5,a5,0x20
 56e:	97aa                	add	a5,a5,a0
 570:	0007c783          	lbu	a5,0(a5)
 574:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 578:	0005879b          	sext.w	a5,a1
 57c:	02c5d5bb          	divuw	a1,a1,a2
 580:	0685                	addi	a3,a3,1
 582:	fec7f0e3          	bgeu	a5,a2,562 <printint+0x2a>
  if(neg)
 586:	00088b63          	beqz	a7,59c <printint+0x64>
    buf[i++] = '-';
 58a:	fd040793          	addi	a5,s0,-48
 58e:	973e                	add	a4,a4,a5
 590:	02d00793          	li	a5,45
 594:	fef70823          	sb	a5,-16(a4)
 598:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 59c:	02e05863          	blez	a4,5cc <printint+0x94>
 5a0:	fc040793          	addi	a5,s0,-64
 5a4:	00e78933          	add	s2,a5,a4
 5a8:	fff78993          	addi	s3,a5,-1
 5ac:	99ba                	add	s3,s3,a4
 5ae:	377d                	addiw	a4,a4,-1
 5b0:	1702                	slli	a4,a4,0x20
 5b2:	9301                	srli	a4,a4,0x20
 5b4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5b8:	fff94583          	lbu	a1,-1(s2)
 5bc:	8526                	mv	a0,s1
 5be:	00000097          	auipc	ra,0x0
 5c2:	f58080e7          	jalr	-168(ra) # 516 <putc>
  while(--i >= 0)
 5c6:	197d                	addi	s2,s2,-1
 5c8:	ff3918e3          	bne	s2,s3,5b8 <printint+0x80>
}
 5cc:	70e2                	ld	ra,56(sp)
 5ce:	7442                	ld	s0,48(sp)
 5d0:	74a2                	ld	s1,40(sp)
 5d2:	7902                	ld	s2,32(sp)
 5d4:	69e2                	ld	s3,24(sp)
 5d6:	6121                	addi	sp,sp,64
 5d8:	8082                	ret
    x = -xx;
 5da:	40b005bb          	negw	a1,a1
    neg = 1;
 5de:	4885                	li	a7,1
    x = -xx;
 5e0:	bf8d                	j	552 <printint+0x1a>

00000000000005e2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e2:	7119                	addi	sp,sp,-128
 5e4:	fc86                	sd	ra,120(sp)
 5e6:	f8a2                	sd	s0,112(sp)
 5e8:	f4a6                	sd	s1,104(sp)
 5ea:	f0ca                	sd	s2,96(sp)
 5ec:	ecce                	sd	s3,88(sp)
 5ee:	e8d2                	sd	s4,80(sp)
 5f0:	e4d6                	sd	s5,72(sp)
 5f2:	e0da                	sd	s6,64(sp)
 5f4:	fc5e                	sd	s7,56(sp)
 5f6:	f862                	sd	s8,48(sp)
 5f8:	f466                	sd	s9,40(sp)
 5fa:	f06a                	sd	s10,32(sp)
 5fc:	ec6e                	sd	s11,24(sp)
 5fe:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 600:	0005c903          	lbu	s2,0(a1)
 604:	18090f63          	beqz	s2,7a2 <vprintf+0x1c0>
 608:	8aaa                	mv	s5,a0
 60a:	8b32                	mv	s6,a2
 60c:	00158493          	addi	s1,a1,1
  state = 0;
 610:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 612:	02500a13          	li	s4,37
      if(c == 'd'){
 616:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 61a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 61e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 622:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 626:	00000b97          	auipc	s7,0x0
 62a:	3bab8b93          	addi	s7,s7,954 # 9e0 <digits>
 62e:	a839                	j	64c <vprintf+0x6a>
        putc(fd, c);
 630:	85ca                	mv	a1,s2
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	ee2080e7          	jalr	-286(ra) # 516 <putc>
 63c:	a019                	j	642 <vprintf+0x60>
    } else if(state == '%'){
 63e:	01498f63          	beq	s3,s4,65c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 642:	0485                	addi	s1,s1,1
 644:	fff4c903          	lbu	s2,-1(s1)
 648:	14090d63          	beqz	s2,7a2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 64c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 650:	fe0997e3          	bnez	s3,63e <vprintf+0x5c>
      if(c == '%'){
 654:	fd479ee3          	bne	a5,s4,630 <vprintf+0x4e>
        state = '%';
 658:	89be                	mv	s3,a5
 65a:	b7e5                	j	642 <vprintf+0x60>
      if(c == 'd'){
 65c:	05878063          	beq	a5,s8,69c <vprintf+0xba>
      } else if(c == 'l') {
 660:	05978c63          	beq	a5,s9,6b8 <vprintf+0xd6>
      } else if(c == 'x') {
 664:	07a78863          	beq	a5,s10,6d4 <vprintf+0xf2>
      } else if(c == 'p') {
 668:	09b78463          	beq	a5,s11,6f0 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 66c:	07300713          	li	a4,115
 670:	0ce78663          	beq	a5,a4,73c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 674:	06300713          	li	a4,99
 678:	0ee78e63          	beq	a5,a4,774 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 67c:	11478863          	beq	a5,s4,78c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 680:	85d2                	mv	a1,s4
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e92080e7          	jalr	-366(ra) # 516 <putc>
        putc(fd, c);
 68c:	85ca                	mv	a1,s2
 68e:	8556                	mv	a0,s5
 690:	00000097          	auipc	ra,0x0
 694:	e86080e7          	jalr	-378(ra) # 516 <putc>
      }
      state = 0;
 698:	4981                	li	s3,0
 69a:	b765                	j	642 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 69c:	008b0913          	addi	s2,s6,8
 6a0:	4685                	li	a3,1
 6a2:	4629                	li	a2,10
 6a4:	000b2583          	lw	a1,0(s6)
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	e8e080e7          	jalr	-370(ra) # 538 <printint>
 6b2:	8b4a                	mv	s6,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b771                	j	642 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	008b0913          	addi	s2,s6,8
 6bc:	4681                	li	a3,0
 6be:	4629                	li	a2,10
 6c0:	000b2583          	lw	a1,0(s6)
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e72080e7          	jalr	-398(ra) # 538 <printint>
 6ce:	8b4a                	mv	s6,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bf85                	j	642 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6d4:	008b0913          	addi	s2,s6,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000b2583          	lw	a1,0(s6)
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e56080e7          	jalr	-426(ra) # 538 <printint>
 6ea:	8b4a                	mv	s6,s2
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	bf91                	j	642 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6f0:	008b0793          	addi	a5,s6,8
 6f4:	f8f43423          	sd	a5,-120(s0)
 6f8:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6fc:	03000593          	li	a1,48
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	e14080e7          	jalr	-492(ra) # 516 <putc>
  putc(fd, 'x');
 70a:	85ea                	mv	a1,s10
 70c:	8556                	mv	a0,s5
 70e:	00000097          	auipc	ra,0x0
 712:	e08080e7          	jalr	-504(ra) # 516 <putc>
 716:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 718:	03c9d793          	srli	a5,s3,0x3c
 71c:	97de                	add	a5,a5,s7
 71e:	0007c583          	lbu	a1,0(a5)
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	df2080e7          	jalr	-526(ra) # 516 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72c:	0992                	slli	s3,s3,0x4
 72e:	397d                	addiw	s2,s2,-1
 730:	fe0914e3          	bnez	s2,718 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 734:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 738:	4981                	li	s3,0
 73a:	b721                	j	642 <vprintf+0x60>
        s = va_arg(ap, char*);
 73c:	008b0993          	addi	s3,s6,8
 740:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 744:	02090163          	beqz	s2,766 <vprintf+0x184>
        while(*s != 0){
 748:	00094583          	lbu	a1,0(s2)
 74c:	c9a1                	beqz	a1,79c <vprintf+0x1ba>
          putc(fd, *s);
 74e:	8556                	mv	a0,s5
 750:	00000097          	auipc	ra,0x0
 754:	dc6080e7          	jalr	-570(ra) # 516 <putc>
          s++;
 758:	0905                	addi	s2,s2,1
        while(*s != 0){
 75a:	00094583          	lbu	a1,0(s2)
 75e:	f9e5                	bnez	a1,74e <vprintf+0x16c>
        s = va_arg(ap, char*);
 760:	8b4e                	mv	s6,s3
      state = 0;
 762:	4981                	li	s3,0
 764:	bdf9                	j	642 <vprintf+0x60>
          s = "(null)";
 766:	00000917          	auipc	s2,0x0
 76a:	27290913          	addi	s2,s2,626 # 9d8 <malloc+0x12c>
        while(*s != 0){
 76e:	02800593          	li	a1,40
 772:	bff1                	j	74e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 774:	008b0913          	addi	s2,s6,8
 778:	000b4583          	lbu	a1,0(s6)
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	d98080e7          	jalr	-616(ra) # 516 <putc>
 786:	8b4a                	mv	s6,s2
      state = 0;
 788:	4981                	li	s3,0
 78a:	bd65                	j	642 <vprintf+0x60>
        putc(fd, c);
 78c:	85d2                	mv	a1,s4
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	d86080e7          	jalr	-634(ra) # 516 <putc>
      state = 0;
 798:	4981                	li	s3,0
 79a:	b565                	j	642 <vprintf+0x60>
        s = va_arg(ap, char*);
 79c:	8b4e                	mv	s6,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b54d                	j	642 <vprintf+0x60>
    }
  }
}
 7a2:	70e6                	ld	ra,120(sp)
 7a4:	7446                	ld	s0,112(sp)
 7a6:	74a6                	ld	s1,104(sp)
 7a8:	7906                	ld	s2,96(sp)
 7aa:	69e6                	ld	s3,88(sp)
 7ac:	6a46                	ld	s4,80(sp)
 7ae:	6aa6                	ld	s5,72(sp)
 7b0:	6b06                	ld	s6,64(sp)
 7b2:	7be2                	ld	s7,56(sp)
 7b4:	7c42                	ld	s8,48(sp)
 7b6:	7ca2                	ld	s9,40(sp)
 7b8:	7d02                	ld	s10,32(sp)
 7ba:	6de2                	ld	s11,24(sp)
 7bc:	6109                	addi	sp,sp,128
 7be:	8082                	ret

00000000000007c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c0:	715d                	addi	sp,sp,-80
 7c2:	ec06                	sd	ra,24(sp)
 7c4:	e822                	sd	s0,16(sp)
 7c6:	1000                	addi	s0,sp,32
 7c8:	e010                	sd	a2,0(s0)
 7ca:	e414                	sd	a3,8(s0)
 7cc:	e818                	sd	a4,16(s0)
 7ce:	ec1c                	sd	a5,24(s0)
 7d0:	03043023          	sd	a6,32(s0)
 7d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7dc:	8622                	mv	a2,s0
 7de:	00000097          	auipc	ra,0x0
 7e2:	e04080e7          	jalr	-508(ra) # 5e2 <vprintf>
}
 7e6:	60e2                	ld	ra,24(sp)
 7e8:	6442                	ld	s0,16(sp)
 7ea:	6161                	addi	sp,sp,80
 7ec:	8082                	ret

00000000000007ee <printf>:

void
printf(const char *fmt, ...)
{
 7ee:	711d                	addi	sp,sp,-96
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e40c                	sd	a1,8(s0)
 7f8:	e810                	sd	a2,16(s0)
 7fa:	ec14                	sd	a3,24(s0)
 7fc:	f018                	sd	a4,32(s0)
 7fe:	f41c                	sd	a5,40(s0)
 800:	03043823          	sd	a6,48(s0)
 804:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	00840613          	addi	a2,s0,8
 80c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 810:	85aa                	mv	a1,a0
 812:	4505                	li	a0,1
 814:	00000097          	auipc	ra,0x0
 818:	dce080e7          	jalr	-562(ra) # 5e2 <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6125                	addi	sp,sp,96
 822:	8082                	ret

0000000000000824 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 824:	1141                	addi	sp,sp,-16
 826:	e422                	sd	s0,8(sp)
 828:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 82a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82e:	00000797          	auipc	a5,0x0
 832:	7d27b783          	ld	a5,2002(a5) # 1000 <freep>
 836:	a805                	j	866 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 838:	4618                	lw	a4,8(a2)
 83a:	9db9                	addw	a1,a1,a4
 83c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	6398                	ld	a4,0(a5)
 842:	6318                	ld	a4,0(a4)
 844:	fee53823          	sd	a4,-16(a0)
 848:	a091                	j	88c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 84a:	ff852703          	lw	a4,-8(a0)
 84e:	9e39                	addw	a2,a2,a4
 850:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 852:	ff053703          	ld	a4,-16(a0)
 856:	e398                	sd	a4,0(a5)
 858:	a099                	j	89e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85a:	6398                	ld	a4,0(a5)
 85c:	00e7e463          	bltu	a5,a4,864 <free+0x40>
 860:	00e6ea63          	bltu	a3,a4,874 <free+0x50>
{
 864:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 866:	fed7fae3          	bgeu	a5,a3,85a <free+0x36>
 86a:	6398                	ld	a4,0(a5)
 86c:	00e6e463          	bltu	a3,a4,874 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	fee7eae3          	bltu	a5,a4,864 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 874:	ff852583          	lw	a1,-8(a0)
 878:	6390                	ld	a2,0(a5)
 87a:	02059713          	slli	a4,a1,0x20
 87e:	9301                	srli	a4,a4,0x20
 880:	0712                	slli	a4,a4,0x4
 882:	9736                	add	a4,a4,a3
 884:	fae60ae3          	beq	a2,a4,838 <free+0x14>
    bp->s.ptr = p->s.ptr;
 888:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 88c:	4790                	lw	a2,8(a5)
 88e:	02061713          	slli	a4,a2,0x20
 892:	9301                	srli	a4,a4,0x20
 894:	0712                	slli	a4,a4,0x4
 896:	973e                	add	a4,a4,a5
 898:	fae689e3          	beq	a3,a4,84a <free+0x26>
  } else
    p->s.ptr = bp;
 89c:	e394                	sd	a3,0(a5)
  freep = p;
 89e:	00000717          	auipc	a4,0x0
 8a2:	76f73123          	sd	a5,1890(a4) # 1000 <freep>
}
 8a6:	6422                	ld	s0,8(sp)
 8a8:	0141                	addi	sp,sp,16
 8aa:	8082                	ret

00000000000008ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ac:	7139                	addi	sp,sp,-64
 8ae:	fc06                	sd	ra,56(sp)
 8b0:	f822                	sd	s0,48(sp)
 8b2:	f426                	sd	s1,40(sp)
 8b4:	f04a                	sd	s2,32(sp)
 8b6:	ec4e                	sd	s3,24(sp)
 8b8:	e852                	sd	s4,16(sp)
 8ba:	e456                	sd	s5,8(sp)
 8bc:	e05a                	sd	s6,0(sp)
 8be:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c0:	02051493          	slli	s1,a0,0x20
 8c4:	9081                	srli	s1,s1,0x20
 8c6:	04bd                	addi	s1,s1,15
 8c8:	8091                	srli	s1,s1,0x4
 8ca:	0014899b          	addiw	s3,s1,1
 8ce:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8d0:	00000517          	auipc	a0,0x0
 8d4:	73053503          	ld	a0,1840(a0) # 1000 <freep>
 8d8:	c515                	beqz	a0,904 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8dc:	4798                	lw	a4,8(a5)
 8de:	02977f63          	bgeu	a4,s1,91c <malloc+0x70>
 8e2:	8a4e                	mv	s4,s3
 8e4:	0009871b          	sext.w	a4,s3
 8e8:	6685                	lui	a3,0x1
 8ea:	00d77363          	bgeu	a4,a3,8f0 <malloc+0x44>
 8ee:	6a05                	lui	s4,0x1
 8f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f8:	00000917          	auipc	s2,0x0
 8fc:	70890913          	addi	s2,s2,1800 # 1000 <freep>
  if(p == (char*)-1)
 900:	5afd                	li	s5,-1
 902:	a88d                	j	974 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 904:	00001797          	auipc	a5,0x1
 908:	90c78793          	addi	a5,a5,-1780 # 1210 <base>
 90c:	00000717          	auipc	a4,0x0
 910:	6ef73a23          	sd	a5,1780(a4) # 1000 <freep>
 914:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 916:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 91a:	b7e1                	j	8e2 <malloc+0x36>
      if(p->s.size == nunits)
 91c:	02e48b63          	beq	s1,a4,952 <malloc+0xa6>
        p->s.size -= nunits;
 920:	4137073b          	subw	a4,a4,s3
 924:	c798                	sw	a4,8(a5)
        p += p->s.size;
 926:	1702                	slli	a4,a4,0x20
 928:	9301                	srli	a4,a4,0x20
 92a:	0712                	slli	a4,a4,0x4
 92c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 932:	00000717          	auipc	a4,0x0
 936:	6ca73723          	sd	a0,1742(a4) # 1000 <freep>
      return (void*)(p + 1);
 93a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 93e:	70e2                	ld	ra,56(sp)
 940:	7442                	ld	s0,48(sp)
 942:	74a2                	ld	s1,40(sp)
 944:	7902                	ld	s2,32(sp)
 946:	69e2                	ld	s3,24(sp)
 948:	6a42                	ld	s4,16(sp)
 94a:	6aa2                	ld	s5,8(sp)
 94c:	6b02                	ld	s6,0(sp)
 94e:	6121                	addi	sp,sp,64
 950:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 952:	6398                	ld	a4,0(a5)
 954:	e118                	sd	a4,0(a0)
 956:	bff1                	j	932 <malloc+0x86>
  hp->s.size = nu;
 958:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 95c:	0541                	addi	a0,a0,16
 95e:	00000097          	auipc	ra,0x0
 962:	ec6080e7          	jalr	-314(ra) # 824 <free>
  return freep;
 966:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 96a:	d971                	beqz	a0,93e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96e:	4798                	lw	a4,8(a5)
 970:	fa9776e3          	bgeu	a4,s1,91c <malloc+0x70>
    if(p == freep)
 974:	00093703          	ld	a4,0(s2)
 978:	853e                	mv	a0,a5
 97a:	fef719e3          	bne	a4,a5,96c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 97e:	8552                	mv	a0,s4
 980:	00000097          	auipc	ra,0x0
 984:	b56080e7          	jalr	-1194(ra) # 4d6 <sbrk>
  if(p == (char*)-1)
 988:	fd5518e3          	bne	a0,s5,958 <malloc+0xac>
        return 0;
 98c:	4501                	li	a0,0
 98e:	bf45                	j	93e <malloc+0x92>
