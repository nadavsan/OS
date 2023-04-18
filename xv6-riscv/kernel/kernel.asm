
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	95013103          	ld	sp,-1712(sp) # 80008950 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	95e70713          	addi	a4,a4,-1698 # 800089b0 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	19c78793          	addi	a5,a5,412 # 80006200 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb9df>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	de678793          	addi	a5,a5,-538 # 80000e94 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00003097          	auipc	ra,0x3
    80000130:	86a080e7          	jalr	-1942(ra) # 80002996 <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	794080e7          	jalr	1940(ra) # 800008d0 <uartputc>
  for(i = 0; i < n; i++){
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
  }

  return i;
}
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000164:	7119                	addi	sp,sp,-128
    80000166:	fc86                	sd	ra,120(sp)
    80000168:	f8a2                	sd	s0,112(sp)
    8000016a:	f4a6                	sd	s1,104(sp)
    8000016c:	f0ca                	sd	s2,96(sp)
    8000016e:	ecce                	sd	s3,88(sp)
    80000170:	e8d2                	sd	s4,80(sp)
    80000172:	e4d6                	sd	s5,72(sp)
    80000174:	e0da                	sd	s6,64(sp)
    80000176:	fc5e                	sd	s7,56(sp)
    80000178:	f862                	sd	s8,48(sp)
    8000017a:	f466                	sd	s9,40(sp)
    8000017c:	f06a                	sd	s10,32(sp)
    8000017e:	ec6e                	sd	s11,24(sp)
    80000180:	0100                	addi	s0,sp,128
    80000182:	8b2a                	mv	s6,a0
    80000184:	8aae                	mv	s5,a1
    80000186:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000018c:	00011517          	auipc	a0,0x11
    80000190:	96450513          	addi	a0,a0,-1692 # 80010af0 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	a56080e7          	jalr	-1450(ra) # 80000bea <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019c:	00011497          	auipc	s1,0x11
    800001a0:	95448493          	addi	s1,s1,-1708 # 80010af0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a4:	89a6                	mv	s3,s1
    800001a6:	00011917          	auipc	s2,0x11
    800001aa:	9e290913          	addi	s2,s2,-1566 # 80010b88 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001ae:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001b0:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001b2:	4da9                	li	s11,10
  while(n > 0){
    800001b4:	07405b63          	blez	s4,8000022a <consoleread+0xc6>
    while(cons.r == cons.w){
    800001b8:	0984a783          	lw	a5,152(s1)
    800001bc:	09c4a703          	lw	a4,156(s1)
    800001c0:	02f71763          	bne	a4,a5,800001ee <consoleread+0x8a>
      if(killed(myproc())){
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	818080e7          	jalr	-2024(ra) # 800019dc <myproc>
    800001cc:	00002097          	auipc	ra,0x2
    800001d0:	5c2080e7          	jalr	1474(ra) # 8000278e <killed>
    800001d4:	e535                	bnez	a0,80000240 <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    800001d6:	85ce                	mv	a1,s3
    800001d8:	854a                	mv	a0,s2
    800001da:	00002097          	auipc	ra,0x2
    800001de:	2a2080e7          	jalr	674(ra) # 8000247c <sleep>
    while(cons.r == cons.w){
    800001e2:	0984a783          	lw	a5,152(s1)
    800001e6:	09c4a703          	lw	a4,156(s1)
    800001ea:	fcf70de3          	beq	a4,a5,800001c4 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	0017871b          	addiw	a4,a5,1
    800001f2:	08e4ac23          	sw	a4,152(s1)
    800001f6:	07f7f713          	andi	a4,a5,127
    800001fa:	9726                	add	a4,a4,s1
    800001fc:	01874703          	lbu	a4,24(a4)
    80000200:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80000204:	079c0663          	beq	s8,s9,80000270 <consoleread+0x10c>
    cbuf = c;
    80000208:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000020c:	4685                	li	a3,1
    8000020e:	f8f40613          	addi	a2,s0,-113
    80000212:	85d6                	mv	a1,s5
    80000214:	855a                	mv	a0,s6
    80000216:	00002097          	auipc	ra,0x2
    8000021a:	72a080e7          	jalr	1834(ra) # 80002940 <either_copyout>
    8000021e:	01a50663          	beq	a0,s10,8000022a <consoleread+0xc6>
    dst++;
    80000222:	0a85                	addi	s5,s5,1
    --n;
    80000224:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80000226:	f9bc17e3          	bne	s8,s11,800001b4 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022a:	00011517          	auipc	a0,0x11
    8000022e:	8c650513          	addi	a0,a0,-1850 # 80010af0 <cons>
    80000232:	00001097          	auipc	ra,0x1
    80000236:	a6c080e7          	jalr	-1428(ra) # 80000c9e <release>

  return target - n;
    8000023a:	414b853b          	subw	a0,s7,s4
    8000023e:	a811                	j	80000252 <consoleread+0xee>
        release(&cons.lock);
    80000240:	00011517          	auipc	a0,0x11
    80000244:	8b050513          	addi	a0,a0,-1872 # 80010af0 <cons>
    80000248:	00001097          	auipc	ra,0x1
    8000024c:	a56080e7          	jalr	-1450(ra) # 80000c9e <release>
        return -1;
    80000250:	557d                	li	a0,-1
}
    80000252:	70e6                	ld	ra,120(sp)
    80000254:	7446                	ld	s0,112(sp)
    80000256:	74a6                	ld	s1,104(sp)
    80000258:	7906                	ld	s2,96(sp)
    8000025a:	69e6                	ld	s3,88(sp)
    8000025c:	6a46                	ld	s4,80(sp)
    8000025e:	6aa6                	ld	s5,72(sp)
    80000260:	6b06                	ld	s6,64(sp)
    80000262:	7be2                	ld	s7,56(sp)
    80000264:	7c42                	ld	s8,48(sp)
    80000266:	7ca2                	ld	s9,40(sp)
    80000268:	7d02                	ld	s10,32(sp)
    8000026a:	6de2                	ld	s11,24(sp)
    8000026c:	6109                	addi	sp,sp,128
    8000026e:	8082                	ret
      if(n < target){
    80000270:	000a071b          	sext.w	a4,s4
    80000274:	fb777be3          	bgeu	a4,s7,8000022a <consoleread+0xc6>
        cons.r--;
    80000278:	00011717          	auipc	a4,0x11
    8000027c:	90f72823          	sw	a5,-1776(a4) # 80010b88 <cons+0x98>
    80000280:	b76d                	j	8000022a <consoleread+0xc6>

0000000080000282 <consputc>:
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e406                	sd	ra,8(sp)
    80000286:	e022                	sd	s0,0(sp)
    80000288:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000028a:	10000793          	li	a5,256
    8000028e:	00f50a63          	beq	a0,a5,800002a2 <consputc+0x20>
    uartputc_sync(c);
    80000292:	00000097          	auipc	ra,0x0
    80000296:	564080e7          	jalr	1380(ra) # 800007f6 <uartputc_sync>
}
    8000029a:	60a2                	ld	ra,8(sp)
    8000029c:	6402                	ld	s0,0(sp)
    8000029e:	0141                	addi	sp,sp,16
    800002a0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a2:	4521                	li	a0,8
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	552080e7          	jalr	1362(ra) # 800007f6 <uartputc_sync>
    800002ac:	02000513          	li	a0,32
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	546080e7          	jalr	1350(ra) # 800007f6 <uartputc_sync>
    800002b8:	4521                	li	a0,8
    800002ba:	00000097          	auipc	ra,0x0
    800002be:	53c080e7          	jalr	1340(ra) # 800007f6 <uartputc_sync>
    800002c2:	bfe1                	j	8000029a <consputc+0x18>

00000000800002c4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c4:	1101                	addi	sp,sp,-32
    800002c6:	ec06                	sd	ra,24(sp)
    800002c8:	e822                	sd	s0,16(sp)
    800002ca:	e426                	sd	s1,8(sp)
    800002cc:	e04a                	sd	s2,0(sp)
    800002ce:	1000                	addi	s0,sp,32
    800002d0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d2:	00011517          	auipc	a0,0x11
    800002d6:	81e50513          	addi	a0,a0,-2018 # 80010af0 <cons>
    800002da:	00001097          	auipc	ra,0x1
    800002de:	910080e7          	jalr	-1776(ra) # 80000bea <acquire>

  switch(c){
    800002e2:	47d5                	li	a5,21
    800002e4:	0af48663          	beq	s1,a5,80000390 <consoleintr+0xcc>
    800002e8:	0297ca63          	blt	a5,s1,8000031c <consoleintr+0x58>
    800002ec:	47a1                	li	a5,8
    800002ee:	0ef48763          	beq	s1,a5,800003dc <consoleintr+0x118>
    800002f2:	47c1                	li	a5,16
    800002f4:	10f49a63          	bne	s1,a5,80000408 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f8:	00002097          	auipc	ra,0x2
    800002fc:	6f4080e7          	jalr	1780(ra) # 800029ec <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000300:	00010517          	auipc	a0,0x10
    80000304:	7f050513          	addi	a0,a0,2032 # 80010af0 <cons>
    80000308:	00001097          	auipc	ra,0x1
    8000030c:	996080e7          	jalr	-1642(ra) # 80000c9e <release>
}
    80000310:	60e2                	ld	ra,24(sp)
    80000312:	6442                	ld	s0,16(sp)
    80000314:	64a2                	ld	s1,8(sp)
    80000316:	6902                	ld	s2,0(sp)
    80000318:	6105                	addi	sp,sp,32
    8000031a:	8082                	ret
  switch(c){
    8000031c:	07f00793          	li	a5,127
    80000320:	0af48e63          	beq	s1,a5,800003dc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000324:	00010717          	auipc	a4,0x10
    80000328:	7cc70713          	addi	a4,a4,1996 # 80010af0 <cons>
    8000032c:	0a072783          	lw	a5,160(a4)
    80000330:	09872703          	lw	a4,152(a4)
    80000334:	9f99                	subw	a5,a5,a4
    80000336:	07f00713          	li	a4,127
    8000033a:	fcf763e3          	bltu	a4,a5,80000300 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    8000033e:	47b5                	li	a5,13
    80000340:	0cf48763          	beq	s1,a5,8000040e <consoleintr+0x14a>
      consputc(c);
    80000344:	8526                	mv	a0,s1
    80000346:	00000097          	auipc	ra,0x0
    8000034a:	f3c080e7          	jalr	-196(ra) # 80000282 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000034e:	00010797          	auipc	a5,0x10
    80000352:	7a278793          	addi	a5,a5,1954 # 80010af0 <cons>
    80000356:	0a07a683          	lw	a3,160(a5)
    8000035a:	0016871b          	addiw	a4,a3,1
    8000035e:	0007061b          	sext.w	a2,a4
    80000362:	0ae7a023          	sw	a4,160(a5)
    80000366:	07f6f693          	andi	a3,a3,127
    8000036a:	97b6                	add	a5,a5,a3
    8000036c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000370:	47a9                	li	a5,10
    80000372:	0cf48563          	beq	s1,a5,8000043c <consoleintr+0x178>
    80000376:	4791                	li	a5,4
    80000378:	0cf48263          	beq	s1,a5,8000043c <consoleintr+0x178>
    8000037c:	00011797          	auipc	a5,0x11
    80000380:	80c7a783          	lw	a5,-2036(a5) # 80010b88 <cons+0x98>
    80000384:	9f1d                	subw	a4,a4,a5
    80000386:	08000793          	li	a5,128
    8000038a:	f6f71be3          	bne	a4,a5,80000300 <consoleintr+0x3c>
    8000038e:	a07d                	j	8000043c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000390:	00010717          	auipc	a4,0x10
    80000394:	76070713          	addi	a4,a4,1888 # 80010af0 <cons>
    80000398:	0a072783          	lw	a5,160(a4)
    8000039c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a0:	00010497          	auipc	s1,0x10
    800003a4:	75048493          	addi	s1,s1,1872 # 80010af0 <cons>
    while(cons.e != cons.w &&
    800003a8:	4929                	li	s2,10
    800003aa:	f4f70be3          	beq	a4,a5,80000300 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003ae:	37fd                	addiw	a5,a5,-1
    800003b0:	07f7f713          	andi	a4,a5,127
    800003b4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b6:	01874703          	lbu	a4,24(a4)
    800003ba:	f52703e3          	beq	a4,s2,80000300 <consoleintr+0x3c>
      cons.e--;
    800003be:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c2:	10000513          	li	a0,256
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	ebc080e7          	jalr	-324(ra) # 80000282 <consputc>
    while(cons.e != cons.w &&
    800003ce:	0a04a783          	lw	a5,160(s1)
    800003d2:	09c4a703          	lw	a4,156(s1)
    800003d6:	fcf71ce3          	bne	a4,a5,800003ae <consoleintr+0xea>
    800003da:	b71d                	j	80000300 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003dc:	00010717          	auipc	a4,0x10
    800003e0:	71470713          	addi	a4,a4,1812 # 80010af0 <cons>
    800003e4:	0a072783          	lw	a5,160(a4)
    800003e8:	09c72703          	lw	a4,156(a4)
    800003ec:	f0f70ae3          	beq	a4,a5,80000300 <consoleintr+0x3c>
      cons.e--;
    800003f0:	37fd                	addiw	a5,a5,-1
    800003f2:	00010717          	auipc	a4,0x10
    800003f6:	78f72f23          	sw	a5,1950(a4) # 80010b90 <cons+0xa0>
      consputc(BACKSPACE);
    800003fa:	10000513          	li	a0,256
    800003fe:	00000097          	auipc	ra,0x0
    80000402:	e84080e7          	jalr	-380(ra) # 80000282 <consputc>
    80000406:	bded                	j	80000300 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000408:	ee048ce3          	beqz	s1,80000300 <consoleintr+0x3c>
    8000040c:	bf21                	j	80000324 <consoleintr+0x60>
      consputc(c);
    8000040e:	4529                	li	a0,10
    80000410:	00000097          	auipc	ra,0x0
    80000414:	e72080e7          	jalr	-398(ra) # 80000282 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000418:	00010797          	auipc	a5,0x10
    8000041c:	6d878793          	addi	a5,a5,1752 # 80010af0 <cons>
    80000420:	0a07a703          	lw	a4,160(a5)
    80000424:	0017069b          	addiw	a3,a4,1
    80000428:	0006861b          	sext.w	a2,a3
    8000042c:	0ad7a023          	sw	a3,160(a5)
    80000430:	07f77713          	andi	a4,a4,127
    80000434:	97ba                	add	a5,a5,a4
    80000436:	4729                	li	a4,10
    80000438:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000043c:	00010797          	auipc	a5,0x10
    80000440:	74c7a823          	sw	a2,1872(a5) # 80010b8c <cons+0x9c>
        wakeup(&cons.r);
    80000444:	00010517          	auipc	a0,0x10
    80000448:	74450513          	addi	a0,a0,1860 # 80010b88 <cons+0x98>
    8000044c:	00002097          	auipc	ra,0x2
    80000450:	094080e7          	jalr	148(ra) # 800024e0 <wakeup>
    80000454:	b575                	j	80000300 <consoleintr+0x3c>

0000000080000456 <consoleinit>:

void
consoleinit(void)
{
    80000456:	1141                	addi	sp,sp,-16
    80000458:	e406                	sd	ra,8(sp)
    8000045a:	e022                	sd	s0,0(sp)
    8000045c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000045e:	00008597          	auipc	a1,0x8
    80000462:	bb258593          	addi	a1,a1,-1102 # 80008010 <etext+0x10>
    80000466:	00010517          	auipc	a0,0x10
    8000046a:	68a50513          	addi	a0,a0,1674 # 80010af0 <cons>
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	6ec080e7          	jalr	1772(ra) # 80000b5a <initlock>

  uartinit();
    80000476:	00000097          	auipc	ra,0x0
    8000047a:	330080e7          	jalr	816(ra) # 800007a6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000047e:	00022797          	auipc	a5,0x22
    80000482:	80a78793          	addi	a5,a5,-2038 # 80021c88 <devsw>
    80000486:	00000717          	auipc	a4,0x0
    8000048a:	cde70713          	addi	a4,a4,-802 # 80000164 <consoleread>
    8000048e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000490:	00000717          	auipc	a4,0x0
    80000494:	c7270713          	addi	a4,a4,-910 # 80000102 <consolewrite>
    80000498:	ef98                	sd	a4,24(a5)
}
    8000049a:	60a2                	ld	ra,8(sp)
    8000049c:	6402                	ld	s0,0(sp)
    8000049e:	0141                	addi	sp,sp,16
    800004a0:	8082                	ret

00000000800004a2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a2:	7179                	addi	sp,sp,-48
    800004a4:	f406                	sd	ra,40(sp)
    800004a6:	f022                	sd	s0,32(sp)
    800004a8:	ec26                	sd	s1,24(sp)
    800004aa:	e84a                	sd	s2,16(sp)
    800004ac:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004ae:	c219                	beqz	a2,800004b4 <printint+0x12>
    800004b0:	08054663          	bltz	a0,8000053c <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b4:	2501                	sext.w	a0,a0
    800004b6:	4881                	li	a7,0
    800004b8:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004bc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004be:	2581                	sext.w	a1,a1
    800004c0:	00008617          	auipc	a2,0x8
    800004c4:	b8060613          	addi	a2,a2,-1152 # 80008040 <digits>
    800004c8:	883a                	mv	a6,a4
    800004ca:	2705                	addiw	a4,a4,1
    800004cc:	02b577bb          	remuw	a5,a0,a1
    800004d0:	1782                	slli	a5,a5,0x20
    800004d2:	9381                	srli	a5,a5,0x20
    800004d4:	97b2                	add	a5,a5,a2
    800004d6:	0007c783          	lbu	a5,0(a5)
    800004da:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004de:	0005079b          	sext.w	a5,a0
    800004e2:	02b5553b          	divuw	a0,a0,a1
    800004e6:	0685                	addi	a3,a3,1
    800004e8:	feb7f0e3          	bgeu	a5,a1,800004c8 <printint+0x26>

  if(sign)
    800004ec:	00088b63          	beqz	a7,80000502 <printint+0x60>
    buf[i++] = '-';
    800004f0:	fe040793          	addi	a5,s0,-32
    800004f4:	973e                	add	a4,a4,a5
    800004f6:	02d00793          	li	a5,45
    800004fa:	fef70823          	sb	a5,-16(a4)
    800004fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000502:	02e05763          	blez	a4,80000530 <printint+0x8e>
    80000506:	fd040793          	addi	a5,s0,-48
    8000050a:	00e784b3          	add	s1,a5,a4
    8000050e:	fff78913          	addi	s2,a5,-1
    80000512:	993a                	add	s2,s2,a4
    80000514:	377d                	addiw	a4,a4,-1
    80000516:	1702                	slli	a4,a4,0x20
    80000518:	9301                	srli	a4,a4,0x20
    8000051a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000051e:	fff4c503          	lbu	a0,-1(s1)
    80000522:	00000097          	auipc	ra,0x0
    80000526:	d60080e7          	jalr	-672(ra) # 80000282 <consputc>
  while(--i >= 0)
    8000052a:	14fd                	addi	s1,s1,-1
    8000052c:	ff2499e3          	bne	s1,s2,8000051e <printint+0x7c>
}
    80000530:	70a2                	ld	ra,40(sp)
    80000532:	7402                	ld	s0,32(sp)
    80000534:	64e2                	ld	s1,24(sp)
    80000536:	6942                	ld	s2,16(sp)
    80000538:	6145                	addi	sp,sp,48
    8000053a:	8082                	ret
    x = -xx;
    8000053c:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000540:	4885                	li	a7,1
    x = -xx;
    80000542:	bf9d                	j	800004b8 <printint+0x16>

0000000080000544 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000544:	1101                	addi	sp,sp,-32
    80000546:	ec06                	sd	ra,24(sp)
    80000548:	e822                	sd	s0,16(sp)
    8000054a:	e426                	sd	s1,8(sp)
    8000054c:	1000                	addi	s0,sp,32
    8000054e:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000550:	00010797          	auipc	a5,0x10
    80000554:	6607a023          	sw	zero,1632(a5) # 80010bb0 <pr+0x18>
  printf("panic: ");
    80000558:	00008517          	auipc	a0,0x8
    8000055c:	ac050513          	addi	a0,a0,-1344 # 80008018 <etext+0x18>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	02e080e7          	jalr	46(ra) # 8000058e <printf>
  printf(s);
    80000568:	8526                	mv	a0,s1
    8000056a:	00000097          	auipc	ra,0x0
    8000056e:	024080e7          	jalr	36(ra) # 8000058e <printf>
  printf("\n");
    80000572:	00008517          	auipc	a0,0x8
    80000576:	b5650513          	addi	a0,a0,-1194 # 800080c8 <digits+0x88>
    8000057a:	00000097          	auipc	ra,0x0
    8000057e:	014080e7          	jalr	20(ra) # 8000058e <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000582:	4785                	li	a5,1
    80000584:	00008717          	auipc	a4,0x8
    80000588:	3ef72623          	sw	a5,1004(a4) # 80008970 <panicked>
  for(;;)
    8000058c:	a001                	j	8000058c <panic+0x48>

000000008000058e <printf>:
{
    8000058e:	7131                	addi	sp,sp,-192
    80000590:	fc86                	sd	ra,120(sp)
    80000592:	f8a2                	sd	s0,112(sp)
    80000594:	f4a6                	sd	s1,104(sp)
    80000596:	f0ca                	sd	s2,96(sp)
    80000598:	ecce                	sd	s3,88(sp)
    8000059a:	e8d2                	sd	s4,80(sp)
    8000059c:	e4d6                	sd	s5,72(sp)
    8000059e:	e0da                	sd	s6,64(sp)
    800005a0:	fc5e                	sd	s7,56(sp)
    800005a2:	f862                	sd	s8,48(sp)
    800005a4:	f466                	sd	s9,40(sp)
    800005a6:	f06a                	sd	s10,32(sp)
    800005a8:	ec6e                	sd	s11,24(sp)
    800005aa:	0100                	addi	s0,sp,128
    800005ac:	8a2a                	mv	s4,a0
    800005ae:	e40c                	sd	a1,8(s0)
    800005b0:	e810                	sd	a2,16(s0)
    800005b2:	ec14                	sd	a3,24(s0)
    800005b4:	f018                	sd	a4,32(s0)
    800005b6:	f41c                	sd	a5,40(s0)
    800005b8:	03043823          	sd	a6,48(s0)
    800005bc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c0:	00010d97          	auipc	s11,0x10
    800005c4:	5f0dad83          	lw	s11,1520(s11) # 80010bb0 <pr+0x18>
  if(locking)
    800005c8:	020d9b63          	bnez	s11,800005fe <printf+0x70>
  if (fmt == 0)
    800005cc:	040a0263          	beqz	s4,80000610 <printf+0x82>
  va_start(ap, fmt);
    800005d0:	00840793          	addi	a5,s0,8
    800005d4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d8:	000a4503          	lbu	a0,0(s4)
    800005dc:	16050263          	beqz	a0,80000740 <printf+0x1b2>
    800005e0:	4481                	li	s1,0
    if(c != '%'){
    800005e2:	02500a93          	li	s5,37
    switch(c){
    800005e6:	07000b13          	li	s6,112
  consputc('x');
    800005ea:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005ec:	00008b97          	auipc	s7,0x8
    800005f0:	a54b8b93          	addi	s7,s7,-1452 # 80008040 <digits>
    switch(c){
    800005f4:	07300c93          	li	s9,115
    800005f8:	06400c13          	li	s8,100
    800005fc:	a82d                	j	80000636 <printf+0xa8>
    acquire(&pr.lock);
    800005fe:	00010517          	auipc	a0,0x10
    80000602:	59a50513          	addi	a0,a0,1434 # 80010b98 <pr>
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	5e4080e7          	jalr	1508(ra) # 80000bea <acquire>
    8000060e:	bf7d                	j	800005cc <printf+0x3e>
    panic("null fmt");
    80000610:	00008517          	auipc	a0,0x8
    80000614:	a1850513          	addi	a0,a0,-1512 # 80008028 <etext+0x28>
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	f2c080e7          	jalr	-212(ra) # 80000544 <panic>
      consputc(c);
    80000620:	00000097          	auipc	ra,0x0
    80000624:	c62080e7          	jalr	-926(ra) # 80000282 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000628:	2485                	addiw	s1,s1,1
    8000062a:	009a07b3          	add	a5,s4,s1
    8000062e:	0007c503          	lbu	a0,0(a5)
    80000632:	10050763          	beqz	a0,80000740 <printf+0x1b2>
    if(c != '%'){
    80000636:	ff5515e3          	bne	a0,s5,80000620 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000063a:	2485                	addiw	s1,s1,1
    8000063c:	009a07b3          	add	a5,s4,s1
    80000640:	0007c783          	lbu	a5,0(a5)
    80000644:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80000648:	cfe5                	beqz	a5,80000740 <printf+0x1b2>
    switch(c){
    8000064a:	05678a63          	beq	a5,s6,8000069e <printf+0x110>
    8000064e:	02fb7663          	bgeu	s6,a5,8000067a <printf+0xec>
    80000652:	09978963          	beq	a5,s9,800006e4 <printf+0x156>
    80000656:	07800713          	li	a4,120
    8000065a:	0ce79863          	bne	a5,a4,8000072a <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	addi	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4605                	li	a2,1
    8000066c:	85ea                	mv	a1,s10
    8000066e:	4388                	lw	a0,0(a5)
    80000670:	00000097          	auipc	ra,0x0
    80000674:	e32080e7          	jalr	-462(ra) # 800004a2 <printint>
      break;
    80000678:	bf45                	j	80000628 <printf+0x9a>
    switch(c){
    8000067a:	0b578263          	beq	a5,s5,8000071e <printf+0x190>
    8000067e:	0b879663          	bne	a5,s8,8000072a <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80000682:	f8843783          	ld	a5,-120(s0)
    80000686:	00878713          	addi	a4,a5,8
    8000068a:	f8e43423          	sd	a4,-120(s0)
    8000068e:	4605                	li	a2,1
    80000690:	45a9                	li	a1,10
    80000692:	4388                	lw	a0,0(a5)
    80000694:	00000097          	auipc	ra,0x0
    80000698:	e0e080e7          	jalr	-498(ra) # 800004a2 <printint>
      break;
    8000069c:	b771                	j	80000628 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	addi	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006ae:	03000513          	li	a0,48
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	bd0080e7          	jalr	-1072(ra) # 80000282 <consputc>
  consputc('x');
    800006ba:	07800513          	li	a0,120
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	bc4080e7          	jalr	-1084(ra) # 80000282 <consputc>
    800006c6:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c8:	03c9d793          	srli	a5,s3,0x3c
    800006cc:	97de                	add	a5,a5,s7
    800006ce:	0007c503          	lbu	a0,0(a5)
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	bb0080e7          	jalr	-1104(ra) # 80000282 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006da:	0992                	slli	s3,s3,0x4
    800006dc:	397d                	addiw	s2,s2,-1
    800006de:	fe0915e3          	bnez	s2,800006c8 <printf+0x13a>
    800006e2:	b799                	j	80000628 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e4:	f8843783          	ld	a5,-120(s0)
    800006e8:	00878713          	addi	a4,a5,8
    800006ec:	f8e43423          	sd	a4,-120(s0)
    800006f0:	0007b903          	ld	s2,0(a5)
    800006f4:	00090e63          	beqz	s2,80000710 <printf+0x182>
      for(; *s; s++)
    800006f8:	00094503          	lbu	a0,0(s2)
    800006fc:	d515                	beqz	a0,80000628 <printf+0x9a>
        consputc(*s);
    800006fe:	00000097          	auipc	ra,0x0
    80000702:	b84080e7          	jalr	-1148(ra) # 80000282 <consputc>
      for(; *s; s++)
    80000706:	0905                	addi	s2,s2,1
    80000708:	00094503          	lbu	a0,0(s2)
    8000070c:	f96d                	bnez	a0,800006fe <printf+0x170>
    8000070e:	bf29                	j	80000628 <printf+0x9a>
        s = "(null)";
    80000710:	00008917          	auipc	s2,0x8
    80000714:	91090913          	addi	s2,s2,-1776 # 80008020 <etext+0x20>
      for(; *s; s++)
    80000718:	02800513          	li	a0,40
    8000071c:	b7cd                	j	800006fe <printf+0x170>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b62080e7          	jalr	-1182(ra) # 80000282 <consputc>
      break;
    80000728:	b701                	j	80000628 <printf+0x9a>
      consputc('%');
    8000072a:	8556                	mv	a0,s5
    8000072c:	00000097          	auipc	ra,0x0
    80000730:	b56080e7          	jalr	-1194(ra) # 80000282 <consputc>
      consputc(c);
    80000734:	854a                	mv	a0,s2
    80000736:	00000097          	auipc	ra,0x0
    8000073a:	b4c080e7          	jalr	-1204(ra) # 80000282 <consputc>
      break;
    8000073e:	b5ed                	j	80000628 <printf+0x9a>
  if(locking)
    80000740:	020d9163          	bnez	s11,80000762 <printf+0x1d4>
}
    80000744:	70e6                	ld	ra,120(sp)
    80000746:	7446                	ld	s0,112(sp)
    80000748:	74a6                	ld	s1,104(sp)
    8000074a:	7906                	ld	s2,96(sp)
    8000074c:	69e6                	ld	s3,88(sp)
    8000074e:	6a46                	ld	s4,80(sp)
    80000750:	6aa6                	ld	s5,72(sp)
    80000752:	6b06                	ld	s6,64(sp)
    80000754:	7be2                	ld	s7,56(sp)
    80000756:	7c42                	ld	s8,48(sp)
    80000758:	7ca2                	ld	s9,40(sp)
    8000075a:	7d02                	ld	s10,32(sp)
    8000075c:	6de2                	ld	s11,24(sp)
    8000075e:	6129                	addi	sp,sp,192
    80000760:	8082                	ret
    release(&pr.lock);
    80000762:	00010517          	auipc	a0,0x10
    80000766:	43650513          	addi	a0,a0,1078 # 80010b98 <pr>
    8000076a:	00000097          	auipc	ra,0x0
    8000076e:	534080e7          	jalr	1332(ra) # 80000c9e <release>
}
    80000772:	bfc9                	j	80000744 <printf+0x1b6>

0000000080000774 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000774:	1101                	addi	sp,sp,-32
    80000776:	ec06                	sd	ra,24(sp)
    80000778:	e822                	sd	s0,16(sp)
    8000077a:	e426                	sd	s1,8(sp)
    8000077c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000077e:	00010497          	auipc	s1,0x10
    80000782:	41a48493          	addi	s1,s1,1050 # 80010b98 <pr>
    80000786:	00008597          	auipc	a1,0x8
    8000078a:	8b258593          	addi	a1,a1,-1870 # 80008038 <etext+0x38>
    8000078e:	8526                	mv	a0,s1
    80000790:	00000097          	auipc	ra,0x0
    80000794:	3ca080e7          	jalr	970(ra) # 80000b5a <initlock>
  pr.locking = 1;
    80000798:	4785                	li	a5,1
    8000079a:	cc9c                	sw	a5,24(s1)
}
    8000079c:	60e2                	ld	ra,24(sp)
    8000079e:	6442                	ld	s0,16(sp)
    800007a0:	64a2                	ld	s1,8(sp)
    800007a2:	6105                	addi	sp,sp,32
    800007a4:	8082                	ret

00000000800007a6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007a6:	1141                	addi	sp,sp,-16
    800007a8:	e406                	sd	ra,8(sp)
    800007aa:	e022                	sd	s0,0(sp)
    800007ac:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ae:	100007b7          	lui	a5,0x10000
    800007b2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007b6:	f8000713          	li	a4,-128
    800007ba:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007be:	470d                	li	a4,3
    800007c0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007c8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007cc:	469d                	li	a3,7
    800007ce:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007d2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007d6:	00008597          	auipc	a1,0x8
    800007da:	88258593          	addi	a1,a1,-1918 # 80008058 <digits+0x18>
    800007de:	00010517          	auipc	a0,0x10
    800007e2:	3da50513          	addi	a0,a0,986 # 80010bb8 <uart_tx_lock>
    800007e6:	00000097          	auipc	ra,0x0
    800007ea:	374080e7          	jalr	884(ra) # 80000b5a <initlock>
}
    800007ee:	60a2                	ld	ra,8(sp)
    800007f0:	6402                	ld	s0,0(sp)
    800007f2:	0141                	addi	sp,sp,16
    800007f4:	8082                	ret

00000000800007f6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007f6:	1101                	addi	sp,sp,-32
    800007f8:	ec06                	sd	ra,24(sp)
    800007fa:	e822                	sd	s0,16(sp)
    800007fc:	e426                	sd	s1,8(sp)
    800007fe:	1000                	addi	s0,sp,32
    80000800:	84aa                	mv	s1,a0
  push_off();
    80000802:	00000097          	auipc	ra,0x0
    80000806:	39c080e7          	jalr	924(ra) # 80000b9e <push_off>

  if(panicked){
    8000080a:	00008797          	auipc	a5,0x8
    8000080e:	1667a783          	lw	a5,358(a5) # 80008970 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000812:	10000737          	lui	a4,0x10000
  if(panicked){
    80000816:	c391                	beqz	a5,8000081a <uartputc_sync+0x24>
    for(;;)
    80000818:	a001                	j	80000818 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000081a:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000081e:	0ff7f793          	andi	a5,a5,255
    80000822:	0207f793          	andi	a5,a5,32
    80000826:	dbf5                	beqz	a5,8000081a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000828:	0ff4f793          	andi	a5,s1,255
    8000082c:	10000737          	lui	a4,0x10000
    80000830:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80000834:	00000097          	auipc	ra,0x0
    80000838:	40a080e7          	jalr	1034(ra) # 80000c3e <pop_off>
}
    8000083c:	60e2                	ld	ra,24(sp)
    8000083e:	6442                	ld	s0,16(sp)
    80000840:	64a2                	ld	s1,8(sp)
    80000842:	6105                	addi	sp,sp,32
    80000844:	8082                	ret

0000000080000846 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000846:	00008717          	auipc	a4,0x8
    8000084a:	13273703          	ld	a4,306(a4) # 80008978 <uart_tx_r>
    8000084e:	00008797          	auipc	a5,0x8
    80000852:	1327b783          	ld	a5,306(a5) # 80008980 <uart_tx_w>
    80000856:	06e78c63          	beq	a5,a4,800008ce <uartstart+0x88>
{
    8000085a:	7139                	addi	sp,sp,-64
    8000085c:	fc06                	sd	ra,56(sp)
    8000085e:	f822                	sd	s0,48(sp)
    80000860:	f426                	sd	s1,40(sp)
    80000862:	f04a                	sd	s2,32(sp)
    80000864:	ec4e                	sd	s3,24(sp)
    80000866:	e852                	sd	s4,16(sp)
    80000868:	e456                	sd	s5,8(sp)
    8000086a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000086c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000870:	00010a17          	auipc	s4,0x10
    80000874:	348a0a13          	addi	s4,s4,840 # 80010bb8 <uart_tx_lock>
    uart_tx_r += 1;
    80000878:	00008497          	auipc	s1,0x8
    8000087c:	10048493          	addi	s1,s1,256 # 80008978 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000880:	00008997          	auipc	s3,0x8
    80000884:	10098993          	addi	s3,s3,256 # 80008980 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000888:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000088c:	0ff7f793          	andi	a5,a5,255
    80000890:	0207f793          	andi	a5,a5,32
    80000894:	c785                	beqz	a5,800008bc <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000896:	01f77793          	andi	a5,a4,31
    8000089a:	97d2                	add	a5,a5,s4
    8000089c:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800008a0:	0705                	addi	a4,a4,1
    800008a2:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008a4:	8526                	mv	a0,s1
    800008a6:	00002097          	auipc	ra,0x2
    800008aa:	c3a080e7          	jalr	-966(ra) # 800024e0 <wakeup>
    
    WriteReg(THR, c);
    800008ae:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008b2:	6098                	ld	a4,0(s1)
    800008b4:	0009b783          	ld	a5,0(s3)
    800008b8:	fce798e3          	bne	a5,a4,80000888 <uartstart+0x42>
  }
}
    800008bc:	70e2                	ld	ra,56(sp)
    800008be:	7442                	ld	s0,48(sp)
    800008c0:	74a2                	ld	s1,40(sp)
    800008c2:	7902                	ld	s2,32(sp)
    800008c4:	69e2                	ld	s3,24(sp)
    800008c6:	6a42                	ld	s4,16(sp)
    800008c8:	6aa2                	ld	s5,8(sp)
    800008ca:	6121                	addi	sp,sp,64
    800008cc:	8082                	ret
    800008ce:	8082                	ret

00000000800008d0 <uartputc>:
{
    800008d0:	7179                	addi	sp,sp,-48
    800008d2:	f406                	sd	ra,40(sp)
    800008d4:	f022                	sd	s0,32(sp)
    800008d6:	ec26                	sd	s1,24(sp)
    800008d8:	e84a                	sd	s2,16(sp)
    800008da:	e44e                	sd	s3,8(sp)
    800008dc:	e052                	sd	s4,0(sp)
    800008de:	1800                	addi	s0,sp,48
    800008e0:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800008e2:	00010517          	auipc	a0,0x10
    800008e6:	2d650513          	addi	a0,a0,726 # 80010bb8 <uart_tx_lock>
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	300080e7          	jalr	768(ra) # 80000bea <acquire>
  if(panicked){
    800008f2:	00008797          	auipc	a5,0x8
    800008f6:	07e7a783          	lw	a5,126(a5) # 80008970 <panicked>
    800008fa:	e7c9                	bnez	a5,80000984 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fc:	00008797          	auipc	a5,0x8
    80000900:	0847b783          	ld	a5,132(a5) # 80008980 <uart_tx_w>
    80000904:	00008717          	auipc	a4,0x8
    80000908:	07473703          	ld	a4,116(a4) # 80008978 <uart_tx_r>
    8000090c:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000910:	00010a17          	auipc	s4,0x10
    80000914:	2a8a0a13          	addi	s4,s4,680 # 80010bb8 <uart_tx_lock>
    80000918:	00008497          	auipc	s1,0x8
    8000091c:	06048493          	addi	s1,s1,96 # 80008978 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000920:	00008917          	auipc	s2,0x8
    80000924:	06090913          	addi	s2,s2,96 # 80008980 <uart_tx_w>
    80000928:	00f71f63          	bne	a4,a5,80000946 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000092c:	85d2                	mv	a1,s4
    8000092e:	8526                	mv	a0,s1
    80000930:	00002097          	auipc	ra,0x2
    80000934:	b4c080e7          	jalr	-1204(ra) # 8000247c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000938:	00093783          	ld	a5,0(s2)
    8000093c:	6098                	ld	a4,0(s1)
    8000093e:	02070713          	addi	a4,a4,32
    80000942:	fef705e3          	beq	a4,a5,8000092c <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000946:	00010497          	auipc	s1,0x10
    8000094a:	27248493          	addi	s1,s1,626 # 80010bb8 <uart_tx_lock>
    8000094e:	01f7f713          	andi	a4,a5,31
    80000952:	9726                	add	a4,a4,s1
    80000954:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80000958:	0785                	addi	a5,a5,1
    8000095a:	00008717          	auipc	a4,0x8
    8000095e:	02f73323          	sd	a5,38(a4) # 80008980 <uart_tx_w>
  uartstart();
    80000962:	00000097          	auipc	ra,0x0
    80000966:	ee4080e7          	jalr	-284(ra) # 80000846 <uartstart>
  release(&uart_tx_lock);
    8000096a:	8526                	mv	a0,s1
    8000096c:	00000097          	auipc	ra,0x0
    80000970:	332080e7          	jalr	818(ra) # 80000c9e <release>
}
    80000974:	70a2                	ld	ra,40(sp)
    80000976:	7402                	ld	s0,32(sp)
    80000978:	64e2                	ld	s1,24(sp)
    8000097a:	6942                	ld	s2,16(sp)
    8000097c:	69a2                	ld	s3,8(sp)
    8000097e:	6a02                	ld	s4,0(sp)
    80000980:	6145                	addi	sp,sp,48
    80000982:	8082                	ret
    for(;;)
    80000984:	a001                	j	80000984 <uartputc+0xb4>

0000000080000986 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000986:	1141                	addi	sp,sp,-16
    80000988:	e422                	sd	s0,8(sp)
    8000098a:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000098c:	100007b7          	lui	a5,0x10000
    80000990:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000994:	8b85                	andi	a5,a5,1
    80000996:	cb91                	beqz	a5,800009aa <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000998:	100007b7          	lui	a5,0x10000
    8000099c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009a0:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009a4:	6422                	ld	s0,8(sp)
    800009a6:	0141                	addi	sp,sp,16
    800009a8:	8082                	ret
    return -1;
    800009aa:	557d                	li	a0,-1
    800009ac:	bfe5                	j	800009a4 <uartgetc+0x1e>

00000000800009ae <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009ae:	1101                	addi	sp,sp,-32
    800009b0:	ec06                	sd	ra,24(sp)
    800009b2:	e822                	sd	s0,16(sp)
    800009b4:	e426                	sd	s1,8(sp)
    800009b6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009b8:	54fd                	li	s1,-1
    int c = uartgetc();
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	fcc080e7          	jalr	-52(ra) # 80000986 <uartgetc>
    if(c == -1)
    800009c2:	00950763          	beq	a0,s1,800009d0 <uartintr+0x22>
      break;
    consoleintr(c);
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	8fe080e7          	jalr	-1794(ra) # 800002c4 <consoleintr>
  while(1){
    800009ce:	b7f5                	j	800009ba <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009d0:	00010497          	auipc	s1,0x10
    800009d4:	1e848493          	addi	s1,s1,488 # 80010bb8 <uart_tx_lock>
    800009d8:	8526                	mv	a0,s1
    800009da:	00000097          	auipc	ra,0x0
    800009de:	210080e7          	jalr	528(ra) # 80000bea <acquire>
  uartstart();
    800009e2:	00000097          	auipc	ra,0x0
    800009e6:	e64080e7          	jalr	-412(ra) # 80000846 <uartstart>
  release(&uart_tx_lock);
    800009ea:	8526                	mv	a0,s1
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	2b2080e7          	jalr	690(ra) # 80000c9e <release>
}
    800009f4:	60e2                	ld	ra,24(sp)
    800009f6:	6442                	ld	s0,16(sp)
    800009f8:	64a2                	ld	s1,8(sp)
    800009fa:	6105                	addi	sp,sp,32
    800009fc:	8082                	ret

00000000800009fe <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	e04a                	sd	s2,0(sp)
    80000a08:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a0a:	03451793          	slli	a5,a0,0x34
    80000a0e:	ebb9                	bnez	a5,80000a64 <kfree+0x66>
    80000a10:	84aa                	mv	s1,a0
    80000a12:	00022797          	auipc	a5,0x22
    80000a16:	40e78793          	addi	a5,a5,1038 # 80022e20 <end>
    80000a1a:	04f56563          	bltu	a0,a5,80000a64 <kfree+0x66>
    80000a1e:	47c5                	li	a5,17
    80000a20:	07ee                	slli	a5,a5,0x1b
    80000a22:	04f57163          	bgeu	a0,a5,80000a64 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a26:	6605                	lui	a2,0x1
    80000a28:	4585                	li	a1,1
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	2bc080e7          	jalr	700(ra) # 80000ce6 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a32:	00010917          	auipc	s2,0x10
    80000a36:	1be90913          	addi	s2,s2,446 # 80010bf0 <kmem>
    80000a3a:	854a                	mv	a0,s2
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	1ae080e7          	jalr	430(ra) # 80000bea <acquire>
  r->next = kmem.freelist;
    80000a44:	01893783          	ld	a5,24(s2)
    80000a48:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a4a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a4e:	854a                	mv	a0,s2
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	24e080e7          	jalr	590(ra) # 80000c9e <release>
}
    80000a58:	60e2                	ld	ra,24(sp)
    80000a5a:	6442                	ld	s0,16(sp)
    80000a5c:	64a2                	ld	s1,8(sp)
    80000a5e:	6902                	ld	s2,0(sp)
    80000a60:	6105                	addi	sp,sp,32
    80000a62:	8082                	ret
    panic("kfree");
    80000a64:	00007517          	auipc	a0,0x7
    80000a68:	5fc50513          	addi	a0,a0,1532 # 80008060 <digits+0x20>
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	ad8080e7          	jalr	-1320(ra) # 80000544 <panic>

0000000080000a74 <freerange>:
{
    80000a74:	7179                	addi	sp,sp,-48
    80000a76:	f406                	sd	ra,40(sp)
    80000a78:	f022                	sd	s0,32(sp)
    80000a7a:	ec26                	sd	s1,24(sp)
    80000a7c:	e84a                	sd	s2,16(sp)
    80000a7e:	e44e                	sd	s3,8(sp)
    80000a80:	e052                	sd	s4,0(sp)
    80000a82:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a84:	6785                	lui	a5,0x1
    80000a86:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a8a:	94aa                	add	s1,s1,a0
    80000a8c:	757d                	lui	a0,0xfffff
    80000a8e:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a90:	94be                	add	s1,s1,a5
    80000a92:	0095ee63          	bltu	a1,s1,80000aae <freerange+0x3a>
    80000a96:	892e                	mv	s2,a1
    kfree(p);
    80000a98:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a9a:	6985                	lui	s3,0x1
    kfree(p);
    80000a9c:	01448533          	add	a0,s1,s4
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	f5e080e7          	jalr	-162(ra) # 800009fe <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aa8:	94ce                	add	s1,s1,s3
    80000aaa:	fe9979e3          	bgeu	s2,s1,80000a9c <freerange+0x28>
}
    80000aae:	70a2                	ld	ra,40(sp)
    80000ab0:	7402                	ld	s0,32(sp)
    80000ab2:	64e2                	ld	s1,24(sp)
    80000ab4:	6942                	ld	s2,16(sp)
    80000ab6:	69a2                	ld	s3,8(sp)
    80000ab8:	6a02                	ld	s4,0(sp)
    80000aba:	6145                	addi	sp,sp,48
    80000abc:	8082                	ret

0000000080000abe <kinit>:
{
    80000abe:	1141                	addi	sp,sp,-16
    80000ac0:	e406                	sd	ra,8(sp)
    80000ac2:	e022                	sd	s0,0(sp)
    80000ac4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ac6:	00007597          	auipc	a1,0x7
    80000aca:	5a258593          	addi	a1,a1,1442 # 80008068 <digits+0x28>
    80000ace:	00010517          	auipc	a0,0x10
    80000ad2:	12250513          	addi	a0,a0,290 # 80010bf0 <kmem>
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	084080e7          	jalr	132(ra) # 80000b5a <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ade:	45c5                	li	a1,17
    80000ae0:	05ee                	slli	a1,a1,0x1b
    80000ae2:	00022517          	auipc	a0,0x22
    80000ae6:	33e50513          	addi	a0,a0,830 # 80022e20 <end>
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	f8a080e7          	jalr	-118(ra) # 80000a74 <freerange>
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret

0000000080000afa <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000afa:	1101                	addi	sp,sp,-32
    80000afc:	ec06                	sd	ra,24(sp)
    80000afe:	e822                	sd	s0,16(sp)
    80000b00:	e426                	sd	s1,8(sp)
    80000b02:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b04:	00010497          	auipc	s1,0x10
    80000b08:	0ec48493          	addi	s1,s1,236 # 80010bf0 <kmem>
    80000b0c:	8526                	mv	a0,s1
    80000b0e:	00000097          	auipc	ra,0x0
    80000b12:	0dc080e7          	jalr	220(ra) # 80000bea <acquire>
  r = kmem.freelist;
    80000b16:	6c84                	ld	s1,24(s1)
  if(r)
    80000b18:	c885                	beqz	s1,80000b48 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b1a:	609c                	ld	a5,0(s1)
    80000b1c:	00010517          	auipc	a0,0x10
    80000b20:	0d450513          	addi	a0,a0,212 # 80010bf0 <kmem>
    80000b24:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b26:	00000097          	auipc	ra,0x0
    80000b2a:	178080e7          	jalr	376(ra) # 80000c9e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b2e:	6605                	lui	a2,0x1
    80000b30:	4595                	li	a1,5
    80000b32:	8526                	mv	a0,s1
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	1b2080e7          	jalr	434(ra) # 80000ce6 <memset>
  return (void*)r;
}
    80000b3c:	8526                	mv	a0,s1
    80000b3e:	60e2                	ld	ra,24(sp)
    80000b40:	6442                	ld	s0,16(sp)
    80000b42:	64a2                	ld	s1,8(sp)
    80000b44:	6105                	addi	sp,sp,32
    80000b46:	8082                	ret
  release(&kmem.lock);
    80000b48:	00010517          	auipc	a0,0x10
    80000b4c:	0a850513          	addi	a0,a0,168 # 80010bf0 <kmem>
    80000b50:	00000097          	auipc	ra,0x0
    80000b54:	14e080e7          	jalr	334(ra) # 80000c9e <release>
  if(r)
    80000b58:	b7d5                	j	80000b3c <kalloc+0x42>

0000000080000b5a <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b5a:	1141                	addi	sp,sp,-16
    80000b5c:	e422                	sd	s0,8(sp)
    80000b5e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b60:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b62:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b66:	00053823          	sd	zero,16(a0)
}
    80000b6a:	6422                	ld	s0,8(sp)
    80000b6c:	0141                	addi	sp,sp,16
    80000b6e:	8082                	ret

0000000080000b70 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b70:	411c                	lw	a5,0(a0)
    80000b72:	e399                	bnez	a5,80000b78 <holding+0x8>
    80000b74:	4501                	li	a0,0
  return r;
}
    80000b76:	8082                	ret
{
    80000b78:	1101                	addi	sp,sp,-32
    80000b7a:	ec06                	sd	ra,24(sp)
    80000b7c:	e822                	sd	s0,16(sp)
    80000b7e:	e426                	sd	s1,8(sp)
    80000b80:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b82:	6904                	ld	s1,16(a0)
    80000b84:	00001097          	auipc	ra,0x1
    80000b88:	e3c080e7          	jalr	-452(ra) # 800019c0 <mycpu>
    80000b8c:	40a48533          	sub	a0,s1,a0
    80000b90:	00153513          	seqz	a0,a0
}
    80000b94:	60e2                	ld	ra,24(sp)
    80000b96:	6442                	ld	s0,16(sp)
    80000b98:	64a2                	ld	s1,8(sp)
    80000b9a:	6105                	addi	sp,sp,32
    80000b9c:	8082                	ret

0000000080000b9e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b9e:	1101                	addi	sp,sp,-32
    80000ba0:	ec06                	sd	ra,24(sp)
    80000ba2:	e822                	sd	s0,16(sp)
    80000ba4:	e426                	sd	s1,8(sp)
    80000ba6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ba8:	100024f3          	csrr	s1,sstatus
    80000bac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bb0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bb2:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bb6:	00001097          	auipc	ra,0x1
    80000bba:	e0a080e7          	jalr	-502(ra) # 800019c0 <mycpu>
    80000bbe:	5d3c                	lw	a5,120(a0)
    80000bc0:	cf89                	beqz	a5,80000bda <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bc2:	00001097          	auipc	ra,0x1
    80000bc6:	dfe080e7          	jalr	-514(ra) # 800019c0 <mycpu>
    80000bca:	5d3c                	lw	a5,120(a0)
    80000bcc:	2785                	addiw	a5,a5,1
    80000bce:	dd3c                	sw	a5,120(a0)
}
    80000bd0:	60e2                	ld	ra,24(sp)
    80000bd2:	6442                	ld	s0,16(sp)
    80000bd4:	64a2                	ld	s1,8(sp)
    80000bd6:	6105                	addi	sp,sp,32
    80000bd8:	8082                	ret
    mycpu()->intena = old;
    80000bda:	00001097          	auipc	ra,0x1
    80000bde:	de6080e7          	jalr	-538(ra) # 800019c0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000be2:	8085                	srli	s1,s1,0x1
    80000be4:	8885                	andi	s1,s1,1
    80000be6:	dd64                	sw	s1,124(a0)
    80000be8:	bfe9                	j	80000bc2 <push_off+0x24>

0000000080000bea <acquire>:
{
    80000bea:	1101                	addi	sp,sp,-32
    80000bec:	ec06                	sd	ra,24(sp)
    80000bee:	e822                	sd	s0,16(sp)
    80000bf0:	e426                	sd	s1,8(sp)
    80000bf2:	1000                	addi	s0,sp,32
    80000bf4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bf6:	00000097          	auipc	ra,0x0
    80000bfa:	fa8080e7          	jalr	-88(ra) # 80000b9e <push_off>
  if(holding(lk))
    80000bfe:	8526                	mv	a0,s1
    80000c00:	00000097          	auipc	ra,0x0
    80000c04:	f70080e7          	jalr	-144(ra) # 80000b70 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c08:	4705                	li	a4,1
  if(holding(lk))
    80000c0a:	e115                	bnez	a0,80000c2e <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0c:	87ba                	mv	a5,a4
    80000c0e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c12:	2781                	sext.w	a5,a5
    80000c14:	ffe5                	bnez	a5,80000c0c <acquire+0x22>
  __sync_synchronize();
    80000c16:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c1a:	00001097          	auipc	ra,0x1
    80000c1e:	da6080e7          	jalr	-602(ra) # 800019c0 <mycpu>
    80000c22:	e888                	sd	a0,16(s1)
}
    80000c24:	60e2                	ld	ra,24(sp)
    80000c26:	6442                	ld	s0,16(sp)
    80000c28:	64a2                	ld	s1,8(sp)
    80000c2a:	6105                	addi	sp,sp,32
    80000c2c:	8082                	ret
    panic("acquire");
    80000c2e:	00007517          	auipc	a0,0x7
    80000c32:	44250513          	addi	a0,a0,1090 # 80008070 <digits+0x30>
    80000c36:	00000097          	auipc	ra,0x0
    80000c3a:	90e080e7          	jalr	-1778(ra) # 80000544 <panic>

0000000080000c3e <pop_off>:

void
pop_off(void)
{
    80000c3e:	1141                	addi	sp,sp,-16
    80000c40:	e406                	sd	ra,8(sp)
    80000c42:	e022                	sd	s0,0(sp)
    80000c44:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c46:	00001097          	auipc	ra,0x1
    80000c4a:	d7a080e7          	jalr	-646(ra) # 800019c0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c52:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c54:	e78d                	bnez	a5,80000c7e <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c56:	5d3c                	lw	a5,120(a0)
    80000c58:	02f05b63          	blez	a5,80000c8e <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c5c:	37fd                	addiw	a5,a5,-1
    80000c5e:	0007871b          	sext.w	a4,a5
    80000c62:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c64:	eb09                	bnez	a4,80000c76 <pop_off+0x38>
    80000c66:	5d7c                	lw	a5,124(a0)
    80000c68:	c799                	beqz	a5,80000c76 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c6a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c6e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c72:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c76:	60a2                	ld	ra,8(sp)
    80000c78:	6402                	ld	s0,0(sp)
    80000c7a:	0141                	addi	sp,sp,16
    80000c7c:	8082                	ret
    panic("pop_off - interruptible");
    80000c7e:	00007517          	auipc	a0,0x7
    80000c82:	3fa50513          	addi	a0,a0,1018 # 80008078 <digits+0x38>
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	8be080e7          	jalr	-1858(ra) # 80000544 <panic>
    panic("pop_off");
    80000c8e:	00007517          	auipc	a0,0x7
    80000c92:	40250513          	addi	a0,a0,1026 # 80008090 <digits+0x50>
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	8ae080e7          	jalr	-1874(ra) # 80000544 <panic>

0000000080000c9e <release>:
{
    80000c9e:	1101                	addi	sp,sp,-32
    80000ca0:	ec06                	sd	ra,24(sp)
    80000ca2:	e822                	sd	s0,16(sp)
    80000ca4:	e426                	sd	s1,8(sp)
    80000ca6:	1000                	addi	s0,sp,32
    80000ca8:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	ec6080e7          	jalr	-314(ra) # 80000b70 <holding>
    80000cb2:	c115                	beqz	a0,80000cd6 <release+0x38>
  lk->cpu = 0;
    80000cb4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cb8:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000cbc:	0f50000f          	fence	iorw,ow
    80000cc0:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	f7a080e7          	jalr	-134(ra) # 80000c3e <pop_off>
}
    80000ccc:	60e2                	ld	ra,24(sp)
    80000cce:	6442                	ld	s0,16(sp)
    80000cd0:	64a2                	ld	s1,8(sp)
    80000cd2:	6105                	addi	sp,sp,32
    80000cd4:	8082                	ret
    panic("release");
    80000cd6:	00007517          	auipc	a0,0x7
    80000cda:	3c250513          	addi	a0,a0,962 # 80008098 <digits+0x58>
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	866080e7          	jalr	-1946(ra) # 80000544 <panic>

0000000080000ce6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ce6:	1141                	addi	sp,sp,-16
    80000ce8:	e422                	sd	s0,8(sp)
    80000cea:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cec:	ce09                	beqz	a2,80000d06 <memset+0x20>
    80000cee:	87aa                	mv	a5,a0
    80000cf0:	fff6071b          	addiw	a4,a2,-1
    80000cf4:	1702                	slli	a4,a4,0x20
    80000cf6:	9301                	srli	a4,a4,0x20
    80000cf8:	0705                	addi	a4,a4,1
    80000cfa:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000cfc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d00:	0785                	addi	a5,a5,1
    80000d02:	fee79de3          	bne	a5,a4,80000cfc <memset+0x16>
  }
  return dst;
}
    80000d06:	6422                	ld	s0,8(sp)
    80000d08:	0141                	addi	sp,sp,16
    80000d0a:	8082                	ret

0000000080000d0c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d0c:	1141                	addi	sp,sp,-16
    80000d0e:	e422                	sd	s0,8(sp)
    80000d10:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d12:	ca05                	beqz	a2,80000d42 <memcmp+0x36>
    80000d14:	fff6069b          	addiw	a3,a2,-1
    80000d18:	1682                	slli	a3,a3,0x20
    80000d1a:	9281                	srli	a3,a3,0x20
    80000d1c:	0685                	addi	a3,a3,1
    80000d1e:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d20:	00054783          	lbu	a5,0(a0)
    80000d24:	0005c703          	lbu	a4,0(a1)
    80000d28:	00e79863          	bne	a5,a4,80000d38 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d2c:	0505                	addi	a0,a0,1
    80000d2e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d30:	fed518e3          	bne	a0,a3,80000d20 <memcmp+0x14>
  }

  return 0;
    80000d34:	4501                	li	a0,0
    80000d36:	a019                	j	80000d3c <memcmp+0x30>
      return *s1 - *s2;
    80000d38:	40e7853b          	subw	a0,a5,a4
}
    80000d3c:	6422                	ld	s0,8(sp)
    80000d3e:	0141                	addi	sp,sp,16
    80000d40:	8082                	ret
  return 0;
    80000d42:	4501                	li	a0,0
    80000d44:	bfe5                	j	80000d3c <memcmp+0x30>

0000000080000d46 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d46:	1141                	addi	sp,sp,-16
    80000d48:	e422                	sd	s0,8(sp)
    80000d4a:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d4c:	ca0d                	beqz	a2,80000d7e <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d4e:	00a5f963          	bgeu	a1,a0,80000d60 <memmove+0x1a>
    80000d52:	02061693          	slli	a3,a2,0x20
    80000d56:	9281                	srli	a3,a3,0x20
    80000d58:	00d58733          	add	a4,a1,a3
    80000d5c:	02e56463          	bltu	a0,a4,80000d84 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	0785                	addi	a5,a5,1
    80000d6a:	97ae                	add	a5,a5,a1
    80000d6c:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d6e:	0585                	addi	a1,a1,1
    80000d70:	0705                	addi	a4,a4,1
    80000d72:	fff5c683          	lbu	a3,-1(a1)
    80000d76:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d7a:	fef59ae3          	bne	a1,a5,80000d6e <memmove+0x28>

  return dst;
}
    80000d7e:	6422                	ld	s0,8(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret
    d += n;
    80000d84:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d86:	fff6079b          	addiw	a5,a2,-1
    80000d8a:	1782                	slli	a5,a5,0x20
    80000d8c:	9381                	srli	a5,a5,0x20
    80000d8e:	fff7c793          	not	a5,a5
    80000d92:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d94:	177d                	addi	a4,a4,-1
    80000d96:	16fd                	addi	a3,a3,-1
    80000d98:	00074603          	lbu	a2,0(a4)
    80000d9c:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000da0:	fef71ae3          	bne	a4,a5,80000d94 <memmove+0x4e>
    80000da4:	bfe9                	j	80000d7e <memmove+0x38>

0000000080000da6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000da6:	1141                	addi	sp,sp,-16
    80000da8:	e406                	sd	ra,8(sp)
    80000daa:	e022                	sd	s0,0(sp)
    80000dac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dae:	00000097          	auipc	ra,0x0
    80000db2:	f98080e7          	jalr	-104(ra) # 80000d46 <memmove>
}
    80000db6:	60a2                	ld	ra,8(sp)
    80000db8:	6402                	ld	s0,0(sp)
    80000dba:	0141                	addi	sp,sp,16
    80000dbc:	8082                	ret

0000000080000dbe <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dbe:	1141                	addi	sp,sp,-16
    80000dc0:	e422                	sd	s0,8(sp)
    80000dc2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dc4:	ce11                	beqz	a2,80000de0 <strncmp+0x22>
    80000dc6:	00054783          	lbu	a5,0(a0)
    80000dca:	cf89                	beqz	a5,80000de4 <strncmp+0x26>
    80000dcc:	0005c703          	lbu	a4,0(a1)
    80000dd0:	00f71a63          	bne	a4,a5,80000de4 <strncmp+0x26>
    n--, p++, q++;
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	0505                	addi	a0,a0,1
    80000dd8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dda:	f675                	bnez	a2,80000dc6 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000ddc:	4501                	li	a0,0
    80000dde:	a809                	j	80000df0 <strncmp+0x32>
    80000de0:	4501                	li	a0,0
    80000de2:	a039                	j	80000df0 <strncmp+0x32>
  if(n == 0)
    80000de4:	ca09                	beqz	a2,80000df6 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000de6:	00054503          	lbu	a0,0(a0)
    80000dea:	0005c783          	lbu	a5,0(a1)
    80000dee:	9d1d                	subw	a0,a0,a5
}
    80000df0:	6422                	ld	s0,8(sp)
    80000df2:	0141                	addi	sp,sp,16
    80000df4:	8082                	ret
    return 0;
    80000df6:	4501                	li	a0,0
    80000df8:	bfe5                	j	80000df0 <strncmp+0x32>

0000000080000dfa <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dfa:	1141                	addi	sp,sp,-16
    80000dfc:	e422                	sd	s0,8(sp)
    80000dfe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e00:	872a                	mv	a4,a0
    80000e02:	8832                	mv	a6,a2
    80000e04:	367d                	addiw	a2,a2,-1
    80000e06:	01005963          	blez	a6,80000e18 <strncpy+0x1e>
    80000e0a:	0705                	addi	a4,a4,1
    80000e0c:	0005c783          	lbu	a5,0(a1)
    80000e10:	fef70fa3          	sb	a5,-1(a4)
    80000e14:	0585                	addi	a1,a1,1
    80000e16:	f7f5                	bnez	a5,80000e02 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e18:	00c05d63          	blez	a2,80000e32 <strncpy+0x38>
    80000e1c:	86ba                	mv	a3,a4
    *s++ = 0;
    80000e1e:	0685                	addi	a3,a3,1
    80000e20:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e24:	fff6c793          	not	a5,a3
    80000e28:	9fb9                	addw	a5,a5,a4
    80000e2a:	010787bb          	addw	a5,a5,a6
    80000e2e:	fef048e3          	bgtz	a5,80000e1e <strncpy+0x24>
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e3e:	02c05363          	blez	a2,80000e64 <safestrcpy+0x2c>
    80000e42:	fff6069b          	addiw	a3,a2,-1
    80000e46:	1682                	slli	a3,a3,0x20
    80000e48:	9281                	srli	a3,a3,0x20
    80000e4a:	96ae                	add	a3,a3,a1
    80000e4c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e4e:	00d58963          	beq	a1,a3,80000e60 <safestrcpy+0x28>
    80000e52:	0585                	addi	a1,a1,1
    80000e54:	0785                	addi	a5,a5,1
    80000e56:	fff5c703          	lbu	a4,-1(a1)
    80000e5a:	fee78fa3          	sb	a4,-1(a5)
    80000e5e:	fb65                	bnez	a4,80000e4e <safestrcpy+0x16>
    ;
  *s = 0;
    80000e60:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e64:	6422                	ld	s0,8(sp)
    80000e66:	0141                	addi	sp,sp,16
    80000e68:	8082                	ret

0000000080000e6a <strlen>:

int
strlen(const char *s)
{
    80000e6a:	1141                	addi	sp,sp,-16
    80000e6c:	e422                	sd	s0,8(sp)
    80000e6e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e70:	00054783          	lbu	a5,0(a0)
    80000e74:	cf91                	beqz	a5,80000e90 <strlen+0x26>
    80000e76:	0505                	addi	a0,a0,1
    80000e78:	87aa                	mv	a5,a0
    80000e7a:	4685                	li	a3,1
    80000e7c:	9e89                	subw	a3,a3,a0
    80000e7e:	00f6853b          	addw	a0,a3,a5
    80000e82:	0785                	addi	a5,a5,1
    80000e84:	fff7c703          	lbu	a4,-1(a5)
    80000e88:	fb7d                	bnez	a4,80000e7e <strlen+0x14>
    ;
  return n;
}
    80000e8a:	6422                	ld	s0,8(sp)
    80000e8c:	0141                	addi	sp,sp,16
    80000e8e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e90:	4501                	li	a0,0
    80000e92:	bfe5                	j	80000e8a <strlen+0x20>

0000000080000e94 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e406                	sd	ra,8(sp)
    80000e98:	e022                	sd	s0,0(sp)
    80000e9a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	b14080e7          	jalr	-1260(ra) # 800019b0 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ea4:	00008717          	auipc	a4,0x8
    80000ea8:	ae470713          	addi	a4,a4,-1308 # 80008988 <started>
  if(cpuid() == 0){
    80000eac:	c139                	beqz	a0,80000ef2 <main+0x5e>
    while(started == 0)
    80000eae:	431c                	lw	a5,0(a4)
    80000eb0:	2781                	sext.w	a5,a5
    80000eb2:	dff5                	beqz	a5,80000eae <main+0x1a>
      ;
    __sync_synchronize();
    80000eb4:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000eb8:	00001097          	auipc	ra,0x1
    80000ebc:	af8080e7          	jalr	-1288(ra) # 800019b0 <cpuid>
    80000ec0:	85aa                	mv	a1,a0
    80000ec2:	00007517          	auipc	a0,0x7
    80000ec6:	1f650513          	addi	a0,a0,502 # 800080b8 <digits+0x78>
    80000eca:	fffff097          	auipc	ra,0xfffff
    80000ece:	6c4080e7          	jalr	1732(ra) # 8000058e <printf>
    kvminithart();    // turn on paging
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	0d8080e7          	jalr	216(ra) # 80000faa <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eda:	00002097          	auipc	ra,0x2
    80000ede:	c52080e7          	jalr	-942(ra) # 80002b2c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee2:	00005097          	auipc	ra,0x5
    80000ee6:	35e080e7          	jalr	862(ra) # 80006240 <plicinithart>
  }

  scheduler();        
    80000eea:	00001097          	auipc	ra,0x1
    80000eee:	7b2080e7          	jalr	1970(ra) # 8000269c <scheduler>
    consoleinit();
    80000ef2:	fffff097          	auipc	ra,0xfffff
    80000ef6:	564080e7          	jalr	1380(ra) # 80000456 <consoleinit>
    printfinit();
    80000efa:	00000097          	auipc	ra,0x0
    80000efe:	87a080e7          	jalr	-1926(ra) # 80000774 <printfinit>
    printf("\n");
    80000f02:	00007517          	auipc	a0,0x7
    80000f06:	1c650513          	addi	a0,a0,454 # 800080c8 <digits+0x88>
    80000f0a:	fffff097          	auipc	ra,0xfffff
    80000f0e:	684080e7          	jalr	1668(ra) # 8000058e <printf>
    printf("xv6 kernel is booting\n");
    80000f12:	00007517          	auipc	a0,0x7
    80000f16:	18e50513          	addi	a0,a0,398 # 800080a0 <digits+0x60>
    80000f1a:	fffff097          	auipc	ra,0xfffff
    80000f1e:	674080e7          	jalr	1652(ra) # 8000058e <printf>
    printf("\n");
    80000f22:	00007517          	auipc	a0,0x7
    80000f26:	1a650513          	addi	a0,a0,422 # 800080c8 <digits+0x88>
    80000f2a:	fffff097          	auipc	ra,0xfffff
    80000f2e:	664080e7          	jalr	1636(ra) # 8000058e <printf>
    kinit();         // physical page allocator
    80000f32:	00000097          	auipc	ra,0x0
    80000f36:	b8c080e7          	jalr	-1140(ra) # 80000abe <kinit>
    kvminit();       // create kernel page table
    80000f3a:	00000097          	auipc	ra,0x0
    80000f3e:	326080e7          	jalr	806(ra) # 80001260 <kvminit>
    kvminithart();   // turn on paging
    80000f42:	00000097          	auipc	ra,0x0
    80000f46:	068080e7          	jalr	104(ra) # 80000faa <kvminithart>
    procinit();      // process table
    80000f4a:	00001097          	auipc	ra,0x1
    80000f4e:	9b2080e7          	jalr	-1614(ra) # 800018fc <procinit>
    trapinit();      // trap vectors
    80000f52:	00002097          	auipc	ra,0x2
    80000f56:	bb2080e7          	jalr	-1102(ra) # 80002b04 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f5a:	00002097          	auipc	ra,0x2
    80000f5e:	bd2080e7          	jalr	-1070(ra) # 80002b2c <trapinithart>
    plicinit();      // set up interrupt controller
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	2c8080e7          	jalr	712(ra) # 8000622a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f6a:	00005097          	auipc	ra,0x5
    80000f6e:	2d6080e7          	jalr	726(ra) # 80006240 <plicinithart>
    binit();         // buffer cache
    80000f72:	00002097          	auipc	ra,0x2
    80000f76:	484080e7          	jalr	1156(ra) # 800033f6 <binit>
    iinit();         // inode table
    80000f7a:	00003097          	auipc	ra,0x3
    80000f7e:	b28080e7          	jalr	-1240(ra) # 80003aa2 <iinit>
    fileinit();      // file table
    80000f82:	00004097          	auipc	ra,0x4
    80000f86:	ac6080e7          	jalr	-1338(ra) # 80004a48 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f8a:	00005097          	auipc	ra,0x5
    80000f8e:	3be080e7          	jalr	958(ra) # 80006348 <virtio_disk_init>
    userinit();      // first user process
    80000f92:	00001097          	auipc	ra,0x1
    80000f96:	eae080e7          	jalr	-338(ra) # 80001e40 <userinit>
    __sync_synchronize();
    80000f9a:	0ff0000f          	fence
    started = 1;
    80000f9e:	4785                	li	a5,1
    80000fa0:	00008717          	auipc	a4,0x8
    80000fa4:	9ef72423          	sw	a5,-1560(a4) # 80008988 <started>
    80000fa8:	b789                	j	80000eea <main+0x56>

0000000080000faa <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000faa:	1141                	addi	sp,sp,-16
    80000fac:	e422                	sd	s0,8(sp)
    80000fae:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fb0:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000fb4:	00008797          	auipc	a5,0x8
    80000fb8:	9dc7b783          	ld	a5,-1572(a5) # 80008990 <kernel_pagetable>
    80000fbc:	83b1                	srli	a5,a5,0xc
    80000fbe:	577d                	li	a4,-1
    80000fc0:	177e                	slli	a4,a4,0x3f
    80000fc2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fc4:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000fc8:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000fcc:	6422                	ld	s0,8(sp)
    80000fce:	0141                	addi	sp,sp,16
    80000fd0:	8082                	ret

0000000080000fd2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fd2:	7139                	addi	sp,sp,-64
    80000fd4:	fc06                	sd	ra,56(sp)
    80000fd6:	f822                	sd	s0,48(sp)
    80000fd8:	f426                	sd	s1,40(sp)
    80000fda:	f04a                	sd	s2,32(sp)
    80000fdc:	ec4e                	sd	s3,24(sp)
    80000fde:	e852                	sd	s4,16(sp)
    80000fe0:	e456                	sd	s5,8(sp)
    80000fe2:	e05a                	sd	s6,0(sp)
    80000fe4:	0080                	addi	s0,sp,64
    80000fe6:	84aa                	mv	s1,a0
    80000fe8:	89ae                	mv	s3,a1
    80000fea:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fec:	57fd                	li	a5,-1
    80000fee:	83e9                	srli	a5,a5,0x1a
    80000ff0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000ff2:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000ff4:	04b7f263          	bgeu	a5,a1,80001038 <walk+0x66>
    panic("walk");
    80000ff8:	00007517          	auipc	a0,0x7
    80000ffc:	0d850513          	addi	a0,a0,216 # 800080d0 <digits+0x90>
    80001000:	fffff097          	auipc	ra,0xfffff
    80001004:	544080e7          	jalr	1348(ra) # 80000544 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001008:	060a8663          	beqz	s5,80001074 <walk+0xa2>
    8000100c:	00000097          	auipc	ra,0x0
    80001010:	aee080e7          	jalr	-1298(ra) # 80000afa <kalloc>
    80001014:	84aa                	mv	s1,a0
    80001016:	c529                	beqz	a0,80001060 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001018:	6605                	lui	a2,0x1
    8000101a:	4581                	li	a1,0
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	cca080e7          	jalr	-822(ra) # 80000ce6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001024:	00c4d793          	srli	a5,s1,0xc
    80001028:	07aa                	slli	a5,a5,0xa
    8000102a:	0017e793          	ori	a5,a5,1
    8000102e:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001032:	3a5d                	addiw	s4,s4,-9
    80001034:	036a0063          	beq	s4,s6,80001054 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001038:	0149d933          	srl	s2,s3,s4
    8000103c:	1ff97913          	andi	s2,s2,511
    80001040:	090e                	slli	s2,s2,0x3
    80001042:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001044:	00093483          	ld	s1,0(s2)
    80001048:	0014f793          	andi	a5,s1,1
    8000104c:	dfd5                	beqz	a5,80001008 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000104e:	80a9                	srli	s1,s1,0xa
    80001050:	04b2                	slli	s1,s1,0xc
    80001052:	b7c5                	j	80001032 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001054:	00c9d513          	srli	a0,s3,0xc
    80001058:	1ff57513          	andi	a0,a0,511
    8000105c:	050e                	slli	a0,a0,0x3
    8000105e:	9526                	add	a0,a0,s1
}
    80001060:	70e2                	ld	ra,56(sp)
    80001062:	7442                	ld	s0,48(sp)
    80001064:	74a2                	ld	s1,40(sp)
    80001066:	7902                	ld	s2,32(sp)
    80001068:	69e2                	ld	s3,24(sp)
    8000106a:	6a42                	ld	s4,16(sp)
    8000106c:	6aa2                	ld	s5,8(sp)
    8000106e:	6b02                	ld	s6,0(sp)
    80001070:	6121                	addi	sp,sp,64
    80001072:	8082                	ret
        return 0;
    80001074:	4501                	li	a0,0
    80001076:	b7ed                	j	80001060 <walk+0x8e>

0000000080001078 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001078:	57fd                	li	a5,-1
    8000107a:	83e9                	srli	a5,a5,0x1a
    8000107c:	00b7f463          	bgeu	a5,a1,80001084 <walkaddr+0xc>
    return 0;
    80001080:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001082:	8082                	ret
{
    80001084:	1141                	addi	sp,sp,-16
    80001086:	e406                	sd	ra,8(sp)
    80001088:	e022                	sd	s0,0(sp)
    8000108a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000108c:	4601                	li	a2,0
    8000108e:	00000097          	auipc	ra,0x0
    80001092:	f44080e7          	jalr	-188(ra) # 80000fd2 <walk>
  if(pte == 0)
    80001096:	c105                	beqz	a0,800010b6 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80001098:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000109a:	0117f693          	andi	a3,a5,17
    8000109e:	4745                	li	a4,17
    return 0;
    800010a0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010a2:	00e68663          	beq	a3,a4,800010ae <walkaddr+0x36>
}
    800010a6:	60a2                	ld	ra,8(sp)
    800010a8:	6402                	ld	s0,0(sp)
    800010aa:	0141                	addi	sp,sp,16
    800010ac:	8082                	ret
  pa = PTE2PA(*pte);
    800010ae:	00a7d513          	srli	a0,a5,0xa
    800010b2:	0532                	slli	a0,a0,0xc
  return pa;
    800010b4:	bfcd                	j	800010a6 <walkaddr+0x2e>
    return 0;
    800010b6:	4501                	li	a0,0
    800010b8:	b7fd                	j	800010a6 <walkaddr+0x2e>

00000000800010ba <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010ba:	715d                	addi	sp,sp,-80
    800010bc:	e486                	sd	ra,72(sp)
    800010be:	e0a2                	sd	s0,64(sp)
    800010c0:	fc26                	sd	s1,56(sp)
    800010c2:	f84a                	sd	s2,48(sp)
    800010c4:	f44e                	sd	s3,40(sp)
    800010c6:	f052                	sd	s4,32(sp)
    800010c8:	ec56                	sd	s5,24(sp)
    800010ca:	e85a                	sd	s6,16(sp)
    800010cc:	e45e                	sd	s7,8(sp)
    800010ce:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800010d0:	c205                	beqz	a2,800010f0 <mappages+0x36>
    800010d2:	8aaa                	mv	s5,a0
    800010d4:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800010d6:	77fd                	lui	a5,0xfffff
    800010d8:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800010dc:	15fd                	addi	a1,a1,-1
    800010de:	00c589b3          	add	s3,a1,a2
    800010e2:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800010e6:	8952                	mv	s2,s4
    800010e8:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010ec:	6b85                	lui	s7,0x1
    800010ee:	a015                	j	80001112 <mappages+0x58>
    panic("mappages: size");
    800010f0:	00007517          	auipc	a0,0x7
    800010f4:	fe850513          	addi	a0,a0,-24 # 800080d8 <digits+0x98>
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	44c080e7          	jalr	1100(ra) # 80000544 <panic>
      panic("mappages: remap");
    80001100:	00007517          	auipc	a0,0x7
    80001104:	fe850513          	addi	a0,a0,-24 # 800080e8 <digits+0xa8>
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	43c080e7          	jalr	1084(ra) # 80000544 <panic>
    a += PGSIZE;
    80001110:	995e                	add	s2,s2,s7
  for(;;){
    80001112:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001116:	4605                	li	a2,1
    80001118:	85ca                	mv	a1,s2
    8000111a:	8556                	mv	a0,s5
    8000111c:	00000097          	auipc	ra,0x0
    80001120:	eb6080e7          	jalr	-330(ra) # 80000fd2 <walk>
    80001124:	cd19                	beqz	a0,80001142 <mappages+0x88>
    if(*pte & PTE_V)
    80001126:	611c                	ld	a5,0(a0)
    80001128:	8b85                	andi	a5,a5,1
    8000112a:	fbf9                	bnez	a5,80001100 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000112c:	80b1                	srli	s1,s1,0xc
    8000112e:	04aa                	slli	s1,s1,0xa
    80001130:	0164e4b3          	or	s1,s1,s6
    80001134:	0014e493          	ori	s1,s1,1
    80001138:	e104                	sd	s1,0(a0)
    if(a == last)
    8000113a:	fd391be3          	bne	s2,s3,80001110 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    8000113e:	4501                	li	a0,0
    80001140:	a011                	j	80001144 <mappages+0x8a>
      return -1;
    80001142:	557d                	li	a0,-1
}
    80001144:	60a6                	ld	ra,72(sp)
    80001146:	6406                	ld	s0,64(sp)
    80001148:	74e2                	ld	s1,56(sp)
    8000114a:	7942                	ld	s2,48(sp)
    8000114c:	79a2                	ld	s3,40(sp)
    8000114e:	7a02                	ld	s4,32(sp)
    80001150:	6ae2                	ld	s5,24(sp)
    80001152:	6b42                	ld	s6,16(sp)
    80001154:	6ba2                	ld	s7,8(sp)
    80001156:	6161                	addi	sp,sp,80
    80001158:	8082                	ret

000000008000115a <kvmmap>:
{
    8000115a:	1141                	addi	sp,sp,-16
    8000115c:	e406                	sd	ra,8(sp)
    8000115e:	e022                	sd	s0,0(sp)
    80001160:	0800                	addi	s0,sp,16
    80001162:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001164:	86b2                	mv	a3,a2
    80001166:	863e                	mv	a2,a5
    80001168:	00000097          	auipc	ra,0x0
    8000116c:	f52080e7          	jalr	-174(ra) # 800010ba <mappages>
    80001170:	e509                	bnez	a0,8000117a <kvmmap+0x20>
}
    80001172:	60a2                	ld	ra,8(sp)
    80001174:	6402                	ld	s0,0(sp)
    80001176:	0141                	addi	sp,sp,16
    80001178:	8082                	ret
    panic("kvmmap");
    8000117a:	00007517          	auipc	a0,0x7
    8000117e:	f7e50513          	addi	a0,a0,-130 # 800080f8 <digits+0xb8>
    80001182:	fffff097          	auipc	ra,0xfffff
    80001186:	3c2080e7          	jalr	962(ra) # 80000544 <panic>

000000008000118a <kvmmake>:
{
    8000118a:	1101                	addi	sp,sp,-32
    8000118c:	ec06                	sd	ra,24(sp)
    8000118e:	e822                	sd	s0,16(sp)
    80001190:	e426                	sd	s1,8(sp)
    80001192:	e04a                	sd	s2,0(sp)
    80001194:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	964080e7          	jalr	-1692(ra) # 80000afa <kalloc>
    8000119e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011a0:	6605                	lui	a2,0x1
    800011a2:	4581                	li	a1,0
    800011a4:	00000097          	auipc	ra,0x0
    800011a8:	b42080e7          	jalr	-1214(ra) # 80000ce6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011ac:	4719                	li	a4,6
    800011ae:	6685                	lui	a3,0x1
    800011b0:	10000637          	lui	a2,0x10000
    800011b4:	100005b7          	lui	a1,0x10000
    800011b8:	8526                	mv	a0,s1
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	fa0080e7          	jalr	-96(ra) # 8000115a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011c2:	4719                	li	a4,6
    800011c4:	6685                	lui	a3,0x1
    800011c6:	10001637          	lui	a2,0x10001
    800011ca:	100015b7          	lui	a1,0x10001
    800011ce:	8526                	mv	a0,s1
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	f8a080e7          	jalr	-118(ra) # 8000115a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800011d8:	4719                	li	a4,6
    800011da:	004006b7          	lui	a3,0x400
    800011de:	0c000637          	lui	a2,0xc000
    800011e2:	0c0005b7          	lui	a1,0xc000
    800011e6:	8526                	mv	a0,s1
    800011e8:	00000097          	auipc	ra,0x0
    800011ec:	f72080e7          	jalr	-142(ra) # 8000115a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011f0:	00007917          	auipc	s2,0x7
    800011f4:	e1090913          	addi	s2,s2,-496 # 80008000 <etext>
    800011f8:	4729                	li	a4,10
    800011fa:	80007697          	auipc	a3,0x80007
    800011fe:	e0668693          	addi	a3,a3,-506 # 8000 <_entry-0x7fff8000>
    80001202:	4605                	li	a2,1
    80001204:	067e                	slli	a2,a2,0x1f
    80001206:	85b2                	mv	a1,a2
    80001208:	8526                	mv	a0,s1
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	f50080e7          	jalr	-176(ra) # 8000115a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001212:	4719                	li	a4,6
    80001214:	46c5                	li	a3,17
    80001216:	06ee                	slli	a3,a3,0x1b
    80001218:	412686b3          	sub	a3,a3,s2
    8000121c:	864a                	mv	a2,s2
    8000121e:	85ca                	mv	a1,s2
    80001220:	8526                	mv	a0,s1
    80001222:	00000097          	auipc	ra,0x0
    80001226:	f38080e7          	jalr	-200(ra) # 8000115a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000122a:	4729                	li	a4,10
    8000122c:	6685                	lui	a3,0x1
    8000122e:	00006617          	auipc	a2,0x6
    80001232:	dd260613          	addi	a2,a2,-558 # 80007000 <_trampoline>
    80001236:	040005b7          	lui	a1,0x4000
    8000123a:	15fd                	addi	a1,a1,-1
    8000123c:	05b2                	slli	a1,a1,0xc
    8000123e:	8526                	mv	a0,s1
    80001240:	00000097          	auipc	ra,0x0
    80001244:	f1a080e7          	jalr	-230(ra) # 8000115a <kvmmap>
  proc_mapstacks(kpgtbl);
    80001248:	8526                	mv	a0,s1
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	61c080e7          	jalr	1564(ra) # 80001866 <proc_mapstacks>
}
    80001252:	8526                	mv	a0,s1
    80001254:	60e2                	ld	ra,24(sp)
    80001256:	6442                	ld	s0,16(sp)
    80001258:	64a2                	ld	s1,8(sp)
    8000125a:	6902                	ld	s2,0(sp)
    8000125c:	6105                	addi	sp,sp,32
    8000125e:	8082                	ret

0000000080001260 <kvminit>:
{
    80001260:	1141                	addi	sp,sp,-16
    80001262:	e406                	sd	ra,8(sp)
    80001264:	e022                	sd	s0,0(sp)
    80001266:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	f22080e7          	jalr	-222(ra) # 8000118a <kvmmake>
    80001270:	00007797          	auipc	a5,0x7
    80001274:	72a7b023          	sd	a0,1824(a5) # 80008990 <kernel_pagetable>
}
    80001278:	60a2                	ld	ra,8(sp)
    8000127a:	6402                	ld	s0,0(sp)
    8000127c:	0141                	addi	sp,sp,16
    8000127e:	8082                	ret

0000000080001280 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001280:	715d                	addi	sp,sp,-80
    80001282:	e486                	sd	ra,72(sp)
    80001284:	e0a2                	sd	s0,64(sp)
    80001286:	fc26                	sd	s1,56(sp)
    80001288:	f84a                	sd	s2,48(sp)
    8000128a:	f44e                	sd	s3,40(sp)
    8000128c:	f052                	sd	s4,32(sp)
    8000128e:	ec56                	sd	s5,24(sp)
    80001290:	e85a                	sd	s6,16(sp)
    80001292:	e45e                	sd	s7,8(sp)
    80001294:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001296:	03459793          	slli	a5,a1,0x34
    8000129a:	e795                	bnez	a5,800012c6 <uvmunmap+0x46>
    8000129c:	8a2a                	mv	s4,a0
    8000129e:	892e                	mv	s2,a1
    800012a0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012a2:	0632                	slli	a2,a2,0xc
    800012a4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012a8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012aa:	6b05                	lui	s6,0x1
    800012ac:	0735e863          	bltu	a1,s3,8000131c <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800012b0:	60a6                	ld	ra,72(sp)
    800012b2:	6406                	ld	s0,64(sp)
    800012b4:	74e2                	ld	s1,56(sp)
    800012b6:	7942                	ld	s2,48(sp)
    800012b8:	79a2                	ld	s3,40(sp)
    800012ba:	7a02                	ld	s4,32(sp)
    800012bc:	6ae2                	ld	s5,24(sp)
    800012be:	6b42                	ld	s6,16(sp)
    800012c0:	6ba2                	ld	s7,8(sp)
    800012c2:	6161                	addi	sp,sp,80
    800012c4:	8082                	ret
    panic("uvmunmap: not aligned");
    800012c6:	00007517          	auipc	a0,0x7
    800012ca:	e3a50513          	addi	a0,a0,-454 # 80008100 <digits+0xc0>
    800012ce:	fffff097          	auipc	ra,0xfffff
    800012d2:	276080e7          	jalr	630(ra) # 80000544 <panic>
      panic("uvmunmap: walk");
    800012d6:	00007517          	auipc	a0,0x7
    800012da:	e4250513          	addi	a0,a0,-446 # 80008118 <digits+0xd8>
    800012de:	fffff097          	auipc	ra,0xfffff
    800012e2:	266080e7          	jalr	614(ra) # 80000544 <panic>
      panic("uvmunmap: not mapped");
    800012e6:	00007517          	auipc	a0,0x7
    800012ea:	e4250513          	addi	a0,a0,-446 # 80008128 <digits+0xe8>
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	256080e7          	jalr	598(ra) # 80000544 <panic>
      panic("uvmunmap: not a leaf");
    800012f6:	00007517          	auipc	a0,0x7
    800012fa:	e4a50513          	addi	a0,a0,-438 # 80008140 <digits+0x100>
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	246080e7          	jalr	582(ra) # 80000544 <panic>
      uint64 pa = PTE2PA(*pte);
    80001306:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001308:	0532                	slli	a0,a0,0xc
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	6f4080e7          	jalr	1780(ra) # 800009fe <kfree>
    *pte = 0;
    80001312:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001316:	995a                	add	s2,s2,s6
    80001318:	f9397ce3          	bgeu	s2,s3,800012b0 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000131c:	4601                	li	a2,0
    8000131e:	85ca                	mv	a1,s2
    80001320:	8552                	mv	a0,s4
    80001322:	00000097          	auipc	ra,0x0
    80001326:	cb0080e7          	jalr	-848(ra) # 80000fd2 <walk>
    8000132a:	84aa                	mv	s1,a0
    8000132c:	d54d                	beqz	a0,800012d6 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000132e:	6108                	ld	a0,0(a0)
    80001330:	00157793          	andi	a5,a0,1
    80001334:	dbcd                	beqz	a5,800012e6 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001336:	3ff57793          	andi	a5,a0,1023
    8000133a:	fb778ee3          	beq	a5,s7,800012f6 <uvmunmap+0x76>
    if(do_free){
    8000133e:	fc0a8ae3          	beqz	s5,80001312 <uvmunmap+0x92>
    80001342:	b7d1                	j	80001306 <uvmunmap+0x86>

0000000080001344 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001344:	1101                	addi	sp,sp,-32
    80001346:	ec06                	sd	ra,24(sp)
    80001348:	e822                	sd	s0,16(sp)
    8000134a:	e426                	sd	s1,8(sp)
    8000134c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000134e:	fffff097          	auipc	ra,0xfffff
    80001352:	7ac080e7          	jalr	1964(ra) # 80000afa <kalloc>
    80001356:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001358:	c519                	beqz	a0,80001366 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000135a:	6605                	lui	a2,0x1
    8000135c:	4581                	li	a1,0
    8000135e:	00000097          	auipc	ra,0x0
    80001362:	988080e7          	jalr	-1656(ra) # 80000ce6 <memset>
  return pagetable;
}
    80001366:	8526                	mv	a0,s1
    80001368:	60e2                	ld	ra,24(sp)
    8000136a:	6442                	ld	s0,16(sp)
    8000136c:	64a2                	ld	s1,8(sp)
    8000136e:	6105                	addi	sp,sp,32
    80001370:	8082                	ret

0000000080001372 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001372:	7179                	addi	sp,sp,-48
    80001374:	f406                	sd	ra,40(sp)
    80001376:	f022                	sd	s0,32(sp)
    80001378:	ec26                	sd	s1,24(sp)
    8000137a:	e84a                	sd	s2,16(sp)
    8000137c:	e44e                	sd	s3,8(sp)
    8000137e:	e052                	sd	s4,0(sp)
    80001380:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001382:	6785                	lui	a5,0x1
    80001384:	04f67863          	bgeu	a2,a5,800013d4 <uvmfirst+0x62>
    80001388:	8a2a                	mv	s4,a0
    8000138a:	89ae                	mv	s3,a1
    8000138c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000138e:	fffff097          	auipc	ra,0xfffff
    80001392:	76c080e7          	jalr	1900(ra) # 80000afa <kalloc>
    80001396:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001398:	6605                	lui	a2,0x1
    8000139a:	4581                	li	a1,0
    8000139c:	00000097          	auipc	ra,0x0
    800013a0:	94a080e7          	jalr	-1718(ra) # 80000ce6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013a4:	4779                	li	a4,30
    800013a6:	86ca                	mv	a3,s2
    800013a8:	6605                	lui	a2,0x1
    800013aa:	4581                	li	a1,0
    800013ac:	8552                	mv	a0,s4
    800013ae:	00000097          	auipc	ra,0x0
    800013b2:	d0c080e7          	jalr	-756(ra) # 800010ba <mappages>
  memmove(mem, src, sz);
    800013b6:	8626                	mv	a2,s1
    800013b8:	85ce                	mv	a1,s3
    800013ba:	854a                	mv	a0,s2
    800013bc:	00000097          	auipc	ra,0x0
    800013c0:	98a080e7          	jalr	-1654(ra) # 80000d46 <memmove>
}
    800013c4:	70a2                	ld	ra,40(sp)
    800013c6:	7402                	ld	s0,32(sp)
    800013c8:	64e2                	ld	s1,24(sp)
    800013ca:	6942                	ld	s2,16(sp)
    800013cc:	69a2                	ld	s3,8(sp)
    800013ce:	6a02                	ld	s4,0(sp)
    800013d0:	6145                	addi	sp,sp,48
    800013d2:	8082                	ret
    panic("uvmfirst: more than a page");
    800013d4:	00007517          	auipc	a0,0x7
    800013d8:	d8450513          	addi	a0,a0,-636 # 80008158 <digits+0x118>
    800013dc:	fffff097          	auipc	ra,0xfffff
    800013e0:	168080e7          	jalr	360(ra) # 80000544 <panic>

00000000800013e4 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013e4:	1101                	addi	sp,sp,-32
    800013e6:	ec06                	sd	ra,24(sp)
    800013e8:	e822                	sd	s0,16(sp)
    800013ea:	e426                	sd	s1,8(sp)
    800013ec:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013ee:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013f0:	00b67d63          	bgeu	a2,a1,8000140a <uvmdealloc+0x26>
    800013f4:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013f6:	6785                	lui	a5,0x1
    800013f8:	17fd                	addi	a5,a5,-1
    800013fa:	00f60733          	add	a4,a2,a5
    800013fe:	767d                	lui	a2,0xfffff
    80001400:	8f71                	and	a4,a4,a2
    80001402:	97ae                	add	a5,a5,a1
    80001404:	8ff1                	and	a5,a5,a2
    80001406:	00f76863          	bltu	a4,a5,80001416 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000140a:	8526                	mv	a0,s1
    8000140c:	60e2                	ld	ra,24(sp)
    8000140e:	6442                	ld	s0,16(sp)
    80001410:	64a2                	ld	s1,8(sp)
    80001412:	6105                	addi	sp,sp,32
    80001414:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001416:	8f99                	sub	a5,a5,a4
    80001418:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000141a:	4685                	li	a3,1
    8000141c:	0007861b          	sext.w	a2,a5
    80001420:	85ba                	mv	a1,a4
    80001422:	00000097          	auipc	ra,0x0
    80001426:	e5e080e7          	jalr	-418(ra) # 80001280 <uvmunmap>
    8000142a:	b7c5                	j	8000140a <uvmdealloc+0x26>

000000008000142c <uvmalloc>:
  if(newsz < oldsz)
    8000142c:	0ab66563          	bltu	a2,a1,800014d6 <uvmalloc+0xaa>
{
    80001430:	7139                	addi	sp,sp,-64
    80001432:	fc06                	sd	ra,56(sp)
    80001434:	f822                	sd	s0,48(sp)
    80001436:	f426                	sd	s1,40(sp)
    80001438:	f04a                	sd	s2,32(sp)
    8000143a:	ec4e                	sd	s3,24(sp)
    8000143c:	e852                	sd	s4,16(sp)
    8000143e:	e456                	sd	s5,8(sp)
    80001440:	e05a                	sd	s6,0(sp)
    80001442:	0080                	addi	s0,sp,64
    80001444:	8aaa                	mv	s5,a0
    80001446:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001448:	6985                	lui	s3,0x1
    8000144a:	19fd                	addi	s3,s3,-1
    8000144c:	95ce                	add	a1,a1,s3
    8000144e:	79fd                	lui	s3,0xfffff
    80001450:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001454:	08c9f363          	bgeu	s3,a2,800014da <uvmalloc+0xae>
    80001458:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000145a:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    8000145e:	fffff097          	auipc	ra,0xfffff
    80001462:	69c080e7          	jalr	1692(ra) # 80000afa <kalloc>
    80001466:	84aa                	mv	s1,a0
    if(mem == 0){
    80001468:	c51d                	beqz	a0,80001496 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000146a:	6605                	lui	a2,0x1
    8000146c:	4581                	li	a1,0
    8000146e:	00000097          	auipc	ra,0x0
    80001472:	878080e7          	jalr	-1928(ra) # 80000ce6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001476:	875a                	mv	a4,s6
    80001478:	86a6                	mv	a3,s1
    8000147a:	6605                	lui	a2,0x1
    8000147c:	85ca                	mv	a1,s2
    8000147e:	8556                	mv	a0,s5
    80001480:	00000097          	auipc	ra,0x0
    80001484:	c3a080e7          	jalr	-966(ra) # 800010ba <mappages>
    80001488:	e90d                	bnez	a0,800014ba <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000148a:	6785                	lui	a5,0x1
    8000148c:	993e                	add	s2,s2,a5
    8000148e:	fd4968e3          	bltu	s2,s4,8000145e <uvmalloc+0x32>
  return newsz;
    80001492:	8552                	mv	a0,s4
    80001494:	a809                	j	800014a6 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80001496:	864e                	mv	a2,s3
    80001498:	85ca                	mv	a1,s2
    8000149a:	8556                	mv	a0,s5
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	f48080e7          	jalr	-184(ra) # 800013e4 <uvmdealloc>
      return 0;
    800014a4:	4501                	li	a0,0
}
    800014a6:	70e2                	ld	ra,56(sp)
    800014a8:	7442                	ld	s0,48(sp)
    800014aa:	74a2                	ld	s1,40(sp)
    800014ac:	7902                	ld	s2,32(sp)
    800014ae:	69e2                	ld	s3,24(sp)
    800014b0:	6a42                	ld	s4,16(sp)
    800014b2:	6aa2                	ld	s5,8(sp)
    800014b4:	6b02                	ld	s6,0(sp)
    800014b6:	6121                	addi	sp,sp,64
    800014b8:	8082                	ret
      kfree(mem);
    800014ba:	8526                	mv	a0,s1
    800014bc:	fffff097          	auipc	ra,0xfffff
    800014c0:	542080e7          	jalr	1346(ra) # 800009fe <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014c4:	864e                	mv	a2,s3
    800014c6:	85ca                	mv	a1,s2
    800014c8:	8556                	mv	a0,s5
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	f1a080e7          	jalr	-230(ra) # 800013e4 <uvmdealloc>
      return 0;
    800014d2:	4501                	li	a0,0
    800014d4:	bfc9                	j	800014a6 <uvmalloc+0x7a>
    return oldsz;
    800014d6:	852e                	mv	a0,a1
}
    800014d8:	8082                	ret
  return newsz;
    800014da:	8532                	mv	a0,a2
    800014dc:	b7e9                	j	800014a6 <uvmalloc+0x7a>

00000000800014de <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014de:	7179                	addi	sp,sp,-48
    800014e0:	f406                	sd	ra,40(sp)
    800014e2:	f022                	sd	s0,32(sp)
    800014e4:	ec26                	sd	s1,24(sp)
    800014e6:	e84a                	sd	s2,16(sp)
    800014e8:	e44e                	sd	s3,8(sp)
    800014ea:	e052                	sd	s4,0(sp)
    800014ec:	1800                	addi	s0,sp,48
    800014ee:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014f0:	84aa                	mv	s1,a0
    800014f2:	6905                	lui	s2,0x1
    800014f4:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014f6:	4985                	li	s3,1
    800014f8:	a821                	j	80001510 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014fa:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014fc:	0532                	slli	a0,a0,0xc
    800014fe:	00000097          	auipc	ra,0x0
    80001502:	fe0080e7          	jalr	-32(ra) # 800014de <freewalk>
      pagetable[i] = 0;
    80001506:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000150a:	04a1                	addi	s1,s1,8
    8000150c:	03248163          	beq	s1,s2,8000152e <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001510:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001512:	00f57793          	andi	a5,a0,15
    80001516:	ff3782e3          	beq	a5,s3,800014fa <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000151a:	8905                	andi	a0,a0,1
    8000151c:	d57d                	beqz	a0,8000150a <freewalk+0x2c>
      panic("freewalk: leaf");
    8000151e:	00007517          	auipc	a0,0x7
    80001522:	c5a50513          	addi	a0,a0,-934 # 80008178 <digits+0x138>
    80001526:	fffff097          	auipc	ra,0xfffff
    8000152a:	01e080e7          	jalr	30(ra) # 80000544 <panic>
    }
  }
  kfree((void*)pagetable);
    8000152e:	8552                	mv	a0,s4
    80001530:	fffff097          	auipc	ra,0xfffff
    80001534:	4ce080e7          	jalr	1230(ra) # 800009fe <kfree>
}
    80001538:	70a2                	ld	ra,40(sp)
    8000153a:	7402                	ld	s0,32(sp)
    8000153c:	64e2                	ld	s1,24(sp)
    8000153e:	6942                	ld	s2,16(sp)
    80001540:	69a2                	ld	s3,8(sp)
    80001542:	6a02                	ld	s4,0(sp)
    80001544:	6145                	addi	sp,sp,48
    80001546:	8082                	ret

0000000080001548 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001548:	1101                	addi	sp,sp,-32
    8000154a:	ec06                	sd	ra,24(sp)
    8000154c:	e822                	sd	s0,16(sp)
    8000154e:	e426                	sd	s1,8(sp)
    80001550:	1000                	addi	s0,sp,32
    80001552:	84aa                	mv	s1,a0
  if(sz > 0)
    80001554:	e999                	bnez	a1,8000156a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001556:	8526                	mv	a0,s1
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	f86080e7          	jalr	-122(ra) # 800014de <freewalk>
}
    80001560:	60e2                	ld	ra,24(sp)
    80001562:	6442                	ld	s0,16(sp)
    80001564:	64a2                	ld	s1,8(sp)
    80001566:	6105                	addi	sp,sp,32
    80001568:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000156a:	6605                	lui	a2,0x1
    8000156c:	167d                	addi	a2,a2,-1
    8000156e:	962e                	add	a2,a2,a1
    80001570:	4685                	li	a3,1
    80001572:	8231                	srli	a2,a2,0xc
    80001574:	4581                	li	a1,0
    80001576:	00000097          	auipc	ra,0x0
    8000157a:	d0a080e7          	jalr	-758(ra) # 80001280 <uvmunmap>
    8000157e:	bfe1                	j	80001556 <uvmfree+0xe>

0000000080001580 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001580:	c679                	beqz	a2,8000164e <uvmcopy+0xce>
{
    80001582:	715d                	addi	sp,sp,-80
    80001584:	e486                	sd	ra,72(sp)
    80001586:	e0a2                	sd	s0,64(sp)
    80001588:	fc26                	sd	s1,56(sp)
    8000158a:	f84a                	sd	s2,48(sp)
    8000158c:	f44e                	sd	s3,40(sp)
    8000158e:	f052                	sd	s4,32(sp)
    80001590:	ec56                	sd	s5,24(sp)
    80001592:	e85a                	sd	s6,16(sp)
    80001594:	e45e                	sd	s7,8(sp)
    80001596:	0880                	addi	s0,sp,80
    80001598:	8b2a                	mv	s6,a0
    8000159a:	8aae                	mv	s5,a1
    8000159c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000159e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015a0:	4601                	li	a2,0
    800015a2:	85ce                	mv	a1,s3
    800015a4:	855a                	mv	a0,s6
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	a2c080e7          	jalr	-1492(ra) # 80000fd2 <walk>
    800015ae:	c531                	beqz	a0,800015fa <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015b0:	6118                	ld	a4,0(a0)
    800015b2:	00177793          	andi	a5,a4,1
    800015b6:	cbb1                	beqz	a5,8000160a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800015b8:	00a75593          	srli	a1,a4,0xa
    800015bc:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800015c0:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800015c4:	fffff097          	auipc	ra,0xfffff
    800015c8:	536080e7          	jalr	1334(ra) # 80000afa <kalloc>
    800015cc:	892a                	mv	s2,a0
    800015ce:	c939                	beqz	a0,80001624 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800015d0:	6605                	lui	a2,0x1
    800015d2:	85de                	mv	a1,s7
    800015d4:	fffff097          	auipc	ra,0xfffff
    800015d8:	772080e7          	jalr	1906(ra) # 80000d46 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800015dc:	8726                	mv	a4,s1
    800015de:	86ca                	mv	a3,s2
    800015e0:	6605                	lui	a2,0x1
    800015e2:	85ce                	mv	a1,s3
    800015e4:	8556                	mv	a0,s5
    800015e6:	00000097          	auipc	ra,0x0
    800015ea:	ad4080e7          	jalr	-1324(ra) # 800010ba <mappages>
    800015ee:	e515                	bnez	a0,8000161a <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015f0:	6785                	lui	a5,0x1
    800015f2:	99be                	add	s3,s3,a5
    800015f4:	fb49e6e3          	bltu	s3,s4,800015a0 <uvmcopy+0x20>
    800015f8:	a081                	j	80001638 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015fa:	00007517          	auipc	a0,0x7
    800015fe:	b8e50513          	addi	a0,a0,-1138 # 80008188 <digits+0x148>
    80001602:	fffff097          	auipc	ra,0xfffff
    80001606:	f42080e7          	jalr	-190(ra) # 80000544 <panic>
      panic("uvmcopy: page not present");
    8000160a:	00007517          	auipc	a0,0x7
    8000160e:	b9e50513          	addi	a0,a0,-1122 # 800081a8 <digits+0x168>
    80001612:	fffff097          	auipc	ra,0xfffff
    80001616:	f32080e7          	jalr	-206(ra) # 80000544 <panic>
      kfree(mem);
    8000161a:	854a                	mv	a0,s2
    8000161c:	fffff097          	auipc	ra,0xfffff
    80001620:	3e2080e7          	jalr	994(ra) # 800009fe <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001624:	4685                	li	a3,1
    80001626:	00c9d613          	srli	a2,s3,0xc
    8000162a:	4581                	li	a1,0
    8000162c:	8556                	mv	a0,s5
    8000162e:	00000097          	auipc	ra,0x0
    80001632:	c52080e7          	jalr	-942(ra) # 80001280 <uvmunmap>
  return -1;
    80001636:	557d                	li	a0,-1
}
    80001638:	60a6                	ld	ra,72(sp)
    8000163a:	6406                	ld	s0,64(sp)
    8000163c:	74e2                	ld	s1,56(sp)
    8000163e:	7942                	ld	s2,48(sp)
    80001640:	79a2                	ld	s3,40(sp)
    80001642:	7a02                	ld	s4,32(sp)
    80001644:	6ae2                	ld	s5,24(sp)
    80001646:	6b42                	ld	s6,16(sp)
    80001648:	6ba2                	ld	s7,8(sp)
    8000164a:	6161                	addi	sp,sp,80
    8000164c:	8082                	ret
  return 0;
    8000164e:	4501                	li	a0,0
}
    80001650:	8082                	ret

0000000080001652 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001652:	1141                	addi	sp,sp,-16
    80001654:	e406                	sd	ra,8(sp)
    80001656:	e022                	sd	s0,0(sp)
    80001658:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000165a:	4601                	li	a2,0
    8000165c:	00000097          	auipc	ra,0x0
    80001660:	976080e7          	jalr	-1674(ra) # 80000fd2 <walk>
  if(pte == 0)
    80001664:	c901                	beqz	a0,80001674 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001666:	611c                	ld	a5,0(a0)
    80001668:	9bbd                	andi	a5,a5,-17
    8000166a:	e11c                	sd	a5,0(a0)
}
    8000166c:	60a2                	ld	ra,8(sp)
    8000166e:	6402                	ld	s0,0(sp)
    80001670:	0141                	addi	sp,sp,16
    80001672:	8082                	ret
    panic("uvmclear");
    80001674:	00007517          	auipc	a0,0x7
    80001678:	b5450513          	addi	a0,a0,-1196 # 800081c8 <digits+0x188>
    8000167c:	fffff097          	auipc	ra,0xfffff
    80001680:	ec8080e7          	jalr	-312(ra) # 80000544 <panic>

0000000080001684 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001684:	c6bd                	beqz	a3,800016f2 <copyout+0x6e>
{
    80001686:	715d                	addi	sp,sp,-80
    80001688:	e486                	sd	ra,72(sp)
    8000168a:	e0a2                	sd	s0,64(sp)
    8000168c:	fc26                	sd	s1,56(sp)
    8000168e:	f84a                	sd	s2,48(sp)
    80001690:	f44e                	sd	s3,40(sp)
    80001692:	f052                	sd	s4,32(sp)
    80001694:	ec56                	sd	s5,24(sp)
    80001696:	e85a                	sd	s6,16(sp)
    80001698:	e45e                	sd	s7,8(sp)
    8000169a:	e062                	sd	s8,0(sp)
    8000169c:	0880                	addi	s0,sp,80
    8000169e:	8b2a                	mv	s6,a0
    800016a0:	8c2e                	mv	s8,a1
    800016a2:	8a32                	mv	s4,a2
    800016a4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016a6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016a8:	6a85                	lui	s5,0x1
    800016aa:	a015                	j	800016ce <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016ac:	9562                	add	a0,a0,s8
    800016ae:	0004861b          	sext.w	a2,s1
    800016b2:	85d2                	mv	a1,s4
    800016b4:	41250533          	sub	a0,a0,s2
    800016b8:	fffff097          	auipc	ra,0xfffff
    800016bc:	68e080e7          	jalr	1678(ra) # 80000d46 <memmove>

    len -= n;
    800016c0:	409989b3          	sub	s3,s3,s1
    src += n;
    800016c4:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800016c6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016ca:	02098263          	beqz	s3,800016ee <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800016ce:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016d2:	85ca                	mv	a1,s2
    800016d4:	855a                	mv	a0,s6
    800016d6:	00000097          	auipc	ra,0x0
    800016da:	9a2080e7          	jalr	-1630(ra) # 80001078 <walkaddr>
    if(pa0 == 0)
    800016de:	cd01                	beqz	a0,800016f6 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800016e0:	418904b3          	sub	s1,s2,s8
    800016e4:	94d6                	add	s1,s1,s5
    if(n > len)
    800016e6:	fc99f3e3          	bgeu	s3,s1,800016ac <copyout+0x28>
    800016ea:	84ce                	mv	s1,s3
    800016ec:	b7c1                	j	800016ac <copyout+0x28>
  }
  return 0;
    800016ee:	4501                	li	a0,0
    800016f0:	a021                	j	800016f8 <copyout+0x74>
    800016f2:	4501                	li	a0,0
}
    800016f4:	8082                	ret
      return -1;
    800016f6:	557d                	li	a0,-1
}
    800016f8:	60a6                	ld	ra,72(sp)
    800016fa:	6406                	ld	s0,64(sp)
    800016fc:	74e2                	ld	s1,56(sp)
    800016fe:	7942                	ld	s2,48(sp)
    80001700:	79a2                	ld	s3,40(sp)
    80001702:	7a02                	ld	s4,32(sp)
    80001704:	6ae2                	ld	s5,24(sp)
    80001706:	6b42                	ld	s6,16(sp)
    80001708:	6ba2                	ld	s7,8(sp)
    8000170a:	6c02                	ld	s8,0(sp)
    8000170c:	6161                	addi	sp,sp,80
    8000170e:	8082                	ret

0000000080001710 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001710:	c6bd                	beqz	a3,8000177e <copyin+0x6e>
{
    80001712:	715d                	addi	sp,sp,-80
    80001714:	e486                	sd	ra,72(sp)
    80001716:	e0a2                	sd	s0,64(sp)
    80001718:	fc26                	sd	s1,56(sp)
    8000171a:	f84a                	sd	s2,48(sp)
    8000171c:	f44e                	sd	s3,40(sp)
    8000171e:	f052                	sd	s4,32(sp)
    80001720:	ec56                	sd	s5,24(sp)
    80001722:	e85a                	sd	s6,16(sp)
    80001724:	e45e                	sd	s7,8(sp)
    80001726:	e062                	sd	s8,0(sp)
    80001728:	0880                	addi	s0,sp,80
    8000172a:	8b2a                	mv	s6,a0
    8000172c:	8a2e                	mv	s4,a1
    8000172e:	8c32                	mv	s8,a2
    80001730:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001732:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001734:	6a85                	lui	s5,0x1
    80001736:	a015                	j	8000175a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001738:	9562                	add	a0,a0,s8
    8000173a:	0004861b          	sext.w	a2,s1
    8000173e:	412505b3          	sub	a1,a0,s2
    80001742:	8552                	mv	a0,s4
    80001744:	fffff097          	auipc	ra,0xfffff
    80001748:	602080e7          	jalr	1538(ra) # 80000d46 <memmove>

    len -= n;
    8000174c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001750:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001752:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001756:	02098263          	beqz	s3,8000177a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    8000175a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000175e:	85ca                	mv	a1,s2
    80001760:	855a                	mv	a0,s6
    80001762:	00000097          	auipc	ra,0x0
    80001766:	916080e7          	jalr	-1770(ra) # 80001078 <walkaddr>
    if(pa0 == 0)
    8000176a:	cd01                	beqz	a0,80001782 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    8000176c:	418904b3          	sub	s1,s2,s8
    80001770:	94d6                	add	s1,s1,s5
    if(n > len)
    80001772:	fc99f3e3          	bgeu	s3,s1,80001738 <copyin+0x28>
    80001776:	84ce                	mv	s1,s3
    80001778:	b7c1                	j	80001738 <copyin+0x28>
  }
  return 0;
    8000177a:	4501                	li	a0,0
    8000177c:	a021                	j	80001784 <copyin+0x74>
    8000177e:	4501                	li	a0,0
}
    80001780:	8082                	ret
      return -1;
    80001782:	557d                	li	a0,-1
}
    80001784:	60a6                	ld	ra,72(sp)
    80001786:	6406                	ld	s0,64(sp)
    80001788:	74e2                	ld	s1,56(sp)
    8000178a:	7942                	ld	s2,48(sp)
    8000178c:	79a2                	ld	s3,40(sp)
    8000178e:	7a02                	ld	s4,32(sp)
    80001790:	6ae2                	ld	s5,24(sp)
    80001792:	6b42                	ld	s6,16(sp)
    80001794:	6ba2                	ld	s7,8(sp)
    80001796:	6c02                	ld	s8,0(sp)
    80001798:	6161                	addi	sp,sp,80
    8000179a:	8082                	ret

000000008000179c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000179c:	c6c5                	beqz	a3,80001844 <copyinstr+0xa8>
{
    8000179e:	715d                	addi	sp,sp,-80
    800017a0:	e486                	sd	ra,72(sp)
    800017a2:	e0a2                	sd	s0,64(sp)
    800017a4:	fc26                	sd	s1,56(sp)
    800017a6:	f84a                	sd	s2,48(sp)
    800017a8:	f44e                	sd	s3,40(sp)
    800017aa:	f052                	sd	s4,32(sp)
    800017ac:	ec56                	sd	s5,24(sp)
    800017ae:	e85a                	sd	s6,16(sp)
    800017b0:	e45e                	sd	s7,8(sp)
    800017b2:	0880                	addi	s0,sp,80
    800017b4:	8a2a                	mv	s4,a0
    800017b6:	8b2e                	mv	s6,a1
    800017b8:	8bb2                	mv	s7,a2
    800017ba:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    800017bc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017be:	6985                	lui	s3,0x1
    800017c0:	a035                	j	800017ec <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800017c2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017c6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800017c8:	0017b793          	seqz	a5,a5
    800017cc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800017d0:	60a6                	ld	ra,72(sp)
    800017d2:	6406                	ld	s0,64(sp)
    800017d4:	74e2                	ld	s1,56(sp)
    800017d6:	7942                	ld	s2,48(sp)
    800017d8:	79a2                	ld	s3,40(sp)
    800017da:	7a02                	ld	s4,32(sp)
    800017dc:	6ae2                	ld	s5,24(sp)
    800017de:	6b42                	ld	s6,16(sp)
    800017e0:	6ba2                	ld	s7,8(sp)
    800017e2:	6161                	addi	sp,sp,80
    800017e4:	8082                	ret
    srcva = va0 + PGSIZE;
    800017e6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017ea:	c8a9                	beqz	s1,8000183c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017ec:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017f0:	85ca                	mv	a1,s2
    800017f2:	8552                	mv	a0,s4
    800017f4:	00000097          	auipc	ra,0x0
    800017f8:	884080e7          	jalr	-1916(ra) # 80001078 <walkaddr>
    if(pa0 == 0)
    800017fc:	c131                	beqz	a0,80001840 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017fe:	41790833          	sub	a6,s2,s7
    80001802:	984e                	add	a6,a6,s3
    if(n > max)
    80001804:	0104f363          	bgeu	s1,a6,8000180a <copyinstr+0x6e>
    80001808:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    8000180a:	955e                	add	a0,a0,s7
    8000180c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001810:	fc080be3          	beqz	a6,800017e6 <copyinstr+0x4a>
    80001814:	985a                	add	a6,a6,s6
    80001816:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001818:	41650633          	sub	a2,a0,s6
    8000181c:	14fd                	addi	s1,s1,-1
    8000181e:	9b26                	add	s6,s6,s1
    80001820:	00f60733          	add	a4,a2,a5
    80001824:	00074703          	lbu	a4,0(a4)
    80001828:	df49                	beqz	a4,800017c2 <copyinstr+0x26>
        *dst = *p;
    8000182a:	00e78023          	sb	a4,0(a5)
      --max;
    8000182e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001832:	0785                	addi	a5,a5,1
    while(n > 0){
    80001834:	ff0796e3          	bne	a5,a6,80001820 <copyinstr+0x84>
      dst++;
    80001838:	8b42                	mv	s6,a6
    8000183a:	b775                	j	800017e6 <copyinstr+0x4a>
    8000183c:	4781                	li	a5,0
    8000183e:	b769                	j	800017c8 <copyinstr+0x2c>
      return -1;
    80001840:	557d                	li	a0,-1
    80001842:	b779                	j	800017d0 <copyinstr+0x34>
  int got_null = 0;
    80001844:	4781                	li	a5,0
  if(got_null){
    80001846:	0017b793          	seqz	a5,a5
    8000184a:	40f00533          	neg	a0,a5
}
    8000184e:	8082                	ret

0000000080001850 <set_policy>:
  my_p->cfs_priority = prior; 
  release(&my_p->lock);
}

//new code: 
int set_policy(int policy){
    80001850:	1141                	addi	sp,sp,-16
    80001852:	e422                	sd	s0,8(sp)
    80001854:	0800                	addi	s0,sp,16
  sched_policy = policy;
    80001856:	00007797          	auipc	a5,0x7
    8000185a:	0aa7a723          	sw	a0,174(a5) # 80008904 <sched_policy>
  return 0;
}
    8000185e:	4501                	li	a0,0
    80001860:	6422                	ld	s0,8(sp)
    80001862:	0141                	addi	sp,sp,16
    80001864:	8082                	ret

0000000080001866 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001866:	7139                	addi	sp,sp,-64
    80001868:	fc06                	sd	ra,56(sp)
    8000186a:	f822                	sd	s0,48(sp)
    8000186c:	f426                	sd	s1,40(sp)
    8000186e:	f04a                	sd	s2,32(sp)
    80001870:	ec4e                	sd	s3,24(sp)
    80001872:	e852                	sd	s4,16(sp)
    80001874:	e456                	sd	s5,8(sp)
    80001876:	e05a                	sd	s6,0(sp)
    80001878:	0080                	addi	s0,sp,64
    8000187a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187c:	0000f497          	auipc	s1,0xf
    80001880:	7c448493          	addi	s1,s1,1988 # 80011040 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001884:	8b26                	mv	s6,s1
    80001886:	00006a97          	auipc	s5,0x6
    8000188a:	77aa8a93          	addi	s5,s5,1914 # 80008000 <etext>
    8000188e:	04000937          	lui	s2,0x4000
    80001892:	197d                	addi	s2,s2,-1
    80001894:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001896:	00016a17          	auipc	s4,0x16
    8000189a:	1aaa0a13          	addi	s4,s4,426 # 80017a40 <tickslock>
    char *pa = kalloc();
    8000189e:	fffff097          	auipc	ra,0xfffff
    800018a2:	25c080e7          	jalr	604(ra) # 80000afa <kalloc>
    800018a6:	862a                	mv	a2,a0
    if(pa == 0)
    800018a8:	c131                	beqz	a0,800018ec <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    800018aa:	416485b3          	sub	a1,s1,s6
    800018ae:	858d                	srai	a1,a1,0x3
    800018b0:	000ab783          	ld	a5,0(s5)
    800018b4:	02f585b3          	mul	a1,a1,a5
    800018b8:	2585                	addiw	a1,a1,1
    800018ba:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800018be:	4719                	li	a4,6
    800018c0:	6685                	lui	a3,0x1
    800018c2:	40b905b3          	sub	a1,s2,a1
    800018c6:	854e                	mv	a0,s3
    800018c8:	00000097          	auipc	ra,0x0
    800018cc:	892080e7          	jalr	-1902(ra) # 8000115a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018d0:	1a848493          	addi	s1,s1,424
    800018d4:	fd4495e3          	bne	s1,s4,8000189e <proc_mapstacks+0x38>
  }
}
    800018d8:	70e2                	ld	ra,56(sp)
    800018da:	7442                	ld	s0,48(sp)
    800018dc:	74a2                	ld	s1,40(sp)
    800018de:	7902                	ld	s2,32(sp)
    800018e0:	69e2                	ld	s3,24(sp)
    800018e2:	6a42                	ld	s4,16(sp)
    800018e4:	6aa2                	ld	s5,8(sp)
    800018e6:	6b02                	ld	s6,0(sp)
    800018e8:	6121                	addi	sp,sp,64
    800018ea:	8082                	ret
      panic("kalloc");
    800018ec:	00007517          	auipc	a0,0x7
    800018f0:	8ec50513          	addi	a0,a0,-1812 # 800081d8 <digits+0x198>
    800018f4:	fffff097          	auipc	ra,0xfffff
    800018f8:	c50080e7          	jalr	-944(ra) # 80000544 <panic>

00000000800018fc <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800018fc:	7139                	addi	sp,sp,-64
    800018fe:	fc06                	sd	ra,56(sp)
    80001900:	f822                	sd	s0,48(sp)
    80001902:	f426                	sd	s1,40(sp)
    80001904:	f04a                	sd	s2,32(sp)
    80001906:	ec4e                	sd	s3,24(sp)
    80001908:	e852                	sd	s4,16(sp)
    8000190a:	e456                	sd	s5,8(sp)
    8000190c:	e05a                	sd	s6,0(sp)
    8000190e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001910:	00007597          	auipc	a1,0x7
    80001914:	8d058593          	addi	a1,a1,-1840 # 800081e0 <digits+0x1a0>
    80001918:	0000f517          	auipc	a0,0xf
    8000191c:	2f850513          	addi	a0,a0,760 # 80010c10 <pid_lock>
    80001920:	fffff097          	auipc	ra,0xfffff
    80001924:	23a080e7          	jalr	570(ra) # 80000b5a <initlock>
  initlock(&wait_lock, "wait_lock");
    80001928:	00007597          	auipc	a1,0x7
    8000192c:	8c058593          	addi	a1,a1,-1856 # 800081e8 <digits+0x1a8>
    80001930:	0000f517          	auipc	a0,0xf
    80001934:	2f850513          	addi	a0,a0,760 # 80010c28 <wait_lock>
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	222080e7          	jalr	546(ra) # 80000b5a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001940:	0000f497          	auipc	s1,0xf
    80001944:	70048493          	addi	s1,s1,1792 # 80011040 <proc>
      initlock(&p->lock, "proc");
    80001948:	00007b17          	auipc	s6,0x7
    8000194c:	8b0b0b13          	addi	s6,s6,-1872 # 800081f8 <digits+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001950:	8aa6                	mv	s5,s1
    80001952:	00006a17          	auipc	s4,0x6
    80001956:	6aea0a13          	addi	s4,s4,1710 # 80008000 <etext>
    8000195a:	04000937          	lui	s2,0x4000
    8000195e:	197d                	addi	s2,s2,-1
    80001960:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001962:	00016997          	auipc	s3,0x16
    80001966:	0de98993          	addi	s3,s3,222 # 80017a40 <tickslock>
      initlock(&p->lock, "proc");
    8000196a:	85da                	mv	a1,s6
    8000196c:	8526                	mv	a0,s1
    8000196e:	fffff097          	auipc	ra,0xfffff
    80001972:	1ec080e7          	jalr	492(ra) # 80000b5a <initlock>
      p->state = UNUSED;
    80001976:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000197a:	415487b3          	sub	a5,s1,s5
    8000197e:	878d                	srai	a5,a5,0x3
    80001980:	000a3703          	ld	a4,0(s4)
    80001984:	02e787b3          	mul	a5,a5,a4
    80001988:	2785                	addiw	a5,a5,1
    8000198a:	00d7979b          	slliw	a5,a5,0xd
    8000198e:	40f907b3          	sub	a5,s2,a5
    80001992:	e0dc                	sd	a5,128(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001994:	1a848493          	addi	s1,s1,424
    80001998:	fd3499e3          	bne	s1,s3,8000196a <procinit+0x6e>
  }
}
    8000199c:	70e2                	ld	ra,56(sp)
    8000199e:	7442                	ld	s0,48(sp)
    800019a0:	74a2                	ld	s1,40(sp)
    800019a2:	7902                	ld	s2,32(sp)
    800019a4:	69e2                	ld	s3,24(sp)
    800019a6:	6a42                	ld	s4,16(sp)
    800019a8:	6aa2                	ld	s5,8(sp)
    800019aa:	6b02                	ld	s6,0(sp)
    800019ac:	6121                	addi	sp,sp,64
    800019ae:	8082                	ret

00000000800019b0 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800019b0:	1141                	addi	sp,sp,-16
    800019b2:	e422                	sd	s0,8(sp)
    800019b4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019b6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800019b8:	2501                	sext.w	a0,a0
    800019ba:	6422                	ld	s0,8(sp)
    800019bc:	0141                	addi	sp,sp,16
    800019be:	8082                	ret

00000000800019c0 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800019c0:	1141                	addi	sp,sp,-16
    800019c2:	e422                	sd	s0,8(sp)
    800019c4:	0800                	addi	s0,sp,16
    800019c6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800019c8:	2781                	sext.w	a5,a5
    800019ca:	079e                	slli	a5,a5,0x7
  return c;
}
    800019cc:	0000f517          	auipc	a0,0xf
    800019d0:	27450513          	addi	a0,a0,628 # 80010c40 <cpus>
    800019d4:	953e                	add	a0,a0,a5
    800019d6:	6422                	ld	s0,8(sp)
    800019d8:	0141                	addi	sp,sp,16
    800019da:	8082                	ret

00000000800019dc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800019dc:	1101                	addi	sp,sp,-32
    800019de:	ec06                	sd	ra,24(sp)
    800019e0:	e822                	sd	s0,16(sp)
    800019e2:	e426                	sd	s1,8(sp)
    800019e4:	1000                	addi	s0,sp,32
  push_off();
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	1b8080e7          	jalr	440(ra) # 80000b9e <push_off>
    800019ee:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019f0:	2781                	sext.w	a5,a5
    800019f2:	079e                	slli	a5,a5,0x7
    800019f4:	0000f717          	auipc	a4,0xf
    800019f8:	21c70713          	addi	a4,a4,540 # 80010c10 <pid_lock>
    800019fc:	97ba                	add	a5,a5,a4
    800019fe:	7b84                	ld	s1,48(a5)
  pop_off();
    80001a00:	fffff097          	auipc	ra,0xfffff
    80001a04:	23e080e7          	jalr	574(ra) # 80000c3e <pop_off>
  return p;
}
    80001a08:	8526                	mv	a0,s1
    80001a0a:	60e2                	ld	ra,24(sp)
    80001a0c:	6442                	ld	s0,16(sp)
    80001a0e:	64a2                	ld	s1,8(sp)
    80001a10:	6105                	addi	sp,sp,32
    80001a12:	8082                	ret

0000000080001a14 <increment_tick>:
{
    80001a14:	7139                	addi	sp,sp,-64
    80001a16:	fc06                	sd	ra,56(sp)
    80001a18:	f822                	sd	s0,48(sp)
    80001a1a:	f426                	sd	s1,40(sp)
    80001a1c:	f04a                	sd	s2,32(sp)
    80001a1e:	ec4e                	sd	s3,24(sp)
    80001a20:	e852                	sd	s4,16(sp)
    80001a22:	e456                	sd	s5,8(sp)
    80001a24:	0080                	addi	s0,sp,64
  for(my_p = proc; my_p < &proc[NPROC]; my_p++) {
    80001a26:	0000f497          	auipc	s1,0xf
    80001a2a:	61a48493          	addi	s1,s1,1562 # 80011040 <proc>
      switch (my_p->state)
    80001a2e:	4a8d                	li	s5,3
    80001a30:	4a11                	li	s4,4
    80001a32:	4989                	li	s3,2
  for(my_p = proc; my_p < &proc[NPROC]; my_p++) {
    80001a34:	00016917          	auipc	s2,0x16
    80001a38:	00c90913          	addi	s2,s2,12 # 80017a40 <tickslock>
    80001a3c:	a829                	j	80001a56 <increment_tick+0x42>
          my_p->rtime++;
    80001a3e:	54bc                	lw	a5,104(s1)
    80001a40:	2785                	addiw	a5,a5,1
    80001a42:	d4bc                	sw	a5,104(s1)
      release(&my_p->lock);}
    80001a44:	8526                	mv	a0,s1
    80001a46:	fffff097          	auipc	ra,0xfffff
    80001a4a:	258080e7          	jalr	600(ra) # 80000c9e <release>
  for(my_p = proc; my_p < &proc[NPROC]; my_p++) {
    80001a4e:	1a848493          	addi	s1,s1,424
    80001a52:	03248c63          	beq	s1,s2,80001a8a <increment_tick+0x76>
    if(my_p != myproc()){
    80001a56:	00000097          	auipc	ra,0x0
    80001a5a:	f86080e7          	jalr	-122(ra) # 800019dc <myproc>
    80001a5e:	fea488e3          	beq	s1,a0,80001a4e <increment_tick+0x3a>
      acquire(&my_p->lock);
    80001a62:	8526                	mv	a0,s1
    80001a64:	fffff097          	auipc	ra,0xfffff
    80001a68:	186080e7          	jalr	390(ra) # 80000bea <acquire>
      switch (my_p->state)
    80001a6c:	4c9c                	lw	a5,24(s1)
    80001a6e:	01578a63          	beq	a5,s5,80001a82 <increment_tick+0x6e>
    80001a72:	fd4786e3          	beq	a5,s4,80001a3e <increment_tick+0x2a>
    80001a76:	fd3797e3          	bne	a5,s3,80001a44 <increment_tick+0x30>
          my_p->stime++;
    80001a7a:	54fc                	lw	a5,108(s1)
    80001a7c:	2785                	addiw	a5,a5,1
    80001a7e:	d4fc                	sw	a5,108(s1)
            break;
    80001a80:	b7d1                	j	80001a44 <increment_tick+0x30>
          my_p->retime++;
    80001a82:	58bc                	lw	a5,112(s1)
    80001a84:	2785                	addiw	a5,a5,1
    80001a86:	d8bc                	sw	a5,112(s1)
            break;
    80001a88:	bf75                	j	80001a44 <increment_tick+0x30>
  }
    80001a8a:	70e2                	ld	ra,56(sp)
    80001a8c:	7442                	ld	s0,48(sp)
    80001a8e:	74a2                	ld	s1,40(sp)
    80001a90:	7902                	ld	s2,32(sp)
    80001a92:	69e2                	ld	s3,24(sp)
    80001a94:	6a42                	ld	s4,16(sp)
    80001a96:	6aa2                	ld	s5,8(sp)
    80001a98:	6121                	addi	sp,sp,64
    80001a9a:	8082                	ret

0000000080001a9c <get_cfs_stats>:
int get_cfs_stats(int pid, int* arr){
    80001a9c:	7179                	addi	sp,sp,-48
    80001a9e:	f406                	sd	ra,40(sp)
    80001aa0:	f022                	sd	s0,32(sp)
    80001aa2:	ec26                	sd	s1,24(sp)
    80001aa4:	e84a                	sd	s2,16(sp)
    80001aa6:	1800                	addi	s0,sp,48
    80001aa8:	84aa                	mv	s1,a0
    80001aaa:	892e                	mv	s2,a1
  for(p = proc; p < &proc[NPROC] && !(found); p++){
    80001aac:	0000f797          	auipc	a5,0xf
    80001ab0:	59478793          	addi	a5,a5,1428 # 80011040 <proc>
    80001ab4:	00016697          	auipc	a3,0x16
    80001ab8:	f8c68693          	addi	a3,a3,-116 # 80017a40 <tickslock>
    if(p->pid == pid){
    80001abc:	5b98                	lw	a4,48(a5)
    80001abe:	00970a63          	beq	a4,s1,80001ad2 <get_cfs_stats+0x36>
  for(p = proc; p < &proc[NPROC] && !(found); p++){
    80001ac2:	1a878793          	addi	a5,a5,424
    80001ac6:	fed79be3          	bne	a5,a3,80001abc <get_cfs_stats+0x20>
    return -1;
    80001aca:	557d                	li	a0,-1
    80001acc:	a085                	j	80001b2c <get_cfs_stats+0x90>
    return -1;
    80001ace:	557d                	li	a0,-1
    80001ad0:	a8b1                	j	80001b2c <get_cfs_stats+0x90>
  array[0] = p->cfs_priority;
    80001ad2:	53f8                	lw	a4,100(a5)
    80001ad4:	fce42823          	sw	a4,-48(s0)
  array[1] = p->rtime;
    80001ad8:	57b8                	lw	a4,104(a5)
    80001ada:	fce42a23          	sw	a4,-44(s0)
  array[2] = p->stime;
    80001ade:	57f8                	lw	a4,108(a5)
    80001ae0:	fce42c23          	sw	a4,-40(s0)
  array[3] = p->retime;    
    80001ae4:	5bbc                	lw	a5,112(a5)
    80001ae6:	fcf42e23          	sw	a5,-36(s0)
  if (copyout(myproc()->pagetable, (uint64)arr, (char*)&array, 4*sizeof(int)) < 0) {
    80001aea:	00000097          	auipc	ra,0x0
    80001aee:	ef2080e7          	jalr	-270(ra) # 800019dc <myproc>
    80001af2:	46c1                	li	a3,16
    80001af4:	fd040613          	addi	a2,s0,-48
    80001af8:	85ca                	mv	a1,s2
    80001afa:	6948                	ld	a0,144(a0)
    80001afc:	00000097          	auipc	ra,0x0
    80001b00:	b88080e7          	jalr	-1144(ra) # 80001684 <copyout>
    80001b04:	fc0545e3          	bltz	a0,80001ace <get_cfs_stats+0x32>
  printf("proc id: %d, proc cfs priority: %d, proc cfs rtime: %d, proc cfs stime: %d, proc cfs retime: %d\n",pid , array[0], array[1], array[2], array[3]);
    80001b08:	fdc42783          	lw	a5,-36(s0)
    80001b0c:	fd842703          	lw	a4,-40(s0)
    80001b10:	fd442683          	lw	a3,-44(s0)
    80001b14:	fd042603          	lw	a2,-48(s0)
    80001b18:	85a6                	mv	a1,s1
    80001b1a:	00006517          	auipc	a0,0x6
    80001b1e:	6e650513          	addi	a0,a0,1766 # 80008200 <digits+0x1c0>
    80001b22:	fffff097          	auipc	ra,0xfffff
    80001b26:	a6c080e7          	jalr	-1428(ra) # 8000058e <printf>
  return 0;
    80001b2a:	4501                	li	a0,0
}
    80001b2c:	70a2                	ld	ra,40(sp)
    80001b2e:	7402                	ld	s0,32(sp)
    80001b30:	64e2                	ld	s1,24(sp)
    80001b32:	6942                	ld	s2,16(sp)
    80001b34:	6145                	addi	sp,sp,48
    80001b36:	8082                	ret

0000000080001b38 <set_cfs_priority>:
void set_cfs_priority (int prior){
    80001b38:	1101                	addi	sp,sp,-32
    80001b3a:	ec06                	sd	ra,24(sp)
    80001b3c:	e822                	sd	s0,16(sp)
    80001b3e:	e426                	sd	s1,8(sp)
    80001b40:	e04a                	sd	s2,0(sp)
    80001b42:	1000                	addi	s0,sp,32
    80001b44:	892a                	mv	s2,a0
  struct proc* my_p = myproc(); 
    80001b46:	00000097          	auipc	ra,0x0
    80001b4a:	e96080e7          	jalr	-362(ra) # 800019dc <myproc>
    80001b4e:	84aa                	mv	s1,a0
  acquire(&my_p->lock);
    80001b50:	fffff097          	auipc	ra,0xfffff
    80001b54:	09a080e7          	jalr	154(ra) # 80000bea <acquire>
  my_p->cfs_priority = prior; 
    80001b58:	0724a223          	sw	s2,100(s1)
  release(&my_p->lock);
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	fffff097          	auipc	ra,0xfffff
    80001b62:	140080e7          	jalr	320(ra) # 80000c9e <release>
}
    80001b66:	60e2                	ld	ra,24(sp)
    80001b68:	6442                	ld	s0,16(sp)
    80001b6a:	64a2                	ld	s1,8(sp)
    80001b6c:	6902                	ld	s2,0(sp)
    80001b6e:	6105                	addi	sp,sp,32
    80001b70:	8082                	ret

0000000080001b72 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001b72:	1141                	addi	sp,sp,-16
    80001b74:	e406                	sd	ra,8(sp)
    80001b76:	e022                	sd	s0,0(sp)
    80001b78:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001b7a:	00000097          	auipc	ra,0x0
    80001b7e:	e62080e7          	jalr	-414(ra) # 800019dc <myproc>
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	11c080e7          	jalr	284(ra) # 80000c9e <release>

  if (first) {
    80001b8a:	00007797          	auipc	a5,0x7
    80001b8e:	d767a783          	lw	a5,-650(a5) # 80008900 <first.1773>
    80001b92:	eb89                	bnez	a5,80001ba4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001b94:	00001097          	auipc	ra,0x1
    80001b98:	fb0080e7          	jalr	-80(ra) # 80002b44 <usertrapret>
}
    80001b9c:	60a2                	ld	ra,8(sp)
    80001b9e:	6402                	ld	s0,0(sp)
    80001ba0:	0141                	addi	sp,sp,16
    80001ba2:	8082                	ret
    first = 0;
    80001ba4:	00007797          	auipc	a5,0x7
    80001ba8:	d407ae23          	sw	zero,-676(a5) # 80008900 <first.1773>
    fsinit(ROOTDEV);
    80001bac:	4505                	li	a0,1
    80001bae:	00002097          	auipc	ra,0x2
    80001bb2:	e74080e7          	jalr	-396(ra) # 80003a22 <fsinit>
    80001bb6:	bff9                	j	80001b94 <forkret+0x22>

0000000080001bb8 <allocpid>:
{
    80001bb8:	1101                	addi	sp,sp,-32
    80001bba:	ec06                	sd	ra,24(sp)
    80001bbc:	e822                	sd	s0,16(sp)
    80001bbe:	e426                	sd	s1,8(sp)
    80001bc0:	e04a                	sd	s2,0(sp)
    80001bc2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001bc4:	0000f917          	auipc	s2,0xf
    80001bc8:	04c90913          	addi	s2,s2,76 # 80010c10 <pid_lock>
    80001bcc:	854a                	mv	a0,s2
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	01c080e7          	jalr	28(ra) # 80000bea <acquire>
  pid = nextpid;
    80001bd6:	00007797          	auipc	a5,0x7
    80001bda:	d3278793          	addi	a5,a5,-718 # 80008908 <nextpid>
    80001bde:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001be0:	0014871b          	addiw	a4,s1,1
    80001be4:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001be6:	854a                	mv	a0,s2
    80001be8:	fffff097          	auipc	ra,0xfffff
    80001bec:	0b6080e7          	jalr	182(ra) # 80000c9e <release>
}
    80001bf0:	8526                	mv	a0,s1
    80001bf2:	60e2                	ld	ra,24(sp)
    80001bf4:	6442                	ld	s0,16(sp)
    80001bf6:	64a2                	ld	s1,8(sp)
    80001bf8:	6902                	ld	s2,0(sp)
    80001bfa:	6105                	addi	sp,sp,32
    80001bfc:	8082                	ret

0000000080001bfe <proc_pagetable>:
{
    80001bfe:	1101                	addi	sp,sp,-32
    80001c00:	ec06                	sd	ra,24(sp)
    80001c02:	e822                	sd	s0,16(sp)
    80001c04:	e426                	sd	s1,8(sp)
    80001c06:	e04a                	sd	s2,0(sp)
    80001c08:	1000                	addi	s0,sp,32
    80001c0a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001c0c:	fffff097          	auipc	ra,0xfffff
    80001c10:	738080e7          	jalr	1848(ra) # 80001344 <uvmcreate>
    80001c14:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001c16:	c121                	beqz	a0,80001c56 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001c18:	4729                	li	a4,10
    80001c1a:	00005697          	auipc	a3,0x5
    80001c1e:	3e668693          	addi	a3,a3,998 # 80007000 <_trampoline>
    80001c22:	6605                	lui	a2,0x1
    80001c24:	040005b7          	lui	a1,0x4000
    80001c28:	15fd                	addi	a1,a1,-1
    80001c2a:	05b2                	slli	a1,a1,0xc
    80001c2c:	fffff097          	auipc	ra,0xfffff
    80001c30:	48e080e7          	jalr	1166(ra) # 800010ba <mappages>
    80001c34:	02054863          	bltz	a0,80001c64 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c38:	4719                	li	a4,6
    80001c3a:	09893683          	ld	a3,152(s2)
    80001c3e:	6605                	lui	a2,0x1
    80001c40:	020005b7          	lui	a1,0x2000
    80001c44:	15fd                	addi	a1,a1,-1
    80001c46:	05b6                	slli	a1,a1,0xd
    80001c48:	8526                	mv	a0,s1
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	470080e7          	jalr	1136(ra) # 800010ba <mappages>
    80001c52:	02054163          	bltz	a0,80001c74 <proc_pagetable+0x76>
}
    80001c56:	8526                	mv	a0,s1
    80001c58:	60e2                	ld	ra,24(sp)
    80001c5a:	6442                	ld	s0,16(sp)
    80001c5c:	64a2                	ld	s1,8(sp)
    80001c5e:	6902                	ld	s2,0(sp)
    80001c60:	6105                	addi	sp,sp,32
    80001c62:	8082                	ret
    uvmfree(pagetable, 0);
    80001c64:	4581                	li	a1,0
    80001c66:	8526                	mv	a0,s1
    80001c68:	00000097          	auipc	ra,0x0
    80001c6c:	8e0080e7          	jalr	-1824(ra) # 80001548 <uvmfree>
    return 0;
    80001c70:	4481                	li	s1,0
    80001c72:	b7d5                	j	80001c56 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c74:	4681                	li	a3,0
    80001c76:	4605                	li	a2,1
    80001c78:	040005b7          	lui	a1,0x4000
    80001c7c:	15fd                	addi	a1,a1,-1
    80001c7e:	05b2                	slli	a1,a1,0xc
    80001c80:	8526                	mv	a0,s1
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	5fe080e7          	jalr	1534(ra) # 80001280 <uvmunmap>
    uvmfree(pagetable, 0);
    80001c8a:	4581                	li	a1,0
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	8ba080e7          	jalr	-1862(ra) # 80001548 <uvmfree>
    return 0;
    80001c96:	4481                	li	s1,0
    80001c98:	bf7d                	j	80001c56 <proc_pagetable+0x58>

0000000080001c9a <proc_freepagetable>:
{
    80001c9a:	1101                	addi	sp,sp,-32
    80001c9c:	ec06                	sd	ra,24(sp)
    80001c9e:	e822                	sd	s0,16(sp)
    80001ca0:	e426                	sd	s1,8(sp)
    80001ca2:	e04a                	sd	s2,0(sp)
    80001ca4:	1000                	addi	s0,sp,32
    80001ca6:	84aa                	mv	s1,a0
    80001ca8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001caa:	4681                	li	a3,0
    80001cac:	4605                	li	a2,1
    80001cae:	040005b7          	lui	a1,0x4000
    80001cb2:	15fd                	addi	a1,a1,-1
    80001cb4:	05b2                	slli	a1,a1,0xc
    80001cb6:	fffff097          	auipc	ra,0xfffff
    80001cba:	5ca080e7          	jalr	1482(ra) # 80001280 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001cbe:	4681                	li	a3,0
    80001cc0:	4605                	li	a2,1
    80001cc2:	020005b7          	lui	a1,0x2000
    80001cc6:	15fd                	addi	a1,a1,-1
    80001cc8:	05b6                	slli	a1,a1,0xd
    80001cca:	8526                	mv	a0,s1
    80001ccc:	fffff097          	auipc	ra,0xfffff
    80001cd0:	5b4080e7          	jalr	1460(ra) # 80001280 <uvmunmap>
  uvmfree(pagetable, sz);
    80001cd4:	85ca                	mv	a1,s2
    80001cd6:	8526                	mv	a0,s1
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	870080e7          	jalr	-1936(ra) # 80001548 <uvmfree>
}
    80001ce0:	60e2                	ld	ra,24(sp)
    80001ce2:	6442                	ld	s0,16(sp)
    80001ce4:	64a2                	ld	s1,8(sp)
    80001ce6:	6902                	ld	s2,0(sp)
    80001ce8:	6105                	addi	sp,sp,32
    80001cea:	8082                	ret

0000000080001cec <freeproc>:
{
    80001cec:	1101                	addi	sp,sp,-32
    80001cee:	ec06                	sd	ra,24(sp)
    80001cf0:	e822                	sd	s0,16(sp)
    80001cf2:	e426                	sd	s1,8(sp)
    80001cf4:	1000                	addi	s0,sp,32
    80001cf6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001cf8:	6d48                	ld	a0,152(a0)
    80001cfa:	c509                	beqz	a0,80001d04 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001cfc:	fffff097          	auipc	ra,0xfffff
    80001d00:	d02080e7          	jalr	-766(ra) # 800009fe <kfree>
  p->trapframe = 0;
    80001d04:	0804bc23          	sd	zero,152(s1)
  if(p->pagetable)
    80001d08:	68c8                	ld	a0,144(s1)
    80001d0a:	c511                	beqz	a0,80001d16 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001d0c:	64cc                	ld	a1,136(s1)
    80001d0e:	00000097          	auipc	ra,0x0
    80001d12:	f8c080e7          	jalr	-116(ra) # 80001c9a <proc_freepagetable>
  p->pagetable = 0;
    80001d16:	0804b823          	sd	zero,144(s1)
  p->sz = 0;
    80001d1a:	0804b423          	sd	zero,136(s1)
  p->pid = 0;
    80001d1e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001d22:	0604bc23          	sd	zero,120(s1)
  p->name[0] = 0;
    80001d26:	18048c23          	sb	zero,408(s1)
  p->exit_msg[0] = 0;
    80001d2a:	02048a23          	sb	zero,52(s1)
  p->chan = 0;
    80001d2e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001d32:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001d36:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001d3a:	0004ac23          	sw	zero,24(s1)
}
    80001d3e:	60e2                	ld	ra,24(sp)
    80001d40:	6442                	ld	s0,16(sp)
    80001d42:	64a2                	ld	s1,8(sp)
    80001d44:	6105                	addi	sp,sp,32
    80001d46:	8082                	ret

0000000080001d48 <allocproc>:
{
    80001d48:	1101                	addi	sp,sp,-32
    80001d4a:	ec06                	sd	ra,24(sp)
    80001d4c:	e822                	sd	s0,16(sp)
    80001d4e:	e426                	sd	s1,8(sp)
    80001d50:	e04a                	sd	s2,0(sp)
    80001d52:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d54:	0000f497          	auipc	s1,0xf
    80001d58:	2ec48493          	addi	s1,s1,748 # 80011040 <proc>
    80001d5c:	00016917          	auipc	s2,0x16
    80001d60:	ce490913          	addi	s2,s2,-796 # 80017a40 <tickslock>
    acquire(&p->lock);
    80001d64:	8526                	mv	a0,s1
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	e84080e7          	jalr	-380(ra) # 80000bea <acquire>
    if(p->state == UNUSED) {
    80001d6e:	4c9c                	lw	a5,24(s1)
    80001d70:	cf81                	beqz	a5,80001d88 <allocproc+0x40>
      release(&p->lock);
    80001d72:	8526                	mv	a0,s1
    80001d74:	fffff097          	auipc	ra,0xfffff
    80001d78:	f2a080e7          	jalr	-214(ra) # 80000c9e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001d7c:	1a848493          	addi	s1,s1,424
    80001d80:	ff2492e3          	bne	s1,s2,80001d64 <allocproc+0x1c>
  return 0;
    80001d84:	4481                	li	s1,0
    80001d86:	a8b5                	j	80001e02 <allocproc+0xba>
  memset(p->exit_msg, 0, sizeof(p->exit_msg));
    80001d88:	02000613          	li	a2,32
    80001d8c:	4581                	li	a1,0
    80001d8e:	03448513          	addi	a0,s1,52
    80001d92:	fffff097          	auipc	ra,0xfffff
    80001d96:	f54080e7          	jalr	-172(ra) # 80000ce6 <memset>
  p->pid = allocpid();
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	e1e080e7          	jalr	-482(ra) # 80001bb8 <allocpid>
    80001da2:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001da4:	4785                	li	a5,1
    80001da6:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001da8:	fffff097          	auipc	ra,0xfffff
    80001dac:	d52080e7          	jalr	-686(ra) # 80000afa <kalloc>
    80001db0:	892a                	mv	s2,a0
    80001db2:	ecc8                	sd	a0,152(s1)
    80001db4:	cd31                	beqz	a0,80001e10 <allocproc+0xc8>
  p->pagetable = proc_pagetable(p);
    80001db6:	8526                	mv	a0,s1
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	e46080e7          	jalr	-442(ra) # 80001bfe <proc_pagetable>
    80001dc0:	892a                	mv	s2,a0
    80001dc2:	e8c8                	sd	a0,144(s1)
  if(p->pagetable == 0){
    80001dc4:	c135                	beqz	a0,80001e28 <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80001dc6:	07000613          	li	a2,112
    80001dca:	4581                	li	a1,0
    80001dcc:	0a048513          	addi	a0,s1,160
    80001dd0:	fffff097          	auipc	ra,0xfffff
    80001dd4:	f16080e7          	jalr	-234(ra) # 80000ce6 <memset>
  p->context.ra = (uint64)forkret;
    80001dd8:	00000797          	auipc	a5,0x0
    80001ddc:	d9a78793          	addi	a5,a5,-614 # 80001b72 <forkret>
    80001de0:	f0dc                	sd	a5,160(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001de2:	60dc                	ld	a5,128(s1)
    80001de4:	6705                	lui	a4,0x1
    80001de6:	97ba                	add	a5,a5,a4
    80001de8:	f4dc                	sd	a5,168(s1)
  p->ps_priority = 5;
    80001dea:	4795                	li	a5,5
    80001dec:	d0bc                	sw	a5,96(s1)
  p->accumulator = 0;
    80001dee:	0404bc23          	sd	zero,88(s1)
  p->cfs_priority = 1;
    80001df2:	4785                	li	a5,1
    80001df4:	d0fc                	sw	a5,100(s1)
  p->rtime = 0;
    80001df6:	0604a423          	sw	zero,104(s1)
  p->stime = 0;
    80001dfa:	0604a623          	sw	zero,108(s1)
  p->retime = 0;
    80001dfe:	0604a823          	sw	zero,112(s1)
}
    80001e02:	8526                	mv	a0,s1
    80001e04:	60e2                	ld	ra,24(sp)
    80001e06:	6442                	ld	s0,16(sp)
    80001e08:	64a2                	ld	s1,8(sp)
    80001e0a:	6902                	ld	s2,0(sp)
    80001e0c:	6105                	addi	sp,sp,32
    80001e0e:	8082                	ret
    freeproc(p);
    80001e10:	8526                	mv	a0,s1
    80001e12:	00000097          	auipc	ra,0x0
    80001e16:	eda080e7          	jalr	-294(ra) # 80001cec <freeproc>
    release(&p->lock);
    80001e1a:	8526                	mv	a0,s1
    80001e1c:	fffff097          	auipc	ra,0xfffff
    80001e20:	e82080e7          	jalr	-382(ra) # 80000c9e <release>
    return 0;
    80001e24:	84ca                	mv	s1,s2
    80001e26:	bff1                	j	80001e02 <allocproc+0xba>
    freeproc(p);
    80001e28:	8526                	mv	a0,s1
    80001e2a:	00000097          	auipc	ra,0x0
    80001e2e:	ec2080e7          	jalr	-318(ra) # 80001cec <freeproc>
    release(&p->lock);
    80001e32:	8526                	mv	a0,s1
    80001e34:	fffff097          	auipc	ra,0xfffff
    80001e38:	e6a080e7          	jalr	-406(ra) # 80000c9e <release>
    return 0;
    80001e3c:	84ca                	mv	s1,s2
    80001e3e:	b7d1                	j	80001e02 <allocproc+0xba>

0000000080001e40 <userinit>:
{
    80001e40:	1101                	addi	sp,sp,-32
    80001e42:	ec06                	sd	ra,24(sp)
    80001e44:	e822                	sd	s0,16(sp)
    80001e46:	e426                	sd	s1,8(sp)
    80001e48:	1000                	addi	s0,sp,32
  p = allocproc();
    80001e4a:	00000097          	auipc	ra,0x0
    80001e4e:	efe080e7          	jalr	-258(ra) # 80001d48 <allocproc>
    80001e52:	84aa                	mv	s1,a0
  initproc = p;
    80001e54:	00007797          	auipc	a5,0x7
    80001e58:	b4a7b623          	sd	a0,-1204(a5) # 800089a0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001e5c:	03400613          	li	a2,52
    80001e60:	00007597          	auipc	a1,0x7
    80001e64:	ab058593          	addi	a1,a1,-1360 # 80008910 <initcode>
    80001e68:	6948                	ld	a0,144(a0)
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	508080e7          	jalr	1288(ra) # 80001372 <uvmfirst>
  p->sz = PGSIZE;
    80001e72:	6785                	lui	a5,0x1
    80001e74:	e4dc                	sd	a5,136(s1)
  p->trapframe->epc = 0;      // user program counter
    80001e76:	6cd8                	ld	a4,152(s1)
    80001e78:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001e7c:	6cd8                	ld	a4,152(s1)
    80001e7e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001e80:	4641                	li	a2,16
    80001e82:	00006597          	auipc	a1,0x6
    80001e86:	3e658593          	addi	a1,a1,998 # 80008268 <digits+0x228>
    80001e8a:	19848513          	addi	a0,s1,408
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	faa080e7          	jalr	-86(ra) # 80000e38 <safestrcpy>
  p->cwd = namei("/");
    80001e96:	00006517          	auipc	a0,0x6
    80001e9a:	3e250513          	addi	a0,a0,994 # 80008278 <digits+0x238>
    80001e9e:	00002097          	auipc	ra,0x2
    80001ea2:	5a6080e7          	jalr	1446(ra) # 80004444 <namei>
    80001ea6:	18a4b823          	sd	a0,400(s1)
  p->state = RUNNABLE;
    80001eaa:	478d                	li	a5,3
    80001eac:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001eae:	8526                	mv	a0,s1
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	dee080e7          	jalr	-530(ra) # 80000c9e <release>
}
    80001eb8:	60e2                	ld	ra,24(sp)
    80001eba:	6442                	ld	s0,16(sp)
    80001ebc:	64a2                	ld	s1,8(sp)
    80001ebe:	6105                	addi	sp,sp,32
    80001ec0:	8082                	ret

0000000080001ec2 <growproc>:
{
    80001ec2:	1101                	addi	sp,sp,-32
    80001ec4:	ec06                	sd	ra,24(sp)
    80001ec6:	e822                	sd	s0,16(sp)
    80001ec8:	e426                	sd	s1,8(sp)
    80001eca:	e04a                	sd	s2,0(sp)
    80001ecc:	1000                	addi	s0,sp,32
    80001ece:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001ed0:	00000097          	auipc	ra,0x0
    80001ed4:	b0c080e7          	jalr	-1268(ra) # 800019dc <myproc>
    80001ed8:	84aa                	mv	s1,a0
  sz = p->sz;
    80001eda:	654c                	ld	a1,136(a0)
  if(n > 0){
    80001edc:	01204c63          	bgtz	s2,80001ef4 <growproc+0x32>
  } else if(n < 0){
    80001ee0:	02094663          	bltz	s2,80001f0c <growproc+0x4a>
  p->sz = sz;
    80001ee4:	e4cc                	sd	a1,136(s1)
  return 0;
    80001ee6:	4501                	li	a0,0
}
    80001ee8:	60e2                	ld	ra,24(sp)
    80001eea:	6442                	ld	s0,16(sp)
    80001eec:	64a2                	ld	s1,8(sp)
    80001eee:	6902                	ld	s2,0(sp)
    80001ef0:	6105                	addi	sp,sp,32
    80001ef2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001ef4:	4691                	li	a3,4
    80001ef6:	00b90633          	add	a2,s2,a1
    80001efa:	6948                	ld	a0,144(a0)
    80001efc:	fffff097          	auipc	ra,0xfffff
    80001f00:	530080e7          	jalr	1328(ra) # 8000142c <uvmalloc>
    80001f04:	85aa                	mv	a1,a0
    80001f06:	fd79                	bnez	a0,80001ee4 <growproc+0x22>
      return -1;
    80001f08:	557d                	li	a0,-1
    80001f0a:	bff9                	j	80001ee8 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001f0c:	00b90633          	add	a2,s2,a1
    80001f10:	6948                	ld	a0,144(a0)
    80001f12:	fffff097          	auipc	ra,0xfffff
    80001f16:	4d2080e7          	jalr	1234(ra) # 800013e4 <uvmdealloc>
    80001f1a:	85aa                	mv	a1,a0
    80001f1c:	b7e1                	j	80001ee4 <growproc+0x22>

0000000080001f1e <fork>:
{
    80001f1e:	7179                	addi	sp,sp,-48
    80001f20:	f406                	sd	ra,40(sp)
    80001f22:	f022                	sd	s0,32(sp)
    80001f24:	ec26                	sd	s1,24(sp)
    80001f26:	e84a                	sd	s2,16(sp)
    80001f28:	e44e                	sd	s3,8(sp)
    80001f2a:	e052                	sd	s4,0(sp)
    80001f2c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f2e:	00000097          	auipc	ra,0x0
    80001f32:	aae080e7          	jalr	-1362(ra) # 800019dc <myproc>
    80001f36:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001f38:	00000097          	auipc	ra,0x0
    80001f3c:	e10080e7          	jalr	-496(ra) # 80001d48 <allocproc>
    80001f40:	10050b63          	beqz	a0,80002056 <fork+0x138>
    80001f44:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001f46:	08893603          	ld	a2,136(s2)
    80001f4a:	694c                	ld	a1,144(a0)
    80001f4c:	09093503          	ld	a0,144(s2)
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	630080e7          	jalr	1584(ra) # 80001580 <uvmcopy>
    80001f58:	04054663          	bltz	a0,80001fa4 <fork+0x86>
  np->sz = p->sz;
    80001f5c:	08893783          	ld	a5,136(s2)
    80001f60:	08f9b423          	sd	a5,136(s3)
  *(np->trapframe) = *(p->trapframe);
    80001f64:	09893683          	ld	a3,152(s2)
    80001f68:	87b6                	mv	a5,a3
    80001f6a:	0989b703          	ld	a4,152(s3)
    80001f6e:	12068693          	addi	a3,a3,288
    80001f72:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001f76:	6788                	ld	a0,8(a5)
    80001f78:	6b8c                	ld	a1,16(a5)
    80001f7a:	6f90                	ld	a2,24(a5)
    80001f7c:	01073023          	sd	a6,0(a4)
    80001f80:	e708                	sd	a0,8(a4)
    80001f82:	eb0c                	sd	a1,16(a4)
    80001f84:	ef10                	sd	a2,24(a4)
    80001f86:	02078793          	addi	a5,a5,32
    80001f8a:	02070713          	addi	a4,a4,32
    80001f8e:	fed792e3          	bne	a5,a3,80001f72 <fork+0x54>
  np->trapframe->a0 = 0;
    80001f92:	0989b783          	ld	a5,152(s3)
    80001f96:	0607b823          	sd	zero,112(a5)
    80001f9a:	11000493          	li	s1,272
  for(i = 0; i < NOFILE; i++)
    80001f9e:	19000a13          	li	s4,400
    80001fa2:	a03d                	j	80001fd0 <fork+0xb2>
    freeproc(np);
    80001fa4:	854e                	mv	a0,s3
    80001fa6:	00000097          	auipc	ra,0x0
    80001faa:	d46080e7          	jalr	-698(ra) # 80001cec <freeproc>
    release(&np->lock);
    80001fae:	854e                	mv	a0,s3
    80001fb0:	fffff097          	auipc	ra,0xfffff
    80001fb4:	cee080e7          	jalr	-786(ra) # 80000c9e <release>
    return -1;
    80001fb8:	5a7d                	li	s4,-1
    80001fba:	a069                	j	80002044 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001fbc:	00003097          	auipc	ra,0x3
    80001fc0:	b1e080e7          	jalr	-1250(ra) # 80004ada <filedup>
    80001fc4:	009987b3          	add	a5,s3,s1
    80001fc8:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001fca:	04a1                	addi	s1,s1,8
    80001fcc:	01448763          	beq	s1,s4,80001fda <fork+0xbc>
    if(p->ofile[i])
    80001fd0:	009907b3          	add	a5,s2,s1
    80001fd4:	6388                	ld	a0,0(a5)
    80001fd6:	f17d                	bnez	a0,80001fbc <fork+0x9e>
    80001fd8:	bfcd                	j	80001fca <fork+0xac>
  np->cwd = idup(p->cwd);
    80001fda:	19093503          	ld	a0,400(s2)
    80001fde:	00002097          	auipc	ra,0x2
    80001fe2:	c82080e7          	jalr	-894(ra) # 80003c60 <idup>
    80001fe6:	18a9b823          	sd	a0,400(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001fea:	4641                	li	a2,16
    80001fec:	19890593          	addi	a1,s2,408
    80001ff0:	19898513          	addi	a0,s3,408
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	e44080e7          	jalr	-444(ra) # 80000e38 <safestrcpy>
  pid = np->pid;
    80001ffc:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80002000:	854e                	mv	a0,s3
    80002002:	fffff097          	auipc	ra,0xfffff
    80002006:	c9c080e7          	jalr	-868(ra) # 80000c9e <release>
  acquire(&wait_lock);
    8000200a:	0000f497          	auipc	s1,0xf
    8000200e:	c1e48493          	addi	s1,s1,-994 # 80010c28 <wait_lock>
    80002012:	8526                	mv	a0,s1
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	bd6080e7          	jalr	-1066(ra) # 80000bea <acquire>
  np->parent = p;
    8000201c:	0729bc23          	sd	s2,120(s3)
  release(&wait_lock);
    80002020:	8526                	mv	a0,s1
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	c7c080e7          	jalr	-900(ra) # 80000c9e <release>
  acquire(&np->lock);
    8000202a:	854e                	mv	a0,s3
    8000202c:	fffff097          	auipc	ra,0xfffff
    80002030:	bbe080e7          	jalr	-1090(ra) # 80000bea <acquire>
  np->state = RUNNABLE;
    80002034:	478d                	li	a5,3
    80002036:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000203a:	854e                	mv	a0,s3
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	c62080e7          	jalr	-926(ra) # 80000c9e <release>
}
    80002044:	8552                	mv	a0,s4
    80002046:	70a2                	ld	ra,40(sp)
    80002048:	7402                	ld	s0,32(sp)
    8000204a:	64e2                	ld	s1,24(sp)
    8000204c:	6942                	ld	s2,16(sp)
    8000204e:	69a2                	ld	s3,8(sp)
    80002050:	6a02                	ld	s4,0(sp)
    80002052:	6145                	addi	sp,sp,48
    80002054:	8082                	ret
    return -1;
    80002056:	5a7d                	li	s4,-1
    80002058:	b7f5                	j	80002044 <fork+0x126>

000000008000205a <original_scheduler>:
    8000205a:	8792                	mv	a5,tp
  int id = r_tp();
    8000205c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000205e:	00779693          	slli	a3,a5,0x7
    80002062:	0000f717          	auipc	a4,0xf
    80002066:	bae70713          	addi	a4,a4,-1106 # 80010c10 <pid_lock>
    8000206a:	9736                	add	a4,a4,a3
    8000206c:	02073823          	sd	zero,48(a4)
    if(sched_policy != 0) {
    80002070:	00007717          	auipc	a4,0x7
    80002074:	89472703          	lw	a4,-1900(a4) # 80008904 <sched_policy>
    80002078:	eb55                	bnez	a4,8000212c <original_scheduler+0xd2>
{
    8000207a:	715d                	addi	sp,sp,-80
    8000207c:	e486                	sd	ra,72(sp)
    8000207e:	e0a2                	sd	s0,64(sp)
    80002080:	fc26                	sd	s1,56(sp)
    80002082:	f84a                	sd	s2,48(sp)
    80002084:	f44e                	sd	s3,40(sp)
    80002086:	f052                	sd	s4,32(sp)
    80002088:	ec56                	sd	s5,24(sp)
    8000208a:	e85a                	sd	s6,16(sp)
    8000208c:	e45e                	sd	s7,8(sp)
    8000208e:	0880                	addi	s0,sp,80
        swtch(&c->context, &p->context);
    80002090:	0000f717          	auipc	a4,0xf
    80002094:	bb870713          	addi	a4,a4,-1096 # 80010c48 <cpus+0x8>
    80002098:	00e68ab3          	add	s5,a3,a4
        p->state = RUNNING;
    8000209c:	4b11                	li	s6,4
        c->proc = p;
    8000209e:	0000fa17          	auipc	s4,0xf
    800020a2:	b72a0a13          	addi	s4,s4,-1166 # 80010c10 <pid_lock>
    800020a6:	9a36                	add	s4,s4,a3
    for(p = proc; p < &proc[NPROC]; p++) {
    800020a8:	00016997          	auipc	s3,0x16
    800020ac:	99898993          	addi	s3,s3,-1640 # 80017a40 <tickslock>
    if(sched_policy != 0) {
    800020b0:	00007b97          	auipc	s7,0x7
    800020b4:	854b8b93          	addi	s7,s7,-1964 # 80008904 <sched_policy>
    800020b8:	a099                	j	800020fe <original_scheduler+0xa4>
        p->state = RUNNING;
    800020ba:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800020be:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800020c2:	0a048593          	addi	a1,s1,160
    800020c6:	8556                	mv	a0,s5
    800020c8:	00001097          	auipc	ra,0x1
    800020cc:	9d2080e7          	jalr	-1582(ra) # 80002a9a <swtch>
        c->proc = 0;
    800020d0:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800020d4:	8526                	mv	a0,s1
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	bc8080e7          	jalr	-1080(ra) # 80000c9e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800020de:	1a848493          	addi	s1,s1,424
    800020e2:	01348b63          	beq	s1,s3,800020f8 <original_scheduler+0x9e>
      acquire(&p->lock);
    800020e6:	8526                	mv	a0,s1
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	b02080e7          	jalr	-1278(ra) # 80000bea <acquire>
      if(p->state == RUNNABLE) {
    800020f0:	4c9c                	lw	a5,24(s1)
    800020f2:	ff2791e3          	bne	a5,s2,800020d4 <original_scheduler+0x7a>
    800020f6:	b7d1                	j	800020ba <original_scheduler+0x60>
    if(sched_policy != 0) {
    800020f8:	000ba783          	lw	a5,0(s7)
    800020fc:	ef89                	bnez	a5,80002116 <original_scheduler+0xbc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002102:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002106:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000210a:	0000f497          	auipc	s1,0xf
    8000210e:	f3648493          	addi	s1,s1,-202 # 80011040 <proc>
      if(p->state == RUNNABLE) {
    80002112:	490d                	li	s2,3
    80002114:	bfc9                	j	800020e6 <original_scheduler+0x8c>
}
    80002116:	60a6                	ld	ra,72(sp)
    80002118:	6406                	ld	s0,64(sp)
    8000211a:	74e2                	ld	s1,56(sp)
    8000211c:	7942                	ld	s2,48(sp)
    8000211e:	79a2                	ld	s3,40(sp)
    80002120:	7a02                	ld	s4,32(sp)
    80002122:	6ae2                	ld	s5,24(sp)
    80002124:	6b42                	ld	s6,16(sp)
    80002126:	6ba2                	ld	s7,8(sp)
    80002128:	6161                	addi	sp,sp,80
    8000212a:	8082                	ret
    8000212c:	8082                	ret

000000008000212e <accumulator_scheduler>:
{
    8000212e:	711d                	addi	sp,sp,-96
    80002130:	ec86                	sd	ra,88(sp)
    80002132:	e8a2                	sd	s0,80(sp)
    80002134:	e4a6                	sd	s1,72(sp)
    80002136:	e0ca                	sd	s2,64(sp)
    80002138:	fc4e                	sd	s3,56(sp)
    8000213a:	f852                	sd	s4,48(sp)
    8000213c:	f456                	sd	s5,40(sp)
    8000213e:	f05a                	sd	s6,32(sp)
    80002140:	ec5e                	sd	s7,24(sp)
    80002142:	e862                	sd	s8,16(sp)
    80002144:	e466                	sd	s9,8(sp)
    80002146:	e06a                	sd	s10,0(sp)
    80002148:	1080                	addi	s0,sp,96
  asm volatile("mv %0, tp" : "=r" (x) );
    8000214a:	8792                	mv	a5,tp
  int id = r_tp();
    8000214c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000214e:	00779d13          	slli	s10,a5,0x7
    80002152:	0000f717          	auipc	a4,0xf
    80002156:	abe70713          	addi	a4,a4,-1346 # 80010c10 <pid_lock>
    8000215a:	976a                	add	a4,a4,s10
    8000215c:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &p_to_run->context);
    80002160:	0000f717          	auipc	a4,0xf
    80002164:	ae870713          	addi	a4,a4,-1304 # 80010c48 <cpus+0x8>
    80002168:	9d3a                	add	s10,s10,a4
    acc = __LONG_LONG_MAX__;
    8000216a:	00007b17          	auipc	s6,0x7
    8000216e:	82eb0b13          	addi	s6,s6,-2002 # 80008998 <acc>
    80002172:	5cfd                	li	s9,-1
    80002174:	001cdc93          	srli	s9,s9,0x1
    for(p = proc; p < &proc[NPROC]; p++) {
    80002178:	00016a17          	auipc	s4,0x16
    8000217c:	8c8a0a13          	addi	s4,s4,-1848 # 80017a40 <tickslock>
      c->proc = p_to_run;
    80002180:	079e                	slli	a5,a5,0x7
    80002182:	0000fc17          	auipc	s8,0xf
    80002186:	a8ec0c13          	addi	s8,s8,-1394 # 80010c10 <pid_lock>
    8000218a:	9c3e                	add	s8,s8,a5
    8000218c:	a079                	j	8000221a <accumulator_scheduler+0xec>
          release(&p->lock);
    8000218e:	8526                	mv	a0,s1
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	b0e080e7          	jalr	-1266(ra) # 80000c9e <release>
    80002198:	a031                	j	800021a4 <accumulator_scheduler+0x76>
        release(&p->lock);
    8000219a:	8526                	mv	a0,s1
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	b02080e7          	jalr	-1278(ra) # 80000c9e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800021a4:	1a848793          	addi	a5,s1,424
    800021a8:	0547f363          	bgeu	a5,s4,800021ee <accumulator_scheduler+0xc0>
    800021ac:	1a848493          	addi	s1,s1,424
    800021b0:	8926                	mv	s2,s1
      acquire(&p->lock);
    800021b2:	8526                	mv	a0,s1
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	a36080e7          	jalr	-1482(ra) # 80000bea <acquire>
      if(p->state == RUNNABLE) {
    800021bc:	4c9c                	lw	a5,24(s1)
    800021be:	fd379ee3          	bne	a5,s3,8000219a <accumulator_scheduler+0x6c>
        if(p->accumulator < acc){
    800021c2:	6cb8                	ld	a4,88(s1)
    800021c4:	000b3783          	ld	a5,0(s6)
    800021c8:	fcf753e3          	bge	a4,a5,8000218e <accumulator_scheduler+0x60>
          if(p_to_run)
    800021cc:	000a8763          	beqz	s5,800021da <accumulator_scheduler+0xac>
            release(&p_to_run->lock);
    800021d0:	8556                	mv	a0,s5
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	acc080e7          	jalr	-1332(ra) # 80000c9e <release>
          acc = p->accumulator;
    800021da:	05893783          	ld	a5,88(s2)
    800021de:	00fb3023          	sd	a5,0(s6)
    for(p = proc; p < &proc[NPROC]; p++) {
    800021e2:	1a848793          	addi	a5,s1,424
    800021e6:	0147f763          	bgeu	a5,s4,800021f4 <accumulator_scheduler+0xc6>
    800021ea:	8aca                	mv	s5,s2
    800021ec:	b7c1                	j	800021ac <accumulator_scheduler+0x7e>
    if(p_to_run){
    800021ee:	020a8863          	beqz	s5,8000221e <accumulator_scheduler+0xf0>
    800021f2:	8956                	mv	s2,s5
      p_to_run->state = RUNNING;
    800021f4:	4791                	li	a5,4
    800021f6:	00f92c23          	sw	a5,24(s2)
      c->proc = p_to_run;
    800021fa:	032c3823          	sd	s2,48(s8)
      swtch(&c->context, &p_to_run->context);
    800021fe:	0a090593          	addi	a1,s2,160
    80002202:	856a                	mv	a0,s10
    80002204:	00001097          	auipc	ra,0x1
    80002208:	896080e7          	jalr	-1898(ra) # 80002a9a <swtch>
      c->proc = 0;
    8000220c:	020c3823          	sd	zero,48(s8)
      release(&p_to_run->lock);
    80002210:	854a                	mv	a0,s2
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	a8c080e7          	jalr	-1396(ra) # 80000c9e <release>
    acc = __LONG_LONG_MAX__;
    8000221a:	4b81                	li	s7,0
      if(p->state == RUNNABLE) {
    8000221c:	498d                	li	s3,3
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000221e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002222:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002226:	10079073          	csrw	sstatus,a5
    acc = __LONG_LONG_MAX__;
    8000222a:	019b3023          	sd	s9,0(s6)
    for(p = proc; p < &proc[NPROC]; p++) {
    8000222e:	0000f497          	auipc	s1,0xf
    80002232:	e1248493          	addi	s1,s1,-494 # 80011040 <proc>
    acc = __LONG_LONG_MAX__;
    80002236:	8ade                	mv	s5,s7
    80002238:	bfa5                	j	800021b0 <accumulator_scheduler+0x82>

000000008000223a <cfs_scheduler>:
{
    8000223a:	7119                	addi	sp,sp,-128
    8000223c:	fc86                	sd	ra,120(sp)
    8000223e:	f8a2                	sd	s0,112(sp)
    80002240:	f4a6                	sd	s1,104(sp)
    80002242:	f0ca                	sd	s2,96(sp)
    80002244:	ecce                	sd	s3,88(sp)
    80002246:	e8d2                	sd	s4,80(sp)
    80002248:	e4d6                	sd	s5,72(sp)
    8000224a:	e0da                	sd	s6,64(sp)
    8000224c:	fc5e                	sd	s7,56(sp)
    8000224e:	f862                	sd	s8,48(sp)
    80002250:	f466                	sd	s9,40(sp)
    80002252:	f06a                	sd	s10,32(sp)
    80002254:	ec6e                	sd	s11,24(sp)
    80002256:	0100                	addi	s0,sp,128
  asm volatile("mv %0, tp" : "=r" (x) );
    80002258:	8792                	mv	a5,tp
  int id = r_tp();
    8000225a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000225c:	00779693          	slli	a3,a5,0x7
    80002260:	0000f717          	auipc	a4,0xf
    80002264:	9b070713          	addi	a4,a4,-1616 # 80010c10 <pid_lock>
    80002268:	9736                	add	a4,a4,a3
    8000226a:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &min_proc->context);
    8000226e:	0000f717          	auipc	a4,0xf
    80002272:	9da70713          	addi	a4,a4,-1574 # 80010c48 <cpus+0x8>
    80002276:	9736                	add	a4,a4,a3
    80002278:	f8e43423          	sd	a4,-120(s0)
  uint decay_factor = 100;
    8000227c:	06400a13          	li	s4,100
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002280:	5c7d                	li	s8,-1
      switch (p->cfs_priority) {
    80002282:	4d05                	li	s10,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80002284:	00015b17          	auipc	s6,0x15
    80002288:	7bcb0b13          	addi	s6,s6,1980 # 80017a40 <tickslock>
      c->proc = min_proc;
    8000228c:	0000f717          	auipc	a4,0xf
    80002290:	98470713          	addi	a4,a4,-1660 # 80010c10 <pid_lock>
    80002294:	00d707b3          	add	a5,a4,a3
    80002298:	f8f43023          	sd	a5,-128(s0)
    8000229c:	a075                	j	80002348 <cfs_scheduler+0x10e>
        release(&p->lock);
    8000229e:	8526                	mv	a0,s1
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	9fe080e7          	jalr	-1538(ra) # 80000c9e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800022a8:	1a848493          	addi	s1,s1,424
    800022ac:	07648663          	beq	s1,s6,80002318 <cfs_scheduler+0xde>
      acquire(&p->lock);
    800022b0:	8526                	mv	a0,s1
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	938080e7          	jalr	-1736(ra) # 80000bea <acquire>
      if (p->state != RUNNABLE) {
    800022ba:	4c9c                	lw	a5,24(s1)
    800022bc:	ff5791e3          	bne	a5,s5,8000229e <cfs_scheduler+0x64>
      switch (p->cfs_priority) {
    800022c0:	50fc                	lw	a5,100(s1)
    800022c2:	03a78d63          	beq	a5,s10,800022fc <cfs_scheduler+0xc2>
    800022c6:	03978e63          	beq	a5,s9,80002302 <cfs_scheduler+0xc8>
    800022ca:	c795                	beqz	a5,800022f6 <cfs_scheduler+0xbc>
      uint vruntime = p->rtime * decay_factor / (p->rtime + p->stime + p->retime);
    800022cc:	54b8                	lw	a4,104(s1)
    800022ce:	0347093b          	mulw	s2,a4,s4
    800022d2:	54fc                	lw	a5,108(s1)
    800022d4:	9fb9                	addw	a5,a5,a4
    800022d6:	58b8                	lw	a4,112(s1)
    800022d8:	9fb9                	addw	a5,a5,a4
    800022da:	02f9593b          	divuw	s2,s2,a5
      if(min_vruntime == -1){
    800022de:	03898a63          	beq	s3,s8,80002312 <cfs_scheduler+0xd8>
      else if (vruntime < min_vruntime) {
    800022e2:	03397263          	bgeu	s2,s3,80002306 <cfs_scheduler+0xcc>
        release(&min_proc->lock);
    800022e6:	855e                	mv	a0,s7
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	9b6080e7          	jalr	-1610(ra) # 80000c9e <release>
        min_vruntime = vruntime;
    800022f0:	89ca                	mv	s3,s2
    800022f2:	8ba6                	mv	s7,s1
    800022f4:	bf55                	j	800022a8 <cfs_scheduler+0x6e>
      switch (p->cfs_priority) {
    800022f6:	07d00a13          	li	s4,125
    800022fa:	bfc9                	j	800022cc <cfs_scheduler+0x92>
        case 1: decay_factor = 100; break;   // normal priority
    800022fc:	06400a13          	li	s4,100
    80002300:	b7f1                	j	800022cc <cfs_scheduler+0x92>
        case 2: decay_factor = 75; break;    // high priority
    80002302:	8a6e                	mv	s4,s11
    80002304:	b7e1                	j	800022cc <cfs_scheduler+0x92>
        release(&p->lock);
    80002306:	8526                	mv	a0,s1
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	996080e7          	jalr	-1642(ra) # 80000c9e <release>
    80002310:	bf61                	j	800022a8 <cfs_scheduler+0x6e>
        min_vruntime = vruntime;
    80002312:	89ca                	mv	s3,s2
    80002314:	8ba6                	mv	s7,s1
    80002316:	bf49                	j	800022a8 <cfs_scheduler+0x6e>
    if (min_proc) {
    80002318:	020b8863          	beqz	s7,80002348 <cfs_scheduler+0x10e>
      min_proc->state = RUNNING;
    8000231c:	4791                	li	a5,4
    8000231e:	00fbac23          	sw	a5,24(s7)
      c->proc = min_proc;
    80002322:	f8043483          	ld	s1,-128(s0)
    80002326:	0374b823          	sd	s7,48(s1)
      swtch(&c->context, &min_proc->context);
    8000232a:	0a0b8593          	addi	a1,s7,160
    8000232e:	f8843503          	ld	a0,-120(s0)
    80002332:	00000097          	auipc	ra,0x0
    80002336:	768080e7          	jalr	1896(ra) # 80002a9a <swtch>
      c->proc = 0;
    8000233a:	0204b823          	sd	zero,48(s1)
      release(&min_proc->lock);
    8000233e:	855e                	mv	a0,s7
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	95e080e7          	jalr	-1698(ra) # 80000c9e <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002348:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000234c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002350:	10079073          	csrw	sstatus,a5
    80002354:	89e2                	mv	s3,s8
    80002356:	4b81                	li	s7,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002358:	0000f497          	auipc	s1,0xf
    8000235c:	ce848493          	addi	s1,s1,-792 # 80011040 <proc>
      if (p->state != RUNNABLE) {
    80002360:	4a8d                	li	s5,3
      switch (p->cfs_priority) {
    80002362:	4c89                	li	s9,2
        case 2: decay_factor = 75; break;    // high priority
    80002364:	04b00d93          	li	s11,75
    80002368:	b7a1                	j	800022b0 <cfs_scheduler+0x76>

000000008000236a <sched>:
{
    8000236a:	7179                	addi	sp,sp,-48
    8000236c:	f406                	sd	ra,40(sp)
    8000236e:	f022                	sd	s0,32(sp)
    80002370:	ec26                	sd	s1,24(sp)
    80002372:	e84a                	sd	s2,16(sp)
    80002374:	e44e                	sd	s3,8(sp)
    80002376:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	664080e7          	jalr	1636(ra) # 800019dc <myproc>
    80002380:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002382:	ffffe097          	auipc	ra,0xffffe
    80002386:	7ee080e7          	jalr	2030(ra) # 80000b70 <holding>
    8000238a:	c93d                	beqz	a0,80002400 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000238c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000238e:	2781                	sext.w	a5,a5
    80002390:	079e                	slli	a5,a5,0x7
    80002392:	0000f717          	auipc	a4,0xf
    80002396:	87e70713          	addi	a4,a4,-1922 # 80010c10 <pid_lock>
    8000239a:	97ba                	add	a5,a5,a4
    8000239c:	0a87a703          	lw	a4,168(a5)
    800023a0:	4785                	li	a5,1
    800023a2:	06f71763          	bne	a4,a5,80002410 <sched+0xa6>
  if(p->state == RUNNING)
    800023a6:	4c98                	lw	a4,24(s1)
    800023a8:	4791                	li	a5,4
    800023aa:	06f70b63          	beq	a4,a5,80002420 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023ae:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800023b2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800023b4:	efb5                	bnez	a5,80002430 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800023b6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800023b8:	0000f917          	auipc	s2,0xf
    800023bc:	85890913          	addi	s2,s2,-1960 # 80010c10 <pid_lock>
    800023c0:	2781                	sext.w	a5,a5
    800023c2:	079e                	slli	a5,a5,0x7
    800023c4:	97ca                	add	a5,a5,s2
    800023c6:	0ac7a983          	lw	s3,172(a5)
    800023ca:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800023cc:	2781                	sext.w	a5,a5
    800023ce:	079e                	slli	a5,a5,0x7
    800023d0:	0000f597          	auipc	a1,0xf
    800023d4:	87858593          	addi	a1,a1,-1928 # 80010c48 <cpus+0x8>
    800023d8:	95be                	add	a1,a1,a5
    800023da:	0a048513          	addi	a0,s1,160
    800023de:	00000097          	auipc	ra,0x0
    800023e2:	6bc080e7          	jalr	1724(ra) # 80002a9a <swtch>
    800023e6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800023e8:	2781                	sext.w	a5,a5
    800023ea:	079e                	slli	a5,a5,0x7
    800023ec:	97ca                	add	a5,a5,s2
    800023ee:	0b37a623          	sw	s3,172(a5)
}
    800023f2:	70a2                	ld	ra,40(sp)
    800023f4:	7402                	ld	s0,32(sp)
    800023f6:	64e2                	ld	s1,24(sp)
    800023f8:	6942                	ld	s2,16(sp)
    800023fa:	69a2                	ld	s3,8(sp)
    800023fc:	6145                	addi	sp,sp,48
    800023fe:	8082                	ret
    panic("sched p->lock");
    80002400:	00006517          	auipc	a0,0x6
    80002404:	e8050513          	addi	a0,a0,-384 # 80008280 <digits+0x240>
    80002408:	ffffe097          	auipc	ra,0xffffe
    8000240c:	13c080e7          	jalr	316(ra) # 80000544 <panic>
    panic("sched locks");
    80002410:	00006517          	auipc	a0,0x6
    80002414:	e8050513          	addi	a0,a0,-384 # 80008290 <digits+0x250>
    80002418:	ffffe097          	auipc	ra,0xffffe
    8000241c:	12c080e7          	jalr	300(ra) # 80000544 <panic>
    panic("sched running");
    80002420:	00006517          	auipc	a0,0x6
    80002424:	e8050513          	addi	a0,a0,-384 # 800082a0 <digits+0x260>
    80002428:	ffffe097          	auipc	ra,0xffffe
    8000242c:	11c080e7          	jalr	284(ra) # 80000544 <panic>
    panic("sched interruptible");
    80002430:	00006517          	auipc	a0,0x6
    80002434:	e8050513          	addi	a0,a0,-384 # 800082b0 <digits+0x270>
    80002438:	ffffe097          	auipc	ra,0xffffe
    8000243c:	10c080e7          	jalr	268(ra) # 80000544 <panic>

0000000080002440 <yield>:
{
    80002440:	1101                	addi	sp,sp,-32
    80002442:	ec06                	sd	ra,24(sp)
    80002444:	e822                	sd	s0,16(sp)
    80002446:	e426                	sd	s1,8(sp)
    80002448:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	592080e7          	jalr	1426(ra) # 800019dc <myproc>
    80002452:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002454:	ffffe097          	auipc	ra,0xffffe
    80002458:	796080e7          	jalr	1942(ra) # 80000bea <acquire>
  p->state = RUNNABLE;
    8000245c:	478d                	li	a5,3
    8000245e:	cc9c                	sw	a5,24(s1)
  sched();
    80002460:	00000097          	auipc	ra,0x0
    80002464:	f0a080e7          	jalr	-246(ra) # 8000236a <sched>
  release(&p->lock);
    80002468:	8526                	mv	a0,s1
    8000246a:	fffff097          	auipc	ra,0xfffff
    8000246e:	834080e7          	jalr	-1996(ra) # 80000c9e <release>
}
    80002472:	60e2                	ld	ra,24(sp)
    80002474:	6442                	ld	s0,16(sp)
    80002476:	64a2                	ld	s1,8(sp)
    80002478:	6105                	addi	sp,sp,32
    8000247a:	8082                	ret

000000008000247c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000247c:	7179                	addi	sp,sp,-48
    8000247e:	f406                	sd	ra,40(sp)
    80002480:	f022                	sd	s0,32(sp)
    80002482:	ec26                	sd	s1,24(sp)
    80002484:	e84a                	sd	s2,16(sp)
    80002486:	e44e                	sd	s3,8(sp)
    80002488:	1800                	addi	s0,sp,48
    8000248a:	89aa                	mv	s3,a0
    8000248c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000248e:	fffff097          	auipc	ra,0xfffff
    80002492:	54e080e7          	jalr	1358(ra) # 800019dc <myproc>
    80002496:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002498:	ffffe097          	auipc	ra,0xffffe
    8000249c:	752080e7          	jalr	1874(ra) # 80000bea <acquire>
  release(lk);
    800024a0:	854a                	mv	a0,s2
    800024a2:	ffffe097          	auipc	ra,0xffffe
    800024a6:	7fc080e7          	jalr	2044(ra) # 80000c9e <release>

  // Go to sleep.
  p->chan = chan;
    800024aa:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800024ae:	4789                	li	a5,2
    800024b0:	cc9c                	sw	a5,24(s1)

  sched();
    800024b2:	00000097          	auipc	ra,0x0
    800024b6:	eb8080e7          	jalr	-328(ra) # 8000236a <sched>

  // Tidy up.
  p->chan = 0;
    800024ba:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800024be:	8526                	mv	a0,s1
    800024c0:	ffffe097          	auipc	ra,0xffffe
    800024c4:	7de080e7          	jalr	2014(ra) # 80000c9e <release>
  acquire(lk);
    800024c8:	854a                	mv	a0,s2
    800024ca:	ffffe097          	auipc	ra,0xffffe
    800024ce:	720080e7          	jalr	1824(ra) # 80000bea <acquire>
}
    800024d2:	70a2                	ld	ra,40(sp)
    800024d4:	7402                	ld	s0,32(sp)
    800024d6:	64e2                	ld	s1,24(sp)
    800024d8:	6942                	ld	s2,16(sp)
    800024da:	69a2                	ld	s3,8(sp)
    800024dc:	6145                	addi	sp,sp,48
    800024de:	8082                	ret

00000000800024e0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800024e0:	7139                	addi	sp,sp,-64
    800024e2:	fc06                	sd	ra,56(sp)
    800024e4:	f822                	sd	s0,48(sp)
    800024e6:	f426                	sd	s1,40(sp)
    800024e8:	f04a                	sd	s2,32(sp)
    800024ea:	ec4e                	sd	s3,24(sp)
    800024ec:	e852                	sd	s4,16(sp)
    800024ee:	e456                	sd	s5,8(sp)
    800024f0:	0080                	addi	s0,sp,64
    800024f2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800024f4:	0000f497          	auipc	s1,0xf
    800024f8:	b4c48493          	addi	s1,s1,-1204 # 80011040 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800024fc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800024fe:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002500:	00015917          	auipc	s2,0x15
    80002504:	54090913          	addi	s2,s2,1344 # 80017a40 <tickslock>
    80002508:	a821                	j	80002520 <wakeup+0x40>
        p->state = RUNNABLE;
    8000250a:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000250e:	8526                	mv	a0,s1
    80002510:	ffffe097          	auipc	ra,0xffffe
    80002514:	78e080e7          	jalr	1934(ra) # 80000c9e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002518:	1a848493          	addi	s1,s1,424
    8000251c:	03248463          	beq	s1,s2,80002544 <wakeup+0x64>
    if(p != myproc()){
    80002520:	fffff097          	auipc	ra,0xfffff
    80002524:	4bc080e7          	jalr	1212(ra) # 800019dc <myproc>
    80002528:	fea488e3          	beq	s1,a0,80002518 <wakeup+0x38>
      acquire(&p->lock);
    8000252c:	8526                	mv	a0,s1
    8000252e:	ffffe097          	auipc	ra,0xffffe
    80002532:	6bc080e7          	jalr	1724(ra) # 80000bea <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002536:	4c9c                	lw	a5,24(s1)
    80002538:	fd379be3          	bne	a5,s3,8000250e <wakeup+0x2e>
    8000253c:	709c                	ld	a5,32(s1)
    8000253e:	fd4798e3          	bne	a5,s4,8000250e <wakeup+0x2e>
    80002542:	b7e1                	j	8000250a <wakeup+0x2a>
    }
  }
}
    80002544:	70e2                	ld	ra,56(sp)
    80002546:	7442                	ld	s0,48(sp)
    80002548:	74a2                	ld	s1,40(sp)
    8000254a:	7902                	ld	s2,32(sp)
    8000254c:	69e2                	ld	s3,24(sp)
    8000254e:	6a42                	ld	s4,16(sp)
    80002550:	6aa2                	ld	s5,8(sp)
    80002552:	6121                	addi	sp,sp,64
    80002554:	8082                	ret

0000000080002556 <reparent>:
{
    80002556:	7179                	addi	sp,sp,-48
    80002558:	f406                	sd	ra,40(sp)
    8000255a:	f022                	sd	s0,32(sp)
    8000255c:	ec26                	sd	s1,24(sp)
    8000255e:	e84a                	sd	s2,16(sp)
    80002560:	e44e                	sd	s3,8(sp)
    80002562:	e052                	sd	s4,0(sp)
    80002564:	1800                	addi	s0,sp,48
    80002566:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002568:	0000f497          	auipc	s1,0xf
    8000256c:	ad848493          	addi	s1,s1,-1320 # 80011040 <proc>
      pp->parent = initproc;
    80002570:	00006a17          	auipc	s4,0x6
    80002574:	430a0a13          	addi	s4,s4,1072 # 800089a0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002578:	00015997          	auipc	s3,0x15
    8000257c:	4c898993          	addi	s3,s3,1224 # 80017a40 <tickslock>
    80002580:	a029                	j	8000258a <reparent+0x34>
    80002582:	1a848493          	addi	s1,s1,424
    80002586:	01348d63          	beq	s1,s3,800025a0 <reparent+0x4a>
    if(pp->parent == p){
    8000258a:	7cbc                	ld	a5,120(s1)
    8000258c:	ff279be3          	bne	a5,s2,80002582 <reparent+0x2c>
      pp->parent = initproc;
    80002590:	000a3503          	ld	a0,0(s4)
    80002594:	fca8                	sd	a0,120(s1)
      wakeup(initproc);
    80002596:	00000097          	auipc	ra,0x0
    8000259a:	f4a080e7          	jalr	-182(ra) # 800024e0 <wakeup>
    8000259e:	b7d5                	j	80002582 <reparent+0x2c>
}
    800025a0:	70a2                	ld	ra,40(sp)
    800025a2:	7402                	ld	s0,32(sp)
    800025a4:	64e2                	ld	s1,24(sp)
    800025a6:	6942                	ld	s2,16(sp)
    800025a8:	69a2                	ld	s3,8(sp)
    800025aa:	6a02                	ld	s4,0(sp)
    800025ac:	6145                	addi	sp,sp,48
    800025ae:	8082                	ret

00000000800025b0 <exit>:
{
    800025b0:	7139                	addi	sp,sp,-64
    800025b2:	fc06                	sd	ra,56(sp)
    800025b4:	f822                	sd	s0,48(sp)
    800025b6:	f426                	sd	s1,40(sp)
    800025b8:	f04a                	sd	s2,32(sp)
    800025ba:	ec4e                	sd	s3,24(sp)
    800025bc:	e852                	sd	s4,16(sp)
    800025be:	e456                	sd	s5,8(sp)
    800025c0:	0080                	addi	s0,sp,64
    800025c2:	8aaa                	mv	s5,a0
    800025c4:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800025c6:	fffff097          	auipc	ra,0xfffff
    800025ca:	416080e7          	jalr	1046(ra) # 800019dc <myproc>
    800025ce:	89aa                	mv	s3,a0
  if(p == initproc)
    800025d0:	00006797          	auipc	a5,0x6
    800025d4:	3d07b783          	ld	a5,976(a5) # 800089a0 <initproc>
    800025d8:	11050493          	addi	s1,a0,272
    800025dc:	19050913          	addi	s2,a0,400
    800025e0:	02a79363          	bne	a5,a0,80002606 <exit+0x56>
    panic("init exiting");
    800025e4:	00006517          	auipc	a0,0x6
    800025e8:	ce450513          	addi	a0,a0,-796 # 800082c8 <digits+0x288>
    800025ec:	ffffe097          	auipc	ra,0xffffe
    800025f0:	f58080e7          	jalr	-168(ra) # 80000544 <panic>
      fileclose(f);
    800025f4:	00002097          	auipc	ra,0x2
    800025f8:	538080e7          	jalr	1336(ra) # 80004b2c <fileclose>
      p->ofile[fd] = 0;
    800025fc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002600:	04a1                	addi	s1,s1,8
    80002602:	01248563          	beq	s1,s2,8000260c <exit+0x5c>
    if(p->ofile[fd]){
    80002606:	6088                	ld	a0,0(s1)
    80002608:	f575                	bnez	a0,800025f4 <exit+0x44>
    8000260a:	bfdd                	j	80002600 <exit+0x50>
  begin_op();
    8000260c:	00002097          	auipc	ra,0x2
    80002610:	054080e7          	jalr	84(ra) # 80004660 <begin_op>
  iput(p->cwd);
    80002614:	1909b503          	ld	a0,400(s3)
    80002618:	00002097          	auipc	ra,0x2
    8000261c:	840080e7          	jalr	-1984(ra) # 80003e58 <iput>
  end_op();
    80002620:	00002097          	auipc	ra,0x2
    80002624:	0c0080e7          	jalr	192(ra) # 800046e0 <end_op>
  p->cwd = 0;
    80002628:	1809b823          	sd	zero,400(s3)
  acquire(&wait_lock);
    8000262c:	0000e497          	auipc	s1,0xe
    80002630:	5fc48493          	addi	s1,s1,1532 # 80010c28 <wait_lock>
    80002634:	8526                	mv	a0,s1
    80002636:	ffffe097          	auipc	ra,0xffffe
    8000263a:	5b4080e7          	jalr	1460(ra) # 80000bea <acquire>
  reparent(p);
    8000263e:	854e                	mv	a0,s3
    80002640:	00000097          	auipc	ra,0x0
    80002644:	f16080e7          	jalr	-234(ra) # 80002556 <reparent>
  wakeup(p->parent);
    80002648:	0789b503          	ld	a0,120(s3)
    8000264c:	00000097          	auipc	ra,0x0
    80002650:	e94080e7          	jalr	-364(ra) # 800024e0 <wakeup>
  acquire(&p->lock);
    80002654:	854e                	mv	a0,s3
    80002656:	ffffe097          	auipc	ra,0xffffe
    8000265a:	594080e7          	jalr	1428(ra) # 80000bea <acquire>
  p->xstate = status;
    8000265e:	0359a623          	sw	s5,44(s3)
  safestrcpy(p->exit_msg, msg, 32);
    80002662:	02000613          	li	a2,32
    80002666:	85d2                	mv	a1,s4
    80002668:	03498513          	addi	a0,s3,52
    8000266c:	ffffe097          	auipc	ra,0xffffe
    80002670:	7cc080e7          	jalr	1996(ra) # 80000e38 <safestrcpy>
  p->state = ZOMBIE;
    80002674:	4795                	li	a5,5
    80002676:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000267a:	8526                	mv	a0,s1
    8000267c:	ffffe097          	auipc	ra,0xffffe
    80002680:	622080e7          	jalr	1570(ra) # 80000c9e <release>
  sched();
    80002684:	00000097          	auipc	ra,0x0
    80002688:	ce6080e7          	jalr	-794(ra) # 8000236a <sched>
  panic("zombie exit");
    8000268c:	00006517          	auipc	a0,0x6
    80002690:	c4c50513          	addi	a0,a0,-948 # 800082d8 <digits+0x298>
    80002694:	ffffe097          	auipc	ra,0xffffe
    80002698:	eb0080e7          	jalr	-336(ra) # 80000544 <panic>

000000008000269c <scheduler>:
scheduler(void){
    8000269c:	7179                	addi	sp,sp,-48
    8000269e:	f406                	sd	ra,40(sp)
    800026a0:	f022                	sd	s0,32(sp)
    800026a2:	ec26                	sd	s1,24(sp)
    800026a4:	e84a                	sd	s2,16(sp)
    800026a6:	e44e                	sd	s3,8(sp)
    800026a8:	1800                	addi	s0,sp,48
    switch (sched_policy) {
    800026aa:	00006997          	auipc	s3,0x6
    800026ae:	25a98993          	addi	s3,s3,602 # 80008904 <sched_policy>
    800026b2:	4905                	li	s2,1
    800026b4:	4489                	li	s1,2
    800026b6:	0009a783          	lw	a5,0(s3)
    800026ba:	03278363          	beq	a5,s2,800026e0 <scheduler+0x44>
    800026be:	02978563          	beq	a5,s1,800026e8 <scheduler+0x4c>
    800026c2:	cb91                	beqz	a5,800026d6 <scheduler+0x3a>
      exit(1, "Scheduling policy was not set");
    800026c4:	00006597          	auipc	a1,0x6
    800026c8:	c2458593          	addi	a1,a1,-988 # 800082e8 <digits+0x2a8>
    800026cc:	4505                	li	a0,1
    800026ce:	00000097          	auipc	ra,0x0
    800026d2:	ee2080e7          	jalr	-286(ra) # 800025b0 <exit>
      original_scheduler();
    800026d6:	00000097          	auipc	ra,0x0
    800026da:	984080e7          	jalr	-1660(ra) # 8000205a <original_scheduler>
      break;
    800026de:	bfe1                	j	800026b6 <scheduler+0x1a>
      accumulator_scheduler();
    800026e0:	00000097          	auipc	ra,0x0
    800026e4:	a4e080e7          	jalr	-1458(ra) # 8000212e <accumulator_scheduler>
      cfs_scheduler();
    800026e8:	00000097          	auipc	ra,0x0
    800026ec:	b52080e7          	jalr	-1198(ra) # 8000223a <cfs_scheduler>

00000000800026f0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800026f0:	7179                	addi	sp,sp,-48
    800026f2:	f406                	sd	ra,40(sp)
    800026f4:	f022                	sd	s0,32(sp)
    800026f6:	ec26                	sd	s1,24(sp)
    800026f8:	e84a                	sd	s2,16(sp)
    800026fa:	e44e                	sd	s3,8(sp)
    800026fc:	1800                	addi	s0,sp,48
    800026fe:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002700:	0000f497          	auipc	s1,0xf
    80002704:	94048493          	addi	s1,s1,-1728 # 80011040 <proc>
    80002708:	00015997          	auipc	s3,0x15
    8000270c:	33898993          	addi	s3,s3,824 # 80017a40 <tickslock>
    acquire(&p->lock);
    80002710:	8526                	mv	a0,s1
    80002712:	ffffe097          	auipc	ra,0xffffe
    80002716:	4d8080e7          	jalr	1240(ra) # 80000bea <acquire>
    if(p->pid == pid){
    8000271a:	589c                	lw	a5,48(s1)
    8000271c:	01278d63          	beq	a5,s2,80002736 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002720:	8526                	mv	a0,s1
    80002722:	ffffe097          	auipc	ra,0xffffe
    80002726:	57c080e7          	jalr	1404(ra) # 80000c9e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000272a:	1a848493          	addi	s1,s1,424
    8000272e:	ff3491e3          	bne	s1,s3,80002710 <kill+0x20>
  }
  return -1;
    80002732:	557d                	li	a0,-1
    80002734:	a829                	j	8000274e <kill+0x5e>
      p->killed = 1;
    80002736:	4785                	li	a5,1
    80002738:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000273a:	4c98                	lw	a4,24(s1)
    8000273c:	4789                	li	a5,2
    8000273e:	00f70f63          	beq	a4,a5,8000275c <kill+0x6c>
      release(&p->lock);
    80002742:	8526                	mv	a0,s1
    80002744:	ffffe097          	auipc	ra,0xffffe
    80002748:	55a080e7          	jalr	1370(ra) # 80000c9e <release>
      return 0;
    8000274c:	4501                	li	a0,0
}
    8000274e:	70a2                	ld	ra,40(sp)
    80002750:	7402                	ld	s0,32(sp)
    80002752:	64e2                	ld	s1,24(sp)
    80002754:	6942                	ld	s2,16(sp)
    80002756:	69a2                	ld	s3,8(sp)
    80002758:	6145                	addi	sp,sp,48
    8000275a:	8082                	ret
        p->state = RUNNABLE;
    8000275c:	478d                	li	a5,3
    8000275e:	cc9c                	sw	a5,24(s1)
    80002760:	b7cd                	j	80002742 <kill+0x52>

0000000080002762 <setkilled>:

void
setkilled(struct proc *p)
{
    80002762:	1101                	addi	sp,sp,-32
    80002764:	ec06                	sd	ra,24(sp)
    80002766:	e822                	sd	s0,16(sp)
    80002768:	e426                	sd	s1,8(sp)
    8000276a:	1000                	addi	s0,sp,32
    8000276c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000276e:	ffffe097          	auipc	ra,0xffffe
    80002772:	47c080e7          	jalr	1148(ra) # 80000bea <acquire>
  p->killed = 1;
    80002776:	4785                	li	a5,1
    80002778:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000277a:	8526                	mv	a0,s1
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	522080e7          	jalr	1314(ra) # 80000c9e <release>
}
    80002784:	60e2                	ld	ra,24(sp)
    80002786:	6442                	ld	s0,16(sp)
    80002788:	64a2                	ld	s1,8(sp)
    8000278a:	6105                	addi	sp,sp,32
    8000278c:	8082                	ret

000000008000278e <killed>:

int
killed(struct proc *p)
{
    8000278e:	1101                	addi	sp,sp,-32
    80002790:	ec06                	sd	ra,24(sp)
    80002792:	e822                	sd	s0,16(sp)
    80002794:	e426                	sd	s1,8(sp)
    80002796:	e04a                	sd	s2,0(sp)
    80002798:	1000                	addi	s0,sp,32
    8000279a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000279c:	ffffe097          	auipc	ra,0xffffe
    800027a0:	44e080e7          	jalr	1102(ra) # 80000bea <acquire>
  k = p->killed;
    800027a4:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800027a8:	8526                	mv	a0,s1
    800027aa:	ffffe097          	auipc	ra,0xffffe
    800027ae:	4f4080e7          	jalr	1268(ra) # 80000c9e <release>
  return k;
}
    800027b2:	854a                	mv	a0,s2
    800027b4:	60e2                	ld	ra,24(sp)
    800027b6:	6442                	ld	s0,16(sp)
    800027b8:	64a2                	ld	s1,8(sp)
    800027ba:	6902                	ld	s2,0(sp)
    800027bc:	6105                	addi	sp,sp,32
    800027be:	8082                	ret

00000000800027c0 <wait>:
{
    800027c0:	711d                	addi	sp,sp,-96
    800027c2:	ec86                	sd	ra,88(sp)
    800027c4:	e8a2                	sd	s0,80(sp)
    800027c6:	e4a6                	sd	s1,72(sp)
    800027c8:	e0ca                	sd	s2,64(sp)
    800027ca:	fc4e                	sd	s3,56(sp)
    800027cc:	f852                	sd	s4,48(sp)
    800027ce:	f456                	sd	s5,40(sp)
    800027d0:	f05a                	sd	s6,32(sp)
    800027d2:	ec5e                	sd	s7,24(sp)
    800027d4:	e862                	sd	s8,16(sp)
    800027d6:	e466                	sd	s9,8(sp)
    800027d8:	1080                	addi	s0,sp,96
    800027da:	8baa                	mv	s7,a0
    800027dc:	8b2e                	mv	s6,a1
  struct proc *p = myproc();//parent
    800027de:	fffff097          	auipc	ra,0xfffff
    800027e2:	1fe080e7          	jalr	510(ra) # 800019dc <myproc>
    800027e6:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800027e8:	0000e517          	auipc	a0,0xe
    800027ec:	44050513          	addi	a0,a0,1088 # 80010c28 <wait_lock>
    800027f0:	ffffe097          	auipc	ra,0xffffe
    800027f4:	3fa080e7          	jalr	1018(ra) # 80000bea <acquire>
    havekids = 0;
    800027f8:	4c01                	li	s8,0
        if(pp->state == ZOMBIE){
    800027fa:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800027fc:	00015997          	auipc	s3,0x15
    80002800:	24498993          	addi	s3,s3,580 # 80017a40 <tickslock>
        havekids = 1;
    80002804:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002806:	0000ec97          	auipc	s9,0xe
    8000280a:	422c8c93          	addi	s9,s9,1058 # 80010c28 <wait_lock>
    havekids = 0;
    8000280e:	8762                	mv	a4,s8
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002810:	0000f497          	auipc	s1,0xf
    80002814:	83048493          	addi	s1,s1,-2000 # 80011040 <proc>
    80002818:	a86d                	j	800028d2 <wait+0x112>
          pid = pp->pid;
    8000281a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000281e:	040b9463          	bnez	s7,80002866 <wait+0xa6>
          if (msg != 0 && copyout(p->pagetable, msg, (char *)&pp->exit_msg,
    80002822:	000b0f63          	beqz	s6,80002840 <wait+0x80>
    80002826:	02000693          	li	a3,32
    8000282a:	03448613          	addi	a2,s1,52
    8000282e:	85da                	mv	a1,s6
    80002830:	09093503          	ld	a0,144(s2)
    80002834:	fffff097          	auipc	ra,0xfffff
    80002838:	e50080e7          	jalr	-432(ra) # 80001684 <copyout>
    8000283c:	06054063          	bltz	a0,8000289c <wait+0xdc>
          freeproc(pp);
    80002840:	8526                	mv	a0,s1
    80002842:	fffff097          	auipc	ra,0xfffff
    80002846:	4aa080e7          	jalr	1194(ra) # 80001cec <freeproc>
          release(&pp->lock);
    8000284a:	8526                	mv	a0,s1
    8000284c:	ffffe097          	auipc	ra,0xffffe
    80002850:	452080e7          	jalr	1106(ra) # 80000c9e <release>
          release(&wait_lock);
    80002854:	0000e517          	auipc	a0,0xe
    80002858:	3d450513          	addi	a0,a0,980 # 80010c28 <wait_lock>
    8000285c:	ffffe097          	auipc	ra,0xffffe
    80002860:	442080e7          	jalr	1090(ra) # 80000c9e <release>
          return pid;
    80002864:	a84d                	j	80002916 <wait+0x156>
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002866:	4691                	li	a3,4
    80002868:	02c48613          	addi	a2,s1,44
    8000286c:	85de                	mv	a1,s7
    8000286e:	09093503          	ld	a0,144(s2)
    80002872:	fffff097          	auipc	ra,0xfffff
    80002876:	e12080e7          	jalr	-494(ra) # 80001684 <copyout>
    8000287a:	fa0554e3          	bgez	a0,80002822 <wait+0x62>
            release(&pp->lock);
    8000287e:	8526                	mv	a0,s1
    80002880:	ffffe097          	auipc	ra,0xffffe
    80002884:	41e080e7          	jalr	1054(ra) # 80000c9e <release>
            release(&wait_lock);
    80002888:	0000e517          	auipc	a0,0xe
    8000288c:	3a050513          	addi	a0,a0,928 # 80010c28 <wait_lock>
    80002890:	ffffe097          	auipc	ra,0xffffe
    80002894:	40e080e7          	jalr	1038(ra) # 80000c9e <release>
            return -1;
    80002898:	59fd                	li	s3,-1
    8000289a:	a8b5                	j	80002916 <wait+0x156>
            printf("copyout failed\n");
    8000289c:	00006517          	auipc	a0,0x6
    800028a0:	a6c50513          	addi	a0,a0,-1428 # 80008308 <digits+0x2c8>
    800028a4:	ffffe097          	auipc	ra,0xffffe
    800028a8:	cea080e7          	jalr	-790(ra) # 8000058e <printf>
            release(&pp->lock);
    800028ac:	8526                	mv	a0,s1
    800028ae:	ffffe097          	auipc	ra,0xffffe
    800028b2:	3f0080e7          	jalr	1008(ra) # 80000c9e <release>
            release(&wait_lock);
    800028b6:	0000e517          	auipc	a0,0xe
    800028ba:	37250513          	addi	a0,a0,882 # 80010c28 <wait_lock>
    800028be:	ffffe097          	auipc	ra,0xffffe
    800028c2:	3e0080e7          	jalr	992(ra) # 80000c9e <release>
            return -1;
    800028c6:	59fd                	li	s3,-1
    800028c8:	a0b9                	j	80002916 <wait+0x156>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800028ca:	1a848493          	addi	s1,s1,424
    800028ce:	03348463          	beq	s1,s3,800028f6 <wait+0x136>
      if(pp->parent == p){
    800028d2:	7cbc                	ld	a5,120(s1)
    800028d4:	ff279be3          	bne	a5,s2,800028ca <wait+0x10a>
        acquire(&pp->lock);
    800028d8:	8526                	mv	a0,s1
    800028da:	ffffe097          	auipc	ra,0xffffe
    800028de:	310080e7          	jalr	784(ra) # 80000bea <acquire>
        if(pp->state == ZOMBIE){
    800028e2:	4c9c                	lw	a5,24(s1)
    800028e4:	f3478be3          	beq	a5,s4,8000281a <wait+0x5a>
        release(&pp->lock);
    800028e8:	8526                	mv	a0,s1
    800028ea:	ffffe097          	auipc	ra,0xffffe
    800028ee:	3b4080e7          	jalr	948(ra) # 80000c9e <release>
        havekids = 1;
    800028f2:	8756                	mv	a4,s5
    800028f4:	bfd9                	j	800028ca <wait+0x10a>
    if(!havekids || killed(p)){
    800028f6:	c719                	beqz	a4,80002904 <wait+0x144>
    800028f8:	854a                	mv	a0,s2
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	e94080e7          	jalr	-364(ra) # 8000278e <killed>
    80002902:	c905                	beqz	a0,80002932 <wait+0x172>
      release(&wait_lock);
    80002904:	0000e517          	auipc	a0,0xe
    80002908:	32450513          	addi	a0,a0,804 # 80010c28 <wait_lock>
    8000290c:	ffffe097          	auipc	ra,0xffffe
    80002910:	392080e7          	jalr	914(ra) # 80000c9e <release>
      return -1;
    80002914:	59fd                	li	s3,-1
}
    80002916:	854e                	mv	a0,s3
    80002918:	60e6                	ld	ra,88(sp)
    8000291a:	6446                	ld	s0,80(sp)
    8000291c:	64a6                	ld	s1,72(sp)
    8000291e:	6906                	ld	s2,64(sp)
    80002920:	79e2                	ld	s3,56(sp)
    80002922:	7a42                	ld	s4,48(sp)
    80002924:	7aa2                	ld	s5,40(sp)
    80002926:	7b02                	ld	s6,32(sp)
    80002928:	6be2                	ld	s7,24(sp)
    8000292a:	6c42                	ld	s8,16(sp)
    8000292c:	6ca2                	ld	s9,8(sp)
    8000292e:	6125                	addi	sp,sp,96
    80002930:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002932:	85e6                	mv	a1,s9
    80002934:	854a                	mv	a0,s2
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	b46080e7          	jalr	-1210(ra) # 8000247c <sleep>
    havekids = 0;
    8000293e:	bdc1                	j	8000280e <wait+0x4e>

0000000080002940 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002940:	7179                	addi	sp,sp,-48
    80002942:	f406                	sd	ra,40(sp)
    80002944:	f022                	sd	s0,32(sp)
    80002946:	ec26                	sd	s1,24(sp)
    80002948:	e84a                	sd	s2,16(sp)
    8000294a:	e44e                	sd	s3,8(sp)
    8000294c:	e052                	sd	s4,0(sp)
    8000294e:	1800                	addi	s0,sp,48
    80002950:	84aa                	mv	s1,a0
    80002952:	892e                	mv	s2,a1
    80002954:	89b2                	mv	s3,a2
    80002956:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002958:	fffff097          	auipc	ra,0xfffff
    8000295c:	084080e7          	jalr	132(ra) # 800019dc <myproc>
  if(user_dst){
    80002960:	c08d                	beqz	s1,80002982 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002962:	86d2                	mv	a3,s4
    80002964:	864e                	mv	a2,s3
    80002966:	85ca                	mv	a1,s2
    80002968:	6948                	ld	a0,144(a0)
    8000296a:	fffff097          	auipc	ra,0xfffff
    8000296e:	d1a080e7          	jalr	-742(ra) # 80001684 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002972:	70a2                	ld	ra,40(sp)
    80002974:	7402                	ld	s0,32(sp)
    80002976:	64e2                	ld	s1,24(sp)
    80002978:	6942                	ld	s2,16(sp)
    8000297a:	69a2                	ld	s3,8(sp)
    8000297c:	6a02                	ld	s4,0(sp)
    8000297e:	6145                	addi	sp,sp,48
    80002980:	8082                	ret
    memmove((char *)dst, src, len);
    80002982:	000a061b          	sext.w	a2,s4
    80002986:	85ce                	mv	a1,s3
    80002988:	854a                	mv	a0,s2
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	3bc080e7          	jalr	956(ra) # 80000d46 <memmove>
    return 0;
    80002992:	8526                	mv	a0,s1
    80002994:	bff9                	j	80002972 <either_copyout+0x32>

0000000080002996 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002996:	7179                	addi	sp,sp,-48
    80002998:	f406                	sd	ra,40(sp)
    8000299a:	f022                	sd	s0,32(sp)
    8000299c:	ec26                	sd	s1,24(sp)
    8000299e:	e84a                	sd	s2,16(sp)
    800029a0:	e44e                	sd	s3,8(sp)
    800029a2:	e052                	sd	s4,0(sp)
    800029a4:	1800                	addi	s0,sp,48
    800029a6:	892a                	mv	s2,a0
    800029a8:	84ae                	mv	s1,a1
    800029aa:	89b2                	mv	s3,a2
    800029ac:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800029ae:	fffff097          	auipc	ra,0xfffff
    800029b2:	02e080e7          	jalr	46(ra) # 800019dc <myproc>
  if(user_src){
    800029b6:	c08d                	beqz	s1,800029d8 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800029b8:	86d2                	mv	a3,s4
    800029ba:	864e                	mv	a2,s3
    800029bc:	85ca                	mv	a1,s2
    800029be:	6948                	ld	a0,144(a0)
    800029c0:	fffff097          	auipc	ra,0xfffff
    800029c4:	d50080e7          	jalr	-688(ra) # 80001710 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800029c8:	70a2                	ld	ra,40(sp)
    800029ca:	7402                	ld	s0,32(sp)
    800029cc:	64e2                	ld	s1,24(sp)
    800029ce:	6942                	ld	s2,16(sp)
    800029d0:	69a2                	ld	s3,8(sp)
    800029d2:	6a02                	ld	s4,0(sp)
    800029d4:	6145                	addi	sp,sp,48
    800029d6:	8082                	ret
    memmove(dst, (char*)src, len);
    800029d8:	000a061b          	sext.w	a2,s4
    800029dc:	85ce                	mv	a1,s3
    800029de:	854a                	mv	a0,s2
    800029e0:	ffffe097          	auipc	ra,0xffffe
    800029e4:	366080e7          	jalr	870(ra) # 80000d46 <memmove>
    return 0;
    800029e8:	8526                	mv	a0,s1
    800029ea:	bff9                	j	800029c8 <either_copyin+0x32>

00000000800029ec <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800029ec:	715d                	addi	sp,sp,-80
    800029ee:	e486                	sd	ra,72(sp)
    800029f0:	e0a2                	sd	s0,64(sp)
    800029f2:	fc26                	sd	s1,56(sp)
    800029f4:	f84a                	sd	s2,48(sp)
    800029f6:	f44e                	sd	s3,40(sp)
    800029f8:	f052                	sd	s4,32(sp)
    800029fa:	ec56                	sd	s5,24(sp)
    800029fc:	e85a                	sd	s6,16(sp)
    800029fe:	e45e                	sd	s7,8(sp)
    80002a00:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002a02:	00005517          	auipc	a0,0x5
    80002a06:	6c650513          	addi	a0,a0,1734 # 800080c8 <digits+0x88>
    80002a0a:	ffffe097          	auipc	ra,0xffffe
    80002a0e:	b84080e7          	jalr	-1148(ra) # 8000058e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a12:	0000e497          	auipc	s1,0xe
    80002a16:	7c648493          	addi	s1,s1,1990 # 800111d8 <proc+0x198>
    80002a1a:	00015917          	auipc	s2,0x15
    80002a1e:	1be90913          	addi	s2,s2,446 # 80017bd8 <bcache+0x180>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a22:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002a24:	00006997          	auipc	s3,0x6
    80002a28:	8f498993          	addi	s3,s3,-1804 # 80008318 <digits+0x2d8>
    printf("%d %s %s", p->pid, state, p->name);
    80002a2c:	00006a97          	auipc	s5,0x6
    80002a30:	8f4a8a93          	addi	s5,s5,-1804 # 80008320 <digits+0x2e0>
    printf("\n");
    80002a34:	00005a17          	auipc	s4,0x5
    80002a38:	694a0a13          	addi	s4,s4,1684 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a3c:	00006b97          	auipc	s7,0x6
    80002a40:	924b8b93          	addi	s7,s7,-1756 # 80008360 <states.1817>
    80002a44:	a00d                	j	80002a66 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002a46:	e986a583          	lw	a1,-360(a3)
    80002a4a:	8556                	mv	a0,s5
    80002a4c:	ffffe097          	auipc	ra,0xffffe
    80002a50:	b42080e7          	jalr	-1214(ra) # 8000058e <printf>
    printf("\n");
    80002a54:	8552                	mv	a0,s4
    80002a56:	ffffe097          	auipc	ra,0xffffe
    80002a5a:	b38080e7          	jalr	-1224(ra) # 8000058e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a5e:	1a848493          	addi	s1,s1,424
    80002a62:	03248163          	beq	s1,s2,80002a84 <procdump+0x98>
    if(p->state == UNUSED)
    80002a66:	86a6                	mv	a3,s1
    80002a68:	e804a783          	lw	a5,-384(s1)
    80002a6c:	dbed                	beqz	a5,80002a5e <procdump+0x72>
      state = "???";
    80002a6e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a70:	fcfb6be3          	bltu	s6,a5,80002a46 <procdump+0x5a>
    80002a74:	1782                	slli	a5,a5,0x20
    80002a76:	9381                	srli	a5,a5,0x20
    80002a78:	078e                	slli	a5,a5,0x3
    80002a7a:	97de                	add	a5,a5,s7
    80002a7c:	6390                	ld	a2,0(a5)
    80002a7e:	f661                	bnez	a2,80002a46 <procdump+0x5a>
      state = "???";
    80002a80:	864e                	mv	a2,s3
    80002a82:	b7d1                	j	80002a46 <procdump+0x5a>
  }
}
    80002a84:	60a6                	ld	ra,72(sp)
    80002a86:	6406                	ld	s0,64(sp)
    80002a88:	74e2                	ld	s1,56(sp)
    80002a8a:	7942                	ld	s2,48(sp)
    80002a8c:	79a2                	ld	s3,40(sp)
    80002a8e:	7a02                	ld	s4,32(sp)
    80002a90:	6ae2                	ld	s5,24(sp)
    80002a92:	6b42                	ld	s6,16(sp)
    80002a94:	6ba2                	ld	s7,8(sp)
    80002a96:	6161                	addi	sp,sp,80
    80002a98:	8082                	ret

0000000080002a9a <swtch>:
    80002a9a:	00153023          	sd	ra,0(a0)
    80002a9e:	00253423          	sd	sp,8(a0)
    80002aa2:	e900                	sd	s0,16(a0)
    80002aa4:	ed04                	sd	s1,24(a0)
    80002aa6:	03253023          	sd	s2,32(a0)
    80002aaa:	03353423          	sd	s3,40(a0)
    80002aae:	03453823          	sd	s4,48(a0)
    80002ab2:	03553c23          	sd	s5,56(a0)
    80002ab6:	05653023          	sd	s6,64(a0)
    80002aba:	05753423          	sd	s7,72(a0)
    80002abe:	05853823          	sd	s8,80(a0)
    80002ac2:	05953c23          	sd	s9,88(a0)
    80002ac6:	07a53023          	sd	s10,96(a0)
    80002aca:	07b53423          	sd	s11,104(a0)
    80002ace:	0005b083          	ld	ra,0(a1)
    80002ad2:	0085b103          	ld	sp,8(a1)
    80002ad6:	6980                	ld	s0,16(a1)
    80002ad8:	6d84                	ld	s1,24(a1)
    80002ada:	0205b903          	ld	s2,32(a1)
    80002ade:	0285b983          	ld	s3,40(a1)
    80002ae2:	0305ba03          	ld	s4,48(a1)
    80002ae6:	0385ba83          	ld	s5,56(a1)
    80002aea:	0405bb03          	ld	s6,64(a1)
    80002aee:	0485bb83          	ld	s7,72(a1)
    80002af2:	0505bc03          	ld	s8,80(a1)
    80002af6:	0585bc83          	ld	s9,88(a1)
    80002afa:	0605bd03          	ld	s10,96(a1)
    80002afe:	0685bd83          	ld	s11,104(a1)
    80002b02:	8082                	ret

0000000080002b04 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002b04:	1141                	addi	sp,sp,-16
    80002b06:	e406                	sd	ra,8(sp)
    80002b08:	e022                	sd	s0,0(sp)
    80002b0a:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b0c:	00006597          	auipc	a1,0x6
    80002b10:	88458593          	addi	a1,a1,-1916 # 80008390 <states.1817+0x30>
    80002b14:	00015517          	auipc	a0,0x15
    80002b18:	f2c50513          	addi	a0,a0,-212 # 80017a40 <tickslock>
    80002b1c:	ffffe097          	auipc	ra,0xffffe
    80002b20:	03e080e7          	jalr	62(ra) # 80000b5a <initlock>
}
    80002b24:	60a2                	ld	ra,8(sp)
    80002b26:	6402                	ld	s0,0(sp)
    80002b28:	0141                	addi	sp,sp,16
    80002b2a:	8082                	ret

0000000080002b2c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002b2c:	1141                	addi	sp,sp,-16
    80002b2e:	e422                	sd	s0,8(sp)
    80002b30:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b32:	00003797          	auipc	a5,0x3
    80002b36:	63e78793          	addi	a5,a5,1598 # 80006170 <kernelvec>
    80002b3a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002b3e:	6422                	ld	s0,8(sp)
    80002b40:	0141                	addi	sp,sp,16
    80002b42:	8082                	ret

0000000080002b44 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002b44:	1141                	addi	sp,sp,-16
    80002b46:	e406                	sd	ra,8(sp)
    80002b48:	e022                	sd	s0,0(sp)
    80002b4a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b4c:	fffff097          	auipc	ra,0xfffff
    80002b50:	e90080e7          	jalr	-368(ra) # 800019dc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b54:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002b58:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b5a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002b5e:	00004617          	auipc	a2,0x4
    80002b62:	4a260613          	addi	a2,a2,1186 # 80007000 <_trampoline>
    80002b66:	00004697          	auipc	a3,0x4
    80002b6a:	49a68693          	addi	a3,a3,1178 # 80007000 <_trampoline>
    80002b6e:	8e91                	sub	a3,a3,a2
    80002b70:	040007b7          	lui	a5,0x4000
    80002b74:	17fd                	addi	a5,a5,-1
    80002b76:	07b2                	slli	a5,a5,0xc
    80002b78:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002b7a:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b7e:	6d58                	ld	a4,152(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002b80:	180026f3          	csrr	a3,satp
    80002b84:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b86:	6d58                	ld	a4,152(a0)
    80002b88:	6154                	ld	a3,128(a0)
    80002b8a:	6585                	lui	a1,0x1
    80002b8c:	96ae                	add	a3,a3,a1
    80002b8e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b90:	6d58                	ld	a4,152(a0)
    80002b92:	00000697          	auipc	a3,0x0
    80002b96:	14668693          	addi	a3,a3,326 # 80002cd8 <usertrap>
    80002b9a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002b9c:	6d58                	ld	a4,152(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002b9e:	8692                	mv	a3,tp
    80002ba0:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ba2:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002ba6:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002baa:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002bae:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002bb2:	6d58                	ld	a4,152(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002bb4:	6f18                	ld	a4,24(a4)
    80002bb6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002bba:	6948                	ld	a0,144(a0)
    80002bbc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002bbe:	00004717          	auipc	a4,0x4
    80002bc2:	4de70713          	addi	a4,a4,1246 # 8000709c <userret>
    80002bc6:	8f11                	sub	a4,a4,a2
    80002bc8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002bca:	577d                	li	a4,-1
    80002bcc:	177e                	slli	a4,a4,0x3f
    80002bce:	8d59                	or	a0,a0,a4
    80002bd0:	9782                	jalr	a5
}
    80002bd2:	60a2                	ld	ra,8(sp)
    80002bd4:	6402                	ld	s0,0(sp)
    80002bd6:	0141                	addi	sp,sp,16
    80002bd8:	8082                	ret

0000000080002bda <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002bda:	1101                	addi	sp,sp,-32
    80002bdc:	ec06                	sd	ra,24(sp)
    80002bde:	e822                	sd	s0,16(sp)
    80002be0:	e426                	sd	s1,8(sp)
    80002be2:	e04a                	sd	s2,0(sp)
    80002be4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002be6:	00015917          	auipc	s2,0x15
    80002bea:	e5a90913          	addi	s2,s2,-422 # 80017a40 <tickslock>
    80002bee:	854a                	mv	a0,s2
    80002bf0:	ffffe097          	auipc	ra,0xffffe
    80002bf4:	ffa080e7          	jalr	-6(ra) # 80000bea <acquire>
  ticks++;
    80002bf8:	00006497          	auipc	s1,0x6
    80002bfc:	db048493          	addi	s1,s1,-592 # 800089a8 <ticks>
    80002c00:	409c                	lw	a5,0(s1)
    80002c02:	2785                	addiw	a5,a5,1
    80002c04:	c09c                	sw	a5,0(s1)
  increment_tick();
    80002c06:	fffff097          	auipc	ra,0xfffff
    80002c0a:	e0e080e7          	jalr	-498(ra) # 80001a14 <increment_tick>
  wakeup(&ticks);
    80002c0e:	8526                	mv	a0,s1
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	8d0080e7          	jalr	-1840(ra) # 800024e0 <wakeup>
  increment_tick();
    80002c18:	fffff097          	auipc	ra,0xfffff
    80002c1c:	dfc080e7          	jalr	-516(ra) # 80001a14 <increment_tick>
  release(&tickslock);
    80002c20:	854a                	mv	a0,s2
    80002c22:	ffffe097          	auipc	ra,0xffffe
    80002c26:	07c080e7          	jalr	124(ra) # 80000c9e <release>
}
    80002c2a:	60e2                	ld	ra,24(sp)
    80002c2c:	6442                	ld	s0,16(sp)
    80002c2e:	64a2                	ld	s1,8(sp)
    80002c30:	6902                	ld	s2,0(sp)
    80002c32:	6105                	addi	sp,sp,32
    80002c34:	8082                	ret

0000000080002c36 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002c36:	1101                	addi	sp,sp,-32
    80002c38:	ec06                	sd	ra,24(sp)
    80002c3a:	e822                	sd	s0,16(sp)
    80002c3c:	e426                	sd	s1,8(sp)
    80002c3e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002c40:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002c44:	00074d63          	bltz	a4,80002c5e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002c48:	57fd                	li	a5,-1
    80002c4a:	17fe                	slli	a5,a5,0x3f
    80002c4c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002c4e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002c50:	06f70363          	beq	a4,a5,80002cb6 <devintr+0x80>
  }
}
    80002c54:	60e2                	ld	ra,24(sp)
    80002c56:	6442                	ld	s0,16(sp)
    80002c58:	64a2                	ld	s1,8(sp)
    80002c5a:	6105                	addi	sp,sp,32
    80002c5c:	8082                	ret
     (scause & 0xff) == 9){
    80002c5e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80002c62:	46a5                	li	a3,9
    80002c64:	fed792e3          	bne	a5,a3,80002c48 <devintr+0x12>
    int irq = plic_claim();
    80002c68:	00003097          	auipc	ra,0x3
    80002c6c:	610080e7          	jalr	1552(ra) # 80006278 <plic_claim>
    80002c70:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002c72:	47a9                	li	a5,10
    80002c74:	02f50763          	beq	a0,a5,80002ca2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002c78:	4785                	li	a5,1
    80002c7a:	02f50963          	beq	a0,a5,80002cac <devintr+0x76>
    return 1;
    80002c7e:	4505                	li	a0,1
    } else if(irq){
    80002c80:	d8f1                	beqz	s1,80002c54 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002c82:	85a6                	mv	a1,s1
    80002c84:	00005517          	auipc	a0,0x5
    80002c88:	71450513          	addi	a0,a0,1812 # 80008398 <states.1817+0x38>
    80002c8c:	ffffe097          	auipc	ra,0xffffe
    80002c90:	902080e7          	jalr	-1790(ra) # 8000058e <printf>
      plic_complete(irq);
    80002c94:	8526                	mv	a0,s1
    80002c96:	00003097          	auipc	ra,0x3
    80002c9a:	606080e7          	jalr	1542(ra) # 8000629c <plic_complete>
    return 1;
    80002c9e:	4505                	li	a0,1
    80002ca0:	bf55                	j	80002c54 <devintr+0x1e>
      uartintr();
    80002ca2:	ffffe097          	auipc	ra,0xffffe
    80002ca6:	d0c080e7          	jalr	-756(ra) # 800009ae <uartintr>
    80002caa:	b7ed                	j	80002c94 <devintr+0x5e>
      virtio_disk_intr();
    80002cac:	00004097          	auipc	ra,0x4
    80002cb0:	b1a080e7          	jalr	-1254(ra) # 800067c6 <virtio_disk_intr>
    80002cb4:	b7c5                	j	80002c94 <devintr+0x5e>
    if(cpuid() == 0){
    80002cb6:	fffff097          	auipc	ra,0xfffff
    80002cba:	cfa080e7          	jalr	-774(ra) # 800019b0 <cpuid>
    80002cbe:	c901                	beqz	a0,80002cce <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002cc0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002cc4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002cc6:	14479073          	csrw	sip,a5
    return 2;
    80002cca:	4509                	li	a0,2
    80002ccc:	b761                	j	80002c54 <devintr+0x1e>
      clockintr();
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	f0c080e7          	jalr	-244(ra) # 80002bda <clockintr>
    80002cd6:	b7ed                	j	80002cc0 <devintr+0x8a>

0000000080002cd8 <usertrap>:
{
    80002cd8:	1101                	addi	sp,sp,-32
    80002cda:	ec06                	sd	ra,24(sp)
    80002cdc:	e822                	sd	s0,16(sp)
    80002cde:	e426                	sd	s1,8(sp)
    80002ce0:	e04a                	sd	s2,0(sp)
    80002ce2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ce4:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002ce8:	1007f793          	andi	a5,a5,256
    80002cec:	e3b1                	bnez	a5,80002d30 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002cee:	00003797          	auipc	a5,0x3
    80002cf2:	48278793          	addi	a5,a5,1154 # 80006170 <kernelvec>
    80002cf6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002cfa:	fffff097          	auipc	ra,0xfffff
    80002cfe:	ce2080e7          	jalr	-798(ra) # 800019dc <myproc>
    80002d02:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002d04:	6d5c                	ld	a5,152(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d06:	14102773          	csrr	a4,sepc
    80002d0a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d0c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002d10:	47a1                	li	a5,8
    80002d12:	02f70763          	beq	a4,a5,80002d40 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	f20080e7          	jalr	-224(ra) # 80002c36 <devintr>
    80002d1e:	892a                	mv	s2,a0
    80002d20:	c951                	beqz	a0,80002db4 <usertrap+0xdc>
  if(killed(p))
    80002d22:	8526                	mv	a0,s1
    80002d24:	00000097          	auipc	ra,0x0
    80002d28:	a6a080e7          	jalr	-1430(ra) # 8000278e <killed>
    80002d2c:	cd29                	beqz	a0,80002d86 <usertrap+0xae>
    80002d2e:	a099                	j	80002d74 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002d30:	00005517          	auipc	a0,0x5
    80002d34:	68850513          	addi	a0,a0,1672 # 800083b8 <states.1817+0x58>
    80002d38:	ffffe097          	auipc	ra,0xffffe
    80002d3c:	80c080e7          	jalr	-2036(ra) # 80000544 <panic>
    if(killed(p))
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	a4e080e7          	jalr	-1458(ra) # 8000278e <killed>
    80002d48:	ed21                	bnez	a0,80002da0 <usertrap+0xc8>
    p->trapframe->epc += 4;
    80002d4a:	6cd8                	ld	a4,152(s1)
    80002d4c:	6f1c                	ld	a5,24(a4)
    80002d4e:	0791                	addi	a5,a5,4
    80002d50:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002d56:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002d5a:	10079073          	csrw	sstatus,a5
    syscall();
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	31e080e7          	jalr	798(ra) # 8000307c <syscall>
  if(killed(p))
    80002d66:	8526                	mv	a0,s1
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	a26080e7          	jalr	-1498(ra) # 8000278e <killed>
    80002d70:	cd11                	beqz	a0,80002d8c <usertrap+0xb4>
    80002d72:	4901                	li	s2,0
    exit(-1,"");
    80002d74:	00005597          	auipc	a1,0x5
    80002d78:	4ec58593          	addi	a1,a1,1260 # 80008260 <digits+0x220>
    80002d7c:	557d                	li	a0,-1
    80002d7e:	00000097          	auipc	ra,0x0
    80002d82:	832080e7          	jalr	-1998(ra) # 800025b0 <exit>
  if(which_dev == 2){
    80002d86:	4789                	li	a5,2
    80002d88:	06f90363          	beq	s2,a5,80002dee <usertrap+0x116>
  usertrapret();
    80002d8c:	00000097          	auipc	ra,0x0
    80002d90:	db8080e7          	jalr	-584(ra) # 80002b44 <usertrapret>
}
    80002d94:	60e2                	ld	ra,24(sp)
    80002d96:	6442                	ld	s0,16(sp)
    80002d98:	64a2                	ld	s1,8(sp)
    80002d9a:	6902                	ld	s2,0(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret
      exit(-1,"");
    80002da0:	00005597          	auipc	a1,0x5
    80002da4:	4c058593          	addi	a1,a1,1216 # 80008260 <digits+0x220>
    80002da8:	557d                	li	a0,-1
    80002daa:	00000097          	auipc	ra,0x0
    80002dae:	806080e7          	jalr	-2042(ra) # 800025b0 <exit>
    80002db2:	bf61                	j	80002d4a <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002db4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002db8:	5890                	lw	a2,48(s1)
    80002dba:	00005517          	auipc	a0,0x5
    80002dbe:	61e50513          	addi	a0,a0,1566 # 800083d8 <states.1817+0x78>
    80002dc2:	ffffd097          	auipc	ra,0xffffd
    80002dc6:	7cc080e7          	jalr	1996(ra) # 8000058e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002dca:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002dce:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002dd2:	00005517          	auipc	a0,0x5
    80002dd6:	63650513          	addi	a0,a0,1590 # 80008408 <states.1817+0xa8>
    80002dda:	ffffd097          	auipc	ra,0xffffd
    80002dde:	7b4080e7          	jalr	1972(ra) # 8000058e <printf>
    setkilled(p);
    80002de2:	8526                	mv	a0,s1
    80002de4:	00000097          	auipc	ra,0x0
    80002de8:	97e080e7          	jalr	-1666(ra) # 80002762 <setkilled>
    80002dec:	bfad                	j	80002d66 <usertrap+0x8e>
    struct proc* my_p = myproc();
    80002dee:	fffff097          	auipc	ra,0xfffff
    80002df2:	bee080e7          	jalr	-1042(ra) # 800019dc <myproc>
    my_p->accumulator += my_p->ps_priority;
    80002df6:	5138                	lw	a4,96(a0)
    80002df8:	6d3c                	ld	a5,88(a0)
    80002dfa:	97ba                	add	a5,a5,a4
    80002dfc:	ed3c                	sd	a5,88(a0)
    increment_tick();
    80002dfe:	fffff097          	auipc	ra,0xfffff
    80002e02:	c16080e7          	jalr	-1002(ra) # 80001a14 <increment_tick>
    yield();
    80002e06:	fffff097          	auipc	ra,0xfffff
    80002e0a:	63a080e7          	jalr	1594(ra) # 80002440 <yield>
    80002e0e:	bfbd                	j	80002d8c <usertrap+0xb4>

0000000080002e10 <kerneltrap>:
{
    80002e10:	7179                	addi	sp,sp,-48
    80002e12:	f406                	sd	ra,40(sp)
    80002e14:	f022                	sd	s0,32(sp)
    80002e16:	ec26                	sd	s1,24(sp)
    80002e18:	e84a                	sd	s2,16(sp)
    80002e1a:	e44e                	sd	s3,8(sp)
    80002e1c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e1e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e22:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e26:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002e2a:	1004f793          	andi	a5,s1,256
    80002e2e:	cb85                	beqz	a5,80002e5e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e30:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002e34:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002e36:	ef85                	bnez	a5,80002e6e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002e38:	00000097          	auipc	ra,0x0
    80002e3c:	dfe080e7          	jalr	-514(ra) # 80002c36 <devintr>
    80002e40:	cd1d                	beqz	a0,80002e7e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING){
    80002e42:	4789                	li	a5,2
    80002e44:	06f50a63          	beq	a0,a5,80002eb8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e48:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e4c:	10049073          	csrw	sstatus,s1
}
    80002e50:	70a2                	ld	ra,40(sp)
    80002e52:	7402                	ld	s0,32(sp)
    80002e54:	64e2                	ld	s1,24(sp)
    80002e56:	6942                	ld	s2,16(sp)
    80002e58:	69a2                	ld	s3,8(sp)
    80002e5a:	6145                	addi	sp,sp,48
    80002e5c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002e5e:	00005517          	auipc	a0,0x5
    80002e62:	5ca50513          	addi	a0,a0,1482 # 80008428 <states.1817+0xc8>
    80002e66:	ffffd097          	auipc	ra,0xffffd
    80002e6a:	6de080e7          	jalr	1758(ra) # 80000544 <panic>
    panic("kerneltrap: interrupts enabled");
    80002e6e:	00005517          	auipc	a0,0x5
    80002e72:	5e250513          	addi	a0,a0,1506 # 80008450 <states.1817+0xf0>
    80002e76:	ffffd097          	auipc	ra,0xffffd
    80002e7a:	6ce080e7          	jalr	1742(ra) # 80000544 <panic>
    printf("scause %p\n", scause);
    80002e7e:	85ce                	mv	a1,s3
    80002e80:	00005517          	auipc	a0,0x5
    80002e84:	5f050513          	addi	a0,a0,1520 # 80008470 <states.1817+0x110>
    80002e88:	ffffd097          	auipc	ra,0xffffd
    80002e8c:	706080e7          	jalr	1798(ra) # 8000058e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e90:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e94:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002e98:	00005517          	auipc	a0,0x5
    80002e9c:	5e850513          	addi	a0,a0,1512 # 80008480 <states.1817+0x120>
    80002ea0:	ffffd097          	auipc	ra,0xffffd
    80002ea4:	6ee080e7          	jalr	1774(ra) # 8000058e <printf>
    panic("kerneltrap");
    80002ea8:	00005517          	auipc	a0,0x5
    80002eac:	5f050513          	addi	a0,a0,1520 # 80008498 <states.1817+0x138>
    80002eb0:	ffffd097          	auipc	ra,0xffffd
    80002eb4:	694080e7          	jalr	1684(ra) # 80000544 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING){
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	b24080e7          	jalr	-1244(ra) # 800019dc <myproc>
    80002ec0:	d541                	beqz	a0,80002e48 <kerneltrap+0x38>
    80002ec2:	fffff097          	auipc	ra,0xfffff
    80002ec6:	b1a080e7          	jalr	-1254(ra) # 800019dc <myproc>
    80002eca:	4d18                	lw	a4,24(a0)
    80002ecc:	4791                	li	a5,4
    80002ece:	f6f71de3          	bne	a4,a5,80002e48 <kerneltrap+0x38>
    myproc()->accumulator += myproc()->ps_priority;
    80002ed2:	fffff097          	auipc	ra,0xfffff
    80002ed6:	b0a080e7          	jalr	-1270(ra) # 800019dc <myproc>
    80002eda:	06052983          	lw	s3,96(a0)
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	afe080e7          	jalr	-1282(ra) # 800019dc <myproc>
    80002ee6:	6d3c                	ld	a5,88(a0)
    80002ee8:	97ce                	add	a5,a5,s3
    80002eea:	ed3c                	sd	a5,88(a0)
    increment_tick();
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	b28080e7          	jalr	-1240(ra) # 80001a14 <increment_tick>
    yield();
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	54c080e7          	jalr	1356(ra) # 80002440 <yield>
    80002efc:	b7b1                	j	80002e48 <kerneltrap+0x38>

0000000080002efe <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002efe:	1101                	addi	sp,sp,-32
    80002f00:	ec06                	sd	ra,24(sp)
    80002f02:	e822                	sd	s0,16(sp)
    80002f04:	e426                	sd	s1,8(sp)
    80002f06:	1000                	addi	s0,sp,32
    80002f08:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002f0a:	fffff097          	auipc	ra,0xfffff
    80002f0e:	ad2080e7          	jalr	-1326(ra) # 800019dc <myproc>
  switch (n) {
    80002f12:	4795                	li	a5,5
    80002f14:	0497e163          	bltu	a5,s1,80002f56 <argraw+0x58>
    80002f18:	048a                	slli	s1,s1,0x2
    80002f1a:	00005717          	auipc	a4,0x5
    80002f1e:	5b670713          	addi	a4,a4,1462 # 800084d0 <states.1817+0x170>
    80002f22:	94ba                	add	s1,s1,a4
    80002f24:	409c                	lw	a5,0(s1)
    80002f26:	97ba                	add	a5,a5,a4
    80002f28:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002f2a:	6d5c                	ld	a5,152(a0)
    80002f2c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002f2e:	60e2                	ld	ra,24(sp)
    80002f30:	6442                	ld	s0,16(sp)
    80002f32:	64a2                	ld	s1,8(sp)
    80002f34:	6105                	addi	sp,sp,32
    80002f36:	8082                	ret
    return p->trapframe->a1;
    80002f38:	6d5c                	ld	a5,152(a0)
    80002f3a:	7fa8                	ld	a0,120(a5)
    80002f3c:	bfcd                	j	80002f2e <argraw+0x30>
    return p->trapframe->a2;
    80002f3e:	6d5c                	ld	a5,152(a0)
    80002f40:	63c8                	ld	a0,128(a5)
    80002f42:	b7f5                	j	80002f2e <argraw+0x30>
    return p->trapframe->a3;
    80002f44:	6d5c                	ld	a5,152(a0)
    80002f46:	67c8                	ld	a0,136(a5)
    80002f48:	b7dd                	j	80002f2e <argraw+0x30>
    return p->trapframe->a4;
    80002f4a:	6d5c                	ld	a5,152(a0)
    80002f4c:	6bc8                	ld	a0,144(a5)
    80002f4e:	b7c5                	j	80002f2e <argraw+0x30>
    return p->trapframe->a5;
    80002f50:	6d5c                	ld	a5,152(a0)
    80002f52:	6fc8                	ld	a0,152(a5)
    80002f54:	bfe9                	j	80002f2e <argraw+0x30>
  panic("argraw");
    80002f56:	00005517          	auipc	a0,0x5
    80002f5a:	55250513          	addi	a0,a0,1362 # 800084a8 <states.1817+0x148>
    80002f5e:	ffffd097          	auipc	ra,0xffffd
    80002f62:	5e6080e7          	jalr	1510(ra) # 80000544 <panic>

0000000080002f66 <fetchaddr>:
{
    80002f66:	1101                	addi	sp,sp,-32
    80002f68:	ec06                	sd	ra,24(sp)
    80002f6a:	e822                	sd	s0,16(sp)
    80002f6c:	e426                	sd	s1,8(sp)
    80002f6e:	e04a                	sd	s2,0(sp)
    80002f70:	1000                	addi	s0,sp,32
    80002f72:	84aa                	mv	s1,a0
    80002f74:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002f76:	fffff097          	auipc	ra,0xfffff
    80002f7a:	a66080e7          	jalr	-1434(ra) # 800019dc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002f7e:	655c                	ld	a5,136(a0)
    80002f80:	02f4f863          	bgeu	s1,a5,80002fb0 <fetchaddr+0x4a>
    80002f84:	00848713          	addi	a4,s1,8
    80002f88:	02e7e663          	bltu	a5,a4,80002fb4 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002f8c:	46a1                	li	a3,8
    80002f8e:	8626                	mv	a2,s1
    80002f90:	85ca                	mv	a1,s2
    80002f92:	6948                	ld	a0,144(a0)
    80002f94:	ffffe097          	auipc	ra,0xffffe
    80002f98:	77c080e7          	jalr	1916(ra) # 80001710 <copyin>
    80002f9c:	00a03533          	snez	a0,a0
    80002fa0:	40a00533          	neg	a0,a0
}
    80002fa4:	60e2                	ld	ra,24(sp)
    80002fa6:	6442                	ld	s0,16(sp)
    80002fa8:	64a2                	ld	s1,8(sp)
    80002faa:	6902                	ld	s2,0(sp)
    80002fac:	6105                	addi	sp,sp,32
    80002fae:	8082                	ret
    return -1;
    80002fb0:	557d                	li	a0,-1
    80002fb2:	bfcd                	j	80002fa4 <fetchaddr+0x3e>
    80002fb4:	557d                	li	a0,-1
    80002fb6:	b7fd                	j	80002fa4 <fetchaddr+0x3e>

0000000080002fb8 <fetchstr>:
{
    80002fb8:	7179                	addi	sp,sp,-48
    80002fba:	f406                	sd	ra,40(sp)
    80002fbc:	f022                	sd	s0,32(sp)
    80002fbe:	ec26                	sd	s1,24(sp)
    80002fc0:	e84a                	sd	s2,16(sp)
    80002fc2:	e44e                	sd	s3,8(sp)
    80002fc4:	1800                	addi	s0,sp,48
    80002fc6:	892a                	mv	s2,a0
    80002fc8:	84ae                	mv	s1,a1
    80002fca:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	a10080e7          	jalr	-1520(ra) # 800019dc <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002fd4:	86ce                	mv	a3,s3
    80002fd6:	864a                	mv	a2,s2
    80002fd8:	85a6                	mv	a1,s1
    80002fda:	6948                	ld	a0,144(a0)
    80002fdc:	ffffe097          	auipc	ra,0xffffe
    80002fe0:	7c0080e7          	jalr	1984(ra) # 8000179c <copyinstr>
    80002fe4:	00054e63          	bltz	a0,80003000 <fetchstr+0x48>
  return strlen(buf);
    80002fe8:	8526                	mv	a0,s1
    80002fea:	ffffe097          	auipc	ra,0xffffe
    80002fee:	e80080e7          	jalr	-384(ra) # 80000e6a <strlen>
}
    80002ff2:	70a2                	ld	ra,40(sp)
    80002ff4:	7402                	ld	s0,32(sp)
    80002ff6:	64e2                	ld	s1,24(sp)
    80002ff8:	6942                	ld	s2,16(sp)
    80002ffa:	69a2                	ld	s3,8(sp)
    80002ffc:	6145                	addi	sp,sp,48
    80002ffe:	8082                	ret
    return -1;
    80003000:	557d                	li	a0,-1
    80003002:	bfc5                	j	80002ff2 <fetchstr+0x3a>

0000000080003004 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003004:	1101                	addi	sp,sp,-32
    80003006:	ec06                	sd	ra,24(sp)
    80003008:	e822                	sd	s0,16(sp)
    8000300a:	e426                	sd	s1,8(sp)
    8000300c:	1000                	addi	s0,sp,32
    8000300e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003010:	00000097          	auipc	ra,0x0
    80003014:	eee080e7          	jalr	-274(ra) # 80002efe <argraw>
    80003018:	c088                	sw	a0,0(s1)
}
    8000301a:	60e2                	ld	ra,24(sp)
    8000301c:	6442                	ld	s0,16(sp)
    8000301e:	64a2                	ld	s1,8(sp)
    80003020:	6105                	addi	sp,sp,32
    80003022:	8082                	ret

0000000080003024 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003024:	1101                	addi	sp,sp,-32
    80003026:	ec06                	sd	ra,24(sp)
    80003028:	e822                	sd	s0,16(sp)
    8000302a:	e426                	sd	s1,8(sp)
    8000302c:	1000                	addi	s0,sp,32
    8000302e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003030:	00000097          	auipc	ra,0x0
    80003034:	ece080e7          	jalr	-306(ra) # 80002efe <argraw>
    80003038:	e088                	sd	a0,0(s1)
}
    8000303a:	60e2                	ld	ra,24(sp)
    8000303c:	6442                	ld	s0,16(sp)
    8000303e:	64a2                	ld	s1,8(sp)
    80003040:	6105                	addi	sp,sp,32
    80003042:	8082                	ret

0000000080003044 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003044:	7179                	addi	sp,sp,-48
    80003046:	f406                	sd	ra,40(sp)
    80003048:	f022                	sd	s0,32(sp)
    8000304a:	ec26                	sd	s1,24(sp)
    8000304c:	e84a                	sd	s2,16(sp)
    8000304e:	1800                	addi	s0,sp,48
    80003050:	84ae                	mv	s1,a1
    80003052:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003054:	fd840593          	addi	a1,s0,-40
    80003058:	00000097          	auipc	ra,0x0
    8000305c:	fcc080e7          	jalr	-52(ra) # 80003024 <argaddr>
  return fetchstr(addr, buf, max);
    80003060:	864a                	mv	a2,s2
    80003062:	85a6                	mv	a1,s1
    80003064:	fd843503          	ld	a0,-40(s0)
    80003068:	00000097          	auipc	ra,0x0
    8000306c:	f50080e7          	jalr	-176(ra) # 80002fb8 <fetchstr>
}
    80003070:	70a2                	ld	ra,40(sp)
    80003072:	7402                	ld	s0,32(sp)
    80003074:	64e2                	ld	s1,24(sp)
    80003076:	6942                	ld	s2,16(sp)
    80003078:	6145                	addi	sp,sp,48
    8000307a:	8082                	ret

000000008000307c <syscall>:
[SYS_set_policy] sys_set_policy,
};

void
syscall(void)
{
    8000307c:	1101                	addi	sp,sp,-32
    8000307e:	ec06                	sd	ra,24(sp)
    80003080:	e822                	sd	s0,16(sp)
    80003082:	e426                	sd	s1,8(sp)
    80003084:	e04a                	sd	s2,0(sp)
    80003086:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003088:	fffff097          	auipc	ra,0xfffff
    8000308c:	954080e7          	jalr	-1708(ra) # 800019dc <myproc>
    80003090:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003092:	09853903          	ld	s2,152(a0)
    80003096:	0a893783          	ld	a5,168(s2)
    8000309a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000309e:	37fd                	addiw	a5,a5,-1
    800030a0:	4765                	li	a4,25
    800030a2:	00f76f63          	bltu	a4,a5,800030c0 <syscall+0x44>
    800030a6:	00369713          	slli	a4,a3,0x3
    800030aa:	00005797          	auipc	a5,0x5
    800030ae:	43e78793          	addi	a5,a5,1086 # 800084e8 <syscalls>
    800030b2:	97ba                	add	a5,a5,a4
    800030b4:	639c                	ld	a5,0(a5)
    800030b6:	c789                	beqz	a5,800030c0 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800030b8:	9782                	jalr	a5
    800030ba:	06a93823          	sd	a0,112(s2)
    800030be:	a839                	j	800030dc <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800030c0:	19848613          	addi	a2,s1,408
    800030c4:	588c                	lw	a1,48(s1)
    800030c6:	00005517          	auipc	a0,0x5
    800030ca:	3ea50513          	addi	a0,a0,1002 # 800084b0 <states.1817+0x150>
    800030ce:	ffffd097          	auipc	ra,0xffffd
    800030d2:	4c0080e7          	jalr	1216(ra) # 8000058e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800030d6:	6cdc                	ld	a5,152(s1)
    800030d8:	577d                	li	a4,-1
    800030da:	fbb8                	sd	a4,112(a5)
  }
}
    800030dc:	60e2                	ld	ra,24(sp)
    800030de:	6442                	ld	s0,16(sp)
    800030e0:	64a2                	ld	s1,8(sp)
    800030e2:	6902                	ld	s2,0(sp)
    800030e4:	6105                	addi	sp,sp,32
    800030e6:	8082                	ret

00000000800030e8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800030e8:	7139                	addi	sp,sp,-64
    800030ea:	fc06                	sd	ra,56(sp)
    800030ec:	f822                	sd	s0,48(sp)
    800030ee:	0080                	addi	s0,sp,64
  int n;
  char msg[32];
  argint(0, &n);
    800030f0:	fec40593          	addi	a1,s0,-20
    800030f4:	4501                	li	a0,0
    800030f6:	00000097          	auipc	ra,0x0
    800030fa:	f0e080e7          	jalr	-242(ra) # 80003004 <argint>
  argstr(1,msg,32);
    800030fe:	02000613          	li	a2,32
    80003102:	fc840593          	addi	a1,s0,-56
    80003106:	4505                	li	a0,1
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	f3c080e7          	jalr	-196(ra) # 80003044 <argstr>
  exit(n,msg);
    80003110:	fc840593          	addi	a1,s0,-56
    80003114:	fec42503          	lw	a0,-20(s0)
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	498080e7          	jalr	1176(ra) # 800025b0 <exit>
  return 0;  // not reached
}
    80003120:	4501                	li	a0,0
    80003122:	70e2                	ld	ra,56(sp)
    80003124:	7442                	ld	s0,48(sp)
    80003126:	6121                	addi	sp,sp,64
    80003128:	8082                	ret

000000008000312a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000312a:	1141                	addi	sp,sp,-16
    8000312c:	e406                	sd	ra,8(sp)
    8000312e:	e022                	sd	s0,0(sp)
    80003130:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003132:	fffff097          	auipc	ra,0xfffff
    80003136:	8aa080e7          	jalr	-1878(ra) # 800019dc <myproc>
}
    8000313a:	5908                	lw	a0,48(a0)
    8000313c:	60a2                	ld	ra,8(sp)
    8000313e:	6402                	ld	s0,0(sp)
    80003140:	0141                	addi	sp,sp,16
    80003142:	8082                	ret

0000000080003144 <sys_fork>:

uint64
sys_fork(void)
{
    80003144:	1141                	addi	sp,sp,-16
    80003146:	e406                	sd	ra,8(sp)
    80003148:	e022                	sd	s0,0(sp)
    8000314a:	0800                	addi	s0,sp,16
  return fork();
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	dd2080e7          	jalr	-558(ra) # 80001f1e <fork>
}
    80003154:	60a2                	ld	ra,8(sp)
    80003156:	6402                	ld	s0,0(sp)
    80003158:	0141                	addi	sp,sp,16
    8000315a:	8082                	ret

000000008000315c <sys_wait>:

uint64
sys_wait(void)
{
    8000315c:	1101                	addi	sp,sp,-32
    8000315e:	ec06                	sd	ra,24(sp)
    80003160:	e822                	sd	s0,16(sp)
    80003162:	1000                	addi	s0,sp,32
  uint64 p;
  uint64 msg;
  argaddr(0, &p);
    80003164:	fe840593          	addi	a1,s0,-24
    80003168:	4501                	li	a0,0
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	eba080e7          	jalr	-326(ra) # 80003024 <argaddr>
  argaddr(1, &msg);
    80003172:	fe040593          	addi	a1,s0,-32
    80003176:	4505                	li	a0,1
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	eac080e7          	jalr	-340(ra) # 80003024 <argaddr>
  return wait(p,msg);
    80003180:	fe043583          	ld	a1,-32(s0)
    80003184:	fe843503          	ld	a0,-24(s0)
    80003188:	fffff097          	auipc	ra,0xfffff
    8000318c:	638080e7          	jalr	1592(ra) # 800027c0 <wait>
}
    80003190:	60e2                	ld	ra,24(sp)
    80003192:	6442                	ld	s0,16(sp)
    80003194:	6105                	addi	sp,sp,32
    80003196:	8082                	ret

0000000080003198 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003198:	7179                	addi	sp,sp,-48
    8000319a:	f406                	sd	ra,40(sp)
    8000319c:	f022                	sd	s0,32(sp)
    8000319e:	ec26                	sd	s1,24(sp)
    800031a0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800031a2:	fdc40593          	addi	a1,s0,-36
    800031a6:	4501                	li	a0,0
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	e5c080e7          	jalr	-420(ra) # 80003004 <argint>
  addr = myproc()->sz;
    800031b0:	fffff097          	auipc	ra,0xfffff
    800031b4:	82c080e7          	jalr	-2004(ra) # 800019dc <myproc>
    800031b8:	6544                	ld	s1,136(a0)
  if(growproc(n) < 0)
    800031ba:	fdc42503          	lw	a0,-36(s0)
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	d04080e7          	jalr	-764(ra) # 80001ec2 <growproc>
    800031c6:	00054863          	bltz	a0,800031d6 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800031ca:	8526                	mv	a0,s1
    800031cc:	70a2                	ld	ra,40(sp)
    800031ce:	7402                	ld	s0,32(sp)
    800031d0:	64e2                	ld	s1,24(sp)
    800031d2:	6145                	addi	sp,sp,48
    800031d4:	8082                	ret
    return -1;
    800031d6:	54fd                	li	s1,-1
    800031d8:	bfcd                	j	800031ca <sys_sbrk+0x32>

00000000800031da <sys_sleep>:

uint64
sys_sleep(void)
{
    800031da:	7139                	addi	sp,sp,-64
    800031dc:	fc06                	sd	ra,56(sp)
    800031de:	f822                	sd	s0,48(sp)
    800031e0:	f426                	sd	s1,40(sp)
    800031e2:	f04a                	sd	s2,32(sp)
    800031e4:	ec4e                	sd	s3,24(sp)
    800031e6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800031e8:	fcc40593          	addi	a1,s0,-52
    800031ec:	4501                	li	a0,0
    800031ee:	00000097          	auipc	ra,0x0
    800031f2:	e16080e7          	jalr	-490(ra) # 80003004 <argint>
  acquire(&tickslock);
    800031f6:	00015517          	auipc	a0,0x15
    800031fa:	84a50513          	addi	a0,a0,-1974 # 80017a40 <tickslock>
    800031fe:	ffffe097          	auipc	ra,0xffffe
    80003202:	9ec080e7          	jalr	-1556(ra) # 80000bea <acquire>
  ticks0 = ticks;
    80003206:	00005917          	auipc	s2,0x5
    8000320a:	7a292903          	lw	s2,1954(s2) # 800089a8 <ticks>
  while(ticks - ticks0 < n){
    8000320e:	fcc42783          	lw	a5,-52(s0)
    80003212:	cf9d                	beqz	a5,80003250 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003214:	00015997          	auipc	s3,0x15
    80003218:	82c98993          	addi	s3,s3,-2004 # 80017a40 <tickslock>
    8000321c:	00005497          	auipc	s1,0x5
    80003220:	78c48493          	addi	s1,s1,1932 # 800089a8 <ticks>
    if(killed(myproc())){
    80003224:	ffffe097          	auipc	ra,0xffffe
    80003228:	7b8080e7          	jalr	1976(ra) # 800019dc <myproc>
    8000322c:	fffff097          	auipc	ra,0xfffff
    80003230:	562080e7          	jalr	1378(ra) # 8000278e <killed>
    80003234:	ed15                	bnez	a0,80003270 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003236:	85ce                	mv	a1,s3
    80003238:	8526                	mv	a0,s1
    8000323a:	fffff097          	auipc	ra,0xfffff
    8000323e:	242080e7          	jalr	578(ra) # 8000247c <sleep>
  while(ticks - ticks0 < n){
    80003242:	409c                	lw	a5,0(s1)
    80003244:	412787bb          	subw	a5,a5,s2
    80003248:	fcc42703          	lw	a4,-52(s0)
    8000324c:	fce7ece3          	bltu	a5,a4,80003224 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003250:	00014517          	auipc	a0,0x14
    80003254:	7f050513          	addi	a0,a0,2032 # 80017a40 <tickslock>
    80003258:	ffffe097          	auipc	ra,0xffffe
    8000325c:	a46080e7          	jalr	-1466(ra) # 80000c9e <release>
  return 0;
    80003260:	4501                	li	a0,0
}
    80003262:	70e2                	ld	ra,56(sp)
    80003264:	7442                	ld	s0,48(sp)
    80003266:	74a2                	ld	s1,40(sp)
    80003268:	7902                	ld	s2,32(sp)
    8000326a:	69e2                	ld	s3,24(sp)
    8000326c:	6121                	addi	sp,sp,64
    8000326e:	8082                	ret
      release(&tickslock);
    80003270:	00014517          	auipc	a0,0x14
    80003274:	7d050513          	addi	a0,a0,2000 # 80017a40 <tickslock>
    80003278:	ffffe097          	auipc	ra,0xffffe
    8000327c:	a26080e7          	jalr	-1498(ra) # 80000c9e <release>
      return -1;
    80003280:	557d                	li	a0,-1
    80003282:	b7c5                	j	80003262 <sys_sleep+0x88>

0000000080003284 <sys_kill>:

uint64
sys_kill(void)
{
    80003284:	1101                	addi	sp,sp,-32
    80003286:	ec06                	sd	ra,24(sp)
    80003288:	e822                	sd	s0,16(sp)
    8000328a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000328c:	fec40593          	addi	a1,s0,-20
    80003290:	4501                	li	a0,0
    80003292:	00000097          	auipc	ra,0x0
    80003296:	d72080e7          	jalr	-654(ra) # 80003004 <argint>
  return kill(pid);
    8000329a:	fec42503          	lw	a0,-20(s0)
    8000329e:	fffff097          	auipc	ra,0xfffff
    800032a2:	452080e7          	jalr	1106(ra) # 800026f0 <kill>
}
    800032a6:	60e2                	ld	ra,24(sp)
    800032a8:	6442                	ld	s0,16(sp)
    800032aa:	6105                	addi	sp,sp,32
    800032ac:	8082                	ret

00000000800032ae <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800032ae:	1101                	addi	sp,sp,-32
    800032b0:	ec06                	sd	ra,24(sp)
    800032b2:	e822                	sd	s0,16(sp)
    800032b4:	e426                	sd	s1,8(sp)
    800032b6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800032b8:	00014517          	auipc	a0,0x14
    800032bc:	78850513          	addi	a0,a0,1928 # 80017a40 <tickslock>
    800032c0:	ffffe097          	auipc	ra,0xffffe
    800032c4:	92a080e7          	jalr	-1750(ra) # 80000bea <acquire>
  xticks = ticks;
    800032c8:	00005497          	auipc	s1,0x5
    800032cc:	6e04a483          	lw	s1,1760(s1) # 800089a8 <ticks>
  release(&tickslock);
    800032d0:	00014517          	auipc	a0,0x14
    800032d4:	77050513          	addi	a0,a0,1904 # 80017a40 <tickslock>
    800032d8:	ffffe097          	auipc	ra,0xffffe
    800032dc:	9c6080e7          	jalr	-1594(ra) # 80000c9e <release>
  return xticks;
}
    800032e0:	02049513          	slli	a0,s1,0x20
    800032e4:	9101                	srli	a0,a0,0x20
    800032e6:	60e2                	ld	ra,24(sp)
    800032e8:	6442                	ld	s0,16(sp)
    800032ea:	64a2                	ld	s1,8(sp)
    800032ec:	6105                	addi	sp,sp,32
    800032ee:	8082                	ret

00000000800032f0 <sys_memsize>:

uint64 sys_memsize(void)
{
    800032f0:	1141                	addi	sp,sp,-16
    800032f2:	e406                	sd	ra,8(sp)
    800032f4:	e022                	sd	s0,0(sp)
    800032f6:	0800                	addi	s0,sp,16
  return myproc()->sz;
    800032f8:	ffffe097          	auipc	ra,0xffffe
    800032fc:	6e4080e7          	jalr	1764(ra) # 800019dc <myproc>
}
    80003300:	6548                	ld	a0,136(a0)
    80003302:	60a2                	ld	ra,8(sp)
    80003304:	6402                	ld	s0,0(sp)
    80003306:	0141                	addi	sp,sp,16
    80003308:	8082                	ret

000000008000330a <sys_set_ps_priority>:

uint64 sys_set_ps_priority(struct proc* p, int priority)
{
    8000330a:	7179                	addi	sp,sp,-48
    8000330c:	f406                	sd	ra,40(sp)
    8000330e:	f022                	sd	s0,32(sp)
    80003310:	ec26                	sd	s1,24(sp)
    80003312:	1800                	addi	s0,sp,48
    80003314:	84aa                	mv	s1,a0
    80003316:	fcb42e23          	sw	a1,-36(s0)
  argint(0, &priority);
    8000331a:	fdc40593          	addi	a1,s0,-36
    8000331e:	4501                	li	a0,0
    80003320:	00000097          	auipc	ra,0x0
    80003324:	ce4080e7          	jalr	-796(ra) # 80003004 <argint>
  if(priority < 1 || priority > 10)
    80003328:	fdc42503          	lw	a0,-36(s0)
    8000332c:	fff5071b          	addiw	a4,a0,-1
    80003330:	47a5                	li	a5,9
    80003332:	00e7e863          	bltu	a5,a4,80003342 <sys_set_ps_priority+0x38>
    return -1;
  p->ps_priority = priority;
    80003336:	d0a8                	sw	a0,96(s1)
  return priority;
}
    80003338:	70a2                	ld	ra,40(sp)
    8000333a:	7402                	ld	s0,32(sp)
    8000333c:	64e2                	ld	s1,24(sp)
    8000333e:	6145                	addi	sp,sp,48
    80003340:	8082                	ret
    return -1;
    80003342:	557d                	li	a0,-1
    80003344:	bfd5                	j	80003338 <sys_set_ps_priority+0x2e>

0000000080003346 <sys_set_cfs_priority>:

uint64
sys_set_cfs_priority(void)
{
    80003346:	1101                	addi	sp,sp,-32
    80003348:	ec06                	sd	ra,24(sp)
    8000334a:	e822                	sd	s0,16(sp)
    8000334c:	1000                	addi	s0,sp,32
  int priority;
  argint(0, &priority);
    8000334e:	fec40593          	addi	a1,s0,-20
    80003352:	4501                	li	a0,0
    80003354:	00000097          	auipc	ra,0x0
    80003358:	cb0080e7          	jalr	-848(ra) # 80003004 <argint>
  if (priority < 0 || priority > 2) {
    8000335c:	fec42783          	lw	a5,-20(s0)
    80003360:	0007869b          	sext.w	a3,a5
    80003364:	4709                	li	a4,2
    return -1;
    80003366:	557d                	li	a0,-1
  if (priority < 0 || priority > 2) {
    80003368:	00d76863          	bltu	a4,a3,80003378 <sys_set_cfs_priority+0x32>
  }
  set_cfs_priority(priority);
    8000336c:	853e                	mv	a0,a5
    8000336e:	ffffe097          	auipc	ra,0xffffe
    80003372:	7ca080e7          	jalr	1994(ra) # 80001b38 <set_cfs_priority>
  // printf("priority: %d, myproc()->cfs_priority: %d\n", priority, myproc()->cfs_priority);
  return 0;
    80003376:	4501                	li	a0,0
}
    80003378:	60e2                	ld	ra,24(sp)
    8000337a:	6442                	ld	s0,16(sp)
    8000337c:	6105                	addi	sp,sp,32
    8000337e:	8082                	ret

0000000080003380 <sys_set_policy>:

uint64
sys_set_policy(void){
    80003380:	1101                	addi	sp,sp,-32
    80003382:	ec06                	sd	ra,24(sp)
    80003384:	e822                	sd	s0,16(sp)
    80003386:	1000                	addi	s0,sp,32
  int policy;
  argint(0, &policy);
    80003388:	fec40593          	addi	a1,s0,-20
    8000338c:	4501                	li	a0,0
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	c76080e7          	jalr	-906(ra) # 80003004 <argint>
  if (policy < 0 || policy > 2) {
    80003396:	fec42783          	lw	a5,-20(s0)
    8000339a:	0007869b          	sext.w	a3,a5
    8000339e:	4709                	li	a4,2
    return -1;
    800033a0:	557d                	li	a0,-1
  if (policy < 0 || policy > 2) {
    800033a2:	00d76763          	bltu	a4,a3,800033b0 <sys_set_policy+0x30>
  }
  return set_policy(policy);
    800033a6:	853e                	mv	a0,a5
    800033a8:	ffffe097          	auipc	ra,0xffffe
    800033ac:	4a8080e7          	jalr	1192(ra) # 80001850 <set_policy>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret

00000000800033b8 <sys_get_cfs_stats>:

//TODO 1
uint64
sys_get_cfs_stats(void){
    800033b8:	1101                	addi	sp,sp,-32
    800033ba:	ec06                	sd	ra,24(sp)
    800033bc:	e822                	sd	s0,16(sp)
    800033be:	1000                	addi	s0,sp,32
  int pid;
  int* arr;
  uint64 addr;
  argint(0, &pid);
    800033c0:	fec40593          	addi	a1,s0,-20
    800033c4:	4501                	li	a0,0
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	c3e080e7          	jalr	-962(ra) # 80003004 <argint>
  argaddr(1, &addr);
    800033ce:	fe040593          	addi	a1,s0,-32
    800033d2:	4505                	li	a0,1
    800033d4:	00000097          	auipc	ra,0x0
    800033d8:	c50080e7          	jalr	-944(ra) # 80003024 <argaddr>
  arr = (int*)addr;
  get_cfs_stats(pid, arr);
    800033dc:	fe043583          	ld	a1,-32(s0)
    800033e0:	fec42503          	lw	a0,-20(s0)
    800033e4:	ffffe097          	auipc	ra,0xffffe
    800033e8:	6b8080e7          	jalr	1720(ra) # 80001a9c <get_cfs_stats>
  return 0;
}
    800033ec:	4501                	li	a0,0
    800033ee:	60e2                	ld	ra,24(sp)
    800033f0:	6442                	ld	s0,16(sp)
    800033f2:	6105                	addi	sp,sp,32
    800033f4:	8082                	ret

00000000800033f6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800033f6:	7179                	addi	sp,sp,-48
    800033f8:	f406                	sd	ra,40(sp)
    800033fa:	f022                	sd	s0,32(sp)
    800033fc:	ec26                	sd	s1,24(sp)
    800033fe:	e84a                	sd	s2,16(sp)
    80003400:	e44e                	sd	s3,8(sp)
    80003402:	e052                	sd	s4,0(sp)
    80003404:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003406:	00005597          	auipc	a1,0x5
    8000340a:	1ba58593          	addi	a1,a1,442 # 800085c0 <syscalls+0xd8>
    8000340e:	00014517          	auipc	a0,0x14
    80003412:	64a50513          	addi	a0,a0,1610 # 80017a58 <bcache>
    80003416:	ffffd097          	auipc	ra,0xffffd
    8000341a:	744080e7          	jalr	1860(ra) # 80000b5a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000341e:	0001c797          	auipc	a5,0x1c
    80003422:	63a78793          	addi	a5,a5,1594 # 8001fa58 <bcache+0x8000>
    80003426:	0001d717          	auipc	a4,0x1d
    8000342a:	89a70713          	addi	a4,a4,-1894 # 8001fcc0 <bcache+0x8268>
    8000342e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003432:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003436:	00014497          	auipc	s1,0x14
    8000343a:	63a48493          	addi	s1,s1,1594 # 80017a70 <bcache+0x18>
    b->next = bcache.head.next;
    8000343e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003440:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003442:	00005a17          	auipc	s4,0x5
    80003446:	186a0a13          	addi	s4,s4,390 # 800085c8 <syscalls+0xe0>
    b->next = bcache.head.next;
    8000344a:	2b893783          	ld	a5,696(s2)
    8000344e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003450:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003454:	85d2                	mv	a1,s4
    80003456:	01048513          	addi	a0,s1,16
    8000345a:	00001097          	auipc	ra,0x1
    8000345e:	4c4080e7          	jalr	1220(ra) # 8000491e <initsleeplock>
    bcache.head.next->prev = b;
    80003462:	2b893783          	ld	a5,696(s2)
    80003466:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003468:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000346c:	45848493          	addi	s1,s1,1112
    80003470:	fd349de3          	bne	s1,s3,8000344a <binit+0x54>
  }
}
    80003474:	70a2                	ld	ra,40(sp)
    80003476:	7402                	ld	s0,32(sp)
    80003478:	64e2                	ld	s1,24(sp)
    8000347a:	6942                	ld	s2,16(sp)
    8000347c:	69a2                	ld	s3,8(sp)
    8000347e:	6a02                	ld	s4,0(sp)
    80003480:	6145                	addi	sp,sp,48
    80003482:	8082                	ret

0000000080003484 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003484:	7179                	addi	sp,sp,-48
    80003486:	f406                	sd	ra,40(sp)
    80003488:	f022                	sd	s0,32(sp)
    8000348a:	ec26                	sd	s1,24(sp)
    8000348c:	e84a                	sd	s2,16(sp)
    8000348e:	e44e                	sd	s3,8(sp)
    80003490:	1800                	addi	s0,sp,48
    80003492:	89aa                	mv	s3,a0
    80003494:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80003496:	00014517          	auipc	a0,0x14
    8000349a:	5c250513          	addi	a0,a0,1474 # 80017a58 <bcache>
    8000349e:	ffffd097          	auipc	ra,0xffffd
    800034a2:	74c080e7          	jalr	1868(ra) # 80000bea <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800034a6:	0001d497          	auipc	s1,0x1d
    800034aa:	86a4b483          	ld	s1,-1942(s1) # 8001fd10 <bcache+0x82b8>
    800034ae:	0001d797          	auipc	a5,0x1d
    800034b2:	81278793          	addi	a5,a5,-2030 # 8001fcc0 <bcache+0x8268>
    800034b6:	02f48f63          	beq	s1,a5,800034f4 <bread+0x70>
    800034ba:	873e                	mv	a4,a5
    800034bc:	a021                	j	800034c4 <bread+0x40>
    800034be:	68a4                	ld	s1,80(s1)
    800034c0:	02e48a63          	beq	s1,a4,800034f4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800034c4:	449c                	lw	a5,8(s1)
    800034c6:	ff379ce3          	bne	a5,s3,800034be <bread+0x3a>
    800034ca:	44dc                	lw	a5,12(s1)
    800034cc:	ff2799e3          	bne	a5,s2,800034be <bread+0x3a>
      b->refcnt++;
    800034d0:	40bc                	lw	a5,64(s1)
    800034d2:	2785                	addiw	a5,a5,1
    800034d4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800034d6:	00014517          	auipc	a0,0x14
    800034da:	58250513          	addi	a0,a0,1410 # 80017a58 <bcache>
    800034de:	ffffd097          	auipc	ra,0xffffd
    800034e2:	7c0080e7          	jalr	1984(ra) # 80000c9e <release>
      acquiresleep(&b->lock);
    800034e6:	01048513          	addi	a0,s1,16
    800034ea:	00001097          	auipc	ra,0x1
    800034ee:	46e080e7          	jalr	1134(ra) # 80004958 <acquiresleep>
      return b;
    800034f2:	a8b9                	j	80003550 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800034f4:	0001d497          	auipc	s1,0x1d
    800034f8:	8144b483          	ld	s1,-2028(s1) # 8001fd08 <bcache+0x82b0>
    800034fc:	0001c797          	auipc	a5,0x1c
    80003500:	7c478793          	addi	a5,a5,1988 # 8001fcc0 <bcache+0x8268>
    80003504:	00f48863          	beq	s1,a5,80003514 <bread+0x90>
    80003508:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000350a:	40bc                	lw	a5,64(s1)
    8000350c:	cf81                	beqz	a5,80003524 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000350e:	64a4                	ld	s1,72(s1)
    80003510:	fee49de3          	bne	s1,a4,8000350a <bread+0x86>
  panic("bget: no buffers");
    80003514:	00005517          	auipc	a0,0x5
    80003518:	0bc50513          	addi	a0,a0,188 # 800085d0 <syscalls+0xe8>
    8000351c:	ffffd097          	auipc	ra,0xffffd
    80003520:	028080e7          	jalr	40(ra) # 80000544 <panic>
      b->dev = dev;
    80003524:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80003528:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000352c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003530:	4785                	li	a5,1
    80003532:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003534:	00014517          	auipc	a0,0x14
    80003538:	52450513          	addi	a0,a0,1316 # 80017a58 <bcache>
    8000353c:	ffffd097          	auipc	ra,0xffffd
    80003540:	762080e7          	jalr	1890(ra) # 80000c9e <release>
      acquiresleep(&b->lock);
    80003544:	01048513          	addi	a0,s1,16
    80003548:	00001097          	auipc	ra,0x1
    8000354c:	410080e7          	jalr	1040(ra) # 80004958 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003550:	409c                	lw	a5,0(s1)
    80003552:	cb89                	beqz	a5,80003564 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003554:	8526                	mv	a0,s1
    80003556:	70a2                	ld	ra,40(sp)
    80003558:	7402                	ld	s0,32(sp)
    8000355a:	64e2                	ld	s1,24(sp)
    8000355c:	6942                	ld	s2,16(sp)
    8000355e:	69a2                	ld	s3,8(sp)
    80003560:	6145                	addi	sp,sp,48
    80003562:	8082                	ret
    virtio_disk_rw(b, 0);
    80003564:	4581                	li	a1,0
    80003566:	8526                	mv	a0,s1
    80003568:	00003097          	auipc	ra,0x3
    8000356c:	fd0080e7          	jalr	-48(ra) # 80006538 <virtio_disk_rw>
    b->valid = 1;
    80003570:	4785                	li	a5,1
    80003572:	c09c                	sw	a5,0(s1)
  return b;
    80003574:	b7c5                	j	80003554 <bread+0xd0>

0000000080003576 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003576:	1101                	addi	sp,sp,-32
    80003578:	ec06                	sd	ra,24(sp)
    8000357a:	e822                	sd	s0,16(sp)
    8000357c:	e426                	sd	s1,8(sp)
    8000357e:	1000                	addi	s0,sp,32
    80003580:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003582:	0541                	addi	a0,a0,16
    80003584:	00001097          	auipc	ra,0x1
    80003588:	46e080e7          	jalr	1134(ra) # 800049f2 <holdingsleep>
    8000358c:	cd01                	beqz	a0,800035a4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000358e:	4585                	li	a1,1
    80003590:	8526                	mv	a0,s1
    80003592:	00003097          	auipc	ra,0x3
    80003596:	fa6080e7          	jalr	-90(ra) # 80006538 <virtio_disk_rw>
}
    8000359a:	60e2                	ld	ra,24(sp)
    8000359c:	6442                	ld	s0,16(sp)
    8000359e:	64a2                	ld	s1,8(sp)
    800035a0:	6105                	addi	sp,sp,32
    800035a2:	8082                	ret
    panic("bwrite");
    800035a4:	00005517          	auipc	a0,0x5
    800035a8:	04450513          	addi	a0,a0,68 # 800085e8 <syscalls+0x100>
    800035ac:	ffffd097          	auipc	ra,0xffffd
    800035b0:	f98080e7          	jalr	-104(ra) # 80000544 <panic>

00000000800035b4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800035b4:	1101                	addi	sp,sp,-32
    800035b6:	ec06                	sd	ra,24(sp)
    800035b8:	e822                	sd	s0,16(sp)
    800035ba:	e426                	sd	s1,8(sp)
    800035bc:	e04a                	sd	s2,0(sp)
    800035be:	1000                	addi	s0,sp,32
    800035c0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035c2:	01050913          	addi	s2,a0,16
    800035c6:	854a                	mv	a0,s2
    800035c8:	00001097          	auipc	ra,0x1
    800035cc:	42a080e7          	jalr	1066(ra) # 800049f2 <holdingsleep>
    800035d0:	c92d                	beqz	a0,80003642 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800035d2:	854a                	mv	a0,s2
    800035d4:	00001097          	auipc	ra,0x1
    800035d8:	3da080e7          	jalr	986(ra) # 800049ae <releasesleep>

  acquire(&bcache.lock);
    800035dc:	00014517          	auipc	a0,0x14
    800035e0:	47c50513          	addi	a0,a0,1148 # 80017a58 <bcache>
    800035e4:	ffffd097          	auipc	ra,0xffffd
    800035e8:	606080e7          	jalr	1542(ra) # 80000bea <acquire>
  b->refcnt--;
    800035ec:	40bc                	lw	a5,64(s1)
    800035ee:	37fd                	addiw	a5,a5,-1
    800035f0:	0007871b          	sext.w	a4,a5
    800035f4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800035f6:	eb05                	bnez	a4,80003626 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800035f8:	68bc                	ld	a5,80(s1)
    800035fa:	64b8                	ld	a4,72(s1)
    800035fc:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800035fe:	64bc                	ld	a5,72(s1)
    80003600:	68b8                	ld	a4,80(s1)
    80003602:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003604:	0001c797          	auipc	a5,0x1c
    80003608:	45478793          	addi	a5,a5,1108 # 8001fa58 <bcache+0x8000>
    8000360c:	2b87b703          	ld	a4,696(a5)
    80003610:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003612:	0001c717          	auipc	a4,0x1c
    80003616:	6ae70713          	addi	a4,a4,1710 # 8001fcc0 <bcache+0x8268>
    8000361a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000361c:	2b87b703          	ld	a4,696(a5)
    80003620:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003622:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003626:	00014517          	auipc	a0,0x14
    8000362a:	43250513          	addi	a0,a0,1074 # 80017a58 <bcache>
    8000362e:	ffffd097          	auipc	ra,0xffffd
    80003632:	670080e7          	jalr	1648(ra) # 80000c9e <release>
}
    80003636:	60e2                	ld	ra,24(sp)
    80003638:	6442                	ld	s0,16(sp)
    8000363a:	64a2                	ld	s1,8(sp)
    8000363c:	6902                	ld	s2,0(sp)
    8000363e:	6105                	addi	sp,sp,32
    80003640:	8082                	ret
    panic("brelse");
    80003642:	00005517          	auipc	a0,0x5
    80003646:	fae50513          	addi	a0,a0,-82 # 800085f0 <syscalls+0x108>
    8000364a:	ffffd097          	auipc	ra,0xffffd
    8000364e:	efa080e7          	jalr	-262(ra) # 80000544 <panic>

0000000080003652 <bpin>:

void
bpin(struct buf *b) {
    80003652:	1101                	addi	sp,sp,-32
    80003654:	ec06                	sd	ra,24(sp)
    80003656:	e822                	sd	s0,16(sp)
    80003658:	e426                	sd	s1,8(sp)
    8000365a:	1000                	addi	s0,sp,32
    8000365c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000365e:	00014517          	auipc	a0,0x14
    80003662:	3fa50513          	addi	a0,a0,1018 # 80017a58 <bcache>
    80003666:	ffffd097          	auipc	ra,0xffffd
    8000366a:	584080e7          	jalr	1412(ra) # 80000bea <acquire>
  b->refcnt++;
    8000366e:	40bc                	lw	a5,64(s1)
    80003670:	2785                	addiw	a5,a5,1
    80003672:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003674:	00014517          	auipc	a0,0x14
    80003678:	3e450513          	addi	a0,a0,996 # 80017a58 <bcache>
    8000367c:	ffffd097          	auipc	ra,0xffffd
    80003680:	622080e7          	jalr	1570(ra) # 80000c9e <release>
}
    80003684:	60e2                	ld	ra,24(sp)
    80003686:	6442                	ld	s0,16(sp)
    80003688:	64a2                	ld	s1,8(sp)
    8000368a:	6105                	addi	sp,sp,32
    8000368c:	8082                	ret

000000008000368e <bunpin>:

void
bunpin(struct buf *b) {
    8000368e:	1101                	addi	sp,sp,-32
    80003690:	ec06                	sd	ra,24(sp)
    80003692:	e822                	sd	s0,16(sp)
    80003694:	e426                	sd	s1,8(sp)
    80003696:	1000                	addi	s0,sp,32
    80003698:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000369a:	00014517          	auipc	a0,0x14
    8000369e:	3be50513          	addi	a0,a0,958 # 80017a58 <bcache>
    800036a2:	ffffd097          	auipc	ra,0xffffd
    800036a6:	548080e7          	jalr	1352(ra) # 80000bea <acquire>
  b->refcnt--;
    800036aa:	40bc                	lw	a5,64(s1)
    800036ac:	37fd                	addiw	a5,a5,-1
    800036ae:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036b0:	00014517          	auipc	a0,0x14
    800036b4:	3a850513          	addi	a0,a0,936 # 80017a58 <bcache>
    800036b8:	ffffd097          	auipc	ra,0xffffd
    800036bc:	5e6080e7          	jalr	1510(ra) # 80000c9e <release>
}
    800036c0:	60e2                	ld	ra,24(sp)
    800036c2:	6442                	ld	s0,16(sp)
    800036c4:	64a2                	ld	s1,8(sp)
    800036c6:	6105                	addi	sp,sp,32
    800036c8:	8082                	ret

00000000800036ca <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800036ca:	1101                	addi	sp,sp,-32
    800036cc:	ec06                	sd	ra,24(sp)
    800036ce:	e822                	sd	s0,16(sp)
    800036d0:	e426                	sd	s1,8(sp)
    800036d2:	e04a                	sd	s2,0(sp)
    800036d4:	1000                	addi	s0,sp,32
    800036d6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800036d8:	00d5d59b          	srliw	a1,a1,0xd
    800036dc:	0001d797          	auipc	a5,0x1d
    800036e0:	a587a783          	lw	a5,-1448(a5) # 80020134 <sb+0x1c>
    800036e4:	9dbd                	addw	a1,a1,a5
    800036e6:	00000097          	auipc	ra,0x0
    800036ea:	d9e080e7          	jalr	-610(ra) # 80003484 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800036ee:	0074f713          	andi	a4,s1,7
    800036f2:	4785                	li	a5,1
    800036f4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800036f8:	14ce                	slli	s1,s1,0x33
    800036fa:	90d9                	srli	s1,s1,0x36
    800036fc:	00950733          	add	a4,a0,s1
    80003700:	05874703          	lbu	a4,88(a4)
    80003704:	00e7f6b3          	and	a3,a5,a4
    80003708:	c69d                	beqz	a3,80003736 <bfree+0x6c>
    8000370a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000370c:	94aa                	add	s1,s1,a0
    8000370e:	fff7c793          	not	a5,a5
    80003712:	8ff9                	and	a5,a5,a4
    80003714:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80003718:	00001097          	auipc	ra,0x1
    8000371c:	120080e7          	jalr	288(ra) # 80004838 <log_write>
  brelse(bp);
    80003720:	854a                	mv	a0,s2
    80003722:	00000097          	auipc	ra,0x0
    80003726:	e92080e7          	jalr	-366(ra) # 800035b4 <brelse>
}
    8000372a:	60e2                	ld	ra,24(sp)
    8000372c:	6442                	ld	s0,16(sp)
    8000372e:	64a2                	ld	s1,8(sp)
    80003730:	6902                	ld	s2,0(sp)
    80003732:	6105                	addi	sp,sp,32
    80003734:	8082                	ret
    panic("freeing free block");
    80003736:	00005517          	auipc	a0,0x5
    8000373a:	ec250513          	addi	a0,a0,-318 # 800085f8 <syscalls+0x110>
    8000373e:	ffffd097          	auipc	ra,0xffffd
    80003742:	e06080e7          	jalr	-506(ra) # 80000544 <panic>

0000000080003746 <balloc>:
{
    80003746:	711d                	addi	sp,sp,-96
    80003748:	ec86                	sd	ra,88(sp)
    8000374a:	e8a2                	sd	s0,80(sp)
    8000374c:	e4a6                	sd	s1,72(sp)
    8000374e:	e0ca                	sd	s2,64(sp)
    80003750:	fc4e                	sd	s3,56(sp)
    80003752:	f852                	sd	s4,48(sp)
    80003754:	f456                	sd	s5,40(sp)
    80003756:	f05a                	sd	s6,32(sp)
    80003758:	ec5e                	sd	s7,24(sp)
    8000375a:	e862                	sd	s8,16(sp)
    8000375c:	e466                	sd	s9,8(sp)
    8000375e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003760:	0001d797          	auipc	a5,0x1d
    80003764:	9bc7a783          	lw	a5,-1604(a5) # 8002011c <sb+0x4>
    80003768:	10078163          	beqz	a5,8000386a <balloc+0x124>
    8000376c:	8baa                	mv	s7,a0
    8000376e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003770:	0001db17          	auipc	s6,0x1d
    80003774:	9a8b0b13          	addi	s6,s6,-1624 # 80020118 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003778:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000377a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000377c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000377e:	6c89                	lui	s9,0x2
    80003780:	a061                	j	80003808 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003782:	974a                	add	a4,a4,s2
    80003784:	8fd5                	or	a5,a5,a3
    80003786:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000378a:	854a                	mv	a0,s2
    8000378c:	00001097          	auipc	ra,0x1
    80003790:	0ac080e7          	jalr	172(ra) # 80004838 <log_write>
        brelse(bp);
    80003794:	854a                	mv	a0,s2
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	e1e080e7          	jalr	-482(ra) # 800035b4 <brelse>
  bp = bread(dev, bno);
    8000379e:	85a6                	mv	a1,s1
    800037a0:	855e                	mv	a0,s7
    800037a2:	00000097          	auipc	ra,0x0
    800037a6:	ce2080e7          	jalr	-798(ra) # 80003484 <bread>
    800037aa:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800037ac:	40000613          	li	a2,1024
    800037b0:	4581                	li	a1,0
    800037b2:	05850513          	addi	a0,a0,88
    800037b6:	ffffd097          	auipc	ra,0xffffd
    800037ba:	530080e7          	jalr	1328(ra) # 80000ce6 <memset>
  log_write(bp);
    800037be:	854a                	mv	a0,s2
    800037c0:	00001097          	auipc	ra,0x1
    800037c4:	078080e7          	jalr	120(ra) # 80004838 <log_write>
  brelse(bp);
    800037c8:	854a                	mv	a0,s2
    800037ca:	00000097          	auipc	ra,0x0
    800037ce:	dea080e7          	jalr	-534(ra) # 800035b4 <brelse>
}
    800037d2:	8526                	mv	a0,s1
    800037d4:	60e6                	ld	ra,88(sp)
    800037d6:	6446                	ld	s0,80(sp)
    800037d8:	64a6                	ld	s1,72(sp)
    800037da:	6906                	ld	s2,64(sp)
    800037dc:	79e2                	ld	s3,56(sp)
    800037de:	7a42                	ld	s4,48(sp)
    800037e0:	7aa2                	ld	s5,40(sp)
    800037e2:	7b02                	ld	s6,32(sp)
    800037e4:	6be2                	ld	s7,24(sp)
    800037e6:	6c42                	ld	s8,16(sp)
    800037e8:	6ca2                	ld	s9,8(sp)
    800037ea:	6125                	addi	sp,sp,96
    800037ec:	8082                	ret
    brelse(bp);
    800037ee:	854a                	mv	a0,s2
    800037f0:	00000097          	auipc	ra,0x0
    800037f4:	dc4080e7          	jalr	-572(ra) # 800035b4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800037f8:	015c87bb          	addw	a5,s9,s5
    800037fc:	00078a9b          	sext.w	s5,a5
    80003800:	004b2703          	lw	a4,4(s6)
    80003804:	06eaf363          	bgeu	s5,a4,8000386a <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80003808:	41fad79b          	sraiw	a5,s5,0x1f
    8000380c:	0137d79b          	srliw	a5,a5,0x13
    80003810:	015787bb          	addw	a5,a5,s5
    80003814:	40d7d79b          	sraiw	a5,a5,0xd
    80003818:	01cb2583          	lw	a1,28(s6)
    8000381c:	9dbd                	addw	a1,a1,a5
    8000381e:	855e                	mv	a0,s7
    80003820:	00000097          	auipc	ra,0x0
    80003824:	c64080e7          	jalr	-924(ra) # 80003484 <bread>
    80003828:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000382a:	004b2503          	lw	a0,4(s6)
    8000382e:	000a849b          	sext.w	s1,s5
    80003832:	8662                	mv	a2,s8
    80003834:	faa4fde3          	bgeu	s1,a0,800037ee <balloc+0xa8>
      m = 1 << (bi % 8);
    80003838:	41f6579b          	sraiw	a5,a2,0x1f
    8000383c:	01d7d69b          	srliw	a3,a5,0x1d
    80003840:	00c6873b          	addw	a4,a3,a2
    80003844:	00777793          	andi	a5,a4,7
    80003848:	9f95                	subw	a5,a5,a3
    8000384a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000384e:	4037571b          	sraiw	a4,a4,0x3
    80003852:	00e906b3          	add	a3,s2,a4
    80003856:	0586c683          	lbu	a3,88(a3)
    8000385a:	00d7f5b3          	and	a1,a5,a3
    8000385e:	d195                	beqz	a1,80003782 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003860:	2605                	addiw	a2,a2,1
    80003862:	2485                	addiw	s1,s1,1
    80003864:	fd4618e3          	bne	a2,s4,80003834 <balloc+0xee>
    80003868:	b759                	j	800037ee <balloc+0xa8>
  printf("balloc: out of blocks\n");
    8000386a:	00005517          	auipc	a0,0x5
    8000386e:	da650513          	addi	a0,a0,-602 # 80008610 <syscalls+0x128>
    80003872:	ffffd097          	auipc	ra,0xffffd
    80003876:	d1c080e7          	jalr	-740(ra) # 8000058e <printf>
  return 0;
    8000387a:	4481                	li	s1,0
    8000387c:	bf99                	j	800037d2 <balloc+0x8c>

000000008000387e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000387e:	7179                	addi	sp,sp,-48
    80003880:	f406                	sd	ra,40(sp)
    80003882:	f022                	sd	s0,32(sp)
    80003884:	ec26                	sd	s1,24(sp)
    80003886:	e84a                	sd	s2,16(sp)
    80003888:	e44e                	sd	s3,8(sp)
    8000388a:	e052                	sd	s4,0(sp)
    8000388c:	1800                	addi	s0,sp,48
    8000388e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003890:	47ad                	li	a5,11
    80003892:	02b7e763          	bltu	a5,a1,800038c0 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003896:	02059493          	slli	s1,a1,0x20
    8000389a:	9081                	srli	s1,s1,0x20
    8000389c:	048a                	slli	s1,s1,0x2
    8000389e:	94aa                	add	s1,s1,a0
    800038a0:	0504a903          	lw	s2,80(s1)
    800038a4:	06091e63          	bnez	s2,80003920 <bmap+0xa2>
      addr = balloc(ip->dev);
    800038a8:	4108                	lw	a0,0(a0)
    800038aa:	00000097          	auipc	ra,0x0
    800038ae:	e9c080e7          	jalr	-356(ra) # 80003746 <balloc>
    800038b2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800038b6:	06090563          	beqz	s2,80003920 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800038ba:	0524a823          	sw	s2,80(s1)
    800038be:	a08d                	j	80003920 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800038c0:	ff45849b          	addiw	s1,a1,-12
    800038c4:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800038c8:	0ff00793          	li	a5,255
    800038cc:	08e7e563          	bltu	a5,a4,80003956 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800038d0:	08052903          	lw	s2,128(a0)
    800038d4:	00091d63          	bnez	s2,800038ee <bmap+0x70>
      addr = balloc(ip->dev);
    800038d8:	4108                	lw	a0,0(a0)
    800038da:	00000097          	auipc	ra,0x0
    800038de:	e6c080e7          	jalr	-404(ra) # 80003746 <balloc>
    800038e2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800038e6:	02090d63          	beqz	s2,80003920 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800038ea:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800038ee:	85ca                	mv	a1,s2
    800038f0:	0009a503          	lw	a0,0(s3)
    800038f4:	00000097          	auipc	ra,0x0
    800038f8:	b90080e7          	jalr	-1136(ra) # 80003484 <bread>
    800038fc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800038fe:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003902:	02049593          	slli	a1,s1,0x20
    80003906:	9181                	srli	a1,a1,0x20
    80003908:	058a                	slli	a1,a1,0x2
    8000390a:	00b784b3          	add	s1,a5,a1
    8000390e:	0004a903          	lw	s2,0(s1)
    80003912:	02090063          	beqz	s2,80003932 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003916:	8552                	mv	a0,s4
    80003918:	00000097          	auipc	ra,0x0
    8000391c:	c9c080e7          	jalr	-868(ra) # 800035b4 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003920:	854a                	mv	a0,s2
    80003922:	70a2                	ld	ra,40(sp)
    80003924:	7402                	ld	s0,32(sp)
    80003926:	64e2                	ld	s1,24(sp)
    80003928:	6942                	ld	s2,16(sp)
    8000392a:	69a2                	ld	s3,8(sp)
    8000392c:	6a02                	ld	s4,0(sp)
    8000392e:	6145                	addi	sp,sp,48
    80003930:	8082                	ret
      addr = balloc(ip->dev);
    80003932:	0009a503          	lw	a0,0(s3)
    80003936:	00000097          	auipc	ra,0x0
    8000393a:	e10080e7          	jalr	-496(ra) # 80003746 <balloc>
    8000393e:	0005091b          	sext.w	s2,a0
      if(addr){
    80003942:	fc090ae3          	beqz	s2,80003916 <bmap+0x98>
        a[bn] = addr;
    80003946:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000394a:	8552                	mv	a0,s4
    8000394c:	00001097          	auipc	ra,0x1
    80003950:	eec080e7          	jalr	-276(ra) # 80004838 <log_write>
    80003954:	b7c9                	j	80003916 <bmap+0x98>
  panic("bmap: out of range");
    80003956:	00005517          	auipc	a0,0x5
    8000395a:	cd250513          	addi	a0,a0,-814 # 80008628 <syscalls+0x140>
    8000395e:	ffffd097          	auipc	ra,0xffffd
    80003962:	be6080e7          	jalr	-1050(ra) # 80000544 <panic>

0000000080003966 <iget>:
{
    80003966:	7179                	addi	sp,sp,-48
    80003968:	f406                	sd	ra,40(sp)
    8000396a:	f022                	sd	s0,32(sp)
    8000396c:	ec26                	sd	s1,24(sp)
    8000396e:	e84a                	sd	s2,16(sp)
    80003970:	e44e                	sd	s3,8(sp)
    80003972:	e052                	sd	s4,0(sp)
    80003974:	1800                	addi	s0,sp,48
    80003976:	89aa                	mv	s3,a0
    80003978:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000397a:	0001c517          	auipc	a0,0x1c
    8000397e:	7be50513          	addi	a0,a0,1982 # 80020138 <itable>
    80003982:	ffffd097          	auipc	ra,0xffffd
    80003986:	268080e7          	jalr	616(ra) # 80000bea <acquire>
  empty = 0;
    8000398a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000398c:	0001c497          	auipc	s1,0x1c
    80003990:	7c448493          	addi	s1,s1,1988 # 80020150 <itable+0x18>
    80003994:	0001e697          	auipc	a3,0x1e
    80003998:	24c68693          	addi	a3,a3,588 # 80021be0 <log>
    8000399c:	a039                	j	800039aa <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000399e:	02090b63          	beqz	s2,800039d4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039a2:	08848493          	addi	s1,s1,136
    800039a6:	02d48a63          	beq	s1,a3,800039da <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800039aa:	449c                	lw	a5,8(s1)
    800039ac:	fef059e3          	blez	a5,8000399e <iget+0x38>
    800039b0:	4098                	lw	a4,0(s1)
    800039b2:	ff3716e3          	bne	a4,s3,8000399e <iget+0x38>
    800039b6:	40d8                	lw	a4,4(s1)
    800039b8:	ff4713e3          	bne	a4,s4,8000399e <iget+0x38>
      ip->ref++;
    800039bc:	2785                	addiw	a5,a5,1
    800039be:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800039c0:	0001c517          	auipc	a0,0x1c
    800039c4:	77850513          	addi	a0,a0,1912 # 80020138 <itable>
    800039c8:	ffffd097          	auipc	ra,0xffffd
    800039cc:	2d6080e7          	jalr	726(ra) # 80000c9e <release>
      return ip;
    800039d0:	8926                	mv	s2,s1
    800039d2:	a03d                	j	80003a00 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039d4:	f7f9                	bnez	a5,800039a2 <iget+0x3c>
    800039d6:	8926                	mv	s2,s1
    800039d8:	b7e9                	j	800039a2 <iget+0x3c>
  if(empty == 0)
    800039da:	02090c63          	beqz	s2,80003a12 <iget+0xac>
  ip->dev = dev;
    800039de:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800039e2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800039e6:	4785                	li	a5,1
    800039e8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800039ec:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800039f0:	0001c517          	auipc	a0,0x1c
    800039f4:	74850513          	addi	a0,a0,1864 # 80020138 <itable>
    800039f8:	ffffd097          	auipc	ra,0xffffd
    800039fc:	2a6080e7          	jalr	678(ra) # 80000c9e <release>
}
    80003a00:	854a                	mv	a0,s2
    80003a02:	70a2                	ld	ra,40(sp)
    80003a04:	7402                	ld	s0,32(sp)
    80003a06:	64e2                	ld	s1,24(sp)
    80003a08:	6942                	ld	s2,16(sp)
    80003a0a:	69a2                	ld	s3,8(sp)
    80003a0c:	6a02                	ld	s4,0(sp)
    80003a0e:	6145                	addi	sp,sp,48
    80003a10:	8082                	ret
    panic("iget: no inodes");
    80003a12:	00005517          	auipc	a0,0x5
    80003a16:	c2e50513          	addi	a0,a0,-978 # 80008640 <syscalls+0x158>
    80003a1a:	ffffd097          	auipc	ra,0xffffd
    80003a1e:	b2a080e7          	jalr	-1238(ra) # 80000544 <panic>

0000000080003a22 <fsinit>:
fsinit(int dev) {
    80003a22:	7179                	addi	sp,sp,-48
    80003a24:	f406                	sd	ra,40(sp)
    80003a26:	f022                	sd	s0,32(sp)
    80003a28:	ec26                	sd	s1,24(sp)
    80003a2a:	e84a                	sd	s2,16(sp)
    80003a2c:	e44e                	sd	s3,8(sp)
    80003a2e:	1800                	addi	s0,sp,48
    80003a30:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003a32:	4585                	li	a1,1
    80003a34:	00000097          	auipc	ra,0x0
    80003a38:	a50080e7          	jalr	-1456(ra) # 80003484 <bread>
    80003a3c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a3e:	0001c997          	auipc	s3,0x1c
    80003a42:	6da98993          	addi	s3,s3,1754 # 80020118 <sb>
    80003a46:	02000613          	li	a2,32
    80003a4a:	05850593          	addi	a1,a0,88
    80003a4e:	854e                	mv	a0,s3
    80003a50:	ffffd097          	auipc	ra,0xffffd
    80003a54:	2f6080e7          	jalr	758(ra) # 80000d46 <memmove>
  brelse(bp);
    80003a58:	8526                	mv	a0,s1
    80003a5a:	00000097          	auipc	ra,0x0
    80003a5e:	b5a080e7          	jalr	-1190(ra) # 800035b4 <brelse>
  if(sb.magic != FSMAGIC)
    80003a62:	0009a703          	lw	a4,0(s3)
    80003a66:	102037b7          	lui	a5,0x10203
    80003a6a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a6e:	02f71263          	bne	a4,a5,80003a92 <fsinit+0x70>
  initlog(dev, &sb);
    80003a72:	0001c597          	auipc	a1,0x1c
    80003a76:	6a658593          	addi	a1,a1,1702 # 80020118 <sb>
    80003a7a:	854a                	mv	a0,s2
    80003a7c:	00001097          	auipc	ra,0x1
    80003a80:	b40080e7          	jalr	-1216(ra) # 800045bc <initlog>
}
    80003a84:	70a2                	ld	ra,40(sp)
    80003a86:	7402                	ld	s0,32(sp)
    80003a88:	64e2                	ld	s1,24(sp)
    80003a8a:	6942                	ld	s2,16(sp)
    80003a8c:	69a2                	ld	s3,8(sp)
    80003a8e:	6145                	addi	sp,sp,48
    80003a90:	8082                	ret
    panic("invalid file system");
    80003a92:	00005517          	auipc	a0,0x5
    80003a96:	bbe50513          	addi	a0,a0,-1090 # 80008650 <syscalls+0x168>
    80003a9a:	ffffd097          	auipc	ra,0xffffd
    80003a9e:	aaa080e7          	jalr	-1366(ra) # 80000544 <panic>

0000000080003aa2 <iinit>:
{
    80003aa2:	7179                	addi	sp,sp,-48
    80003aa4:	f406                	sd	ra,40(sp)
    80003aa6:	f022                	sd	s0,32(sp)
    80003aa8:	ec26                	sd	s1,24(sp)
    80003aaa:	e84a                	sd	s2,16(sp)
    80003aac:	e44e                	sd	s3,8(sp)
    80003aae:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003ab0:	00005597          	auipc	a1,0x5
    80003ab4:	bb858593          	addi	a1,a1,-1096 # 80008668 <syscalls+0x180>
    80003ab8:	0001c517          	auipc	a0,0x1c
    80003abc:	68050513          	addi	a0,a0,1664 # 80020138 <itable>
    80003ac0:	ffffd097          	auipc	ra,0xffffd
    80003ac4:	09a080e7          	jalr	154(ra) # 80000b5a <initlock>
  for(i = 0; i < NINODE; i++) {
    80003ac8:	0001c497          	auipc	s1,0x1c
    80003acc:	69848493          	addi	s1,s1,1688 # 80020160 <itable+0x28>
    80003ad0:	0001e997          	auipc	s3,0x1e
    80003ad4:	12098993          	addi	s3,s3,288 # 80021bf0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003ad8:	00005917          	auipc	s2,0x5
    80003adc:	b9890913          	addi	s2,s2,-1128 # 80008670 <syscalls+0x188>
    80003ae0:	85ca                	mv	a1,s2
    80003ae2:	8526                	mv	a0,s1
    80003ae4:	00001097          	auipc	ra,0x1
    80003ae8:	e3a080e7          	jalr	-454(ra) # 8000491e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003aec:	08848493          	addi	s1,s1,136
    80003af0:	ff3498e3          	bne	s1,s3,80003ae0 <iinit+0x3e>
}
    80003af4:	70a2                	ld	ra,40(sp)
    80003af6:	7402                	ld	s0,32(sp)
    80003af8:	64e2                	ld	s1,24(sp)
    80003afa:	6942                	ld	s2,16(sp)
    80003afc:	69a2                	ld	s3,8(sp)
    80003afe:	6145                	addi	sp,sp,48
    80003b00:	8082                	ret

0000000080003b02 <ialloc>:
{
    80003b02:	715d                	addi	sp,sp,-80
    80003b04:	e486                	sd	ra,72(sp)
    80003b06:	e0a2                	sd	s0,64(sp)
    80003b08:	fc26                	sd	s1,56(sp)
    80003b0a:	f84a                	sd	s2,48(sp)
    80003b0c:	f44e                	sd	s3,40(sp)
    80003b0e:	f052                	sd	s4,32(sp)
    80003b10:	ec56                	sd	s5,24(sp)
    80003b12:	e85a                	sd	s6,16(sp)
    80003b14:	e45e                	sd	s7,8(sp)
    80003b16:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b18:	0001c717          	auipc	a4,0x1c
    80003b1c:	60c72703          	lw	a4,1548(a4) # 80020124 <sb+0xc>
    80003b20:	4785                	li	a5,1
    80003b22:	04e7fa63          	bgeu	a5,a4,80003b76 <ialloc+0x74>
    80003b26:	8aaa                	mv	s5,a0
    80003b28:	8bae                	mv	s7,a1
    80003b2a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003b2c:	0001ca17          	auipc	s4,0x1c
    80003b30:	5eca0a13          	addi	s4,s4,1516 # 80020118 <sb>
    80003b34:	00048b1b          	sext.w	s6,s1
    80003b38:	0044d593          	srli	a1,s1,0x4
    80003b3c:	018a2783          	lw	a5,24(s4)
    80003b40:	9dbd                	addw	a1,a1,a5
    80003b42:	8556                	mv	a0,s5
    80003b44:	00000097          	auipc	ra,0x0
    80003b48:	940080e7          	jalr	-1728(ra) # 80003484 <bread>
    80003b4c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b4e:	05850993          	addi	s3,a0,88
    80003b52:	00f4f793          	andi	a5,s1,15
    80003b56:	079a                	slli	a5,a5,0x6
    80003b58:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b5a:	00099783          	lh	a5,0(s3)
    80003b5e:	c3a1                	beqz	a5,80003b9e <ialloc+0x9c>
    brelse(bp);
    80003b60:	00000097          	auipc	ra,0x0
    80003b64:	a54080e7          	jalr	-1452(ra) # 800035b4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b68:	0485                	addi	s1,s1,1
    80003b6a:	00ca2703          	lw	a4,12(s4)
    80003b6e:	0004879b          	sext.w	a5,s1
    80003b72:	fce7e1e3          	bltu	a5,a4,80003b34 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003b76:	00005517          	auipc	a0,0x5
    80003b7a:	b0250513          	addi	a0,a0,-1278 # 80008678 <syscalls+0x190>
    80003b7e:	ffffd097          	auipc	ra,0xffffd
    80003b82:	a10080e7          	jalr	-1520(ra) # 8000058e <printf>
  return 0;
    80003b86:	4501                	li	a0,0
}
    80003b88:	60a6                	ld	ra,72(sp)
    80003b8a:	6406                	ld	s0,64(sp)
    80003b8c:	74e2                	ld	s1,56(sp)
    80003b8e:	7942                	ld	s2,48(sp)
    80003b90:	79a2                	ld	s3,40(sp)
    80003b92:	7a02                	ld	s4,32(sp)
    80003b94:	6ae2                	ld	s5,24(sp)
    80003b96:	6b42                	ld	s6,16(sp)
    80003b98:	6ba2                	ld	s7,8(sp)
    80003b9a:	6161                	addi	sp,sp,80
    80003b9c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003b9e:	04000613          	li	a2,64
    80003ba2:	4581                	li	a1,0
    80003ba4:	854e                	mv	a0,s3
    80003ba6:	ffffd097          	auipc	ra,0xffffd
    80003baa:	140080e7          	jalr	320(ra) # 80000ce6 <memset>
      dip->type = type;
    80003bae:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003bb2:	854a                	mv	a0,s2
    80003bb4:	00001097          	auipc	ra,0x1
    80003bb8:	c84080e7          	jalr	-892(ra) # 80004838 <log_write>
      brelse(bp);
    80003bbc:	854a                	mv	a0,s2
    80003bbe:	00000097          	auipc	ra,0x0
    80003bc2:	9f6080e7          	jalr	-1546(ra) # 800035b4 <brelse>
      return iget(dev, inum);
    80003bc6:	85da                	mv	a1,s6
    80003bc8:	8556                	mv	a0,s5
    80003bca:	00000097          	auipc	ra,0x0
    80003bce:	d9c080e7          	jalr	-612(ra) # 80003966 <iget>
    80003bd2:	bf5d                	j	80003b88 <ialloc+0x86>

0000000080003bd4 <iupdate>:
{
    80003bd4:	1101                	addi	sp,sp,-32
    80003bd6:	ec06                	sd	ra,24(sp)
    80003bd8:	e822                	sd	s0,16(sp)
    80003bda:	e426                	sd	s1,8(sp)
    80003bdc:	e04a                	sd	s2,0(sp)
    80003bde:	1000                	addi	s0,sp,32
    80003be0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003be2:	415c                	lw	a5,4(a0)
    80003be4:	0047d79b          	srliw	a5,a5,0x4
    80003be8:	0001c597          	auipc	a1,0x1c
    80003bec:	5485a583          	lw	a1,1352(a1) # 80020130 <sb+0x18>
    80003bf0:	9dbd                	addw	a1,a1,a5
    80003bf2:	4108                	lw	a0,0(a0)
    80003bf4:	00000097          	auipc	ra,0x0
    80003bf8:	890080e7          	jalr	-1904(ra) # 80003484 <bread>
    80003bfc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003bfe:	05850793          	addi	a5,a0,88
    80003c02:	40c8                	lw	a0,4(s1)
    80003c04:	893d                	andi	a0,a0,15
    80003c06:	051a                	slli	a0,a0,0x6
    80003c08:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003c0a:	04449703          	lh	a4,68(s1)
    80003c0e:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003c12:	04649703          	lh	a4,70(s1)
    80003c16:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003c1a:	04849703          	lh	a4,72(s1)
    80003c1e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003c22:	04a49703          	lh	a4,74(s1)
    80003c26:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003c2a:	44f8                	lw	a4,76(s1)
    80003c2c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c2e:	03400613          	li	a2,52
    80003c32:	05048593          	addi	a1,s1,80
    80003c36:	0531                	addi	a0,a0,12
    80003c38:	ffffd097          	auipc	ra,0xffffd
    80003c3c:	10e080e7          	jalr	270(ra) # 80000d46 <memmove>
  log_write(bp);
    80003c40:	854a                	mv	a0,s2
    80003c42:	00001097          	auipc	ra,0x1
    80003c46:	bf6080e7          	jalr	-1034(ra) # 80004838 <log_write>
  brelse(bp);
    80003c4a:	854a                	mv	a0,s2
    80003c4c:	00000097          	auipc	ra,0x0
    80003c50:	968080e7          	jalr	-1688(ra) # 800035b4 <brelse>
}
    80003c54:	60e2                	ld	ra,24(sp)
    80003c56:	6442                	ld	s0,16(sp)
    80003c58:	64a2                	ld	s1,8(sp)
    80003c5a:	6902                	ld	s2,0(sp)
    80003c5c:	6105                	addi	sp,sp,32
    80003c5e:	8082                	ret

0000000080003c60 <idup>:
{
    80003c60:	1101                	addi	sp,sp,-32
    80003c62:	ec06                	sd	ra,24(sp)
    80003c64:	e822                	sd	s0,16(sp)
    80003c66:	e426                	sd	s1,8(sp)
    80003c68:	1000                	addi	s0,sp,32
    80003c6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c6c:	0001c517          	auipc	a0,0x1c
    80003c70:	4cc50513          	addi	a0,a0,1228 # 80020138 <itable>
    80003c74:	ffffd097          	auipc	ra,0xffffd
    80003c78:	f76080e7          	jalr	-138(ra) # 80000bea <acquire>
  ip->ref++;
    80003c7c:	449c                	lw	a5,8(s1)
    80003c7e:	2785                	addiw	a5,a5,1
    80003c80:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c82:	0001c517          	auipc	a0,0x1c
    80003c86:	4b650513          	addi	a0,a0,1206 # 80020138 <itable>
    80003c8a:	ffffd097          	auipc	ra,0xffffd
    80003c8e:	014080e7          	jalr	20(ra) # 80000c9e <release>
}
    80003c92:	8526                	mv	a0,s1
    80003c94:	60e2                	ld	ra,24(sp)
    80003c96:	6442                	ld	s0,16(sp)
    80003c98:	64a2                	ld	s1,8(sp)
    80003c9a:	6105                	addi	sp,sp,32
    80003c9c:	8082                	ret

0000000080003c9e <ilock>:
{
    80003c9e:	1101                	addi	sp,sp,-32
    80003ca0:	ec06                	sd	ra,24(sp)
    80003ca2:	e822                	sd	s0,16(sp)
    80003ca4:	e426                	sd	s1,8(sp)
    80003ca6:	e04a                	sd	s2,0(sp)
    80003ca8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003caa:	c115                	beqz	a0,80003cce <ilock+0x30>
    80003cac:	84aa                	mv	s1,a0
    80003cae:	451c                	lw	a5,8(a0)
    80003cb0:	00f05f63          	blez	a5,80003cce <ilock+0x30>
  acquiresleep(&ip->lock);
    80003cb4:	0541                	addi	a0,a0,16
    80003cb6:	00001097          	auipc	ra,0x1
    80003cba:	ca2080e7          	jalr	-862(ra) # 80004958 <acquiresleep>
  if(ip->valid == 0){
    80003cbe:	40bc                	lw	a5,64(s1)
    80003cc0:	cf99                	beqz	a5,80003cde <ilock+0x40>
}
    80003cc2:	60e2                	ld	ra,24(sp)
    80003cc4:	6442                	ld	s0,16(sp)
    80003cc6:	64a2                	ld	s1,8(sp)
    80003cc8:	6902                	ld	s2,0(sp)
    80003cca:	6105                	addi	sp,sp,32
    80003ccc:	8082                	ret
    panic("ilock");
    80003cce:	00005517          	auipc	a0,0x5
    80003cd2:	9c250513          	addi	a0,a0,-1598 # 80008690 <syscalls+0x1a8>
    80003cd6:	ffffd097          	auipc	ra,0xffffd
    80003cda:	86e080e7          	jalr	-1938(ra) # 80000544 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003cde:	40dc                	lw	a5,4(s1)
    80003ce0:	0047d79b          	srliw	a5,a5,0x4
    80003ce4:	0001c597          	auipc	a1,0x1c
    80003ce8:	44c5a583          	lw	a1,1100(a1) # 80020130 <sb+0x18>
    80003cec:	9dbd                	addw	a1,a1,a5
    80003cee:	4088                	lw	a0,0(s1)
    80003cf0:	fffff097          	auipc	ra,0xfffff
    80003cf4:	794080e7          	jalr	1940(ra) # 80003484 <bread>
    80003cf8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003cfa:	05850593          	addi	a1,a0,88
    80003cfe:	40dc                	lw	a5,4(s1)
    80003d00:	8bbd                	andi	a5,a5,15
    80003d02:	079a                	slli	a5,a5,0x6
    80003d04:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003d06:	00059783          	lh	a5,0(a1)
    80003d0a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003d0e:	00259783          	lh	a5,2(a1)
    80003d12:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003d16:	00459783          	lh	a5,4(a1)
    80003d1a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d1e:	00659783          	lh	a5,6(a1)
    80003d22:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d26:	459c                	lw	a5,8(a1)
    80003d28:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d2a:	03400613          	li	a2,52
    80003d2e:	05b1                	addi	a1,a1,12
    80003d30:	05048513          	addi	a0,s1,80
    80003d34:	ffffd097          	auipc	ra,0xffffd
    80003d38:	012080e7          	jalr	18(ra) # 80000d46 <memmove>
    brelse(bp);
    80003d3c:	854a                	mv	a0,s2
    80003d3e:	00000097          	auipc	ra,0x0
    80003d42:	876080e7          	jalr	-1930(ra) # 800035b4 <brelse>
    ip->valid = 1;
    80003d46:	4785                	li	a5,1
    80003d48:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d4a:	04449783          	lh	a5,68(s1)
    80003d4e:	fbb5                	bnez	a5,80003cc2 <ilock+0x24>
      panic("ilock: no type");
    80003d50:	00005517          	auipc	a0,0x5
    80003d54:	94850513          	addi	a0,a0,-1720 # 80008698 <syscalls+0x1b0>
    80003d58:	ffffc097          	auipc	ra,0xffffc
    80003d5c:	7ec080e7          	jalr	2028(ra) # 80000544 <panic>

0000000080003d60 <iunlock>:
{
    80003d60:	1101                	addi	sp,sp,-32
    80003d62:	ec06                	sd	ra,24(sp)
    80003d64:	e822                	sd	s0,16(sp)
    80003d66:	e426                	sd	s1,8(sp)
    80003d68:	e04a                	sd	s2,0(sp)
    80003d6a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d6c:	c905                	beqz	a0,80003d9c <iunlock+0x3c>
    80003d6e:	84aa                	mv	s1,a0
    80003d70:	01050913          	addi	s2,a0,16
    80003d74:	854a                	mv	a0,s2
    80003d76:	00001097          	auipc	ra,0x1
    80003d7a:	c7c080e7          	jalr	-900(ra) # 800049f2 <holdingsleep>
    80003d7e:	cd19                	beqz	a0,80003d9c <iunlock+0x3c>
    80003d80:	449c                	lw	a5,8(s1)
    80003d82:	00f05d63          	blez	a5,80003d9c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003d86:	854a                	mv	a0,s2
    80003d88:	00001097          	auipc	ra,0x1
    80003d8c:	c26080e7          	jalr	-986(ra) # 800049ae <releasesleep>
}
    80003d90:	60e2                	ld	ra,24(sp)
    80003d92:	6442                	ld	s0,16(sp)
    80003d94:	64a2                	ld	s1,8(sp)
    80003d96:	6902                	ld	s2,0(sp)
    80003d98:	6105                	addi	sp,sp,32
    80003d9a:	8082                	ret
    panic("iunlock");
    80003d9c:	00005517          	auipc	a0,0x5
    80003da0:	90c50513          	addi	a0,a0,-1780 # 800086a8 <syscalls+0x1c0>
    80003da4:	ffffc097          	auipc	ra,0xffffc
    80003da8:	7a0080e7          	jalr	1952(ra) # 80000544 <panic>

0000000080003dac <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003dac:	7179                	addi	sp,sp,-48
    80003dae:	f406                	sd	ra,40(sp)
    80003db0:	f022                	sd	s0,32(sp)
    80003db2:	ec26                	sd	s1,24(sp)
    80003db4:	e84a                	sd	s2,16(sp)
    80003db6:	e44e                	sd	s3,8(sp)
    80003db8:	e052                	sd	s4,0(sp)
    80003dba:	1800                	addi	s0,sp,48
    80003dbc:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003dbe:	05050493          	addi	s1,a0,80
    80003dc2:	08050913          	addi	s2,a0,128
    80003dc6:	a021                	j	80003dce <itrunc+0x22>
    80003dc8:	0491                	addi	s1,s1,4
    80003dca:	01248d63          	beq	s1,s2,80003de4 <itrunc+0x38>
    if(ip->addrs[i]){
    80003dce:	408c                	lw	a1,0(s1)
    80003dd0:	dde5                	beqz	a1,80003dc8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003dd2:	0009a503          	lw	a0,0(s3)
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	8f4080e7          	jalr	-1804(ra) # 800036ca <bfree>
      ip->addrs[i] = 0;
    80003dde:	0004a023          	sw	zero,0(s1)
    80003de2:	b7dd                	j	80003dc8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003de4:	0809a583          	lw	a1,128(s3)
    80003de8:	e185                	bnez	a1,80003e08 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003dea:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003dee:	854e                	mv	a0,s3
    80003df0:	00000097          	auipc	ra,0x0
    80003df4:	de4080e7          	jalr	-540(ra) # 80003bd4 <iupdate>
}
    80003df8:	70a2                	ld	ra,40(sp)
    80003dfa:	7402                	ld	s0,32(sp)
    80003dfc:	64e2                	ld	s1,24(sp)
    80003dfe:	6942                	ld	s2,16(sp)
    80003e00:	69a2                	ld	s3,8(sp)
    80003e02:	6a02                	ld	s4,0(sp)
    80003e04:	6145                	addi	sp,sp,48
    80003e06:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003e08:	0009a503          	lw	a0,0(s3)
    80003e0c:	fffff097          	auipc	ra,0xfffff
    80003e10:	678080e7          	jalr	1656(ra) # 80003484 <bread>
    80003e14:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e16:	05850493          	addi	s1,a0,88
    80003e1a:	45850913          	addi	s2,a0,1112
    80003e1e:	a811                	j	80003e32 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80003e20:	0009a503          	lw	a0,0(s3)
    80003e24:	00000097          	auipc	ra,0x0
    80003e28:	8a6080e7          	jalr	-1882(ra) # 800036ca <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003e2c:	0491                	addi	s1,s1,4
    80003e2e:	01248563          	beq	s1,s2,80003e38 <itrunc+0x8c>
      if(a[j])
    80003e32:	408c                	lw	a1,0(s1)
    80003e34:	dde5                	beqz	a1,80003e2c <itrunc+0x80>
    80003e36:	b7ed                	j	80003e20 <itrunc+0x74>
    brelse(bp);
    80003e38:	8552                	mv	a0,s4
    80003e3a:	fffff097          	auipc	ra,0xfffff
    80003e3e:	77a080e7          	jalr	1914(ra) # 800035b4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e42:	0809a583          	lw	a1,128(s3)
    80003e46:	0009a503          	lw	a0,0(s3)
    80003e4a:	00000097          	auipc	ra,0x0
    80003e4e:	880080e7          	jalr	-1920(ra) # 800036ca <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e52:	0809a023          	sw	zero,128(s3)
    80003e56:	bf51                	j	80003dea <itrunc+0x3e>

0000000080003e58 <iput>:
{
    80003e58:	1101                	addi	sp,sp,-32
    80003e5a:	ec06                	sd	ra,24(sp)
    80003e5c:	e822                	sd	s0,16(sp)
    80003e5e:	e426                	sd	s1,8(sp)
    80003e60:	e04a                	sd	s2,0(sp)
    80003e62:	1000                	addi	s0,sp,32
    80003e64:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e66:	0001c517          	auipc	a0,0x1c
    80003e6a:	2d250513          	addi	a0,a0,722 # 80020138 <itable>
    80003e6e:	ffffd097          	auipc	ra,0xffffd
    80003e72:	d7c080e7          	jalr	-644(ra) # 80000bea <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e76:	4498                	lw	a4,8(s1)
    80003e78:	4785                	li	a5,1
    80003e7a:	02f70363          	beq	a4,a5,80003ea0 <iput+0x48>
  ip->ref--;
    80003e7e:	449c                	lw	a5,8(s1)
    80003e80:	37fd                	addiw	a5,a5,-1
    80003e82:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e84:	0001c517          	auipc	a0,0x1c
    80003e88:	2b450513          	addi	a0,a0,692 # 80020138 <itable>
    80003e8c:	ffffd097          	auipc	ra,0xffffd
    80003e90:	e12080e7          	jalr	-494(ra) # 80000c9e <release>
}
    80003e94:	60e2                	ld	ra,24(sp)
    80003e96:	6442                	ld	s0,16(sp)
    80003e98:	64a2                	ld	s1,8(sp)
    80003e9a:	6902                	ld	s2,0(sp)
    80003e9c:	6105                	addi	sp,sp,32
    80003e9e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ea0:	40bc                	lw	a5,64(s1)
    80003ea2:	dff1                	beqz	a5,80003e7e <iput+0x26>
    80003ea4:	04a49783          	lh	a5,74(s1)
    80003ea8:	fbf9                	bnez	a5,80003e7e <iput+0x26>
    acquiresleep(&ip->lock);
    80003eaa:	01048913          	addi	s2,s1,16
    80003eae:	854a                	mv	a0,s2
    80003eb0:	00001097          	auipc	ra,0x1
    80003eb4:	aa8080e7          	jalr	-1368(ra) # 80004958 <acquiresleep>
    release(&itable.lock);
    80003eb8:	0001c517          	auipc	a0,0x1c
    80003ebc:	28050513          	addi	a0,a0,640 # 80020138 <itable>
    80003ec0:	ffffd097          	auipc	ra,0xffffd
    80003ec4:	dde080e7          	jalr	-546(ra) # 80000c9e <release>
    itrunc(ip);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	ee2080e7          	jalr	-286(ra) # 80003dac <itrunc>
    ip->type = 0;
    80003ed2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	00000097          	auipc	ra,0x0
    80003edc:	cfc080e7          	jalr	-772(ra) # 80003bd4 <iupdate>
    ip->valid = 0;
    80003ee0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ee4:	854a                	mv	a0,s2
    80003ee6:	00001097          	auipc	ra,0x1
    80003eea:	ac8080e7          	jalr	-1336(ra) # 800049ae <releasesleep>
    acquire(&itable.lock);
    80003eee:	0001c517          	auipc	a0,0x1c
    80003ef2:	24a50513          	addi	a0,a0,586 # 80020138 <itable>
    80003ef6:	ffffd097          	auipc	ra,0xffffd
    80003efa:	cf4080e7          	jalr	-780(ra) # 80000bea <acquire>
    80003efe:	b741                	j	80003e7e <iput+0x26>

0000000080003f00 <iunlockput>:
{
    80003f00:	1101                	addi	sp,sp,-32
    80003f02:	ec06                	sd	ra,24(sp)
    80003f04:	e822                	sd	s0,16(sp)
    80003f06:	e426                	sd	s1,8(sp)
    80003f08:	1000                	addi	s0,sp,32
    80003f0a:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	e54080e7          	jalr	-428(ra) # 80003d60 <iunlock>
  iput(ip);
    80003f14:	8526                	mv	a0,s1
    80003f16:	00000097          	auipc	ra,0x0
    80003f1a:	f42080e7          	jalr	-190(ra) # 80003e58 <iput>
}
    80003f1e:	60e2                	ld	ra,24(sp)
    80003f20:	6442                	ld	s0,16(sp)
    80003f22:	64a2                	ld	s1,8(sp)
    80003f24:	6105                	addi	sp,sp,32
    80003f26:	8082                	ret

0000000080003f28 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f28:	1141                	addi	sp,sp,-16
    80003f2a:	e422                	sd	s0,8(sp)
    80003f2c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f2e:	411c                	lw	a5,0(a0)
    80003f30:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f32:	415c                	lw	a5,4(a0)
    80003f34:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f36:	04451783          	lh	a5,68(a0)
    80003f3a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f3e:	04a51783          	lh	a5,74(a0)
    80003f42:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f46:	04c56783          	lwu	a5,76(a0)
    80003f4a:	e99c                	sd	a5,16(a1)
}
    80003f4c:	6422                	ld	s0,8(sp)
    80003f4e:	0141                	addi	sp,sp,16
    80003f50:	8082                	ret

0000000080003f52 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f52:	457c                	lw	a5,76(a0)
    80003f54:	0ed7e963          	bltu	a5,a3,80004046 <readi+0xf4>
{
    80003f58:	7159                	addi	sp,sp,-112
    80003f5a:	f486                	sd	ra,104(sp)
    80003f5c:	f0a2                	sd	s0,96(sp)
    80003f5e:	eca6                	sd	s1,88(sp)
    80003f60:	e8ca                	sd	s2,80(sp)
    80003f62:	e4ce                	sd	s3,72(sp)
    80003f64:	e0d2                	sd	s4,64(sp)
    80003f66:	fc56                	sd	s5,56(sp)
    80003f68:	f85a                	sd	s6,48(sp)
    80003f6a:	f45e                	sd	s7,40(sp)
    80003f6c:	f062                	sd	s8,32(sp)
    80003f6e:	ec66                	sd	s9,24(sp)
    80003f70:	e86a                	sd	s10,16(sp)
    80003f72:	e46e                	sd	s11,8(sp)
    80003f74:	1880                	addi	s0,sp,112
    80003f76:	8b2a                	mv	s6,a0
    80003f78:	8bae                	mv	s7,a1
    80003f7a:	8a32                	mv	s4,a2
    80003f7c:	84b6                	mv	s1,a3
    80003f7e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003f80:	9f35                	addw	a4,a4,a3
    return 0;
    80003f82:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003f84:	0ad76063          	bltu	a4,a3,80004024 <readi+0xd2>
  if(off + n > ip->size)
    80003f88:	00e7f463          	bgeu	a5,a4,80003f90 <readi+0x3e>
    n = ip->size - off;
    80003f8c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003f90:	0a0a8963          	beqz	s5,80004042 <readi+0xf0>
    80003f94:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f96:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f9a:	5c7d                	li	s8,-1
    80003f9c:	a82d                	j	80003fd6 <readi+0x84>
    80003f9e:	020d1d93          	slli	s11,s10,0x20
    80003fa2:	020ddd93          	srli	s11,s11,0x20
    80003fa6:	05890613          	addi	a2,s2,88
    80003faa:	86ee                	mv	a3,s11
    80003fac:	963a                	add	a2,a2,a4
    80003fae:	85d2                	mv	a1,s4
    80003fb0:	855e                	mv	a0,s7
    80003fb2:	fffff097          	auipc	ra,0xfffff
    80003fb6:	98e080e7          	jalr	-1650(ra) # 80002940 <either_copyout>
    80003fba:	05850d63          	beq	a0,s8,80004014 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003fbe:	854a                	mv	a0,s2
    80003fc0:	fffff097          	auipc	ra,0xfffff
    80003fc4:	5f4080e7          	jalr	1524(ra) # 800035b4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fc8:	013d09bb          	addw	s3,s10,s3
    80003fcc:	009d04bb          	addw	s1,s10,s1
    80003fd0:	9a6e                	add	s4,s4,s11
    80003fd2:	0559f763          	bgeu	s3,s5,80004020 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003fd6:	00a4d59b          	srliw	a1,s1,0xa
    80003fda:	855a                	mv	a0,s6
    80003fdc:	00000097          	auipc	ra,0x0
    80003fe0:	8a2080e7          	jalr	-1886(ra) # 8000387e <bmap>
    80003fe4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003fe8:	cd85                	beqz	a1,80004020 <readi+0xce>
    bp = bread(ip->dev, addr);
    80003fea:	000b2503          	lw	a0,0(s6)
    80003fee:	fffff097          	auipc	ra,0xfffff
    80003ff2:	496080e7          	jalr	1174(ra) # 80003484 <bread>
    80003ff6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ff8:	3ff4f713          	andi	a4,s1,1023
    80003ffc:	40ec87bb          	subw	a5,s9,a4
    80004000:	413a86bb          	subw	a3,s5,s3
    80004004:	8d3e                	mv	s10,a5
    80004006:	2781                	sext.w	a5,a5
    80004008:	0006861b          	sext.w	a2,a3
    8000400c:	f8f679e3          	bgeu	a2,a5,80003f9e <readi+0x4c>
    80004010:	8d36                	mv	s10,a3
    80004012:	b771                	j	80003f9e <readi+0x4c>
      brelse(bp);
    80004014:	854a                	mv	a0,s2
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	59e080e7          	jalr	1438(ra) # 800035b4 <brelse>
      tot = -1;
    8000401e:	59fd                	li	s3,-1
  }
  return tot;
    80004020:	0009851b          	sext.w	a0,s3
}
    80004024:	70a6                	ld	ra,104(sp)
    80004026:	7406                	ld	s0,96(sp)
    80004028:	64e6                	ld	s1,88(sp)
    8000402a:	6946                	ld	s2,80(sp)
    8000402c:	69a6                	ld	s3,72(sp)
    8000402e:	6a06                	ld	s4,64(sp)
    80004030:	7ae2                	ld	s5,56(sp)
    80004032:	7b42                	ld	s6,48(sp)
    80004034:	7ba2                	ld	s7,40(sp)
    80004036:	7c02                	ld	s8,32(sp)
    80004038:	6ce2                	ld	s9,24(sp)
    8000403a:	6d42                	ld	s10,16(sp)
    8000403c:	6da2                	ld	s11,8(sp)
    8000403e:	6165                	addi	sp,sp,112
    80004040:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004042:	89d6                	mv	s3,s5
    80004044:	bff1                	j	80004020 <readi+0xce>
    return 0;
    80004046:	4501                	li	a0,0
}
    80004048:	8082                	ret

000000008000404a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000404a:	457c                	lw	a5,76(a0)
    8000404c:	10d7e863          	bltu	a5,a3,8000415c <writei+0x112>
{
    80004050:	7159                	addi	sp,sp,-112
    80004052:	f486                	sd	ra,104(sp)
    80004054:	f0a2                	sd	s0,96(sp)
    80004056:	eca6                	sd	s1,88(sp)
    80004058:	e8ca                	sd	s2,80(sp)
    8000405a:	e4ce                	sd	s3,72(sp)
    8000405c:	e0d2                	sd	s4,64(sp)
    8000405e:	fc56                	sd	s5,56(sp)
    80004060:	f85a                	sd	s6,48(sp)
    80004062:	f45e                	sd	s7,40(sp)
    80004064:	f062                	sd	s8,32(sp)
    80004066:	ec66                	sd	s9,24(sp)
    80004068:	e86a                	sd	s10,16(sp)
    8000406a:	e46e                	sd	s11,8(sp)
    8000406c:	1880                	addi	s0,sp,112
    8000406e:	8aaa                	mv	s5,a0
    80004070:	8bae                	mv	s7,a1
    80004072:	8a32                	mv	s4,a2
    80004074:	8936                	mv	s2,a3
    80004076:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004078:	00e687bb          	addw	a5,a3,a4
    8000407c:	0ed7e263          	bltu	a5,a3,80004160 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004080:	00043737          	lui	a4,0x43
    80004084:	0ef76063          	bltu	a4,a5,80004164 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004088:	0c0b0863          	beqz	s6,80004158 <writei+0x10e>
    8000408c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000408e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004092:	5c7d                	li	s8,-1
    80004094:	a091                	j	800040d8 <writei+0x8e>
    80004096:	020d1d93          	slli	s11,s10,0x20
    8000409a:	020ddd93          	srli	s11,s11,0x20
    8000409e:	05848513          	addi	a0,s1,88
    800040a2:	86ee                	mv	a3,s11
    800040a4:	8652                	mv	a2,s4
    800040a6:	85de                	mv	a1,s7
    800040a8:	953a                	add	a0,a0,a4
    800040aa:	fffff097          	auipc	ra,0xfffff
    800040ae:	8ec080e7          	jalr	-1812(ra) # 80002996 <either_copyin>
    800040b2:	07850263          	beq	a0,s8,80004116 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800040b6:	8526                	mv	a0,s1
    800040b8:	00000097          	auipc	ra,0x0
    800040bc:	780080e7          	jalr	1920(ra) # 80004838 <log_write>
    brelse(bp);
    800040c0:	8526                	mv	a0,s1
    800040c2:	fffff097          	auipc	ra,0xfffff
    800040c6:	4f2080e7          	jalr	1266(ra) # 800035b4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040ca:	013d09bb          	addw	s3,s10,s3
    800040ce:	012d093b          	addw	s2,s10,s2
    800040d2:	9a6e                	add	s4,s4,s11
    800040d4:	0569f663          	bgeu	s3,s6,80004120 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800040d8:	00a9559b          	srliw	a1,s2,0xa
    800040dc:	8556                	mv	a0,s5
    800040de:	fffff097          	auipc	ra,0xfffff
    800040e2:	7a0080e7          	jalr	1952(ra) # 8000387e <bmap>
    800040e6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800040ea:	c99d                	beqz	a1,80004120 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800040ec:	000aa503          	lw	a0,0(s5)
    800040f0:	fffff097          	auipc	ra,0xfffff
    800040f4:	394080e7          	jalr	916(ra) # 80003484 <bread>
    800040f8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800040fa:	3ff97713          	andi	a4,s2,1023
    800040fe:	40ec87bb          	subw	a5,s9,a4
    80004102:	413b06bb          	subw	a3,s6,s3
    80004106:	8d3e                	mv	s10,a5
    80004108:	2781                	sext.w	a5,a5
    8000410a:	0006861b          	sext.w	a2,a3
    8000410e:	f8f674e3          	bgeu	a2,a5,80004096 <writei+0x4c>
    80004112:	8d36                	mv	s10,a3
    80004114:	b749                	j	80004096 <writei+0x4c>
      brelse(bp);
    80004116:	8526                	mv	a0,s1
    80004118:	fffff097          	auipc	ra,0xfffff
    8000411c:	49c080e7          	jalr	1180(ra) # 800035b4 <brelse>
  }

  if(off > ip->size)
    80004120:	04caa783          	lw	a5,76(s5)
    80004124:	0127f463          	bgeu	a5,s2,8000412c <writei+0xe2>
    ip->size = off;
    80004128:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000412c:	8556                	mv	a0,s5
    8000412e:	00000097          	auipc	ra,0x0
    80004132:	aa6080e7          	jalr	-1370(ra) # 80003bd4 <iupdate>

  return tot;
    80004136:	0009851b          	sext.w	a0,s3
}
    8000413a:	70a6                	ld	ra,104(sp)
    8000413c:	7406                	ld	s0,96(sp)
    8000413e:	64e6                	ld	s1,88(sp)
    80004140:	6946                	ld	s2,80(sp)
    80004142:	69a6                	ld	s3,72(sp)
    80004144:	6a06                	ld	s4,64(sp)
    80004146:	7ae2                	ld	s5,56(sp)
    80004148:	7b42                	ld	s6,48(sp)
    8000414a:	7ba2                	ld	s7,40(sp)
    8000414c:	7c02                	ld	s8,32(sp)
    8000414e:	6ce2                	ld	s9,24(sp)
    80004150:	6d42                	ld	s10,16(sp)
    80004152:	6da2                	ld	s11,8(sp)
    80004154:	6165                	addi	sp,sp,112
    80004156:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004158:	89da                	mv	s3,s6
    8000415a:	bfc9                	j	8000412c <writei+0xe2>
    return -1;
    8000415c:	557d                	li	a0,-1
}
    8000415e:	8082                	ret
    return -1;
    80004160:	557d                	li	a0,-1
    80004162:	bfe1                	j	8000413a <writei+0xf0>
    return -1;
    80004164:	557d                	li	a0,-1
    80004166:	bfd1                	j	8000413a <writei+0xf0>

0000000080004168 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004168:	1141                	addi	sp,sp,-16
    8000416a:	e406                	sd	ra,8(sp)
    8000416c:	e022                	sd	s0,0(sp)
    8000416e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004170:	4639                	li	a2,14
    80004172:	ffffd097          	auipc	ra,0xffffd
    80004176:	c4c080e7          	jalr	-948(ra) # 80000dbe <strncmp>
}
    8000417a:	60a2                	ld	ra,8(sp)
    8000417c:	6402                	ld	s0,0(sp)
    8000417e:	0141                	addi	sp,sp,16
    80004180:	8082                	ret

0000000080004182 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004182:	7139                	addi	sp,sp,-64
    80004184:	fc06                	sd	ra,56(sp)
    80004186:	f822                	sd	s0,48(sp)
    80004188:	f426                	sd	s1,40(sp)
    8000418a:	f04a                	sd	s2,32(sp)
    8000418c:	ec4e                	sd	s3,24(sp)
    8000418e:	e852                	sd	s4,16(sp)
    80004190:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004192:	04451703          	lh	a4,68(a0)
    80004196:	4785                	li	a5,1
    80004198:	00f71a63          	bne	a4,a5,800041ac <dirlookup+0x2a>
    8000419c:	892a                	mv	s2,a0
    8000419e:	89ae                	mv	s3,a1
    800041a0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800041a2:	457c                	lw	a5,76(a0)
    800041a4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800041a6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041a8:	e79d                	bnez	a5,800041d6 <dirlookup+0x54>
    800041aa:	a8a5                	j	80004222 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800041ac:	00004517          	auipc	a0,0x4
    800041b0:	50450513          	addi	a0,a0,1284 # 800086b0 <syscalls+0x1c8>
    800041b4:	ffffc097          	auipc	ra,0xffffc
    800041b8:	390080e7          	jalr	912(ra) # 80000544 <panic>
      panic("dirlookup read");
    800041bc:	00004517          	auipc	a0,0x4
    800041c0:	50c50513          	addi	a0,a0,1292 # 800086c8 <syscalls+0x1e0>
    800041c4:	ffffc097          	auipc	ra,0xffffc
    800041c8:	380080e7          	jalr	896(ra) # 80000544 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041cc:	24c1                	addiw	s1,s1,16
    800041ce:	04c92783          	lw	a5,76(s2)
    800041d2:	04f4f763          	bgeu	s1,a5,80004220 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041d6:	4741                	li	a4,16
    800041d8:	86a6                	mv	a3,s1
    800041da:	fc040613          	addi	a2,s0,-64
    800041de:	4581                	li	a1,0
    800041e0:	854a                	mv	a0,s2
    800041e2:	00000097          	auipc	ra,0x0
    800041e6:	d70080e7          	jalr	-656(ra) # 80003f52 <readi>
    800041ea:	47c1                	li	a5,16
    800041ec:	fcf518e3          	bne	a0,a5,800041bc <dirlookup+0x3a>
    if(de.inum == 0)
    800041f0:	fc045783          	lhu	a5,-64(s0)
    800041f4:	dfe1                	beqz	a5,800041cc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800041f6:	fc240593          	addi	a1,s0,-62
    800041fa:	854e                	mv	a0,s3
    800041fc:	00000097          	auipc	ra,0x0
    80004200:	f6c080e7          	jalr	-148(ra) # 80004168 <namecmp>
    80004204:	f561                	bnez	a0,800041cc <dirlookup+0x4a>
      if(poff)
    80004206:	000a0463          	beqz	s4,8000420e <dirlookup+0x8c>
        *poff = off;
    8000420a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000420e:	fc045583          	lhu	a1,-64(s0)
    80004212:	00092503          	lw	a0,0(s2)
    80004216:	fffff097          	auipc	ra,0xfffff
    8000421a:	750080e7          	jalr	1872(ra) # 80003966 <iget>
    8000421e:	a011                	j	80004222 <dirlookup+0xa0>
  return 0;
    80004220:	4501                	li	a0,0
}
    80004222:	70e2                	ld	ra,56(sp)
    80004224:	7442                	ld	s0,48(sp)
    80004226:	74a2                	ld	s1,40(sp)
    80004228:	7902                	ld	s2,32(sp)
    8000422a:	69e2                	ld	s3,24(sp)
    8000422c:	6a42                	ld	s4,16(sp)
    8000422e:	6121                	addi	sp,sp,64
    80004230:	8082                	ret

0000000080004232 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004232:	711d                	addi	sp,sp,-96
    80004234:	ec86                	sd	ra,88(sp)
    80004236:	e8a2                	sd	s0,80(sp)
    80004238:	e4a6                	sd	s1,72(sp)
    8000423a:	e0ca                	sd	s2,64(sp)
    8000423c:	fc4e                	sd	s3,56(sp)
    8000423e:	f852                	sd	s4,48(sp)
    80004240:	f456                	sd	s5,40(sp)
    80004242:	f05a                	sd	s6,32(sp)
    80004244:	ec5e                	sd	s7,24(sp)
    80004246:	e862                	sd	s8,16(sp)
    80004248:	e466                	sd	s9,8(sp)
    8000424a:	1080                	addi	s0,sp,96
    8000424c:	84aa                	mv	s1,a0
    8000424e:	8b2e                	mv	s6,a1
    80004250:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004252:	00054703          	lbu	a4,0(a0)
    80004256:	02f00793          	li	a5,47
    8000425a:	02f70363          	beq	a4,a5,80004280 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000425e:	ffffd097          	auipc	ra,0xffffd
    80004262:	77e080e7          	jalr	1918(ra) # 800019dc <myproc>
    80004266:	19053503          	ld	a0,400(a0)
    8000426a:	00000097          	auipc	ra,0x0
    8000426e:	9f6080e7          	jalr	-1546(ra) # 80003c60 <idup>
    80004272:	89aa                	mv	s3,a0
  while(*path == '/')
    80004274:	02f00913          	li	s2,47
  len = path - s;
    80004278:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000427a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000427c:	4c05                	li	s8,1
    8000427e:	a865                	j	80004336 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004280:	4585                	li	a1,1
    80004282:	4505                	li	a0,1
    80004284:	fffff097          	auipc	ra,0xfffff
    80004288:	6e2080e7          	jalr	1762(ra) # 80003966 <iget>
    8000428c:	89aa                	mv	s3,a0
    8000428e:	b7dd                	j	80004274 <namex+0x42>
      iunlockput(ip);
    80004290:	854e                	mv	a0,s3
    80004292:	00000097          	auipc	ra,0x0
    80004296:	c6e080e7          	jalr	-914(ra) # 80003f00 <iunlockput>
      return 0;
    8000429a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000429c:	854e                	mv	a0,s3
    8000429e:	60e6                	ld	ra,88(sp)
    800042a0:	6446                	ld	s0,80(sp)
    800042a2:	64a6                	ld	s1,72(sp)
    800042a4:	6906                	ld	s2,64(sp)
    800042a6:	79e2                	ld	s3,56(sp)
    800042a8:	7a42                	ld	s4,48(sp)
    800042aa:	7aa2                	ld	s5,40(sp)
    800042ac:	7b02                	ld	s6,32(sp)
    800042ae:	6be2                	ld	s7,24(sp)
    800042b0:	6c42                	ld	s8,16(sp)
    800042b2:	6ca2                	ld	s9,8(sp)
    800042b4:	6125                	addi	sp,sp,96
    800042b6:	8082                	ret
      iunlock(ip);
    800042b8:	854e                	mv	a0,s3
    800042ba:	00000097          	auipc	ra,0x0
    800042be:	aa6080e7          	jalr	-1370(ra) # 80003d60 <iunlock>
      return ip;
    800042c2:	bfe9                	j	8000429c <namex+0x6a>
      iunlockput(ip);
    800042c4:	854e                	mv	a0,s3
    800042c6:	00000097          	auipc	ra,0x0
    800042ca:	c3a080e7          	jalr	-966(ra) # 80003f00 <iunlockput>
      return 0;
    800042ce:	89d2                	mv	s3,s4
    800042d0:	b7f1                	j	8000429c <namex+0x6a>
  len = path - s;
    800042d2:	40b48633          	sub	a2,s1,a1
    800042d6:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800042da:	094cd463          	bge	s9,s4,80004362 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800042de:	4639                	li	a2,14
    800042e0:	8556                	mv	a0,s5
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	a64080e7          	jalr	-1436(ra) # 80000d46 <memmove>
  while(*path == '/')
    800042ea:	0004c783          	lbu	a5,0(s1)
    800042ee:	01279763          	bne	a5,s2,800042fc <namex+0xca>
    path++;
    800042f2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800042f4:	0004c783          	lbu	a5,0(s1)
    800042f8:	ff278de3          	beq	a5,s2,800042f2 <namex+0xc0>
    ilock(ip);
    800042fc:	854e                	mv	a0,s3
    800042fe:	00000097          	auipc	ra,0x0
    80004302:	9a0080e7          	jalr	-1632(ra) # 80003c9e <ilock>
    if(ip->type != T_DIR){
    80004306:	04499783          	lh	a5,68(s3)
    8000430a:	f98793e3          	bne	a5,s8,80004290 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000430e:	000b0563          	beqz	s6,80004318 <namex+0xe6>
    80004312:	0004c783          	lbu	a5,0(s1)
    80004316:	d3cd                	beqz	a5,800042b8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004318:	865e                	mv	a2,s7
    8000431a:	85d6                	mv	a1,s5
    8000431c:	854e                	mv	a0,s3
    8000431e:	00000097          	auipc	ra,0x0
    80004322:	e64080e7          	jalr	-412(ra) # 80004182 <dirlookup>
    80004326:	8a2a                	mv	s4,a0
    80004328:	dd51                	beqz	a0,800042c4 <namex+0x92>
    iunlockput(ip);
    8000432a:	854e                	mv	a0,s3
    8000432c:	00000097          	auipc	ra,0x0
    80004330:	bd4080e7          	jalr	-1068(ra) # 80003f00 <iunlockput>
    ip = next;
    80004334:	89d2                	mv	s3,s4
  while(*path == '/')
    80004336:	0004c783          	lbu	a5,0(s1)
    8000433a:	05279763          	bne	a5,s2,80004388 <namex+0x156>
    path++;
    8000433e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004340:	0004c783          	lbu	a5,0(s1)
    80004344:	ff278de3          	beq	a5,s2,8000433e <namex+0x10c>
  if(*path == 0)
    80004348:	c79d                	beqz	a5,80004376 <namex+0x144>
    path++;
    8000434a:	85a6                	mv	a1,s1
  len = path - s;
    8000434c:	8a5e                	mv	s4,s7
    8000434e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80004350:	01278963          	beq	a5,s2,80004362 <namex+0x130>
    80004354:	dfbd                	beqz	a5,800042d2 <namex+0xa0>
    path++;
    80004356:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80004358:	0004c783          	lbu	a5,0(s1)
    8000435c:	ff279ce3          	bne	a5,s2,80004354 <namex+0x122>
    80004360:	bf8d                	j	800042d2 <namex+0xa0>
    memmove(name, s, len);
    80004362:	2601                	sext.w	a2,a2
    80004364:	8556                	mv	a0,s5
    80004366:	ffffd097          	auipc	ra,0xffffd
    8000436a:	9e0080e7          	jalr	-1568(ra) # 80000d46 <memmove>
    name[len] = 0;
    8000436e:	9a56                	add	s4,s4,s5
    80004370:	000a0023          	sb	zero,0(s4)
    80004374:	bf9d                	j	800042ea <namex+0xb8>
  if(nameiparent){
    80004376:	f20b03e3          	beqz	s6,8000429c <namex+0x6a>
    iput(ip);
    8000437a:	854e                	mv	a0,s3
    8000437c:	00000097          	auipc	ra,0x0
    80004380:	adc080e7          	jalr	-1316(ra) # 80003e58 <iput>
    return 0;
    80004384:	4981                	li	s3,0
    80004386:	bf19                	j	8000429c <namex+0x6a>
  if(*path == 0)
    80004388:	d7fd                	beqz	a5,80004376 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000438a:	0004c783          	lbu	a5,0(s1)
    8000438e:	85a6                	mv	a1,s1
    80004390:	b7d1                	j	80004354 <namex+0x122>

0000000080004392 <dirlink>:
{
    80004392:	7139                	addi	sp,sp,-64
    80004394:	fc06                	sd	ra,56(sp)
    80004396:	f822                	sd	s0,48(sp)
    80004398:	f426                	sd	s1,40(sp)
    8000439a:	f04a                	sd	s2,32(sp)
    8000439c:	ec4e                	sd	s3,24(sp)
    8000439e:	e852                	sd	s4,16(sp)
    800043a0:	0080                	addi	s0,sp,64
    800043a2:	892a                	mv	s2,a0
    800043a4:	8a2e                	mv	s4,a1
    800043a6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800043a8:	4601                	li	a2,0
    800043aa:	00000097          	auipc	ra,0x0
    800043ae:	dd8080e7          	jalr	-552(ra) # 80004182 <dirlookup>
    800043b2:	e93d                	bnez	a0,80004428 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043b4:	04c92483          	lw	s1,76(s2)
    800043b8:	c49d                	beqz	s1,800043e6 <dirlink+0x54>
    800043ba:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043bc:	4741                	li	a4,16
    800043be:	86a6                	mv	a3,s1
    800043c0:	fc040613          	addi	a2,s0,-64
    800043c4:	4581                	li	a1,0
    800043c6:	854a                	mv	a0,s2
    800043c8:	00000097          	auipc	ra,0x0
    800043cc:	b8a080e7          	jalr	-1142(ra) # 80003f52 <readi>
    800043d0:	47c1                	li	a5,16
    800043d2:	06f51163          	bne	a0,a5,80004434 <dirlink+0xa2>
    if(de.inum == 0)
    800043d6:	fc045783          	lhu	a5,-64(s0)
    800043da:	c791                	beqz	a5,800043e6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043dc:	24c1                	addiw	s1,s1,16
    800043de:	04c92783          	lw	a5,76(s2)
    800043e2:	fcf4ede3          	bltu	s1,a5,800043bc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800043e6:	4639                	li	a2,14
    800043e8:	85d2                	mv	a1,s4
    800043ea:	fc240513          	addi	a0,s0,-62
    800043ee:	ffffd097          	auipc	ra,0xffffd
    800043f2:	a0c080e7          	jalr	-1524(ra) # 80000dfa <strncpy>
  de.inum = inum;
    800043f6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043fa:	4741                	li	a4,16
    800043fc:	86a6                	mv	a3,s1
    800043fe:	fc040613          	addi	a2,s0,-64
    80004402:	4581                	li	a1,0
    80004404:	854a                	mv	a0,s2
    80004406:	00000097          	auipc	ra,0x0
    8000440a:	c44080e7          	jalr	-956(ra) # 8000404a <writei>
    8000440e:	1541                	addi	a0,a0,-16
    80004410:	00a03533          	snez	a0,a0
    80004414:	40a00533          	neg	a0,a0
}
    80004418:	70e2                	ld	ra,56(sp)
    8000441a:	7442                	ld	s0,48(sp)
    8000441c:	74a2                	ld	s1,40(sp)
    8000441e:	7902                	ld	s2,32(sp)
    80004420:	69e2                	ld	s3,24(sp)
    80004422:	6a42                	ld	s4,16(sp)
    80004424:	6121                	addi	sp,sp,64
    80004426:	8082                	ret
    iput(ip);
    80004428:	00000097          	auipc	ra,0x0
    8000442c:	a30080e7          	jalr	-1488(ra) # 80003e58 <iput>
    return -1;
    80004430:	557d                	li	a0,-1
    80004432:	b7dd                	j	80004418 <dirlink+0x86>
      panic("dirlink read");
    80004434:	00004517          	auipc	a0,0x4
    80004438:	2a450513          	addi	a0,a0,676 # 800086d8 <syscalls+0x1f0>
    8000443c:	ffffc097          	auipc	ra,0xffffc
    80004440:	108080e7          	jalr	264(ra) # 80000544 <panic>

0000000080004444 <namei>:

struct inode*
namei(char *path)
{
    80004444:	1101                	addi	sp,sp,-32
    80004446:	ec06                	sd	ra,24(sp)
    80004448:	e822                	sd	s0,16(sp)
    8000444a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000444c:	fe040613          	addi	a2,s0,-32
    80004450:	4581                	li	a1,0
    80004452:	00000097          	auipc	ra,0x0
    80004456:	de0080e7          	jalr	-544(ra) # 80004232 <namex>
}
    8000445a:	60e2                	ld	ra,24(sp)
    8000445c:	6442                	ld	s0,16(sp)
    8000445e:	6105                	addi	sp,sp,32
    80004460:	8082                	ret

0000000080004462 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004462:	1141                	addi	sp,sp,-16
    80004464:	e406                	sd	ra,8(sp)
    80004466:	e022                	sd	s0,0(sp)
    80004468:	0800                	addi	s0,sp,16
    8000446a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000446c:	4585                	li	a1,1
    8000446e:	00000097          	auipc	ra,0x0
    80004472:	dc4080e7          	jalr	-572(ra) # 80004232 <namex>
}
    80004476:	60a2                	ld	ra,8(sp)
    80004478:	6402                	ld	s0,0(sp)
    8000447a:	0141                	addi	sp,sp,16
    8000447c:	8082                	ret

000000008000447e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000447e:	1101                	addi	sp,sp,-32
    80004480:	ec06                	sd	ra,24(sp)
    80004482:	e822                	sd	s0,16(sp)
    80004484:	e426                	sd	s1,8(sp)
    80004486:	e04a                	sd	s2,0(sp)
    80004488:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000448a:	0001d917          	auipc	s2,0x1d
    8000448e:	75690913          	addi	s2,s2,1878 # 80021be0 <log>
    80004492:	01892583          	lw	a1,24(s2)
    80004496:	02892503          	lw	a0,40(s2)
    8000449a:	fffff097          	auipc	ra,0xfffff
    8000449e:	fea080e7          	jalr	-22(ra) # 80003484 <bread>
    800044a2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800044a4:	02c92683          	lw	a3,44(s2)
    800044a8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800044aa:	02d05763          	blez	a3,800044d8 <write_head+0x5a>
    800044ae:	0001d797          	auipc	a5,0x1d
    800044b2:	76278793          	addi	a5,a5,1890 # 80021c10 <log+0x30>
    800044b6:	05c50713          	addi	a4,a0,92
    800044ba:	36fd                	addiw	a3,a3,-1
    800044bc:	1682                	slli	a3,a3,0x20
    800044be:	9281                	srli	a3,a3,0x20
    800044c0:	068a                	slli	a3,a3,0x2
    800044c2:	0001d617          	auipc	a2,0x1d
    800044c6:	75260613          	addi	a2,a2,1874 # 80021c14 <log+0x34>
    800044ca:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800044cc:	4390                	lw	a2,0(a5)
    800044ce:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800044d0:	0791                	addi	a5,a5,4
    800044d2:	0711                	addi	a4,a4,4
    800044d4:	fed79ce3          	bne	a5,a3,800044cc <write_head+0x4e>
  }
  bwrite(buf);
    800044d8:	8526                	mv	a0,s1
    800044da:	fffff097          	auipc	ra,0xfffff
    800044de:	09c080e7          	jalr	156(ra) # 80003576 <bwrite>
  brelse(buf);
    800044e2:	8526                	mv	a0,s1
    800044e4:	fffff097          	auipc	ra,0xfffff
    800044e8:	0d0080e7          	jalr	208(ra) # 800035b4 <brelse>
}
    800044ec:	60e2                	ld	ra,24(sp)
    800044ee:	6442                	ld	s0,16(sp)
    800044f0:	64a2                	ld	s1,8(sp)
    800044f2:	6902                	ld	s2,0(sp)
    800044f4:	6105                	addi	sp,sp,32
    800044f6:	8082                	ret

00000000800044f8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800044f8:	0001d797          	auipc	a5,0x1d
    800044fc:	7147a783          	lw	a5,1812(a5) # 80021c0c <log+0x2c>
    80004500:	0af05d63          	blez	a5,800045ba <install_trans+0xc2>
{
    80004504:	7139                	addi	sp,sp,-64
    80004506:	fc06                	sd	ra,56(sp)
    80004508:	f822                	sd	s0,48(sp)
    8000450a:	f426                	sd	s1,40(sp)
    8000450c:	f04a                	sd	s2,32(sp)
    8000450e:	ec4e                	sd	s3,24(sp)
    80004510:	e852                	sd	s4,16(sp)
    80004512:	e456                	sd	s5,8(sp)
    80004514:	e05a                	sd	s6,0(sp)
    80004516:	0080                	addi	s0,sp,64
    80004518:	8b2a                	mv	s6,a0
    8000451a:	0001da97          	auipc	s5,0x1d
    8000451e:	6f6a8a93          	addi	s5,s5,1782 # 80021c10 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004522:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004524:	0001d997          	auipc	s3,0x1d
    80004528:	6bc98993          	addi	s3,s3,1724 # 80021be0 <log>
    8000452c:	a035                	j	80004558 <install_trans+0x60>
      bunpin(dbuf);
    8000452e:	8526                	mv	a0,s1
    80004530:	fffff097          	auipc	ra,0xfffff
    80004534:	15e080e7          	jalr	350(ra) # 8000368e <bunpin>
    brelse(lbuf);
    80004538:	854a                	mv	a0,s2
    8000453a:	fffff097          	auipc	ra,0xfffff
    8000453e:	07a080e7          	jalr	122(ra) # 800035b4 <brelse>
    brelse(dbuf);
    80004542:	8526                	mv	a0,s1
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	070080e7          	jalr	112(ra) # 800035b4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000454c:	2a05                	addiw	s4,s4,1
    8000454e:	0a91                	addi	s5,s5,4
    80004550:	02c9a783          	lw	a5,44(s3)
    80004554:	04fa5963          	bge	s4,a5,800045a6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004558:	0189a583          	lw	a1,24(s3)
    8000455c:	014585bb          	addw	a1,a1,s4
    80004560:	2585                	addiw	a1,a1,1
    80004562:	0289a503          	lw	a0,40(s3)
    80004566:	fffff097          	auipc	ra,0xfffff
    8000456a:	f1e080e7          	jalr	-226(ra) # 80003484 <bread>
    8000456e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004570:	000aa583          	lw	a1,0(s5)
    80004574:	0289a503          	lw	a0,40(s3)
    80004578:	fffff097          	auipc	ra,0xfffff
    8000457c:	f0c080e7          	jalr	-244(ra) # 80003484 <bread>
    80004580:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004582:	40000613          	li	a2,1024
    80004586:	05890593          	addi	a1,s2,88
    8000458a:	05850513          	addi	a0,a0,88
    8000458e:	ffffc097          	auipc	ra,0xffffc
    80004592:	7b8080e7          	jalr	1976(ra) # 80000d46 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004596:	8526                	mv	a0,s1
    80004598:	fffff097          	auipc	ra,0xfffff
    8000459c:	fde080e7          	jalr	-34(ra) # 80003576 <bwrite>
    if(recovering == 0)
    800045a0:	f80b1ce3          	bnez	s6,80004538 <install_trans+0x40>
    800045a4:	b769                	j	8000452e <install_trans+0x36>
}
    800045a6:	70e2                	ld	ra,56(sp)
    800045a8:	7442                	ld	s0,48(sp)
    800045aa:	74a2                	ld	s1,40(sp)
    800045ac:	7902                	ld	s2,32(sp)
    800045ae:	69e2                	ld	s3,24(sp)
    800045b0:	6a42                	ld	s4,16(sp)
    800045b2:	6aa2                	ld	s5,8(sp)
    800045b4:	6b02                	ld	s6,0(sp)
    800045b6:	6121                	addi	sp,sp,64
    800045b8:	8082                	ret
    800045ba:	8082                	ret

00000000800045bc <initlog>:
{
    800045bc:	7179                	addi	sp,sp,-48
    800045be:	f406                	sd	ra,40(sp)
    800045c0:	f022                	sd	s0,32(sp)
    800045c2:	ec26                	sd	s1,24(sp)
    800045c4:	e84a                	sd	s2,16(sp)
    800045c6:	e44e                	sd	s3,8(sp)
    800045c8:	1800                	addi	s0,sp,48
    800045ca:	892a                	mv	s2,a0
    800045cc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800045ce:	0001d497          	auipc	s1,0x1d
    800045d2:	61248493          	addi	s1,s1,1554 # 80021be0 <log>
    800045d6:	00004597          	auipc	a1,0x4
    800045da:	11258593          	addi	a1,a1,274 # 800086e8 <syscalls+0x200>
    800045de:	8526                	mv	a0,s1
    800045e0:	ffffc097          	auipc	ra,0xffffc
    800045e4:	57a080e7          	jalr	1402(ra) # 80000b5a <initlock>
  log.start = sb->logstart;
    800045e8:	0149a583          	lw	a1,20(s3)
    800045ec:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800045ee:	0109a783          	lw	a5,16(s3)
    800045f2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800045f4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800045f8:	854a                	mv	a0,s2
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	e8a080e7          	jalr	-374(ra) # 80003484 <bread>
  log.lh.n = lh->n;
    80004602:	4d3c                	lw	a5,88(a0)
    80004604:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004606:	02f05563          	blez	a5,80004630 <initlog+0x74>
    8000460a:	05c50713          	addi	a4,a0,92
    8000460e:	0001d697          	auipc	a3,0x1d
    80004612:	60268693          	addi	a3,a3,1538 # 80021c10 <log+0x30>
    80004616:	37fd                	addiw	a5,a5,-1
    80004618:	1782                	slli	a5,a5,0x20
    8000461a:	9381                	srli	a5,a5,0x20
    8000461c:	078a                	slli	a5,a5,0x2
    8000461e:	06050613          	addi	a2,a0,96
    80004622:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80004624:	4310                	lw	a2,0(a4)
    80004626:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80004628:	0711                	addi	a4,a4,4
    8000462a:	0691                	addi	a3,a3,4
    8000462c:	fef71ce3          	bne	a4,a5,80004624 <initlog+0x68>
  brelse(buf);
    80004630:	fffff097          	auipc	ra,0xfffff
    80004634:	f84080e7          	jalr	-124(ra) # 800035b4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004638:	4505                	li	a0,1
    8000463a:	00000097          	auipc	ra,0x0
    8000463e:	ebe080e7          	jalr	-322(ra) # 800044f8 <install_trans>
  log.lh.n = 0;
    80004642:	0001d797          	auipc	a5,0x1d
    80004646:	5c07a523          	sw	zero,1482(a5) # 80021c0c <log+0x2c>
  write_head(); // clear the log
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	e34080e7          	jalr	-460(ra) # 8000447e <write_head>
}
    80004652:	70a2                	ld	ra,40(sp)
    80004654:	7402                	ld	s0,32(sp)
    80004656:	64e2                	ld	s1,24(sp)
    80004658:	6942                	ld	s2,16(sp)
    8000465a:	69a2                	ld	s3,8(sp)
    8000465c:	6145                	addi	sp,sp,48
    8000465e:	8082                	ret

0000000080004660 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004660:	1101                	addi	sp,sp,-32
    80004662:	ec06                	sd	ra,24(sp)
    80004664:	e822                	sd	s0,16(sp)
    80004666:	e426                	sd	s1,8(sp)
    80004668:	e04a                	sd	s2,0(sp)
    8000466a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000466c:	0001d517          	auipc	a0,0x1d
    80004670:	57450513          	addi	a0,a0,1396 # 80021be0 <log>
    80004674:	ffffc097          	auipc	ra,0xffffc
    80004678:	576080e7          	jalr	1398(ra) # 80000bea <acquire>
  while(1){
    if(log.committing){
    8000467c:	0001d497          	auipc	s1,0x1d
    80004680:	56448493          	addi	s1,s1,1380 # 80021be0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004684:	4979                	li	s2,30
    80004686:	a039                	j	80004694 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004688:	85a6                	mv	a1,s1
    8000468a:	8526                	mv	a0,s1
    8000468c:	ffffe097          	auipc	ra,0xffffe
    80004690:	df0080e7          	jalr	-528(ra) # 8000247c <sleep>
    if(log.committing){
    80004694:	50dc                	lw	a5,36(s1)
    80004696:	fbed                	bnez	a5,80004688 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004698:	509c                	lw	a5,32(s1)
    8000469a:	0017871b          	addiw	a4,a5,1
    8000469e:	0007069b          	sext.w	a3,a4
    800046a2:	0027179b          	slliw	a5,a4,0x2
    800046a6:	9fb9                	addw	a5,a5,a4
    800046a8:	0017979b          	slliw	a5,a5,0x1
    800046ac:	54d8                	lw	a4,44(s1)
    800046ae:	9fb9                	addw	a5,a5,a4
    800046b0:	00f95963          	bge	s2,a5,800046c2 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800046b4:	85a6                	mv	a1,s1
    800046b6:	8526                	mv	a0,s1
    800046b8:	ffffe097          	auipc	ra,0xffffe
    800046bc:	dc4080e7          	jalr	-572(ra) # 8000247c <sleep>
    800046c0:	bfd1                	j	80004694 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800046c2:	0001d517          	auipc	a0,0x1d
    800046c6:	51e50513          	addi	a0,a0,1310 # 80021be0 <log>
    800046ca:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800046cc:	ffffc097          	auipc	ra,0xffffc
    800046d0:	5d2080e7          	jalr	1490(ra) # 80000c9e <release>
      break;
    }
  }
}
    800046d4:	60e2                	ld	ra,24(sp)
    800046d6:	6442                	ld	s0,16(sp)
    800046d8:	64a2                	ld	s1,8(sp)
    800046da:	6902                	ld	s2,0(sp)
    800046dc:	6105                	addi	sp,sp,32
    800046de:	8082                	ret

00000000800046e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800046e0:	7139                	addi	sp,sp,-64
    800046e2:	fc06                	sd	ra,56(sp)
    800046e4:	f822                	sd	s0,48(sp)
    800046e6:	f426                	sd	s1,40(sp)
    800046e8:	f04a                	sd	s2,32(sp)
    800046ea:	ec4e                	sd	s3,24(sp)
    800046ec:	e852                	sd	s4,16(sp)
    800046ee:	e456                	sd	s5,8(sp)
    800046f0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800046f2:	0001d497          	auipc	s1,0x1d
    800046f6:	4ee48493          	addi	s1,s1,1262 # 80021be0 <log>
    800046fa:	8526                	mv	a0,s1
    800046fc:	ffffc097          	auipc	ra,0xffffc
    80004700:	4ee080e7          	jalr	1262(ra) # 80000bea <acquire>
  log.outstanding -= 1;
    80004704:	509c                	lw	a5,32(s1)
    80004706:	37fd                	addiw	a5,a5,-1
    80004708:	0007891b          	sext.w	s2,a5
    8000470c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000470e:	50dc                	lw	a5,36(s1)
    80004710:	efb9                	bnez	a5,8000476e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004712:	06091663          	bnez	s2,8000477e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80004716:	0001d497          	auipc	s1,0x1d
    8000471a:	4ca48493          	addi	s1,s1,1226 # 80021be0 <log>
    8000471e:	4785                	li	a5,1
    80004720:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004722:	8526                	mv	a0,s1
    80004724:	ffffc097          	auipc	ra,0xffffc
    80004728:	57a080e7          	jalr	1402(ra) # 80000c9e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000472c:	54dc                	lw	a5,44(s1)
    8000472e:	06f04763          	bgtz	a5,8000479c <end_op+0xbc>
    acquire(&log.lock);
    80004732:	0001d497          	auipc	s1,0x1d
    80004736:	4ae48493          	addi	s1,s1,1198 # 80021be0 <log>
    8000473a:	8526                	mv	a0,s1
    8000473c:	ffffc097          	auipc	ra,0xffffc
    80004740:	4ae080e7          	jalr	1198(ra) # 80000bea <acquire>
    log.committing = 0;
    80004744:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004748:	8526                	mv	a0,s1
    8000474a:	ffffe097          	auipc	ra,0xffffe
    8000474e:	d96080e7          	jalr	-618(ra) # 800024e0 <wakeup>
    release(&log.lock);
    80004752:	8526                	mv	a0,s1
    80004754:	ffffc097          	auipc	ra,0xffffc
    80004758:	54a080e7          	jalr	1354(ra) # 80000c9e <release>
}
    8000475c:	70e2                	ld	ra,56(sp)
    8000475e:	7442                	ld	s0,48(sp)
    80004760:	74a2                	ld	s1,40(sp)
    80004762:	7902                	ld	s2,32(sp)
    80004764:	69e2                	ld	s3,24(sp)
    80004766:	6a42                	ld	s4,16(sp)
    80004768:	6aa2                	ld	s5,8(sp)
    8000476a:	6121                	addi	sp,sp,64
    8000476c:	8082                	ret
    panic("log.committing");
    8000476e:	00004517          	auipc	a0,0x4
    80004772:	f8250513          	addi	a0,a0,-126 # 800086f0 <syscalls+0x208>
    80004776:	ffffc097          	auipc	ra,0xffffc
    8000477a:	dce080e7          	jalr	-562(ra) # 80000544 <panic>
    wakeup(&log);
    8000477e:	0001d497          	auipc	s1,0x1d
    80004782:	46248493          	addi	s1,s1,1122 # 80021be0 <log>
    80004786:	8526                	mv	a0,s1
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	d58080e7          	jalr	-680(ra) # 800024e0 <wakeup>
  release(&log.lock);
    80004790:	8526                	mv	a0,s1
    80004792:	ffffc097          	auipc	ra,0xffffc
    80004796:	50c080e7          	jalr	1292(ra) # 80000c9e <release>
  if(do_commit){
    8000479a:	b7c9                	j	8000475c <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000479c:	0001da97          	auipc	s5,0x1d
    800047a0:	474a8a93          	addi	s5,s5,1140 # 80021c10 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800047a4:	0001da17          	auipc	s4,0x1d
    800047a8:	43ca0a13          	addi	s4,s4,1084 # 80021be0 <log>
    800047ac:	018a2583          	lw	a1,24(s4)
    800047b0:	012585bb          	addw	a1,a1,s2
    800047b4:	2585                	addiw	a1,a1,1
    800047b6:	028a2503          	lw	a0,40(s4)
    800047ba:	fffff097          	auipc	ra,0xfffff
    800047be:	cca080e7          	jalr	-822(ra) # 80003484 <bread>
    800047c2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800047c4:	000aa583          	lw	a1,0(s5)
    800047c8:	028a2503          	lw	a0,40(s4)
    800047cc:	fffff097          	auipc	ra,0xfffff
    800047d0:	cb8080e7          	jalr	-840(ra) # 80003484 <bread>
    800047d4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800047d6:	40000613          	li	a2,1024
    800047da:	05850593          	addi	a1,a0,88
    800047de:	05848513          	addi	a0,s1,88
    800047e2:	ffffc097          	auipc	ra,0xffffc
    800047e6:	564080e7          	jalr	1380(ra) # 80000d46 <memmove>
    bwrite(to);  // write the log
    800047ea:	8526                	mv	a0,s1
    800047ec:	fffff097          	auipc	ra,0xfffff
    800047f0:	d8a080e7          	jalr	-630(ra) # 80003576 <bwrite>
    brelse(from);
    800047f4:	854e                	mv	a0,s3
    800047f6:	fffff097          	auipc	ra,0xfffff
    800047fa:	dbe080e7          	jalr	-578(ra) # 800035b4 <brelse>
    brelse(to);
    800047fe:	8526                	mv	a0,s1
    80004800:	fffff097          	auipc	ra,0xfffff
    80004804:	db4080e7          	jalr	-588(ra) # 800035b4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004808:	2905                	addiw	s2,s2,1
    8000480a:	0a91                	addi	s5,s5,4
    8000480c:	02ca2783          	lw	a5,44(s4)
    80004810:	f8f94ee3          	blt	s2,a5,800047ac <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004814:	00000097          	auipc	ra,0x0
    80004818:	c6a080e7          	jalr	-918(ra) # 8000447e <write_head>
    install_trans(0); // Now install writes to home locations
    8000481c:	4501                	li	a0,0
    8000481e:	00000097          	auipc	ra,0x0
    80004822:	cda080e7          	jalr	-806(ra) # 800044f8 <install_trans>
    log.lh.n = 0;
    80004826:	0001d797          	auipc	a5,0x1d
    8000482a:	3e07a323          	sw	zero,998(a5) # 80021c0c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000482e:	00000097          	auipc	ra,0x0
    80004832:	c50080e7          	jalr	-944(ra) # 8000447e <write_head>
    80004836:	bdf5                	j	80004732 <end_op+0x52>

0000000080004838 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004838:	1101                	addi	sp,sp,-32
    8000483a:	ec06                	sd	ra,24(sp)
    8000483c:	e822                	sd	s0,16(sp)
    8000483e:	e426                	sd	s1,8(sp)
    80004840:	e04a                	sd	s2,0(sp)
    80004842:	1000                	addi	s0,sp,32
    80004844:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004846:	0001d917          	auipc	s2,0x1d
    8000484a:	39a90913          	addi	s2,s2,922 # 80021be0 <log>
    8000484e:	854a                	mv	a0,s2
    80004850:	ffffc097          	auipc	ra,0xffffc
    80004854:	39a080e7          	jalr	922(ra) # 80000bea <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004858:	02c92603          	lw	a2,44(s2)
    8000485c:	47f5                	li	a5,29
    8000485e:	06c7c563          	blt	a5,a2,800048c8 <log_write+0x90>
    80004862:	0001d797          	auipc	a5,0x1d
    80004866:	39a7a783          	lw	a5,922(a5) # 80021bfc <log+0x1c>
    8000486a:	37fd                	addiw	a5,a5,-1
    8000486c:	04f65e63          	bge	a2,a5,800048c8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004870:	0001d797          	auipc	a5,0x1d
    80004874:	3907a783          	lw	a5,912(a5) # 80021c00 <log+0x20>
    80004878:	06f05063          	blez	a5,800048d8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000487c:	4781                	li	a5,0
    8000487e:	06c05563          	blez	a2,800048e8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004882:	44cc                	lw	a1,12(s1)
    80004884:	0001d717          	auipc	a4,0x1d
    80004888:	38c70713          	addi	a4,a4,908 # 80021c10 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000488c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000488e:	4314                	lw	a3,0(a4)
    80004890:	04b68c63          	beq	a3,a1,800048e8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004894:	2785                	addiw	a5,a5,1
    80004896:	0711                	addi	a4,a4,4
    80004898:	fef61be3          	bne	a2,a5,8000488e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000489c:	0621                	addi	a2,a2,8
    8000489e:	060a                	slli	a2,a2,0x2
    800048a0:	0001d797          	auipc	a5,0x1d
    800048a4:	34078793          	addi	a5,a5,832 # 80021be0 <log>
    800048a8:	963e                	add	a2,a2,a5
    800048aa:	44dc                	lw	a5,12(s1)
    800048ac:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800048ae:	8526                	mv	a0,s1
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	da2080e7          	jalr	-606(ra) # 80003652 <bpin>
    log.lh.n++;
    800048b8:	0001d717          	auipc	a4,0x1d
    800048bc:	32870713          	addi	a4,a4,808 # 80021be0 <log>
    800048c0:	575c                	lw	a5,44(a4)
    800048c2:	2785                	addiw	a5,a5,1
    800048c4:	d75c                	sw	a5,44(a4)
    800048c6:	a835                	j	80004902 <log_write+0xca>
    panic("too big a transaction");
    800048c8:	00004517          	auipc	a0,0x4
    800048cc:	e3850513          	addi	a0,a0,-456 # 80008700 <syscalls+0x218>
    800048d0:	ffffc097          	auipc	ra,0xffffc
    800048d4:	c74080e7          	jalr	-908(ra) # 80000544 <panic>
    panic("log_write outside of trans");
    800048d8:	00004517          	auipc	a0,0x4
    800048dc:	e4050513          	addi	a0,a0,-448 # 80008718 <syscalls+0x230>
    800048e0:	ffffc097          	auipc	ra,0xffffc
    800048e4:	c64080e7          	jalr	-924(ra) # 80000544 <panic>
  log.lh.block[i] = b->blockno;
    800048e8:	00878713          	addi	a4,a5,8
    800048ec:	00271693          	slli	a3,a4,0x2
    800048f0:	0001d717          	auipc	a4,0x1d
    800048f4:	2f070713          	addi	a4,a4,752 # 80021be0 <log>
    800048f8:	9736                	add	a4,a4,a3
    800048fa:	44d4                	lw	a3,12(s1)
    800048fc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800048fe:	faf608e3          	beq	a2,a5,800048ae <log_write+0x76>
  }
  release(&log.lock);
    80004902:	0001d517          	auipc	a0,0x1d
    80004906:	2de50513          	addi	a0,a0,734 # 80021be0 <log>
    8000490a:	ffffc097          	auipc	ra,0xffffc
    8000490e:	394080e7          	jalr	916(ra) # 80000c9e <release>
}
    80004912:	60e2                	ld	ra,24(sp)
    80004914:	6442                	ld	s0,16(sp)
    80004916:	64a2                	ld	s1,8(sp)
    80004918:	6902                	ld	s2,0(sp)
    8000491a:	6105                	addi	sp,sp,32
    8000491c:	8082                	ret

000000008000491e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000491e:	1101                	addi	sp,sp,-32
    80004920:	ec06                	sd	ra,24(sp)
    80004922:	e822                	sd	s0,16(sp)
    80004924:	e426                	sd	s1,8(sp)
    80004926:	e04a                	sd	s2,0(sp)
    80004928:	1000                	addi	s0,sp,32
    8000492a:	84aa                	mv	s1,a0
    8000492c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000492e:	00004597          	auipc	a1,0x4
    80004932:	e0a58593          	addi	a1,a1,-502 # 80008738 <syscalls+0x250>
    80004936:	0521                	addi	a0,a0,8
    80004938:	ffffc097          	auipc	ra,0xffffc
    8000493c:	222080e7          	jalr	546(ra) # 80000b5a <initlock>
  lk->name = name;
    80004940:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004944:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004948:	0204a423          	sw	zero,40(s1)
}
    8000494c:	60e2                	ld	ra,24(sp)
    8000494e:	6442                	ld	s0,16(sp)
    80004950:	64a2                	ld	s1,8(sp)
    80004952:	6902                	ld	s2,0(sp)
    80004954:	6105                	addi	sp,sp,32
    80004956:	8082                	ret

0000000080004958 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004958:	1101                	addi	sp,sp,-32
    8000495a:	ec06                	sd	ra,24(sp)
    8000495c:	e822                	sd	s0,16(sp)
    8000495e:	e426                	sd	s1,8(sp)
    80004960:	e04a                	sd	s2,0(sp)
    80004962:	1000                	addi	s0,sp,32
    80004964:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004966:	00850913          	addi	s2,a0,8
    8000496a:	854a                	mv	a0,s2
    8000496c:	ffffc097          	auipc	ra,0xffffc
    80004970:	27e080e7          	jalr	638(ra) # 80000bea <acquire>
  while (lk->locked) {
    80004974:	409c                	lw	a5,0(s1)
    80004976:	cb89                	beqz	a5,80004988 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004978:	85ca                	mv	a1,s2
    8000497a:	8526                	mv	a0,s1
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	b00080e7          	jalr	-1280(ra) # 8000247c <sleep>
  while (lk->locked) {
    80004984:	409c                	lw	a5,0(s1)
    80004986:	fbed                	bnez	a5,80004978 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004988:	4785                	li	a5,1
    8000498a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000498c:	ffffd097          	auipc	ra,0xffffd
    80004990:	050080e7          	jalr	80(ra) # 800019dc <myproc>
    80004994:	591c                	lw	a5,48(a0)
    80004996:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004998:	854a                	mv	a0,s2
    8000499a:	ffffc097          	auipc	ra,0xffffc
    8000499e:	304080e7          	jalr	772(ra) # 80000c9e <release>
}
    800049a2:	60e2                	ld	ra,24(sp)
    800049a4:	6442                	ld	s0,16(sp)
    800049a6:	64a2                	ld	s1,8(sp)
    800049a8:	6902                	ld	s2,0(sp)
    800049aa:	6105                	addi	sp,sp,32
    800049ac:	8082                	ret

00000000800049ae <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800049ae:	1101                	addi	sp,sp,-32
    800049b0:	ec06                	sd	ra,24(sp)
    800049b2:	e822                	sd	s0,16(sp)
    800049b4:	e426                	sd	s1,8(sp)
    800049b6:	e04a                	sd	s2,0(sp)
    800049b8:	1000                	addi	s0,sp,32
    800049ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049bc:	00850913          	addi	s2,a0,8
    800049c0:	854a                	mv	a0,s2
    800049c2:	ffffc097          	auipc	ra,0xffffc
    800049c6:	228080e7          	jalr	552(ra) # 80000bea <acquire>
  lk->locked = 0;
    800049ca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049ce:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800049d2:	8526                	mv	a0,s1
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	b0c080e7          	jalr	-1268(ra) # 800024e0 <wakeup>
  release(&lk->lk);
    800049dc:	854a                	mv	a0,s2
    800049de:	ffffc097          	auipc	ra,0xffffc
    800049e2:	2c0080e7          	jalr	704(ra) # 80000c9e <release>
}
    800049e6:	60e2                	ld	ra,24(sp)
    800049e8:	6442                	ld	s0,16(sp)
    800049ea:	64a2                	ld	s1,8(sp)
    800049ec:	6902                	ld	s2,0(sp)
    800049ee:	6105                	addi	sp,sp,32
    800049f0:	8082                	ret

00000000800049f2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800049f2:	7179                	addi	sp,sp,-48
    800049f4:	f406                	sd	ra,40(sp)
    800049f6:	f022                	sd	s0,32(sp)
    800049f8:	ec26                	sd	s1,24(sp)
    800049fa:	e84a                	sd	s2,16(sp)
    800049fc:	e44e                	sd	s3,8(sp)
    800049fe:	1800                	addi	s0,sp,48
    80004a00:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a02:	00850913          	addi	s2,a0,8
    80004a06:	854a                	mv	a0,s2
    80004a08:	ffffc097          	auipc	ra,0xffffc
    80004a0c:	1e2080e7          	jalr	482(ra) # 80000bea <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a10:	409c                	lw	a5,0(s1)
    80004a12:	ef99                	bnez	a5,80004a30 <holdingsleep+0x3e>
    80004a14:	4481                	li	s1,0
  release(&lk->lk);
    80004a16:	854a                	mv	a0,s2
    80004a18:	ffffc097          	auipc	ra,0xffffc
    80004a1c:	286080e7          	jalr	646(ra) # 80000c9e <release>
  return r;
}
    80004a20:	8526                	mv	a0,s1
    80004a22:	70a2                	ld	ra,40(sp)
    80004a24:	7402                	ld	s0,32(sp)
    80004a26:	64e2                	ld	s1,24(sp)
    80004a28:	6942                	ld	s2,16(sp)
    80004a2a:	69a2                	ld	s3,8(sp)
    80004a2c:	6145                	addi	sp,sp,48
    80004a2e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a30:	0284a983          	lw	s3,40(s1)
    80004a34:	ffffd097          	auipc	ra,0xffffd
    80004a38:	fa8080e7          	jalr	-88(ra) # 800019dc <myproc>
    80004a3c:	5904                	lw	s1,48(a0)
    80004a3e:	413484b3          	sub	s1,s1,s3
    80004a42:	0014b493          	seqz	s1,s1
    80004a46:	bfc1                	j	80004a16 <holdingsleep+0x24>

0000000080004a48 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004a48:	1141                	addi	sp,sp,-16
    80004a4a:	e406                	sd	ra,8(sp)
    80004a4c:	e022                	sd	s0,0(sp)
    80004a4e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004a50:	00004597          	auipc	a1,0x4
    80004a54:	cf858593          	addi	a1,a1,-776 # 80008748 <syscalls+0x260>
    80004a58:	0001d517          	auipc	a0,0x1d
    80004a5c:	2d050513          	addi	a0,a0,720 # 80021d28 <ftable>
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	0fa080e7          	jalr	250(ra) # 80000b5a <initlock>
}
    80004a68:	60a2                	ld	ra,8(sp)
    80004a6a:	6402                	ld	s0,0(sp)
    80004a6c:	0141                	addi	sp,sp,16
    80004a6e:	8082                	ret

0000000080004a70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a70:	1101                	addi	sp,sp,-32
    80004a72:	ec06                	sd	ra,24(sp)
    80004a74:	e822                	sd	s0,16(sp)
    80004a76:	e426                	sd	s1,8(sp)
    80004a78:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004a7a:	0001d517          	auipc	a0,0x1d
    80004a7e:	2ae50513          	addi	a0,a0,686 # 80021d28 <ftable>
    80004a82:	ffffc097          	auipc	ra,0xffffc
    80004a86:	168080e7          	jalr	360(ra) # 80000bea <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a8a:	0001d497          	auipc	s1,0x1d
    80004a8e:	2b648493          	addi	s1,s1,694 # 80021d40 <ftable+0x18>
    80004a92:	0001e717          	auipc	a4,0x1e
    80004a96:	24e70713          	addi	a4,a4,590 # 80022ce0 <disk>
    if(f->ref == 0){
    80004a9a:	40dc                	lw	a5,4(s1)
    80004a9c:	cf99                	beqz	a5,80004aba <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a9e:	02848493          	addi	s1,s1,40
    80004aa2:	fee49ce3          	bne	s1,a4,80004a9a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004aa6:	0001d517          	auipc	a0,0x1d
    80004aaa:	28250513          	addi	a0,a0,642 # 80021d28 <ftable>
    80004aae:	ffffc097          	auipc	ra,0xffffc
    80004ab2:	1f0080e7          	jalr	496(ra) # 80000c9e <release>
  return 0;
    80004ab6:	4481                	li	s1,0
    80004ab8:	a819                	j	80004ace <filealloc+0x5e>
      f->ref = 1;
    80004aba:	4785                	li	a5,1
    80004abc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004abe:	0001d517          	auipc	a0,0x1d
    80004ac2:	26a50513          	addi	a0,a0,618 # 80021d28 <ftable>
    80004ac6:	ffffc097          	auipc	ra,0xffffc
    80004aca:	1d8080e7          	jalr	472(ra) # 80000c9e <release>
}
    80004ace:	8526                	mv	a0,s1
    80004ad0:	60e2                	ld	ra,24(sp)
    80004ad2:	6442                	ld	s0,16(sp)
    80004ad4:	64a2                	ld	s1,8(sp)
    80004ad6:	6105                	addi	sp,sp,32
    80004ad8:	8082                	ret

0000000080004ada <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004ada:	1101                	addi	sp,sp,-32
    80004adc:	ec06                	sd	ra,24(sp)
    80004ade:	e822                	sd	s0,16(sp)
    80004ae0:	e426                	sd	s1,8(sp)
    80004ae2:	1000                	addi	s0,sp,32
    80004ae4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004ae6:	0001d517          	auipc	a0,0x1d
    80004aea:	24250513          	addi	a0,a0,578 # 80021d28 <ftable>
    80004aee:	ffffc097          	auipc	ra,0xffffc
    80004af2:	0fc080e7          	jalr	252(ra) # 80000bea <acquire>
  if(f->ref < 1)
    80004af6:	40dc                	lw	a5,4(s1)
    80004af8:	02f05263          	blez	a5,80004b1c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004afc:	2785                	addiw	a5,a5,1
    80004afe:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b00:	0001d517          	auipc	a0,0x1d
    80004b04:	22850513          	addi	a0,a0,552 # 80021d28 <ftable>
    80004b08:	ffffc097          	auipc	ra,0xffffc
    80004b0c:	196080e7          	jalr	406(ra) # 80000c9e <release>
  return f;
}
    80004b10:	8526                	mv	a0,s1
    80004b12:	60e2                	ld	ra,24(sp)
    80004b14:	6442                	ld	s0,16(sp)
    80004b16:	64a2                	ld	s1,8(sp)
    80004b18:	6105                	addi	sp,sp,32
    80004b1a:	8082                	ret
    panic("filedup");
    80004b1c:	00004517          	auipc	a0,0x4
    80004b20:	c3450513          	addi	a0,a0,-972 # 80008750 <syscalls+0x268>
    80004b24:	ffffc097          	auipc	ra,0xffffc
    80004b28:	a20080e7          	jalr	-1504(ra) # 80000544 <panic>

0000000080004b2c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b2c:	7139                	addi	sp,sp,-64
    80004b2e:	fc06                	sd	ra,56(sp)
    80004b30:	f822                	sd	s0,48(sp)
    80004b32:	f426                	sd	s1,40(sp)
    80004b34:	f04a                	sd	s2,32(sp)
    80004b36:	ec4e                	sd	s3,24(sp)
    80004b38:	e852                	sd	s4,16(sp)
    80004b3a:	e456                	sd	s5,8(sp)
    80004b3c:	0080                	addi	s0,sp,64
    80004b3e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b40:	0001d517          	auipc	a0,0x1d
    80004b44:	1e850513          	addi	a0,a0,488 # 80021d28 <ftable>
    80004b48:	ffffc097          	auipc	ra,0xffffc
    80004b4c:	0a2080e7          	jalr	162(ra) # 80000bea <acquire>
  if(f->ref < 1)
    80004b50:	40dc                	lw	a5,4(s1)
    80004b52:	06f05163          	blez	a5,80004bb4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004b56:	37fd                	addiw	a5,a5,-1
    80004b58:	0007871b          	sext.w	a4,a5
    80004b5c:	c0dc                	sw	a5,4(s1)
    80004b5e:	06e04363          	bgtz	a4,80004bc4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b62:	0004a903          	lw	s2,0(s1)
    80004b66:	0094ca83          	lbu	s5,9(s1)
    80004b6a:	0104ba03          	ld	s4,16(s1)
    80004b6e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004b72:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004b76:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004b7a:	0001d517          	auipc	a0,0x1d
    80004b7e:	1ae50513          	addi	a0,a0,430 # 80021d28 <ftable>
    80004b82:	ffffc097          	auipc	ra,0xffffc
    80004b86:	11c080e7          	jalr	284(ra) # 80000c9e <release>

  if(ff.type == FD_PIPE){
    80004b8a:	4785                	li	a5,1
    80004b8c:	04f90d63          	beq	s2,a5,80004be6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004b90:	3979                	addiw	s2,s2,-2
    80004b92:	4785                	li	a5,1
    80004b94:	0527e063          	bltu	a5,s2,80004bd4 <fileclose+0xa8>
    begin_op();
    80004b98:	00000097          	auipc	ra,0x0
    80004b9c:	ac8080e7          	jalr	-1336(ra) # 80004660 <begin_op>
    iput(ff.ip);
    80004ba0:	854e                	mv	a0,s3
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	2b6080e7          	jalr	694(ra) # 80003e58 <iput>
    end_op();
    80004baa:	00000097          	auipc	ra,0x0
    80004bae:	b36080e7          	jalr	-1226(ra) # 800046e0 <end_op>
    80004bb2:	a00d                	j	80004bd4 <fileclose+0xa8>
    panic("fileclose");
    80004bb4:	00004517          	auipc	a0,0x4
    80004bb8:	ba450513          	addi	a0,a0,-1116 # 80008758 <syscalls+0x270>
    80004bbc:	ffffc097          	auipc	ra,0xffffc
    80004bc0:	988080e7          	jalr	-1656(ra) # 80000544 <panic>
    release(&ftable.lock);
    80004bc4:	0001d517          	auipc	a0,0x1d
    80004bc8:	16450513          	addi	a0,a0,356 # 80021d28 <ftable>
    80004bcc:	ffffc097          	auipc	ra,0xffffc
    80004bd0:	0d2080e7          	jalr	210(ra) # 80000c9e <release>
  }
}
    80004bd4:	70e2                	ld	ra,56(sp)
    80004bd6:	7442                	ld	s0,48(sp)
    80004bd8:	74a2                	ld	s1,40(sp)
    80004bda:	7902                	ld	s2,32(sp)
    80004bdc:	69e2                	ld	s3,24(sp)
    80004bde:	6a42                	ld	s4,16(sp)
    80004be0:	6aa2                	ld	s5,8(sp)
    80004be2:	6121                	addi	sp,sp,64
    80004be4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004be6:	85d6                	mv	a1,s5
    80004be8:	8552                	mv	a0,s4
    80004bea:	00000097          	auipc	ra,0x0
    80004bee:	34c080e7          	jalr	844(ra) # 80004f36 <pipeclose>
    80004bf2:	b7cd                	j	80004bd4 <fileclose+0xa8>

0000000080004bf4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004bf4:	715d                	addi	sp,sp,-80
    80004bf6:	e486                	sd	ra,72(sp)
    80004bf8:	e0a2                	sd	s0,64(sp)
    80004bfa:	fc26                	sd	s1,56(sp)
    80004bfc:	f84a                	sd	s2,48(sp)
    80004bfe:	f44e                	sd	s3,40(sp)
    80004c00:	0880                	addi	s0,sp,80
    80004c02:	84aa                	mv	s1,a0
    80004c04:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004c06:	ffffd097          	auipc	ra,0xffffd
    80004c0a:	dd6080e7          	jalr	-554(ra) # 800019dc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c0e:	409c                	lw	a5,0(s1)
    80004c10:	37f9                	addiw	a5,a5,-2
    80004c12:	4705                	li	a4,1
    80004c14:	04f76763          	bltu	a4,a5,80004c62 <filestat+0x6e>
    80004c18:	892a                	mv	s2,a0
    ilock(f->ip);
    80004c1a:	6c88                	ld	a0,24(s1)
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	082080e7          	jalr	130(ra) # 80003c9e <ilock>
    stati(f->ip, &st);
    80004c24:	fb840593          	addi	a1,s0,-72
    80004c28:	6c88                	ld	a0,24(s1)
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	2fe080e7          	jalr	766(ra) # 80003f28 <stati>
    iunlock(f->ip);
    80004c32:	6c88                	ld	a0,24(s1)
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	12c080e7          	jalr	300(ra) # 80003d60 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004c3c:	46e1                	li	a3,24
    80004c3e:	fb840613          	addi	a2,s0,-72
    80004c42:	85ce                	mv	a1,s3
    80004c44:	09093503          	ld	a0,144(s2)
    80004c48:	ffffd097          	auipc	ra,0xffffd
    80004c4c:	a3c080e7          	jalr	-1476(ra) # 80001684 <copyout>
    80004c50:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004c54:	60a6                	ld	ra,72(sp)
    80004c56:	6406                	ld	s0,64(sp)
    80004c58:	74e2                	ld	s1,56(sp)
    80004c5a:	7942                	ld	s2,48(sp)
    80004c5c:	79a2                	ld	s3,40(sp)
    80004c5e:	6161                	addi	sp,sp,80
    80004c60:	8082                	ret
  return -1;
    80004c62:	557d                	li	a0,-1
    80004c64:	bfc5                	j	80004c54 <filestat+0x60>

0000000080004c66 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c66:	7179                	addi	sp,sp,-48
    80004c68:	f406                	sd	ra,40(sp)
    80004c6a:	f022                	sd	s0,32(sp)
    80004c6c:	ec26                	sd	s1,24(sp)
    80004c6e:	e84a                	sd	s2,16(sp)
    80004c70:	e44e                	sd	s3,8(sp)
    80004c72:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c74:	00854783          	lbu	a5,8(a0)
    80004c78:	c3d5                	beqz	a5,80004d1c <fileread+0xb6>
    80004c7a:	84aa                	mv	s1,a0
    80004c7c:	89ae                	mv	s3,a1
    80004c7e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c80:	411c                	lw	a5,0(a0)
    80004c82:	4705                	li	a4,1
    80004c84:	04e78963          	beq	a5,a4,80004cd6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c88:	470d                	li	a4,3
    80004c8a:	04e78d63          	beq	a5,a4,80004ce4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c8e:	4709                	li	a4,2
    80004c90:	06e79e63          	bne	a5,a4,80004d0c <fileread+0xa6>
    ilock(f->ip);
    80004c94:	6d08                	ld	a0,24(a0)
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	008080e7          	jalr	8(ra) # 80003c9e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c9e:	874a                	mv	a4,s2
    80004ca0:	5094                	lw	a3,32(s1)
    80004ca2:	864e                	mv	a2,s3
    80004ca4:	4585                	li	a1,1
    80004ca6:	6c88                	ld	a0,24(s1)
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	2aa080e7          	jalr	682(ra) # 80003f52 <readi>
    80004cb0:	892a                	mv	s2,a0
    80004cb2:	00a05563          	blez	a0,80004cbc <fileread+0x56>
      f->off += r;
    80004cb6:	509c                	lw	a5,32(s1)
    80004cb8:	9fa9                	addw	a5,a5,a0
    80004cba:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004cbc:	6c88                	ld	a0,24(s1)
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	0a2080e7          	jalr	162(ra) # 80003d60 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004cc6:	854a                	mv	a0,s2
    80004cc8:	70a2                	ld	ra,40(sp)
    80004cca:	7402                	ld	s0,32(sp)
    80004ccc:	64e2                	ld	s1,24(sp)
    80004cce:	6942                	ld	s2,16(sp)
    80004cd0:	69a2                	ld	s3,8(sp)
    80004cd2:	6145                	addi	sp,sp,48
    80004cd4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004cd6:	6908                	ld	a0,16(a0)
    80004cd8:	00000097          	auipc	ra,0x0
    80004cdc:	3ce080e7          	jalr	974(ra) # 800050a6 <piperead>
    80004ce0:	892a                	mv	s2,a0
    80004ce2:	b7d5                	j	80004cc6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004ce4:	02451783          	lh	a5,36(a0)
    80004ce8:	03079693          	slli	a3,a5,0x30
    80004cec:	92c1                	srli	a3,a3,0x30
    80004cee:	4725                	li	a4,9
    80004cf0:	02d76863          	bltu	a4,a3,80004d20 <fileread+0xba>
    80004cf4:	0792                	slli	a5,a5,0x4
    80004cf6:	0001d717          	auipc	a4,0x1d
    80004cfa:	f9270713          	addi	a4,a4,-110 # 80021c88 <devsw>
    80004cfe:	97ba                	add	a5,a5,a4
    80004d00:	639c                	ld	a5,0(a5)
    80004d02:	c38d                	beqz	a5,80004d24 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004d04:	4505                	li	a0,1
    80004d06:	9782                	jalr	a5
    80004d08:	892a                	mv	s2,a0
    80004d0a:	bf75                	j	80004cc6 <fileread+0x60>
    panic("fileread");
    80004d0c:	00004517          	auipc	a0,0x4
    80004d10:	a5c50513          	addi	a0,a0,-1444 # 80008768 <syscalls+0x280>
    80004d14:	ffffc097          	auipc	ra,0xffffc
    80004d18:	830080e7          	jalr	-2000(ra) # 80000544 <panic>
    return -1;
    80004d1c:	597d                	li	s2,-1
    80004d1e:	b765                	j	80004cc6 <fileread+0x60>
      return -1;
    80004d20:	597d                	li	s2,-1
    80004d22:	b755                	j	80004cc6 <fileread+0x60>
    80004d24:	597d                	li	s2,-1
    80004d26:	b745                	j	80004cc6 <fileread+0x60>

0000000080004d28 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004d28:	715d                	addi	sp,sp,-80
    80004d2a:	e486                	sd	ra,72(sp)
    80004d2c:	e0a2                	sd	s0,64(sp)
    80004d2e:	fc26                	sd	s1,56(sp)
    80004d30:	f84a                	sd	s2,48(sp)
    80004d32:	f44e                	sd	s3,40(sp)
    80004d34:	f052                	sd	s4,32(sp)
    80004d36:	ec56                	sd	s5,24(sp)
    80004d38:	e85a                	sd	s6,16(sp)
    80004d3a:	e45e                	sd	s7,8(sp)
    80004d3c:	e062                	sd	s8,0(sp)
    80004d3e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80004d40:	00954783          	lbu	a5,9(a0)
    80004d44:	10078663          	beqz	a5,80004e50 <filewrite+0x128>
    80004d48:	892a                	mv	s2,a0
    80004d4a:	8aae                	mv	s5,a1
    80004d4c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d4e:	411c                	lw	a5,0(a0)
    80004d50:	4705                	li	a4,1
    80004d52:	02e78263          	beq	a5,a4,80004d76 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d56:	470d                	li	a4,3
    80004d58:	02e78663          	beq	a5,a4,80004d84 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d5c:	4709                	li	a4,2
    80004d5e:	0ee79163          	bne	a5,a4,80004e40 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d62:	0ac05d63          	blez	a2,80004e1c <filewrite+0xf4>
    int i = 0;
    80004d66:	4981                	li	s3,0
    80004d68:	6b05                	lui	s6,0x1
    80004d6a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004d6e:	6b85                	lui	s7,0x1
    80004d70:	c00b8b9b          	addiw	s7,s7,-1024
    80004d74:	a861                	j	80004e0c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004d76:	6908                	ld	a0,16(a0)
    80004d78:	00000097          	auipc	ra,0x0
    80004d7c:	22e080e7          	jalr	558(ra) # 80004fa6 <pipewrite>
    80004d80:	8a2a                	mv	s4,a0
    80004d82:	a045                	j	80004e22 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004d84:	02451783          	lh	a5,36(a0)
    80004d88:	03079693          	slli	a3,a5,0x30
    80004d8c:	92c1                	srli	a3,a3,0x30
    80004d8e:	4725                	li	a4,9
    80004d90:	0cd76263          	bltu	a4,a3,80004e54 <filewrite+0x12c>
    80004d94:	0792                	slli	a5,a5,0x4
    80004d96:	0001d717          	auipc	a4,0x1d
    80004d9a:	ef270713          	addi	a4,a4,-270 # 80021c88 <devsw>
    80004d9e:	97ba                	add	a5,a5,a4
    80004da0:	679c                	ld	a5,8(a5)
    80004da2:	cbdd                	beqz	a5,80004e58 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004da4:	4505                	li	a0,1
    80004da6:	9782                	jalr	a5
    80004da8:	8a2a                	mv	s4,a0
    80004daa:	a8a5                	j	80004e22 <filewrite+0xfa>
    80004dac:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004db0:	00000097          	auipc	ra,0x0
    80004db4:	8b0080e7          	jalr	-1872(ra) # 80004660 <begin_op>
      ilock(f->ip);
    80004db8:	01893503          	ld	a0,24(s2)
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	ee2080e7          	jalr	-286(ra) # 80003c9e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004dc4:	8762                	mv	a4,s8
    80004dc6:	02092683          	lw	a3,32(s2)
    80004dca:	01598633          	add	a2,s3,s5
    80004dce:	4585                	li	a1,1
    80004dd0:	01893503          	ld	a0,24(s2)
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	276080e7          	jalr	630(ra) # 8000404a <writei>
    80004ddc:	84aa                	mv	s1,a0
    80004dde:	00a05763          	blez	a0,80004dec <filewrite+0xc4>
        f->off += r;
    80004de2:	02092783          	lw	a5,32(s2)
    80004de6:	9fa9                	addw	a5,a5,a0
    80004de8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004dec:	01893503          	ld	a0,24(s2)
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	f70080e7          	jalr	-144(ra) # 80003d60 <iunlock>
      end_op();
    80004df8:	00000097          	auipc	ra,0x0
    80004dfc:	8e8080e7          	jalr	-1816(ra) # 800046e0 <end_op>

      if(r != n1){
    80004e00:	009c1f63          	bne	s8,s1,80004e1e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004e04:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004e08:	0149db63          	bge	s3,s4,80004e1e <filewrite+0xf6>
      int n1 = n - i;
    80004e0c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004e10:	84be                	mv	s1,a5
    80004e12:	2781                	sext.w	a5,a5
    80004e14:	f8fb5ce3          	bge	s6,a5,80004dac <filewrite+0x84>
    80004e18:	84de                	mv	s1,s7
    80004e1a:	bf49                	j	80004dac <filewrite+0x84>
    int i = 0;
    80004e1c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004e1e:	013a1f63          	bne	s4,s3,80004e3c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004e22:	8552                	mv	a0,s4
    80004e24:	60a6                	ld	ra,72(sp)
    80004e26:	6406                	ld	s0,64(sp)
    80004e28:	74e2                	ld	s1,56(sp)
    80004e2a:	7942                	ld	s2,48(sp)
    80004e2c:	79a2                	ld	s3,40(sp)
    80004e2e:	7a02                	ld	s4,32(sp)
    80004e30:	6ae2                	ld	s5,24(sp)
    80004e32:	6b42                	ld	s6,16(sp)
    80004e34:	6ba2                	ld	s7,8(sp)
    80004e36:	6c02                	ld	s8,0(sp)
    80004e38:	6161                	addi	sp,sp,80
    80004e3a:	8082                	ret
    ret = (i == n ? n : -1);
    80004e3c:	5a7d                	li	s4,-1
    80004e3e:	b7d5                	j	80004e22 <filewrite+0xfa>
    panic("filewrite");
    80004e40:	00004517          	auipc	a0,0x4
    80004e44:	93850513          	addi	a0,a0,-1736 # 80008778 <syscalls+0x290>
    80004e48:	ffffb097          	auipc	ra,0xffffb
    80004e4c:	6fc080e7          	jalr	1788(ra) # 80000544 <panic>
    return -1;
    80004e50:	5a7d                	li	s4,-1
    80004e52:	bfc1                	j	80004e22 <filewrite+0xfa>
      return -1;
    80004e54:	5a7d                	li	s4,-1
    80004e56:	b7f1                	j	80004e22 <filewrite+0xfa>
    80004e58:	5a7d                	li	s4,-1
    80004e5a:	b7e1                	j	80004e22 <filewrite+0xfa>

0000000080004e5c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e5c:	7179                	addi	sp,sp,-48
    80004e5e:	f406                	sd	ra,40(sp)
    80004e60:	f022                	sd	s0,32(sp)
    80004e62:	ec26                	sd	s1,24(sp)
    80004e64:	e84a                	sd	s2,16(sp)
    80004e66:	e44e                	sd	s3,8(sp)
    80004e68:	e052                	sd	s4,0(sp)
    80004e6a:	1800                	addi	s0,sp,48
    80004e6c:	84aa                	mv	s1,a0
    80004e6e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e70:	0005b023          	sd	zero,0(a1)
    80004e74:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e78:	00000097          	auipc	ra,0x0
    80004e7c:	bf8080e7          	jalr	-1032(ra) # 80004a70 <filealloc>
    80004e80:	e088                	sd	a0,0(s1)
    80004e82:	c551                	beqz	a0,80004f0e <pipealloc+0xb2>
    80004e84:	00000097          	auipc	ra,0x0
    80004e88:	bec080e7          	jalr	-1044(ra) # 80004a70 <filealloc>
    80004e8c:	00aa3023          	sd	a0,0(s4)
    80004e90:	c92d                	beqz	a0,80004f02 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004e92:	ffffc097          	auipc	ra,0xffffc
    80004e96:	c68080e7          	jalr	-920(ra) # 80000afa <kalloc>
    80004e9a:	892a                	mv	s2,a0
    80004e9c:	c125                	beqz	a0,80004efc <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80004e9e:	4985                	li	s3,1
    80004ea0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004ea4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004ea8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004eac:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004eb0:	00004597          	auipc	a1,0x4
    80004eb4:	8d858593          	addi	a1,a1,-1832 # 80008788 <syscalls+0x2a0>
    80004eb8:	ffffc097          	auipc	ra,0xffffc
    80004ebc:	ca2080e7          	jalr	-862(ra) # 80000b5a <initlock>
  (*f0)->type = FD_PIPE;
    80004ec0:	609c                	ld	a5,0(s1)
    80004ec2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004ec6:	609c                	ld	a5,0(s1)
    80004ec8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004ecc:	609c                	ld	a5,0(s1)
    80004ece:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004ed2:	609c                	ld	a5,0(s1)
    80004ed4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004ed8:	000a3783          	ld	a5,0(s4)
    80004edc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004ee0:	000a3783          	ld	a5,0(s4)
    80004ee4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ee8:	000a3783          	ld	a5,0(s4)
    80004eec:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004ef0:	000a3783          	ld	a5,0(s4)
    80004ef4:	0127b823          	sd	s2,16(a5)
  return 0;
    80004ef8:	4501                	li	a0,0
    80004efa:	a025                	j	80004f22 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004efc:	6088                	ld	a0,0(s1)
    80004efe:	e501                	bnez	a0,80004f06 <pipealloc+0xaa>
    80004f00:	a039                	j	80004f0e <pipealloc+0xb2>
    80004f02:	6088                	ld	a0,0(s1)
    80004f04:	c51d                	beqz	a0,80004f32 <pipealloc+0xd6>
    fileclose(*f0);
    80004f06:	00000097          	auipc	ra,0x0
    80004f0a:	c26080e7          	jalr	-986(ra) # 80004b2c <fileclose>
  if(*f1)
    80004f0e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004f12:	557d                	li	a0,-1
  if(*f1)
    80004f14:	c799                	beqz	a5,80004f22 <pipealloc+0xc6>
    fileclose(*f1);
    80004f16:	853e                	mv	a0,a5
    80004f18:	00000097          	auipc	ra,0x0
    80004f1c:	c14080e7          	jalr	-1004(ra) # 80004b2c <fileclose>
  return -1;
    80004f20:	557d                	li	a0,-1
}
    80004f22:	70a2                	ld	ra,40(sp)
    80004f24:	7402                	ld	s0,32(sp)
    80004f26:	64e2                	ld	s1,24(sp)
    80004f28:	6942                	ld	s2,16(sp)
    80004f2a:	69a2                	ld	s3,8(sp)
    80004f2c:	6a02                	ld	s4,0(sp)
    80004f2e:	6145                	addi	sp,sp,48
    80004f30:	8082                	ret
  return -1;
    80004f32:	557d                	li	a0,-1
    80004f34:	b7fd                	j	80004f22 <pipealloc+0xc6>

0000000080004f36 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004f36:	1101                	addi	sp,sp,-32
    80004f38:	ec06                	sd	ra,24(sp)
    80004f3a:	e822                	sd	s0,16(sp)
    80004f3c:	e426                	sd	s1,8(sp)
    80004f3e:	e04a                	sd	s2,0(sp)
    80004f40:	1000                	addi	s0,sp,32
    80004f42:	84aa                	mv	s1,a0
    80004f44:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f46:	ffffc097          	auipc	ra,0xffffc
    80004f4a:	ca4080e7          	jalr	-860(ra) # 80000bea <acquire>
  if(writable){
    80004f4e:	02090d63          	beqz	s2,80004f88 <pipeclose+0x52>
    pi->writeopen = 0;
    80004f52:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f56:	21848513          	addi	a0,s1,536
    80004f5a:	ffffd097          	auipc	ra,0xffffd
    80004f5e:	586080e7          	jalr	1414(ra) # 800024e0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f62:	2204b783          	ld	a5,544(s1)
    80004f66:	eb95                	bnez	a5,80004f9a <pipeclose+0x64>
    release(&pi->lock);
    80004f68:	8526                	mv	a0,s1
    80004f6a:	ffffc097          	auipc	ra,0xffffc
    80004f6e:	d34080e7          	jalr	-716(ra) # 80000c9e <release>
    kfree((char*)pi);
    80004f72:	8526                	mv	a0,s1
    80004f74:	ffffc097          	auipc	ra,0xffffc
    80004f78:	a8a080e7          	jalr	-1398(ra) # 800009fe <kfree>
  } else
    release(&pi->lock);
}
    80004f7c:	60e2                	ld	ra,24(sp)
    80004f7e:	6442                	ld	s0,16(sp)
    80004f80:	64a2                	ld	s1,8(sp)
    80004f82:	6902                	ld	s2,0(sp)
    80004f84:	6105                	addi	sp,sp,32
    80004f86:	8082                	ret
    pi->readopen = 0;
    80004f88:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004f8c:	21c48513          	addi	a0,s1,540
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	550080e7          	jalr	1360(ra) # 800024e0 <wakeup>
    80004f98:	b7e9                	j	80004f62 <pipeclose+0x2c>
    release(&pi->lock);
    80004f9a:	8526                	mv	a0,s1
    80004f9c:	ffffc097          	auipc	ra,0xffffc
    80004fa0:	d02080e7          	jalr	-766(ra) # 80000c9e <release>
}
    80004fa4:	bfe1                	j	80004f7c <pipeclose+0x46>

0000000080004fa6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004fa6:	7159                	addi	sp,sp,-112
    80004fa8:	f486                	sd	ra,104(sp)
    80004faa:	f0a2                	sd	s0,96(sp)
    80004fac:	eca6                	sd	s1,88(sp)
    80004fae:	e8ca                	sd	s2,80(sp)
    80004fb0:	e4ce                	sd	s3,72(sp)
    80004fb2:	e0d2                	sd	s4,64(sp)
    80004fb4:	fc56                	sd	s5,56(sp)
    80004fb6:	f85a                	sd	s6,48(sp)
    80004fb8:	f45e                	sd	s7,40(sp)
    80004fba:	f062                	sd	s8,32(sp)
    80004fbc:	ec66                	sd	s9,24(sp)
    80004fbe:	1880                	addi	s0,sp,112
    80004fc0:	84aa                	mv	s1,a0
    80004fc2:	8aae                	mv	s5,a1
    80004fc4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004fc6:	ffffd097          	auipc	ra,0xffffd
    80004fca:	a16080e7          	jalr	-1514(ra) # 800019dc <myproc>
    80004fce:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004fd0:	8526                	mv	a0,s1
    80004fd2:	ffffc097          	auipc	ra,0xffffc
    80004fd6:	c18080e7          	jalr	-1000(ra) # 80000bea <acquire>
  while(i < n){
    80004fda:	0d405463          	blez	s4,800050a2 <pipewrite+0xfc>
    80004fde:	8ba6                	mv	s7,s1
  int i = 0;
    80004fe0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004fe2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004fe4:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004fe8:	21c48c13          	addi	s8,s1,540
    80004fec:	a08d                	j	8000504e <pipewrite+0xa8>
      release(&pi->lock);
    80004fee:	8526                	mv	a0,s1
    80004ff0:	ffffc097          	auipc	ra,0xffffc
    80004ff4:	cae080e7          	jalr	-850(ra) # 80000c9e <release>
      return -1;
    80004ff8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004ffa:	854a                	mv	a0,s2
    80004ffc:	70a6                	ld	ra,104(sp)
    80004ffe:	7406                	ld	s0,96(sp)
    80005000:	64e6                	ld	s1,88(sp)
    80005002:	6946                	ld	s2,80(sp)
    80005004:	69a6                	ld	s3,72(sp)
    80005006:	6a06                	ld	s4,64(sp)
    80005008:	7ae2                	ld	s5,56(sp)
    8000500a:	7b42                	ld	s6,48(sp)
    8000500c:	7ba2                	ld	s7,40(sp)
    8000500e:	7c02                	ld	s8,32(sp)
    80005010:	6ce2                	ld	s9,24(sp)
    80005012:	6165                	addi	sp,sp,112
    80005014:	8082                	ret
      wakeup(&pi->nread);
    80005016:	8566                	mv	a0,s9
    80005018:	ffffd097          	auipc	ra,0xffffd
    8000501c:	4c8080e7          	jalr	1224(ra) # 800024e0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005020:	85de                	mv	a1,s7
    80005022:	8562                	mv	a0,s8
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	458080e7          	jalr	1112(ra) # 8000247c <sleep>
    8000502c:	a839                	j	8000504a <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000502e:	21c4a783          	lw	a5,540(s1)
    80005032:	0017871b          	addiw	a4,a5,1
    80005036:	20e4ae23          	sw	a4,540(s1)
    8000503a:	1ff7f793          	andi	a5,a5,511
    8000503e:	97a6                	add	a5,a5,s1
    80005040:	f9f44703          	lbu	a4,-97(s0)
    80005044:	00e78c23          	sb	a4,24(a5)
      i++;
    80005048:	2905                	addiw	s2,s2,1
  while(i < n){
    8000504a:	05495063          	bge	s2,s4,8000508a <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    8000504e:	2204a783          	lw	a5,544(s1)
    80005052:	dfd1                	beqz	a5,80004fee <pipewrite+0x48>
    80005054:	854e                	mv	a0,s3
    80005056:	ffffd097          	auipc	ra,0xffffd
    8000505a:	738080e7          	jalr	1848(ra) # 8000278e <killed>
    8000505e:	f941                	bnez	a0,80004fee <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005060:	2184a783          	lw	a5,536(s1)
    80005064:	21c4a703          	lw	a4,540(s1)
    80005068:	2007879b          	addiw	a5,a5,512
    8000506c:	faf705e3          	beq	a4,a5,80005016 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005070:	4685                	li	a3,1
    80005072:	01590633          	add	a2,s2,s5
    80005076:	f9f40593          	addi	a1,s0,-97
    8000507a:	0909b503          	ld	a0,144(s3)
    8000507e:	ffffc097          	auipc	ra,0xffffc
    80005082:	692080e7          	jalr	1682(ra) # 80001710 <copyin>
    80005086:	fb6514e3          	bne	a0,s6,8000502e <pipewrite+0x88>
  wakeup(&pi->nread);
    8000508a:	21848513          	addi	a0,s1,536
    8000508e:	ffffd097          	auipc	ra,0xffffd
    80005092:	452080e7          	jalr	1106(ra) # 800024e0 <wakeup>
  release(&pi->lock);
    80005096:	8526                	mv	a0,s1
    80005098:	ffffc097          	auipc	ra,0xffffc
    8000509c:	c06080e7          	jalr	-1018(ra) # 80000c9e <release>
  return i;
    800050a0:	bfa9                	j	80004ffa <pipewrite+0x54>
  int i = 0;
    800050a2:	4901                	li	s2,0
    800050a4:	b7dd                	j	8000508a <pipewrite+0xe4>

00000000800050a6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800050a6:	715d                	addi	sp,sp,-80
    800050a8:	e486                	sd	ra,72(sp)
    800050aa:	e0a2                	sd	s0,64(sp)
    800050ac:	fc26                	sd	s1,56(sp)
    800050ae:	f84a                	sd	s2,48(sp)
    800050b0:	f44e                	sd	s3,40(sp)
    800050b2:	f052                	sd	s4,32(sp)
    800050b4:	ec56                	sd	s5,24(sp)
    800050b6:	e85a                	sd	s6,16(sp)
    800050b8:	0880                	addi	s0,sp,80
    800050ba:	84aa                	mv	s1,a0
    800050bc:	892e                	mv	s2,a1
    800050be:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800050c0:	ffffd097          	auipc	ra,0xffffd
    800050c4:	91c080e7          	jalr	-1764(ra) # 800019dc <myproc>
    800050c8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800050ca:	8b26                	mv	s6,s1
    800050cc:	8526                	mv	a0,s1
    800050ce:	ffffc097          	auipc	ra,0xffffc
    800050d2:	b1c080e7          	jalr	-1252(ra) # 80000bea <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050d6:	2184a703          	lw	a4,536(s1)
    800050da:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050de:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800050e2:	02f71763          	bne	a4,a5,80005110 <piperead+0x6a>
    800050e6:	2244a783          	lw	a5,548(s1)
    800050ea:	c39d                	beqz	a5,80005110 <piperead+0x6a>
    if(killed(pr)){
    800050ec:	8552                	mv	a0,s4
    800050ee:	ffffd097          	auipc	ra,0xffffd
    800050f2:	6a0080e7          	jalr	1696(ra) # 8000278e <killed>
    800050f6:	e941                	bnez	a0,80005186 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800050f8:	85da                	mv	a1,s6
    800050fa:	854e                	mv	a0,s3
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	380080e7          	jalr	896(ra) # 8000247c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005104:	2184a703          	lw	a4,536(s1)
    80005108:	21c4a783          	lw	a5,540(s1)
    8000510c:	fcf70de3          	beq	a4,a5,800050e6 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005110:	09505263          	blez	s5,80005194 <piperead+0xee>
    80005114:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005116:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80005118:	2184a783          	lw	a5,536(s1)
    8000511c:	21c4a703          	lw	a4,540(s1)
    80005120:	02f70d63          	beq	a4,a5,8000515a <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005124:	0017871b          	addiw	a4,a5,1
    80005128:	20e4ac23          	sw	a4,536(s1)
    8000512c:	1ff7f793          	andi	a5,a5,511
    80005130:	97a6                	add	a5,a5,s1
    80005132:	0187c783          	lbu	a5,24(a5)
    80005136:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000513a:	4685                	li	a3,1
    8000513c:	fbf40613          	addi	a2,s0,-65
    80005140:	85ca                	mv	a1,s2
    80005142:	090a3503          	ld	a0,144(s4)
    80005146:	ffffc097          	auipc	ra,0xffffc
    8000514a:	53e080e7          	jalr	1342(ra) # 80001684 <copyout>
    8000514e:	01650663          	beq	a0,s6,8000515a <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005152:	2985                	addiw	s3,s3,1
    80005154:	0905                	addi	s2,s2,1
    80005156:	fd3a91e3          	bne	s5,s3,80005118 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000515a:	21c48513          	addi	a0,s1,540
    8000515e:	ffffd097          	auipc	ra,0xffffd
    80005162:	382080e7          	jalr	898(ra) # 800024e0 <wakeup>
  release(&pi->lock);
    80005166:	8526                	mv	a0,s1
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	b36080e7          	jalr	-1226(ra) # 80000c9e <release>
  return i;
}
    80005170:	854e                	mv	a0,s3
    80005172:	60a6                	ld	ra,72(sp)
    80005174:	6406                	ld	s0,64(sp)
    80005176:	74e2                	ld	s1,56(sp)
    80005178:	7942                	ld	s2,48(sp)
    8000517a:	79a2                	ld	s3,40(sp)
    8000517c:	7a02                	ld	s4,32(sp)
    8000517e:	6ae2                	ld	s5,24(sp)
    80005180:	6b42                	ld	s6,16(sp)
    80005182:	6161                	addi	sp,sp,80
    80005184:	8082                	ret
      release(&pi->lock);
    80005186:	8526                	mv	a0,s1
    80005188:	ffffc097          	auipc	ra,0xffffc
    8000518c:	b16080e7          	jalr	-1258(ra) # 80000c9e <release>
      return -1;
    80005190:	59fd                	li	s3,-1
    80005192:	bff9                	j	80005170 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005194:	4981                	li	s3,0
    80005196:	b7d1                	j	8000515a <piperead+0xb4>

0000000080005198 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005198:	1141                	addi	sp,sp,-16
    8000519a:	e422                	sd	s0,8(sp)
    8000519c:	0800                	addi	s0,sp,16
    8000519e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800051a0:	8905                	andi	a0,a0,1
    800051a2:	c111                	beqz	a0,800051a6 <flags2perm+0xe>
      perm = PTE_X;
    800051a4:	4521                	li	a0,8
    if(flags & 0x2)
    800051a6:	8b89                	andi	a5,a5,2
    800051a8:	c399                	beqz	a5,800051ae <flags2perm+0x16>
      perm |= PTE_W;
    800051aa:	00456513          	ori	a0,a0,4
    return perm;
}
    800051ae:	6422                	ld	s0,8(sp)
    800051b0:	0141                	addi	sp,sp,16
    800051b2:	8082                	ret

00000000800051b4 <exec>:

int
exec(char *path, char **argv)
{
    800051b4:	df010113          	addi	sp,sp,-528
    800051b8:	20113423          	sd	ra,520(sp)
    800051bc:	20813023          	sd	s0,512(sp)
    800051c0:	ffa6                	sd	s1,504(sp)
    800051c2:	fbca                	sd	s2,496(sp)
    800051c4:	f7ce                	sd	s3,488(sp)
    800051c6:	f3d2                	sd	s4,480(sp)
    800051c8:	efd6                	sd	s5,472(sp)
    800051ca:	ebda                	sd	s6,464(sp)
    800051cc:	e7de                	sd	s7,456(sp)
    800051ce:	e3e2                	sd	s8,448(sp)
    800051d0:	ff66                	sd	s9,440(sp)
    800051d2:	fb6a                	sd	s10,432(sp)
    800051d4:	f76e                	sd	s11,424(sp)
    800051d6:	0c00                	addi	s0,sp,528
    800051d8:	84aa                	mv	s1,a0
    800051da:	dea43c23          	sd	a0,-520(s0)
    800051de:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800051e2:	ffffc097          	auipc	ra,0xffffc
    800051e6:	7fa080e7          	jalr	2042(ra) # 800019dc <myproc>
    800051ea:	892a                	mv	s2,a0

  begin_op();
    800051ec:	fffff097          	auipc	ra,0xfffff
    800051f0:	474080e7          	jalr	1140(ra) # 80004660 <begin_op>

  if((ip = namei(path)) == 0){
    800051f4:	8526                	mv	a0,s1
    800051f6:	fffff097          	auipc	ra,0xfffff
    800051fa:	24e080e7          	jalr	590(ra) # 80004444 <namei>
    800051fe:	c92d                	beqz	a0,80005270 <exec+0xbc>
    80005200:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005202:	fffff097          	auipc	ra,0xfffff
    80005206:	a9c080e7          	jalr	-1380(ra) # 80003c9e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000520a:	04000713          	li	a4,64
    8000520e:	4681                	li	a3,0
    80005210:	e5040613          	addi	a2,s0,-432
    80005214:	4581                	li	a1,0
    80005216:	8526                	mv	a0,s1
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	d3a080e7          	jalr	-710(ra) # 80003f52 <readi>
    80005220:	04000793          	li	a5,64
    80005224:	00f51a63          	bne	a0,a5,80005238 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005228:	e5042703          	lw	a4,-432(s0)
    8000522c:	464c47b7          	lui	a5,0x464c4
    80005230:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005234:	04f70463          	beq	a4,a5,8000527c <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005238:	8526                	mv	a0,s1
    8000523a:	fffff097          	auipc	ra,0xfffff
    8000523e:	cc6080e7          	jalr	-826(ra) # 80003f00 <iunlockput>
    end_op();
    80005242:	fffff097          	auipc	ra,0xfffff
    80005246:	49e080e7          	jalr	1182(ra) # 800046e0 <end_op>
  }
  return -1;
    8000524a:	557d                	li	a0,-1
}
    8000524c:	20813083          	ld	ra,520(sp)
    80005250:	20013403          	ld	s0,512(sp)
    80005254:	74fe                	ld	s1,504(sp)
    80005256:	795e                	ld	s2,496(sp)
    80005258:	79be                	ld	s3,488(sp)
    8000525a:	7a1e                	ld	s4,480(sp)
    8000525c:	6afe                	ld	s5,472(sp)
    8000525e:	6b5e                	ld	s6,464(sp)
    80005260:	6bbe                	ld	s7,456(sp)
    80005262:	6c1e                	ld	s8,448(sp)
    80005264:	7cfa                	ld	s9,440(sp)
    80005266:	7d5a                	ld	s10,432(sp)
    80005268:	7dba                	ld	s11,424(sp)
    8000526a:	21010113          	addi	sp,sp,528
    8000526e:	8082                	ret
    end_op();
    80005270:	fffff097          	auipc	ra,0xfffff
    80005274:	470080e7          	jalr	1136(ra) # 800046e0 <end_op>
    return -1;
    80005278:	557d                	li	a0,-1
    8000527a:	bfc9                	j	8000524c <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000527c:	854a                	mv	a0,s2
    8000527e:	ffffd097          	auipc	ra,0xffffd
    80005282:	980080e7          	jalr	-1664(ra) # 80001bfe <proc_pagetable>
    80005286:	8baa                	mv	s7,a0
    80005288:	d945                	beqz	a0,80005238 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000528a:	e7042983          	lw	s3,-400(s0)
    8000528e:	e8845783          	lhu	a5,-376(s0)
    80005292:	c7ad                	beqz	a5,800052fc <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005294:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005296:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80005298:	6c85                	lui	s9,0x1
    8000529a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000529e:	def43823          	sd	a5,-528(s0)
    800052a2:	ac0d                	j	800054d4 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800052a4:	00003517          	auipc	a0,0x3
    800052a8:	4ec50513          	addi	a0,a0,1260 # 80008790 <syscalls+0x2a8>
    800052ac:	ffffb097          	auipc	ra,0xffffb
    800052b0:	298080e7          	jalr	664(ra) # 80000544 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800052b4:	8756                	mv	a4,s5
    800052b6:	012d86bb          	addw	a3,s11,s2
    800052ba:	4581                	li	a1,0
    800052bc:	8526                	mv	a0,s1
    800052be:	fffff097          	auipc	ra,0xfffff
    800052c2:	c94080e7          	jalr	-876(ra) # 80003f52 <readi>
    800052c6:	2501                	sext.w	a0,a0
    800052c8:	1aaa9a63          	bne	s5,a0,8000547c <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800052cc:	6785                	lui	a5,0x1
    800052ce:	0127893b          	addw	s2,a5,s2
    800052d2:	77fd                	lui	a5,0xfffff
    800052d4:	01478a3b          	addw	s4,a5,s4
    800052d8:	1f897563          	bgeu	s2,s8,800054c2 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800052dc:	02091593          	slli	a1,s2,0x20
    800052e0:	9181                	srli	a1,a1,0x20
    800052e2:	95ea                	add	a1,a1,s10
    800052e4:	855e                	mv	a0,s7
    800052e6:	ffffc097          	auipc	ra,0xffffc
    800052ea:	d92080e7          	jalr	-622(ra) # 80001078 <walkaddr>
    800052ee:	862a                	mv	a2,a0
    if(pa == 0)
    800052f0:	d955                	beqz	a0,800052a4 <exec+0xf0>
      n = PGSIZE;
    800052f2:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800052f4:	fd9a70e3          	bgeu	s4,s9,800052b4 <exec+0x100>
      n = sz - i;
    800052f8:	8ad2                	mv	s5,s4
    800052fa:	bf6d                	j	800052b4 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800052fc:	4a01                	li	s4,0
  iunlockput(ip);
    800052fe:	8526                	mv	a0,s1
    80005300:	fffff097          	auipc	ra,0xfffff
    80005304:	c00080e7          	jalr	-1024(ra) # 80003f00 <iunlockput>
  end_op();
    80005308:	fffff097          	auipc	ra,0xfffff
    8000530c:	3d8080e7          	jalr	984(ra) # 800046e0 <end_op>
  p = myproc();
    80005310:	ffffc097          	auipc	ra,0xffffc
    80005314:	6cc080e7          	jalr	1740(ra) # 800019dc <myproc>
    80005318:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000531a:	08853d03          	ld	s10,136(a0)
  sz = PGROUNDUP(sz);
    8000531e:	6785                	lui	a5,0x1
    80005320:	17fd                	addi	a5,a5,-1
    80005322:	9a3e                	add	s4,s4,a5
    80005324:	757d                	lui	a0,0xfffff
    80005326:	00aa77b3          	and	a5,s4,a0
    8000532a:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000532e:	4691                	li	a3,4
    80005330:	6609                	lui	a2,0x2
    80005332:	963e                	add	a2,a2,a5
    80005334:	85be                	mv	a1,a5
    80005336:	855e                	mv	a0,s7
    80005338:	ffffc097          	auipc	ra,0xffffc
    8000533c:	0f4080e7          	jalr	244(ra) # 8000142c <uvmalloc>
    80005340:	8b2a                	mv	s6,a0
  ip = 0;
    80005342:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005344:	12050c63          	beqz	a0,8000547c <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80005348:	75f9                	lui	a1,0xffffe
    8000534a:	95aa                	add	a1,a1,a0
    8000534c:	855e                	mv	a0,s7
    8000534e:	ffffc097          	auipc	ra,0xffffc
    80005352:	304080e7          	jalr	772(ra) # 80001652 <uvmclear>
  stackbase = sp - PGSIZE;
    80005356:	7c7d                	lui	s8,0xfffff
    80005358:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000535a:	e0043783          	ld	a5,-512(s0)
    8000535e:	6388                	ld	a0,0(a5)
    80005360:	c535                	beqz	a0,800053cc <exec+0x218>
    80005362:	e9040993          	addi	s3,s0,-368
    80005366:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000536a:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000536c:	ffffc097          	auipc	ra,0xffffc
    80005370:	afe080e7          	jalr	-1282(ra) # 80000e6a <strlen>
    80005374:	2505                	addiw	a0,a0,1
    80005376:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000537a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000537e:	13896663          	bltu	s2,s8,800054aa <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005382:	e0043d83          	ld	s11,-512(s0)
    80005386:	000dba03          	ld	s4,0(s11)
    8000538a:	8552                	mv	a0,s4
    8000538c:	ffffc097          	auipc	ra,0xffffc
    80005390:	ade080e7          	jalr	-1314(ra) # 80000e6a <strlen>
    80005394:	0015069b          	addiw	a3,a0,1
    80005398:	8652                	mv	a2,s4
    8000539a:	85ca                	mv	a1,s2
    8000539c:	855e                	mv	a0,s7
    8000539e:	ffffc097          	auipc	ra,0xffffc
    800053a2:	2e6080e7          	jalr	742(ra) # 80001684 <copyout>
    800053a6:	10054663          	bltz	a0,800054b2 <exec+0x2fe>
    ustack[argc] = sp;
    800053aa:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800053ae:	0485                	addi	s1,s1,1
    800053b0:	008d8793          	addi	a5,s11,8
    800053b4:	e0f43023          	sd	a5,-512(s0)
    800053b8:	008db503          	ld	a0,8(s11)
    800053bc:	c911                	beqz	a0,800053d0 <exec+0x21c>
    if(argc >= MAXARG)
    800053be:	09a1                	addi	s3,s3,8
    800053c0:	fb3c96e3          	bne	s9,s3,8000536c <exec+0x1b8>
  sz = sz1;
    800053c4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800053c8:	4481                	li	s1,0
    800053ca:	a84d                	j	8000547c <exec+0x2c8>
  sp = sz;
    800053cc:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800053ce:	4481                	li	s1,0
  ustack[argc] = 0;
    800053d0:	00349793          	slli	a5,s1,0x3
    800053d4:	f9040713          	addi	a4,s0,-112
    800053d8:	97ba                	add	a5,a5,a4
    800053da:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800053de:	00148693          	addi	a3,s1,1
    800053e2:	068e                	slli	a3,a3,0x3
    800053e4:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800053e8:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800053ec:	01897663          	bgeu	s2,s8,800053f8 <exec+0x244>
  sz = sz1;
    800053f0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800053f4:	4481                	li	s1,0
    800053f6:	a059                	j	8000547c <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800053f8:	e9040613          	addi	a2,s0,-368
    800053fc:	85ca                	mv	a1,s2
    800053fe:	855e                	mv	a0,s7
    80005400:	ffffc097          	auipc	ra,0xffffc
    80005404:	284080e7          	jalr	644(ra) # 80001684 <copyout>
    80005408:	0a054963          	bltz	a0,800054ba <exec+0x306>
  p->trapframe->a1 = sp;
    8000540c:	098ab783          	ld	a5,152(s5)
    80005410:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005414:	df843783          	ld	a5,-520(s0)
    80005418:	0007c703          	lbu	a4,0(a5)
    8000541c:	cf11                	beqz	a4,80005438 <exec+0x284>
    8000541e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005420:	02f00693          	li	a3,47
    80005424:	a039                	j	80005432 <exec+0x27e>
      last = s+1;
    80005426:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000542a:	0785                	addi	a5,a5,1
    8000542c:	fff7c703          	lbu	a4,-1(a5)
    80005430:	c701                	beqz	a4,80005438 <exec+0x284>
    if(*s == '/')
    80005432:	fed71ce3          	bne	a4,a3,8000542a <exec+0x276>
    80005436:	bfc5                	j	80005426 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80005438:	4641                	li	a2,16
    8000543a:	df843583          	ld	a1,-520(s0)
    8000543e:	198a8513          	addi	a0,s5,408
    80005442:	ffffc097          	auipc	ra,0xffffc
    80005446:	9f6080e7          	jalr	-1546(ra) # 80000e38 <safestrcpy>
  oldpagetable = p->pagetable;
    8000544a:	090ab503          	ld	a0,144(s5)
  p->pagetable = pagetable;
    8000544e:	097ab823          	sd	s7,144(s5)
  p->sz = sz;
    80005452:	096ab423          	sd	s6,136(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005456:	098ab783          	ld	a5,152(s5)
    8000545a:	e6843703          	ld	a4,-408(s0)
    8000545e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005460:	098ab783          	ld	a5,152(s5)
    80005464:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005468:	85ea                	mv	a1,s10
    8000546a:	ffffd097          	auipc	ra,0xffffd
    8000546e:	830080e7          	jalr	-2000(ra) # 80001c9a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005472:	0004851b          	sext.w	a0,s1
    80005476:	bbd9                	j	8000524c <exec+0x98>
    80005478:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000547c:	e0843583          	ld	a1,-504(s0)
    80005480:	855e                	mv	a0,s7
    80005482:	ffffd097          	auipc	ra,0xffffd
    80005486:	818080e7          	jalr	-2024(ra) # 80001c9a <proc_freepagetable>
  if(ip){
    8000548a:	da0497e3          	bnez	s1,80005238 <exec+0x84>
  return -1;
    8000548e:	557d                	li	a0,-1
    80005490:	bb75                	j	8000524c <exec+0x98>
    80005492:	e1443423          	sd	s4,-504(s0)
    80005496:	b7dd                	j	8000547c <exec+0x2c8>
    80005498:	e1443423          	sd	s4,-504(s0)
    8000549c:	b7c5                	j	8000547c <exec+0x2c8>
    8000549e:	e1443423          	sd	s4,-504(s0)
    800054a2:	bfe9                	j	8000547c <exec+0x2c8>
    800054a4:	e1443423          	sd	s4,-504(s0)
    800054a8:	bfd1                	j	8000547c <exec+0x2c8>
  sz = sz1;
    800054aa:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800054ae:	4481                	li	s1,0
    800054b0:	b7f1                	j	8000547c <exec+0x2c8>
  sz = sz1;
    800054b2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800054b6:	4481                	li	s1,0
    800054b8:	b7d1                	j	8000547c <exec+0x2c8>
  sz = sz1;
    800054ba:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800054be:	4481                	li	s1,0
    800054c0:	bf75                	j	8000547c <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800054c2:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054c6:	2b05                	addiw	s6,s6,1
    800054c8:	0389899b          	addiw	s3,s3,56
    800054cc:	e8845783          	lhu	a5,-376(s0)
    800054d0:	e2fb57e3          	bge	s6,a5,800052fe <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800054d4:	2981                	sext.w	s3,s3
    800054d6:	03800713          	li	a4,56
    800054da:	86ce                	mv	a3,s3
    800054dc:	e1840613          	addi	a2,s0,-488
    800054e0:	4581                	li	a1,0
    800054e2:	8526                	mv	a0,s1
    800054e4:	fffff097          	auipc	ra,0xfffff
    800054e8:	a6e080e7          	jalr	-1426(ra) # 80003f52 <readi>
    800054ec:	03800793          	li	a5,56
    800054f0:	f8f514e3          	bne	a0,a5,80005478 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800054f4:	e1842783          	lw	a5,-488(s0)
    800054f8:	4705                	li	a4,1
    800054fa:	fce796e3          	bne	a5,a4,800054c6 <exec+0x312>
    if(ph.memsz < ph.filesz)
    800054fe:	e4043903          	ld	s2,-448(s0)
    80005502:	e3843783          	ld	a5,-456(s0)
    80005506:	f8f966e3          	bltu	s2,a5,80005492 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000550a:	e2843783          	ld	a5,-472(s0)
    8000550e:	993e                	add	s2,s2,a5
    80005510:	f8f964e3          	bltu	s2,a5,80005498 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    80005514:	df043703          	ld	a4,-528(s0)
    80005518:	8ff9                	and	a5,a5,a4
    8000551a:	f3d1                	bnez	a5,8000549e <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000551c:	e1c42503          	lw	a0,-484(s0)
    80005520:	00000097          	auipc	ra,0x0
    80005524:	c78080e7          	jalr	-904(ra) # 80005198 <flags2perm>
    80005528:	86aa                	mv	a3,a0
    8000552a:	864a                	mv	a2,s2
    8000552c:	85d2                	mv	a1,s4
    8000552e:	855e                	mv	a0,s7
    80005530:	ffffc097          	auipc	ra,0xffffc
    80005534:	efc080e7          	jalr	-260(ra) # 8000142c <uvmalloc>
    80005538:	e0a43423          	sd	a0,-504(s0)
    8000553c:	d525                	beqz	a0,800054a4 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000553e:	e2843d03          	ld	s10,-472(s0)
    80005542:	e2042d83          	lw	s11,-480(s0)
    80005546:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000554a:	f60c0ce3          	beqz	s8,800054c2 <exec+0x30e>
    8000554e:	8a62                	mv	s4,s8
    80005550:	4901                	li	s2,0
    80005552:	b369                	j	800052dc <exec+0x128>

0000000080005554 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005554:	7179                	addi	sp,sp,-48
    80005556:	f406                	sd	ra,40(sp)
    80005558:	f022                	sd	s0,32(sp)
    8000555a:	ec26                	sd	s1,24(sp)
    8000555c:	e84a                	sd	s2,16(sp)
    8000555e:	1800                	addi	s0,sp,48
    80005560:	892e                	mv	s2,a1
    80005562:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005564:	fdc40593          	addi	a1,s0,-36
    80005568:	ffffe097          	auipc	ra,0xffffe
    8000556c:	a9c080e7          	jalr	-1380(ra) # 80003004 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005570:	fdc42703          	lw	a4,-36(s0)
    80005574:	47bd                	li	a5,15
    80005576:	02e7eb63          	bltu	a5,a4,800055ac <argfd+0x58>
    8000557a:	ffffc097          	auipc	ra,0xffffc
    8000557e:	462080e7          	jalr	1122(ra) # 800019dc <myproc>
    80005582:	fdc42703          	lw	a4,-36(s0)
    80005586:	02270793          	addi	a5,a4,34
    8000558a:	078e                	slli	a5,a5,0x3
    8000558c:	953e                	add	a0,a0,a5
    8000558e:	611c                	ld	a5,0(a0)
    80005590:	c385                	beqz	a5,800055b0 <argfd+0x5c>
    return -1;
  if(pfd)
    80005592:	00090463          	beqz	s2,8000559a <argfd+0x46>
    *pfd = fd;
    80005596:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000559a:	4501                	li	a0,0
  if(pf)
    8000559c:	c091                	beqz	s1,800055a0 <argfd+0x4c>
    *pf = f;
    8000559e:	e09c                	sd	a5,0(s1)
}
    800055a0:	70a2                	ld	ra,40(sp)
    800055a2:	7402                	ld	s0,32(sp)
    800055a4:	64e2                	ld	s1,24(sp)
    800055a6:	6942                	ld	s2,16(sp)
    800055a8:	6145                	addi	sp,sp,48
    800055aa:	8082                	ret
    return -1;
    800055ac:	557d                	li	a0,-1
    800055ae:	bfcd                	j	800055a0 <argfd+0x4c>
    800055b0:	557d                	li	a0,-1
    800055b2:	b7fd                	j	800055a0 <argfd+0x4c>

00000000800055b4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800055b4:	1101                	addi	sp,sp,-32
    800055b6:	ec06                	sd	ra,24(sp)
    800055b8:	e822                	sd	s0,16(sp)
    800055ba:	e426                	sd	s1,8(sp)
    800055bc:	1000                	addi	s0,sp,32
    800055be:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800055c0:	ffffc097          	auipc	ra,0xffffc
    800055c4:	41c080e7          	jalr	1052(ra) # 800019dc <myproc>
    800055c8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800055ca:	11050793          	addi	a5,a0,272 # fffffffffffff110 <end+0xffffffff7ffdc2f0>
    800055ce:	4501                	li	a0,0
    800055d0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800055d2:	6398                	ld	a4,0(a5)
    800055d4:	cb19                	beqz	a4,800055ea <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800055d6:	2505                	addiw	a0,a0,1
    800055d8:	07a1                	addi	a5,a5,8
    800055da:	fed51ce3          	bne	a0,a3,800055d2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800055de:	557d                	li	a0,-1
}
    800055e0:	60e2                	ld	ra,24(sp)
    800055e2:	6442                	ld	s0,16(sp)
    800055e4:	64a2                	ld	s1,8(sp)
    800055e6:	6105                	addi	sp,sp,32
    800055e8:	8082                	ret
      p->ofile[fd] = f;
    800055ea:	02250793          	addi	a5,a0,34
    800055ee:	078e                	slli	a5,a5,0x3
    800055f0:	963e                	add	a2,a2,a5
    800055f2:	e204                	sd	s1,0(a2)
      return fd;
    800055f4:	b7f5                	j	800055e0 <fdalloc+0x2c>

00000000800055f6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800055f6:	715d                	addi	sp,sp,-80
    800055f8:	e486                	sd	ra,72(sp)
    800055fa:	e0a2                	sd	s0,64(sp)
    800055fc:	fc26                	sd	s1,56(sp)
    800055fe:	f84a                	sd	s2,48(sp)
    80005600:	f44e                	sd	s3,40(sp)
    80005602:	f052                	sd	s4,32(sp)
    80005604:	ec56                	sd	s5,24(sp)
    80005606:	e85a                	sd	s6,16(sp)
    80005608:	0880                	addi	s0,sp,80
    8000560a:	8b2e                	mv	s6,a1
    8000560c:	89b2                	mv	s3,a2
    8000560e:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005610:	fb040593          	addi	a1,s0,-80
    80005614:	fffff097          	auipc	ra,0xfffff
    80005618:	e4e080e7          	jalr	-434(ra) # 80004462 <nameiparent>
    8000561c:	84aa                	mv	s1,a0
    8000561e:	16050063          	beqz	a0,8000577e <create+0x188>
    return 0;

  ilock(dp);
    80005622:	ffffe097          	auipc	ra,0xffffe
    80005626:	67c080e7          	jalr	1660(ra) # 80003c9e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000562a:	4601                	li	a2,0
    8000562c:	fb040593          	addi	a1,s0,-80
    80005630:	8526                	mv	a0,s1
    80005632:	fffff097          	auipc	ra,0xfffff
    80005636:	b50080e7          	jalr	-1200(ra) # 80004182 <dirlookup>
    8000563a:	8aaa                	mv	s5,a0
    8000563c:	c931                	beqz	a0,80005690 <create+0x9a>
    iunlockput(dp);
    8000563e:	8526                	mv	a0,s1
    80005640:	fffff097          	auipc	ra,0xfffff
    80005644:	8c0080e7          	jalr	-1856(ra) # 80003f00 <iunlockput>
    ilock(ip);
    80005648:	8556                	mv	a0,s5
    8000564a:	ffffe097          	auipc	ra,0xffffe
    8000564e:	654080e7          	jalr	1620(ra) # 80003c9e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005652:	000b059b          	sext.w	a1,s6
    80005656:	4789                	li	a5,2
    80005658:	02f59563          	bne	a1,a5,80005682 <create+0x8c>
    8000565c:	044ad783          	lhu	a5,68(s5)
    80005660:	37f9                	addiw	a5,a5,-2
    80005662:	17c2                	slli	a5,a5,0x30
    80005664:	93c1                	srli	a5,a5,0x30
    80005666:	4705                	li	a4,1
    80005668:	00f76d63          	bltu	a4,a5,80005682 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000566c:	8556                	mv	a0,s5
    8000566e:	60a6                	ld	ra,72(sp)
    80005670:	6406                	ld	s0,64(sp)
    80005672:	74e2                	ld	s1,56(sp)
    80005674:	7942                	ld	s2,48(sp)
    80005676:	79a2                	ld	s3,40(sp)
    80005678:	7a02                	ld	s4,32(sp)
    8000567a:	6ae2                	ld	s5,24(sp)
    8000567c:	6b42                	ld	s6,16(sp)
    8000567e:	6161                	addi	sp,sp,80
    80005680:	8082                	ret
    iunlockput(ip);
    80005682:	8556                	mv	a0,s5
    80005684:	fffff097          	auipc	ra,0xfffff
    80005688:	87c080e7          	jalr	-1924(ra) # 80003f00 <iunlockput>
    return 0;
    8000568c:	4a81                	li	s5,0
    8000568e:	bff9                	j	8000566c <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005690:	85da                	mv	a1,s6
    80005692:	4088                	lw	a0,0(s1)
    80005694:	ffffe097          	auipc	ra,0xffffe
    80005698:	46e080e7          	jalr	1134(ra) # 80003b02 <ialloc>
    8000569c:	8a2a                	mv	s4,a0
    8000569e:	c921                	beqz	a0,800056ee <create+0xf8>
  ilock(ip);
    800056a0:	ffffe097          	auipc	ra,0xffffe
    800056a4:	5fe080e7          	jalr	1534(ra) # 80003c9e <ilock>
  ip->major = major;
    800056a8:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800056ac:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800056b0:	4785                	li	a5,1
    800056b2:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800056b6:	8552                	mv	a0,s4
    800056b8:	ffffe097          	auipc	ra,0xffffe
    800056bc:	51c080e7          	jalr	1308(ra) # 80003bd4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800056c0:	000b059b          	sext.w	a1,s6
    800056c4:	4785                	li	a5,1
    800056c6:	02f58b63          	beq	a1,a5,800056fc <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800056ca:	004a2603          	lw	a2,4(s4)
    800056ce:	fb040593          	addi	a1,s0,-80
    800056d2:	8526                	mv	a0,s1
    800056d4:	fffff097          	auipc	ra,0xfffff
    800056d8:	cbe080e7          	jalr	-834(ra) # 80004392 <dirlink>
    800056dc:	06054f63          	bltz	a0,8000575a <create+0x164>
  iunlockput(dp);
    800056e0:	8526                	mv	a0,s1
    800056e2:	fffff097          	auipc	ra,0xfffff
    800056e6:	81e080e7          	jalr	-2018(ra) # 80003f00 <iunlockput>
  return ip;
    800056ea:	8ad2                	mv	s5,s4
    800056ec:	b741                	j	8000566c <create+0x76>
    iunlockput(dp);
    800056ee:	8526                	mv	a0,s1
    800056f0:	fffff097          	auipc	ra,0xfffff
    800056f4:	810080e7          	jalr	-2032(ra) # 80003f00 <iunlockput>
    return 0;
    800056f8:	8ad2                	mv	s5,s4
    800056fa:	bf8d                	j	8000566c <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800056fc:	004a2603          	lw	a2,4(s4)
    80005700:	00003597          	auipc	a1,0x3
    80005704:	0b058593          	addi	a1,a1,176 # 800087b0 <syscalls+0x2c8>
    80005708:	8552                	mv	a0,s4
    8000570a:	fffff097          	auipc	ra,0xfffff
    8000570e:	c88080e7          	jalr	-888(ra) # 80004392 <dirlink>
    80005712:	04054463          	bltz	a0,8000575a <create+0x164>
    80005716:	40d0                	lw	a2,4(s1)
    80005718:	00003597          	auipc	a1,0x3
    8000571c:	0a058593          	addi	a1,a1,160 # 800087b8 <syscalls+0x2d0>
    80005720:	8552                	mv	a0,s4
    80005722:	fffff097          	auipc	ra,0xfffff
    80005726:	c70080e7          	jalr	-912(ra) # 80004392 <dirlink>
    8000572a:	02054863          	bltz	a0,8000575a <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    8000572e:	004a2603          	lw	a2,4(s4)
    80005732:	fb040593          	addi	a1,s0,-80
    80005736:	8526                	mv	a0,s1
    80005738:	fffff097          	auipc	ra,0xfffff
    8000573c:	c5a080e7          	jalr	-934(ra) # 80004392 <dirlink>
    80005740:	00054d63          	bltz	a0,8000575a <create+0x164>
    dp->nlink++;  // for ".."
    80005744:	04a4d783          	lhu	a5,74(s1)
    80005748:	2785                	addiw	a5,a5,1
    8000574a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000574e:	8526                	mv	a0,s1
    80005750:	ffffe097          	auipc	ra,0xffffe
    80005754:	484080e7          	jalr	1156(ra) # 80003bd4 <iupdate>
    80005758:	b761                	j	800056e0 <create+0xea>
  ip->nlink = 0;
    8000575a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000575e:	8552                	mv	a0,s4
    80005760:	ffffe097          	auipc	ra,0xffffe
    80005764:	474080e7          	jalr	1140(ra) # 80003bd4 <iupdate>
  iunlockput(ip);
    80005768:	8552                	mv	a0,s4
    8000576a:	ffffe097          	auipc	ra,0xffffe
    8000576e:	796080e7          	jalr	1942(ra) # 80003f00 <iunlockput>
  iunlockput(dp);
    80005772:	8526                	mv	a0,s1
    80005774:	ffffe097          	auipc	ra,0xffffe
    80005778:	78c080e7          	jalr	1932(ra) # 80003f00 <iunlockput>
  return 0;
    8000577c:	bdc5                	j	8000566c <create+0x76>
    return 0;
    8000577e:	8aaa                	mv	s5,a0
    80005780:	b5f5                	j	8000566c <create+0x76>

0000000080005782 <sys_dup>:
{
    80005782:	7179                	addi	sp,sp,-48
    80005784:	f406                	sd	ra,40(sp)
    80005786:	f022                	sd	s0,32(sp)
    80005788:	ec26                	sd	s1,24(sp)
    8000578a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000578c:	fd840613          	addi	a2,s0,-40
    80005790:	4581                	li	a1,0
    80005792:	4501                	li	a0,0
    80005794:	00000097          	auipc	ra,0x0
    80005798:	dc0080e7          	jalr	-576(ra) # 80005554 <argfd>
    return -1;
    8000579c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000579e:	02054363          	bltz	a0,800057c4 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800057a2:	fd843503          	ld	a0,-40(s0)
    800057a6:	00000097          	auipc	ra,0x0
    800057aa:	e0e080e7          	jalr	-498(ra) # 800055b4 <fdalloc>
    800057ae:	84aa                	mv	s1,a0
    return -1;
    800057b0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800057b2:	00054963          	bltz	a0,800057c4 <sys_dup+0x42>
  filedup(f);
    800057b6:	fd843503          	ld	a0,-40(s0)
    800057ba:	fffff097          	auipc	ra,0xfffff
    800057be:	320080e7          	jalr	800(ra) # 80004ada <filedup>
  return fd;
    800057c2:	87a6                	mv	a5,s1
}
    800057c4:	853e                	mv	a0,a5
    800057c6:	70a2                	ld	ra,40(sp)
    800057c8:	7402                	ld	s0,32(sp)
    800057ca:	64e2                	ld	s1,24(sp)
    800057cc:	6145                	addi	sp,sp,48
    800057ce:	8082                	ret

00000000800057d0 <sys_read>:
{
    800057d0:	7179                	addi	sp,sp,-48
    800057d2:	f406                	sd	ra,40(sp)
    800057d4:	f022                	sd	s0,32(sp)
    800057d6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800057d8:	fd840593          	addi	a1,s0,-40
    800057dc:	4505                	li	a0,1
    800057de:	ffffe097          	auipc	ra,0xffffe
    800057e2:	846080e7          	jalr	-1978(ra) # 80003024 <argaddr>
  argint(2, &n);
    800057e6:	fe440593          	addi	a1,s0,-28
    800057ea:	4509                	li	a0,2
    800057ec:	ffffe097          	auipc	ra,0xffffe
    800057f0:	818080e7          	jalr	-2024(ra) # 80003004 <argint>
  if(argfd(0, 0, &f) < 0)
    800057f4:	fe840613          	addi	a2,s0,-24
    800057f8:	4581                	li	a1,0
    800057fa:	4501                	li	a0,0
    800057fc:	00000097          	auipc	ra,0x0
    80005800:	d58080e7          	jalr	-680(ra) # 80005554 <argfd>
    80005804:	87aa                	mv	a5,a0
    return -1;
    80005806:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005808:	0007cc63          	bltz	a5,80005820 <sys_read+0x50>
  return fileread(f, p, n);
    8000580c:	fe442603          	lw	a2,-28(s0)
    80005810:	fd843583          	ld	a1,-40(s0)
    80005814:	fe843503          	ld	a0,-24(s0)
    80005818:	fffff097          	auipc	ra,0xfffff
    8000581c:	44e080e7          	jalr	1102(ra) # 80004c66 <fileread>
}
    80005820:	70a2                	ld	ra,40(sp)
    80005822:	7402                	ld	s0,32(sp)
    80005824:	6145                	addi	sp,sp,48
    80005826:	8082                	ret

0000000080005828 <sys_write>:
{
    80005828:	7179                	addi	sp,sp,-48
    8000582a:	f406                	sd	ra,40(sp)
    8000582c:	f022                	sd	s0,32(sp)
    8000582e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005830:	fd840593          	addi	a1,s0,-40
    80005834:	4505                	li	a0,1
    80005836:	ffffd097          	auipc	ra,0xffffd
    8000583a:	7ee080e7          	jalr	2030(ra) # 80003024 <argaddr>
  argint(2, &n);
    8000583e:	fe440593          	addi	a1,s0,-28
    80005842:	4509                	li	a0,2
    80005844:	ffffd097          	auipc	ra,0xffffd
    80005848:	7c0080e7          	jalr	1984(ra) # 80003004 <argint>
  if(argfd(0, 0, &f) < 0)
    8000584c:	fe840613          	addi	a2,s0,-24
    80005850:	4581                	li	a1,0
    80005852:	4501                	li	a0,0
    80005854:	00000097          	auipc	ra,0x0
    80005858:	d00080e7          	jalr	-768(ra) # 80005554 <argfd>
    8000585c:	87aa                	mv	a5,a0
    return -1;
    8000585e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005860:	0007cc63          	bltz	a5,80005878 <sys_write+0x50>
  return filewrite(f, p, n);
    80005864:	fe442603          	lw	a2,-28(s0)
    80005868:	fd843583          	ld	a1,-40(s0)
    8000586c:	fe843503          	ld	a0,-24(s0)
    80005870:	fffff097          	auipc	ra,0xfffff
    80005874:	4b8080e7          	jalr	1208(ra) # 80004d28 <filewrite>
}
    80005878:	70a2                	ld	ra,40(sp)
    8000587a:	7402                	ld	s0,32(sp)
    8000587c:	6145                	addi	sp,sp,48
    8000587e:	8082                	ret

0000000080005880 <sys_close>:
{
    80005880:	1101                	addi	sp,sp,-32
    80005882:	ec06                	sd	ra,24(sp)
    80005884:	e822                	sd	s0,16(sp)
    80005886:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005888:	fe040613          	addi	a2,s0,-32
    8000588c:	fec40593          	addi	a1,s0,-20
    80005890:	4501                	li	a0,0
    80005892:	00000097          	auipc	ra,0x0
    80005896:	cc2080e7          	jalr	-830(ra) # 80005554 <argfd>
    return -1;
    8000589a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000589c:	02054563          	bltz	a0,800058c6 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    800058a0:	ffffc097          	auipc	ra,0xffffc
    800058a4:	13c080e7          	jalr	316(ra) # 800019dc <myproc>
    800058a8:	fec42783          	lw	a5,-20(s0)
    800058ac:	02278793          	addi	a5,a5,34
    800058b0:	078e                	slli	a5,a5,0x3
    800058b2:	97aa                	add	a5,a5,a0
    800058b4:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800058b8:	fe043503          	ld	a0,-32(s0)
    800058bc:	fffff097          	auipc	ra,0xfffff
    800058c0:	270080e7          	jalr	624(ra) # 80004b2c <fileclose>
  return 0;
    800058c4:	4781                	li	a5,0
}
    800058c6:	853e                	mv	a0,a5
    800058c8:	60e2                	ld	ra,24(sp)
    800058ca:	6442                	ld	s0,16(sp)
    800058cc:	6105                	addi	sp,sp,32
    800058ce:	8082                	ret

00000000800058d0 <sys_fstat>:
{
    800058d0:	1101                	addi	sp,sp,-32
    800058d2:	ec06                	sd	ra,24(sp)
    800058d4:	e822                	sd	s0,16(sp)
    800058d6:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800058d8:	fe040593          	addi	a1,s0,-32
    800058dc:	4505                	li	a0,1
    800058de:	ffffd097          	auipc	ra,0xffffd
    800058e2:	746080e7          	jalr	1862(ra) # 80003024 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800058e6:	fe840613          	addi	a2,s0,-24
    800058ea:	4581                	li	a1,0
    800058ec:	4501                	li	a0,0
    800058ee:	00000097          	auipc	ra,0x0
    800058f2:	c66080e7          	jalr	-922(ra) # 80005554 <argfd>
    800058f6:	87aa                	mv	a5,a0
    return -1;
    800058f8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058fa:	0007ca63          	bltz	a5,8000590e <sys_fstat+0x3e>
  return filestat(f, st);
    800058fe:	fe043583          	ld	a1,-32(s0)
    80005902:	fe843503          	ld	a0,-24(s0)
    80005906:	fffff097          	auipc	ra,0xfffff
    8000590a:	2ee080e7          	jalr	750(ra) # 80004bf4 <filestat>
}
    8000590e:	60e2                	ld	ra,24(sp)
    80005910:	6442                	ld	s0,16(sp)
    80005912:	6105                	addi	sp,sp,32
    80005914:	8082                	ret

0000000080005916 <sys_link>:
{
    80005916:	7169                	addi	sp,sp,-304
    80005918:	f606                	sd	ra,296(sp)
    8000591a:	f222                	sd	s0,288(sp)
    8000591c:	ee26                	sd	s1,280(sp)
    8000591e:	ea4a                	sd	s2,272(sp)
    80005920:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005922:	08000613          	li	a2,128
    80005926:	ed040593          	addi	a1,s0,-304
    8000592a:	4501                	li	a0,0
    8000592c:	ffffd097          	auipc	ra,0xffffd
    80005930:	718080e7          	jalr	1816(ra) # 80003044 <argstr>
    return -1;
    80005934:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005936:	10054e63          	bltz	a0,80005a52 <sys_link+0x13c>
    8000593a:	08000613          	li	a2,128
    8000593e:	f5040593          	addi	a1,s0,-176
    80005942:	4505                	li	a0,1
    80005944:	ffffd097          	auipc	ra,0xffffd
    80005948:	700080e7          	jalr	1792(ra) # 80003044 <argstr>
    return -1;
    8000594c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000594e:	10054263          	bltz	a0,80005a52 <sys_link+0x13c>
  begin_op();
    80005952:	fffff097          	auipc	ra,0xfffff
    80005956:	d0e080e7          	jalr	-754(ra) # 80004660 <begin_op>
  if((ip = namei(old)) == 0){
    8000595a:	ed040513          	addi	a0,s0,-304
    8000595e:	fffff097          	auipc	ra,0xfffff
    80005962:	ae6080e7          	jalr	-1306(ra) # 80004444 <namei>
    80005966:	84aa                	mv	s1,a0
    80005968:	c551                	beqz	a0,800059f4 <sys_link+0xde>
  ilock(ip);
    8000596a:	ffffe097          	auipc	ra,0xffffe
    8000596e:	334080e7          	jalr	820(ra) # 80003c9e <ilock>
  if(ip->type == T_DIR){
    80005972:	04449703          	lh	a4,68(s1)
    80005976:	4785                	li	a5,1
    80005978:	08f70463          	beq	a4,a5,80005a00 <sys_link+0xea>
  ip->nlink++;
    8000597c:	04a4d783          	lhu	a5,74(s1)
    80005980:	2785                	addiw	a5,a5,1
    80005982:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005986:	8526                	mv	a0,s1
    80005988:	ffffe097          	auipc	ra,0xffffe
    8000598c:	24c080e7          	jalr	588(ra) # 80003bd4 <iupdate>
  iunlock(ip);
    80005990:	8526                	mv	a0,s1
    80005992:	ffffe097          	auipc	ra,0xffffe
    80005996:	3ce080e7          	jalr	974(ra) # 80003d60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000599a:	fd040593          	addi	a1,s0,-48
    8000599e:	f5040513          	addi	a0,s0,-176
    800059a2:	fffff097          	auipc	ra,0xfffff
    800059a6:	ac0080e7          	jalr	-1344(ra) # 80004462 <nameiparent>
    800059aa:	892a                	mv	s2,a0
    800059ac:	c935                	beqz	a0,80005a20 <sys_link+0x10a>
  ilock(dp);
    800059ae:	ffffe097          	auipc	ra,0xffffe
    800059b2:	2f0080e7          	jalr	752(ra) # 80003c9e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800059b6:	00092703          	lw	a4,0(s2)
    800059ba:	409c                	lw	a5,0(s1)
    800059bc:	04f71d63          	bne	a4,a5,80005a16 <sys_link+0x100>
    800059c0:	40d0                	lw	a2,4(s1)
    800059c2:	fd040593          	addi	a1,s0,-48
    800059c6:	854a                	mv	a0,s2
    800059c8:	fffff097          	auipc	ra,0xfffff
    800059cc:	9ca080e7          	jalr	-1590(ra) # 80004392 <dirlink>
    800059d0:	04054363          	bltz	a0,80005a16 <sys_link+0x100>
  iunlockput(dp);
    800059d4:	854a                	mv	a0,s2
    800059d6:	ffffe097          	auipc	ra,0xffffe
    800059da:	52a080e7          	jalr	1322(ra) # 80003f00 <iunlockput>
  iput(ip);
    800059de:	8526                	mv	a0,s1
    800059e0:	ffffe097          	auipc	ra,0xffffe
    800059e4:	478080e7          	jalr	1144(ra) # 80003e58 <iput>
  end_op();
    800059e8:	fffff097          	auipc	ra,0xfffff
    800059ec:	cf8080e7          	jalr	-776(ra) # 800046e0 <end_op>
  return 0;
    800059f0:	4781                	li	a5,0
    800059f2:	a085                	j	80005a52 <sys_link+0x13c>
    end_op();
    800059f4:	fffff097          	auipc	ra,0xfffff
    800059f8:	cec080e7          	jalr	-788(ra) # 800046e0 <end_op>
    return -1;
    800059fc:	57fd                	li	a5,-1
    800059fe:	a891                	j	80005a52 <sys_link+0x13c>
    iunlockput(ip);
    80005a00:	8526                	mv	a0,s1
    80005a02:	ffffe097          	auipc	ra,0xffffe
    80005a06:	4fe080e7          	jalr	1278(ra) # 80003f00 <iunlockput>
    end_op();
    80005a0a:	fffff097          	auipc	ra,0xfffff
    80005a0e:	cd6080e7          	jalr	-810(ra) # 800046e0 <end_op>
    return -1;
    80005a12:	57fd                	li	a5,-1
    80005a14:	a83d                	j	80005a52 <sys_link+0x13c>
    iunlockput(dp);
    80005a16:	854a                	mv	a0,s2
    80005a18:	ffffe097          	auipc	ra,0xffffe
    80005a1c:	4e8080e7          	jalr	1256(ra) # 80003f00 <iunlockput>
  ilock(ip);
    80005a20:	8526                	mv	a0,s1
    80005a22:	ffffe097          	auipc	ra,0xffffe
    80005a26:	27c080e7          	jalr	636(ra) # 80003c9e <ilock>
  ip->nlink--;
    80005a2a:	04a4d783          	lhu	a5,74(s1)
    80005a2e:	37fd                	addiw	a5,a5,-1
    80005a30:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a34:	8526                	mv	a0,s1
    80005a36:	ffffe097          	auipc	ra,0xffffe
    80005a3a:	19e080e7          	jalr	414(ra) # 80003bd4 <iupdate>
  iunlockput(ip);
    80005a3e:	8526                	mv	a0,s1
    80005a40:	ffffe097          	auipc	ra,0xffffe
    80005a44:	4c0080e7          	jalr	1216(ra) # 80003f00 <iunlockput>
  end_op();
    80005a48:	fffff097          	auipc	ra,0xfffff
    80005a4c:	c98080e7          	jalr	-872(ra) # 800046e0 <end_op>
  return -1;
    80005a50:	57fd                	li	a5,-1
}
    80005a52:	853e                	mv	a0,a5
    80005a54:	70b2                	ld	ra,296(sp)
    80005a56:	7412                	ld	s0,288(sp)
    80005a58:	64f2                	ld	s1,280(sp)
    80005a5a:	6952                	ld	s2,272(sp)
    80005a5c:	6155                	addi	sp,sp,304
    80005a5e:	8082                	ret

0000000080005a60 <sys_unlink>:
{
    80005a60:	7151                	addi	sp,sp,-240
    80005a62:	f586                	sd	ra,232(sp)
    80005a64:	f1a2                	sd	s0,224(sp)
    80005a66:	eda6                	sd	s1,216(sp)
    80005a68:	e9ca                	sd	s2,208(sp)
    80005a6a:	e5ce                	sd	s3,200(sp)
    80005a6c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005a6e:	08000613          	li	a2,128
    80005a72:	f3040593          	addi	a1,s0,-208
    80005a76:	4501                	li	a0,0
    80005a78:	ffffd097          	auipc	ra,0xffffd
    80005a7c:	5cc080e7          	jalr	1484(ra) # 80003044 <argstr>
    80005a80:	18054163          	bltz	a0,80005c02 <sys_unlink+0x1a2>
  begin_op();
    80005a84:	fffff097          	auipc	ra,0xfffff
    80005a88:	bdc080e7          	jalr	-1060(ra) # 80004660 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005a8c:	fb040593          	addi	a1,s0,-80
    80005a90:	f3040513          	addi	a0,s0,-208
    80005a94:	fffff097          	auipc	ra,0xfffff
    80005a98:	9ce080e7          	jalr	-1586(ra) # 80004462 <nameiparent>
    80005a9c:	84aa                	mv	s1,a0
    80005a9e:	c979                	beqz	a0,80005b74 <sys_unlink+0x114>
  ilock(dp);
    80005aa0:	ffffe097          	auipc	ra,0xffffe
    80005aa4:	1fe080e7          	jalr	510(ra) # 80003c9e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005aa8:	00003597          	auipc	a1,0x3
    80005aac:	d0858593          	addi	a1,a1,-760 # 800087b0 <syscalls+0x2c8>
    80005ab0:	fb040513          	addi	a0,s0,-80
    80005ab4:	ffffe097          	auipc	ra,0xffffe
    80005ab8:	6b4080e7          	jalr	1716(ra) # 80004168 <namecmp>
    80005abc:	14050a63          	beqz	a0,80005c10 <sys_unlink+0x1b0>
    80005ac0:	00003597          	auipc	a1,0x3
    80005ac4:	cf858593          	addi	a1,a1,-776 # 800087b8 <syscalls+0x2d0>
    80005ac8:	fb040513          	addi	a0,s0,-80
    80005acc:	ffffe097          	auipc	ra,0xffffe
    80005ad0:	69c080e7          	jalr	1692(ra) # 80004168 <namecmp>
    80005ad4:	12050e63          	beqz	a0,80005c10 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005ad8:	f2c40613          	addi	a2,s0,-212
    80005adc:	fb040593          	addi	a1,s0,-80
    80005ae0:	8526                	mv	a0,s1
    80005ae2:	ffffe097          	auipc	ra,0xffffe
    80005ae6:	6a0080e7          	jalr	1696(ra) # 80004182 <dirlookup>
    80005aea:	892a                	mv	s2,a0
    80005aec:	12050263          	beqz	a0,80005c10 <sys_unlink+0x1b0>
  ilock(ip);
    80005af0:	ffffe097          	auipc	ra,0xffffe
    80005af4:	1ae080e7          	jalr	430(ra) # 80003c9e <ilock>
  if(ip->nlink < 1)
    80005af8:	04a91783          	lh	a5,74(s2)
    80005afc:	08f05263          	blez	a5,80005b80 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005b00:	04491703          	lh	a4,68(s2)
    80005b04:	4785                	li	a5,1
    80005b06:	08f70563          	beq	a4,a5,80005b90 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005b0a:	4641                	li	a2,16
    80005b0c:	4581                	li	a1,0
    80005b0e:	fc040513          	addi	a0,s0,-64
    80005b12:	ffffb097          	auipc	ra,0xffffb
    80005b16:	1d4080e7          	jalr	468(ra) # 80000ce6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b1a:	4741                	li	a4,16
    80005b1c:	f2c42683          	lw	a3,-212(s0)
    80005b20:	fc040613          	addi	a2,s0,-64
    80005b24:	4581                	li	a1,0
    80005b26:	8526                	mv	a0,s1
    80005b28:	ffffe097          	auipc	ra,0xffffe
    80005b2c:	522080e7          	jalr	1314(ra) # 8000404a <writei>
    80005b30:	47c1                	li	a5,16
    80005b32:	0af51563          	bne	a0,a5,80005bdc <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005b36:	04491703          	lh	a4,68(s2)
    80005b3a:	4785                	li	a5,1
    80005b3c:	0af70863          	beq	a4,a5,80005bec <sys_unlink+0x18c>
  iunlockput(dp);
    80005b40:	8526                	mv	a0,s1
    80005b42:	ffffe097          	auipc	ra,0xffffe
    80005b46:	3be080e7          	jalr	958(ra) # 80003f00 <iunlockput>
  ip->nlink--;
    80005b4a:	04a95783          	lhu	a5,74(s2)
    80005b4e:	37fd                	addiw	a5,a5,-1
    80005b50:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b54:	854a                	mv	a0,s2
    80005b56:	ffffe097          	auipc	ra,0xffffe
    80005b5a:	07e080e7          	jalr	126(ra) # 80003bd4 <iupdate>
  iunlockput(ip);
    80005b5e:	854a                	mv	a0,s2
    80005b60:	ffffe097          	auipc	ra,0xffffe
    80005b64:	3a0080e7          	jalr	928(ra) # 80003f00 <iunlockput>
  end_op();
    80005b68:	fffff097          	auipc	ra,0xfffff
    80005b6c:	b78080e7          	jalr	-1160(ra) # 800046e0 <end_op>
  return 0;
    80005b70:	4501                	li	a0,0
    80005b72:	a84d                	j	80005c24 <sys_unlink+0x1c4>
    end_op();
    80005b74:	fffff097          	auipc	ra,0xfffff
    80005b78:	b6c080e7          	jalr	-1172(ra) # 800046e0 <end_op>
    return -1;
    80005b7c:	557d                	li	a0,-1
    80005b7e:	a05d                	j	80005c24 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005b80:	00003517          	auipc	a0,0x3
    80005b84:	c4050513          	addi	a0,a0,-960 # 800087c0 <syscalls+0x2d8>
    80005b88:	ffffb097          	auipc	ra,0xffffb
    80005b8c:	9bc080e7          	jalr	-1604(ra) # 80000544 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005b90:	04c92703          	lw	a4,76(s2)
    80005b94:	02000793          	li	a5,32
    80005b98:	f6e7f9e3          	bgeu	a5,a4,80005b0a <sys_unlink+0xaa>
    80005b9c:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ba0:	4741                	li	a4,16
    80005ba2:	86ce                	mv	a3,s3
    80005ba4:	f1840613          	addi	a2,s0,-232
    80005ba8:	4581                	li	a1,0
    80005baa:	854a                	mv	a0,s2
    80005bac:	ffffe097          	auipc	ra,0xffffe
    80005bb0:	3a6080e7          	jalr	934(ra) # 80003f52 <readi>
    80005bb4:	47c1                	li	a5,16
    80005bb6:	00f51b63          	bne	a0,a5,80005bcc <sys_unlink+0x16c>
    if(de.inum != 0)
    80005bba:	f1845783          	lhu	a5,-232(s0)
    80005bbe:	e7a1                	bnez	a5,80005c06 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005bc0:	29c1                	addiw	s3,s3,16
    80005bc2:	04c92783          	lw	a5,76(s2)
    80005bc6:	fcf9ede3          	bltu	s3,a5,80005ba0 <sys_unlink+0x140>
    80005bca:	b781                	j	80005b0a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005bcc:	00003517          	auipc	a0,0x3
    80005bd0:	c0c50513          	addi	a0,a0,-1012 # 800087d8 <syscalls+0x2f0>
    80005bd4:	ffffb097          	auipc	ra,0xffffb
    80005bd8:	970080e7          	jalr	-1680(ra) # 80000544 <panic>
    panic("unlink: writei");
    80005bdc:	00003517          	auipc	a0,0x3
    80005be0:	c1450513          	addi	a0,a0,-1004 # 800087f0 <syscalls+0x308>
    80005be4:	ffffb097          	auipc	ra,0xffffb
    80005be8:	960080e7          	jalr	-1696(ra) # 80000544 <panic>
    dp->nlink--;
    80005bec:	04a4d783          	lhu	a5,74(s1)
    80005bf0:	37fd                	addiw	a5,a5,-1
    80005bf2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005bf6:	8526                	mv	a0,s1
    80005bf8:	ffffe097          	auipc	ra,0xffffe
    80005bfc:	fdc080e7          	jalr	-36(ra) # 80003bd4 <iupdate>
    80005c00:	b781                	j	80005b40 <sys_unlink+0xe0>
    return -1;
    80005c02:	557d                	li	a0,-1
    80005c04:	a005                	j	80005c24 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005c06:	854a                	mv	a0,s2
    80005c08:	ffffe097          	auipc	ra,0xffffe
    80005c0c:	2f8080e7          	jalr	760(ra) # 80003f00 <iunlockput>
  iunlockput(dp);
    80005c10:	8526                	mv	a0,s1
    80005c12:	ffffe097          	auipc	ra,0xffffe
    80005c16:	2ee080e7          	jalr	750(ra) # 80003f00 <iunlockput>
  end_op();
    80005c1a:	fffff097          	auipc	ra,0xfffff
    80005c1e:	ac6080e7          	jalr	-1338(ra) # 800046e0 <end_op>
  return -1;
    80005c22:	557d                	li	a0,-1
}
    80005c24:	70ae                	ld	ra,232(sp)
    80005c26:	740e                	ld	s0,224(sp)
    80005c28:	64ee                	ld	s1,216(sp)
    80005c2a:	694e                	ld	s2,208(sp)
    80005c2c:	69ae                	ld	s3,200(sp)
    80005c2e:	616d                	addi	sp,sp,240
    80005c30:	8082                	ret

0000000080005c32 <sys_open>:

uint64
sys_open(void)
{
    80005c32:	7131                	addi	sp,sp,-192
    80005c34:	fd06                	sd	ra,184(sp)
    80005c36:	f922                	sd	s0,176(sp)
    80005c38:	f526                	sd	s1,168(sp)
    80005c3a:	f14a                	sd	s2,160(sp)
    80005c3c:	ed4e                	sd	s3,152(sp)
    80005c3e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005c40:	f4c40593          	addi	a1,s0,-180
    80005c44:	4505                	li	a0,1
    80005c46:	ffffd097          	auipc	ra,0xffffd
    80005c4a:	3be080e7          	jalr	958(ra) # 80003004 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c4e:	08000613          	li	a2,128
    80005c52:	f5040593          	addi	a1,s0,-176
    80005c56:	4501                	li	a0,0
    80005c58:	ffffd097          	auipc	ra,0xffffd
    80005c5c:	3ec080e7          	jalr	1004(ra) # 80003044 <argstr>
    80005c60:	87aa                	mv	a5,a0
    return -1;
    80005c62:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005c64:	0a07c963          	bltz	a5,80005d16 <sys_open+0xe4>

  begin_op();
    80005c68:	fffff097          	auipc	ra,0xfffff
    80005c6c:	9f8080e7          	jalr	-1544(ra) # 80004660 <begin_op>

  if(omode & O_CREATE){
    80005c70:	f4c42783          	lw	a5,-180(s0)
    80005c74:	2007f793          	andi	a5,a5,512
    80005c78:	cfc5                	beqz	a5,80005d30 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80005c7a:	4681                	li	a3,0
    80005c7c:	4601                	li	a2,0
    80005c7e:	4589                	li	a1,2
    80005c80:	f5040513          	addi	a0,s0,-176
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	972080e7          	jalr	-1678(ra) # 800055f6 <create>
    80005c8c:	84aa                	mv	s1,a0
    if(ip == 0){
    80005c8e:	c959                	beqz	a0,80005d24 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005c90:	04449703          	lh	a4,68(s1)
    80005c94:	478d                	li	a5,3
    80005c96:	00f71763          	bne	a4,a5,80005ca4 <sys_open+0x72>
    80005c9a:	0464d703          	lhu	a4,70(s1)
    80005c9e:	47a5                	li	a5,9
    80005ca0:	0ce7ed63          	bltu	a5,a4,80005d7a <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005ca4:	fffff097          	auipc	ra,0xfffff
    80005ca8:	dcc080e7          	jalr	-564(ra) # 80004a70 <filealloc>
    80005cac:	89aa                	mv	s3,a0
    80005cae:	10050363          	beqz	a0,80005db4 <sys_open+0x182>
    80005cb2:	00000097          	auipc	ra,0x0
    80005cb6:	902080e7          	jalr	-1790(ra) # 800055b4 <fdalloc>
    80005cba:	892a                	mv	s2,a0
    80005cbc:	0e054763          	bltz	a0,80005daa <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005cc0:	04449703          	lh	a4,68(s1)
    80005cc4:	478d                	li	a5,3
    80005cc6:	0cf70563          	beq	a4,a5,80005d90 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005cca:	4789                	li	a5,2
    80005ccc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005cd0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005cd4:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005cd8:	f4c42783          	lw	a5,-180(s0)
    80005cdc:	0017c713          	xori	a4,a5,1
    80005ce0:	8b05                	andi	a4,a4,1
    80005ce2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005ce6:	0037f713          	andi	a4,a5,3
    80005cea:	00e03733          	snez	a4,a4
    80005cee:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005cf2:	4007f793          	andi	a5,a5,1024
    80005cf6:	c791                	beqz	a5,80005d02 <sys_open+0xd0>
    80005cf8:	04449703          	lh	a4,68(s1)
    80005cfc:	4789                	li	a5,2
    80005cfe:	0af70063          	beq	a4,a5,80005d9e <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005d02:	8526                	mv	a0,s1
    80005d04:	ffffe097          	auipc	ra,0xffffe
    80005d08:	05c080e7          	jalr	92(ra) # 80003d60 <iunlock>
  end_op();
    80005d0c:	fffff097          	auipc	ra,0xfffff
    80005d10:	9d4080e7          	jalr	-1580(ra) # 800046e0 <end_op>

  return fd;
    80005d14:	854a                	mv	a0,s2
}
    80005d16:	70ea                	ld	ra,184(sp)
    80005d18:	744a                	ld	s0,176(sp)
    80005d1a:	74aa                	ld	s1,168(sp)
    80005d1c:	790a                	ld	s2,160(sp)
    80005d1e:	69ea                	ld	s3,152(sp)
    80005d20:	6129                	addi	sp,sp,192
    80005d22:	8082                	ret
      end_op();
    80005d24:	fffff097          	auipc	ra,0xfffff
    80005d28:	9bc080e7          	jalr	-1604(ra) # 800046e0 <end_op>
      return -1;
    80005d2c:	557d                	li	a0,-1
    80005d2e:	b7e5                	j	80005d16 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005d30:	f5040513          	addi	a0,s0,-176
    80005d34:	ffffe097          	auipc	ra,0xffffe
    80005d38:	710080e7          	jalr	1808(ra) # 80004444 <namei>
    80005d3c:	84aa                	mv	s1,a0
    80005d3e:	c905                	beqz	a0,80005d6e <sys_open+0x13c>
    ilock(ip);
    80005d40:	ffffe097          	auipc	ra,0xffffe
    80005d44:	f5e080e7          	jalr	-162(ra) # 80003c9e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005d48:	04449703          	lh	a4,68(s1)
    80005d4c:	4785                	li	a5,1
    80005d4e:	f4f711e3          	bne	a4,a5,80005c90 <sys_open+0x5e>
    80005d52:	f4c42783          	lw	a5,-180(s0)
    80005d56:	d7b9                	beqz	a5,80005ca4 <sys_open+0x72>
      iunlockput(ip);
    80005d58:	8526                	mv	a0,s1
    80005d5a:	ffffe097          	auipc	ra,0xffffe
    80005d5e:	1a6080e7          	jalr	422(ra) # 80003f00 <iunlockput>
      end_op();
    80005d62:	fffff097          	auipc	ra,0xfffff
    80005d66:	97e080e7          	jalr	-1666(ra) # 800046e0 <end_op>
      return -1;
    80005d6a:	557d                	li	a0,-1
    80005d6c:	b76d                	j	80005d16 <sys_open+0xe4>
      end_op();
    80005d6e:	fffff097          	auipc	ra,0xfffff
    80005d72:	972080e7          	jalr	-1678(ra) # 800046e0 <end_op>
      return -1;
    80005d76:	557d                	li	a0,-1
    80005d78:	bf79                	j	80005d16 <sys_open+0xe4>
    iunlockput(ip);
    80005d7a:	8526                	mv	a0,s1
    80005d7c:	ffffe097          	auipc	ra,0xffffe
    80005d80:	184080e7          	jalr	388(ra) # 80003f00 <iunlockput>
    end_op();
    80005d84:	fffff097          	auipc	ra,0xfffff
    80005d88:	95c080e7          	jalr	-1700(ra) # 800046e0 <end_op>
    return -1;
    80005d8c:	557d                	li	a0,-1
    80005d8e:	b761                	j	80005d16 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80005d90:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005d94:	04649783          	lh	a5,70(s1)
    80005d98:	02f99223          	sh	a5,36(s3)
    80005d9c:	bf25                	j	80005cd4 <sys_open+0xa2>
    itrunc(ip);
    80005d9e:	8526                	mv	a0,s1
    80005da0:	ffffe097          	auipc	ra,0xffffe
    80005da4:	00c080e7          	jalr	12(ra) # 80003dac <itrunc>
    80005da8:	bfa9                	j	80005d02 <sys_open+0xd0>
      fileclose(f);
    80005daa:	854e                	mv	a0,s3
    80005dac:	fffff097          	auipc	ra,0xfffff
    80005db0:	d80080e7          	jalr	-640(ra) # 80004b2c <fileclose>
    iunlockput(ip);
    80005db4:	8526                	mv	a0,s1
    80005db6:	ffffe097          	auipc	ra,0xffffe
    80005dba:	14a080e7          	jalr	330(ra) # 80003f00 <iunlockput>
    end_op();
    80005dbe:	fffff097          	auipc	ra,0xfffff
    80005dc2:	922080e7          	jalr	-1758(ra) # 800046e0 <end_op>
    return -1;
    80005dc6:	557d                	li	a0,-1
    80005dc8:	b7b9                	j	80005d16 <sys_open+0xe4>

0000000080005dca <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005dca:	7175                	addi	sp,sp,-144
    80005dcc:	e506                	sd	ra,136(sp)
    80005dce:	e122                	sd	s0,128(sp)
    80005dd0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005dd2:	fffff097          	auipc	ra,0xfffff
    80005dd6:	88e080e7          	jalr	-1906(ra) # 80004660 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005dda:	08000613          	li	a2,128
    80005dde:	f7040593          	addi	a1,s0,-144
    80005de2:	4501                	li	a0,0
    80005de4:	ffffd097          	auipc	ra,0xffffd
    80005de8:	260080e7          	jalr	608(ra) # 80003044 <argstr>
    80005dec:	02054963          	bltz	a0,80005e1e <sys_mkdir+0x54>
    80005df0:	4681                	li	a3,0
    80005df2:	4601                	li	a2,0
    80005df4:	4585                	li	a1,1
    80005df6:	f7040513          	addi	a0,s0,-144
    80005dfa:	fffff097          	auipc	ra,0xfffff
    80005dfe:	7fc080e7          	jalr	2044(ra) # 800055f6 <create>
    80005e02:	cd11                	beqz	a0,80005e1e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e04:	ffffe097          	auipc	ra,0xffffe
    80005e08:	0fc080e7          	jalr	252(ra) # 80003f00 <iunlockput>
  end_op();
    80005e0c:	fffff097          	auipc	ra,0xfffff
    80005e10:	8d4080e7          	jalr	-1836(ra) # 800046e0 <end_op>
  return 0;
    80005e14:	4501                	li	a0,0
}
    80005e16:	60aa                	ld	ra,136(sp)
    80005e18:	640a                	ld	s0,128(sp)
    80005e1a:	6149                	addi	sp,sp,144
    80005e1c:	8082                	ret
    end_op();
    80005e1e:	fffff097          	auipc	ra,0xfffff
    80005e22:	8c2080e7          	jalr	-1854(ra) # 800046e0 <end_op>
    return -1;
    80005e26:	557d                	li	a0,-1
    80005e28:	b7fd                	j	80005e16 <sys_mkdir+0x4c>

0000000080005e2a <sys_mknod>:

uint64
sys_mknod(void)
{
    80005e2a:	7135                	addi	sp,sp,-160
    80005e2c:	ed06                	sd	ra,152(sp)
    80005e2e:	e922                	sd	s0,144(sp)
    80005e30:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005e32:	fffff097          	auipc	ra,0xfffff
    80005e36:	82e080e7          	jalr	-2002(ra) # 80004660 <begin_op>
  argint(1, &major);
    80005e3a:	f6c40593          	addi	a1,s0,-148
    80005e3e:	4505                	li	a0,1
    80005e40:	ffffd097          	auipc	ra,0xffffd
    80005e44:	1c4080e7          	jalr	452(ra) # 80003004 <argint>
  argint(2, &minor);
    80005e48:	f6840593          	addi	a1,s0,-152
    80005e4c:	4509                	li	a0,2
    80005e4e:	ffffd097          	auipc	ra,0xffffd
    80005e52:	1b6080e7          	jalr	438(ra) # 80003004 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e56:	08000613          	li	a2,128
    80005e5a:	f7040593          	addi	a1,s0,-144
    80005e5e:	4501                	li	a0,0
    80005e60:	ffffd097          	auipc	ra,0xffffd
    80005e64:	1e4080e7          	jalr	484(ra) # 80003044 <argstr>
    80005e68:	02054b63          	bltz	a0,80005e9e <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005e6c:	f6841683          	lh	a3,-152(s0)
    80005e70:	f6c41603          	lh	a2,-148(s0)
    80005e74:	458d                	li	a1,3
    80005e76:	f7040513          	addi	a0,s0,-144
    80005e7a:	fffff097          	auipc	ra,0xfffff
    80005e7e:	77c080e7          	jalr	1916(ra) # 800055f6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005e82:	cd11                	beqz	a0,80005e9e <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005e84:	ffffe097          	auipc	ra,0xffffe
    80005e88:	07c080e7          	jalr	124(ra) # 80003f00 <iunlockput>
  end_op();
    80005e8c:	fffff097          	auipc	ra,0xfffff
    80005e90:	854080e7          	jalr	-1964(ra) # 800046e0 <end_op>
  return 0;
    80005e94:	4501                	li	a0,0
}
    80005e96:	60ea                	ld	ra,152(sp)
    80005e98:	644a                	ld	s0,144(sp)
    80005e9a:	610d                	addi	sp,sp,160
    80005e9c:	8082                	ret
    end_op();
    80005e9e:	fffff097          	auipc	ra,0xfffff
    80005ea2:	842080e7          	jalr	-1982(ra) # 800046e0 <end_op>
    return -1;
    80005ea6:	557d                	li	a0,-1
    80005ea8:	b7fd                	j	80005e96 <sys_mknod+0x6c>

0000000080005eaa <sys_chdir>:

uint64
sys_chdir(void)
{
    80005eaa:	7135                	addi	sp,sp,-160
    80005eac:	ed06                	sd	ra,152(sp)
    80005eae:	e922                	sd	s0,144(sp)
    80005eb0:	e526                	sd	s1,136(sp)
    80005eb2:	e14a                	sd	s2,128(sp)
    80005eb4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005eb6:	ffffc097          	auipc	ra,0xffffc
    80005eba:	b26080e7          	jalr	-1242(ra) # 800019dc <myproc>
    80005ebe:	892a                	mv	s2,a0
  
  begin_op();
    80005ec0:	ffffe097          	auipc	ra,0xffffe
    80005ec4:	7a0080e7          	jalr	1952(ra) # 80004660 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005ec8:	08000613          	li	a2,128
    80005ecc:	f6040593          	addi	a1,s0,-160
    80005ed0:	4501                	li	a0,0
    80005ed2:	ffffd097          	auipc	ra,0xffffd
    80005ed6:	172080e7          	jalr	370(ra) # 80003044 <argstr>
    80005eda:	04054b63          	bltz	a0,80005f30 <sys_chdir+0x86>
    80005ede:	f6040513          	addi	a0,s0,-160
    80005ee2:	ffffe097          	auipc	ra,0xffffe
    80005ee6:	562080e7          	jalr	1378(ra) # 80004444 <namei>
    80005eea:	84aa                	mv	s1,a0
    80005eec:	c131                	beqz	a0,80005f30 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005eee:	ffffe097          	auipc	ra,0xffffe
    80005ef2:	db0080e7          	jalr	-592(ra) # 80003c9e <ilock>
  if(ip->type != T_DIR){
    80005ef6:	04449703          	lh	a4,68(s1)
    80005efa:	4785                	li	a5,1
    80005efc:	04f71063          	bne	a4,a5,80005f3c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f00:	8526                	mv	a0,s1
    80005f02:	ffffe097          	auipc	ra,0xffffe
    80005f06:	e5e080e7          	jalr	-418(ra) # 80003d60 <iunlock>
  iput(p->cwd);
    80005f0a:	19093503          	ld	a0,400(s2)
    80005f0e:	ffffe097          	auipc	ra,0xffffe
    80005f12:	f4a080e7          	jalr	-182(ra) # 80003e58 <iput>
  end_op();
    80005f16:	ffffe097          	auipc	ra,0xffffe
    80005f1a:	7ca080e7          	jalr	1994(ra) # 800046e0 <end_op>
  p->cwd = ip;
    80005f1e:	18993823          	sd	s1,400(s2)
  return 0;
    80005f22:	4501                	li	a0,0
}
    80005f24:	60ea                	ld	ra,152(sp)
    80005f26:	644a                	ld	s0,144(sp)
    80005f28:	64aa                	ld	s1,136(sp)
    80005f2a:	690a                	ld	s2,128(sp)
    80005f2c:	610d                	addi	sp,sp,160
    80005f2e:	8082                	ret
    end_op();
    80005f30:	ffffe097          	auipc	ra,0xffffe
    80005f34:	7b0080e7          	jalr	1968(ra) # 800046e0 <end_op>
    return -1;
    80005f38:	557d                	li	a0,-1
    80005f3a:	b7ed                	j	80005f24 <sys_chdir+0x7a>
    iunlockput(ip);
    80005f3c:	8526                	mv	a0,s1
    80005f3e:	ffffe097          	auipc	ra,0xffffe
    80005f42:	fc2080e7          	jalr	-62(ra) # 80003f00 <iunlockput>
    end_op();
    80005f46:	ffffe097          	auipc	ra,0xffffe
    80005f4a:	79a080e7          	jalr	1946(ra) # 800046e0 <end_op>
    return -1;
    80005f4e:	557d                	li	a0,-1
    80005f50:	bfd1                	j	80005f24 <sys_chdir+0x7a>

0000000080005f52 <sys_exec>:

uint64
sys_exec(void)
{
    80005f52:	7145                	addi	sp,sp,-464
    80005f54:	e786                	sd	ra,456(sp)
    80005f56:	e3a2                	sd	s0,448(sp)
    80005f58:	ff26                	sd	s1,440(sp)
    80005f5a:	fb4a                	sd	s2,432(sp)
    80005f5c:	f74e                	sd	s3,424(sp)
    80005f5e:	f352                	sd	s4,416(sp)
    80005f60:	ef56                	sd	s5,408(sp)
    80005f62:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005f64:	e3840593          	addi	a1,s0,-456
    80005f68:	4505                	li	a0,1
    80005f6a:	ffffd097          	auipc	ra,0xffffd
    80005f6e:	0ba080e7          	jalr	186(ra) # 80003024 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005f72:	08000613          	li	a2,128
    80005f76:	f4040593          	addi	a1,s0,-192
    80005f7a:	4501                	li	a0,0
    80005f7c:	ffffd097          	auipc	ra,0xffffd
    80005f80:	0c8080e7          	jalr	200(ra) # 80003044 <argstr>
    80005f84:	87aa                	mv	a5,a0
    return -1;
    80005f86:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005f88:	0c07c263          	bltz	a5,8000604c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005f8c:	10000613          	li	a2,256
    80005f90:	4581                	li	a1,0
    80005f92:	e4040513          	addi	a0,s0,-448
    80005f96:	ffffb097          	auipc	ra,0xffffb
    80005f9a:	d50080e7          	jalr	-688(ra) # 80000ce6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005f9e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005fa2:	89a6                	mv	s3,s1
    80005fa4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005fa6:	02000a13          	li	s4,32
    80005faa:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005fae:	00391513          	slli	a0,s2,0x3
    80005fb2:	e3040593          	addi	a1,s0,-464
    80005fb6:	e3843783          	ld	a5,-456(s0)
    80005fba:	953e                	add	a0,a0,a5
    80005fbc:	ffffd097          	auipc	ra,0xffffd
    80005fc0:	faa080e7          	jalr	-86(ra) # 80002f66 <fetchaddr>
    80005fc4:	02054a63          	bltz	a0,80005ff8 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005fc8:	e3043783          	ld	a5,-464(s0)
    80005fcc:	c3b9                	beqz	a5,80006012 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005fce:	ffffb097          	auipc	ra,0xffffb
    80005fd2:	b2c080e7          	jalr	-1236(ra) # 80000afa <kalloc>
    80005fd6:	85aa                	mv	a1,a0
    80005fd8:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005fdc:	cd11                	beqz	a0,80005ff8 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005fde:	6605                	lui	a2,0x1
    80005fe0:	e3043503          	ld	a0,-464(s0)
    80005fe4:	ffffd097          	auipc	ra,0xffffd
    80005fe8:	fd4080e7          	jalr	-44(ra) # 80002fb8 <fetchstr>
    80005fec:	00054663          	bltz	a0,80005ff8 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005ff0:	0905                	addi	s2,s2,1
    80005ff2:	09a1                	addi	s3,s3,8
    80005ff4:	fb491be3          	bne	s2,s4,80005faa <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ff8:	10048913          	addi	s2,s1,256
    80005ffc:	6088                	ld	a0,0(s1)
    80005ffe:	c531                	beqz	a0,8000604a <sys_exec+0xf8>
    kfree(argv[i]);
    80006000:	ffffb097          	auipc	ra,0xffffb
    80006004:	9fe080e7          	jalr	-1538(ra) # 800009fe <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006008:	04a1                	addi	s1,s1,8
    8000600a:	ff2499e3          	bne	s1,s2,80005ffc <sys_exec+0xaa>
  return -1;
    8000600e:	557d                	li	a0,-1
    80006010:	a835                	j	8000604c <sys_exec+0xfa>
      argv[i] = 0;
    80006012:	0a8e                	slli	s5,s5,0x3
    80006014:	fc040793          	addi	a5,s0,-64
    80006018:	9abe                	add	s5,s5,a5
    8000601a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000601e:	e4040593          	addi	a1,s0,-448
    80006022:	f4040513          	addi	a0,s0,-192
    80006026:	fffff097          	auipc	ra,0xfffff
    8000602a:	18e080e7          	jalr	398(ra) # 800051b4 <exec>
    8000602e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006030:	10048993          	addi	s3,s1,256
    80006034:	6088                	ld	a0,0(s1)
    80006036:	c901                	beqz	a0,80006046 <sys_exec+0xf4>
    kfree(argv[i]);
    80006038:	ffffb097          	auipc	ra,0xffffb
    8000603c:	9c6080e7          	jalr	-1594(ra) # 800009fe <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006040:	04a1                	addi	s1,s1,8
    80006042:	ff3499e3          	bne	s1,s3,80006034 <sys_exec+0xe2>
  return ret;
    80006046:	854a                	mv	a0,s2
    80006048:	a011                	j	8000604c <sys_exec+0xfa>
  return -1;
    8000604a:	557d                	li	a0,-1
}
    8000604c:	60be                	ld	ra,456(sp)
    8000604e:	641e                	ld	s0,448(sp)
    80006050:	74fa                	ld	s1,440(sp)
    80006052:	795a                	ld	s2,432(sp)
    80006054:	79ba                	ld	s3,424(sp)
    80006056:	7a1a                	ld	s4,416(sp)
    80006058:	6afa                	ld	s5,408(sp)
    8000605a:	6179                	addi	sp,sp,464
    8000605c:	8082                	ret

000000008000605e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000605e:	7139                	addi	sp,sp,-64
    80006060:	fc06                	sd	ra,56(sp)
    80006062:	f822                	sd	s0,48(sp)
    80006064:	f426                	sd	s1,40(sp)
    80006066:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006068:	ffffc097          	auipc	ra,0xffffc
    8000606c:	974080e7          	jalr	-1676(ra) # 800019dc <myproc>
    80006070:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006072:	fd840593          	addi	a1,s0,-40
    80006076:	4501                	li	a0,0
    80006078:	ffffd097          	auipc	ra,0xffffd
    8000607c:	fac080e7          	jalr	-84(ra) # 80003024 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006080:	fc840593          	addi	a1,s0,-56
    80006084:	fd040513          	addi	a0,s0,-48
    80006088:	fffff097          	auipc	ra,0xfffff
    8000608c:	dd4080e7          	jalr	-556(ra) # 80004e5c <pipealloc>
    return -1;
    80006090:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006092:	0c054763          	bltz	a0,80006160 <sys_pipe+0x102>
  fd0 = -1;
    80006096:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000609a:	fd043503          	ld	a0,-48(s0)
    8000609e:	fffff097          	auipc	ra,0xfffff
    800060a2:	516080e7          	jalr	1302(ra) # 800055b4 <fdalloc>
    800060a6:	fca42223          	sw	a0,-60(s0)
    800060aa:	08054e63          	bltz	a0,80006146 <sys_pipe+0xe8>
    800060ae:	fc843503          	ld	a0,-56(s0)
    800060b2:	fffff097          	auipc	ra,0xfffff
    800060b6:	502080e7          	jalr	1282(ra) # 800055b4 <fdalloc>
    800060ba:	fca42023          	sw	a0,-64(s0)
    800060be:	06054a63          	bltz	a0,80006132 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800060c2:	4691                	li	a3,4
    800060c4:	fc440613          	addi	a2,s0,-60
    800060c8:	fd843583          	ld	a1,-40(s0)
    800060cc:	68c8                	ld	a0,144(s1)
    800060ce:	ffffb097          	auipc	ra,0xffffb
    800060d2:	5b6080e7          	jalr	1462(ra) # 80001684 <copyout>
    800060d6:	02054063          	bltz	a0,800060f6 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800060da:	4691                	li	a3,4
    800060dc:	fc040613          	addi	a2,s0,-64
    800060e0:	fd843583          	ld	a1,-40(s0)
    800060e4:	0591                	addi	a1,a1,4
    800060e6:	68c8                	ld	a0,144(s1)
    800060e8:	ffffb097          	auipc	ra,0xffffb
    800060ec:	59c080e7          	jalr	1436(ra) # 80001684 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800060f0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800060f2:	06055763          	bgez	a0,80006160 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    800060f6:	fc442783          	lw	a5,-60(s0)
    800060fa:	02278793          	addi	a5,a5,34
    800060fe:	078e                	slli	a5,a5,0x3
    80006100:	97a6                	add	a5,a5,s1
    80006102:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006106:	fc042503          	lw	a0,-64(s0)
    8000610a:	02250513          	addi	a0,a0,34
    8000610e:	050e                	slli	a0,a0,0x3
    80006110:	94aa                	add	s1,s1,a0
    80006112:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006116:	fd043503          	ld	a0,-48(s0)
    8000611a:	fffff097          	auipc	ra,0xfffff
    8000611e:	a12080e7          	jalr	-1518(ra) # 80004b2c <fileclose>
    fileclose(wf);
    80006122:	fc843503          	ld	a0,-56(s0)
    80006126:	fffff097          	auipc	ra,0xfffff
    8000612a:	a06080e7          	jalr	-1530(ra) # 80004b2c <fileclose>
    return -1;
    8000612e:	57fd                	li	a5,-1
    80006130:	a805                	j	80006160 <sys_pipe+0x102>
    if(fd0 >= 0)
    80006132:	fc442783          	lw	a5,-60(s0)
    80006136:	0007c863          	bltz	a5,80006146 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    8000613a:	02278793          	addi	a5,a5,34
    8000613e:	078e                	slli	a5,a5,0x3
    80006140:	94be                	add	s1,s1,a5
    80006142:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006146:	fd043503          	ld	a0,-48(s0)
    8000614a:	fffff097          	auipc	ra,0xfffff
    8000614e:	9e2080e7          	jalr	-1566(ra) # 80004b2c <fileclose>
    fileclose(wf);
    80006152:	fc843503          	ld	a0,-56(s0)
    80006156:	fffff097          	auipc	ra,0xfffff
    8000615a:	9d6080e7          	jalr	-1578(ra) # 80004b2c <fileclose>
    return -1;
    8000615e:	57fd                	li	a5,-1
}
    80006160:	853e                	mv	a0,a5
    80006162:	70e2                	ld	ra,56(sp)
    80006164:	7442                	ld	s0,48(sp)
    80006166:	74a2                	ld	s1,40(sp)
    80006168:	6121                	addi	sp,sp,64
    8000616a:	8082                	ret
    8000616c:	0000                	unimp
	...

0000000080006170 <kernelvec>:
    80006170:	7111                	addi	sp,sp,-256
    80006172:	e006                	sd	ra,0(sp)
    80006174:	e40a                	sd	sp,8(sp)
    80006176:	e80e                	sd	gp,16(sp)
    80006178:	ec12                	sd	tp,24(sp)
    8000617a:	f016                	sd	t0,32(sp)
    8000617c:	f41a                	sd	t1,40(sp)
    8000617e:	f81e                	sd	t2,48(sp)
    80006180:	fc22                	sd	s0,56(sp)
    80006182:	e0a6                	sd	s1,64(sp)
    80006184:	e4aa                	sd	a0,72(sp)
    80006186:	e8ae                	sd	a1,80(sp)
    80006188:	ecb2                	sd	a2,88(sp)
    8000618a:	f0b6                	sd	a3,96(sp)
    8000618c:	f4ba                	sd	a4,104(sp)
    8000618e:	f8be                	sd	a5,112(sp)
    80006190:	fcc2                	sd	a6,120(sp)
    80006192:	e146                	sd	a7,128(sp)
    80006194:	e54a                	sd	s2,136(sp)
    80006196:	e94e                	sd	s3,144(sp)
    80006198:	ed52                	sd	s4,152(sp)
    8000619a:	f156                	sd	s5,160(sp)
    8000619c:	f55a                	sd	s6,168(sp)
    8000619e:	f95e                	sd	s7,176(sp)
    800061a0:	fd62                	sd	s8,184(sp)
    800061a2:	e1e6                	sd	s9,192(sp)
    800061a4:	e5ea                	sd	s10,200(sp)
    800061a6:	e9ee                	sd	s11,208(sp)
    800061a8:	edf2                	sd	t3,216(sp)
    800061aa:	f1f6                	sd	t4,224(sp)
    800061ac:	f5fa                	sd	t5,232(sp)
    800061ae:	f9fe                	sd	t6,240(sp)
    800061b0:	c61fc0ef          	jal	ra,80002e10 <kerneltrap>
    800061b4:	6082                	ld	ra,0(sp)
    800061b6:	6122                	ld	sp,8(sp)
    800061b8:	61c2                	ld	gp,16(sp)
    800061ba:	7282                	ld	t0,32(sp)
    800061bc:	7322                	ld	t1,40(sp)
    800061be:	73c2                	ld	t2,48(sp)
    800061c0:	7462                	ld	s0,56(sp)
    800061c2:	6486                	ld	s1,64(sp)
    800061c4:	6526                	ld	a0,72(sp)
    800061c6:	65c6                	ld	a1,80(sp)
    800061c8:	6666                	ld	a2,88(sp)
    800061ca:	7686                	ld	a3,96(sp)
    800061cc:	7726                	ld	a4,104(sp)
    800061ce:	77c6                	ld	a5,112(sp)
    800061d0:	7866                	ld	a6,120(sp)
    800061d2:	688a                	ld	a7,128(sp)
    800061d4:	692a                	ld	s2,136(sp)
    800061d6:	69ca                	ld	s3,144(sp)
    800061d8:	6a6a                	ld	s4,152(sp)
    800061da:	7a8a                	ld	s5,160(sp)
    800061dc:	7b2a                	ld	s6,168(sp)
    800061de:	7bca                	ld	s7,176(sp)
    800061e0:	7c6a                	ld	s8,184(sp)
    800061e2:	6c8e                	ld	s9,192(sp)
    800061e4:	6d2e                	ld	s10,200(sp)
    800061e6:	6dce                	ld	s11,208(sp)
    800061e8:	6e6e                	ld	t3,216(sp)
    800061ea:	7e8e                	ld	t4,224(sp)
    800061ec:	7f2e                	ld	t5,232(sp)
    800061ee:	7fce                	ld	t6,240(sp)
    800061f0:	6111                	addi	sp,sp,256
    800061f2:	10200073          	sret
    800061f6:	00000013          	nop
    800061fa:	00000013          	nop
    800061fe:	0001                	nop

0000000080006200 <timervec>:
    80006200:	34051573          	csrrw	a0,mscratch,a0
    80006204:	e10c                	sd	a1,0(a0)
    80006206:	e510                	sd	a2,8(a0)
    80006208:	e914                	sd	a3,16(a0)
    8000620a:	6d0c                	ld	a1,24(a0)
    8000620c:	7110                	ld	a2,32(a0)
    8000620e:	6194                	ld	a3,0(a1)
    80006210:	96b2                	add	a3,a3,a2
    80006212:	e194                	sd	a3,0(a1)
    80006214:	4589                	li	a1,2
    80006216:	14459073          	csrw	sip,a1
    8000621a:	6914                	ld	a3,16(a0)
    8000621c:	6510                	ld	a2,8(a0)
    8000621e:	610c                	ld	a1,0(a0)
    80006220:	34051573          	csrrw	a0,mscratch,a0
    80006224:	30200073          	mret
	...

000000008000622a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000622a:	1141                	addi	sp,sp,-16
    8000622c:	e422                	sd	s0,8(sp)
    8000622e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006230:	0c0007b7          	lui	a5,0xc000
    80006234:	4705                	li	a4,1
    80006236:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006238:	c3d8                	sw	a4,4(a5)
}
    8000623a:	6422                	ld	s0,8(sp)
    8000623c:	0141                	addi	sp,sp,16
    8000623e:	8082                	ret

0000000080006240 <plicinithart>:

void
plicinithart(void)
{
    80006240:	1141                	addi	sp,sp,-16
    80006242:	e406                	sd	ra,8(sp)
    80006244:	e022                	sd	s0,0(sp)
    80006246:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006248:	ffffb097          	auipc	ra,0xffffb
    8000624c:	768080e7          	jalr	1896(ra) # 800019b0 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006250:	0085171b          	slliw	a4,a0,0x8
    80006254:	0c0027b7          	lui	a5,0xc002
    80006258:	97ba                	add	a5,a5,a4
    8000625a:	40200713          	li	a4,1026
    8000625e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006262:	00d5151b          	slliw	a0,a0,0xd
    80006266:	0c2017b7          	lui	a5,0xc201
    8000626a:	953e                	add	a0,a0,a5
    8000626c:	00052023          	sw	zero,0(a0)
}
    80006270:	60a2                	ld	ra,8(sp)
    80006272:	6402                	ld	s0,0(sp)
    80006274:	0141                	addi	sp,sp,16
    80006276:	8082                	ret

0000000080006278 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006278:	1141                	addi	sp,sp,-16
    8000627a:	e406                	sd	ra,8(sp)
    8000627c:	e022                	sd	s0,0(sp)
    8000627e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006280:	ffffb097          	auipc	ra,0xffffb
    80006284:	730080e7          	jalr	1840(ra) # 800019b0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006288:	00d5179b          	slliw	a5,a0,0xd
    8000628c:	0c201537          	lui	a0,0xc201
    80006290:	953e                	add	a0,a0,a5
  return irq;
}
    80006292:	4148                	lw	a0,4(a0)
    80006294:	60a2                	ld	ra,8(sp)
    80006296:	6402                	ld	s0,0(sp)
    80006298:	0141                	addi	sp,sp,16
    8000629a:	8082                	ret

000000008000629c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000629c:	1101                	addi	sp,sp,-32
    8000629e:	ec06                	sd	ra,24(sp)
    800062a0:	e822                	sd	s0,16(sp)
    800062a2:	e426                	sd	s1,8(sp)
    800062a4:	1000                	addi	s0,sp,32
    800062a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800062a8:	ffffb097          	auipc	ra,0xffffb
    800062ac:	708080e7          	jalr	1800(ra) # 800019b0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800062b0:	00d5151b          	slliw	a0,a0,0xd
    800062b4:	0c2017b7          	lui	a5,0xc201
    800062b8:	97aa                	add	a5,a5,a0
    800062ba:	c3c4                	sw	s1,4(a5)
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6105                	addi	sp,sp,32
    800062c4:	8082                	ret

00000000800062c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800062c6:	1141                	addi	sp,sp,-16
    800062c8:	e406                	sd	ra,8(sp)
    800062ca:	e022                	sd	s0,0(sp)
    800062cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800062ce:	479d                	li	a5,7
    800062d0:	04a7cc63          	blt	a5,a0,80006328 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800062d4:	0001d797          	auipc	a5,0x1d
    800062d8:	a0c78793          	addi	a5,a5,-1524 # 80022ce0 <disk>
    800062dc:	97aa                	add	a5,a5,a0
    800062de:	0187c783          	lbu	a5,24(a5)
    800062e2:	ebb9                	bnez	a5,80006338 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800062e4:	00451613          	slli	a2,a0,0x4
    800062e8:	0001d797          	auipc	a5,0x1d
    800062ec:	9f878793          	addi	a5,a5,-1544 # 80022ce0 <disk>
    800062f0:	6394                	ld	a3,0(a5)
    800062f2:	96b2                	add	a3,a3,a2
    800062f4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800062f8:	6398                	ld	a4,0(a5)
    800062fa:	9732                	add	a4,a4,a2
    800062fc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006300:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006304:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006308:	953e                	add	a0,a0,a5
    8000630a:	4785                	li	a5,1
    8000630c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80006310:	0001d517          	auipc	a0,0x1d
    80006314:	9e850513          	addi	a0,a0,-1560 # 80022cf8 <disk+0x18>
    80006318:	ffffc097          	auipc	ra,0xffffc
    8000631c:	1c8080e7          	jalr	456(ra) # 800024e0 <wakeup>
}
    80006320:	60a2                	ld	ra,8(sp)
    80006322:	6402                	ld	s0,0(sp)
    80006324:	0141                	addi	sp,sp,16
    80006326:	8082                	ret
    panic("free_desc 1");
    80006328:	00002517          	auipc	a0,0x2
    8000632c:	4d850513          	addi	a0,a0,1240 # 80008800 <syscalls+0x318>
    80006330:	ffffa097          	auipc	ra,0xffffa
    80006334:	214080e7          	jalr	532(ra) # 80000544 <panic>
    panic("free_desc 2");
    80006338:	00002517          	auipc	a0,0x2
    8000633c:	4d850513          	addi	a0,a0,1240 # 80008810 <syscalls+0x328>
    80006340:	ffffa097          	auipc	ra,0xffffa
    80006344:	204080e7          	jalr	516(ra) # 80000544 <panic>

0000000080006348 <virtio_disk_init>:
{
    80006348:	1101                	addi	sp,sp,-32
    8000634a:	ec06                	sd	ra,24(sp)
    8000634c:	e822                	sd	s0,16(sp)
    8000634e:	e426                	sd	s1,8(sp)
    80006350:	e04a                	sd	s2,0(sp)
    80006352:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006354:	00002597          	auipc	a1,0x2
    80006358:	4cc58593          	addi	a1,a1,1228 # 80008820 <syscalls+0x338>
    8000635c:	0001d517          	auipc	a0,0x1d
    80006360:	aac50513          	addi	a0,a0,-1364 # 80022e08 <disk+0x128>
    80006364:	ffffa097          	auipc	ra,0xffffa
    80006368:	7f6080e7          	jalr	2038(ra) # 80000b5a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000636c:	100017b7          	lui	a5,0x10001
    80006370:	4398                	lw	a4,0(a5)
    80006372:	2701                	sext.w	a4,a4
    80006374:	747277b7          	lui	a5,0x74727
    80006378:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000637c:	14f71e63          	bne	a4,a5,800064d8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006380:	100017b7          	lui	a5,0x10001
    80006384:	43dc                	lw	a5,4(a5)
    80006386:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006388:	4709                	li	a4,2
    8000638a:	14e79763          	bne	a5,a4,800064d8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000638e:	100017b7          	lui	a5,0x10001
    80006392:	479c                	lw	a5,8(a5)
    80006394:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006396:	14e79163          	bne	a5,a4,800064d8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000639a:	100017b7          	lui	a5,0x10001
    8000639e:	47d8                	lw	a4,12(a5)
    800063a0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800063a2:	554d47b7          	lui	a5,0x554d4
    800063a6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800063aa:	12f71763          	bne	a4,a5,800064d8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063ae:	100017b7          	lui	a5,0x10001
    800063b2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063b6:	4705                	li	a4,1
    800063b8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063ba:	470d                	li	a4,3
    800063bc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800063be:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800063c0:	c7ffe737          	lui	a4,0xc7ffe
    800063c4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb93f>
    800063c8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800063ca:	2701                	sext.w	a4,a4
    800063cc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063ce:	472d                	li	a4,11
    800063d0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800063d2:	0707a903          	lw	s2,112(a5)
    800063d6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800063d8:	00897793          	andi	a5,s2,8
    800063dc:	10078663          	beqz	a5,800064e8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800063e0:	100017b7          	lui	a5,0x10001
    800063e4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800063e8:	43fc                	lw	a5,68(a5)
    800063ea:	2781                	sext.w	a5,a5
    800063ec:	10079663          	bnez	a5,800064f8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800063f0:	100017b7          	lui	a5,0x10001
    800063f4:	5bdc                	lw	a5,52(a5)
    800063f6:	2781                	sext.w	a5,a5
  if(max == 0)
    800063f8:	10078863          	beqz	a5,80006508 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800063fc:	471d                	li	a4,7
    800063fe:	10f77d63          	bgeu	a4,a5,80006518 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80006402:	ffffa097          	auipc	ra,0xffffa
    80006406:	6f8080e7          	jalr	1784(ra) # 80000afa <kalloc>
    8000640a:	0001d497          	auipc	s1,0x1d
    8000640e:	8d648493          	addi	s1,s1,-1834 # 80022ce0 <disk>
    80006412:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006414:	ffffa097          	auipc	ra,0xffffa
    80006418:	6e6080e7          	jalr	1766(ra) # 80000afa <kalloc>
    8000641c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000641e:	ffffa097          	auipc	ra,0xffffa
    80006422:	6dc080e7          	jalr	1756(ra) # 80000afa <kalloc>
    80006426:	87aa                	mv	a5,a0
    80006428:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000642a:	6088                	ld	a0,0(s1)
    8000642c:	cd75                	beqz	a0,80006528 <virtio_disk_init+0x1e0>
    8000642e:	0001d717          	auipc	a4,0x1d
    80006432:	8ba73703          	ld	a4,-1862(a4) # 80022ce8 <disk+0x8>
    80006436:	cb6d                	beqz	a4,80006528 <virtio_disk_init+0x1e0>
    80006438:	cbe5                	beqz	a5,80006528 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000643a:	6605                	lui	a2,0x1
    8000643c:	4581                	li	a1,0
    8000643e:	ffffb097          	auipc	ra,0xffffb
    80006442:	8a8080e7          	jalr	-1880(ra) # 80000ce6 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006446:	0001d497          	auipc	s1,0x1d
    8000644a:	89a48493          	addi	s1,s1,-1894 # 80022ce0 <disk>
    8000644e:	6605                	lui	a2,0x1
    80006450:	4581                	li	a1,0
    80006452:	6488                	ld	a0,8(s1)
    80006454:	ffffb097          	auipc	ra,0xffffb
    80006458:	892080e7          	jalr	-1902(ra) # 80000ce6 <memset>
  memset(disk.used, 0, PGSIZE);
    8000645c:	6605                	lui	a2,0x1
    8000645e:	4581                	li	a1,0
    80006460:	6888                	ld	a0,16(s1)
    80006462:	ffffb097          	auipc	ra,0xffffb
    80006466:	884080e7          	jalr	-1916(ra) # 80000ce6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000646a:	100017b7          	lui	a5,0x10001
    8000646e:	4721                	li	a4,8
    80006470:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006472:	4098                	lw	a4,0(s1)
    80006474:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006478:	40d8                	lw	a4,4(s1)
    8000647a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000647e:	6498                	ld	a4,8(s1)
    80006480:	0007069b          	sext.w	a3,a4
    80006484:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006488:	9701                	srai	a4,a4,0x20
    8000648a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000648e:	6898                	ld	a4,16(s1)
    80006490:	0007069b          	sext.w	a3,a4
    80006494:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006498:	9701                	srai	a4,a4,0x20
    8000649a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000649e:	4685                	li	a3,1
    800064a0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800064a2:	4705                	li	a4,1
    800064a4:	00d48c23          	sb	a3,24(s1)
    800064a8:	00e48ca3          	sb	a4,25(s1)
    800064ac:	00e48d23          	sb	a4,26(s1)
    800064b0:	00e48da3          	sb	a4,27(s1)
    800064b4:	00e48e23          	sb	a4,28(s1)
    800064b8:	00e48ea3          	sb	a4,29(s1)
    800064bc:	00e48f23          	sb	a4,30(s1)
    800064c0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800064c4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800064c8:	0727a823          	sw	s2,112(a5)
}
    800064cc:	60e2                	ld	ra,24(sp)
    800064ce:	6442                	ld	s0,16(sp)
    800064d0:	64a2                	ld	s1,8(sp)
    800064d2:	6902                	ld	s2,0(sp)
    800064d4:	6105                	addi	sp,sp,32
    800064d6:	8082                	ret
    panic("could not find virtio disk");
    800064d8:	00002517          	auipc	a0,0x2
    800064dc:	35850513          	addi	a0,a0,856 # 80008830 <syscalls+0x348>
    800064e0:	ffffa097          	auipc	ra,0xffffa
    800064e4:	064080e7          	jalr	100(ra) # 80000544 <panic>
    panic("virtio disk FEATURES_OK unset");
    800064e8:	00002517          	auipc	a0,0x2
    800064ec:	36850513          	addi	a0,a0,872 # 80008850 <syscalls+0x368>
    800064f0:	ffffa097          	auipc	ra,0xffffa
    800064f4:	054080e7          	jalr	84(ra) # 80000544 <panic>
    panic("virtio disk should not be ready");
    800064f8:	00002517          	auipc	a0,0x2
    800064fc:	37850513          	addi	a0,a0,888 # 80008870 <syscalls+0x388>
    80006500:	ffffa097          	auipc	ra,0xffffa
    80006504:	044080e7          	jalr	68(ra) # 80000544 <panic>
    panic("virtio disk has no queue 0");
    80006508:	00002517          	auipc	a0,0x2
    8000650c:	38850513          	addi	a0,a0,904 # 80008890 <syscalls+0x3a8>
    80006510:	ffffa097          	auipc	ra,0xffffa
    80006514:	034080e7          	jalr	52(ra) # 80000544 <panic>
    panic("virtio disk max queue too short");
    80006518:	00002517          	auipc	a0,0x2
    8000651c:	39850513          	addi	a0,a0,920 # 800088b0 <syscalls+0x3c8>
    80006520:	ffffa097          	auipc	ra,0xffffa
    80006524:	024080e7          	jalr	36(ra) # 80000544 <panic>
    panic("virtio disk kalloc");
    80006528:	00002517          	auipc	a0,0x2
    8000652c:	3a850513          	addi	a0,a0,936 # 800088d0 <syscalls+0x3e8>
    80006530:	ffffa097          	auipc	ra,0xffffa
    80006534:	014080e7          	jalr	20(ra) # 80000544 <panic>

0000000080006538 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006538:	7159                	addi	sp,sp,-112
    8000653a:	f486                	sd	ra,104(sp)
    8000653c:	f0a2                	sd	s0,96(sp)
    8000653e:	eca6                	sd	s1,88(sp)
    80006540:	e8ca                	sd	s2,80(sp)
    80006542:	e4ce                	sd	s3,72(sp)
    80006544:	e0d2                	sd	s4,64(sp)
    80006546:	fc56                	sd	s5,56(sp)
    80006548:	f85a                	sd	s6,48(sp)
    8000654a:	f45e                	sd	s7,40(sp)
    8000654c:	f062                	sd	s8,32(sp)
    8000654e:	ec66                	sd	s9,24(sp)
    80006550:	e86a                	sd	s10,16(sp)
    80006552:	1880                	addi	s0,sp,112
    80006554:	892a                	mv	s2,a0
    80006556:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006558:	00c52c83          	lw	s9,12(a0)
    8000655c:	001c9c9b          	slliw	s9,s9,0x1
    80006560:	1c82                	slli	s9,s9,0x20
    80006562:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006566:	0001d517          	auipc	a0,0x1d
    8000656a:	8a250513          	addi	a0,a0,-1886 # 80022e08 <disk+0x128>
    8000656e:	ffffa097          	auipc	ra,0xffffa
    80006572:	67c080e7          	jalr	1660(ra) # 80000bea <acquire>
  for(int i = 0; i < 3; i++){
    80006576:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006578:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000657a:	0001cb17          	auipc	s6,0x1c
    8000657e:	766b0b13          	addi	s6,s6,1894 # 80022ce0 <disk>
  for(int i = 0; i < 3; i++){
    80006582:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80006584:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006586:	0001dc17          	auipc	s8,0x1d
    8000658a:	882c0c13          	addi	s8,s8,-1918 # 80022e08 <disk+0x128>
    8000658e:	a8b5                	j	8000660a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80006590:	00fb06b3          	add	a3,s6,a5
    80006594:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80006598:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000659a:	0207c563          	bltz	a5,800065c4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000659e:	2485                	addiw	s1,s1,1
    800065a0:	0711                	addi	a4,a4,4
    800065a2:	1f548a63          	beq	s1,s5,80006796 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800065a6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800065a8:	0001c697          	auipc	a3,0x1c
    800065ac:	73868693          	addi	a3,a3,1848 # 80022ce0 <disk>
    800065b0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800065b2:	0186c583          	lbu	a1,24(a3)
    800065b6:	fde9                	bnez	a1,80006590 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800065b8:	2785                	addiw	a5,a5,1
    800065ba:	0685                	addi	a3,a3,1
    800065bc:	ff779be3          	bne	a5,s7,800065b2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800065c0:	57fd                	li	a5,-1
    800065c2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800065c4:	02905a63          	blez	s1,800065f8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800065c8:	f9042503          	lw	a0,-112(s0)
    800065cc:	00000097          	auipc	ra,0x0
    800065d0:	cfa080e7          	jalr	-774(ra) # 800062c6 <free_desc>
      for(int j = 0; j < i; j++)
    800065d4:	4785                	li	a5,1
    800065d6:	0297d163          	bge	a5,s1,800065f8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800065da:	f9442503          	lw	a0,-108(s0)
    800065de:	00000097          	auipc	ra,0x0
    800065e2:	ce8080e7          	jalr	-792(ra) # 800062c6 <free_desc>
      for(int j = 0; j < i; j++)
    800065e6:	4789                	li	a5,2
    800065e8:	0097d863          	bge	a5,s1,800065f8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800065ec:	f9842503          	lw	a0,-104(s0)
    800065f0:	00000097          	auipc	ra,0x0
    800065f4:	cd6080e7          	jalr	-810(ra) # 800062c6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800065f8:	85e2                	mv	a1,s8
    800065fa:	0001c517          	auipc	a0,0x1c
    800065fe:	6fe50513          	addi	a0,a0,1790 # 80022cf8 <disk+0x18>
    80006602:	ffffc097          	auipc	ra,0xffffc
    80006606:	e7a080e7          	jalr	-390(ra) # 8000247c <sleep>
  for(int i = 0; i < 3; i++){
    8000660a:	f9040713          	addi	a4,s0,-112
    8000660e:	84ce                	mv	s1,s3
    80006610:	bf59                	j	800065a6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80006612:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80006616:	00479693          	slli	a3,a5,0x4
    8000661a:	0001c797          	auipc	a5,0x1c
    8000661e:	6c678793          	addi	a5,a5,1734 # 80022ce0 <disk>
    80006622:	97b6                	add	a5,a5,a3
    80006624:	4685                	li	a3,1
    80006626:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006628:	0001c597          	auipc	a1,0x1c
    8000662c:	6b858593          	addi	a1,a1,1720 # 80022ce0 <disk>
    80006630:	00a60793          	addi	a5,a2,10
    80006634:	0792                	slli	a5,a5,0x4
    80006636:	97ae                	add	a5,a5,a1
    80006638:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000663c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006640:	f6070693          	addi	a3,a4,-160
    80006644:	619c                	ld	a5,0(a1)
    80006646:	97b6                	add	a5,a5,a3
    80006648:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000664a:	6188                	ld	a0,0(a1)
    8000664c:	96aa                	add	a3,a3,a0
    8000664e:	47c1                	li	a5,16
    80006650:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006652:	4785                	li	a5,1
    80006654:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006658:	f9442783          	lw	a5,-108(s0)
    8000665c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006660:	0792                	slli	a5,a5,0x4
    80006662:	953e                	add	a0,a0,a5
    80006664:	05890693          	addi	a3,s2,88
    80006668:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000666a:	6188                	ld	a0,0(a1)
    8000666c:	97aa                	add	a5,a5,a0
    8000666e:	40000693          	li	a3,1024
    80006672:	c794                	sw	a3,8(a5)
  if(write)
    80006674:	100d0d63          	beqz	s10,8000678e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80006678:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000667c:	00c7d683          	lhu	a3,12(a5)
    80006680:	0016e693          	ori	a3,a3,1
    80006684:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80006688:	f9842583          	lw	a1,-104(s0)
    8000668c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006690:	0001c697          	auipc	a3,0x1c
    80006694:	65068693          	addi	a3,a3,1616 # 80022ce0 <disk>
    80006698:	00260793          	addi	a5,a2,2
    8000669c:	0792                	slli	a5,a5,0x4
    8000669e:	97b6                	add	a5,a5,a3
    800066a0:	587d                	li	a6,-1
    800066a2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800066a6:	0592                	slli	a1,a1,0x4
    800066a8:	952e                	add	a0,a0,a1
    800066aa:	f9070713          	addi	a4,a4,-112
    800066ae:	9736                	add	a4,a4,a3
    800066b0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800066b2:	6298                	ld	a4,0(a3)
    800066b4:	972e                	add	a4,a4,a1
    800066b6:	4585                	li	a1,1
    800066b8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800066ba:	4509                	li	a0,2
    800066bc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800066c0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800066c4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800066c8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800066cc:	6698                	ld	a4,8(a3)
    800066ce:	00275783          	lhu	a5,2(a4)
    800066d2:	8b9d                	andi	a5,a5,7
    800066d4:	0786                	slli	a5,a5,0x1
    800066d6:	97ba                	add	a5,a5,a4
    800066d8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800066dc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800066e0:	6698                	ld	a4,8(a3)
    800066e2:	00275783          	lhu	a5,2(a4)
    800066e6:	2785                	addiw	a5,a5,1
    800066e8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800066ec:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800066f0:	100017b7          	lui	a5,0x10001
    800066f4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800066f8:	00492703          	lw	a4,4(s2)
    800066fc:	4785                	li	a5,1
    800066fe:	02f71163          	bne	a4,a5,80006720 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80006702:	0001c997          	auipc	s3,0x1c
    80006706:	70698993          	addi	s3,s3,1798 # 80022e08 <disk+0x128>
  while(b->disk == 1) {
    8000670a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000670c:	85ce                	mv	a1,s3
    8000670e:	854a                	mv	a0,s2
    80006710:	ffffc097          	auipc	ra,0xffffc
    80006714:	d6c080e7          	jalr	-660(ra) # 8000247c <sleep>
  while(b->disk == 1) {
    80006718:	00492783          	lw	a5,4(s2)
    8000671c:	fe9788e3          	beq	a5,s1,8000670c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80006720:	f9042903          	lw	s2,-112(s0)
    80006724:	00290793          	addi	a5,s2,2
    80006728:	00479713          	slli	a4,a5,0x4
    8000672c:	0001c797          	auipc	a5,0x1c
    80006730:	5b478793          	addi	a5,a5,1460 # 80022ce0 <disk>
    80006734:	97ba                	add	a5,a5,a4
    80006736:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000673a:	0001c997          	auipc	s3,0x1c
    8000673e:	5a698993          	addi	s3,s3,1446 # 80022ce0 <disk>
    80006742:	00491713          	slli	a4,s2,0x4
    80006746:	0009b783          	ld	a5,0(s3)
    8000674a:	97ba                	add	a5,a5,a4
    8000674c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006750:	854a                	mv	a0,s2
    80006752:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006756:	00000097          	auipc	ra,0x0
    8000675a:	b70080e7          	jalr	-1168(ra) # 800062c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000675e:	8885                	andi	s1,s1,1
    80006760:	f0ed                	bnez	s1,80006742 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006762:	0001c517          	auipc	a0,0x1c
    80006766:	6a650513          	addi	a0,a0,1702 # 80022e08 <disk+0x128>
    8000676a:	ffffa097          	auipc	ra,0xffffa
    8000676e:	534080e7          	jalr	1332(ra) # 80000c9e <release>
}
    80006772:	70a6                	ld	ra,104(sp)
    80006774:	7406                	ld	s0,96(sp)
    80006776:	64e6                	ld	s1,88(sp)
    80006778:	6946                	ld	s2,80(sp)
    8000677a:	69a6                	ld	s3,72(sp)
    8000677c:	6a06                	ld	s4,64(sp)
    8000677e:	7ae2                	ld	s5,56(sp)
    80006780:	7b42                	ld	s6,48(sp)
    80006782:	7ba2                	ld	s7,40(sp)
    80006784:	7c02                	ld	s8,32(sp)
    80006786:	6ce2                	ld	s9,24(sp)
    80006788:	6d42                	ld	s10,16(sp)
    8000678a:	6165                	addi	sp,sp,112
    8000678c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000678e:	4689                	li	a3,2
    80006790:	00d79623          	sh	a3,12(a5)
    80006794:	b5e5                	j	8000667c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006796:	f9042603          	lw	a2,-112(s0)
    8000679a:	00a60713          	addi	a4,a2,10
    8000679e:	0712                	slli	a4,a4,0x4
    800067a0:	0001c517          	auipc	a0,0x1c
    800067a4:	54850513          	addi	a0,a0,1352 # 80022ce8 <disk+0x8>
    800067a8:	953a                	add	a0,a0,a4
  if(write)
    800067aa:	e60d14e3          	bnez	s10,80006612 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800067ae:	00a60793          	addi	a5,a2,10
    800067b2:	00479693          	slli	a3,a5,0x4
    800067b6:	0001c797          	auipc	a5,0x1c
    800067ba:	52a78793          	addi	a5,a5,1322 # 80022ce0 <disk>
    800067be:	97b6                	add	a5,a5,a3
    800067c0:	0007a423          	sw	zero,8(a5)
    800067c4:	b595                	j	80006628 <virtio_disk_rw+0xf0>

00000000800067c6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800067c6:	1101                	addi	sp,sp,-32
    800067c8:	ec06                	sd	ra,24(sp)
    800067ca:	e822                	sd	s0,16(sp)
    800067cc:	e426                	sd	s1,8(sp)
    800067ce:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800067d0:	0001c497          	auipc	s1,0x1c
    800067d4:	51048493          	addi	s1,s1,1296 # 80022ce0 <disk>
    800067d8:	0001c517          	auipc	a0,0x1c
    800067dc:	63050513          	addi	a0,a0,1584 # 80022e08 <disk+0x128>
    800067e0:	ffffa097          	auipc	ra,0xffffa
    800067e4:	40a080e7          	jalr	1034(ra) # 80000bea <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800067e8:	10001737          	lui	a4,0x10001
    800067ec:	533c                	lw	a5,96(a4)
    800067ee:	8b8d                	andi	a5,a5,3
    800067f0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800067f2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800067f6:	689c                	ld	a5,16(s1)
    800067f8:	0204d703          	lhu	a4,32(s1)
    800067fc:	0027d783          	lhu	a5,2(a5)
    80006800:	04f70863          	beq	a4,a5,80006850 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006804:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006808:	6898                	ld	a4,16(s1)
    8000680a:	0204d783          	lhu	a5,32(s1)
    8000680e:	8b9d                	andi	a5,a5,7
    80006810:	078e                	slli	a5,a5,0x3
    80006812:	97ba                	add	a5,a5,a4
    80006814:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006816:	00278713          	addi	a4,a5,2
    8000681a:	0712                	slli	a4,a4,0x4
    8000681c:	9726                	add	a4,a4,s1
    8000681e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006822:	e721                	bnez	a4,8000686a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006824:	0789                	addi	a5,a5,2
    80006826:	0792                	slli	a5,a5,0x4
    80006828:	97a6                	add	a5,a5,s1
    8000682a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000682c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006830:	ffffc097          	auipc	ra,0xffffc
    80006834:	cb0080e7          	jalr	-848(ra) # 800024e0 <wakeup>

    disk.used_idx += 1;
    80006838:	0204d783          	lhu	a5,32(s1)
    8000683c:	2785                	addiw	a5,a5,1
    8000683e:	17c2                	slli	a5,a5,0x30
    80006840:	93c1                	srli	a5,a5,0x30
    80006842:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006846:	6898                	ld	a4,16(s1)
    80006848:	00275703          	lhu	a4,2(a4)
    8000684c:	faf71ce3          	bne	a4,a5,80006804 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006850:	0001c517          	auipc	a0,0x1c
    80006854:	5b850513          	addi	a0,a0,1464 # 80022e08 <disk+0x128>
    80006858:	ffffa097          	auipc	ra,0xffffa
    8000685c:	446080e7          	jalr	1094(ra) # 80000c9e <release>
}
    80006860:	60e2                	ld	ra,24(sp)
    80006862:	6442                	ld	s0,16(sp)
    80006864:	64a2                	ld	s1,8(sp)
    80006866:	6105                	addi	sp,sp,32
    80006868:	8082                	ret
      panic("virtio_disk_intr status");
    8000686a:	00002517          	auipc	a0,0x2
    8000686e:	07e50513          	addi	a0,a0,126 # 800088e8 <syscalls+0x400>
    80006872:	ffffa097          	auipc	ra,0xffffa
    80006876:	cd2080e7          	jalr	-814(ra) # 80000544 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
