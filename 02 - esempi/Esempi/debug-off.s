.section .rodata
mesg:
    .asciz "Hello World\n"
dbg:
    .asciz "DEBUG active!\n"

.equ NDEBUG, 0

.text
.type main, %function
.global main
main:
    // print "Hello World\n"
    stp x29, x30, [sp, #-16]!
    adr x0, mesg
    bl printf

    .ifndef NDEBUG
        adr x0, dbg
        bl printf
    .endif

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
