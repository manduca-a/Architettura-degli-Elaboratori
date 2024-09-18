.section .rodata
fmt: .asciz "%d with remainder %d\n"
.align 2

a: .dword 100
b: .dword 8

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    ldr x3, a
    ldr x4, b

    udiv w1, w3, w4
    msub w2, w1, w4, w3

    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
