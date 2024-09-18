.section .rodata
fmt_n: .asciz "n: "
fmt_arr: .asciz "arr[%d]: "
fmt_sum: .asciz "sum = %d\n"
fmt_scan: .asciz "%d"
.align 2

.macro bytes_for_array res size
    mov \res, \size, lsl #2
    add \res, \res, #15
    and \res, \res, #0xFFFFFFFFFFFFFFF0
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
        ldr w20, [sp]
    add sp, sp, #16

    bytes_for_array w0, w20
    sub sp, sp, w0

        mov w19, #0
        read_loop:
            cmp w19, w20
            bge end_read_loop

            adr x0, fmt_arr
            mov w1, w19
            bl printf

            adr x0, fmt_scan
            add x1, sp, w19, lsl #2
            bl scanf

            add w19, w19, #1
            b read_loop
        end_read_loop:

        mov w1, #0
        mov w19, #0
        sum_loop:
            cmp w19, w20
            bge end_sum_loop

            ldr w0, [sp, x19, lsl #2]
            add w1, w1, w0

            add w19, w19, #1
            b sum_loop
        end_sum_loop:

        adr x0, fmt_sum
        bl printf

    bytes_for_array w0, w20
    add sp, sp, w0

    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
