0000000100002380   push       rbp                                         ; Objective C Implementation defined at 0x100008418 (instance)
0000000100002381   mov        rbp, rsp
0000000100002384   push       r15
0000000100002386   push       r14
0000000100002388   push       r13
000000010000238a   push       r12
000000010000238c   push       rbx
000000010000238d   sub        rsp, 0x38
0000000100002391   mov        r15, rdi
0000000100002394   mov        r13, 0x7fffffffffffffff
000000010000239e   mov        rax, qword [ds:__TWvdvC12swift_weekly14ViewController4dictGVSs10DictionarySiSi_] ; __TWvdvC12swift_weekly14ViewController4dictGVSs10DictionarySiSi_
00000001000023a5   mov        rbx, qword [ds:r15+rax]
00000001000023a9   mov        rax, qword [ds:imp___got__swift_isaMask]    ; imp___got__swift_isaMask
00000001000023b0   mov        rax, qword [ds:rax]
00000001000023b3   and        rax, qword [ds:r15]
00000001000023b6   lea        rcx, qword [ds:_OBJC_CLASS_$__TtC12swift_weekly14ViewController] ; _OBJC_CLASS_$__TtC12swift_weekly14ViewController
00000001000023bd   xor        edx, edx
00000001000023bf   cmp        rax, rcx
00000001000023c2   cmove      rdx, r15
00000001000023c6   test       rdx, rdx
00000001000023c9   je         0x100002403

00000001000023db   test       rbx, rbx
00000001000023de   js         0x10000243b

00000001000023e0   mov        r14, qword [ds:rbx+0x18]
00000001000023f4   test       r14, r14
00000001000023f7   je         0x10000274f

00000001000023fd   mov        rdi, qword [ds:r14+0x18]
0000000100002401   jmp        0x100002466

0000000100002403   mov        r12, qword [ds:rax+0x50]                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+73
0000000100002417   test       rbx, rbx
000000010000241a   jns        0x1000024a8

0000000100002420   mov        r14, rbx
0000000100002423   and        r14, r13
0000000100002436   jmp        0x1000024c3

000000010000243b   mov        r14, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+94
000000010000243e   and        r14, r13
0000000100002441   mov        r12, qword [ds:0x100009080]                 ; @selector(count)
0000000100002458   mov        rdi, r14                                    ; argument "instance" for method imp___stubs__objc_msgSend
000000010000245b   mov        rsi, r12                                    ; argument "selector" for method imp___stubs__objc_msgSend
000000010000245e   call       imp___stubs__objc_msgSend
0000000100002463   mov        rdi, rax

0000000100002466   mov        eax, edi                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+129
0000000100002468   cmp        rdi, rax
000000010000246b   jne        0x10000274f

0000000100002471   call       imp___stubs__arc4random_uniform
0000000100002476   test       rbx, rbx
0000000100002479   mov        r12d, eax
000000010000247c   jns        0x10000248b

000000010000247e   mov        rdi, rbx
0000000100002489   jmp        0x10000249e

000000010000248b   mov        rax, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+252
000000010000248e   shr        rax, 0x3f
0000000100002492   test       al, al
0000000100002494   jne        0x10000249e

00000001000024a6   jmp        0x1000024cf

00000001000024a8   mov        rax, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+154
00000001000024ab   shr        rax, 0x3f
00000001000024af   test       al, al
00000001000024b1   jne        0x1000024c3


00000001000024c3   mov        rdi, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+182, __TToFC12swift_weekly14ViewController8example2fS0_FT_T_+305
00000001000024c6   mov        rsi, r15
00000001000024c9   call       r12
00000001000024cc   mov        r12, rax

00000001000024cf   test       rbx, rbx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+294
00000001000024d2   js         0x100002590

00000001000024d8   mov        qword [ss:rbp+var_58], r15
00000001000024dc   mov        r15, qword [ds:rbx+0x18]
00000001000024e0   test       r15, r15
00000001000024e3   je         0x10000274f

00000001000024e9   mov        qword [ss:rbp+var_50], rbx
00000001000024ed   mov        r13, qword [ds:r15+0x10]
00000001000024f1   test       r13, r13
00000001000024f4   js         0x10000274f

00000001000024fa   mov        rax, qword [ds:imp___got___swift_stdlib_HashingDetail_fixedSeedOverride] ; imp___got___swift_stdlib_HashingDetail_fixedSeedOverride
0000000100002501   mov        rax, qword [ds:rax]
0000000100002504   test       rax, rax
0000000100002507   mov        r14, 0xff51afd7ed558ccd
0000000100002511   cmovne     r14, rax
0000000100002515   mov        ebx, r12d
0000000100002528   mov        rdi, rax
000000010000252b   test       r13, r13
000000010000252e   je         0x10000274f

0000000100002534   mov        rax, r12
0000000100002537   shr        rax, 0x20
000000010000253b   lea        rcx, qword [ds:r14+rbx*8]
000000010000253f   xor        rcx, rax
0000000100002542   mov        rdx, 0x9ddfea08eb382d69
000000010000254c   imul       rcx, rdx
0000000100002550   mov        rsi, rcx
0000000100002553   shr        rsi, 0x2f
0000000100002557   xor        rcx, rax
000000010000255a   xor        rcx, rsi
000000010000255d   imul       rcx, rdx
0000000100002561   mov        rax, rcx
0000000100002564   shr        rax, 0x2f
0000000100002568   xor        rax, rcx
000000010000256b   imul       rax, rdx
000000010000256f   mov        rdx, r13
0000000100002572   sub        rdx, 0x1
0000000100002576   setb       cl
0000000100002579   test       r13, rdx
000000010000257c   je         0x10000267e

0000000100002582   xor        edx, edx
0000000100002584   div        r13
0000000100002587   mov        r14, qword [ss:rbp+var_50]
000000010000258b   jmp        0x100002689

0000000100002590   and        rbx, r13                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+338
0000000100002593   mov        qword [ss:rbp+var_30], r12
000000010000259f   mov        r13, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
00000001000025a6   add        r13, 0x8
00000001000025aa   lea        rdi, qword [ss:rbp+var_30]
00000001000025ae   mov        rsi, r13
00000001000025b1   call       imp___stubs__swift_bridgeNonVerbatimToObjectiveC
00000001000025b6   mov        r12, rax
00000001000025b9   test       r12, r12
00000001000025bc   je         0x10000274f

00000001000025c2   mov        r14, qword [ds:0x100009090]                 ; @selector(objectForKey:)
00000001000025d9   mov        rdi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend
00000001000025dc   mov        rsi, r14                                    ; argument "selector" for method imp___stubs__objc_msgSend
00000001000025df   mov        rdx, r12
00000001000025e2   call       imp___stubs__objc_msgSend
0000000100002606   test       r12, r12
0000000100002609   je         0x100002753

000000010000260f   mov        qword [ss:rbp+var_48], 0x0
0000000100002617   mov        byte [ss:rbp+var_40], 0x1
0000000100002623   lea        rdx, qword [ss:rbp+var_48]
0000000100002627   mov        rdi, r12
000000010000262a   mov        rsi, r13
000000010000262d   mov        rcx, r13
0000000100002630   call       imp___stubs__swift_bridgeNonVerbatimFromObjectiveC
0000000100002635   mov        r13, qword [ss:rbp+var_48]
0000000100002639   mov        r14b, byte [ss:rbp+var_40]
0000000100002645   movzx      eax, r14b
0000000100002649   cmp        eax, 0x1
000000010000264c   jne        0x100002657

000000010000264e   test       r13, r13
0000000100002651   je         0x10000274f

0000000100002670   test       r14b, r14b
0000000100002673   je         0x100002720

0000000100002679   jmp        0x100002751

000000010000267e   test       cl, cl                                      ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+508
0000000100002680   mov        r14, qword [ss:rbp+var_50]
0000000100002684   jne        0x1000026d7

0000000100002686   and        rdx, rax

0000000100002689   test       rdx, rdx                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+523
000000010000268c   js         0x1000026d7

000000010000268e   nop        

0000000100002690   cmp        rdx, r13                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+853
0000000100002693   jge        0x10000274f

0000000100002699   lea        rax, qword [ds:0x0+rdx*8]
00000001000026a1   lea        rsi, qword [ds:rax+rax*2]
00000001000026a5   mov        rcx, qword [ds:r15+rsi+0x28]
00000001000026aa   mov        rax, qword [ds:r15+rsi+0x30]
00000001000026af   mov        bl, byte [ds:r15+rsi+0x38]
00000001000026b4   test       bl, bl
00000001000026b6   jne        0x1000026d9

00000001000026b8   cmp        rcx, r12
00000001000026bb   je         0x1000026d9

00000001000026bd   inc        rdx
00000001000026c0   jo         0x10000274f

00000001000026c6   mov        r13, qword [ds:r15+0x10]
00000001000026ca   mov        rax, r13
00000001000026cd   dec        rax
00000001000026d0   jo         0x10000274f

00000001000026d2   and        rdx, rax
00000001000026d5   jns        0x100002690

00000001000026d7   ud2                                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+772, __TToFC12swift_weekly14ViewController8example2fS0_FT_T_+780

00000001000026d9   mov        r12b, 0x1                                   ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+822, __TToFC12swift_weekly14ViewController8example2fS0_FT_T_+827
00000001000026dc   xor        r13d, r13d
00000001000026df   test       bl, bl
00000001000026e1   jne        0x1000026ff

00000001000026e3   cmp        rdx, qword [ds:r15+0x10]
00000001000026e7   jge        0x10000274f

00000001000026e9   movzx      edx, byte [ds:r15+rsi+0x38]
00000001000026ef   cmp        edx, 0x1
00000001000026f2   jne        0x1000026f9

00000001000026f4   or         rcx, rax
00000001000026f7   je         0x10000274f

00000001000026f9   xor        r12d, r12d                                  ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+882
00000001000026fc   mov        r13, rax

00000001000026ff   mov        rbx, rdi                                    ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+865
0000000100002717   test       r12b, r12b
000000010000271a   mov        r15, qword [ss:rbp+var_58]
000000010000271e   jne        0x100002751

0000000100002720   mov        qword [ss:rbp+var_38], r13                  ; XREF=__TToFC12swift_weekly14ViewController8example2fS0_FT_T_+755
0000000100002724   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
000000010000272b   add        rsi, 0x8
000000010000272f   lea        rdi, qword [ss:rbp+var_38]
0000000100002733   call       imp___stubs___TFSs7printlnU__FQ_T_
0000000100002740   add        rsp, 0x38
0000000100002744   pop        rbx
0000000100002745   pop        r12
0000000100002747   pop        r13
0000000100002749   pop        r14
000000010000274b   pop        r15
000000010000274d   pop        rbp
000000010000274e   ret