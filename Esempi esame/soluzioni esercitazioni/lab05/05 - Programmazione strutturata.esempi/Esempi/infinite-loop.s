.section .rodata
fmt: .asciz "LOVING '80s (press ctrl+c to terminate)\n"
.align 2

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    loop:
        adr x0, fmt
        bl printf
        b loop

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
