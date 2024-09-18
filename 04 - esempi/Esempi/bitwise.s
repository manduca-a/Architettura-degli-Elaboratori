.section .rodata
fmt_x: .asciz "x: "
fmt_y: .asciz "y: "
fmt_scan: .asciz "%x"
fmt_print: .asciz "%08x\n"
.align 2

.data
x: .word 0
y: .word 0
x_and_y: .word 0
x_bic_y: .word 0
x_orr_y: .word 0
x_orn_y: .word 0
x_eor_y: .word 0
x_eon_y: .word 0
mvn_x: .word 0
mvn_y: .word 0

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
    
    and w5, w3, w4
    adr x1, x_and_y
    str w5, [x1]

    bic w5, w3, w4
    adr x1, x_bic_y
    str w5, [x1]

    orr w5, w3, w4
    adr x1, x_orr_y
    str w5, [x1]

    orn w5, w3, w4
    adr x1, x_orn_y
    str w5, [x1]

    eor w5, w3, w4
    adr x1, x_eor_y
    str w5, [x1]

    eon w5, w3, w4
    adr x1, x_eon_y
    str w5, [x1]

    mvn w5, w3
    adr x1, mvn_x
    str w5, [x1]

    mvn w5, w4
    adr x1, mvn_y
    str w5, [x1]

    print fmt_print, x_and_y
    print fmt_print, x_bic_y
    print fmt_print, x_orr_y
    print fmt_print, x_orn_y
    print fmt_print, x_eor_y
    print fmt_print, x_eon_y
    print fmt_print, mvn_x
    print fmt_print, mvn_y

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
