.section .rodata
fmt_n: .asciz "Inserisci un numero positivo (per terminare negativo): "
fmt_scan: .asciz "%d"
fmt_count: .asciz "La somma di numeri pari è: %d.\n"
.align 2

.bss
n: .word 0 //da utilizzare per memorizzare di volta in volta il numero letto

.macro scan fmt var //da utilizzare per leggere un numero
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
    
    mov w19, #0
    mov w20, #2
    
    loop:
        scan fmt_n, n               //prendi n da input

        ldr w0, n                   //metti n in w0
        cmp w0, #0                  //confronta w0 con 0
        blt endloop                 //se è minore termina il loop

        udiv w1, w0, w20            //n diviso 2
        msub w2, w1, w20, w0        //n-((n/2)*2), sarebbe n-n quindi se è pari esce 0
        cmp w2, #0                  //confronta il risultato di sopra con 0
        bgt else                    //se non è più grande vai a add
            add w19, w19, #1           
        else:
        endif:
        b loop                      //ricomincia il loop
    endloop:

    adr x0, fmt_count
    mov w1, w19
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
