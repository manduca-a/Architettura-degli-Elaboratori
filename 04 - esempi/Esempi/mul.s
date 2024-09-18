.section .rodata
fmt_n: .asciz "Insert a non-negative number (negative to terminate): "
fmt_scan: .asciz "%d"
fmt_res: .asciz "The multiplication of all these numbers is %d.\n"
.align 2

.data
n: .word 0

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!


    mov w19, #1
    loop:
        adr x0, fmt_n
        bl printf

        adr x0, fmt_scan
        ldr x1, =n
        bl scanf

        ldr w0, n
        cmp w0, #0
        blt endloop

        mul w19, w19, w0

        b loop
    endloop:

    adr x0, fmt_res
    mov w1, w19
    bl printf


    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
