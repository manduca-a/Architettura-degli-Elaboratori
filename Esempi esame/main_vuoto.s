.section .text
.global main
.type main, %function
main:
  stp x29, x30, [sp, #-16]!

  //body

  mov x0, #0
  ldp x29, x30, [sp], #16
  ret
  .size main, (. - main)
  
