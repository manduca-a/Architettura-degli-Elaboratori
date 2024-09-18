.section .rodata
fmt: .asciz "%d\n"
spazio: .asciz "\n"
.align 2

.data
A: .word 1, 5 , -3, 2
B: .word -4, 5, 34, 6

.macro print i
	adr x0, fmt
	ldr x2, =A
	ldr x1, [x2, #\i * 4]
	bl printf
.endm

.text
	.type main, %function
	.global main
	main:
		stp x29, x30, [sp, #-16]!
		str x19, [sp, #-16]!
		
		print 0
		print 1
		print 2
		print 3

		mov x7, #0
		mov x19, #4

		loop:
			ldr x2, =A				//indirizzoA
			ldr x3, =B				//indirizzoB
			madd x0, x7, x19, x2			//x0=indirizzoA+(x7*4)
			madd x1, x7, x19, x3			//x1=indirizzoB+(x7*4)
			
			ldr w4, [x0]								//contenuto a indirizzo x0
			ldr w5, [x1]								//contenuto a indirizzo x1
			
			add w6, w4, w5					//sommma dei due
			str w6, [x0]								//w6 in indirizzo contenuto in x0
			
			add x7, x7, #1						//x7+=1
			cmp x7, x19								//if x7<4
			blt loop									//vai a loop
		
		adr x0, spazio
		bl printf

		print 0
		print 1
		print 2
		print 3
		
		mov x0, #0
		ldr x19, [sp], #16
		ldp x29, x30, [sp], #16
		ret
		.size main, ( . - main )
		