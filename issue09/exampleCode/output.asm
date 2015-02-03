00000001000015c0         push       rbp                                         ; XREF=__TFC12swift_weekly14ViewController11viewDidLoadfS0_FT_T_+111, -[_TtC12swift_weekly14ViewController viewDidLoad]+119
00000001000015c1         mov        rbp, rsp
00000001000015c4         push       r15
00000001000015c6         push       r14
00000001000015c8         push       r13
00000001000015ca         push       r12
00000001000015cc         push       rbx
00000001000015cd         sub        rsp, 0x28
00000001000015d1         mov        rax, qword [ds:__TWvdvC12swift_weekly14ViewController5arrayGSaPSs9AnyObject__] ; __TWvdvC12swift_weekly14ViewController5arrayGSaPSs9AnyObject__
00000001000015d8         mov        qword [ss:rbp+var_40], rax
00000001000015dc         mov        rbx, qword [ds:rdi+rax]
00000001000015e0         mov        r14, rdi
00000001000015e3         test       rbx, rbx
00000001000015e6         je         0x100001911

00000001000015ec         mov        al, byte [ds:rbx+0x19]
00000001000015ef         mov        r15, qword [ds:rbx+0x10]
00000001000015f3         test       al, al
00000001000015f5         je         0x10000163f

0000000100001607         mov        r12, rax
000000010000160a         test       r15, r15
000000010000160d         je         0x1000018ff

0000000100001623         mov        rsi, qword [ds:0x100018320]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
000000010000162a         mov        rdi, r15                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000162d         call       imp___stubs__objc_msgSend
0000000100001632         mov        rbx, rax
000000010000163d         jmp        0x100001665

000000010000164f         mov        r12, rax
0000000100001652         xor        ebx, ebx
0000000100001654         test       r15, r15
0000000100001657         je         0x100001665

0000000100001659         mov        rbx, qword [ds:r15+0x10]

000000010000166d         mov        qword [ss:rbp+var_48], rbx
0000000100001671         test       rbx, rbx
0000000100001674         js         0x100001911

000000010000167a         mov        rbx, r14
000000010000167d         je         0x1000018e9

0000000100001683         nop        qword [cs:rax+rax+0x0]

0000000100001690         mov        rax, qword [ss:rbp+var_40]                  ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+803
0000000100001694         mov        r13, qword [ds:rbx+rax]
0000000100001698         mov        rax, qword [ds:imp___got__swift_isaMask]    ; imp___got__swift_isaMask
000000010000169f         mov        rax, qword [ds:rax]
00000001000016a2         and        rax, qword [ds:rbx]
00000001000016a5         lea        rcx, qword [ds:_OBJC_CLASS_$__TtC12swift_weekly14ViewController] ; _OBJC_CLASS_$__TtC12swift_weekly14ViewController
00000001000016ac         cmp        rax, rcx
00000001000016af         mov        edi, 0x0
00000001000016b4         cmove      rdi, rbx
00000001000016b8         test       rdi, rdi
00000001000016bb         je         0x100001730

00000001000016cd         mov        r15, rax
00000001000016d0         test       r13, r13
00000001000016d3         je         0x100001911

00000001000016d9         mov        al, byte [ds:r13+0x19]
00000001000016dd         mov        r12, qword [ds:r13+0x10]
00000001000016e1         test       al, al
00000001000016e3         je         0x100001760

00000001000016ed         mov        r15, rax
00000001000016f0         test       r12, r12
00000001000016f3         je         0x1000018ff

0000000100001709         mov        rsi, qword [ds:0x100018320]                 ; @selector(count), argument "selector" for method imp___stubs__objc_msgSend
0000000100001710         mov        rdi, r12                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001713         call       imp___stubs__objc_msgSend
0000000100001718         mov        rbx, rax
0000000100001723         jmp        0x100001780
0000000100001725         nop        qword [cs:rax+rax+0x0]

0000000100001730         mov        r14, qword [ds:rax+0x48]                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+251
000000010000174c         mov        rdi, r13
000000010000174f         mov        rsi, rbx
0000000100001752         call       r14
0000000100001755         mov        r12, rax
0000000100001758         jmp        0x1000017a2
000000010000175a         nop        qword [ds:rax+rax+0x0]

0000000100001768         test       r12, r12
000000010000176b         je         0x10000177c

000000010000176d         mov        rbx, qword [ds:r12+0x10]
000000010000177a         jmp        0x100001780

000000010000177c         xor        ebx, ebx                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+427
000000010000177e         nop

0000000100001780         mov        eax, ebx                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+355, __TFC12swift_weekly14ViewController8example1fS0_FT_T_+442
0000000100001782         cmp        rbx, rax
0000000100001785         jne        0x100001911

000000010000178b         mov        edi, ebx                                    ; argument "upper_bound" for method imp___stubs__arc4random_uniform
000000010000178d         call       imp___stubs__arc4random_uniform
0000000100001792         mov        ebx, eax
000000010000179c         mov        r12d, ebx
000000010000179f         mov        rbx, r14

00000001000017a2         mov        rax, qword [ss:rbp+var_40]                  ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+408
00000001000017a6         mov        r15, qword [ds:rbx+rax]
00000001000017aa         mov        r13, rbx
00000001000017ad         test       r15, r15
00000001000017b0         je         0x100001911

00000001000017b6         mov        al, byte [ds:r15+0x19]
00000001000017ba         test       al, al
00000001000017bc         je         0x100001810

00000001000017d6         mov        rbx, rax
00000001000017d9         test       r12, r12
00000001000017dc         js         0x100001901

00000001000017ea         mov        rbx, rax
00000001000017ed         mov        rdi, r15
00000001000017f0         call       __TTSPSs9AnyObject____TFVSs12_ArrayBufferg5countSi
00000001000017f5         mov        r14, rax
0000000100001808         jmp        0x100001852
000000010000180a         nop        qword [ds:rax+rax+0x0]

0000000100001810         mov        rbx, qword [ds:r15+0x10]                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+508
000000010000182c         test       rbx, rbx
000000010000182f         je         0x100001911

0000000100001835         mov        r14, qword [ds:rbx+0x10]
0000000100001849         test       r12, r12
000000010000184c         js         0x100001911

0000000100001852         cmp        r12, r14                                    ; XREF=__TFC12swift_weekly14ViewController8example1fS0_FT_T_+584
0000000100001855         jge        0x100001911

000000010000185b         lea        rdi, qword [ss:rbp+var_30]
000000010000185f         mov        rsi, r12
0000000100001862         mov        rdx, r15
0000000100001865         call       __TTSPSs9AnyObject____TFVSs12_ArrayBufferg9subscriptFSiQ_
000000010000186a         mov        rbx, r13
0000000100001875         mov        r14, qword [ss:rbp+var_30]
0000000100001879         mov        qword [ss:rbp+var_38], r14
0000000100001885         lea        rdi, qword [ss:rbp+var_38]
0000000100001889         call       __TTSPSs9AnyObject__VSs7_StdoutS0_Ss16OutputStreamType___TFSs5printU_Ss16OutputStreamType__FTQ_RQ0__T_
00000001000018c6         mov        edi, 0xa                                    ; argument "c" for method imp___stubs__putchar
00000001000018cb         call       imp___stubs__putchar
00000001000018df         dec        qword [ss:rbp+var_48]
00000001000018e3         jne        0x100001690

00000001000018ec         add        rsp, 0x28
00000001000018f0         pop        rbx
00000001000018f1         pop        r12
00000001000018f3         pop        r13
00000001000018f5         pop        r14
00000001000018f7         pop        r15
00000001000018f9         pop        rbp