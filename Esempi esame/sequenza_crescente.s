//sequenza da input terminata da un numero negativo con stampa per vedere se è strettamente crescente

.section .rodata
fmt_n: .asciz "n: "
fmt_scan: .asciz "%d"
fmt_fail: .asciz "NO\n"
fmt_true: .asciz "OK\n"
.align 2

.data
n: .word 0

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

.macro add_
    ldr x8, =n
    ldr w9, [x8]            //w9=n
    cmp x19, #0                             //cmp input con 0
    blt togli                                       //if < : vai a togli    else:
        adds w9, w9, w19                    //n = n + input
        b endtogli                              //vai a endtogli
    togli:
        subs w9, w9, w19                    //n = n - input
    endtogli:
    str w9, [x8]                //memorizza
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    //stp x19, x20, [sp, #-16]!
    
    mov x20, #1

    read_int fmt_n                                            //legge l'input per scegliere un numero
    mov x19, x0                         //x19=input

    add_
    
    ldr x8, =n
    ldr w25, [x8]
    
    add w25, w25, #1
    
    cmp w25, #1
    bmi end_main_loop
    sub w25, w25, #1

    main_loop:

        read_int fmt_n                                            //legge l'input per scegliere un numero

        mov x19, x0

        add w19, w19, #1

        cmp w19, #1
        bmi end_main_loop
        
    check:
        sub w19, w19, #1
        cmp w19, w25
        ble no_crescente

        add w19, w19, #1

        cmp w19, #1
        bmi end_main_loop

        sub w19, w19, #1

        mov w25, w19

        b main_loop

        no_crescente:
            mov x20, #0
        
        cmp w19, #1
        bmi end_main_loop

        mov w9, w19

        b main_loop

    end_main_loop:

        cmp x20, #0
        beq falso

        vero:
            adr x0, fmt_true
            bl printf
        b end_

        falso:
            adr x0, fmt_fail
            bl printf
        b end_

    end_:
    mov w0, #0
    //ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
