.section .rodata
    fmt: .asciz "Inserisci due numeri separati da spazio\n"
    fmt_scan: .asciz "%d %d"
    fmt_space: .asciz " \n"
    fmt_print: .asciz "%d\t"

.data
    n: .word 0

.bss
    tmp_int: .skip 8
    tmp_int_2: .skip 8

.macro read_ prompt                          //macro per leggere gli interi da input
    adr x0, \prompt
    bl printf

	adr x0, fmt_scan
    adr x1, tmp_int
    adr x2, tmp_int_2
    bl scanf

    ldr x5, tmp_int
    ldr x19, tmp_int_2
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    read_ fmt

    add x5, x19, x5
    mov x1, x5
    adr x0, fmt_print
    bl printf

    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
  
