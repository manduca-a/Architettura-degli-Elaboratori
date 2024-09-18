.section .rodata
fmt: .asciz "%lu * %lu = %lu * 2**64 + %lu\n"
.align 2

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    mov x1, #105
    lsl x1, x1, #40
    mov x2, #90
    lsl x2, x2, #24
    
    mov x3, #0  // res high
    mov x4, #0  // res low
    mov x5, #0  // multiplicand high
    mov x6, x1  // multiplicand low
    mov x7, x2  // multiplier
    loop:
        cmp x7, #0
        beq endloop

        tst x7, #1
        beq endif
        adds x4, x4, x6  // add multiplicand low to res low, and set carry bit
        adc x3, x3, x5   // add multiplicand high to res high, plus carry bit from previous add
        endif:

        tst x6, #(1 << 63)  // is there a 1 moving from multiplicand low to multiplicand high?
        lsl x6, x6, #1      // shift multiplicand low
        lsl x5, x5, #1      // shift multiplicand high
        cinc x5, x5, ne     // increment multiplicand high if there was a 1 in MSB(multiplicand low)

        lsr x7, x7, #1

        b loop
    endloop:

    adr x0, fmt
    bl printf

    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
