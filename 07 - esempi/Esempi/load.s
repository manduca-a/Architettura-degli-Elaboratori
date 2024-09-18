.section .rodata
fmt_student: .ascii "First name: %s\n"
             .ascii " Last name: %s\n"
             .ascii "     Class: %d\n"
             .asciz "     Grade: %d\n\n"
filename: .asciz "data.dat"
read_mode: .asciz "r"

.equ offset_student_first_name, 0
.equ offset_student_last_name, 30
.equ offset_student_class, 60
.equ offset_student_grade, 64
.equ size_student, 80

.bss
students: .skip size_student*3

.macro print index
    ldr x0, =students
    mov x1, size_student
    mov x2, \index
    madd x0, x1, x2, x0  // x0 = x0 + (x1 * x2)

    add x1, x0, offset_student_first_name
    add x2, x0, offset_student_last_name
    ldrb w3, [x0, offset_student_class]
    ldr x4, [x0, offset_student_grade]
    adr x0, fmt_student
    bl printf
.endm

.text
.type main, %function
.global main
main:
    stp x29, x30, [sp, #-16]!
    str x19, [sp, #-16]!

    adr x0, filename
    adr x1, read_mode
    bl fopen

    cmp x0, #0
    beq end

        mov x19, x0

        ldr x0, =students
        mov x1, size_student
        mov x2, #3
        mov x3, x19
        bl fread

        mov x0, x19
        bl fclose

        print 0
        print 1
        print 2

    end:

    mov w0, #0
    ldr x19, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size main, (. - main)
