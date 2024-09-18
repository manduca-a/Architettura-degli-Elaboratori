.section .rodata
    fmt: .asciz "Inserisci una stringa: "
    fmt_scan: .ascii "%s"

    fmt_str: .asciz "%s"
    fmt_space: .asciz " \n"
    fmt_print: .asciz "%s\t"

.data
    n: .word 0

.bss
    tmp_str: .skip 128
    n_str: .skip 128

.macro read_ prompt                          
    adr x0, \prompt
    bl printf

	adr x0, fmt_str
    adr x1, tmp_str
    bl scanf

    
.endm

//.macro inverti
//    ldr x3, =tmp_str
//    mov x19, #0
//
//	loop:
//
//        ldrb w4, [x19]
//        mov w1, w4
//        adr x0, fmt_str
//        bl printf
//        add x19, x19, #1
//
//    end_loop:
//.endm

//.macro print i
//    adr x0, fmt_print
//    ldr x2, =n
//    ldr x1, [x2]
//    bl printf
//.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    read_ fmt
    adr x0, fmt_str
    ldr x1, tmp_str
    bl printf

//
    //mov x1, x19
    //adr x0, fmt_str
    //bl printf

    //inverti
//
    //mov x1, x19
    //adr x0, fmt_print
    //bl printf
//
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
  
