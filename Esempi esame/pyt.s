/* 
f( 0 o 1 ) = n
f( n > 1 ) = 2 * f( n - 1 ) - f( n - 2 ) // 2
*/

/*
Il programma
salva i risultati nell'array in modo che 
f(n>=2) vada nell'array per calcolare: 2 * f(n - 1) - f(n - 2) // 2
*/

.section .rodata
fmt_n: .asciz "n:"
fmt_scan: .asciz "%d"
fmt: .asciz "t(%d) = %d\n"

.data
	.equ dimensione, 8	//bit						//spazio per ognuno   
	.equ lunghezza, 50										//numero di elementi
.bss
	A: .skip dimensione * lunghezza								//array usato per salvare i risultati
	tmp_int: .skip 8

.macro read_int prompt                          //macro per leggere gli interi da input
    adr x0, \prompt
    bl printf

    adr x0, fmt_scan
    adr x1, tmp_int
    bl scanf

    ldr x0, tmp_int
.endm

.text
.global main
.type main, %function
main:
  stp x29, x30, [sp, #-16]!
  stp x19, x20, [sp, #-16]!

	mov x19, #0  	// contatore
	mov x20, #27 	// x20 costante 2       per le operazioni
	adr x21, A								//indirizzo array
	mov x22, #6
	mov x23, #7
	mov x24, #0

	read_int fmt_n

    mov x16, x0

     zero:
		mov x0, #6
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]
		b end

	uno:
		mov x0, #9
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]
		b rico

	due:
		mov x0, #2
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]
		b rico

  	mov x0, #0
  	ldp x19, x20, [sp], #16
  	ldp x29, x30, [sp], #16
  	ret
  	.size main, (. - main)
  
rico:
    sub x0, x0, #1								//x0 = n-1
    cmp x0, #3
    bge rico

    cmp x0, #0
	beq zero
	cmp x0, #1
	beq uno	
	cmp x0, #2
	beq due

    zero:
		mov x0, #6
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]
		b end

	uno:
		mov x0, #9
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]
		b rico

	due:
		mov x0, #2
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]
		b rico
end_rico:



.type  t, %function
t:
	cmp x0, #0
	beq zero
	cmp x0, #1
	beq uno	
	cmp x0, #2
	beq due	
	cmp x0, #3
	bge continua
	
	continua:
	
	csel x9, x9, x11, gt			
	csel x9, x9, x12, gt
	mov x0, x9								
	b salva

	zero:
		mov x0, #6
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]
		b end

	uno:
		mov x0, #9
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]
		b end

	due:
		mov x0, #2
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]
		b end

	salva:
		madd x10, x22, x19, x21										//x10 = indirizzo array + dimensione*contatore
		str x0, [x10]																		//metti all'indirizzo contenuto in x10 quello che è in x0
	
	end:
	ret															//return
	.size t, ( . - t )
	