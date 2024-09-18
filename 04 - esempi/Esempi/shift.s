.section .rodata
fmt: .asciz "%d\n"
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

    mov x19, #1
    print
    lsl x19, x19, #1
    print
    lsl x19, x19, #1
    print
    lsl x19, x19, #1
    print
    lsl x19, x19, #1
    print

    lsr x19, x19, #1
    print
    lsr x19, x19, #1
    print
    lsr x19, x19, #1
    print
    lsr x19, x19, #1
    print

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
