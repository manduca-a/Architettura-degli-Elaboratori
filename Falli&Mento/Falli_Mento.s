//
.section .rodata
filename: .asciz "Falli&Mento.dat"
read_mode: .asciz "r"
write_mode: .asciz "w"
fmt_menu_title:
    .ascii "                                  __________________________\n"
    .ascii "                                  |••     Falli&Mento®   ••|\n"
    .asciz "                                  ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\n"
fmt_menu_line:
    .asciz "----------------------------------------------------------------------------------------------------------\n"
fmt_menu_header:
    .asciz "| # Marca           Modello           Sistema Operativo           Archiviazione(GB)          Prezzo(€)   |\n"
fmt_menu_entry:
    .asciz "|%2d %-15s %-17s %-24s %16d GB  %15d €    |\n"
fmt_mex:
    .asciz "%s"
fmt_menu_ent:
    .asciz "%|-15s %-17s %-24s %16d GB  %15d €   |\n"
messaggio:
    .asciz "\n GRAZIE PER AVER SCELTO         ••     Falli&Mento®   ••         Buona vita! \n\n"
fmt_menu_options:
    .ascii "1: Aggiungi Smartphone\n"
    .ascii "2: Elimina Smartphone\n"
    .ascii "3: Calcola prezzo medio\n"
    .ascii "4: Calcola prezzo medio (double)\n"
    .ascii "5: Trova uno Smartphone per Archiviazione (maggiore di)\n"
    .ascii "6: Filtra in base al prezzo\n"
    .ascii "7: Trova il più economico (Ricorsivo)\n"
    .ascii "8: Cambia l'ordine di due prodotti\n"
    .asciz "0: Esci\n"
fmt_prezzo_medio: .asciz "Prezzo medio: %12d €\n"
fmt_prezzo_medio_double: .asciz "Prezzo medio: %12.2f €\n"
fmt_fail_save_data: .asciz "\nImpossibile salvere i dati.\n\n"
fmt_fail_Aggiungi_smartphone: .asciz "\nTroppi Smartphone in magazzino. Vedi di venderne qualcuno\n\n"
fmt_fail_calcola_prezzo_medio: .asciz "   Nessuno smartphone disponibile.\n"
fmt_scan_int: .asciz "%d"
fmt_scan_str: .asciz "%127s"
fmt_prompt_menu: .asciz "Digita "
fmt_prompt_marca: .asciz "MARCA: "
fmt_prompt_modello: .asciz "MODELLO(Inserisci un _ se ci sono più sigle): "
fmt_prompt_so: .asciz "SISTEMA OPERATIVO: "
fmt_prompt_archiviazione: .asciz "ARCHIVIAZIONE(GB): "
fmt_prompt_prezzo: .asciz "PREZZO(€): "
fmt_prompt_index: .asciz "# (fuori range per annullare): "
fmt_prompt_index_ar: .asciz "Inserisci il minimo di Archiviazione: "
fmt_prompt_filtro: .asciz "Inserisci il tuo Budget: "
fmt_a_capo: .asciz "\n"
fmt_menu_lines:
    .asciz "----------------------------------------------------------\n"
fmt_menu_headers:
    .asciz "|   Marca           Modello           Archiviazione(GB)  |\n"
fmt_menu_headers_:
    .asciz "|   Marca           Modello                  Prezzo (€)  |\n"
fmt_smartphone: .asciz "|%9s %17s %23d GB  |\n"
fmt_smartphones: .asciz "|%9s %17s %23d €   |\n"
fmt_linee:
    .asciz "------------------------------\n"
fmt_line:
    .asciz "------------------------------------\n"
fmt_smartphonee: .asciz "Il prezzo minore è %8d €\n"

.align 2                                                                //allineare la memoria di 2 byte

.data
n_smartphone: .word 0                                                 //dichiara n_smartphone di tipo word (conterrà al max 32bit)

.equ max_smartphone, 10                                               // nelle size dichiariamo quanto spazio riserviamo per le variabili
.equ size_smartphone_marca, 10
.equ size_smartphone_modello, 25
.equ size_smartphone_so, 12
.equ size_smartphone_archiviazione, 5
.equ size_smartphone_prezzo, 5
.equ offset_smartphone_marca, 0                                      // indicano il numero di bit da aggiungere ad un indirizzo base 
.equ offset_smartphone_modello, offset_smartphone_marca + size_smartphone_marca
.equ offset_smartphone_so, offset_smartphone_modello + size_smartphone_modello
.equ offset_smartphone_archiviazione, offset_smartphone_so + size_smartphone_so
.equ offset_smartphone_prezzo, offset_smartphone_archiviazione + size_smartphone_archiviazione
.equ smartphone_size_aligned, 80


.bss
tmp_str: .skip 128                                              //passa i dati statici per acquisire interi e stringhe   
tmp_int: .skip 8                                                //e gli riserva spazi di 128 bit per le str e 8 bit per gli int
smartphone: .skip smartphone_size_aligned * max_smartphone      //matrice di 80 colonne(<- smartphone_size_aligned) * 10 righe(<- max_smartphone)



.macro read_int prompt                          //macro per leggere gli interi serviti da input
    adr x0, \prompt
    bl printf

    adr x0, fmt_scan_int
    adr x1, tmp_int
    bl scanf

    ldr x0, tmp_int
.endm

.macro read_str prompt                          //macro per leggere le stringhe servite da input
    adr x0, \prompt
    bl printf

    adr x0, fmt_scan_str
    adr x1, tmp_str                                             //mette in tmp_str quello che legge
    bl scanf
.endm

.macro save_to item, offset, size                               //macro che serve per salvare un nuovo array di un telefono nella matrice 
    add x0, \item, \offset                                      //destinazione:       x20 con offset
    ldr x1, =tmp_str                                            //sorgente:           indirizzo di tmp_str per la stringa da copiare
    mov x2, \size                                               //dimensione:         di ciò che bisogna copiare
    bl strncpy                                                  //copia la stringa nella destinazione scelta

    add x0, \item, \offset + \size - 1
    strb wzr, [x0]                                              //memorizza, con unsigned byte, il valore del registro w31(wzr), nell'indirizzo contenuto in x0
                                                                //salva il l'indirizzo di x0 in wzr che è un registro speciale 
                                                                //che va ad occupare lo spazio che gli serve per la variabile
                                                                //e nello spazio rimanente ci mette degli zeri
.endm

.macro ricorsione
    stp x22, x23, [sp, #-16]!
    stp x21, x27, [sp, #-16]!                                     //utilizziamo stp per dichiarare i registri che non devono essere volatili
    
    ldr x21, n_smartphone                                         //carica in x21 il contenuto di n_smartphone

        cmp x21, #0                                               //con i cmp vediamo se il contenuto nel registro di x21, se è uguale a 0 darà errore
        beq error                                                 // se invece il contenuto è 1 stampa l'unico prezzo disponibile
        cmp x21, #1
        beq rico_errore
        adr x0, fmt_linee
        bl printf
        ldr x22, =smartphone                                     // carica l'indirizzo dell'array smartphone in x22
        add x22, x22, offset_smartphone_prezzo
        mov x23, x22
        add x23, x23, offset_smartphone_marca
        mov w27, #2
        bl rico
        mov w2, w26
        //ldr x1, [x23, offset_smartphone_prezzo]
        adr x0, fmt_smartphonee
        bl printf
        adr x0, fmt_linee
        bl printf
        b end_
        error:
            adr x0, fmt_line
            bl printf 
            adr x0,fmt_fail_calcola_prezzo_medio
            bl printf
            adr x0, fmt_line
            bl printf 
        rico_errore:
            ldr x22, =smartphone                                            //carica l'indirizzo dell'array in x22

            adr x0,fmt_menu_lines
            bl printf
            adr x0,fmt_menu_headers_
            bl printf
            adr x0,fmt_menu_lines
            bl printf
            adr x0, fmt_smartphones
            add x1, x22, offset_smartphone_marca
            add x2, x22, offset_smartphone_modello
            ldr x3, [x22, offset_smartphone_prezzo]                         //carica in x3 ciò che si trova all'indirizzo di x22+offset
            bl printf
            adr x0,fmt_menu_lines
            bl printf
        end_:
            
    ldp x21, x27, [sp], #16                                                 //deallochiamo dallo stack pointer per ripristinare i registri
    ldp x22, x23, [sp], #16
.endm

.macro print_w1
    adr x0, fmt_w4
    mov w1, w1
    bl printf
.endm

.text
.type main, %function
.global main
main:                                  //GESTIONE MENU E INTERAZIONE UTENTE
    stp x29, x30, [sp, #-16]!                                               //pre-indexed immediate offset 

    bl load_data                                                            //saltiamo all'etichetta per caricare dati

    main_loop:
        bl print_menu                                       
        read_int fmt_prompt_menu                                            //legge l'input per scegliere un opzione del menu
        
        cmp x0, #0                                                          // queste sono le varie opzioni del menu
        beq end_main_loop
        
        cmp x0, #1
        bne no_Aggiungi_smartphone
        bl Aggiungi_smartphone
        no_Aggiungi_smartphone:

        cmp x0, #2
        bne no_Elimina_smartphone
        bl Elimina_smartphone
        no_Elimina_smartphone:

        cmp x0, #3
        bne no_calcola_prezzo_medio
        bl calcola_prezzo_medio
        no_calcola_prezzo_medio:

        cmp x0, #4
        bne no_calcola_prezzo_medio_double
        bl calcola_prezzo_medio_double
        no_calcola_prezzo_medio_double:

        cmp x0, #5
        bne no_trova_smartphone_ar
        bl trova_smartphone_ar
        no_trova_smartphone_ar:

        cmp x0, #6
        bne no_filtro
        bl filtro
        no_filtro:

        cmp x0, #7
        bne no_rico
        ricorsione
        no_rico:

        cmp x0, #8
        bne no_cambia
        bl cambia
        no_cambia:

        b main_loop     
    end_main_loop:
    adr x0, messaggio
    bl printf 

    mov w0, #0
    ldp x29, x30, [sp], #16                                 //post_indexed immediate offset
    ret
    .size main, (. - main)                                  //Dichiara la lunghezza di un simbolo, in termini di byte


.type load_data, %function                      //GESTIONE INPUT/OUTPUT
load_data:
    stp x29, x30, [sp, #-16]!                               //utilizziamo stp per dichiarare i registri che non devono essere volatili
    str x19, [sp, #-8]!
    
    adr x0, filename                                        //assegnamo ad un registro il nome del file .dat ad un registro 
    adr x1, read_mode                                       //e accediamo in modalità di lettura
    bl fopen                                                //apertura del file

    cmp x0, #0                                              
    beq end_load_data

    mov x19, x0                                             //copia il nome del file in x19

    ldr x0, =n_smartphone                                   //indirizzo da cui leggere i dati
    mov x1, #4                                              //dimensione di ogni singlo dato in byte
    mov x2, #1                                              //il numero degli elementi da leggere
    mov x3, x19                                             //il puntatore al file restituito dalla funzione fopen
    bl fread                                                //salta all'etichetta che legge il contenuto del file

    ldr x0, =smartphone                                     //indirizzo da cui leggere i dati
    mov x1, smartphone_size_aligned                         //dimensione di ogni singlo dato in byte
    mov x2, max_smartphone                                  //prende tutti gli smartphone
    mov x3, x19                                             //il puntatore al file restituito dalla funzione fopen
    bl fread

    mov x0, x19
    bl fclose                                               //chiude il file dopo aver effettuato la lettura

    end_load_data:

    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16                                 //deallochiamo dallo stack pointer per ripristinare i registri
    ret
    .size load_data, (. - load_data)


.type save_data, %function                      //GESTIONE INPUT/OUTPUT
save_data:                                                             //etichetta per salvare i dati acquisiti
    stp x29, x30, [sp, #-16]!                                          //utilizziamo stp per dichiarare i registri che non devono essere volatili
    str x19, [sp, #-8]!
    
    adr x0, filename
    adr x1, write_mode
    bl fopen

    cmp x0, #0
    beq fail_save_data

        mov x19, x0

        ldr x0, =n_smartphone
        mov x1, #4
        mov x2, #1
        mov x3, x19
        bl fwrite

        ldr x0, =smartphone
        mov x1, smartphone_size_aligned
        mov x2, max_smartphone
        mov x3, x19
        bl fwrite

        mov x0, x19
        bl fclose

        b end_save_data

    fail_save_data:
        adr x0, fmt_fail_save_data
        bl printf

    end_save_data:

    ldr x19, [sp], #8
    ldp x29, x30, [sp], #16                                     //deallochiamo dallo stack pointer per ripristinare i registri
    ret
    .size save_data, (. - save_data)


.type print_menu, %function                                                 //ARRAY CON DATI E STAMPA
print_menu:
    stp x29, x30, [sp, #-16]!                                                       //utilizziamo stp per dichiarare i registri che non devono essere volatili
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!

    adr x0, fmt_menu_title
    bl printf

    adr x0, fmt_menu_line
    bl printf
    adr x0, fmt_menu_header
    bl printf
    adr x0, fmt_menu_line
    bl printf

    mov x19, #0
    ldr x20, n_smartphone
    ldr x21, =smartphone
    print_entries_loop:
        cmp x19, x20
        bge end_print_entries_loop

        adr x0, fmt_menu_entry
        add x1, x19, #1
        add x2, x21, offset_smartphone_marca
        add x3, x21, offset_smartphone_modello
        add x4, x21, offset_smartphone_so
        ldr x5, [x21, offset_smartphone_archiviazione]
        ldr x6, [x21, offset_smartphone_prezzo]
        bl printf

        add x19, x19, #1
        add x21, x21, smartphone_size_aligned
        b print_entries_loop
    end_print_entries_loop:

    adr x0, fmt_menu_line
    bl printf

    adr x0, fmt_menu_options
    bl printf

    ldp x21, x22, [sp], #16                                                  //deallochiamo dallo stack pointer per ripristinare i registri
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size print_menu, (. - print_menu)


.type Aggiungi_smartphone, %function                //AGGIUNTA ELEMENTO
Aggiungi_smartphone:
    stp x29, x30, [sp, #-16]!                                                //utilizziamo stp per dichiarare i registri che non devono essere volatili
    stp x19, x20, [sp, #-16]!
    
    ldr x19, n_smartphone                         //carica i dati dalla memoria, variabile n_smartphone, a x19
    ldr x20, =smartphone                          //carica in x20 l'indirizzo dell'array Smartphone
    mov x0, smartphone_size_aligned               //carica in x0 la dimensione di uno smartphone
    mul x0, x19, x0                               //righe della matrice (n_smartphone * dimensione)
    add x20, x20, x0                                                                    
    
    cmp x19, max_smartphone
    bge fail_Aggiungi_smartphone
        read_str fmt_prompt_marca
        save_to x20, offset_smartphone_marca, size_smartphone_marca                     //salva i dati di x20 in wzr stessa cosa sotto 
        
        read_str fmt_prompt_modello
        save_to x20, offset_smartphone_modello, size_smartphone_modello 

        read_str fmt_prompt_so
        save_to x20, offset_smartphone_so, size_smartphone_so

        read_int fmt_prompt_archiviazione
        str w0, [x20, offset_smartphone_archiviazione]

        read_int fmt_prompt_prezzo
        str w0, [x20, offset_smartphone_prezzo]

        add x19, x19,#1
        ldr x20, =n_smartphone
        str x19, [x20]                                                                   //prende il contenuto di x19 e lo mette all'indirizzo contenuto in x20     
                                                                                         //per incrementare n_smartphone
        bl save_data

        b end_Aggiungi_smartphone 

    fail_Aggiungi_smartphone:                                                            //se superassimo max_smartphone il programma stamperebbe un messaggio di errore
        adr x0, fmt_line
        bl printf
        adr x0, fmt_fail_Aggiungi_smartphone
        bl printf
        adr x0, fmt_line
        bl printf
        
    end_Aggiungi_smartphone:
    
    ldp x19, x20, [sp], #16                                                             //deallochiamo dallo stack pointer per ripristinare i registri
    ldp x29, x30, [sp], #16
    ret
    .size Aggiungi_smartphone, (. - Aggiungi_smartphone)


.type Elimina_smartphone, %function                     //RIMOZIONE ELEMENTO
Elimina_smartphone:
    stp x29, x30, [sp, #-16]!                                                            //utilizziamo stp per dichiarare i registri che non devono essere volatili

    ldr x1, n_smartphone                                                                 //carichiamo in x1, n_smartphone 
    cmp x1, #0
    beq fail_elimina_smartphone
    
    read_int fmt_prompt_index
    cmp x0, #1
    blt end_Elimina_smartphone

    ldr x1, n_smartphone
    cmp x0, x1
    bgt end_Elimina_smartphone

    sub x5, x0, #1   // selected index
    ldr x6, n_smartphone
    sub x6, x6, x0  // number of smartphone after selected index
    mov x7, smartphone_size_aligned
    ldr x0, =smartphone
    mul x1, x5, x7  // offset to dest
    add x0, x0, x1  // dest
    add x1, x0, x7  // source
    mul x2, x6, x7  // bytes to copy
    bl memcpy

    ldr x0, =n_smartphone
    ldr x1, [x0]
    sub x1, x1, #1
    str x1, [x0]

    bl save_data

    b end_Elimina_smartphone

    fail_elimina_smartphone:
        adr x0, fmt_line
        bl printf
        adr x0, fmt_fail_calcola_prezzo_medio
        bl printf
        adr x0, fmt_line
        bl printf

    end_Elimina_smartphone:
    
    ldp x29, x30, [sp], #16                                                                     //deallochiamo dallo stack pointer per ripristinare i registri
    ret
    .size Elimina_smartphone, (. - Elimina_smartphone)


.type calcola_prezzo_medio, %function                   //STATISTICA CON RISULTATO INTERO
calcola_prezzo_medio:
    stp x29, x30, [sp, #-16]!                                                                       //utilizziamo stp per dichiarare i registri che non devono essere volatili
    
    adr x0, fmt_linee
    bl printf

    ldr x0, n_smartphone
    cmp x0, #0
    beq calcola_prezzo_medio_error

        mov x1, #0
        mov x2, #0
        ldr x3, =smartphone
        add x3, x3, offset_smartphone_prezzo
        // prendo la quantità di bit di offset smartphone prezzo e li aggiungo
        calcola_prezzo_medio_loop:
            ldr x4, [x3]                                                //carica in w4 ciò che si trova all'indirizzo contenuto in x3
            add x1, x1, x4
            add x3, x3, smartphone_size_aligned

            add x2, x2, #1
            cmp x2, x0
            blt calcola_prezzo_medio_loop
        
        udiv x1, x1, x0
        adr x0, fmt_prezzo_medio
        bl printf
        adr x0, fmt_linee
        bl printf
        b end_calcola_prezzo_medio

    calcola_prezzo_medio_error:
        adr x0, fmt_line
        bl printf
        adr x0, fmt_fail_calcola_prezzo_medio
        bl printf
        adr x0, fmt_line
        bl printf
    
    end_calcola_prezzo_medio:

    ldp x29, x30, [sp], #16                                             //deallochiamo dallo stack pointer per ripristinare i registri
    ret
    .size calcola_prezzo_medio, (. - calcola_prezzo_medio)


.type calcola_prezzo_medio_double, %function                    //STATISTICA CON RISULTATO NON INTERO
calcola_prezzo_medio_double:
    stp x29, x30, [sp, #-16]!
    
    adr x0, fmt_linee
    bl printf

    ldr x0, n_smartphone
    cmp x0, #0
    beq calcola_prezzo_medio_double_error

        fmov d1, xzr                                                                //d1 è il registro per gli argomenti di tipo double
        mov x2, #0
        ldr x3, =smartphone
        add x3, x3, offset_smartphone_prezzo

        calcola_prezzo_medio_double_loop:
            ldr w4, [x3]
            ucvtf d4, w4                                                            //converte ciò che si trova nel registro w4 in floating-point e lo mette in d4
            fadd d1, d1, d4                                                         //somma tra registri con argomenti double
            add x3, x3, smartphone_size_aligned

            add x2, x2, 1
            cmp x2, x0
            blt calcola_prezzo_medio_double_loop

        ucvtf d0, x0                                                                //converte ciò che si trova nel registro w0 in floating-point e lo mette in d0
        fdiv d0, d1, d0                                                             //divisione tra registri con argomenti double
        adr x0, fmt_prezzo_medio_double
        bl printf
        adr x0, fmt_linee
        bl printf
        b end_calcola_prezzo_medio_double

    calcola_prezzo_medio_double_error:
        adr x0, fmt_line
        bl printf
        adr x0, fmt_fail_calcola_prezzo_medio
        bl printf
        adr x0, fmt_line
        bl printf
    
    end_calcola_prezzo_medio_double:

    ldp x29, x30, [sp], #16                                                         //deallochiamo dallo stack pointer per ripristinare i registri
    ret
    .size calcola_prezzo_medio_double, (. - calcola_prezzo_medio_double)

.type trova_smartphone_ar, %function            //FILTRO SU QUALCHE DATO IMPLEMENTATO IN MODO ITERATIVO
trova_smartphone_ar:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    
        read_int fmt_prompt_index_ar                                    //leggi da input l'archiviazione da cercare
        sub x0, x0, 1
        ldr x21, n_smartphone
        cmp x21, #0
        beq filtra_per_ar_error
        mov w19, w0
        mov x20, #0
        ldr x22, =smartphone                                            //carica l'indirizzo dell'array in x22
        mov x23, x22
        add x22, x22, offset_smartphone_archiviazione                   //questo serve per trovare l'archiviazione == input
        add x23, x23, offset_smartphone_marca                           //questo serve per stampare il nome dello smartphone relativo all'archiviazione

        adr x0, fmt_menu_lines
        bl printf
        
        adr x0, fmt_menu_headers
        bl printf

        adr x0, fmt_menu_lines
        bl printf

        filtra_per_ar_loop:
        ldr w24, [x22]
        cmp w19, w24                                                    //vede se l'input è diverso da quello che sta controllando
        bge continua                                                    //se è >= passa all'indice superiore


        //se trova l'archiviazione allora stampa ste cose giù
        add x1, x23, offset_smartphone_marca
        add x2, x23, offset_smartphone_modello
        ldr x3, [x23, offset_smartphone_archiviazione]
        adr x0, fmt_smartphone
        bl printf

        continua:    
        add x22, x22, smartphone_size_aligned
        add x23, x23, smartphone_size_aligned
        add x20, x20, #1   // indice +1
        cmp x20, x21  // fino a che x20 non arriva all'indice massimo ()
        blt filtra_per_ar_loop

        b end_filtra_per_ar
        
        filtra_per_ar_error:
        adr x0, fmt_line
        adr x1, fmt_fail_calcola_prezzo_medio 
        adr x2, fmt_line
        bl printf
        
    end_filtra_per_ar:
        adr x0, fmt_menu_lines
        bl printf
    ldp x23, x24, [sp], #16                                                             //deallochiamo dallo stack pointer per ripristinare i registri
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size trova_smartphone_ar, (. - trova_smartphone_ar)

.type filtro, %function                 //FILTRO SU QUALCHE DATO IMPLEMENTATO IN MODO ITERATIVO
filtro:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    

        mov x25, #0
        read_int fmt_prompt_filtro    // leggi da input il budget 
        sub x0, x0, 1     
        ldr x21, n_smartphone
        cmp x21, #0
        beq filtra_error
        mov w19, w0
        mov x20, #0
        ldr x22, =smartphone            // carica l'indirizzo dell'array in x22
        mov x23, x22
        add x22, x22, offset_smartphone_prezzo        // questo serve per trovare il prezzo == input
        add x23, x23, offset_smartphone_marca       // questo serve per stampare la marca dello smartphone relativo all'anno

        adr x0, fmt_menu_lines
        bl printf
        
        adr x0, fmt_menu_headers_
        bl printf

        adr x0, fmt_menu_lines
        bl printf

        filtro_loop:
        ldr w24, [x22]
        cmp w19, w24 // vede se l'input è diverso da quello che sta controllando
        ble continuas  // se è così passa all'indice superiore

        //se lo trova allora stampa ste cose giù
        add x1, x23, offset_smartphone_marca
        add x2, x23, offset_smartphone_modello
        ldr x3, [x23, offset_smartphone_prezzo]
        adr x0, fmt_smartphones
        bl printf

        continuas:    
        add x22, x22, smartphone_size_aligned
        add x23, x23, smartphone_size_aligned
        add x20, x20, #1   // indice +1
        cmp x20, x21  // fino a che x20 non arriva all'indice massimo 
        blt filtro_loop

        b end_filtro_loop

        filtra_error:
        adr x0, fmt_line
        bl printf
        adr x0, fmt_fail_calcola_prezzo_medio
        bl printf
        adr x0, fmt_line
        bl printf
        
        end_filtro_loop:
        adr x0, fmt_menu_lines
        bl printf
    ldp x23, x24, [sp], #16
    ldp x21, x22, [sp], #16
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size filtro, (. - filtro)

.type rico, %function                   //FILTRO SU QUALCHE DATO IMPLEMENTATO IN MODO RICORSIVO
rico:                                           //RICORSIONE
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    stp x21, x22, [sp, #-16]!
    stp x23, x24, [sp, #-16]!
    stp x25, x27, [sp, #-16]!
    //str x26, [sp, #-16]!
       
        ldr w24, [x22]
        //print_w24                   //primo prezzo
        mov x20, x22                  //indirizzo dell'array+offset
        add x20, x20, smartphone_size_aligned
        ldr w25, [x20]
        //print_w25                   //secondo prezzo  
        cmp w27, #2
        blt else
            cmp w25, w24
            csel w25, w25, w24, lt
            cmp w25, w26
            csel w26, w25, w26, lt
            b endif
        else:
            cmp w25, w24
            csel w25, w25, w24, lt
            mov w26, w25
        endif:
        
        cmp w27, w21                    //se w27 è < n_smartphone...
        blt recursive

        b end_rico

        recursive:
            add w27, w27, #1
            add x22, x22, smartphone_size_aligned
            add x23, x23, smartphone_size_aligned
            bl rico
        
        end_rico:
        mov w1, w26 
        //ldr x26, [sp], #16
        ldp x25, x27, [sp], #16
        ldp x23, x24, [sp], #16
        ldp x21, x22, [sp], #16
        ldp x19, x20, [sp], #16
        ldp x29, x30, [sp], #16
        ret
        .size rico, (. - rico)

.type cambia, %function                     //OPERAZIONE DI SCAMBIO TRA DUE ELEMENTI
cambia:
     stp x29, x30, [sp, #-16]!
     stp x19, x27, [sp, #-16]!
     stp x20, x21, [sp, #-16]!
     stp x22, x23, [sp, #-16]!
    
    read_int fmt_prompt_index                       //legge il primo elemento da spostare
    mov x19, x0                                     //lo mette in x19

    ldr x20, =n_smartphone
    cmp x19, x20                                 //se è più grande esci
    bgt end_cambia

    read_int fmt_prompt_index                       //legge il secondo input 
    mov x20, x0                                      //lo mette in x20

    //cmp x20, n_smartphone                                  //se è più grande esci
    //bgt end_cambia

    sub x19, x19, #1                                  //gli toglie 1 per essere l'indice dell'array
    sub x20, x20, #1                                  //gli toglie 1 per essere l'indice dell'array


    //metto secondo input in max_smartphone + 1
    mov x3, smartphone_size_aligned                      //carica la dimensione di una riga
    mov x4, max_smartphone
    add x4, x4, #1
    ldr x27, =smartphone                                 //carica in x27 l'indirizzo dell'array
    
    madd x0, x4, x3, x27                                //destinazione ------- (x20*x3)+x27
    madd x1, x20, x3, x27                                //sorgente     ------- (x19*x3)+x27
    mov x2, x3                                           //dimensione dell'elemento da copiare
    bl memcpy
    //


    //metto input in secondo input
    mov x3, smartphone_size_aligned                      //carica la dimensione di una riga
    ldr x27, =smartphone                                 //carica in x27 l'indirizzo dell'array
    
    madd x0, x20, x3, x27                                //destinazione ------- (x20*x3)+x27
    madd x1, x19, x3, x27                                //sorgente     ------- (x19*x3)+x27
    mov x2, x3                                           //dimensione dell'elemento da copiare
    bl memcpy
    //


    //metto max_smartphone + 1 in input
    mov x3, smartphone_size_aligned                      //carica la dimensione di una riga
    mov x4, max_smartphone
    add x4, x4, #1 
    ldr x27, =smartphone                                 //carica in x27 l'indirizzo dell'array
    
    madd x0, x19, x3, x27                                //destinazione ------- (x20*x3)+x27
    madd x1, x4, x3, x27                                //sorgente     ------- (x19*x3)+x27
    mov x2, x3                                           //dimensione dell'elemento da copiare
    bl memcpy
    //

    bl save_data

    end_cambia:
    
    ldp x22, x23, [sp], #16
    ldp x20, x21, [sp], #16
    ldp x19, x27, [sp], #16
    ldp x29, x30, [sp], #16
    ret
    .size cambia, (. - cambia)
