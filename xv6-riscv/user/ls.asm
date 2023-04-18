
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	342080e7          	jalr	834(ra) # 352 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	316080e7          	jalr	790(ra) # 352 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	2f4080e7          	jalr	756(ra) # 352 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	faa98993          	addi	s3,s3,-86 # 1010 <buf.1119>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	454080e7          	jalr	1108(ra) # 4ca <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2d2080e7          	jalr	722(ra) # 352 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2c4080e7          	jalr	708(ra) # 352 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	02000593          	li	a1,32
  a4:	01298533          	add	a0,s3,s2
  a8:	00000097          	auipc	ra,0x0
  ac:	2d4080e7          	jalr	724(ra) # 37c <memset>
  return buf;
  b0:	84ce                	mv	s1,s3
  b2:	bf69                	j	4c <fmtname+0x4c>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	24913c23          	sd	s1,600(sp)
  c4:	25213823          	sd	s2,592(sp)
  c8:	25313423          	sd	s3,584(sp)
  cc:	25413023          	sd	s4,576(sp)
  d0:	23513c23          	sd	s5,568(sp)
  d4:	1c80                	addi	s0,sp,624
  d6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  d8:	4581                	li	a1,0
  da:	00000097          	auipc	ra,0x0
  de:	4e6080e7          	jalr	1254(ra) # 5c0 <open>
  e2:	08054163          	bltz	a0,164 <ls+0xb0>
  e6:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  e8:	d9840593          	addi	a1,s0,-616
  ec:	00000097          	auipc	ra,0x0
  f0:	4ec080e7          	jalr	1260(ra) # 5d8 <fstat>
  f4:	08054363          	bltz	a0,17a <ls+0xc6>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  f8:	da041783          	lh	a5,-608(s0)
  fc:	0007869b          	sext.w	a3,a5
 100:	4705                	li	a4,1
 102:	08e68c63          	beq	a3,a4,19a <ls+0xe6>
 106:	37f9                	addiw	a5,a5,-2
 108:	17c2                	slli	a5,a5,0x30
 10a:	93c1                	srli	a5,a5,0x30
 10c:	02f76663          	bltu	a4,a5,138 <ls+0x84>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 110:	854a                	mv	a0,s2
 112:	00000097          	auipc	ra,0x0
 116:	eee080e7          	jalr	-274(ra) # 0 <fmtname>
 11a:	85aa                	mv	a1,a0
 11c:	da843703          	ld	a4,-600(s0)
 120:	d9c42683          	lw	a3,-612(s0)
 124:	da041603          	lh	a2,-608(s0)
 128:	00001517          	auipc	a0,0x1
 12c:	9d850513          	addi	a0,a0,-1576 # b00 <malloc+0x122>
 130:	00000097          	auipc	ra,0x0
 134:	7f0080e7          	jalr	2032(ra) # 920 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 138:	8526                	mv	a0,s1
 13a:	00000097          	auipc	ra,0x0
 13e:	46e080e7          	jalr	1134(ra) # 5a8 <close>
}
 142:	26813083          	ld	ra,616(sp)
 146:	26013403          	ld	s0,608(sp)
 14a:	25813483          	ld	s1,600(sp)
 14e:	25013903          	ld	s2,592(sp)
 152:	24813983          	ld	s3,584(sp)
 156:	24013a03          	ld	s4,576(sp)
 15a:	23813a83          	ld	s5,568(sp)
 15e:	27010113          	addi	sp,sp,624
 162:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 164:	864a                	mv	a2,s2
 166:	00001597          	auipc	a1,0x1
 16a:	96a58593          	addi	a1,a1,-1686 # ad0 <malloc+0xf2>
 16e:	4509                	li	a0,2
 170:	00000097          	auipc	ra,0x0
 174:	782080e7          	jalr	1922(ra) # 8f2 <fprintf>
    return;
 178:	b7e9                	j	142 <ls+0x8e>
    fprintf(2, "ls: cannot stat %s\n", path);
 17a:	864a                	mv	a2,s2
 17c:	00001597          	auipc	a1,0x1
 180:	96c58593          	addi	a1,a1,-1684 # ae8 <malloc+0x10a>
 184:	4509                	li	a0,2
 186:	00000097          	auipc	ra,0x0
 18a:	76c080e7          	jalr	1900(ra) # 8f2 <fprintf>
    close(fd);
 18e:	8526                	mv	a0,s1
 190:	00000097          	auipc	ra,0x0
 194:	418080e7          	jalr	1048(ra) # 5a8 <close>
    return;
 198:	b76d                	j	142 <ls+0x8e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19a:	854a                	mv	a0,s2
 19c:	00000097          	auipc	ra,0x0
 1a0:	1b6080e7          	jalr	438(ra) # 352 <strlen>
 1a4:	2541                	addiw	a0,a0,16
 1a6:	20000793          	li	a5,512
 1aa:	00a7fb63          	bgeu	a5,a0,1c0 <ls+0x10c>
      printf("ls: path too long\n");
 1ae:	00001517          	auipc	a0,0x1
 1b2:	96250513          	addi	a0,a0,-1694 # b10 <malloc+0x132>
 1b6:	00000097          	auipc	ra,0x0
 1ba:	76a080e7          	jalr	1898(ra) # 920 <printf>
      break;
 1be:	bfad                	j	138 <ls+0x84>
    strcpy(buf, path);
 1c0:	85ca                	mv	a1,s2
 1c2:	dc040513          	addi	a0,s0,-576
 1c6:	00000097          	auipc	ra,0x0
 1ca:	144080e7          	jalr	324(ra) # 30a <strcpy>
    p = buf+strlen(buf);
 1ce:	dc040513          	addi	a0,s0,-576
 1d2:	00000097          	auipc	ra,0x0
 1d6:	180080e7          	jalr	384(ra) # 352 <strlen>
 1da:	02051913          	slli	s2,a0,0x20
 1de:	02095913          	srli	s2,s2,0x20
 1e2:	dc040793          	addi	a5,s0,-576
 1e6:	993e                	add	s2,s2,a5
    *p++ = '/';
 1e8:	00190993          	addi	s3,s2,1
 1ec:	02f00793          	li	a5,47
 1f0:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1f4:	00001a17          	auipc	s4,0x1
 1f8:	934a0a13          	addi	s4,s4,-1740 # b28 <malloc+0x14a>
        printf("ls: cannot stat %s\n", buf);
 1fc:	00001a97          	auipc	s5,0x1
 200:	8eca8a93          	addi	s5,s5,-1812 # ae8 <malloc+0x10a>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 204:	a801                	j	214 <ls+0x160>
        printf("ls: cannot stat %s\n", buf);
 206:	dc040593          	addi	a1,s0,-576
 20a:	8556                	mv	a0,s5
 20c:	00000097          	auipc	ra,0x0
 210:	714080e7          	jalr	1812(ra) # 920 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 214:	4641                	li	a2,16
 216:	db040593          	addi	a1,s0,-592
 21a:	8526                	mv	a0,s1
 21c:	00000097          	auipc	ra,0x0
 220:	37c080e7          	jalr	892(ra) # 598 <read>
 224:	47c1                	li	a5,16
 226:	f0f519e3          	bne	a0,a5,138 <ls+0x84>
      if(de.inum == 0)
 22a:	db045783          	lhu	a5,-592(s0)
 22e:	d3fd                	beqz	a5,214 <ls+0x160>
      memmove(p, de.name, DIRSIZ);
 230:	4639                	li	a2,14
 232:	db240593          	addi	a1,s0,-590
 236:	854e                	mv	a0,s3
 238:	00000097          	auipc	ra,0x0
 23c:	292080e7          	jalr	658(ra) # 4ca <memmove>
      p[DIRSIZ] = 0;
 240:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 244:	d9840593          	addi	a1,s0,-616
 248:	dc040513          	addi	a0,s0,-576
 24c:	00000097          	auipc	ra,0x0
 250:	1ee080e7          	jalr	494(ra) # 43a <stat>
 254:	fa0549e3          	bltz	a0,206 <ls+0x152>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 258:	dc040513          	addi	a0,s0,-576
 25c:	00000097          	auipc	ra,0x0
 260:	da4080e7          	jalr	-604(ra) # 0 <fmtname>
 264:	85aa                	mv	a1,a0
 266:	da843703          	ld	a4,-600(s0)
 26a:	d9c42683          	lw	a3,-612(s0)
 26e:	da041603          	lh	a2,-608(s0)
 272:	8552                	mv	a0,s4
 274:	00000097          	auipc	ra,0x0
 278:	6ac080e7          	jalr	1708(ra) # 920 <printf>
 27c:	bf61                	j	214 <ls+0x160>

000000000000027e <main>:

int
main(int argc, char *argv[])
{
 27e:	1101                	addi	sp,sp,-32
 280:	ec06                	sd	ra,24(sp)
 282:	e822                	sd	s0,16(sp)
 284:	e426                	sd	s1,8(sp)
 286:	e04a                	sd	s2,0(sp)
 288:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 28a:	4785                	li	a5,1
 28c:	02a7dd63          	bge	a5,a0,2c6 <main+0x48>
 290:	00858493          	addi	s1,a1,8
 294:	ffe5091b          	addiw	s2,a0,-2
 298:	1902                	slli	s2,s2,0x20
 29a:	02095913          	srli	s2,s2,0x20
 29e:	090e                	slli	s2,s2,0x3
 2a0:	05c1                	addi	a1,a1,16
 2a2:	992e                	add	s2,s2,a1
    ls(".");
    exit(0,"");
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a4:	6088                	ld	a0,0(s1)
 2a6:	00000097          	auipc	ra,0x0
 2aa:	e0e080e7          	jalr	-498(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2ae:	04a1                	addi	s1,s1,8
 2b0:	ff249ae3          	bne	s1,s2,2a4 <main+0x26>
  exit(0,"");
 2b4:	00001597          	auipc	a1,0x1
 2b8:	88c58593          	addi	a1,a1,-1908 # b40 <malloc+0x162>
 2bc:	4501                	li	a0,0
 2be:	00000097          	auipc	ra,0x0
 2c2:	2c2080e7          	jalr	706(ra) # 580 <exit>
    ls(".");
 2c6:	00001517          	auipc	a0,0x1
 2ca:	87250513          	addi	a0,a0,-1934 # b38 <malloc+0x15a>
 2ce:	00000097          	auipc	ra,0x0
 2d2:	de6080e7          	jalr	-538(ra) # b4 <ls>
    exit(0,"");
 2d6:	00001597          	auipc	a1,0x1
 2da:	86a58593          	addi	a1,a1,-1942 # b40 <malloc+0x162>
 2de:	4501                	li	a0,0
 2e0:	00000097          	auipc	ra,0x0
 2e4:	2a0080e7          	jalr	672(ra) # 580 <exit>

00000000000002e8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2f0:	00000097          	auipc	ra,0x0
 2f4:	f8e080e7          	jalr	-114(ra) # 27e <main>
  exit(0,"");
 2f8:	00001597          	auipc	a1,0x1
 2fc:	84858593          	addi	a1,a1,-1976 # b40 <malloc+0x162>
 300:	4501                	li	a0,0
 302:	00000097          	auipc	ra,0x0
 306:	27e080e7          	jalr	638(ra) # 580 <exit>

000000000000030a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 310:	87aa                	mv	a5,a0
 312:	0585                	addi	a1,a1,1
 314:	0785                	addi	a5,a5,1
 316:	fff5c703          	lbu	a4,-1(a1)
 31a:	fee78fa3          	sb	a4,-1(a5)
 31e:	fb75                	bnez	a4,312 <strcpy+0x8>
    ;
  return os;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 326:	1141                	addi	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 32c:	00054783          	lbu	a5,0(a0)
 330:	cb91                	beqz	a5,344 <strcmp+0x1e>
 332:	0005c703          	lbu	a4,0(a1)
 336:	00f71763          	bne	a4,a5,344 <strcmp+0x1e>
    p++, q++;
 33a:	0505                	addi	a0,a0,1
 33c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 33e:	00054783          	lbu	a5,0(a0)
 342:	fbe5                	bnez	a5,332 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 344:	0005c503          	lbu	a0,0(a1)
}
 348:	40a7853b          	subw	a0,a5,a0
 34c:	6422                	ld	s0,8(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <strlen>:

uint
strlen(const char *s)
{
 352:	1141                	addi	sp,sp,-16
 354:	e422                	sd	s0,8(sp)
 356:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 358:	00054783          	lbu	a5,0(a0)
 35c:	cf91                	beqz	a5,378 <strlen+0x26>
 35e:	0505                	addi	a0,a0,1
 360:	87aa                	mv	a5,a0
 362:	4685                	li	a3,1
 364:	9e89                	subw	a3,a3,a0
 366:	00f6853b          	addw	a0,a3,a5
 36a:	0785                	addi	a5,a5,1
 36c:	fff7c703          	lbu	a4,-1(a5)
 370:	fb7d                	bnez	a4,366 <strlen+0x14>
    ;
  return n;
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	addi	sp,sp,16
 376:	8082                	ret
  for(n = 0; s[n]; n++)
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <strlen+0x20>

000000000000037c <memset>:

void*
memset(void *dst, int c, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 382:	ce09                	beqz	a2,39c <memset+0x20>
 384:	87aa                	mv	a5,a0
 386:	fff6071b          	addiw	a4,a2,-1
 38a:	1702                	slli	a4,a4,0x20
 38c:	9301                	srli	a4,a4,0x20
 38e:	0705                	addi	a4,a4,1
 390:	972a                	add	a4,a4,a0
    cdst[i] = c;
 392:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 396:	0785                	addi	a5,a5,1
 398:	fee79de3          	bne	a5,a4,392 <memset+0x16>
  }
  return dst;
}
 39c:	6422                	ld	s0,8(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <strchr>:

char*
strchr(const char *s, char c)
{
 3a2:	1141                	addi	sp,sp,-16
 3a4:	e422                	sd	s0,8(sp)
 3a6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3a8:	00054783          	lbu	a5,0(a0)
 3ac:	cb99                	beqz	a5,3c2 <strchr+0x20>
    if(*s == c)
 3ae:	00f58763          	beq	a1,a5,3bc <strchr+0x1a>
  for(; *s; s++)
 3b2:	0505                	addi	a0,a0,1
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	fbfd                	bnez	a5,3ae <strchr+0xc>
      return (char*)s;
  return 0;
 3ba:	4501                	li	a0,0
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	addi	sp,sp,16
 3c0:	8082                	ret
  return 0;
 3c2:	4501                	li	a0,0
 3c4:	bfe5                	j	3bc <strchr+0x1a>

00000000000003c6 <gets>:

char*
gets(char *buf, int max)
{
 3c6:	711d                	addi	sp,sp,-96
 3c8:	ec86                	sd	ra,88(sp)
 3ca:	e8a2                	sd	s0,80(sp)
 3cc:	e4a6                	sd	s1,72(sp)
 3ce:	e0ca                	sd	s2,64(sp)
 3d0:	fc4e                	sd	s3,56(sp)
 3d2:	f852                	sd	s4,48(sp)
 3d4:	f456                	sd	s5,40(sp)
 3d6:	f05a                	sd	s6,32(sp)
 3d8:	ec5e                	sd	s7,24(sp)
 3da:	1080                	addi	s0,sp,96
 3dc:	8baa                	mv	s7,a0
 3de:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3e0:	892a                	mv	s2,a0
 3e2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3e4:	4aa9                	li	s5,10
 3e6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3e8:	89a6                	mv	s3,s1
 3ea:	2485                	addiw	s1,s1,1
 3ec:	0344d863          	bge	s1,s4,41c <gets+0x56>
    cc = read(0, &c, 1);
 3f0:	4605                	li	a2,1
 3f2:	faf40593          	addi	a1,s0,-81
 3f6:	4501                	li	a0,0
 3f8:	00000097          	auipc	ra,0x0
 3fc:	1a0080e7          	jalr	416(ra) # 598 <read>
    if(cc < 1)
 400:	00a05e63          	blez	a0,41c <gets+0x56>
    buf[i++] = c;
 404:	faf44783          	lbu	a5,-81(s0)
 408:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 40c:	01578763          	beq	a5,s5,41a <gets+0x54>
 410:	0905                	addi	s2,s2,1
 412:	fd679be3          	bne	a5,s6,3e8 <gets+0x22>
  for(i=0; i+1 < max; ){
 416:	89a6                	mv	s3,s1
 418:	a011                	j	41c <gets+0x56>
 41a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 41c:	99de                	add	s3,s3,s7
 41e:	00098023          	sb	zero,0(s3)
  return buf;
}
 422:	855e                	mv	a0,s7
 424:	60e6                	ld	ra,88(sp)
 426:	6446                	ld	s0,80(sp)
 428:	64a6                	ld	s1,72(sp)
 42a:	6906                	ld	s2,64(sp)
 42c:	79e2                	ld	s3,56(sp)
 42e:	7a42                	ld	s4,48(sp)
 430:	7aa2                	ld	s5,40(sp)
 432:	7b02                	ld	s6,32(sp)
 434:	6be2                	ld	s7,24(sp)
 436:	6125                	addi	sp,sp,96
 438:	8082                	ret

000000000000043a <stat>:

int
stat(const char *n, struct stat *st)
{
 43a:	1101                	addi	sp,sp,-32
 43c:	ec06                	sd	ra,24(sp)
 43e:	e822                	sd	s0,16(sp)
 440:	e426                	sd	s1,8(sp)
 442:	e04a                	sd	s2,0(sp)
 444:	1000                	addi	s0,sp,32
 446:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 448:	4581                	li	a1,0
 44a:	00000097          	auipc	ra,0x0
 44e:	176080e7          	jalr	374(ra) # 5c0 <open>
  if(fd < 0)
 452:	02054563          	bltz	a0,47c <stat+0x42>
 456:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 458:	85ca                	mv	a1,s2
 45a:	00000097          	auipc	ra,0x0
 45e:	17e080e7          	jalr	382(ra) # 5d8 <fstat>
 462:	892a                	mv	s2,a0
  close(fd);
 464:	8526                	mv	a0,s1
 466:	00000097          	auipc	ra,0x0
 46a:	142080e7          	jalr	322(ra) # 5a8 <close>
  return r;
}
 46e:	854a                	mv	a0,s2
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	64a2                	ld	s1,8(sp)
 476:	6902                	ld	s2,0(sp)
 478:	6105                	addi	sp,sp,32
 47a:	8082                	ret
    return -1;
 47c:	597d                	li	s2,-1
 47e:	bfc5                	j	46e <stat+0x34>

0000000000000480 <atoi>:

int
atoi(const char *s)
{
 480:	1141                	addi	sp,sp,-16
 482:	e422                	sd	s0,8(sp)
 484:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 486:	00054603          	lbu	a2,0(a0)
 48a:	fd06079b          	addiw	a5,a2,-48
 48e:	0ff7f793          	andi	a5,a5,255
 492:	4725                	li	a4,9
 494:	02f76963          	bltu	a4,a5,4c6 <atoi+0x46>
 498:	86aa                	mv	a3,a0
  n = 0;
 49a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 49c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 49e:	0685                	addi	a3,a3,1
 4a0:	0025179b          	slliw	a5,a0,0x2
 4a4:	9fa9                	addw	a5,a5,a0
 4a6:	0017979b          	slliw	a5,a5,0x1
 4aa:	9fb1                	addw	a5,a5,a2
 4ac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4b0:	0006c603          	lbu	a2,0(a3)
 4b4:	fd06071b          	addiw	a4,a2,-48
 4b8:	0ff77713          	andi	a4,a4,255
 4bc:	fee5f1e3          	bgeu	a1,a4,49e <atoi+0x1e>
  return n;
}
 4c0:	6422                	ld	s0,8(sp)
 4c2:	0141                	addi	sp,sp,16
 4c4:	8082                	ret
  n = 0;
 4c6:	4501                	li	a0,0
 4c8:	bfe5                	j	4c0 <atoi+0x40>

00000000000004ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e422                	sd	s0,8(sp)
 4ce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4d0:	02b57663          	bgeu	a0,a1,4fc <memmove+0x32>
    while(n-- > 0)
 4d4:	02c05163          	blez	a2,4f6 <memmove+0x2c>
 4d8:	fff6079b          	addiw	a5,a2,-1
 4dc:	1782                	slli	a5,a5,0x20
 4de:	9381                	srli	a5,a5,0x20
 4e0:	0785                	addi	a5,a5,1
 4e2:	97aa                	add	a5,a5,a0
  dst = vdst;
 4e4:	872a                	mv	a4,a0
      *dst++ = *src++;
 4e6:	0585                	addi	a1,a1,1
 4e8:	0705                	addi	a4,a4,1
 4ea:	fff5c683          	lbu	a3,-1(a1)
 4ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4f2:	fee79ae3          	bne	a5,a4,4e6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4f6:	6422                	ld	s0,8(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret
    dst += n;
 4fc:	00c50733          	add	a4,a0,a2
    src += n;
 500:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 502:	fec05ae3          	blez	a2,4f6 <memmove+0x2c>
 506:	fff6079b          	addiw	a5,a2,-1
 50a:	1782                	slli	a5,a5,0x20
 50c:	9381                	srli	a5,a5,0x20
 50e:	fff7c793          	not	a5,a5
 512:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 514:	15fd                	addi	a1,a1,-1
 516:	177d                	addi	a4,a4,-1
 518:	0005c683          	lbu	a3,0(a1)
 51c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 520:	fee79ae3          	bne	a5,a4,514 <memmove+0x4a>
 524:	bfc9                	j	4f6 <memmove+0x2c>

0000000000000526 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 526:	1141                	addi	sp,sp,-16
 528:	e422                	sd	s0,8(sp)
 52a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 52c:	ca05                	beqz	a2,55c <memcmp+0x36>
 52e:	fff6069b          	addiw	a3,a2,-1
 532:	1682                	slli	a3,a3,0x20
 534:	9281                	srli	a3,a3,0x20
 536:	0685                	addi	a3,a3,1
 538:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 53a:	00054783          	lbu	a5,0(a0)
 53e:	0005c703          	lbu	a4,0(a1)
 542:	00e79863          	bne	a5,a4,552 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 546:	0505                	addi	a0,a0,1
    p2++;
 548:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 54a:	fed518e3          	bne	a0,a3,53a <memcmp+0x14>
  }
  return 0;
 54e:	4501                	li	a0,0
 550:	a019                	j	556 <memcmp+0x30>
      return *p1 - *p2;
 552:	40e7853b          	subw	a0,a5,a4
}
 556:	6422                	ld	s0,8(sp)
 558:	0141                	addi	sp,sp,16
 55a:	8082                	ret
  return 0;
 55c:	4501                	li	a0,0
 55e:	bfe5                	j	556 <memcmp+0x30>

0000000000000560 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 560:	1141                	addi	sp,sp,-16
 562:	e406                	sd	ra,8(sp)
 564:	e022                	sd	s0,0(sp)
 566:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 568:	00000097          	auipc	ra,0x0
 56c:	f62080e7          	jalr	-158(ra) # 4ca <memmove>
}
 570:	60a2                	ld	ra,8(sp)
 572:	6402                	ld	s0,0(sp)
 574:	0141                	addi	sp,sp,16
 576:	8082                	ret

0000000000000578 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 578:	4885                	li	a7,1
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <exit>:
.global exit
exit:
 li a7, SYS_exit
 580:	4889                	li	a7,2
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <wait>:
.global wait
wait:
 li a7, SYS_wait
 588:	488d                	li	a7,3
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 590:	4891                	li	a7,4
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <read>:
.global read
read:
 li a7, SYS_read
 598:	4895                	li	a7,5
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <write>:
.global write
write:
 li a7, SYS_write
 5a0:	48c1                	li	a7,16
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <close>:
.global close
close:
 li a7, SYS_close
 5a8:	48d5                	li	a7,21
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5b0:	4899                	li	a7,6
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b8:	489d                	li	a7,7
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <open>:
.global open
open:
 li a7, SYS_open
 5c0:	48bd                	li	a7,15
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c8:	48c5                	li	a7,17
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5d0:	48c9                	li	a7,18
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d8:	48a1                	li	a7,8
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <link>:
.global link
link:
 li a7, SYS_link
 5e0:	48cd                	li	a7,19
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e8:	48d1                	li	a7,20
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5f0:	48a5                	li	a7,9
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f8:	48a9                	li	a7,10
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 600:	48ad                	li	a7,11
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 608:	48b1                	li	a7,12
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 610:	48b5                	li	a7,13
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 618:	48b9                	li	a7,14
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 620:	48d9                	li	a7,22
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 628:	48dd                	li	a7,23
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 630:	48e1                	li	a7,24
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 638:	48e5                	li	a7,25
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 640:	48e9                	li	a7,26
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 648:	1101                	addi	sp,sp,-32
 64a:	ec06                	sd	ra,24(sp)
 64c:	e822                	sd	s0,16(sp)
 64e:	1000                	addi	s0,sp,32
 650:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 654:	4605                	li	a2,1
 656:	fef40593          	addi	a1,s0,-17
 65a:	00000097          	auipc	ra,0x0
 65e:	f46080e7          	jalr	-186(ra) # 5a0 <write>
}
 662:	60e2                	ld	ra,24(sp)
 664:	6442                	ld	s0,16(sp)
 666:	6105                	addi	sp,sp,32
 668:	8082                	ret

000000000000066a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 66a:	7139                	addi	sp,sp,-64
 66c:	fc06                	sd	ra,56(sp)
 66e:	f822                	sd	s0,48(sp)
 670:	f426                	sd	s1,40(sp)
 672:	f04a                	sd	s2,32(sp)
 674:	ec4e                	sd	s3,24(sp)
 676:	0080                	addi	s0,sp,64
 678:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 67a:	c299                	beqz	a3,680 <printint+0x16>
 67c:	0805c863          	bltz	a1,70c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 680:	2581                	sext.w	a1,a1
  neg = 0;
 682:	4881                	li	a7,0
 684:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 688:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 68a:	2601                	sext.w	a2,a2
 68c:	00000517          	auipc	a0,0x0
 690:	4c450513          	addi	a0,a0,1220 # b50 <digits>
 694:	883a                	mv	a6,a4
 696:	2705                	addiw	a4,a4,1
 698:	02c5f7bb          	remuw	a5,a1,a2
 69c:	1782                	slli	a5,a5,0x20
 69e:	9381                	srli	a5,a5,0x20
 6a0:	97aa                	add	a5,a5,a0
 6a2:	0007c783          	lbu	a5,0(a5)
 6a6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6aa:	0005879b          	sext.w	a5,a1
 6ae:	02c5d5bb          	divuw	a1,a1,a2
 6b2:	0685                	addi	a3,a3,1
 6b4:	fec7f0e3          	bgeu	a5,a2,694 <printint+0x2a>
  if(neg)
 6b8:	00088b63          	beqz	a7,6ce <printint+0x64>
    buf[i++] = '-';
 6bc:	fd040793          	addi	a5,s0,-48
 6c0:	973e                	add	a4,a4,a5
 6c2:	02d00793          	li	a5,45
 6c6:	fef70823          	sb	a5,-16(a4)
 6ca:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6ce:	02e05863          	blez	a4,6fe <printint+0x94>
 6d2:	fc040793          	addi	a5,s0,-64
 6d6:	00e78933          	add	s2,a5,a4
 6da:	fff78993          	addi	s3,a5,-1
 6de:	99ba                	add	s3,s3,a4
 6e0:	377d                	addiw	a4,a4,-1
 6e2:	1702                	slli	a4,a4,0x20
 6e4:	9301                	srli	a4,a4,0x20
 6e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ea:	fff94583          	lbu	a1,-1(s2)
 6ee:	8526                	mv	a0,s1
 6f0:	00000097          	auipc	ra,0x0
 6f4:	f58080e7          	jalr	-168(ra) # 648 <putc>
  while(--i >= 0)
 6f8:	197d                	addi	s2,s2,-1
 6fa:	ff3918e3          	bne	s2,s3,6ea <printint+0x80>
}
 6fe:	70e2                	ld	ra,56(sp)
 700:	7442                	ld	s0,48(sp)
 702:	74a2                	ld	s1,40(sp)
 704:	7902                	ld	s2,32(sp)
 706:	69e2                	ld	s3,24(sp)
 708:	6121                	addi	sp,sp,64
 70a:	8082                	ret
    x = -xx;
 70c:	40b005bb          	negw	a1,a1
    neg = 1;
 710:	4885                	li	a7,1
    x = -xx;
 712:	bf8d                	j	684 <printint+0x1a>

0000000000000714 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 714:	7119                	addi	sp,sp,-128
 716:	fc86                	sd	ra,120(sp)
 718:	f8a2                	sd	s0,112(sp)
 71a:	f4a6                	sd	s1,104(sp)
 71c:	f0ca                	sd	s2,96(sp)
 71e:	ecce                	sd	s3,88(sp)
 720:	e8d2                	sd	s4,80(sp)
 722:	e4d6                	sd	s5,72(sp)
 724:	e0da                	sd	s6,64(sp)
 726:	fc5e                	sd	s7,56(sp)
 728:	f862                	sd	s8,48(sp)
 72a:	f466                	sd	s9,40(sp)
 72c:	f06a                	sd	s10,32(sp)
 72e:	ec6e                	sd	s11,24(sp)
 730:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 732:	0005c903          	lbu	s2,0(a1)
 736:	18090f63          	beqz	s2,8d4 <vprintf+0x1c0>
 73a:	8aaa                	mv	s5,a0
 73c:	8b32                	mv	s6,a2
 73e:	00158493          	addi	s1,a1,1
  state = 0;
 742:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 744:	02500a13          	li	s4,37
      if(c == 'd'){
 748:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 74c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 750:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 754:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 758:	00000b97          	auipc	s7,0x0
 75c:	3f8b8b93          	addi	s7,s7,1016 # b50 <digits>
 760:	a839                	j	77e <vprintf+0x6a>
        putc(fd, c);
 762:	85ca                	mv	a1,s2
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	ee2080e7          	jalr	-286(ra) # 648 <putc>
 76e:	a019                	j	774 <vprintf+0x60>
    } else if(state == '%'){
 770:	01498f63          	beq	s3,s4,78e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 774:	0485                	addi	s1,s1,1
 776:	fff4c903          	lbu	s2,-1(s1)
 77a:	14090d63          	beqz	s2,8d4 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 77e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 782:	fe0997e3          	bnez	s3,770 <vprintf+0x5c>
      if(c == '%'){
 786:	fd479ee3          	bne	a5,s4,762 <vprintf+0x4e>
        state = '%';
 78a:	89be                	mv	s3,a5
 78c:	b7e5                	j	774 <vprintf+0x60>
      if(c == 'd'){
 78e:	05878063          	beq	a5,s8,7ce <vprintf+0xba>
      } else if(c == 'l') {
 792:	05978c63          	beq	a5,s9,7ea <vprintf+0xd6>
      } else if(c == 'x') {
 796:	07a78863          	beq	a5,s10,806 <vprintf+0xf2>
      } else if(c == 'p') {
 79a:	09b78463          	beq	a5,s11,822 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 79e:	07300713          	li	a4,115
 7a2:	0ce78663          	beq	a5,a4,86e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7a6:	06300713          	li	a4,99
 7aa:	0ee78e63          	beq	a5,a4,8a6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7ae:	11478863          	beq	a5,s4,8be <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7b2:	85d2                	mv	a1,s4
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e92080e7          	jalr	-366(ra) # 648 <putc>
        putc(fd, c);
 7be:	85ca                	mv	a1,s2
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e86080e7          	jalr	-378(ra) # 648 <putc>
      }
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	b765                	j	774 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7ce:	008b0913          	addi	s2,s6,8
 7d2:	4685                	li	a3,1
 7d4:	4629                	li	a2,10
 7d6:	000b2583          	lw	a1,0(s6)
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	e8e080e7          	jalr	-370(ra) # 66a <printint>
 7e4:	8b4a                	mv	s6,s2
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	b771                	j	774 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ea:	008b0913          	addi	s2,s6,8
 7ee:	4681                	li	a3,0
 7f0:	4629                	li	a2,10
 7f2:	000b2583          	lw	a1,0(s6)
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	e72080e7          	jalr	-398(ra) # 66a <printint>
 800:	8b4a                	mv	s6,s2
      state = 0;
 802:	4981                	li	s3,0
 804:	bf85                	j	774 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 806:	008b0913          	addi	s2,s6,8
 80a:	4681                	li	a3,0
 80c:	4641                	li	a2,16
 80e:	000b2583          	lw	a1,0(s6)
 812:	8556                	mv	a0,s5
 814:	00000097          	auipc	ra,0x0
 818:	e56080e7          	jalr	-426(ra) # 66a <printint>
 81c:	8b4a                	mv	s6,s2
      state = 0;
 81e:	4981                	li	s3,0
 820:	bf91                	j	774 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 822:	008b0793          	addi	a5,s6,8
 826:	f8f43423          	sd	a5,-120(s0)
 82a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 82e:	03000593          	li	a1,48
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	e14080e7          	jalr	-492(ra) # 648 <putc>
  putc(fd, 'x');
 83c:	85ea                	mv	a1,s10
 83e:	8556                	mv	a0,s5
 840:	00000097          	auipc	ra,0x0
 844:	e08080e7          	jalr	-504(ra) # 648 <putc>
 848:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 84a:	03c9d793          	srli	a5,s3,0x3c
 84e:	97de                	add	a5,a5,s7
 850:	0007c583          	lbu	a1,0(a5)
 854:	8556                	mv	a0,s5
 856:	00000097          	auipc	ra,0x0
 85a:	df2080e7          	jalr	-526(ra) # 648 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 85e:	0992                	slli	s3,s3,0x4
 860:	397d                	addiw	s2,s2,-1
 862:	fe0914e3          	bnez	s2,84a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 866:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 86a:	4981                	li	s3,0
 86c:	b721                	j	774 <vprintf+0x60>
        s = va_arg(ap, char*);
 86e:	008b0993          	addi	s3,s6,8
 872:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 876:	02090163          	beqz	s2,898 <vprintf+0x184>
        while(*s != 0){
 87a:	00094583          	lbu	a1,0(s2)
 87e:	c9a1                	beqz	a1,8ce <vprintf+0x1ba>
          putc(fd, *s);
 880:	8556                	mv	a0,s5
 882:	00000097          	auipc	ra,0x0
 886:	dc6080e7          	jalr	-570(ra) # 648 <putc>
          s++;
 88a:	0905                	addi	s2,s2,1
        while(*s != 0){
 88c:	00094583          	lbu	a1,0(s2)
 890:	f9e5                	bnez	a1,880 <vprintf+0x16c>
        s = va_arg(ap, char*);
 892:	8b4e                	mv	s6,s3
      state = 0;
 894:	4981                	li	s3,0
 896:	bdf9                	j	774 <vprintf+0x60>
          s = "(null)";
 898:	00000917          	auipc	s2,0x0
 89c:	2b090913          	addi	s2,s2,688 # b48 <malloc+0x16a>
        while(*s != 0){
 8a0:	02800593          	li	a1,40
 8a4:	bff1                	j	880 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8a6:	008b0913          	addi	s2,s6,8
 8aa:	000b4583          	lbu	a1,0(s6)
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	d98080e7          	jalr	-616(ra) # 648 <putc>
 8b8:	8b4a                	mv	s6,s2
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	bd65                	j	774 <vprintf+0x60>
        putc(fd, c);
 8be:	85d2                	mv	a1,s4
 8c0:	8556                	mv	a0,s5
 8c2:	00000097          	auipc	ra,0x0
 8c6:	d86080e7          	jalr	-634(ra) # 648 <putc>
      state = 0;
 8ca:	4981                	li	s3,0
 8cc:	b565                	j	774 <vprintf+0x60>
        s = va_arg(ap, char*);
 8ce:	8b4e                	mv	s6,s3
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	b54d                	j	774 <vprintf+0x60>
    }
  }
}
 8d4:	70e6                	ld	ra,120(sp)
 8d6:	7446                	ld	s0,112(sp)
 8d8:	74a6                	ld	s1,104(sp)
 8da:	7906                	ld	s2,96(sp)
 8dc:	69e6                	ld	s3,88(sp)
 8de:	6a46                	ld	s4,80(sp)
 8e0:	6aa6                	ld	s5,72(sp)
 8e2:	6b06                	ld	s6,64(sp)
 8e4:	7be2                	ld	s7,56(sp)
 8e6:	7c42                	ld	s8,48(sp)
 8e8:	7ca2                	ld	s9,40(sp)
 8ea:	7d02                	ld	s10,32(sp)
 8ec:	6de2                	ld	s11,24(sp)
 8ee:	6109                	addi	sp,sp,128
 8f0:	8082                	ret

00000000000008f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f2:	715d                	addi	sp,sp,-80
 8f4:	ec06                	sd	ra,24(sp)
 8f6:	e822                	sd	s0,16(sp)
 8f8:	1000                	addi	s0,sp,32
 8fa:	e010                	sd	a2,0(s0)
 8fc:	e414                	sd	a3,8(s0)
 8fe:	e818                	sd	a4,16(s0)
 900:	ec1c                	sd	a5,24(s0)
 902:	03043023          	sd	a6,32(s0)
 906:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 90e:	8622                	mv	a2,s0
 910:	00000097          	auipc	ra,0x0
 914:	e04080e7          	jalr	-508(ra) # 714 <vprintf>
}
 918:	60e2                	ld	ra,24(sp)
 91a:	6442                	ld	s0,16(sp)
 91c:	6161                	addi	sp,sp,80
 91e:	8082                	ret

0000000000000920 <printf>:

void
printf(const char *fmt, ...)
{
 920:	711d                	addi	sp,sp,-96
 922:	ec06                	sd	ra,24(sp)
 924:	e822                	sd	s0,16(sp)
 926:	1000                	addi	s0,sp,32
 928:	e40c                	sd	a1,8(s0)
 92a:	e810                	sd	a2,16(s0)
 92c:	ec14                	sd	a3,24(s0)
 92e:	f018                	sd	a4,32(s0)
 930:	f41c                	sd	a5,40(s0)
 932:	03043823          	sd	a6,48(s0)
 936:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93a:	00840613          	addi	a2,s0,8
 93e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 942:	85aa                	mv	a1,a0
 944:	4505                	li	a0,1
 946:	00000097          	auipc	ra,0x0
 94a:	dce080e7          	jalr	-562(ra) # 714 <vprintf>
}
 94e:	60e2                	ld	ra,24(sp)
 950:	6442                	ld	s0,16(sp)
 952:	6125                	addi	sp,sp,96
 954:	8082                	ret

0000000000000956 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 956:	1141                	addi	sp,sp,-16
 958:	e422                	sd	s0,8(sp)
 95a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 95c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 960:	00000797          	auipc	a5,0x0
 964:	6a07b783          	ld	a5,1696(a5) # 1000 <freep>
 968:	a805                	j	998 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 96a:	4618                	lw	a4,8(a2)
 96c:	9db9                	addw	a1,a1,a4
 96e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 972:	6398                	ld	a4,0(a5)
 974:	6318                	ld	a4,0(a4)
 976:	fee53823          	sd	a4,-16(a0)
 97a:	a091                	j	9be <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 97c:	ff852703          	lw	a4,-8(a0)
 980:	9e39                	addw	a2,a2,a4
 982:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 984:	ff053703          	ld	a4,-16(a0)
 988:	e398                	sd	a4,0(a5)
 98a:	a099                	j	9d0 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 98c:	6398                	ld	a4,0(a5)
 98e:	00e7e463          	bltu	a5,a4,996 <free+0x40>
 992:	00e6ea63          	bltu	a3,a4,9a6 <free+0x50>
{
 996:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 998:	fed7fae3          	bgeu	a5,a3,98c <free+0x36>
 99c:	6398                	ld	a4,0(a5)
 99e:	00e6e463          	bltu	a3,a4,9a6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a2:	fee7eae3          	bltu	a5,a4,996 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9a6:	ff852583          	lw	a1,-8(a0)
 9aa:	6390                	ld	a2,0(a5)
 9ac:	02059713          	slli	a4,a1,0x20
 9b0:	9301                	srli	a4,a4,0x20
 9b2:	0712                	slli	a4,a4,0x4
 9b4:	9736                	add	a4,a4,a3
 9b6:	fae60ae3          	beq	a2,a4,96a <free+0x14>
    bp->s.ptr = p->s.ptr;
 9ba:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9be:	4790                	lw	a2,8(a5)
 9c0:	02061713          	slli	a4,a2,0x20
 9c4:	9301                	srli	a4,a4,0x20
 9c6:	0712                	slli	a4,a4,0x4
 9c8:	973e                	add	a4,a4,a5
 9ca:	fae689e3          	beq	a3,a4,97c <free+0x26>
  } else
    p->s.ptr = bp;
 9ce:	e394                	sd	a3,0(a5)
  freep = p;
 9d0:	00000717          	auipc	a4,0x0
 9d4:	62f73823          	sd	a5,1584(a4) # 1000 <freep>
}
 9d8:	6422                	ld	s0,8(sp)
 9da:	0141                	addi	sp,sp,16
 9dc:	8082                	ret

00000000000009de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9de:	7139                	addi	sp,sp,-64
 9e0:	fc06                	sd	ra,56(sp)
 9e2:	f822                	sd	s0,48(sp)
 9e4:	f426                	sd	s1,40(sp)
 9e6:	f04a                	sd	s2,32(sp)
 9e8:	ec4e                	sd	s3,24(sp)
 9ea:	e852                	sd	s4,16(sp)
 9ec:	e456                	sd	s5,8(sp)
 9ee:	e05a                	sd	s6,0(sp)
 9f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f2:	02051493          	slli	s1,a0,0x20
 9f6:	9081                	srli	s1,s1,0x20
 9f8:	04bd                	addi	s1,s1,15
 9fa:	8091                	srli	s1,s1,0x4
 9fc:	0014899b          	addiw	s3,s1,1
 a00:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a02:	00000517          	auipc	a0,0x0
 a06:	5fe53503          	ld	a0,1534(a0) # 1000 <freep>
 a0a:	c515                	beqz	a0,a36 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a0e:	4798                	lw	a4,8(a5)
 a10:	02977f63          	bgeu	a4,s1,a4e <malloc+0x70>
 a14:	8a4e                	mv	s4,s3
 a16:	0009871b          	sext.w	a4,s3
 a1a:	6685                	lui	a3,0x1
 a1c:	00d77363          	bgeu	a4,a3,a22 <malloc+0x44>
 a20:	6a05                	lui	s4,0x1
 a22:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a26:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a2a:	00000917          	auipc	s2,0x0
 a2e:	5d690913          	addi	s2,s2,1494 # 1000 <freep>
  if(p == (char*)-1)
 a32:	5afd                	li	s5,-1
 a34:	a88d                	j	aa6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a36:	00000797          	auipc	a5,0x0
 a3a:	5ea78793          	addi	a5,a5,1514 # 1020 <base>
 a3e:	00000717          	auipc	a4,0x0
 a42:	5cf73123          	sd	a5,1474(a4) # 1000 <freep>
 a46:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a48:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a4c:	b7e1                	j	a14 <malloc+0x36>
      if(p->s.size == nunits)
 a4e:	02e48b63          	beq	s1,a4,a84 <malloc+0xa6>
        p->s.size -= nunits;
 a52:	4137073b          	subw	a4,a4,s3
 a56:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a58:	1702                	slli	a4,a4,0x20
 a5a:	9301                	srli	a4,a4,0x20
 a5c:	0712                	slli	a4,a4,0x4
 a5e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a60:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a64:	00000717          	auipc	a4,0x0
 a68:	58a73e23          	sd	a0,1436(a4) # 1000 <freep>
      return (void*)(p + 1);
 a6c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a70:	70e2                	ld	ra,56(sp)
 a72:	7442                	ld	s0,48(sp)
 a74:	74a2                	ld	s1,40(sp)
 a76:	7902                	ld	s2,32(sp)
 a78:	69e2                	ld	s3,24(sp)
 a7a:	6a42                	ld	s4,16(sp)
 a7c:	6aa2                	ld	s5,8(sp)
 a7e:	6b02                	ld	s6,0(sp)
 a80:	6121                	addi	sp,sp,64
 a82:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a84:	6398                	ld	a4,0(a5)
 a86:	e118                	sd	a4,0(a0)
 a88:	bff1                	j	a64 <malloc+0x86>
  hp->s.size = nu;
 a8a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a8e:	0541                	addi	a0,a0,16
 a90:	00000097          	auipc	ra,0x0
 a94:	ec6080e7          	jalr	-314(ra) # 956 <free>
  return freep;
 a98:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a9c:	d971                	beqz	a0,a70 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa0:	4798                	lw	a4,8(a5)
 aa2:	fa9776e3          	bgeu	a4,s1,a4e <malloc+0x70>
    if(p == freep)
 aa6:	00093703          	ld	a4,0(s2)
 aaa:	853e                	mv	a0,a5
 aac:	fef719e3          	bne	a4,a5,a9e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 ab0:	8552                	mv	a0,s4
 ab2:	00000097          	auipc	ra,0x0
 ab6:	b56080e7          	jalr	-1194(ra) # 608 <sbrk>
  if(p == (char*)-1)
 aba:	fd5518e3          	bne	a0,s5,a8a <malloc+0xac>
        return 0;
 abe:	4501                	li	a0,0
 ac0:	bf45                	j	a70 <malloc+0x92>
