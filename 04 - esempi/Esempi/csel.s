.section .rodata
fmt_n: .asciz "Insert a non-negative number (negative to terminate): "
fmt_scan: .asciz "%d"
fmt_max: .asciz "The maximum is %d.\n"
.align 2

.data
n: .word 0

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!


    mov w19, #0
    loop:
        adr x0, fmt_n
        bl printf

        adr x0, fmt_scan
        ldr x1, =n
        bl scanf

        ldr w0, n
        cmp w0, #0
        blt endloop

        cmp w0, w19
        csel w19, w0, w19, gt

        b loop
    endloop:

    adr x0, fmt_max
    mov w1, w19
    bl printf


    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
