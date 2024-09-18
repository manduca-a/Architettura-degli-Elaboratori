.section .rodata
fmt: .asciz "%d * 2**%d = %d\n"
.align 2

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    mov w19, #19
    mov w20, #0
    loop:
        adr x0, fmt
        mov w1, w19
        mov w2, w20
        lsl w3, w19, w20
        bl printf
        
        add w20, w20, #1

        cmp w20, #10
        blt loop

    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
