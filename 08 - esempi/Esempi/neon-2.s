.section .rodata
fmt: .asciz "%.2f is stored as 0x%016lx\n"
.align 3

.data
x: .double 1.234

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    adr x0, fmt
    ldr d0, x
    fmov x1, d0
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
