.section .rodata
fmt: .asciz "max = %d\n\n"
fmt_trace: .asciz "compare %d and %d => max = %d\n"
.align 2

.macro max a b c
    mov x0, \a
    mov x1, \b
    mov x2, \c
    bl max_among_3

    mov x1, x0
    adr x0, fmt
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    max #10, #20, #30
    max #3, #2, #1
    max #10, #20, #10

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

.type max_among_3, %function
max_among_3:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    cmp x0, x1
    csel x19, x0, x1, gt
    mov x20, x2

    mov x2, x1
    mov x1, x0
    adr x0, fmt_trace
    mov x3, x19
    bl printf

    cmp x19, x20
    csel x19, x19, x20, gt

    adr x0, fmt_trace
    mov x1, x19
    mov x2, x20
    mov x3, x19
    bl printf

    mov x0, x19
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size max_among_3, (. - max_among_3)
