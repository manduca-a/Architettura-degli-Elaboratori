.section .rodata
fmt_arrA: .asciz "A[%d]: "
fmt_arrB: .asciz "B[%d]: "
fmt_sum: .asciz "sum = %d\n"
fmt_scan: .asciz "%d"
.align 2

.equ n, 5

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!
    sub sp, sp, #(5 * 2 * 4)

    mov w19, #0
    read_loop:
        cmp w19, n
        bge end_read_loop

        adr x0, fmt_arrA
        mov w1, w19
        bl printf

        adr x0, fmt_scan
        add x1, sp, w19, lsl #2 
        bl scanf

        adr x0, fmt_arrB
        mov w1, w19
        bl printf

        adr x0, fmt_scan
        add w2, w19, n
        add x1, sp, w2, lsl #2 
        bl scanf

        add w19, w19, #1
        b read_loop
    end_read_loop:

    mov w1, #0
    mov w19, #0
    sum_loop:
        cmp w19, n
        bge end_sum_loop

        ldr w0, [sp, x19, lsl #2]
        add w1, w1, w0

        add w2, w19, n
        ldr w0, [sp, x2, lsl #2]
        add w1, w1, w0

        add w19, w19, #1
        b sum_loop
    end_sum_loop:

    adr x0, fmt_sum
    bl printf

    mov w0, #0
    add sp, sp, #(5 * 2 * 4)
    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
