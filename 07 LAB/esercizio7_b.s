.section .rodata
fmt_n: .asciz "Inserisci un numero (negativo per terminare): "
fmt_x: .asciz "Inserisci il numero per cui si vuole controllare la divisibilità: "
fmt_scan: .asciz "%d"
fmt_count: .asciz "I numeri divisibili sono: %d.\n"
.align 2

.bss
n: .word 0 //da utilizzare per memorizzare di volta in volta il numero letto
x: .word 0 //da utilizzare per memorizzare il numero X

.macro scan fmt var //da utilizzare per leggere un numero della sequenza oppure X
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

    scan fmt_x, x                   //prende x da input
    mov w19, #0                     //mette 0 in w19 per il loop
    ldr w20, x                      //mette x in w20

    loop:
        scan fmt_n, n               //prendi sequenza di n da input
        ldr w21, n                  //metti n in w21
        cmp w21, #0                 //confronta l'input con 0
        blt endloop                 //se è un numero negativo esce dal loop
        
        udiv w22, w21, w20          //divide n per x
        msub w23, w22, w20, w21     //n-((n/x)*x) se esce zero allora n è divisibile per x
        cmp w23, #0                 //confronta il risultato con 0
        bne else                    //se è diverso altrimenti:
            add w19, w19, #1        //incrementa w19 di 1
        else:
        endif:

        b loop
        
    endloop:

    adr x0, fmt_count
    mov w1, w19
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
