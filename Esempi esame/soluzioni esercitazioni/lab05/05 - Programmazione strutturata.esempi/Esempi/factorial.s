.section .rodata
fmt_n: .asciz "n: "
fmt_res: .asciz "%d! = %d\n"
fmt_scan: .asciz "%d"
.align 2


.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!

    adr x0, fmt_n
    bl printf

    sub sp, sp, #4
        adr x0, fmt_scan
        mov x1, sp
        bl scanf
        ldr w19, [sp]
    add sp, sp, #4

    mov w0, w19
    bl fact

    mov w2, w0
    adr x0, fmt_res
    mov w1, w19
    bl printf

    mov w0, #0
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)


.type fact, %function
fact:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-8]!

    cmp w0, #1
    bgt recursive_case

    base_case:
        mov w19, #1
        b end_fact

    recursive_case:
        mov w19, w0
        sub w0, w0, #1
        bl fact
        mul w19, w19, w0
    
    end_fact:
    mov w0, w19
    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16
    ret
    .size fact, (. - fact)
