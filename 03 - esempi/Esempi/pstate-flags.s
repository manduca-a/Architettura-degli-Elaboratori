.section .rodata
fmt:
    .asciz "N = %d\tZ = %d\tC = %d\tV = %d\tn = %d\n"
    .align 2

.data
n:
    .word 0

.macro print
    adr x0, fmt
    cset w1, mi
    cset w2, eq
    cset w3, cs
    cset w4, vs
    ldr w5, n
    bl printf
.endm

.macro add_to_n value
    ldr x8, =[n]
    ldr w9, [x8]
    .if \value >= 0
        adds w9, w9, #\value
    .else
        subs w9, w9, #-\value
    .endif
    str w9, [x8]
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    add_to_n 2
    print
        
    add_to_n -1
    print

    add_to_n -1
    print

    add_to_n -1
    print

    ldr x8, =[n]
    mov w9, #0x7FFFFFFF
    str w9, [x8]
    add_to_n 1
    print

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

