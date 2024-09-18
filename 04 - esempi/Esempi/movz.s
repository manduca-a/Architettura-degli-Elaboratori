.section .rodata
fmt: .asciz "%018p\n"
.align 2

.macro print
    adr x0, fmt
    mov x1, x19
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    movz x19, #0xdead, lsl #48
    print
    movk x19, #0xbeef, lsl #32
    print
    movk x19, #0xbac1, lsl #16
    print
    movk x19, #0x0123
    print

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
