# - Matricula:    2021101028
# - Nome:         Andrei Danelli

		        .data
Menu:                   .string  "\nMenu:\n1. Insere elemento na lista\n2. Remove elemento da lista indice\n3. Remove elemento da lista valor\n4. Exibe elementos da lista\n5. Exibe estatisticas da lista\n6. Finalizar programa\nEscolha uma opcao: "
MsgExibeEstatistica:    .string  "\nExibe estatisticas da lista\n"		
MsgExibeElementos:      .string  "\nExibe elementos da lista\n"
MsgRemoveIndice:	.string  "\nRemove elemento da lista indice\n"        
MsgRemoveValor:  	.string	 "\nRemove elemento da lista valor\n"  
MsgInsere:              .string  "\nDigite um valor inteiro: "
MsgExit:		.string  "\nFinalizando programa!\n"
OpcaoInvalida:          .string  "\nOpcao invalida. Tente novamente.\n"
								
			.text					
main:
	add s0, zero, zero  # s0 é o registrador apontador para o início da lista
	
	la a0, Menu
	jal ra, exibe_mensagem
	
	jal ra, le_entrada
	
	li t0, 1
	beq a0, t0, insere_inteiro    # Se for igual a 1 insere_inteiro
	
	li t0, 2
	beq a0, t0, remove_por_indice # Se for igual a 2 remove_por_indice
	
	li t0, 3
	beq a0, t0, remove_por_valor  # Se for igual a 3 remove_por_valor
	
	li t0, 4
	beq a0, t0, imprime_lista     # Se for igual a 4 imprime_lista
	
	li t0, 5
	beq a0, t0, estatistica       # Se for igual a 5 estatistica	
	
	li t0, 6
	beq a0, t0, finaliza          # Se for igual a 6 finaliza

	la a0,  OpcaoInvalida
	jal ra, exibe_mensagem   
	jal ra, main            

exibe_mensagem:
	li a7,4            # Syscall number for write
	ecall
	ret
	
le_entrada:
	li a7, 5
	ecall 	
	ret
	
insere_inteiro:
	la, a0, MsgInsere
	jal ra, exibe_mensagem
	
	li a7, 5
	ecall
	
	add a1, zero, a0 # Carrega em a1 o valor lido
	add a0, zero, 
	jal 
	
	
	
	
	
	jal ra, main

remove_por_indice:
	la, a0, MsgRemoveIndice	
	jal ra, exibe_mensagem
	jal ra, main

remove_por_valor:
	la, a0, MsgRemoveValor
	jal ra, exibe_mensagem
	jal ra, main

imprime_lista:
	la, a0, MsgExibeElementos
	jal ra, exibe_mensagem
	jal ra, main
	
estatistica:
	la, a0, MsgExibeEstatistica
	jal ra, exibe_mensagem
	jal ra, main
	
finaliza:
	la a0, MsgExit
	jal ra, exibe_mensagem
	li a7, 93             # Syscall
	ecall