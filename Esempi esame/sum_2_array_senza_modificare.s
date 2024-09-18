.section .rodata
fmt: .asciz "%d\n"
.align 2

.data
A: .word 1, 5, -3, 2
B: .word -4, 5, 34, 6

.macro print i
    adr x0, fmt
    ldr x3, =A                          //indirizzo di A
    //ldr x4, =B                          //indirizzo di B
    ldr w1, [x3, #\i * 4]               //elemento in posizione A[i]
    //ldr w2, [x4, #\i * 4]               //elemento in posizione B[i]
    //add w1, w1, w2                      //somma tra i due
    bl printf
.endm

.macro somma i
    ldr x3, =A                          //indirizzo di A
    ldr x4, =B                          //indirizzo di B
    ldr w5, [x3, #\i * 4]               //elemento in posizione A[i]
    ldr w6, [x4, #\i * 4]               //elemento in posizione B[i]
    add w1, w5, w6                      //somma tra i due
    adr x0, fmt
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    print 0
    print 1
    print 2
    print 3

    somma 0
    somma 1
    somma 2
    somma 3

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
