.section .rodata
fmt: .asciz "%d\n"

.macro print n
    adr x0, fmt
    mov w1, \n
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    print #0b10000
    print #0x10
    print #020
    print #16

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
