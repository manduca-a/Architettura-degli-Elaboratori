.section .rodata
fmt:
    .asciz "a=%d, b=%d\n"

.macro mymacro a=0, b
    adr x0, fmt
    mov x1, \a
    mov x2, \b
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp     x29, x30, [sp, #-16]!
    mymacro b=20

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
