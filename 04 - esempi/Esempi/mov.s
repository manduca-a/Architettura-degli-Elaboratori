.section .rodata
fmt: .asciz "%018p\n"
.align 2

.macro print value
    adr x0, fmt
    mov x1, \value
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    print #0x1
    print #0x10
    print #0x1020
    // print #0x102030      THIS ONE GIVES ERROR
    print #0xffffff
    print #0xffff00
    print #0xffffff00
    print #0xffffffff00000000

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
