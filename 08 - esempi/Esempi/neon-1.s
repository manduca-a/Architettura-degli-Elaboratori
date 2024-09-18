.section .rodata
fmt: .asciz "%.2f\n"
.align 3

.data
x: .double 1.234

.macro print
    adr x0, fmt
    ldr d0, x
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    print

    fmov d0, 1.25
    ldr x0, =x
    str d0, [x0]
    
    print

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
