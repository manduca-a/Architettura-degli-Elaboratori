// bubble sort

.section .rodata
	fmt: .asciz "%d"
	fmt_: .asciz "%d\t"
	fmt_n: .asciz "n: "
	fmt_dim: .asciz "dimensione array: "
	fmt_scan: .asciz "%d"
	riga: .asciz "\n"	

.data
	.equ elementi, 10		//numero elementi
	.equ dimensione, 4			//4 byte per ogni elemento perchè uso registri...

.bss
	A: .skip elementi * dimensione							//array usato per salvare i risultati
	tmp_int: .skip 8

.macro read_int prompt                          //macro per leggere gli interi da input
    adr x0, \prompt
    bl printf

	adr x0, fmt
    adr x1, tmp_int
    bl scanf

    ldr x0, tmp_int
.endm

.macro stampa value
	adr x9, A
	mov x11, #4
	madd x10, \value, x11, x9
	ldr x1, [x10]
	adr x0, fmt_
	bl printf
.endm

/*.macro print_x20
	adr x0, fmt
	mov x1, x19
	bl printf
.endm*/

.text
.type main, %function
.global main

main:
	stp x29, x30, [sp, #-16]!
	stp x22, x21, [sp, #-16]!
	stp x19, x20, [sp, #-16]!

	mov x20, #0
	
	main_loop:
		cmp x20, elementi
		bge end_main_loop

		read_int fmt_n

		adr x9, A 					// il registro 9 conterrà l'indirizzo dell'array
		mov x21, #4
		madd x10, x21, x20, x9			//x9 + (x21*x20)

		str w0, [x10]

		add x20, x20, #1
		b main_loop

	end_main_loop:

	mov x20, #0
	
	print_loop:	
		cmp x20, elementi
		bge end_print_loop
		stampa x20					// stampa l'array
		add x20, x20, #1
		b print_loop
    end_print_loop:

	adr x0, riga
	bl printf
	
	adr x9, A 					// il registro 9 conterrà l'indirizzo dell'array
	b reset
	
	reset:
		mov x20, #0 					// il 7 sarà un contatore
		mov w10, #0					// il 10 sarà un flag che indica se ci sono stati scambi
	
	loop:
		ldr w0, [x9, x20, lsl #2]	// w0 = startarray + ( index * 4 )
		add x20, x20, #1				// cont += 1
		ldr w1, [x9, x20, lsl #2]	// w1 = startarray + ( index * 4 )
		cmp w0, w1					// if w0 > w1:
		bgt scambia					//	  	goto scambia
		resume:				//    	e torna qui
		
		cmp x20, #9			// if cont < max_index
		blt loop					//		goto loop
		cbnz w10, reset				// else: if flag != 0: goto reset
		mov x20, #0						//		  else: stampa
		b print_loop_2					//       	    goto end_main
	
	scambia:
		str w0, [x9, x20, lsl #2]	// salva w0 nella posizione successiva
		sub x20, x20, #1				// cont -= 1
		str w1, [x9, x20, lsl #2]	// salva w1 nella posizione precedente
		add x20, x20, #1				// riporta cont all'index corretto
		mov w10, #1					// segnala lo scambio
		b resume				// return
	
	print_loop_2:
			
			cmp x20, elementi
			bge end_main
			stampa x20					// stampa l'array
			add x20, x20, #1
			b print_loop_2

end_main:
	ldp x19, x20, [sp], #16
	ldp x22, x21, [sp], #16
	ldp x29, x30, [sp], #16
	mov w0, #0
	ret
	.size main, ( . - main )
