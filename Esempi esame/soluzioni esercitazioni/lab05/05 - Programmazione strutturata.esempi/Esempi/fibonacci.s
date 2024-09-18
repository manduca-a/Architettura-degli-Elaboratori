.section .rodata
fmt_n: .asciz "n: "
fmt_res: .asciz "fib(%d) = %d\n"
fmt_scan: .asciz "%d"
.align 2


.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    adr x0, fmt_n
    bl printf

    sub sp, sp, #4
        adr x0, fmt_scan
        mov x1, sp
        bl scanf
        ldr w19, [sp]
    add sp, sp, #4

    mov w0, w19
    bl fib

    mov w2, w0
    adr x0, fmt_res
    mov w1, w19
    bl printf

    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)


.type fib, %function
fib:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!

    cmp w0, #1
    bgt recursive_case

    base_case:
        mov w19, w0
        b end_fib

    recursive_case:
        mov w19, w0
        sub w0, w0, #1
        bl fib

        mov w1, w0
        sub w0, w19, #2
        mov w19, w1
        bl fib
        add w19, w19, w0
    
    end_fib:
    mov w0, w19
    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size fib, (. - fib)
