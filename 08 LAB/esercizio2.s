.section .rodata
fmt_prompt: .asciz "Inserisci tre numeri maggiori di 1 (attento che non lo controllo!): "
fmt_scan: .asciz "%d %d %d"
fmt_si: .asciz "SI`\n"
fmt_no: .asciz "NO\n"

.data
a: .word 0
b: .word 0
c: .word 0


.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    //Main da realizzare

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)


.type divisibili, %function
divisibili:

    //Funzione da realizzare

    ret
    .size divisibili, (. - divisibili)
