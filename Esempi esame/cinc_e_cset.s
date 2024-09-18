//cinc incrementa sempre di 1 
//cset eguaglia a 1 oèèure a 0 a seconda della condizione

.section .rodata
fmt: .asciz "%d %d\n"
.text
.global main
.type main, %function
main:
  stp x29, x30, [sp, #-16]!

  mov x1, #0 	// contatore

  mov x9, #8 	// semi nelle mele
  mov x10, #0 	// semi nelle banane
  mov x11, #400 	// semi nelle angurie
  
  cmp x9, x10			// compara mele e banane
  cinc x1, x1, gt		// se le mele hanno più semi, aumenta il contatore (qui va a 1)
  
  cmp x9, x11			// compara mele e angurie
  cinc x1, x1, gt		// se le mele hanno più semi, aumenta il contatore (qui resta a 1)
  
  cmp x10, #0			// compara le banane con zero
  cset x2, eq			// se è vero che le banane non hanno semi mette 1, else mette 0
  
  adr x0, fmt
  bl printf 

  mov x0, #0
  ldp x29, x30, [sp], #16
  ret
  .size main, (. - main)
  