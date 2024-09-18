.section .rodata
fmt_n: .asciz "n: "
fmt_res: .asciz "f(%d) = %d\n"
fmt_scan: .asciz "%d"
fmt: .asciz "%d\n"
.align 2

.macro print
    adr x0, fmt
    mov x1, #1
    bl printf
    mov w0, w19 
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
        bl scanf                        //legge 2
        ldr w19, [sp]
    add sp, sp, #16

    mov w20, #2
    mov w0, w19                         //lo mette in w0
    bl f                            //va a funzione

    mov w2, w0
    adr x0, fmt_res
    mov w1, w19
    bl printf

    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)


.type f, %function
f:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-16]!


    cmp w0, #1                                                  //if w0>1
    bgt recursive_case_2                                                  //vai a recursive

    base_case:
        mov w19, #1
        b end_f

    recursive_case:
        mov w19, w0                                             //w19 = w0
        sub w0, w0, #1                                          //w0-=1
        bl f                                        //ricorsione
        udiv w19, w20, w0
        b end_f

    recursive_case_2:
        mov w19, w0                                             //w19 = w0
        sub w0, w0, #1                                          //w0-=1
        bl f                                        //ricorsione
        mul w19, w20, w0
    
    end_f:
    mov w0, w19
    ldr x19, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size f, (. - f)
