.section .rodata
fmt: .asciz "%d\n"
.align 2

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    mov w19, #0
    b loop_cond
    loop:
        adr x0, fmt
        mov w1, w19
        bl printf
        
        add w19, w19, #1
        
        loop_cond:
            cmp w19, #10
            blt loop

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
