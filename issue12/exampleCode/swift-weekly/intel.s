.globl _addMethod
_addMethod:
    pushq  %rbp
    movq   %rsp, %rbp
    movq   %rdi, -0x8(%rbp)
    movq   %rsi, -0x10(%rbp)
    movq   -0x8(%rbp), %rsi
    addq   -0x10(%rbp), %rsi
    movq   %rsi, %rax
    popq   %rbp
    retq
