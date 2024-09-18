.section .rodata
fmt_read: .asciz "Inserisci un numero positivo: "
fmt_scan: .asciz "%d"
fmt: .asciz "%d\n"
.align 2

.data
n: .word 0

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
    stp x19, x20, [sp, #-16]!

    scan fmt_read, n            //input  io do 10

    mov w19, #1                 //w19=1
    ldr w20, n                  //w20=10

    loop:
        add w19, w19, #1        //w19+=1 quindi nel primo caso  w19= 2
        cmp w19, w20            //compara w19+1 con 10
        bgt end                 //se w19+1>=w20 termina
        mov w0, w19             //w0=w19
        bl primo                //va alla funzione primo **
        cmp w0, #0
        beq loop                //se w0==0 ricomincia il loop
        adr x0, fmt
        mov w1, w19             //w1=w19
        bl printf               //stampalo
        b loop                  //ricomincia il loop
    end:

    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)

.type primo, %function
primo:                          //c **
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!

    mov w19, #1                 //w19=1
    cmp w0, w19                 
    ble numero_non_primo        //se w0<=w19 vai a numero non primo  #

    loop_primo_function:        //inizia il loop
        add w19, w19, #1        //incrementa w19 di 1
        cmp w19, w0             
        bge numero_primo        //se w19>=w0 vai a numero primo  !
        udiv w1, w0, w19        // 2/1      3/2     4/2     5/2     5/3     5/4
        msub w2, w1, w19, w0    //w0-(w1*w19)
        cmp w2, #0
        beq numero_non_primo    //se w2==0 vai a numero non primo
        b loop_primo_function   //ricomincia il loop

    numero_non_primo:           //#
        mov w0, #0              //w0=0
        b end_primo_function    //termina la funzione
    
    numero_primo:               // !
        mov w0, #1              //w0=1
    
    end_primo_function:

    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size primo, (. - primo)   
