
user/_policy:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    if (argc < 2) {
   a:	4785                	li	a5,1
   c:	02a7de63          	bge	a5,a0,48 <main+0x48>
        printf("Usage: policy <policy_code>\n");
        return 1;
    }

    int policy_code = atoi(argv[1]);
  10:	6588                	ld	a0,8(a1)
  12:	00000097          	auipc	ra,0x0
  16:	1f8080e7          	jalr	504(ra) # 20a <atoi>
  1a:	84aa                	mv	s1,a0

    int result = set_policy(policy_code);
  1c:	00000097          	auipc	ra,0x0
  20:	3ae080e7          	jalr	942(ra) # 3ca <set_policy>

    if (result == -1) {
  24:	57fd                	li	a5,-1
  26:	02f50b63          	beq	a0,a5,5c <main+0x5c>
        printf("Error setting policy: %d\n", policy_code);
        return 1;
    }

    printf("Policy set to: %d\n", policy_code);
  2a:	85a6                	mv	a1,s1
  2c:	00001517          	auipc	a0,0x1
  30:	86450513          	addi	a0,a0,-1948 # 890 <malloc+0x128>
  34:	00000097          	auipc	ra,0x0
  38:	676080e7          	jalr	1654(ra) # 6aa <printf>

    return 0;
  3c:	4501                	li	a0,0
}
  3e:	60e2                	ld	ra,24(sp)
  40:	6442                	ld	s0,16(sp)
  42:	64a2                	ld	s1,8(sp)
  44:	6105                	addi	sp,sp,32
  46:	8082                	ret
        printf("Usage: policy <policy_code>\n");
  48:	00001517          	auipc	a0,0x1
  4c:	80850513          	addi	a0,a0,-2040 # 850 <malloc+0xe8>
  50:	00000097          	auipc	ra,0x0
  54:	65a080e7          	jalr	1626(ra) # 6aa <printf>
        return 1;
  58:	4505                	li	a0,1
  5a:	b7d5                	j	3e <main+0x3e>
        printf("Error setting policy: %d\n", policy_code);
  5c:	85a6                	mv	a1,s1
  5e:	00001517          	auipc	a0,0x1
  62:	81250513          	addi	a0,a0,-2030 # 870 <malloc+0x108>
  66:	00000097          	auipc	ra,0x0
  6a:	644080e7          	jalr	1604(ra) # 6aa <printf>
        return 1;
  6e:	4505                	li	a0,1
  70:	b7f9                	j	3e <main+0x3e>

0000000000000072 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
  extern int main();
  main();
  7a:	00000097          	auipc	ra,0x0
  7e:	f86080e7          	jalr	-122(ra) # 0 <main>
  exit(0,"");
  82:	00001597          	auipc	a1,0x1
  86:	82658593          	addi	a1,a1,-2010 # 8a8 <malloc+0x140>
  8a:	4501                	li	a0,0
  8c:	00000097          	auipc	ra,0x0
  90:	27e080e7          	jalr	638(ra) # 30a <exit>

0000000000000094 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	87aa                	mv	a5,a0
  9c:	0585                	addi	a1,a1,1
  9e:	0785                	addi	a5,a5,1
  a0:	fff5c703          	lbu	a4,-1(a1)
  a4:	fee78fa3          	sb	a4,-1(a5)
  a8:	fb75                	bnez	a4,9c <strcpy+0x8>
    ;
  return os;
}
  aa:	6422                	ld	s0,8(sp)
  ac:	0141                	addi	sp,sp,16
  ae:	8082                	ret

00000000000000b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b0:	1141                	addi	sp,sp,-16
  b2:	e422                	sd	s0,8(sp)
  b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb91                	beqz	a5,ce <strcmp+0x1e>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71763          	bne	a4,a5,ce <strcmp+0x1e>
    p++, q++;
  c4:	0505                	addi	a0,a0,1
  c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbe5                	bnez	a5,bc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  ce:	0005c503          	lbu	a0,0(a1)
}
  d2:	40a7853b          	subw	a0,a5,a0
  d6:	6422                	ld	s0,8(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e422                	sd	s0,8(sp)
  e0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e2:	00054783          	lbu	a5,0(a0)
  e6:	cf91                	beqz	a5,102 <strlen+0x26>
  e8:	0505                	addi	a0,a0,1
  ea:	87aa                	mv	a5,a0
  ec:	4685                	li	a3,1
  ee:	9e89                	subw	a3,a3,a0
  f0:	00f6853b          	addw	a0,a3,a5
  f4:	0785                	addi	a5,a5,1
  f6:	fff7c703          	lbu	a4,-1(a5)
  fa:	fb7d                	bnez	a4,f0 <strlen+0x14>
    ;
  return n;
}
  fc:	6422                	ld	s0,8(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret
  for(n = 0; s[n]; n++)
 102:	4501                	li	a0,0
 104:	bfe5                	j	fc <strlen+0x20>

0000000000000106 <memset>:

void*
memset(void *dst, int c, uint n)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 10c:	ce09                	beqz	a2,126 <memset+0x20>
 10e:	87aa                	mv	a5,a0
 110:	fff6071b          	addiw	a4,a2,-1
 114:	1702                	slli	a4,a4,0x20
 116:	9301                	srli	a4,a4,0x20
 118:	0705                	addi	a4,a4,1
 11a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 11c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 120:	0785                	addi	a5,a5,1
 122:	fee79de3          	bne	a5,a4,11c <memset+0x16>
  }
  return dst;
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strchr>:

char*
strchr(const char *s, char c)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e422                	sd	s0,8(sp)
 130:	0800                	addi	s0,sp,16
  for(; *s; s++)
 132:	00054783          	lbu	a5,0(a0)
 136:	cb99                	beqz	a5,14c <strchr+0x20>
    if(*s == c)
 138:	00f58763          	beq	a1,a5,146 <strchr+0x1a>
  for(; *s; s++)
 13c:	0505                	addi	a0,a0,1
 13e:	00054783          	lbu	a5,0(a0)
 142:	fbfd                	bnez	a5,138 <strchr+0xc>
      return (char*)s;
  return 0;
 144:	4501                	li	a0,0
}
 146:	6422                	ld	s0,8(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret
  return 0;
 14c:	4501                	li	a0,0
 14e:	bfe5                	j	146 <strchr+0x1a>

0000000000000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	711d                	addi	sp,sp,-96
 152:	ec86                	sd	ra,88(sp)
 154:	e8a2                	sd	s0,80(sp)
 156:	e4a6                	sd	s1,72(sp)
 158:	e0ca                	sd	s2,64(sp)
 15a:	fc4e                	sd	s3,56(sp)
 15c:	f852                	sd	s4,48(sp)
 15e:	f456                	sd	s5,40(sp)
 160:	f05a                	sd	s6,32(sp)
 162:	ec5e                	sd	s7,24(sp)
 164:	1080                	addi	s0,sp,96
 166:	8baa                	mv	s7,a0
 168:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16a:	892a                	mv	s2,a0
 16c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 16e:	4aa9                	li	s5,10
 170:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 172:	89a6                	mv	s3,s1
 174:	2485                	addiw	s1,s1,1
 176:	0344d863          	bge	s1,s4,1a6 <gets+0x56>
    cc = read(0, &c, 1);
 17a:	4605                	li	a2,1
 17c:	faf40593          	addi	a1,s0,-81
 180:	4501                	li	a0,0
 182:	00000097          	auipc	ra,0x0
 186:	1a0080e7          	jalr	416(ra) # 322 <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x56>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x54>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679be3          	bne	a5,s6,172 <gets+0x22>
  for(i=0; i+1 < max; ){
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x56>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e426                	sd	s1,8(sp)
 1cc:	e04a                	sd	s2,0(sp)
 1ce:	1000                	addi	s0,sp,32
 1d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d2:	4581                	li	a1,0
 1d4:	00000097          	auipc	ra,0x0
 1d8:	176080e7          	jalr	374(ra) # 34a <open>
  if(fd < 0)
 1dc:	02054563          	bltz	a0,206 <stat+0x42>
 1e0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e2:	85ca                	mv	a1,s2
 1e4:	00000097          	auipc	ra,0x0
 1e8:	17e080e7          	jalr	382(ra) # 362 <fstat>
 1ec:	892a                	mv	s2,a0
  close(fd);
 1ee:	8526                	mv	a0,s1
 1f0:	00000097          	auipc	ra,0x0
 1f4:	142080e7          	jalr	322(ra) # 332 <close>
  return r;
}
 1f8:	854a                	mv	a0,s2
 1fa:	60e2                	ld	ra,24(sp)
 1fc:	6442                	ld	s0,16(sp)
 1fe:	64a2                	ld	s1,8(sp)
 200:	6902                	ld	s2,0(sp)
 202:	6105                	addi	sp,sp,32
 204:	8082                	ret
    return -1;
 206:	597d                	li	s2,-1
 208:	bfc5                	j	1f8 <stat+0x34>

000000000000020a <atoi>:

int
atoi(const char *s)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 210:	00054603          	lbu	a2,0(a0)
 214:	fd06079b          	addiw	a5,a2,-48
 218:	0ff7f793          	andi	a5,a5,255
 21c:	4725                	li	a4,9
 21e:	02f76963          	bltu	a4,a5,250 <atoi+0x46>
 222:	86aa                	mv	a3,a0
  n = 0;
 224:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 226:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 228:	0685                	addi	a3,a3,1
 22a:	0025179b          	slliw	a5,a0,0x2
 22e:	9fa9                	addw	a5,a5,a0
 230:	0017979b          	slliw	a5,a5,0x1
 234:	9fb1                	addw	a5,a5,a2
 236:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 23a:	0006c603          	lbu	a2,0(a3)
 23e:	fd06071b          	addiw	a4,a2,-48
 242:	0ff77713          	andi	a4,a4,255
 246:	fee5f1e3          	bgeu	a1,a4,228 <atoi+0x1e>
  return n;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
  n = 0;
 250:	4501                	li	a0,0
 252:	bfe5                	j	24a <atoi+0x40>

0000000000000254 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25a:	02b57663          	bgeu	a0,a1,286 <memmove+0x32>
    while(n-- > 0)
 25e:	02c05163          	blez	a2,280 <memmove+0x2c>
 262:	fff6079b          	addiw	a5,a2,-1
 266:	1782                	slli	a5,a5,0x20
 268:	9381                	srli	a5,a5,0x20
 26a:	0785                	addi	a5,a5,1
 26c:	97aa                	add	a5,a5,a0
  dst = vdst;
 26e:	872a                	mv	a4,a0
      *dst++ = *src++;
 270:	0585                	addi	a1,a1,1
 272:	0705                	addi	a4,a4,1
 274:	fff5c683          	lbu	a3,-1(a1)
 278:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27c:	fee79ae3          	bne	a5,a4,270 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 280:	6422                	ld	s0,8(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
    dst += n;
 286:	00c50733          	add	a4,a0,a2
    src += n;
 28a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 28c:	fec05ae3          	blez	a2,280 <memmove+0x2c>
 290:	fff6079b          	addiw	a5,a2,-1
 294:	1782                	slli	a5,a5,0x20
 296:	9381                	srli	a5,a5,0x20
 298:	fff7c793          	not	a5,a5
 29c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29e:	15fd                	addi	a1,a1,-1
 2a0:	177d                	addi	a4,a4,-1
 2a2:	0005c683          	lbu	a3,0(a1)
 2a6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2aa:	fee79ae3          	bne	a5,a4,29e <memmove+0x4a>
 2ae:	bfc9                	j	280 <memmove+0x2c>

00000000000002b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e422                	sd	s0,8(sp)
 2b4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b6:	ca05                	beqz	a2,2e6 <memcmp+0x36>
 2b8:	fff6069b          	addiw	a3,a2,-1
 2bc:	1682                	slli	a3,a3,0x20
 2be:	9281                	srli	a3,a3,0x20
 2c0:	0685                	addi	a3,a3,1
 2c2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00e79863          	bne	a5,a4,2dc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2d0:	0505                	addi	a0,a0,1
    p2++;
 2d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d4:	fed518e3          	bne	a0,a3,2c4 <memcmp+0x14>
  }
  return 0;
 2d8:	4501                	li	a0,0
 2da:	a019                	j	2e0 <memcmp+0x30>
      return *p1 - *p2;
 2dc:	40e7853b          	subw	a0,a5,a4
}
 2e0:	6422                	ld	s0,8(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	bfe5                	j	2e0 <memcmp+0x30>

00000000000002ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f2:	00000097          	auipc	ra,0x0
 2f6:	f62080e7          	jalr	-158(ra) # 254 <memmove>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 302:	4885                	li	a7,1
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <exit>:
.global exit
exit:
 li a7, SYS_exit
 30a:	4889                	li	a7,2
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <wait>:
.global wait
wait:
 li a7, SYS_wait
 312:	488d                	li	a7,3
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 31a:	4891                	li	a7,4
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <read>:
.global read
read:
 li a7, SYS_read
 322:	4895                	li	a7,5
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <write>:
.global write
write:
 li a7, SYS_write
 32a:	48c1                	li	a7,16
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <close>:
.global close
close:
 li a7, SYS_close
 332:	48d5                	li	a7,21
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <kill>:
.global kill
kill:
 li a7, SYS_kill
 33a:	4899                	li	a7,6
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exec>:
.global exec
exec:
 li a7, SYS_exec
 342:	489d                	li	a7,7
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <open>:
.global open
open:
 li a7, SYS_open
 34a:	48bd                	li	a7,15
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 352:	48c5                	li	a7,17
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 35a:	48c9                	li	a7,18
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 362:	48a1                	li	a7,8
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <link>:
.global link
link:
 li a7, SYS_link
 36a:	48cd                	li	a7,19
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 372:	48d1                	li	a7,20
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 37a:	48a5                	li	a7,9
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <dup>:
.global dup
dup:
 li a7, SYS_dup
 382:	48a9                	li	a7,10
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 38a:	48ad                	li	a7,11
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 392:	48b1                	li	a7,12
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 39a:	48b5                	li	a7,13
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a2:	48b9                	li	a7,14
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
 3aa:	48d9                	li	a7,22
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
 3b2:	48dd                	li	a7,23
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
 3ba:	48e1                	li	a7,24
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
 3c2:	48e5                	li	a7,25
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
 3ca:	48e9                	li	a7,26
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3de:	4605                	li	a2,1
 3e0:	fef40593          	addi	a1,s0,-17
 3e4:	00000097          	auipc	ra,0x0
 3e8:	f46080e7          	jalr	-186(ra) # 32a <write>
}
 3ec:	60e2                	ld	ra,24(sp)
 3ee:	6442                	ld	s0,16(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f4:	7139                	addi	sp,sp,-64
 3f6:	fc06                	sd	ra,56(sp)
 3f8:	f822                	sd	s0,48(sp)
 3fa:	f426                	sd	s1,40(sp)
 3fc:	f04a                	sd	s2,32(sp)
 3fe:	ec4e                	sd	s3,24(sp)
 400:	0080                	addi	s0,sp,64
 402:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 404:	c299                	beqz	a3,40a <printint+0x16>
 406:	0805c863          	bltz	a1,496 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 40a:	2581                	sext.w	a1,a1
  neg = 0;
 40c:	4881                	li	a7,0
 40e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 412:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 414:	2601                	sext.w	a2,a2
 416:	00000517          	auipc	a0,0x0
 41a:	4a250513          	addi	a0,a0,1186 # 8b8 <digits>
 41e:	883a                	mv	a6,a4
 420:	2705                	addiw	a4,a4,1
 422:	02c5f7bb          	remuw	a5,a1,a2
 426:	1782                	slli	a5,a5,0x20
 428:	9381                	srli	a5,a5,0x20
 42a:	97aa                	add	a5,a5,a0
 42c:	0007c783          	lbu	a5,0(a5)
 430:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 434:	0005879b          	sext.w	a5,a1
 438:	02c5d5bb          	divuw	a1,a1,a2
 43c:	0685                	addi	a3,a3,1
 43e:	fec7f0e3          	bgeu	a5,a2,41e <printint+0x2a>
  if(neg)
 442:	00088b63          	beqz	a7,458 <printint+0x64>
    buf[i++] = '-';
 446:	fd040793          	addi	a5,s0,-48
 44a:	973e                	add	a4,a4,a5
 44c:	02d00793          	li	a5,45
 450:	fef70823          	sb	a5,-16(a4)
 454:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 458:	02e05863          	blez	a4,488 <printint+0x94>
 45c:	fc040793          	addi	a5,s0,-64
 460:	00e78933          	add	s2,a5,a4
 464:	fff78993          	addi	s3,a5,-1
 468:	99ba                	add	s3,s3,a4
 46a:	377d                	addiw	a4,a4,-1
 46c:	1702                	slli	a4,a4,0x20
 46e:	9301                	srli	a4,a4,0x20
 470:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 474:	fff94583          	lbu	a1,-1(s2)
 478:	8526                	mv	a0,s1
 47a:	00000097          	auipc	ra,0x0
 47e:	f58080e7          	jalr	-168(ra) # 3d2 <putc>
  while(--i >= 0)
 482:	197d                	addi	s2,s2,-1
 484:	ff3918e3          	bne	s2,s3,474 <printint+0x80>
}
 488:	70e2                	ld	ra,56(sp)
 48a:	7442                	ld	s0,48(sp)
 48c:	74a2                	ld	s1,40(sp)
 48e:	7902                	ld	s2,32(sp)
 490:	69e2                	ld	s3,24(sp)
 492:	6121                	addi	sp,sp,64
 494:	8082                	ret
    x = -xx;
 496:	40b005bb          	negw	a1,a1
    neg = 1;
 49a:	4885                	li	a7,1
    x = -xx;
 49c:	bf8d                	j	40e <printint+0x1a>

000000000000049e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49e:	7119                	addi	sp,sp,-128
 4a0:	fc86                	sd	ra,120(sp)
 4a2:	f8a2                	sd	s0,112(sp)
 4a4:	f4a6                	sd	s1,104(sp)
 4a6:	f0ca                	sd	s2,96(sp)
 4a8:	ecce                	sd	s3,88(sp)
 4aa:	e8d2                	sd	s4,80(sp)
 4ac:	e4d6                	sd	s5,72(sp)
 4ae:	e0da                	sd	s6,64(sp)
 4b0:	fc5e                	sd	s7,56(sp)
 4b2:	f862                	sd	s8,48(sp)
 4b4:	f466                	sd	s9,40(sp)
 4b6:	f06a                	sd	s10,32(sp)
 4b8:	ec6e                	sd	s11,24(sp)
 4ba:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4bc:	0005c903          	lbu	s2,0(a1)
 4c0:	18090f63          	beqz	s2,65e <vprintf+0x1c0>
 4c4:	8aaa                	mv	s5,a0
 4c6:	8b32                	mv	s6,a2
 4c8:	00158493          	addi	s1,a1,1
  state = 0;
 4cc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ce:	02500a13          	li	s4,37
      if(c == 'd'){
 4d2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 4d6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 4da:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 4de:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4e2:	00000b97          	auipc	s7,0x0
 4e6:	3d6b8b93          	addi	s7,s7,982 # 8b8 <digits>
 4ea:	a839                	j	508 <vprintf+0x6a>
        putc(fd, c);
 4ec:	85ca                	mv	a1,s2
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	ee2080e7          	jalr	-286(ra) # 3d2 <putc>
 4f8:	a019                	j	4fe <vprintf+0x60>
    } else if(state == '%'){
 4fa:	01498f63          	beq	s3,s4,518 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4fe:	0485                	addi	s1,s1,1
 500:	fff4c903          	lbu	s2,-1(s1)
 504:	14090d63          	beqz	s2,65e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 508:	0009079b          	sext.w	a5,s2
    if(state == 0){
 50c:	fe0997e3          	bnez	s3,4fa <vprintf+0x5c>
      if(c == '%'){
 510:	fd479ee3          	bne	a5,s4,4ec <vprintf+0x4e>
        state = '%';
 514:	89be                	mv	s3,a5
 516:	b7e5                	j	4fe <vprintf+0x60>
      if(c == 'd'){
 518:	05878063          	beq	a5,s8,558 <vprintf+0xba>
      } else if(c == 'l') {
 51c:	05978c63          	beq	a5,s9,574 <vprintf+0xd6>
      } else if(c == 'x') {
 520:	07a78863          	beq	a5,s10,590 <vprintf+0xf2>
      } else if(c == 'p') {
 524:	09b78463          	beq	a5,s11,5ac <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 528:	07300713          	li	a4,115
 52c:	0ce78663          	beq	a5,a4,5f8 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 530:	06300713          	li	a4,99
 534:	0ee78e63          	beq	a5,a4,630 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 538:	11478863          	beq	a5,s4,648 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 53c:	85d2                	mv	a1,s4
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	e92080e7          	jalr	-366(ra) # 3d2 <putc>
        putc(fd, c);
 548:	85ca                	mv	a1,s2
 54a:	8556                	mv	a0,s5
 54c:	00000097          	auipc	ra,0x0
 550:	e86080e7          	jalr	-378(ra) # 3d2 <putc>
      }
      state = 0;
 554:	4981                	li	s3,0
 556:	b765                	j	4fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 558:	008b0913          	addi	s2,s6,8
 55c:	4685                	li	a3,1
 55e:	4629                	li	a2,10
 560:	000b2583          	lw	a1,0(s6)
 564:	8556                	mv	a0,s5
 566:	00000097          	auipc	ra,0x0
 56a:	e8e080e7          	jalr	-370(ra) # 3f4 <printint>
 56e:	8b4a                	mv	s6,s2
      state = 0;
 570:	4981                	li	s3,0
 572:	b771                	j	4fe <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 574:	008b0913          	addi	s2,s6,8
 578:	4681                	li	a3,0
 57a:	4629                	li	a2,10
 57c:	000b2583          	lw	a1,0(s6)
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e72080e7          	jalr	-398(ra) # 3f4 <printint>
 58a:	8b4a                	mv	s6,s2
      state = 0;
 58c:	4981                	li	s3,0
 58e:	bf85                	j	4fe <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 590:	008b0913          	addi	s2,s6,8
 594:	4681                	li	a3,0
 596:	4641                	li	a2,16
 598:	000b2583          	lw	a1,0(s6)
 59c:	8556                	mv	a0,s5
 59e:	00000097          	auipc	ra,0x0
 5a2:	e56080e7          	jalr	-426(ra) # 3f4 <printint>
 5a6:	8b4a                	mv	s6,s2
      state = 0;
 5a8:	4981                	li	s3,0
 5aa:	bf91                	j	4fe <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5ac:	008b0793          	addi	a5,s6,8
 5b0:	f8f43423          	sd	a5,-120(s0)
 5b4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5b8:	03000593          	li	a1,48
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	e14080e7          	jalr	-492(ra) # 3d2 <putc>
  putc(fd, 'x');
 5c6:	85ea                	mv	a1,s10
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e08080e7          	jalr	-504(ra) # 3d2 <putc>
 5d2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d4:	03c9d793          	srli	a5,s3,0x3c
 5d8:	97de                	add	a5,a5,s7
 5da:	0007c583          	lbu	a1,0(a5)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	df2080e7          	jalr	-526(ra) # 3d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5e8:	0992                	slli	s3,s3,0x4
 5ea:	397d                	addiw	s2,s2,-1
 5ec:	fe0914e3          	bnez	s2,5d4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 5f0:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b721                	j	4fe <vprintf+0x60>
        s = va_arg(ap, char*);
 5f8:	008b0993          	addi	s3,s6,8
 5fc:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 600:	02090163          	beqz	s2,622 <vprintf+0x184>
        while(*s != 0){
 604:	00094583          	lbu	a1,0(s2)
 608:	c9a1                	beqz	a1,658 <vprintf+0x1ba>
          putc(fd, *s);
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	dc6080e7          	jalr	-570(ra) # 3d2 <putc>
          s++;
 614:	0905                	addi	s2,s2,1
        while(*s != 0){
 616:	00094583          	lbu	a1,0(s2)
 61a:	f9e5                	bnez	a1,60a <vprintf+0x16c>
        s = va_arg(ap, char*);
 61c:	8b4e                	mv	s6,s3
      state = 0;
 61e:	4981                	li	s3,0
 620:	bdf9                	j	4fe <vprintf+0x60>
          s = "(null)";
 622:	00000917          	auipc	s2,0x0
 626:	28e90913          	addi	s2,s2,654 # 8b0 <malloc+0x148>
        while(*s != 0){
 62a:	02800593          	li	a1,40
 62e:	bff1                	j	60a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 630:	008b0913          	addi	s2,s6,8
 634:	000b4583          	lbu	a1,0(s6)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	d98080e7          	jalr	-616(ra) # 3d2 <putc>
 642:	8b4a                	mv	s6,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	bd65                	j	4fe <vprintf+0x60>
        putc(fd, c);
 648:	85d2                	mv	a1,s4
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	d86080e7          	jalr	-634(ra) # 3d2 <putc>
      state = 0;
 654:	4981                	li	s3,0
 656:	b565                	j	4fe <vprintf+0x60>
        s = va_arg(ap, char*);
 658:	8b4e                	mv	s6,s3
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b54d                	j	4fe <vprintf+0x60>
    }
  }
}
 65e:	70e6                	ld	ra,120(sp)
 660:	7446                	ld	s0,112(sp)
 662:	74a6                	ld	s1,104(sp)
 664:	7906                	ld	s2,96(sp)
 666:	69e6                	ld	s3,88(sp)
 668:	6a46                	ld	s4,80(sp)
 66a:	6aa6                	ld	s5,72(sp)
 66c:	6b06                	ld	s6,64(sp)
 66e:	7be2                	ld	s7,56(sp)
 670:	7c42                	ld	s8,48(sp)
 672:	7ca2                	ld	s9,40(sp)
 674:	7d02                	ld	s10,32(sp)
 676:	6de2                	ld	s11,24(sp)
 678:	6109                	addi	sp,sp,128
 67a:	8082                	ret

000000000000067c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 67c:	715d                	addi	sp,sp,-80
 67e:	ec06                	sd	ra,24(sp)
 680:	e822                	sd	s0,16(sp)
 682:	1000                	addi	s0,sp,32
 684:	e010                	sd	a2,0(s0)
 686:	e414                	sd	a3,8(s0)
 688:	e818                	sd	a4,16(s0)
 68a:	ec1c                	sd	a5,24(s0)
 68c:	03043023          	sd	a6,32(s0)
 690:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 694:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 698:	8622                	mv	a2,s0
 69a:	00000097          	auipc	ra,0x0
 69e:	e04080e7          	jalr	-508(ra) # 49e <vprintf>
}
 6a2:	60e2                	ld	ra,24(sp)
 6a4:	6442                	ld	s0,16(sp)
 6a6:	6161                	addi	sp,sp,80
 6a8:	8082                	ret

00000000000006aa <printf>:

void
printf(const char *fmt, ...)
{
 6aa:	711d                	addi	sp,sp,-96
 6ac:	ec06                	sd	ra,24(sp)
 6ae:	e822                	sd	s0,16(sp)
 6b0:	1000                	addi	s0,sp,32
 6b2:	e40c                	sd	a1,8(s0)
 6b4:	e810                	sd	a2,16(s0)
 6b6:	ec14                	sd	a3,24(s0)
 6b8:	f018                	sd	a4,32(s0)
 6ba:	f41c                	sd	a5,40(s0)
 6bc:	03043823          	sd	a6,48(s0)
 6c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c4:	00840613          	addi	a2,s0,8
 6c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6cc:	85aa                	mv	a1,a0
 6ce:	4505                	li	a0,1
 6d0:	00000097          	auipc	ra,0x0
 6d4:	dce080e7          	jalr	-562(ra) # 49e <vprintf>
}
 6d8:	60e2                	ld	ra,24(sp)
 6da:	6442                	ld	s0,16(sp)
 6dc:	6125                	addi	sp,sp,96
 6de:	8082                	ret

00000000000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	1141                	addi	sp,sp,-16
 6e2:	e422                	sd	s0,8(sp)
 6e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ea:	00001797          	auipc	a5,0x1
 6ee:	9167b783          	ld	a5,-1770(a5) # 1000 <freep>
 6f2:	a805                	j	722 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f4:	4618                	lw	a4,8(a2)
 6f6:	9db9                	addw	a1,a1,a4
 6f8:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fc:	6398                	ld	a4,0(a5)
 6fe:	6318                	ld	a4,0(a4)
 700:	fee53823          	sd	a4,-16(a0)
 704:	a091                	j	748 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 706:	ff852703          	lw	a4,-8(a0)
 70a:	9e39                	addw	a2,a2,a4
 70c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 70e:	ff053703          	ld	a4,-16(a0)
 712:	e398                	sd	a4,0(a5)
 714:	a099                	j	75a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 716:	6398                	ld	a4,0(a5)
 718:	00e7e463          	bltu	a5,a4,720 <free+0x40>
 71c:	00e6ea63          	bltu	a3,a4,730 <free+0x50>
{
 720:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 722:	fed7fae3          	bgeu	a5,a3,716 <free+0x36>
 726:	6398                	ld	a4,0(a5)
 728:	00e6e463          	bltu	a3,a4,730 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72c:	fee7eae3          	bltu	a5,a4,720 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 730:	ff852583          	lw	a1,-8(a0)
 734:	6390                	ld	a2,0(a5)
 736:	02059713          	slli	a4,a1,0x20
 73a:	9301                	srli	a4,a4,0x20
 73c:	0712                	slli	a4,a4,0x4
 73e:	9736                	add	a4,a4,a3
 740:	fae60ae3          	beq	a2,a4,6f4 <free+0x14>
    bp->s.ptr = p->s.ptr;
 744:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 748:	4790                	lw	a2,8(a5)
 74a:	02061713          	slli	a4,a2,0x20
 74e:	9301                	srli	a4,a4,0x20
 750:	0712                	slli	a4,a4,0x4
 752:	973e                	add	a4,a4,a5
 754:	fae689e3          	beq	a3,a4,706 <free+0x26>
  } else
    p->s.ptr = bp;
 758:	e394                	sd	a3,0(a5)
  freep = p;
 75a:	00001717          	auipc	a4,0x1
 75e:	8af73323          	sd	a5,-1882(a4) # 1000 <freep>
}
 762:	6422                	ld	s0,8(sp)
 764:	0141                	addi	sp,sp,16
 766:	8082                	ret

0000000000000768 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 768:	7139                	addi	sp,sp,-64
 76a:	fc06                	sd	ra,56(sp)
 76c:	f822                	sd	s0,48(sp)
 76e:	f426                	sd	s1,40(sp)
 770:	f04a                	sd	s2,32(sp)
 772:	ec4e                	sd	s3,24(sp)
 774:	e852                	sd	s4,16(sp)
 776:	e456                	sd	s5,8(sp)
 778:	e05a                	sd	s6,0(sp)
 77a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77c:	02051493          	slli	s1,a0,0x20
 780:	9081                	srli	s1,s1,0x20
 782:	04bd                	addi	s1,s1,15
 784:	8091                	srli	s1,s1,0x4
 786:	0014899b          	addiw	s3,s1,1
 78a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 78c:	00001517          	auipc	a0,0x1
 790:	87453503          	ld	a0,-1932(a0) # 1000 <freep>
 794:	c515                	beqz	a0,7c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 796:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 798:	4798                	lw	a4,8(a5)
 79a:	02977f63          	bgeu	a4,s1,7d8 <malloc+0x70>
 79e:	8a4e                	mv	s4,s3
 7a0:	0009871b          	sext.w	a4,s3
 7a4:	6685                	lui	a3,0x1
 7a6:	00d77363          	bgeu	a4,a3,7ac <malloc+0x44>
 7aa:	6a05                	lui	s4,0x1
 7ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b4:	00001917          	auipc	s2,0x1
 7b8:	84c90913          	addi	s2,s2,-1972 # 1000 <freep>
  if(p == (char*)-1)
 7bc:	5afd                	li	s5,-1
 7be:	a88d                	j	830 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7c0:	00001797          	auipc	a5,0x1
 7c4:	85078793          	addi	a5,a5,-1968 # 1010 <base>
 7c8:	00001717          	auipc	a4,0x1
 7cc:	82f73c23          	sd	a5,-1992(a4) # 1000 <freep>
 7d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d6:	b7e1                	j	79e <malloc+0x36>
      if(p->s.size == nunits)
 7d8:	02e48b63          	beq	s1,a4,80e <malloc+0xa6>
        p->s.size -= nunits;
 7dc:	4137073b          	subw	a4,a4,s3
 7e0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7e2:	1702                	slli	a4,a4,0x20
 7e4:	9301                	srli	a4,a4,0x20
 7e6:	0712                	slli	a4,a4,0x4
 7e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7ee:	00001717          	auipc	a4,0x1
 7f2:	80a73923          	sd	a0,-2030(a4) # 1000 <freep>
      return (void*)(p + 1);
 7f6:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7fa:	70e2                	ld	ra,56(sp)
 7fc:	7442                	ld	s0,48(sp)
 7fe:	74a2                	ld	s1,40(sp)
 800:	7902                	ld	s2,32(sp)
 802:	69e2                	ld	s3,24(sp)
 804:	6a42                	ld	s4,16(sp)
 806:	6aa2                	ld	s5,8(sp)
 808:	6b02                	ld	s6,0(sp)
 80a:	6121                	addi	sp,sp,64
 80c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 80e:	6398                	ld	a4,0(a5)
 810:	e118                	sd	a4,0(a0)
 812:	bff1                	j	7ee <malloc+0x86>
  hp->s.size = nu;
 814:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 818:	0541                	addi	a0,a0,16
 81a:	00000097          	auipc	ra,0x0
 81e:	ec6080e7          	jalr	-314(ra) # 6e0 <free>
  return freep;
 822:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 826:	d971                	beqz	a0,7fa <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	fa9776e3          	bgeu	a4,s1,7d8 <malloc+0x70>
    if(p == freep)
 830:	00093703          	ld	a4,0(s2)
 834:	853e                	mv	a0,a5
 836:	fef719e3          	bne	a4,a5,828 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 83a:	8552                	mv	a0,s4
 83c:	00000097          	auipc	ra,0x0
 840:	b56080e7          	jalr	-1194(ra) # 392 <sbrk>
  if(p == (char*)-1)
 844:	fd5518e3          	bne	a0,s5,814 <malloc+0xac>
        return 0;
 848:	4501                	li	a0,0
 84a:	bf45                	j	7fa <malloc+0x92>
