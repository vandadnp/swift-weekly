.align 4
.global _addMethod
_addMethod:
    sub	sp, sp, #16
    stp	x1, x0, [sp]
    ldp	x1, x0, [sp]
    add	x0, x0, x1
    add	sp, sp, #16
    ret
