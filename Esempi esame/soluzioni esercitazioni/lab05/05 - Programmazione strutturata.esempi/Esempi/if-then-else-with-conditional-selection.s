.section .rodata
fmt_x: .asciz "x: "
fmt_y: .asciz "y: "
fmt_scan: .asciz "%d"
fmt_ge: .asciz "%d is greater than or equal to %d\n"
fmt_lt: .asciz "%d is lesser than %d\n"
.align 2

.bss
x: .word 0
y: .word 0

.macro scan fmt var
    adr x0, \fmt
    bl printf

    adr x0, fmt_scan
    ldr x1, =\var
    bl scanf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    scan fmt_x, x
    scan fmt_y, y
    
    ldr w1, x
    ldr w2, y
    ldr x3, =fmt_ge
    ldr x4, =fmt_lt
    cmp w1, w2
    csel x0, x3, x4, ge
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
