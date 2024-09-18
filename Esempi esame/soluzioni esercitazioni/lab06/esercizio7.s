.section .rodata
fmt: .asciz "%d\n"

.data
A: .byte 0b00100011, 0b00011011, 0b00001001, 0b11111111
B: .byte 0b00101011, 0b10010011, 0b00000001, 0b10000001

.macro print i
    adr x0, fmt
    ldr x2, =A
    ldrsb w1, [x2, #\i * 1]
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    ldr x0, =A
    ldr x1, =B
    
    ldrsb w2, [x0]
    ldrsb w3, [x1], #1
    and w2, w2, w3
    strb w2, [x0], #1
    
    ldrsb w2, [x0]
    ldrsb w3, [x1], #1
    orr w2, w2, w3
    strb w2, [x0], #1

    ldrsb w2, [x0]
    ldrsb w3, [x1], #1
    cmp w2, w3
    csinc w2, w2, w3, lt
    strb w2, [x0], #1

    ldrsb w2, [x0]
    ldrsb w3, [x1]
    and w4, w2, w3
    tst w4, 0b10000000
    csneg w2, w4, w4, mi 
    strb w2, [x0]

    print 0
    print 1
    print 2
    print 3

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    