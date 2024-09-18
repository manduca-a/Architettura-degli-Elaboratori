.section .rodata
fmt: .asciz "%d * %d = %d\n"
.align 2

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    mov w1, #105
    mov w2, #90
    
    mov w3, #0
    mov w4, w1
    mov w5, w2
    loop:
        cmp w5, #0
        beq endloop

        tst w5, #1
        beq endif
        add w3, w3, w4
        endif:

        lsl w4, w4, #1
        lsr w5, w5, #1

        b loop
    endloop:

    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
