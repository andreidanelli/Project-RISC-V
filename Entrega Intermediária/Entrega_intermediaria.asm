# - Matricula:    Andrei 2021101028, Guilherme 1821101014
# - Nome:         Andrei Danelli, Guilherme Fusieger

		        .data
Menu:                   .string  "\n\nMenu:\n1. Insere elemento na lista\n2. Remove elemento da lista indice\n3. Remove elemento da lista valor\n4. Exibe elementos da lista\n5. Exibe estatisticas da lista\n6. Finalizar programa\nEscolha uma opcao: "
MsgExibeEstatistica:    .string  "\nExibe estatisticas da lista\n"		
MsgErroAlocacao:        .string  "\nErro ao inserir elemento na lista\n"
MsgRemoveIndice:	.string  "\nIndice da lista a ser removido: \n"        
MsgRemoveValor:  	.string	 "\nValor da lista a ser removido: \n"
MsgListaVazia:		.string  "\n Lista esta vazia!"
MsgPosicao1: 		.string  "\nValor "
MsgPosicao2:		.string	 " inserido na posição "
MsgPosicao3:		.string  " da lista\n"
MsgInsere:              .string  "\nDigite um valor inteiro: "
MsgEspaco:		.string	 " "
MsgLista: 		.string  "\nElementos da Lista: "
MsgExit:		.string  "\nFinalizando programa!\n"
OpcaoInvalida:          .string  "\nOpcao invalida. Tente novamente.\n"
MsgMaiorValor:          .string  "\nMaior valor: "
MsgMenorValor:          .string  "\nMenor valor: "
MsgQuantidade:          .string  "\nQuantidade de inserções: "
MsgRemocaoSucesso:      .string  "\nElemento removido com sucesso.\n"
MsgRemocaoIndice:       .string  "\nElemento removido do indice.\n"
MsgRemocaoErro:         .string  "\nErro ao remover elemento.\n"
								
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
	beq a0, t0, op_imprimir_lista # Se for igual a 4 imprime_lista
	
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

##############################################################
# Inicio Opção
# Imprimir lista
##############################################################
op_imprimir_lista:
	add a0, zero, s0
	jal imprime_lista

exibe_lista:
	li a7, 4
	la a0, MsgLista
	ecall
	
for_lista:
	lw a0, 4(t0)
	li a7, 1
	ecall 
	
	la, a0, MsgEspaco
	li, a7, 4
	ecall
	
	lw t0, 8(t0)
	bne t0, zero, for_lista
	j main 	

imprime_lista:
	add t0, zero, a0
	bne t0, zero, exibe_lista
	beq t0, zero, imprime_lista_vazia
	
	j main
	
imprime_lista_vazia:
	li a7, 4
	la a0, MsgListaVazia
	ecall
	
	j main

##############################################################
# Final Opção
# Imprimir lista
##############################################################

##############################################################
# Inicio Opção
# Estatísticas da lista
##############################################################
estatistica:
    la a0, MsgExibeEstatistica			#quando a opção 5 é selecionada, exibe a mensagem é a função calc_estatisticas é chamada
    jal ra, exibe_mensagem
    add a0, zero, s0
    jal calc_estatisticas
    j main

calc_estatisticas:
    beq s0, zero, estatisticas_lista_vazia	#exibe a mensagem e retorna se a lista estiver vazia

    add t0, zero, s0          			#t0 aponta para o início da lista
    lw t1, 4(t0)              			#t1 recebe o primeiro valor da lista
    add t2, zero, t1          			#t2 vai ser o maior valor(inicializa com o primeiro valor)
    add t3, zero, t1          			#t3 vai ser o menor valor(inicializa com o primeiro valor)
    li t4, 1                  			#t4 é o contador de elementos (inicializa com 1)

calc_estatisticas_loop:				#loop de cálculo das estatísticas
    lw t0, 8(t0)              			#t0 recebe o endereço do próximo nodo
    beq t0, zero, estatisticas_fim_loop 	#se t0 for zero, fim do loop
    lw t1, 4(t0)              			#t1 recebe o valor do próximo nodo

    blt t1, t2, atualiza_menor			#atualiza o menor valor
    j verifica_maior

atualiza_menor:
    add t2, zero, t1          			#t2 recebe t1(novo menor valor)
    j verifica_maior

verifica_maior:
    bge t3, t1, conta_elementos
    add t3, zero, t1          			#t3 recebe t1(novo maior valor)

conta_elementos:
    addi t4, t4, 1            			#incrementa contador de elementos
    j calc_estatisticas_loop

estatisticas_fim_loop:
    la a0, MsgMenorValor			#exibe o menor valor
    li a7, 4
    ecall
    
    add a0, zero, t2
    li a7, 1
    ecall

    la a0, MsgMaiorValor			#exibe o maior valor
    li a7, 4
    ecall
    
    add a0, zero, t3
    li a7, 1
    ecall

    la a0, MsgQuantidade			#exibe a qtd de inserções
    li a7, 4
    ecall
    add a0, zero, t4
    li a7, 1
    ecall

    j main

estatisticas_lista_vazia:
    la a0, MsgListaVazia
    li a7, 4
    ecall
    j main

##############################################################
# Final Opção
# Estatísticas da lista
##############################################################

# Inicio Opção
# Remove por índice
##############################################################

remove_por_indice:
	la a0, MsgRemoveIndice	
	jal ra, exibe_mensagem

	li a7, 5				#leitura do índice a ser removido
	ecall
	add a1, zero, a0
	
	beq s0, zero, remove_indice_lista_vazia #verifica se a lista está vazia
	
						#inicializa variáveis
	add t0, zero, s0      			#t0 aponta para o início da lista
	li t1, 0              			#t1 é o contador de índice
	add t2, zero, zero    			#t2 é o ponteiro para o nodo anterior
	
remove_indice_loop:
	beq t1, a1, remove_indice_encontrado   #se t1 == a1, encontrou o índice
	lw t2, 0(t0)	        		#t2 aponta para o nodo atual
	lw t0, 8(t0)        			#t0 aponta para o próximo nodo
	addi t1, t1, 1      			#incrementa o contador de índice
	bne t0, zero, remove_indice_loop  	#continua se não for o fim da lista
	
	la a0, MsgRemocaoErro			#indice não encontrado
	jal ra, exibe_mensagem
	j main
	
remove_indice_encontrado:
	lw a1, 4(t0)        			#a1 recebe o valor do nodo a ser removido
	
						#remove o nodo da lista
	beq t2, zero, remove_indice_primeiro  	#se t2 == 0, é o primeiro nodo
	lw t3, 8(t0)        			#t3 aponta para o próximo nodo
	sw t3, 8(t2)        			#atualiza o próximo do nodo anterior
	
	beq t3, zero, remove_indice_ultimo   	#se t3 == 0, é o último nodo
	sw t2, 0(t3)        			#atualiza o anterior do próximo nodo
	la a0, MsgRemocaoSucesso
	jal ra, exibe_mensagem
	li a0, 1
	j main
	
remove_indice_primeiro:
	lw s0, 8(t0)        			#atualiza o início da lista
	beq s0, zero, remove_indice_ultimo
	sw zero, 0(s0)      			#atualiza o anterior do novo início da lista
	la a0, MsgRemocaoSucesso
	jal ra, exibe_mensagem
	li a0, 1
	j main
	
remove_indice_ultimo:
	la a0, MsgRemocaoSucesso
	jal ra, exibe_mensagem
	li a0, 1
	j main
	
remove_indice_lista_vazia:
	la a0, MsgListaVazia
	jal ra, exibe_mensagem
	j main
	
##############################################################
# Final Opção
# Remove por índice
##############################################################

##############################################################
# Inicio Opção
# Remove por valor
##############################################################

remove_por_valor:
	la a0, MsgRemoveValor
	jal ra, exibe_mensagem

						#leitura do valor a ser removido
	li a7, 5
	ecall
	add a1, zero, a0
	
						#verifica se a lista está vazia
	beq s0, zero, remove_valor_lista_vazia
	
						#inicializa variáveis
	add t0, zero, s0      			#t0 aponta para o início da lista
	li t1, 0              			#t1 é o índice do nodo atual
	add t2, zero, zero    			#t2 é o ponteiro para o nodo anterior
	
remove_valor_loop:
	lw t3, 4(t0)          			#t3 recebe o valor do nodo atual
	beq t3, a1, remove_valor_encontrado  	#se t3 == a1, encontrou o valor
	lw t2, 0(t0)				#t2 aponta para o nodo atual
	lw t0, 8(t0)          			#t0 aponta para o próximo nodo
	addi t1, t1, 1        			#incrementa o índice
	bne t0, zero, remove_valor_loop  	#continua se não for o fim da lista

	la a0, MsgRemocaoErro			#valor não encontrado
	jal ra, exibe_mensagem
	j main
	
remove_valor_encontrado:
	lw t4, 8(t0)          			#t4 aponta para o próximo nodo
	
						#remove o nodo da lista
	beq t2, zero, remove_valor_primeiro  	#se t2 == 0, é o primeiro nodo
	sw t4, 8(t2)        			#atualiza o próximo do nodo anterior
	
	beq t4, zero, remove_valor_ultimo   	#se t4 == 0, é o último nodo
	sw t2, 0(t4)        			#atualiza o anterior do próximo nodo
	la a0, MsgRemocaoSucesso
	jal ra, exibe_mensagem
	li a0, 1
	j main
	
remove_valor_primeiro:
	lw s0, 8(t0)        			#atualiza o início da lista
	beq s0, zero, remove_valor_ultimo
	sw zero, 0(s0)      			#atualiza o anterior do novo início da lista
	la a0, MsgRemocaoSucesso
	jal ra, exibe_mensagem
	li a0, 1
	j main
	
remove_valor_ultimo:
	la a0, MsgRemocaoSucesso
	jal ra, exibe_mensagem
	li a0, 1
	j main
	
remove_valor_lista_vazia:
	la a0, MsgListaVazia
	jal ra, exibe_mensagem
	j main
	
##############################################################
# Final Opção
# Remove por valor
##############################################################
	
finaliza:
	la a0, MsgExit
	jal ra, exibe_mensagem
	li a7, 93             # Syscall
	ecall
