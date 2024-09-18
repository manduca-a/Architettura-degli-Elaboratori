.section .rodata
fmt: .asciz "max = %d\n"
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
    // stp x29, x30, [sp, #-16]!

    cmp x0, x1
    csel x0, x0, x1, gt

    cmp x0, x2
    csel x0, x0, x2, gt

    // ldp x29, x30, [sp], #16
    ret
    .size max_among_3, (. - max_among_3)
