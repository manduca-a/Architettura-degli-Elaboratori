.section .rodata
fmt_read: .asciz "Inserisci un numero: "
fmt_scan: .asciz "%d"
fmt_print: .asciz "%d\n"
fmt_ok: .asciz "OK\n"

.align 2

.bss
a: .word 0
b: .word 0
c: .word 0

.macro print fmt
    adr x0, \fmt
    bl printf
.endm

.macro print_value fmt
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

    scan fmt_read, a
    scan fmt_read, b
    scan fmt_read, c

    ldr w2, a
    ldr w3, b
    ldr w4, c
    
    cmp w2, w3      //confronta primo con secondo
    mov w1, w2      //mette primo in w1
    beq else        //se non sono uguali vai avanti
    
    cmp w3, w4      //confronta secondo con terzo
    mov w1, w4      //mette primo in w1
    beq else        //se non sono uguali vai avanti

    cmp w2, w4      //confronta primo con terzo
    mov w1, w4      //mette primo in w1
    beq else        //se non sono uguali vai avanti
        print fmt_ok
        b endif        
    else:
        print_value fmt_print
    endif:

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
