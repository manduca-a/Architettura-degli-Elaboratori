.section .rodata
fmt_a: .asciz "a: "
fmt_b: .asciz "b: "
fmt_c: .asciz "c: "
fmt_scan: .asciz "%d"
fmt_min: .asciz "min = %d\n"
.align 2

.bss
a: .word 0
b: .word 0
c: .word 0

.macro print min
    mov w1, \min
    adr x0, fmt_min
    bl printf
.endm

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

    scan fmt_a, a
    scan fmt_b, b
    scan fmt_c, c
    
    ldr w0, a
    ldr w1, b
    ldr w2, c

    if:
        cmp w0, w1
        bge elseif
        cmp w0, w2
        bge elseif
    then:
        print w0
        b endif
    elseif:
        cmp w1, w2
        bge else
    then2:
        print w1
        b endif
    else:
        print w2
    endif:

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
