.section .rodata
fmt_x: .asciz "Inserisci un numero: "
fmt_scan: .asciz "%d"
fmt_pari: .asciz "PARI\n"
fmt_dispari: .asciz "DISPARI\n"
.align 2

.bss
x: .word 0

.macro print fmt
    adr x0, \fmt
    bl printf
.endm

.macro scan fmt var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    scan fmt_x, x //x contiene il numero letto da input

    //Da continuare a partire da qui
    mov w20, #2                 //metto 2 in w20
    ldr w21, x                  //metto l'input in w21
    udiv w22, w21, w20          //divido e metto in w22 il numero input per 2
    msub w23, w22, w20, w21     //w21-(w22*w20), dovrebbe far 0 se è PARI
    cmp w23, #0                 //compara il risultato di msub con 0
    bne else                    //se è diverso va a stampare dispari altrimenti va a stampare pari
        print fmt_pari
        b endif
    else:
        print fmt_dispari
    endif:

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
