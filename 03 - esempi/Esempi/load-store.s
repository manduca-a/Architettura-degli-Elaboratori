.section .rodata
fmt: .asciz "n = %d\n"
.align 2

.data
n: .word 20

.macro print
    adr x0, fmt
    ldr w1, n
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    print
    
    ldr x1, n
    add x1, x1, #10
    ldr x2, =n
    str x1, [x2]
    print

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
