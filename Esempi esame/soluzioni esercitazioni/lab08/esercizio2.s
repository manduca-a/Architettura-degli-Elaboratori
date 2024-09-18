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

    adr x0, fmt_prompt
    bl printf

    adr x0, fmt_scan
    ldr x1, =a
    ldr x2, =b
    ldr x3, =c
    bl scanf

    if:
        ldr w0, a
        ldr w1, c
        bl divisibili
        cmp w0, #1
        bne else

        ldr w0, b
        ldr w1, c
        bl divisibili
        cmp w0, #1
        bne else
    then:
        adr x0, fmt_si
        bl printf
        b end_if
    else:
        adr x0, fmt_no
        bl printf
    end_if:

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)


.type divisibili, %function
divisibili:
    udiv w2, w0, w1
    msub w0, w2, w1, w0

    mov w1, #1
    cmp w0, #0
    csel w0, w1, wzr, eq

    ret
    .size divisibili, (. - divisibili)
