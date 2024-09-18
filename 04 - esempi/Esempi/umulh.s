.section .rodata
fmt: .asciz "%016lx%016lx\n"
.align 2

a: .dword 0xffffffffffffffff
b: .dword 0x1000000

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    ldr x3, a
    ldr x4, b

    mul x2, x3, x4
    umulh x1, x3, x4

    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
