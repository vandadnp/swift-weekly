0000000100001cb0   push       rbp                                         ; Objective C Implementation defined at 0x1000052a0 (instance)
0000000100001cb1   mov        rbp, rsp
0000000100001cb4   push       r14
0000000100001cb6   push       rbx
0000000100001cb7   sub        rsp, 0x20
0000000100001cbb   mov        rbx, rdi
0000000100001cbe   mov        rax, qword [ds:imp___got__swift_isaMask]    ; imp___got__swift_isaMask
0000000100001cc5   mov        rax, qword [ds:rax]
0000000100001cc8   and        rax, qword [ds:rbx]
0000000100001ccb   lea        rcx, qword [ds:_OBJC_CLASS_$__TtC12swift_weekly14ViewController] ; _OBJC_CLASS_$__TtC12swift_weekly14ViewController
0000000100001cd2   xor        edi, edi
0000000100001cd4   cmp        rax, rcx
0000000100001cd7   cmove      rdi, rbx
0000000100001cdb   test       rdi, rdi
0000000100001cde   je         0x100001cf3

0000000100001ce5   mov        edi, 0xffffffff                             ; argument "upper_bound" for method imp___stubs__arc4random_uniform
0000000100001cea   call       imp___stubs__arc4random_uniform
0000000100001cef   mov        eax, eax
0000000100001cf1   jmp        0x100001d0d

0000000100001cf3   mov        r14, qword [ds:rax+0x50]                    ; XREF=-[_TtC12swift_weekly14ViewController example2]+46
0000000100001d07   mov        rdi, rbx
0000000100001d0a   call       r14

0000000100001d0d   cmp        rax, 0x64                                   ; XREF=-[_TtC12swift_weekly14ViewController example2]+65
0000000100001d11   ja         0x100001d2c

0000000100001d13   mov        qword [ss:rbp+var_28], 0xabcdefa
0000000100001d1b   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
0000000100001d22   add        rsi, 0x8
0000000100001d26   lea        rdi, qword [ss:rbp+var_28]
0000000100001d2a   jmp        0x100001d66

0000000100001d2c   add        rax, 0xffffffffffffff9b                     ; XREF=-[_TtC12swift_weekly14ViewController example2]+97
0000000100001d30   cmp        rax, 0x63
0000000100001d34   ja         0x100001d4f

0000000100001d36   mov        qword [ss:rbp+var_20], 0xabcdefb
0000000100001d3e   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
0000000100001d45   add        rsi, 0x8
0000000100001d49   lea        rdi, qword [ss:rbp+var_20]
0000000100001d4d   jmp        0x100001d66

0000000100001d4f   mov        qword [ss:rbp+var_18], 0xabcdefc            ; XREF=-[_TtC12swift_weekly14ViewController example2]+132
0000000100001d57   mov        rsi, qword [ds:imp___got___TMdSi]           ; imp___got___TMdSi
0000000100001d5e   add        rsi, 0x8
0000000100001d62   lea        rdi, qword [ss:rbp+var_18]

0000000100001d66   call       imp___stubs___TFSs7printlnU__FQ_T_          ; XREF=-[_TtC12swift_weekly14ViewController example2]+122, -[_TtC12swift_weekly14ViewController example2]+157
0000000100001d73   add        rsp, 0x20
0000000100001d77   pop        rbx
0000000100001d78   pop        r14
0000000100001d7a   pop        rbp
0000000100001d7b   ret