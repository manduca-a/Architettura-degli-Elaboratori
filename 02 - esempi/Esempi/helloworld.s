.global main  // entry point of libc

.section .rodata
mesg:
    .asciz "Hello World\n"

.text  // short for .section .text
main:
    // print "Hello World\n"
    stp     x29, x30, [sp, #-16]!
    adr     x0, mesg
    bl      printf

    // return 0
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
