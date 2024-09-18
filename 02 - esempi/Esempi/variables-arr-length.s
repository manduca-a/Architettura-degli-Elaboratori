.global main

.data
i: .word 0
j: .word 1
fmt: .asciz "Hello\n"
ch: .byte 'A', 'B', 0
.align 2
arr: .word 16, 16*2, 16*3, 16*4, 16*5
.equ arr_size, (. - arr) / 4
