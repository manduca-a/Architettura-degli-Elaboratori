.section .rodata
fmt_x: .asciz "Inserisci un numero: "
fmt_scan: .asciz "%d"
fmt_pari: .asciz "PARI\n"
fmt_dispari: .asciz "DISPARI\n"
.align 2

.bss
x: .word 0

.macro print fmt
    adr x0, \fmt
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

    scan fmt_x, x

    mov w2, #2
    ldr w0, x
    udiv w1, w0, w2
    msub w3, w1, w2, w0
    cmp w3, #0
    bne else
        print fmt_pari
        b endif  
    else:
        print fmt_dispari    
    endif:


    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
