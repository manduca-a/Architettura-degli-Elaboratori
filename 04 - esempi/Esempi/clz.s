.section .rodata
fmt: .asciz "%08x has %d leading zeros\n"
.align 2

a: .dword 0xff

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    ldr x1, a
    clz w2, w1

    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
