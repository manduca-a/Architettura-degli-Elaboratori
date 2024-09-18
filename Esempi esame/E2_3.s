//sequenza da input terminata da un numero negativo con stampa per vedere se è strettamente crescente

.section .rodata
fmt_n: .asciz "n: "
fmt_scan: .asciz "%d"
fmt_fail: .asciz "NO\n"
fmt_true: .asciz "OK\n"
fmt_ris: .asciz "%u"
.align 2

.data
n: .word 0
min: .word 0

.bss                                                 
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
    stp x19, x20, [sp, #-16]!
    
    mov x20, #1
    mov X21, #912
    ldr x9, =min

    read_int fmt_n                                            //legge l'input per scegliere un numero

    cmp x0, X21
    beq end_main_loop

    mov x19, x0
    cmp w19, #27
    bgt minimo

    main_loop:

        read_int fmt_n                                            //legge l'input per scegliere un numero

        mov x19, x0

        cmp w19, -912
        beq end_main_loop
        
        cmp x19, #27
        bgt check
        b main_loop
    check:
        ldr x9, min
        
        cmp x19, x9
        mov w11, w19 
        blt minimo

        b main_loop

    minimo:
        ldr x9, =min
        str w11, [x9]
        b main_loop

    end_main_loop:
        adr x0, fmt_ris
        ldr x1, minimo
        bl printf

    end_:
    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
