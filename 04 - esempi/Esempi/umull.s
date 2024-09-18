.section .rodata
fmt: .asciz "%016lx\n"
.align 2

a: .dword 0xfffffff
b: .dword 0x1000

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    ldr x3, a
    ldr x4, b

    umull x1, w3, w4

    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
