0000000100003070  push       rbp                                         ; Objective C Implementation defined at 0x10000d518 (instance)
0000000100003071  mov        rbp, rsp
0000000100003074  push       r15
0000000100003076  push       r14
0000000100003078  push       r12
000000010000307a  push       rbx
000000010000307b  sub        rsp, 0x90
000000010000308a  lea        rbx, qword [ds:0x10000bb52]                 ; "Hello, World!"
0000000100003091  lea        rdi, qword [ss:rbp+var_48]                  ; argument #1 for method __TFSSg10startIndexVSS5Index
0000000100003095  mov        edx, 0xd                                    ; argument #3 for method __TFSSg10startIndexVSS5Index
000000010000309a  xor        ecx, ecx                                    ; argument #4 for method __TFSSg10startIndexVSS5Index
000000010000309c  mov        rsi, rbx                                    ; argument #2 for method __TFSSg10startIndexVSS5Index
000000010000309f  call       __TFSSg10startIndexVSS5Index
00000001000030a4  mov        rax, qword [ss:rbp+var_48]
00000001000030a8  mov        rcx, qword [ss:rbp+var_40]
00000001000030ac  movups     xmm0, xmmword [ss:rbp+var_38]
00000001000030b0  mov        rdx, qword [ss:rbp+var_28]
00000001000030b4  mov        qword [ss:rbp+var_70], rax
00000001000030b8  mov        qword [ss:rbp+var_68], rcx
00000001000030bc  movups     xmmword [ss:rbp+var_60], xmm0
00000001000030c0  mov        qword [ss:rbp+var_50], rdx
00000001000030c4  mov        qword [ss:rbp+var_A0], 0x4
00000001000030cf  mov        rcx, qword [ds:imp___got___TMdVSS5Index]    ; imp___got___TMdVSS5Index
00000001000030d6  add        rcx, 0x8
00000001000030da  lea        rdi, qword [ss:rbp+var_98]                  ; argument #1 for method __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
00000001000030e1  lea        rsi, qword [ss:rbp+var_70]                  ; argument #2 for method __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
00000001000030e5  lea        rdx, qword [ss:rbp+var_A0]                  ; argument #3 for method __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
00000001000030ec  mov        r8, rcx
00000001000030ef  call       __TTWVSS5IndexSs16ForwardIndexTypeSsFS0_oi2tgUS0__USs18_SignedIntegerType_Ss33_BuiltinIntegerLiteralConvertible___fMQPS0_FTS3_TVSs8_AdvanceQS3_8Distance__S3_
00000001000030f4  mov        rax, qword [ss:rbp+var_98]
00000001000030fb  mov        rsi, qword [ss:rbp+var_78]
00000001000030ff  add        rsi, rax
0000000100003102  jo         0x10000317b

0000000100003104  cmp        rsi, rax
0000000100003107  jl         0x10000317b

0000000100003109  test       rax, rax
000000010000310c  js         0x10000317b

000000010000310e  cmp        rsi, 0xd
0000000100003112  jg         0x10000317b

0000000100003114  sub        rsi, rax
0000000100003117  jo         0x10000317b

0000000100003119  test       rsi, rsi
000000010000311c  js         0x10000317b

000000010000311e  mov        r15, qword [ss:rbp+var_80]
0000000100003122  add        rbx, rax
0000000100003125  xor        edx, edx                                    ; argument #3 for method __TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_
0000000100003127  mov        rdi, rbx                                    ; argument #1 for method __TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_
000000010000312a  call       __TTSf4gs_d___TFVSs9CharacterCfMS_FSSS_
000000010000312f  mov        r12, rax
0000000100003132  mov        bl, dl
000000010000313c  mov        qword [ss:rbp+var_B0], r12
0000000100003143  and        bl, 0x1
0000000100003146  mov        byte [ss:rbp+var_A8], bl
000000010000314c  mov        rsi, qword [ds:imp___got___TMdVSs9Character] ; imp___got___TMdVSs9Character
0000000100003153  add        rsi, 0x8
0000000100003157  lea        rdi, qword [ss:rbp+var_B0]
000000010000315e  call       imp___stubs___TFSs7printlnU__FQ_T_
000000010000316b  add        rsp, 0x90
0000000100003172  pop        rbx
0000000100003173  pop        r12
0000000100003175  pop        r14
0000000100003177  pop        r15
0000000100003179  pop        rbp
000000010000317a  ret