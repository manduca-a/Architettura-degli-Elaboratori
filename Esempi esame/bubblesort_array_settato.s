// bubble sort

.section .rodata
	fmt: .asciz "%d %d %d %d %d\n"
	
.data
	A: .word 5, 3, 4, 1, 2
	.equ max_index, 4
	
	.macro stampa
		adr x9, A
		adr x0, fmt
		ldp w1, w2, [x9]
		ldp w3, w4, [x9, #8]
		ldr w5, [x9, #16]
		bl printf
	.endm

.text
	.type main, %function
	.global main
	
	main:
		stp x29, x30, [sp, #-16]!
		stampa						// stampa l'array
		adr x9, A 					// il registro 9 conterrà l'indirizzo dell'array
		
	reset:
		mov x7, #0 					// il 7 sarà un contatore
		mov w10, #0					// il 10 sarà un flag che indica se ci sono stati scambi
	
	loop:
		ldr w0, [x9, x7, lsl #2 ]	// w0 = startarray + ( index * 4 )
		add x7, x7, #1				// cont += 1
		ldr w1, [x9, x7, lsl #2 ]	// w1 = startarray + ( index * 4 )
		cmp w0, w1					// if w0 > w1:
		bgt scambia					//	  	goto scambia
	    end_scambia:				//    	e torna qui
		
		cmp x7, max_index			// if cont < max_index
		blt loop					//		goto loop
		cbnz w10, reset				// else: if flag != 0: goto reset
		stampa						//		  else: stampa
		b end_main					//       	    goto end_main
	
	scambia:
		str w0, [x9, x7, lsl #2 ]	// salva w0 nella posizione successiva
		sub x7, x7, #1				// cont -= 1
		str w1, [x9, x7, lsl #2 ]	// salva w1 nella posizione precedente
		add x7, x7, #1				// riporta cont all'index corretto
		mov w10, #1					// segnala lo scambio
		b end_scambia				// return
	
	end_main:
		
		ldp x29, x30, [sp], #16
		mov w0, 0
		ret
		.size main, ( . - main )
	