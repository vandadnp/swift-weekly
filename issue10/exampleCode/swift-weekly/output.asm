0000000100001b50   push       rbp                                         ; Objective C Implementation defined at 0x100005260 (instance)
0000000100001b51   mov        rbp, rsp
0000000100001b54   push       r15
0000000100001b56   push       r14
0000000100001b58   push       r12
0000000100001b5a   push       rbx
0000000100001b5b   sub        rsp, 0xc0
0000000100001b62   mov        r14, rdi
0000000100001b65   mov        r15d, 0xaaaaaaaa
0000000100001b70   lea        rsi, qword [ds:r15+0x11111111]
0000000100001b77   mov        edi, 0xaaaaaaaa
0000000100001b7c   call       imp___stubs___TFE12CoreGraphicsVSC7CGPointCfMS0_FT1xSi1ySi_S0_
0000000100001b81   movsd      xmmword [ss:rbp+var_C8], xmm0
0000000100001b89   movsd      xmmword [ss:rbp+var_D0], xmm1
0000000100001b91   mov        rbx, qword [ds:0x100005e40]                 ; @selector(view)
0000000100001ba0   mov        rdi, r14                                    ; argument "instance" for method imp___stubs__objc_msgSend
0000000100001ba3   mov        rsi, rbx                                    ; argument "selector" for method imp___stubs__objc_msgSend
0000000100001ba6   call       imp___stubs__objc_msgSend
0000000100001bb3   mov        rbx, rax
0000000100001bb6   test       rbx, rbx
0000000100001bb9   je         0x100001de4

0000000100001bbf   mov        rdx, qword [ds:0x100005e48]                 ; @selector(frame), argument "selector" for method imp___stubs__objc_msgSend_stret
0000000100001bc6   lea        rdi, qword [ss:rbp+var_40]                  ; argument "stret" for method imp___stubs__objc_msgSend_stret
0000000100001bca   mov        rsi, rbx                                    ; argument "instance" for method imp___stubs__objc_msgSend_stret
0000000100001bcd   call       imp___stubs__objc_msgSend_stret
0000000100001bd2   movsd      xmm0, qword [ss:rbp+var_30]
0000000100001bd7   movsd      xmmword [ss:rbp+var_D8], xmm0
0000000100001bdf   movsd      xmm0, qword [ss:rbp+var_28]
0000000100001be4   movsd      xmmword [ss:rbp+var_E0], xmm0
0000000100001bfc   mov        rax, 0x41a579bdf8000000
0000000100001c06   mov        qword [ss:rbp+var_48], rax
0000000100001c0a   movsd      xmm0, qword [ss:rbp+var_C8]
0000000100001c12   movsd      xmmword [ss:rbp+var_50], xmm0
0000000100001c17   mov        r12, qword [ds:imp___got___TWPV12CoreGraphics7CGFloatSs9EquatableS_] ; imp___got___TWPV12CoreGraphics7CGFloatSs9EquatableS_
0000000100001c1e   mov        rbx, qword [ds:imp___got___TMdV12CoreGraphics7CGFloat] ; imp___got___TMdV12CoreGraphics7CGFloat
0000000100001c25   add        rbx, 0x8
0000000100001c29   lea        rdi, qword [ss:rbp+var_48]
0000000100001c2d   lea        rsi, qword [ss:rbp+var_50]
0000000100001c31   mov        rdx, rbx
0000000100001c34   mov        rcx, rbx
0000000100001c37   call       qword [ds:r12]
0000000100001c3b   test       al, 0x1
0000000100001c3d   je         0x100001c98

0000000100001c3f   mov        qword [ss:rbp+var_B0], 0x0
0000000100001c4a   movsd      xmm0, qword [ss:rbp+var_D0]
0000000100001c52   movsd      xmmword [ss:rbp+var_B8], xmm0
0000000100001c5a   lea        rdi, qword [ss:rbp+var_B0]
0000000100001c61   lea        rsi, qword [ss:rbp+var_B8]
0000000100001c68   mov        rdx, rbx
0000000100001c6b   mov        rcx, rbx
0000000100001c6e   call       qword [ds:r12]
0000000100001c72   test       al, 0x1
0000000100001c74   je         0x100001c98

0000000100001c76   mov        qword [ss:rbp+var_C0], 0xabcdefc
0000000100001c81   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
0000000100001c88   add        rsi, 0x8
0000000100001c8c   lea        rdi, qword [ss:rbp+var_C0]
0000000100001c93   jmp        0x100001dc7

0000000100001c98   movsd      xmm0, qword [ss:rbp+var_D8]                 ; XREF=-[_TtC12swift_weekly14ViewController example1]+237, -[_TtC12swift_weekly14ViewController example1]+292
0000000100001ca0   movsd      xmmword [ss:rbp+var_58], xmm0
0000000100001ca5   movsd      xmm0, qword [ss:rbp+var_C8]
0000000100001cad   movsd      xmmword [ss:rbp+var_60], xmm0
0000000100001cb2   lea        rdi, qword [ss:rbp+var_58]
0000000100001cb6   lea        rsi, qword [ss:rbp+var_60]
0000000100001cba   mov        rdx, rbx
0000000100001cbd   mov        rcx, rbx
0000000100001cc0   call       qword [ds:r12]
0000000100001cc4   test       al, 0x1
0000000100001cc6   je         0x100001d27

0000000100001cc8   mov        rax, 0x41a579bdfc000000
0000000100001cd2   mov        qword [ss:rbp+var_98], rax
0000000100001cd9   movsd      xmm0, qword [ss:rbp+var_D0]
0000000100001ce1   movsd      xmmword [ss:rbp+var_A0], xmm0
0000000100001ce9   lea        rdi, qword [ss:rbp+var_98]
0000000100001cf0   lea        rsi, qword [ss:rbp+var_A0]
0000000100001cf7   mov        rdx, rbx
0000000100001cfa   mov        rcx, rbx
0000000100001cfd   call       qword [ds:r12]
0000000100001d01   test       al, 0x1
0000000100001d03   je         0x100001d27

0000000100001d05   mov        qword [ss:rbp+var_A8], 0xabcdefe
0000000100001d10   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
0000000100001d17   add        rsi, 0x8
0000000100001d1b   lea        rdi, qword [ss:rbp+var_A8]
0000000100001d22   jmp        0x100001dc7

0000000100001d27   mov        rax, 0x41a579bdfe000000                     ; XREF=-[_TtC12swift_weekly14ViewController example1]+374, -[_TtC12swift_weekly14ViewController example1]+435
0000000100001d31   mov        qword [ss:rbp+var_68], rax
0000000100001d35   movsd      xmm0, qword [ss:rbp+var_C8]
0000000100001d3d   movsd      xmmword [ss:rbp+var_70], xmm0
0000000100001d42   lea        rdi, qword [ss:rbp+var_68]
0000000100001d46   lea        rsi, qword [ss:rbp+var_70]
0000000100001d4a   mov        rdx, rbx
0000000100001d4d   mov        rcx, rbx
0000000100001d50   call       qword [ds:r12]
0000000100001d54   test       al, 0x1
0000000100001d56   je         0x100001dad

0000000100001d58   movsd      xmm0, qword [ss:rbp+var_E0]
0000000100001d60   movsd      xmmword [ss:rbp+var_80], xmm0
0000000100001d65   movsd      xmm0, qword [ss:rbp+var_D0]
0000000100001d6d   movsd      xmmword [ss:rbp+var_88], xmm0
0000000100001d75   lea        rdi, qword [ss:rbp+var_80]
0000000100001d79   lea        rsi, qword [ss:rbp+var_88]
0000000100001d80   mov        rdx, rbx
0000000100001d83   mov        rcx, rbx
0000000100001d86   call       qword [ds:r12]
0000000100001d8a   test       al, 0x1
0000000100001d8c   je         0x100001dad

0000000100001d8e   mov        qword [ss:rbp+var_90], 0xabcdeff
0000000100001d99   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
0000000100001da0   add        rsi, 0x8
0000000100001da4   lea        rdi, qword [ss:rbp+var_90]
0000000100001dab   jmp        0x100001dc7

0000000100001dad   add        r15, 0x55555555                             ; XREF=-[_TtC12swift_weekly14ViewController example1]+518, -[_TtC12swift_weekly14ViewController example1]+572
0000000100001db4   mov        qword [ss:rbp+var_78], r15
0000000100001db8   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
0000000100001dbf   add        rsi, 0x8
0000000100001dc3   lea        rdi, qword [ss:rbp+var_78]

0000000100001dc7   call       imp___stubs___TFSs7printlnU__FQ_T_          ; XREF=-[_TtC12swift_weekly14ViewController example1]+323, -[_TtC12swift_weekly14ViewController example1]+466, -[_TtC12swift_weekly14ViewController example1]+603
0000000100001dd4   add        rsp, 0xc0
0000000100001ddb   pop        rbx
0000000100001ddc   pop        r12
0000000100001dde   pop        r14
0000000100001de0   pop        r15
0000000100001de2   pop        rbp
0000000100001de3   ret