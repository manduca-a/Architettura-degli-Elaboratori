.section .rodata
fmt_x: .asciz "x: "
fmt_y: .asciz "y: "
fmt_scan: .asciz "%d"
fmt_sum: .asciz "the sum is %d\n"
fmt_diff: .asciz "the difference is %d\n"
.align 2

.data
x: .word 0
y: .word 0
sum: .word 0
diff: .word 0

.macro scan fmt var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

.macro print fmt var
    adr x0, \fmt
    adr x2, \var
    ldr w1, [x2]
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    scan fmt_x, x
    scan fmt_y, y

    // load x and y into w3 and w4
    adr x1, x
    adr x2, y
    ldr w3, [x1]
    ldr w4, [x2]
    
    // store w3 + w4 into sum
    add w5, w3, w4
    adr x1, sum
    str w5, [x1]

    // store w3 - w4 into diff
    sub w5, w3, w4
    adr x1, diff
    str w5, [x1]

    print fmt_sum, sum
    print fmt_diff, diff

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
