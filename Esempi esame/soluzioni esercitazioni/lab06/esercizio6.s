.section .rodata
fmt: .asciz "%d\n"
.align 2

.data
A: .word 1, 5, 4, 12
B: .word -4, 5, 10, 6

.macro print i
    adr x0, fmt
    ldr x2, =A
    ldr w1, [x2, #\i * 4]
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    ldr x0, =A
    ldr x1, =B
    
    ldr w2, [x0]
    ldr w3, [x1], #4
    add w2, w2, w3
    str w2, [x0], #4
    
    ldr w2, [x0]
    ldr w3, [x1], #4
    sub w2, w2, w3
    str w2, [x0], #4

    ldr w2, [x0]
    ldr w3, [x1], #4
    cmp w2, w3
    csel w2, w3, w2, lt
    str w2, [x0], #4

    ldr w2, [x0]
    ldr w3, [x1]
    cmp w2, w3
    cset w2, gt
    str w2, [x0]

    print 0
    print 1
    print 2
    print 3

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    