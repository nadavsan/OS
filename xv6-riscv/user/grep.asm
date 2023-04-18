
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	addi	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	addi	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	addi	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	addi	a1,a1,1
  ba:	00178513          	addi	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	addi	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	addi	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	addi	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	addi	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	addi	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	e862                	sd	s8,16(sp)
 130:	e466                	sd	s9,8(sp)
 132:	e06a                	sd	s10,0(sp)
 134:	1080                	addi	s0,sp,96
 136:	89aa                	mv	s3,a0
 138:	8bae                	mv	s7,a1
  m = 0;
 13a:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13c:	3ff00c13          	li	s8,1023
 140:	00001b17          	auipc	s6,0x1
 144:	ed0b0b13          	addi	s6,s6,-304 # 1010 <buf>
    p = buf;
 148:	8d5a                	mv	s10,s6
        *q = '\n';
 14a:	4aa9                	li	s5,10
    p = buf;
 14c:	8cda                	mv	s9,s6
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 14e:	a099                	j	194 <grep+0x7a>
        *q = '\n';
 150:	01548023          	sb	s5,0(s1)
        write(1, p, q+1 - p);
 154:	00148613          	addi	a2,s1,1
 158:	4126063b          	subw	a2,a2,s2
 15c:	85ca                	mv	a1,s2
 15e:	4505                	li	a0,1
 160:	00000097          	auipc	ra,0x0
 164:	426080e7          	jalr	1062(ra) # 586 <write>
      p = q+1;
 168:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 16c:	45a9                	li	a1,10
 16e:	854a                	mv	a0,s2
 170:	00000097          	auipc	ra,0x0
 174:	218080e7          	jalr	536(ra) # 388 <strchr>
 178:	84aa                	mv	s1,a0
 17a:	c919                	beqz	a0,190 <grep+0x76>
      *q = 0;
 17c:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 180:	85ca                	mv	a1,s2
 182:	854e                	mv	a0,s3
 184:	00000097          	auipc	ra,0x0
 188:	f48080e7          	jalr	-184(ra) # cc <match>
 18c:	dd71                	beqz	a0,168 <grep+0x4e>
 18e:	b7c9                	j	150 <grep+0x36>
    if(m > 0){
 190:	03404563          	bgtz	s4,1ba <grep+0xa0>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 194:	414c063b          	subw	a2,s8,s4
 198:	014b05b3          	add	a1,s6,s4
 19c:	855e                	mv	a0,s7
 19e:	00000097          	auipc	ra,0x0
 1a2:	3e0080e7          	jalr	992(ra) # 57e <read>
 1a6:	02a05663          	blez	a0,1d2 <grep+0xb8>
    m += n;
 1aa:	00aa0a3b          	addw	s4,s4,a0
    buf[m] = '\0';
 1ae:	014b07b3          	add	a5,s6,s4
 1b2:	00078023          	sb	zero,0(a5)
    p = buf;
 1b6:	8966                	mv	s2,s9
    while((q = strchr(p, '\n')) != 0){
 1b8:	bf55                	j	16c <grep+0x52>
      m -= p - buf;
 1ba:	416907b3          	sub	a5,s2,s6
 1be:	40fa0a3b          	subw	s4,s4,a5
      memmove(buf, p, m);
 1c2:	8652                	mv	a2,s4
 1c4:	85ca                	mv	a1,s2
 1c6:	856a                	mv	a0,s10
 1c8:	00000097          	auipc	ra,0x0
 1cc:	2e8080e7          	jalr	744(ra) # 4b0 <memmove>
 1d0:	b7d1                	j	194 <grep+0x7a>
}
 1d2:	60e6                	ld	ra,88(sp)
 1d4:	6446                	ld	s0,80(sp)
 1d6:	64a6                	ld	s1,72(sp)
 1d8:	6906                	ld	s2,64(sp)
 1da:	79e2                	ld	s3,56(sp)
 1dc:	7a42                	ld	s4,48(sp)
 1de:	7aa2                	ld	s5,40(sp)
 1e0:	7b02                	ld	s6,32(sp)
 1e2:	6be2                	ld	s7,24(sp)
 1e4:	6c42                	ld	s8,16(sp)
 1e6:	6ca2                	ld	s9,8(sp)
 1e8:	6d02                	ld	s10,0(sp)
 1ea:	6125                	addi	sp,sp,96
 1ec:	8082                	ret

00000000000001ee <main>:
{
 1ee:	7139                	addi	sp,sp,-64
 1f0:	fc06                	sd	ra,56(sp)
 1f2:	f822                	sd	s0,48(sp)
 1f4:	f426                	sd	s1,40(sp)
 1f6:	f04a                	sd	s2,32(sp)
 1f8:	ec4e                	sd	s3,24(sp)
 1fa:	e852                	sd	s4,16(sp)
 1fc:	e456                	sd	s5,8(sp)
 1fe:	0080                	addi	s0,sp,64
  if(argc <= 1){
 200:	4785                	li	a5,1
 202:	06a7d263          	bge	a5,a0,266 <main+0x78>
  pattern = argv[1];
 206:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 20a:	4789                	li	a5,2
 20c:	06a7df63          	bge	a5,a0,28a <main+0x9c>
 210:	01058913          	addi	s2,a1,16
 214:	ffd5099b          	addiw	s3,a0,-3
 218:	1982                	slli	s3,s3,0x20
 21a:	0209d993          	srli	s3,s3,0x20
 21e:	098e                	slli	s3,s3,0x3
 220:	05e1                	addi	a1,a1,24
 222:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 224:	4581                	li	a1,0
 226:	00093503          	ld	a0,0(s2)
 22a:	00000097          	auipc	ra,0x0
 22e:	37c080e7          	jalr	892(ra) # 5a6 <open>
 232:	84aa                	mv	s1,a0
 234:	06054a63          	bltz	a0,2a8 <main+0xba>
    grep(pattern, fd);
 238:	85aa                	mv	a1,a0
 23a:	8552                	mv	a0,s4
 23c:	00000097          	auipc	ra,0x0
 240:	ede080e7          	jalr	-290(ra) # 11a <grep>
    close(fd);
 244:	8526                	mv	a0,s1
 246:	00000097          	auipc	ra,0x0
 24a:	348080e7          	jalr	840(ra) # 58e <close>
  for(i = 2; i < argc; i++){
 24e:	0921                	addi	s2,s2,8
 250:	fd391ae3          	bne	s2,s3,224 <main+0x36>
  exit(0,"");
 254:	00001597          	auipc	a1,0x1
 258:	87c58593          	addi	a1,a1,-1924 # ad0 <malloc+0x10c>
 25c:	4501                	li	a0,0
 25e:	00000097          	auipc	ra,0x0
 262:	308080e7          	jalr	776(ra) # 566 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 266:	00001597          	auipc	a1,0x1
 26a:	84a58593          	addi	a1,a1,-1974 # ab0 <malloc+0xec>
 26e:	4509                	li	a0,2
 270:	00000097          	auipc	ra,0x0
 274:	668080e7          	jalr	1640(ra) # 8d8 <fprintf>
    exit(1,"");
 278:	00001597          	auipc	a1,0x1
 27c:	85858593          	addi	a1,a1,-1960 # ad0 <malloc+0x10c>
 280:	4505                	li	a0,1
 282:	00000097          	auipc	ra,0x0
 286:	2e4080e7          	jalr	740(ra) # 566 <exit>
    grep(pattern, 0);
 28a:	4581                	li	a1,0
 28c:	8552                	mv	a0,s4
 28e:	00000097          	auipc	ra,0x0
 292:	e8c080e7          	jalr	-372(ra) # 11a <grep>
    exit(0,"");
 296:	00001597          	auipc	a1,0x1
 29a:	83a58593          	addi	a1,a1,-1990 # ad0 <malloc+0x10c>
 29e:	4501                	li	a0,0
 2a0:	00000097          	auipc	ra,0x0
 2a4:	2c6080e7          	jalr	710(ra) # 566 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 2a8:	00093583          	ld	a1,0(s2)
 2ac:	00001517          	auipc	a0,0x1
 2b0:	82c50513          	addi	a0,a0,-2004 # ad8 <malloc+0x114>
 2b4:	00000097          	auipc	ra,0x0
 2b8:	652080e7          	jalr	1618(ra) # 906 <printf>
      exit(1,"");
 2bc:	00001597          	auipc	a1,0x1
 2c0:	81458593          	addi	a1,a1,-2028 # ad0 <malloc+0x10c>
 2c4:	4505                	li	a0,1
 2c6:	00000097          	auipc	ra,0x0
 2ca:	2a0080e7          	jalr	672(ra) # 566 <exit>

00000000000002ce <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2d6:	00000097          	auipc	ra,0x0
 2da:	f18080e7          	jalr	-232(ra) # 1ee <main>
  exit(0,"");
 2de:	00000597          	auipc	a1,0x0
 2e2:	7f258593          	addi	a1,a1,2034 # ad0 <malloc+0x10c>
 2e6:	4501                	li	a0,0
 2e8:	00000097          	auipc	ra,0x0
 2ec:	27e080e7          	jalr	638(ra) # 566 <exit>

00000000000002f0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f6:	87aa                	mv	a5,a0
 2f8:	0585                	addi	a1,a1,1
 2fa:	0785                	addi	a5,a5,1
 2fc:	fff5c703          	lbu	a4,-1(a1)
 300:	fee78fa3          	sb	a4,-1(a5)
 304:	fb75                	bnez	a4,2f8 <strcpy+0x8>
    ;
  return os;
}
 306:	6422                	ld	s0,8(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 312:	00054783          	lbu	a5,0(a0)
 316:	cb91                	beqz	a5,32a <strcmp+0x1e>
 318:	0005c703          	lbu	a4,0(a1)
 31c:	00f71763          	bne	a4,a5,32a <strcmp+0x1e>
    p++, q++;
 320:	0505                	addi	a0,a0,1
 322:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 324:	00054783          	lbu	a5,0(a0)
 328:	fbe5                	bnez	a5,318 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 32a:	0005c503          	lbu	a0,0(a1)
}
 32e:	40a7853b          	subw	a0,a5,a0
 332:	6422                	ld	s0,8(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <strlen>:

uint
strlen(const char *s)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 33e:	00054783          	lbu	a5,0(a0)
 342:	cf91                	beqz	a5,35e <strlen+0x26>
 344:	0505                	addi	a0,a0,1
 346:	87aa                	mv	a5,a0
 348:	4685                	li	a3,1
 34a:	9e89                	subw	a3,a3,a0
 34c:	00f6853b          	addw	a0,a3,a5
 350:	0785                	addi	a5,a5,1
 352:	fff7c703          	lbu	a4,-1(a5)
 356:	fb7d                	bnez	a4,34c <strlen+0x14>
    ;
  return n;
}
 358:	6422                	ld	s0,8(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  for(n = 0; s[n]; n++)
 35e:	4501                	li	a0,0
 360:	bfe5                	j	358 <strlen+0x20>

0000000000000362 <memset>:

void*
memset(void *dst, int c, uint n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e422                	sd	s0,8(sp)
 366:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 368:	ce09                	beqz	a2,382 <memset+0x20>
 36a:	87aa                	mv	a5,a0
 36c:	fff6071b          	addiw	a4,a2,-1
 370:	1702                	slli	a4,a4,0x20
 372:	9301                	srli	a4,a4,0x20
 374:	0705                	addi	a4,a4,1
 376:	972a                	add	a4,a4,a0
    cdst[i] = c;
 378:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 37c:	0785                	addi	a5,a5,1
 37e:	fee79de3          	bne	a5,a4,378 <memset+0x16>
  }
  return dst;
}
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <strchr>:

char*
strchr(const char *s, char c)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 38e:	00054783          	lbu	a5,0(a0)
 392:	cb99                	beqz	a5,3a8 <strchr+0x20>
    if(*s == c)
 394:	00f58763          	beq	a1,a5,3a2 <strchr+0x1a>
  for(; *s; s++)
 398:	0505                	addi	a0,a0,1
 39a:	00054783          	lbu	a5,0(a0)
 39e:	fbfd                	bnez	a5,394 <strchr+0xc>
      return (char*)s;
  return 0;
 3a0:	4501                	li	a0,0
}
 3a2:	6422                	ld	s0,8(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret
  return 0;
 3a8:	4501                	li	a0,0
 3aa:	bfe5                	j	3a2 <strchr+0x1a>

00000000000003ac <gets>:

char*
gets(char *buf, int max)
{
 3ac:	711d                	addi	sp,sp,-96
 3ae:	ec86                	sd	ra,88(sp)
 3b0:	e8a2                	sd	s0,80(sp)
 3b2:	e4a6                	sd	s1,72(sp)
 3b4:	e0ca                	sd	s2,64(sp)
 3b6:	fc4e                	sd	s3,56(sp)
 3b8:	f852                	sd	s4,48(sp)
 3ba:	f456                	sd	s5,40(sp)
 3bc:	f05a                	sd	s6,32(sp)
 3be:	ec5e                	sd	s7,24(sp)
 3c0:	1080                	addi	s0,sp,96
 3c2:	8baa                	mv	s7,a0
 3c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c6:	892a                	mv	s2,a0
 3c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ca:	4aa9                	li	s5,10
 3cc:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3ce:	89a6                	mv	s3,s1
 3d0:	2485                	addiw	s1,s1,1
 3d2:	0344d863          	bge	s1,s4,402 <gets+0x56>
    cc = read(0, &c, 1);
 3d6:	4605                	li	a2,1
 3d8:	faf40593          	addi	a1,s0,-81
 3dc:	4501                	li	a0,0
 3de:	00000097          	auipc	ra,0x0
 3e2:	1a0080e7          	jalr	416(ra) # 57e <read>
    if(cc < 1)
 3e6:	00a05e63          	blez	a0,402 <gets+0x56>
    buf[i++] = c;
 3ea:	faf44783          	lbu	a5,-81(s0)
 3ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3f2:	01578763          	beq	a5,s5,400 <gets+0x54>
 3f6:	0905                	addi	s2,s2,1
 3f8:	fd679be3          	bne	a5,s6,3ce <gets+0x22>
  for(i=0; i+1 < max; ){
 3fc:	89a6                	mv	s3,s1
 3fe:	a011                	j	402 <gets+0x56>
 400:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 402:	99de                	add	s3,s3,s7
 404:	00098023          	sb	zero,0(s3)
  return buf;
}
 408:	855e                	mv	a0,s7
 40a:	60e6                	ld	ra,88(sp)
 40c:	6446                	ld	s0,80(sp)
 40e:	64a6                	ld	s1,72(sp)
 410:	6906                	ld	s2,64(sp)
 412:	79e2                	ld	s3,56(sp)
 414:	7a42                	ld	s4,48(sp)
 416:	7aa2                	ld	s5,40(sp)
 418:	7b02                	ld	s6,32(sp)
 41a:	6be2                	ld	s7,24(sp)
 41c:	6125                	addi	sp,sp,96
 41e:	8082                	ret

0000000000000420 <stat>:

int
stat(const char *n, struct stat *st)
{
 420:	1101                	addi	sp,sp,-32
 422:	ec06                	sd	ra,24(sp)
 424:	e822                	sd	s0,16(sp)
 426:	e426                	sd	s1,8(sp)
 428:	e04a                	sd	s2,0(sp)
 42a:	1000                	addi	s0,sp,32
 42c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42e:	4581                	li	a1,0
 430:	00000097          	auipc	ra,0x0
 434:	176080e7          	jalr	374(ra) # 5a6 <open>
  if(fd < 0)
 438:	02054563          	bltz	a0,462 <stat+0x42>
 43c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 43e:	85ca                	mv	a1,s2
 440:	00000097          	auipc	ra,0x0
 444:	17e080e7          	jalr	382(ra) # 5be <fstat>
 448:	892a                	mv	s2,a0
  close(fd);
 44a:	8526                	mv	a0,s1
 44c:	00000097          	auipc	ra,0x0
 450:	142080e7          	jalr	322(ra) # 58e <close>
  return r;
}
 454:	854a                	mv	a0,s2
 456:	60e2                	ld	ra,24(sp)
 458:	6442                	ld	s0,16(sp)
 45a:	64a2                	ld	s1,8(sp)
 45c:	6902                	ld	s2,0(sp)
 45e:	6105                	addi	sp,sp,32
 460:	8082                	ret
    return -1;
 462:	597d                	li	s2,-1
 464:	bfc5                	j	454 <stat+0x34>

0000000000000466 <atoi>:

int
atoi(const char *s)
{
 466:	1141                	addi	sp,sp,-16
 468:	e422                	sd	s0,8(sp)
 46a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46c:	00054603          	lbu	a2,0(a0)
 470:	fd06079b          	addiw	a5,a2,-48
 474:	0ff7f793          	andi	a5,a5,255
 478:	4725                	li	a4,9
 47a:	02f76963          	bltu	a4,a5,4ac <atoi+0x46>
 47e:	86aa                	mv	a3,a0
  n = 0;
 480:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 482:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 484:	0685                	addi	a3,a3,1
 486:	0025179b          	slliw	a5,a0,0x2
 48a:	9fa9                	addw	a5,a5,a0
 48c:	0017979b          	slliw	a5,a5,0x1
 490:	9fb1                	addw	a5,a5,a2
 492:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 496:	0006c603          	lbu	a2,0(a3)
 49a:	fd06071b          	addiw	a4,a2,-48
 49e:	0ff77713          	andi	a4,a4,255
 4a2:	fee5f1e3          	bgeu	a1,a4,484 <atoi+0x1e>
  return n;
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret
  n = 0;
 4ac:	4501                	li	a0,0
 4ae:	bfe5                	j	4a6 <atoi+0x40>

00000000000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4b6:	02b57663          	bgeu	a0,a1,4e2 <memmove+0x32>
    while(n-- > 0)
 4ba:	02c05163          	blez	a2,4dc <memmove+0x2c>
 4be:	fff6079b          	addiw	a5,a2,-1
 4c2:	1782                	slli	a5,a5,0x20
 4c4:	9381                	srli	a5,a5,0x20
 4c6:	0785                	addi	a5,a5,1
 4c8:	97aa                	add	a5,a5,a0
  dst = vdst;
 4ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 4cc:	0585                	addi	a1,a1,1
 4ce:	0705                	addi	a4,a4,1
 4d0:	fff5c683          	lbu	a3,-1(a1)
 4d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4d8:	fee79ae3          	bne	a5,a4,4cc <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4dc:	6422                	ld	s0,8(sp)
 4de:	0141                	addi	sp,sp,16
 4e0:	8082                	ret
    dst += n;
 4e2:	00c50733          	add	a4,a0,a2
    src += n;
 4e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4e8:	fec05ae3          	blez	a2,4dc <memmove+0x2c>
 4ec:	fff6079b          	addiw	a5,a2,-1
 4f0:	1782                	slli	a5,a5,0x20
 4f2:	9381                	srli	a5,a5,0x20
 4f4:	fff7c793          	not	a5,a5
 4f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4fa:	15fd                	addi	a1,a1,-1
 4fc:	177d                	addi	a4,a4,-1
 4fe:	0005c683          	lbu	a3,0(a1)
 502:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 506:	fee79ae3          	bne	a5,a4,4fa <memmove+0x4a>
 50a:	bfc9                	j	4dc <memmove+0x2c>

000000000000050c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 50c:	1141                	addi	sp,sp,-16
 50e:	e422                	sd	s0,8(sp)
 510:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 512:	ca05                	beqz	a2,542 <memcmp+0x36>
 514:	fff6069b          	addiw	a3,a2,-1
 518:	1682                	slli	a3,a3,0x20
 51a:	9281                	srli	a3,a3,0x20
 51c:	0685                	addi	a3,a3,1
 51e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 520:	00054783          	lbu	a5,0(a0)
 524:	0005c703          	lbu	a4,0(a1)
 528:	00e79863          	bne	a5,a4,538 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 52c:	0505                	addi	a0,a0,1
    p2++;
 52e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 530:	fed518e3          	bne	a0,a3,520 <memcmp+0x14>
  }
  return 0;
 534:	4501                	li	a0,0
 536:	a019                	j	53c <memcmp+0x30>
      return *p1 - *p2;
 538:	40e7853b          	subw	a0,a5,a4
}
 53c:	6422                	ld	s0,8(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret
  return 0;
 542:	4501                	li	a0,0
 544:	bfe5                	j	53c <memcmp+0x30>

0000000000000546 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 546:	1141                	addi	sp,sp,-16
 548:	e406                	sd	ra,8(sp)
 54a:	e022                	sd	s0,0(sp)
 54c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 54e:	00000097          	auipc	ra,0x0
 552:	f62080e7          	jalr	-158(ra) # 4b0 <memmove>
}
 556:	60a2                	ld	ra,8(sp)
 558:	6402                	ld	s0,0(sp)
 55a:	0141                	addi	sp,sp,16
 55c:	8082                	ret

000000000000055e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 55e:	4885                	li	a7,1
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <exit>:
.global exit
exit:
 li a7, SYS_exit
 566:	4889                	li	a7,2
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <wait>:
.global wait
wait:
 li a7, SYS_wait
 56e:	488d                	li	a7,3
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 576:	4891                	li	a7,4
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <read>:
.global read
read:
 li a7, SYS_read
 57e:	4895                	li	a7,5
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <write>:
.global write
write:
 li a7, SYS_write
 586:	48c1                	li	a7,16
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <close>:
.global close
close:
 li a7, SYS_close
 58e:	48d5                	li	a7,21
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <kill>:
.global kill
kill:
 li a7, SYS_kill
 596:	4899                	li	a7,6
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <exec>:
.global exec
exec:
 li a7, SYS_exec
 59e:	489d                	li	a7,7
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <open>:
.global open
open:
 li a7, SYS_open
 5a6:	48bd                	li	a7,15
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5ae:	48c5                	li	a7,17
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5b6:	48c9                	li	a7,18
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5be:	48a1                	li	a7,8
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <link>:
.global link
link:
 li a7, SYS_link
 5c6:	48cd                	li	a7,19
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ce:	48d1                	li	a7,20
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5d6:	48a5                	li	a7,9
 ecall
 5d8:	00000073          	ecall
 ret
 5dc:	8082                	ret

00000000000005de <dup>:
.global dup
dup:
 li a7, SYS_dup
 5de:	48a9                	li	a7,10
 ecall
 5e0:	00000073          	ecall
 ret
 5e4:	8082                	ret

00000000000005e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5e6:	48ad                	li	a7,11
 ecall
 5e8:	00000073          	ecall
 ret
 5ec:	8082                	ret

00000000000005ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ee:	48b1                	li	a7,12
 ecall
 5f0:	00000073          	ecall
 ret
 5f4:	8082                	ret

00000000000005f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5f6:	48b5                	li	a7,13
 ecall
 5f8:	00000073          	ecall
 ret
 5fc:	8082                	ret

00000000000005fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5fe:	48b9                	li	a7,14
 ecall
 600:	00000073          	ecall
 ret
 604:	8082                	ret

0000000000000606 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 606:	48d9                	li	a7,22
 ecall
 608:	00000073          	ecall
 ret
 60c:	8082                	ret

000000000000060e <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 60e:	48dd                	li	a7,23
 ecall
 610:	00000073          	ecall
 ret
 614:	8082                	ret

0000000000000616 <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 616:	48e1                	li	a7,24
 ecall
 618:	00000073          	ecall
 ret
 61c:	8082                	ret

000000000000061e <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 61e:	48e5                	li	a7,25
 ecall
 620:	00000073          	ecall
 ret
 624:	8082                	ret

0000000000000626 <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 626:	48e9                	li	a7,26
 ecall
 628:	00000073          	ecall
 ret
 62c:	8082                	ret

000000000000062e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 62e:	1101                	addi	sp,sp,-32
 630:	ec06                	sd	ra,24(sp)
 632:	e822                	sd	s0,16(sp)
 634:	1000                	addi	s0,sp,32
 636:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 63a:	4605                	li	a2,1
 63c:	fef40593          	addi	a1,s0,-17
 640:	00000097          	auipc	ra,0x0
 644:	f46080e7          	jalr	-186(ra) # 586 <write>
}
 648:	60e2                	ld	ra,24(sp)
 64a:	6442                	ld	s0,16(sp)
 64c:	6105                	addi	sp,sp,32
 64e:	8082                	ret

0000000000000650 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 650:	7139                	addi	sp,sp,-64
 652:	fc06                	sd	ra,56(sp)
 654:	f822                	sd	s0,48(sp)
 656:	f426                	sd	s1,40(sp)
 658:	f04a                	sd	s2,32(sp)
 65a:	ec4e                	sd	s3,24(sp)
 65c:	0080                	addi	s0,sp,64
 65e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 660:	c299                	beqz	a3,666 <printint+0x16>
 662:	0805c863          	bltz	a1,6f2 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 666:	2581                	sext.w	a1,a1
  neg = 0;
 668:	4881                	li	a7,0
 66a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 66e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 670:	2601                	sext.w	a2,a2
 672:	00000517          	auipc	a0,0x0
 676:	48650513          	addi	a0,a0,1158 # af8 <digits>
 67a:	883a                	mv	a6,a4
 67c:	2705                	addiw	a4,a4,1
 67e:	02c5f7bb          	remuw	a5,a1,a2
 682:	1782                	slli	a5,a5,0x20
 684:	9381                	srli	a5,a5,0x20
 686:	97aa                	add	a5,a5,a0
 688:	0007c783          	lbu	a5,0(a5)
 68c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 690:	0005879b          	sext.w	a5,a1
 694:	02c5d5bb          	divuw	a1,a1,a2
 698:	0685                	addi	a3,a3,1
 69a:	fec7f0e3          	bgeu	a5,a2,67a <printint+0x2a>
  if(neg)
 69e:	00088b63          	beqz	a7,6b4 <printint+0x64>
    buf[i++] = '-';
 6a2:	fd040793          	addi	a5,s0,-48
 6a6:	973e                	add	a4,a4,a5
 6a8:	02d00793          	li	a5,45
 6ac:	fef70823          	sb	a5,-16(a4)
 6b0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6b4:	02e05863          	blez	a4,6e4 <printint+0x94>
 6b8:	fc040793          	addi	a5,s0,-64
 6bc:	00e78933          	add	s2,a5,a4
 6c0:	fff78993          	addi	s3,a5,-1
 6c4:	99ba                	add	s3,s3,a4
 6c6:	377d                	addiw	a4,a4,-1
 6c8:	1702                	slli	a4,a4,0x20
 6ca:	9301                	srli	a4,a4,0x20
 6cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6d0:	fff94583          	lbu	a1,-1(s2)
 6d4:	8526                	mv	a0,s1
 6d6:	00000097          	auipc	ra,0x0
 6da:	f58080e7          	jalr	-168(ra) # 62e <putc>
  while(--i >= 0)
 6de:	197d                	addi	s2,s2,-1
 6e0:	ff3918e3          	bne	s2,s3,6d0 <printint+0x80>
}
 6e4:	70e2                	ld	ra,56(sp)
 6e6:	7442                	ld	s0,48(sp)
 6e8:	74a2                	ld	s1,40(sp)
 6ea:	7902                	ld	s2,32(sp)
 6ec:	69e2                	ld	s3,24(sp)
 6ee:	6121                	addi	sp,sp,64
 6f0:	8082                	ret
    x = -xx;
 6f2:	40b005bb          	negw	a1,a1
    neg = 1;
 6f6:	4885                	li	a7,1
    x = -xx;
 6f8:	bf8d                	j	66a <printint+0x1a>

00000000000006fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6fa:	7119                	addi	sp,sp,-128
 6fc:	fc86                	sd	ra,120(sp)
 6fe:	f8a2                	sd	s0,112(sp)
 700:	f4a6                	sd	s1,104(sp)
 702:	f0ca                	sd	s2,96(sp)
 704:	ecce                	sd	s3,88(sp)
 706:	e8d2                	sd	s4,80(sp)
 708:	e4d6                	sd	s5,72(sp)
 70a:	e0da                	sd	s6,64(sp)
 70c:	fc5e                	sd	s7,56(sp)
 70e:	f862                	sd	s8,48(sp)
 710:	f466                	sd	s9,40(sp)
 712:	f06a                	sd	s10,32(sp)
 714:	ec6e                	sd	s11,24(sp)
 716:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 718:	0005c903          	lbu	s2,0(a1)
 71c:	18090f63          	beqz	s2,8ba <vprintf+0x1c0>
 720:	8aaa                	mv	s5,a0
 722:	8b32                	mv	s6,a2
 724:	00158493          	addi	s1,a1,1
  state = 0;
 728:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 72a:	02500a13          	li	s4,37
      if(c == 'd'){
 72e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 732:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 736:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 73a:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	00000b97          	auipc	s7,0x0
 742:	3bab8b93          	addi	s7,s7,954 # af8 <digits>
 746:	a839                	j	764 <vprintf+0x6a>
        putc(fd, c);
 748:	85ca                	mv	a1,s2
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	ee2080e7          	jalr	-286(ra) # 62e <putc>
 754:	a019                	j	75a <vprintf+0x60>
    } else if(state == '%'){
 756:	01498f63          	beq	s3,s4,774 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 75a:	0485                	addi	s1,s1,1
 75c:	fff4c903          	lbu	s2,-1(s1)
 760:	14090d63          	beqz	s2,8ba <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 764:	0009079b          	sext.w	a5,s2
    if(state == 0){
 768:	fe0997e3          	bnez	s3,756 <vprintf+0x5c>
      if(c == '%'){
 76c:	fd479ee3          	bne	a5,s4,748 <vprintf+0x4e>
        state = '%';
 770:	89be                	mv	s3,a5
 772:	b7e5                	j	75a <vprintf+0x60>
      if(c == 'd'){
 774:	05878063          	beq	a5,s8,7b4 <vprintf+0xba>
      } else if(c == 'l') {
 778:	05978c63          	beq	a5,s9,7d0 <vprintf+0xd6>
      } else if(c == 'x') {
 77c:	07a78863          	beq	a5,s10,7ec <vprintf+0xf2>
      } else if(c == 'p') {
 780:	09b78463          	beq	a5,s11,808 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 784:	07300713          	li	a4,115
 788:	0ce78663          	beq	a5,a4,854 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 78c:	06300713          	li	a4,99
 790:	0ee78e63          	beq	a5,a4,88c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 794:	11478863          	beq	a5,s4,8a4 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 798:	85d2                	mv	a1,s4
 79a:	8556                	mv	a0,s5
 79c:	00000097          	auipc	ra,0x0
 7a0:	e92080e7          	jalr	-366(ra) # 62e <putc>
        putc(fd, c);
 7a4:	85ca                	mv	a1,s2
 7a6:	8556                	mv	a0,s5
 7a8:	00000097          	auipc	ra,0x0
 7ac:	e86080e7          	jalr	-378(ra) # 62e <putc>
      }
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b765                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7b4:	008b0913          	addi	s2,s6,8
 7b8:	4685                	li	a3,1
 7ba:	4629                	li	a2,10
 7bc:	000b2583          	lw	a1,0(s6)
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e8e080e7          	jalr	-370(ra) # 650 <printint>
 7ca:	8b4a                	mv	s6,s2
      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b771                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d0:	008b0913          	addi	s2,s6,8
 7d4:	4681                	li	a3,0
 7d6:	4629                	li	a2,10
 7d8:	000b2583          	lw	a1,0(s6)
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	e72080e7          	jalr	-398(ra) # 650 <printint>
 7e6:	8b4a                	mv	s6,s2
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	bf85                	j	75a <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7ec:	008b0913          	addi	s2,s6,8
 7f0:	4681                	li	a3,0
 7f2:	4641                	li	a2,16
 7f4:	000b2583          	lw	a1,0(s6)
 7f8:	8556                	mv	a0,s5
 7fa:	00000097          	auipc	ra,0x0
 7fe:	e56080e7          	jalr	-426(ra) # 650 <printint>
 802:	8b4a                	mv	s6,s2
      state = 0;
 804:	4981                	li	s3,0
 806:	bf91                	j	75a <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 808:	008b0793          	addi	a5,s6,8
 80c:	f8f43423          	sd	a5,-120(s0)
 810:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 814:	03000593          	li	a1,48
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	e14080e7          	jalr	-492(ra) # 62e <putc>
  putc(fd, 'x');
 822:	85ea                	mv	a1,s10
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	e08080e7          	jalr	-504(ra) # 62e <putc>
 82e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 830:	03c9d793          	srli	a5,s3,0x3c
 834:	97de                	add	a5,a5,s7
 836:	0007c583          	lbu	a1,0(a5)
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	df2080e7          	jalr	-526(ra) # 62e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 844:	0992                	slli	s3,s3,0x4
 846:	397d                	addiw	s2,s2,-1
 848:	fe0914e3          	bnez	s2,830 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 84c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 850:	4981                	li	s3,0
 852:	b721                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 854:	008b0993          	addi	s3,s6,8
 858:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 85c:	02090163          	beqz	s2,87e <vprintf+0x184>
        while(*s != 0){
 860:	00094583          	lbu	a1,0(s2)
 864:	c9a1                	beqz	a1,8b4 <vprintf+0x1ba>
          putc(fd, *s);
 866:	8556                	mv	a0,s5
 868:	00000097          	auipc	ra,0x0
 86c:	dc6080e7          	jalr	-570(ra) # 62e <putc>
          s++;
 870:	0905                	addi	s2,s2,1
        while(*s != 0){
 872:	00094583          	lbu	a1,0(s2)
 876:	f9e5                	bnez	a1,866 <vprintf+0x16c>
        s = va_arg(ap, char*);
 878:	8b4e                	mv	s6,s3
      state = 0;
 87a:	4981                	li	s3,0
 87c:	bdf9                	j	75a <vprintf+0x60>
          s = "(null)";
 87e:	00000917          	auipc	s2,0x0
 882:	27290913          	addi	s2,s2,626 # af0 <malloc+0x12c>
        while(*s != 0){
 886:	02800593          	li	a1,40
 88a:	bff1                	j	866 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 88c:	008b0913          	addi	s2,s6,8
 890:	000b4583          	lbu	a1,0(s6)
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	d98080e7          	jalr	-616(ra) # 62e <putc>
 89e:	8b4a                	mv	s6,s2
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	bd65                	j	75a <vprintf+0x60>
        putc(fd, c);
 8a4:	85d2                	mv	a1,s4
 8a6:	8556                	mv	a0,s5
 8a8:	00000097          	auipc	ra,0x0
 8ac:	d86080e7          	jalr	-634(ra) # 62e <putc>
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	b565                	j	75a <vprintf+0x60>
        s = va_arg(ap, char*);
 8b4:	8b4e                	mv	s6,s3
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b54d                	j	75a <vprintf+0x60>
    }
  }
}
 8ba:	70e6                	ld	ra,120(sp)
 8bc:	7446                	ld	s0,112(sp)
 8be:	74a6                	ld	s1,104(sp)
 8c0:	7906                	ld	s2,96(sp)
 8c2:	69e6                	ld	s3,88(sp)
 8c4:	6a46                	ld	s4,80(sp)
 8c6:	6aa6                	ld	s5,72(sp)
 8c8:	6b06                	ld	s6,64(sp)
 8ca:	7be2                	ld	s7,56(sp)
 8cc:	7c42                	ld	s8,48(sp)
 8ce:	7ca2                	ld	s9,40(sp)
 8d0:	7d02                	ld	s10,32(sp)
 8d2:	6de2                	ld	s11,24(sp)
 8d4:	6109                	addi	sp,sp,128
 8d6:	8082                	ret

00000000000008d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d8:	715d                	addi	sp,sp,-80
 8da:	ec06                	sd	ra,24(sp)
 8dc:	e822                	sd	s0,16(sp)
 8de:	1000                	addi	s0,sp,32
 8e0:	e010                	sd	a2,0(s0)
 8e2:	e414                	sd	a3,8(s0)
 8e4:	e818                	sd	a4,16(s0)
 8e6:	ec1c                	sd	a5,24(s0)
 8e8:	03043023          	sd	a6,32(s0)
 8ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8f0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f4:	8622                	mv	a2,s0
 8f6:	00000097          	auipc	ra,0x0
 8fa:	e04080e7          	jalr	-508(ra) # 6fa <vprintf>
}
 8fe:	60e2                	ld	ra,24(sp)
 900:	6442                	ld	s0,16(sp)
 902:	6161                	addi	sp,sp,80
 904:	8082                	ret

0000000000000906 <printf>:

void
printf(const char *fmt, ...)
{
 906:	711d                	addi	sp,sp,-96
 908:	ec06                	sd	ra,24(sp)
 90a:	e822                	sd	s0,16(sp)
 90c:	1000                	addi	s0,sp,32
 90e:	e40c                	sd	a1,8(s0)
 910:	e810                	sd	a2,16(s0)
 912:	ec14                	sd	a3,24(s0)
 914:	f018                	sd	a4,32(s0)
 916:	f41c                	sd	a5,40(s0)
 918:	03043823          	sd	a6,48(s0)
 91c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 920:	00840613          	addi	a2,s0,8
 924:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 928:	85aa                	mv	a1,a0
 92a:	4505                	li	a0,1
 92c:	00000097          	auipc	ra,0x0
 930:	dce080e7          	jalr	-562(ra) # 6fa <vprintf>
}
 934:	60e2                	ld	ra,24(sp)
 936:	6442                	ld	s0,16(sp)
 938:	6125                	addi	sp,sp,96
 93a:	8082                	ret

000000000000093c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 93c:	1141                	addi	sp,sp,-16
 93e:	e422                	sd	s0,8(sp)
 940:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 942:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 946:	00000797          	auipc	a5,0x0
 94a:	6ba7b783          	ld	a5,1722(a5) # 1000 <freep>
 94e:	a805                	j	97e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 950:	4618                	lw	a4,8(a2)
 952:	9db9                	addw	a1,a1,a4
 954:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 958:	6398                	ld	a4,0(a5)
 95a:	6318                	ld	a4,0(a4)
 95c:	fee53823          	sd	a4,-16(a0)
 960:	a091                	j	9a4 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 962:	ff852703          	lw	a4,-8(a0)
 966:	9e39                	addw	a2,a2,a4
 968:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 96a:	ff053703          	ld	a4,-16(a0)
 96e:	e398                	sd	a4,0(a5)
 970:	a099                	j	9b6 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 972:	6398                	ld	a4,0(a5)
 974:	00e7e463          	bltu	a5,a4,97c <free+0x40>
 978:	00e6ea63          	bltu	a3,a4,98c <free+0x50>
{
 97c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97e:	fed7fae3          	bgeu	a5,a3,972 <free+0x36>
 982:	6398                	ld	a4,0(a5)
 984:	00e6e463          	bltu	a3,a4,98c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 988:	fee7eae3          	bltu	a5,a4,97c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 98c:	ff852583          	lw	a1,-8(a0)
 990:	6390                	ld	a2,0(a5)
 992:	02059713          	slli	a4,a1,0x20
 996:	9301                	srli	a4,a4,0x20
 998:	0712                	slli	a4,a4,0x4
 99a:	9736                	add	a4,a4,a3
 99c:	fae60ae3          	beq	a2,a4,950 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9a0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9a4:	4790                	lw	a2,8(a5)
 9a6:	02061713          	slli	a4,a2,0x20
 9aa:	9301                	srli	a4,a4,0x20
 9ac:	0712                	slli	a4,a4,0x4
 9ae:	973e                	add	a4,a4,a5
 9b0:	fae689e3          	beq	a3,a4,962 <free+0x26>
  } else
    p->s.ptr = bp;
 9b4:	e394                	sd	a3,0(a5)
  freep = p;
 9b6:	00000717          	auipc	a4,0x0
 9ba:	64f73523          	sd	a5,1610(a4) # 1000 <freep>
}
 9be:	6422                	ld	s0,8(sp)
 9c0:	0141                	addi	sp,sp,16
 9c2:	8082                	ret

00000000000009c4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c4:	7139                	addi	sp,sp,-64
 9c6:	fc06                	sd	ra,56(sp)
 9c8:	f822                	sd	s0,48(sp)
 9ca:	f426                	sd	s1,40(sp)
 9cc:	f04a                	sd	s2,32(sp)
 9ce:	ec4e                	sd	s3,24(sp)
 9d0:	e852                	sd	s4,16(sp)
 9d2:	e456                	sd	s5,8(sp)
 9d4:	e05a                	sd	s6,0(sp)
 9d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d8:	02051493          	slli	s1,a0,0x20
 9dc:	9081                	srli	s1,s1,0x20
 9de:	04bd                	addi	s1,s1,15
 9e0:	8091                	srli	s1,s1,0x4
 9e2:	0014899b          	addiw	s3,s1,1
 9e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9e8:	00000517          	auipc	a0,0x0
 9ec:	61853503          	ld	a0,1560(a0) # 1000 <freep>
 9f0:	c515                	beqz	a0,a1c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f4:	4798                	lw	a4,8(a5)
 9f6:	02977f63          	bgeu	a4,s1,a34 <malloc+0x70>
 9fa:	8a4e                	mv	s4,s3
 9fc:	0009871b          	sext.w	a4,s3
 a00:	6685                	lui	a3,0x1
 a02:	00d77363          	bgeu	a4,a3,a08 <malloc+0x44>
 a06:	6a05                	lui	s4,0x1
 a08:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a0c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a10:	00000917          	auipc	s2,0x0
 a14:	5f090913          	addi	s2,s2,1520 # 1000 <freep>
  if(p == (char*)-1)
 a18:	5afd                	li	s5,-1
 a1a:	a88d                	j	a8c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a1c:	00001797          	auipc	a5,0x1
 a20:	9f478793          	addi	a5,a5,-1548 # 1410 <base>
 a24:	00000717          	auipc	a4,0x0
 a28:	5cf73e23          	sd	a5,1500(a4) # 1000 <freep>
 a2c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a2e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a32:	b7e1                	j	9fa <malloc+0x36>
      if(p->s.size == nunits)
 a34:	02e48b63          	beq	s1,a4,a6a <malloc+0xa6>
        p->s.size -= nunits;
 a38:	4137073b          	subw	a4,a4,s3
 a3c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a3e:	1702                	slli	a4,a4,0x20
 a40:	9301                	srli	a4,a4,0x20
 a42:	0712                	slli	a4,a4,0x4
 a44:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a46:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a4a:	00000717          	auipc	a4,0x0
 a4e:	5aa73b23          	sd	a0,1462(a4) # 1000 <freep>
      return (void*)(p + 1);
 a52:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a56:	70e2                	ld	ra,56(sp)
 a58:	7442                	ld	s0,48(sp)
 a5a:	74a2                	ld	s1,40(sp)
 a5c:	7902                	ld	s2,32(sp)
 a5e:	69e2                	ld	s3,24(sp)
 a60:	6a42                	ld	s4,16(sp)
 a62:	6aa2                	ld	s5,8(sp)
 a64:	6b02                	ld	s6,0(sp)
 a66:	6121                	addi	sp,sp,64
 a68:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a6a:	6398                	ld	a4,0(a5)
 a6c:	e118                	sd	a4,0(a0)
 a6e:	bff1                	j	a4a <malloc+0x86>
  hp->s.size = nu;
 a70:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a74:	0541                	addi	a0,a0,16
 a76:	00000097          	auipc	ra,0x0
 a7a:	ec6080e7          	jalr	-314(ra) # 93c <free>
  return freep;
 a7e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a82:	d971                	beqz	a0,a56 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a84:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a86:	4798                	lw	a4,8(a5)
 a88:	fa9776e3          	bgeu	a4,s1,a34 <malloc+0x70>
    if(p == freep)
 a8c:	00093703          	ld	a4,0(s2)
 a90:	853e                	mv	a0,a5
 a92:	fef719e3          	bne	a4,a5,a84 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a96:	8552                	mv	a0,s4
 a98:	00000097          	auipc	ra,0x0
 a9c:	b56080e7          	jalr	-1194(ra) # 5ee <sbrk>
  if(p == (char*)-1)
 aa0:	fd5518e3          	bne	a0,s5,a70 <malloc+0xac>
        return 0;
 aa4:	4501                	li	a0,0
 aa6:	bf45                	j	a56 <malloc+0x92>
