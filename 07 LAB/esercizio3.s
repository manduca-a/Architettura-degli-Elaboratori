.section .rodata
fmt_saldo: .asciz "SALDO: %d\n"
.align 2

.data
saldo: .word 500
canone: .word 5
interesse: .word 2

.macro print
    adr x0, fmt_saldo
    ldr w1, saldo
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    //carichiamo i dati nei registri
    ldr w20, saldo
    ldr w21, canone
    ldr w22, interesse
    mov w23, #100

    print

    //iniziamo le operazioni
    sub w24, w20, w21       //500-5
    mul w25, w20,w22        //500*2
    udiv w25, w25, w23      //1000/100
    add w25, w25, w24       //10+495

    ////stampiamo il secondo mese
    ldr x1, =saldo
    str w25, [x1]
    print

    //iniziamo le operazioni
    sub w24, w25, w21       //505-5
    mul w21, w25, w22        //505*2
    udiv w26, w21, w23      //1010/100
    add w25, w26, w24       //10+500

    //stampo il terzo mese
    ldr x1, =saldo
    str w25, [x1]
    print

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    