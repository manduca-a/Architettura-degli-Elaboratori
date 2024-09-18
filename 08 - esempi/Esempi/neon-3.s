.section .rodata
fmt: .asciz "%.2f ~ %d\n"
.align 3

.data
x: .double 1.234

.macro print
    adr x0, fmt
    fcvtzs w1, d0
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    ldr d0, x
    print

    mov x1, #3
    scvtf d0, x1    
    print

    mov x1, #3
    scvtf d0, x1, #1
    print

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
