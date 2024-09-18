.section .rodata
// Per stampare i dati ottenuti potete utilizzare a vostra scelta, 
// delle singole format string oppure una format string complessiva come specificato di seguito

// Formattazione per stampare ogni valore uno per volta (la funzione printf lo recuperera' dal registro 1)
fmt_min: .asciz "Minimo: %d\n"
fmt_max: .asciz "Massimo: %d\n"
fmt_somma: .asciz "Somma: %d\n"
fmt_media: .asciz "Media: %d\n"

// Formattazione per stampare tutti i valori insieme (la funzione printf li recuperera' nell'ordine dai registri 1, 2, 3 e 4)
fmt: .asciz "Minimo: %d Massimo: %d Somma: %d Media: %d\n"
.align 2

.data
A: .word 13, 4, 5, 4, 1, 0, -3, 10
.equ A_size, (. - A) / 4

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    
    ldr x0, =A                      //carica l'array in x0
    ldp w4, w5, [x0], #8            //carica i primi due elementi in w4 e w5
    cmp w4, w5                      //confronta w4 e w5
    csel w1, w4, w5, lt             //metti in w1 il più piccolo dei due
    csel w2, w4, w5, gt             //metti in w2 il più grande dei due
    add w3, w4, w5                  //metti in w3 la somma dei due
    
    ldp w4, w5, [x0], #8            //carica i secondi due elementi in w4 e w5
    cmp w1, w4                      //confronta w1 e w4
    csel w1, w1, w4, lt             //metti in w1 il più piccolo dei due
    cmp w2, w4                      //confronta w2 e w4
    csel w2, w2, w4, gt             //metti in w2 il più grande dei due
    cmp w1, w5
    csel w1, w1, w5, lt
    cmp w2, w5
    csel w2, w2, w5, gt
    add w3, w3, w4
    add w3, w3, w5
    
    ldp w4, w5, [x0], #8
    cmp w1, w4
    csel w1, w1, w4, lt
    cmp w2, w4
    csel w2, w2, w4, gt
    cmp w1, w5
    csel w1, w1, w5, lt
    cmp w2, w5
    csel w2, w2, w5, gt
    add w3, w3, w4
    add w3, w3, w5

    ldp w4, w5, [x0], #8
    cmp w1, w4
    csel w1, w1, w4, lt
    cmp w2, w4
    csel w2, w2, w4, gt
    cmp w1, w5
    csel w1, w1, w5, lt
    cmp w2, w5
    csel w2, w2, w5, gt
    add w3, w3, w4
    add w3, w3, w5

    ldr w5, =A_size
    udiv w4, w3, w5

    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    