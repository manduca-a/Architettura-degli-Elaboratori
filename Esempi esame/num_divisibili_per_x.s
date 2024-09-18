//sequenza da input con stampa per vedere se è divisibile

.section .rodata
fmt_n: .asciz "n: "
fmt_x: .asciz "x: "
fmt_scan: .asciz "%d"
fmt_stampa: .asciz "\tn: %d\n"
fmt_nonsono: .asciz "NON sono divisibili \n"
fmt_sono: .asciz "sono divisibili\n"
.align 2

.data
x: .word 0

.bss 
n: .skip 128                                                
tmp_int: .skip 8

.macro read_int prompt                          //macro per leggere gli interi da input
    adr x0, \prompt
    bl printf

    adr x0, fmt_scan
    adr x1, tmp_int
    bl scanf

    ldr x0, tmp_int
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    //stp x19, x20, [sp, #-16]!
    //str x21, [sp, #-16]!
    
    mov x19, #0
    mov x21, #4

    read_loop:

        read_int fmt_n                                            //legge l'input per scegliere un numero

        adr x9, n
        madd x10, x19, x21, x9
        str x0, [x10]

        add x19, x19, #1

        cmp x19, #10
        blt read_loop
        
    read_int fmt_x
    
    adr x9, x
    str x0,[x9]

    mov x19, #0
    mov x20, #0
    mov x21, #4
    
    ldr x11, x
    check:
        adr x9, n
        madd x10, x19, x21, x9
        ldr x22, [x10]
        
        udiv x23, x22, x11
        msub x24, x23, x11, x22
        cmp x24, #0
        beq divisibile

        add x19, x19, #1

        cmp x19, #10
        blt check
        b riscontro

        divisibile:
            mov x20, #1
      
        add x19, x19, #1

        cmp x19, #10
        blt check

    riscontro:
        cmp x20, #1
        beq falso

        vero:
            adr x0, fmt_nonsono
            bl printf
        b end_

        falso:
            adr x0, fmt_sono
            bl printf
        b end_

    end_:
    mov w0, #0
    //ldr x21, [sp], #16
    //ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
