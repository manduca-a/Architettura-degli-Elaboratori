.section .rodata
fmt_int: .asciz "You typed %d\n"
fmt_str: .asciz "You typed %s\n"
fmt_double: .asciz "You typed %.2lf\n"

fmt_prompt_int: .asciz "Type number: "
fmt_prompt_str: .asciz "Type string: "
fmt_prompt_double: .asciz "Type a (non-integer) number: "

fmt_scan_int: .asciz "%d"
fmt_scan_str: .asciz "%s"
fmt_scan_double: .asciz "%lf"
.align 3

.bss
tmp_double: .skip 8
tmp_int: .skip 4
tmp_str: .skip 128

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!


    adr x0, fmt_prompt_int
    bl printf

    adr x0, fmt_scan_int
    adr x1, tmp_int
    bl scanf

    adr x0, fmt_int
    ldr x1, tmp_int
    bl printf

    
    adr x0, fmt_prompt_str
    bl printf

    adr x0, fmt_scan_str
    adr x1, tmp_str
    bl scanf

    adr x0, fmt_str
    adr x1, tmp_str
    bl printf


    adr x0, fmt_prompt_double
    bl printf

    adr x0, fmt_scan_double
    ldr x1, =tmp_double
    bl scanf
    
    adr x0, fmt_double
    ldr d0, tmp_double
    bl printf


    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
