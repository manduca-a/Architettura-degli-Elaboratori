.section .rodata
fmt_n: .asciz "n: "
fmt_res: .asciz "%d\n"
fmt_scan: .asciz "%d"
fmt_double: .asciz "ris: %.1f\n"
fmt: .asciz "aaaa %.2f\n"
.align 2

.macro print_w19
mov w1, w19
adr x0, fmt_scan
bl printf
.endm

.macro print_w0
mov w1, w0
adr x0, fmt_res
bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    adr x0, fmt_n
    bl printf

    sub sp, sp, #16
        adr x0, fmt_scan
        mov x1, sp
        bl scanf
        ldr w19, [sp]
    add sp, sp, #16

    mov w0, w19
    mov w2, w19
    bl f

    mov w1, w0
    adr x0, fmt_double
    bl printf

    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)


.type fib, %function
f:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    str x21, [sp, #-16]!
    mov w8, #2
    fmov d8, #2

    cmp w0, #2
    bgt maggiori

    zero_uno_due:
        mov w19, w0
        ucvtf d19, w19
        b end_f

    maggiori:
        mov w19, w0
        sub w0, w0, #1
        bl f
        mul w19, w0, w8
        ucvtf d0, w19                                                  
        fmov d21, d0

        

        mov w1, w2
        sub w1, w1, #2
        
        mov w19, w1
        bl f
        ucvtf d19, w19
        fdiv d19, d19, d8
        fsub d19, d21, d19

    end_f:
    fmov d0, d19
    
    ldr x21, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size f, (. - f)
