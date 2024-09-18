.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    ldr x0, =0xdead
    ldr x0, =0x123456789abcdef0

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
