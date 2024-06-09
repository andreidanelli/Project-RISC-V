# - Matricula:    Andrei 2021101028, Guilherme 1821101014
# - Nome:         Andrei Danelli, Guilherme Fusieger

		        .data
Menu:                   .string  "\n\nMenu:\n1. Insere elemento na lista\n2. Remove elemento da lista indice\n3. Remove elemento da lista valor\n4. Exibe elementos da lista\n5. Exibe estatisticas da lista\n6. Finalizar programa\nEscolha uma opcao: "
MsgExibeEstatistica:    .string  "\nExibe estatisticas da lista\n"		
MsgExibeElementos:      .string  "\nExibe elementos da lista\n"
MsgErroAlocacao:        .string  "\nErro ao inserir elemento na lista\n"
MsgRemoveIndice:	.string  "\nRemove elemento da lista indice\n"        
MsgRemoveValor:  	.string	 "\nRemove elemento da lista valor\n"
MsgPosicao1: 		.string  "\nValor "
MsgPosicao2:		.string	 " inserido na posição "
MsgPosicao3:		.string  " da lista\n"
MsgInsere:              .string  "\nDigite um valor inteiro: "
MsgExit:		.string  "\nFinalizando programa!\n"
OpcaoInvalida:          .string  "\nOpcao invalida. Tente novamente.\n"
								
			.text
			add s0, zero, zero  # s0 é o registrador apontador para o início da lista	
			add s2, zero, zero  # Contador				
main:
	la a0, Menu
	jal ra, exibe_mensagem
	
	jal ra, le_entrada
	
	li t0, 1
	beq a0, t0, prepara_insere    # Se for igual a 1 insere_inteiro
	
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
	j main            

exibe_mensagem:
	li a7, 4   
	ecall
	ret
	
le_entrada:
	li a7, 5
	ecall 	
	ret
	
##############################################################
# Inicio Opção
# Inserir registro na lista
##############################################################
prepara_insere:
	la, a0, MsgInsere
	jal ra, exibe_mensagem	
	
	li a7, 5
	ecall
	
	add a1, zero, a0                            # Carrega em a1 o valor lido
	add a0, zero, s0                            # Carrega inicio da lista
	jal insere_inteiro
	
	# Verifica se houve falha na inserção
	bge a0, zero, exibe_mensagem_sucesso        # Se a0 >= 0, inserção foi um sucesso
	la  a0, MsgErroAlocacao
	jal ra, exibe_mensagem
	j main

insere_inteiro:
	add t1, zero, a1                             # Valor informado pelo usuário
	add t0, zero, a0                             # Posição do inicio da lista
	
	li a0, 12                                    # Cria um nodo, mesmo que não seja usado por algum erro
	li a7, 9                                     # Alocando memória
	ecall
	
	bge a0, zero, insere_registro_continue
	li a0, -1
	ret
	
insere_registro_continue:
	add t6, zero, a0
	sw t1, 4(t6)                                # Adiciona valor na memória
	sw zero, 0(t6)                              # Indica valor anterior como NULL
	sw zero, 8(t6)                              # Indica o próximo valor como NULL
	    
	bne t0, zero, insere_registro_ordem_lista   # Se a lista não estiver vazia
	beq t0, zero, insere_primeiro_registro_lista
	ret
	
insere_registro_ordem_lista:
	lw t3, 4(s0)                                 # Copia para o registrador t3 o valor do primeiro elemento da lista
	slt t5, t1, t3                               # Se o valor a ser inserido for menor que o valor do primeiro nodo
	bne t5, zero, insere_inicio_lista            # Quando o valor ser maior que o primeiro valor, sera inserido no inicio da lista   rs1 <> rs2
	
	add t4, zero, s0                             # Responsável por passar pelos nodos
	li t2, 1				     # Indice da inserção
	j insere_ordem_loop                          # Se não for menor que o primeiro sera inserido no meio ou final da lista 
	
insere_primeiro_registro_lista:
	add s0, zero, t6
	li a0, 0				     
	ret

exibe_mensagem_sucesso: 
	add s2, zero, a0
    
	li a7, 4
	la a0, MsgPosicao1
	ecall
	
	add a0, zero, a1
	li a7, 1
	ecall
	
	li a7, 4
	la a0, MsgPosicao2
	ecall
	
	add a0, zero, s2
	li a7, 1
	ecall
	
	li a7, 4
	la a0, MsgPosicao3
	ecall
	
	j main
		
insere_inicio_lista:
	sw t6, 0(s0)                                 # Próximo valor do novo nodo sera o inicio da lista
	sw s0, 8(t6)                                 # Anterior do inicio da fila aponta par ao novo nodo
	add s0, zero, t6                             # Ponteiro do comeco da lista aponta para novo nodo
	li a0, 0				     # Retorna o indice de inserção
	ret

insere_ordem_loop:				     # Loop que percorre a lista ate encontrar a posicao onde sera inserido novo nodo
	add s1, zero, t4				
	lw t4, 8(t4)                               
	beq t4, zero, insere_fim_lista               # Se t4 for igual a 0, insere final da lista
	lw t3, 4(t4)
	slt t5, t1, t3      			     # t5 recebe 1 se o valor a ser inserido é menor que o do nodo em que está a iteração
	beq t5, zero, insere_ordem_loop              # Se não for menor, itera novamente
	bne t5, zero, insere_meio_lista              # Se for menor, vai para a função de inserir entre 2 nodos
	ret
	
insere_fim_lista:
	sw t6, 8(s1)
	sw s1, 0(t6)
	add a0, s2, t2			             # Retorna o indice de inserção
	ret

insere_meio_lista:
	sw t6, 8(s1)                                 # Nodo anterior recebe como próximo o novo nodo
	sw s1, 0(t6)				     # O novo nodo recebe o nodo anterior
	sw t4, 8(t6) 				     # O Novo nodo recebe o proximo nodo
	sw t6, 0(t4)
	add a0, s2, t2		                     # Retorna o indice de inserção
	ret

##############################################################
# Final Opção
# Inserir registro na lista
##############################################################
remove_por_indice:
	la, a0, MsgRemoveIndice	
	jal ra, exibe_mensagem
	j main

remove_por_valor:
	la, a0, MsgRemoveValor
	jal ra, exibe_mensagem
	j main
	
imprime_lista:
	la, a0, MsgExibeElementos
	jal ra, exibe_mensagem
	j main
	
estatistica:
	la, a0, MsgExibeEstatistica
	jal ra, exibe_mensagem
	j main
	
finaliza:
	la a0, MsgExit
	jal ra, exibe_mensagem
	li a7, 93             # Syscall
	ecall
