.section .rodata
fmt_str: .ascii "|%10s| allineamento a destra\n"
         .asciz "|%-10s| allineamento a sinistra\n"
fmt_int: .ascii "|%10d| allineamento a destra\n"
         .ascii "|%-10d| allineamento a sinistra\n"
         .asciz "|%010d| allineamento a destra con riempimento\n"
fmt_double: .ascii "|%8.2f| allineamento a destra\n"
            .ascii "|%-8.2f| allineamento a sinistra\n"
            .asciz "|%08.2f| allineamento a sinistra con riempimento\n"
foo: .asciz "foo"

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    adr x0, fmt_str
    adr x1, foo
    adr x2, foo
    bl printf

    adr x0, fmt_int
    mov x1, #123
    mov x2, #123
    mov x3, #123
    bl printf

    adr x0, fmt_double
    fmov d0, #.5
    fmov d1, #.5
    fmov d2, #.5
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
