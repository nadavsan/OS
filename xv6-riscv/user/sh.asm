
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0,"");
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	3ae58593          	addi	a1,a1,942 # 13c0 <malloc+0xe6>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	e80080e7          	jalr	-384(ra) # e9c <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	c4e080e7          	jalr	-946(ra) # c78 <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	c8c080e7          	jalr	-884(ra) # cc2 <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0,"");
}

void
panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	36858593          	addi	a1,a1,872 # 13c8 <malloc+0xee>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	184080e7          	jalr	388(ra) # 11ee <fprintf>
  exit(1,"");
      72:	00001597          	auipc	a1,0x1
      76:	35e58593          	addi	a1,a1,862 # 13d0 <malloc+0xf6>
      7a:	4505                	li	a0,1
      7c:	00001097          	auipc	ra,0x1
      80:	e00080e7          	jalr	-512(ra) # e7c <exit>

0000000000000084 <fork1>:
}

int
fork1(void)
{
      84:	1141                	addi	sp,sp,-16
      86:	e406                	sd	ra,8(sp)
      88:	e022                	sd	s0,0(sp)
      8a:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      8c:	00001097          	auipc	ra,0x1
      90:	de8080e7          	jalr	-536(ra) # e74 <fork>
  if(pid == -1)
      94:	57fd                	li	a5,-1
      96:	00f50663          	beq	a0,a5,a2 <fork1+0x1e>
    panic("fork");
  return pid;
}
      9a:	60a2                	ld	ra,8(sp)
      9c:	6402                	ld	s0,0(sp)
      9e:	0141                	addi	sp,sp,16
      a0:	8082                	ret
    panic("fork");
      a2:	00001517          	auipc	a0,0x1
      a6:	33650513          	addi	a0,a0,822 # 13d8 <malloc+0xfe>
      aa:	00000097          	auipc	ra,0x0
      ae:	fac080e7          	jalr	-84(ra) # 56 <panic>

00000000000000b2 <runcmd>:
{
      b2:	7179                	addi	sp,sp,-48
      b4:	f406                	sd	ra,40(sp)
      b6:	f022                	sd	s0,32(sp)
      b8:	ec26                	sd	s1,24(sp)
      ba:	1800                	addi	s0,sp,48
  if(cmd == 0)
      bc:	c10d                	beqz	a0,de <runcmd+0x2c>
      be:	84aa                	mv	s1,a0
  switch(cmd->type){
      c0:	4118                	lw	a4,0(a0)
      c2:	4795                	li	a5,5
      c4:	02e7e663          	bltu	a5,a4,f0 <runcmd+0x3e>
      c8:	00056783          	lwu	a5,0(a0)
      cc:	078a                	slli	a5,a5,0x2
      ce:	00001717          	auipc	a4,0x1
      d2:	41670713          	addi	a4,a4,1046 # 14e4 <malloc+0x20a>
      d6:	97ba                	add	a5,a5,a4
      d8:	439c                	lw	a5,0(a5)
      da:	97ba                	add	a5,a5,a4
      dc:	8782                	jr	a5
    exit(1,"");
      de:	00001597          	auipc	a1,0x1
      e2:	2f258593          	addi	a1,a1,754 # 13d0 <malloc+0xf6>
      e6:	4505                	li	a0,1
      e8:	00001097          	auipc	ra,0x1
      ec:	d94080e7          	jalr	-620(ra) # e7c <exit>
    panic("runcmd");
      f0:	00001517          	auipc	a0,0x1
      f4:	2f050513          	addi	a0,a0,752 # 13e0 <malloc+0x106>
      f8:	00000097          	auipc	ra,0x0
      fc:	f5e080e7          	jalr	-162(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
     100:	6508                	ld	a0,8(a0)
     102:	c915                	beqz	a0,136 <runcmd+0x84>
    exec(ecmd->argv[0], ecmd->argv);
     104:	00848593          	addi	a1,s1,8
     108:	00001097          	auipc	ra,0x1
     10c:	dac080e7          	jalr	-596(ra) # eb4 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     110:	6490                	ld	a2,8(s1)
     112:	00001597          	auipc	a1,0x1
     116:	2d658593          	addi	a1,a1,726 # 13e8 <malloc+0x10e>
     11a:	4509                	li	a0,2
     11c:	00001097          	auipc	ra,0x1
     120:	0d2080e7          	jalr	210(ra) # 11ee <fprintf>
  exit(0,"");
     124:	00001597          	auipc	a1,0x1
     128:	2ac58593          	addi	a1,a1,684 # 13d0 <malloc+0xf6>
     12c:	4501                	li	a0,0
     12e:	00001097          	auipc	ra,0x1
     132:	d4e080e7          	jalr	-690(ra) # e7c <exit>
      exit(1,"");
     136:	00001597          	auipc	a1,0x1
     13a:	29a58593          	addi	a1,a1,666 # 13d0 <malloc+0xf6>
     13e:	4505                	li	a0,1
     140:	00001097          	auipc	ra,0x1
     144:	d3c080e7          	jalr	-708(ra) # e7c <exit>
    close(rcmd->fd);
     148:	5148                	lw	a0,36(a0)
     14a:	00001097          	auipc	ra,0x1
     14e:	d5a080e7          	jalr	-678(ra) # ea4 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     152:	508c                	lw	a1,32(s1)
     154:	6888                	ld	a0,16(s1)
     156:	00001097          	auipc	ra,0x1
     15a:	d66080e7          	jalr	-666(ra) # ebc <open>
     15e:	00054763          	bltz	a0,16c <runcmd+0xba>
    runcmd(rcmd->cmd);
     162:	6488                	ld	a0,8(s1)
     164:	00000097          	auipc	ra,0x0
     168:	f4e080e7          	jalr	-178(ra) # b2 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     16c:	6890                	ld	a2,16(s1)
     16e:	00001597          	auipc	a1,0x1
     172:	28a58593          	addi	a1,a1,650 # 13f8 <malloc+0x11e>
     176:	4509                	li	a0,2
     178:	00001097          	auipc	ra,0x1
     17c:	076080e7          	jalr	118(ra) # 11ee <fprintf>
      exit(1,"");
     180:	00001597          	auipc	a1,0x1
     184:	25058593          	addi	a1,a1,592 # 13d0 <malloc+0xf6>
     188:	4505                	li	a0,1
     18a:	00001097          	auipc	ra,0x1
     18e:	cf2080e7          	jalr	-782(ra) # e7c <exit>
    if(fork1() == 0)
     192:	00000097          	auipc	ra,0x0
     196:	ef2080e7          	jalr	-270(ra) # 84 <fork1>
     19a:	e511                	bnez	a0,1a6 <runcmd+0xf4>
      runcmd(lcmd->left);
     19c:	6488                	ld	a0,8(s1)
     19e:	00000097          	auipc	ra,0x0
     1a2:	f14080e7          	jalr	-236(ra) # b2 <runcmd>
    wait(0,0);
     1a6:	4581                	li	a1,0
     1a8:	4501                	li	a0,0
     1aa:	00001097          	auipc	ra,0x1
     1ae:	cda080e7          	jalr	-806(ra) # e84 <wait>
    runcmd(lcmd->right);
     1b2:	6888                	ld	a0,16(s1)
     1b4:	00000097          	auipc	ra,0x0
     1b8:	efe080e7          	jalr	-258(ra) # b2 <runcmd>
    if(pipe(p) < 0)
     1bc:	fd840513          	addi	a0,s0,-40
     1c0:	00001097          	auipc	ra,0x1
     1c4:	ccc080e7          	jalr	-820(ra) # e8c <pipe>
     1c8:	04054363          	bltz	a0,20e <runcmd+0x15c>
    if(fork1() == 0){
     1cc:	00000097          	auipc	ra,0x0
     1d0:	eb8080e7          	jalr	-328(ra) # 84 <fork1>
     1d4:	e529                	bnez	a0,21e <runcmd+0x16c>
      close(1);
     1d6:	4505                	li	a0,1
     1d8:	00001097          	auipc	ra,0x1
     1dc:	ccc080e7          	jalr	-820(ra) # ea4 <close>
      dup(p[1]);
     1e0:	fdc42503          	lw	a0,-36(s0)
     1e4:	00001097          	auipc	ra,0x1
     1e8:	d10080e7          	jalr	-752(ra) # ef4 <dup>
      close(p[0]);
     1ec:	fd842503          	lw	a0,-40(s0)
     1f0:	00001097          	auipc	ra,0x1
     1f4:	cb4080e7          	jalr	-844(ra) # ea4 <close>
      close(p[1]);
     1f8:	fdc42503          	lw	a0,-36(s0)
     1fc:	00001097          	auipc	ra,0x1
     200:	ca8080e7          	jalr	-856(ra) # ea4 <close>
      runcmd(pcmd->left);
     204:	6488                	ld	a0,8(s1)
     206:	00000097          	auipc	ra,0x0
     20a:	eac080e7          	jalr	-340(ra) # b2 <runcmd>
      panic("pipe");
     20e:	00001517          	auipc	a0,0x1
     212:	1fa50513          	addi	a0,a0,506 # 1408 <malloc+0x12e>
     216:	00000097          	auipc	ra,0x0
     21a:	e40080e7          	jalr	-448(ra) # 56 <panic>
    if(fork1() == 0){
     21e:	00000097          	auipc	ra,0x0
     222:	e66080e7          	jalr	-410(ra) # 84 <fork1>
     226:	ed05                	bnez	a0,25e <runcmd+0x1ac>
      close(0);
     228:	00001097          	auipc	ra,0x1
     22c:	c7c080e7          	jalr	-900(ra) # ea4 <close>
      dup(p[0]);
     230:	fd842503          	lw	a0,-40(s0)
     234:	00001097          	auipc	ra,0x1
     238:	cc0080e7          	jalr	-832(ra) # ef4 <dup>
      close(p[0]);
     23c:	fd842503          	lw	a0,-40(s0)
     240:	00001097          	auipc	ra,0x1
     244:	c64080e7          	jalr	-924(ra) # ea4 <close>
      close(p[1]);
     248:	fdc42503          	lw	a0,-36(s0)
     24c:	00001097          	auipc	ra,0x1
     250:	c58080e7          	jalr	-936(ra) # ea4 <close>
      runcmd(pcmd->right);
     254:	6888                	ld	a0,16(s1)
     256:	00000097          	auipc	ra,0x0
     25a:	e5c080e7          	jalr	-420(ra) # b2 <runcmd>
    close(p[0]);
     25e:	fd842503          	lw	a0,-40(s0)
     262:	00001097          	auipc	ra,0x1
     266:	c42080e7          	jalr	-958(ra) # ea4 <close>
    close(p[1]);
     26a:	fdc42503          	lw	a0,-36(s0)
     26e:	00001097          	auipc	ra,0x1
     272:	c36080e7          	jalr	-970(ra) # ea4 <close>
    wait(0,0);
     276:	4581                	li	a1,0
     278:	4501                	li	a0,0
     27a:	00001097          	auipc	ra,0x1
     27e:	c0a080e7          	jalr	-1014(ra) # e84 <wait>
    wait(0,0);
     282:	4581                	li	a1,0
     284:	4501                	li	a0,0
     286:	00001097          	auipc	ra,0x1
     28a:	bfe080e7          	jalr	-1026(ra) # e84 <wait>
    break;
     28e:	bd59                	j	124 <runcmd+0x72>
    if(fork1() == 0)
     290:	00000097          	auipc	ra,0x0
     294:	df4080e7          	jalr	-524(ra) # 84 <fork1>
     298:	e80516e3          	bnez	a0,124 <runcmd+0x72>
      runcmd(bcmd->cmd);
     29c:	6488                	ld	a0,8(s1)
     29e:	00000097          	auipc	ra,0x0
     2a2:	e14080e7          	jalr	-492(ra) # b2 <runcmd>

00000000000002a6 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     2a6:	1101                	addi	sp,sp,-32
     2a8:	ec06                	sd	ra,24(sp)
     2aa:	e822                	sd	s0,16(sp)
     2ac:	e426                	sd	s1,8(sp)
     2ae:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	0a800513          	li	a0,168
     2b4:	00001097          	auipc	ra,0x1
     2b8:	026080e7          	jalr	38(ra) # 12da <malloc>
     2bc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2be:	0a800613          	li	a2,168
     2c2:	4581                	li	a1,0
     2c4:	00001097          	auipc	ra,0x1
     2c8:	9b4080e7          	jalr	-1612(ra) # c78 <memset>
  cmd->type = EXEC;
     2cc:	4785                	li	a5,1
     2ce:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2d0:	8526                	mv	a0,s1
     2d2:	60e2                	ld	ra,24(sp)
     2d4:	6442                	ld	s0,16(sp)
     2d6:	64a2                	ld	s1,8(sp)
     2d8:	6105                	addi	sp,sp,32
     2da:	8082                	ret

00000000000002dc <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2dc:	7139                	addi	sp,sp,-64
     2de:	fc06                	sd	ra,56(sp)
     2e0:	f822                	sd	s0,48(sp)
     2e2:	f426                	sd	s1,40(sp)
     2e4:	f04a                	sd	s2,32(sp)
     2e6:	ec4e                	sd	s3,24(sp)
     2e8:	e852                	sd	s4,16(sp)
     2ea:	e456                	sd	s5,8(sp)
     2ec:	e05a                	sd	s6,0(sp)
     2ee:	0080                	addi	s0,sp,64
     2f0:	8b2a                	mv	s6,a0
     2f2:	8aae                	mv	s5,a1
     2f4:	8a32                	mv	s4,a2
     2f6:	89b6                	mv	s3,a3
     2f8:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2fa:	02800513          	li	a0,40
     2fe:	00001097          	auipc	ra,0x1
     302:	fdc080e7          	jalr	-36(ra) # 12da <malloc>
     306:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     308:	02800613          	li	a2,40
     30c:	4581                	li	a1,0
     30e:	00001097          	auipc	ra,0x1
     312:	96a080e7          	jalr	-1686(ra) # c78 <memset>
  cmd->type = REDIR;
     316:	4789                	li	a5,2
     318:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     31a:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     31e:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     322:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     326:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     32a:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     32e:	8526                	mv	a0,s1
     330:	70e2                	ld	ra,56(sp)
     332:	7442                	ld	s0,48(sp)
     334:	74a2                	ld	s1,40(sp)
     336:	7902                	ld	s2,32(sp)
     338:	69e2                	ld	s3,24(sp)
     33a:	6a42                	ld	s4,16(sp)
     33c:	6aa2                	ld	s5,8(sp)
     33e:	6b02                	ld	s6,0(sp)
     340:	6121                	addi	sp,sp,64
     342:	8082                	ret

0000000000000344 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     344:	7179                	addi	sp,sp,-48
     346:	f406                	sd	ra,40(sp)
     348:	f022                	sd	s0,32(sp)
     34a:	ec26                	sd	s1,24(sp)
     34c:	e84a                	sd	s2,16(sp)
     34e:	e44e                	sd	s3,8(sp)
     350:	1800                	addi	s0,sp,48
     352:	89aa                	mv	s3,a0
     354:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     356:	4561                	li	a0,24
     358:	00001097          	auipc	ra,0x1
     35c:	f82080e7          	jalr	-126(ra) # 12da <malloc>
     360:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     362:	4661                	li	a2,24
     364:	4581                	li	a1,0
     366:	00001097          	auipc	ra,0x1
     36a:	912080e7          	jalr	-1774(ra) # c78 <memset>
  cmd->type = PIPE;
     36e:	478d                	li	a5,3
     370:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     372:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     376:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     37a:	8526                	mv	a0,s1
     37c:	70a2                	ld	ra,40(sp)
     37e:	7402                	ld	s0,32(sp)
     380:	64e2                	ld	s1,24(sp)
     382:	6942                	ld	s2,16(sp)
     384:	69a2                	ld	s3,8(sp)
     386:	6145                	addi	sp,sp,48
     388:	8082                	ret

000000000000038a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     38a:	7179                	addi	sp,sp,-48
     38c:	f406                	sd	ra,40(sp)
     38e:	f022                	sd	s0,32(sp)
     390:	ec26                	sd	s1,24(sp)
     392:	e84a                	sd	s2,16(sp)
     394:	e44e                	sd	s3,8(sp)
     396:	1800                	addi	s0,sp,48
     398:	89aa                	mv	s3,a0
     39a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     39c:	4561                	li	a0,24
     39e:	00001097          	auipc	ra,0x1
     3a2:	f3c080e7          	jalr	-196(ra) # 12da <malloc>
     3a6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3a8:	4661                	li	a2,24
     3aa:	4581                	li	a1,0
     3ac:	00001097          	auipc	ra,0x1
     3b0:	8cc080e7          	jalr	-1844(ra) # c78 <memset>
  cmd->type = LIST;
     3b4:	4791                	li	a5,4
     3b6:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     3b8:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     3bc:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     3c0:	8526                	mv	a0,s1
     3c2:	70a2                	ld	ra,40(sp)
     3c4:	7402                	ld	s0,32(sp)
     3c6:	64e2                	ld	s1,24(sp)
     3c8:	6942                	ld	s2,16(sp)
     3ca:	69a2                	ld	s3,8(sp)
     3cc:	6145                	addi	sp,sp,48
     3ce:	8082                	ret

00000000000003d0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3d0:	1101                	addi	sp,sp,-32
     3d2:	ec06                	sd	ra,24(sp)
     3d4:	e822                	sd	s0,16(sp)
     3d6:	e426                	sd	s1,8(sp)
     3d8:	e04a                	sd	s2,0(sp)
     3da:	1000                	addi	s0,sp,32
     3dc:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3de:	4541                	li	a0,16
     3e0:	00001097          	auipc	ra,0x1
     3e4:	efa080e7          	jalr	-262(ra) # 12da <malloc>
     3e8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3ea:	4641                	li	a2,16
     3ec:	4581                	li	a1,0
     3ee:	00001097          	auipc	ra,0x1
     3f2:	88a080e7          	jalr	-1910(ra) # c78 <memset>
  cmd->type = BACK;
     3f6:	4795                	li	a5,5
     3f8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3fa:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3fe:	8526                	mv	a0,s1
     400:	60e2                	ld	ra,24(sp)
     402:	6442                	ld	s0,16(sp)
     404:	64a2                	ld	s1,8(sp)
     406:	6902                	ld	s2,0(sp)
     408:	6105                	addi	sp,sp,32
     40a:	8082                	ret

000000000000040c <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     40c:	7139                	addi	sp,sp,-64
     40e:	fc06                	sd	ra,56(sp)
     410:	f822                	sd	s0,48(sp)
     412:	f426                	sd	s1,40(sp)
     414:	f04a                	sd	s2,32(sp)
     416:	ec4e                	sd	s3,24(sp)
     418:	e852                	sd	s4,16(sp)
     41a:	e456                	sd	s5,8(sp)
     41c:	e05a                	sd	s6,0(sp)
     41e:	0080                	addi	s0,sp,64
     420:	8a2a                	mv	s4,a0
     422:	892e                	mv	s2,a1
     424:	8ab2                	mv	s5,a2
     426:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     428:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     42a:	00002997          	auipc	s3,0x2
     42e:	bde98993          	addi	s3,s3,-1058 # 2008 <whitespace>
     432:	00b4fd63          	bgeu	s1,a1,44c <gettoken+0x40>
     436:	0004c583          	lbu	a1,0(s1)
     43a:	854e                	mv	a0,s3
     43c:	00001097          	auipc	ra,0x1
     440:	862080e7          	jalr	-1950(ra) # c9e <strchr>
     444:	c501                	beqz	a0,44c <gettoken+0x40>
    s++;
     446:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     448:	fe9917e3          	bne	s2,s1,436 <gettoken+0x2a>
  if(q)
     44c:	000a8463          	beqz	s5,454 <gettoken+0x48>
    *q = s;
     450:	009ab023          	sd	s1,0(s5)
  ret = *s;
     454:	0004c783          	lbu	a5,0(s1)
     458:	00078a9b          	sext.w	s5,a5
  switch(*s){
     45c:	03c00713          	li	a4,60
     460:	06f76563          	bltu	a4,a5,4ca <gettoken+0xbe>
     464:	03a00713          	li	a4,58
     468:	00f76e63          	bltu	a4,a5,484 <gettoken+0x78>
     46c:	cf89                	beqz	a5,486 <gettoken+0x7a>
     46e:	02600713          	li	a4,38
     472:	00e78963          	beq	a5,a4,484 <gettoken+0x78>
     476:	fd87879b          	addiw	a5,a5,-40
     47a:	0ff7f793          	andi	a5,a5,255
     47e:	4705                	li	a4,1
     480:	06f76c63          	bltu	a4,a5,4f8 <gettoken+0xec>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     484:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     486:	000b0463          	beqz	s6,48e <gettoken+0x82>
    *eq = s;
     48a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     48e:	00002997          	auipc	s3,0x2
     492:	b7a98993          	addi	s3,s3,-1158 # 2008 <whitespace>
     496:	0124fd63          	bgeu	s1,s2,4b0 <gettoken+0xa4>
     49a:	0004c583          	lbu	a1,0(s1)
     49e:	854e                	mv	a0,s3
     4a0:	00000097          	auipc	ra,0x0
     4a4:	7fe080e7          	jalr	2046(ra) # c9e <strchr>
     4a8:	c501                	beqz	a0,4b0 <gettoken+0xa4>
    s++;
     4aa:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     4ac:	fe9917e3          	bne	s2,s1,49a <gettoken+0x8e>
  *ps = s;
     4b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     4b4:	8556                	mv	a0,s5
     4b6:	70e2                	ld	ra,56(sp)
     4b8:	7442                	ld	s0,48(sp)
     4ba:	74a2                	ld	s1,40(sp)
     4bc:	7902                	ld	s2,32(sp)
     4be:	69e2                	ld	s3,24(sp)
     4c0:	6a42                	ld	s4,16(sp)
     4c2:	6aa2                	ld	s5,8(sp)
     4c4:	6b02                	ld	s6,0(sp)
     4c6:	6121                	addi	sp,sp,64
     4c8:	8082                	ret
  switch(*s){
     4ca:	03e00713          	li	a4,62
     4ce:	02e79163          	bne	a5,a4,4f0 <gettoken+0xe4>
    s++;
     4d2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4d6:	0014c703          	lbu	a4,1(s1)
     4da:	03e00793          	li	a5,62
      s++;
     4de:	0489                	addi	s1,s1,2
      ret = '+';
     4e0:	02b00a93          	li	s5,43
    if(*s == '>'){
     4e4:	faf701e3          	beq	a4,a5,486 <gettoken+0x7a>
    s++;
     4e8:	84b6                	mv	s1,a3
  ret = *s;
     4ea:	03e00a93          	li	s5,62
     4ee:	bf61                	j	486 <gettoken+0x7a>
  switch(*s){
     4f0:	07c00713          	li	a4,124
     4f4:	f8e788e3          	beq	a5,a4,484 <gettoken+0x78>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4f8:	00002997          	auipc	s3,0x2
     4fc:	b1098993          	addi	s3,s3,-1264 # 2008 <whitespace>
     500:	00002a97          	auipc	s5,0x2
     504:	b00a8a93          	addi	s5,s5,-1280 # 2000 <symbols>
     508:	0324f563          	bgeu	s1,s2,532 <gettoken+0x126>
     50c:	0004c583          	lbu	a1,0(s1)
     510:	854e                	mv	a0,s3
     512:	00000097          	auipc	ra,0x0
     516:	78c080e7          	jalr	1932(ra) # c9e <strchr>
     51a:	e505                	bnez	a0,542 <gettoken+0x136>
     51c:	0004c583          	lbu	a1,0(s1)
     520:	8556                	mv	a0,s5
     522:	00000097          	auipc	ra,0x0
     526:	77c080e7          	jalr	1916(ra) # c9e <strchr>
     52a:	e909                	bnez	a0,53c <gettoken+0x130>
      s++;
     52c:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     52e:	fc991fe3          	bne	s2,s1,50c <gettoken+0x100>
  if(eq)
     532:	06100a93          	li	s5,97
     536:	f40b1ae3          	bnez	s6,48a <gettoken+0x7e>
     53a:	bf9d                	j	4b0 <gettoken+0xa4>
    ret = 'a';
     53c:	06100a93          	li	s5,97
     540:	b799                	j	486 <gettoken+0x7a>
     542:	06100a93          	li	s5,97
     546:	b781                	j	486 <gettoken+0x7a>

0000000000000548 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     548:	7139                	addi	sp,sp,-64
     54a:	fc06                	sd	ra,56(sp)
     54c:	f822                	sd	s0,48(sp)
     54e:	f426                	sd	s1,40(sp)
     550:	f04a                	sd	s2,32(sp)
     552:	ec4e                	sd	s3,24(sp)
     554:	e852                	sd	s4,16(sp)
     556:	e456                	sd	s5,8(sp)
     558:	0080                	addi	s0,sp,64
     55a:	8a2a                	mv	s4,a0
     55c:	892e                	mv	s2,a1
     55e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     560:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     562:	00002997          	auipc	s3,0x2
     566:	aa698993          	addi	s3,s3,-1370 # 2008 <whitespace>
     56a:	00b4fd63          	bgeu	s1,a1,584 <peek+0x3c>
     56e:	0004c583          	lbu	a1,0(s1)
     572:	854e                	mv	a0,s3
     574:	00000097          	auipc	ra,0x0
     578:	72a080e7          	jalr	1834(ra) # c9e <strchr>
     57c:	c501                	beqz	a0,584 <peek+0x3c>
    s++;
     57e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     580:	fe9917e3          	bne	s2,s1,56e <peek+0x26>
  *ps = s;
     584:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     588:	0004c583          	lbu	a1,0(s1)
     58c:	4501                	li	a0,0
     58e:	e991                	bnez	a1,5a2 <peek+0x5a>
}
     590:	70e2                	ld	ra,56(sp)
     592:	7442                	ld	s0,48(sp)
     594:	74a2                	ld	s1,40(sp)
     596:	7902                	ld	s2,32(sp)
     598:	69e2                	ld	s3,24(sp)
     59a:	6a42                	ld	s4,16(sp)
     59c:	6aa2                	ld	s5,8(sp)
     59e:	6121                	addi	sp,sp,64
     5a0:	8082                	ret
  return *s && strchr(toks, *s);
     5a2:	8556                	mv	a0,s5
     5a4:	00000097          	auipc	ra,0x0
     5a8:	6fa080e7          	jalr	1786(ra) # c9e <strchr>
     5ac:	00a03533          	snez	a0,a0
     5b0:	b7c5                	j	590 <peek+0x48>

00000000000005b2 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     5b2:	7159                	addi	sp,sp,-112
     5b4:	f486                	sd	ra,104(sp)
     5b6:	f0a2                	sd	s0,96(sp)
     5b8:	eca6                	sd	s1,88(sp)
     5ba:	e8ca                	sd	s2,80(sp)
     5bc:	e4ce                	sd	s3,72(sp)
     5be:	e0d2                	sd	s4,64(sp)
     5c0:	fc56                	sd	s5,56(sp)
     5c2:	f85a                	sd	s6,48(sp)
     5c4:	f45e                	sd	s7,40(sp)
     5c6:	f062                	sd	s8,32(sp)
     5c8:	ec66                	sd	s9,24(sp)
     5ca:	1880                	addi	s0,sp,112
     5cc:	8a2a                	mv	s4,a0
     5ce:	89ae                	mv	s3,a1
     5d0:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5d2:	00001b97          	auipc	s7,0x1
     5d6:	e5eb8b93          	addi	s7,s7,-418 # 1430 <malloc+0x156>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5da:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     5de:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     5e2:	a02d                	j	60c <parseredirs+0x5a>
      panic("missing file for redirection");
     5e4:	00001517          	auipc	a0,0x1
     5e8:	e2c50513          	addi	a0,a0,-468 # 1410 <malloc+0x136>
     5ec:	00000097          	auipc	ra,0x0
     5f0:	a6a080e7          	jalr	-1430(ra) # 56 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5f4:	4701                	li	a4,0
     5f6:	4681                	li	a3,0
     5f8:	f9043603          	ld	a2,-112(s0)
     5fc:	f9843583          	ld	a1,-104(s0)
     600:	8552                	mv	a0,s4
     602:	00000097          	auipc	ra,0x0
     606:	cda080e7          	jalr	-806(ra) # 2dc <redircmd>
     60a:	8a2a                	mv	s4,a0
    switch(tok){
     60c:	03e00b13          	li	s6,62
     610:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     614:	865e                	mv	a2,s7
     616:	85ca                	mv	a1,s2
     618:	854e                	mv	a0,s3
     61a:	00000097          	auipc	ra,0x0
     61e:	f2e080e7          	jalr	-210(ra) # 548 <peek>
     622:	c925                	beqz	a0,692 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     624:	4681                	li	a3,0
     626:	4601                	li	a2,0
     628:	85ca                	mv	a1,s2
     62a:	854e                	mv	a0,s3
     62c:	00000097          	auipc	ra,0x0
     630:	de0080e7          	jalr	-544(ra) # 40c <gettoken>
     634:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     636:	f9040693          	addi	a3,s0,-112
     63a:	f9840613          	addi	a2,s0,-104
     63e:	85ca                	mv	a1,s2
     640:	854e                	mv	a0,s3
     642:	00000097          	auipc	ra,0x0
     646:	dca080e7          	jalr	-566(ra) # 40c <gettoken>
     64a:	f9851de3          	bne	a0,s8,5e4 <parseredirs+0x32>
    switch(tok){
     64e:	fb9483e3          	beq	s1,s9,5f4 <parseredirs+0x42>
     652:	03648263          	beq	s1,s6,676 <parseredirs+0xc4>
     656:	fb549fe3          	bne	s1,s5,614 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     65a:	4705                	li	a4,1
     65c:	20100693          	li	a3,513
     660:	f9043603          	ld	a2,-112(s0)
     664:	f9843583          	ld	a1,-104(s0)
     668:	8552                	mv	a0,s4
     66a:	00000097          	auipc	ra,0x0
     66e:	c72080e7          	jalr	-910(ra) # 2dc <redircmd>
     672:	8a2a                	mv	s4,a0
      break;
     674:	bf61                	j	60c <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     676:	4705                	li	a4,1
     678:	60100693          	li	a3,1537
     67c:	f9043603          	ld	a2,-112(s0)
     680:	f9843583          	ld	a1,-104(s0)
     684:	8552                	mv	a0,s4
     686:	00000097          	auipc	ra,0x0
     68a:	c56080e7          	jalr	-938(ra) # 2dc <redircmd>
     68e:	8a2a                	mv	s4,a0
      break;
     690:	bfb5                	j	60c <parseredirs+0x5a>
    }
  }
  return cmd;
}
     692:	8552                	mv	a0,s4
     694:	70a6                	ld	ra,104(sp)
     696:	7406                	ld	s0,96(sp)
     698:	64e6                	ld	s1,88(sp)
     69a:	6946                	ld	s2,80(sp)
     69c:	69a6                	ld	s3,72(sp)
     69e:	6a06                	ld	s4,64(sp)
     6a0:	7ae2                	ld	s5,56(sp)
     6a2:	7b42                	ld	s6,48(sp)
     6a4:	7ba2                	ld	s7,40(sp)
     6a6:	7c02                	ld	s8,32(sp)
     6a8:	6ce2                	ld	s9,24(sp)
     6aa:	6165                	addi	sp,sp,112
     6ac:	8082                	ret

00000000000006ae <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     6ae:	7159                	addi	sp,sp,-112
     6b0:	f486                	sd	ra,104(sp)
     6b2:	f0a2                	sd	s0,96(sp)
     6b4:	eca6                	sd	s1,88(sp)
     6b6:	e8ca                	sd	s2,80(sp)
     6b8:	e4ce                	sd	s3,72(sp)
     6ba:	e0d2                	sd	s4,64(sp)
     6bc:	fc56                	sd	s5,56(sp)
     6be:	f85a                	sd	s6,48(sp)
     6c0:	f45e                	sd	s7,40(sp)
     6c2:	f062                	sd	s8,32(sp)
     6c4:	ec66                	sd	s9,24(sp)
     6c6:	1880                	addi	s0,sp,112
     6c8:	8a2a                	mv	s4,a0
     6ca:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     6cc:	00001617          	auipc	a2,0x1
     6d0:	d6c60613          	addi	a2,a2,-660 # 1438 <malloc+0x15e>
     6d4:	00000097          	auipc	ra,0x0
     6d8:	e74080e7          	jalr	-396(ra) # 548 <peek>
     6dc:	e905                	bnez	a0,70c <parseexec+0x5e>
     6de:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6e0:	00000097          	auipc	ra,0x0
     6e4:	bc6080e7          	jalr	-1082(ra) # 2a6 <execcmd>
     6e8:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6ea:	8656                	mv	a2,s5
     6ec:	85d2                	mv	a1,s4
     6ee:	00000097          	auipc	ra,0x0
     6f2:	ec4080e7          	jalr	-316(ra) # 5b2 <parseredirs>
     6f6:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6f8:	008c0913          	addi	s2,s8,8
     6fc:	00001b17          	auipc	s6,0x1
     700:	d5cb0b13          	addi	s6,s6,-676 # 1458 <malloc+0x17e>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     704:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     708:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     70a:	a0b1                	j	756 <parseexec+0xa8>
    return parseblock(ps, es);
     70c:	85d6                	mv	a1,s5
     70e:	8552                	mv	a0,s4
     710:	00000097          	auipc	ra,0x0
     714:	1bc080e7          	jalr	444(ra) # 8cc <parseblock>
     718:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     71a:	8526                	mv	a0,s1
     71c:	70a6                	ld	ra,104(sp)
     71e:	7406                	ld	s0,96(sp)
     720:	64e6                	ld	s1,88(sp)
     722:	6946                	ld	s2,80(sp)
     724:	69a6                	ld	s3,72(sp)
     726:	6a06                	ld	s4,64(sp)
     728:	7ae2                	ld	s5,56(sp)
     72a:	7b42                	ld	s6,48(sp)
     72c:	7ba2                	ld	s7,40(sp)
     72e:	7c02                	ld	s8,32(sp)
     730:	6ce2                	ld	s9,24(sp)
     732:	6165                	addi	sp,sp,112
     734:	8082                	ret
      panic("syntax");
     736:	00001517          	auipc	a0,0x1
     73a:	d0a50513          	addi	a0,a0,-758 # 1440 <malloc+0x166>
     73e:	00000097          	auipc	ra,0x0
     742:	918080e7          	jalr	-1768(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     746:	8656                	mv	a2,s5
     748:	85d2                	mv	a1,s4
     74a:	8526                	mv	a0,s1
     74c:	00000097          	auipc	ra,0x0
     750:	e66080e7          	jalr	-410(ra) # 5b2 <parseredirs>
     754:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     756:	865a                	mv	a2,s6
     758:	85d6                	mv	a1,s5
     75a:	8552                	mv	a0,s4
     75c:	00000097          	auipc	ra,0x0
     760:	dec080e7          	jalr	-532(ra) # 548 <peek>
     764:	e131                	bnez	a0,7a8 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     766:	f9040693          	addi	a3,s0,-112
     76a:	f9840613          	addi	a2,s0,-104
     76e:	85d6                	mv	a1,s5
     770:	8552                	mv	a0,s4
     772:	00000097          	auipc	ra,0x0
     776:	c9a080e7          	jalr	-870(ra) # 40c <gettoken>
     77a:	c51d                	beqz	a0,7a8 <parseexec+0xfa>
    if(tok != 'a')
     77c:	fb951de3          	bne	a0,s9,736 <parseexec+0x88>
    cmd->argv[argc] = q;
     780:	f9843783          	ld	a5,-104(s0)
     784:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     788:	f9043783          	ld	a5,-112(s0)
     78c:	04f93823          	sd	a5,80(s2)
    argc++;
     790:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     792:	0921                	addi	s2,s2,8
     794:	fb7999e3          	bne	s3,s7,746 <parseexec+0x98>
      panic("too many args");
     798:	00001517          	auipc	a0,0x1
     79c:	cb050513          	addi	a0,a0,-848 # 1448 <malloc+0x16e>
     7a0:	00000097          	auipc	ra,0x0
     7a4:	8b6080e7          	jalr	-1866(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     7a8:	098e                	slli	s3,s3,0x3
     7aa:	99e2                	add	s3,s3,s8
     7ac:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     7b0:	0409bc23          	sd	zero,88(s3)
  return ret;
     7b4:	b79d                	j	71a <parseexec+0x6c>

00000000000007b6 <parsepipe>:
{
     7b6:	7179                	addi	sp,sp,-48
     7b8:	f406                	sd	ra,40(sp)
     7ba:	f022                	sd	s0,32(sp)
     7bc:	ec26                	sd	s1,24(sp)
     7be:	e84a                	sd	s2,16(sp)
     7c0:	e44e                	sd	s3,8(sp)
     7c2:	1800                	addi	s0,sp,48
     7c4:	892a                	mv	s2,a0
     7c6:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7c8:	00000097          	auipc	ra,0x0
     7cc:	ee6080e7          	jalr	-282(ra) # 6ae <parseexec>
     7d0:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7d2:	00001617          	auipc	a2,0x1
     7d6:	c8e60613          	addi	a2,a2,-882 # 1460 <malloc+0x186>
     7da:	85ce                	mv	a1,s3
     7dc:	854a                	mv	a0,s2
     7de:	00000097          	auipc	ra,0x0
     7e2:	d6a080e7          	jalr	-662(ra) # 548 <peek>
     7e6:	e909                	bnez	a0,7f8 <parsepipe+0x42>
}
     7e8:	8526                	mv	a0,s1
     7ea:	70a2                	ld	ra,40(sp)
     7ec:	7402                	ld	s0,32(sp)
     7ee:	64e2                	ld	s1,24(sp)
     7f0:	6942                	ld	s2,16(sp)
     7f2:	69a2                	ld	s3,8(sp)
     7f4:	6145                	addi	sp,sp,48
     7f6:	8082                	ret
    gettoken(ps, es, 0, 0);
     7f8:	4681                	li	a3,0
     7fa:	4601                	li	a2,0
     7fc:	85ce                	mv	a1,s3
     7fe:	854a                	mv	a0,s2
     800:	00000097          	auipc	ra,0x0
     804:	c0c080e7          	jalr	-1012(ra) # 40c <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     808:	85ce                	mv	a1,s3
     80a:	854a                	mv	a0,s2
     80c:	00000097          	auipc	ra,0x0
     810:	faa080e7          	jalr	-86(ra) # 7b6 <parsepipe>
     814:	85aa                	mv	a1,a0
     816:	8526                	mv	a0,s1
     818:	00000097          	auipc	ra,0x0
     81c:	b2c080e7          	jalr	-1236(ra) # 344 <pipecmd>
     820:	84aa                	mv	s1,a0
  return cmd;
     822:	b7d9                	j	7e8 <parsepipe+0x32>

0000000000000824 <parseline>:
{
     824:	7179                	addi	sp,sp,-48
     826:	f406                	sd	ra,40(sp)
     828:	f022                	sd	s0,32(sp)
     82a:	ec26                	sd	s1,24(sp)
     82c:	e84a                	sd	s2,16(sp)
     82e:	e44e                	sd	s3,8(sp)
     830:	e052                	sd	s4,0(sp)
     832:	1800                	addi	s0,sp,48
     834:	892a                	mv	s2,a0
     836:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     838:	00000097          	auipc	ra,0x0
     83c:	f7e080e7          	jalr	-130(ra) # 7b6 <parsepipe>
     840:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     842:	00001a17          	auipc	s4,0x1
     846:	c26a0a13          	addi	s4,s4,-986 # 1468 <malloc+0x18e>
     84a:	8652                	mv	a2,s4
     84c:	85ce                	mv	a1,s3
     84e:	854a                	mv	a0,s2
     850:	00000097          	auipc	ra,0x0
     854:	cf8080e7          	jalr	-776(ra) # 548 <peek>
     858:	c105                	beqz	a0,878 <parseline+0x54>
    gettoken(ps, es, 0, 0);
     85a:	4681                	li	a3,0
     85c:	4601                	li	a2,0
     85e:	85ce                	mv	a1,s3
     860:	854a                	mv	a0,s2
     862:	00000097          	auipc	ra,0x0
     866:	baa080e7          	jalr	-1110(ra) # 40c <gettoken>
    cmd = backcmd(cmd);
     86a:	8526                	mv	a0,s1
     86c:	00000097          	auipc	ra,0x0
     870:	b64080e7          	jalr	-1180(ra) # 3d0 <backcmd>
     874:	84aa                	mv	s1,a0
     876:	bfd1                	j	84a <parseline+0x26>
  if(peek(ps, es, ";")){
     878:	00001617          	auipc	a2,0x1
     87c:	bf860613          	addi	a2,a2,-1032 # 1470 <malloc+0x196>
     880:	85ce                	mv	a1,s3
     882:	854a                	mv	a0,s2
     884:	00000097          	auipc	ra,0x0
     888:	cc4080e7          	jalr	-828(ra) # 548 <peek>
     88c:	e911                	bnez	a0,8a0 <parseline+0x7c>
}
     88e:	8526                	mv	a0,s1
     890:	70a2                	ld	ra,40(sp)
     892:	7402                	ld	s0,32(sp)
     894:	64e2                	ld	s1,24(sp)
     896:	6942                	ld	s2,16(sp)
     898:	69a2                	ld	s3,8(sp)
     89a:	6a02                	ld	s4,0(sp)
     89c:	6145                	addi	sp,sp,48
     89e:	8082                	ret
    gettoken(ps, es, 0, 0);
     8a0:	4681                	li	a3,0
     8a2:	4601                	li	a2,0
     8a4:	85ce                	mv	a1,s3
     8a6:	854a                	mv	a0,s2
     8a8:	00000097          	auipc	ra,0x0
     8ac:	b64080e7          	jalr	-1180(ra) # 40c <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8b0:	85ce                	mv	a1,s3
     8b2:	854a                	mv	a0,s2
     8b4:	00000097          	auipc	ra,0x0
     8b8:	f70080e7          	jalr	-144(ra) # 824 <parseline>
     8bc:	85aa                	mv	a1,a0
     8be:	8526                	mv	a0,s1
     8c0:	00000097          	auipc	ra,0x0
     8c4:	aca080e7          	jalr	-1334(ra) # 38a <listcmd>
     8c8:	84aa                	mv	s1,a0
  return cmd;
     8ca:	b7d1                	j	88e <parseline+0x6a>

00000000000008cc <parseblock>:
{
     8cc:	7179                	addi	sp,sp,-48
     8ce:	f406                	sd	ra,40(sp)
     8d0:	f022                	sd	s0,32(sp)
     8d2:	ec26                	sd	s1,24(sp)
     8d4:	e84a                	sd	s2,16(sp)
     8d6:	e44e                	sd	s3,8(sp)
     8d8:	1800                	addi	s0,sp,48
     8da:	84aa                	mv	s1,a0
     8dc:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8de:	00001617          	auipc	a2,0x1
     8e2:	b5a60613          	addi	a2,a2,-1190 # 1438 <malloc+0x15e>
     8e6:	00000097          	auipc	ra,0x0
     8ea:	c62080e7          	jalr	-926(ra) # 548 <peek>
     8ee:	c12d                	beqz	a0,950 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8f0:	4681                	li	a3,0
     8f2:	4601                	li	a2,0
     8f4:	85ca                	mv	a1,s2
     8f6:	8526                	mv	a0,s1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	b14080e7          	jalr	-1260(ra) # 40c <gettoken>
  cmd = parseline(ps, es);
     900:	85ca                	mv	a1,s2
     902:	8526                	mv	a0,s1
     904:	00000097          	auipc	ra,0x0
     908:	f20080e7          	jalr	-224(ra) # 824 <parseline>
     90c:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     90e:	00001617          	auipc	a2,0x1
     912:	b7a60613          	addi	a2,a2,-1158 # 1488 <malloc+0x1ae>
     916:	85ca                	mv	a1,s2
     918:	8526                	mv	a0,s1
     91a:	00000097          	auipc	ra,0x0
     91e:	c2e080e7          	jalr	-978(ra) # 548 <peek>
     922:	cd1d                	beqz	a0,960 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     924:	4681                	li	a3,0
     926:	4601                	li	a2,0
     928:	85ca                	mv	a1,s2
     92a:	8526                	mv	a0,s1
     92c:	00000097          	auipc	ra,0x0
     930:	ae0080e7          	jalr	-1312(ra) # 40c <gettoken>
  cmd = parseredirs(cmd, ps, es);
     934:	864a                	mv	a2,s2
     936:	85a6                	mv	a1,s1
     938:	854e                	mv	a0,s3
     93a:	00000097          	auipc	ra,0x0
     93e:	c78080e7          	jalr	-904(ra) # 5b2 <parseredirs>
}
     942:	70a2                	ld	ra,40(sp)
     944:	7402                	ld	s0,32(sp)
     946:	64e2                	ld	s1,24(sp)
     948:	6942                	ld	s2,16(sp)
     94a:	69a2                	ld	s3,8(sp)
     94c:	6145                	addi	sp,sp,48
     94e:	8082                	ret
    panic("parseblock");
     950:	00001517          	auipc	a0,0x1
     954:	b2850513          	addi	a0,a0,-1240 # 1478 <malloc+0x19e>
     958:	fffff097          	auipc	ra,0xfffff
     95c:	6fe080e7          	jalr	1790(ra) # 56 <panic>
    panic("syntax - missing )");
     960:	00001517          	auipc	a0,0x1
     964:	b3050513          	addi	a0,a0,-1232 # 1490 <malloc+0x1b6>
     968:	fffff097          	auipc	ra,0xfffff
     96c:	6ee080e7          	jalr	1774(ra) # 56 <panic>

0000000000000970 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     970:	1101                	addi	sp,sp,-32
     972:	ec06                	sd	ra,24(sp)
     974:	e822                	sd	s0,16(sp)
     976:	e426                	sd	s1,8(sp)
     978:	1000                	addi	s0,sp,32
     97a:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     97c:	c521                	beqz	a0,9c4 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     97e:	4118                	lw	a4,0(a0)
     980:	4795                	li	a5,5
     982:	04e7e163          	bltu	a5,a4,9c4 <nulterminate+0x54>
     986:	00056783          	lwu	a5,0(a0)
     98a:	078a                	slli	a5,a5,0x2
     98c:	00001717          	auipc	a4,0x1
     990:	b7070713          	addi	a4,a4,-1168 # 14fc <malloc+0x222>
     994:	97ba                	add	a5,a5,a4
     996:	439c                	lw	a5,0(a5)
     998:	97ba                	add	a5,a5,a4
     99a:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     99c:	651c                	ld	a5,8(a0)
     99e:	c39d                	beqz	a5,9c4 <nulterminate+0x54>
     9a0:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     9a4:	67b8                	ld	a4,72(a5)
     9a6:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     9aa:	07a1                	addi	a5,a5,8
     9ac:	ff87b703          	ld	a4,-8(a5)
     9b0:	fb75                	bnez	a4,9a4 <nulterminate+0x34>
     9b2:	a809                	j	9c4 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     9b4:	6508                	ld	a0,8(a0)
     9b6:	00000097          	auipc	ra,0x0
     9ba:	fba080e7          	jalr	-70(ra) # 970 <nulterminate>
    *rcmd->efile = 0;
     9be:	6c9c                	ld	a5,24(s1)
     9c0:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9c4:	8526                	mv	a0,s1
     9c6:	60e2                	ld	ra,24(sp)
     9c8:	6442                	ld	s0,16(sp)
     9ca:	64a2                	ld	s1,8(sp)
     9cc:	6105                	addi	sp,sp,32
     9ce:	8082                	ret
    nulterminate(pcmd->left);
     9d0:	6508                	ld	a0,8(a0)
     9d2:	00000097          	auipc	ra,0x0
     9d6:	f9e080e7          	jalr	-98(ra) # 970 <nulterminate>
    nulterminate(pcmd->right);
     9da:	6888                	ld	a0,16(s1)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	f94080e7          	jalr	-108(ra) # 970 <nulterminate>
    break;
     9e4:	b7c5                	j	9c4 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9e6:	6508                	ld	a0,8(a0)
     9e8:	00000097          	auipc	ra,0x0
     9ec:	f88080e7          	jalr	-120(ra) # 970 <nulterminate>
    nulterminate(lcmd->right);
     9f0:	6888                	ld	a0,16(s1)
     9f2:	00000097          	auipc	ra,0x0
     9f6:	f7e080e7          	jalr	-130(ra) # 970 <nulterminate>
    break;
     9fa:	b7e9                	j	9c4 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9fc:	6508                	ld	a0,8(a0)
     9fe:	00000097          	auipc	ra,0x0
     a02:	f72080e7          	jalr	-142(ra) # 970 <nulterminate>
    break;
     a06:	bf7d                	j	9c4 <nulterminate+0x54>

0000000000000a08 <parsecmd>:
{
     a08:	7179                	addi	sp,sp,-48
     a0a:	f406                	sd	ra,40(sp)
     a0c:	f022                	sd	s0,32(sp)
     a0e:	ec26                	sd	s1,24(sp)
     a10:	e84a                	sd	s2,16(sp)
     a12:	1800                	addi	s0,sp,48
     a14:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     a18:	84aa                	mv	s1,a0
     a1a:	00000097          	auipc	ra,0x0
     a1e:	234080e7          	jalr	564(ra) # c4e <strlen>
     a22:	1502                	slli	a0,a0,0x20
     a24:	9101                	srli	a0,a0,0x20
     a26:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a28:	85a6                	mv	a1,s1
     a2a:	fd840513          	addi	a0,s0,-40
     a2e:	00000097          	auipc	ra,0x0
     a32:	df6080e7          	jalr	-522(ra) # 824 <parseline>
     a36:	892a                	mv	s2,a0
  peek(&s, es, "");
     a38:	00001617          	auipc	a2,0x1
     a3c:	99860613          	addi	a2,a2,-1640 # 13d0 <malloc+0xf6>
     a40:	85a6                	mv	a1,s1
     a42:	fd840513          	addi	a0,s0,-40
     a46:	00000097          	auipc	ra,0x0
     a4a:	b02080e7          	jalr	-1278(ra) # 548 <peek>
  if(s != es){
     a4e:	fd843603          	ld	a2,-40(s0)
     a52:	00961e63          	bne	a2,s1,a6e <parsecmd+0x66>
  nulterminate(cmd);
     a56:	854a                	mv	a0,s2
     a58:	00000097          	auipc	ra,0x0
     a5c:	f18080e7          	jalr	-232(ra) # 970 <nulterminate>
}
     a60:	854a                	mv	a0,s2
     a62:	70a2                	ld	ra,40(sp)
     a64:	7402                	ld	s0,32(sp)
     a66:	64e2                	ld	s1,24(sp)
     a68:	6942                	ld	s2,16(sp)
     a6a:	6145                	addi	sp,sp,48
     a6c:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a6e:	00001597          	auipc	a1,0x1
     a72:	a3a58593          	addi	a1,a1,-1478 # 14a8 <malloc+0x1ce>
     a76:	4509                	li	a0,2
     a78:	00000097          	auipc	ra,0x0
     a7c:	776080e7          	jalr	1910(ra) # 11ee <fprintf>
    panic("syntax");
     a80:	00001517          	auipc	a0,0x1
     a84:	9c050513          	addi	a0,a0,-1600 # 1440 <malloc+0x166>
     a88:	fffff097          	auipc	ra,0xfffff
     a8c:	5ce080e7          	jalr	1486(ra) # 56 <panic>

0000000000000a90 <main>:
{
     a90:	7159                	addi	sp,sp,-112
     a92:	f486                	sd	ra,104(sp)
     a94:	f0a2                	sd	s0,96(sp)
     a96:	eca6                	sd	s1,88(sp)
     a98:	e8ca                	sd	s2,80(sp)
     a9a:	e4ce                	sd	s3,72(sp)
     a9c:	e0d2                	sd	s4,64(sp)
     a9e:	fc56                	sd	s5,56(sp)
     aa0:	f85a                	sd	s6,48(sp)
     aa2:	f45e                	sd	s7,40(sp)
     aa4:	1880                	addi	s0,sp,112
  while((fd = open("console", O_RDWR)) >= 0){
     aa6:	00001497          	auipc	s1,0x1
     aaa:	a1248493          	addi	s1,s1,-1518 # 14b8 <malloc+0x1de>
     aae:	4589                	li	a1,2
     ab0:	8526                	mv	a0,s1
     ab2:	00000097          	auipc	ra,0x0
     ab6:	40a080e7          	jalr	1034(ra) # ebc <open>
     aba:	00054963          	bltz	a0,acc <main+0x3c>
    if(fd >= 3){
     abe:	4789                	li	a5,2
     ac0:	fea7d7e3          	bge	a5,a0,aae <main+0x1e>
      close(fd);
     ac4:	00000097          	auipc	ra,0x0
     ac8:	3e0080e7          	jalr	992(ra) # ea4 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     acc:	00001497          	auipc	s1,0x1
     ad0:	55448493          	addi	s1,s1,1364 # 2020 <buf.1147>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ad4:	06300913          	li	s2,99
      if (pid == -1) {
     ad8:	59fd                	li	s3,-1
          write(1, "\n", 1);
     ada:	00001a17          	auipc	s4,0x1
     ade:	a06a0a13          	addi	s4,s4,-1530 # 14e0 <malloc+0x206>
        write(2, "wait failed\n", 12);
     ae2:	00001a97          	auipc	s5,0x1
     ae6:	9eea8a93          	addi	s5,s5,-1554 # 14d0 <malloc+0x1f6>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aea:	02000b13          	li	s6,32
      if(chdir(buf+3) < 0)
     aee:	00001b97          	auipc	s7,0x1
     af2:	535b8b93          	addi	s7,s7,1333 # 2023 <buf.1147+0x3>
     af6:	a0a9                	j	b40 <main+0xb0>
    if(fork1() == 0)
     af8:	fffff097          	auipc	ra,0xfffff
     afc:	58c080e7          	jalr	1420(ra) # 84 <fork1>
     b00:	c54d                	beqz	a0,baa <main+0x11a>
      int pid = wait(0, msg); // modified wait() call
     b02:	f9040593          	addi	a1,s0,-112
     b06:	4501                	li	a0,0
     b08:	00000097          	auipc	ra,0x0
     b0c:	37c080e7          	jalr	892(ra) # e84 <wait>
      if (pid == -1) {
     b10:	0b350963          	beq	a0,s3,bc2 <main+0x132>
          write(1, msg,strlen(msg));
     b14:	f9040513          	addi	a0,s0,-112
     b18:	00000097          	auipc	ra,0x0
     b1c:	136080e7          	jalr	310(ra) # c4e <strlen>
     b20:	0005061b          	sext.w	a2,a0
     b24:	f9040593          	addi	a1,s0,-112
     b28:	4505                	li	a0,1
     b2a:	00000097          	auipc	ra,0x0
     b2e:	372080e7          	jalr	882(ra) # e9c <write>
          write(1, "\n", 1);
     b32:	4605                	li	a2,1
     b34:	85d2                	mv	a1,s4
     b36:	4505                	li	a0,1
     b38:	00000097          	auipc	ra,0x0
     b3c:	364080e7          	jalr	868(ra) # e9c <write>
  while(getcmd(buf, sizeof(buf)) >= 0){
     b40:	06400593          	li	a1,100
     b44:	8526                	mv	a0,s1
     b46:	fffff097          	auipc	ra,0xfffff
     b4a:	4ba080e7          	jalr	1210(ra) # 0 <getcmd>
     b4e:	08054263          	bltz	a0,bd2 <main+0x142>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     b52:	0004c783          	lbu	a5,0(s1)
     b56:	fb2791e3          	bne	a5,s2,af8 <main+0x68>
     b5a:	0014c703          	lbu	a4,1(s1)
     b5e:	06400793          	li	a5,100
     b62:	f8f71be3          	bne	a4,a5,af8 <main+0x68>
     b66:	0024c783          	lbu	a5,2(s1)
     b6a:	f96797e3          	bne	a5,s6,af8 <main+0x68>
      buf[strlen(buf)-1] = 0;  // chop \n
     b6e:	8526                	mv	a0,s1
     b70:	00000097          	auipc	ra,0x0
     b74:	0de080e7          	jalr	222(ra) # c4e <strlen>
     b78:	fff5079b          	addiw	a5,a0,-1
     b7c:	1782                	slli	a5,a5,0x20
     b7e:	9381                	srli	a5,a5,0x20
     b80:	97a6                	add	a5,a5,s1
     b82:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     b86:	855e                	mv	a0,s7
     b88:	00000097          	auipc	ra,0x0
     b8c:	364080e7          	jalr	868(ra) # eec <chdir>
     b90:	fa0558e3          	bgez	a0,b40 <main+0xb0>
        fprintf(2, "cannot cd %s\n", buf+3);
     b94:	865e                	mv	a2,s7
     b96:	00001597          	auipc	a1,0x1
     b9a:	92a58593          	addi	a1,a1,-1750 # 14c0 <malloc+0x1e6>
     b9e:	4509                	li	a0,2
     ba0:	00000097          	auipc	ra,0x0
     ba4:	64e080e7          	jalr	1614(ra) # 11ee <fprintf>
     ba8:	bf61                	j	b40 <main+0xb0>
      runcmd(parsecmd(buf));
     baa:	00001517          	auipc	a0,0x1
     bae:	47650513          	addi	a0,a0,1142 # 2020 <buf.1147>
     bb2:	00000097          	auipc	ra,0x0
     bb6:	e56080e7          	jalr	-426(ra) # a08 <parsecmd>
     bba:	fffff097          	auipc	ra,0xfffff
     bbe:	4f8080e7          	jalr	1272(ra) # b2 <runcmd>
        write(2, "wait failed\n", 12);
     bc2:	4631                	li	a2,12
     bc4:	85d6                	mv	a1,s5
     bc6:	4509                	li	a0,2
     bc8:	00000097          	auipc	ra,0x0
     bcc:	2d4080e7          	jalr	724(ra) # e9c <write>
     bd0:	bf85                	j	b40 <main+0xb0>
  exit(0,"");
     bd2:	00000597          	auipc	a1,0x0
     bd6:	7fe58593          	addi	a1,a1,2046 # 13d0 <malloc+0xf6>
     bda:	4501                	li	a0,0
     bdc:	00000097          	auipc	ra,0x0
     be0:	2a0080e7          	jalr	672(ra) # e7c <exit>

0000000000000be4 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     be4:	1141                	addi	sp,sp,-16
     be6:	e406                	sd	ra,8(sp)
     be8:	e022                	sd	s0,0(sp)
     bea:	0800                	addi	s0,sp,16
  extern int main();
  main();
     bec:	00000097          	auipc	ra,0x0
     bf0:	ea4080e7          	jalr	-348(ra) # a90 <main>
  exit(0,"");
     bf4:	00000597          	auipc	a1,0x0
     bf8:	7dc58593          	addi	a1,a1,2012 # 13d0 <malloc+0xf6>
     bfc:	4501                	li	a0,0
     bfe:	00000097          	auipc	ra,0x0
     c02:	27e080e7          	jalr	638(ra) # e7c <exit>

0000000000000c06 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     c06:	1141                	addi	sp,sp,-16
     c08:	e422                	sd	s0,8(sp)
     c0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c0c:	87aa                	mv	a5,a0
     c0e:	0585                	addi	a1,a1,1
     c10:	0785                	addi	a5,a5,1
     c12:	fff5c703          	lbu	a4,-1(a1)
     c16:	fee78fa3          	sb	a4,-1(a5)
     c1a:	fb75                	bnez	a4,c0e <strcpy+0x8>
    ;
  return os;
}
     c1c:	6422                	ld	s0,8(sp)
     c1e:	0141                	addi	sp,sp,16
     c20:	8082                	ret

0000000000000c22 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c22:	1141                	addi	sp,sp,-16
     c24:	e422                	sd	s0,8(sp)
     c26:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c28:	00054783          	lbu	a5,0(a0)
     c2c:	cb91                	beqz	a5,c40 <strcmp+0x1e>
     c2e:	0005c703          	lbu	a4,0(a1)
     c32:	00f71763          	bne	a4,a5,c40 <strcmp+0x1e>
    p++, q++;
     c36:	0505                	addi	a0,a0,1
     c38:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c3a:	00054783          	lbu	a5,0(a0)
     c3e:	fbe5                	bnez	a5,c2e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c40:	0005c503          	lbu	a0,0(a1)
}
     c44:	40a7853b          	subw	a0,a5,a0
     c48:	6422                	ld	s0,8(sp)
     c4a:	0141                	addi	sp,sp,16
     c4c:	8082                	ret

0000000000000c4e <strlen>:

uint
strlen(const char *s)
{
     c4e:	1141                	addi	sp,sp,-16
     c50:	e422                	sd	s0,8(sp)
     c52:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c54:	00054783          	lbu	a5,0(a0)
     c58:	cf91                	beqz	a5,c74 <strlen+0x26>
     c5a:	0505                	addi	a0,a0,1
     c5c:	87aa                	mv	a5,a0
     c5e:	4685                	li	a3,1
     c60:	9e89                	subw	a3,a3,a0
     c62:	00f6853b          	addw	a0,a3,a5
     c66:	0785                	addi	a5,a5,1
     c68:	fff7c703          	lbu	a4,-1(a5)
     c6c:	fb7d                	bnez	a4,c62 <strlen+0x14>
    ;
  return n;
}
     c6e:	6422                	ld	s0,8(sp)
     c70:	0141                	addi	sp,sp,16
     c72:	8082                	ret
  for(n = 0; s[n]; n++)
     c74:	4501                	li	a0,0
     c76:	bfe5                	j	c6e <strlen+0x20>

0000000000000c78 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c78:	1141                	addi	sp,sp,-16
     c7a:	e422                	sd	s0,8(sp)
     c7c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c7e:	ce09                	beqz	a2,c98 <memset+0x20>
     c80:	87aa                	mv	a5,a0
     c82:	fff6071b          	addiw	a4,a2,-1
     c86:	1702                	slli	a4,a4,0x20
     c88:	9301                	srli	a4,a4,0x20
     c8a:	0705                	addi	a4,a4,1
     c8c:	972a                	add	a4,a4,a0
    cdst[i] = c;
     c8e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c92:	0785                	addi	a5,a5,1
     c94:	fee79de3          	bne	a5,a4,c8e <memset+0x16>
  }
  return dst;
}
     c98:	6422                	ld	s0,8(sp)
     c9a:	0141                	addi	sp,sp,16
     c9c:	8082                	ret

0000000000000c9e <strchr>:

char*
strchr(const char *s, char c)
{
     c9e:	1141                	addi	sp,sp,-16
     ca0:	e422                	sd	s0,8(sp)
     ca2:	0800                	addi	s0,sp,16
  for(; *s; s++)
     ca4:	00054783          	lbu	a5,0(a0)
     ca8:	cb99                	beqz	a5,cbe <strchr+0x20>
    if(*s == c)
     caa:	00f58763          	beq	a1,a5,cb8 <strchr+0x1a>
  for(; *s; s++)
     cae:	0505                	addi	a0,a0,1
     cb0:	00054783          	lbu	a5,0(a0)
     cb4:	fbfd                	bnez	a5,caa <strchr+0xc>
      return (char*)s;
  return 0;
     cb6:	4501                	li	a0,0
}
     cb8:	6422                	ld	s0,8(sp)
     cba:	0141                	addi	sp,sp,16
     cbc:	8082                	ret
  return 0;
     cbe:	4501                	li	a0,0
     cc0:	bfe5                	j	cb8 <strchr+0x1a>

0000000000000cc2 <gets>:

char*
gets(char *buf, int max)
{
     cc2:	711d                	addi	sp,sp,-96
     cc4:	ec86                	sd	ra,88(sp)
     cc6:	e8a2                	sd	s0,80(sp)
     cc8:	e4a6                	sd	s1,72(sp)
     cca:	e0ca                	sd	s2,64(sp)
     ccc:	fc4e                	sd	s3,56(sp)
     cce:	f852                	sd	s4,48(sp)
     cd0:	f456                	sd	s5,40(sp)
     cd2:	f05a                	sd	s6,32(sp)
     cd4:	ec5e                	sd	s7,24(sp)
     cd6:	1080                	addi	s0,sp,96
     cd8:	8baa                	mv	s7,a0
     cda:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cdc:	892a                	mv	s2,a0
     cde:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     ce0:	4aa9                	li	s5,10
     ce2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     ce4:	89a6                	mv	s3,s1
     ce6:	2485                	addiw	s1,s1,1
     ce8:	0344d863          	bge	s1,s4,d18 <gets+0x56>
    cc = read(0, &c, 1);
     cec:	4605                	li	a2,1
     cee:	faf40593          	addi	a1,s0,-81
     cf2:	4501                	li	a0,0
     cf4:	00000097          	auipc	ra,0x0
     cf8:	1a0080e7          	jalr	416(ra) # e94 <read>
    if(cc < 1)
     cfc:	00a05e63          	blez	a0,d18 <gets+0x56>
    buf[i++] = c;
     d00:	faf44783          	lbu	a5,-81(s0)
     d04:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d08:	01578763          	beq	a5,s5,d16 <gets+0x54>
     d0c:	0905                	addi	s2,s2,1
     d0e:	fd679be3          	bne	a5,s6,ce4 <gets+0x22>
  for(i=0; i+1 < max; ){
     d12:	89a6                	mv	s3,s1
     d14:	a011                	j	d18 <gets+0x56>
     d16:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d18:	99de                	add	s3,s3,s7
     d1a:	00098023          	sb	zero,0(s3)
  return buf;
}
     d1e:	855e                	mv	a0,s7
     d20:	60e6                	ld	ra,88(sp)
     d22:	6446                	ld	s0,80(sp)
     d24:	64a6                	ld	s1,72(sp)
     d26:	6906                	ld	s2,64(sp)
     d28:	79e2                	ld	s3,56(sp)
     d2a:	7a42                	ld	s4,48(sp)
     d2c:	7aa2                	ld	s5,40(sp)
     d2e:	7b02                	ld	s6,32(sp)
     d30:	6be2                	ld	s7,24(sp)
     d32:	6125                	addi	sp,sp,96
     d34:	8082                	ret

0000000000000d36 <stat>:

int
stat(const char *n, struct stat *st)
{
     d36:	1101                	addi	sp,sp,-32
     d38:	ec06                	sd	ra,24(sp)
     d3a:	e822                	sd	s0,16(sp)
     d3c:	e426                	sd	s1,8(sp)
     d3e:	e04a                	sd	s2,0(sp)
     d40:	1000                	addi	s0,sp,32
     d42:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d44:	4581                	li	a1,0
     d46:	00000097          	auipc	ra,0x0
     d4a:	176080e7          	jalr	374(ra) # ebc <open>
  if(fd < 0)
     d4e:	02054563          	bltz	a0,d78 <stat+0x42>
     d52:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d54:	85ca                	mv	a1,s2
     d56:	00000097          	auipc	ra,0x0
     d5a:	17e080e7          	jalr	382(ra) # ed4 <fstat>
     d5e:	892a                	mv	s2,a0
  close(fd);
     d60:	8526                	mv	a0,s1
     d62:	00000097          	auipc	ra,0x0
     d66:	142080e7          	jalr	322(ra) # ea4 <close>
  return r;
}
     d6a:	854a                	mv	a0,s2
     d6c:	60e2                	ld	ra,24(sp)
     d6e:	6442                	ld	s0,16(sp)
     d70:	64a2                	ld	s1,8(sp)
     d72:	6902                	ld	s2,0(sp)
     d74:	6105                	addi	sp,sp,32
     d76:	8082                	ret
    return -1;
     d78:	597d                	li	s2,-1
     d7a:	bfc5                	j	d6a <stat+0x34>

0000000000000d7c <atoi>:

int
atoi(const char *s)
{
     d7c:	1141                	addi	sp,sp,-16
     d7e:	e422                	sd	s0,8(sp)
     d80:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d82:	00054603          	lbu	a2,0(a0)
     d86:	fd06079b          	addiw	a5,a2,-48
     d8a:	0ff7f793          	andi	a5,a5,255
     d8e:	4725                	li	a4,9
     d90:	02f76963          	bltu	a4,a5,dc2 <atoi+0x46>
     d94:	86aa                	mv	a3,a0
  n = 0;
     d96:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     d98:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     d9a:	0685                	addi	a3,a3,1
     d9c:	0025179b          	slliw	a5,a0,0x2
     da0:	9fa9                	addw	a5,a5,a0
     da2:	0017979b          	slliw	a5,a5,0x1
     da6:	9fb1                	addw	a5,a5,a2
     da8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     dac:	0006c603          	lbu	a2,0(a3)
     db0:	fd06071b          	addiw	a4,a2,-48
     db4:	0ff77713          	andi	a4,a4,255
     db8:	fee5f1e3          	bgeu	a1,a4,d9a <atoi+0x1e>
  return n;
}
     dbc:	6422                	ld	s0,8(sp)
     dbe:	0141                	addi	sp,sp,16
     dc0:	8082                	ret
  n = 0;
     dc2:	4501                	li	a0,0
     dc4:	bfe5                	j	dbc <atoi+0x40>

0000000000000dc6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     dc6:	1141                	addi	sp,sp,-16
     dc8:	e422                	sd	s0,8(sp)
     dca:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     dcc:	02b57663          	bgeu	a0,a1,df8 <memmove+0x32>
    while(n-- > 0)
     dd0:	02c05163          	blez	a2,df2 <memmove+0x2c>
     dd4:	fff6079b          	addiw	a5,a2,-1
     dd8:	1782                	slli	a5,a5,0x20
     dda:	9381                	srli	a5,a5,0x20
     ddc:	0785                	addi	a5,a5,1
     dde:	97aa                	add	a5,a5,a0
  dst = vdst;
     de0:	872a                	mv	a4,a0
      *dst++ = *src++;
     de2:	0585                	addi	a1,a1,1
     de4:	0705                	addi	a4,a4,1
     de6:	fff5c683          	lbu	a3,-1(a1)
     dea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     dee:	fee79ae3          	bne	a5,a4,de2 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     df2:	6422                	ld	s0,8(sp)
     df4:	0141                	addi	sp,sp,16
     df6:	8082                	ret
    dst += n;
     df8:	00c50733          	add	a4,a0,a2
    src += n;
     dfc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     dfe:	fec05ae3          	blez	a2,df2 <memmove+0x2c>
     e02:	fff6079b          	addiw	a5,a2,-1
     e06:	1782                	slli	a5,a5,0x20
     e08:	9381                	srli	a5,a5,0x20
     e0a:	fff7c793          	not	a5,a5
     e0e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e10:	15fd                	addi	a1,a1,-1
     e12:	177d                	addi	a4,a4,-1
     e14:	0005c683          	lbu	a3,0(a1)
     e18:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e1c:	fee79ae3          	bne	a5,a4,e10 <memmove+0x4a>
     e20:	bfc9                	j	df2 <memmove+0x2c>

0000000000000e22 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e22:	1141                	addi	sp,sp,-16
     e24:	e422                	sd	s0,8(sp)
     e26:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e28:	ca05                	beqz	a2,e58 <memcmp+0x36>
     e2a:	fff6069b          	addiw	a3,a2,-1
     e2e:	1682                	slli	a3,a3,0x20
     e30:	9281                	srli	a3,a3,0x20
     e32:	0685                	addi	a3,a3,1
     e34:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e36:	00054783          	lbu	a5,0(a0)
     e3a:	0005c703          	lbu	a4,0(a1)
     e3e:	00e79863          	bne	a5,a4,e4e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e42:	0505                	addi	a0,a0,1
    p2++;
     e44:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e46:	fed518e3          	bne	a0,a3,e36 <memcmp+0x14>
  }
  return 0;
     e4a:	4501                	li	a0,0
     e4c:	a019                	j	e52 <memcmp+0x30>
      return *p1 - *p2;
     e4e:	40e7853b          	subw	a0,a5,a4
}
     e52:	6422                	ld	s0,8(sp)
     e54:	0141                	addi	sp,sp,16
     e56:	8082                	ret
  return 0;
     e58:	4501                	li	a0,0
     e5a:	bfe5                	j	e52 <memcmp+0x30>

0000000000000e5c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e5c:	1141                	addi	sp,sp,-16
     e5e:	e406                	sd	ra,8(sp)
     e60:	e022                	sd	s0,0(sp)
     e62:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e64:	00000097          	auipc	ra,0x0
     e68:	f62080e7          	jalr	-158(ra) # dc6 <memmove>
}
     e6c:	60a2                	ld	ra,8(sp)
     e6e:	6402                	ld	s0,0(sp)
     e70:	0141                	addi	sp,sp,16
     e72:	8082                	ret

0000000000000e74 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e74:	4885                	li	a7,1
 ecall
     e76:	00000073          	ecall
 ret
     e7a:	8082                	ret

0000000000000e7c <exit>:
.global exit
exit:
 li a7, SYS_exit
     e7c:	4889                	li	a7,2
 ecall
     e7e:	00000073          	ecall
 ret
     e82:	8082                	ret

0000000000000e84 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e84:	488d                	li	a7,3
 ecall
     e86:	00000073          	ecall
 ret
     e8a:	8082                	ret

0000000000000e8c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e8c:	4891                	li	a7,4
 ecall
     e8e:	00000073          	ecall
 ret
     e92:	8082                	ret

0000000000000e94 <read>:
.global read
read:
 li a7, SYS_read
     e94:	4895                	li	a7,5
 ecall
     e96:	00000073          	ecall
 ret
     e9a:	8082                	ret

0000000000000e9c <write>:
.global write
write:
 li a7, SYS_write
     e9c:	48c1                	li	a7,16
 ecall
     e9e:	00000073          	ecall
 ret
     ea2:	8082                	ret

0000000000000ea4 <close>:
.global close
close:
 li a7, SYS_close
     ea4:	48d5                	li	a7,21
 ecall
     ea6:	00000073          	ecall
 ret
     eaa:	8082                	ret

0000000000000eac <kill>:
.global kill
kill:
 li a7, SYS_kill
     eac:	4899                	li	a7,6
 ecall
     eae:	00000073          	ecall
 ret
     eb2:	8082                	ret

0000000000000eb4 <exec>:
.global exec
exec:
 li a7, SYS_exec
     eb4:	489d                	li	a7,7
 ecall
     eb6:	00000073          	ecall
 ret
     eba:	8082                	ret

0000000000000ebc <open>:
.global open
open:
 li a7, SYS_open
     ebc:	48bd                	li	a7,15
 ecall
     ebe:	00000073          	ecall
 ret
     ec2:	8082                	ret

0000000000000ec4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ec4:	48c5                	li	a7,17
 ecall
     ec6:	00000073          	ecall
 ret
     eca:	8082                	ret

0000000000000ecc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ecc:	48c9                	li	a7,18
 ecall
     ece:	00000073          	ecall
 ret
     ed2:	8082                	ret

0000000000000ed4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ed4:	48a1                	li	a7,8
 ecall
     ed6:	00000073          	ecall
 ret
     eda:	8082                	ret

0000000000000edc <link>:
.global link
link:
 li a7, SYS_link
     edc:	48cd                	li	a7,19
 ecall
     ede:	00000073          	ecall
 ret
     ee2:	8082                	ret

0000000000000ee4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ee4:	48d1                	li	a7,20
 ecall
     ee6:	00000073          	ecall
 ret
     eea:	8082                	ret

0000000000000eec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     eec:	48a5                	li	a7,9
 ecall
     eee:	00000073          	ecall
 ret
     ef2:	8082                	ret

0000000000000ef4 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ef4:	48a9                	li	a7,10
 ecall
     ef6:	00000073          	ecall
 ret
     efa:	8082                	ret

0000000000000efc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     efc:	48ad                	li	a7,11
 ecall
     efe:	00000073          	ecall
 ret
     f02:	8082                	ret

0000000000000f04 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f04:	48b1                	li	a7,12
 ecall
     f06:	00000073          	ecall
 ret
     f0a:	8082                	ret

0000000000000f0c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f0c:	48b5                	li	a7,13
 ecall
     f0e:	00000073          	ecall
 ret
     f12:	8082                	ret

0000000000000f14 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f14:	48b9                	li	a7,14
 ecall
     f16:	00000073          	ecall
 ret
     f1a:	8082                	ret

0000000000000f1c <memsize>:
.global memsize
memsize:
 li a7, SYS_memsize
     f1c:	48d9                	li	a7,22
 ecall
     f1e:	00000073          	ecall
 ret
     f22:	8082                	ret

0000000000000f24 <set_ps_priority>:
.global set_ps_priority
set_ps_priority:
 li a7, SYS_set_ps_priority
     f24:	48dd                	li	a7,23
 ecall
     f26:	00000073          	ecall
 ret
     f2a:	8082                	ret

0000000000000f2c <set_cfs_priority>:
.global set_cfs_priority
set_cfs_priority:
 li a7, SYS_set_cfs_priority
     f2c:	48e1                	li	a7,24
 ecall
     f2e:	00000073          	ecall
 ret
     f32:	8082                	ret

0000000000000f34 <get_cfs_stats>:
.global get_cfs_stats
get_cfs_stats:
 li a7, SYS_get_cfs_stats
     f34:	48e5                	li	a7,25
 ecall
     f36:	00000073          	ecall
 ret
     f3a:	8082                	ret

0000000000000f3c <set_policy>:
.global set_policy
set_policy:
 li a7, SYS_set_policy
     f3c:	48e9                	li	a7,26
 ecall
     f3e:	00000073          	ecall
 ret
     f42:	8082                	ret

0000000000000f44 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f44:	1101                	addi	sp,sp,-32
     f46:	ec06                	sd	ra,24(sp)
     f48:	e822                	sd	s0,16(sp)
     f4a:	1000                	addi	s0,sp,32
     f4c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f50:	4605                	li	a2,1
     f52:	fef40593          	addi	a1,s0,-17
     f56:	00000097          	auipc	ra,0x0
     f5a:	f46080e7          	jalr	-186(ra) # e9c <write>
}
     f5e:	60e2                	ld	ra,24(sp)
     f60:	6442                	ld	s0,16(sp)
     f62:	6105                	addi	sp,sp,32
     f64:	8082                	ret

0000000000000f66 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f66:	7139                	addi	sp,sp,-64
     f68:	fc06                	sd	ra,56(sp)
     f6a:	f822                	sd	s0,48(sp)
     f6c:	f426                	sd	s1,40(sp)
     f6e:	f04a                	sd	s2,32(sp)
     f70:	ec4e                	sd	s3,24(sp)
     f72:	0080                	addi	s0,sp,64
     f74:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f76:	c299                	beqz	a3,f7c <printint+0x16>
     f78:	0805c863          	bltz	a1,1008 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f7c:	2581                	sext.w	a1,a1
  neg = 0;
     f7e:	4881                	li	a7,0
     f80:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f84:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f86:	2601                	sext.w	a2,a2
     f88:	00000517          	auipc	a0,0x0
     f8c:	59850513          	addi	a0,a0,1432 # 1520 <digits>
     f90:	883a                	mv	a6,a4
     f92:	2705                	addiw	a4,a4,1
     f94:	02c5f7bb          	remuw	a5,a1,a2
     f98:	1782                	slli	a5,a5,0x20
     f9a:	9381                	srli	a5,a5,0x20
     f9c:	97aa                	add	a5,a5,a0
     f9e:	0007c783          	lbu	a5,0(a5)
     fa2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     fa6:	0005879b          	sext.w	a5,a1
     faa:	02c5d5bb          	divuw	a1,a1,a2
     fae:	0685                	addi	a3,a3,1
     fb0:	fec7f0e3          	bgeu	a5,a2,f90 <printint+0x2a>
  if(neg)
     fb4:	00088b63          	beqz	a7,fca <printint+0x64>
    buf[i++] = '-';
     fb8:	fd040793          	addi	a5,s0,-48
     fbc:	973e                	add	a4,a4,a5
     fbe:	02d00793          	li	a5,45
     fc2:	fef70823          	sb	a5,-16(a4)
     fc6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     fca:	02e05863          	blez	a4,ffa <printint+0x94>
     fce:	fc040793          	addi	a5,s0,-64
     fd2:	00e78933          	add	s2,a5,a4
     fd6:	fff78993          	addi	s3,a5,-1
     fda:	99ba                	add	s3,s3,a4
     fdc:	377d                	addiw	a4,a4,-1
     fde:	1702                	slli	a4,a4,0x20
     fe0:	9301                	srli	a4,a4,0x20
     fe2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     fe6:	fff94583          	lbu	a1,-1(s2)
     fea:	8526                	mv	a0,s1
     fec:	00000097          	auipc	ra,0x0
     ff0:	f58080e7          	jalr	-168(ra) # f44 <putc>
  while(--i >= 0)
     ff4:	197d                	addi	s2,s2,-1
     ff6:	ff3918e3          	bne	s2,s3,fe6 <printint+0x80>
}
     ffa:	70e2                	ld	ra,56(sp)
     ffc:	7442                	ld	s0,48(sp)
     ffe:	74a2                	ld	s1,40(sp)
    1000:	7902                	ld	s2,32(sp)
    1002:	69e2                	ld	s3,24(sp)
    1004:	6121                	addi	sp,sp,64
    1006:	8082                	ret
    x = -xx;
    1008:	40b005bb          	negw	a1,a1
    neg = 1;
    100c:	4885                	li	a7,1
    x = -xx;
    100e:	bf8d                	j	f80 <printint+0x1a>

0000000000001010 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1010:	7119                	addi	sp,sp,-128
    1012:	fc86                	sd	ra,120(sp)
    1014:	f8a2                	sd	s0,112(sp)
    1016:	f4a6                	sd	s1,104(sp)
    1018:	f0ca                	sd	s2,96(sp)
    101a:	ecce                	sd	s3,88(sp)
    101c:	e8d2                	sd	s4,80(sp)
    101e:	e4d6                	sd	s5,72(sp)
    1020:	e0da                	sd	s6,64(sp)
    1022:	fc5e                	sd	s7,56(sp)
    1024:	f862                	sd	s8,48(sp)
    1026:	f466                	sd	s9,40(sp)
    1028:	f06a                	sd	s10,32(sp)
    102a:	ec6e                	sd	s11,24(sp)
    102c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    102e:	0005c903          	lbu	s2,0(a1)
    1032:	18090f63          	beqz	s2,11d0 <vprintf+0x1c0>
    1036:	8aaa                	mv	s5,a0
    1038:	8b32                	mv	s6,a2
    103a:	00158493          	addi	s1,a1,1
  state = 0;
    103e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1040:	02500a13          	li	s4,37
      if(c == 'd'){
    1044:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    1048:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    104c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1050:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1054:	00000b97          	auipc	s7,0x0
    1058:	4ccb8b93          	addi	s7,s7,1228 # 1520 <digits>
    105c:	a839                	j	107a <vprintf+0x6a>
        putc(fd, c);
    105e:	85ca                	mv	a1,s2
    1060:	8556                	mv	a0,s5
    1062:	00000097          	auipc	ra,0x0
    1066:	ee2080e7          	jalr	-286(ra) # f44 <putc>
    106a:	a019                	j	1070 <vprintf+0x60>
    } else if(state == '%'){
    106c:	01498f63          	beq	s3,s4,108a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1070:	0485                	addi	s1,s1,1
    1072:	fff4c903          	lbu	s2,-1(s1)
    1076:	14090d63          	beqz	s2,11d0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    107a:	0009079b          	sext.w	a5,s2
    if(state == 0){
    107e:	fe0997e3          	bnez	s3,106c <vprintf+0x5c>
      if(c == '%'){
    1082:	fd479ee3          	bne	a5,s4,105e <vprintf+0x4e>
        state = '%';
    1086:	89be                	mv	s3,a5
    1088:	b7e5                	j	1070 <vprintf+0x60>
      if(c == 'd'){
    108a:	05878063          	beq	a5,s8,10ca <vprintf+0xba>
      } else if(c == 'l') {
    108e:	05978c63          	beq	a5,s9,10e6 <vprintf+0xd6>
      } else if(c == 'x') {
    1092:	07a78863          	beq	a5,s10,1102 <vprintf+0xf2>
      } else if(c == 'p') {
    1096:	09b78463          	beq	a5,s11,111e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    109a:	07300713          	li	a4,115
    109e:	0ce78663          	beq	a5,a4,116a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    10a2:	06300713          	li	a4,99
    10a6:	0ee78e63          	beq	a5,a4,11a2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    10aa:	11478863          	beq	a5,s4,11ba <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10ae:	85d2                	mv	a1,s4
    10b0:	8556                	mv	a0,s5
    10b2:	00000097          	auipc	ra,0x0
    10b6:	e92080e7          	jalr	-366(ra) # f44 <putc>
        putc(fd, c);
    10ba:	85ca                	mv	a1,s2
    10bc:	8556                	mv	a0,s5
    10be:	00000097          	auipc	ra,0x0
    10c2:	e86080e7          	jalr	-378(ra) # f44 <putc>
      }
      state = 0;
    10c6:	4981                	li	s3,0
    10c8:	b765                	j	1070 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    10ca:	008b0913          	addi	s2,s6,8
    10ce:	4685                	li	a3,1
    10d0:	4629                	li	a2,10
    10d2:	000b2583          	lw	a1,0(s6)
    10d6:	8556                	mv	a0,s5
    10d8:	00000097          	auipc	ra,0x0
    10dc:	e8e080e7          	jalr	-370(ra) # f66 <printint>
    10e0:	8b4a                	mv	s6,s2
      state = 0;
    10e2:	4981                	li	s3,0
    10e4:	b771                	j	1070 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10e6:	008b0913          	addi	s2,s6,8
    10ea:	4681                	li	a3,0
    10ec:	4629                	li	a2,10
    10ee:	000b2583          	lw	a1,0(s6)
    10f2:	8556                	mv	a0,s5
    10f4:	00000097          	auipc	ra,0x0
    10f8:	e72080e7          	jalr	-398(ra) # f66 <printint>
    10fc:	8b4a                	mv	s6,s2
      state = 0;
    10fe:	4981                	li	s3,0
    1100:	bf85                	j	1070 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    1102:	008b0913          	addi	s2,s6,8
    1106:	4681                	li	a3,0
    1108:	4641                	li	a2,16
    110a:	000b2583          	lw	a1,0(s6)
    110e:	8556                	mv	a0,s5
    1110:	00000097          	auipc	ra,0x0
    1114:	e56080e7          	jalr	-426(ra) # f66 <printint>
    1118:	8b4a                	mv	s6,s2
      state = 0;
    111a:	4981                	li	s3,0
    111c:	bf91                	j	1070 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    111e:	008b0793          	addi	a5,s6,8
    1122:	f8f43423          	sd	a5,-120(s0)
    1126:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    112a:	03000593          	li	a1,48
    112e:	8556                	mv	a0,s5
    1130:	00000097          	auipc	ra,0x0
    1134:	e14080e7          	jalr	-492(ra) # f44 <putc>
  putc(fd, 'x');
    1138:	85ea                	mv	a1,s10
    113a:	8556                	mv	a0,s5
    113c:	00000097          	auipc	ra,0x0
    1140:	e08080e7          	jalr	-504(ra) # f44 <putc>
    1144:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1146:	03c9d793          	srli	a5,s3,0x3c
    114a:	97de                	add	a5,a5,s7
    114c:	0007c583          	lbu	a1,0(a5)
    1150:	8556                	mv	a0,s5
    1152:	00000097          	auipc	ra,0x0
    1156:	df2080e7          	jalr	-526(ra) # f44 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    115a:	0992                	slli	s3,s3,0x4
    115c:	397d                	addiw	s2,s2,-1
    115e:	fe0914e3          	bnez	s2,1146 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1162:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    1166:	4981                	li	s3,0
    1168:	b721                	j	1070 <vprintf+0x60>
        s = va_arg(ap, char*);
    116a:	008b0993          	addi	s3,s6,8
    116e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1172:	02090163          	beqz	s2,1194 <vprintf+0x184>
        while(*s != 0){
    1176:	00094583          	lbu	a1,0(s2)
    117a:	c9a1                	beqz	a1,11ca <vprintf+0x1ba>
          putc(fd, *s);
    117c:	8556                	mv	a0,s5
    117e:	00000097          	auipc	ra,0x0
    1182:	dc6080e7          	jalr	-570(ra) # f44 <putc>
          s++;
    1186:	0905                	addi	s2,s2,1
        while(*s != 0){
    1188:	00094583          	lbu	a1,0(s2)
    118c:	f9e5                	bnez	a1,117c <vprintf+0x16c>
        s = va_arg(ap, char*);
    118e:	8b4e                	mv	s6,s3
      state = 0;
    1190:	4981                	li	s3,0
    1192:	bdf9                	j	1070 <vprintf+0x60>
          s = "(null)";
    1194:	00000917          	auipc	s2,0x0
    1198:	38490913          	addi	s2,s2,900 # 1518 <malloc+0x23e>
        while(*s != 0){
    119c:	02800593          	li	a1,40
    11a0:	bff1                	j	117c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    11a2:	008b0913          	addi	s2,s6,8
    11a6:	000b4583          	lbu	a1,0(s6)
    11aa:	8556                	mv	a0,s5
    11ac:	00000097          	auipc	ra,0x0
    11b0:	d98080e7          	jalr	-616(ra) # f44 <putc>
    11b4:	8b4a                	mv	s6,s2
      state = 0;
    11b6:	4981                	li	s3,0
    11b8:	bd65                	j	1070 <vprintf+0x60>
        putc(fd, c);
    11ba:	85d2                	mv	a1,s4
    11bc:	8556                	mv	a0,s5
    11be:	00000097          	auipc	ra,0x0
    11c2:	d86080e7          	jalr	-634(ra) # f44 <putc>
      state = 0;
    11c6:	4981                	li	s3,0
    11c8:	b565                	j	1070 <vprintf+0x60>
        s = va_arg(ap, char*);
    11ca:	8b4e                	mv	s6,s3
      state = 0;
    11cc:	4981                	li	s3,0
    11ce:	b54d                	j	1070 <vprintf+0x60>
    }
  }
}
    11d0:	70e6                	ld	ra,120(sp)
    11d2:	7446                	ld	s0,112(sp)
    11d4:	74a6                	ld	s1,104(sp)
    11d6:	7906                	ld	s2,96(sp)
    11d8:	69e6                	ld	s3,88(sp)
    11da:	6a46                	ld	s4,80(sp)
    11dc:	6aa6                	ld	s5,72(sp)
    11de:	6b06                	ld	s6,64(sp)
    11e0:	7be2                	ld	s7,56(sp)
    11e2:	7c42                	ld	s8,48(sp)
    11e4:	7ca2                	ld	s9,40(sp)
    11e6:	7d02                	ld	s10,32(sp)
    11e8:	6de2                	ld	s11,24(sp)
    11ea:	6109                	addi	sp,sp,128
    11ec:	8082                	ret

00000000000011ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11ee:	715d                	addi	sp,sp,-80
    11f0:	ec06                	sd	ra,24(sp)
    11f2:	e822                	sd	s0,16(sp)
    11f4:	1000                	addi	s0,sp,32
    11f6:	e010                	sd	a2,0(s0)
    11f8:	e414                	sd	a3,8(s0)
    11fa:	e818                	sd	a4,16(s0)
    11fc:	ec1c                	sd	a5,24(s0)
    11fe:	03043023          	sd	a6,32(s0)
    1202:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1206:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    120a:	8622                	mv	a2,s0
    120c:	00000097          	auipc	ra,0x0
    1210:	e04080e7          	jalr	-508(ra) # 1010 <vprintf>
}
    1214:	60e2                	ld	ra,24(sp)
    1216:	6442                	ld	s0,16(sp)
    1218:	6161                	addi	sp,sp,80
    121a:	8082                	ret

000000000000121c <printf>:

void
printf(const char *fmt, ...)
{
    121c:	711d                	addi	sp,sp,-96
    121e:	ec06                	sd	ra,24(sp)
    1220:	e822                	sd	s0,16(sp)
    1222:	1000                	addi	s0,sp,32
    1224:	e40c                	sd	a1,8(s0)
    1226:	e810                	sd	a2,16(s0)
    1228:	ec14                	sd	a3,24(s0)
    122a:	f018                	sd	a4,32(s0)
    122c:	f41c                	sd	a5,40(s0)
    122e:	03043823          	sd	a6,48(s0)
    1232:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1236:	00840613          	addi	a2,s0,8
    123a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    123e:	85aa                	mv	a1,a0
    1240:	4505                	li	a0,1
    1242:	00000097          	auipc	ra,0x0
    1246:	dce080e7          	jalr	-562(ra) # 1010 <vprintf>
}
    124a:	60e2                	ld	ra,24(sp)
    124c:	6442                	ld	s0,16(sp)
    124e:	6125                	addi	sp,sp,96
    1250:	8082                	ret

0000000000001252 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1252:	1141                	addi	sp,sp,-16
    1254:	e422                	sd	s0,8(sp)
    1256:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1258:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    125c:	00001797          	auipc	a5,0x1
    1260:	db47b783          	ld	a5,-588(a5) # 2010 <freep>
    1264:	a805                	j	1294 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1266:	4618                	lw	a4,8(a2)
    1268:	9db9                	addw	a1,a1,a4
    126a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    126e:	6398                	ld	a4,0(a5)
    1270:	6318                	ld	a4,0(a4)
    1272:	fee53823          	sd	a4,-16(a0)
    1276:	a091                	j	12ba <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1278:	ff852703          	lw	a4,-8(a0)
    127c:	9e39                	addw	a2,a2,a4
    127e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1280:	ff053703          	ld	a4,-16(a0)
    1284:	e398                	sd	a4,0(a5)
    1286:	a099                	j	12cc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1288:	6398                	ld	a4,0(a5)
    128a:	00e7e463          	bltu	a5,a4,1292 <free+0x40>
    128e:	00e6ea63          	bltu	a3,a4,12a2 <free+0x50>
{
    1292:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1294:	fed7fae3          	bgeu	a5,a3,1288 <free+0x36>
    1298:	6398                	ld	a4,0(a5)
    129a:	00e6e463          	bltu	a3,a4,12a2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    129e:	fee7eae3          	bltu	a5,a4,1292 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    12a2:	ff852583          	lw	a1,-8(a0)
    12a6:	6390                	ld	a2,0(a5)
    12a8:	02059713          	slli	a4,a1,0x20
    12ac:	9301                	srli	a4,a4,0x20
    12ae:	0712                	slli	a4,a4,0x4
    12b0:	9736                	add	a4,a4,a3
    12b2:	fae60ae3          	beq	a2,a4,1266 <free+0x14>
    bp->s.ptr = p->s.ptr;
    12b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12ba:	4790                	lw	a2,8(a5)
    12bc:	02061713          	slli	a4,a2,0x20
    12c0:	9301                	srli	a4,a4,0x20
    12c2:	0712                	slli	a4,a4,0x4
    12c4:	973e                	add	a4,a4,a5
    12c6:	fae689e3          	beq	a3,a4,1278 <free+0x26>
  } else
    p->s.ptr = bp;
    12ca:	e394                	sd	a3,0(a5)
  freep = p;
    12cc:	00001717          	auipc	a4,0x1
    12d0:	d4f73223          	sd	a5,-700(a4) # 2010 <freep>
}
    12d4:	6422                	ld	s0,8(sp)
    12d6:	0141                	addi	sp,sp,16
    12d8:	8082                	ret

00000000000012da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12da:	7139                	addi	sp,sp,-64
    12dc:	fc06                	sd	ra,56(sp)
    12de:	f822                	sd	s0,48(sp)
    12e0:	f426                	sd	s1,40(sp)
    12e2:	f04a                	sd	s2,32(sp)
    12e4:	ec4e                	sd	s3,24(sp)
    12e6:	e852                	sd	s4,16(sp)
    12e8:	e456                	sd	s5,8(sp)
    12ea:	e05a                	sd	s6,0(sp)
    12ec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12ee:	02051493          	slli	s1,a0,0x20
    12f2:	9081                	srli	s1,s1,0x20
    12f4:	04bd                	addi	s1,s1,15
    12f6:	8091                	srli	s1,s1,0x4
    12f8:	0014899b          	addiw	s3,s1,1
    12fc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    12fe:	00001517          	auipc	a0,0x1
    1302:	d1253503          	ld	a0,-750(a0) # 2010 <freep>
    1306:	c515                	beqz	a0,1332 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1308:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    130a:	4798                	lw	a4,8(a5)
    130c:	02977f63          	bgeu	a4,s1,134a <malloc+0x70>
    1310:	8a4e                	mv	s4,s3
    1312:	0009871b          	sext.w	a4,s3
    1316:	6685                	lui	a3,0x1
    1318:	00d77363          	bgeu	a4,a3,131e <malloc+0x44>
    131c:	6a05                	lui	s4,0x1
    131e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1322:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1326:	00001917          	auipc	s2,0x1
    132a:	cea90913          	addi	s2,s2,-790 # 2010 <freep>
  if(p == (char*)-1)
    132e:	5afd                	li	s5,-1
    1330:	a88d                	j	13a2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    1332:	00001797          	auipc	a5,0x1
    1336:	d5678793          	addi	a5,a5,-682 # 2088 <base>
    133a:	00001717          	auipc	a4,0x1
    133e:	ccf73b23          	sd	a5,-810(a4) # 2010 <freep>
    1342:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1344:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1348:	b7e1                	j	1310 <malloc+0x36>
      if(p->s.size == nunits)
    134a:	02e48b63          	beq	s1,a4,1380 <malloc+0xa6>
        p->s.size -= nunits;
    134e:	4137073b          	subw	a4,a4,s3
    1352:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1354:	1702                	slli	a4,a4,0x20
    1356:	9301                	srli	a4,a4,0x20
    1358:	0712                	slli	a4,a4,0x4
    135a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    135c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1360:	00001717          	auipc	a4,0x1
    1364:	caa73823          	sd	a0,-848(a4) # 2010 <freep>
      return (void*)(p + 1);
    1368:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    136c:	70e2                	ld	ra,56(sp)
    136e:	7442                	ld	s0,48(sp)
    1370:	74a2                	ld	s1,40(sp)
    1372:	7902                	ld	s2,32(sp)
    1374:	69e2                	ld	s3,24(sp)
    1376:	6a42                	ld	s4,16(sp)
    1378:	6aa2                	ld	s5,8(sp)
    137a:	6b02                	ld	s6,0(sp)
    137c:	6121                	addi	sp,sp,64
    137e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1380:	6398                	ld	a4,0(a5)
    1382:	e118                	sd	a4,0(a0)
    1384:	bff1                	j	1360 <malloc+0x86>
  hp->s.size = nu;
    1386:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    138a:	0541                	addi	a0,a0,16
    138c:	00000097          	auipc	ra,0x0
    1390:	ec6080e7          	jalr	-314(ra) # 1252 <free>
  return freep;
    1394:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1398:	d971                	beqz	a0,136c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    139a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    139c:	4798                	lw	a4,8(a5)
    139e:	fa9776e3          	bgeu	a4,s1,134a <malloc+0x70>
    if(p == freep)
    13a2:	00093703          	ld	a4,0(s2)
    13a6:	853e                	mv	a0,a5
    13a8:	fef719e3          	bne	a4,a5,139a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    13ac:	8552                	mv	a0,s4
    13ae:	00000097          	auipc	ra,0x0
    13b2:	b56080e7          	jalr	-1194(ra) # f04 <sbrk>
  if(p == (char*)-1)
    13b6:	fd5518e3          	bne	a0,s5,1386 <malloc+0xac>
        return 0;
    13ba:	4501                	li	a0,0
    13bc:	bf45                	j	136c <malloc+0x92>
