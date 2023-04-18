
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	6bc080e7          	jalr	1724(ra) # 66cc <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	6aa080e7          	jalr	1706(ra) # 66cc <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1,"");
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00007517          	auipc	a0,0x7
      42:	bb250513          	addi	a0,a0,-1102 # 6bf0 <malloc+0x106>
      46:	00007097          	auipc	ra,0x7
      4a:	9e6080e7          	jalr	-1562(ra) # 6a2c <printf>
      exit(1,"");
      4e:	00008597          	auipc	a1,0x8
      52:	1ca58593          	addi	a1,a1,458 # 8218 <malloc+0x172e>
      56:	4505                	li	a0,1
      58:	00006097          	auipc	ra,0x6
      5c:	634080e7          	jalr	1588(ra) # 668c <exit>

0000000000000060 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      60:	0000b797          	auipc	a5,0xb
      64:	50878793          	addi	a5,a5,1288 # b568 <uninit>
      68:	0000e697          	auipc	a3,0xe
      6c:	c1068693          	addi	a3,a3,-1008 # dc78 <buf>
    if(uninit[i] != '\0'){
      70:	0007c703          	lbu	a4,0(a5)
      74:	e709                	bnez	a4,7e <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      76:	0785                	addi	a5,a5,1
      78:	fed79ce3          	bne	a5,a3,70 <bsstest+0x10>
      7c:	8082                	ret
{
      7e:	1141                	addi	sp,sp,-16
      80:	e406                	sd	ra,8(sp)
      82:	e022                	sd	s0,0(sp)
      84:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      86:	85aa                	mv	a1,a0
      88:	00007517          	auipc	a0,0x7
      8c:	b8850513          	addi	a0,a0,-1144 # 6c10 <malloc+0x126>
      90:	00007097          	auipc	ra,0x7
      94:	99c080e7          	jalr	-1636(ra) # 6a2c <printf>
      exit(1,"");
      98:	00008597          	auipc	a1,0x8
      9c:	18058593          	addi	a1,a1,384 # 8218 <malloc+0x172e>
      a0:	4505                	li	a0,1
      a2:	00006097          	auipc	ra,0x6
      a6:	5ea080e7          	jalr	1514(ra) # 668c <exit>

00000000000000aa <opentest>:
{
      aa:	1101                	addi	sp,sp,-32
      ac:	ec06                	sd	ra,24(sp)
      ae:	e822                	sd	s0,16(sp)
      b0:	e426                	sd	s1,8(sp)
      b2:	1000                	addi	s0,sp,32
      b4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      b6:	4581                	li	a1,0
      b8:	00007517          	auipc	a0,0x7
      bc:	b7050513          	addi	a0,a0,-1168 # 6c28 <malloc+0x13e>
      c0:	00006097          	auipc	ra,0x6
      c4:	60c080e7          	jalr	1548(ra) # 66cc <open>
  if(fd < 0){
      c8:	02054663          	bltz	a0,f4 <opentest+0x4a>
  close(fd);
      cc:	00006097          	auipc	ra,0x6
      d0:	5e8080e7          	jalr	1512(ra) # 66b4 <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00007517          	auipc	a0,0x7
      da:	b7250513          	addi	a0,a0,-1166 # 6c48 <malloc+0x15e>
      de:	00006097          	auipc	ra,0x6
      e2:	5ee080e7          	jalr	1518(ra) # 66cc <open>
  if(fd >= 0){
      e6:	02055963          	bgez	a0,118 <opentest+0x6e>
}
      ea:	60e2                	ld	ra,24(sp)
      ec:	6442                	ld	s0,16(sp)
      ee:	64a2                	ld	s1,8(sp)
      f0:	6105                	addi	sp,sp,32
      f2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f4:	85a6                	mv	a1,s1
      f6:	00007517          	auipc	a0,0x7
      fa:	b3a50513          	addi	a0,a0,-1222 # 6c30 <malloc+0x146>
      fe:	00007097          	auipc	ra,0x7
     102:	92e080e7          	jalr	-1746(ra) # 6a2c <printf>
    exit(1,"");
     106:	00008597          	auipc	a1,0x8
     10a:	11258593          	addi	a1,a1,274 # 8218 <malloc+0x172e>
     10e:	4505                	li	a0,1
     110:	00006097          	auipc	ra,0x6
     114:	57c080e7          	jalr	1404(ra) # 668c <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     118:	85a6                	mv	a1,s1
     11a:	00007517          	auipc	a0,0x7
     11e:	b3e50513          	addi	a0,a0,-1218 # 6c58 <malloc+0x16e>
     122:	00007097          	auipc	ra,0x7
     126:	90a080e7          	jalr	-1782(ra) # 6a2c <printf>
    exit(1,"");
     12a:	00008597          	auipc	a1,0x8
     12e:	0ee58593          	addi	a1,a1,238 # 8218 <malloc+0x172e>
     132:	4505                	li	a0,1
     134:	00006097          	auipc	ra,0x6
     138:	558080e7          	jalr	1368(ra) # 668c <exit>

000000000000013c <truncate2>:
{
     13c:	7179                	addi	sp,sp,-48
     13e:	f406                	sd	ra,40(sp)
     140:	f022                	sd	s0,32(sp)
     142:	ec26                	sd	s1,24(sp)
     144:	e84a                	sd	s2,16(sp)
     146:	e44e                	sd	s3,8(sp)
     148:	1800                	addi	s0,sp,48
     14a:	89aa                	mv	s3,a0
  unlink("truncfile");
     14c:	00007517          	auipc	a0,0x7
     150:	b3450513          	addi	a0,a0,-1228 # 6c80 <malloc+0x196>
     154:	00006097          	auipc	ra,0x6
     158:	588080e7          	jalr	1416(ra) # 66dc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     15c:	60100593          	li	a1,1537
     160:	00007517          	auipc	a0,0x7
     164:	b2050513          	addi	a0,a0,-1248 # 6c80 <malloc+0x196>
     168:	00006097          	auipc	ra,0x6
     16c:	564080e7          	jalr	1380(ra) # 66cc <open>
     170:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     172:	4611                	li	a2,4
     174:	00007597          	auipc	a1,0x7
     178:	b1c58593          	addi	a1,a1,-1252 # 6c90 <malloc+0x1a6>
     17c:	00006097          	auipc	ra,0x6
     180:	530080e7          	jalr	1328(ra) # 66ac <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     184:	40100593          	li	a1,1025
     188:	00007517          	auipc	a0,0x7
     18c:	af850513          	addi	a0,a0,-1288 # 6c80 <malloc+0x196>
     190:	00006097          	auipc	ra,0x6
     194:	53c080e7          	jalr	1340(ra) # 66cc <open>
     198:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     19a:	4605                	li	a2,1
     19c:	00007597          	auipc	a1,0x7
     1a0:	afc58593          	addi	a1,a1,-1284 # 6c98 <malloc+0x1ae>
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	506080e7          	jalr	1286(ra) # 66ac <write>
  if(n != -1){
     1ae:	57fd                	li	a5,-1
     1b0:	02f51b63          	bne	a0,a5,1e6 <truncate2+0xaa>
  unlink("truncfile");
     1b4:	00007517          	auipc	a0,0x7
     1b8:	acc50513          	addi	a0,a0,-1332 # 6c80 <malloc+0x196>
     1bc:	00006097          	auipc	ra,0x6
     1c0:	520080e7          	jalr	1312(ra) # 66dc <unlink>
  close(fd1);
     1c4:	8526                	mv	a0,s1
     1c6:	00006097          	auipc	ra,0x6
     1ca:	4ee080e7          	jalr	1262(ra) # 66b4 <close>
  close(fd2);
     1ce:	854a                	mv	a0,s2
     1d0:	00006097          	auipc	ra,0x6
     1d4:	4e4080e7          	jalr	1252(ra) # 66b4 <close>
}
     1d8:	70a2                	ld	ra,40(sp)
     1da:	7402                	ld	s0,32(sp)
     1dc:	64e2                	ld	s1,24(sp)
     1de:	6942                	ld	s2,16(sp)
     1e0:	69a2                	ld	s3,8(sp)
     1e2:	6145                	addi	sp,sp,48
     1e4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1e6:	862a                	mv	a2,a0
     1e8:	85ce                	mv	a1,s3
     1ea:	00007517          	auipc	a0,0x7
     1ee:	ab650513          	addi	a0,a0,-1354 # 6ca0 <malloc+0x1b6>
     1f2:	00007097          	auipc	ra,0x7
     1f6:	83a080e7          	jalr	-1990(ra) # 6a2c <printf>
    exit(1,"");
     1fa:	00008597          	auipc	a1,0x8
     1fe:	01e58593          	addi	a1,a1,30 # 8218 <malloc+0x172e>
     202:	4505                	li	a0,1
     204:	00006097          	auipc	ra,0x6
     208:	488080e7          	jalr	1160(ra) # 668c <exit>

000000000000020c <createtest>:
{
     20c:	7179                	addi	sp,sp,-48
     20e:	f406                	sd	ra,40(sp)
     210:	f022                	sd	s0,32(sp)
     212:	ec26                	sd	s1,24(sp)
     214:	e84a                	sd	s2,16(sp)
     216:	1800                	addi	s0,sp,48
  name[0] = 'a';
     218:	06100793          	li	a5,97
     21c:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     220:	fc040d23          	sb	zero,-38(s0)
     224:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     228:	06400913          	li	s2,100
    name[1] = '0' + i;
     22c:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     230:	20200593          	li	a1,514
     234:	fd840513          	addi	a0,s0,-40
     238:	00006097          	auipc	ra,0x6
     23c:	494080e7          	jalr	1172(ra) # 66cc <open>
    close(fd);
     240:	00006097          	auipc	ra,0x6
     244:	474080e7          	jalr	1140(ra) # 66b4 <close>
  for(i = 0; i < N; i++){
     248:	2485                	addiw	s1,s1,1
     24a:	0ff4f493          	andi	s1,s1,255
     24e:	fd249fe3          	bne	s1,s2,22c <createtest+0x20>
  name[0] = 'a';
     252:	06100793          	li	a5,97
     256:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     25a:	fc040d23          	sb	zero,-38(s0)
     25e:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     262:	06400913          	li	s2,100
    name[1] = '0' + i;
     266:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     26a:	fd840513          	addi	a0,s0,-40
     26e:	00006097          	auipc	ra,0x6
     272:	46e080e7          	jalr	1134(ra) # 66dc <unlink>
  for(i = 0; i < N; i++){
     276:	2485                	addiw	s1,s1,1
     278:	0ff4f493          	andi	s1,s1,255
     27c:	ff2495e3          	bne	s1,s2,266 <createtest+0x5a>
}
     280:	70a2                	ld	ra,40(sp)
     282:	7402                	ld	s0,32(sp)
     284:	64e2                	ld	s1,24(sp)
     286:	6942                	ld	s2,16(sp)
     288:	6145                	addi	sp,sp,48
     28a:	8082                	ret

000000000000028c <bigwrite>:
{
     28c:	715d                	addi	sp,sp,-80
     28e:	e486                	sd	ra,72(sp)
     290:	e0a2                	sd	s0,64(sp)
     292:	fc26                	sd	s1,56(sp)
     294:	f84a                	sd	s2,48(sp)
     296:	f44e                	sd	s3,40(sp)
     298:	f052                	sd	s4,32(sp)
     29a:	ec56                	sd	s5,24(sp)
     29c:	e85a                	sd	s6,16(sp)
     29e:	e45e                	sd	s7,8(sp)
     2a0:	0880                	addi	s0,sp,80
     2a2:	8baa                	mv	s7,a0
  unlink("bigwrite");
     2a4:	00007517          	auipc	a0,0x7
     2a8:	a2450513          	addi	a0,a0,-1500 # 6cc8 <malloc+0x1de>
     2ac:	00006097          	auipc	ra,0x6
     2b0:	430080e7          	jalr	1072(ra) # 66dc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2b8:	00007a97          	auipc	s5,0x7
     2bc:	a10a8a93          	addi	s5,s5,-1520 # 6cc8 <malloc+0x1de>
      int cc = write(fd, buf, sz);
     2c0:	0000ea17          	auipc	s4,0xe
     2c4:	9b8a0a13          	addi	s4,s4,-1608 # dc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2c8:	6b0d                	lui	s6,0x3
     2ca:	1c9b0b13          	addi	s6,s6,457 # 31c9 <sbrkarg+0x49>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ce:	20200593          	li	a1,514
     2d2:	8556                	mv	a0,s5
     2d4:	00006097          	auipc	ra,0x6
     2d8:	3f8080e7          	jalr	1016(ra) # 66cc <open>
     2dc:	892a                	mv	s2,a0
    if(fd < 0){
     2de:	04054d63          	bltz	a0,338 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2e2:	8626                	mv	a2,s1
     2e4:	85d2                	mv	a1,s4
     2e6:	00006097          	auipc	ra,0x6
     2ea:	3c6080e7          	jalr	966(ra) # 66ac <write>
     2ee:	89aa                	mv	s3,a0
      if(cc != sz){
     2f0:	06a49863          	bne	s1,a0,360 <bigwrite+0xd4>
      int cc = write(fd, buf, sz);
     2f4:	8626                	mv	a2,s1
     2f6:	85d2                	mv	a1,s4
     2f8:	854a                	mv	a0,s2
     2fa:	00006097          	auipc	ra,0x6
     2fe:	3b2080e7          	jalr	946(ra) # 66ac <write>
      if(cc != sz){
     302:	04951d63          	bne	a0,s1,35c <bigwrite+0xd0>
    close(fd);
     306:	854a                	mv	a0,s2
     308:	00006097          	auipc	ra,0x6
     30c:	3ac080e7          	jalr	940(ra) # 66b4 <close>
    unlink("bigwrite");
     310:	8556                	mv	a0,s5
     312:	00006097          	auipc	ra,0x6
     316:	3ca080e7          	jalr	970(ra) # 66dc <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     31a:	1d74849b          	addiw	s1,s1,471
     31e:	fb6498e3          	bne	s1,s6,2ce <bigwrite+0x42>
}
     322:	60a6                	ld	ra,72(sp)
     324:	6406                	ld	s0,64(sp)
     326:	74e2                	ld	s1,56(sp)
     328:	7942                	ld	s2,48(sp)
     32a:	79a2                	ld	s3,40(sp)
     32c:	7a02                	ld	s4,32(sp)
     32e:	6ae2                	ld	s5,24(sp)
     330:	6b42                	ld	s6,16(sp)
     332:	6ba2                	ld	s7,8(sp)
     334:	6161                	addi	sp,sp,80
     336:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     338:	85de                	mv	a1,s7
     33a:	00007517          	auipc	a0,0x7
     33e:	99e50513          	addi	a0,a0,-1634 # 6cd8 <malloc+0x1ee>
     342:	00006097          	auipc	ra,0x6
     346:	6ea080e7          	jalr	1770(ra) # 6a2c <printf>
      exit(1,"");
     34a:	00008597          	auipc	a1,0x8
     34e:	ece58593          	addi	a1,a1,-306 # 8218 <malloc+0x172e>
     352:	4505                	li	a0,1
     354:	00006097          	auipc	ra,0x6
     358:	338080e7          	jalr	824(ra) # 668c <exit>
     35c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     35e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     360:	86ce                	mv	a3,s3
     362:	8626                	mv	a2,s1
     364:	85de                	mv	a1,s7
     366:	00007517          	auipc	a0,0x7
     36a:	99250513          	addi	a0,a0,-1646 # 6cf8 <malloc+0x20e>
     36e:	00006097          	auipc	ra,0x6
     372:	6be080e7          	jalr	1726(ra) # 6a2c <printf>
        exit(1,"");
     376:	00008597          	auipc	a1,0x8
     37a:	ea258593          	addi	a1,a1,-350 # 8218 <malloc+0x172e>
     37e:	4505                	li	a0,1
     380:	00006097          	auipc	ra,0x6
     384:	30c080e7          	jalr	780(ra) # 668c <exit>

0000000000000388 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     388:	7179                	addi	sp,sp,-48
     38a:	f406                	sd	ra,40(sp)
     38c:	f022                	sd	s0,32(sp)
     38e:	ec26                	sd	s1,24(sp)
     390:	e84a                	sd	s2,16(sp)
     392:	e44e                	sd	s3,8(sp)
     394:	e052                	sd	s4,0(sp)
     396:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     398:	00007517          	auipc	a0,0x7
     39c:	97850513          	addi	a0,a0,-1672 # 6d10 <malloc+0x226>
     3a0:	00006097          	auipc	ra,0x6
     3a4:	33c080e7          	jalr	828(ra) # 66dc <unlink>
     3a8:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     3ac:	00007997          	auipc	s3,0x7
     3b0:	96498993          	addi	s3,s3,-1692 # 6d10 <malloc+0x226>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1,"");
    }
    write(fd, (char*)0xffffffffffL, 1);
     3b4:	5a7d                	li	s4,-1
     3b6:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	854e                	mv	a0,s3
     3c0:	00006097          	auipc	ra,0x6
     3c4:	30c080e7          	jalr	780(ra) # 66cc <open>
     3c8:	84aa                	mv	s1,a0
    if(fd < 0){
     3ca:	06054f63          	bltz	a0,448 <badwrite+0xc0>
    write(fd, (char*)0xffffffffffL, 1);
     3ce:	4605                	li	a2,1
     3d0:	85d2                	mv	a1,s4
     3d2:	00006097          	auipc	ra,0x6
     3d6:	2da080e7          	jalr	730(ra) # 66ac <write>
    close(fd);
     3da:	8526                	mv	a0,s1
     3dc:	00006097          	auipc	ra,0x6
     3e0:	2d8080e7          	jalr	728(ra) # 66b4 <close>
    unlink("junk");
     3e4:	854e                	mv	a0,s3
     3e6:	00006097          	auipc	ra,0x6
     3ea:	2f6080e7          	jalr	758(ra) # 66dc <unlink>
  for(int i = 0; i < assumed_free; i++){
     3ee:	397d                	addiw	s2,s2,-1
     3f0:	fc0915e3          	bnez	s2,3ba <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3f4:	20100593          	li	a1,513
     3f8:	00007517          	auipc	a0,0x7
     3fc:	91850513          	addi	a0,a0,-1768 # 6d10 <malloc+0x226>
     400:	00006097          	auipc	ra,0x6
     404:	2cc080e7          	jalr	716(ra) # 66cc <open>
     408:	84aa                	mv	s1,a0
  if(fd < 0){
     40a:	06054063          	bltz	a0,46a <badwrite+0xe2>
    printf("open junk failed\n");
    exit(1,"");
  }
  if(write(fd, "x", 1) != 1){
     40e:	4605                	li	a2,1
     410:	00007597          	auipc	a1,0x7
     414:	88858593          	addi	a1,a1,-1912 # 6c98 <malloc+0x1ae>
     418:	00006097          	auipc	ra,0x6
     41c:	294080e7          	jalr	660(ra) # 66ac <write>
     420:	4785                	li	a5,1
     422:	06f50563          	beq	a0,a5,48c <badwrite+0x104>
    printf("write failed\n");
     426:	00007517          	auipc	a0,0x7
     42a:	90a50513          	addi	a0,a0,-1782 # 6d30 <malloc+0x246>
     42e:	00006097          	auipc	ra,0x6
     432:	5fe080e7          	jalr	1534(ra) # 6a2c <printf>
    exit(1,"");
     436:	00008597          	auipc	a1,0x8
     43a:	de258593          	addi	a1,a1,-542 # 8218 <malloc+0x172e>
     43e:	4505                	li	a0,1
     440:	00006097          	auipc	ra,0x6
     444:	24c080e7          	jalr	588(ra) # 668c <exit>
      printf("open junk failed\n");
     448:	00007517          	auipc	a0,0x7
     44c:	8d050513          	addi	a0,a0,-1840 # 6d18 <malloc+0x22e>
     450:	00006097          	auipc	ra,0x6
     454:	5dc080e7          	jalr	1500(ra) # 6a2c <printf>
      exit(1,"");
     458:	00008597          	auipc	a1,0x8
     45c:	dc058593          	addi	a1,a1,-576 # 8218 <malloc+0x172e>
     460:	4505                	li	a0,1
     462:	00006097          	auipc	ra,0x6
     466:	22a080e7          	jalr	554(ra) # 668c <exit>
    printf("open junk failed\n");
     46a:	00007517          	auipc	a0,0x7
     46e:	8ae50513          	addi	a0,a0,-1874 # 6d18 <malloc+0x22e>
     472:	00006097          	auipc	ra,0x6
     476:	5ba080e7          	jalr	1466(ra) # 6a2c <printf>
    exit(1,"");
     47a:	00008597          	auipc	a1,0x8
     47e:	d9e58593          	addi	a1,a1,-610 # 8218 <malloc+0x172e>
     482:	4505                	li	a0,1
     484:	00006097          	auipc	ra,0x6
     488:	208080e7          	jalr	520(ra) # 668c <exit>
  }
  close(fd);
     48c:	8526                	mv	a0,s1
     48e:	00006097          	auipc	ra,0x6
     492:	226080e7          	jalr	550(ra) # 66b4 <close>
  unlink("junk");
     496:	00007517          	auipc	a0,0x7
     49a:	87a50513          	addi	a0,a0,-1926 # 6d10 <malloc+0x226>
     49e:	00006097          	auipc	ra,0x6
     4a2:	23e080e7          	jalr	574(ra) # 66dc <unlink>

  exit(0,"");
     4a6:	00008597          	auipc	a1,0x8
     4aa:	d7258593          	addi	a1,a1,-654 # 8218 <malloc+0x172e>
     4ae:	4501                	li	a0,0
     4b0:	00006097          	auipc	ra,0x6
     4b4:	1dc080e7          	jalr	476(ra) # 668c <exit>

00000000000004b8 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     4b8:	715d                	addi	sp,sp,-80
     4ba:	e486                	sd	ra,72(sp)
     4bc:	e0a2                	sd	s0,64(sp)
     4be:	fc26                	sd	s1,56(sp)
     4c0:	f84a                	sd	s2,48(sp)
     4c2:	f44e                	sd	s3,40(sp)
     4c4:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     4c6:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     4c8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4cc:	40000993          	li	s3,1024
    name[0] = 'z';
     4d0:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4d4:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4d8:	41f4d79b          	sraiw	a5,s1,0x1f
     4dc:	01b7d71b          	srliw	a4,a5,0x1b
     4e0:	009707bb          	addw	a5,a4,s1
     4e4:	4057d69b          	sraiw	a3,a5,0x5
     4e8:	0306869b          	addiw	a3,a3,48
     4ec:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4f0:	8bfd                	andi	a5,a5,31
     4f2:	9f99                	subw	a5,a5,a4
     4f4:	0307879b          	addiw	a5,a5,48
     4f8:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4fc:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     500:	fb040513          	addi	a0,s0,-80
     504:	00006097          	auipc	ra,0x6
     508:	1d8080e7          	jalr	472(ra) # 66dc <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     50c:	60200593          	li	a1,1538
     510:	fb040513          	addi	a0,s0,-80
     514:	00006097          	auipc	ra,0x6
     518:	1b8080e7          	jalr	440(ra) # 66cc <open>
    if(fd < 0){
     51c:	00054963          	bltz	a0,52e <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     520:	00006097          	auipc	ra,0x6
     524:	194080e7          	jalr	404(ra) # 66b4 <close>
  for(int i = 0; i < nzz; i++){
     528:	2485                	addiw	s1,s1,1
     52a:	fb3493e3          	bne	s1,s3,4d0 <outofinodes+0x18>
     52e:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     530:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     534:	40000993          	li	s3,1024
    name[0] = 'z';
     538:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     53c:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     540:	41f4d79b          	sraiw	a5,s1,0x1f
     544:	01b7d71b          	srliw	a4,a5,0x1b
     548:	009707bb          	addw	a5,a4,s1
     54c:	4057d69b          	sraiw	a3,a5,0x5
     550:	0306869b          	addiw	a3,a3,48
     554:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     558:	8bfd                	andi	a5,a5,31
     55a:	9f99                	subw	a5,a5,a4
     55c:	0307879b          	addiw	a5,a5,48
     560:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     564:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     568:	fb040513          	addi	a0,s0,-80
     56c:	00006097          	auipc	ra,0x6
     570:	170080e7          	jalr	368(ra) # 66dc <unlink>
  for(int i = 0; i < nzz; i++){
     574:	2485                	addiw	s1,s1,1
     576:	fd3491e3          	bne	s1,s3,538 <outofinodes+0x80>
  }
}
     57a:	60a6                	ld	ra,72(sp)
     57c:	6406                	ld	s0,64(sp)
     57e:	74e2                	ld	s1,56(sp)
     580:	7942                	ld	s2,48(sp)
     582:	79a2                	ld	s3,40(sp)
     584:	6161                	addi	sp,sp,80
     586:	8082                	ret

0000000000000588 <copyin>:
{
     588:	715d                	addi	sp,sp,-80
     58a:	e486                	sd	ra,72(sp)
     58c:	e0a2                	sd	s0,64(sp)
     58e:	fc26                	sd	s1,56(sp)
     590:	f84a                	sd	s2,48(sp)
     592:	f44e                	sd	s3,40(sp)
     594:	f052                	sd	s4,32(sp)
     596:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     598:	4785                	li	a5,1
     59a:	07fe                	slli	a5,a5,0x1f
     59c:	fcf43023          	sd	a5,-64(s0)
     5a0:	57fd                	li	a5,-1
     5a2:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     5a6:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5aa:	00006a17          	auipc	s4,0x6
     5ae:	796a0a13          	addi	s4,s4,1942 # 6d40 <malloc+0x256>
    uint64 addr = addrs[ai];
     5b2:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     5b6:	20100593          	li	a1,513
     5ba:	8552                	mv	a0,s4
     5bc:	00006097          	auipc	ra,0x6
     5c0:	110080e7          	jalr	272(ra) # 66cc <open>
     5c4:	84aa                	mv	s1,a0
    if(fd < 0){
     5c6:	08054863          	bltz	a0,656 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     5ca:	6609                	lui	a2,0x2
     5cc:	85ce                	mv	a1,s3
     5ce:	00006097          	auipc	ra,0x6
     5d2:	0de080e7          	jalr	222(ra) # 66ac <write>
    if(n >= 0){
     5d6:	0a055163          	bgez	a0,678 <copyin+0xf0>
    close(fd);
     5da:	8526                	mv	a0,s1
     5dc:	00006097          	auipc	ra,0x6
     5e0:	0d8080e7          	jalr	216(ra) # 66b4 <close>
    unlink("copyin1");
     5e4:	8552                	mv	a0,s4
     5e6:	00006097          	auipc	ra,0x6
     5ea:	0f6080e7          	jalr	246(ra) # 66dc <unlink>
    n = write(1, (char*)addr, 8192);
     5ee:	6609                	lui	a2,0x2
     5f0:	85ce                	mv	a1,s3
     5f2:	4505                	li	a0,1
     5f4:	00006097          	auipc	ra,0x6
     5f8:	0b8080e7          	jalr	184(ra) # 66ac <write>
    if(n > 0){
     5fc:	0aa04163          	bgtz	a0,69e <copyin+0x116>
    if(pipe(fds) < 0){
     600:	fb840513          	addi	a0,s0,-72
     604:	00006097          	auipc	ra,0x6
     608:	098080e7          	jalr	152(ra) # 669c <pipe>
     60c:	0a054c63          	bltz	a0,6c4 <copyin+0x13c>
    n = write(fds[1], (char*)addr, 8192);
     610:	6609                	lui	a2,0x2
     612:	85ce                	mv	a1,s3
     614:	fbc42503          	lw	a0,-68(s0)
     618:	00006097          	auipc	ra,0x6
     61c:	094080e7          	jalr	148(ra) # 66ac <write>
    if(n > 0){
     620:	0ca04363          	bgtz	a0,6e6 <copyin+0x15e>
    close(fds[0]);
     624:	fb842503          	lw	a0,-72(s0)
     628:	00006097          	auipc	ra,0x6
     62c:	08c080e7          	jalr	140(ra) # 66b4 <close>
    close(fds[1]);
     630:	fbc42503          	lw	a0,-68(s0)
     634:	00006097          	auipc	ra,0x6
     638:	080080e7          	jalr	128(ra) # 66b4 <close>
  for(int ai = 0; ai < 2; ai++){
     63c:	0921                	addi	s2,s2,8
     63e:	fd040793          	addi	a5,s0,-48
     642:	f6f918e3          	bne	s2,a5,5b2 <copyin+0x2a>
}
     646:	60a6                	ld	ra,72(sp)
     648:	6406                	ld	s0,64(sp)
     64a:	74e2                	ld	s1,56(sp)
     64c:	7942                	ld	s2,48(sp)
     64e:	79a2                	ld	s3,40(sp)
     650:	7a02                	ld	s4,32(sp)
     652:	6161                	addi	sp,sp,80
     654:	8082                	ret
      printf("open(copyin1) failed\n");
     656:	00006517          	auipc	a0,0x6
     65a:	6f250513          	addi	a0,a0,1778 # 6d48 <malloc+0x25e>
     65e:	00006097          	auipc	ra,0x6
     662:	3ce080e7          	jalr	974(ra) # 6a2c <printf>
      exit(1,"");
     666:	00008597          	auipc	a1,0x8
     66a:	bb258593          	addi	a1,a1,-1102 # 8218 <malloc+0x172e>
     66e:	4505                	li	a0,1
     670:	00006097          	auipc	ra,0x6
     674:	01c080e7          	jalr	28(ra) # 668c <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     678:	862a                	mv	a2,a0
     67a:	85ce                	mv	a1,s3
     67c:	00006517          	auipc	a0,0x6
     680:	6e450513          	addi	a0,a0,1764 # 6d60 <malloc+0x276>
     684:	00006097          	auipc	ra,0x6
     688:	3a8080e7          	jalr	936(ra) # 6a2c <printf>
      exit(1,"");
     68c:	00008597          	auipc	a1,0x8
     690:	b8c58593          	addi	a1,a1,-1140 # 8218 <malloc+0x172e>
     694:	4505                	li	a0,1
     696:	00006097          	auipc	ra,0x6
     69a:	ff6080e7          	jalr	-10(ra) # 668c <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     69e:	862a                	mv	a2,a0
     6a0:	85ce                	mv	a1,s3
     6a2:	00006517          	auipc	a0,0x6
     6a6:	6ee50513          	addi	a0,a0,1774 # 6d90 <malloc+0x2a6>
     6aa:	00006097          	auipc	ra,0x6
     6ae:	382080e7          	jalr	898(ra) # 6a2c <printf>
      exit(1,"");
     6b2:	00008597          	auipc	a1,0x8
     6b6:	b6658593          	addi	a1,a1,-1178 # 8218 <malloc+0x172e>
     6ba:	4505                	li	a0,1
     6bc:	00006097          	auipc	ra,0x6
     6c0:	fd0080e7          	jalr	-48(ra) # 668c <exit>
      printf("pipe() failed\n");
     6c4:	00006517          	auipc	a0,0x6
     6c8:	6fc50513          	addi	a0,a0,1788 # 6dc0 <malloc+0x2d6>
     6cc:	00006097          	auipc	ra,0x6
     6d0:	360080e7          	jalr	864(ra) # 6a2c <printf>
      exit(1,"");
     6d4:	00008597          	auipc	a1,0x8
     6d8:	b4458593          	addi	a1,a1,-1212 # 8218 <malloc+0x172e>
     6dc:	4505                	li	a0,1
     6de:	00006097          	auipc	ra,0x6
     6e2:	fae080e7          	jalr	-82(ra) # 668c <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     6e6:	862a                	mv	a2,a0
     6e8:	85ce                	mv	a1,s3
     6ea:	00006517          	auipc	a0,0x6
     6ee:	6e650513          	addi	a0,a0,1766 # 6dd0 <malloc+0x2e6>
     6f2:	00006097          	auipc	ra,0x6
     6f6:	33a080e7          	jalr	826(ra) # 6a2c <printf>
      exit(1,"");
     6fa:	00008597          	auipc	a1,0x8
     6fe:	b1e58593          	addi	a1,a1,-1250 # 8218 <malloc+0x172e>
     702:	4505                	li	a0,1
     704:	00006097          	auipc	ra,0x6
     708:	f88080e7          	jalr	-120(ra) # 668c <exit>

000000000000070c <copyout>:
{
     70c:	711d                	addi	sp,sp,-96
     70e:	ec86                	sd	ra,88(sp)
     710:	e8a2                	sd	s0,80(sp)
     712:	e4a6                	sd	s1,72(sp)
     714:	e0ca                	sd	s2,64(sp)
     716:	fc4e                	sd	s3,56(sp)
     718:	f852                	sd	s4,48(sp)
     71a:	f456                	sd	s5,40(sp)
     71c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     71e:	4785                	li	a5,1
     720:	07fe                	slli	a5,a5,0x1f
     722:	faf43823          	sd	a5,-80(s0)
     726:	57fd                	li	a5,-1
     728:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     72c:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     730:	00006a17          	auipc	s4,0x6
     734:	6d0a0a13          	addi	s4,s4,1744 # 6e00 <malloc+0x316>
    n = write(fds[1], "x", 1);
     738:	00006a97          	auipc	s5,0x6
     73c:	560a8a93          	addi	s5,s5,1376 # 6c98 <malloc+0x1ae>
    uint64 addr = addrs[ai];
     740:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     744:	4581                	li	a1,0
     746:	8552                	mv	a0,s4
     748:	00006097          	auipc	ra,0x6
     74c:	f84080e7          	jalr	-124(ra) # 66cc <open>
     750:	84aa                	mv	s1,a0
    if(fd < 0){
     752:	08054663          	bltz	a0,7de <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     756:	6609                	lui	a2,0x2
     758:	85ce                	mv	a1,s3
     75a:	00006097          	auipc	ra,0x6
     75e:	f4a080e7          	jalr	-182(ra) # 66a4 <read>
    if(n > 0){
     762:	08a04f63          	bgtz	a0,800 <copyout+0xf4>
    close(fd);
     766:	8526                	mv	a0,s1
     768:	00006097          	auipc	ra,0x6
     76c:	f4c080e7          	jalr	-180(ra) # 66b4 <close>
    if(pipe(fds) < 0){
     770:	fa840513          	addi	a0,s0,-88
     774:	00006097          	auipc	ra,0x6
     778:	f28080e7          	jalr	-216(ra) # 669c <pipe>
     77c:	0a054563          	bltz	a0,826 <copyout+0x11a>
    n = write(fds[1], "x", 1);
     780:	4605                	li	a2,1
     782:	85d6                	mv	a1,s5
     784:	fac42503          	lw	a0,-84(s0)
     788:	00006097          	auipc	ra,0x6
     78c:	f24080e7          	jalr	-220(ra) # 66ac <write>
    if(n != 1){
     790:	4785                	li	a5,1
     792:	0af51b63          	bne	a0,a5,848 <copyout+0x13c>
    n = read(fds[0], (void*)addr, 8192);
     796:	6609                	lui	a2,0x2
     798:	85ce                	mv	a1,s3
     79a:	fa842503          	lw	a0,-88(s0)
     79e:	00006097          	auipc	ra,0x6
     7a2:	f06080e7          	jalr	-250(ra) # 66a4 <read>
    if(n > 0){
     7a6:	0ca04263          	bgtz	a0,86a <copyout+0x15e>
    close(fds[0]);
     7aa:	fa842503          	lw	a0,-88(s0)
     7ae:	00006097          	auipc	ra,0x6
     7b2:	f06080e7          	jalr	-250(ra) # 66b4 <close>
    close(fds[1]);
     7b6:	fac42503          	lw	a0,-84(s0)
     7ba:	00006097          	auipc	ra,0x6
     7be:	efa080e7          	jalr	-262(ra) # 66b4 <close>
  for(int ai = 0; ai < 2; ai++){
     7c2:	0921                	addi	s2,s2,8
     7c4:	fc040793          	addi	a5,s0,-64
     7c8:	f6f91ce3          	bne	s2,a5,740 <copyout+0x34>
}
     7cc:	60e6                	ld	ra,88(sp)
     7ce:	6446                	ld	s0,80(sp)
     7d0:	64a6                	ld	s1,72(sp)
     7d2:	6906                	ld	s2,64(sp)
     7d4:	79e2                	ld	s3,56(sp)
     7d6:	7a42                	ld	s4,48(sp)
     7d8:	7aa2                	ld	s5,40(sp)
     7da:	6125                	addi	sp,sp,96
     7dc:	8082                	ret
      printf("open(README) failed\n");
     7de:	00006517          	auipc	a0,0x6
     7e2:	62a50513          	addi	a0,a0,1578 # 6e08 <malloc+0x31e>
     7e6:	00006097          	auipc	ra,0x6
     7ea:	246080e7          	jalr	582(ra) # 6a2c <printf>
      exit(1,"");
     7ee:	00008597          	auipc	a1,0x8
     7f2:	a2a58593          	addi	a1,a1,-1494 # 8218 <malloc+0x172e>
     7f6:	4505                	li	a0,1
     7f8:	00006097          	auipc	ra,0x6
     7fc:	e94080e7          	jalr	-364(ra) # 668c <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     800:	862a                	mv	a2,a0
     802:	85ce                	mv	a1,s3
     804:	00006517          	auipc	a0,0x6
     808:	61c50513          	addi	a0,a0,1564 # 6e20 <malloc+0x336>
     80c:	00006097          	auipc	ra,0x6
     810:	220080e7          	jalr	544(ra) # 6a2c <printf>
      exit(1,"");
     814:	00008597          	auipc	a1,0x8
     818:	a0458593          	addi	a1,a1,-1532 # 8218 <malloc+0x172e>
     81c:	4505                	li	a0,1
     81e:	00006097          	auipc	ra,0x6
     822:	e6e080e7          	jalr	-402(ra) # 668c <exit>
      printf("pipe() failed\n");
     826:	00006517          	auipc	a0,0x6
     82a:	59a50513          	addi	a0,a0,1434 # 6dc0 <malloc+0x2d6>
     82e:	00006097          	auipc	ra,0x6
     832:	1fe080e7          	jalr	510(ra) # 6a2c <printf>
      exit(1,"");
     836:	00008597          	auipc	a1,0x8
     83a:	9e258593          	addi	a1,a1,-1566 # 8218 <malloc+0x172e>
     83e:	4505                	li	a0,1
     840:	00006097          	auipc	ra,0x6
     844:	e4c080e7          	jalr	-436(ra) # 668c <exit>
      printf("pipe write failed\n");
     848:	00006517          	auipc	a0,0x6
     84c:	60850513          	addi	a0,a0,1544 # 6e50 <malloc+0x366>
     850:	00006097          	auipc	ra,0x6
     854:	1dc080e7          	jalr	476(ra) # 6a2c <printf>
      exit(1,"");
     858:	00008597          	auipc	a1,0x8
     85c:	9c058593          	addi	a1,a1,-1600 # 8218 <malloc+0x172e>
     860:	4505                	li	a0,1
     862:	00006097          	auipc	ra,0x6
     866:	e2a080e7          	jalr	-470(ra) # 668c <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     86a:	862a                	mv	a2,a0
     86c:	85ce                	mv	a1,s3
     86e:	00006517          	auipc	a0,0x6
     872:	5fa50513          	addi	a0,a0,1530 # 6e68 <malloc+0x37e>
     876:	00006097          	auipc	ra,0x6
     87a:	1b6080e7          	jalr	438(ra) # 6a2c <printf>
      exit(1,"");
     87e:	00008597          	auipc	a1,0x8
     882:	99a58593          	addi	a1,a1,-1638 # 8218 <malloc+0x172e>
     886:	4505                	li	a0,1
     888:	00006097          	auipc	ra,0x6
     88c:	e04080e7          	jalr	-508(ra) # 668c <exit>

0000000000000890 <truncate1>:
{
     890:	711d                	addi	sp,sp,-96
     892:	ec86                	sd	ra,88(sp)
     894:	e8a2                	sd	s0,80(sp)
     896:	e4a6                	sd	s1,72(sp)
     898:	e0ca                	sd	s2,64(sp)
     89a:	fc4e                	sd	s3,56(sp)
     89c:	f852                	sd	s4,48(sp)
     89e:	f456                	sd	s5,40(sp)
     8a0:	1080                	addi	s0,sp,96
     8a2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     8a4:	00006517          	auipc	a0,0x6
     8a8:	3dc50513          	addi	a0,a0,988 # 6c80 <malloc+0x196>
     8ac:	00006097          	auipc	ra,0x6
     8b0:	e30080e7          	jalr	-464(ra) # 66dc <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     8b4:	60100593          	li	a1,1537
     8b8:	00006517          	auipc	a0,0x6
     8bc:	3c850513          	addi	a0,a0,968 # 6c80 <malloc+0x196>
     8c0:	00006097          	auipc	ra,0x6
     8c4:	e0c080e7          	jalr	-500(ra) # 66cc <open>
     8c8:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     8ca:	4611                	li	a2,4
     8cc:	00006597          	auipc	a1,0x6
     8d0:	3c458593          	addi	a1,a1,964 # 6c90 <malloc+0x1a6>
     8d4:	00006097          	auipc	ra,0x6
     8d8:	dd8080e7          	jalr	-552(ra) # 66ac <write>
  close(fd1);
     8dc:	8526                	mv	a0,s1
     8de:	00006097          	auipc	ra,0x6
     8e2:	dd6080e7          	jalr	-554(ra) # 66b4 <close>
  int fd2 = open("truncfile", O_RDONLY);
     8e6:	4581                	li	a1,0
     8e8:	00006517          	auipc	a0,0x6
     8ec:	39850513          	addi	a0,a0,920 # 6c80 <malloc+0x196>
     8f0:	00006097          	auipc	ra,0x6
     8f4:	ddc080e7          	jalr	-548(ra) # 66cc <open>
     8f8:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     8fa:	02000613          	li	a2,32
     8fe:	fa040593          	addi	a1,s0,-96
     902:	00006097          	auipc	ra,0x6
     906:	da2080e7          	jalr	-606(ra) # 66a4 <read>
  if(n != 4){
     90a:	4791                	li	a5,4
     90c:	0cf51e63          	bne	a0,a5,9e8 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     910:	40100593          	li	a1,1025
     914:	00006517          	auipc	a0,0x6
     918:	36c50513          	addi	a0,a0,876 # 6c80 <malloc+0x196>
     91c:	00006097          	auipc	ra,0x6
     920:	db0080e7          	jalr	-592(ra) # 66cc <open>
     924:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     926:	4581                	li	a1,0
     928:	00006517          	auipc	a0,0x6
     92c:	35850513          	addi	a0,a0,856 # 6c80 <malloc+0x196>
     930:	00006097          	auipc	ra,0x6
     934:	d9c080e7          	jalr	-612(ra) # 66cc <open>
     938:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     93a:	02000613          	li	a2,32
     93e:	fa040593          	addi	a1,s0,-96
     942:	00006097          	auipc	ra,0x6
     946:	d62080e7          	jalr	-670(ra) # 66a4 <read>
     94a:	8a2a                	mv	s4,a0
  if(n != 0){
     94c:	e169                	bnez	a0,a0e <truncate1+0x17e>
  n = read(fd2, buf, sizeof(buf));
     94e:	02000613          	li	a2,32
     952:	fa040593          	addi	a1,s0,-96
     956:	8526                	mv	a0,s1
     958:	00006097          	auipc	ra,0x6
     95c:	d4c080e7          	jalr	-692(ra) # 66a4 <read>
     960:	8a2a                	mv	s4,a0
  if(n != 0){
     962:	e175                	bnez	a0,a46 <truncate1+0x1b6>
  write(fd1, "abcdef", 6);
     964:	4619                	li	a2,6
     966:	00006597          	auipc	a1,0x6
     96a:	59258593          	addi	a1,a1,1426 # 6ef8 <malloc+0x40e>
     96e:	854e                	mv	a0,s3
     970:	00006097          	auipc	ra,0x6
     974:	d3c080e7          	jalr	-708(ra) # 66ac <write>
  n = read(fd3, buf, sizeof(buf));
     978:	02000613          	li	a2,32
     97c:	fa040593          	addi	a1,s0,-96
     980:	854a                	mv	a0,s2
     982:	00006097          	auipc	ra,0x6
     986:	d22080e7          	jalr	-734(ra) # 66a4 <read>
  if(n != 6){
     98a:	4799                	li	a5,6
     98c:	0ef51963          	bne	a0,a5,a7e <truncate1+0x1ee>
  n = read(fd2, buf, sizeof(buf));
     990:	02000613          	li	a2,32
     994:	fa040593          	addi	a1,s0,-96
     998:	8526                	mv	a0,s1
     99a:	00006097          	auipc	ra,0x6
     99e:	d0a080e7          	jalr	-758(ra) # 66a4 <read>
  if(n != 2){
     9a2:	4789                	li	a5,2
     9a4:	10f51063          	bne	a0,a5,aa4 <truncate1+0x214>
  unlink("truncfile");
     9a8:	00006517          	auipc	a0,0x6
     9ac:	2d850513          	addi	a0,a0,728 # 6c80 <malloc+0x196>
     9b0:	00006097          	auipc	ra,0x6
     9b4:	d2c080e7          	jalr	-724(ra) # 66dc <unlink>
  close(fd1);
     9b8:	854e                	mv	a0,s3
     9ba:	00006097          	auipc	ra,0x6
     9be:	cfa080e7          	jalr	-774(ra) # 66b4 <close>
  close(fd2);
     9c2:	8526                	mv	a0,s1
     9c4:	00006097          	auipc	ra,0x6
     9c8:	cf0080e7          	jalr	-784(ra) # 66b4 <close>
  close(fd3);
     9cc:	854a                	mv	a0,s2
     9ce:	00006097          	auipc	ra,0x6
     9d2:	ce6080e7          	jalr	-794(ra) # 66b4 <close>
}
     9d6:	60e6                	ld	ra,88(sp)
     9d8:	6446                	ld	s0,80(sp)
     9da:	64a6                	ld	s1,72(sp)
     9dc:	6906                	ld	s2,64(sp)
     9de:	79e2                	ld	s3,56(sp)
     9e0:	7a42                	ld	s4,48(sp)
     9e2:	7aa2                	ld	s5,40(sp)
     9e4:	6125                	addi	sp,sp,96
     9e6:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     9e8:	862a                	mv	a2,a0
     9ea:	85d6                	mv	a1,s5
     9ec:	00006517          	auipc	a0,0x6
     9f0:	4ac50513          	addi	a0,a0,1196 # 6e98 <malloc+0x3ae>
     9f4:	00006097          	auipc	ra,0x6
     9f8:	038080e7          	jalr	56(ra) # 6a2c <printf>
    exit(1,"");
     9fc:	00008597          	auipc	a1,0x8
     a00:	81c58593          	addi	a1,a1,-2020 # 8218 <malloc+0x172e>
     a04:	4505                	li	a0,1
     a06:	00006097          	auipc	ra,0x6
     a0a:	c86080e7          	jalr	-890(ra) # 668c <exit>
    printf("aaa fd3=%d\n", fd3);
     a0e:	85ca                	mv	a1,s2
     a10:	00006517          	auipc	a0,0x6
     a14:	4a850513          	addi	a0,a0,1192 # 6eb8 <malloc+0x3ce>
     a18:	00006097          	auipc	ra,0x6
     a1c:	014080e7          	jalr	20(ra) # 6a2c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a20:	8652                	mv	a2,s4
     a22:	85d6                	mv	a1,s5
     a24:	00006517          	auipc	a0,0x6
     a28:	4a450513          	addi	a0,a0,1188 # 6ec8 <malloc+0x3de>
     a2c:	00006097          	auipc	ra,0x6
     a30:	000080e7          	jalr	ra # 6a2c <printf>
    exit(1,"");
     a34:	00007597          	auipc	a1,0x7
     a38:	7e458593          	addi	a1,a1,2020 # 8218 <malloc+0x172e>
     a3c:	4505                	li	a0,1
     a3e:	00006097          	auipc	ra,0x6
     a42:	c4e080e7          	jalr	-946(ra) # 668c <exit>
    printf("bbb fd2=%d\n", fd2);
     a46:	85a6                	mv	a1,s1
     a48:	00006517          	auipc	a0,0x6
     a4c:	4a050513          	addi	a0,a0,1184 # 6ee8 <malloc+0x3fe>
     a50:	00006097          	auipc	ra,0x6
     a54:	fdc080e7          	jalr	-36(ra) # 6a2c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     a58:	8652                	mv	a2,s4
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	46c50513          	addi	a0,a0,1132 # 6ec8 <malloc+0x3de>
     a64:	00006097          	auipc	ra,0x6
     a68:	fc8080e7          	jalr	-56(ra) # 6a2c <printf>
    exit(1,"");
     a6c:	00007597          	auipc	a1,0x7
     a70:	7ac58593          	addi	a1,a1,1964 # 8218 <malloc+0x172e>
     a74:	4505                	li	a0,1
     a76:	00006097          	auipc	ra,0x6
     a7a:	c16080e7          	jalr	-1002(ra) # 668c <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     a7e:	862a                	mv	a2,a0
     a80:	85d6                	mv	a1,s5
     a82:	00006517          	auipc	a0,0x6
     a86:	47e50513          	addi	a0,a0,1150 # 6f00 <malloc+0x416>
     a8a:	00006097          	auipc	ra,0x6
     a8e:	fa2080e7          	jalr	-94(ra) # 6a2c <printf>
    exit(1,"");
     a92:	00007597          	auipc	a1,0x7
     a96:	78658593          	addi	a1,a1,1926 # 8218 <malloc+0x172e>
     a9a:	4505                	li	a0,1
     a9c:	00006097          	auipc	ra,0x6
     aa0:	bf0080e7          	jalr	-1040(ra) # 668c <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     aa4:	862a                	mv	a2,a0
     aa6:	85d6                	mv	a1,s5
     aa8:	00006517          	auipc	a0,0x6
     aac:	47850513          	addi	a0,a0,1144 # 6f20 <malloc+0x436>
     ab0:	00006097          	auipc	ra,0x6
     ab4:	f7c080e7          	jalr	-132(ra) # 6a2c <printf>
    exit(1,"");
     ab8:	00007597          	auipc	a1,0x7
     abc:	76058593          	addi	a1,a1,1888 # 8218 <malloc+0x172e>
     ac0:	4505                	li	a0,1
     ac2:	00006097          	auipc	ra,0x6
     ac6:	bca080e7          	jalr	-1078(ra) # 668c <exit>

0000000000000aca <writetest>:
{
     aca:	7139                	addi	sp,sp,-64
     acc:	fc06                	sd	ra,56(sp)
     ace:	f822                	sd	s0,48(sp)
     ad0:	f426                	sd	s1,40(sp)
     ad2:	f04a                	sd	s2,32(sp)
     ad4:	ec4e                	sd	s3,24(sp)
     ad6:	e852                	sd	s4,16(sp)
     ad8:	e456                	sd	s5,8(sp)
     ada:	e05a                	sd	s6,0(sp)
     adc:	0080                	addi	s0,sp,64
     ade:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     ae0:	20200593          	li	a1,514
     ae4:	00006517          	auipc	a0,0x6
     ae8:	45c50513          	addi	a0,a0,1116 # 6f40 <malloc+0x456>
     aec:	00006097          	auipc	ra,0x6
     af0:	be0080e7          	jalr	-1056(ra) # 66cc <open>
  if(fd < 0){
     af4:	0a054d63          	bltz	a0,bae <writetest+0xe4>
     af8:	892a                	mv	s2,a0
     afa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     afc:	00006997          	auipc	s3,0x6
     b00:	46c98993          	addi	s3,s3,1132 # 6f68 <malloc+0x47e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     b04:	00006a97          	auipc	s5,0x6
     b08:	49ca8a93          	addi	s5,s5,1180 # 6fa0 <malloc+0x4b6>
  for(i = 0; i < N; i++){
     b0c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     b10:	4629                	li	a2,10
     b12:	85ce                	mv	a1,s3
     b14:	854a                	mv	a0,s2
     b16:	00006097          	auipc	ra,0x6
     b1a:	b96080e7          	jalr	-1130(ra) # 66ac <write>
     b1e:	47a9                	li	a5,10
     b20:	0af51963          	bne	a0,a5,bd2 <writetest+0x108>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     b24:	4629                	li	a2,10
     b26:	85d6                	mv	a1,s5
     b28:	854a                	mv	a0,s2
     b2a:	00006097          	auipc	ra,0x6
     b2e:	b82080e7          	jalr	-1150(ra) # 66ac <write>
     b32:	47a9                	li	a5,10
     b34:	0cf51263          	bne	a0,a5,bf8 <writetest+0x12e>
  for(i = 0; i < N; i++){
     b38:	2485                	addiw	s1,s1,1
     b3a:	fd449be3          	bne	s1,s4,b10 <writetest+0x46>
  close(fd);
     b3e:	854a                	mv	a0,s2
     b40:	00006097          	auipc	ra,0x6
     b44:	b74080e7          	jalr	-1164(ra) # 66b4 <close>
  fd = open("small", O_RDONLY);
     b48:	4581                	li	a1,0
     b4a:	00006517          	auipc	a0,0x6
     b4e:	3f650513          	addi	a0,a0,1014 # 6f40 <malloc+0x456>
     b52:	00006097          	auipc	ra,0x6
     b56:	b7a080e7          	jalr	-1158(ra) # 66cc <open>
     b5a:	84aa                	mv	s1,a0
  if(fd < 0){
     b5c:	0c054163          	bltz	a0,c1e <writetest+0x154>
  i = read(fd, buf, N*SZ*2);
     b60:	7d000613          	li	a2,2000
     b64:	0000d597          	auipc	a1,0xd
     b68:	11458593          	addi	a1,a1,276 # dc78 <buf>
     b6c:	00006097          	auipc	ra,0x6
     b70:	b38080e7          	jalr	-1224(ra) # 66a4 <read>
  if(i != N*SZ*2){
     b74:	7d000793          	li	a5,2000
     b78:	0cf51563          	bne	a0,a5,c42 <writetest+0x178>
  close(fd);
     b7c:	8526                	mv	a0,s1
     b7e:	00006097          	auipc	ra,0x6
     b82:	b36080e7          	jalr	-1226(ra) # 66b4 <close>
  if(unlink("small") < 0){
     b86:	00006517          	auipc	a0,0x6
     b8a:	3ba50513          	addi	a0,a0,954 # 6f40 <malloc+0x456>
     b8e:	00006097          	auipc	ra,0x6
     b92:	b4e080e7          	jalr	-1202(ra) # 66dc <unlink>
     b96:	0c054863          	bltz	a0,c66 <writetest+0x19c>
}
     b9a:	70e2                	ld	ra,56(sp)
     b9c:	7442                	ld	s0,48(sp)
     b9e:	74a2                	ld	s1,40(sp)
     ba0:	7902                	ld	s2,32(sp)
     ba2:	69e2                	ld	s3,24(sp)
     ba4:	6a42                	ld	s4,16(sp)
     ba6:	6aa2                	ld	s5,8(sp)
     ba8:	6b02                	ld	s6,0(sp)
     baa:	6121                	addi	sp,sp,64
     bac:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     bae:	85da                	mv	a1,s6
     bb0:	00006517          	auipc	a0,0x6
     bb4:	39850513          	addi	a0,a0,920 # 6f48 <malloc+0x45e>
     bb8:	00006097          	auipc	ra,0x6
     bbc:	e74080e7          	jalr	-396(ra) # 6a2c <printf>
    exit(1,"");
     bc0:	00007597          	auipc	a1,0x7
     bc4:	65858593          	addi	a1,a1,1624 # 8218 <malloc+0x172e>
     bc8:	4505                	li	a0,1
     bca:	00006097          	auipc	ra,0x6
     bce:	ac2080e7          	jalr	-1342(ra) # 668c <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     bd2:	8626                	mv	a2,s1
     bd4:	85da                	mv	a1,s6
     bd6:	00006517          	auipc	a0,0x6
     bda:	3a250513          	addi	a0,a0,930 # 6f78 <malloc+0x48e>
     bde:	00006097          	auipc	ra,0x6
     be2:	e4e080e7          	jalr	-434(ra) # 6a2c <printf>
      exit(1,"");
     be6:	00007597          	auipc	a1,0x7
     bea:	63258593          	addi	a1,a1,1586 # 8218 <malloc+0x172e>
     bee:	4505                	li	a0,1
     bf0:	00006097          	auipc	ra,0x6
     bf4:	a9c080e7          	jalr	-1380(ra) # 668c <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     bf8:	8626                	mv	a2,s1
     bfa:	85da                	mv	a1,s6
     bfc:	00006517          	auipc	a0,0x6
     c00:	3b450513          	addi	a0,a0,948 # 6fb0 <malloc+0x4c6>
     c04:	00006097          	auipc	ra,0x6
     c08:	e28080e7          	jalr	-472(ra) # 6a2c <printf>
      exit(1,"");
     c0c:	00007597          	auipc	a1,0x7
     c10:	60c58593          	addi	a1,a1,1548 # 8218 <malloc+0x172e>
     c14:	4505                	li	a0,1
     c16:	00006097          	auipc	ra,0x6
     c1a:	a76080e7          	jalr	-1418(ra) # 668c <exit>
    printf("%s: error: open small failed!\n", s);
     c1e:	85da                	mv	a1,s6
     c20:	00006517          	auipc	a0,0x6
     c24:	3b850513          	addi	a0,a0,952 # 6fd8 <malloc+0x4ee>
     c28:	00006097          	auipc	ra,0x6
     c2c:	e04080e7          	jalr	-508(ra) # 6a2c <printf>
    exit(1,"");
     c30:	00007597          	auipc	a1,0x7
     c34:	5e858593          	addi	a1,a1,1512 # 8218 <malloc+0x172e>
     c38:	4505                	li	a0,1
     c3a:	00006097          	auipc	ra,0x6
     c3e:	a52080e7          	jalr	-1454(ra) # 668c <exit>
    printf("%s: read failed\n", s);
     c42:	85da                	mv	a1,s6
     c44:	00006517          	auipc	a0,0x6
     c48:	3b450513          	addi	a0,a0,948 # 6ff8 <malloc+0x50e>
     c4c:	00006097          	auipc	ra,0x6
     c50:	de0080e7          	jalr	-544(ra) # 6a2c <printf>
    exit(1,"");
     c54:	00007597          	auipc	a1,0x7
     c58:	5c458593          	addi	a1,a1,1476 # 8218 <malloc+0x172e>
     c5c:	4505                	li	a0,1
     c5e:	00006097          	auipc	ra,0x6
     c62:	a2e080e7          	jalr	-1490(ra) # 668c <exit>
    printf("%s: unlink small failed\n", s);
     c66:	85da                	mv	a1,s6
     c68:	00006517          	auipc	a0,0x6
     c6c:	3a850513          	addi	a0,a0,936 # 7010 <malloc+0x526>
     c70:	00006097          	auipc	ra,0x6
     c74:	dbc080e7          	jalr	-580(ra) # 6a2c <printf>
    exit(1,"");
     c78:	00007597          	auipc	a1,0x7
     c7c:	5a058593          	addi	a1,a1,1440 # 8218 <malloc+0x172e>
     c80:	4505                	li	a0,1
     c82:	00006097          	auipc	ra,0x6
     c86:	a0a080e7          	jalr	-1526(ra) # 668c <exit>

0000000000000c8a <writebig>:
{
     c8a:	7139                	addi	sp,sp,-64
     c8c:	fc06                	sd	ra,56(sp)
     c8e:	f822                	sd	s0,48(sp)
     c90:	f426                	sd	s1,40(sp)
     c92:	f04a                	sd	s2,32(sp)
     c94:	ec4e                	sd	s3,24(sp)
     c96:	e852                	sd	s4,16(sp)
     c98:	e456                	sd	s5,8(sp)
     c9a:	0080                	addi	s0,sp,64
     c9c:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     c9e:	20200593          	li	a1,514
     ca2:	00006517          	auipc	a0,0x6
     ca6:	38e50513          	addi	a0,a0,910 # 7030 <malloc+0x546>
     caa:	00006097          	auipc	ra,0x6
     cae:	a22080e7          	jalr	-1502(ra) # 66cc <open>
     cb2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     cb4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     cb6:	0000d917          	auipc	s2,0xd
     cba:	fc290913          	addi	s2,s2,-62 # dc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     cbe:	10c00a13          	li	s4,268
  if(fd < 0){
     cc2:	06054c63          	bltz	a0,d3a <writebig+0xb0>
    ((int*)buf)[0] = i;
     cc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     cca:	40000613          	li	a2,1024
     cce:	85ca                	mv	a1,s2
     cd0:	854e                	mv	a0,s3
     cd2:	00006097          	auipc	ra,0x6
     cd6:	9da080e7          	jalr	-1574(ra) # 66ac <write>
     cda:	40000793          	li	a5,1024
     cde:	08f51063          	bne	a0,a5,d5e <writebig+0xd4>
  for(i = 0; i < MAXFILE; i++){
     ce2:	2485                	addiw	s1,s1,1
     ce4:	ff4491e3          	bne	s1,s4,cc6 <writebig+0x3c>
  close(fd);
     ce8:	854e                	mv	a0,s3
     cea:	00006097          	auipc	ra,0x6
     cee:	9ca080e7          	jalr	-1590(ra) # 66b4 <close>
  fd = open("big", O_RDONLY);
     cf2:	4581                	li	a1,0
     cf4:	00006517          	auipc	a0,0x6
     cf8:	33c50513          	addi	a0,a0,828 # 7030 <malloc+0x546>
     cfc:	00006097          	auipc	ra,0x6
     d00:	9d0080e7          	jalr	-1584(ra) # 66cc <open>
     d04:	89aa                	mv	s3,a0
  n = 0;
     d06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     d08:	0000d917          	auipc	s2,0xd
     d0c:	f7090913          	addi	s2,s2,-144 # dc78 <buf>
  if(fd < 0){
     d10:	06054a63          	bltz	a0,d84 <writebig+0xfa>
    i = read(fd, buf, BSIZE);
     d14:	40000613          	li	a2,1024
     d18:	85ca                	mv	a1,s2
     d1a:	854e                	mv	a0,s3
     d1c:	00006097          	auipc	ra,0x6
     d20:	988080e7          	jalr	-1656(ra) # 66a4 <read>
    if(i == 0){
     d24:	c151                	beqz	a0,da8 <writebig+0x11e>
    } else if(i != BSIZE){
     d26:	40000793          	li	a5,1024
     d2a:	0cf51f63          	bne	a0,a5,e08 <writebig+0x17e>
    if(((int*)buf)[0] != n){
     d2e:	00092683          	lw	a3,0(s2)
     d32:	0e969e63          	bne	a3,s1,e2e <writebig+0x1a4>
    n++;
     d36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     d38:	bff1                	j	d14 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     d3a:	85d6                	mv	a1,s5
     d3c:	00006517          	auipc	a0,0x6
     d40:	2fc50513          	addi	a0,a0,764 # 7038 <malloc+0x54e>
     d44:	00006097          	auipc	ra,0x6
     d48:	ce8080e7          	jalr	-792(ra) # 6a2c <printf>
    exit(1,"");
     d4c:	00007597          	auipc	a1,0x7
     d50:	4cc58593          	addi	a1,a1,1228 # 8218 <malloc+0x172e>
     d54:	4505                	li	a0,1
     d56:	00006097          	auipc	ra,0x6
     d5a:	936080e7          	jalr	-1738(ra) # 668c <exit>
      printf("%s: error: write big file failed\n", s, i);
     d5e:	8626                	mv	a2,s1
     d60:	85d6                	mv	a1,s5
     d62:	00006517          	auipc	a0,0x6
     d66:	2f650513          	addi	a0,a0,758 # 7058 <malloc+0x56e>
     d6a:	00006097          	auipc	ra,0x6
     d6e:	cc2080e7          	jalr	-830(ra) # 6a2c <printf>
      exit(1,"");
     d72:	00007597          	auipc	a1,0x7
     d76:	4a658593          	addi	a1,a1,1190 # 8218 <malloc+0x172e>
     d7a:	4505                	li	a0,1
     d7c:	00006097          	auipc	ra,0x6
     d80:	910080e7          	jalr	-1776(ra) # 668c <exit>
    printf("%s: error: open big failed!\n", s);
     d84:	85d6                	mv	a1,s5
     d86:	00006517          	auipc	a0,0x6
     d8a:	2fa50513          	addi	a0,a0,762 # 7080 <malloc+0x596>
     d8e:	00006097          	auipc	ra,0x6
     d92:	c9e080e7          	jalr	-866(ra) # 6a2c <printf>
    exit(1,"");
     d96:	00007597          	auipc	a1,0x7
     d9a:	48258593          	addi	a1,a1,1154 # 8218 <malloc+0x172e>
     d9e:	4505                	li	a0,1
     da0:	00006097          	auipc	ra,0x6
     da4:	8ec080e7          	jalr	-1812(ra) # 668c <exit>
      if(n == MAXFILE - 1){
     da8:	10b00793          	li	a5,267
     dac:	02f48a63          	beq	s1,a5,de0 <writebig+0x156>
  close(fd);
     db0:	854e                	mv	a0,s3
     db2:	00006097          	auipc	ra,0x6
     db6:	902080e7          	jalr	-1790(ra) # 66b4 <close>
  if(unlink("big") < 0){
     dba:	00006517          	auipc	a0,0x6
     dbe:	27650513          	addi	a0,a0,630 # 7030 <malloc+0x546>
     dc2:	00006097          	auipc	ra,0x6
     dc6:	91a080e7          	jalr	-1766(ra) # 66dc <unlink>
     dca:	08054563          	bltz	a0,e54 <writebig+0x1ca>
}
     dce:	70e2                	ld	ra,56(sp)
     dd0:	7442                	ld	s0,48(sp)
     dd2:	74a2                	ld	s1,40(sp)
     dd4:	7902                	ld	s2,32(sp)
     dd6:	69e2                	ld	s3,24(sp)
     dd8:	6a42                	ld	s4,16(sp)
     dda:	6aa2                	ld	s5,8(sp)
     ddc:	6121                	addi	sp,sp,64
     dde:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     de0:	10b00613          	li	a2,267
     de4:	85d6                	mv	a1,s5
     de6:	00006517          	auipc	a0,0x6
     dea:	2ba50513          	addi	a0,a0,698 # 70a0 <malloc+0x5b6>
     dee:	00006097          	auipc	ra,0x6
     df2:	c3e080e7          	jalr	-962(ra) # 6a2c <printf>
        exit(1,"");
     df6:	00007597          	auipc	a1,0x7
     dfa:	42258593          	addi	a1,a1,1058 # 8218 <malloc+0x172e>
     dfe:	4505                	li	a0,1
     e00:	00006097          	auipc	ra,0x6
     e04:	88c080e7          	jalr	-1908(ra) # 668c <exit>
      printf("%s: read failed %d\n", s, i);
     e08:	862a                	mv	a2,a0
     e0a:	85d6                	mv	a1,s5
     e0c:	00006517          	auipc	a0,0x6
     e10:	2bc50513          	addi	a0,a0,700 # 70c8 <malloc+0x5de>
     e14:	00006097          	auipc	ra,0x6
     e18:	c18080e7          	jalr	-1000(ra) # 6a2c <printf>
      exit(1,"");
     e1c:	00007597          	auipc	a1,0x7
     e20:	3fc58593          	addi	a1,a1,1020 # 8218 <malloc+0x172e>
     e24:	4505                	li	a0,1
     e26:	00006097          	auipc	ra,0x6
     e2a:	866080e7          	jalr	-1946(ra) # 668c <exit>
      printf("%s: read content of block %d is %d\n", s,
     e2e:	8626                	mv	a2,s1
     e30:	85d6                	mv	a1,s5
     e32:	00006517          	auipc	a0,0x6
     e36:	2ae50513          	addi	a0,a0,686 # 70e0 <malloc+0x5f6>
     e3a:	00006097          	auipc	ra,0x6
     e3e:	bf2080e7          	jalr	-1038(ra) # 6a2c <printf>
      exit(1,"");
     e42:	00007597          	auipc	a1,0x7
     e46:	3d658593          	addi	a1,a1,982 # 8218 <malloc+0x172e>
     e4a:	4505                	li	a0,1
     e4c:	00006097          	auipc	ra,0x6
     e50:	840080e7          	jalr	-1984(ra) # 668c <exit>
    printf("%s: unlink big failed\n", s);
     e54:	85d6                	mv	a1,s5
     e56:	00006517          	auipc	a0,0x6
     e5a:	2b250513          	addi	a0,a0,690 # 7108 <malloc+0x61e>
     e5e:	00006097          	auipc	ra,0x6
     e62:	bce080e7          	jalr	-1074(ra) # 6a2c <printf>
    exit(1,"");
     e66:	00007597          	auipc	a1,0x7
     e6a:	3b258593          	addi	a1,a1,946 # 8218 <malloc+0x172e>
     e6e:	4505                	li	a0,1
     e70:	00006097          	auipc	ra,0x6
     e74:	81c080e7          	jalr	-2020(ra) # 668c <exit>

0000000000000e78 <unlinkread>:
{
     e78:	7179                	addi	sp,sp,-48
     e7a:	f406                	sd	ra,40(sp)
     e7c:	f022                	sd	s0,32(sp)
     e7e:	ec26                	sd	s1,24(sp)
     e80:	e84a                	sd	s2,16(sp)
     e82:	e44e                	sd	s3,8(sp)
     e84:	1800                	addi	s0,sp,48
     e86:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     e88:	20200593          	li	a1,514
     e8c:	00006517          	auipc	a0,0x6
     e90:	29450513          	addi	a0,a0,660 # 7120 <malloc+0x636>
     e94:	00006097          	auipc	ra,0x6
     e98:	838080e7          	jalr	-1992(ra) # 66cc <open>
  if(fd < 0){
     e9c:	0e054563          	bltz	a0,f86 <unlinkread+0x10e>
     ea0:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     ea2:	4615                	li	a2,5
     ea4:	00006597          	auipc	a1,0x6
     ea8:	2ac58593          	addi	a1,a1,684 # 7150 <malloc+0x666>
     eac:	00006097          	auipc	ra,0x6
     eb0:	800080e7          	jalr	-2048(ra) # 66ac <write>
  close(fd);
     eb4:	8526                	mv	a0,s1
     eb6:	00005097          	auipc	ra,0x5
     eba:	7fe080e7          	jalr	2046(ra) # 66b4 <close>
  fd = open("unlinkread", O_RDWR);
     ebe:	4589                	li	a1,2
     ec0:	00006517          	auipc	a0,0x6
     ec4:	26050513          	addi	a0,a0,608 # 7120 <malloc+0x636>
     ec8:	00006097          	auipc	ra,0x6
     ecc:	804080e7          	jalr	-2044(ra) # 66cc <open>
     ed0:	84aa                	mv	s1,a0
  if(fd < 0){
     ed2:	0c054c63          	bltz	a0,faa <unlinkread+0x132>
  if(unlink("unlinkread") != 0){
     ed6:	00006517          	auipc	a0,0x6
     eda:	24a50513          	addi	a0,a0,586 # 7120 <malloc+0x636>
     ede:	00005097          	auipc	ra,0x5
     ee2:	7fe080e7          	jalr	2046(ra) # 66dc <unlink>
     ee6:	e565                	bnez	a0,fce <unlinkread+0x156>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     ee8:	20200593          	li	a1,514
     eec:	00006517          	auipc	a0,0x6
     ef0:	23450513          	addi	a0,a0,564 # 7120 <malloc+0x636>
     ef4:	00005097          	auipc	ra,0x5
     ef8:	7d8080e7          	jalr	2008(ra) # 66cc <open>
     efc:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     efe:	460d                	li	a2,3
     f00:	00006597          	auipc	a1,0x6
     f04:	29858593          	addi	a1,a1,664 # 7198 <malloc+0x6ae>
     f08:	00005097          	auipc	ra,0x5
     f0c:	7a4080e7          	jalr	1956(ra) # 66ac <write>
  close(fd1);
     f10:	854a                	mv	a0,s2
     f12:	00005097          	auipc	ra,0x5
     f16:	7a2080e7          	jalr	1954(ra) # 66b4 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     f1a:	660d                	lui	a2,0x3
     f1c:	0000d597          	auipc	a1,0xd
     f20:	d5c58593          	addi	a1,a1,-676 # dc78 <buf>
     f24:	8526                	mv	a0,s1
     f26:	00005097          	auipc	ra,0x5
     f2a:	77e080e7          	jalr	1918(ra) # 66a4 <read>
     f2e:	4795                	li	a5,5
     f30:	0cf51163          	bne	a0,a5,ff2 <unlinkread+0x17a>
  if(buf[0] != 'h'){
     f34:	0000d717          	auipc	a4,0xd
     f38:	d4474703          	lbu	a4,-700(a4) # dc78 <buf>
     f3c:	06800793          	li	a5,104
     f40:	0cf71b63          	bne	a4,a5,1016 <unlinkread+0x19e>
  if(write(fd, buf, 10) != 10){
     f44:	4629                	li	a2,10
     f46:	0000d597          	auipc	a1,0xd
     f4a:	d3258593          	addi	a1,a1,-718 # dc78 <buf>
     f4e:	8526                	mv	a0,s1
     f50:	00005097          	auipc	ra,0x5
     f54:	75c080e7          	jalr	1884(ra) # 66ac <write>
     f58:	47a9                	li	a5,10
     f5a:	0ef51063          	bne	a0,a5,103a <unlinkread+0x1c2>
  close(fd);
     f5e:	8526                	mv	a0,s1
     f60:	00005097          	auipc	ra,0x5
     f64:	754080e7          	jalr	1876(ra) # 66b4 <close>
  unlink("unlinkread");
     f68:	00006517          	auipc	a0,0x6
     f6c:	1b850513          	addi	a0,a0,440 # 7120 <malloc+0x636>
     f70:	00005097          	auipc	ra,0x5
     f74:	76c080e7          	jalr	1900(ra) # 66dc <unlink>
}
     f78:	70a2                	ld	ra,40(sp)
     f7a:	7402                	ld	s0,32(sp)
     f7c:	64e2                	ld	s1,24(sp)
     f7e:	6942                	ld	s2,16(sp)
     f80:	69a2                	ld	s3,8(sp)
     f82:	6145                	addi	sp,sp,48
     f84:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     f86:	85ce                	mv	a1,s3
     f88:	00006517          	auipc	a0,0x6
     f8c:	1a850513          	addi	a0,a0,424 # 7130 <malloc+0x646>
     f90:	00006097          	auipc	ra,0x6
     f94:	a9c080e7          	jalr	-1380(ra) # 6a2c <printf>
    exit(1,"");
     f98:	00007597          	auipc	a1,0x7
     f9c:	28058593          	addi	a1,a1,640 # 8218 <malloc+0x172e>
     fa0:	4505                	li	a0,1
     fa2:	00005097          	auipc	ra,0x5
     fa6:	6ea080e7          	jalr	1770(ra) # 668c <exit>
    printf("%s: open unlinkread failed\n", s);
     faa:	85ce                	mv	a1,s3
     fac:	00006517          	auipc	a0,0x6
     fb0:	1ac50513          	addi	a0,a0,428 # 7158 <malloc+0x66e>
     fb4:	00006097          	auipc	ra,0x6
     fb8:	a78080e7          	jalr	-1416(ra) # 6a2c <printf>
    exit(1,"");
     fbc:	00007597          	auipc	a1,0x7
     fc0:	25c58593          	addi	a1,a1,604 # 8218 <malloc+0x172e>
     fc4:	4505                	li	a0,1
     fc6:	00005097          	auipc	ra,0x5
     fca:	6c6080e7          	jalr	1734(ra) # 668c <exit>
    printf("%s: unlink unlinkread failed\n", s);
     fce:	85ce                	mv	a1,s3
     fd0:	00006517          	auipc	a0,0x6
     fd4:	1a850513          	addi	a0,a0,424 # 7178 <malloc+0x68e>
     fd8:	00006097          	auipc	ra,0x6
     fdc:	a54080e7          	jalr	-1452(ra) # 6a2c <printf>
    exit(1,"");
     fe0:	00007597          	auipc	a1,0x7
     fe4:	23858593          	addi	a1,a1,568 # 8218 <malloc+0x172e>
     fe8:	4505                	li	a0,1
     fea:	00005097          	auipc	ra,0x5
     fee:	6a2080e7          	jalr	1698(ra) # 668c <exit>
    printf("%s: unlinkread read failed", s);
     ff2:	85ce                	mv	a1,s3
     ff4:	00006517          	auipc	a0,0x6
     ff8:	1ac50513          	addi	a0,a0,428 # 71a0 <malloc+0x6b6>
     ffc:	00006097          	auipc	ra,0x6
    1000:	a30080e7          	jalr	-1488(ra) # 6a2c <printf>
    exit(1,"");
    1004:	00007597          	auipc	a1,0x7
    1008:	21458593          	addi	a1,a1,532 # 8218 <malloc+0x172e>
    100c:	4505                	li	a0,1
    100e:	00005097          	auipc	ra,0x5
    1012:	67e080e7          	jalr	1662(ra) # 668c <exit>
    printf("%s: unlinkread wrong data\n", s);
    1016:	85ce                	mv	a1,s3
    1018:	00006517          	auipc	a0,0x6
    101c:	1a850513          	addi	a0,a0,424 # 71c0 <malloc+0x6d6>
    1020:	00006097          	auipc	ra,0x6
    1024:	a0c080e7          	jalr	-1524(ra) # 6a2c <printf>
    exit(1,"");
    1028:	00007597          	auipc	a1,0x7
    102c:	1f058593          	addi	a1,a1,496 # 8218 <malloc+0x172e>
    1030:	4505                	li	a0,1
    1032:	00005097          	auipc	ra,0x5
    1036:	65a080e7          	jalr	1626(ra) # 668c <exit>
    printf("%s: unlinkread write failed\n", s);
    103a:	85ce                	mv	a1,s3
    103c:	00006517          	auipc	a0,0x6
    1040:	1a450513          	addi	a0,a0,420 # 71e0 <malloc+0x6f6>
    1044:	00006097          	auipc	ra,0x6
    1048:	9e8080e7          	jalr	-1560(ra) # 6a2c <printf>
    exit(1,"");
    104c:	00007597          	auipc	a1,0x7
    1050:	1cc58593          	addi	a1,a1,460 # 8218 <malloc+0x172e>
    1054:	4505                	li	a0,1
    1056:	00005097          	auipc	ra,0x5
    105a:	636080e7          	jalr	1590(ra) # 668c <exit>

000000000000105e <linktest>:
{
    105e:	1101                	addi	sp,sp,-32
    1060:	ec06                	sd	ra,24(sp)
    1062:	e822                	sd	s0,16(sp)
    1064:	e426                	sd	s1,8(sp)
    1066:	e04a                	sd	s2,0(sp)
    1068:	1000                	addi	s0,sp,32
    106a:	892a                	mv	s2,a0
  unlink("lf1");
    106c:	00006517          	auipc	a0,0x6
    1070:	19450513          	addi	a0,a0,404 # 7200 <malloc+0x716>
    1074:	00005097          	auipc	ra,0x5
    1078:	668080e7          	jalr	1640(ra) # 66dc <unlink>
  unlink("lf2");
    107c:	00006517          	auipc	a0,0x6
    1080:	18c50513          	addi	a0,a0,396 # 7208 <malloc+0x71e>
    1084:	00005097          	auipc	ra,0x5
    1088:	658080e7          	jalr	1624(ra) # 66dc <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    108c:	20200593          	li	a1,514
    1090:	00006517          	auipc	a0,0x6
    1094:	17050513          	addi	a0,a0,368 # 7200 <malloc+0x716>
    1098:	00005097          	auipc	ra,0x5
    109c:	634080e7          	jalr	1588(ra) # 66cc <open>
  if(fd < 0){
    10a0:	10054763          	bltz	a0,11ae <linktest+0x150>
    10a4:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    10a6:	4615                	li	a2,5
    10a8:	00006597          	auipc	a1,0x6
    10ac:	0a858593          	addi	a1,a1,168 # 7150 <malloc+0x666>
    10b0:	00005097          	auipc	ra,0x5
    10b4:	5fc080e7          	jalr	1532(ra) # 66ac <write>
    10b8:	4795                	li	a5,5
    10ba:	10f51c63          	bne	a0,a5,11d2 <linktest+0x174>
  close(fd);
    10be:	8526                	mv	a0,s1
    10c0:	00005097          	auipc	ra,0x5
    10c4:	5f4080e7          	jalr	1524(ra) # 66b4 <close>
  if(link("lf1", "lf2") < 0){
    10c8:	00006597          	auipc	a1,0x6
    10cc:	14058593          	addi	a1,a1,320 # 7208 <malloc+0x71e>
    10d0:	00006517          	auipc	a0,0x6
    10d4:	13050513          	addi	a0,a0,304 # 7200 <malloc+0x716>
    10d8:	00005097          	auipc	ra,0x5
    10dc:	614080e7          	jalr	1556(ra) # 66ec <link>
    10e0:	10054b63          	bltz	a0,11f6 <linktest+0x198>
  unlink("lf1");
    10e4:	00006517          	auipc	a0,0x6
    10e8:	11c50513          	addi	a0,a0,284 # 7200 <malloc+0x716>
    10ec:	00005097          	auipc	ra,0x5
    10f0:	5f0080e7          	jalr	1520(ra) # 66dc <unlink>
  if(open("lf1", 0) >= 0){
    10f4:	4581                	li	a1,0
    10f6:	00006517          	auipc	a0,0x6
    10fa:	10a50513          	addi	a0,a0,266 # 7200 <malloc+0x716>
    10fe:	00005097          	auipc	ra,0x5
    1102:	5ce080e7          	jalr	1486(ra) # 66cc <open>
    1106:	10055a63          	bgez	a0,121a <linktest+0x1bc>
  fd = open("lf2", 0);
    110a:	4581                	li	a1,0
    110c:	00006517          	auipc	a0,0x6
    1110:	0fc50513          	addi	a0,a0,252 # 7208 <malloc+0x71e>
    1114:	00005097          	auipc	ra,0x5
    1118:	5b8080e7          	jalr	1464(ra) # 66cc <open>
    111c:	84aa                	mv	s1,a0
  if(fd < 0){
    111e:	12054063          	bltz	a0,123e <linktest+0x1e0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1122:	660d                	lui	a2,0x3
    1124:	0000d597          	auipc	a1,0xd
    1128:	b5458593          	addi	a1,a1,-1196 # dc78 <buf>
    112c:	00005097          	auipc	ra,0x5
    1130:	578080e7          	jalr	1400(ra) # 66a4 <read>
    1134:	4795                	li	a5,5
    1136:	12f51663          	bne	a0,a5,1262 <linktest+0x204>
  close(fd);
    113a:	8526                	mv	a0,s1
    113c:	00005097          	auipc	ra,0x5
    1140:	578080e7          	jalr	1400(ra) # 66b4 <close>
  if(link("lf2", "lf2") >= 0){
    1144:	00006597          	auipc	a1,0x6
    1148:	0c458593          	addi	a1,a1,196 # 7208 <malloc+0x71e>
    114c:	852e                	mv	a0,a1
    114e:	00005097          	auipc	ra,0x5
    1152:	59e080e7          	jalr	1438(ra) # 66ec <link>
    1156:	12055863          	bgez	a0,1286 <linktest+0x228>
  unlink("lf2");
    115a:	00006517          	auipc	a0,0x6
    115e:	0ae50513          	addi	a0,a0,174 # 7208 <malloc+0x71e>
    1162:	00005097          	auipc	ra,0x5
    1166:	57a080e7          	jalr	1402(ra) # 66dc <unlink>
  if(link("lf2", "lf1") >= 0){
    116a:	00006597          	auipc	a1,0x6
    116e:	09658593          	addi	a1,a1,150 # 7200 <malloc+0x716>
    1172:	00006517          	auipc	a0,0x6
    1176:	09650513          	addi	a0,a0,150 # 7208 <malloc+0x71e>
    117a:	00005097          	auipc	ra,0x5
    117e:	572080e7          	jalr	1394(ra) # 66ec <link>
    1182:	12055463          	bgez	a0,12aa <linktest+0x24c>
  if(link(".", "lf1") >= 0){
    1186:	00006597          	auipc	a1,0x6
    118a:	07a58593          	addi	a1,a1,122 # 7200 <malloc+0x716>
    118e:	00006517          	auipc	a0,0x6
    1192:	18250513          	addi	a0,a0,386 # 7310 <malloc+0x826>
    1196:	00005097          	auipc	ra,0x5
    119a:	556080e7          	jalr	1366(ra) # 66ec <link>
    119e:	12055863          	bgez	a0,12ce <linktest+0x270>
}
    11a2:	60e2                	ld	ra,24(sp)
    11a4:	6442                	ld	s0,16(sp)
    11a6:	64a2                	ld	s1,8(sp)
    11a8:	6902                	ld	s2,0(sp)
    11aa:	6105                	addi	sp,sp,32
    11ac:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    11ae:	85ca                	mv	a1,s2
    11b0:	00006517          	auipc	a0,0x6
    11b4:	06050513          	addi	a0,a0,96 # 7210 <malloc+0x726>
    11b8:	00006097          	auipc	ra,0x6
    11bc:	874080e7          	jalr	-1932(ra) # 6a2c <printf>
    exit(1,"");
    11c0:	00007597          	auipc	a1,0x7
    11c4:	05858593          	addi	a1,a1,88 # 8218 <malloc+0x172e>
    11c8:	4505                	li	a0,1
    11ca:	00005097          	auipc	ra,0x5
    11ce:	4c2080e7          	jalr	1218(ra) # 668c <exit>
    printf("%s: write lf1 failed\n", s);
    11d2:	85ca                	mv	a1,s2
    11d4:	00006517          	auipc	a0,0x6
    11d8:	05450513          	addi	a0,a0,84 # 7228 <malloc+0x73e>
    11dc:	00006097          	auipc	ra,0x6
    11e0:	850080e7          	jalr	-1968(ra) # 6a2c <printf>
    exit(1,"");
    11e4:	00007597          	auipc	a1,0x7
    11e8:	03458593          	addi	a1,a1,52 # 8218 <malloc+0x172e>
    11ec:	4505                	li	a0,1
    11ee:	00005097          	auipc	ra,0x5
    11f2:	49e080e7          	jalr	1182(ra) # 668c <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    11f6:	85ca                	mv	a1,s2
    11f8:	00006517          	auipc	a0,0x6
    11fc:	04850513          	addi	a0,a0,72 # 7240 <malloc+0x756>
    1200:	00006097          	auipc	ra,0x6
    1204:	82c080e7          	jalr	-2004(ra) # 6a2c <printf>
    exit(1,"");
    1208:	00007597          	auipc	a1,0x7
    120c:	01058593          	addi	a1,a1,16 # 8218 <malloc+0x172e>
    1210:	4505                	li	a0,1
    1212:	00005097          	auipc	ra,0x5
    1216:	47a080e7          	jalr	1146(ra) # 668c <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    121a:	85ca                	mv	a1,s2
    121c:	00006517          	auipc	a0,0x6
    1220:	04450513          	addi	a0,a0,68 # 7260 <malloc+0x776>
    1224:	00006097          	auipc	ra,0x6
    1228:	808080e7          	jalr	-2040(ra) # 6a2c <printf>
    exit(1,"");
    122c:	00007597          	auipc	a1,0x7
    1230:	fec58593          	addi	a1,a1,-20 # 8218 <malloc+0x172e>
    1234:	4505                	li	a0,1
    1236:	00005097          	auipc	ra,0x5
    123a:	456080e7          	jalr	1110(ra) # 668c <exit>
    printf("%s: open lf2 failed\n", s);
    123e:	85ca                	mv	a1,s2
    1240:	00006517          	auipc	a0,0x6
    1244:	05050513          	addi	a0,a0,80 # 7290 <malloc+0x7a6>
    1248:	00005097          	auipc	ra,0x5
    124c:	7e4080e7          	jalr	2020(ra) # 6a2c <printf>
    exit(1,"");
    1250:	00007597          	auipc	a1,0x7
    1254:	fc858593          	addi	a1,a1,-56 # 8218 <malloc+0x172e>
    1258:	4505                	li	a0,1
    125a:	00005097          	auipc	ra,0x5
    125e:	432080e7          	jalr	1074(ra) # 668c <exit>
    printf("%s: read lf2 failed\n", s);
    1262:	85ca                	mv	a1,s2
    1264:	00006517          	auipc	a0,0x6
    1268:	04450513          	addi	a0,a0,68 # 72a8 <malloc+0x7be>
    126c:	00005097          	auipc	ra,0x5
    1270:	7c0080e7          	jalr	1984(ra) # 6a2c <printf>
    exit(1,"");
    1274:	00007597          	auipc	a1,0x7
    1278:	fa458593          	addi	a1,a1,-92 # 8218 <malloc+0x172e>
    127c:	4505                	li	a0,1
    127e:	00005097          	auipc	ra,0x5
    1282:	40e080e7          	jalr	1038(ra) # 668c <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    1286:	85ca                	mv	a1,s2
    1288:	00006517          	auipc	a0,0x6
    128c:	03850513          	addi	a0,a0,56 # 72c0 <malloc+0x7d6>
    1290:	00005097          	auipc	ra,0x5
    1294:	79c080e7          	jalr	1948(ra) # 6a2c <printf>
    exit(1,"");
    1298:	00007597          	auipc	a1,0x7
    129c:	f8058593          	addi	a1,a1,-128 # 8218 <malloc+0x172e>
    12a0:	4505                	li	a0,1
    12a2:	00005097          	auipc	ra,0x5
    12a6:	3ea080e7          	jalr	1002(ra) # 668c <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    12aa:	85ca                	mv	a1,s2
    12ac:	00006517          	auipc	a0,0x6
    12b0:	03c50513          	addi	a0,a0,60 # 72e8 <malloc+0x7fe>
    12b4:	00005097          	auipc	ra,0x5
    12b8:	778080e7          	jalr	1912(ra) # 6a2c <printf>
    exit(1,"");
    12bc:	00007597          	auipc	a1,0x7
    12c0:	f5c58593          	addi	a1,a1,-164 # 8218 <malloc+0x172e>
    12c4:	4505                	li	a0,1
    12c6:	00005097          	auipc	ra,0x5
    12ca:	3c6080e7          	jalr	966(ra) # 668c <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    12ce:	85ca                	mv	a1,s2
    12d0:	00006517          	auipc	a0,0x6
    12d4:	04850513          	addi	a0,a0,72 # 7318 <malloc+0x82e>
    12d8:	00005097          	auipc	ra,0x5
    12dc:	754080e7          	jalr	1876(ra) # 6a2c <printf>
    exit(1,"");
    12e0:	00007597          	auipc	a1,0x7
    12e4:	f3858593          	addi	a1,a1,-200 # 8218 <malloc+0x172e>
    12e8:	4505                	li	a0,1
    12ea:	00005097          	auipc	ra,0x5
    12ee:	3a2080e7          	jalr	930(ra) # 668c <exit>

00000000000012f2 <validatetest>:
{
    12f2:	7139                	addi	sp,sp,-64
    12f4:	fc06                	sd	ra,56(sp)
    12f6:	f822                	sd	s0,48(sp)
    12f8:	f426                	sd	s1,40(sp)
    12fa:	f04a                	sd	s2,32(sp)
    12fc:	ec4e                	sd	s3,24(sp)
    12fe:	e852                	sd	s4,16(sp)
    1300:	e456                	sd	s5,8(sp)
    1302:	e05a                	sd	s6,0(sp)
    1304:	0080                	addi	s0,sp,64
    1306:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1308:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    130a:	00006997          	auipc	s3,0x6
    130e:	02e98993          	addi	s3,s3,46 # 7338 <malloc+0x84e>
    1312:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1314:	6a85                	lui	s5,0x1
    1316:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    131a:	85a6                	mv	a1,s1
    131c:	854e                	mv	a0,s3
    131e:	00005097          	auipc	ra,0x5
    1322:	3ce080e7          	jalr	974(ra) # 66ec <link>
    1326:	01251f63          	bne	a0,s2,1344 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    132a:	94d6                	add	s1,s1,s5
    132c:	ff4497e3          	bne	s1,s4,131a <validatetest+0x28>
}
    1330:	70e2                	ld	ra,56(sp)
    1332:	7442                	ld	s0,48(sp)
    1334:	74a2                	ld	s1,40(sp)
    1336:	7902                	ld	s2,32(sp)
    1338:	69e2                	ld	s3,24(sp)
    133a:	6a42                	ld	s4,16(sp)
    133c:	6aa2                	ld	s5,8(sp)
    133e:	6b02                	ld	s6,0(sp)
    1340:	6121                	addi	sp,sp,64
    1342:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1344:	85da                	mv	a1,s6
    1346:	00006517          	auipc	a0,0x6
    134a:	00250513          	addi	a0,a0,2 # 7348 <malloc+0x85e>
    134e:	00005097          	auipc	ra,0x5
    1352:	6de080e7          	jalr	1758(ra) # 6a2c <printf>
      exit(1,"");
    1356:	00007597          	auipc	a1,0x7
    135a:	ec258593          	addi	a1,a1,-318 # 8218 <malloc+0x172e>
    135e:	4505                	li	a0,1
    1360:	00005097          	auipc	ra,0x5
    1364:	32c080e7          	jalr	812(ra) # 668c <exit>

0000000000001368 <bigdir>:
{
    1368:	715d                	addi	sp,sp,-80
    136a:	e486                	sd	ra,72(sp)
    136c:	e0a2                	sd	s0,64(sp)
    136e:	fc26                	sd	s1,56(sp)
    1370:	f84a                	sd	s2,48(sp)
    1372:	f44e                	sd	s3,40(sp)
    1374:	f052                	sd	s4,32(sp)
    1376:	ec56                	sd	s5,24(sp)
    1378:	e85a                	sd	s6,16(sp)
    137a:	0880                	addi	s0,sp,80
    137c:	89aa                	mv	s3,a0
  unlink("bd");
    137e:	00006517          	auipc	a0,0x6
    1382:	fea50513          	addi	a0,a0,-22 # 7368 <malloc+0x87e>
    1386:	00005097          	auipc	ra,0x5
    138a:	356080e7          	jalr	854(ra) # 66dc <unlink>
  fd = open("bd", O_CREATE);
    138e:	20000593          	li	a1,512
    1392:	00006517          	auipc	a0,0x6
    1396:	fd650513          	addi	a0,a0,-42 # 7368 <malloc+0x87e>
    139a:	00005097          	auipc	ra,0x5
    139e:	332080e7          	jalr	818(ra) # 66cc <open>
  if(fd < 0){
    13a2:	0c054963          	bltz	a0,1474 <bigdir+0x10c>
  close(fd);
    13a6:	00005097          	auipc	ra,0x5
    13aa:	30e080e7          	jalr	782(ra) # 66b4 <close>
  for(i = 0; i < N; i++){
    13ae:	4901                	li	s2,0
    name[0] = 'x';
    13b0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    13b4:	00006a17          	auipc	s4,0x6
    13b8:	fb4a0a13          	addi	s4,s4,-76 # 7368 <malloc+0x87e>
  for(i = 0; i < N; i++){
    13bc:	1f400b13          	li	s6,500
    name[0] = 'x';
    13c0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    13c4:	41f9579b          	sraiw	a5,s2,0x1f
    13c8:	01a7d71b          	srliw	a4,a5,0x1a
    13cc:	012707bb          	addw	a5,a4,s2
    13d0:	4067d69b          	sraiw	a3,a5,0x6
    13d4:	0306869b          	addiw	a3,a3,48
    13d8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    13dc:	03f7f793          	andi	a5,a5,63
    13e0:	9f99                	subw	a5,a5,a4
    13e2:	0307879b          	addiw	a5,a5,48
    13e6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    13ea:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    13ee:	fb040593          	addi	a1,s0,-80
    13f2:	8552                	mv	a0,s4
    13f4:	00005097          	auipc	ra,0x5
    13f8:	2f8080e7          	jalr	760(ra) # 66ec <link>
    13fc:	84aa                	mv	s1,a0
    13fe:	ed49                	bnez	a0,1498 <bigdir+0x130>
  for(i = 0; i < N; i++){
    1400:	2905                	addiw	s2,s2,1
    1402:	fb691fe3          	bne	s2,s6,13c0 <bigdir+0x58>
  unlink("bd");
    1406:	00006517          	auipc	a0,0x6
    140a:	f6250513          	addi	a0,a0,-158 # 7368 <malloc+0x87e>
    140e:	00005097          	auipc	ra,0x5
    1412:	2ce080e7          	jalr	718(ra) # 66dc <unlink>
    name[0] = 'x';
    1416:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    141a:	1f400a13          	li	s4,500
    name[0] = 'x';
    141e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1422:	41f4d79b          	sraiw	a5,s1,0x1f
    1426:	01a7d71b          	srliw	a4,a5,0x1a
    142a:	009707bb          	addw	a5,a4,s1
    142e:	4067d69b          	sraiw	a3,a5,0x6
    1432:	0306869b          	addiw	a3,a3,48
    1436:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    143a:	03f7f793          	andi	a5,a5,63
    143e:	9f99                	subw	a5,a5,a4
    1440:	0307879b          	addiw	a5,a5,48
    1444:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1448:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    144c:	fb040513          	addi	a0,s0,-80
    1450:	00005097          	auipc	ra,0x5
    1454:	28c080e7          	jalr	652(ra) # 66dc <unlink>
    1458:	e525                	bnez	a0,14c0 <bigdir+0x158>
  for(i = 0; i < N; i++){
    145a:	2485                	addiw	s1,s1,1
    145c:	fd4491e3          	bne	s1,s4,141e <bigdir+0xb6>
}
    1460:	60a6                	ld	ra,72(sp)
    1462:	6406                	ld	s0,64(sp)
    1464:	74e2                	ld	s1,56(sp)
    1466:	7942                	ld	s2,48(sp)
    1468:	79a2                	ld	s3,40(sp)
    146a:	7a02                	ld	s4,32(sp)
    146c:	6ae2                	ld	s5,24(sp)
    146e:	6b42                	ld	s6,16(sp)
    1470:	6161                	addi	sp,sp,80
    1472:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1474:	85ce                	mv	a1,s3
    1476:	00006517          	auipc	a0,0x6
    147a:	efa50513          	addi	a0,a0,-262 # 7370 <malloc+0x886>
    147e:	00005097          	auipc	ra,0x5
    1482:	5ae080e7          	jalr	1454(ra) # 6a2c <printf>
    exit(1,"");
    1486:	00007597          	auipc	a1,0x7
    148a:	d9258593          	addi	a1,a1,-622 # 8218 <malloc+0x172e>
    148e:	4505                	li	a0,1
    1490:	00005097          	auipc	ra,0x5
    1494:	1fc080e7          	jalr	508(ra) # 668c <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1498:	fb040613          	addi	a2,s0,-80
    149c:	85ce                	mv	a1,s3
    149e:	00006517          	auipc	a0,0x6
    14a2:	ef250513          	addi	a0,a0,-270 # 7390 <malloc+0x8a6>
    14a6:	00005097          	auipc	ra,0x5
    14aa:	586080e7          	jalr	1414(ra) # 6a2c <printf>
      exit(1,"");
    14ae:	00007597          	auipc	a1,0x7
    14b2:	d6a58593          	addi	a1,a1,-662 # 8218 <malloc+0x172e>
    14b6:	4505                	li	a0,1
    14b8:	00005097          	auipc	ra,0x5
    14bc:	1d4080e7          	jalr	468(ra) # 668c <exit>
      printf("%s: bigdir unlink failed", s);
    14c0:	85ce                	mv	a1,s3
    14c2:	00006517          	auipc	a0,0x6
    14c6:	eee50513          	addi	a0,a0,-274 # 73b0 <malloc+0x8c6>
    14ca:	00005097          	auipc	ra,0x5
    14ce:	562080e7          	jalr	1378(ra) # 6a2c <printf>
      exit(1,"");
    14d2:	00007597          	auipc	a1,0x7
    14d6:	d4658593          	addi	a1,a1,-698 # 8218 <malloc+0x172e>
    14da:	4505                	li	a0,1
    14dc:	00005097          	auipc	ra,0x5
    14e0:	1b0080e7          	jalr	432(ra) # 668c <exit>

00000000000014e4 <pgbug>:
{
    14e4:	7179                	addi	sp,sp,-48
    14e6:	f406                	sd	ra,40(sp)
    14e8:	f022                	sd	s0,32(sp)
    14ea:	ec26                	sd	s1,24(sp)
    14ec:	1800                	addi	s0,sp,48
  argv[0] = 0;
    14ee:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    14f2:	00009497          	auipc	s1,0x9
    14f6:	b0e48493          	addi	s1,s1,-1266 # a000 <big>
    14fa:	fd840593          	addi	a1,s0,-40
    14fe:	6088                	ld	a0,0(s1)
    1500:	00005097          	auipc	ra,0x5
    1504:	1c4080e7          	jalr	452(ra) # 66c4 <exec>
  pipe(big);
    1508:	6088                	ld	a0,0(s1)
    150a:	00005097          	auipc	ra,0x5
    150e:	192080e7          	jalr	402(ra) # 669c <pipe>
  exit(0,"");
    1512:	00007597          	auipc	a1,0x7
    1516:	d0658593          	addi	a1,a1,-762 # 8218 <malloc+0x172e>
    151a:	4501                	li	a0,0
    151c:	00005097          	auipc	ra,0x5
    1520:	170080e7          	jalr	368(ra) # 668c <exit>

0000000000001524 <badarg>:
{
    1524:	7139                	addi	sp,sp,-64
    1526:	fc06                	sd	ra,56(sp)
    1528:	f822                	sd	s0,48(sp)
    152a:	f426                	sd	s1,40(sp)
    152c:	f04a                	sd	s2,32(sp)
    152e:	ec4e                	sd	s3,24(sp)
    1530:	0080                	addi	s0,sp,64
    1532:	64b1                	lui	s1,0xc
    1534:	35048493          	addi	s1,s1,848 # c350 <uninit+0xde8>
    argv[0] = (char*)0xffffffff;
    1538:	597d                	li	s2,-1
    153a:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    153e:	00005997          	auipc	s3,0x5
    1542:	6ea98993          	addi	s3,s3,1770 # 6c28 <malloc+0x13e>
    argv[0] = (char*)0xffffffff;
    1546:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    154a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    154e:	fc040593          	addi	a1,s0,-64
    1552:	854e                	mv	a0,s3
    1554:	00005097          	auipc	ra,0x5
    1558:	170080e7          	jalr	368(ra) # 66c4 <exec>
  for(int i = 0; i < 50000; i++){
    155c:	34fd                	addiw	s1,s1,-1
    155e:	f4e5                	bnez	s1,1546 <badarg+0x22>
  exit(0,"");
    1560:	00007597          	auipc	a1,0x7
    1564:	cb858593          	addi	a1,a1,-840 # 8218 <malloc+0x172e>
    1568:	4501                	li	a0,0
    156a:	00005097          	auipc	ra,0x5
    156e:	122080e7          	jalr	290(ra) # 668c <exit>

0000000000001572 <copyinstr2>:
{
    1572:	7155                	addi	sp,sp,-208
    1574:	e586                	sd	ra,200(sp)
    1576:	e1a2                	sd	s0,192(sp)
    1578:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    157a:	f6840793          	addi	a5,s0,-152
    157e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1582:	07800713          	li	a4,120
    1586:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    158a:	0785                	addi	a5,a5,1
    158c:	fed79de3          	bne	a5,a3,1586 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1590:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1594:	f6840513          	addi	a0,s0,-152
    1598:	00005097          	auipc	ra,0x5
    159c:	144080e7          	jalr	324(ra) # 66dc <unlink>
  if(ret != -1){
    15a0:	57fd                	li	a5,-1
    15a2:	0ef51463          	bne	a0,a5,168a <copyinstr2+0x118>
  int fd = open(b, O_CREATE | O_WRONLY);
    15a6:	20100593          	li	a1,513
    15aa:	f6840513          	addi	a0,s0,-152
    15ae:	00005097          	auipc	ra,0x5
    15b2:	11e080e7          	jalr	286(ra) # 66cc <open>
  if(fd != -1){
    15b6:	57fd                	li	a5,-1
    15b8:	0ef51d63          	bne	a0,a5,16b2 <copyinstr2+0x140>
  ret = link(b, b);
    15bc:	f6840593          	addi	a1,s0,-152
    15c0:	852e                	mv	a0,a1
    15c2:	00005097          	auipc	ra,0x5
    15c6:	12a080e7          	jalr	298(ra) # 66ec <link>
  if(ret != -1){
    15ca:	57fd                	li	a5,-1
    15cc:	10f51763          	bne	a0,a5,16da <copyinstr2+0x168>
  char *args[] = { "xx", 0 };
    15d0:	00007797          	auipc	a5,0x7
    15d4:	03878793          	addi	a5,a5,56 # 8608 <malloc+0x1b1e>
    15d8:	f4f43c23          	sd	a5,-168(s0)
    15dc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    15e0:	f5840593          	addi	a1,s0,-168
    15e4:	f6840513          	addi	a0,s0,-152
    15e8:	00005097          	auipc	ra,0x5
    15ec:	0dc080e7          	jalr	220(ra) # 66c4 <exec>
  if(ret != -1){
    15f0:	57fd                	li	a5,-1
    15f2:	10f51963          	bne	a0,a5,1704 <copyinstr2+0x192>
  int pid = fork();
    15f6:	00005097          	auipc	ra,0x5
    15fa:	08e080e7          	jalr	142(ra) # 6684 <fork>
  if(pid < 0){
    15fe:	12054763          	bltz	a0,172c <copyinstr2+0x1ba>
  if(pid == 0){
    1602:	16051063          	bnez	a0,1762 <copyinstr2+0x1f0>
    1606:	00009797          	auipc	a5,0x9
    160a:	f5a78793          	addi	a5,a5,-166 # a560 <big.1279>
    160e:	0000a697          	auipc	a3,0xa
    1612:	f5268693          	addi	a3,a3,-174 # b560 <big.1279+0x1000>
      big[i] = 'x';
    1616:	07800713          	li	a4,120
    161a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    161e:	0785                	addi	a5,a5,1
    1620:	fed79de3          	bne	a5,a3,161a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1624:	0000a797          	auipc	a5,0xa
    1628:	f2078e23          	sb	zero,-196(a5) # b560 <big.1279+0x1000>
    char *args2[] = { big, big, big, 0 };
    162c:	00008797          	auipc	a5,0x8
    1630:	9fc78793          	addi	a5,a5,-1540 # 9028 <malloc+0x253e>
    1634:	6390                	ld	a2,0(a5)
    1636:	6794                	ld	a3,8(a5)
    1638:	6b98                	ld	a4,16(a5)
    163a:	6f9c                	ld	a5,24(a5)
    163c:	f2c43823          	sd	a2,-208(s0)
    1640:	f2d43c23          	sd	a3,-200(s0)
    1644:	f4e43023          	sd	a4,-192(s0)
    1648:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    164c:	f3040593          	addi	a1,s0,-208
    1650:	00005517          	auipc	a0,0x5
    1654:	5d850513          	addi	a0,a0,1496 # 6c28 <malloc+0x13e>
    1658:	00005097          	auipc	ra,0x5
    165c:	06c080e7          	jalr	108(ra) # 66c4 <exec>
    if(ret != -1){
    1660:	57fd                	li	a5,-1
    1662:	0ef50663          	beq	a0,a5,174e <copyinstr2+0x1dc>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1666:	55fd                	li	a1,-1
    1668:	00006517          	auipc	a0,0x6
    166c:	df050513          	addi	a0,a0,-528 # 7458 <malloc+0x96e>
    1670:	00005097          	auipc	ra,0x5
    1674:	3bc080e7          	jalr	956(ra) # 6a2c <printf>
      exit(1,"");
    1678:	00007597          	auipc	a1,0x7
    167c:	ba058593          	addi	a1,a1,-1120 # 8218 <malloc+0x172e>
    1680:	4505                	li	a0,1
    1682:	00005097          	auipc	ra,0x5
    1686:	00a080e7          	jalr	10(ra) # 668c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    168a:	862a                	mv	a2,a0
    168c:	f6840593          	addi	a1,s0,-152
    1690:	00006517          	auipc	a0,0x6
    1694:	d4050513          	addi	a0,a0,-704 # 73d0 <malloc+0x8e6>
    1698:	00005097          	auipc	ra,0x5
    169c:	394080e7          	jalr	916(ra) # 6a2c <printf>
    exit(1,"");
    16a0:	00007597          	auipc	a1,0x7
    16a4:	b7858593          	addi	a1,a1,-1160 # 8218 <malloc+0x172e>
    16a8:	4505                	li	a0,1
    16aa:	00005097          	auipc	ra,0x5
    16ae:	fe2080e7          	jalr	-30(ra) # 668c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    16b2:	862a                	mv	a2,a0
    16b4:	f6840593          	addi	a1,s0,-152
    16b8:	00006517          	auipc	a0,0x6
    16bc:	d3850513          	addi	a0,a0,-712 # 73f0 <malloc+0x906>
    16c0:	00005097          	auipc	ra,0x5
    16c4:	36c080e7          	jalr	876(ra) # 6a2c <printf>
    exit(1,"");
    16c8:	00007597          	auipc	a1,0x7
    16cc:	b5058593          	addi	a1,a1,-1200 # 8218 <malloc+0x172e>
    16d0:	4505                	li	a0,1
    16d2:	00005097          	auipc	ra,0x5
    16d6:	fba080e7          	jalr	-70(ra) # 668c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    16da:	86aa                	mv	a3,a0
    16dc:	f6840613          	addi	a2,s0,-152
    16e0:	85b2                	mv	a1,a2
    16e2:	00006517          	auipc	a0,0x6
    16e6:	d2e50513          	addi	a0,a0,-722 # 7410 <malloc+0x926>
    16ea:	00005097          	auipc	ra,0x5
    16ee:	342080e7          	jalr	834(ra) # 6a2c <printf>
    exit(1,"");
    16f2:	00007597          	auipc	a1,0x7
    16f6:	b2658593          	addi	a1,a1,-1242 # 8218 <malloc+0x172e>
    16fa:	4505                	li	a0,1
    16fc:	00005097          	auipc	ra,0x5
    1700:	f90080e7          	jalr	-112(ra) # 668c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1704:	567d                	li	a2,-1
    1706:	f6840593          	addi	a1,s0,-152
    170a:	00006517          	auipc	a0,0x6
    170e:	d2e50513          	addi	a0,a0,-722 # 7438 <malloc+0x94e>
    1712:	00005097          	auipc	ra,0x5
    1716:	31a080e7          	jalr	794(ra) # 6a2c <printf>
    exit(1,"");
    171a:	00007597          	auipc	a1,0x7
    171e:	afe58593          	addi	a1,a1,-1282 # 8218 <malloc+0x172e>
    1722:	4505                	li	a0,1
    1724:	00005097          	auipc	ra,0x5
    1728:	f68080e7          	jalr	-152(ra) # 668c <exit>
    printf("fork failed\n");
    172c:	00006517          	auipc	a0,0x6
    1730:	18c50513          	addi	a0,a0,396 # 78b8 <malloc+0xdce>
    1734:	00005097          	auipc	ra,0x5
    1738:	2f8080e7          	jalr	760(ra) # 6a2c <printf>
    exit(1,"");
    173c:	00007597          	auipc	a1,0x7
    1740:	adc58593          	addi	a1,a1,-1316 # 8218 <malloc+0x172e>
    1744:	4505                	li	a0,1
    1746:	00005097          	auipc	ra,0x5
    174a:	f46080e7          	jalr	-186(ra) # 668c <exit>
    exit(747,""); // OK
    174e:	00007597          	auipc	a1,0x7
    1752:	aca58593          	addi	a1,a1,-1334 # 8218 <malloc+0x172e>
    1756:	2eb00513          	li	a0,747
    175a:	00005097          	auipc	ra,0x5
    175e:	f32080e7          	jalr	-206(ra) # 668c <exit>
  int st = 0;
    1762:	f4042a23          	sw	zero,-172(s0)
  wait(&st,0);
    1766:	4581                	li	a1,0
    1768:	f5440513          	addi	a0,s0,-172
    176c:	00005097          	auipc	ra,0x5
    1770:	f28080e7          	jalr	-216(ra) # 6694 <wait>
  if(st != 747){
    1774:	f5442703          	lw	a4,-172(s0)
    1778:	2eb00793          	li	a5,747
    177c:	00f71663          	bne	a4,a5,1788 <copyinstr2+0x216>
}
    1780:	60ae                	ld	ra,200(sp)
    1782:	640e                	ld	s0,192(sp)
    1784:	6169                	addi	sp,sp,208
    1786:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1788:	00006517          	auipc	a0,0x6
    178c:	cf850513          	addi	a0,a0,-776 # 7480 <malloc+0x996>
    1790:	00005097          	auipc	ra,0x5
    1794:	29c080e7          	jalr	668(ra) # 6a2c <printf>
    exit(1,"");
    1798:	00007597          	auipc	a1,0x7
    179c:	a8058593          	addi	a1,a1,-1408 # 8218 <malloc+0x172e>
    17a0:	4505                	li	a0,1
    17a2:	00005097          	auipc	ra,0x5
    17a6:	eea080e7          	jalr	-278(ra) # 668c <exit>

00000000000017aa <truncate3>:
{
    17aa:	7159                	addi	sp,sp,-112
    17ac:	f486                	sd	ra,104(sp)
    17ae:	f0a2                	sd	s0,96(sp)
    17b0:	eca6                	sd	s1,88(sp)
    17b2:	e8ca                	sd	s2,80(sp)
    17b4:	e4ce                	sd	s3,72(sp)
    17b6:	e0d2                	sd	s4,64(sp)
    17b8:	fc56                	sd	s5,56(sp)
    17ba:	1880                	addi	s0,sp,112
    17bc:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    17be:	60100593          	li	a1,1537
    17c2:	00005517          	auipc	a0,0x5
    17c6:	4be50513          	addi	a0,a0,1214 # 6c80 <malloc+0x196>
    17ca:	00005097          	auipc	ra,0x5
    17ce:	f02080e7          	jalr	-254(ra) # 66cc <open>
    17d2:	00005097          	auipc	ra,0x5
    17d6:	ee2080e7          	jalr	-286(ra) # 66b4 <close>
  pid = fork();
    17da:	00005097          	auipc	ra,0x5
    17de:	eaa080e7          	jalr	-342(ra) # 6684 <fork>
  if(pid < 0){
    17e2:	08054463          	bltz	a0,186a <truncate3+0xc0>
  if(pid == 0){
    17e6:	e96d                	bnez	a0,18d8 <truncate3+0x12e>
    17e8:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    17ec:	00005a17          	auipc	s4,0x5
    17f0:	494a0a13          	addi	s4,s4,1172 # 6c80 <malloc+0x196>
      int n = write(fd, "1234567890", 10);
    17f4:	00006a97          	auipc	s5,0x6
    17f8:	ceca8a93          	addi	s5,s5,-788 # 74e0 <malloc+0x9f6>
      int fd = open("truncfile", O_WRONLY);
    17fc:	4585                	li	a1,1
    17fe:	8552                	mv	a0,s4
    1800:	00005097          	auipc	ra,0x5
    1804:	ecc080e7          	jalr	-308(ra) # 66cc <open>
    1808:	84aa                	mv	s1,a0
      if(fd < 0){
    180a:	08054263          	bltz	a0,188e <truncate3+0xe4>
      int n = write(fd, "1234567890", 10);
    180e:	4629                	li	a2,10
    1810:	85d6                	mv	a1,s5
    1812:	00005097          	auipc	ra,0x5
    1816:	e9a080e7          	jalr	-358(ra) # 66ac <write>
      if(n != 10){
    181a:	47a9                	li	a5,10
    181c:	08f51b63          	bne	a0,a5,18b2 <truncate3+0x108>
      close(fd);
    1820:	8526                	mv	a0,s1
    1822:	00005097          	auipc	ra,0x5
    1826:	e92080e7          	jalr	-366(ra) # 66b4 <close>
      fd = open("truncfile", O_RDONLY);
    182a:	4581                	li	a1,0
    182c:	8552                	mv	a0,s4
    182e:	00005097          	auipc	ra,0x5
    1832:	e9e080e7          	jalr	-354(ra) # 66cc <open>
    1836:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1838:	02000613          	li	a2,32
    183c:	f9840593          	addi	a1,s0,-104
    1840:	00005097          	auipc	ra,0x5
    1844:	e64080e7          	jalr	-412(ra) # 66a4 <read>
      close(fd);
    1848:	8526                	mv	a0,s1
    184a:	00005097          	auipc	ra,0x5
    184e:	e6a080e7          	jalr	-406(ra) # 66b4 <close>
    for(int i = 0; i < 100; i++){
    1852:	39fd                	addiw	s3,s3,-1
    1854:	fa0994e3          	bnez	s3,17fc <truncate3+0x52>
    exit(0,"");
    1858:	00007597          	auipc	a1,0x7
    185c:	9c058593          	addi	a1,a1,-1600 # 8218 <malloc+0x172e>
    1860:	4501                	li	a0,0
    1862:	00005097          	auipc	ra,0x5
    1866:	e2a080e7          	jalr	-470(ra) # 668c <exit>
    printf("%s: fork failed\n", s);
    186a:	85ca                	mv	a1,s2
    186c:	00006517          	auipc	a0,0x6
    1870:	c4450513          	addi	a0,a0,-956 # 74b0 <malloc+0x9c6>
    1874:	00005097          	auipc	ra,0x5
    1878:	1b8080e7          	jalr	440(ra) # 6a2c <printf>
    exit(1,"");
    187c:	00007597          	auipc	a1,0x7
    1880:	99c58593          	addi	a1,a1,-1636 # 8218 <malloc+0x172e>
    1884:	4505                	li	a0,1
    1886:	00005097          	auipc	ra,0x5
    188a:	e06080e7          	jalr	-506(ra) # 668c <exit>
        printf("%s: open failed\n", s);
    188e:	85ca                	mv	a1,s2
    1890:	00006517          	auipc	a0,0x6
    1894:	c3850513          	addi	a0,a0,-968 # 74c8 <malloc+0x9de>
    1898:	00005097          	auipc	ra,0x5
    189c:	194080e7          	jalr	404(ra) # 6a2c <printf>
        exit(1,"");
    18a0:	00007597          	auipc	a1,0x7
    18a4:	97858593          	addi	a1,a1,-1672 # 8218 <malloc+0x172e>
    18a8:	4505                	li	a0,1
    18aa:	00005097          	auipc	ra,0x5
    18ae:	de2080e7          	jalr	-542(ra) # 668c <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    18b2:	862a                	mv	a2,a0
    18b4:	85ca                	mv	a1,s2
    18b6:	00006517          	auipc	a0,0x6
    18ba:	c3a50513          	addi	a0,a0,-966 # 74f0 <malloc+0xa06>
    18be:	00005097          	auipc	ra,0x5
    18c2:	16e080e7          	jalr	366(ra) # 6a2c <printf>
        exit(1,"");
    18c6:	00007597          	auipc	a1,0x7
    18ca:	95258593          	addi	a1,a1,-1710 # 8218 <malloc+0x172e>
    18ce:	4505                	li	a0,1
    18d0:	00005097          	auipc	ra,0x5
    18d4:	dbc080e7          	jalr	-580(ra) # 668c <exit>
    18d8:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    18dc:	00005a17          	auipc	s4,0x5
    18e0:	3a4a0a13          	addi	s4,s4,932 # 6c80 <malloc+0x196>
    int n = write(fd, "xxx", 3);
    18e4:	00006a97          	auipc	s5,0x6
    18e8:	c2ca8a93          	addi	s5,s5,-980 # 7510 <malloc+0xa26>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    18ec:	60100593          	li	a1,1537
    18f0:	8552                	mv	a0,s4
    18f2:	00005097          	auipc	ra,0x5
    18f6:	dda080e7          	jalr	-550(ra) # 66cc <open>
    18fa:	84aa                	mv	s1,a0
    if(fd < 0){
    18fc:	04054c63          	bltz	a0,1954 <truncate3+0x1aa>
    int n = write(fd, "xxx", 3);
    1900:	460d                	li	a2,3
    1902:	85d6                	mv	a1,s5
    1904:	00005097          	auipc	ra,0x5
    1908:	da8080e7          	jalr	-600(ra) # 66ac <write>
    if(n != 3){
    190c:	478d                	li	a5,3
    190e:	06f51563          	bne	a0,a5,1978 <truncate3+0x1ce>
    close(fd);
    1912:	8526                	mv	a0,s1
    1914:	00005097          	auipc	ra,0x5
    1918:	da0080e7          	jalr	-608(ra) # 66b4 <close>
  for(int i = 0; i < 150; i++){
    191c:	39fd                	addiw	s3,s3,-1
    191e:	fc0997e3          	bnez	s3,18ec <truncate3+0x142>
  wait(&xstatus,0);
    1922:	4581                	li	a1,0
    1924:	fbc40513          	addi	a0,s0,-68
    1928:	00005097          	auipc	ra,0x5
    192c:	d6c080e7          	jalr	-660(ra) # 6694 <wait>
  unlink("truncfile");
    1930:	00005517          	auipc	a0,0x5
    1934:	35050513          	addi	a0,a0,848 # 6c80 <malloc+0x196>
    1938:	00005097          	auipc	ra,0x5
    193c:	da4080e7          	jalr	-604(ra) # 66dc <unlink>
  exit(xstatus,"");
    1940:	00007597          	auipc	a1,0x7
    1944:	8d858593          	addi	a1,a1,-1832 # 8218 <malloc+0x172e>
    1948:	fbc42503          	lw	a0,-68(s0)
    194c:	00005097          	auipc	ra,0x5
    1950:	d40080e7          	jalr	-704(ra) # 668c <exit>
      printf("%s: open failed\n", s);
    1954:	85ca                	mv	a1,s2
    1956:	00006517          	auipc	a0,0x6
    195a:	b7250513          	addi	a0,a0,-1166 # 74c8 <malloc+0x9de>
    195e:	00005097          	auipc	ra,0x5
    1962:	0ce080e7          	jalr	206(ra) # 6a2c <printf>
      exit(1,"");
    1966:	00007597          	auipc	a1,0x7
    196a:	8b258593          	addi	a1,a1,-1870 # 8218 <malloc+0x172e>
    196e:	4505                	li	a0,1
    1970:	00005097          	auipc	ra,0x5
    1974:	d1c080e7          	jalr	-740(ra) # 668c <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1978:	862a                	mv	a2,a0
    197a:	85ca                	mv	a1,s2
    197c:	00006517          	auipc	a0,0x6
    1980:	b9c50513          	addi	a0,a0,-1124 # 7518 <malloc+0xa2e>
    1984:	00005097          	auipc	ra,0x5
    1988:	0a8080e7          	jalr	168(ra) # 6a2c <printf>
      exit(1,"");
    198c:	00007597          	auipc	a1,0x7
    1990:	88c58593          	addi	a1,a1,-1908 # 8218 <malloc+0x172e>
    1994:	4505                	li	a0,1
    1996:	00005097          	auipc	ra,0x5
    199a:	cf6080e7          	jalr	-778(ra) # 668c <exit>

000000000000199e <exectest>:
{
    199e:	715d                	addi	sp,sp,-80
    19a0:	e486                	sd	ra,72(sp)
    19a2:	e0a2                	sd	s0,64(sp)
    19a4:	fc26                	sd	s1,56(sp)
    19a6:	f84a                	sd	s2,48(sp)
    19a8:	0880                	addi	s0,sp,80
    19aa:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    19ac:	00005797          	auipc	a5,0x5
    19b0:	27c78793          	addi	a5,a5,636 # 6c28 <malloc+0x13e>
    19b4:	fcf43023          	sd	a5,-64(s0)
    19b8:	00006797          	auipc	a5,0x6
    19bc:	b8078793          	addi	a5,a5,-1152 # 7538 <malloc+0xa4e>
    19c0:	fcf43423          	sd	a5,-56(s0)
    19c4:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    19c8:	00006517          	auipc	a0,0x6
    19cc:	b7850513          	addi	a0,a0,-1160 # 7540 <malloc+0xa56>
    19d0:	00005097          	auipc	ra,0x5
    19d4:	d0c080e7          	jalr	-756(ra) # 66dc <unlink>
  pid = fork();
    19d8:	00005097          	auipc	ra,0x5
    19dc:	cac080e7          	jalr	-852(ra) # 6684 <fork>
  if(pid < 0) {
    19e0:	04054a63          	bltz	a0,1a34 <exectest+0x96>
    19e4:	84aa                	mv	s1,a0
  if(pid == 0) {
    19e6:	e55d                	bnez	a0,1a94 <exectest+0xf6>
    close(1);
    19e8:	4505                	li	a0,1
    19ea:	00005097          	auipc	ra,0x5
    19ee:	cca080e7          	jalr	-822(ra) # 66b4 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    19f2:	20100593          	li	a1,513
    19f6:	00006517          	auipc	a0,0x6
    19fa:	b4a50513          	addi	a0,a0,-1206 # 7540 <malloc+0xa56>
    19fe:	00005097          	auipc	ra,0x5
    1a02:	cce080e7          	jalr	-818(ra) # 66cc <open>
    if(fd < 0) {
    1a06:	04054963          	bltz	a0,1a58 <exectest+0xba>
    if(fd != 1) {
    1a0a:	4785                	li	a5,1
    1a0c:	06f50863          	beq	a0,a5,1a7c <exectest+0xde>
      printf("%s: wrong fd\n", s);
    1a10:	85ca                	mv	a1,s2
    1a12:	00006517          	auipc	a0,0x6
    1a16:	b4e50513          	addi	a0,a0,-1202 # 7560 <malloc+0xa76>
    1a1a:	00005097          	auipc	ra,0x5
    1a1e:	012080e7          	jalr	18(ra) # 6a2c <printf>
      exit(1,"");
    1a22:	00006597          	auipc	a1,0x6
    1a26:	7f658593          	addi	a1,a1,2038 # 8218 <malloc+0x172e>
    1a2a:	4505                	li	a0,1
    1a2c:	00005097          	auipc	ra,0x5
    1a30:	c60080e7          	jalr	-928(ra) # 668c <exit>
     printf("%s: fork failed\n", s);
    1a34:	85ca                	mv	a1,s2
    1a36:	00006517          	auipc	a0,0x6
    1a3a:	a7a50513          	addi	a0,a0,-1414 # 74b0 <malloc+0x9c6>
    1a3e:	00005097          	auipc	ra,0x5
    1a42:	fee080e7          	jalr	-18(ra) # 6a2c <printf>
     exit(1,"");
    1a46:	00006597          	auipc	a1,0x6
    1a4a:	7d258593          	addi	a1,a1,2002 # 8218 <malloc+0x172e>
    1a4e:	4505                	li	a0,1
    1a50:	00005097          	auipc	ra,0x5
    1a54:	c3c080e7          	jalr	-964(ra) # 668c <exit>
      printf("%s: create failed\n", s);
    1a58:	85ca                	mv	a1,s2
    1a5a:	00006517          	auipc	a0,0x6
    1a5e:	aee50513          	addi	a0,a0,-1298 # 7548 <malloc+0xa5e>
    1a62:	00005097          	auipc	ra,0x5
    1a66:	fca080e7          	jalr	-54(ra) # 6a2c <printf>
      exit(1,"");
    1a6a:	00006597          	auipc	a1,0x6
    1a6e:	7ae58593          	addi	a1,a1,1966 # 8218 <malloc+0x172e>
    1a72:	4505                	li	a0,1
    1a74:	00005097          	auipc	ra,0x5
    1a78:	c18080e7          	jalr	-1000(ra) # 668c <exit>
    if(exec("echo", echoargv) < 0){
    1a7c:	fc040593          	addi	a1,s0,-64
    1a80:	00005517          	auipc	a0,0x5
    1a84:	1a850513          	addi	a0,a0,424 # 6c28 <malloc+0x13e>
    1a88:	00005097          	auipc	ra,0x5
    1a8c:	c3c080e7          	jalr	-964(ra) # 66c4 <exec>
    1a90:	02054663          	bltz	a0,1abc <exectest+0x11e>
  if (wait(&xstatus,0) != pid) {
    1a94:	4581                	li	a1,0
    1a96:	fdc40513          	addi	a0,s0,-36
    1a9a:	00005097          	auipc	ra,0x5
    1a9e:	bfa080e7          	jalr	-1030(ra) # 6694 <wait>
    1aa2:	02951f63          	bne	a0,s1,1ae0 <exectest+0x142>
  if(xstatus != 0)
    1aa6:	fdc42503          	lw	a0,-36(s0)
    1aaa:	c529                	beqz	a0,1af4 <exectest+0x156>
    exit(xstatus,"");
    1aac:	00006597          	auipc	a1,0x6
    1ab0:	76c58593          	addi	a1,a1,1900 # 8218 <malloc+0x172e>
    1ab4:	00005097          	auipc	ra,0x5
    1ab8:	bd8080e7          	jalr	-1064(ra) # 668c <exit>
      printf("%s: exec echo failed\n", s);
    1abc:	85ca                	mv	a1,s2
    1abe:	00006517          	auipc	a0,0x6
    1ac2:	ab250513          	addi	a0,a0,-1358 # 7570 <malloc+0xa86>
    1ac6:	00005097          	auipc	ra,0x5
    1aca:	f66080e7          	jalr	-154(ra) # 6a2c <printf>
      exit(1,"");
    1ace:	00006597          	auipc	a1,0x6
    1ad2:	74a58593          	addi	a1,a1,1866 # 8218 <malloc+0x172e>
    1ad6:	4505                	li	a0,1
    1ad8:	00005097          	auipc	ra,0x5
    1adc:	bb4080e7          	jalr	-1100(ra) # 668c <exit>
    printf("%s: wait failed!\n", s);
    1ae0:	85ca                	mv	a1,s2
    1ae2:	00006517          	auipc	a0,0x6
    1ae6:	aa650513          	addi	a0,a0,-1370 # 7588 <malloc+0xa9e>
    1aea:	00005097          	auipc	ra,0x5
    1aee:	f42080e7          	jalr	-190(ra) # 6a2c <printf>
    1af2:	bf55                	j	1aa6 <exectest+0x108>
  fd = open("echo-ok", O_RDONLY);
    1af4:	4581                	li	a1,0
    1af6:	00006517          	auipc	a0,0x6
    1afa:	a4a50513          	addi	a0,a0,-1462 # 7540 <malloc+0xa56>
    1afe:	00005097          	auipc	ra,0x5
    1b02:	bce080e7          	jalr	-1074(ra) # 66cc <open>
  if(fd < 0) {
    1b06:	02054e63          	bltz	a0,1b42 <exectest+0x1a4>
  if (read(fd, buf, 2) != 2) {
    1b0a:	4609                	li	a2,2
    1b0c:	fb840593          	addi	a1,s0,-72
    1b10:	00005097          	auipc	ra,0x5
    1b14:	b94080e7          	jalr	-1132(ra) # 66a4 <read>
    1b18:	4789                	li	a5,2
    1b1a:	04f50663          	beq	a0,a5,1b66 <exectest+0x1c8>
    printf("%s: read failed\n", s);
    1b1e:	85ca                	mv	a1,s2
    1b20:	00005517          	auipc	a0,0x5
    1b24:	4d850513          	addi	a0,a0,1240 # 6ff8 <malloc+0x50e>
    1b28:	00005097          	auipc	ra,0x5
    1b2c:	f04080e7          	jalr	-252(ra) # 6a2c <printf>
    exit(1,"");
    1b30:	00006597          	auipc	a1,0x6
    1b34:	6e858593          	addi	a1,a1,1768 # 8218 <malloc+0x172e>
    1b38:	4505                	li	a0,1
    1b3a:	00005097          	auipc	ra,0x5
    1b3e:	b52080e7          	jalr	-1198(ra) # 668c <exit>
    printf("%s: open failed\n", s);
    1b42:	85ca                	mv	a1,s2
    1b44:	00006517          	auipc	a0,0x6
    1b48:	98450513          	addi	a0,a0,-1660 # 74c8 <malloc+0x9de>
    1b4c:	00005097          	auipc	ra,0x5
    1b50:	ee0080e7          	jalr	-288(ra) # 6a2c <printf>
    exit(1,"");
    1b54:	00006597          	auipc	a1,0x6
    1b58:	6c458593          	addi	a1,a1,1732 # 8218 <malloc+0x172e>
    1b5c:	4505                	li	a0,1
    1b5e:	00005097          	auipc	ra,0x5
    1b62:	b2e080e7          	jalr	-1234(ra) # 668c <exit>
  unlink("echo-ok");
    1b66:	00006517          	auipc	a0,0x6
    1b6a:	9da50513          	addi	a0,a0,-1574 # 7540 <malloc+0xa56>
    1b6e:	00005097          	auipc	ra,0x5
    1b72:	b6e080e7          	jalr	-1170(ra) # 66dc <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1b76:	fb844703          	lbu	a4,-72(s0)
    1b7a:	04f00793          	li	a5,79
    1b7e:	00f71863          	bne	a4,a5,1b8e <exectest+0x1f0>
    1b82:	fb944703          	lbu	a4,-71(s0)
    1b86:	04b00793          	li	a5,75
    1b8a:	02f70463          	beq	a4,a5,1bb2 <exectest+0x214>
    printf("%s: wrong output\n", s);
    1b8e:	85ca                	mv	a1,s2
    1b90:	00006517          	auipc	a0,0x6
    1b94:	a1050513          	addi	a0,a0,-1520 # 75a0 <malloc+0xab6>
    1b98:	00005097          	auipc	ra,0x5
    1b9c:	e94080e7          	jalr	-364(ra) # 6a2c <printf>
    exit(1,"");
    1ba0:	00006597          	auipc	a1,0x6
    1ba4:	67858593          	addi	a1,a1,1656 # 8218 <malloc+0x172e>
    1ba8:	4505                	li	a0,1
    1baa:	00005097          	auipc	ra,0x5
    1bae:	ae2080e7          	jalr	-1310(ra) # 668c <exit>
    exit(0,"");
    1bb2:	00006597          	auipc	a1,0x6
    1bb6:	66658593          	addi	a1,a1,1638 # 8218 <malloc+0x172e>
    1bba:	4501                	li	a0,0
    1bbc:	00005097          	auipc	ra,0x5
    1bc0:	ad0080e7          	jalr	-1328(ra) # 668c <exit>

0000000000001bc4 <pipe1>:
{
    1bc4:	711d                	addi	sp,sp,-96
    1bc6:	ec86                	sd	ra,88(sp)
    1bc8:	e8a2                	sd	s0,80(sp)
    1bca:	e4a6                	sd	s1,72(sp)
    1bcc:	e0ca                	sd	s2,64(sp)
    1bce:	fc4e                	sd	s3,56(sp)
    1bd0:	f852                	sd	s4,48(sp)
    1bd2:	f456                	sd	s5,40(sp)
    1bd4:	f05a                	sd	s6,32(sp)
    1bd6:	ec5e                	sd	s7,24(sp)
    1bd8:	1080                	addi	s0,sp,96
    1bda:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1bdc:	fa840513          	addi	a0,s0,-88
    1be0:	00005097          	auipc	ra,0x5
    1be4:	abc080e7          	jalr	-1348(ra) # 669c <pipe>
    1be8:	ed25                	bnez	a0,1c60 <pipe1+0x9c>
    1bea:	84aa                	mv	s1,a0
  pid = fork();
    1bec:	00005097          	auipc	ra,0x5
    1bf0:	a98080e7          	jalr	-1384(ra) # 6684 <fork>
    1bf4:	8a2a                	mv	s4,a0
  if(pid == 0){
    1bf6:	c559                	beqz	a0,1c84 <pipe1+0xc0>
  } else if(pid > 0){
    1bf8:	1aa05363          	blez	a0,1d9e <pipe1+0x1da>
    close(fds[1]);
    1bfc:	fac42503          	lw	a0,-84(s0)
    1c00:	00005097          	auipc	ra,0x5
    1c04:	ab4080e7          	jalr	-1356(ra) # 66b4 <close>
    total = 0;
    1c08:	8a26                	mv	s4,s1
    cc = 1;
    1c0a:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1c0c:	0000ca97          	auipc	s5,0xc
    1c10:	06ca8a93          	addi	s5,s5,108 # dc78 <buf>
      if(cc > sizeof(buf))
    1c14:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1c16:	864e                	mv	a2,s3
    1c18:	85d6                	mv	a1,s5
    1c1a:	fa842503          	lw	a0,-88(s0)
    1c1e:	00005097          	auipc	ra,0x5
    1c22:	a86080e7          	jalr	-1402(ra) # 66a4 <read>
    1c26:	10a05e63          	blez	a0,1d42 <pipe1+0x17e>
      for(i = 0; i < n; i++){
    1c2a:	0000c717          	auipc	a4,0xc
    1c2e:	04e70713          	addi	a4,a4,78 # dc78 <buf>
    1c32:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1c36:	00074683          	lbu	a3,0(a4)
    1c3a:	0ff4f793          	andi	a5,s1,255
    1c3e:	2485                	addiw	s1,s1,1
    1c40:	0cf69d63          	bne	a3,a5,1d1a <pipe1+0x156>
      for(i = 0; i < n; i++){
    1c44:	0705                	addi	a4,a4,1
    1c46:	fec498e3          	bne	s1,a2,1c36 <pipe1+0x72>
      total += n;
    1c4a:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1c4e:	0019979b          	slliw	a5,s3,0x1
    1c52:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    1c56:	013b7363          	bgeu	s6,s3,1c5c <pipe1+0x98>
        cc = sizeof(buf);
    1c5a:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1c5c:	84b2                	mv	s1,a2
    1c5e:	bf65                	j	1c16 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    1c60:	85ca                	mv	a1,s2
    1c62:	00006517          	auipc	a0,0x6
    1c66:	95650513          	addi	a0,a0,-1706 # 75b8 <malloc+0xace>
    1c6a:	00005097          	auipc	ra,0x5
    1c6e:	dc2080e7          	jalr	-574(ra) # 6a2c <printf>
    exit(1,"");
    1c72:	00006597          	auipc	a1,0x6
    1c76:	5a658593          	addi	a1,a1,1446 # 8218 <malloc+0x172e>
    1c7a:	4505                	li	a0,1
    1c7c:	00005097          	auipc	ra,0x5
    1c80:	a10080e7          	jalr	-1520(ra) # 668c <exit>
    close(fds[0]);
    1c84:	fa842503          	lw	a0,-88(s0)
    1c88:	00005097          	auipc	ra,0x5
    1c8c:	a2c080e7          	jalr	-1492(ra) # 66b4 <close>
    for(n = 0; n < N; n++){
    1c90:	0000cb17          	auipc	s6,0xc
    1c94:	fe8b0b13          	addi	s6,s6,-24 # dc78 <buf>
    1c98:	416004bb          	negw	s1,s6
    1c9c:	0ff4f493          	andi	s1,s1,255
    1ca0:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1ca4:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1ca6:	6a85                	lui	s5,0x1
    1ca8:	42da8a93          	addi	s5,s5,1069 # 142d <bigdir+0xc5>
{
    1cac:	87da                	mv	a5,s6
        buf[i] = seq++;
    1cae:	0097873b          	addw	a4,a5,s1
    1cb2:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1cb6:	0785                	addi	a5,a5,1
    1cb8:	fef99be3          	bne	s3,a5,1cae <pipe1+0xea>
    1cbc:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1cc0:	40900613          	li	a2,1033
    1cc4:	85de                	mv	a1,s7
    1cc6:	fac42503          	lw	a0,-84(s0)
    1cca:	00005097          	auipc	ra,0x5
    1cce:	9e2080e7          	jalr	-1566(ra) # 66ac <write>
    1cd2:	40900793          	li	a5,1033
    1cd6:	02f51063          	bne	a0,a5,1cf6 <pipe1+0x132>
    for(n = 0; n < N; n++){
    1cda:	24a5                	addiw	s1,s1,9
    1cdc:	0ff4f493          	andi	s1,s1,255
    1ce0:	fd5a16e3          	bne	s4,s5,1cac <pipe1+0xe8>
    exit(0,"");
    1ce4:	00006597          	auipc	a1,0x6
    1ce8:	53458593          	addi	a1,a1,1332 # 8218 <malloc+0x172e>
    1cec:	4501                	li	a0,0
    1cee:	00005097          	auipc	ra,0x5
    1cf2:	99e080e7          	jalr	-1634(ra) # 668c <exit>
        printf("%s: pipe1 oops 1\n", s);
    1cf6:	85ca                	mv	a1,s2
    1cf8:	00006517          	auipc	a0,0x6
    1cfc:	8d850513          	addi	a0,a0,-1832 # 75d0 <malloc+0xae6>
    1d00:	00005097          	auipc	ra,0x5
    1d04:	d2c080e7          	jalr	-724(ra) # 6a2c <printf>
        exit(1,"");
    1d08:	00006597          	auipc	a1,0x6
    1d0c:	51058593          	addi	a1,a1,1296 # 8218 <malloc+0x172e>
    1d10:	4505                	li	a0,1
    1d12:	00005097          	auipc	ra,0x5
    1d16:	97a080e7          	jalr	-1670(ra) # 668c <exit>
          printf("%s: pipe1 oops 2\n", s);
    1d1a:	85ca                	mv	a1,s2
    1d1c:	00006517          	auipc	a0,0x6
    1d20:	8cc50513          	addi	a0,a0,-1844 # 75e8 <malloc+0xafe>
    1d24:	00005097          	auipc	ra,0x5
    1d28:	d08080e7          	jalr	-760(ra) # 6a2c <printf>
}
    1d2c:	60e6                	ld	ra,88(sp)
    1d2e:	6446                	ld	s0,80(sp)
    1d30:	64a6                	ld	s1,72(sp)
    1d32:	6906                	ld	s2,64(sp)
    1d34:	79e2                	ld	s3,56(sp)
    1d36:	7a42                	ld	s4,48(sp)
    1d38:	7aa2                	ld	s5,40(sp)
    1d3a:	7b02                	ld	s6,32(sp)
    1d3c:	6be2                	ld	s7,24(sp)
    1d3e:	6125                	addi	sp,sp,96
    1d40:	8082                	ret
    if(total != N * SZ){
    1d42:	6785                	lui	a5,0x1
    1d44:	42d78793          	addi	a5,a5,1069 # 142d <bigdir+0xc5>
    1d48:	02fa0463          	beq	s4,a5,1d70 <pipe1+0x1ac>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1d4c:	85d2                	mv	a1,s4
    1d4e:	00006517          	auipc	a0,0x6
    1d52:	8b250513          	addi	a0,a0,-1870 # 7600 <malloc+0xb16>
    1d56:	00005097          	auipc	ra,0x5
    1d5a:	cd6080e7          	jalr	-810(ra) # 6a2c <printf>
      exit(1,"");
    1d5e:	00006597          	auipc	a1,0x6
    1d62:	4ba58593          	addi	a1,a1,1210 # 8218 <malloc+0x172e>
    1d66:	4505                	li	a0,1
    1d68:	00005097          	auipc	ra,0x5
    1d6c:	924080e7          	jalr	-1756(ra) # 668c <exit>
    close(fds[0]);
    1d70:	fa842503          	lw	a0,-88(s0)
    1d74:	00005097          	auipc	ra,0x5
    1d78:	940080e7          	jalr	-1728(ra) # 66b4 <close>
    wait(&xstatus,0);
    1d7c:	4581                	li	a1,0
    1d7e:	fa440513          	addi	a0,s0,-92
    1d82:	00005097          	auipc	ra,0x5
    1d86:	912080e7          	jalr	-1774(ra) # 6694 <wait>
    exit(xstatus,"");
    1d8a:	00006597          	auipc	a1,0x6
    1d8e:	48e58593          	addi	a1,a1,1166 # 8218 <malloc+0x172e>
    1d92:	fa442503          	lw	a0,-92(s0)
    1d96:	00005097          	auipc	ra,0x5
    1d9a:	8f6080e7          	jalr	-1802(ra) # 668c <exit>
    printf("%s: fork() failed\n", s);
    1d9e:	85ca                	mv	a1,s2
    1da0:	00006517          	auipc	a0,0x6
    1da4:	88050513          	addi	a0,a0,-1920 # 7620 <malloc+0xb36>
    1da8:	00005097          	auipc	ra,0x5
    1dac:	c84080e7          	jalr	-892(ra) # 6a2c <printf>
    exit(1,"");
    1db0:	00006597          	auipc	a1,0x6
    1db4:	46858593          	addi	a1,a1,1128 # 8218 <malloc+0x172e>
    1db8:	4505                	li	a0,1
    1dba:	00005097          	auipc	ra,0x5
    1dbe:	8d2080e7          	jalr	-1838(ra) # 668c <exit>

0000000000001dc2 <exitwait>:
{
    1dc2:	7139                	addi	sp,sp,-64
    1dc4:	fc06                	sd	ra,56(sp)
    1dc6:	f822                	sd	s0,48(sp)
    1dc8:	f426                	sd	s1,40(sp)
    1dca:	f04a                	sd	s2,32(sp)
    1dcc:	ec4e                	sd	s3,24(sp)
    1dce:	e852                	sd	s4,16(sp)
    1dd0:	0080                	addi	s0,sp,64
    1dd2:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1dd4:	4901                	li	s2,0
    1dd6:	06400993          	li	s3,100
    pid = fork();
    1dda:	00005097          	auipc	ra,0x5
    1dde:	8aa080e7          	jalr	-1878(ra) # 6684 <fork>
    1de2:	84aa                	mv	s1,a0
    if(pid < 0){
    1de4:	02054b63          	bltz	a0,1e1a <exitwait+0x58>
    if(pid){
    1de8:	cd59                	beqz	a0,1e86 <exitwait+0xc4>
      if(wait(&xstate,0) != pid){
    1dea:	4581                	li	a1,0
    1dec:	fcc40513          	addi	a0,s0,-52
    1df0:	00005097          	auipc	ra,0x5
    1df4:	8a4080e7          	jalr	-1884(ra) # 6694 <wait>
    1df8:	04951363          	bne	a0,s1,1e3e <exitwait+0x7c>
      if(i != xstate) {
    1dfc:	fcc42783          	lw	a5,-52(s0)
    1e00:	07279163          	bne	a5,s2,1e62 <exitwait+0xa0>
  for(i = 0; i < 100; i++){
    1e04:	2905                	addiw	s2,s2,1
    1e06:	fd391ae3          	bne	s2,s3,1dda <exitwait+0x18>
}
    1e0a:	70e2                	ld	ra,56(sp)
    1e0c:	7442                	ld	s0,48(sp)
    1e0e:	74a2                	ld	s1,40(sp)
    1e10:	7902                	ld	s2,32(sp)
    1e12:	69e2                	ld	s3,24(sp)
    1e14:	6a42                	ld	s4,16(sp)
    1e16:	6121                	addi	sp,sp,64
    1e18:	8082                	ret
      printf("%s: fork failed\n", s);
    1e1a:	85d2                	mv	a1,s4
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	69450513          	addi	a0,a0,1684 # 74b0 <malloc+0x9c6>
    1e24:	00005097          	auipc	ra,0x5
    1e28:	c08080e7          	jalr	-1016(ra) # 6a2c <printf>
      exit(1,"");
    1e2c:	00006597          	auipc	a1,0x6
    1e30:	3ec58593          	addi	a1,a1,1004 # 8218 <malloc+0x172e>
    1e34:	4505                	li	a0,1
    1e36:	00005097          	auipc	ra,0x5
    1e3a:	856080e7          	jalr	-1962(ra) # 668c <exit>
        printf("%s: wait wrong pid\n", s);
    1e3e:	85d2                	mv	a1,s4
    1e40:	00005517          	auipc	a0,0x5
    1e44:	7f850513          	addi	a0,a0,2040 # 7638 <malloc+0xb4e>
    1e48:	00005097          	auipc	ra,0x5
    1e4c:	be4080e7          	jalr	-1052(ra) # 6a2c <printf>
        exit(1,"");
    1e50:	00006597          	auipc	a1,0x6
    1e54:	3c858593          	addi	a1,a1,968 # 8218 <malloc+0x172e>
    1e58:	4505                	li	a0,1
    1e5a:	00005097          	auipc	ra,0x5
    1e5e:	832080e7          	jalr	-1998(ra) # 668c <exit>
        printf("%s: wait wrong exit status\n", s);
    1e62:	85d2                	mv	a1,s4
    1e64:	00005517          	auipc	a0,0x5
    1e68:	7ec50513          	addi	a0,a0,2028 # 7650 <malloc+0xb66>
    1e6c:	00005097          	auipc	ra,0x5
    1e70:	bc0080e7          	jalr	-1088(ra) # 6a2c <printf>
        exit(1,"");
    1e74:	00006597          	auipc	a1,0x6
    1e78:	3a458593          	addi	a1,a1,932 # 8218 <malloc+0x172e>
    1e7c:	4505                	li	a0,1
    1e7e:	00005097          	auipc	ra,0x5
    1e82:	80e080e7          	jalr	-2034(ra) # 668c <exit>
      exit(i,"");
    1e86:	00006597          	auipc	a1,0x6
    1e8a:	39258593          	addi	a1,a1,914 # 8218 <malloc+0x172e>
    1e8e:	854a                	mv	a0,s2
    1e90:	00004097          	auipc	ra,0x4
    1e94:	7fc080e7          	jalr	2044(ra) # 668c <exit>

0000000000001e98 <twochildren>:
{
    1e98:	1101                	addi	sp,sp,-32
    1e9a:	ec06                	sd	ra,24(sp)
    1e9c:	e822                	sd	s0,16(sp)
    1e9e:	e426                	sd	s1,8(sp)
    1ea0:	e04a                	sd	s2,0(sp)
    1ea2:	1000                	addi	s0,sp,32
    1ea4:	892a                	mv	s2,a0
    1ea6:	3e800493          	li	s1,1000
    int pid1 = fork();
    1eaa:	00004097          	auipc	ra,0x4
    1eae:	7da080e7          	jalr	2010(ra) # 6684 <fork>
    if(pid1 < 0){
    1eb2:	02054e63          	bltz	a0,1eee <twochildren+0x56>
    if(pid1 == 0){
    1eb6:	cd31                	beqz	a0,1f12 <twochildren+0x7a>
      int pid2 = fork();
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	7cc080e7          	jalr	1996(ra) # 6684 <fork>
      if(pid2 < 0){
    1ec0:	06054163          	bltz	a0,1f22 <twochildren+0x8a>
      if(pid2 == 0){
    1ec4:	c149                	beqz	a0,1f46 <twochildren+0xae>
        wait(0,0);
    1ec6:	4581                	li	a1,0
    1ec8:	4501                	li	a0,0
    1eca:	00004097          	auipc	ra,0x4
    1ece:	7ca080e7          	jalr	1994(ra) # 6694 <wait>
        wait(0,0);
    1ed2:	4581                	li	a1,0
    1ed4:	4501                	li	a0,0
    1ed6:	00004097          	auipc	ra,0x4
    1eda:	7be080e7          	jalr	1982(ra) # 6694 <wait>
  for(int i = 0; i < 1000; i++){
    1ede:	34fd                	addiw	s1,s1,-1
    1ee0:	f4e9                	bnez	s1,1eaa <twochildren+0x12>
}
    1ee2:	60e2                	ld	ra,24(sp)
    1ee4:	6442                	ld	s0,16(sp)
    1ee6:	64a2                	ld	s1,8(sp)
    1ee8:	6902                	ld	s2,0(sp)
    1eea:	6105                	addi	sp,sp,32
    1eec:	8082                	ret
      printf("%s: fork failed\n", s);
    1eee:	85ca                	mv	a1,s2
    1ef0:	00005517          	auipc	a0,0x5
    1ef4:	5c050513          	addi	a0,a0,1472 # 74b0 <malloc+0x9c6>
    1ef8:	00005097          	auipc	ra,0x5
    1efc:	b34080e7          	jalr	-1228(ra) # 6a2c <printf>
      exit(1,"");
    1f00:	00006597          	auipc	a1,0x6
    1f04:	31858593          	addi	a1,a1,792 # 8218 <malloc+0x172e>
    1f08:	4505                	li	a0,1
    1f0a:	00004097          	auipc	ra,0x4
    1f0e:	782080e7          	jalr	1922(ra) # 668c <exit>
      exit(0,"");
    1f12:	00006597          	auipc	a1,0x6
    1f16:	30658593          	addi	a1,a1,774 # 8218 <malloc+0x172e>
    1f1a:	00004097          	auipc	ra,0x4
    1f1e:	772080e7          	jalr	1906(ra) # 668c <exit>
        printf("%s: fork failed\n", s);
    1f22:	85ca                	mv	a1,s2
    1f24:	00005517          	auipc	a0,0x5
    1f28:	58c50513          	addi	a0,a0,1420 # 74b0 <malloc+0x9c6>
    1f2c:	00005097          	auipc	ra,0x5
    1f30:	b00080e7          	jalr	-1280(ra) # 6a2c <printf>
        exit(1,"");
    1f34:	00006597          	auipc	a1,0x6
    1f38:	2e458593          	addi	a1,a1,740 # 8218 <malloc+0x172e>
    1f3c:	4505                	li	a0,1
    1f3e:	00004097          	auipc	ra,0x4
    1f42:	74e080e7          	jalr	1870(ra) # 668c <exit>
        exit(0,"");
    1f46:	00006597          	auipc	a1,0x6
    1f4a:	2d258593          	addi	a1,a1,722 # 8218 <malloc+0x172e>
    1f4e:	00004097          	auipc	ra,0x4
    1f52:	73e080e7          	jalr	1854(ra) # 668c <exit>

0000000000001f56 <forkfork>:
{
    1f56:	7179                	addi	sp,sp,-48
    1f58:	f406                	sd	ra,40(sp)
    1f5a:	f022                	sd	s0,32(sp)
    1f5c:	ec26                	sd	s1,24(sp)
    1f5e:	1800                	addi	s0,sp,48
    1f60:	84aa                	mv	s1,a0
    int pid = fork();
    1f62:	00004097          	auipc	ra,0x4
    1f66:	722080e7          	jalr	1826(ra) # 6684 <fork>
    if(pid < 0){
    1f6a:	04054363          	bltz	a0,1fb0 <forkfork+0x5a>
    if(pid == 0){
    1f6e:	c13d                	beqz	a0,1fd4 <forkfork+0x7e>
    int pid = fork();
    1f70:	00004097          	auipc	ra,0x4
    1f74:	714080e7          	jalr	1812(ra) # 6684 <fork>
    if(pid < 0){
    1f78:	02054c63          	bltz	a0,1fb0 <forkfork+0x5a>
    if(pid == 0){
    1f7c:	cd21                	beqz	a0,1fd4 <forkfork+0x7e>
    wait(&xstatus,0);
    1f7e:	4581                	li	a1,0
    1f80:	fdc40513          	addi	a0,s0,-36
    1f84:	00004097          	auipc	ra,0x4
    1f88:	710080e7          	jalr	1808(ra) # 6694 <wait>
    if(xstatus != 0) {
    1f8c:	fdc42783          	lw	a5,-36(s0)
    1f90:	efc9                	bnez	a5,202a <forkfork+0xd4>
    wait(&xstatus,0);
    1f92:	4581                	li	a1,0
    1f94:	fdc40513          	addi	a0,s0,-36
    1f98:	00004097          	auipc	ra,0x4
    1f9c:	6fc080e7          	jalr	1788(ra) # 6694 <wait>
    if(xstatus != 0) {
    1fa0:	fdc42783          	lw	a5,-36(s0)
    1fa4:	e3d9                	bnez	a5,202a <forkfork+0xd4>
}
    1fa6:	70a2                	ld	ra,40(sp)
    1fa8:	7402                	ld	s0,32(sp)
    1faa:	64e2                	ld	s1,24(sp)
    1fac:	6145                	addi	sp,sp,48
    1fae:	8082                	ret
      printf("%s: fork failed", s);
    1fb0:	85a6                	mv	a1,s1
    1fb2:	00005517          	auipc	a0,0x5
    1fb6:	6be50513          	addi	a0,a0,1726 # 7670 <malloc+0xb86>
    1fba:	00005097          	auipc	ra,0x5
    1fbe:	a72080e7          	jalr	-1422(ra) # 6a2c <printf>
      exit(1,"");
    1fc2:	00006597          	auipc	a1,0x6
    1fc6:	25658593          	addi	a1,a1,598 # 8218 <malloc+0x172e>
    1fca:	4505                	li	a0,1
    1fcc:	00004097          	auipc	ra,0x4
    1fd0:	6c0080e7          	jalr	1728(ra) # 668c <exit>
{
    1fd4:	0c800493          	li	s1,200
        int pid1 = fork();
    1fd8:	00004097          	auipc	ra,0x4
    1fdc:	6ac080e7          	jalr	1708(ra) # 6684 <fork>
        if(pid1 < 0){
    1fe0:	02054463          	bltz	a0,2008 <forkfork+0xb2>
        if(pid1 == 0){
    1fe4:	c91d                	beqz	a0,201a <forkfork+0xc4>
        wait(0,0);
    1fe6:	4581                	li	a1,0
    1fe8:	4501                	li	a0,0
    1fea:	00004097          	auipc	ra,0x4
    1fee:	6aa080e7          	jalr	1706(ra) # 6694 <wait>
      for(int j = 0; j < 200; j++){
    1ff2:	34fd                	addiw	s1,s1,-1
    1ff4:	f0f5                	bnez	s1,1fd8 <forkfork+0x82>
      exit(0,"");
    1ff6:	00006597          	auipc	a1,0x6
    1ffa:	22258593          	addi	a1,a1,546 # 8218 <malloc+0x172e>
    1ffe:	4501                	li	a0,0
    2000:	00004097          	auipc	ra,0x4
    2004:	68c080e7          	jalr	1676(ra) # 668c <exit>
          exit(1,"");
    2008:	00006597          	auipc	a1,0x6
    200c:	21058593          	addi	a1,a1,528 # 8218 <malloc+0x172e>
    2010:	4505                	li	a0,1
    2012:	00004097          	auipc	ra,0x4
    2016:	67a080e7          	jalr	1658(ra) # 668c <exit>
          exit(0,"");
    201a:	00006597          	auipc	a1,0x6
    201e:	1fe58593          	addi	a1,a1,510 # 8218 <malloc+0x172e>
    2022:	00004097          	auipc	ra,0x4
    2026:	66a080e7          	jalr	1642(ra) # 668c <exit>
      printf("%s: fork in child failed", s);
    202a:	85a6                	mv	a1,s1
    202c:	00005517          	auipc	a0,0x5
    2030:	65450513          	addi	a0,a0,1620 # 7680 <malloc+0xb96>
    2034:	00005097          	auipc	ra,0x5
    2038:	9f8080e7          	jalr	-1544(ra) # 6a2c <printf>
      exit(1,"");
    203c:	00006597          	auipc	a1,0x6
    2040:	1dc58593          	addi	a1,a1,476 # 8218 <malloc+0x172e>
    2044:	4505                	li	a0,1
    2046:	00004097          	auipc	ra,0x4
    204a:	646080e7          	jalr	1606(ra) # 668c <exit>

000000000000204e <reparent2>:
{
    204e:	1101                	addi	sp,sp,-32
    2050:	ec06                	sd	ra,24(sp)
    2052:	e822                	sd	s0,16(sp)
    2054:	e426                	sd	s1,8(sp)
    2056:	1000                	addi	s0,sp,32
    2058:	32000493          	li	s1,800
    int pid1 = fork();
    205c:	00004097          	auipc	ra,0x4
    2060:	628080e7          	jalr	1576(ra) # 6684 <fork>
    if(pid1 < 0){
    2064:	02054463          	bltz	a0,208c <reparent2+0x3e>
    if(pid1 == 0){
    2068:	c139                	beqz	a0,20ae <reparent2+0x60>
    wait(0,0);
    206a:	4581                	li	a1,0
    206c:	4501                	li	a0,0
    206e:	00004097          	auipc	ra,0x4
    2072:	626080e7          	jalr	1574(ra) # 6694 <wait>
  for(int i = 0; i < 800; i++){
    2076:	34fd                	addiw	s1,s1,-1
    2078:	f0f5                	bnez	s1,205c <reparent2+0xe>
  exit(0,"");
    207a:	00006597          	auipc	a1,0x6
    207e:	19e58593          	addi	a1,a1,414 # 8218 <malloc+0x172e>
    2082:	4501                	li	a0,0
    2084:	00004097          	auipc	ra,0x4
    2088:	608080e7          	jalr	1544(ra) # 668c <exit>
      printf("fork failed\n");
    208c:	00006517          	auipc	a0,0x6
    2090:	82c50513          	addi	a0,a0,-2004 # 78b8 <malloc+0xdce>
    2094:	00005097          	auipc	ra,0x5
    2098:	998080e7          	jalr	-1640(ra) # 6a2c <printf>
      exit(1,"");
    209c:	00006597          	auipc	a1,0x6
    20a0:	17c58593          	addi	a1,a1,380 # 8218 <malloc+0x172e>
    20a4:	4505                	li	a0,1
    20a6:	00004097          	auipc	ra,0x4
    20aa:	5e6080e7          	jalr	1510(ra) # 668c <exit>
      fork();
    20ae:	00004097          	auipc	ra,0x4
    20b2:	5d6080e7          	jalr	1494(ra) # 6684 <fork>
      fork();
    20b6:	00004097          	auipc	ra,0x4
    20ba:	5ce080e7          	jalr	1486(ra) # 6684 <fork>
      exit(0,"");
    20be:	00006597          	auipc	a1,0x6
    20c2:	15a58593          	addi	a1,a1,346 # 8218 <malloc+0x172e>
    20c6:	4501                	li	a0,0
    20c8:	00004097          	auipc	ra,0x4
    20cc:	5c4080e7          	jalr	1476(ra) # 668c <exit>

00000000000020d0 <createdelete>:
{
    20d0:	7175                	addi	sp,sp,-144
    20d2:	e506                	sd	ra,136(sp)
    20d4:	e122                	sd	s0,128(sp)
    20d6:	fca6                	sd	s1,120(sp)
    20d8:	f8ca                	sd	s2,112(sp)
    20da:	f4ce                	sd	s3,104(sp)
    20dc:	f0d2                	sd	s4,96(sp)
    20de:	ecd6                	sd	s5,88(sp)
    20e0:	e8da                	sd	s6,80(sp)
    20e2:	e4de                	sd	s7,72(sp)
    20e4:	e0e2                	sd	s8,64(sp)
    20e6:	fc66                	sd	s9,56(sp)
    20e8:	0900                	addi	s0,sp,144
    20ea:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    20ec:	4901                	li	s2,0
    20ee:	4991                	li	s3,4
    pid = fork();
    20f0:	00004097          	auipc	ra,0x4
    20f4:	594080e7          	jalr	1428(ra) # 6684 <fork>
    20f8:	84aa                	mv	s1,a0
    if(pid < 0){
    20fa:	04054063          	bltz	a0,213a <createdelete+0x6a>
    if(pid == 0){
    20fe:	c125                	beqz	a0,215e <createdelete+0x8e>
  for(pi = 0; pi < NCHILD; pi++){
    2100:	2905                	addiw	s2,s2,1
    2102:	ff3917e3          	bne	s2,s3,20f0 <createdelete+0x20>
    2106:	4491                	li	s1,4
    wait(&xstatus,0);
    2108:	4581                	li	a1,0
    210a:	f7c40513          	addi	a0,s0,-132
    210e:	00004097          	auipc	ra,0x4
    2112:	586080e7          	jalr	1414(ra) # 6694 <wait>
    if(xstatus != 0)
    2116:	f7c42903          	lw	s2,-132(s0)
    211a:	10091263          	bnez	s2,221e <createdelete+0x14e>
  for(pi = 0; pi < NCHILD; pi++){
    211e:	34fd                	addiw	s1,s1,-1
    2120:	f4e5                	bnez	s1,2108 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    2122:	f8040123          	sb	zero,-126(s0)
    2126:	03000993          	li	s3,48
    212a:	5a7d                	li	s4,-1
    212c:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2130:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    2132:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    2134:	07400a93          	li	s5,116
    2138:	aa79                	j	22d6 <createdelete+0x206>
      printf("fork failed\n", s);
    213a:	85e6                	mv	a1,s9
    213c:	00005517          	auipc	a0,0x5
    2140:	77c50513          	addi	a0,a0,1916 # 78b8 <malloc+0xdce>
    2144:	00005097          	auipc	ra,0x5
    2148:	8e8080e7          	jalr	-1816(ra) # 6a2c <printf>
      exit(1,"");
    214c:	00006597          	auipc	a1,0x6
    2150:	0cc58593          	addi	a1,a1,204 # 8218 <malloc+0x172e>
    2154:	4505                	li	a0,1
    2156:	00004097          	auipc	ra,0x4
    215a:	536080e7          	jalr	1334(ra) # 668c <exit>
      name[0] = 'p' + pi;
    215e:	0709091b          	addiw	s2,s2,112
    2162:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    2166:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    216a:	4951                	li	s2,20
    216c:	a035                	j	2198 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    216e:	85e6                	mv	a1,s9
    2170:	00005517          	auipc	a0,0x5
    2174:	3d850513          	addi	a0,a0,984 # 7548 <malloc+0xa5e>
    2178:	00005097          	auipc	ra,0x5
    217c:	8b4080e7          	jalr	-1868(ra) # 6a2c <printf>
          exit(1,"");
    2180:	00006597          	auipc	a1,0x6
    2184:	09858593          	addi	a1,a1,152 # 8218 <malloc+0x172e>
    2188:	4505                	li	a0,1
    218a:	00004097          	auipc	ra,0x4
    218e:	502080e7          	jalr	1282(ra) # 668c <exit>
      for(i = 0; i < N; i++){
    2192:	2485                	addiw	s1,s1,1
    2194:	07248c63          	beq	s1,s2,220c <createdelete+0x13c>
        name[1] = '0' + i;
    2198:	0304879b          	addiw	a5,s1,48
    219c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    21a0:	20200593          	li	a1,514
    21a4:	f8040513          	addi	a0,s0,-128
    21a8:	00004097          	auipc	ra,0x4
    21ac:	524080e7          	jalr	1316(ra) # 66cc <open>
        if(fd < 0){
    21b0:	fa054fe3          	bltz	a0,216e <createdelete+0x9e>
        close(fd);
    21b4:	00004097          	auipc	ra,0x4
    21b8:	500080e7          	jalr	1280(ra) # 66b4 <close>
        if(i > 0 && (i % 2 ) == 0){
    21bc:	fc905be3          	blez	s1,2192 <createdelete+0xc2>
    21c0:	0014f793          	andi	a5,s1,1
    21c4:	f7f9                	bnez	a5,2192 <createdelete+0xc2>
          name[1] = '0' + (i / 2);
    21c6:	01f4d79b          	srliw	a5,s1,0x1f
    21ca:	9fa5                	addw	a5,a5,s1
    21cc:	4017d79b          	sraiw	a5,a5,0x1
    21d0:	0307879b          	addiw	a5,a5,48
    21d4:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    21d8:	f8040513          	addi	a0,s0,-128
    21dc:	00004097          	auipc	ra,0x4
    21e0:	500080e7          	jalr	1280(ra) # 66dc <unlink>
    21e4:	fa0557e3          	bgez	a0,2192 <createdelete+0xc2>
            printf("%s: unlink failed\n", s);
    21e8:	85e6                	mv	a1,s9
    21ea:	00005517          	auipc	a0,0x5
    21ee:	4b650513          	addi	a0,a0,1206 # 76a0 <malloc+0xbb6>
    21f2:	00005097          	auipc	ra,0x5
    21f6:	83a080e7          	jalr	-1990(ra) # 6a2c <printf>
            exit(1,"");
    21fa:	00006597          	auipc	a1,0x6
    21fe:	01e58593          	addi	a1,a1,30 # 8218 <malloc+0x172e>
    2202:	4505                	li	a0,1
    2204:	00004097          	auipc	ra,0x4
    2208:	488080e7          	jalr	1160(ra) # 668c <exit>
      exit(0,"");
    220c:	00006597          	auipc	a1,0x6
    2210:	00c58593          	addi	a1,a1,12 # 8218 <malloc+0x172e>
    2214:	4501                	li	a0,0
    2216:	00004097          	auipc	ra,0x4
    221a:	476080e7          	jalr	1142(ra) # 668c <exit>
      exit(1,"");
    221e:	00006597          	auipc	a1,0x6
    2222:	ffa58593          	addi	a1,a1,-6 # 8218 <malloc+0x172e>
    2226:	4505                	li	a0,1
    2228:	00004097          	auipc	ra,0x4
    222c:	464080e7          	jalr	1124(ra) # 668c <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    2230:	f8040613          	addi	a2,s0,-128
    2234:	85e6                	mv	a1,s9
    2236:	00005517          	auipc	a0,0x5
    223a:	48250513          	addi	a0,a0,1154 # 76b8 <malloc+0xbce>
    223e:	00004097          	auipc	ra,0x4
    2242:	7ee080e7          	jalr	2030(ra) # 6a2c <printf>
        exit(1,"");
    2246:	00006597          	auipc	a1,0x6
    224a:	fd258593          	addi	a1,a1,-46 # 8218 <malloc+0x172e>
    224e:	4505                	li	a0,1
    2250:	00004097          	auipc	ra,0x4
    2254:	43c080e7          	jalr	1084(ra) # 668c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2258:	054b7163          	bgeu	s6,s4,229a <createdelete+0x1ca>
      if(fd >= 0)
    225c:	02055a63          	bgez	a0,2290 <createdelete+0x1c0>
    for(pi = 0; pi < NCHILD; pi++){
    2260:	2485                	addiw	s1,s1,1
    2262:	0ff4f493          	andi	s1,s1,255
    2266:	07548063          	beq	s1,s5,22c6 <createdelete+0x1f6>
      name[0] = 'p' + pi;
    226a:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    226e:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    2272:	4581                	li	a1,0
    2274:	f8040513          	addi	a0,s0,-128
    2278:	00004097          	auipc	ra,0x4
    227c:	454080e7          	jalr	1108(ra) # 66cc <open>
      if((i == 0 || i >= N/2) && fd < 0){
    2280:	00090463          	beqz	s2,2288 <createdelete+0x1b8>
    2284:	fd2bdae3          	bge	s7,s2,2258 <createdelete+0x188>
    2288:	fa0544e3          	bltz	a0,2230 <createdelete+0x160>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    228c:	014b7963          	bgeu	s6,s4,229e <createdelete+0x1ce>
        close(fd);
    2290:	00004097          	auipc	ra,0x4
    2294:	424080e7          	jalr	1060(ra) # 66b4 <close>
    2298:	b7e1                	j	2260 <createdelete+0x190>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    229a:	fc0543e3          	bltz	a0,2260 <createdelete+0x190>
        printf("%s: oops createdelete %s did exist\n", s, name);
    229e:	f8040613          	addi	a2,s0,-128
    22a2:	85e6                	mv	a1,s9
    22a4:	00005517          	auipc	a0,0x5
    22a8:	43c50513          	addi	a0,a0,1084 # 76e0 <malloc+0xbf6>
    22ac:	00004097          	auipc	ra,0x4
    22b0:	780080e7          	jalr	1920(ra) # 6a2c <printf>
        exit(1,"");
    22b4:	00006597          	auipc	a1,0x6
    22b8:	f6458593          	addi	a1,a1,-156 # 8218 <malloc+0x172e>
    22bc:	4505                	li	a0,1
    22be:	00004097          	auipc	ra,0x4
    22c2:	3ce080e7          	jalr	974(ra) # 668c <exit>
  for(i = 0; i < N; i++){
    22c6:	2905                	addiw	s2,s2,1
    22c8:	2a05                	addiw	s4,s4,1
    22ca:	2985                	addiw	s3,s3,1
    22cc:	0ff9f993          	andi	s3,s3,255
    22d0:	47d1                	li	a5,20
    22d2:	02f90a63          	beq	s2,a5,2306 <createdelete+0x236>
    for(pi = 0; pi < NCHILD; pi++){
    22d6:	84e2                	mv	s1,s8
    22d8:	bf49                	j	226a <createdelete+0x19a>
  for(i = 0; i < N; i++){
    22da:	2905                	addiw	s2,s2,1
    22dc:	0ff97913          	andi	s2,s2,255
    22e0:	2985                	addiw	s3,s3,1
    22e2:	0ff9f993          	andi	s3,s3,255
    22e6:	03490863          	beq	s2,s4,2316 <createdelete+0x246>
  name[0] = name[1] = name[2] = 0;
    22ea:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    22ec:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    22f0:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    22f4:	f8040513          	addi	a0,s0,-128
    22f8:	00004097          	auipc	ra,0x4
    22fc:	3e4080e7          	jalr	996(ra) # 66dc <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    2300:	34fd                	addiw	s1,s1,-1
    2302:	f4ed                	bnez	s1,22ec <createdelete+0x21c>
    2304:	bfd9                	j	22da <createdelete+0x20a>
    2306:	03000993          	li	s3,48
    230a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    230e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    2310:	08400a13          	li	s4,132
    2314:	bfd9                	j	22ea <createdelete+0x21a>
}
    2316:	60aa                	ld	ra,136(sp)
    2318:	640a                	ld	s0,128(sp)
    231a:	74e6                	ld	s1,120(sp)
    231c:	7946                	ld	s2,112(sp)
    231e:	79a6                	ld	s3,104(sp)
    2320:	7a06                	ld	s4,96(sp)
    2322:	6ae6                	ld	s5,88(sp)
    2324:	6b46                	ld	s6,80(sp)
    2326:	6ba6                	ld	s7,72(sp)
    2328:	6c06                	ld	s8,64(sp)
    232a:	7ce2                	ld	s9,56(sp)
    232c:	6149                	addi	sp,sp,144
    232e:	8082                	ret

0000000000002330 <linkunlink>:
{
    2330:	711d                	addi	sp,sp,-96
    2332:	ec86                	sd	ra,88(sp)
    2334:	e8a2                	sd	s0,80(sp)
    2336:	e4a6                	sd	s1,72(sp)
    2338:	e0ca                	sd	s2,64(sp)
    233a:	fc4e                	sd	s3,56(sp)
    233c:	f852                	sd	s4,48(sp)
    233e:	f456                	sd	s5,40(sp)
    2340:	f05a                	sd	s6,32(sp)
    2342:	ec5e                	sd	s7,24(sp)
    2344:	e862                	sd	s8,16(sp)
    2346:	e466                	sd	s9,8(sp)
    2348:	1080                	addi	s0,sp,96
    234a:	84aa                	mv	s1,a0
  unlink("x");
    234c:	00005517          	auipc	a0,0x5
    2350:	94c50513          	addi	a0,a0,-1716 # 6c98 <malloc+0x1ae>
    2354:	00004097          	auipc	ra,0x4
    2358:	388080e7          	jalr	904(ra) # 66dc <unlink>
  pid = fork();
    235c:	00004097          	auipc	ra,0x4
    2360:	328080e7          	jalr	808(ra) # 6684 <fork>
  if(pid < 0){
    2364:	02054b63          	bltz	a0,239a <linkunlink+0x6a>
    2368:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    236a:	4c85                	li	s9,1
    236c:	e119                	bnez	a0,2372 <linkunlink+0x42>
    236e:	06100c93          	li	s9,97
    2372:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2376:	41c659b7          	lui	s3,0x41c65
    237a:	e6d9899b          	addiw	s3,s3,-403
    237e:	690d                	lui	s2,0x3
    2380:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    2384:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    2386:	4b05                	li	s6,1
      unlink("x");
    2388:	00005a97          	auipc	s5,0x5
    238c:	910a8a93          	addi	s5,s5,-1776 # 6c98 <malloc+0x1ae>
      link("cat", "x");
    2390:	00005b97          	auipc	s7,0x5
    2394:	378b8b93          	addi	s7,s7,888 # 7708 <malloc+0xc1e>
    2398:	a0b1                	j	23e4 <linkunlink+0xb4>
    printf("%s: fork failed\n", s);
    239a:	85a6                	mv	a1,s1
    239c:	00005517          	auipc	a0,0x5
    23a0:	11450513          	addi	a0,a0,276 # 74b0 <malloc+0x9c6>
    23a4:	00004097          	auipc	ra,0x4
    23a8:	688080e7          	jalr	1672(ra) # 6a2c <printf>
    exit(1,"");
    23ac:	00006597          	auipc	a1,0x6
    23b0:	e6c58593          	addi	a1,a1,-404 # 8218 <malloc+0x172e>
    23b4:	4505                	li	a0,1
    23b6:	00004097          	auipc	ra,0x4
    23ba:	2d6080e7          	jalr	726(ra) # 668c <exit>
      close(open("x", O_RDWR | O_CREATE));
    23be:	20200593          	li	a1,514
    23c2:	8556                	mv	a0,s5
    23c4:	00004097          	auipc	ra,0x4
    23c8:	308080e7          	jalr	776(ra) # 66cc <open>
    23cc:	00004097          	auipc	ra,0x4
    23d0:	2e8080e7          	jalr	744(ra) # 66b4 <close>
    23d4:	a031                	j	23e0 <linkunlink+0xb0>
      unlink("x");
    23d6:	8556                	mv	a0,s5
    23d8:	00004097          	auipc	ra,0x4
    23dc:	304080e7          	jalr	772(ra) # 66dc <unlink>
  for(i = 0; i < 100; i++){
    23e0:	34fd                	addiw	s1,s1,-1
    23e2:	c09d                	beqz	s1,2408 <linkunlink+0xd8>
    x = x * 1103515245 + 12345;
    23e4:	033c87bb          	mulw	a5,s9,s3
    23e8:	012787bb          	addw	a5,a5,s2
    23ec:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    23f0:	0347f7bb          	remuw	a5,a5,s4
    23f4:	d7e9                	beqz	a5,23be <linkunlink+0x8e>
    } else if((x % 3) == 1){
    23f6:	ff6790e3          	bne	a5,s6,23d6 <linkunlink+0xa6>
      link("cat", "x");
    23fa:	85d6                	mv	a1,s5
    23fc:	855e                	mv	a0,s7
    23fe:	00004097          	auipc	ra,0x4
    2402:	2ee080e7          	jalr	750(ra) # 66ec <link>
    2406:	bfe9                	j	23e0 <linkunlink+0xb0>
  if(pid)
    2408:	020c0563          	beqz	s8,2432 <linkunlink+0x102>
    wait(0,0);
    240c:	4581                	li	a1,0
    240e:	4501                	li	a0,0
    2410:	00004097          	auipc	ra,0x4
    2414:	284080e7          	jalr	644(ra) # 6694 <wait>
}
    2418:	60e6                	ld	ra,88(sp)
    241a:	6446                	ld	s0,80(sp)
    241c:	64a6                	ld	s1,72(sp)
    241e:	6906                	ld	s2,64(sp)
    2420:	79e2                	ld	s3,56(sp)
    2422:	7a42                	ld	s4,48(sp)
    2424:	7aa2                	ld	s5,40(sp)
    2426:	7b02                	ld	s6,32(sp)
    2428:	6be2                	ld	s7,24(sp)
    242a:	6c42                	ld	s8,16(sp)
    242c:	6ca2                	ld	s9,8(sp)
    242e:	6125                	addi	sp,sp,96
    2430:	8082                	ret
    exit(0,"");
    2432:	00006597          	auipc	a1,0x6
    2436:	de658593          	addi	a1,a1,-538 # 8218 <malloc+0x172e>
    243a:	4501                	li	a0,0
    243c:	00004097          	auipc	ra,0x4
    2440:	250080e7          	jalr	592(ra) # 668c <exit>

0000000000002444 <forktest>:
{
    2444:	7179                	addi	sp,sp,-48
    2446:	f406                	sd	ra,40(sp)
    2448:	f022                	sd	s0,32(sp)
    244a:	ec26                	sd	s1,24(sp)
    244c:	e84a                	sd	s2,16(sp)
    244e:	e44e                	sd	s3,8(sp)
    2450:	1800                	addi	s0,sp,48
    2452:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2454:	4481                	li	s1,0
    2456:	3e800913          	li	s2,1000
    pid = fork();
    245a:	00004097          	auipc	ra,0x4
    245e:	22a080e7          	jalr	554(ra) # 6684 <fork>
    if(pid < 0)
    2462:	04054063          	bltz	a0,24a2 <forktest+0x5e>
    if(pid == 0)
    2466:	c515                	beqz	a0,2492 <forktest+0x4e>
  for(n=0; n<N; n++){
    2468:	2485                	addiw	s1,s1,1
    246a:	ff2498e3          	bne	s1,s2,245a <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    246e:	85ce                	mv	a1,s3
    2470:	00005517          	auipc	a0,0x5
    2474:	2b850513          	addi	a0,a0,696 # 7728 <malloc+0xc3e>
    2478:	00004097          	auipc	ra,0x4
    247c:	5b4080e7          	jalr	1460(ra) # 6a2c <printf>
    exit(1,"");
    2480:	00006597          	auipc	a1,0x6
    2484:	d9858593          	addi	a1,a1,-616 # 8218 <malloc+0x172e>
    2488:	4505                	li	a0,1
    248a:	00004097          	auipc	ra,0x4
    248e:	202080e7          	jalr	514(ra) # 668c <exit>
      exit(0,"");
    2492:	00006597          	auipc	a1,0x6
    2496:	d8658593          	addi	a1,a1,-634 # 8218 <malloc+0x172e>
    249a:	00004097          	auipc	ra,0x4
    249e:	1f2080e7          	jalr	498(ra) # 668c <exit>
  if (n == 0) {
    24a2:	c0a9                	beqz	s1,24e4 <forktest+0xa0>
  if(n == N){
    24a4:	3e800793          	li	a5,1000
    24a8:	fcf483e3          	beq	s1,a5,246e <forktest+0x2a>
  for(; n > 0; n--){
    24ac:	00905c63          	blez	s1,24c4 <forktest+0x80>
    if(wait(0,0) < 0){
    24b0:	4581                	li	a1,0
    24b2:	4501                	li	a0,0
    24b4:	00004097          	auipc	ra,0x4
    24b8:	1e0080e7          	jalr	480(ra) # 6694 <wait>
    24bc:	04054663          	bltz	a0,2508 <forktest+0xc4>
  for(; n > 0; n--){
    24c0:	34fd                	addiw	s1,s1,-1
    24c2:	f4fd                	bnez	s1,24b0 <forktest+0x6c>
  if(wait(0,0) != -1){
    24c4:	4581                	li	a1,0
    24c6:	4501                	li	a0,0
    24c8:	00004097          	auipc	ra,0x4
    24cc:	1cc080e7          	jalr	460(ra) # 6694 <wait>
    24d0:	57fd                	li	a5,-1
    24d2:	04f51d63          	bne	a0,a5,252c <forktest+0xe8>
}
    24d6:	70a2                	ld	ra,40(sp)
    24d8:	7402                	ld	s0,32(sp)
    24da:	64e2                	ld	s1,24(sp)
    24dc:	6942                	ld	s2,16(sp)
    24de:	69a2                	ld	s3,8(sp)
    24e0:	6145                	addi	sp,sp,48
    24e2:	8082                	ret
    printf("%s: no fork at all!\n", s);
    24e4:	85ce                	mv	a1,s3
    24e6:	00005517          	auipc	a0,0x5
    24ea:	22a50513          	addi	a0,a0,554 # 7710 <malloc+0xc26>
    24ee:	00004097          	auipc	ra,0x4
    24f2:	53e080e7          	jalr	1342(ra) # 6a2c <printf>
    exit(1,"");
    24f6:	00006597          	auipc	a1,0x6
    24fa:	d2258593          	addi	a1,a1,-734 # 8218 <malloc+0x172e>
    24fe:	4505                	li	a0,1
    2500:	00004097          	auipc	ra,0x4
    2504:	18c080e7          	jalr	396(ra) # 668c <exit>
      printf("%s: wait stopped early\n", s);
    2508:	85ce                	mv	a1,s3
    250a:	00005517          	auipc	a0,0x5
    250e:	24650513          	addi	a0,a0,582 # 7750 <malloc+0xc66>
    2512:	00004097          	auipc	ra,0x4
    2516:	51a080e7          	jalr	1306(ra) # 6a2c <printf>
      exit(1,"");
    251a:	00006597          	auipc	a1,0x6
    251e:	cfe58593          	addi	a1,a1,-770 # 8218 <malloc+0x172e>
    2522:	4505                	li	a0,1
    2524:	00004097          	auipc	ra,0x4
    2528:	168080e7          	jalr	360(ra) # 668c <exit>
    printf("%s: wait got too many\n", s);
    252c:	85ce                	mv	a1,s3
    252e:	00005517          	auipc	a0,0x5
    2532:	23a50513          	addi	a0,a0,570 # 7768 <malloc+0xc7e>
    2536:	00004097          	auipc	ra,0x4
    253a:	4f6080e7          	jalr	1270(ra) # 6a2c <printf>
    exit(1,"");
    253e:	00006597          	auipc	a1,0x6
    2542:	cda58593          	addi	a1,a1,-806 # 8218 <malloc+0x172e>
    2546:	4505                	li	a0,1
    2548:	00004097          	auipc	ra,0x4
    254c:	144080e7          	jalr	324(ra) # 668c <exit>

0000000000002550 <kernmem>:
{
    2550:	715d                	addi	sp,sp,-80
    2552:	e486                	sd	ra,72(sp)
    2554:	e0a2                	sd	s0,64(sp)
    2556:	fc26                	sd	s1,56(sp)
    2558:	f84a                	sd	s2,48(sp)
    255a:	f44e                	sd	s3,40(sp)
    255c:	f052                	sd	s4,32(sp)
    255e:	ec56                	sd	s5,24(sp)
    2560:	0880                	addi	s0,sp,80
    2562:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2564:	4485                	li	s1,1
    2566:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2568:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    256a:	69b1                	lui	s3,0xc
    256c:	35098993          	addi	s3,s3,848 # c350 <uninit+0xde8>
    2570:	1003d937          	lui	s2,0x1003d
    2574:	090e                	slli	s2,s2,0x3
    2576:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c808>
    pid = fork();
    257a:	00004097          	auipc	ra,0x4
    257e:	10a080e7          	jalr	266(ra) # 6684 <fork>
    if(pid < 0){
    2582:	02054a63          	bltz	a0,25b6 <kernmem+0x66>
    if(pid == 0){
    2586:	c931                	beqz	a0,25da <kernmem+0x8a>
    wait(&xstatus,0);
    2588:	4581                	li	a1,0
    258a:	fbc40513          	addi	a0,s0,-68
    258e:	00004097          	auipc	ra,0x4
    2592:	106080e7          	jalr	262(ra) # 6694 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2596:	fbc42783          	lw	a5,-68(s0)
    259a:	07579563          	bne	a5,s5,2604 <kernmem+0xb4>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    259e:	94ce                	add	s1,s1,s3
    25a0:	fd249de3          	bne	s1,s2,257a <kernmem+0x2a>
}
    25a4:	60a6                	ld	ra,72(sp)
    25a6:	6406                	ld	s0,64(sp)
    25a8:	74e2                	ld	s1,56(sp)
    25aa:	7942                	ld	s2,48(sp)
    25ac:	79a2                	ld	s3,40(sp)
    25ae:	7a02                	ld	s4,32(sp)
    25b0:	6ae2                	ld	s5,24(sp)
    25b2:	6161                	addi	sp,sp,80
    25b4:	8082                	ret
      printf("%s: fork failed\n", s);
    25b6:	85d2                	mv	a1,s4
    25b8:	00005517          	auipc	a0,0x5
    25bc:	ef850513          	addi	a0,a0,-264 # 74b0 <malloc+0x9c6>
    25c0:	00004097          	auipc	ra,0x4
    25c4:	46c080e7          	jalr	1132(ra) # 6a2c <printf>
      exit(1,"");
    25c8:	00006597          	auipc	a1,0x6
    25cc:	c5058593          	addi	a1,a1,-944 # 8218 <malloc+0x172e>
    25d0:	4505                	li	a0,1
    25d2:	00004097          	auipc	ra,0x4
    25d6:	0ba080e7          	jalr	186(ra) # 668c <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    25da:	0004c683          	lbu	a3,0(s1)
    25de:	8626                	mv	a2,s1
    25e0:	85d2                	mv	a1,s4
    25e2:	00005517          	auipc	a0,0x5
    25e6:	19e50513          	addi	a0,a0,414 # 7780 <malloc+0xc96>
    25ea:	00004097          	auipc	ra,0x4
    25ee:	442080e7          	jalr	1090(ra) # 6a2c <printf>
      exit(1,"");
    25f2:	00006597          	auipc	a1,0x6
    25f6:	c2658593          	addi	a1,a1,-986 # 8218 <malloc+0x172e>
    25fa:	4505                	li	a0,1
    25fc:	00004097          	auipc	ra,0x4
    2600:	090080e7          	jalr	144(ra) # 668c <exit>
      exit(1,"");
    2604:	00006597          	auipc	a1,0x6
    2608:	c1458593          	addi	a1,a1,-1004 # 8218 <malloc+0x172e>
    260c:	4505                	li	a0,1
    260e:	00004097          	auipc	ra,0x4
    2612:	07e080e7          	jalr	126(ra) # 668c <exit>

0000000000002616 <MAXVAplus>:
{
    2616:	7179                	addi	sp,sp,-48
    2618:	f406                	sd	ra,40(sp)
    261a:	f022                	sd	s0,32(sp)
    261c:	ec26                	sd	s1,24(sp)
    261e:	e84a                	sd	s2,16(sp)
    2620:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2622:	4785                	li	a5,1
    2624:	179a                	slli	a5,a5,0x26
    2626:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    262a:	fd843783          	ld	a5,-40(s0)
    262e:	cf8d                	beqz	a5,2668 <MAXVAplus+0x52>
    2630:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2632:	54fd                	li	s1,-1
    pid = fork();
    2634:	00004097          	auipc	ra,0x4
    2638:	050080e7          	jalr	80(ra) # 6684 <fork>
    if(pid < 0){
    263c:	02054c63          	bltz	a0,2674 <MAXVAplus+0x5e>
    if(pid == 0){
    2640:	cd21                	beqz	a0,2698 <MAXVAplus+0x82>
    wait(&xstatus,0);
    2642:	4581                	li	a1,0
    2644:	fd440513          	addi	a0,s0,-44
    2648:	00004097          	auipc	ra,0x4
    264c:	04c080e7          	jalr	76(ra) # 6694 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2650:	fd442783          	lw	a5,-44(s0)
    2654:	06979c63          	bne	a5,s1,26cc <MAXVAplus+0xb6>
  for( ; a != 0; a <<= 1){
    2658:	fd843783          	ld	a5,-40(s0)
    265c:	0786                	slli	a5,a5,0x1
    265e:	fcf43c23          	sd	a5,-40(s0)
    2662:	fd843783          	ld	a5,-40(s0)
    2666:	f7f9                	bnez	a5,2634 <MAXVAplus+0x1e>
}
    2668:	70a2                	ld	ra,40(sp)
    266a:	7402                	ld	s0,32(sp)
    266c:	64e2                	ld	s1,24(sp)
    266e:	6942                	ld	s2,16(sp)
    2670:	6145                	addi	sp,sp,48
    2672:	8082                	ret
      printf("%s: fork failed\n", s);
    2674:	85ca                	mv	a1,s2
    2676:	00005517          	auipc	a0,0x5
    267a:	e3a50513          	addi	a0,a0,-454 # 74b0 <malloc+0x9c6>
    267e:	00004097          	auipc	ra,0x4
    2682:	3ae080e7          	jalr	942(ra) # 6a2c <printf>
      exit(1,"");
    2686:	00006597          	auipc	a1,0x6
    268a:	b9258593          	addi	a1,a1,-1134 # 8218 <malloc+0x172e>
    268e:	4505                	li	a0,1
    2690:	00004097          	auipc	ra,0x4
    2694:	ffc080e7          	jalr	-4(ra) # 668c <exit>
      *(char*)a = 99;
    2698:	fd843783          	ld	a5,-40(s0)
    269c:	06300713          	li	a4,99
    26a0:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    26a4:	fd843603          	ld	a2,-40(s0)
    26a8:	85ca                	mv	a1,s2
    26aa:	00005517          	auipc	a0,0x5
    26ae:	0f650513          	addi	a0,a0,246 # 77a0 <malloc+0xcb6>
    26b2:	00004097          	auipc	ra,0x4
    26b6:	37a080e7          	jalr	890(ra) # 6a2c <printf>
      exit(1,"");
    26ba:	00006597          	auipc	a1,0x6
    26be:	b5e58593          	addi	a1,a1,-1186 # 8218 <malloc+0x172e>
    26c2:	4505                	li	a0,1
    26c4:	00004097          	auipc	ra,0x4
    26c8:	fc8080e7          	jalr	-56(ra) # 668c <exit>
      exit(1,"");
    26cc:	00006597          	auipc	a1,0x6
    26d0:	b4c58593          	addi	a1,a1,-1204 # 8218 <malloc+0x172e>
    26d4:	4505                	li	a0,1
    26d6:	00004097          	auipc	ra,0x4
    26da:	fb6080e7          	jalr	-74(ra) # 668c <exit>

00000000000026de <bigargtest>:
{
    26de:	7179                	addi	sp,sp,-48
    26e0:	f406                	sd	ra,40(sp)
    26e2:	f022                	sd	s0,32(sp)
    26e4:	ec26                	sd	s1,24(sp)
    26e6:	1800                	addi	s0,sp,48
    26e8:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    26ea:	00005517          	auipc	a0,0x5
    26ee:	0ce50513          	addi	a0,a0,206 # 77b8 <malloc+0xcce>
    26f2:	00004097          	auipc	ra,0x4
    26f6:	fea080e7          	jalr	-22(ra) # 66dc <unlink>
  pid = fork();
    26fa:	00004097          	auipc	ra,0x4
    26fe:	f8a080e7          	jalr	-118(ra) # 6684 <fork>
  if(pid == 0){
    2702:	c129                	beqz	a0,2744 <bigargtest+0x66>
  } else if(pid < 0){
    2704:	0a054563          	bltz	a0,27ae <bigargtest+0xd0>
  wait(&xstatus,0);
    2708:	4581                	li	a1,0
    270a:	fdc40513          	addi	a0,s0,-36
    270e:	00004097          	auipc	ra,0x4
    2712:	f86080e7          	jalr	-122(ra) # 6694 <wait>
  if(xstatus != 0)
    2716:	fdc42503          	lw	a0,-36(s0)
    271a:	ed45                	bnez	a0,27d2 <bigargtest+0xf4>
  fd = open("bigarg-ok", 0);
    271c:	4581                	li	a1,0
    271e:	00005517          	auipc	a0,0x5
    2722:	09a50513          	addi	a0,a0,154 # 77b8 <malloc+0xcce>
    2726:	00004097          	auipc	ra,0x4
    272a:	fa6080e7          	jalr	-90(ra) # 66cc <open>
  if(fd < 0){
    272e:	0a054a63          	bltz	a0,27e2 <bigargtest+0x104>
  close(fd);
    2732:	00004097          	auipc	ra,0x4
    2736:	f82080e7          	jalr	-126(ra) # 66b4 <close>
}
    273a:	70a2                	ld	ra,40(sp)
    273c:	7402                	ld	s0,32(sp)
    273e:	64e2                	ld	s1,24(sp)
    2740:	6145                	addi	sp,sp,48
    2742:	8082                	ret
    2744:	00008797          	auipc	a5,0x8
    2748:	d1c78793          	addi	a5,a5,-740 # a460 <args.1827>
    274c:	00008697          	auipc	a3,0x8
    2750:	e0c68693          	addi	a3,a3,-500 # a558 <args.1827+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2754:	00005717          	auipc	a4,0x5
    2758:	07470713          	addi	a4,a4,116 # 77c8 <malloc+0xcde>
    275c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    275e:	07a1                	addi	a5,a5,8
    2760:	fed79ee3          	bne	a5,a3,275c <bigargtest+0x7e>
    args[MAXARG-1] = 0;
    2764:	00008597          	auipc	a1,0x8
    2768:	cfc58593          	addi	a1,a1,-772 # a460 <args.1827>
    276c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2770:	00004517          	auipc	a0,0x4
    2774:	4b850513          	addi	a0,a0,1208 # 6c28 <malloc+0x13e>
    2778:	00004097          	auipc	ra,0x4
    277c:	f4c080e7          	jalr	-180(ra) # 66c4 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2780:	20000593          	li	a1,512
    2784:	00005517          	auipc	a0,0x5
    2788:	03450513          	addi	a0,a0,52 # 77b8 <malloc+0xcce>
    278c:	00004097          	auipc	ra,0x4
    2790:	f40080e7          	jalr	-192(ra) # 66cc <open>
    close(fd);
    2794:	00004097          	auipc	ra,0x4
    2798:	f20080e7          	jalr	-224(ra) # 66b4 <close>
    exit(0,"");
    279c:	00006597          	auipc	a1,0x6
    27a0:	a7c58593          	addi	a1,a1,-1412 # 8218 <malloc+0x172e>
    27a4:	4501                	li	a0,0
    27a6:	00004097          	auipc	ra,0x4
    27aa:	ee6080e7          	jalr	-282(ra) # 668c <exit>
    printf("%s: bigargtest: fork failed\n", s);
    27ae:	85a6                	mv	a1,s1
    27b0:	00005517          	auipc	a0,0x5
    27b4:	0f850513          	addi	a0,a0,248 # 78a8 <malloc+0xdbe>
    27b8:	00004097          	auipc	ra,0x4
    27bc:	274080e7          	jalr	628(ra) # 6a2c <printf>
    exit(1,"");
    27c0:	00006597          	auipc	a1,0x6
    27c4:	a5858593          	addi	a1,a1,-1448 # 8218 <malloc+0x172e>
    27c8:	4505                	li	a0,1
    27ca:	00004097          	auipc	ra,0x4
    27ce:	ec2080e7          	jalr	-318(ra) # 668c <exit>
    exit(xstatus,"");
    27d2:	00006597          	auipc	a1,0x6
    27d6:	a4658593          	addi	a1,a1,-1466 # 8218 <malloc+0x172e>
    27da:	00004097          	auipc	ra,0x4
    27de:	eb2080e7          	jalr	-334(ra) # 668c <exit>
    printf("%s: bigarg test failed!\n", s);
    27e2:	85a6                	mv	a1,s1
    27e4:	00005517          	auipc	a0,0x5
    27e8:	0e450513          	addi	a0,a0,228 # 78c8 <malloc+0xdde>
    27ec:	00004097          	auipc	ra,0x4
    27f0:	240080e7          	jalr	576(ra) # 6a2c <printf>
    exit(1,"");
    27f4:	00006597          	auipc	a1,0x6
    27f8:	a2458593          	addi	a1,a1,-1500 # 8218 <malloc+0x172e>
    27fc:	4505                	li	a0,1
    27fe:	00004097          	auipc	ra,0x4
    2802:	e8e080e7          	jalr	-370(ra) # 668c <exit>

0000000000002806 <stacktest>:
{
    2806:	7179                	addi	sp,sp,-48
    2808:	f406                	sd	ra,40(sp)
    280a:	f022                	sd	s0,32(sp)
    280c:	ec26                	sd	s1,24(sp)
    280e:	1800                	addi	s0,sp,48
    2810:	84aa                	mv	s1,a0
  pid = fork();
    2812:	00004097          	auipc	ra,0x4
    2816:	e72080e7          	jalr	-398(ra) # 6684 <fork>
  if(pid == 0) {
    281a:	c51d                	beqz	a0,2848 <stacktest+0x42>
  } else if(pid < 0){
    281c:	04054d63          	bltz	a0,2876 <stacktest+0x70>
  wait(&xstatus,0);
    2820:	4581                	li	a1,0
    2822:	fdc40513          	addi	a0,s0,-36
    2826:	00004097          	auipc	ra,0x4
    282a:	e6e080e7          	jalr	-402(ra) # 6694 <wait>
  if(xstatus == -1)  // kernel killed child?
    282e:	fdc42503          	lw	a0,-36(s0)
    2832:	57fd                	li	a5,-1
    2834:	06f50363          	beq	a0,a5,289a <stacktest+0x94>
    exit(xstatus,"");
    2838:	00006597          	auipc	a1,0x6
    283c:	9e058593          	addi	a1,a1,-1568 # 8218 <malloc+0x172e>
    2840:	00004097          	auipc	ra,0x4
    2844:	e4c080e7          	jalr	-436(ra) # 668c <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2848:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    284a:	77fd                	lui	a5,0xfffff
    284c:	97ba                	add	a5,a5,a4
    284e:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffee388>
    2852:	85a6                	mv	a1,s1
    2854:	00005517          	auipc	a0,0x5
    2858:	09450513          	addi	a0,a0,148 # 78e8 <malloc+0xdfe>
    285c:	00004097          	auipc	ra,0x4
    2860:	1d0080e7          	jalr	464(ra) # 6a2c <printf>
    exit(1,"");
    2864:	00006597          	auipc	a1,0x6
    2868:	9b458593          	addi	a1,a1,-1612 # 8218 <malloc+0x172e>
    286c:	4505                	li	a0,1
    286e:	00004097          	auipc	ra,0x4
    2872:	e1e080e7          	jalr	-482(ra) # 668c <exit>
    printf("%s: fork failed\n", s);
    2876:	85a6                	mv	a1,s1
    2878:	00005517          	auipc	a0,0x5
    287c:	c3850513          	addi	a0,a0,-968 # 74b0 <malloc+0x9c6>
    2880:	00004097          	auipc	ra,0x4
    2884:	1ac080e7          	jalr	428(ra) # 6a2c <printf>
    exit(1,"");
    2888:	00006597          	auipc	a1,0x6
    288c:	99058593          	addi	a1,a1,-1648 # 8218 <malloc+0x172e>
    2890:	4505                	li	a0,1
    2892:	00004097          	auipc	ra,0x4
    2896:	dfa080e7          	jalr	-518(ra) # 668c <exit>
    exit(0,"");
    289a:	00006597          	auipc	a1,0x6
    289e:	97e58593          	addi	a1,a1,-1666 # 8218 <malloc+0x172e>
    28a2:	4501                	li	a0,0
    28a4:	00004097          	auipc	ra,0x4
    28a8:	de8080e7          	jalr	-536(ra) # 668c <exit>

00000000000028ac <textwrite>:
{
    28ac:	7179                	addi	sp,sp,-48
    28ae:	f406                	sd	ra,40(sp)
    28b0:	f022                	sd	s0,32(sp)
    28b2:	ec26                	sd	s1,24(sp)
    28b4:	1800                	addi	s0,sp,48
    28b6:	84aa                	mv	s1,a0
  pid = fork();
    28b8:	00004097          	auipc	ra,0x4
    28bc:	dcc080e7          	jalr	-564(ra) # 6684 <fork>
  if(pid == 0) {
    28c0:	c51d                	beqz	a0,28ee <textwrite+0x42>
  } else if(pid < 0){
    28c2:	04054263          	bltz	a0,2906 <textwrite+0x5a>
  wait(&xstatus,0);
    28c6:	4581                	li	a1,0
    28c8:	fdc40513          	addi	a0,s0,-36
    28cc:	00004097          	auipc	ra,0x4
    28d0:	dc8080e7          	jalr	-568(ra) # 6694 <wait>
  if(xstatus == -1)  // kernel killed child?
    28d4:	fdc42503          	lw	a0,-36(s0)
    28d8:	57fd                	li	a5,-1
    28da:	04f50863          	beq	a0,a5,292a <textwrite+0x7e>
    exit(xstatus,"");
    28de:	00006597          	auipc	a1,0x6
    28e2:	93a58593          	addi	a1,a1,-1734 # 8218 <malloc+0x172e>
    28e6:	00004097          	auipc	ra,0x4
    28ea:	da6080e7          	jalr	-602(ra) # 668c <exit>
    *addr = 10;
    28ee:	47a9                	li	a5,10
    28f0:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1,"");
    28f4:	00006597          	auipc	a1,0x6
    28f8:	92458593          	addi	a1,a1,-1756 # 8218 <malloc+0x172e>
    28fc:	4505                	li	a0,1
    28fe:	00004097          	auipc	ra,0x4
    2902:	d8e080e7          	jalr	-626(ra) # 668c <exit>
    printf("%s: fork failed\n", s);
    2906:	85a6                	mv	a1,s1
    2908:	00005517          	auipc	a0,0x5
    290c:	ba850513          	addi	a0,a0,-1112 # 74b0 <malloc+0x9c6>
    2910:	00004097          	auipc	ra,0x4
    2914:	11c080e7          	jalr	284(ra) # 6a2c <printf>
    exit(1,"");
    2918:	00006597          	auipc	a1,0x6
    291c:	90058593          	addi	a1,a1,-1792 # 8218 <malloc+0x172e>
    2920:	4505                	li	a0,1
    2922:	00004097          	auipc	ra,0x4
    2926:	d6a080e7          	jalr	-662(ra) # 668c <exit>
    exit(0,"");
    292a:	00006597          	auipc	a1,0x6
    292e:	8ee58593          	addi	a1,a1,-1810 # 8218 <malloc+0x172e>
    2932:	4501                	li	a0,0
    2934:	00004097          	auipc	ra,0x4
    2938:	d58080e7          	jalr	-680(ra) # 668c <exit>

000000000000293c <manywrites>:
{
    293c:	711d                	addi	sp,sp,-96
    293e:	ec86                	sd	ra,88(sp)
    2940:	e8a2                	sd	s0,80(sp)
    2942:	e4a6                	sd	s1,72(sp)
    2944:	e0ca                	sd	s2,64(sp)
    2946:	fc4e                	sd	s3,56(sp)
    2948:	f852                	sd	s4,48(sp)
    294a:	f456                	sd	s5,40(sp)
    294c:	f05a                	sd	s6,32(sp)
    294e:	ec5e                	sd	s7,24(sp)
    2950:	1080                	addi	s0,sp,96
    2952:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    2954:	4901                	li	s2,0
    2956:	4991                	li	s3,4
    int pid = fork();
    2958:	00004097          	auipc	ra,0x4
    295c:	d2c080e7          	jalr	-724(ra) # 6684 <fork>
    2960:	84aa                	mv	s1,a0
    if(pid < 0){
    2962:	02054f63          	bltz	a0,29a0 <manywrites+0x64>
    if(pid == 0){
    2966:	cd31                	beqz	a0,29c2 <manywrites+0x86>
  for(int ci = 0; ci < nchildren; ci++){
    2968:	2905                	addiw	s2,s2,1
    296a:	ff3917e3          	bne	s2,s3,2958 <manywrites+0x1c>
    296e:	4491                	li	s1,4
    int st = 0;
    2970:	fa042423          	sw	zero,-88(s0)
    wait(&st,0);
    2974:	4581                	li	a1,0
    2976:	fa840513          	addi	a0,s0,-88
    297a:	00004097          	auipc	ra,0x4
    297e:	d1a080e7          	jalr	-742(ra) # 6694 <wait>
    if(st != 0)
    2982:	fa842503          	lw	a0,-88(s0)
    2986:	12051263          	bnez	a0,2aaa <manywrites+0x16e>
  for(int ci = 0; ci < nchildren; ci++){
    298a:	34fd                	addiw	s1,s1,-1
    298c:	f0f5                	bnez	s1,2970 <manywrites+0x34>
  exit(0,"");
    298e:	00006597          	auipc	a1,0x6
    2992:	88a58593          	addi	a1,a1,-1910 # 8218 <malloc+0x172e>
    2996:	4501                	li	a0,0
    2998:	00004097          	auipc	ra,0x4
    299c:	cf4080e7          	jalr	-780(ra) # 668c <exit>
      printf("fork failed\n");
    29a0:	00005517          	auipc	a0,0x5
    29a4:	f1850513          	addi	a0,a0,-232 # 78b8 <malloc+0xdce>
    29a8:	00004097          	auipc	ra,0x4
    29ac:	084080e7          	jalr	132(ra) # 6a2c <printf>
      exit(1,"");
    29b0:	00006597          	auipc	a1,0x6
    29b4:	86858593          	addi	a1,a1,-1944 # 8218 <malloc+0x172e>
    29b8:	4505                	li	a0,1
    29ba:	00004097          	auipc	ra,0x4
    29be:	cd2080e7          	jalr	-814(ra) # 668c <exit>
      name[0] = 'b';
    29c2:	06200793          	li	a5,98
    29c6:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    29ca:	0619079b          	addiw	a5,s2,97
    29ce:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    29d2:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    29d6:	fa840513          	addi	a0,s0,-88
    29da:	00004097          	auipc	ra,0x4
    29de:	d02080e7          	jalr	-766(ra) # 66dc <unlink>
    29e2:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    29e4:	0000bb97          	auipc	s7,0xb
    29e8:	294b8b93          	addi	s7,s7,660 # dc78 <buf>
        for(int i = 0; i < ci+1; i++){
    29ec:	8a26                	mv	s4,s1
    29ee:	02094e63          	bltz	s2,2a2a <manywrites+0xee>
          int fd = open(name, O_CREATE | O_RDWR);
    29f2:	20200593          	li	a1,514
    29f6:	fa840513          	addi	a0,s0,-88
    29fa:	00004097          	auipc	ra,0x4
    29fe:	cd2080e7          	jalr	-814(ra) # 66cc <open>
    2a02:	89aa                	mv	s3,a0
          if(fd < 0){
    2a04:	04054b63          	bltz	a0,2a5a <manywrites+0x11e>
          int cc = write(fd, buf, sz);
    2a08:	660d                	lui	a2,0x3
    2a0a:	85de                	mv	a1,s7
    2a0c:	00004097          	auipc	ra,0x4
    2a10:	ca0080e7          	jalr	-864(ra) # 66ac <write>
          if(cc != sz){
    2a14:	678d                	lui	a5,0x3
    2a16:	06f51663          	bne	a0,a5,2a82 <manywrites+0x146>
          close(fd);
    2a1a:	854e                	mv	a0,s3
    2a1c:	00004097          	auipc	ra,0x4
    2a20:	c98080e7          	jalr	-872(ra) # 66b4 <close>
        for(int i = 0; i < ci+1; i++){
    2a24:	2a05                	addiw	s4,s4,1
    2a26:	fd4956e3          	bge	s2,s4,29f2 <manywrites+0xb6>
        unlink(name);
    2a2a:	fa840513          	addi	a0,s0,-88
    2a2e:	00004097          	auipc	ra,0x4
    2a32:	cae080e7          	jalr	-850(ra) # 66dc <unlink>
      for(int iters = 0; iters < howmany; iters++){
    2a36:	3b7d                	addiw	s6,s6,-1
    2a38:	fa0b1ae3          	bnez	s6,29ec <manywrites+0xb0>
      unlink(name);
    2a3c:	fa840513          	addi	a0,s0,-88
    2a40:	00004097          	auipc	ra,0x4
    2a44:	c9c080e7          	jalr	-868(ra) # 66dc <unlink>
      exit(0,"");
    2a48:	00005597          	auipc	a1,0x5
    2a4c:	7d058593          	addi	a1,a1,2000 # 8218 <malloc+0x172e>
    2a50:	4501                	li	a0,0
    2a52:	00004097          	auipc	ra,0x4
    2a56:	c3a080e7          	jalr	-966(ra) # 668c <exit>
            printf("%s: cannot create %s\n", s, name);
    2a5a:	fa840613          	addi	a2,s0,-88
    2a5e:	85d6                	mv	a1,s5
    2a60:	00005517          	auipc	a0,0x5
    2a64:	eb050513          	addi	a0,a0,-336 # 7910 <malloc+0xe26>
    2a68:	00004097          	auipc	ra,0x4
    2a6c:	fc4080e7          	jalr	-60(ra) # 6a2c <printf>
            exit(1,"");
    2a70:	00005597          	auipc	a1,0x5
    2a74:	7a858593          	addi	a1,a1,1960 # 8218 <malloc+0x172e>
    2a78:	4505                	li	a0,1
    2a7a:	00004097          	auipc	ra,0x4
    2a7e:	c12080e7          	jalr	-1006(ra) # 668c <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2a82:	86aa                	mv	a3,a0
    2a84:	660d                	lui	a2,0x3
    2a86:	85d6                	mv	a1,s5
    2a88:	00004517          	auipc	a0,0x4
    2a8c:	27050513          	addi	a0,a0,624 # 6cf8 <malloc+0x20e>
    2a90:	00004097          	auipc	ra,0x4
    2a94:	f9c080e7          	jalr	-100(ra) # 6a2c <printf>
            exit(1,"");
    2a98:	00005597          	auipc	a1,0x5
    2a9c:	78058593          	addi	a1,a1,1920 # 8218 <malloc+0x172e>
    2aa0:	4505                	li	a0,1
    2aa2:	00004097          	auipc	ra,0x4
    2aa6:	bea080e7          	jalr	-1046(ra) # 668c <exit>
      exit(st,"");
    2aaa:	00005597          	auipc	a1,0x5
    2aae:	76e58593          	addi	a1,a1,1902 # 8218 <malloc+0x172e>
    2ab2:	00004097          	auipc	ra,0x4
    2ab6:	bda080e7          	jalr	-1062(ra) # 668c <exit>

0000000000002aba <copyinstr3>:
{
    2aba:	7179                	addi	sp,sp,-48
    2abc:	f406                	sd	ra,40(sp)
    2abe:	f022                	sd	s0,32(sp)
    2ac0:	ec26                	sd	s1,24(sp)
    2ac2:	1800                	addi	s0,sp,48
  sbrk(8192);
    2ac4:	6509                	lui	a0,0x2
    2ac6:	00004097          	auipc	ra,0x4
    2aca:	c4e080e7          	jalr	-946(ra) # 6714 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2ace:	4501                	li	a0,0
    2ad0:	00004097          	auipc	ra,0x4
    2ad4:	c44080e7          	jalr	-956(ra) # 6714 <sbrk>
  if((top % PGSIZE) != 0){
    2ad8:	03451793          	slli	a5,a0,0x34
    2adc:	e3c9                	bnez	a5,2b5e <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2ade:	4501                	li	a0,0
    2ae0:	00004097          	auipc	ra,0x4
    2ae4:	c34080e7          	jalr	-972(ra) # 6714 <sbrk>
  if(top % PGSIZE){
    2ae8:	03451793          	slli	a5,a0,0x34
    2aec:	e3d9                	bnez	a5,2b72 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2aee:	fff50493          	addi	s1,a0,-1 # 1fff <forkfork+0xa9>
  *b = 'x';
    2af2:	07800793          	li	a5,120
    2af6:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2afa:	8526                	mv	a0,s1
    2afc:	00004097          	auipc	ra,0x4
    2b00:	be0080e7          	jalr	-1056(ra) # 66dc <unlink>
  if(ret != -1){
    2b04:	57fd                	li	a5,-1
    2b06:	08f51763          	bne	a0,a5,2b94 <copyinstr3+0xda>
  int fd = open(b, O_CREATE | O_WRONLY);
    2b0a:	20100593          	li	a1,513
    2b0e:	8526                	mv	a0,s1
    2b10:	00004097          	auipc	ra,0x4
    2b14:	bbc080e7          	jalr	-1092(ra) # 66cc <open>
  if(fd != -1){
    2b18:	57fd                	li	a5,-1
    2b1a:	0af51063          	bne	a0,a5,2bba <copyinstr3+0x100>
  ret = link(b, b);
    2b1e:	85a6                	mv	a1,s1
    2b20:	8526                	mv	a0,s1
    2b22:	00004097          	auipc	ra,0x4
    2b26:	bca080e7          	jalr	-1078(ra) # 66ec <link>
  if(ret != -1){
    2b2a:	57fd                	li	a5,-1
    2b2c:	0af51a63          	bne	a0,a5,2be0 <copyinstr3+0x126>
  char *args[] = { "xx", 0 };
    2b30:	00006797          	auipc	a5,0x6
    2b34:	ad878793          	addi	a5,a5,-1320 # 8608 <malloc+0x1b1e>
    2b38:	fcf43823          	sd	a5,-48(s0)
    2b3c:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2b40:	fd040593          	addi	a1,s0,-48
    2b44:	8526                	mv	a0,s1
    2b46:	00004097          	auipc	ra,0x4
    2b4a:	b7e080e7          	jalr	-1154(ra) # 66c4 <exec>
  if(ret != -1){
    2b4e:	57fd                	li	a5,-1
    2b50:	0af51c63          	bne	a0,a5,2c08 <copyinstr3+0x14e>
}
    2b54:	70a2                	ld	ra,40(sp)
    2b56:	7402                	ld	s0,32(sp)
    2b58:	64e2                	ld	s1,24(sp)
    2b5a:	6145                	addi	sp,sp,48
    2b5c:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2b5e:	0347d513          	srli	a0,a5,0x34
    2b62:	6785                	lui	a5,0x1
    2b64:	40a7853b          	subw	a0,a5,a0
    2b68:	00004097          	auipc	ra,0x4
    2b6c:	bac080e7          	jalr	-1108(ra) # 6714 <sbrk>
    2b70:	b7bd                	j	2ade <copyinstr3+0x24>
    printf("oops\n");
    2b72:	00005517          	auipc	a0,0x5
    2b76:	db650513          	addi	a0,a0,-586 # 7928 <malloc+0xe3e>
    2b7a:	00004097          	auipc	ra,0x4
    2b7e:	eb2080e7          	jalr	-334(ra) # 6a2c <printf>
    exit(1,"");
    2b82:	00005597          	auipc	a1,0x5
    2b86:	69658593          	addi	a1,a1,1686 # 8218 <malloc+0x172e>
    2b8a:	4505                	li	a0,1
    2b8c:	00004097          	auipc	ra,0x4
    2b90:	b00080e7          	jalr	-1280(ra) # 668c <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2b94:	862a                	mv	a2,a0
    2b96:	85a6                	mv	a1,s1
    2b98:	00005517          	auipc	a0,0x5
    2b9c:	83850513          	addi	a0,a0,-1992 # 73d0 <malloc+0x8e6>
    2ba0:	00004097          	auipc	ra,0x4
    2ba4:	e8c080e7          	jalr	-372(ra) # 6a2c <printf>
    exit(1,"");
    2ba8:	00005597          	auipc	a1,0x5
    2bac:	67058593          	addi	a1,a1,1648 # 8218 <malloc+0x172e>
    2bb0:	4505                	li	a0,1
    2bb2:	00004097          	auipc	ra,0x4
    2bb6:	ada080e7          	jalr	-1318(ra) # 668c <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2bba:	862a                	mv	a2,a0
    2bbc:	85a6                	mv	a1,s1
    2bbe:	00005517          	auipc	a0,0x5
    2bc2:	83250513          	addi	a0,a0,-1998 # 73f0 <malloc+0x906>
    2bc6:	00004097          	auipc	ra,0x4
    2bca:	e66080e7          	jalr	-410(ra) # 6a2c <printf>
    exit(1,"");
    2bce:	00005597          	auipc	a1,0x5
    2bd2:	64a58593          	addi	a1,a1,1610 # 8218 <malloc+0x172e>
    2bd6:	4505                	li	a0,1
    2bd8:	00004097          	auipc	ra,0x4
    2bdc:	ab4080e7          	jalr	-1356(ra) # 668c <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2be0:	86aa                	mv	a3,a0
    2be2:	8626                	mv	a2,s1
    2be4:	85a6                	mv	a1,s1
    2be6:	00005517          	auipc	a0,0x5
    2bea:	82a50513          	addi	a0,a0,-2006 # 7410 <malloc+0x926>
    2bee:	00004097          	auipc	ra,0x4
    2bf2:	e3e080e7          	jalr	-450(ra) # 6a2c <printf>
    exit(1,"");
    2bf6:	00005597          	auipc	a1,0x5
    2bfa:	62258593          	addi	a1,a1,1570 # 8218 <malloc+0x172e>
    2bfe:	4505                	li	a0,1
    2c00:	00004097          	auipc	ra,0x4
    2c04:	a8c080e7          	jalr	-1396(ra) # 668c <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2c08:	567d                	li	a2,-1
    2c0a:	85a6                	mv	a1,s1
    2c0c:	00005517          	auipc	a0,0x5
    2c10:	82c50513          	addi	a0,a0,-2004 # 7438 <malloc+0x94e>
    2c14:	00004097          	auipc	ra,0x4
    2c18:	e18080e7          	jalr	-488(ra) # 6a2c <printf>
    exit(1,"");
    2c1c:	00005597          	auipc	a1,0x5
    2c20:	5fc58593          	addi	a1,a1,1532 # 8218 <malloc+0x172e>
    2c24:	4505                	li	a0,1
    2c26:	00004097          	auipc	ra,0x4
    2c2a:	a66080e7          	jalr	-1434(ra) # 668c <exit>

0000000000002c2e <rwsbrk>:
{
    2c2e:	1101                	addi	sp,sp,-32
    2c30:	ec06                	sd	ra,24(sp)
    2c32:	e822                	sd	s0,16(sp)
    2c34:	e426                	sd	s1,8(sp)
    2c36:	e04a                	sd	s2,0(sp)
    2c38:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2c3a:	6509                	lui	a0,0x2
    2c3c:	00004097          	auipc	ra,0x4
    2c40:	ad8080e7          	jalr	-1320(ra) # 6714 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2c44:	57fd                	li	a5,-1
    2c46:	06f50763          	beq	a0,a5,2cb4 <rwsbrk+0x86>
    2c4a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2c4c:	7579                	lui	a0,0xffffe
    2c4e:	00004097          	auipc	ra,0x4
    2c52:	ac6080e7          	jalr	-1338(ra) # 6714 <sbrk>
    2c56:	57fd                	li	a5,-1
    2c58:	06f50f63          	beq	a0,a5,2cd6 <rwsbrk+0xa8>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2c5c:	20100593          	li	a1,513
    2c60:	00005517          	auipc	a0,0x5
    2c64:	d0850513          	addi	a0,a0,-760 # 7968 <malloc+0xe7e>
    2c68:	00004097          	auipc	ra,0x4
    2c6c:	a64080e7          	jalr	-1436(ra) # 66cc <open>
    2c70:	892a                	mv	s2,a0
  if(fd < 0){
    2c72:	08054363          	bltz	a0,2cf8 <rwsbrk+0xca>
  n = write(fd, (void*)(a+4096), 1024);
    2c76:	6505                	lui	a0,0x1
    2c78:	94aa                	add	s1,s1,a0
    2c7a:	40000613          	li	a2,1024
    2c7e:	85a6                	mv	a1,s1
    2c80:	854a                	mv	a0,s2
    2c82:	00004097          	auipc	ra,0x4
    2c86:	a2a080e7          	jalr	-1494(ra) # 66ac <write>
    2c8a:	862a                	mv	a2,a0
  if(n >= 0){
    2c8c:	08054763          	bltz	a0,2d1a <rwsbrk+0xec>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2c90:	85a6                	mv	a1,s1
    2c92:	00005517          	auipc	a0,0x5
    2c96:	cf650513          	addi	a0,a0,-778 # 7988 <malloc+0xe9e>
    2c9a:	00004097          	auipc	ra,0x4
    2c9e:	d92080e7          	jalr	-622(ra) # 6a2c <printf>
    exit(1,"");
    2ca2:	00005597          	auipc	a1,0x5
    2ca6:	57658593          	addi	a1,a1,1398 # 8218 <malloc+0x172e>
    2caa:	4505                	li	a0,1
    2cac:	00004097          	auipc	ra,0x4
    2cb0:	9e0080e7          	jalr	-1568(ra) # 668c <exit>
    printf("sbrk(rwsbrk) failed\n");
    2cb4:	00005517          	auipc	a0,0x5
    2cb8:	c7c50513          	addi	a0,a0,-900 # 7930 <malloc+0xe46>
    2cbc:	00004097          	auipc	ra,0x4
    2cc0:	d70080e7          	jalr	-656(ra) # 6a2c <printf>
    exit(1,"");
    2cc4:	00005597          	auipc	a1,0x5
    2cc8:	55458593          	addi	a1,a1,1364 # 8218 <malloc+0x172e>
    2ccc:	4505                	li	a0,1
    2cce:	00004097          	auipc	ra,0x4
    2cd2:	9be080e7          	jalr	-1602(ra) # 668c <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    2cd6:	00005517          	auipc	a0,0x5
    2cda:	c7250513          	addi	a0,a0,-910 # 7948 <malloc+0xe5e>
    2cde:	00004097          	auipc	ra,0x4
    2ce2:	d4e080e7          	jalr	-690(ra) # 6a2c <printf>
    exit(1,"");
    2ce6:	00005597          	auipc	a1,0x5
    2cea:	53258593          	addi	a1,a1,1330 # 8218 <malloc+0x172e>
    2cee:	4505                	li	a0,1
    2cf0:	00004097          	auipc	ra,0x4
    2cf4:	99c080e7          	jalr	-1636(ra) # 668c <exit>
    printf("open(rwsbrk) failed\n");
    2cf8:	00005517          	auipc	a0,0x5
    2cfc:	c7850513          	addi	a0,a0,-904 # 7970 <malloc+0xe86>
    2d00:	00004097          	auipc	ra,0x4
    2d04:	d2c080e7          	jalr	-724(ra) # 6a2c <printf>
    exit(1,"");
    2d08:	00005597          	auipc	a1,0x5
    2d0c:	51058593          	addi	a1,a1,1296 # 8218 <malloc+0x172e>
    2d10:	4505                	li	a0,1
    2d12:	00004097          	auipc	ra,0x4
    2d16:	97a080e7          	jalr	-1670(ra) # 668c <exit>
  close(fd);
    2d1a:	854a                	mv	a0,s2
    2d1c:	00004097          	auipc	ra,0x4
    2d20:	998080e7          	jalr	-1640(ra) # 66b4 <close>
  unlink("rwsbrk");
    2d24:	00005517          	auipc	a0,0x5
    2d28:	c4450513          	addi	a0,a0,-956 # 7968 <malloc+0xe7e>
    2d2c:	00004097          	auipc	ra,0x4
    2d30:	9b0080e7          	jalr	-1616(ra) # 66dc <unlink>
  fd = open("README", O_RDONLY);
    2d34:	4581                	li	a1,0
    2d36:	00004517          	auipc	a0,0x4
    2d3a:	0ca50513          	addi	a0,a0,202 # 6e00 <malloc+0x316>
    2d3e:	00004097          	auipc	ra,0x4
    2d42:	98e080e7          	jalr	-1650(ra) # 66cc <open>
    2d46:	892a                	mv	s2,a0
  if(fd < 0){
    2d48:	02054d63          	bltz	a0,2d82 <rwsbrk+0x154>
  n = read(fd, (void*)(a+4096), 10);
    2d4c:	4629                	li	a2,10
    2d4e:	85a6                	mv	a1,s1
    2d50:	00004097          	auipc	ra,0x4
    2d54:	954080e7          	jalr	-1708(ra) # 66a4 <read>
    2d58:	862a                	mv	a2,a0
  if(n >= 0){
    2d5a:	04054563          	bltz	a0,2da4 <rwsbrk+0x176>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2d5e:	85a6                	mv	a1,s1
    2d60:	00005517          	auipc	a0,0x5
    2d64:	c5850513          	addi	a0,a0,-936 # 79b8 <malloc+0xece>
    2d68:	00004097          	auipc	ra,0x4
    2d6c:	cc4080e7          	jalr	-828(ra) # 6a2c <printf>
    exit(1,"");
    2d70:	00005597          	auipc	a1,0x5
    2d74:	4a858593          	addi	a1,a1,1192 # 8218 <malloc+0x172e>
    2d78:	4505                	li	a0,1
    2d7a:	00004097          	auipc	ra,0x4
    2d7e:	912080e7          	jalr	-1774(ra) # 668c <exit>
    printf("open(rwsbrk) failed\n");
    2d82:	00005517          	auipc	a0,0x5
    2d86:	bee50513          	addi	a0,a0,-1042 # 7970 <malloc+0xe86>
    2d8a:	00004097          	auipc	ra,0x4
    2d8e:	ca2080e7          	jalr	-862(ra) # 6a2c <printf>
    exit(1,"");
    2d92:	00005597          	auipc	a1,0x5
    2d96:	48658593          	addi	a1,a1,1158 # 8218 <malloc+0x172e>
    2d9a:	4505                	li	a0,1
    2d9c:	00004097          	auipc	ra,0x4
    2da0:	8f0080e7          	jalr	-1808(ra) # 668c <exit>
  close(fd);
    2da4:	854a                	mv	a0,s2
    2da6:	00004097          	auipc	ra,0x4
    2daa:	90e080e7          	jalr	-1778(ra) # 66b4 <close>
  exit(0,"");
    2dae:	00005597          	auipc	a1,0x5
    2db2:	46a58593          	addi	a1,a1,1130 # 8218 <malloc+0x172e>
    2db6:	4501                	li	a0,0
    2db8:	00004097          	auipc	ra,0x4
    2dbc:	8d4080e7          	jalr	-1836(ra) # 668c <exit>

0000000000002dc0 <sbrkbasic>:
{
    2dc0:	715d                	addi	sp,sp,-80
    2dc2:	e486                	sd	ra,72(sp)
    2dc4:	e0a2                	sd	s0,64(sp)
    2dc6:	fc26                	sd	s1,56(sp)
    2dc8:	f84a                	sd	s2,48(sp)
    2dca:	f44e                	sd	s3,40(sp)
    2dcc:	f052                	sd	s4,32(sp)
    2dce:	ec56                	sd	s5,24(sp)
    2dd0:	0880                	addi	s0,sp,80
    2dd2:	8a2a                	mv	s4,a0
  pid = fork();
    2dd4:	00004097          	auipc	ra,0x4
    2dd8:	8b0080e7          	jalr	-1872(ra) # 6684 <fork>
  if(pid < 0){
    2ddc:	04054063          	bltz	a0,2e1c <sbrkbasic+0x5c>
  if(pid == 0){
    2de0:	e925                	bnez	a0,2e50 <sbrkbasic+0x90>
    a = sbrk(TOOMUCH);
    2de2:	40000537          	lui	a0,0x40000
    2de6:	00004097          	auipc	ra,0x4
    2dea:	92e080e7          	jalr	-1746(ra) # 6714 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2dee:	57fd                	li	a5,-1
    2df0:	04f50763          	beq	a0,a5,2e3e <sbrkbasic+0x7e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2df4:	400007b7          	lui	a5,0x40000
    2df8:	97aa                	add	a5,a5,a0
      *b = 99;
    2dfa:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2dfe:	6705                	lui	a4,0x1
      *b = 99;
    2e00:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2e04:	953a                	add	a0,a0,a4
    2e06:	fef51de3          	bne	a0,a5,2e00 <sbrkbasic+0x40>
    exit(1,"");
    2e0a:	00005597          	auipc	a1,0x5
    2e0e:	40e58593          	addi	a1,a1,1038 # 8218 <malloc+0x172e>
    2e12:	4505                	li	a0,1
    2e14:	00004097          	auipc	ra,0x4
    2e18:	878080e7          	jalr	-1928(ra) # 668c <exit>
    printf("fork failed in sbrkbasic\n");
    2e1c:	00005517          	auipc	a0,0x5
    2e20:	bc450513          	addi	a0,a0,-1084 # 79e0 <malloc+0xef6>
    2e24:	00004097          	auipc	ra,0x4
    2e28:	c08080e7          	jalr	-1016(ra) # 6a2c <printf>
    exit(1,"");
    2e2c:	00005597          	auipc	a1,0x5
    2e30:	3ec58593          	addi	a1,a1,1004 # 8218 <malloc+0x172e>
    2e34:	4505                	li	a0,1
    2e36:	00004097          	auipc	ra,0x4
    2e3a:	856080e7          	jalr	-1962(ra) # 668c <exit>
      exit(0,"");
    2e3e:	00005597          	auipc	a1,0x5
    2e42:	3da58593          	addi	a1,a1,986 # 8218 <malloc+0x172e>
    2e46:	4501                	li	a0,0
    2e48:	00004097          	auipc	ra,0x4
    2e4c:	844080e7          	jalr	-1980(ra) # 668c <exit>
  wait(&xstatus,0);
    2e50:	4581                	li	a1,0
    2e52:	fbc40513          	addi	a0,s0,-68
    2e56:	00004097          	auipc	ra,0x4
    2e5a:	83e080e7          	jalr	-1986(ra) # 6694 <wait>
  if(xstatus == 1){
    2e5e:	fbc42703          	lw	a4,-68(s0)
    2e62:	4785                	li	a5,1
    2e64:	00f70e63          	beq	a4,a5,2e80 <sbrkbasic+0xc0>
  a = sbrk(0);
    2e68:	4501                	li	a0,0
    2e6a:	00004097          	auipc	ra,0x4
    2e6e:	8aa080e7          	jalr	-1878(ra) # 6714 <sbrk>
    2e72:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2e74:	4901                	li	s2,0
    *b = 1;
    2e76:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2e78:	6985                	lui	s3,0x1
    2e7a:	38898993          	addi	s3,s3,904 # 1388 <bigdir+0x20>
    2e7e:	a025                	j	2ea6 <sbrkbasic+0xe6>
    printf("%s: too much memory allocated!\n", s);
    2e80:	85d2                	mv	a1,s4
    2e82:	00005517          	auipc	a0,0x5
    2e86:	b7e50513          	addi	a0,a0,-1154 # 7a00 <malloc+0xf16>
    2e8a:	00004097          	auipc	ra,0x4
    2e8e:	ba2080e7          	jalr	-1118(ra) # 6a2c <printf>
    exit(1,"");
    2e92:	00005597          	auipc	a1,0x5
    2e96:	38658593          	addi	a1,a1,902 # 8218 <malloc+0x172e>
    2e9a:	4505                	li	a0,1
    2e9c:	00003097          	auipc	ra,0x3
    2ea0:	7f0080e7          	jalr	2032(ra) # 668c <exit>
    a = b + 1;
    2ea4:	84be                	mv	s1,a5
    b = sbrk(1);
    2ea6:	4505                	li	a0,1
    2ea8:	00004097          	auipc	ra,0x4
    2eac:	86c080e7          	jalr	-1940(ra) # 6714 <sbrk>
    if(b != a){
    2eb0:	04951f63          	bne	a0,s1,2f0e <sbrkbasic+0x14e>
    *b = 1;
    2eb4:	01548023          	sb	s5,0(s1)
    a = b + 1;
    2eb8:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2ebc:	2905                	addiw	s2,s2,1
    2ebe:	ff3913e3          	bne	s2,s3,2ea4 <sbrkbasic+0xe4>
  pid = fork();
    2ec2:	00003097          	auipc	ra,0x3
    2ec6:	7c2080e7          	jalr	1986(ra) # 6684 <fork>
    2eca:	892a                	mv	s2,a0
  if(pid < 0){
    2ecc:	06054663          	bltz	a0,2f38 <sbrkbasic+0x178>
  c = sbrk(1);
    2ed0:	4505                	li	a0,1
    2ed2:	00004097          	auipc	ra,0x4
    2ed6:	842080e7          	jalr	-1982(ra) # 6714 <sbrk>
  c = sbrk(1);
    2eda:	4505                	li	a0,1
    2edc:	00004097          	auipc	ra,0x4
    2ee0:	838080e7          	jalr	-1992(ra) # 6714 <sbrk>
  if(c != a + 1){
    2ee4:	0489                	addi	s1,s1,2
    2ee6:	06a48b63          	beq	s1,a0,2f5c <sbrkbasic+0x19c>
    printf("%s: sbrk test failed post-fork\n", s);
    2eea:	85d2                	mv	a1,s4
    2eec:	00005517          	auipc	a0,0x5
    2ef0:	b7450513          	addi	a0,a0,-1164 # 7a60 <malloc+0xf76>
    2ef4:	00004097          	auipc	ra,0x4
    2ef8:	b38080e7          	jalr	-1224(ra) # 6a2c <printf>
    exit(1,"");
    2efc:	00005597          	auipc	a1,0x5
    2f00:	31c58593          	addi	a1,a1,796 # 8218 <malloc+0x172e>
    2f04:	4505                	li	a0,1
    2f06:	00003097          	auipc	ra,0x3
    2f0a:	786080e7          	jalr	1926(ra) # 668c <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2f0e:	872a                	mv	a4,a0
    2f10:	86a6                	mv	a3,s1
    2f12:	864a                	mv	a2,s2
    2f14:	85d2                	mv	a1,s4
    2f16:	00005517          	auipc	a0,0x5
    2f1a:	b0a50513          	addi	a0,a0,-1270 # 7a20 <malloc+0xf36>
    2f1e:	00004097          	auipc	ra,0x4
    2f22:	b0e080e7          	jalr	-1266(ra) # 6a2c <printf>
      exit(1,"");
    2f26:	00005597          	auipc	a1,0x5
    2f2a:	2f258593          	addi	a1,a1,754 # 8218 <malloc+0x172e>
    2f2e:	4505                	li	a0,1
    2f30:	00003097          	auipc	ra,0x3
    2f34:	75c080e7          	jalr	1884(ra) # 668c <exit>
    printf("%s: sbrk test fork failed\n", s);
    2f38:	85d2                	mv	a1,s4
    2f3a:	00005517          	auipc	a0,0x5
    2f3e:	b0650513          	addi	a0,a0,-1274 # 7a40 <malloc+0xf56>
    2f42:	00004097          	auipc	ra,0x4
    2f46:	aea080e7          	jalr	-1302(ra) # 6a2c <printf>
    exit(1,"");
    2f4a:	00005597          	auipc	a1,0x5
    2f4e:	2ce58593          	addi	a1,a1,718 # 8218 <malloc+0x172e>
    2f52:	4505                	li	a0,1
    2f54:	00003097          	auipc	ra,0x3
    2f58:	738080e7          	jalr	1848(ra) # 668c <exit>
  if(pid == 0)
    2f5c:	00091b63          	bnez	s2,2f72 <sbrkbasic+0x1b2>
    exit(0,"");
    2f60:	00005597          	auipc	a1,0x5
    2f64:	2b858593          	addi	a1,a1,696 # 8218 <malloc+0x172e>
    2f68:	4501                	li	a0,0
    2f6a:	00003097          	auipc	ra,0x3
    2f6e:	722080e7          	jalr	1826(ra) # 668c <exit>
  wait(&xstatus,0);
    2f72:	4581                	li	a1,0
    2f74:	fbc40513          	addi	a0,s0,-68
    2f78:	00003097          	auipc	ra,0x3
    2f7c:	71c080e7          	jalr	1820(ra) # 6694 <wait>
  exit(xstatus,"");
    2f80:	00005597          	auipc	a1,0x5
    2f84:	29858593          	addi	a1,a1,664 # 8218 <malloc+0x172e>
    2f88:	fbc42503          	lw	a0,-68(s0)
    2f8c:	00003097          	auipc	ra,0x3
    2f90:	700080e7          	jalr	1792(ra) # 668c <exit>

0000000000002f94 <sbrkmuch>:
{
    2f94:	7179                	addi	sp,sp,-48
    2f96:	f406                	sd	ra,40(sp)
    2f98:	f022                	sd	s0,32(sp)
    2f9a:	ec26                	sd	s1,24(sp)
    2f9c:	e84a                	sd	s2,16(sp)
    2f9e:	e44e                	sd	s3,8(sp)
    2fa0:	e052                	sd	s4,0(sp)
    2fa2:	1800                	addi	s0,sp,48
    2fa4:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2fa6:	4501                	li	a0,0
    2fa8:	00003097          	auipc	ra,0x3
    2fac:	76c080e7          	jalr	1900(ra) # 6714 <sbrk>
    2fb0:	892a                	mv	s2,a0
  a = sbrk(0);
    2fb2:	4501                	li	a0,0
    2fb4:	00003097          	auipc	ra,0x3
    2fb8:	760080e7          	jalr	1888(ra) # 6714 <sbrk>
    2fbc:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2fbe:	06400537          	lui	a0,0x6400
    2fc2:	9d05                	subw	a0,a0,s1
    2fc4:	00003097          	auipc	ra,0x3
    2fc8:	750080e7          	jalr	1872(ra) # 6714 <sbrk>
  if (p != a) {
    2fcc:	0ca49863          	bne	s1,a0,309c <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2fd0:	4501                	li	a0,0
    2fd2:	00003097          	auipc	ra,0x3
    2fd6:	742080e7          	jalr	1858(ra) # 6714 <sbrk>
    2fda:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2fdc:	00a4f963          	bgeu	s1,a0,2fee <sbrkmuch+0x5a>
    *pp = 1;
    2fe0:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2fe2:	6705                	lui	a4,0x1
    *pp = 1;
    2fe4:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2fe8:	94ba                	add	s1,s1,a4
    2fea:	fef4ede3          	bltu	s1,a5,2fe4 <sbrkmuch+0x50>
  *lastaddr = 99;
    2fee:	064007b7          	lui	a5,0x6400
    2ff2:	06300713          	li	a4,99
    2ff6:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef387>
  a = sbrk(0);
    2ffa:	4501                	li	a0,0
    2ffc:	00003097          	auipc	ra,0x3
    3000:	718080e7          	jalr	1816(ra) # 6714 <sbrk>
    3004:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    3006:	757d                	lui	a0,0xfffff
    3008:	00003097          	auipc	ra,0x3
    300c:	70c080e7          	jalr	1804(ra) # 6714 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    3010:	57fd                	li	a5,-1
    3012:	0af50763          	beq	a0,a5,30c0 <sbrkmuch+0x12c>
  c = sbrk(0);
    3016:	4501                	li	a0,0
    3018:	00003097          	auipc	ra,0x3
    301c:	6fc080e7          	jalr	1788(ra) # 6714 <sbrk>
  if(c != a - PGSIZE){
    3020:	77fd                	lui	a5,0xfffff
    3022:	97a6                	add	a5,a5,s1
    3024:	0cf51063          	bne	a0,a5,30e4 <sbrkmuch+0x150>
  a = sbrk(0);
    3028:	4501                	li	a0,0
    302a:	00003097          	auipc	ra,0x3
    302e:	6ea080e7          	jalr	1770(ra) # 6714 <sbrk>
    3032:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    3034:	6505                	lui	a0,0x1
    3036:	00003097          	auipc	ra,0x3
    303a:	6de080e7          	jalr	1758(ra) # 6714 <sbrk>
    303e:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    3040:	0ca49663          	bne	s1,a0,310c <sbrkmuch+0x178>
    3044:	4501                	li	a0,0
    3046:	00003097          	auipc	ra,0x3
    304a:	6ce080e7          	jalr	1742(ra) # 6714 <sbrk>
    304e:	6785                	lui	a5,0x1
    3050:	97a6                	add	a5,a5,s1
    3052:	0af51d63          	bne	a0,a5,310c <sbrkmuch+0x178>
  if(*lastaddr == 99){
    3056:	064007b7          	lui	a5,0x6400
    305a:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef387>
    305e:	06300793          	li	a5,99
    3062:	0cf70963          	beq	a4,a5,3134 <sbrkmuch+0x1a0>
  a = sbrk(0);
    3066:	4501                	li	a0,0
    3068:	00003097          	auipc	ra,0x3
    306c:	6ac080e7          	jalr	1708(ra) # 6714 <sbrk>
    3070:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    3072:	4501                	li	a0,0
    3074:	00003097          	auipc	ra,0x3
    3078:	6a0080e7          	jalr	1696(ra) # 6714 <sbrk>
    307c:	40a9053b          	subw	a0,s2,a0
    3080:	00003097          	auipc	ra,0x3
    3084:	694080e7          	jalr	1684(ra) # 6714 <sbrk>
  if(c != a){
    3088:	0ca49863          	bne	s1,a0,3158 <sbrkmuch+0x1c4>
}
    308c:	70a2                	ld	ra,40(sp)
    308e:	7402                	ld	s0,32(sp)
    3090:	64e2                	ld	s1,24(sp)
    3092:	6942                	ld	s2,16(sp)
    3094:	69a2                	ld	s3,8(sp)
    3096:	6a02                	ld	s4,0(sp)
    3098:	6145                	addi	sp,sp,48
    309a:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    309c:	85ce                	mv	a1,s3
    309e:	00005517          	auipc	a0,0x5
    30a2:	9e250513          	addi	a0,a0,-1566 # 7a80 <malloc+0xf96>
    30a6:	00004097          	auipc	ra,0x4
    30aa:	986080e7          	jalr	-1658(ra) # 6a2c <printf>
    exit(1,"");
    30ae:	00005597          	auipc	a1,0x5
    30b2:	16a58593          	addi	a1,a1,362 # 8218 <malloc+0x172e>
    30b6:	4505                	li	a0,1
    30b8:	00003097          	auipc	ra,0x3
    30bc:	5d4080e7          	jalr	1492(ra) # 668c <exit>
    printf("%s: sbrk could not deallocate\n", s);
    30c0:	85ce                	mv	a1,s3
    30c2:	00005517          	auipc	a0,0x5
    30c6:	a0650513          	addi	a0,a0,-1530 # 7ac8 <malloc+0xfde>
    30ca:	00004097          	auipc	ra,0x4
    30ce:	962080e7          	jalr	-1694(ra) # 6a2c <printf>
    exit(1,"");
    30d2:	00005597          	auipc	a1,0x5
    30d6:	14658593          	addi	a1,a1,326 # 8218 <malloc+0x172e>
    30da:	4505                	li	a0,1
    30dc:	00003097          	auipc	ra,0x3
    30e0:	5b0080e7          	jalr	1456(ra) # 668c <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    30e4:	86aa                	mv	a3,a0
    30e6:	8626                	mv	a2,s1
    30e8:	85ce                	mv	a1,s3
    30ea:	00005517          	auipc	a0,0x5
    30ee:	9fe50513          	addi	a0,a0,-1538 # 7ae8 <malloc+0xffe>
    30f2:	00004097          	auipc	ra,0x4
    30f6:	93a080e7          	jalr	-1734(ra) # 6a2c <printf>
    exit(1,"");
    30fa:	00005597          	auipc	a1,0x5
    30fe:	11e58593          	addi	a1,a1,286 # 8218 <malloc+0x172e>
    3102:	4505                	li	a0,1
    3104:	00003097          	auipc	ra,0x3
    3108:	588080e7          	jalr	1416(ra) # 668c <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    310c:	86d2                	mv	a3,s4
    310e:	8626                	mv	a2,s1
    3110:	85ce                	mv	a1,s3
    3112:	00005517          	auipc	a0,0x5
    3116:	a1650513          	addi	a0,a0,-1514 # 7b28 <malloc+0x103e>
    311a:	00004097          	auipc	ra,0x4
    311e:	912080e7          	jalr	-1774(ra) # 6a2c <printf>
    exit(1,"");
    3122:	00005597          	auipc	a1,0x5
    3126:	0f658593          	addi	a1,a1,246 # 8218 <malloc+0x172e>
    312a:	4505                	li	a0,1
    312c:	00003097          	auipc	ra,0x3
    3130:	560080e7          	jalr	1376(ra) # 668c <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    3134:	85ce                	mv	a1,s3
    3136:	00005517          	auipc	a0,0x5
    313a:	a2250513          	addi	a0,a0,-1502 # 7b58 <malloc+0x106e>
    313e:	00004097          	auipc	ra,0x4
    3142:	8ee080e7          	jalr	-1810(ra) # 6a2c <printf>
    exit(1,"");
    3146:	00005597          	auipc	a1,0x5
    314a:	0d258593          	addi	a1,a1,210 # 8218 <malloc+0x172e>
    314e:	4505                	li	a0,1
    3150:	00003097          	auipc	ra,0x3
    3154:	53c080e7          	jalr	1340(ra) # 668c <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    3158:	86aa                	mv	a3,a0
    315a:	8626                	mv	a2,s1
    315c:	85ce                	mv	a1,s3
    315e:	00005517          	auipc	a0,0x5
    3162:	a3250513          	addi	a0,a0,-1486 # 7b90 <malloc+0x10a6>
    3166:	00004097          	auipc	ra,0x4
    316a:	8c6080e7          	jalr	-1850(ra) # 6a2c <printf>
    exit(1,"");
    316e:	00005597          	auipc	a1,0x5
    3172:	0aa58593          	addi	a1,a1,170 # 8218 <malloc+0x172e>
    3176:	4505                	li	a0,1
    3178:	00003097          	auipc	ra,0x3
    317c:	514080e7          	jalr	1300(ra) # 668c <exit>

0000000000003180 <sbrkarg>:
{
    3180:	7179                	addi	sp,sp,-48
    3182:	f406                	sd	ra,40(sp)
    3184:	f022                	sd	s0,32(sp)
    3186:	ec26                	sd	s1,24(sp)
    3188:	e84a                	sd	s2,16(sp)
    318a:	e44e                	sd	s3,8(sp)
    318c:	1800                	addi	s0,sp,48
    318e:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    3190:	6505                	lui	a0,0x1
    3192:	00003097          	auipc	ra,0x3
    3196:	582080e7          	jalr	1410(ra) # 6714 <sbrk>
    319a:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    319c:	20100593          	li	a1,513
    31a0:	00005517          	auipc	a0,0x5
    31a4:	a1850513          	addi	a0,a0,-1512 # 7bb8 <malloc+0x10ce>
    31a8:	00003097          	auipc	ra,0x3
    31ac:	524080e7          	jalr	1316(ra) # 66cc <open>
    31b0:	84aa                	mv	s1,a0
  unlink("sbrk");
    31b2:	00005517          	auipc	a0,0x5
    31b6:	a0650513          	addi	a0,a0,-1530 # 7bb8 <malloc+0x10ce>
    31ba:	00003097          	auipc	ra,0x3
    31be:	522080e7          	jalr	1314(ra) # 66dc <unlink>
  if(fd < 0)  {
    31c2:	0404c163          	bltz	s1,3204 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    31c6:	6605                	lui	a2,0x1
    31c8:	85ca                	mv	a1,s2
    31ca:	8526                	mv	a0,s1
    31cc:	00003097          	auipc	ra,0x3
    31d0:	4e0080e7          	jalr	1248(ra) # 66ac <write>
    31d4:	04054a63          	bltz	a0,3228 <sbrkarg+0xa8>
  close(fd);
    31d8:	8526                	mv	a0,s1
    31da:	00003097          	auipc	ra,0x3
    31de:	4da080e7          	jalr	1242(ra) # 66b4 <close>
  a = sbrk(PGSIZE);
    31e2:	6505                	lui	a0,0x1
    31e4:	00003097          	auipc	ra,0x3
    31e8:	530080e7          	jalr	1328(ra) # 6714 <sbrk>
  if(pipe((int *) a) != 0){
    31ec:	00003097          	auipc	ra,0x3
    31f0:	4b0080e7          	jalr	1200(ra) # 669c <pipe>
    31f4:	ed21                	bnez	a0,324c <sbrkarg+0xcc>
}
    31f6:	70a2                	ld	ra,40(sp)
    31f8:	7402                	ld	s0,32(sp)
    31fa:	64e2                	ld	s1,24(sp)
    31fc:	6942                	ld	s2,16(sp)
    31fe:	69a2                	ld	s3,8(sp)
    3200:	6145                	addi	sp,sp,48
    3202:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    3204:	85ce                	mv	a1,s3
    3206:	00005517          	auipc	a0,0x5
    320a:	9ba50513          	addi	a0,a0,-1606 # 7bc0 <malloc+0x10d6>
    320e:	00004097          	auipc	ra,0x4
    3212:	81e080e7          	jalr	-2018(ra) # 6a2c <printf>
    exit(1,"");
    3216:	00005597          	auipc	a1,0x5
    321a:	00258593          	addi	a1,a1,2 # 8218 <malloc+0x172e>
    321e:	4505                	li	a0,1
    3220:	00003097          	auipc	ra,0x3
    3224:	46c080e7          	jalr	1132(ra) # 668c <exit>
    printf("%s: write sbrk failed\n", s);
    3228:	85ce                	mv	a1,s3
    322a:	00005517          	auipc	a0,0x5
    322e:	9ae50513          	addi	a0,a0,-1618 # 7bd8 <malloc+0x10ee>
    3232:	00003097          	auipc	ra,0x3
    3236:	7fa080e7          	jalr	2042(ra) # 6a2c <printf>
    exit(1,"");
    323a:	00005597          	auipc	a1,0x5
    323e:	fde58593          	addi	a1,a1,-34 # 8218 <malloc+0x172e>
    3242:	4505                	li	a0,1
    3244:	00003097          	auipc	ra,0x3
    3248:	448080e7          	jalr	1096(ra) # 668c <exit>
    printf("%s: pipe() failed\n", s);
    324c:	85ce                	mv	a1,s3
    324e:	00004517          	auipc	a0,0x4
    3252:	36a50513          	addi	a0,a0,874 # 75b8 <malloc+0xace>
    3256:	00003097          	auipc	ra,0x3
    325a:	7d6080e7          	jalr	2006(ra) # 6a2c <printf>
    exit(1,"");
    325e:	00005597          	auipc	a1,0x5
    3262:	fba58593          	addi	a1,a1,-70 # 8218 <malloc+0x172e>
    3266:	4505                	li	a0,1
    3268:	00003097          	auipc	ra,0x3
    326c:	424080e7          	jalr	1060(ra) # 668c <exit>

0000000000003270 <argptest>:
{
    3270:	1101                	addi	sp,sp,-32
    3272:	ec06                	sd	ra,24(sp)
    3274:	e822                	sd	s0,16(sp)
    3276:	e426                	sd	s1,8(sp)
    3278:	e04a                	sd	s2,0(sp)
    327a:	1000                	addi	s0,sp,32
    327c:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    327e:	4581                	li	a1,0
    3280:	00005517          	auipc	a0,0x5
    3284:	97050513          	addi	a0,a0,-1680 # 7bf0 <malloc+0x1106>
    3288:	00003097          	auipc	ra,0x3
    328c:	444080e7          	jalr	1092(ra) # 66cc <open>
  if (fd < 0) {
    3290:	02054b63          	bltz	a0,32c6 <argptest+0x56>
    3294:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    3296:	4501                	li	a0,0
    3298:	00003097          	auipc	ra,0x3
    329c:	47c080e7          	jalr	1148(ra) # 6714 <sbrk>
    32a0:	567d                	li	a2,-1
    32a2:	fff50593          	addi	a1,a0,-1
    32a6:	8526                	mv	a0,s1
    32a8:	00003097          	auipc	ra,0x3
    32ac:	3fc080e7          	jalr	1020(ra) # 66a4 <read>
  close(fd);
    32b0:	8526                	mv	a0,s1
    32b2:	00003097          	auipc	ra,0x3
    32b6:	402080e7          	jalr	1026(ra) # 66b4 <close>
}
    32ba:	60e2                	ld	ra,24(sp)
    32bc:	6442                	ld	s0,16(sp)
    32be:	64a2                	ld	s1,8(sp)
    32c0:	6902                	ld	s2,0(sp)
    32c2:	6105                	addi	sp,sp,32
    32c4:	8082                	ret
    printf("%s: open failed\n", s);
    32c6:	85ca                	mv	a1,s2
    32c8:	00004517          	auipc	a0,0x4
    32cc:	20050513          	addi	a0,a0,512 # 74c8 <malloc+0x9de>
    32d0:	00003097          	auipc	ra,0x3
    32d4:	75c080e7          	jalr	1884(ra) # 6a2c <printf>
    exit(1,"");
    32d8:	00005597          	auipc	a1,0x5
    32dc:	f4058593          	addi	a1,a1,-192 # 8218 <malloc+0x172e>
    32e0:	4505                	li	a0,1
    32e2:	00003097          	auipc	ra,0x3
    32e6:	3aa080e7          	jalr	938(ra) # 668c <exit>

00000000000032ea <sbrkbugs>:
{
    32ea:	1141                	addi	sp,sp,-16
    32ec:	e406                	sd	ra,8(sp)
    32ee:	e022                	sd	s0,0(sp)
    32f0:	0800                	addi	s0,sp,16
  int pid = fork();
    32f2:	00003097          	auipc	ra,0x3
    32f6:	392080e7          	jalr	914(ra) # 6684 <fork>
  if(pid < 0){
    32fa:	02054663          	bltz	a0,3326 <sbrkbugs+0x3c>
  if(pid == 0){
    32fe:	e529                	bnez	a0,3348 <sbrkbugs+0x5e>
    int sz = (uint64) sbrk(0);
    3300:	00003097          	auipc	ra,0x3
    3304:	414080e7          	jalr	1044(ra) # 6714 <sbrk>
    sbrk(-sz);
    3308:	40a0053b          	negw	a0,a0
    330c:	00003097          	auipc	ra,0x3
    3310:	408080e7          	jalr	1032(ra) # 6714 <sbrk>
    exit(0,"");
    3314:	00005597          	auipc	a1,0x5
    3318:	f0458593          	addi	a1,a1,-252 # 8218 <malloc+0x172e>
    331c:	4501                	li	a0,0
    331e:	00003097          	auipc	ra,0x3
    3322:	36e080e7          	jalr	878(ra) # 668c <exit>
    printf("fork failed\n");
    3326:	00004517          	auipc	a0,0x4
    332a:	59250513          	addi	a0,a0,1426 # 78b8 <malloc+0xdce>
    332e:	00003097          	auipc	ra,0x3
    3332:	6fe080e7          	jalr	1790(ra) # 6a2c <printf>
    exit(1,"");
    3336:	00005597          	auipc	a1,0x5
    333a:	ee258593          	addi	a1,a1,-286 # 8218 <malloc+0x172e>
    333e:	4505                	li	a0,1
    3340:	00003097          	auipc	ra,0x3
    3344:	34c080e7          	jalr	844(ra) # 668c <exit>
  wait(0,0);
    3348:	4581                	li	a1,0
    334a:	4501                	li	a0,0
    334c:	00003097          	auipc	ra,0x3
    3350:	348080e7          	jalr	840(ra) # 6694 <wait>
  pid = fork();
    3354:	00003097          	auipc	ra,0x3
    3358:	330080e7          	jalr	816(ra) # 6684 <fork>
  if(pid < 0){
    335c:	02054963          	bltz	a0,338e <sbrkbugs+0xa4>
  if(pid == 0){
    3360:	e921                	bnez	a0,33b0 <sbrkbugs+0xc6>
    int sz = (uint64) sbrk(0);
    3362:	00003097          	auipc	ra,0x3
    3366:	3b2080e7          	jalr	946(ra) # 6714 <sbrk>
    sbrk(-(sz - 3500));
    336a:	6785                	lui	a5,0x1
    336c:	dac7879b          	addiw	a5,a5,-596
    3370:	40a7853b          	subw	a0,a5,a0
    3374:	00003097          	auipc	ra,0x3
    3378:	3a0080e7          	jalr	928(ra) # 6714 <sbrk>
    exit(0,"");
    337c:	00005597          	auipc	a1,0x5
    3380:	e9c58593          	addi	a1,a1,-356 # 8218 <malloc+0x172e>
    3384:	4501                	li	a0,0
    3386:	00003097          	auipc	ra,0x3
    338a:	306080e7          	jalr	774(ra) # 668c <exit>
    printf("fork failed\n");
    338e:	00004517          	auipc	a0,0x4
    3392:	52a50513          	addi	a0,a0,1322 # 78b8 <malloc+0xdce>
    3396:	00003097          	auipc	ra,0x3
    339a:	696080e7          	jalr	1686(ra) # 6a2c <printf>
    exit(1,"");
    339e:	00005597          	auipc	a1,0x5
    33a2:	e7a58593          	addi	a1,a1,-390 # 8218 <malloc+0x172e>
    33a6:	4505                	li	a0,1
    33a8:	00003097          	auipc	ra,0x3
    33ac:	2e4080e7          	jalr	740(ra) # 668c <exit>
  wait(0,0);
    33b0:	4581                	li	a1,0
    33b2:	4501                	li	a0,0
    33b4:	00003097          	auipc	ra,0x3
    33b8:	2e0080e7          	jalr	736(ra) # 6694 <wait>
  pid = fork();
    33bc:	00003097          	auipc	ra,0x3
    33c0:	2c8080e7          	jalr	712(ra) # 6684 <fork>
  if(pid < 0){
    33c4:	02054e63          	bltz	a0,3400 <sbrkbugs+0x116>
  if(pid == 0){
    33c8:	ed29                	bnez	a0,3422 <sbrkbugs+0x138>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    33ca:	00003097          	auipc	ra,0x3
    33ce:	34a080e7          	jalr	842(ra) # 6714 <sbrk>
    33d2:	67ad                	lui	a5,0xb
    33d4:	8007879b          	addiw	a5,a5,-2048
    33d8:	40a7853b          	subw	a0,a5,a0
    33dc:	00003097          	auipc	ra,0x3
    33e0:	338080e7          	jalr	824(ra) # 6714 <sbrk>
    sbrk(-10);
    33e4:	5559                	li	a0,-10
    33e6:	00003097          	auipc	ra,0x3
    33ea:	32e080e7          	jalr	814(ra) # 6714 <sbrk>
    exit(0,"");
    33ee:	00005597          	auipc	a1,0x5
    33f2:	e2a58593          	addi	a1,a1,-470 # 8218 <malloc+0x172e>
    33f6:	4501                	li	a0,0
    33f8:	00003097          	auipc	ra,0x3
    33fc:	294080e7          	jalr	660(ra) # 668c <exit>
    printf("fork failed\n");
    3400:	00004517          	auipc	a0,0x4
    3404:	4b850513          	addi	a0,a0,1208 # 78b8 <malloc+0xdce>
    3408:	00003097          	auipc	ra,0x3
    340c:	624080e7          	jalr	1572(ra) # 6a2c <printf>
    exit(1,"");
    3410:	00005597          	auipc	a1,0x5
    3414:	e0858593          	addi	a1,a1,-504 # 8218 <malloc+0x172e>
    3418:	4505                	li	a0,1
    341a:	00003097          	auipc	ra,0x3
    341e:	272080e7          	jalr	626(ra) # 668c <exit>
  wait(0,0);
    3422:	4581                	li	a1,0
    3424:	4501                	li	a0,0
    3426:	00003097          	auipc	ra,0x3
    342a:	26e080e7          	jalr	622(ra) # 6694 <wait>
  exit(0,"");
    342e:	00005597          	auipc	a1,0x5
    3432:	dea58593          	addi	a1,a1,-534 # 8218 <malloc+0x172e>
    3436:	4501                	li	a0,0
    3438:	00003097          	auipc	ra,0x3
    343c:	254080e7          	jalr	596(ra) # 668c <exit>

0000000000003440 <sbrklast>:
{
    3440:	7179                	addi	sp,sp,-48
    3442:	f406                	sd	ra,40(sp)
    3444:	f022                	sd	s0,32(sp)
    3446:	ec26                	sd	s1,24(sp)
    3448:	e84a                	sd	s2,16(sp)
    344a:	e44e                	sd	s3,8(sp)
    344c:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    344e:	4501                	li	a0,0
    3450:	00003097          	auipc	ra,0x3
    3454:	2c4080e7          	jalr	708(ra) # 6714 <sbrk>
  if((top % 4096) != 0)
    3458:	03451793          	slli	a5,a0,0x34
    345c:	efc1                	bnez	a5,34f4 <sbrklast+0xb4>
  sbrk(4096);
    345e:	6505                	lui	a0,0x1
    3460:	00003097          	auipc	ra,0x3
    3464:	2b4080e7          	jalr	692(ra) # 6714 <sbrk>
  sbrk(10);
    3468:	4529                	li	a0,10
    346a:	00003097          	auipc	ra,0x3
    346e:	2aa080e7          	jalr	682(ra) # 6714 <sbrk>
  sbrk(-20);
    3472:	5531                	li	a0,-20
    3474:	00003097          	auipc	ra,0x3
    3478:	2a0080e7          	jalr	672(ra) # 6714 <sbrk>
  top = (uint64) sbrk(0);
    347c:	4501                	li	a0,0
    347e:	00003097          	auipc	ra,0x3
    3482:	296080e7          	jalr	662(ra) # 6714 <sbrk>
    3486:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    3488:	fc050913          	addi	s2,a0,-64 # fc0 <unlinkread+0x148>
  p[0] = 'x';
    348c:	07800793          	li	a5,120
    3490:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    3494:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    3498:	20200593          	li	a1,514
    349c:	854a                	mv	a0,s2
    349e:	00003097          	auipc	ra,0x3
    34a2:	22e080e7          	jalr	558(ra) # 66cc <open>
    34a6:	89aa                	mv	s3,a0
  write(fd, p, 1);
    34a8:	4605                	li	a2,1
    34aa:	85ca                	mv	a1,s2
    34ac:	00003097          	auipc	ra,0x3
    34b0:	200080e7          	jalr	512(ra) # 66ac <write>
  close(fd);
    34b4:	854e                	mv	a0,s3
    34b6:	00003097          	auipc	ra,0x3
    34ba:	1fe080e7          	jalr	510(ra) # 66b4 <close>
  fd = open(p, O_RDWR);
    34be:	4589                	li	a1,2
    34c0:	854a                	mv	a0,s2
    34c2:	00003097          	auipc	ra,0x3
    34c6:	20a080e7          	jalr	522(ra) # 66cc <open>
  p[0] = '\0';
    34ca:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    34ce:	4605                	li	a2,1
    34d0:	85ca                	mv	a1,s2
    34d2:	00003097          	auipc	ra,0x3
    34d6:	1d2080e7          	jalr	466(ra) # 66a4 <read>
  if(p[0] != 'x')
    34da:	fc04c703          	lbu	a4,-64(s1)
    34de:	07800793          	li	a5,120
    34e2:	02f71363          	bne	a4,a5,3508 <sbrklast+0xc8>
}
    34e6:	70a2                	ld	ra,40(sp)
    34e8:	7402                	ld	s0,32(sp)
    34ea:	64e2                	ld	s1,24(sp)
    34ec:	6942                	ld	s2,16(sp)
    34ee:	69a2                	ld	s3,8(sp)
    34f0:	6145                	addi	sp,sp,48
    34f2:	8082                	ret
    sbrk(4096 - (top % 4096));
    34f4:	0347d513          	srli	a0,a5,0x34
    34f8:	6785                	lui	a5,0x1
    34fa:	40a7853b          	subw	a0,a5,a0
    34fe:	00003097          	auipc	ra,0x3
    3502:	216080e7          	jalr	534(ra) # 6714 <sbrk>
    3506:	bfa1                	j	345e <sbrklast+0x1e>
    exit(1,"");
    3508:	00005597          	auipc	a1,0x5
    350c:	d1058593          	addi	a1,a1,-752 # 8218 <malloc+0x172e>
    3510:	4505                	li	a0,1
    3512:	00003097          	auipc	ra,0x3
    3516:	17a080e7          	jalr	378(ra) # 668c <exit>

000000000000351a <sbrk8000>:
{
    351a:	1141                	addi	sp,sp,-16
    351c:	e406                	sd	ra,8(sp)
    351e:	e022                	sd	s0,0(sp)
    3520:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    3522:	80000537          	lui	a0,0x80000
    3526:	0511                	addi	a0,a0,4
    3528:	00003097          	auipc	ra,0x3
    352c:	1ec080e7          	jalr	492(ra) # 6714 <sbrk>
  volatile char *top = sbrk(0);
    3530:	4501                	li	a0,0
    3532:	00003097          	auipc	ra,0x3
    3536:	1e2080e7          	jalr	482(ra) # 6714 <sbrk>
  *(top-1) = *(top-1) + 1;
    353a:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7ffef387>
    353e:	0785                	addi	a5,a5,1
    3540:	0ff7f793          	andi	a5,a5,255
    3544:	fef50fa3          	sb	a5,-1(a0)
}
    3548:	60a2                	ld	ra,8(sp)
    354a:	6402                	ld	s0,0(sp)
    354c:	0141                	addi	sp,sp,16
    354e:	8082                	ret

0000000000003550 <execout>:
{
    3550:	715d                	addi	sp,sp,-80
    3552:	e486                	sd	ra,72(sp)
    3554:	e0a2                	sd	s0,64(sp)
    3556:	fc26                	sd	s1,56(sp)
    3558:	f84a                	sd	s2,48(sp)
    355a:	f44e                	sd	s3,40(sp)
    355c:	f052                	sd	s4,32(sp)
    355e:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    3560:	4901                	li	s2,0
    3562:	49bd                	li	s3,15
    int pid = fork();
    3564:	00003097          	auipc	ra,0x3
    3568:	120080e7          	jalr	288(ra) # 6684 <fork>
    356c:	84aa                	mv	s1,a0
    if(pid < 0){
    356e:	02054563          	bltz	a0,3598 <execout+0x48>
    } else if(pid == 0){
    3572:	c521                	beqz	a0,35ba <execout+0x6a>
      wait((int*)0,0);
    3574:	4581                	li	a1,0
    3576:	4501                	li	a0,0
    3578:	00003097          	auipc	ra,0x3
    357c:	11c080e7          	jalr	284(ra) # 6694 <wait>
  for(int avail = 0; avail < 15; avail++){
    3580:	2905                	addiw	s2,s2,1
    3582:	ff3911e3          	bne	s2,s3,3564 <execout+0x14>
  exit(0,"");
    3586:	00005597          	auipc	a1,0x5
    358a:	c9258593          	addi	a1,a1,-878 # 8218 <malloc+0x172e>
    358e:	4501                	li	a0,0
    3590:	00003097          	auipc	ra,0x3
    3594:	0fc080e7          	jalr	252(ra) # 668c <exit>
      printf("fork failed\n");
    3598:	00004517          	auipc	a0,0x4
    359c:	32050513          	addi	a0,a0,800 # 78b8 <malloc+0xdce>
    35a0:	00003097          	auipc	ra,0x3
    35a4:	48c080e7          	jalr	1164(ra) # 6a2c <printf>
      exit(1,"");
    35a8:	00005597          	auipc	a1,0x5
    35ac:	c7058593          	addi	a1,a1,-912 # 8218 <malloc+0x172e>
    35b0:	4505                	li	a0,1
    35b2:	00003097          	auipc	ra,0x3
    35b6:	0da080e7          	jalr	218(ra) # 668c <exit>
        if(a == 0xffffffffffffffffLL)
    35ba:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    35bc:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    35be:	6505                	lui	a0,0x1
    35c0:	00003097          	auipc	ra,0x3
    35c4:	154080e7          	jalr	340(ra) # 6714 <sbrk>
        if(a == 0xffffffffffffffffLL)
    35c8:	01350763          	beq	a0,s3,35d6 <execout+0x86>
        *(char*)(a + 4096 - 1) = 1;
    35cc:	6785                	lui	a5,0x1
    35ce:	953e                	add	a0,a0,a5
    35d0:	ff450fa3          	sb	s4,-1(a0) # fff <unlinkread+0x187>
      while(1){
    35d4:	b7ed                	j	35be <execout+0x6e>
      for(int i = 0; i < avail; i++)
    35d6:	01205a63          	blez	s2,35ea <execout+0x9a>
        sbrk(-4096);
    35da:	757d                	lui	a0,0xfffff
    35dc:	00003097          	auipc	ra,0x3
    35e0:	138080e7          	jalr	312(ra) # 6714 <sbrk>
      for(int i = 0; i < avail; i++)
    35e4:	2485                	addiw	s1,s1,1
    35e6:	ff249ae3          	bne	s1,s2,35da <execout+0x8a>
      close(1);
    35ea:	4505                	li	a0,1
    35ec:	00003097          	auipc	ra,0x3
    35f0:	0c8080e7          	jalr	200(ra) # 66b4 <close>
      char *args[] = { "echo", "x", 0 };
    35f4:	00003517          	auipc	a0,0x3
    35f8:	63450513          	addi	a0,a0,1588 # 6c28 <malloc+0x13e>
    35fc:	faa43c23          	sd	a0,-72(s0)
    3600:	00003797          	auipc	a5,0x3
    3604:	69878793          	addi	a5,a5,1688 # 6c98 <malloc+0x1ae>
    3608:	fcf43023          	sd	a5,-64(s0)
    360c:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3610:	fb840593          	addi	a1,s0,-72
    3614:	00003097          	auipc	ra,0x3
    3618:	0b0080e7          	jalr	176(ra) # 66c4 <exec>
      exit(0,"");
    361c:	00005597          	auipc	a1,0x5
    3620:	bfc58593          	addi	a1,a1,-1028 # 8218 <malloc+0x172e>
    3624:	4501                	li	a0,0
    3626:	00003097          	auipc	ra,0x3
    362a:	066080e7          	jalr	102(ra) # 668c <exit>

000000000000362e <fourteen>:
{
    362e:	1101                	addi	sp,sp,-32
    3630:	ec06                	sd	ra,24(sp)
    3632:	e822                	sd	s0,16(sp)
    3634:	e426                	sd	s1,8(sp)
    3636:	1000                	addi	s0,sp,32
    3638:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    363a:	00004517          	auipc	a0,0x4
    363e:	78e50513          	addi	a0,a0,1934 # 7dc8 <malloc+0x12de>
    3642:	00003097          	auipc	ra,0x3
    3646:	0b2080e7          	jalr	178(ra) # 66f4 <mkdir>
    364a:	e175                	bnez	a0,372e <fourteen+0x100>
  if(mkdir("12345678901234/123456789012345") != 0){
    364c:	00004517          	auipc	a0,0x4
    3650:	5d450513          	addi	a0,a0,1492 # 7c20 <malloc+0x1136>
    3654:	00003097          	auipc	ra,0x3
    3658:	0a0080e7          	jalr	160(ra) # 66f4 <mkdir>
    365c:	e97d                	bnez	a0,3752 <fourteen+0x124>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    365e:	20000593          	li	a1,512
    3662:	00004517          	auipc	a0,0x4
    3666:	61650513          	addi	a0,a0,1558 # 7c78 <malloc+0x118e>
    366a:	00003097          	auipc	ra,0x3
    366e:	062080e7          	jalr	98(ra) # 66cc <open>
  if(fd < 0){
    3672:	10054263          	bltz	a0,3776 <fourteen+0x148>
  close(fd);
    3676:	00003097          	auipc	ra,0x3
    367a:	03e080e7          	jalr	62(ra) # 66b4 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    367e:	4581                	li	a1,0
    3680:	00004517          	auipc	a0,0x4
    3684:	67050513          	addi	a0,a0,1648 # 7cf0 <malloc+0x1206>
    3688:	00003097          	auipc	ra,0x3
    368c:	044080e7          	jalr	68(ra) # 66cc <open>
  if(fd < 0){
    3690:	10054563          	bltz	a0,379a <fourteen+0x16c>
  close(fd);
    3694:	00003097          	auipc	ra,0x3
    3698:	020080e7          	jalr	32(ra) # 66b4 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    369c:	00004517          	auipc	a0,0x4
    36a0:	6c450513          	addi	a0,a0,1732 # 7d60 <malloc+0x1276>
    36a4:	00003097          	auipc	ra,0x3
    36a8:	050080e7          	jalr	80(ra) # 66f4 <mkdir>
    36ac:	10050963          	beqz	a0,37be <fourteen+0x190>
  if(mkdir("123456789012345/12345678901234") == 0){
    36b0:	00004517          	auipc	a0,0x4
    36b4:	70850513          	addi	a0,a0,1800 # 7db8 <malloc+0x12ce>
    36b8:	00003097          	auipc	ra,0x3
    36bc:	03c080e7          	jalr	60(ra) # 66f4 <mkdir>
    36c0:	12050163          	beqz	a0,37e2 <fourteen+0x1b4>
  unlink("123456789012345/12345678901234");
    36c4:	00004517          	auipc	a0,0x4
    36c8:	6f450513          	addi	a0,a0,1780 # 7db8 <malloc+0x12ce>
    36cc:	00003097          	auipc	ra,0x3
    36d0:	010080e7          	jalr	16(ra) # 66dc <unlink>
  unlink("12345678901234/12345678901234");
    36d4:	00004517          	auipc	a0,0x4
    36d8:	68c50513          	addi	a0,a0,1676 # 7d60 <malloc+0x1276>
    36dc:	00003097          	auipc	ra,0x3
    36e0:	000080e7          	jalr	ra # 66dc <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    36e4:	00004517          	auipc	a0,0x4
    36e8:	60c50513          	addi	a0,a0,1548 # 7cf0 <malloc+0x1206>
    36ec:	00003097          	auipc	ra,0x3
    36f0:	ff0080e7          	jalr	-16(ra) # 66dc <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    36f4:	00004517          	auipc	a0,0x4
    36f8:	58450513          	addi	a0,a0,1412 # 7c78 <malloc+0x118e>
    36fc:	00003097          	auipc	ra,0x3
    3700:	fe0080e7          	jalr	-32(ra) # 66dc <unlink>
  unlink("12345678901234/123456789012345");
    3704:	00004517          	auipc	a0,0x4
    3708:	51c50513          	addi	a0,a0,1308 # 7c20 <malloc+0x1136>
    370c:	00003097          	auipc	ra,0x3
    3710:	fd0080e7          	jalr	-48(ra) # 66dc <unlink>
  unlink("12345678901234");
    3714:	00004517          	auipc	a0,0x4
    3718:	6b450513          	addi	a0,a0,1716 # 7dc8 <malloc+0x12de>
    371c:	00003097          	auipc	ra,0x3
    3720:	fc0080e7          	jalr	-64(ra) # 66dc <unlink>
}
    3724:	60e2                	ld	ra,24(sp)
    3726:	6442                	ld	s0,16(sp)
    3728:	64a2                	ld	s1,8(sp)
    372a:	6105                	addi	sp,sp,32
    372c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    372e:	85a6                	mv	a1,s1
    3730:	00004517          	auipc	a0,0x4
    3734:	4c850513          	addi	a0,a0,1224 # 7bf8 <malloc+0x110e>
    3738:	00003097          	auipc	ra,0x3
    373c:	2f4080e7          	jalr	756(ra) # 6a2c <printf>
    exit(1,"");
    3740:	00005597          	auipc	a1,0x5
    3744:	ad858593          	addi	a1,a1,-1320 # 8218 <malloc+0x172e>
    3748:	4505                	li	a0,1
    374a:	00003097          	auipc	ra,0x3
    374e:	f42080e7          	jalr	-190(ra) # 668c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3752:	85a6                	mv	a1,s1
    3754:	00004517          	auipc	a0,0x4
    3758:	4ec50513          	addi	a0,a0,1260 # 7c40 <malloc+0x1156>
    375c:	00003097          	auipc	ra,0x3
    3760:	2d0080e7          	jalr	720(ra) # 6a2c <printf>
    exit(1,"");
    3764:	00005597          	auipc	a1,0x5
    3768:	ab458593          	addi	a1,a1,-1356 # 8218 <malloc+0x172e>
    376c:	4505                	li	a0,1
    376e:	00003097          	auipc	ra,0x3
    3772:	f1e080e7          	jalr	-226(ra) # 668c <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3776:	85a6                	mv	a1,s1
    3778:	00004517          	auipc	a0,0x4
    377c:	53050513          	addi	a0,a0,1328 # 7ca8 <malloc+0x11be>
    3780:	00003097          	auipc	ra,0x3
    3784:	2ac080e7          	jalr	684(ra) # 6a2c <printf>
    exit(1,"");
    3788:	00005597          	auipc	a1,0x5
    378c:	a9058593          	addi	a1,a1,-1392 # 8218 <malloc+0x172e>
    3790:	4505                	li	a0,1
    3792:	00003097          	auipc	ra,0x3
    3796:	efa080e7          	jalr	-262(ra) # 668c <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    379a:	85a6                	mv	a1,s1
    379c:	00004517          	auipc	a0,0x4
    37a0:	58450513          	addi	a0,a0,1412 # 7d20 <malloc+0x1236>
    37a4:	00003097          	auipc	ra,0x3
    37a8:	288080e7          	jalr	648(ra) # 6a2c <printf>
    exit(1,"");
    37ac:	00005597          	auipc	a1,0x5
    37b0:	a6c58593          	addi	a1,a1,-1428 # 8218 <malloc+0x172e>
    37b4:	4505                	li	a0,1
    37b6:	00003097          	auipc	ra,0x3
    37ba:	ed6080e7          	jalr	-298(ra) # 668c <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    37be:	85a6                	mv	a1,s1
    37c0:	00004517          	auipc	a0,0x4
    37c4:	5c050513          	addi	a0,a0,1472 # 7d80 <malloc+0x1296>
    37c8:	00003097          	auipc	ra,0x3
    37cc:	264080e7          	jalr	612(ra) # 6a2c <printf>
    exit(1,"");
    37d0:	00005597          	auipc	a1,0x5
    37d4:	a4858593          	addi	a1,a1,-1464 # 8218 <malloc+0x172e>
    37d8:	4505                	li	a0,1
    37da:	00003097          	auipc	ra,0x3
    37de:	eb2080e7          	jalr	-334(ra) # 668c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    37e2:	85a6                	mv	a1,s1
    37e4:	00004517          	auipc	a0,0x4
    37e8:	5f450513          	addi	a0,a0,1524 # 7dd8 <malloc+0x12ee>
    37ec:	00003097          	auipc	ra,0x3
    37f0:	240080e7          	jalr	576(ra) # 6a2c <printf>
    exit(1,"");
    37f4:	00005597          	auipc	a1,0x5
    37f8:	a2458593          	addi	a1,a1,-1500 # 8218 <malloc+0x172e>
    37fc:	4505                	li	a0,1
    37fe:	00003097          	auipc	ra,0x3
    3802:	e8e080e7          	jalr	-370(ra) # 668c <exit>

0000000000003806 <diskfull>:
{
    3806:	b9010113          	addi	sp,sp,-1136
    380a:	46113423          	sd	ra,1128(sp)
    380e:	46813023          	sd	s0,1120(sp)
    3812:	44913c23          	sd	s1,1112(sp)
    3816:	45213823          	sd	s2,1104(sp)
    381a:	45313423          	sd	s3,1096(sp)
    381e:	45413023          	sd	s4,1088(sp)
    3822:	43513c23          	sd	s5,1080(sp)
    3826:	43613823          	sd	s6,1072(sp)
    382a:	43713423          	sd	s7,1064(sp)
    382e:	43813023          	sd	s8,1056(sp)
    3832:	47010413          	addi	s0,sp,1136
    3836:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    3838:	00004517          	auipc	a0,0x4
    383c:	5d850513          	addi	a0,a0,1496 # 7e10 <malloc+0x1326>
    3840:	00003097          	auipc	ra,0x3
    3844:	e9c080e7          	jalr	-356(ra) # 66dc <unlink>
  for(fi = 0; done == 0; fi++){
    3848:	4a01                	li	s4,0
    name[0] = 'b';
    384a:	06200b13          	li	s6,98
    name[1] = 'i';
    384e:	06900a93          	li	s5,105
    name[2] = 'g';
    3852:	06700993          	li	s3,103
    3856:	10c00b93          	li	s7,268
    385a:	aabd                	j	39d8 <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    385c:	b9040613          	addi	a2,s0,-1136
    3860:	85e2                	mv	a1,s8
    3862:	00004517          	auipc	a0,0x4
    3866:	5be50513          	addi	a0,a0,1470 # 7e20 <malloc+0x1336>
    386a:	00003097          	auipc	ra,0x3
    386e:	1c2080e7          	jalr	450(ra) # 6a2c <printf>
      break;
    3872:	a821                	j	388a <diskfull+0x84>
        close(fd);
    3874:	854a                	mv	a0,s2
    3876:	00003097          	auipc	ra,0x3
    387a:	e3e080e7          	jalr	-450(ra) # 66b4 <close>
    close(fd);
    387e:	854a                	mv	a0,s2
    3880:	00003097          	auipc	ra,0x3
    3884:	e34080e7          	jalr	-460(ra) # 66b4 <close>
  for(fi = 0; done == 0; fi++){
    3888:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    388a:	4481                	li	s1,0
    name[0] = 'z';
    388c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3890:	08000993          	li	s3,128
    name[0] = 'z';
    3894:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3898:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    389c:	41f4d79b          	sraiw	a5,s1,0x1f
    38a0:	01b7d71b          	srliw	a4,a5,0x1b
    38a4:	009707bb          	addw	a5,a4,s1
    38a8:	4057d69b          	sraiw	a3,a5,0x5
    38ac:	0306869b          	addiw	a3,a3,48
    38b0:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    38b4:	8bfd                	andi	a5,a5,31
    38b6:	9f99                	subw	a5,a5,a4
    38b8:	0307879b          	addiw	a5,a5,48
    38bc:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    38c0:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    38c4:	bb040513          	addi	a0,s0,-1104
    38c8:	00003097          	auipc	ra,0x3
    38cc:	e14080e7          	jalr	-492(ra) # 66dc <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    38d0:	60200593          	li	a1,1538
    38d4:	bb040513          	addi	a0,s0,-1104
    38d8:	00003097          	auipc	ra,0x3
    38dc:	df4080e7          	jalr	-524(ra) # 66cc <open>
    if(fd < 0)
    38e0:	00054963          	bltz	a0,38f2 <diskfull+0xec>
    close(fd);
    38e4:	00003097          	auipc	ra,0x3
    38e8:	dd0080e7          	jalr	-560(ra) # 66b4 <close>
  for(int i = 0; i < nzz; i++){
    38ec:	2485                	addiw	s1,s1,1
    38ee:	fb3493e3          	bne	s1,s3,3894 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    38f2:	00004517          	auipc	a0,0x4
    38f6:	51e50513          	addi	a0,a0,1310 # 7e10 <malloc+0x1326>
    38fa:	00003097          	auipc	ra,0x3
    38fe:	dfa080e7          	jalr	-518(ra) # 66f4 <mkdir>
    3902:	12050963          	beqz	a0,3a34 <diskfull+0x22e>
  unlink("diskfulldir");
    3906:	00004517          	auipc	a0,0x4
    390a:	50a50513          	addi	a0,a0,1290 # 7e10 <malloc+0x1326>
    390e:	00003097          	auipc	ra,0x3
    3912:	dce080e7          	jalr	-562(ra) # 66dc <unlink>
  for(int i = 0; i < nzz; i++){
    3916:	4481                	li	s1,0
    name[0] = 'z';
    3918:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    391c:	08000993          	li	s3,128
    name[0] = 'z';
    3920:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3924:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3928:	41f4d79b          	sraiw	a5,s1,0x1f
    392c:	01b7d71b          	srliw	a4,a5,0x1b
    3930:	009707bb          	addw	a5,a4,s1
    3934:	4057d69b          	sraiw	a3,a5,0x5
    3938:	0306869b          	addiw	a3,a3,48
    393c:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3940:	8bfd                	andi	a5,a5,31
    3942:	9f99                	subw	a5,a5,a4
    3944:	0307879b          	addiw	a5,a5,48
    3948:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    394c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3950:	bb040513          	addi	a0,s0,-1104
    3954:	00003097          	auipc	ra,0x3
    3958:	d88080e7          	jalr	-632(ra) # 66dc <unlink>
  for(int i = 0; i < nzz; i++){
    395c:	2485                	addiw	s1,s1,1
    395e:	fd3491e3          	bne	s1,s3,3920 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    3962:	03405e63          	blez	s4,399e <diskfull+0x198>
    3966:	4481                	li	s1,0
    name[0] = 'b';
    3968:	06200a93          	li	s5,98
    name[1] = 'i';
    396c:	06900993          	li	s3,105
    name[2] = 'g';
    3970:	06700913          	li	s2,103
    name[0] = 'b';
    3974:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    3978:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    397c:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3980:	0304879b          	addiw	a5,s1,48
    3984:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3988:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    398c:	bb040513          	addi	a0,s0,-1104
    3990:	00003097          	auipc	ra,0x3
    3994:	d4c080e7          	jalr	-692(ra) # 66dc <unlink>
  for(int i = 0; i < fi; i++){
    3998:	2485                	addiw	s1,s1,1
    399a:	fd449de3          	bne	s1,s4,3974 <diskfull+0x16e>
}
    399e:	46813083          	ld	ra,1128(sp)
    39a2:	46013403          	ld	s0,1120(sp)
    39a6:	45813483          	ld	s1,1112(sp)
    39aa:	45013903          	ld	s2,1104(sp)
    39ae:	44813983          	ld	s3,1096(sp)
    39b2:	44013a03          	ld	s4,1088(sp)
    39b6:	43813a83          	ld	s5,1080(sp)
    39ba:	43013b03          	ld	s6,1072(sp)
    39be:	42813b83          	ld	s7,1064(sp)
    39c2:	42013c03          	ld	s8,1056(sp)
    39c6:	47010113          	addi	sp,sp,1136
    39ca:	8082                	ret
    close(fd);
    39cc:	854a                	mv	a0,s2
    39ce:	00003097          	auipc	ra,0x3
    39d2:	ce6080e7          	jalr	-794(ra) # 66b4 <close>
  for(fi = 0; done == 0; fi++){
    39d6:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    39d8:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    39dc:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    39e0:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    39e4:	030a079b          	addiw	a5,s4,48
    39e8:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    39ec:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    39f0:	b9040513          	addi	a0,s0,-1136
    39f4:	00003097          	auipc	ra,0x3
    39f8:	ce8080e7          	jalr	-792(ra) # 66dc <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    39fc:	60200593          	li	a1,1538
    3a00:	b9040513          	addi	a0,s0,-1136
    3a04:	00003097          	auipc	ra,0x3
    3a08:	cc8080e7          	jalr	-824(ra) # 66cc <open>
    3a0c:	892a                	mv	s2,a0
    if(fd < 0){
    3a0e:	e40547e3          	bltz	a0,385c <diskfull+0x56>
    3a12:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3a14:	40000613          	li	a2,1024
    3a18:	bb040593          	addi	a1,s0,-1104
    3a1c:	854a                	mv	a0,s2
    3a1e:	00003097          	auipc	ra,0x3
    3a22:	c8e080e7          	jalr	-882(ra) # 66ac <write>
    3a26:	40000793          	li	a5,1024
    3a2a:	e4f515e3          	bne	a0,a5,3874 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    3a2e:	34fd                	addiw	s1,s1,-1
    3a30:	f0f5                	bnez	s1,3a14 <diskfull+0x20e>
    3a32:	bf69                	j	39cc <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3a34:	00004517          	auipc	a0,0x4
    3a38:	40c50513          	addi	a0,a0,1036 # 7e40 <malloc+0x1356>
    3a3c:	00003097          	auipc	ra,0x3
    3a40:	ff0080e7          	jalr	-16(ra) # 6a2c <printf>
    3a44:	b5c9                	j	3906 <diskfull+0x100>

0000000000003a46 <iputtest>:
{
    3a46:	1101                	addi	sp,sp,-32
    3a48:	ec06                	sd	ra,24(sp)
    3a4a:	e822                	sd	s0,16(sp)
    3a4c:	e426                	sd	s1,8(sp)
    3a4e:	1000                	addi	s0,sp,32
    3a50:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3a52:	00004517          	auipc	a0,0x4
    3a56:	41e50513          	addi	a0,a0,1054 # 7e70 <malloc+0x1386>
    3a5a:	00003097          	auipc	ra,0x3
    3a5e:	c9a080e7          	jalr	-870(ra) # 66f4 <mkdir>
    3a62:	04054563          	bltz	a0,3aac <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3a66:	00004517          	auipc	a0,0x4
    3a6a:	40a50513          	addi	a0,a0,1034 # 7e70 <malloc+0x1386>
    3a6e:	00003097          	auipc	ra,0x3
    3a72:	c8e080e7          	jalr	-882(ra) # 66fc <chdir>
    3a76:	04054d63          	bltz	a0,3ad0 <iputtest+0x8a>
  if(unlink("../iputdir") < 0){
    3a7a:	00004517          	auipc	a0,0x4
    3a7e:	43650513          	addi	a0,a0,1078 # 7eb0 <malloc+0x13c6>
    3a82:	00003097          	auipc	ra,0x3
    3a86:	c5a080e7          	jalr	-934(ra) # 66dc <unlink>
    3a8a:	06054563          	bltz	a0,3af4 <iputtest+0xae>
  if(chdir("/") < 0){
    3a8e:	00004517          	auipc	a0,0x4
    3a92:	45250513          	addi	a0,a0,1106 # 7ee0 <malloc+0x13f6>
    3a96:	00003097          	auipc	ra,0x3
    3a9a:	c66080e7          	jalr	-922(ra) # 66fc <chdir>
    3a9e:	06054d63          	bltz	a0,3b18 <iputtest+0xd2>
}
    3aa2:	60e2                	ld	ra,24(sp)
    3aa4:	6442                	ld	s0,16(sp)
    3aa6:	64a2                	ld	s1,8(sp)
    3aa8:	6105                	addi	sp,sp,32
    3aaa:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3aac:	85a6                	mv	a1,s1
    3aae:	00004517          	auipc	a0,0x4
    3ab2:	3ca50513          	addi	a0,a0,970 # 7e78 <malloc+0x138e>
    3ab6:	00003097          	auipc	ra,0x3
    3aba:	f76080e7          	jalr	-138(ra) # 6a2c <printf>
    exit(1,"");
    3abe:	00004597          	auipc	a1,0x4
    3ac2:	75a58593          	addi	a1,a1,1882 # 8218 <malloc+0x172e>
    3ac6:	4505                	li	a0,1
    3ac8:	00003097          	auipc	ra,0x3
    3acc:	bc4080e7          	jalr	-1084(ra) # 668c <exit>
    printf("%s: chdir iputdir failed\n", s);
    3ad0:	85a6                	mv	a1,s1
    3ad2:	00004517          	auipc	a0,0x4
    3ad6:	3be50513          	addi	a0,a0,958 # 7e90 <malloc+0x13a6>
    3ada:	00003097          	auipc	ra,0x3
    3ade:	f52080e7          	jalr	-174(ra) # 6a2c <printf>
    exit(1,"");
    3ae2:	00004597          	auipc	a1,0x4
    3ae6:	73658593          	addi	a1,a1,1846 # 8218 <malloc+0x172e>
    3aea:	4505                	li	a0,1
    3aec:	00003097          	auipc	ra,0x3
    3af0:	ba0080e7          	jalr	-1120(ra) # 668c <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3af4:	85a6                	mv	a1,s1
    3af6:	00004517          	auipc	a0,0x4
    3afa:	3ca50513          	addi	a0,a0,970 # 7ec0 <malloc+0x13d6>
    3afe:	00003097          	auipc	ra,0x3
    3b02:	f2e080e7          	jalr	-210(ra) # 6a2c <printf>
    exit(1,"");
    3b06:	00004597          	auipc	a1,0x4
    3b0a:	71258593          	addi	a1,a1,1810 # 8218 <malloc+0x172e>
    3b0e:	4505                	li	a0,1
    3b10:	00003097          	auipc	ra,0x3
    3b14:	b7c080e7          	jalr	-1156(ra) # 668c <exit>
    printf("%s: chdir / failed\n", s);
    3b18:	85a6                	mv	a1,s1
    3b1a:	00004517          	auipc	a0,0x4
    3b1e:	3ce50513          	addi	a0,a0,974 # 7ee8 <malloc+0x13fe>
    3b22:	00003097          	auipc	ra,0x3
    3b26:	f0a080e7          	jalr	-246(ra) # 6a2c <printf>
    exit(1,"");
    3b2a:	00004597          	auipc	a1,0x4
    3b2e:	6ee58593          	addi	a1,a1,1774 # 8218 <malloc+0x172e>
    3b32:	4505                	li	a0,1
    3b34:	00003097          	auipc	ra,0x3
    3b38:	b58080e7          	jalr	-1192(ra) # 668c <exit>

0000000000003b3c <exitiputtest>:
{
    3b3c:	7179                	addi	sp,sp,-48
    3b3e:	f406                	sd	ra,40(sp)
    3b40:	f022                	sd	s0,32(sp)
    3b42:	ec26                	sd	s1,24(sp)
    3b44:	1800                	addi	s0,sp,48
    3b46:	84aa                	mv	s1,a0
  pid = fork();
    3b48:	00003097          	auipc	ra,0x3
    3b4c:	b3c080e7          	jalr	-1220(ra) # 6684 <fork>
  if(pid < 0){
    3b50:	04054a63          	bltz	a0,3ba4 <exitiputtest+0x68>
  if(pid == 0){
    3b54:	e165                	bnez	a0,3c34 <exitiputtest+0xf8>
    if(mkdir("iputdir") < 0){
    3b56:	00004517          	auipc	a0,0x4
    3b5a:	31a50513          	addi	a0,a0,794 # 7e70 <malloc+0x1386>
    3b5e:	00003097          	auipc	ra,0x3
    3b62:	b96080e7          	jalr	-1130(ra) # 66f4 <mkdir>
    3b66:	06054163          	bltz	a0,3bc8 <exitiputtest+0x8c>
    if(chdir("iputdir") < 0){
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	30650513          	addi	a0,a0,774 # 7e70 <malloc+0x1386>
    3b72:	00003097          	auipc	ra,0x3
    3b76:	b8a080e7          	jalr	-1142(ra) # 66fc <chdir>
    3b7a:	06054963          	bltz	a0,3bec <exitiputtest+0xb0>
    if(unlink("../iputdir") < 0){
    3b7e:	00004517          	auipc	a0,0x4
    3b82:	33250513          	addi	a0,a0,818 # 7eb0 <malloc+0x13c6>
    3b86:	00003097          	auipc	ra,0x3
    3b8a:	b56080e7          	jalr	-1194(ra) # 66dc <unlink>
    3b8e:	08054163          	bltz	a0,3c10 <exitiputtest+0xd4>
    exit(0,"");
    3b92:	00004597          	auipc	a1,0x4
    3b96:	68658593          	addi	a1,a1,1670 # 8218 <malloc+0x172e>
    3b9a:	4501                	li	a0,0
    3b9c:	00003097          	auipc	ra,0x3
    3ba0:	af0080e7          	jalr	-1296(ra) # 668c <exit>
    printf("%s: fork failed\n", s);
    3ba4:	85a6                	mv	a1,s1
    3ba6:	00004517          	auipc	a0,0x4
    3baa:	90a50513          	addi	a0,a0,-1782 # 74b0 <malloc+0x9c6>
    3bae:	00003097          	auipc	ra,0x3
    3bb2:	e7e080e7          	jalr	-386(ra) # 6a2c <printf>
    exit(1,"");
    3bb6:	00004597          	auipc	a1,0x4
    3bba:	66258593          	addi	a1,a1,1634 # 8218 <malloc+0x172e>
    3bbe:	4505                	li	a0,1
    3bc0:	00003097          	auipc	ra,0x3
    3bc4:	acc080e7          	jalr	-1332(ra) # 668c <exit>
      printf("%s: mkdir failed\n", s);
    3bc8:	85a6                	mv	a1,s1
    3bca:	00004517          	auipc	a0,0x4
    3bce:	2ae50513          	addi	a0,a0,686 # 7e78 <malloc+0x138e>
    3bd2:	00003097          	auipc	ra,0x3
    3bd6:	e5a080e7          	jalr	-422(ra) # 6a2c <printf>
      exit(1,"");
    3bda:	00004597          	auipc	a1,0x4
    3bde:	63e58593          	addi	a1,a1,1598 # 8218 <malloc+0x172e>
    3be2:	4505                	li	a0,1
    3be4:	00003097          	auipc	ra,0x3
    3be8:	aa8080e7          	jalr	-1368(ra) # 668c <exit>
      printf("%s: child chdir failed\n", s);
    3bec:	85a6                	mv	a1,s1
    3bee:	00004517          	auipc	a0,0x4
    3bf2:	31250513          	addi	a0,a0,786 # 7f00 <malloc+0x1416>
    3bf6:	00003097          	auipc	ra,0x3
    3bfa:	e36080e7          	jalr	-458(ra) # 6a2c <printf>
      exit(1,"");
    3bfe:	00004597          	auipc	a1,0x4
    3c02:	61a58593          	addi	a1,a1,1562 # 8218 <malloc+0x172e>
    3c06:	4505                	li	a0,1
    3c08:	00003097          	auipc	ra,0x3
    3c0c:	a84080e7          	jalr	-1404(ra) # 668c <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3c10:	85a6                	mv	a1,s1
    3c12:	00004517          	auipc	a0,0x4
    3c16:	2ae50513          	addi	a0,a0,686 # 7ec0 <malloc+0x13d6>
    3c1a:	00003097          	auipc	ra,0x3
    3c1e:	e12080e7          	jalr	-494(ra) # 6a2c <printf>
      exit(1,"");
    3c22:	00004597          	auipc	a1,0x4
    3c26:	5f658593          	addi	a1,a1,1526 # 8218 <malloc+0x172e>
    3c2a:	4505                	li	a0,1
    3c2c:	00003097          	auipc	ra,0x3
    3c30:	a60080e7          	jalr	-1440(ra) # 668c <exit>
  wait(&xstatus,0);
    3c34:	4581                	li	a1,0
    3c36:	fdc40513          	addi	a0,s0,-36
    3c3a:	00003097          	auipc	ra,0x3
    3c3e:	a5a080e7          	jalr	-1446(ra) # 6694 <wait>
  exit(xstatus,"");
    3c42:	00004597          	auipc	a1,0x4
    3c46:	5d658593          	addi	a1,a1,1494 # 8218 <malloc+0x172e>
    3c4a:	fdc42503          	lw	a0,-36(s0)
    3c4e:	00003097          	auipc	ra,0x3
    3c52:	a3e080e7          	jalr	-1474(ra) # 668c <exit>

0000000000003c56 <dirtest>:
{
    3c56:	1101                	addi	sp,sp,-32
    3c58:	ec06                	sd	ra,24(sp)
    3c5a:	e822                	sd	s0,16(sp)
    3c5c:	e426                	sd	s1,8(sp)
    3c5e:	1000                	addi	s0,sp,32
    3c60:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3c62:	00004517          	auipc	a0,0x4
    3c66:	2b650513          	addi	a0,a0,694 # 7f18 <malloc+0x142e>
    3c6a:	00003097          	auipc	ra,0x3
    3c6e:	a8a080e7          	jalr	-1398(ra) # 66f4 <mkdir>
    3c72:	04054563          	bltz	a0,3cbc <dirtest+0x66>
  if(chdir("dir0") < 0){
    3c76:	00004517          	auipc	a0,0x4
    3c7a:	2a250513          	addi	a0,a0,674 # 7f18 <malloc+0x142e>
    3c7e:	00003097          	auipc	ra,0x3
    3c82:	a7e080e7          	jalr	-1410(ra) # 66fc <chdir>
    3c86:	04054d63          	bltz	a0,3ce0 <dirtest+0x8a>
  if(chdir("..") < 0){
    3c8a:	00004517          	auipc	a0,0x4
    3c8e:	2ae50513          	addi	a0,a0,686 # 7f38 <malloc+0x144e>
    3c92:	00003097          	auipc	ra,0x3
    3c96:	a6a080e7          	jalr	-1430(ra) # 66fc <chdir>
    3c9a:	06054563          	bltz	a0,3d04 <dirtest+0xae>
  if(unlink("dir0") < 0){
    3c9e:	00004517          	auipc	a0,0x4
    3ca2:	27a50513          	addi	a0,a0,634 # 7f18 <malloc+0x142e>
    3ca6:	00003097          	auipc	ra,0x3
    3caa:	a36080e7          	jalr	-1482(ra) # 66dc <unlink>
    3cae:	06054d63          	bltz	a0,3d28 <dirtest+0xd2>
}
    3cb2:	60e2                	ld	ra,24(sp)
    3cb4:	6442                	ld	s0,16(sp)
    3cb6:	64a2                	ld	s1,8(sp)
    3cb8:	6105                	addi	sp,sp,32
    3cba:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3cbc:	85a6                	mv	a1,s1
    3cbe:	00004517          	auipc	a0,0x4
    3cc2:	1ba50513          	addi	a0,a0,442 # 7e78 <malloc+0x138e>
    3cc6:	00003097          	auipc	ra,0x3
    3cca:	d66080e7          	jalr	-666(ra) # 6a2c <printf>
    exit(1,"");
    3cce:	00004597          	auipc	a1,0x4
    3cd2:	54a58593          	addi	a1,a1,1354 # 8218 <malloc+0x172e>
    3cd6:	4505                	li	a0,1
    3cd8:	00003097          	auipc	ra,0x3
    3cdc:	9b4080e7          	jalr	-1612(ra) # 668c <exit>
    printf("%s: chdir dir0 failed\n", s);
    3ce0:	85a6                	mv	a1,s1
    3ce2:	00004517          	auipc	a0,0x4
    3ce6:	23e50513          	addi	a0,a0,574 # 7f20 <malloc+0x1436>
    3cea:	00003097          	auipc	ra,0x3
    3cee:	d42080e7          	jalr	-702(ra) # 6a2c <printf>
    exit(1,"");
    3cf2:	00004597          	auipc	a1,0x4
    3cf6:	52658593          	addi	a1,a1,1318 # 8218 <malloc+0x172e>
    3cfa:	4505                	li	a0,1
    3cfc:	00003097          	auipc	ra,0x3
    3d00:	990080e7          	jalr	-1648(ra) # 668c <exit>
    printf("%s: chdir .. failed\n", s);
    3d04:	85a6                	mv	a1,s1
    3d06:	00004517          	auipc	a0,0x4
    3d0a:	23a50513          	addi	a0,a0,570 # 7f40 <malloc+0x1456>
    3d0e:	00003097          	auipc	ra,0x3
    3d12:	d1e080e7          	jalr	-738(ra) # 6a2c <printf>
    exit(1,"");
    3d16:	00004597          	auipc	a1,0x4
    3d1a:	50258593          	addi	a1,a1,1282 # 8218 <malloc+0x172e>
    3d1e:	4505                	li	a0,1
    3d20:	00003097          	auipc	ra,0x3
    3d24:	96c080e7          	jalr	-1684(ra) # 668c <exit>
    printf("%s: unlink dir0 failed\n", s);
    3d28:	85a6                	mv	a1,s1
    3d2a:	00004517          	auipc	a0,0x4
    3d2e:	22e50513          	addi	a0,a0,558 # 7f58 <malloc+0x146e>
    3d32:	00003097          	auipc	ra,0x3
    3d36:	cfa080e7          	jalr	-774(ra) # 6a2c <printf>
    exit(1,"");
    3d3a:	00004597          	auipc	a1,0x4
    3d3e:	4de58593          	addi	a1,a1,1246 # 8218 <malloc+0x172e>
    3d42:	4505                	li	a0,1
    3d44:	00003097          	auipc	ra,0x3
    3d48:	948080e7          	jalr	-1720(ra) # 668c <exit>

0000000000003d4c <subdir>:
{
    3d4c:	1101                	addi	sp,sp,-32
    3d4e:	ec06                	sd	ra,24(sp)
    3d50:	e822                	sd	s0,16(sp)
    3d52:	e426                	sd	s1,8(sp)
    3d54:	e04a                	sd	s2,0(sp)
    3d56:	1000                	addi	s0,sp,32
    3d58:	892a                	mv	s2,a0
  unlink("ff");
    3d5a:	00004517          	auipc	a0,0x4
    3d5e:	34650513          	addi	a0,a0,838 # 80a0 <malloc+0x15b6>
    3d62:	00003097          	auipc	ra,0x3
    3d66:	97a080e7          	jalr	-1670(ra) # 66dc <unlink>
  if(mkdir("dd") != 0){
    3d6a:	00004517          	auipc	a0,0x4
    3d6e:	20650513          	addi	a0,a0,518 # 7f70 <malloc+0x1486>
    3d72:	00003097          	auipc	ra,0x3
    3d76:	982080e7          	jalr	-1662(ra) # 66f4 <mkdir>
    3d7a:	38051663          	bnez	a0,4106 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3d7e:	20200593          	li	a1,514
    3d82:	00004517          	auipc	a0,0x4
    3d86:	20e50513          	addi	a0,a0,526 # 7f90 <malloc+0x14a6>
    3d8a:	00003097          	auipc	ra,0x3
    3d8e:	942080e7          	jalr	-1726(ra) # 66cc <open>
    3d92:	84aa                	mv	s1,a0
  if(fd < 0){
    3d94:	38054b63          	bltz	a0,412a <subdir+0x3de>
  write(fd, "ff", 2);
    3d98:	4609                	li	a2,2
    3d9a:	00004597          	auipc	a1,0x4
    3d9e:	30658593          	addi	a1,a1,774 # 80a0 <malloc+0x15b6>
    3da2:	00003097          	auipc	ra,0x3
    3da6:	90a080e7          	jalr	-1782(ra) # 66ac <write>
  close(fd);
    3daa:	8526                	mv	a0,s1
    3dac:	00003097          	auipc	ra,0x3
    3db0:	908080e7          	jalr	-1784(ra) # 66b4 <close>
  if(unlink("dd") >= 0){
    3db4:	00004517          	auipc	a0,0x4
    3db8:	1bc50513          	addi	a0,a0,444 # 7f70 <malloc+0x1486>
    3dbc:	00003097          	auipc	ra,0x3
    3dc0:	920080e7          	jalr	-1760(ra) # 66dc <unlink>
    3dc4:	38055563          	bgez	a0,414e <subdir+0x402>
  if(mkdir("/dd/dd") != 0){
    3dc8:	00004517          	auipc	a0,0x4
    3dcc:	22050513          	addi	a0,a0,544 # 7fe8 <malloc+0x14fe>
    3dd0:	00003097          	auipc	ra,0x3
    3dd4:	924080e7          	jalr	-1756(ra) # 66f4 <mkdir>
    3dd8:	38051d63          	bnez	a0,4172 <subdir+0x426>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3ddc:	20200593          	li	a1,514
    3de0:	00004517          	auipc	a0,0x4
    3de4:	23050513          	addi	a0,a0,560 # 8010 <malloc+0x1526>
    3de8:	00003097          	auipc	ra,0x3
    3dec:	8e4080e7          	jalr	-1820(ra) # 66cc <open>
    3df0:	84aa                	mv	s1,a0
  if(fd < 0){
    3df2:	3a054263          	bltz	a0,4196 <subdir+0x44a>
  write(fd, "FF", 2);
    3df6:	4609                	li	a2,2
    3df8:	00004597          	auipc	a1,0x4
    3dfc:	24858593          	addi	a1,a1,584 # 8040 <malloc+0x1556>
    3e00:	00003097          	auipc	ra,0x3
    3e04:	8ac080e7          	jalr	-1876(ra) # 66ac <write>
  close(fd);
    3e08:	8526                	mv	a0,s1
    3e0a:	00003097          	auipc	ra,0x3
    3e0e:	8aa080e7          	jalr	-1878(ra) # 66b4 <close>
  fd = open("dd/dd/../ff", 0);
    3e12:	4581                	li	a1,0
    3e14:	00004517          	auipc	a0,0x4
    3e18:	23450513          	addi	a0,a0,564 # 8048 <malloc+0x155e>
    3e1c:	00003097          	auipc	ra,0x3
    3e20:	8b0080e7          	jalr	-1872(ra) # 66cc <open>
    3e24:	84aa                	mv	s1,a0
  if(fd < 0){
    3e26:	38054a63          	bltz	a0,41ba <subdir+0x46e>
  cc = read(fd, buf, sizeof(buf));
    3e2a:	660d                	lui	a2,0x3
    3e2c:	0000a597          	auipc	a1,0xa
    3e30:	e4c58593          	addi	a1,a1,-436 # dc78 <buf>
    3e34:	00003097          	auipc	ra,0x3
    3e38:	870080e7          	jalr	-1936(ra) # 66a4 <read>
  if(cc != 2 || buf[0] != 'f'){
    3e3c:	4789                	li	a5,2
    3e3e:	3af51063          	bne	a0,a5,41de <subdir+0x492>
    3e42:	0000a717          	auipc	a4,0xa
    3e46:	e3674703          	lbu	a4,-458(a4) # dc78 <buf>
    3e4a:	06600793          	li	a5,102
    3e4e:	38f71863          	bne	a4,a5,41de <subdir+0x492>
  close(fd);
    3e52:	8526                	mv	a0,s1
    3e54:	00003097          	auipc	ra,0x3
    3e58:	860080e7          	jalr	-1952(ra) # 66b4 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3e5c:	00004597          	auipc	a1,0x4
    3e60:	23c58593          	addi	a1,a1,572 # 8098 <malloc+0x15ae>
    3e64:	00004517          	auipc	a0,0x4
    3e68:	1ac50513          	addi	a0,a0,428 # 8010 <malloc+0x1526>
    3e6c:	00003097          	auipc	ra,0x3
    3e70:	880080e7          	jalr	-1920(ra) # 66ec <link>
    3e74:	38051763          	bnez	a0,4202 <subdir+0x4b6>
  if(unlink("dd/dd/ff") != 0){
    3e78:	00004517          	auipc	a0,0x4
    3e7c:	19850513          	addi	a0,a0,408 # 8010 <malloc+0x1526>
    3e80:	00003097          	auipc	ra,0x3
    3e84:	85c080e7          	jalr	-1956(ra) # 66dc <unlink>
    3e88:	38051f63          	bnez	a0,4226 <subdir+0x4da>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3e8c:	4581                	li	a1,0
    3e8e:	00004517          	auipc	a0,0x4
    3e92:	18250513          	addi	a0,a0,386 # 8010 <malloc+0x1526>
    3e96:	00003097          	auipc	ra,0x3
    3e9a:	836080e7          	jalr	-1994(ra) # 66cc <open>
    3e9e:	3a055663          	bgez	a0,424a <subdir+0x4fe>
  if(chdir("dd") != 0){
    3ea2:	00004517          	auipc	a0,0x4
    3ea6:	0ce50513          	addi	a0,a0,206 # 7f70 <malloc+0x1486>
    3eaa:	00003097          	auipc	ra,0x3
    3eae:	852080e7          	jalr	-1966(ra) # 66fc <chdir>
    3eb2:	3a051e63          	bnez	a0,426e <subdir+0x522>
  if(chdir("dd/../../dd") != 0){
    3eb6:	00004517          	auipc	a0,0x4
    3eba:	27a50513          	addi	a0,a0,634 # 8130 <malloc+0x1646>
    3ebe:	00003097          	auipc	ra,0x3
    3ec2:	83e080e7          	jalr	-1986(ra) # 66fc <chdir>
    3ec6:	3c051663          	bnez	a0,4292 <subdir+0x546>
  if(chdir("dd/../../../dd") != 0){
    3eca:	00004517          	auipc	a0,0x4
    3ece:	29650513          	addi	a0,a0,662 # 8160 <malloc+0x1676>
    3ed2:	00003097          	auipc	ra,0x3
    3ed6:	82a080e7          	jalr	-2006(ra) # 66fc <chdir>
    3eda:	3c051e63          	bnez	a0,42b6 <subdir+0x56a>
  if(chdir("./..") != 0){
    3ede:	00004517          	auipc	a0,0x4
    3ee2:	2b250513          	addi	a0,a0,690 # 8190 <malloc+0x16a6>
    3ee6:	00003097          	auipc	ra,0x3
    3eea:	816080e7          	jalr	-2026(ra) # 66fc <chdir>
    3eee:	3e051663          	bnez	a0,42da <subdir+0x58e>
  fd = open("dd/dd/ffff", 0);
    3ef2:	4581                	li	a1,0
    3ef4:	00004517          	auipc	a0,0x4
    3ef8:	1a450513          	addi	a0,a0,420 # 8098 <malloc+0x15ae>
    3efc:	00002097          	auipc	ra,0x2
    3f00:	7d0080e7          	jalr	2000(ra) # 66cc <open>
    3f04:	84aa                	mv	s1,a0
  if(fd < 0){
    3f06:	3e054c63          	bltz	a0,42fe <subdir+0x5b2>
  if(read(fd, buf, sizeof(buf)) != 2){
    3f0a:	660d                	lui	a2,0x3
    3f0c:	0000a597          	auipc	a1,0xa
    3f10:	d6c58593          	addi	a1,a1,-660 # dc78 <buf>
    3f14:	00002097          	auipc	ra,0x2
    3f18:	790080e7          	jalr	1936(ra) # 66a4 <read>
    3f1c:	4789                	li	a5,2
    3f1e:	40f51263          	bne	a0,a5,4322 <subdir+0x5d6>
  close(fd);
    3f22:	8526                	mv	a0,s1
    3f24:	00002097          	auipc	ra,0x2
    3f28:	790080e7          	jalr	1936(ra) # 66b4 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3f2c:	4581                	li	a1,0
    3f2e:	00004517          	auipc	a0,0x4
    3f32:	0e250513          	addi	a0,a0,226 # 8010 <malloc+0x1526>
    3f36:	00002097          	auipc	ra,0x2
    3f3a:	796080e7          	jalr	1942(ra) # 66cc <open>
    3f3e:	40055463          	bgez	a0,4346 <subdir+0x5fa>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3f42:	20200593          	li	a1,514
    3f46:	00004517          	auipc	a0,0x4
    3f4a:	2da50513          	addi	a0,a0,730 # 8220 <malloc+0x1736>
    3f4e:	00002097          	auipc	ra,0x2
    3f52:	77e080e7          	jalr	1918(ra) # 66cc <open>
    3f56:	40055a63          	bgez	a0,436a <subdir+0x61e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3f5a:	20200593          	li	a1,514
    3f5e:	00004517          	auipc	a0,0x4
    3f62:	2f250513          	addi	a0,a0,754 # 8250 <malloc+0x1766>
    3f66:	00002097          	auipc	ra,0x2
    3f6a:	766080e7          	jalr	1894(ra) # 66cc <open>
    3f6e:	42055063          	bgez	a0,438e <subdir+0x642>
  if(open("dd", O_CREATE) >= 0){
    3f72:	20000593          	li	a1,512
    3f76:	00004517          	auipc	a0,0x4
    3f7a:	ffa50513          	addi	a0,a0,-6 # 7f70 <malloc+0x1486>
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	74e080e7          	jalr	1870(ra) # 66cc <open>
    3f86:	42055663          	bgez	a0,43b2 <subdir+0x666>
  if(open("dd", O_RDWR) >= 0){
    3f8a:	4589                	li	a1,2
    3f8c:	00004517          	auipc	a0,0x4
    3f90:	fe450513          	addi	a0,a0,-28 # 7f70 <malloc+0x1486>
    3f94:	00002097          	auipc	ra,0x2
    3f98:	738080e7          	jalr	1848(ra) # 66cc <open>
    3f9c:	42055d63          	bgez	a0,43d6 <subdir+0x68a>
  if(open("dd", O_WRONLY) >= 0){
    3fa0:	4585                	li	a1,1
    3fa2:	00004517          	auipc	a0,0x4
    3fa6:	fce50513          	addi	a0,a0,-50 # 7f70 <malloc+0x1486>
    3faa:	00002097          	auipc	ra,0x2
    3fae:	722080e7          	jalr	1826(ra) # 66cc <open>
    3fb2:	44055463          	bgez	a0,43fa <subdir+0x6ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3fb6:	00004597          	auipc	a1,0x4
    3fba:	32a58593          	addi	a1,a1,810 # 82e0 <malloc+0x17f6>
    3fbe:	00004517          	auipc	a0,0x4
    3fc2:	26250513          	addi	a0,a0,610 # 8220 <malloc+0x1736>
    3fc6:	00002097          	auipc	ra,0x2
    3fca:	726080e7          	jalr	1830(ra) # 66ec <link>
    3fce:	44050863          	beqz	a0,441e <subdir+0x6d2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3fd2:	00004597          	auipc	a1,0x4
    3fd6:	30e58593          	addi	a1,a1,782 # 82e0 <malloc+0x17f6>
    3fda:	00004517          	auipc	a0,0x4
    3fde:	27650513          	addi	a0,a0,630 # 8250 <malloc+0x1766>
    3fe2:	00002097          	auipc	ra,0x2
    3fe6:	70a080e7          	jalr	1802(ra) # 66ec <link>
    3fea:	44050c63          	beqz	a0,4442 <subdir+0x6f6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3fee:	00004597          	auipc	a1,0x4
    3ff2:	0aa58593          	addi	a1,a1,170 # 8098 <malloc+0x15ae>
    3ff6:	00004517          	auipc	a0,0x4
    3ffa:	f9a50513          	addi	a0,a0,-102 # 7f90 <malloc+0x14a6>
    3ffe:	00002097          	auipc	ra,0x2
    4002:	6ee080e7          	jalr	1774(ra) # 66ec <link>
    4006:	46050063          	beqz	a0,4466 <subdir+0x71a>
  if(mkdir("dd/ff/ff") == 0){
    400a:	00004517          	auipc	a0,0x4
    400e:	21650513          	addi	a0,a0,534 # 8220 <malloc+0x1736>
    4012:	00002097          	auipc	ra,0x2
    4016:	6e2080e7          	jalr	1762(ra) # 66f4 <mkdir>
    401a:	46050863          	beqz	a0,448a <subdir+0x73e>
  if(mkdir("dd/xx/ff") == 0){
    401e:	00004517          	auipc	a0,0x4
    4022:	23250513          	addi	a0,a0,562 # 8250 <malloc+0x1766>
    4026:	00002097          	auipc	ra,0x2
    402a:	6ce080e7          	jalr	1742(ra) # 66f4 <mkdir>
    402e:	48050063          	beqz	a0,44ae <subdir+0x762>
  if(mkdir("dd/dd/ffff") == 0){
    4032:	00004517          	auipc	a0,0x4
    4036:	06650513          	addi	a0,a0,102 # 8098 <malloc+0x15ae>
    403a:	00002097          	auipc	ra,0x2
    403e:	6ba080e7          	jalr	1722(ra) # 66f4 <mkdir>
    4042:	48050863          	beqz	a0,44d2 <subdir+0x786>
  if(unlink("dd/xx/ff") == 0){
    4046:	00004517          	auipc	a0,0x4
    404a:	20a50513          	addi	a0,a0,522 # 8250 <malloc+0x1766>
    404e:	00002097          	auipc	ra,0x2
    4052:	68e080e7          	jalr	1678(ra) # 66dc <unlink>
    4056:	4a050063          	beqz	a0,44f6 <subdir+0x7aa>
  if(unlink("dd/ff/ff") == 0){
    405a:	00004517          	auipc	a0,0x4
    405e:	1c650513          	addi	a0,a0,454 # 8220 <malloc+0x1736>
    4062:	00002097          	auipc	ra,0x2
    4066:	67a080e7          	jalr	1658(ra) # 66dc <unlink>
    406a:	4a050863          	beqz	a0,451a <subdir+0x7ce>
  if(chdir("dd/ff") == 0){
    406e:	00004517          	auipc	a0,0x4
    4072:	f2250513          	addi	a0,a0,-222 # 7f90 <malloc+0x14a6>
    4076:	00002097          	auipc	ra,0x2
    407a:	686080e7          	jalr	1670(ra) # 66fc <chdir>
    407e:	4c050063          	beqz	a0,453e <subdir+0x7f2>
  if(chdir("dd/xx") == 0){
    4082:	00004517          	auipc	a0,0x4
    4086:	3ae50513          	addi	a0,a0,942 # 8430 <malloc+0x1946>
    408a:	00002097          	auipc	ra,0x2
    408e:	672080e7          	jalr	1650(ra) # 66fc <chdir>
    4092:	4c050863          	beqz	a0,4562 <subdir+0x816>
  if(unlink("dd/dd/ffff") != 0){
    4096:	00004517          	auipc	a0,0x4
    409a:	00250513          	addi	a0,a0,2 # 8098 <malloc+0x15ae>
    409e:	00002097          	auipc	ra,0x2
    40a2:	63e080e7          	jalr	1598(ra) # 66dc <unlink>
    40a6:	4e051063          	bnez	a0,4586 <subdir+0x83a>
  if(unlink("dd/ff") != 0){
    40aa:	00004517          	auipc	a0,0x4
    40ae:	ee650513          	addi	a0,a0,-282 # 7f90 <malloc+0x14a6>
    40b2:	00002097          	auipc	ra,0x2
    40b6:	62a080e7          	jalr	1578(ra) # 66dc <unlink>
    40ba:	4e051863          	bnez	a0,45aa <subdir+0x85e>
  if(unlink("dd") == 0){
    40be:	00004517          	auipc	a0,0x4
    40c2:	eb250513          	addi	a0,a0,-334 # 7f70 <malloc+0x1486>
    40c6:	00002097          	auipc	ra,0x2
    40ca:	616080e7          	jalr	1558(ra) # 66dc <unlink>
    40ce:	50050063          	beqz	a0,45ce <subdir+0x882>
  if(unlink("dd/dd") < 0){
    40d2:	00004517          	auipc	a0,0x4
    40d6:	3ce50513          	addi	a0,a0,974 # 84a0 <malloc+0x19b6>
    40da:	00002097          	auipc	ra,0x2
    40de:	602080e7          	jalr	1538(ra) # 66dc <unlink>
    40e2:	50054863          	bltz	a0,45f2 <subdir+0x8a6>
  if(unlink("dd") < 0){
    40e6:	00004517          	auipc	a0,0x4
    40ea:	e8a50513          	addi	a0,a0,-374 # 7f70 <malloc+0x1486>
    40ee:	00002097          	auipc	ra,0x2
    40f2:	5ee080e7          	jalr	1518(ra) # 66dc <unlink>
    40f6:	52054063          	bltz	a0,4616 <subdir+0x8ca>
}
    40fa:	60e2                	ld	ra,24(sp)
    40fc:	6442                	ld	s0,16(sp)
    40fe:	64a2                	ld	s1,8(sp)
    4100:	6902                	ld	s2,0(sp)
    4102:	6105                	addi	sp,sp,32
    4104:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    4106:	85ca                	mv	a1,s2
    4108:	00004517          	auipc	a0,0x4
    410c:	e7050513          	addi	a0,a0,-400 # 7f78 <malloc+0x148e>
    4110:	00003097          	auipc	ra,0x3
    4114:	91c080e7          	jalr	-1764(ra) # 6a2c <printf>
    exit(1,"");
    4118:	00004597          	auipc	a1,0x4
    411c:	10058593          	addi	a1,a1,256 # 8218 <malloc+0x172e>
    4120:	4505                	li	a0,1
    4122:	00002097          	auipc	ra,0x2
    4126:	56a080e7          	jalr	1386(ra) # 668c <exit>
    printf("%s: create dd/ff failed\n", s);
    412a:	85ca                	mv	a1,s2
    412c:	00004517          	auipc	a0,0x4
    4130:	e6c50513          	addi	a0,a0,-404 # 7f98 <malloc+0x14ae>
    4134:	00003097          	auipc	ra,0x3
    4138:	8f8080e7          	jalr	-1800(ra) # 6a2c <printf>
    exit(1,"");
    413c:	00004597          	auipc	a1,0x4
    4140:	0dc58593          	addi	a1,a1,220 # 8218 <malloc+0x172e>
    4144:	4505                	li	a0,1
    4146:	00002097          	auipc	ra,0x2
    414a:	546080e7          	jalr	1350(ra) # 668c <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    414e:	85ca                	mv	a1,s2
    4150:	00004517          	auipc	a0,0x4
    4154:	e6850513          	addi	a0,a0,-408 # 7fb8 <malloc+0x14ce>
    4158:	00003097          	auipc	ra,0x3
    415c:	8d4080e7          	jalr	-1836(ra) # 6a2c <printf>
    exit(1,"");
    4160:	00004597          	auipc	a1,0x4
    4164:	0b858593          	addi	a1,a1,184 # 8218 <malloc+0x172e>
    4168:	4505                	li	a0,1
    416a:	00002097          	auipc	ra,0x2
    416e:	522080e7          	jalr	1314(ra) # 668c <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    4172:	85ca                	mv	a1,s2
    4174:	00004517          	auipc	a0,0x4
    4178:	e7c50513          	addi	a0,a0,-388 # 7ff0 <malloc+0x1506>
    417c:	00003097          	auipc	ra,0x3
    4180:	8b0080e7          	jalr	-1872(ra) # 6a2c <printf>
    exit(1,"");
    4184:	00004597          	auipc	a1,0x4
    4188:	09458593          	addi	a1,a1,148 # 8218 <malloc+0x172e>
    418c:	4505                	li	a0,1
    418e:	00002097          	auipc	ra,0x2
    4192:	4fe080e7          	jalr	1278(ra) # 668c <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    4196:	85ca                	mv	a1,s2
    4198:	00004517          	auipc	a0,0x4
    419c:	e8850513          	addi	a0,a0,-376 # 8020 <malloc+0x1536>
    41a0:	00003097          	auipc	ra,0x3
    41a4:	88c080e7          	jalr	-1908(ra) # 6a2c <printf>
    exit(1,"");
    41a8:	00004597          	auipc	a1,0x4
    41ac:	07058593          	addi	a1,a1,112 # 8218 <malloc+0x172e>
    41b0:	4505                	li	a0,1
    41b2:	00002097          	auipc	ra,0x2
    41b6:	4da080e7          	jalr	1242(ra) # 668c <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    41ba:	85ca                	mv	a1,s2
    41bc:	00004517          	auipc	a0,0x4
    41c0:	e9c50513          	addi	a0,a0,-356 # 8058 <malloc+0x156e>
    41c4:	00003097          	auipc	ra,0x3
    41c8:	868080e7          	jalr	-1944(ra) # 6a2c <printf>
    exit(1,"");
    41cc:	00004597          	auipc	a1,0x4
    41d0:	04c58593          	addi	a1,a1,76 # 8218 <malloc+0x172e>
    41d4:	4505                	li	a0,1
    41d6:	00002097          	auipc	ra,0x2
    41da:	4b6080e7          	jalr	1206(ra) # 668c <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    41de:	85ca                	mv	a1,s2
    41e0:	00004517          	auipc	a0,0x4
    41e4:	e9850513          	addi	a0,a0,-360 # 8078 <malloc+0x158e>
    41e8:	00003097          	auipc	ra,0x3
    41ec:	844080e7          	jalr	-1980(ra) # 6a2c <printf>
    exit(1,"");
    41f0:	00004597          	auipc	a1,0x4
    41f4:	02858593          	addi	a1,a1,40 # 8218 <malloc+0x172e>
    41f8:	4505                	li	a0,1
    41fa:	00002097          	auipc	ra,0x2
    41fe:	492080e7          	jalr	1170(ra) # 668c <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    4202:	85ca                	mv	a1,s2
    4204:	00004517          	auipc	a0,0x4
    4208:	ea450513          	addi	a0,a0,-348 # 80a8 <malloc+0x15be>
    420c:	00003097          	auipc	ra,0x3
    4210:	820080e7          	jalr	-2016(ra) # 6a2c <printf>
    exit(1,"");
    4214:	00004597          	auipc	a1,0x4
    4218:	00458593          	addi	a1,a1,4 # 8218 <malloc+0x172e>
    421c:	4505                	li	a0,1
    421e:	00002097          	auipc	ra,0x2
    4222:	46e080e7          	jalr	1134(ra) # 668c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    4226:	85ca                	mv	a1,s2
    4228:	00004517          	auipc	a0,0x4
    422c:	ea850513          	addi	a0,a0,-344 # 80d0 <malloc+0x15e6>
    4230:	00002097          	auipc	ra,0x2
    4234:	7fc080e7          	jalr	2044(ra) # 6a2c <printf>
    exit(1,"");
    4238:	00004597          	auipc	a1,0x4
    423c:	fe058593          	addi	a1,a1,-32 # 8218 <malloc+0x172e>
    4240:	4505                	li	a0,1
    4242:	00002097          	auipc	ra,0x2
    4246:	44a080e7          	jalr	1098(ra) # 668c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    424a:	85ca                	mv	a1,s2
    424c:	00004517          	auipc	a0,0x4
    4250:	ea450513          	addi	a0,a0,-348 # 80f0 <malloc+0x1606>
    4254:	00002097          	auipc	ra,0x2
    4258:	7d8080e7          	jalr	2008(ra) # 6a2c <printf>
    exit(1,"");
    425c:	00004597          	auipc	a1,0x4
    4260:	fbc58593          	addi	a1,a1,-68 # 8218 <malloc+0x172e>
    4264:	4505                	li	a0,1
    4266:	00002097          	auipc	ra,0x2
    426a:	426080e7          	jalr	1062(ra) # 668c <exit>
    printf("%s: chdir dd failed\n", s);
    426e:	85ca                	mv	a1,s2
    4270:	00004517          	auipc	a0,0x4
    4274:	ea850513          	addi	a0,a0,-344 # 8118 <malloc+0x162e>
    4278:	00002097          	auipc	ra,0x2
    427c:	7b4080e7          	jalr	1972(ra) # 6a2c <printf>
    exit(1,"");
    4280:	00004597          	auipc	a1,0x4
    4284:	f9858593          	addi	a1,a1,-104 # 8218 <malloc+0x172e>
    4288:	4505                	li	a0,1
    428a:	00002097          	auipc	ra,0x2
    428e:	402080e7          	jalr	1026(ra) # 668c <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    4292:	85ca                	mv	a1,s2
    4294:	00004517          	auipc	a0,0x4
    4298:	eac50513          	addi	a0,a0,-340 # 8140 <malloc+0x1656>
    429c:	00002097          	auipc	ra,0x2
    42a0:	790080e7          	jalr	1936(ra) # 6a2c <printf>
    exit(1,"");
    42a4:	00004597          	auipc	a1,0x4
    42a8:	f7458593          	addi	a1,a1,-140 # 8218 <malloc+0x172e>
    42ac:	4505                	li	a0,1
    42ae:	00002097          	auipc	ra,0x2
    42b2:	3de080e7          	jalr	990(ra) # 668c <exit>
    printf("chdir dd/../../dd failed\n", s);
    42b6:	85ca                	mv	a1,s2
    42b8:	00004517          	auipc	a0,0x4
    42bc:	eb850513          	addi	a0,a0,-328 # 8170 <malloc+0x1686>
    42c0:	00002097          	auipc	ra,0x2
    42c4:	76c080e7          	jalr	1900(ra) # 6a2c <printf>
    exit(1,"");
    42c8:	00004597          	auipc	a1,0x4
    42cc:	f5058593          	addi	a1,a1,-176 # 8218 <malloc+0x172e>
    42d0:	4505                	li	a0,1
    42d2:	00002097          	auipc	ra,0x2
    42d6:	3ba080e7          	jalr	954(ra) # 668c <exit>
    printf("%s: chdir ./.. failed\n", s);
    42da:	85ca                	mv	a1,s2
    42dc:	00004517          	auipc	a0,0x4
    42e0:	ebc50513          	addi	a0,a0,-324 # 8198 <malloc+0x16ae>
    42e4:	00002097          	auipc	ra,0x2
    42e8:	748080e7          	jalr	1864(ra) # 6a2c <printf>
    exit(1,"");
    42ec:	00004597          	auipc	a1,0x4
    42f0:	f2c58593          	addi	a1,a1,-212 # 8218 <malloc+0x172e>
    42f4:	4505                	li	a0,1
    42f6:	00002097          	auipc	ra,0x2
    42fa:	396080e7          	jalr	918(ra) # 668c <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    42fe:	85ca                	mv	a1,s2
    4300:	00004517          	auipc	a0,0x4
    4304:	eb050513          	addi	a0,a0,-336 # 81b0 <malloc+0x16c6>
    4308:	00002097          	auipc	ra,0x2
    430c:	724080e7          	jalr	1828(ra) # 6a2c <printf>
    exit(1,"");
    4310:	00004597          	auipc	a1,0x4
    4314:	f0858593          	addi	a1,a1,-248 # 8218 <malloc+0x172e>
    4318:	4505                	li	a0,1
    431a:	00002097          	auipc	ra,0x2
    431e:	372080e7          	jalr	882(ra) # 668c <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    4322:	85ca                	mv	a1,s2
    4324:	00004517          	auipc	a0,0x4
    4328:	eac50513          	addi	a0,a0,-340 # 81d0 <malloc+0x16e6>
    432c:	00002097          	auipc	ra,0x2
    4330:	700080e7          	jalr	1792(ra) # 6a2c <printf>
    exit(1,"");
    4334:	00004597          	auipc	a1,0x4
    4338:	ee458593          	addi	a1,a1,-284 # 8218 <malloc+0x172e>
    433c:	4505                	li	a0,1
    433e:	00002097          	auipc	ra,0x2
    4342:	34e080e7          	jalr	846(ra) # 668c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    4346:	85ca                	mv	a1,s2
    4348:	00004517          	auipc	a0,0x4
    434c:	ea850513          	addi	a0,a0,-344 # 81f0 <malloc+0x1706>
    4350:	00002097          	auipc	ra,0x2
    4354:	6dc080e7          	jalr	1756(ra) # 6a2c <printf>
    exit(1,"");
    4358:	00004597          	auipc	a1,0x4
    435c:	ec058593          	addi	a1,a1,-320 # 8218 <malloc+0x172e>
    4360:	4505                	li	a0,1
    4362:	00002097          	auipc	ra,0x2
    4366:	32a080e7          	jalr	810(ra) # 668c <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    436a:	85ca                	mv	a1,s2
    436c:	00004517          	auipc	a0,0x4
    4370:	ec450513          	addi	a0,a0,-316 # 8230 <malloc+0x1746>
    4374:	00002097          	auipc	ra,0x2
    4378:	6b8080e7          	jalr	1720(ra) # 6a2c <printf>
    exit(1,"");
    437c:	00004597          	auipc	a1,0x4
    4380:	e9c58593          	addi	a1,a1,-356 # 8218 <malloc+0x172e>
    4384:	4505                	li	a0,1
    4386:	00002097          	auipc	ra,0x2
    438a:	306080e7          	jalr	774(ra) # 668c <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    438e:	85ca                	mv	a1,s2
    4390:	00004517          	auipc	a0,0x4
    4394:	ed050513          	addi	a0,a0,-304 # 8260 <malloc+0x1776>
    4398:	00002097          	auipc	ra,0x2
    439c:	694080e7          	jalr	1684(ra) # 6a2c <printf>
    exit(1,"");
    43a0:	00004597          	auipc	a1,0x4
    43a4:	e7858593          	addi	a1,a1,-392 # 8218 <malloc+0x172e>
    43a8:	4505                	li	a0,1
    43aa:	00002097          	auipc	ra,0x2
    43ae:	2e2080e7          	jalr	738(ra) # 668c <exit>
    printf("%s: create dd succeeded!\n", s);
    43b2:	85ca                	mv	a1,s2
    43b4:	00004517          	auipc	a0,0x4
    43b8:	ecc50513          	addi	a0,a0,-308 # 8280 <malloc+0x1796>
    43bc:	00002097          	auipc	ra,0x2
    43c0:	670080e7          	jalr	1648(ra) # 6a2c <printf>
    exit(1,"");
    43c4:	00004597          	auipc	a1,0x4
    43c8:	e5458593          	addi	a1,a1,-428 # 8218 <malloc+0x172e>
    43cc:	4505                	li	a0,1
    43ce:	00002097          	auipc	ra,0x2
    43d2:	2be080e7          	jalr	702(ra) # 668c <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    43d6:	85ca                	mv	a1,s2
    43d8:	00004517          	auipc	a0,0x4
    43dc:	ec850513          	addi	a0,a0,-312 # 82a0 <malloc+0x17b6>
    43e0:	00002097          	auipc	ra,0x2
    43e4:	64c080e7          	jalr	1612(ra) # 6a2c <printf>
    exit(1,"");
    43e8:	00004597          	auipc	a1,0x4
    43ec:	e3058593          	addi	a1,a1,-464 # 8218 <malloc+0x172e>
    43f0:	4505                	li	a0,1
    43f2:	00002097          	auipc	ra,0x2
    43f6:	29a080e7          	jalr	666(ra) # 668c <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    43fa:	85ca                	mv	a1,s2
    43fc:	00004517          	auipc	a0,0x4
    4400:	ec450513          	addi	a0,a0,-316 # 82c0 <malloc+0x17d6>
    4404:	00002097          	auipc	ra,0x2
    4408:	628080e7          	jalr	1576(ra) # 6a2c <printf>
    exit(1,"");
    440c:	00004597          	auipc	a1,0x4
    4410:	e0c58593          	addi	a1,a1,-500 # 8218 <malloc+0x172e>
    4414:	4505                	li	a0,1
    4416:	00002097          	auipc	ra,0x2
    441a:	276080e7          	jalr	630(ra) # 668c <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    441e:	85ca                	mv	a1,s2
    4420:	00004517          	auipc	a0,0x4
    4424:	ed050513          	addi	a0,a0,-304 # 82f0 <malloc+0x1806>
    4428:	00002097          	auipc	ra,0x2
    442c:	604080e7          	jalr	1540(ra) # 6a2c <printf>
    exit(1,"");
    4430:	00004597          	auipc	a1,0x4
    4434:	de858593          	addi	a1,a1,-536 # 8218 <malloc+0x172e>
    4438:	4505                	li	a0,1
    443a:	00002097          	auipc	ra,0x2
    443e:	252080e7          	jalr	594(ra) # 668c <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    4442:	85ca                	mv	a1,s2
    4444:	00004517          	auipc	a0,0x4
    4448:	ed450513          	addi	a0,a0,-300 # 8318 <malloc+0x182e>
    444c:	00002097          	auipc	ra,0x2
    4450:	5e0080e7          	jalr	1504(ra) # 6a2c <printf>
    exit(1,"");
    4454:	00004597          	auipc	a1,0x4
    4458:	dc458593          	addi	a1,a1,-572 # 8218 <malloc+0x172e>
    445c:	4505                	li	a0,1
    445e:	00002097          	auipc	ra,0x2
    4462:	22e080e7          	jalr	558(ra) # 668c <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    4466:	85ca                	mv	a1,s2
    4468:	00004517          	auipc	a0,0x4
    446c:	ed850513          	addi	a0,a0,-296 # 8340 <malloc+0x1856>
    4470:	00002097          	auipc	ra,0x2
    4474:	5bc080e7          	jalr	1468(ra) # 6a2c <printf>
    exit(1,"");
    4478:	00004597          	auipc	a1,0x4
    447c:	da058593          	addi	a1,a1,-608 # 8218 <malloc+0x172e>
    4480:	4505                	li	a0,1
    4482:	00002097          	auipc	ra,0x2
    4486:	20a080e7          	jalr	522(ra) # 668c <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    448a:	85ca                	mv	a1,s2
    448c:	00004517          	auipc	a0,0x4
    4490:	edc50513          	addi	a0,a0,-292 # 8368 <malloc+0x187e>
    4494:	00002097          	auipc	ra,0x2
    4498:	598080e7          	jalr	1432(ra) # 6a2c <printf>
    exit(1,"");
    449c:	00004597          	auipc	a1,0x4
    44a0:	d7c58593          	addi	a1,a1,-644 # 8218 <malloc+0x172e>
    44a4:	4505                	li	a0,1
    44a6:	00002097          	auipc	ra,0x2
    44aa:	1e6080e7          	jalr	486(ra) # 668c <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    44ae:	85ca                	mv	a1,s2
    44b0:	00004517          	auipc	a0,0x4
    44b4:	ed850513          	addi	a0,a0,-296 # 8388 <malloc+0x189e>
    44b8:	00002097          	auipc	ra,0x2
    44bc:	574080e7          	jalr	1396(ra) # 6a2c <printf>
    exit(1,"");
    44c0:	00004597          	auipc	a1,0x4
    44c4:	d5858593          	addi	a1,a1,-680 # 8218 <malloc+0x172e>
    44c8:	4505                	li	a0,1
    44ca:	00002097          	auipc	ra,0x2
    44ce:	1c2080e7          	jalr	450(ra) # 668c <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    44d2:	85ca                	mv	a1,s2
    44d4:	00004517          	auipc	a0,0x4
    44d8:	ed450513          	addi	a0,a0,-300 # 83a8 <malloc+0x18be>
    44dc:	00002097          	auipc	ra,0x2
    44e0:	550080e7          	jalr	1360(ra) # 6a2c <printf>
    exit(1,"");
    44e4:	00004597          	auipc	a1,0x4
    44e8:	d3458593          	addi	a1,a1,-716 # 8218 <malloc+0x172e>
    44ec:	4505                	li	a0,1
    44ee:	00002097          	auipc	ra,0x2
    44f2:	19e080e7          	jalr	414(ra) # 668c <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    44f6:	85ca                	mv	a1,s2
    44f8:	00004517          	auipc	a0,0x4
    44fc:	ed850513          	addi	a0,a0,-296 # 83d0 <malloc+0x18e6>
    4500:	00002097          	auipc	ra,0x2
    4504:	52c080e7          	jalr	1324(ra) # 6a2c <printf>
    exit(1,"");
    4508:	00004597          	auipc	a1,0x4
    450c:	d1058593          	addi	a1,a1,-752 # 8218 <malloc+0x172e>
    4510:	4505                	li	a0,1
    4512:	00002097          	auipc	ra,0x2
    4516:	17a080e7          	jalr	378(ra) # 668c <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    451a:	85ca                	mv	a1,s2
    451c:	00004517          	auipc	a0,0x4
    4520:	ed450513          	addi	a0,a0,-300 # 83f0 <malloc+0x1906>
    4524:	00002097          	auipc	ra,0x2
    4528:	508080e7          	jalr	1288(ra) # 6a2c <printf>
    exit(1,"");
    452c:	00004597          	auipc	a1,0x4
    4530:	cec58593          	addi	a1,a1,-788 # 8218 <malloc+0x172e>
    4534:	4505                	li	a0,1
    4536:	00002097          	auipc	ra,0x2
    453a:	156080e7          	jalr	342(ra) # 668c <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    453e:	85ca                	mv	a1,s2
    4540:	00004517          	auipc	a0,0x4
    4544:	ed050513          	addi	a0,a0,-304 # 8410 <malloc+0x1926>
    4548:	00002097          	auipc	ra,0x2
    454c:	4e4080e7          	jalr	1252(ra) # 6a2c <printf>
    exit(1,"");
    4550:	00004597          	auipc	a1,0x4
    4554:	cc858593          	addi	a1,a1,-824 # 8218 <malloc+0x172e>
    4558:	4505                	li	a0,1
    455a:	00002097          	auipc	ra,0x2
    455e:	132080e7          	jalr	306(ra) # 668c <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    4562:	85ca                	mv	a1,s2
    4564:	00004517          	auipc	a0,0x4
    4568:	ed450513          	addi	a0,a0,-300 # 8438 <malloc+0x194e>
    456c:	00002097          	auipc	ra,0x2
    4570:	4c0080e7          	jalr	1216(ra) # 6a2c <printf>
    exit(1,"");
    4574:	00004597          	auipc	a1,0x4
    4578:	ca458593          	addi	a1,a1,-860 # 8218 <malloc+0x172e>
    457c:	4505                	li	a0,1
    457e:	00002097          	auipc	ra,0x2
    4582:	10e080e7          	jalr	270(ra) # 668c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    4586:	85ca                	mv	a1,s2
    4588:	00004517          	auipc	a0,0x4
    458c:	b4850513          	addi	a0,a0,-1208 # 80d0 <malloc+0x15e6>
    4590:	00002097          	auipc	ra,0x2
    4594:	49c080e7          	jalr	1180(ra) # 6a2c <printf>
    exit(1,"");
    4598:	00004597          	auipc	a1,0x4
    459c:	c8058593          	addi	a1,a1,-896 # 8218 <malloc+0x172e>
    45a0:	4505                	li	a0,1
    45a2:	00002097          	auipc	ra,0x2
    45a6:	0ea080e7          	jalr	234(ra) # 668c <exit>
    printf("%s: unlink dd/ff failed\n", s);
    45aa:	85ca                	mv	a1,s2
    45ac:	00004517          	auipc	a0,0x4
    45b0:	eac50513          	addi	a0,a0,-340 # 8458 <malloc+0x196e>
    45b4:	00002097          	auipc	ra,0x2
    45b8:	478080e7          	jalr	1144(ra) # 6a2c <printf>
    exit(1,"");
    45bc:	00004597          	auipc	a1,0x4
    45c0:	c5c58593          	addi	a1,a1,-932 # 8218 <malloc+0x172e>
    45c4:	4505                	li	a0,1
    45c6:	00002097          	auipc	ra,0x2
    45ca:	0c6080e7          	jalr	198(ra) # 668c <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    45ce:	85ca                	mv	a1,s2
    45d0:	00004517          	auipc	a0,0x4
    45d4:	ea850513          	addi	a0,a0,-344 # 8478 <malloc+0x198e>
    45d8:	00002097          	auipc	ra,0x2
    45dc:	454080e7          	jalr	1108(ra) # 6a2c <printf>
    exit(1,"");
    45e0:	00004597          	auipc	a1,0x4
    45e4:	c3858593          	addi	a1,a1,-968 # 8218 <malloc+0x172e>
    45e8:	4505                	li	a0,1
    45ea:	00002097          	auipc	ra,0x2
    45ee:	0a2080e7          	jalr	162(ra) # 668c <exit>
    printf("%s: unlink dd/dd failed\n", s);
    45f2:	85ca                	mv	a1,s2
    45f4:	00004517          	auipc	a0,0x4
    45f8:	eb450513          	addi	a0,a0,-332 # 84a8 <malloc+0x19be>
    45fc:	00002097          	auipc	ra,0x2
    4600:	430080e7          	jalr	1072(ra) # 6a2c <printf>
    exit(1,"");
    4604:	00004597          	auipc	a1,0x4
    4608:	c1458593          	addi	a1,a1,-1004 # 8218 <malloc+0x172e>
    460c:	4505                	li	a0,1
    460e:	00002097          	auipc	ra,0x2
    4612:	07e080e7          	jalr	126(ra) # 668c <exit>
    printf("%s: unlink dd failed\n", s);
    4616:	85ca                	mv	a1,s2
    4618:	00004517          	auipc	a0,0x4
    461c:	eb050513          	addi	a0,a0,-336 # 84c8 <malloc+0x19de>
    4620:	00002097          	auipc	ra,0x2
    4624:	40c080e7          	jalr	1036(ra) # 6a2c <printf>
    exit(1,"");
    4628:	00004597          	auipc	a1,0x4
    462c:	bf058593          	addi	a1,a1,-1040 # 8218 <malloc+0x172e>
    4630:	4505                	li	a0,1
    4632:	00002097          	auipc	ra,0x2
    4636:	05a080e7          	jalr	90(ra) # 668c <exit>

000000000000463a <rmdot>:
{
    463a:	1101                	addi	sp,sp,-32
    463c:	ec06                	sd	ra,24(sp)
    463e:	e822                	sd	s0,16(sp)
    4640:	e426                	sd	s1,8(sp)
    4642:	1000                	addi	s0,sp,32
    4644:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    4646:	00004517          	auipc	a0,0x4
    464a:	e9a50513          	addi	a0,a0,-358 # 84e0 <malloc+0x19f6>
    464e:	00002097          	auipc	ra,0x2
    4652:	0a6080e7          	jalr	166(ra) # 66f4 <mkdir>
    4656:	e551                	bnez	a0,46e2 <rmdot+0xa8>
  if(chdir("dots") != 0){
    4658:	00004517          	auipc	a0,0x4
    465c:	e8850513          	addi	a0,a0,-376 # 84e0 <malloc+0x19f6>
    4660:	00002097          	auipc	ra,0x2
    4664:	09c080e7          	jalr	156(ra) # 66fc <chdir>
    4668:	ed59                	bnez	a0,4706 <rmdot+0xcc>
  if(unlink(".") == 0){
    466a:	00003517          	auipc	a0,0x3
    466e:	ca650513          	addi	a0,a0,-858 # 7310 <malloc+0x826>
    4672:	00002097          	auipc	ra,0x2
    4676:	06a080e7          	jalr	106(ra) # 66dc <unlink>
    467a:	c945                	beqz	a0,472a <rmdot+0xf0>
  if(unlink("..") == 0){
    467c:	00004517          	auipc	a0,0x4
    4680:	8bc50513          	addi	a0,a0,-1860 # 7f38 <malloc+0x144e>
    4684:	00002097          	auipc	ra,0x2
    4688:	058080e7          	jalr	88(ra) # 66dc <unlink>
    468c:	c169                	beqz	a0,474e <rmdot+0x114>
  if(chdir("/") != 0){
    468e:	00004517          	auipc	a0,0x4
    4692:	85250513          	addi	a0,a0,-1966 # 7ee0 <malloc+0x13f6>
    4696:	00002097          	auipc	ra,0x2
    469a:	066080e7          	jalr	102(ra) # 66fc <chdir>
    469e:	e971                	bnez	a0,4772 <rmdot+0x138>
  if(unlink("dots/.") == 0){
    46a0:	00004517          	auipc	a0,0x4
    46a4:	ea850513          	addi	a0,a0,-344 # 8548 <malloc+0x1a5e>
    46a8:	00002097          	auipc	ra,0x2
    46ac:	034080e7          	jalr	52(ra) # 66dc <unlink>
    46b0:	c17d                	beqz	a0,4796 <rmdot+0x15c>
  if(unlink("dots/..") == 0){
    46b2:	00004517          	auipc	a0,0x4
    46b6:	ebe50513          	addi	a0,a0,-322 # 8570 <malloc+0x1a86>
    46ba:	00002097          	auipc	ra,0x2
    46be:	022080e7          	jalr	34(ra) # 66dc <unlink>
    46c2:	cd65                	beqz	a0,47ba <rmdot+0x180>
  if(unlink("dots") != 0){
    46c4:	00004517          	auipc	a0,0x4
    46c8:	e1c50513          	addi	a0,a0,-484 # 84e0 <malloc+0x19f6>
    46cc:	00002097          	auipc	ra,0x2
    46d0:	010080e7          	jalr	16(ra) # 66dc <unlink>
    46d4:	10051563          	bnez	a0,47de <rmdot+0x1a4>
}
    46d8:	60e2                	ld	ra,24(sp)
    46da:	6442                	ld	s0,16(sp)
    46dc:	64a2                	ld	s1,8(sp)
    46de:	6105                	addi	sp,sp,32
    46e0:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    46e2:	85a6                	mv	a1,s1
    46e4:	00004517          	auipc	a0,0x4
    46e8:	e0450513          	addi	a0,a0,-508 # 84e8 <malloc+0x19fe>
    46ec:	00002097          	auipc	ra,0x2
    46f0:	340080e7          	jalr	832(ra) # 6a2c <printf>
    exit(1,"");
    46f4:	00004597          	auipc	a1,0x4
    46f8:	b2458593          	addi	a1,a1,-1244 # 8218 <malloc+0x172e>
    46fc:	4505                	li	a0,1
    46fe:	00002097          	auipc	ra,0x2
    4702:	f8e080e7          	jalr	-114(ra) # 668c <exit>
    printf("%s: chdir dots failed\n", s);
    4706:	85a6                	mv	a1,s1
    4708:	00004517          	auipc	a0,0x4
    470c:	df850513          	addi	a0,a0,-520 # 8500 <malloc+0x1a16>
    4710:	00002097          	auipc	ra,0x2
    4714:	31c080e7          	jalr	796(ra) # 6a2c <printf>
    exit(1,"");
    4718:	00004597          	auipc	a1,0x4
    471c:	b0058593          	addi	a1,a1,-1280 # 8218 <malloc+0x172e>
    4720:	4505                	li	a0,1
    4722:	00002097          	auipc	ra,0x2
    4726:	f6a080e7          	jalr	-150(ra) # 668c <exit>
    printf("%s: rm . worked!\n", s);
    472a:	85a6                	mv	a1,s1
    472c:	00004517          	auipc	a0,0x4
    4730:	dec50513          	addi	a0,a0,-532 # 8518 <malloc+0x1a2e>
    4734:	00002097          	auipc	ra,0x2
    4738:	2f8080e7          	jalr	760(ra) # 6a2c <printf>
    exit(1,"");
    473c:	00004597          	auipc	a1,0x4
    4740:	adc58593          	addi	a1,a1,-1316 # 8218 <malloc+0x172e>
    4744:	4505                	li	a0,1
    4746:	00002097          	auipc	ra,0x2
    474a:	f46080e7          	jalr	-186(ra) # 668c <exit>
    printf("%s: rm .. worked!\n", s);
    474e:	85a6                	mv	a1,s1
    4750:	00004517          	auipc	a0,0x4
    4754:	de050513          	addi	a0,a0,-544 # 8530 <malloc+0x1a46>
    4758:	00002097          	auipc	ra,0x2
    475c:	2d4080e7          	jalr	724(ra) # 6a2c <printf>
    exit(1,"");
    4760:	00004597          	auipc	a1,0x4
    4764:	ab858593          	addi	a1,a1,-1352 # 8218 <malloc+0x172e>
    4768:	4505                	li	a0,1
    476a:	00002097          	auipc	ra,0x2
    476e:	f22080e7          	jalr	-222(ra) # 668c <exit>
    printf("%s: chdir / failed\n", s);
    4772:	85a6                	mv	a1,s1
    4774:	00003517          	auipc	a0,0x3
    4778:	77450513          	addi	a0,a0,1908 # 7ee8 <malloc+0x13fe>
    477c:	00002097          	auipc	ra,0x2
    4780:	2b0080e7          	jalr	688(ra) # 6a2c <printf>
    exit(1,"");
    4784:	00004597          	auipc	a1,0x4
    4788:	a9458593          	addi	a1,a1,-1388 # 8218 <malloc+0x172e>
    478c:	4505                	li	a0,1
    478e:	00002097          	auipc	ra,0x2
    4792:	efe080e7          	jalr	-258(ra) # 668c <exit>
    printf("%s: unlink dots/. worked!\n", s);
    4796:	85a6                	mv	a1,s1
    4798:	00004517          	auipc	a0,0x4
    479c:	db850513          	addi	a0,a0,-584 # 8550 <malloc+0x1a66>
    47a0:	00002097          	auipc	ra,0x2
    47a4:	28c080e7          	jalr	652(ra) # 6a2c <printf>
    exit(1,"");
    47a8:	00004597          	auipc	a1,0x4
    47ac:	a7058593          	addi	a1,a1,-1424 # 8218 <malloc+0x172e>
    47b0:	4505                	li	a0,1
    47b2:	00002097          	auipc	ra,0x2
    47b6:	eda080e7          	jalr	-294(ra) # 668c <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    47ba:	85a6                	mv	a1,s1
    47bc:	00004517          	auipc	a0,0x4
    47c0:	dbc50513          	addi	a0,a0,-580 # 8578 <malloc+0x1a8e>
    47c4:	00002097          	auipc	ra,0x2
    47c8:	268080e7          	jalr	616(ra) # 6a2c <printf>
    exit(1,"");
    47cc:	00004597          	auipc	a1,0x4
    47d0:	a4c58593          	addi	a1,a1,-1460 # 8218 <malloc+0x172e>
    47d4:	4505                	li	a0,1
    47d6:	00002097          	auipc	ra,0x2
    47da:	eb6080e7          	jalr	-330(ra) # 668c <exit>
    printf("%s: unlink dots failed!\n", s);
    47de:	85a6                	mv	a1,s1
    47e0:	00004517          	auipc	a0,0x4
    47e4:	db850513          	addi	a0,a0,-584 # 8598 <malloc+0x1aae>
    47e8:	00002097          	auipc	ra,0x2
    47ec:	244080e7          	jalr	580(ra) # 6a2c <printf>
    exit(1,"");
    47f0:	00004597          	auipc	a1,0x4
    47f4:	a2858593          	addi	a1,a1,-1496 # 8218 <malloc+0x172e>
    47f8:	4505                	li	a0,1
    47fa:	00002097          	auipc	ra,0x2
    47fe:	e92080e7          	jalr	-366(ra) # 668c <exit>

0000000000004802 <dirfile>:
{
    4802:	1101                	addi	sp,sp,-32
    4804:	ec06                	sd	ra,24(sp)
    4806:	e822                	sd	s0,16(sp)
    4808:	e426                	sd	s1,8(sp)
    480a:	e04a                	sd	s2,0(sp)
    480c:	1000                	addi	s0,sp,32
    480e:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4810:	20000593          	li	a1,512
    4814:	00004517          	auipc	a0,0x4
    4818:	da450513          	addi	a0,a0,-604 # 85b8 <malloc+0x1ace>
    481c:	00002097          	auipc	ra,0x2
    4820:	eb0080e7          	jalr	-336(ra) # 66cc <open>
  if(fd < 0){
    4824:	0e054e63          	bltz	a0,4920 <dirfile+0x11e>
  close(fd);
    4828:	00002097          	auipc	ra,0x2
    482c:	e8c080e7          	jalr	-372(ra) # 66b4 <close>
  if(chdir("dirfile") == 0){
    4830:	00004517          	auipc	a0,0x4
    4834:	d8850513          	addi	a0,a0,-632 # 85b8 <malloc+0x1ace>
    4838:	00002097          	auipc	ra,0x2
    483c:	ec4080e7          	jalr	-316(ra) # 66fc <chdir>
    4840:	10050263          	beqz	a0,4944 <dirfile+0x142>
  fd = open("dirfile/xx", 0);
    4844:	4581                	li	a1,0
    4846:	00004517          	auipc	a0,0x4
    484a:	dba50513          	addi	a0,a0,-582 # 8600 <malloc+0x1b16>
    484e:	00002097          	auipc	ra,0x2
    4852:	e7e080e7          	jalr	-386(ra) # 66cc <open>
  if(fd >= 0){
    4856:	10055963          	bgez	a0,4968 <dirfile+0x166>
  fd = open("dirfile/xx", O_CREATE);
    485a:	20000593          	li	a1,512
    485e:	00004517          	auipc	a0,0x4
    4862:	da250513          	addi	a0,a0,-606 # 8600 <malloc+0x1b16>
    4866:	00002097          	auipc	ra,0x2
    486a:	e66080e7          	jalr	-410(ra) # 66cc <open>
  if(fd >= 0){
    486e:	10055f63          	bgez	a0,498c <dirfile+0x18a>
  if(mkdir("dirfile/xx") == 0){
    4872:	00004517          	auipc	a0,0x4
    4876:	d8e50513          	addi	a0,a0,-626 # 8600 <malloc+0x1b16>
    487a:	00002097          	auipc	ra,0x2
    487e:	e7a080e7          	jalr	-390(ra) # 66f4 <mkdir>
    4882:	12050763          	beqz	a0,49b0 <dirfile+0x1ae>
  if(unlink("dirfile/xx") == 0){
    4886:	00004517          	auipc	a0,0x4
    488a:	d7a50513          	addi	a0,a0,-646 # 8600 <malloc+0x1b16>
    488e:	00002097          	auipc	ra,0x2
    4892:	e4e080e7          	jalr	-434(ra) # 66dc <unlink>
    4896:	12050f63          	beqz	a0,49d4 <dirfile+0x1d2>
  if(link("README", "dirfile/xx") == 0){
    489a:	00004597          	auipc	a1,0x4
    489e:	d6658593          	addi	a1,a1,-666 # 8600 <malloc+0x1b16>
    48a2:	00002517          	auipc	a0,0x2
    48a6:	55e50513          	addi	a0,a0,1374 # 6e00 <malloc+0x316>
    48aa:	00002097          	auipc	ra,0x2
    48ae:	e42080e7          	jalr	-446(ra) # 66ec <link>
    48b2:	14050363          	beqz	a0,49f8 <dirfile+0x1f6>
  if(unlink("dirfile") != 0){
    48b6:	00004517          	auipc	a0,0x4
    48ba:	d0250513          	addi	a0,a0,-766 # 85b8 <malloc+0x1ace>
    48be:	00002097          	auipc	ra,0x2
    48c2:	e1e080e7          	jalr	-482(ra) # 66dc <unlink>
    48c6:	14051b63          	bnez	a0,4a1c <dirfile+0x21a>
  fd = open(".", O_RDWR);
    48ca:	4589                	li	a1,2
    48cc:	00003517          	auipc	a0,0x3
    48d0:	a4450513          	addi	a0,a0,-1468 # 7310 <malloc+0x826>
    48d4:	00002097          	auipc	ra,0x2
    48d8:	df8080e7          	jalr	-520(ra) # 66cc <open>
  if(fd >= 0){
    48dc:	16055263          	bgez	a0,4a40 <dirfile+0x23e>
  fd = open(".", 0);
    48e0:	4581                	li	a1,0
    48e2:	00003517          	auipc	a0,0x3
    48e6:	a2e50513          	addi	a0,a0,-1490 # 7310 <malloc+0x826>
    48ea:	00002097          	auipc	ra,0x2
    48ee:	de2080e7          	jalr	-542(ra) # 66cc <open>
    48f2:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    48f4:	4605                	li	a2,1
    48f6:	00002597          	auipc	a1,0x2
    48fa:	3a258593          	addi	a1,a1,930 # 6c98 <malloc+0x1ae>
    48fe:	00002097          	auipc	ra,0x2
    4902:	dae080e7          	jalr	-594(ra) # 66ac <write>
    4906:	14a04f63          	bgtz	a0,4a64 <dirfile+0x262>
  close(fd);
    490a:	8526                	mv	a0,s1
    490c:	00002097          	auipc	ra,0x2
    4910:	da8080e7          	jalr	-600(ra) # 66b4 <close>
}
    4914:	60e2                	ld	ra,24(sp)
    4916:	6442                	ld	s0,16(sp)
    4918:	64a2                	ld	s1,8(sp)
    491a:	6902                	ld	s2,0(sp)
    491c:	6105                	addi	sp,sp,32
    491e:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4920:	85ca                	mv	a1,s2
    4922:	00004517          	auipc	a0,0x4
    4926:	c9e50513          	addi	a0,a0,-866 # 85c0 <malloc+0x1ad6>
    492a:	00002097          	auipc	ra,0x2
    492e:	102080e7          	jalr	258(ra) # 6a2c <printf>
    exit(1,"");
    4932:	00004597          	auipc	a1,0x4
    4936:	8e658593          	addi	a1,a1,-1818 # 8218 <malloc+0x172e>
    493a:	4505                	li	a0,1
    493c:	00002097          	auipc	ra,0x2
    4940:	d50080e7          	jalr	-688(ra) # 668c <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4944:	85ca                	mv	a1,s2
    4946:	00004517          	auipc	a0,0x4
    494a:	c9a50513          	addi	a0,a0,-870 # 85e0 <malloc+0x1af6>
    494e:	00002097          	auipc	ra,0x2
    4952:	0de080e7          	jalr	222(ra) # 6a2c <printf>
    exit(1,"");
    4956:	00004597          	auipc	a1,0x4
    495a:	8c258593          	addi	a1,a1,-1854 # 8218 <malloc+0x172e>
    495e:	4505                	li	a0,1
    4960:	00002097          	auipc	ra,0x2
    4964:	d2c080e7          	jalr	-724(ra) # 668c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4968:	85ca                	mv	a1,s2
    496a:	00004517          	auipc	a0,0x4
    496e:	ca650513          	addi	a0,a0,-858 # 8610 <malloc+0x1b26>
    4972:	00002097          	auipc	ra,0x2
    4976:	0ba080e7          	jalr	186(ra) # 6a2c <printf>
    exit(1,"");
    497a:	00004597          	auipc	a1,0x4
    497e:	89e58593          	addi	a1,a1,-1890 # 8218 <malloc+0x172e>
    4982:	4505                	li	a0,1
    4984:	00002097          	auipc	ra,0x2
    4988:	d08080e7          	jalr	-760(ra) # 668c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    498c:	85ca                	mv	a1,s2
    498e:	00004517          	auipc	a0,0x4
    4992:	c8250513          	addi	a0,a0,-894 # 8610 <malloc+0x1b26>
    4996:	00002097          	auipc	ra,0x2
    499a:	096080e7          	jalr	150(ra) # 6a2c <printf>
    exit(1,"");
    499e:	00004597          	auipc	a1,0x4
    49a2:	87a58593          	addi	a1,a1,-1926 # 8218 <malloc+0x172e>
    49a6:	4505                	li	a0,1
    49a8:	00002097          	auipc	ra,0x2
    49ac:	ce4080e7          	jalr	-796(ra) # 668c <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    49b0:	85ca                	mv	a1,s2
    49b2:	00004517          	auipc	a0,0x4
    49b6:	c8650513          	addi	a0,a0,-890 # 8638 <malloc+0x1b4e>
    49ba:	00002097          	auipc	ra,0x2
    49be:	072080e7          	jalr	114(ra) # 6a2c <printf>
    exit(1,"");
    49c2:	00004597          	auipc	a1,0x4
    49c6:	85658593          	addi	a1,a1,-1962 # 8218 <malloc+0x172e>
    49ca:	4505                	li	a0,1
    49cc:	00002097          	auipc	ra,0x2
    49d0:	cc0080e7          	jalr	-832(ra) # 668c <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    49d4:	85ca                	mv	a1,s2
    49d6:	00004517          	auipc	a0,0x4
    49da:	c8a50513          	addi	a0,a0,-886 # 8660 <malloc+0x1b76>
    49de:	00002097          	auipc	ra,0x2
    49e2:	04e080e7          	jalr	78(ra) # 6a2c <printf>
    exit(1,"");
    49e6:	00004597          	auipc	a1,0x4
    49ea:	83258593          	addi	a1,a1,-1998 # 8218 <malloc+0x172e>
    49ee:	4505                	li	a0,1
    49f0:	00002097          	auipc	ra,0x2
    49f4:	c9c080e7          	jalr	-868(ra) # 668c <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    49f8:	85ca                	mv	a1,s2
    49fa:	00004517          	auipc	a0,0x4
    49fe:	c8e50513          	addi	a0,a0,-882 # 8688 <malloc+0x1b9e>
    4a02:	00002097          	auipc	ra,0x2
    4a06:	02a080e7          	jalr	42(ra) # 6a2c <printf>
    exit(1,"");
    4a0a:	00004597          	auipc	a1,0x4
    4a0e:	80e58593          	addi	a1,a1,-2034 # 8218 <malloc+0x172e>
    4a12:	4505                	li	a0,1
    4a14:	00002097          	auipc	ra,0x2
    4a18:	c78080e7          	jalr	-904(ra) # 668c <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4a1c:	85ca                	mv	a1,s2
    4a1e:	00004517          	auipc	a0,0x4
    4a22:	c9250513          	addi	a0,a0,-878 # 86b0 <malloc+0x1bc6>
    4a26:	00002097          	auipc	ra,0x2
    4a2a:	006080e7          	jalr	6(ra) # 6a2c <printf>
    exit(1,"");
    4a2e:	00003597          	auipc	a1,0x3
    4a32:	7ea58593          	addi	a1,a1,2026 # 8218 <malloc+0x172e>
    4a36:	4505                	li	a0,1
    4a38:	00002097          	auipc	ra,0x2
    4a3c:	c54080e7          	jalr	-940(ra) # 668c <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4a40:	85ca                	mv	a1,s2
    4a42:	00004517          	auipc	a0,0x4
    4a46:	c8e50513          	addi	a0,a0,-882 # 86d0 <malloc+0x1be6>
    4a4a:	00002097          	auipc	ra,0x2
    4a4e:	fe2080e7          	jalr	-30(ra) # 6a2c <printf>
    exit(1,"");
    4a52:	00003597          	auipc	a1,0x3
    4a56:	7c658593          	addi	a1,a1,1990 # 8218 <malloc+0x172e>
    4a5a:	4505                	li	a0,1
    4a5c:	00002097          	auipc	ra,0x2
    4a60:	c30080e7          	jalr	-976(ra) # 668c <exit>
    printf("%s: write . succeeded!\n", s);
    4a64:	85ca                	mv	a1,s2
    4a66:	00004517          	auipc	a0,0x4
    4a6a:	c9250513          	addi	a0,a0,-878 # 86f8 <malloc+0x1c0e>
    4a6e:	00002097          	auipc	ra,0x2
    4a72:	fbe080e7          	jalr	-66(ra) # 6a2c <printf>
    exit(1,"");
    4a76:	00003597          	auipc	a1,0x3
    4a7a:	7a258593          	addi	a1,a1,1954 # 8218 <malloc+0x172e>
    4a7e:	4505                	li	a0,1
    4a80:	00002097          	auipc	ra,0x2
    4a84:	c0c080e7          	jalr	-1012(ra) # 668c <exit>

0000000000004a88 <iref>:
{
    4a88:	7139                	addi	sp,sp,-64
    4a8a:	fc06                	sd	ra,56(sp)
    4a8c:	f822                	sd	s0,48(sp)
    4a8e:	f426                	sd	s1,40(sp)
    4a90:	f04a                	sd	s2,32(sp)
    4a92:	ec4e                	sd	s3,24(sp)
    4a94:	e852                	sd	s4,16(sp)
    4a96:	e456                	sd	s5,8(sp)
    4a98:	e05a                	sd	s6,0(sp)
    4a9a:	0080                	addi	s0,sp,64
    4a9c:	8b2a                	mv	s6,a0
    4a9e:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4aa2:	00004a17          	auipc	s4,0x4
    4aa6:	c6ea0a13          	addi	s4,s4,-914 # 8710 <malloc+0x1c26>
    mkdir("");
    4aaa:	00003497          	auipc	s1,0x3
    4aae:	76e48493          	addi	s1,s1,1902 # 8218 <malloc+0x172e>
    link("README", "");
    4ab2:	00002a97          	auipc	s5,0x2
    4ab6:	34ea8a93          	addi	s5,s5,846 # 6e00 <malloc+0x316>
    fd = open("xx", O_CREATE);
    4aba:	00004997          	auipc	s3,0x4
    4abe:	b4e98993          	addi	s3,s3,-1202 # 8608 <malloc+0x1b1e>
    4ac2:	a095                	j	4b26 <iref+0x9e>
      printf("%s: mkdir irefd failed\n", s);
    4ac4:	85da                	mv	a1,s6
    4ac6:	00004517          	auipc	a0,0x4
    4aca:	c5250513          	addi	a0,a0,-942 # 8718 <malloc+0x1c2e>
    4ace:	00002097          	auipc	ra,0x2
    4ad2:	f5e080e7          	jalr	-162(ra) # 6a2c <printf>
      exit(1,"");
    4ad6:	00003597          	auipc	a1,0x3
    4ada:	74258593          	addi	a1,a1,1858 # 8218 <malloc+0x172e>
    4ade:	4505                	li	a0,1
    4ae0:	00002097          	auipc	ra,0x2
    4ae4:	bac080e7          	jalr	-1108(ra) # 668c <exit>
      printf("%s: chdir irefd failed\n", s);
    4ae8:	85da                	mv	a1,s6
    4aea:	00004517          	auipc	a0,0x4
    4aee:	c4650513          	addi	a0,a0,-954 # 8730 <malloc+0x1c46>
    4af2:	00002097          	auipc	ra,0x2
    4af6:	f3a080e7          	jalr	-198(ra) # 6a2c <printf>
      exit(1,"");
    4afa:	00003597          	auipc	a1,0x3
    4afe:	71e58593          	addi	a1,a1,1822 # 8218 <malloc+0x172e>
    4b02:	4505                	li	a0,1
    4b04:	00002097          	auipc	ra,0x2
    4b08:	b88080e7          	jalr	-1144(ra) # 668c <exit>
      close(fd);
    4b0c:	00002097          	auipc	ra,0x2
    4b10:	ba8080e7          	jalr	-1112(ra) # 66b4 <close>
    4b14:	a889                	j	4b66 <iref+0xde>
    unlink("xx");
    4b16:	854e                	mv	a0,s3
    4b18:	00002097          	auipc	ra,0x2
    4b1c:	bc4080e7          	jalr	-1084(ra) # 66dc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4b20:	397d                	addiw	s2,s2,-1
    4b22:	06090063          	beqz	s2,4b82 <iref+0xfa>
    if(mkdir("irefd") != 0){
    4b26:	8552                	mv	a0,s4
    4b28:	00002097          	auipc	ra,0x2
    4b2c:	bcc080e7          	jalr	-1076(ra) # 66f4 <mkdir>
    4b30:	f951                	bnez	a0,4ac4 <iref+0x3c>
    if(chdir("irefd") != 0){
    4b32:	8552                	mv	a0,s4
    4b34:	00002097          	auipc	ra,0x2
    4b38:	bc8080e7          	jalr	-1080(ra) # 66fc <chdir>
    4b3c:	f555                	bnez	a0,4ae8 <iref+0x60>
    mkdir("");
    4b3e:	8526                	mv	a0,s1
    4b40:	00002097          	auipc	ra,0x2
    4b44:	bb4080e7          	jalr	-1100(ra) # 66f4 <mkdir>
    link("README", "");
    4b48:	85a6                	mv	a1,s1
    4b4a:	8556                	mv	a0,s5
    4b4c:	00002097          	auipc	ra,0x2
    4b50:	ba0080e7          	jalr	-1120(ra) # 66ec <link>
    fd = open("", O_CREATE);
    4b54:	20000593          	li	a1,512
    4b58:	8526                	mv	a0,s1
    4b5a:	00002097          	auipc	ra,0x2
    4b5e:	b72080e7          	jalr	-1166(ra) # 66cc <open>
    if(fd >= 0)
    4b62:	fa0555e3          	bgez	a0,4b0c <iref+0x84>
    fd = open("xx", O_CREATE);
    4b66:	20000593          	li	a1,512
    4b6a:	854e                	mv	a0,s3
    4b6c:	00002097          	auipc	ra,0x2
    4b70:	b60080e7          	jalr	-1184(ra) # 66cc <open>
    if(fd >= 0)
    4b74:	fa0541e3          	bltz	a0,4b16 <iref+0x8e>
      close(fd);
    4b78:	00002097          	auipc	ra,0x2
    4b7c:	b3c080e7          	jalr	-1220(ra) # 66b4 <close>
    4b80:	bf59                	j	4b16 <iref+0x8e>
    4b82:	03300493          	li	s1,51
    chdir("..");
    4b86:	00003997          	auipc	s3,0x3
    4b8a:	3b298993          	addi	s3,s3,946 # 7f38 <malloc+0x144e>
    unlink("irefd");
    4b8e:	00004917          	auipc	s2,0x4
    4b92:	b8290913          	addi	s2,s2,-1150 # 8710 <malloc+0x1c26>
    chdir("..");
    4b96:	854e                	mv	a0,s3
    4b98:	00002097          	auipc	ra,0x2
    4b9c:	b64080e7          	jalr	-1180(ra) # 66fc <chdir>
    unlink("irefd");
    4ba0:	854a                	mv	a0,s2
    4ba2:	00002097          	auipc	ra,0x2
    4ba6:	b3a080e7          	jalr	-1222(ra) # 66dc <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4baa:	34fd                	addiw	s1,s1,-1
    4bac:	f4ed                	bnez	s1,4b96 <iref+0x10e>
  chdir("/");
    4bae:	00003517          	auipc	a0,0x3
    4bb2:	33250513          	addi	a0,a0,818 # 7ee0 <malloc+0x13f6>
    4bb6:	00002097          	auipc	ra,0x2
    4bba:	b46080e7          	jalr	-1210(ra) # 66fc <chdir>
}
    4bbe:	70e2                	ld	ra,56(sp)
    4bc0:	7442                	ld	s0,48(sp)
    4bc2:	74a2                	ld	s1,40(sp)
    4bc4:	7902                	ld	s2,32(sp)
    4bc6:	69e2                	ld	s3,24(sp)
    4bc8:	6a42                	ld	s4,16(sp)
    4bca:	6aa2                	ld	s5,8(sp)
    4bcc:	6b02                	ld	s6,0(sp)
    4bce:	6121                	addi	sp,sp,64
    4bd0:	8082                	ret

0000000000004bd2 <openiputtest>:
{
    4bd2:	7179                	addi	sp,sp,-48
    4bd4:	f406                	sd	ra,40(sp)
    4bd6:	f022                	sd	s0,32(sp)
    4bd8:	ec26                	sd	s1,24(sp)
    4bda:	1800                	addi	s0,sp,48
    4bdc:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4bde:	00004517          	auipc	a0,0x4
    4be2:	b6a50513          	addi	a0,a0,-1174 # 8748 <malloc+0x1c5e>
    4be6:	00002097          	auipc	ra,0x2
    4bea:	b0e080e7          	jalr	-1266(ra) # 66f4 <mkdir>
    4bee:	04054663          	bltz	a0,4c3a <openiputtest+0x68>
  pid = fork();
    4bf2:	00002097          	auipc	ra,0x2
    4bf6:	a92080e7          	jalr	-1390(ra) # 6684 <fork>
  if(pid < 0){
    4bfa:	06054263          	bltz	a0,4c5e <openiputtest+0x8c>
  if(pid == 0){
    4bfe:	e959                	bnez	a0,4c94 <openiputtest+0xc2>
    int fd = open("oidir", O_RDWR);
    4c00:	4589                	li	a1,2
    4c02:	00004517          	auipc	a0,0x4
    4c06:	b4650513          	addi	a0,a0,-1210 # 8748 <malloc+0x1c5e>
    4c0a:	00002097          	auipc	ra,0x2
    4c0e:	ac2080e7          	jalr	-1342(ra) # 66cc <open>
    if(fd >= 0){
    4c12:	06054863          	bltz	a0,4c82 <openiputtest+0xb0>
      printf("%s: open directory for write succeeded\n", s);
    4c16:	85a6                	mv	a1,s1
    4c18:	00004517          	auipc	a0,0x4
    4c1c:	b5050513          	addi	a0,a0,-1200 # 8768 <malloc+0x1c7e>
    4c20:	00002097          	auipc	ra,0x2
    4c24:	e0c080e7          	jalr	-500(ra) # 6a2c <printf>
      exit(1,"");
    4c28:	00003597          	auipc	a1,0x3
    4c2c:	5f058593          	addi	a1,a1,1520 # 8218 <malloc+0x172e>
    4c30:	4505                	li	a0,1
    4c32:	00002097          	auipc	ra,0x2
    4c36:	a5a080e7          	jalr	-1446(ra) # 668c <exit>
    printf("%s: mkdir oidir failed\n", s);
    4c3a:	85a6                	mv	a1,s1
    4c3c:	00004517          	auipc	a0,0x4
    4c40:	b1450513          	addi	a0,a0,-1260 # 8750 <malloc+0x1c66>
    4c44:	00002097          	auipc	ra,0x2
    4c48:	de8080e7          	jalr	-536(ra) # 6a2c <printf>
    exit(1,"");
    4c4c:	00003597          	auipc	a1,0x3
    4c50:	5cc58593          	addi	a1,a1,1484 # 8218 <malloc+0x172e>
    4c54:	4505                	li	a0,1
    4c56:	00002097          	auipc	ra,0x2
    4c5a:	a36080e7          	jalr	-1482(ra) # 668c <exit>
    printf("%s: fork failed\n", s);
    4c5e:	85a6                	mv	a1,s1
    4c60:	00003517          	auipc	a0,0x3
    4c64:	85050513          	addi	a0,a0,-1968 # 74b0 <malloc+0x9c6>
    4c68:	00002097          	auipc	ra,0x2
    4c6c:	dc4080e7          	jalr	-572(ra) # 6a2c <printf>
    exit(1,"");
    4c70:	00003597          	auipc	a1,0x3
    4c74:	5a858593          	addi	a1,a1,1448 # 8218 <malloc+0x172e>
    4c78:	4505                	li	a0,1
    4c7a:	00002097          	auipc	ra,0x2
    4c7e:	a12080e7          	jalr	-1518(ra) # 668c <exit>
    exit(0,"");
    4c82:	00003597          	auipc	a1,0x3
    4c86:	59658593          	addi	a1,a1,1430 # 8218 <malloc+0x172e>
    4c8a:	4501                	li	a0,0
    4c8c:	00002097          	auipc	ra,0x2
    4c90:	a00080e7          	jalr	-1536(ra) # 668c <exit>
  sleep(1);
    4c94:	4505                	li	a0,1
    4c96:	00002097          	auipc	ra,0x2
    4c9a:	a86080e7          	jalr	-1402(ra) # 671c <sleep>
  if(unlink("oidir") != 0){
    4c9e:	00004517          	auipc	a0,0x4
    4ca2:	aaa50513          	addi	a0,a0,-1366 # 8748 <malloc+0x1c5e>
    4ca6:	00002097          	auipc	ra,0x2
    4caa:	a36080e7          	jalr	-1482(ra) # 66dc <unlink>
    4cae:	c11d                	beqz	a0,4cd4 <openiputtest+0x102>
    printf("%s: unlink failed\n", s);
    4cb0:	85a6                	mv	a1,s1
    4cb2:	00003517          	auipc	a0,0x3
    4cb6:	9ee50513          	addi	a0,a0,-1554 # 76a0 <malloc+0xbb6>
    4cba:	00002097          	auipc	ra,0x2
    4cbe:	d72080e7          	jalr	-654(ra) # 6a2c <printf>
    exit(1,"");
    4cc2:	00003597          	auipc	a1,0x3
    4cc6:	55658593          	addi	a1,a1,1366 # 8218 <malloc+0x172e>
    4cca:	4505                	li	a0,1
    4ccc:	00002097          	auipc	ra,0x2
    4cd0:	9c0080e7          	jalr	-1600(ra) # 668c <exit>
  wait(&xstatus,0);
    4cd4:	4581                	li	a1,0
    4cd6:	fdc40513          	addi	a0,s0,-36
    4cda:	00002097          	auipc	ra,0x2
    4cde:	9ba080e7          	jalr	-1606(ra) # 6694 <wait>
  exit(xstatus,"");
    4ce2:	00003597          	auipc	a1,0x3
    4ce6:	53658593          	addi	a1,a1,1334 # 8218 <malloc+0x172e>
    4cea:	fdc42503          	lw	a0,-36(s0)
    4cee:	00002097          	auipc	ra,0x2
    4cf2:	99e080e7          	jalr	-1634(ra) # 668c <exit>

0000000000004cf6 <forkforkfork>:
{
    4cf6:	1101                	addi	sp,sp,-32
    4cf8:	ec06                	sd	ra,24(sp)
    4cfa:	e822                	sd	s0,16(sp)
    4cfc:	e426                	sd	s1,8(sp)
    4cfe:	1000                	addi	s0,sp,32
    4d00:	84aa                	mv	s1,a0
  unlink("stopforking");
    4d02:	00004517          	auipc	a0,0x4
    4d06:	a8e50513          	addi	a0,a0,-1394 # 8790 <malloc+0x1ca6>
    4d0a:	00002097          	auipc	ra,0x2
    4d0e:	9d2080e7          	jalr	-1582(ra) # 66dc <unlink>
  int pid = fork();
    4d12:	00002097          	auipc	ra,0x2
    4d16:	972080e7          	jalr	-1678(ra) # 6684 <fork>
  if(pid < 0){
    4d1a:	04054663          	bltz	a0,4d66 <forkforkfork+0x70>
  if(pid == 0){
    4d1e:	c535                	beqz	a0,4d8a <forkforkfork+0x94>
  sleep(20); // two seconds
    4d20:	4551                	li	a0,20
    4d22:	00002097          	auipc	ra,0x2
    4d26:	9fa080e7          	jalr	-1542(ra) # 671c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4d2a:	20200593          	li	a1,514
    4d2e:	00004517          	auipc	a0,0x4
    4d32:	a6250513          	addi	a0,a0,-1438 # 8790 <malloc+0x1ca6>
    4d36:	00002097          	auipc	ra,0x2
    4d3a:	996080e7          	jalr	-1642(ra) # 66cc <open>
    4d3e:	00002097          	auipc	ra,0x2
    4d42:	976080e7          	jalr	-1674(ra) # 66b4 <close>
  wait(0,0);
    4d46:	4581                	li	a1,0
    4d48:	4501                	li	a0,0
    4d4a:	00002097          	auipc	ra,0x2
    4d4e:	94a080e7          	jalr	-1718(ra) # 6694 <wait>
  sleep(10); // one second
    4d52:	4529                	li	a0,10
    4d54:	00002097          	auipc	ra,0x2
    4d58:	9c8080e7          	jalr	-1592(ra) # 671c <sleep>
}
    4d5c:	60e2                	ld	ra,24(sp)
    4d5e:	6442                	ld	s0,16(sp)
    4d60:	64a2                	ld	s1,8(sp)
    4d62:	6105                	addi	sp,sp,32
    4d64:	8082                	ret
    printf("%s: fork failed", s);
    4d66:	85a6                	mv	a1,s1
    4d68:	00003517          	auipc	a0,0x3
    4d6c:	90850513          	addi	a0,a0,-1784 # 7670 <malloc+0xb86>
    4d70:	00002097          	auipc	ra,0x2
    4d74:	cbc080e7          	jalr	-836(ra) # 6a2c <printf>
    exit(1,"");
    4d78:	00003597          	auipc	a1,0x3
    4d7c:	4a058593          	addi	a1,a1,1184 # 8218 <malloc+0x172e>
    4d80:	4505                	li	a0,1
    4d82:	00002097          	auipc	ra,0x2
    4d86:	90a080e7          	jalr	-1782(ra) # 668c <exit>
      int fd = open("stopforking", 0);
    4d8a:	00004497          	auipc	s1,0x4
    4d8e:	a0648493          	addi	s1,s1,-1530 # 8790 <malloc+0x1ca6>
    4d92:	4581                	li	a1,0
    4d94:	8526                	mv	a0,s1
    4d96:	00002097          	auipc	ra,0x2
    4d9a:	936080e7          	jalr	-1738(ra) # 66cc <open>
      if(fd >= 0){
    4d9e:	02055463          	bgez	a0,4dc6 <forkforkfork+0xd0>
      if(fork() < 0){
    4da2:	00002097          	auipc	ra,0x2
    4da6:	8e2080e7          	jalr	-1822(ra) # 6684 <fork>
    4daa:	fe0554e3          	bgez	a0,4d92 <forkforkfork+0x9c>
        close(open("stopforking", O_CREATE|O_RDWR));
    4dae:	20200593          	li	a1,514
    4db2:	8526                	mv	a0,s1
    4db4:	00002097          	auipc	ra,0x2
    4db8:	918080e7          	jalr	-1768(ra) # 66cc <open>
    4dbc:	00002097          	auipc	ra,0x2
    4dc0:	8f8080e7          	jalr	-1800(ra) # 66b4 <close>
    4dc4:	b7f9                	j	4d92 <forkforkfork+0x9c>
        exit(0,"");
    4dc6:	00003597          	auipc	a1,0x3
    4dca:	45258593          	addi	a1,a1,1106 # 8218 <malloc+0x172e>
    4dce:	4501                	li	a0,0
    4dd0:	00002097          	auipc	ra,0x2
    4dd4:	8bc080e7          	jalr	-1860(ra) # 668c <exit>

0000000000004dd8 <killstatus>:
{
    4dd8:	7139                	addi	sp,sp,-64
    4dda:	fc06                	sd	ra,56(sp)
    4ddc:	f822                	sd	s0,48(sp)
    4dde:	f426                	sd	s1,40(sp)
    4de0:	f04a                	sd	s2,32(sp)
    4de2:	ec4e                	sd	s3,24(sp)
    4de4:	e852                	sd	s4,16(sp)
    4de6:	0080                	addi	s0,sp,64
    4de8:	8a2a                	mv	s4,a0
    4dea:	06400913          	li	s2,100
    if(xst != -1) {
    4dee:	59fd                	li	s3,-1
    int pid1 = fork();
    4df0:	00002097          	auipc	ra,0x2
    4df4:	894080e7          	jalr	-1900(ra) # 6684 <fork>
    4df8:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4dfa:	04054463          	bltz	a0,4e42 <killstatus+0x6a>
    if(pid1 == 0){
    4dfe:	c525                	beqz	a0,4e66 <killstatus+0x8e>
    sleep(1);
    4e00:	4505                	li	a0,1
    4e02:	00002097          	auipc	ra,0x2
    4e06:	91a080e7          	jalr	-1766(ra) # 671c <sleep>
    kill(pid1);
    4e0a:	8526                	mv	a0,s1
    4e0c:	00002097          	auipc	ra,0x2
    4e10:	8b0080e7          	jalr	-1872(ra) # 66bc <kill>
    wait(&xst,0);
    4e14:	4581                	li	a1,0
    4e16:	fcc40513          	addi	a0,s0,-52
    4e1a:	00002097          	auipc	ra,0x2
    4e1e:	87a080e7          	jalr	-1926(ra) # 6694 <wait>
    if(xst != -1) {
    4e22:	fcc42783          	lw	a5,-52(s0)
    4e26:	05379563          	bne	a5,s3,4e70 <killstatus+0x98>
  for(int i = 0; i < 100; i++){
    4e2a:	397d                	addiw	s2,s2,-1
    4e2c:	fc0912e3          	bnez	s2,4df0 <killstatus+0x18>
  exit(0,"");
    4e30:	00003597          	auipc	a1,0x3
    4e34:	3e858593          	addi	a1,a1,1000 # 8218 <malloc+0x172e>
    4e38:	4501                	li	a0,0
    4e3a:	00002097          	auipc	ra,0x2
    4e3e:	852080e7          	jalr	-1966(ra) # 668c <exit>
      printf("%s: fork failed\n", s);
    4e42:	85d2                	mv	a1,s4
    4e44:	00002517          	auipc	a0,0x2
    4e48:	66c50513          	addi	a0,a0,1644 # 74b0 <malloc+0x9c6>
    4e4c:	00002097          	auipc	ra,0x2
    4e50:	be0080e7          	jalr	-1056(ra) # 6a2c <printf>
      exit(1,"");
    4e54:	00003597          	auipc	a1,0x3
    4e58:	3c458593          	addi	a1,a1,964 # 8218 <malloc+0x172e>
    4e5c:	4505                	li	a0,1
    4e5e:	00002097          	auipc	ra,0x2
    4e62:	82e080e7          	jalr	-2002(ra) # 668c <exit>
        getpid();
    4e66:	00002097          	auipc	ra,0x2
    4e6a:	8a6080e7          	jalr	-1882(ra) # 670c <getpid>
      while(1) {
    4e6e:	bfe5                	j	4e66 <killstatus+0x8e>
       printf("%s: status should be -1\n", s);
    4e70:	85d2                	mv	a1,s4
    4e72:	00004517          	auipc	a0,0x4
    4e76:	92e50513          	addi	a0,a0,-1746 # 87a0 <malloc+0x1cb6>
    4e7a:	00002097          	auipc	ra,0x2
    4e7e:	bb2080e7          	jalr	-1102(ra) # 6a2c <printf>
       exit(1,"");
    4e82:	00003597          	auipc	a1,0x3
    4e86:	39658593          	addi	a1,a1,918 # 8218 <malloc+0x172e>
    4e8a:	4505                	li	a0,1
    4e8c:	00002097          	auipc	ra,0x2
    4e90:	800080e7          	jalr	-2048(ra) # 668c <exit>

0000000000004e94 <preempt>:
{
    4e94:	7139                	addi	sp,sp,-64
    4e96:	fc06                	sd	ra,56(sp)
    4e98:	f822                	sd	s0,48(sp)
    4e9a:	f426                	sd	s1,40(sp)
    4e9c:	f04a                	sd	s2,32(sp)
    4e9e:	ec4e                	sd	s3,24(sp)
    4ea0:	e852                	sd	s4,16(sp)
    4ea2:	0080                	addi	s0,sp,64
    4ea4:	84aa                	mv	s1,a0
  pid1 = fork();
    4ea6:	00001097          	auipc	ra,0x1
    4eaa:	7de080e7          	jalr	2014(ra) # 6684 <fork>
  if(pid1 < 0) {
    4eae:	00054563          	bltz	a0,4eb8 <preempt+0x24>
    4eb2:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    4eb4:	e505                	bnez	a0,4edc <preempt+0x48>
    for(;;)
    4eb6:	a001                	j	4eb6 <preempt+0x22>
    printf("%s: fork failed", s);
    4eb8:	85a6                	mv	a1,s1
    4eba:	00002517          	auipc	a0,0x2
    4ebe:	7b650513          	addi	a0,a0,1974 # 7670 <malloc+0xb86>
    4ec2:	00002097          	auipc	ra,0x2
    4ec6:	b6a080e7          	jalr	-1174(ra) # 6a2c <printf>
    exit(1,"");
    4eca:	00003597          	auipc	a1,0x3
    4ece:	34e58593          	addi	a1,a1,846 # 8218 <malloc+0x172e>
    4ed2:	4505                	li	a0,1
    4ed4:	00001097          	auipc	ra,0x1
    4ed8:	7b8080e7          	jalr	1976(ra) # 668c <exit>
  pid2 = fork();
    4edc:	00001097          	auipc	ra,0x1
    4ee0:	7a8080e7          	jalr	1960(ra) # 6684 <fork>
    4ee4:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4ee6:	00054463          	bltz	a0,4eee <preempt+0x5a>
  if(pid2 == 0)
    4eea:	e505                	bnez	a0,4f12 <preempt+0x7e>
    for(;;)
    4eec:	a001                	j	4eec <preempt+0x58>
    printf("%s: fork failed\n", s);
    4eee:	85a6                	mv	a1,s1
    4ef0:	00002517          	auipc	a0,0x2
    4ef4:	5c050513          	addi	a0,a0,1472 # 74b0 <malloc+0x9c6>
    4ef8:	00002097          	auipc	ra,0x2
    4efc:	b34080e7          	jalr	-1228(ra) # 6a2c <printf>
    exit(1,"");
    4f00:	00003597          	auipc	a1,0x3
    4f04:	31858593          	addi	a1,a1,792 # 8218 <malloc+0x172e>
    4f08:	4505                	li	a0,1
    4f0a:	00001097          	auipc	ra,0x1
    4f0e:	782080e7          	jalr	1922(ra) # 668c <exit>
  pipe(pfds);
    4f12:	fc840513          	addi	a0,s0,-56
    4f16:	00001097          	auipc	ra,0x1
    4f1a:	786080e7          	jalr	1926(ra) # 669c <pipe>
  pid3 = fork();
    4f1e:	00001097          	auipc	ra,0x1
    4f22:	766080e7          	jalr	1894(ra) # 6684 <fork>
    4f26:	892a                	mv	s2,a0
  if(pid3 < 0) {
    4f28:	02054e63          	bltz	a0,4f64 <preempt+0xd0>
  if(pid3 == 0){
    4f2c:	e925                	bnez	a0,4f9c <preempt+0x108>
    close(pfds[0]);
    4f2e:	fc842503          	lw	a0,-56(s0)
    4f32:	00001097          	auipc	ra,0x1
    4f36:	782080e7          	jalr	1922(ra) # 66b4 <close>
    if(write(pfds[1], "x", 1) != 1)
    4f3a:	4605                	li	a2,1
    4f3c:	00002597          	auipc	a1,0x2
    4f40:	d5c58593          	addi	a1,a1,-676 # 6c98 <malloc+0x1ae>
    4f44:	fcc42503          	lw	a0,-52(s0)
    4f48:	00001097          	auipc	ra,0x1
    4f4c:	764080e7          	jalr	1892(ra) # 66ac <write>
    4f50:	4785                	li	a5,1
    4f52:	02f51b63          	bne	a0,a5,4f88 <preempt+0xf4>
    close(pfds[1]);
    4f56:	fcc42503          	lw	a0,-52(s0)
    4f5a:	00001097          	auipc	ra,0x1
    4f5e:	75a080e7          	jalr	1882(ra) # 66b4 <close>
    for(;;)
    4f62:	a001                	j	4f62 <preempt+0xce>
     printf("%s: fork failed\n", s);
    4f64:	85a6                	mv	a1,s1
    4f66:	00002517          	auipc	a0,0x2
    4f6a:	54a50513          	addi	a0,a0,1354 # 74b0 <malloc+0x9c6>
    4f6e:	00002097          	auipc	ra,0x2
    4f72:	abe080e7          	jalr	-1346(ra) # 6a2c <printf>
     exit(1,"");
    4f76:	00003597          	auipc	a1,0x3
    4f7a:	2a258593          	addi	a1,a1,674 # 8218 <malloc+0x172e>
    4f7e:	4505                	li	a0,1
    4f80:	00001097          	auipc	ra,0x1
    4f84:	70c080e7          	jalr	1804(ra) # 668c <exit>
      printf("%s: preempt write error", s);
    4f88:	85a6                	mv	a1,s1
    4f8a:	00004517          	auipc	a0,0x4
    4f8e:	83650513          	addi	a0,a0,-1994 # 87c0 <malloc+0x1cd6>
    4f92:	00002097          	auipc	ra,0x2
    4f96:	a9a080e7          	jalr	-1382(ra) # 6a2c <printf>
    4f9a:	bf75                	j	4f56 <preempt+0xc2>
  close(pfds[1]);
    4f9c:	fcc42503          	lw	a0,-52(s0)
    4fa0:	00001097          	auipc	ra,0x1
    4fa4:	714080e7          	jalr	1812(ra) # 66b4 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4fa8:	660d                	lui	a2,0x3
    4faa:	00009597          	auipc	a1,0x9
    4fae:	cce58593          	addi	a1,a1,-818 # dc78 <buf>
    4fb2:	fc842503          	lw	a0,-56(s0)
    4fb6:	00001097          	auipc	ra,0x1
    4fba:	6ee080e7          	jalr	1774(ra) # 66a4 <read>
    4fbe:	4785                	li	a5,1
    4fc0:	02f50363          	beq	a0,a5,4fe6 <preempt+0x152>
    printf("%s: preempt read error", s);
    4fc4:	85a6                	mv	a1,s1
    4fc6:	00004517          	auipc	a0,0x4
    4fca:	81250513          	addi	a0,a0,-2030 # 87d8 <malloc+0x1cee>
    4fce:	00002097          	auipc	ra,0x2
    4fd2:	a5e080e7          	jalr	-1442(ra) # 6a2c <printf>
}
    4fd6:	70e2                	ld	ra,56(sp)
    4fd8:	7442                	ld	s0,48(sp)
    4fda:	74a2                	ld	s1,40(sp)
    4fdc:	7902                	ld	s2,32(sp)
    4fde:	69e2                	ld	s3,24(sp)
    4fe0:	6a42                	ld	s4,16(sp)
    4fe2:	6121                	addi	sp,sp,64
    4fe4:	8082                	ret
  close(pfds[0]);
    4fe6:	fc842503          	lw	a0,-56(s0)
    4fea:	00001097          	auipc	ra,0x1
    4fee:	6ca080e7          	jalr	1738(ra) # 66b4 <close>
  printf("kill... ");
    4ff2:	00003517          	auipc	a0,0x3
    4ff6:	7fe50513          	addi	a0,a0,2046 # 87f0 <malloc+0x1d06>
    4ffa:	00002097          	auipc	ra,0x2
    4ffe:	a32080e7          	jalr	-1486(ra) # 6a2c <printf>
  kill(pid1);
    5002:	8552                	mv	a0,s4
    5004:	00001097          	auipc	ra,0x1
    5008:	6b8080e7          	jalr	1720(ra) # 66bc <kill>
  kill(pid2);
    500c:	854e                	mv	a0,s3
    500e:	00001097          	auipc	ra,0x1
    5012:	6ae080e7          	jalr	1710(ra) # 66bc <kill>
  kill(pid3);
    5016:	854a                	mv	a0,s2
    5018:	00001097          	auipc	ra,0x1
    501c:	6a4080e7          	jalr	1700(ra) # 66bc <kill>
  printf("wait... ");
    5020:	00003517          	auipc	a0,0x3
    5024:	7e050513          	addi	a0,a0,2016 # 8800 <malloc+0x1d16>
    5028:	00002097          	auipc	ra,0x2
    502c:	a04080e7          	jalr	-1532(ra) # 6a2c <printf>
  wait(0,0);
    5030:	4581                	li	a1,0
    5032:	4501                	li	a0,0
    5034:	00001097          	auipc	ra,0x1
    5038:	660080e7          	jalr	1632(ra) # 6694 <wait>
  wait(0,0);
    503c:	4581                	li	a1,0
    503e:	4501                	li	a0,0
    5040:	00001097          	auipc	ra,0x1
    5044:	654080e7          	jalr	1620(ra) # 6694 <wait>
  wait(0,0);
    5048:	4581                	li	a1,0
    504a:	4501                	li	a0,0
    504c:	00001097          	auipc	ra,0x1
    5050:	648080e7          	jalr	1608(ra) # 6694 <wait>
    5054:	b749                	j	4fd6 <preempt+0x142>

0000000000005056 <reparent>:
{
    5056:	7179                	addi	sp,sp,-48
    5058:	f406                	sd	ra,40(sp)
    505a:	f022                	sd	s0,32(sp)
    505c:	ec26                	sd	s1,24(sp)
    505e:	e84a                	sd	s2,16(sp)
    5060:	e44e                	sd	s3,8(sp)
    5062:	e052                	sd	s4,0(sp)
    5064:	1800                	addi	s0,sp,48
    5066:	89aa                	mv	s3,a0
  int master_pid = getpid();
    5068:	00001097          	auipc	ra,0x1
    506c:	6a4080e7          	jalr	1700(ra) # 670c <getpid>
    5070:	8a2a                	mv	s4,a0
    5072:	0c800913          	li	s2,200
    int pid = fork();
    5076:	00001097          	auipc	ra,0x1
    507a:	60e080e7          	jalr	1550(ra) # 6684 <fork>
    507e:	84aa                	mv	s1,a0
    if(pid < 0){
    5080:	02054763          	bltz	a0,50ae <reparent+0x58>
    if(pid){
    5084:	c92d                	beqz	a0,50f6 <reparent+0xa0>
      if(wait(0,0) != pid){
    5086:	4581                	li	a1,0
    5088:	4501                	li	a0,0
    508a:	00001097          	auipc	ra,0x1
    508e:	60a080e7          	jalr	1546(ra) # 6694 <wait>
    5092:	04951063          	bne	a0,s1,50d2 <reparent+0x7c>
  for(int i = 0; i < 200; i++){
    5096:	397d                	addiw	s2,s2,-1
    5098:	fc091fe3          	bnez	s2,5076 <reparent+0x20>
  exit(0,"");
    509c:	00003597          	auipc	a1,0x3
    50a0:	17c58593          	addi	a1,a1,380 # 8218 <malloc+0x172e>
    50a4:	4501                	li	a0,0
    50a6:	00001097          	auipc	ra,0x1
    50aa:	5e6080e7          	jalr	1510(ra) # 668c <exit>
      printf("%s: fork failed\n", s);
    50ae:	85ce                	mv	a1,s3
    50b0:	00002517          	auipc	a0,0x2
    50b4:	40050513          	addi	a0,a0,1024 # 74b0 <malloc+0x9c6>
    50b8:	00002097          	auipc	ra,0x2
    50bc:	974080e7          	jalr	-1676(ra) # 6a2c <printf>
      exit(1,"");
    50c0:	00003597          	auipc	a1,0x3
    50c4:	15858593          	addi	a1,a1,344 # 8218 <malloc+0x172e>
    50c8:	4505                	li	a0,1
    50ca:	00001097          	auipc	ra,0x1
    50ce:	5c2080e7          	jalr	1474(ra) # 668c <exit>
        printf("%s: wait wrong pid\n", s);
    50d2:	85ce                	mv	a1,s3
    50d4:	00002517          	auipc	a0,0x2
    50d8:	56450513          	addi	a0,a0,1380 # 7638 <malloc+0xb4e>
    50dc:	00002097          	auipc	ra,0x2
    50e0:	950080e7          	jalr	-1712(ra) # 6a2c <printf>
        exit(1,"");
    50e4:	00003597          	auipc	a1,0x3
    50e8:	13458593          	addi	a1,a1,308 # 8218 <malloc+0x172e>
    50ec:	4505                	li	a0,1
    50ee:	00001097          	auipc	ra,0x1
    50f2:	59e080e7          	jalr	1438(ra) # 668c <exit>
      int pid2 = fork();
    50f6:	00001097          	auipc	ra,0x1
    50fa:	58e080e7          	jalr	1422(ra) # 6684 <fork>
      if(pid2 < 0){
    50fe:	00054b63          	bltz	a0,5114 <reparent+0xbe>
      exit(0,"");
    5102:	00003597          	auipc	a1,0x3
    5106:	11658593          	addi	a1,a1,278 # 8218 <malloc+0x172e>
    510a:	4501                	li	a0,0
    510c:	00001097          	auipc	ra,0x1
    5110:	580080e7          	jalr	1408(ra) # 668c <exit>
        kill(master_pid);
    5114:	8552                	mv	a0,s4
    5116:	00001097          	auipc	ra,0x1
    511a:	5a6080e7          	jalr	1446(ra) # 66bc <kill>
        exit(1,"");
    511e:	00003597          	auipc	a1,0x3
    5122:	0fa58593          	addi	a1,a1,250 # 8218 <malloc+0x172e>
    5126:	4505                	li	a0,1
    5128:	00001097          	auipc	ra,0x1
    512c:	564080e7          	jalr	1380(ra) # 668c <exit>

0000000000005130 <sbrkfail>:
{
    5130:	7119                	addi	sp,sp,-128
    5132:	fc86                	sd	ra,120(sp)
    5134:	f8a2                	sd	s0,112(sp)
    5136:	f4a6                	sd	s1,104(sp)
    5138:	f0ca                	sd	s2,96(sp)
    513a:	ecce                	sd	s3,88(sp)
    513c:	e8d2                	sd	s4,80(sp)
    513e:	e4d6                	sd	s5,72(sp)
    5140:	0100                	addi	s0,sp,128
    5142:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    5144:	fb040513          	addi	a0,s0,-80
    5148:	00001097          	auipc	ra,0x1
    514c:	554080e7          	jalr	1364(ra) # 669c <pipe>
    5150:	e901                	bnez	a0,5160 <sbrkfail+0x30>
    5152:	f8040493          	addi	s1,s0,-128
    5156:	fa840a13          	addi	s4,s0,-88
    515a:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    515c:	5afd                	li	s5,-1
    515e:	a0ad                	j	51c8 <sbrkfail+0x98>
    printf("%s: pipe() failed\n", s);
    5160:	85ca                	mv	a1,s2
    5162:	00002517          	auipc	a0,0x2
    5166:	45650513          	addi	a0,a0,1110 # 75b8 <malloc+0xace>
    516a:	00002097          	auipc	ra,0x2
    516e:	8c2080e7          	jalr	-1854(ra) # 6a2c <printf>
    exit(1,"");
    5172:	00003597          	auipc	a1,0x3
    5176:	0a658593          	addi	a1,a1,166 # 8218 <malloc+0x172e>
    517a:	4505                	li	a0,1
    517c:	00001097          	auipc	ra,0x1
    5180:	510080e7          	jalr	1296(ra) # 668c <exit>
      sbrk(BIG - (uint64)sbrk(0));
    5184:	4501                	li	a0,0
    5186:	00001097          	auipc	ra,0x1
    518a:	58e080e7          	jalr	1422(ra) # 6714 <sbrk>
    518e:	064007b7          	lui	a5,0x6400
    5192:	40a7853b          	subw	a0,a5,a0
    5196:	00001097          	auipc	ra,0x1
    519a:	57e080e7          	jalr	1406(ra) # 6714 <sbrk>
      write(fds[1], "x", 1);
    519e:	4605                	li	a2,1
    51a0:	00002597          	auipc	a1,0x2
    51a4:	af858593          	addi	a1,a1,-1288 # 6c98 <malloc+0x1ae>
    51a8:	fb442503          	lw	a0,-76(s0)
    51ac:	00001097          	auipc	ra,0x1
    51b0:	500080e7          	jalr	1280(ra) # 66ac <write>
      for(;;) sleep(1000);
    51b4:	3e800513          	li	a0,1000
    51b8:	00001097          	auipc	ra,0x1
    51bc:	564080e7          	jalr	1380(ra) # 671c <sleep>
    51c0:	bfd5                	j	51b4 <sbrkfail+0x84>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    51c2:	0991                	addi	s3,s3,4
    51c4:	03498563          	beq	s3,s4,51ee <sbrkfail+0xbe>
    if((pids[i] = fork()) == 0){
    51c8:	00001097          	auipc	ra,0x1
    51cc:	4bc080e7          	jalr	1212(ra) # 6684 <fork>
    51d0:	00a9a023          	sw	a0,0(s3)
    51d4:	d945                	beqz	a0,5184 <sbrkfail+0x54>
    if(pids[i] != -1)
    51d6:	ff5506e3          	beq	a0,s5,51c2 <sbrkfail+0x92>
      read(fds[0], &scratch, 1);
    51da:	4605                	li	a2,1
    51dc:	faf40593          	addi	a1,s0,-81
    51e0:	fb042503          	lw	a0,-80(s0)
    51e4:	00001097          	auipc	ra,0x1
    51e8:	4c0080e7          	jalr	1216(ra) # 66a4 <read>
    51ec:	bfd9                	j	51c2 <sbrkfail+0x92>
  c = sbrk(PGSIZE);
    51ee:	6505                	lui	a0,0x1
    51f0:	00001097          	auipc	ra,0x1
    51f4:	524080e7          	jalr	1316(ra) # 6714 <sbrk>
    51f8:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    51fa:	5afd                	li	s5,-1
    51fc:	a021                	j	5204 <sbrkfail+0xd4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    51fe:	0491                	addi	s1,s1,4
    5200:	03448063          	beq	s1,s4,5220 <sbrkfail+0xf0>
    if(pids[i] == -1)
    5204:	4088                	lw	a0,0(s1)
    5206:	ff550ce3          	beq	a0,s5,51fe <sbrkfail+0xce>
    kill(pids[i]);
    520a:	00001097          	auipc	ra,0x1
    520e:	4b2080e7          	jalr	1202(ra) # 66bc <kill>
    wait(0,0);
    5212:	4581                	li	a1,0
    5214:	4501                	li	a0,0
    5216:	00001097          	auipc	ra,0x1
    521a:	47e080e7          	jalr	1150(ra) # 6694 <wait>
    521e:	b7c5                	j	51fe <sbrkfail+0xce>
  if(c == (char*)0xffffffffffffffffL){
    5220:	57fd                	li	a5,-1
    5222:	04f98263          	beq	s3,a5,5266 <sbrkfail+0x136>
  pid = fork();
    5226:	00001097          	auipc	ra,0x1
    522a:	45e080e7          	jalr	1118(ra) # 6684 <fork>
    522e:	84aa                	mv	s1,a0
  if(pid < 0){
    5230:	04054d63          	bltz	a0,528a <sbrkfail+0x15a>
  if(pid == 0){
    5234:	cd2d                	beqz	a0,52ae <sbrkfail+0x17e>
  wait(&xstatus,0);
    5236:	4581                	li	a1,0
    5238:	fbc40513          	addi	a0,s0,-68
    523c:	00001097          	auipc	ra,0x1
    5240:	458080e7          	jalr	1112(ra) # 6694 <wait>
  if(xstatus != -1 && xstatus != 2)
    5244:	fbc42783          	lw	a5,-68(s0)
    5248:	577d                	li	a4,-1
    524a:	00e78563          	beq	a5,a4,5254 <sbrkfail+0x124>
    524e:	4709                	li	a4,2
    5250:	0ae79963          	bne	a5,a4,5302 <sbrkfail+0x1d2>
}
    5254:	70e6                	ld	ra,120(sp)
    5256:	7446                	ld	s0,112(sp)
    5258:	74a6                	ld	s1,104(sp)
    525a:	7906                	ld	s2,96(sp)
    525c:	69e6                	ld	s3,88(sp)
    525e:	6a46                	ld	s4,80(sp)
    5260:	6aa6                	ld	s5,72(sp)
    5262:	6109                	addi	sp,sp,128
    5264:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    5266:	85ca                	mv	a1,s2
    5268:	00003517          	auipc	a0,0x3
    526c:	5a850513          	addi	a0,a0,1448 # 8810 <malloc+0x1d26>
    5270:	00001097          	auipc	ra,0x1
    5274:	7bc080e7          	jalr	1980(ra) # 6a2c <printf>
    exit(1,"");
    5278:	00003597          	auipc	a1,0x3
    527c:	fa058593          	addi	a1,a1,-96 # 8218 <malloc+0x172e>
    5280:	4505                	li	a0,1
    5282:	00001097          	auipc	ra,0x1
    5286:	40a080e7          	jalr	1034(ra) # 668c <exit>
    printf("%s: fork failed\n", s);
    528a:	85ca                	mv	a1,s2
    528c:	00002517          	auipc	a0,0x2
    5290:	22450513          	addi	a0,a0,548 # 74b0 <malloc+0x9c6>
    5294:	00001097          	auipc	ra,0x1
    5298:	798080e7          	jalr	1944(ra) # 6a2c <printf>
    exit(1,"");
    529c:	00003597          	auipc	a1,0x3
    52a0:	f7c58593          	addi	a1,a1,-132 # 8218 <malloc+0x172e>
    52a4:	4505                	li	a0,1
    52a6:	00001097          	auipc	ra,0x1
    52aa:	3e6080e7          	jalr	998(ra) # 668c <exit>
    a = sbrk(0);
    52ae:	4501                	li	a0,0
    52b0:	00001097          	auipc	ra,0x1
    52b4:	464080e7          	jalr	1124(ra) # 6714 <sbrk>
    52b8:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    52ba:	3e800537          	lui	a0,0x3e800
    52be:	00001097          	auipc	ra,0x1
    52c2:	456080e7          	jalr	1110(ra) # 6714 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    52c6:	874e                	mv	a4,s3
    52c8:	3e8007b7          	lui	a5,0x3e800
    52cc:	97ce                	add	a5,a5,s3
    52ce:	6685                	lui	a3,0x1
      n += *(a+i);
    52d0:	00074603          	lbu	a2,0(a4)
    52d4:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    52d6:	9736                	add	a4,a4,a3
    52d8:	fef71ce3          	bne	a4,a5,52d0 <sbrkfail+0x1a0>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    52dc:	8626                	mv	a2,s1
    52de:	85ca                	mv	a1,s2
    52e0:	00003517          	auipc	a0,0x3
    52e4:	55050513          	addi	a0,a0,1360 # 8830 <malloc+0x1d46>
    52e8:	00001097          	auipc	ra,0x1
    52ec:	744080e7          	jalr	1860(ra) # 6a2c <printf>
    exit(1,"");
    52f0:	00003597          	auipc	a1,0x3
    52f4:	f2858593          	addi	a1,a1,-216 # 8218 <malloc+0x172e>
    52f8:	4505                	li	a0,1
    52fa:	00001097          	auipc	ra,0x1
    52fe:	392080e7          	jalr	914(ra) # 668c <exit>
    exit(1,"");
    5302:	00003597          	auipc	a1,0x3
    5306:	f1658593          	addi	a1,a1,-234 # 8218 <malloc+0x172e>
    530a:	4505                	li	a0,1
    530c:	00001097          	auipc	ra,0x1
    5310:	380080e7          	jalr	896(ra) # 668c <exit>

0000000000005314 <mem>:
{
    5314:	7139                	addi	sp,sp,-64
    5316:	fc06                	sd	ra,56(sp)
    5318:	f822                	sd	s0,48(sp)
    531a:	f426                	sd	s1,40(sp)
    531c:	f04a                	sd	s2,32(sp)
    531e:	ec4e                	sd	s3,24(sp)
    5320:	0080                	addi	s0,sp,64
    5322:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    5324:	00001097          	auipc	ra,0x1
    5328:	360080e7          	jalr	864(ra) # 6684 <fork>
    m1 = 0;
    532c:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    532e:	6909                	lui	s2,0x2
    5330:	71190913          	addi	s2,s2,1809 # 2711 <bigargtest+0x33>
  if((pid = fork()) == 0){
    5334:	e53d                	bnez	a0,53a2 <mem+0x8e>
    while((m2 = malloc(10001)) != 0){
    5336:	854a                	mv	a0,s2
    5338:	00001097          	auipc	ra,0x1
    533c:	7b2080e7          	jalr	1970(ra) # 6aea <malloc>
    5340:	c501                	beqz	a0,5348 <mem+0x34>
      *(char**)m2 = m1;
    5342:	e104                	sd	s1,0(a0)
      m1 = m2;
    5344:	84aa                	mv	s1,a0
    5346:	bfc5                	j	5336 <mem+0x22>
    while(m1){
    5348:	c881                	beqz	s1,5358 <mem+0x44>
      m2 = *(char**)m1;
    534a:	8526                	mv	a0,s1
    534c:	6084                	ld	s1,0(s1)
      free(m1);
    534e:	00001097          	auipc	ra,0x1
    5352:	714080e7          	jalr	1812(ra) # 6a62 <free>
    while(m1){
    5356:	f8f5                	bnez	s1,534a <mem+0x36>
    m1 = malloc(1024*20);
    5358:	6515                	lui	a0,0x5
    535a:	00001097          	auipc	ra,0x1
    535e:	790080e7          	jalr	1936(ra) # 6aea <malloc>
    if(m1 == 0){
    5362:	cd11                	beqz	a0,537e <mem+0x6a>
    free(m1);
    5364:	00001097          	auipc	ra,0x1
    5368:	6fe080e7          	jalr	1790(ra) # 6a62 <free>
    exit(0,"");
    536c:	00003597          	auipc	a1,0x3
    5370:	eac58593          	addi	a1,a1,-340 # 8218 <malloc+0x172e>
    5374:	4501                	li	a0,0
    5376:	00001097          	auipc	ra,0x1
    537a:	316080e7          	jalr	790(ra) # 668c <exit>
      printf("couldn't allocate mem?!!\n", s);
    537e:	85ce                	mv	a1,s3
    5380:	00003517          	auipc	a0,0x3
    5384:	4e050513          	addi	a0,a0,1248 # 8860 <malloc+0x1d76>
    5388:	00001097          	auipc	ra,0x1
    538c:	6a4080e7          	jalr	1700(ra) # 6a2c <printf>
      exit(1,"");
    5390:	00003597          	auipc	a1,0x3
    5394:	e8858593          	addi	a1,a1,-376 # 8218 <malloc+0x172e>
    5398:	4505                	li	a0,1
    539a:	00001097          	auipc	ra,0x1
    539e:	2f2080e7          	jalr	754(ra) # 668c <exit>
    wait(&xstatus,0);
    53a2:	4581                	li	a1,0
    53a4:	fcc40513          	addi	a0,s0,-52
    53a8:	00001097          	auipc	ra,0x1
    53ac:	2ec080e7          	jalr	748(ra) # 6694 <wait>
    if(xstatus == -1){
    53b0:	fcc42503          	lw	a0,-52(s0)
    53b4:	57fd                	li	a5,-1
    53b6:	00f50a63          	beq	a0,a5,53ca <mem+0xb6>
    exit(xstatus,"");
    53ba:	00003597          	auipc	a1,0x3
    53be:	e5e58593          	addi	a1,a1,-418 # 8218 <malloc+0x172e>
    53c2:	00001097          	auipc	ra,0x1
    53c6:	2ca080e7          	jalr	714(ra) # 668c <exit>
      exit(0,"");
    53ca:	00003597          	auipc	a1,0x3
    53ce:	e4e58593          	addi	a1,a1,-434 # 8218 <malloc+0x172e>
    53d2:	4501                	li	a0,0
    53d4:	00001097          	auipc	ra,0x1
    53d8:	2b8080e7          	jalr	696(ra) # 668c <exit>

00000000000053dc <sharedfd>:
{
    53dc:	7159                	addi	sp,sp,-112
    53de:	f486                	sd	ra,104(sp)
    53e0:	f0a2                	sd	s0,96(sp)
    53e2:	eca6                	sd	s1,88(sp)
    53e4:	e8ca                	sd	s2,80(sp)
    53e6:	e4ce                	sd	s3,72(sp)
    53e8:	e0d2                	sd	s4,64(sp)
    53ea:	fc56                	sd	s5,56(sp)
    53ec:	f85a                	sd	s6,48(sp)
    53ee:	f45e                	sd	s7,40(sp)
    53f0:	1880                	addi	s0,sp,112
    53f2:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    53f4:	00003517          	auipc	a0,0x3
    53f8:	48c50513          	addi	a0,a0,1164 # 8880 <malloc+0x1d96>
    53fc:	00001097          	auipc	ra,0x1
    5400:	2e0080e7          	jalr	736(ra) # 66dc <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    5404:	20200593          	li	a1,514
    5408:	00003517          	auipc	a0,0x3
    540c:	47850513          	addi	a0,a0,1144 # 8880 <malloc+0x1d96>
    5410:	00001097          	auipc	ra,0x1
    5414:	2bc080e7          	jalr	700(ra) # 66cc <open>
  if(fd < 0){
    5418:	04054e63          	bltz	a0,5474 <sharedfd+0x98>
    541c:	892a                	mv	s2,a0
  pid = fork();
    541e:	00001097          	auipc	ra,0x1
    5422:	266080e7          	jalr	614(ra) # 6684 <fork>
    5426:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    5428:	06300593          	li	a1,99
    542c:	c119                	beqz	a0,5432 <sharedfd+0x56>
    542e:	07000593          	li	a1,112
    5432:	4629                	li	a2,10
    5434:	fa040513          	addi	a0,s0,-96
    5438:	00001097          	auipc	ra,0x1
    543c:	050080e7          	jalr	80(ra) # 6488 <memset>
    5440:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    5444:	4629                	li	a2,10
    5446:	fa040593          	addi	a1,s0,-96
    544a:	854a                	mv	a0,s2
    544c:	00001097          	auipc	ra,0x1
    5450:	260080e7          	jalr	608(ra) # 66ac <write>
    5454:	47a9                	li	a5,10
    5456:	04f51163          	bne	a0,a5,5498 <sharedfd+0xbc>
  for(i = 0; i < N; i++){
    545a:	34fd                	addiw	s1,s1,-1
    545c:	f4e5                	bnez	s1,5444 <sharedfd+0x68>
  if(pid == 0) {
    545e:	04099f63          	bnez	s3,54bc <sharedfd+0xe0>
    exit(0,"");
    5462:	00003597          	auipc	a1,0x3
    5466:	db658593          	addi	a1,a1,-586 # 8218 <malloc+0x172e>
    546a:	4501                	li	a0,0
    546c:	00001097          	auipc	ra,0x1
    5470:	220080e7          	jalr	544(ra) # 668c <exit>
    printf("%s: cannot open sharedfd for writing", s);
    5474:	85d2                	mv	a1,s4
    5476:	00003517          	auipc	a0,0x3
    547a:	41a50513          	addi	a0,a0,1050 # 8890 <malloc+0x1da6>
    547e:	00001097          	auipc	ra,0x1
    5482:	5ae080e7          	jalr	1454(ra) # 6a2c <printf>
    exit(1,"");
    5486:	00003597          	auipc	a1,0x3
    548a:	d9258593          	addi	a1,a1,-622 # 8218 <malloc+0x172e>
    548e:	4505                	li	a0,1
    5490:	00001097          	auipc	ra,0x1
    5494:	1fc080e7          	jalr	508(ra) # 668c <exit>
      printf("%s: write sharedfd failed\n", s);
    5498:	85d2                	mv	a1,s4
    549a:	00003517          	auipc	a0,0x3
    549e:	41e50513          	addi	a0,a0,1054 # 88b8 <malloc+0x1dce>
    54a2:	00001097          	auipc	ra,0x1
    54a6:	58a080e7          	jalr	1418(ra) # 6a2c <printf>
      exit(1,"");
    54aa:	00003597          	auipc	a1,0x3
    54ae:	d6e58593          	addi	a1,a1,-658 # 8218 <malloc+0x172e>
    54b2:	4505                	li	a0,1
    54b4:	00001097          	auipc	ra,0x1
    54b8:	1d8080e7          	jalr	472(ra) # 668c <exit>
    wait(&xstatus,0);
    54bc:	4581                	li	a1,0
    54be:	f9c40513          	addi	a0,s0,-100
    54c2:	00001097          	auipc	ra,0x1
    54c6:	1d2080e7          	jalr	466(ra) # 6694 <wait>
    if(xstatus != 0)
    54ca:	f9c42983          	lw	s3,-100(s0)
    54ce:	00098b63          	beqz	s3,54e4 <sharedfd+0x108>
      exit(xstatus,"");
    54d2:	00003597          	auipc	a1,0x3
    54d6:	d4658593          	addi	a1,a1,-698 # 8218 <malloc+0x172e>
    54da:	854e                	mv	a0,s3
    54dc:	00001097          	auipc	ra,0x1
    54e0:	1b0080e7          	jalr	432(ra) # 668c <exit>
  close(fd);
    54e4:	854a                	mv	a0,s2
    54e6:	00001097          	auipc	ra,0x1
    54ea:	1ce080e7          	jalr	462(ra) # 66b4 <close>
  fd = open("sharedfd", 0);
    54ee:	4581                	li	a1,0
    54f0:	00003517          	auipc	a0,0x3
    54f4:	39050513          	addi	a0,a0,912 # 8880 <malloc+0x1d96>
    54f8:	00001097          	auipc	ra,0x1
    54fc:	1d4080e7          	jalr	468(ra) # 66cc <open>
    5500:	8baa                	mv	s7,a0
  nc = np = 0;
    5502:	8ace                	mv	s5,s3
  if(fd < 0){
    5504:	02054563          	bltz	a0,552e <sharedfd+0x152>
    5508:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    550c:	06300493          	li	s1,99
      if(buf[i] == 'p')
    5510:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    5514:	4629                	li	a2,10
    5516:	fa040593          	addi	a1,s0,-96
    551a:	855e                	mv	a0,s7
    551c:	00001097          	auipc	ra,0x1
    5520:	188080e7          	jalr	392(ra) # 66a4 <read>
    5524:	04a05363          	blez	a0,556a <sharedfd+0x18e>
    5528:	fa040793          	addi	a5,s0,-96
    552c:	a03d                	j	555a <sharedfd+0x17e>
    printf("%s: cannot open sharedfd for reading\n", s);
    552e:	85d2                	mv	a1,s4
    5530:	00003517          	auipc	a0,0x3
    5534:	3a850513          	addi	a0,a0,936 # 88d8 <malloc+0x1dee>
    5538:	00001097          	auipc	ra,0x1
    553c:	4f4080e7          	jalr	1268(ra) # 6a2c <printf>
    exit(1,"");
    5540:	00003597          	auipc	a1,0x3
    5544:	cd858593          	addi	a1,a1,-808 # 8218 <malloc+0x172e>
    5548:	4505                	li	a0,1
    554a:	00001097          	auipc	ra,0x1
    554e:	142080e7          	jalr	322(ra) # 668c <exit>
        nc++;
    5552:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    5554:	0785                	addi	a5,a5,1
    5556:	fb278fe3          	beq	a5,s2,5514 <sharedfd+0x138>
      if(buf[i] == 'c')
    555a:	0007c703          	lbu	a4,0(a5) # 3e800000 <base+0x3e7ef388>
    555e:	fe970ae3          	beq	a4,s1,5552 <sharedfd+0x176>
      if(buf[i] == 'p')
    5562:	ff6719e3          	bne	a4,s6,5554 <sharedfd+0x178>
        np++;
    5566:	2a85                	addiw	s5,s5,1
    5568:	b7f5                	j	5554 <sharedfd+0x178>
  close(fd);
    556a:	855e                	mv	a0,s7
    556c:	00001097          	auipc	ra,0x1
    5570:	148080e7          	jalr	328(ra) # 66b4 <close>
  unlink("sharedfd");
    5574:	00003517          	auipc	a0,0x3
    5578:	30c50513          	addi	a0,a0,780 # 8880 <malloc+0x1d96>
    557c:	00001097          	auipc	ra,0x1
    5580:	160080e7          	jalr	352(ra) # 66dc <unlink>
  if(nc == N*SZ && np == N*SZ){
    5584:	6789                	lui	a5,0x2
    5586:	71078793          	addi	a5,a5,1808 # 2710 <bigargtest+0x32>
    558a:	00f99763          	bne	s3,a5,5598 <sharedfd+0x1bc>
    558e:	6789                	lui	a5,0x2
    5590:	71078793          	addi	a5,a5,1808 # 2710 <bigargtest+0x32>
    5594:	02fa8463          	beq	s5,a5,55bc <sharedfd+0x1e0>
    printf("%s: nc/np test fails\n", s);
    5598:	85d2                	mv	a1,s4
    559a:	00003517          	auipc	a0,0x3
    559e:	36650513          	addi	a0,a0,870 # 8900 <malloc+0x1e16>
    55a2:	00001097          	auipc	ra,0x1
    55a6:	48a080e7          	jalr	1162(ra) # 6a2c <printf>
    exit(1,"");
    55aa:	00003597          	auipc	a1,0x3
    55ae:	c6e58593          	addi	a1,a1,-914 # 8218 <malloc+0x172e>
    55b2:	4505                	li	a0,1
    55b4:	00001097          	auipc	ra,0x1
    55b8:	0d8080e7          	jalr	216(ra) # 668c <exit>
    exit(0,"");
    55bc:	00003597          	auipc	a1,0x3
    55c0:	c5c58593          	addi	a1,a1,-932 # 8218 <malloc+0x172e>
    55c4:	4501                	li	a0,0
    55c6:	00001097          	auipc	ra,0x1
    55ca:	0c6080e7          	jalr	198(ra) # 668c <exit>

00000000000055ce <fourfiles>:
{
    55ce:	7171                	addi	sp,sp,-176
    55d0:	f506                	sd	ra,168(sp)
    55d2:	f122                	sd	s0,160(sp)
    55d4:	ed26                	sd	s1,152(sp)
    55d6:	e94a                	sd	s2,144(sp)
    55d8:	e54e                	sd	s3,136(sp)
    55da:	e152                	sd	s4,128(sp)
    55dc:	fcd6                	sd	s5,120(sp)
    55de:	f8da                	sd	s6,112(sp)
    55e0:	f4de                	sd	s7,104(sp)
    55e2:	f0e2                	sd	s8,96(sp)
    55e4:	ece6                	sd	s9,88(sp)
    55e6:	e8ea                	sd	s10,80(sp)
    55e8:	e4ee                	sd	s11,72(sp)
    55ea:	1900                	addi	s0,sp,176
    55ec:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    55ee:	00001797          	auipc	a5,0x1
    55f2:	5e278793          	addi	a5,a5,1506 # 6bd0 <malloc+0xe6>
    55f6:	f6f43823          	sd	a5,-144(s0)
    55fa:	00001797          	auipc	a5,0x1
    55fe:	5de78793          	addi	a5,a5,1502 # 6bd8 <malloc+0xee>
    5602:	f6f43c23          	sd	a5,-136(s0)
    5606:	00001797          	auipc	a5,0x1
    560a:	5da78793          	addi	a5,a5,1498 # 6be0 <malloc+0xf6>
    560e:	f8f43023          	sd	a5,-128(s0)
    5612:	00001797          	auipc	a5,0x1
    5616:	5d678793          	addi	a5,a5,1494 # 6be8 <malloc+0xfe>
    561a:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    561e:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    5622:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    5624:	4481                	li	s1,0
    5626:	4a11                	li	s4,4
    fname = names[pi];
    5628:	00093983          	ld	s3,0(s2)
    unlink(fname);
    562c:	854e                	mv	a0,s3
    562e:	00001097          	auipc	ra,0x1
    5632:	0ae080e7          	jalr	174(ra) # 66dc <unlink>
    pid = fork();
    5636:	00001097          	auipc	ra,0x1
    563a:	04e080e7          	jalr	78(ra) # 6684 <fork>
    if(pid < 0){
    563e:	04054663          	bltz	a0,568a <fourfiles+0xbc>
    if(pid == 0){
    5642:	c535                	beqz	a0,56ae <fourfiles+0xe0>
  for(pi = 0; pi < NCHILD; pi++){
    5644:	2485                	addiw	s1,s1,1
    5646:	0921                	addi	s2,s2,8
    5648:	ff4490e3          	bne	s1,s4,5628 <fourfiles+0x5a>
    564c:	4491                	li	s1,4
    wait(&xstatus,0);
    564e:	4581                	li	a1,0
    5650:	f6c40513          	addi	a0,s0,-148
    5654:	00001097          	auipc	ra,0x1
    5658:	040080e7          	jalr	64(ra) # 6694 <wait>
    if(xstatus != 0)
    565c:	f6c42503          	lw	a0,-148(s0)
    5660:	ed6d                	bnez	a0,575a <fourfiles+0x18c>
  for(pi = 0; pi < NCHILD; pi++){
    5662:	34fd                	addiw	s1,s1,-1
    5664:	f4ed                	bnez	s1,564e <fourfiles+0x80>
    5666:	03000b13          	li	s6,48
    total = 0;
    566a:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    566e:	00008a17          	auipc	s4,0x8
    5672:	60aa0a13          	addi	s4,s4,1546 # dc78 <buf>
    5676:	00008a97          	auipc	s5,0x8
    567a:	603a8a93          	addi	s5,s5,1539 # dc79 <buf+0x1>
    if(total != N*SZ){
    567e:	6d05                	lui	s10,0x1
    5680:	770d0d13          	addi	s10,s10,1904 # 1770 <copyinstr2+0x1fe>
  for(i = 0; i < NCHILD; i++){
    5684:	03400d93          	li	s11,52
    5688:	aab9                	j	57e6 <fourfiles+0x218>
      printf("fork failed\n", s);
    568a:	85e6                	mv	a1,s9
    568c:	00002517          	auipc	a0,0x2
    5690:	22c50513          	addi	a0,a0,556 # 78b8 <malloc+0xdce>
    5694:	00001097          	auipc	ra,0x1
    5698:	398080e7          	jalr	920(ra) # 6a2c <printf>
      exit(1,"");
    569c:	00003597          	auipc	a1,0x3
    56a0:	b7c58593          	addi	a1,a1,-1156 # 8218 <malloc+0x172e>
    56a4:	4505                	li	a0,1
    56a6:	00001097          	auipc	ra,0x1
    56aa:	fe6080e7          	jalr	-26(ra) # 668c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    56ae:	20200593          	li	a1,514
    56b2:	854e                	mv	a0,s3
    56b4:	00001097          	auipc	ra,0x1
    56b8:	018080e7          	jalr	24(ra) # 66cc <open>
    56bc:	892a                	mv	s2,a0
      if(fd < 0){
    56be:	04054b63          	bltz	a0,5714 <fourfiles+0x146>
      memset(buf, '0'+pi, SZ);
    56c2:	1f400613          	li	a2,500
    56c6:	0304859b          	addiw	a1,s1,48
    56ca:	00008517          	auipc	a0,0x8
    56ce:	5ae50513          	addi	a0,a0,1454 # dc78 <buf>
    56d2:	00001097          	auipc	ra,0x1
    56d6:	db6080e7          	jalr	-586(ra) # 6488 <memset>
    56da:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    56dc:	00008997          	auipc	s3,0x8
    56e0:	59c98993          	addi	s3,s3,1436 # dc78 <buf>
    56e4:	1f400613          	li	a2,500
    56e8:	85ce                	mv	a1,s3
    56ea:	854a                	mv	a0,s2
    56ec:	00001097          	auipc	ra,0x1
    56f0:	fc0080e7          	jalr	-64(ra) # 66ac <write>
    56f4:	85aa                	mv	a1,a0
    56f6:	1f400793          	li	a5,500
    56fa:	02f51f63          	bne	a0,a5,5738 <fourfiles+0x16a>
      for(i = 0; i < N; i++){
    56fe:	34fd                	addiw	s1,s1,-1
    5700:	f0f5                	bnez	s1,56e4 <fourfiles+0x116>
      exit(0,"");
    5702:	00003597          	auipc	a1,0x3
    5706:	b1658593          	addi	a1,a1,-1258 # 8218 <malloc+0x172e>
    570a:	4501                	li	a0,0
    570c:	00001097          	auipc	ra,0x1
    5710:	f80080e7          	jalr	-128(ra) # 668c <exit>
        printf("create failed\n", s);
    5714:	85e6                	mv	a1,s9
    5716:	00003517          	auipc	a0,0x3
    571a:	20250513          	addi	a0,a0,514 # 8918 <malloc+0x1e2e>
    571e:	00001097          	auipc	ra,0x1
    5722:	30e080e7          	jalr	782(ra) # 6a2c <printf>
        exit(1,"");
    5726:	00003597          	auipc	a1,0x3
    572a:	af258593          	addi	a1,a1,-1294 # 8218 <malloc+0x172e>
    572e:	4505                	li	a0,1
    5730:	00001097          	auipc	ra,0x1
    5734:	f5c080e7          	jalr	-164(ra) # 668c <exit>
          printf("write failed %d\n", n);
    5738:	00003517          	auipc	a0,0x3
    573c:	1f050513          	addi	a0,a0,496 # 8928 <malloc+0x1e3e>
    5740:	00001097          	auipc	ra,0x1
    5744:	2ec080e7          	jalr	748(ra) # 6a2c <printf>
          exit(1,"");
    5748:	00003597          	auipc	a1,0x3
    574c:	ad058593          	addi	a1,a1,-1328 # 8218 <malloc+0x172e>
    5750:	4505                	li	a0,1
    5752:	00001097          	auipc	ra,0x1
    5756:	f3a080e7          	jalr	-198(ra) # 668c <exit>
      exit(xstatus,"");
    575a:	00003597          	auipc	a1,0x3
    575e:	abe58593          	addi	a1,a1,-1346 # 8218 <malloc+0x172e>
    5762:	00001097          	auipc	ra,0x1
    5766:	f2a080e7          	jalr	-214(ra) # 668c <exit>
          printf("wrong char\n", s);
    576a:	85e6                	mv	a1,s9
    576c:	00003517          	auipc	a0,0x3
    5770:	1d450513          	addi	a0,a0,468 # 8940 <malloc+0x1e56>
    5774:	00001097          	auipc	ra,0x1
    5778:	2b8080e7          	jalr	696(ra) # 6a2c <printf>
          exit(1,"");
    577c:	00003597          	auipc	a1,0x3
    5780:	a9c58593          	addi	a1,a1,-1380 # 8218 <malloc+0x172e>
    5784:	4505                	li	a0,1
    5786:	00001097          	auipc	ra,0x1
    578a:	f06080e7          	jalr	-250(ra) # 668c <exit>
      total += n;
    578e:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    5792:	660d                	lui	a2,0x3
    5794:	85d2                	mv	a1,s4
    5796:	854e                	mv	a0,s3
    5798:	00001097          	auipc	ra,0x1
    579c:	f0c080e7          	jalr	-244(ra) # 66a4 <read>
    57a0:	02a05363          	blez	a0,57c6 <fourfiles+0x1f8>
    57a4:	00008797          	auipc	a5,0x8
    57a8:	4d478793          	addi	a5,a5,1236 # dc78 <buf>
    57ac:	fff5069b          	addiw	a3,a0,-1
    57b0:	1682                	slli	a3,a3,0x20
    57b2:	9281                	srli	a3,a3,0x20
    57b4:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    57b6:	0007c703          	lbu	a4,0(a5)
    57ba:	fa9718e3          	bne	a4,s1,576a <fourfiles+0x19c>
      for(j = 0; j < n; j++){
    57be:	0785                	addi	a5,a5,1
    57c0:	fed79be3          	bne	a5,a3,57b6 <fourfiles+0x1e8>
    57c4:	b7e9                	j	578e <fourfiles+0x1c0>
    close(fd);
    57c6:	854e                	mv	a0,s3
    57c8:	00001097          	auipc	ra,0x1
    57cc:	eec080e7          	jalr	-276(ra) # 66b4 <close>
    if(total != N*SZ){
    57d0:	03a91963          	bne	s2,s10,5802 <fourfiles+0x234>
    unlink(fname);
    57d4:	8562                	mv	a0,s8
    57d6:	00001097          	auipc	ra,0x1
    57da:	f06080e7          	jalr	-250(ra) # 66dc <unlink>
  for(i = 0; i < NCHILD; i++){
    57de:	0ba1                	addi	s7,s7,8
    57e0:	2b05                	addiw	s6,s6,1
    57e2:	05bb0263          	beq	s6,s11,5826 <fourfiles+0x258>
    fname = names[i];
    57e6:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    57ea:	4581                	li	a1,0
    57ec:	8562                	mv	a0,s8
    57ee:	00001097          	auipc	ra,0x1
    57f2:	ede080e7          	jalr	-290(ra) # 66cc <open>
    57f6:	89aa                	mv	s3,a0
    total = 0;
    57f8:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    57fc:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    5800:	bf49                	j	5792 <fourfiles+0x1c4>
      printf("wrong length %d\n", total);
    5802:	85ca                	mv	a1,s2
    5804:	00003517          	auipc	a0,0x3
    5808:	14c50513          	addi	a0,a0,332 # 8950 <malloc+0x1e66>
    580c:	00001097          	auipc	ra,0x1
    5810:	220080e7          	jalr	544(ra) # 6a2c <printf>
      exit(1,"");
    5814:	00003597          	auipc	a1,0x3
    5818:	a0458593          	addi	a1,a1,-1532 # 8218 <malloc+0x172e>
    581c:	4505                	li	a0,1
    581e:	00001097          	auipc	ra,0x1
    5822:	e6e080e7          	jalr	-402(ra) # 668c <exit>
}
    5826:	70aa                	ld	ra,168(sp)
    5828:	740a                	ld	s0,160(sp)
    582a:	64ea                	ld	s1,152(sp)
    582c:	694a                	ld	s2,144(sp)
    582e:	69aa                	ld	s3,136(sp)
    5830:	6a0a                	ld	s4,128(sp)
    5832:	7ae6                	ld	s5,120(sp)
    5834:	7b46                	ld	s6,112(sp)
    5836:	7ba6                	ld	s7,104(sp)
    5838:	7c06                	ld	s8,96(sp)
    583a:	6ce6                	ld	s9,88(sp)
    583c:	6d46                	ld	s10,80(sp)
    583e:	6da6                	ld	s11,72(sp)
    5840:	614d                	addi	sp,sp,176
    5842:	8082                	ret

0000000000005844 <concreate>:
{
    5844:	7135                	addi	sp,sp,-160
    5846:	ed06                	sd	ra,152(sp)
    5848:	e922                	sd	s0,144(sp)
    584a:	e526                	sd	s1,136(sp)
    584c:	e14a                	sd	s2,128(sp)
    584e:	fcce                	sd	s3,120(sp)
    5850:	f8d2                	sd	s4,112(sp)
    5852:	f4d6                	sd	s5,104(sp)
    5854:	f0da                	sd	s6,96(sp)
    5856:	ecde                	sd	s7,88(sp)
    5858:	1100                	addi	s0,sp,160
    585a:	89aa                	mv	s3,a0
  file[0] = 'C';
    585c:	04300793          	li	a5,67
    5860:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    5864:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    5868:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    586a:	4b0d                	li	s6,3
    586c:	4a85                	li	s5,1
      link("C0", file);
    586e:	00003b97          	auipc	s7,0x3
    5872:	0fab8b93          	addi	s7,s7,250 # 8968 <malloc+0x1e7e>
  for(i = 0; i < N; i++){
    5876:	02800a13          	li	s4,40
    587a:	ae11                	j	5b8e <concreate+0x34a>
      link("C0", file);
    587c:	fa840593          	addi	a1,s0,-88
    5880:	855e                	mv	a0,s7
    5882:	00001097          	auipc	ra,0x1
    5886:	e6a080e7          	jalr	-406(ra) # 66ec <link>
    if(pid == 0) {
    588a:	a4e5                	j	5b72 <concreate+0x32e>
    } else if(pid == 0 && (i % 5) == 1){
    588c:	4795                	li	a5,5
    588e:	02f9693b          	remw	s2,s2,a5
    5892:	4785                	li	a5,1
    5894:	02f90f63          	beq	s2,a5,58d2 <concreate+0x8e>
      fd = open(file, O_CREATE | O_RDWR);
    5898:	20200593          	li	a1,514
    589c:	fa840513          	addi	a0,s0,-88
    58a0:	00001097          	auipc	ra,0x1
    58a4:	e2c080e7          	jalr	-468(ra) # 66cc <open>
      if(fd < 0){
    58a8:	2a055c63          	bgez	a0,5b60 <concreate+0x31c>
        printf("concreate create %s failed\n", file);
    58ac:	fa840593          	addi	a1,s0,-88
    58b0:	00003517          	auipc	a0,0x3
    58b4:	0c050513          	addi	a0,a0,192 # 8970 <malloc+0x1e86>
    58b8:	00001097          	auipc	ra,0x1
    58bc:	174080e7          	jalr	372(ra) # 6a2c <printf>
        exit(1,"");
    58c0:	00003597          	auipc	a1,0x3
    58c4:	95858593          	addi	a1,a1,-1704 # 8218 <malloc+0x172e>
    58c8:	4505                	li	a0,1
    58ca:	00001097          	auipc	ra,0x1
    58ce:	dc2080e7          	jalr	-574(ra) # 668c <exit>
      link("C0", file);
    58d2:	fa840593          	addi	a1,s0,-88
    58d6:	00003517          	auipc	a0,0x3
    58da:	09250513          	addi	a0,a0,146 # 8968 <malloc+0x1e7e>
    58de:	00001097          	auipc	ra,0x1
    58e2:	e0e080e7          	jalr	-498(ra) # 66ec <link>
      exit(0,"");
    58e6:	00003597          	auipc	a1,0x3
    58ea:	93258593          	addi	a1,a1,-1742 # 8218 <malloc+0x172e>
    58ee:	4501                	li	a0,0
    58f0:	00001097          	auipc	ra,0x1
    58f4:	d9c080e7          	jalr	-612(ra) # 668c <exit>
        exit(1,"");
    58f8:	00003597          	auipc	a1,0x3
    58fc:	92058593          	addi	a1,a1,-1760 # 8218 <malloc+0x172e>
    5900:	4505                	li	a0,1
    5902:	00001097          	auipc	ra,0x1
    5906:	d8a080e7          	jalr	-630(ra) # 668c <exit>
  memset(fa, 0, sizeof(fa));
    590a:	02800613          	li	a2,40
    590e:	4581                	li	a1,0
    5910:	f8040513          	addi	a0,s0,-128
    5914:	00001097          	auipc	ra,0x1
    5918:	b74080e7          	jalr	-1164(ra) # 6488 <memset>
  fd = open(".", 0);
    591c:	4581                	li	a1,0
    591e:	00002517          	auipc	a0,0x2
    5922:	9f250513          	addi	a0,a0,-1550 # 7310 <malloc+0x826>
    5926:	00001097          	auipc	ra,0x1
    592a:	da6080e7          	jalr	-602(ra) # 66cc <open>
    592e:	892a                	mv	s2,a0
  n = 0;
    5930:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    5932:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    5936:	02700b13          	li	s6,39
      fa[i] = 1;
    593a:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    593c:	a81d                	j	5972 <concreate+0x12e>
        printf("%s: concreate weird file %s\n", s, de.name);
    593e:	f7240613          	addi	a2,s0,-142
    5942:	85ce                	mv	a1,s3
    5944:	00003517          	auipc	a0,0x3
    5948:	04c50513          	addi	a0,a0,76 # 8990 <malloc+0x1ea6>
    594c:	00001097          	auipc	ra,0x1
    5950:	0e0080e7          	jalr	224(ra) # 6a2c <printf>
        exit(1,"");
    5954:	00003597          	auipc	a1,0x3
    5958:	8c458593          	addi	a1,a1,-1852 # 8218 <malloc+0x172e>
    595c:	4505                	li	a0,1
    595e:	00001097          	auipc	ra,0x1
    5962:	d2e080e7          	jalr	-722(ra) # 668c <exit>
      fa[i] = 1;
    5966:	fb040793          	addi	a5,s0,-80
    596a:	973e                	add	a4,a4,a5
    596c:	fd770823          	sb	s7,-48(a4)
      n++;
    5970:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    5972:	4641                	li	a2,16
    5974:	f7040593          	addi	a1,s0,-144
    5978:	854a                	mv	a0,s2
    597a:	00001097          	auipc	ra,0x1
    597e:	d2a080e7          	jalr	-726(ra) # 66a4 <read>
    5982:	04a05e63          	blez	a0,59de <concreate+0x19a>
    if(de.inum == 0)
    5986:	f7045783          	lhu	a5,-144(s0)
    598a:	d7e5                	beqz	a5,5972 <concreate+0x12e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    598c:	f7244783          	lbu	a5,-142(s0)
    5990:	ff4791e3          	bne	a5,s4,5972 <concreate+0x12e>
    5994:	f7444783          	lbu	a5,-140(s0)
    5998:	ffe9                	bnez	a5,5972 <concreate+0x12e>
      i = de.name[1] - '0';
    599a:	f7344783          	lbu	a5,-141(s0)
    599e:	fd07879b          	addiw	a5,a5,-48
    59a2:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    59a6:	f8eb6ce3          	bltu	s6,a4,593e <concreate+0xfa>
      if(fa[i]){
    59aa:	fb040793          	addi	a5,s0,-80
    59ae:	97ba                	add	a5,a5,a4
    59b0:	fd07c783          	lbu	a5,-48(a5)
    59b4:	dbcd                	beqz	a5,5966 <concreate+0x122>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    59b6:	f7240613          	addi	a2,s0,-142
    59ba:	85ce                	mv	a1,s3
    59bc:	00003517          	auipc	a0,0x3
    59c0:	ff450513          	addi	a0,a0,-12 # 89b0 <malloc+0x1ec6>
    59c4:	00001097          	auipc	ra,0x1
    59c8:	068080e7          	jalr	104(ra) # 6a2c <printf>
        exit(1,"");
    59cc:	00003597          	auipc	a1,0x3
    59d0:	84c58593          	addi	a1,a1,-1972 # 8218 <malloc+0x172e>
    59d4:	4505                	li	a0,1
    59d6:	00001097          	auipc	ra,0x1
    59da:	cb6080e7          	jalr	-842(ra) # 668c <exit>
  close(fd);
    59de:	854a                	mv	a0,s2
    59e0:	00001097          	auipc	ra,0x1
    59e4:	cd4080e7          	jalr	-812(ra) # 66b4 <close>
  if(n != N){
    59e8:	02800793          	li	a5,40
    59ec:	00fa9763          	bne	s5,a5,59fa <concreate+0x1b6>
    if(((i % 3) == 0 && pid == 0) ||
    59f0:	4a8d                	li	s5,3
    59f2:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    59f4:	02800a13          	li	s4,40
    59f8:	a0d5                	j	5adc <concreate+0x298>
    printf("%s: concreate not enough files in directory listing\n", s);
    59fa:	85ce                	mv	a1,s3
    59fc:	00003517          	auipc	a0,0x3
    5a00:	fdc50513          	addi	a0,a0,-36 # 89d8 <malloc+0x1eee>
    5a04:	00001097          	auipc	ra,0x1
    5a08:	028080e7          	jalr	40(ra) # 6a2c <printf>
    exit(1,"");
    5a0c:	00003597          	auipc	a1,0x3
    5a10:	80c58593          	addi	a1,a1,-2036 # 8218 <malloc+0x172e>
    5a14:	4505                	li	a0,1
    5a16:	00001097          	auipc	ra,0x1
    5a1a:	c76080e7          	jalr	-906(ra) # 668c <exit>
      printf("%s: fork failed\n", s);
    5a1e:	85ce                	mv	a1,s3
    5a20:	00002517          	auipc	a0,0x2
    5a24:	a9050513          	addi	a0,a0,-1392 # 74b0 <malloc+0x9c6>
    5a28:	00001097          	auipc	ra,0x1
    5a2c:	004080e7          	jalr	4(ra) # 6a2c <printf>
      exit(1,"");
    5a30:	00002597          	auipc	a1,0x2
    5a34:	7e858593          	addi	a1,a1,2024 # 8218 <malloc+0x172e>
    5a38:	4505                	li	a0,1
    5a3a:	00001097          	auipc	ra,0x1
    5a3e:	c52080e7          	jalr	-942(ra) # 668c <exit>
      close(open(file, 0));
    5a42:	4581                	li	a1,0
    5a44:	fa840513          	addi	a0,s0,-88
    5a48:	00001097          	auipc	ra,0x1
    5a4c:	c84080e7          	jalr	-892(ra) # 66cc <open>
    5a50:	00001097          	auipc	ra,0x1
    5a54:	c64080e7          	jalr	-924(ra) # 66b4 <close>
      close(open(file, 0));
    5a58:	4581                	li	a1,0
    5a5a:	fa840513          	addi	a0,s0,-88
    5a5e:	00001097          	auipc	ra,0x1
    5a62:	c6e080e7          	jalr	-914(ra) # 66cc <open>
    5a66:	00001097          	auipc	ra,0x1
    5a6a:	c4e080e7          	jalr	-946(ra) # 66b4 <close>
      close(open(file, 0));
    5a6e:	4581                	li	a1,0
    5a70:	fa840513          	addi	a0,s0,-88
    5a74:	00001097          	auipc	ra,0x1
    5a78:	c58080e7          	jalr	-936(ra) # 66cc <open>
    5a7c:	00001097          	auipc	ra,0x1
    5a80:	c38080e7          	jalr	-968(ra) # 66b4 <close>
      close(open(file, 0));
    5a84:	4581                	li	a1,0
    5a86:	fa840513          	addi	a0,s0,-88
    5a8a:	00001097          	auipc	ra,0x1
    5a8e:	c42080e7          	jalr	-958(ra) # 66cc <open>
    5a92:	00001097          	auipc	ra,0x1
    5a96:	c22080e7          	jalr	-990(ra) # 66b4 <close>
      close(open(file, 0));
    5a9a:	4581                	li	a1,0
    5a9c:	fa840513          	addi	a0,s0,-88
    5aa0:	00001097          	auipc	ra,0x1
    5aa4:	c2c080e7          	jalr	-980(ra) # 66cc <open>
    5aa8:	00001097          	auipc	ra,0x1
    5aac:	c0c080e7          	jalr	-1012(ra) # 66b4 <close>
      close(open(file, 0));
    5ab0:	4581                	li	a1,0
    5ab2:	fa840513          	addi	a0,s0,-88
    5ab6:	00001097          	auipc	ra,0x1
    5aba:	c16080e7          	jalr	-1002(ra) # 66cc <open>
    5abe:	00001097          	auipc	ra,0x1
    5ac2:	bf6080e7          	jalr	-1034(ra) # 66b4 <close>
    if(pid == 0)
    5ac6:	08090463          	beqz	s2,5b4e <concreate+0x30a>
      wait(0,0);
    5aca:	4581                	li	a1,0
    5acc:	4501                	li	a0,0
    5ace:	00001097          	auipc	ra,0x1
    5ad2:	bc6080e7          	jalr	-1082(ra) # 6694 <wait>
  for(i = 0; i < N; i++){
    5ad6:	2485                	addiw	s1,s1,1
    5ad8:	0f448a63          	beq	s1,s4,5bcc <concreate+0x388>
    file[1] = '0' + i;
    5adc:	0304879b          	addiw	a5,s1,48
    5ae0:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    5ae4:	00001097          	auipc	ra,0x1
    5ae8:	ba0080e7          	jalr	-1120(ra) # 6684 <fork>
    5aec:	892a                	mv	s2,a0
    if(pid < 0){
    5aee:	f20548e3          	bltz	a0,5a1e <concreate+0x1da>
    if(((i % 3) == 0 && pid == 0) ||
    5af2:	0354e73b          	remw	a4,s1,s5
    5af6:	00a767b3          	or	a5,a4,a0
    5afa:	2781                	sext.w	a5,a5
    5afc:	d3b9                	beqz	a5,5a42 <concreate+0x1fe>
    5afe:	01671363          	bne	a4,s6,5b04 <concreate+0x2c0>
       ((i % 3) == 1 && pid != 0)){
    5b02:	f121                	bnez	a0,5a42 <concreate+0x1fe>
      unlink(file);
    5b04:	fa840513          	addi	a0,s0,-88
    5b08:	00001097          	auipc	ra,0x1
    5b0c:	bd4080e7          	jalr	-1068(ra) # 66dc <unlink>
      unlink(file);
    5b10:	fa840513          	addi	a0,s0,-88
    5b14:	00001097          	auipc	ra,0x1
    5b18:	bc8080e7          	jalr	-1080(ra) # 66dc <unlink>
      unlink(file);
    5b1c:	fa840513          	addi	a0,s0,-88
    5b20:	00001097          	auipc	ra,0x1
    5b24:	bbc080e7          	jalr	-1092(ra) # 66dc <unlink>
      unlink(file);
    5b28:	fa840513          	addi	a0,s0,-88
    5b2c:	00001097          	auipc	ra,0x1
    5b30:	bb0080e7          	jalr	-1104(ra) # 66dc <unlink>
      unlink(file);
    5b34:	fa840513          	addi	a0,s0,-88
    5b38:	00001097          	auipc	ra,0x1
    5b3c:	ba4080e7          	jalr	-1116(ra) # 66dc <unlink>
      unlink(file);
    5b40:	fa840513          	addi	a0,s0,-88
    5b44:	00001097          	auipc	ra,0x1
    5b48:	b98080e7          	jalr	-1128(ra) # 66dc <unlink>
    5b4c:	bfad                	j	5ac6 <concreate+0x282>
      exit(0,"");
    5b4e:	00002597          	auipc	a1,0x2
    5b52:	6ca58593          	addi	a1,a1,1738 # 8218 <malloc+0x172e>
    5b56:	4501                	li	a0,0
    5b58:	00001097          	auipc	ra,0x1
    5b5c:	b34080e7          	jalr	-1228(ra) # 668c <exit>
      close(fd);
    5b60:	00001097          	auipc	ra,0x1
    5b64:	b54080e7          	jalr	-1196(ra) # 66b4 <close>
    if(pid == 0) {
    5b68:	bbbd                	j	58e6 <concreate+0xa2>
      close(fd);
    5b6a:	00001097          	auipc	ra,0x1
    5b6e:	b4a080e7          	jalr	-1206(ra) # 66b4 <close>
      wait(&xstatus,0);
    5b72:	4581                	li	a1,0
    5b74:	f6c40513          	addi	a0,s0,-148
    5b78:	00001097          	auipc	ra,0x1
    5b7c:	b1c080e7          	jalr	-1252(ra) # 6694 <wait>
      if(xstatus != 0)
    5b80:	f6c42483          	lw	s1,-148(s0)
    5b84:	d6049ae3          	bnez	s1,58f8 <concreate+0xb4>
  for(i = 0; i < N; i++){
    5b88:	2905                	addiw	s2,s2,1
    5b8a:	d94900e3          	beq	s2,s4,590a <concreate+0xc6>
    file[1] = '0' + i;
    5b8e:	0309079b          	addiw	a5,s2,48
    5b92:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5b96:	fa840513          	addi	a0,s0,-88
    5b9a:	00001097          	auipc	ra,0x1
    5b9e:	b42080e7          	jalr	-1214(ra) # 66dc <unlink>
    pid = fork();
    5ba2:	00001097          	auipc	ra,0x1
    5ba6:	ae2080e7          	jalr	-1310(ra) # 6684 <fork>
    if(pid && (i % 3) == 1){
    5baa:	ce0501e3          	beqz	a0,588c <concreate+0x48>
    5bae:	036967bb          	remw	a5,s2,s6
    5bb2:	cd5785e3          	beq	a5,s5,587c <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5bb6:	20200593          	li	a1,514
    5bba:	fa840513          	addi	a0,s0,-88
    5bbe:	00001097          	auipc	ra,0x1
    5bc2:	b0e080e7          	jalr	-1266(ra) # 66cc <open>
      if(fd < 0){
    5bc6:	fa0552e3          	bgez	a0,5b6a <concreate+0x326>
    5bca:	b1cd                	j	58ac <concreate+0x68>
}
    5bcc:	60ea                	ld	ra,152(sp)
    5bce:	644a                	ld	s0,144(sp)
    5bd0:	64aa                	ld	s1,136(sp)
    5bd2:	690a                	ld	s2,128(sp)
    5bd4:	79e6                	ld	s3,120(sp)
    5bd6:	7a46                	ld	s4,112(sp)
    5bd8:	7aa6                	ld	s5,104(sp)
    5bda:	7b06                	ld	s6,96(sp)
    5bdc:	6be6                	ld	s7,88(sp)
    5bde:	610d                	addi	sp,sp,160
    5be0:	8082                	ret

0000000000005be2 <bigfile>:
{
    5be2:	7139                	addi	sp,sp,-64
    5be4:	fc06                	sd	ra,56(sp)
    5be6:	f822                	sd	s0,48(sp)
    5be8:	f426                	sd	s1,40(sp)
    5bea:	f04a                	sd	s2,32(sp)
    5bec:	ec4e                	sd	s3,24(sp)
    5bee:	e852                	sd	s4,16(sp)
    5bf0:	e456                	sd	s5,8(sp)
    5bf2:	0080                	addi	s0,sp,64
    5bf4:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    5bf6:	00003517          	auipc	a0,0x3
    5bfa:	e1a50513          	addi	a0,a0,-486 # 8a10 <malloc+0x1f26>
    5bfe:	00001097          	auipc	ra,0x1
    5c02:	ade080e7          	jalr	-1314(ra) # 66dc <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    5c06:	20200593          	li	a1,514
    5c0a:	00003517          	auipc	a0,0x3
    5c0e:	e0650513          	addi	a0,a0,-506 # 8a10 <malloc+0x1f26>
    5c12:	00001097          	auipc	ra,0x1
    5c16:	aba080e7          	jalr	-1350(ra) # 66cc <open>
    5c1a:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5c1c:	4481                	li	s1,0
    memset(buf, i, SZ);
    5c1e:	00008917          	auipc	s2,0x8
    5c22:	05a90913          	addi	s2,s2,90 # dc78 <buf>
  for(i = 0; i < N; i++){
    5c26:	4a51                	li	s4,20
  if(fd < 0){
    5c28:	0a054163          	bltz	a0,5cca <bigfile+0xe8>
    memset(buf, i, SZ);
    5c2c:	25800613          	li	a2,600
    5c30:	85a6                	mv	a1,s1
    5c32:	854a                	mv	a0,s2
    5c34:	00001097          	auipc	ra,0x1
    5c38:	854080e7          	jalr	-1964(ra) # 6488 <memset>
    if(write(fd, buf, SZ) != SZ){
    5c3c:	25800613          	li	a2,600
    5c40:	85ca                	mv	a1,s2
    5c42:	854e                	mv	a0,s3
    5c44:	00001097          	auipc	ra,0x1
    5c48:	a68080e7          	jalr	-1432(ra) # 66ac <write>
    5c4c:	25800793          	li	a5,600
    5c50:	08f51f63          	bne	a0,a5,5cee <bigfile+0x10c>
  for(i = 0; i < N; i++){
    5c54:	2485                	addiw	s1,s1,1
    5c56:	fd449be3          	bne	s1,s4,5c2c <bigfile+0x4a>
  close(fd);
    5c5a:	854e                	mv	a0,s3
    5c5c:	00001097          	auipc	ra,0x1
    5c60:	a58080e7          	jalr	-1448(ra) # 66b4 <close>
  fd = open("bigfile.dat", 0);
    5c64:	4581                	li	a1,0
    5c66:	00003517          	auipc	a0,0x3
    5c6a:	daa50513          	addi	a0,a0,-598 # 8a10 <malloc+0x1f26>
    5c6e:	00001097          	auipc	ra,0x1
    5c72:	a5e080e7          	jalr	-1442(ra) # 66cc <open>
    5c76:	8a2a                	mv	s4,a0
  total = 0;
    5c78:	4981                	li	s3,0
  for(i = 0; ; i++){
    5c7a:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5c7c:	00008917          	auipc	s2,0x8
    5c80:	ffc90913          	addi	s2,s2,-4 # dc78 <buf>
  if(fd < 0){
    5c84:	08054763          	bltz	a0,5d12 <bigfile+0x130>
    cc = read(fd, buf, SZ/2);
    5c88:	12c00613          	li	a2,300
    5c8c:	85ca                	mv	a1,s2
    5c8e:	8552                	mv	a0,s4
    5c90:	00001097          	auipc	ra,0x1
    5c94:	a14080e7          	jalr	-1516(ra) # 66a4 <read>
    if(cc < 0){
    5c98:	08054f63          	bltz	a0,5d36 <bigfile+0x154>
    if(cc == 0)
    5c9c:	10050363          	beqz	a0,5da2 <bigfile+0x1c0>
    if(cc != SZ/2){
    5ca0:	12c00793          	li	a5,300
    5ca4:	0af51b63          	bne	a0,a5,5d5a <bigfile+0x178>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5ca8:	01f4d79b          	srliw	a5,s1,0x1f
    5cac:	9fa5                	addw	a5,a5,s1
    5cae:	4017d79b          	sraiw	a5,a5,0x1
    5cb2:	00094703          	lbu	a4,0(s2)
    5cb6:	0cf71463          	bne	a4,a5,5d7e <bigfile+0x19c>
    5cba:	12b94703          	lbu	a4,299(s2)
    5cbe:	0cf71063          	bne	a4,a5,5d7e <bigfile+0x19c>
    total += cc;
    5cc2:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    5cc6:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    5cc8:	b7c1                	j	5c88 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5cca:	85d6                	mv	a1,s5
    5ccc:	00003517          	auipc	a0,0x3
    5cd0:	d5450513          	addi	a0,a0,-684 # 8a20 <malloc+0x1f36>
    5cd4:	00001097          	auipc	ra,0x1
    5cd8:	d58080e7          	jalr	-680(ra) # 6a2c <printf>
    exit(1,"");
    5cdc:	00002597          	auipc	a1,0x2
    5ce0:	53c58593          	addi	a1,a1,1340 # 8218 <malloc+0x172e>
    5ce4:	4505                	li	a0,1
    5ce6:	00001097          	auipc	ra,0x1
    5cea:	9a6080e7          	jalr	-1626(ra) # 668c <exit>
      printf("%s: write bigfile failed\n", s);
    5cee:	85d6                	mv	a1,s5
    5cf0:	00003517          	auipc	a0,0x3
    5cf4:	d5050513          	addi	a0,a0,-688 # 8a40 <malloc+0x1f56>
    5cf8:	00001097          	auipc	ra,0x1
    5cfc:	d34080e7          	jalr	-716(ra) # 6a2c <printf>
      exit(1,"");
    5d00:	00002597          	auipc	a1,0x2
    5d04:	51858593          	addi	a1,a1,1304 # 8218 <malloc+0x172e>
    5d08:	4505                	li	a0,1
    5d0a:	00001097          	auipc	ra,0x1
    5d0e:	982080e7          	jalr	-1662(ra) # 668c <exit>
    printf("%s: cannot open bigfile\n", s);
    5d12:	85d6                	mv	a1,s5
    5d14:	00003517          	auipc	a0,0x3
    5d18:	d4c50513          	addi	a0,a0,-692 # 8a60 <malloc+0x1f76>
    5d1c:	00001097          	auipc	ra,0x1
    5d20:	d10080e7          	jalr	-752(ra) # 6a2c <printf>
    exit(1,"");
    5d24:	00002597          	auipc	a1,0x2
    5d28:	4f458593          	addi	a1,a1,1268 # 8218 <malloc+0x172e>
    5d2c:	4505                	li	a0,1
    5d2e:	00001097          	auipc	ra,0x1
    5d32:	95e080e7          	jalr	-1698(ra) # 668c <exit>
      printf("%s: read bigfile failed\n", s);
    5d36:	85d6                	mv	a1,s5
    5d38:	00003517          	auipc	a0,0x3
    5d3c:	d4850513          	addi	a0,a0,-696 # 8a80 <malloc+0x1f96>
    5d40:	00001097          	auipc	ra,0x1
    5d44:	cec080e7          	jalr	-788(ra) # 6a2c <printf>
      exit(1,"");
    5d48:	00002597          	auipc	a1,0x2
    5d4c:	4d058593          	addi	a1,a1,1232 # 8218 <malloc+0x172e>
    5d50:	4505                	li	a0,1
    5d52:	00001097          	auipc	ra,0x1
    5d56:	93a080e7          	jalr	-1734(ra) # 668c <exit>
      printf("%s: short read bigfile\n", s);
    5d5a:	85d6                	mv	a1,s5
    5d5c:	00003517          	auipc	a0,0x3
    5d60:	d4450513          	addi	a0,a0,-700 # 8aa0 <malloc+0x1fb6>
    5d64:	00001097          	auipc	ra,0x1
    5d68:	cc8080e7          	jalr	-824(ra) # 6a2c <printf>
      exit(1,"");
    5d6c:	00002597          	auipc	a1,0x2
    5d70:	4ac58593          	addi	a1,a1,1196 # 8218 <malloc+0x172e>
    5d74:	4505                	li	a0,1
    5d76:	00001097          	auipc	ra,0x1
    5d7a:	916080e7          	jalr	-1770(ra) # 668c <exit>
      printf("%s: read bigfile wrong data\n", s);
    5d7e:	85d6                	mv	a1,s5
    5d80:	00003517          	auipc	a0,0x3
    5d84:	d3850513          	addi	a0,a0,-712 # 8ab8 <malloc+0x1fce>
    5d88:	00001097          	auipc	ra,0x1
    5d8c:	ca4080e7          	jalr	-860(ra) # 6a2c <printf>
      exit(1,"");
    5d90:	00002597          	auipc	a1,0x2
    5d94:	48858593          	addi	a1,a1,1160 # 8218 <malloc+0x172e>
    5d98:	4505                	li	a0,1
    5d9a:	00001097          	auipc	ra,0x1
    5d9e:	8f2080e7          	jalr	-1806(ra) # 668c <exit>
  close(fd);
    5da2:	8552                	mv	a0,s4
    5da4:	00001097          	auipc	ra,0x1
    5da8:	910080e7          	jalr	-1776(ra) # 66b4 <close>
  if(total != N*SZ){
    5dac:	678d                	lui	a5,0x3
    5dae:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrkbasic+0x120>
    5db2:	02f99363          	bne	s3,a5,5dd8 <bigfile+0x1f6>
  unlink("bigfile.dat");
    5db6:	00003517          	auipc	a0,0x3
    5dba:	c5a50513          	addi	a0,a0,-934 # 8a10 <malloc+0x1f26>
    5dbe:	00001097          	auipc	ra,0x1
    5dc2:	91e080e7          	jalr	-1762(ra) # 66dc <unlink>
}
    5dc6:	70e2                	ld	ra,56(sp)
    5dc8:	7442                	ld	s0,48(sp)
    5dca:	74a2                	ld	s1,40(sp)
    5dcc:	7902                	ld	s2,32(sp)
    5dce:	69e2                	ld	s3,24(sp)
    5dd0:	6a42                	ld	s4,16(sp)
    5dd2:	6aa2                	ld	s5,8(sp)
    5dd4:	6121                	addi	sp,sp,64
    5dd6:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5dd8:	85d6                	mv	a1,s5
    5dda:	00003517          	auipc	a0,0x3
    5dde:	cfe50513          	addi	a0,a0,-770 # 8ad8 <malloc+0x1fee>
    5de2:	00001097          	auipc	ra,0x1
    5de6:	c4a080e7          	jalr	-950(ra) # 6a2c <printf>
    exit(1,"");
    5dea:	00002597          	auipc	a1,0x2
    5dee:	42e58593          	addi	a1,a1,1070 # 8218 <malloc+0x172e>
    5df2:	4505                	li	a0,1
    5df4:	00001097          	auipc	ra,0x1
    5df8:	898080e7          	jalr	-1896(ra) # 668c <exit>

0000000000005dfc <fsfull>:
{
    5dfc:	7171                	addi	sp,sp,-176
    5dfe:	f506                	sd	ra,168(sp)
    5e00:	f122                	sd	s0,160(sp)
    5e02:	ed26                	sd	s1,152(sp)
    5e04:	e94a                	sd	s2,144(sp)
    5e06:	e54e                	sd	s3,136(sp)
    5e08:	e152                	sd	s4,128(sp)
    5e0a:	fcd6                	sd	s5,120(sp)
    5e0c:	f8da                	sd	s6,112(sp)
    5e0e:	f4de                	sd	s7,104(sp)
    5e10:	f0e2                	sd	s8,96(sp)
    5e12:	ece6                	sd	s9,88(sp)
    5e14:	e8ea                	sd	s10,80(sp)
    5e16:	e4ee                	sd	s11,72(sp)
    5e18:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    5e1a:	00003517          	auipc	a0,0x3
    5e1e:	cde50513          	addi	a0,a0,-802 # 8af8 <malloc+0x200e>
    5e22:	00001097          	auipc	ra,0x1
    5e26:	c0a080e7          	jalr	-1014(ra) # 6a2c <printf>
  for(nfiles = 0; ; nfiles++){
    5e2a:	4481                	li	s1,0
    name[0] = 'f';
    5e2c:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    5e30:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5e34:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5e38:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5e3a:	00003c97          	auipc	s9,0x3
    5e3e:	ccec8c93          	addi	s9,s9,-818 # 8b08 <malloc+0x201e>
    int total = 0;
    5e42:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    5e44:	00008a17          	auipc	s4,0x8
    5e48:	e34a0a13          	addi	s4,s4,-460 # dc78 <buf>
    name[0] = 'f';
    5e4c:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5e50:	0384c7bb          	divw	a5,s1,s8
    5e54:	0307879b          	addiw	a5,a5,48
    5e58:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5e5c:	0384e7bb          	remw	a5,s1,s8
    5e60:	0377c7bb          	divw	a5,a5,s7
    5e64:	0307879b          	addiw	a5,a5,48
    5e68:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5e6c:	0374e7bb          	remw	a5,s1,s7
    5e70:	0367c7bb          	divw	a5,a5,s6
    5e74:	0307879b          	addiw	a5,a5,48
    5e78:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5e7c:	0364e7bb          	remw	a5,s1,s6
    5e80:	0307879b          	addiw	a5,a5,48
    5e84:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5e88:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5e8c:	f5040593          	addi	a1,s0,-176
    5e90:	8566                	mv	a0,s9
    5e92:	00001097          	auipc	ra,0x1
    5e96:	b9a080e7          	jalr	-1126(ra) # 6a2c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    5e9a:	20200593          	li	a1,514
    5e9e:	f5040513          	addi	a0,s0,-176
    5ea2:	00001097          	auipc	ra,0x1
    5ea6:	82a080e7          	jalr	-2006(ra) # 66cc <open>
    5eaa:	892a                	mv	s2,a0
    if(fd < 0){
    5eac:	0a055663          	bgez	a0,5f58 <fsfull+0x15c>
      printf("open %s failed\n", name);
    5eb0:	f5040593          	addi	a1,s0,-176
    5eb4:	00003517          	auipc	a0,0x3
    5eb8:	c6450513          	addi	a0,a0,-924 # 8b18 <malloc+0x202e>
    5ebc:	00001097          	auipc	ra,0x1
    5ec0:	b70080e7          	jalr	-1168(ra) # 6a2c <printf>
  while(nfiles >= 0){
    5ec4:	0604c363          	bltz	s1,5f2a <fsfull+0x12e>
    name[0] = 'f';
    5ec8:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    5ecc:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5ed0:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5ed4:	4929                	li	s2,10
  while(nfiles >= 0){
    5ed6:	5afd                	li	s5,-1
    name[0] = 'f';
    5ed8:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5edc:	0344c7bb          	divw	a5,s1,s4
    5ee0:	0307879b          	addiw	a5,a5,48
    5ee4:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5ee8:	0344e7bb          	remw	a5,s1,s4
    5eec:	0337c7bb          	divw	a5,a5,s3
    5ef0:	0307879b          	addiw	a5,a5,48
    5ef4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5ef8:	0334e7bb          	remw	a5,s1,s3
    5efc:	0327c7bb          	divw	a5,a5,s2
    5f00:	0307879b          	addiw	a5,a5,48
    5f04:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5f08:	0324e7bb          	remw	a5,s1,s2
    5f0c:	0307879b          	addiw	a5,a5,48
    5f10:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5f14:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5f18:	f5040513          	addi	a0,s0,-176
    5f1c:	00000097          	auipc	ra,0x0
    5f20:	7c0080e7          	jalr	1984(ra) # 66dc <unlink>
    nfiles--;
    5f24:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5f26:	fb5499e3          	bne	s1,s5,5ed8 <fsfull+0xdc>
  printf("fsfull test finished\n");
    5f2a:	00003517          	auipc	a0,0x3
    5f2e:	c0e50513          	addi	a0,a0,-1010 # 8b38 <malloc+0x204e>
    5f32:	00001097          	auipc	ra,0x1
    5f36:	afa080e7          	jalr	-1286(ra) # 6a2c <printf>
}
    5f3a:	70aa                	ld	ra,168(sp)
    5f3c:	740a                	ld	s0,160(sp)
    5f3e:	64ea                	ld	s1,152(sp)
    5f40:	694a                	ld	s2,144(sp)
    5f42:	69aa                	ld	s3,136(sp)
    5f44:	6a0a                	ld	s4,128(sp)
    5f46:	7ae6                	ld	s5,120(sp)
    5f48:	7b46                	ld	s6,112(sp)
    5f4a:	7ba6                	ld	s7,104(sp)
    5f4c:	7c06                	ld	s8,96(sp)
    5f4e:	6ce6                	ld	s9,88(sp)
    5f50:	6d46                	ld	s10,80(sp)
    5f52:	6da6                	ld	s11,72(sp)
    5f54:	614d                	addi	sp,sp,176
    5f56:	8082                	ret
    int total = 0;
    5f58:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    5f5a:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    5f5e:	40000613          	li	a2,1024
    5f62:	85d2                	mv	a1,s4
    5f64:	854a                	mv	a0,s2
    5f66:	00000097          	auipc	ra,0x0
    5f6a:	746080e7          	jalr	1862(ra) # 66ac <write>
      if(cc < BSIZE)
    5f6e:	00aad563          	bge	s5,a0,5f78 <fsfull+0x17c>
      total += cc;
    5f72:	00a989bb          	addw	s3,s3,a0
    while(1){
    5f76:	b7e5                	j	5f5e <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5f78:	85ce                	mv	a1,s3
    5f7a:	00003517          	auipc	a0,0x3
    5f7e:	bae50513          	addi	a0,a0,-1106 # 8b28 <malloc+0x203e>
    5f82:	00001097          	auipc	ra,0x1
    5f86:	aaa080e7          	jalr	-1366(ra) # 6a2c <printf>
    close(fd);
    5f8a:	854a                	mv	a0,s2
    5f8c:	00000097          	auipc	ra,0x0
    5f90:	728080e7          	jalr	1832(ra) # 66b4 <close>
    if(total == 0)
    5f94:	f20988e3          	beqz	s3,5ec4 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5f98:	2485                	addiw	s1,s1,1
    5f9a:	bd4d                	j	5e4c <fsfull+0x50>

0000000000005f9c <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5f9c:	7179                	addi	sp,sp,-48
    5f9e:	f406                	sd	ra,40(sp)
    5fa0:	f022                	sd	s0,32(sp)
    5fa2:	ec26                	sd	s1,24(sp)
    5fa4:	e84a                	sd	s2,16(sp)
    5fa6:	1800                	addi	s0,sp,48
    5fa8:	84aa                	mv	s1,a0
    5faa:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5fac:	00003517          	auipc	a0,0x3
    5fb0:	ba450513          	addi	a0,a0,-1116 # 8b50 <malloc+0x2066>
    5fb4:	00001097          	auipc	ra,0x1
    5fb8:	a78080e7          	jalr	-1416(ra) # 6a2c <printf>
  if((pid = fork()) < 0) {
    5fbc:	00000097          	auipc	ra,0x0
    5fc0:	6c8080e7          	jalr	1736(ra) # 6684 <fork>
    5fc4:	02054f63          	bltz	a0,6002 <run+0x66>
    printf("runtest: fork error\n");
    exit(1,"");
  }
  if(pid == 0) {
    5fc8:	cd31                	beqz	a0,6024 <run+0x88>
    f(s);
    exit(0,"");
  } else {
    wait(&xstatus,0);
    5fca:	4581                	li	a1,0
    5fcc:	fdc40513          	addi	a0,s0,-36
    5fd0:	00000097          	auipc	ra,0x0
    5fd4:	6c4080e7          	jalr	1732(ra) # 6694 <wait>
    if(xstatus != 0) 
    5fd8:	fdc42783          	lw	a5,-36(s0)
    5fdc:	cfb9                	beqz	a5,603a <run+0x9e>
      printf("FAILED\n");
    5fde:	00003517          	auipc	a0,0x3
    5fe2:	b9a50513          	addi	a0,a0,-1126 # 8b78 <malloc+0x208e>
    5fe6:	00001097          	auipc	ra,0x1
    5fea:	a46080e7          	jalr	-1466(ra) # 6a2c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5fee:	fdc42503          	lw	a0,-36(s0)
  }
}
    5ff2:	00153513          	seqz	a0,a0
    5ff6:	70a2                	ld	ra,40(sp)
    5ff8:	7402                	ld	s0,32(sp)
    5ffa:	64e2                	ld	s1,24(sp)
    5ffc:	6942                	ld	s2,16(sp)
    5ffe:	6145                	addi	sp,sp,48
    6000:	8082                	ret
    printf("runtest: fork error\n");
    6002:	00003517          	auipc	a0,0x3
    6006:	b5e50513          	addi	a0,a0,-1186 # 8b60 <malloc+0x2076>
    600a:	00001097          	auipc	ra,0x1
    600e:	a22080e7          	jalr	-1502(ra) # 6a2c <printf>
    exit(1,"");
    6012:	00002597          	auipc	a1,0x2
    6016:	20658593          	addi	a1,a1,518 # 8218 <malloc+0x172e>
    601a:	4505                	li	a0,1
    601c:	00000097          	auipc	ra,0x0
    6020:	670080e7          	jalr	1648(ra) # 668c <exit>
    f(s);
    6024:	854a                	mv	a0,s2
    6026:	9482                	jalr	s1
    exit(0,"");
    6028:	00002597          	auipc	a1,0x2
    602c:	1f058593          	addi	a1,a1,496 # 8218 <malloc+0x172e>
    6030:	4501                	li	a0,0
    6032:	00000097          	auipc	ra,0x0
    6036:	65a080e7          	jalr	1626(ra) # 668c <exit>
      printf("OK\n");
    603a:	00003517          	auipc	a0,0x3
    603e:	b4650513          	addi	a0,a0,-1210 # 8b80 <malloc+0x2096>
    6042:	00001097          	auipc	ra,0x1
    6046:	9ea080e7          	jalr	-1558(ra) # 6a2c <printf>
    604a:	b755                	j	5fee <run+0x52>

000000000000604c <runtests>:

int
runtests(struct test *tests, char *justone) {
    604c:	1101                	addi	sp,sp,-32
    604e:	ec06                	sd	ra,24(sp)
    6050:	e822                	sd	s0,16(sp)
    6052:	e426                	sd	s1,8(sp)
    6054:	e04a                	sd	s2,0(sp)
    6056:	1000                	addi	s0,sp,32
    6058:	84aa                	mv	s1,a0
    605a:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    605c:	6508                	ld	a0,8(a0)
    605e:	ed09                	bnez	a0,6078 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    6060:	4501                	li	a0,0
    6062:	a82d                	j	609c <runtests+0x50>
      if(!run(t->f, t->s)){
    6064:	648c                	ld	a1,8(s1)
    6066:	6088                	ld	a0,0(s1)
    6068:	00000097          	auipc	ra,0x0
    606c:	f34080e7          	jalr	-204(ra) # 5f9c <run>
    6070:	cd09                	beqz	a0,608a <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    6072:	04c1                	addi	s1,s1,16
    6074:	6488                	ld	a0,8(s1)
    6076:	c11d                	beqz	a0,609c <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    6078:	fe0906e3          	beqz	s2,6064 <runtests+0x18>
    607c:	85ca                	mv	a1,s2
    607e:	00000097          	auipc	ra,0x0
    6082:	3b4080e7          	jalr	948(ra) # 6432 <strcmp>
    6086:	f575                	bnez	a0,6072 <runtests+0x26>
    6088:	bff1                	j	6064 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    608a:	00003517          	auipc	a0,0x3
    608e:	afe50513          	addi	a0,a0,-1282 # 8b88 <malloc+0x209e>
    6092:	00001097          	auipc	ra,0x1
    6096:	99a080e7          	jalr	-1638(ra) # 6a2c <printf>
        return 1;
    609a:	4505                	li	a0,1
}
    609c:	60e2                	ld	ra,24(sp)
    609e:	6442                	ld	s0,16(sp)
    60a0:	64a2                	ld	s1,8(sp)
    60a2:	6902                	ld	s2,0(sp)
    60a4:	6105                	addi	sp,sp,32
    60a6:	8082                	ret

00000000000060a8 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    60a8:	7139                	addi	sp,sp,-64
    60aa:	fc06                	sd	ra,56(sp)
    60ac:	f822                	sd	s0,48(sp)
    60ae:	f426                	sd	s1,40(sp)
    60b0:	f04a                	sd	s2,32(sp)
    60b2:	ec4e                	sd	s3,24(sp)
    60b4:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    60b6:	fc840513          	addi	a0,s0,-56
    60ba:	00000097          	auipc	ra,0x0
    60be:	5e2080e7          	jalr	1506(ra) # 669c <pipe>
    60c2:	06054c63          	bltz	a0,613a <countfree+0x92>
    printf("pipe() failed in countfree()\n");
    exit(1,"");
  }
  
  int pid = fork();
    60c6:	00000097          	auipc	ra,0x0
    60ca:	5be080e7          	jalr	1470(ra) # 6684 <fork>

  if(pid < 0){
    60ce:	08054763          	bltz	a0,615c <countfree+0xb4>
    printf("fork failed in countfree()\n");
    exit(1,"");
  }

  if(pid == 0){
    60d2:	ed5d                	bnez	a0,6190 <countfree+0xe8>
    close(fds[0]);
    60d4:	fc842503          	lw	a0,-56(s0)
    60d8:	00000097          	auipc	ra,0x0
    60dc:	5dc080e7          	jalr	1500(ra) # 66b4 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    60e0:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    60e2:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    60e4:	00001917          	auipc	s2,0x1
    60e8:	bb490913          	addi	s2,s2,-1100 # 6c98 <malloc+0x1ae>
      uint64 a = (uint64) sbrk(4096);
    60ec:	6505                	lui	a0,0x1
    60ee:	00000097          	auipc	ra,0x0
    60f2:	626080e7          	jalr	1574(ra) # 6714 <sbrk>
      if(a == 0xffffffffffffffff){
    60f6:	08950463          	beq	a0,s1,617e <countfree+0xd6>
      *(char *)(a + 4096 - 1) = 1;
    60fa:	6785                	lui	a5,0x1
    60fc:	953e                	add	a0,a0,a5
    60fe:	ff350fa3          	sb	s3,-1(a0) # fff <unlinkread+0x187>
      if(write(fds[1], "x", 1) != 1){
    6102:	4605                	li	a2,1
    6104:	85ca                	mv	a1,s2
    6106:	fcc42503          	lw	a0,-52(s0)
    610a:	00000097          	auipc	ra,0x0
    610e:	5a2080e7          	jalr	1442(ra) # 66ac <write>
    6112:	4785                	li	a5,1
    6114:	fcf50ce3          	beq	a0,a5,60ec <countfree+0x44>
        printf("write() failed in countfree()\n");
    6118:	00003517          	auipc	a0,0x3
    611c:	ac850513          	addi	a0,a0,-1336 # 8be0 <malloc+0x20f6>
    6120:	00001097          	auipc	ra,0x1
    6124:	90c080e7          	jalr	-1780(ra) # 6a2c <printf>
        exit(1,"");
    6128:	00002597          	auipc	a1,0x2
    612c:	0f058593          	addi	a1,a1,240 # 8218 <malloc+0x172e>
    6130:	4505                	li	a0,1
    6132:	00000097          	auipc	ra,0x0
    6136:	55a080e7          	jalr	1370(ra) # 668c <exit>
    printf("pipe() failed in countfree()\n");
    613a:	00003517          	auipc	a0,0x3
    613e:	a6650513          	addi	a0,a0,-1434 # 8ba0 <malloc+0x20b6>
    6142:	00001097          	auipc	ra,0x1
    6146:	8ea080e7          	jalr	-1814(ra) # 6a2c <printf>
    exit(1,"");
    614a:	00002597          	auipc	a1,0x2
    614e:	0ce58593          	addi	a1,a1,206 # 8218 <malloc+0x172e>
    6152:	4505                	li	a0,1
    6154:	00000097          	auipc	ra,0x0
    6158:	538080e7          	jalr	1336(ra) # 668c <exit>
    printf("fork failed in countfree()\n");
    615c:	00003517          	auipc	a0,0x3
    6160:	a6450513          	addi	a0,a0,-1436 # 8bc0 <malloc+0x20d6>
    6164:	00001097          	auipc	ra,0x1
    6168:	8c8080e7          	jalr	-1848(ra) # 6a2c <printf>
    exit(1,"");
    616c:	00002597          	auipc	a1,0x2
    6170:	0ac58593          	addi	a1,a1,172 # 8218 <malloc+0x172e>
    6174:	4505                	li	a0,1
    6176:	00000097          	auipc	ra,0x0
    617a:	516080e7          	jalr	1302(ra) # 668c <exit>
      }
    }

    exit(0,"");
    617e:	00002597          	auipc	a1,0x2
    6182:	09a58593          	addi	a1,a1,154 # 8218 <malloc+0x172e>
    6186:	4501                	li	a0,0
    6188:	00000097          	auipc	ra,0x0
    618c:	504080e7          	jalr	1284(ra) # 668c <exit>
  }

  close(fds[1]);
    6190:	fcc42503          	lw	a0,-52(s0)
    6194:	00000097          	auipc	ra,0x0
    6198:	520080e7          	jalr	1312(ra) # 66b4 <close>

  int n = 0;
    619c:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    619e:	4605                	li	a2,1
    61a0:	fc740593          	addi	a1,s0,-57
    61a4:	fc842503          	lw	a0,-56(s0)
    61a8:	00000097          	auipc	ra,0x0
    61ac:	4fc080e7          	jalr	1276(ra) # 66a4 <read>
    if(cc < 0){
    61b0:	00054563          	bltz	a0,61ba <countfree+0x112>
      printf("read() failed in countfree()\n");
      exit(1,"");
    }
    if(cc == 0)
    61b4:	c505                	beqz	a0,61dc <countfree+0x134>
      break;
    n += 1;
    61b6:	2485                	addiw	s1,s1,1
  while(1){
    61b8:	b7dd                	j	619e <countfree+0xf6>
      printf("read() failed in countfree()\n");
    61ba:	00003517          	auipc	a0,0x3
    61be:	a4650513          	addi	a0,a0,-1466 # 8c00 <malloc+0x2116>
    61c2:	00001097          	auipc	ra,0x1
    61c6:	86a080e7          	jalr	-1942(ra) # 6a2c <printf>
      exit(1,"");
    61ca:	00002597          	auipc	a1,0x2
    61ce:	04e58593          	addi	a1,a1,78 # 8218 <malloc+0x172e>
    61d2:	4505                	li	a0,1
    61d4:	00000097          	auipc	ra,0x0
    61d8:	4b8080e7          	jalr	1208(ra) # 668c <exit>
  }

  close(fds[0]);
    61dc:	fc842503          	lw	a0,-56(s0)
    61e0:	00000097          	auipc	ra,0x0
    61e4:	4d4080e7          	jalr	1236(ra) # 66b4 <close>
  wait((int*)0,0);
    61e8:	4581                	li	a1,0
    61ea:	4501                	li	a0,0
    61ec:	00000097          	auipc	ra,0x0
    61f0:	4a8080e7          	jalr	1192(ra) # 6694 <wait>
  
  return n;
}
    61f4:	8526                	mv	a0,s1
    61f6:	70e2                	ld	ra,56(sp)
    61f8:	7442                	ld	s0,48(sp)
    61fa:	74a2                	ld	s1,40(sp)
    61fc:	7902                	ld	s2,32(sp)
    61fe:	69e2                	ld	s3,24(sp)
    6200:	6121                	addi	sp,sp,64
    6202:	8082                	ret

0000000000006204 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    6204:	711d                	addi	sp,sp,-96
    6206:	ec86                	sd	ra,88(sp)
    6208:	e8a2                	sd	s0,80(sp)
    620a:	e4a6                	sd	s1,72(sp)
    620c:	e0ca                	sd	s2,64(sp)
    620e:	fc4e                	sd	s3,56(sp)
    6210:	f852                	sd	s4,48(sp)
    6212:	f456                	sd	s5,40(sp)
    6214:	f05a                	sd	s6,32(sp)
    6216:	ec5e                	sd	s7,24(sp)
    6218:	e862                	sd	s8,16(sp)
    621a:	e466                	sd	s9,8(sp)
    621c:	e06a                	sd	s10,0(sp)
    621e:	1080                	addi	s0,sp,96
    6220:	8a2a                	mv	s4,a0
    6222:	89ae                	mv	s3,a1
    6224:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    6226:	00003b97          	auipc	s7,0x3
    622a:	9fab8b93          	addi	s7,s7,-1542 # 8c20 <malloc+0x2136>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    622e:	00004b17          	auipc	s6,0x4
    6232:	de2b0b13          	addi	s6,s6,-542 # a010 <quicktests>
      if(continuous != 2) {
    6236:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    6238:	00003c97          	auipc	s9,0x3
    623c:	a20c8c93          	addi	s9,s9,-1504 # 8c58 <malloc+0x216e>
      if (runtests(slowtests, justone)) {
    6240:	00004c17          	auipc	s8,0x4
    6244:	1a0c0c13          	addi	s8,s8,416 # a3e0 <slowtests>
        printf("usertests slow tests starting\n");
    6248:	00003d17          	auipc	s10,0x3
    624c:	9f0d0d13          	addi	s10,s10,-1552 # 8c38 <malloc+0x214e>
    6250:	a839                	j	626e <drivetests+0x6a>
    6252:	856a                	mv	a0,s10
    6254:	00000097          	auipc	ra,0x0
    6258:	7d8080e7          	jalr	2008(ra) # 6a2c <printf>
    625c:	a081                	j	629c <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    625e:	00000097          	auipc	ra,0x0
    6262:	e4a080e7          	jalr	-438(ra) # 60a8 <countfree>
    6266:	06954263          	blt	a0,s1,62ca <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    626a:	06098f63          	beqz	s3,62e8 <drivetests+0xe4>
    printf("usertests starting\n");
    626e:	855e                	mv	a0,s7
    6270:	00000097          	auipc	ra,0x0
    6274:	7bc080e7          	jalr	1980(ra) # 6a2c <printf>
    int free0 = countfree();
    6278:	00000097          	auipc	ra,0x0
    627c:	e30080e7          	jalr	-464(ra) # 60a8 <countfree>
    6280:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    6282:	85ca                	mv	a1,s2
    6284:	855a                	mv	a0,s6
    6286:	00000097          	auipc	ra,0x0
    628a:	dc6080e7          	jalr	-570(ra) # 604c <runtests>
    628e:	c119                	beqz	a0,6294 <drivetests+0x90>
      if(continuous != 2) {
    6290:	05599863          	bne	s3,s5,62e0 <drivetests+0xdc>
    if(!quick) {
    6294:	fc0a15e3          	bnez	s4,625e <drivetests+0x5a>
      if (justone == 0)
    6298:	fa090de3          	beqz	s2,6252 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    629c:	85ca                	mv	a1,s2
    629e:	8562                	mv	a0,s8
    62a0:	00000097          	auipc	ra,0x0
    62a4:	dac080e7          	jalr	-596(ra) # 604c <runtests>
    62a8:	d95d                	beqz	a0,625e <drivetests+0x5a>
        if(continuous != 2) {
    62aa:	03599d63          	bne	s3,s5,62e4 <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    62ae:	00000097          	auipc	ra,0x0
    62b2:	dfa080e7          	jalr	-518(ra) # 60a8 <countfree>
    62b6:	fa955ae3          	bge	a0,s1,626a <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    62ba:	8626                	mv	a2,s1
    62bc:	85aa                	mv	a1,a0
    62be:	8566                	mv	a0,s9
    62c0:	00000097          	auipc	ra,0x0
    62c4:	76c080e7          	jalr	1900(ra) # 6a2c <printf>
      if(continuous != 2) {
    62c8:	b75d                	j	626e <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    62ca:	8626                	mv	a2,s1
    62cc:	85aa                	mv	a1,a0
    62ce:	8566                	mv	a0,s9
    62d0:	00000097          	auipc	ra,0x0
    62d4:	75c080e7          	jalr	1884(ra) # 6a2c <printf>
      if(continuous != 2) {
    62d8:	f9598be3          	beq	s3,s5,626e <drivetests+0x6a>
        return 1;
    62dc:	4505                	li	a0,1
    62de:	a031                	j	62ea <drivetests+0xe6>
        return 1;
    62e0:	4505                	li	a0,1
    62e2:	a021                	j	62ea <drivetests+0xe6>
          return 1;
    62e4:	4505                	li	a0,1
    62e6:	a011                	j	62ea <drivetests+0xe6>
  return 0;
    62e8:	854e                	mv	a0,s3
}
    62ea:	60e6                	ld	ra,88(sp)
    62ec:	6446                	ld	s0,80(sp)
    62ee:	64a6                	ld	s1,72(sp)
    62f0:	6906                	ld	s2,64(sp)
    62f2:	79e2                	ld	s3,56(sp)
    62f4:	7a42                	ld	s4,48(sp)
    62f6:	7aa2                	ld	s5,40(sp)
    62f8:	7b02                	ld	s6,32(sp)
    62fa:	6be2                	ld	s7,24(sp)
    62fc:	6c42                	ld	s8,16(sp)
    62fe:	6ca2                	ld	s9,8(sp)
    6300:	6d02                	ld	s10,0(sp)
    6302:	6125                	addi	sp,sp,96
    6304:	8082                	ret

0000000000006306 <main>:

int
main(int argc, char *argv[])
{
    6306:	1101                	addi	sp,sp,-32
    6308:	ec06                	sd	ra,24(sp)
    630a:	e822                	sd	s0,16(sp)
    630c:	e426                	sd	s1,8(sp)
    630e:	e04a                	sd	s2,0(sp)
    6310:	1000                	addi	s0,sp,32
    6312:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    6314:	4789                	li	a5,2
    6316:	02f50763          	beq	a0,a5,6344 <main+0x3e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    631a:	4785                	li	a5,1
    631c:	08a7c163          	blt	a5,a0,639e <main+0x98>
  char *justone = 0;
    6320:	4601                	li	a2,0
  int quick = 0;
    6322:	4501                	li	a0,0
  int continuous = 0;
    6324:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1,"");
  }
  if (drivetests(quick, continuous, justone)) {
    6326:	85a6                	mv	a1,s1
    6328:	00000097          	auipc	ra,0x0
    632c:	edc080e7          	jalr	-292(ra) # 6204 <drivetests>
    6330:	c14d                	beqz	a0,63d2 <main+0xcc>
    exit(1,"");
    6332:	00002597          	auipc	a1,0x2
    6336:	ee658593          	addi	a1,a1,-282 # 8218 <malloc+0x172e>
    633a:	4505                	li	a0,1
    633c:	00000097          	auipc	ra,0x0
    6340:	350080e7          	jalr	848(ra) # 668c <exit>
    6344:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    6346:	00003597          	auipc	a1,0x3
    634a:	94258593          	addi	a1,a1,-1726 # 8c88 <malloc+0x219e>
    634e:	00893503          	ld	a0,8(s2)
    6352:	00000097          	auipc	ra,0x0
    6356:	0e0080e7          	jalr	224(ra) # 6432 <strcmp>
    635a:	c13d                	beqz	a0,63c0 <main+0xba>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    635c:	00003597          	auipc	a1,0x3
    6360:	98458593          	addi	a1,a1,-1660 # 8ce0 <malloc+0x21f6>
    6364:	00893503          	ld	a0,8(s2)
    6368:	00000097          	auipc	ra,0x0
    636c:	0ca080e7          	jalr	202(ra) # 6432 <strcmp>
    6370:	cd31                	beqz	a0,63cc <main+0xc6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    6372:	00003597          	auipc	a1,0x3
    6376:	96658593          	addi	a1,a1,-1690 # 8cd8 <malloc+0x21ee>
    637a:	00893503          	ld	a0,8(s2)
    637e:	00000097          	auipc	ra,0x0
    6382:	0b4080e7          	jalr	180(ra) # 6432 <strcmp>
    6386:	c129                	beqz	a0,63c8 <main+0xc2>
  } else if(argc == 2 && argv[1][0] != '-'){
    6388:	00893603          	ld	a2,8(s2)
    638c:	00064703          	lbu	a4,0(a2) # 3000 <sbrkmuch+0x6c>
    6390:	02d00793          	li	a5,45
    6394:	00f70563          	beq	a4,a5,639e <main+0x98>
  int quick = 0;
    6398:	4501                	li	a0,0
  int continuous = 0;
    639a:	4481                	li	s1,0
    639c:	b769                	j	6326 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    639e:	00003517          	auipc	a0,0x3
    63a2:	8f250513          	addi	a0,a0,-1806 # 8c90 <malloc+0x21a6>
    63a6:	00000097          	auipc	ra,0x0
    63aa:	686080e7          	jalr	1670(ra) # 6a2c <printf>
    exit(1,"");
    63ae:	00002597          	auipc	a1,0x2
    63b2:	e6a58593          	addi	a1,a1,-406 # 8218 <malloc+0x172e>
    63b6:	4505                	li	a0,1
    63b8:	00000097          	auipc	ra,0x0
    63bc:	2d4080e7          	jalr	724(ra) # 668c <exit>
  int continuous = 0;
    63c0:	84aa                	mv	s1,a0
  char *justone = 0;
    63c2:	4601                	li	a2,0
    quick = 1;
    63c4:	4505                	li	a0,1
    63c6:	b785                	j	6326 <main+0x20>
  char *justone = 0;
    63c8:	4601                	li	a2,0
    63ca:	bfb1                	j	6326 <main+0x20>
    63cc:	4601                	li	a2,0
    continuous = 1;
    63ce:	4485                	li	s1,1
    63d0:	bf99                	j	6326 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    63d2:	00003517          	auipc	a0,0x3
    63d6:	8ee50513          	addi	a0,a0,-1810 # 8cc0 <malloc+0x21d6>
    63da:	00000097          	auipc	ra,0x0
    63de:	652080e7          	jalr	1618(ra) # 6a2c <printf>
  exit(0,"");
    63e2:	00002597          	auipc	a1,0x2
    63e6:	e3658593          	addi	a1,a1,-458 # 8218 <malloc+0x172e>
    63ea:	4501                	li	a0,0
    63ec:	00000097          	auipc	ra,0x0
    63f0:	2a0080e7          	jalr	672(ra) # 668c <exit>

00000000000063f4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    63f4:	1141                	addi	sp,sp,-16
    63f6:	e406                	sd	ra,8(sp)
    63f8:	e022                	sd	s0,0(sp)
    63fa:	0800                	addi	s0,sp,16
  extern int main();
  main();
    63fc:	00000097          	auipc	ra,0x0
    6400:	f0a080e7          	jalr	-246(ra) # 6306 <main>
  exit(0,"");
    6404:	00002597          	auipc	a1,0x2
    6408:	e1458593          	addi	a1,a1,-492 # 8218 <malloc+0x172e>
    640c:	4501                	li	a0,0
    640e:	00000097          	auipc	ra,0x0
    6412:	27e080e7          	jalr	638(ra) # 668c <exit>

0000000000006416 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    6416:	1141                	addi	sp,sp,-16
    6418:	e422                	sd	s0,8(sp)
    641a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    641c:	87aa                	mv	a5,a0
    641e:	0585                	addi	a1,a1,1
    6420:	0785                	addi	a5,a5,1
    6422:	fff5c703          	lbu	a4,-1(a1)
    6426:	fee78fa3          	sb	a4,-1(a5) # fff <unlinkread+0x187>
    642a:	fb75                	bnez	a4,641e <strcpy+0x8>
    ;
  return os;
}
    642c:	6422                	ld	s0,8(sp)
    642e:	0141                	addi	sp,sp,16
    6430:	8082                	ret

0000000000006432 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    6432:	1141                	addi	sp,sp,-16
    6434:	e422                	sd	s0,8(sp)
    6436:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    6438:	00054783          	lbu	a5,0(a0)
    643c:	cb91                	beqz	a5,6450 <strcmp+0x1e>
    643e:	0005c703          	lbu	a4,0(a1)
    6442:	00f71763          	bne	a4,a5,6450 <strcmp+0x1e>
    p++, q++;
    6446:	0505                	addi	a0,a0,1
    6448:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    644a:	00054783          	lbu	a5,0(a0)
    644e:	fbe5                	bnez	a5,643e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    6450:	0005c503          	lbu	a0,0(a1)
}
    6454:	40a7853b          	subw	a0,a5,a0
    6458:	6422                	ld	s0,8(sp)
    645a:	0141                	addi	sp,sp,16
    645c:	8082                	ret

000000000000645e <strlen>:

uint
strlen(const char *s)
{
    645e:	1141                	addi	sp,sp,-16
    6460:	e422                	sd	s0,8(sp)
    6462:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    6464:	00054783          	lbu	a5,0(a0)
    6468:	cf91                	beqz	a5,6484 <strlen+0x26>
    646a:	0505                	addi	a0,a0,1
    646c:	87aa                	mv	a5,a0
    646e:	4685                	li	a3,1
    6470:	9e89                	subw	a3,a3,a0
    6472:	00f6853b          	addw	a0,a3,a5
    6476:	0785                	addi	a5,a5,1
    6478:	fff7c703          	lbu	a4,-1(a5)
    647c:	fb7d                	bnez	a4,6472 <strlen+0x14>
    ;
  return n;
}
    647e:	6422                	ld	s0,8(sp)
    6480:	0141                	addi	sp,sp,16
    6482:	8082                	ret
  for(n = 0; s[n]; n++)
    6484:	4501                	li	a0,0
    6486:	bfe5                	j	647e <strlen+0x20>

0000000000006488 <memset>:

void*
memset(void *dst, int c, uint n)
{
    6488:	1141                	addi	sp,sp,-16
    648a:	e422                	sd	s0,8(sp)
    648c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    648e:	ce09                	beqz	a2,64a8 <memset+0x20>
    6490:	87aa                	mv	a5,a0
    6492:	fff6071b          	addiw	a4,a2,-1
    6496:	1702                	slli	a4,a4,0x20
    6498:	9301                	srli	a4,a4,0x20
    649a:	0705                	addi	a4,a4,1
    649c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    649e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    64a2:	0785                	addi	a5,a5,1
    64a4:	fee79de3          	bne	a5,a4,649e <memset+0x16>
  }
  return dst;
}
    64a8:	6422                	ld	s0,8(sp)
    64aa:	0141                	addi	sp,sp,16
    64ac:	8082                	ret

00000000000064ae <strchr>:

char*
strchr(const char *s, char c)
{
    64ae:	1141                	addi	sp,sp,-16
    64b0:	e422                	sd	s0,8(sp)
    64b2:	0800                	addi	s0,sp,16
  for(; *s; s++)
    64b4:	00054783          	lbu	a5,0(a0)
    64b8:	cb99                	beqz	a5,64ce <strchr+0x20>
    if(*s == c)
    64ba:	00f58763          	beq	a1,a5,64c8 <strchr+0x1a>
  for(; *s; s++)
    64be:	0505                	addi	a0,a0,1
    64c0:	00054783          	lbu	a5,0(a0)
    64c4:	fbfd                	bnez	a5,64ba <strchr+0xc>
      return (char*)s;
  return 0;
    64c6:	4501                	li	a0,0
}
    64c8:	6422                	ld	s0,8(sp)
    64ca:	0141                	addi	sp,sp,16
    64cc:	8082                	ret
  return 0;
    64ce:	4501                	li	a0,0
    64d0:	bfe5                	j	64c8 <strchr+0x1a>

00000000000064d2 <gets>:

char*
gets(char *buf, int max)
{
    64d2:	711d                	addi	sp,sp,-96
    64d4:	ec86                	sd	ra,88(sp)
    64d6:	e8a2                	sd	s0,80(sp)
    64d8:	e4a6                	sd	s1,72(sp)
    64da:	e0ca                	sd	s2,64(sp)
    64dc:	fc4e                	sd	s3,56(sp)
    64de:	f852                	sd	s4,48(sp)
    64e0:	f456                	sd	s5,40(sp)
    64e2:	f05a                	sd	s6,32(sp)
    64e4:	ec5e                	sd	s7,24(sp)
    64e6:	1080                	addi	s0,sp,96
    64e8:	8baa                	mv	s7,a0
    64ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    64ec:	892a                	mv	s2,a0
    64ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    64f0:	4aa9                	li	s5,10
    64f2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    64f4:	89a6                	mv	s3,s1
    64f6:	2485                	addiw	s1,s1,1
    64f8:	0344d863          	bge	s1,s4,6528 <gets+0x56>
    cc = read(0, &c, 1);
    64fc:	4605                	li	a2,1
    64fe:	faf40593          	addi	a1,s0,-81
    6502:	4501                	li	a0,0
    6504:	00000097          	auipc	ra,0x0
    6508:	1a0080e7          	jalr	416(ra) # 66a4 <read>
    if(cc < 1)
    650c:	00a05e63          	blez	a0,6528 <gets+0x56>
    buf[i++] = c;
    6510:	faf44783          	lbu	a5,-81(s0)
    6514:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    6518:	01578763          	beq	a5,s5,6526 <gets+0x54>
    651c:	0905                	addi	s2,s2,1
    651e:	fd679be3          	bne	a5,s6,64f4 <gets+0x22>
  for(i=0; i+1 < max; ){
    6522:	89a6                	mv	s3,s1
    6524:	a011                	j	6528 <gets+0x56>
    6526:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    6528:	99de                	add	s3,s3,s7
    652a:	00098023          	sb	zero,0(s3)
  return buf;
}
    652e:	855e                	mv	a0,s7
    6530:	60e6                	ld	ra,88(sp)
    6532:	6446                	ld	s0,80(sp)
    6534:	64a6                	ld	s1,72(sp)
    6536:	6906                	ld	s2,64(sp)
    6538:	79e2                	ld	s3,56(sp)
    653a:	7a42                	ld	s4,48(sp)
    653c:	7aa2                	ld	s5,40(sp)
    653e:	7b02                	ld	s6,32(sp)
    6540:	6be2                	ld	s7,24(sp)
    6542:	6125                	addi	sp,sp,96
    6544:	8082                	ret

0000000000006546 <stat>:

int
stat(const char *n, struct stat *st)
{
    6546:	1101                	addi	sp,sp,-32
    6548:	ec06                	sd	ra,24(sp)
    654a:	e822                	sd	s0,16(sp)
    654c:	e426                	sd	s1,8(sp)
    654e:	e04a                	sd	s2,0(sp)
    6550:	1000                	addi	s0,sp,32
    6552:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    6554:	4581                	li	a1,0
    6556:	00000097          	auipc	ra,0x0
    655a:	176080e7          	jalr	374(ra) # 66cc <open>
  if(fd < 0)
    655e:	02054563          	bltz	a0,6588 <stat+0x42>
    6562:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    6564:	85ca                	mv	a1,s2
    6566:	00000097          	auipc	ra,0x0
    656a:	17e080e7          	jalr	382(ra) # 66e4 <fstat>
    656e:	892a                	mv	s2,a0
  close(fd);
    6570:	8526                	mv	a0,s1
    6572:	00000097          	auipc	ra,0x0
    6576:	142080e7          	jalr	322(ra) # 66b4 <close>
  return r;
}
    657a:	854a                	mv	a0,s2
    657c:	60e2                	ld	ra,24(sp)
    657e:	6442                	ld	s0,16(sp)
    6580:	64a2                	ld	s1,8(sp)
    6582:	6902                	ld	s2,0(sp)
    6584:	6105                	addi	sp,sp,32
    6586:	8082                	ret
    return -1;
    6588:	597d                	li	s2,-1
    658a:	bfc5                	j	657a <stat+0x34>

000000000000658c <atoi>:

int
atoi(const char *s)
{
    658c:	1141                	addi	sp,sp,-16
    658e:	e422                	sd	s0,8(sp)
    6590:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    6592:	00054603          	lbu	a2,0(a0)
    6596:	fd06079b          	addiw	a5,a2,-48
    659a:	0ff7f793          	andi	a5,a5,255
    659e:	4725                	li	a4,9
    65a0:	02f76963          	bltu	a4,a5,65d2 <atoi+0x46>
    65a4:	86aa                	mv	a3,a0
  n = 0;
    65a6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    65a8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    65aa:	0685                	addi	a3,a3,1
    65ac:	0025179b          	slliw	a5,a0,0x2
    65b0:	9fa9                	addw	a5,a5,a0
    65b2:	0017979b          	slliw	a5,a5,0x1
    65b6:	9fb1                	addw	a5,a5,a2
    65b8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    65bc:	0006c603          	lbu	a2,0(a3) # 1000 <unlinkread+0x188>
    65c0:	fd06071b          	addiw	a4,a2,-48
    65c4:	0ff77713          	andi	a4,a4,255
    65c8:	fee5f1e3          	bgeu	a1,a4,65aa <atoi+0x1e>
  return n;
}
    65cc:	6422                	ld	s0,8(sp)
    65ce:	0141                	addi	sp,sp,16
    65d0:	8082                	ret
  n = 0;
    65d2:	4501                	li	a0,0
    65d4:	bfe5                	j	65cc <atoi+0x40>

00000000000065d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    65d6:	1141                	addi	sp,sp,-16
    65d8:	e422                	sd	s0,8(sp)
    65da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    65dc:	02b57663          	bgeu	a0,a1,6608 <memmove+0x32>
    while(n-- > 0)
    65e0:	02c05163          	blez	a2,6602 <memmove+0x2c>
    65e4:	fff6079b          	addiw	a5,a2,-1
    65e8:	1782                	slli	a5,a5,0x20
    65ea:	9381                	srli	a5,a5,0x20
    65ec:	0785                	addi	a5,a5,1
    65ee:	97aa                	add	a5,a5,a0
  dst = vdst;
    65f0:	872a                	mv	a4,a0
      *dst++ = *src++;
    65f2:	0585                	addi	a1,a1,1
    65f4:	0705                	addi	a4,a4,1
    65f6:	fff5c683          	lbu	a3,-1(a1)
    65fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    65fe:	fee79ae3          	bne	a5,a4,65f2 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    6602:	6422                	ld	s0,8(sp)
    6604:	0141                	addi	sp,sp,16
    6606:	8082                	ret
    dst += n;
    6608:	00c50733          	add	a4,a0,a2
    src += n;
    660c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    660e:	fec05ae3          	blez	a2,6602 <memmove+0x2c>
    6612:	fff6079b          	addiw	a5,a2,-1
    6616:	1782                	slli	a5,a5,0x20
    6618:	9381                	srli	a5,a5,0x20
    661a:	fff7c793          	not	a5,a5
    661e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    6620:	15fd                	addi	a1,a1,-1
    6622:	177d                	addi	a4,a4,-1
    6624:	0005c683          	lbu	a3,0(a1)
    6628:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    662c:	fee79ae3          	bne	a5,a4,6620 <memmove+0x4a>
    6630:	bfc9                	j	6602 <memmove+0x2c>

0000000000006632 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    6632:	1141                	addi	sp,sp,-16
    6634:	e422                	sd	s0,8(sp)
    6636:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    6638:	ca05                	beqz	a2,6668 <memcmp+0x36>
    663a:	fff6069b          	addiw	a3,a2,-1
    663e:	1682                	slli	a3,a3,0x20
    6640:	9281                	srli	a3,a3,0x20
    6642:	0685                	addi	a3,a3,1
    6644:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    6646:	00054783          	lbu	a5,0(a0)
    664a:	0005c703          	lbu	a4,0(a1)
    664e:	00e79863          	bne	a5,a4,665e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    6652:	0505                	addi	a0,a0,1
    p2++;
    6654:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    6656:	fed518e3          	bne	a0,a3,6646 <memcmp+0x14>
  }
  return 0;
    665a:	4501                	li	a0,0
    665c:	a019                	j	6662 <memcmp+0x30>
      return *p1 - *p2;
    665e:	40e7853b          	subw	a0,a5,a4
}
    6662:	6422                	ld	s0,8(sp)
    6664:	0141                	addi	sp,sp,16
    6666:	8082                	ret
  return 0;
    6668:	4501                	li	a0,0
    666a:	bfe5                	j	6662 <memcmp+0x30>

000000000000666c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    666c:	1141                	addi	sp,sp,-16
    666e:	e406                	sd	ra,8(sp)
    6670:	e022                	sd	s0,0(sp)
    6672:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    6674:	00000097          	auipc	ra,0x0
    6678:	f62080e7          	jalr	-158(ra) # 65d6 <memmove>
}
    667c:	60a2                	ld	ra,8(sp)
    667e:	6402                	ld	s0,0(sp)
    6680:	0141                	addi	sp,sp,16
    6682:	8082                	ret

0000000000006684 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    6684:	4885                	li	a7,1
 ecall
    6686:	00000073          	ecall
 ret
    668a:	8082                	ret

000000000000668c <exit>:
.global exit
exit:
 li a7, SYS_exit
    668c:	4889                	li	a7,2
 ecall
    668e:	00000073          	ecall
 ret
    6692:	8082                	ret

0000000000006694 <wait>:
.global wait
wait:
 li a7, SYS_wait
    6694:	488d                	li	a7,3
 ecall
    6696:	00000073          	ecall
 ret
    669a:	8082                	ret

000000000000669c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    669c:	4891                	li	a7,4
 ecall
    669e:	00000073          	ecall
 ret
    66a2:	8082                	ret

00000000000066a4 <read>:
.global read
read:
 li a7, SYS_read
    66a4:	4895                	li	a7,5
 ecall
    66a6:	00000073          	ecall
 ret
    66aa:	8082                	ret

00000000000066ac <write>:
.global write
write:
 li a7, SYS_write
    66ac:	48c1                	li	a7,16
 ecall
    66ae:	00000073          	ecall
 ret
    66b2:	8082                	ret

00000000000066b4 <close>:
.global close
close:
 li a7, SYS_close
    66b4:	48d5                	li	a7,21
 ecall
    66b6:	00000073          	ecall
 ret
    66ba:	8082                	ret

00000000000066bc <kill>:
.global kill
kill:
 li a7, SYS_kill
    66bc:	4899                	li	a7,6
 ecall
    66be:	00000073          	ecall
 ret
    66c2:	8082                	ret

00000000000066c4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    66c4:	489d                	li	a7,7
 ecall
    66c6:	00000073          	ecall
 ret
    66ca:	8082                	ret

00000000000066cc <open>:
.global open
open:
 li a7, SYS_open
    66cc:	48bd                	li	a7,15
 ecall
    66ce:	00000073          	ecall
 ret
    66d2:	8082                	ret

00000000000066d4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    66d4:	48c5                	li	a7,17
 ecall
    66d6:	00000073          	ecall
 ret
    66da:	8082                	ret

00000000000066dc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    66dc:	48c9                	li	a7,18
 ecall
    66de:	00000073          	ecall
 ret
    66e2:	8082                	ret

00000000000066e4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    66e4:	48a1                	li	a7,8
 ecall
    66e6:	00000073          	ecall
 ret
    66ea:	8082                	ret

00000000000066ec <link>:
.global link
link:
 li a7, SYS_link
    66ec:	48cd                	li	a7,19
 ecall
    66ee:	00000073          	ecall
 ret
    66f2:	8082                	ret

00000000000066f4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    66f4:	48d1                	li	a7,20
 ecall
    66f6:	00000073          	ecall
 ret
    66fa:	8082                	ret

00000000000066fc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    66fc:	48a5                	li	a7,9
 ecall
    66fe:	00000073          	ecall
 ret
    6702:	8082                	ret

0000000000006704 <dup>:
.global dup
dup:
 li a7, SYS_dup
    6704:	48a9                	li	a7,10
 ecall
    6706:	00000073          	ecall
 ret
    670a:	8082                	ret

000000000000670c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    670c:	48ad                	li	a7,11
 ecall
    670e:	00000073          	ecall
 ret
    6712:	8082                	ret

0000000000006714 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    6714:	48b1                	li	a7,12
 ecall
    6716:	00000073          	ecall
 ret
    671a:	8082                	ret

000000000000671c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    671c:	48b5                	li	a7,13
 ecall
    671e:	00000073          	ecall
 ret
    6722:	8082                	ret

0000000000006724 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    6724:	48b9                	li	a7,14
 ecall
    6726:	00000073          	ecall
 ret
    672a:	8082                	ret

000000000000672c <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
    672c:	48d9                	li	a7,22
 ecall
    672e:	00000073          	ecall
 ret
    6732:	8082                	ret

0000000000006734 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
    6734:	48dd                	li	a7,23
 ecall
    6736:	00000073          	ecall
 ret
    673a:	8082                	ret

000000000000673c <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
    673c:	48e1                	li	a7,24
 ecall
    673e:	00000073          	ecall
 ret
    6742:	8082                	ret

0000000000006744 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
    6744:	48e5                	li	a7,25
 ecall
    6746:	00000073          	ecall
 ret
    674a:	8082                	ret

000000000000674c <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
    674c:	48e9                	li	a7,26
 ecall
    674e:	00000073          	ecall
 ret
    6752:	8082                	ret

0000000000006754 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    6754:	1101                	addi	sp,sp,-32
    6756:	ec06                	sd	ra,24(sp)
    6758:	e822                	sd	s0,16(sp)
    675a:	1000                	addi	s0,sp,32
    675c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    6760:	4605                	li	a2,1
    6762:	fef40593          	addi	a1,s0,-17
    6766:	00000097          	auipc	ra,0x0
    676a:	f46080e7          	jalr	-186(ra) # 66ac <write>
}
    676e:	60e2                	ld	ra,24(sp)
    6770:	6442                	ld	s0,16(sp)
    6772:	6105                	addi	sp,sp,32
    6774:	8082                	ret

0000000000006776 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    6776:	7139                	addi	sp,sp,-64
    6778:	fc06                	sd	ra,56(sp)
    677a:	f822                	sd	s0,48(sp)
    677c:	f426                	sd	s1,40(sp)
    677e:	f04a                	sd	s2,32(sp)
    6780:	ec4e                	sd	s3,24(sp)
    6782:	0080                	addi	s0,sp,64
    6784:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    6786:	c299                	beqz	a3,678c <printint+0x16>
    6788:	0805c863          	bltz	a1,6818 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    678c:	2581                	sext.w	a1,a1
  neg = 0;
    678e:	4881                	li	a7,0
    6790:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    6794:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    6796:	2601                	sext.w	a2,a2
    6798:	00003517          	auipc	a0,0x3
    679c:	8b850513          	addi	a0,a0,-1864 # 9050 <digits>
    67a0:	883a                	mv	a6,a4
    67a2:	2705                	addiw	a4,a4,1
    67a4:	02c5f7bb          	remuw	a5,a1,a2
    67a8:	1782                	slli	a5,a5,0x20
    67aa:	9381                	srli	a5,a5,0x20
    67ac:	97aa                	add	a5,a5,a0
    67ae:	0007c783          	lbu	a5,0(a5)
    67b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    67b6:	0005879b          	sext.w	a5,a1
    67ba:	02c5d5bb          	divuw	a1,a1,a2
    67be:	0685                	addi	a3,a3,1
    67c0:	fec7f0e3          	bgeu	a5,a2,67a0 <printint+0x2a>
  if(neg)
    67c4:	00088b63          	beqz	a7,67da <printint+0x64>
    buf[i++] = '-';
    67c8:	fd040793          	addi	a5,s0,-48
    67cc:	973e                	add	a4,a4,a5
    67ce:	02d00793          	li	a5,45
    67d2:	fef70823          	sb	a5,-16(a4)
    67d6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    67da:	02e05863          	blez	a4,680a <printint+0x94>
    67de:	fc040793          	addi	a5,s0,-64
    67e2:	00e78933          	add	s2,a5,a4
    67e6:	fff78993          	addi	s3,a5,-1
    67ea:	99ba                	add	s3,s3,a4
    67ec:	377d                	addiw	a4,a4,-1
    67ee:	1702                	slli	a4,a4,0x20
    67f0:	9301                	srli	a4,a4,0x20
    67f2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    67f6:	fff94583          	lbu	a1,-1(s2)
    67fa:	8526                	mv	a0,s1
    67fc:	00000097          	auipc	ra,0x0
    6800:	f58080e7          	jalr	-168(ra) # 6754 <putc>
  while(--i >= 0)
    6804:	197d                	addi	s2,s2,-1
    6806:	ff3918e3          	bne	s2,s3,67f6 <printint+0x80>
}
    680a:	70e2                	ld	ra,56(sp)
    680c:	7442                	ld	s0,48(sp)
    680e:	74a2                	ld	s1,40(sp)
    6810:	7902                	ld	s2,32(sp)
    6812:	69e2                	ld	s3,24(sp)
    6814:	6121                	addi	sp,sp,64
    6816:	8082                	ret
    x = -xx;
    6818:	40b005bb          	negw	a1,a1
    neg = 1;
    681c:	4885                	li	a7,1
    x = -xx;
    681e:	bf8d                	j	6790 <printint+0x1a>

0000000000006820 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    6820:	7119                	addi	sp,sp,-128
    6822:	fc86                	sd	ra,120(sp)
    6824:	f8a2                	sd	s0,112(sp)
    6826:	f4a6                	sd	s1,104(sp)
    6828:	f0ca                	sd	s2,96(sp)
    682a:	ecce                	sd	s3,88(sp)
    682c:	e8d2                	sd	s4,80(sp)
    682e:	e4d6                	sd	s5,72(sp)
    6830:	e0da                	sd	s6,64(sp)
    6832:	fc5e                	sd	s7,56(sp)
    6834:	f862                	sd	s8,48(sp)
    6836:	f466                	sd	s9,40(sp)
    6838:	f06a                	sd	s10,32(sp)
    683a:	ec6e                	sd	s11,24(sp)
    683c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    683e:	0005c903          	lbu	s2,0(a1)
    6842:	18090f63          	beqz	s2,69e0 <vprintf+0x1c0>
    6846:	8aaa                	mv	s5,a0
    6848:	8b32                	mv	s6,a2
    684a:	00158493          	addi	s1,a1,1
  state = 0;
    684e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    6850:	02500a13          	li	s4,37
      if(c == 'd'){
    6854:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    6858:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    685c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    6860:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    6864:	00002b97          	auipc	s7,0x2
    6868:	7ecb8b93          	addi	s7,s7,2028 # 9050 <digits>
    686c:	a839                	j	688a <vprintf+0x6a>
        putc(fd, c);
    686e:	85ca                	mv	a1,s2
    6870:	8556                	mv	a0,s5
    6872:	00000097          	auipc	ra,0x0
    6876:	ee2080e7          	jalr	-286(ra) # 6754 <putc>
    687a:	a019                	j	6880 <vprintf+0x60>
    } else if(state == '%'){
    687c:	01498f63          	beq	s3,s4,689a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    6880:	0485                	addi	s1,s1,1
    6882:	fff4c903          	lbu	s2,-1(s1)
    6886:	14090d63          	beqz	s2,69e0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    688a:	0009079b          	sext.w	a5,s2
    if(state == 0){
    688e:	fe0997e3          	bnez	s3,687c <vprintf+0x5c>
      if(c == '%'){
    6892:	fd479ee3          	bne	a5,s4,686e <vprintf+0x4e>
        state = '%';
    6896:	89be                	mv	s3,a5
    6898:	b7e5                	j	6880 <vprintf+0x60>
      if(c == 'd'){
    689a:	05878063          	beq	a5,s8,68da <vprintf+0xba>
      } else if(c == 'l') {
    689e:	05978c63          	beq	a5,s9,68f6 <vprintf+0xd6>
      } else if(c == 'x') {
    68a2:	07a78863          	beq	a5,s10,6912 <vprintf+0xf2>
      } else if(c == 'p') {
    68a6:	09b78463          	beq	a5,s11,692e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    68aa:	07300713          	li	a4,115
    68ae:	0ce78663          	beq	a5,a4,697a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    68b2:	06300713          	li	a4,99
    68b6:	0ee78e63          	beq	a5,a4,69b2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    68ba:	11478863          	beq	a5,s4,69ca <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    68be:	85d2                	mv	a1,s4
    68c0:	8556                	mv	a0,s5
    68c2:	00000097          	auipc	ra,0x0
    68c6:	e92080e7          	jalr	-366(ra) # 6754 <putc>
        putc(fd, c);
    68ca:	85ca                	mv	a1,s2
    68cc:	8556                	mv	a0,s5
    68ce:	00000097          	auipc	ra,0x0
    68d2:	e86080e7          	jalr	-378(ra) # 6754 <putc>
      }
      state = 0;
    68d6:	4981                	li	s3,0
    68d8:	b765                	j	6880 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    68da:	008b0913          	addi	s2,s6,8
    68de:	4685                	li	a3,1
    68e0:	4629                	li	a2,10
    68e2:	000b2583          	lw	a1,0(s6)
    68e6:	8556                	mv	a0,s5
    68e8:	00000097          	auipc	ra,0x0
    68ec:	e8e080e7          	jalr	-370(ra) # 6776 <printint>
    68f0:	8b4a                	mv	s6,s2
      state = 0;
    68f2:	4981                	li	s3,0
    68f4:	b771                	j	6880 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    68f6:	008b0913          	addi	s2,s6,8
    68fa:	4681                	li	a3,0
    68fc:	4629                	li	a2,10
    68fe:	000b2583          	lw	a1,0(s6)
    6902:	8556                	mv	a0,s5
    6904:	00000097          	auipc	ra,0x0
    6908:	e72080e7          	jalr	-398(ra) # 6776 <printint>
    690c:	8b4a                	mv	s6,s2
      state = 0;
    690e:	4981                	li	s3,0
    6910:	bf85                	j	6880 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    6912:	008b0913          	addi	s2,s6,8
    6916:	4681                	li	a3,0
    6918:	4641                	li	a2,16
    691a:	000b2583          	lw	a1,0(s6)
    691e:	8556                	mv	a0,s5
    6920:	00000097          	auipc	ra,0x0
    6924:	e56080e7          	jalr	-426(ra) # 6776 <printint>
    6928:	8b4a                	mv	s6,s2
      state = 0;
    692a:	4981                	li	s3,0
    692c:	bf91                	j	6880 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    692e:	008b0793          	addi	a5,s6,8
    6932:	f8f43423          	sd	a5,-120(s0)
    6936:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    693a:	03000593          	li	a1,48
    693e:	8556                	mv	a0,s5
    6940:	00000097          	auipc	ra,0x0
    6944:	e14080e7          	jalr	-492(ra) # 6754 <putc>
  putc(fd, 'x');
    6948:	85ea                	mv	a1,s10
    694a:	8556                	mv	a0,s5
    694c:	00000097          	auipc	ra,0x0
    6950:	e08080e7          	jalr	-504(ra) # 6754 <putc>
    6954:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    6956:	03c9d793          	srli	a5,s3,0x3c
    695a:	97de                	add	a5,a5,s7
    695c:	0007c583          	lbu	a1,0(a5)
    6960:	8556                	mv	a0,s5
    6962:	00000097          	auipc	ra,0x0
    6966:	df2080e7          	jalr	-526(ra) # 6754 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    696a:	0992                	slli	s3,s3,0x4
    696c:	397d                	addiw	s2,s2,-1
    696e:	fe0914e3          	bnez	s2,6956 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    6972:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    6976:	4981                	li	s3,0
    6978:	b721                	j	6880 <vprintf+0x60>
        s = va_arg(ap, char*);
    697a:	008b0993          	addi	s3,s6,8
    697e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    6982:	02090163          	beqz	s2,69a4 <vprintf+0x184>
        while(*s != 0){
    6986:	00094583          	lbu	a1,0(s2)
    698a:	c9a1                	beqz	a1,69da <vprintf+0x1ba>
          putc(fd, *s);
    698c:	8556                	mv	a0,s5
    698e:	00000097          	auipc	ra,0x0
    6992:	dc6080e7          	jalr	-570(ra) # 6754 <putc>
          s++;
    6996:	0905                	addi	s2,s2,1
        while(*s != 0){
    6998:	00094583          	lbu	a1,0(s2)
    699c:	f9e5                	bnez	a1,698c <vprintf+0x16c>
        s = va_arg(ap, char*);
    699e:	8b4e                	mv	s6,s3
      state = 0;
    69a0:	4981                	li	s3,0
    69a2:	bdf9                	j	6880 <vprintf+0x60>
          s = "(null)";
    69a4:	00002917          	auipc	s2,0x2
    69a8:	6a490913          	addi	s2,s2,1700 # 9048 <malloc+0x255e>
        while(*s != 0){
    69ac:	02800593          	li	a1,40
    69b0:	bff1                	j	698c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    69b2:	008b0913          	addi	s2,s6,8
    69b6:	000b4583          	lbu	a1,0(s6)
    69ba:	8556                	mv	a0,s5
    69bc:	00000097          	auipc	ra,0x0
    69c0:	d98080e7          	jalr	-616(ra) # 6754 <putc>
    69c4:	8b4a                	mv	s6,s2
      state = 0;
    69c6:	4981                	li	s3,0
    69c8:	bd65                	j	6880 <vprintf+0x60>
        putc(fd, c);
    69ca:	85d2                	mv	a1,s4
    69cc:	8556                	mv	a0,s5
    69ce:	00000097          	auipc	ra,0x0
    69d2:	d86080e7          	jalr	-634(ra) # 6754 <putc>
      state = 0;
    69d6:	4981                	li	s3,0
    69d8:	b565                	j	6880 <vprintf+0x60>
        s = va_arg(ap, char*);
    69da:	8b4e                	mv	s6,s3
      state = 0;
    69dc:	4981                	li	s3,0
    69de:	b54d                	j	6880 <vprintf+0x60>
    }
  }
}
    69e0:	70e6                	ld	ra,120(sp)
    69e2:	7446                	ld	s0,112(sp)
    69e4:	74a6                	ld	s1,104(sp)
    69e6:	7906                	ld	s2,96(sp)
    69e8:	69e6                	ld	s3,88(sp)
    69ea:	6a46                	ld	s4,80(sp)
    69ec:	6aa6                	ld	s5,72(sp)
    69ee:	6b06                	ld	s6,64(sp)
    69f0:	7be2                	ld	s7,56(sp)
    69f2:	7c42                	ld	s8,48(sp)
    69f4:	7ca2                	ld	s9,40(sp)
    69f6:	7d02                	ld	s10,32(sp)
    69f8:	6de2                	ld	s11,24(sp)
    69fa:	6109                	addi	sp,sp,128
    69fc:	8082                	ret

00000000000069fe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    69fe:	715d                	addi	sp,sp,-80
    6a00:	ec06                	sd	ra,24(sp)
    6a02:	e822                	sd	s0,16(sp)
    6a04:	1000                	addi	s0,sp,32
    6a06:	e010                	sd	a2,0(s0)
    6a08:	e414                	sd	a3,8(s0)
    6a0a:	e818                	sd	a4,16(s0)
    6a0c:	ec1c                	sd	a5,24(s0)
    6a0e:	03043023          	sd	a6,32(s0)
    6a12:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    6a16:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    6a1a:	8622                	mv	a2,s0
    6a1c:	00000097          	auipc	ra,0x0
    6a20:	e04080e7          	jalr	-508(ra) # 6820 <vprintf>
}
    6a24:	60e2                	ld	ra,24(sp)
    6a26:	6442                	ld	s0,16(sp)
    6a28:	6161                	addi	sp,sp,80
    6a2a:	8082                	ret

0000000000006a2c <printf>:

void
printf(const char *fmt, ...)
{
    6a2c:	711d                	addi	sp,sp,-96
    6a2e:	ec06                	sd	ra,24(sp)
    6a30:	e822                	sd	s0,16(sp)
    6a32:	1000                	addi	s0,sp,32
    6a34:	e40c                	sd	a1,8(s0)
    6a36:	e810                	sd	a2,16(s0)
    6a38:	ec14                	sd	a3,24(s0)
    6a3a:	f018                	sd	a4,32(s0)
    6a3c:	f41c                	sd	a5,40(s0)
    6a3e:	03043823          	sd	a6,48(s0)
    6a42:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    6a46:	00840613          	addi	a2,s0,8
    6a4a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    6a4e:	85aa                	mv	a1,a0
    6a50:	4505                	li	a0,1
    6a52:	00000097          	auipc	ra,0x0
    6a56:	dce080e7          	jalr	-562(ra) # 6820 <vprintf>
}
    6a5a:	60e2                	ld	ra,24(sp)
    6a5c:	6442                	ld	s0,16(sp)
    6a5e:	6125                	addi	sp,sp,96
    6a60:	8082                	ret

0000000000006a62 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    6a62:	1141                	addi	sp,sp,-16
    6a64:	e422                	sd	s0,8(sp)
    6a66:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    6a68:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6a6c:	00004797          	auipc	a5,0x4
    6a70:	9e47b783          	ld	a5,-1564(a5) # a450 <freep>
    6a74:	a805                	j	6aa4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    6a76:	4618                	lw	a4,8(a2)
    6a78:	9db9                	addw	a1,a1,a4
    6a7a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    6a7e:	6398                	ld	a4,0(a5)
    6a80:	6318                	ld	a4,0(a4)
    6a82:	fee53823          	sd	a4,-16(a0)
    6a86:	a091                	j	6aca <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    6a88:	ff852703          	lw	a4,-8(a0)
    6a8c:	9e39                	addw	a2,a2,a4
    6a8e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    6a90:	ff053703          	ld	a4,-16(a0)
    6a94:	e398                	sd	a4,0(a5)
    6a96:	a099                	j	6adc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6a98:	6398                	ld	a4,0(a5)
    6a9a:	00e7e463          	bltu	a5,a4,6aa2 <free+0x40>
    6a9e:	00e6ea63          	bltu	a3,a4,6ab2 <free+0x50>
{
    6aa2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    6aa4:	fed7fae3          	bgeu	a5,a3,6a98 <free+0x36>
    6aa8:	6398                	ld	a4,0(a5)
    6aaa:	00e6e463          	bltu	a3,a4,6ab2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6aae:	fee7eae3          	bltu	a5,a4,6aa2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    6ab2:	ff852583          	lw	a1,-8(a0)
    6ab6:	6390                	ld	a2,0(a5)
    6ab8:	02059713          	slli	a4,a1,0x20
    6abc:	9301                	srli	a4,a4,0x20
    6abe:	0712                	slli	a4,a4,0x4
    6ac0:	9736                	add	a4,a4,a3
    6ac2:	fae60ae3          	beq	a2,a4,6a76 <free+0x14>
    bp->s.ptr = p->s.ptr;
    6ac6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6aca:	4790                	lw	a2,8(a5)
    6acc:	02061713          	slli	a4,a2,0x20
    6ad0:	9301                	srli	a4,a4,0x20
    6ad2:	0712                	slli	a4,a4,0x4
    6ad4:	973e                	add	a4,a4,a5
    6ad6:	fae689e3          	beq	a3,a4,6a88 <free+0x26>
  } else
    p->s.ptr = bp;
    6ada:	e394                	sd	a3,0(a5)
  freep = p;
    6adc:	00004717          	auipc	a4,0x4
    6ae0:	96f73a23          	sd	a5,-1676(a4) # a450 <freep>
}
    6ae4:	6422                	ld	s0,8(sp)
    6ae6:	0141                	addi	sp,sp,16
    6ae8:	8082                	ret

0000000000006aea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6aea:	7139                	addi	sp,sp,-64
    6aec:	fc06                	sd	ra,56(sp)
    6aee:	f822                	sd	s0,48(sp)
    6af0:	f426                	sd	s1,40(sp)
    6af2:	f04a                	sd	s2,32(sp)
    6af4:	ec4e                	sd	s3,24(sp)
    6af6:	e852                	sd	s4,16(sp)
    6af8:	e456                	sd	s5,8(sp)
    6afa:	e05a                	sd	s6,0(sp)
    6afc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6afe:	02051493          	slli	s1,a0,0x20
    6b02:	9081                	srli	s1,s1,0x20
    6b04:	04bd                	addi	s1,s1,15
    6b06:	8091                	srli	s1,s1,0x4
    6b08:	0014899b          	addiw	s3,s1,1
    6b0c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6b0e:	00004517          	auipc	a0,0x4
    6b12:	94253503          	ld	a0,-1726(a0) # a450 <freep>
    6b16:	c515                	beqz	a0,6b42 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6b18:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6b1a:	4798                	lw	a4,8(a5)
    6b1c:	02977f63          	bgeu	a4,s1,6b5a <malloc+0x70>
    6b20:	8a4e                	mv	s4,s3
    6b22:	0009871b          	sext.w	a4,s3
    6b26:	6685                	lui	a3,0x1
    6b28:	00d77363          	bgeu	a4,a3,6b2e <malloc+0x44>
    6b2c:	6a05                	lui	s4,0x1
    6b2e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6b32:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6b36:	00004917          	auipc	s2,0x4
    6b3a:	91a90913          	addi	s2,s2,-1766 # a450 <freep>
  if(p == (char*)-1)
    6b3e:	5afd                	li	s5,-1
    6b40:	a88d                	j	6bb2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    6b42:	0000a797          	auipc	a5,0xa
    6b46:	13678793          	addi	a5,a5,310 # 10c78 <base>
    6b4a:	00004717          	auipc	a4,0x4
    6b4e:	90f73323          	sd	a5,-1786(a4) # a450 <freep>
    6b52:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6b54:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    6b58:	b7e1                	j	6b20 <malloc+0x36>
      if(p->s.size == nunits)
    6b5a:	02e48b63          	beq	s1,a4,6b90 <malloc+0xa6>
        p->s.size -= nunits;
    6b5e:	4137073b          	subw	a4,a4,s3
    6b62:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6b64:	1702                	slli	a4,a4,0x20
    6b66:	9301                	srli	a4,a4,0x20
    6b68:	0712                	slli	a4,a4,0x4
    6b6a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6b6c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6b70:	00004717          	auipc	a4,0x4
    6b74:	8ea73023          	sd	a0,-1824(a4) # a450 <freep>
      return (void*)(p + 1);
    6b78:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    6b7c:	70e2                	ld	ra,56(sp)
    6b7e:	7442                	ld	s0,48(sp)
    6b80:	74a2                	ld	s1,40(sp)
    6b82:	7902                	ld	s2,32(sp)
    6b84:	69e2                	ld	s3,24(sp)
    6b86:	6a42                	ld	s4,16(sp)
    6b88:	6aa2                	ld	s5,8(sp)
    6b8a:	6b02                	ld	s6,0(sp)
    6b8c:	6121                	addi	sp,sp,64
    6b8e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    6b90:	6398                	ld	a4,0(a5)
    6b92:	e118                	sd	a4,0(a0)
    6b94:	bff1                	j	6b70 <malloc+0x86>
  hp->s.size = nu;
    6b96:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6b9a:	0541                	addi	a0,a0,16
    6b9c:	00000097          	auipc	ra,0x0
    6ba0:	ec6080e7          	jalr	-314(ra) # 6a62 <free>
  return freep;
    6ba4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6ba8:	d971                	beqz	a0,6b7c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6baa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6bac:	4798                	lw	a4,8(a5)
    6bae:	fa9776e3          	bgeu	a4,s1,6b5a <malloc+0x70>
    if(p == freep)
    6bb2:	00093703          	ld	a4,0(s2)
    6bb6:	853e                	mv	a0,a5
    6bb8:	fef719e3          	bne	a4,a5,6baa <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    6bbc:	8552                	mv	a0,s4
    6bbe:	00000097          	auipc	ra,0x0
    6bc2:	b56080e7          	jalr	-1194(ra) # 6714 <sbrk>
  if(p == (char*)-1)
    6bc6:	fd5518e3          	bne	a0,s5,6b96 <malloc+0xac>
        return 0;
    6bca:	4501                	li	a0,0
    6bcc:	bf45                	j	6b7c <malloc+0x92>
