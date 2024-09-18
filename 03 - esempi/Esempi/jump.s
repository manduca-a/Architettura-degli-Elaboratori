.section .rodata
true_str: .asciz "true\n"
false_str: .asciz "false\n"

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!

    mov x0, #10
    cmp x0, #20
    blt true_case

    false_case:
        adr x0, false_str
        bl printf
        b endif
    true_case:
        adr x0, true_str
        bl printf
    endif:

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
