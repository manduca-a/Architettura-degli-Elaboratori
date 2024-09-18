.section .rodata
fmt: .asciz "%x\n"
.align 2

.data
n: .word 0x10203040

.macro print
    adr x0, fmt
    ldr x1, n
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    print
    mov w0, #0
    ldr x1, =n
    strb w0, [x1, #1]
    print

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
