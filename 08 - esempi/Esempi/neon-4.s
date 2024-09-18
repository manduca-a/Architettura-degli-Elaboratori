.section .rodata
fmt: .asciz "%.2f\n"
.align 3

.data
x: .double 1.234
y: .double 1.34

.macro print
    
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    // find max among x and y, using an if: begin
    ldr d0, x
    ldr d1, y

    fcmp d0, d1
    bgt endif
    fmov d0, d1
    endif:

    adr x0, fmt
    bl printf
    // find max among x and y, using an if: end

    // find max among x and y, using a csel: begin
    ldr d0, x
    ldr d1, y

    fcmp d0, d1
    fcsel d0, d0, d1, ge

    adr x0, fmt
    bl printf
    // find max among x and y, using a csel: end

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
