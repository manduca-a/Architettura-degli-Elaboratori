.section .rodata
fmt: .asciz "%d\n"
.align 2

.macro print
    adr x0, fmt
    mov w1, w19
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    mov w19, #0
    loop:
        cmp w19, #10
        bge endloop

        print

        add w19, w19, #1
        b loop
    endloop:

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
