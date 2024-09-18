.section .rodata
fmt: .asciz "%d\n"
fmt_num: .asciz "Inserisci numero: "
fmt_scan: .asciz "%d"
.align 2

.data
A: .word 7, 0, 3, 1

.bss
x: .word 0
y: .word 0

.macro print i
    adr x0, fmt
    ldr x2, =A
    ldr w1, [x2, #\i * 4]
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
    
    scan fmt_num, x

    ldr x0, =A
    ldr x2, =x
    ldr x3, [x2]
    
    ldr w1, [x0]
    add w1, w1, w3
    str w1, [x0], #4
    
    ldr w1, [x0]
    add w1, w1, w3
    str w1, [x0], #4
    
    ldr w1, [x0]
    add w1, w1, w3
    str w1, [x0], #4

    ldr w1, [x0]
    add w1, w1, w3
    str w1, [x0]

    print 0
    print 1
    print 2
    print 3

    scan fmt_num, y

    ldr x0, =A
    ldr x2, =y
    ldr x3, [x2]
    
    ldr w1, [x0]
    sub w1, w1, w3
    str w1, [x0], #4
    
    ldr w1, [x0]
    sub w1, w1, w3
    str w1, [x0], #4
    
    ldr w1, [x0]
    sub w1, w1, w3
    str w1, [x0], #4

    ldr w1, [x0]
    sub w1, w1, w3
    str w1, [x0]

    print 0
    print 1
    print 2
    print 3

    ldr x0, =A

    ldr w1, [x0]
    lsl w1, w1, #1
    str w1, [x0], #4
    
    ldr w1, [x0]
    lsl w1, w1, #1
    str w1, [x0], #4
    
    ldr w1, [x0]
    lsl w1, w1, #1
    str w1, [x0], #4

    ldr w1, [x0]
    lsl w1, w1, #1
    str w1, [x0]

    print 0
    print 1
    print 2
    print 3

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
    