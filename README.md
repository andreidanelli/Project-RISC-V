# Project-RISC-V
Programa implementado utilizando o conjunto de instruções do processador RISC-V para rodar no simulador RARS

<h1 align="center">Lista Encadeada usando instruções do processador RISC-V</h1>

<div align="center">
  <img src="https://microhobby.com.br/img/riscv-logo.png"/>
</div>

<h4>Trabalho final da disciplina de Organização de Computadores (ORG), ministradas pelo professor Dr. Luciano Lores Caimi.</h4>

# Descrição

- Faça um programa que implementa a gerencia de uma lista ordenada com capacidade de
armazenar números inteiros. O inicio da lista deve estar armazenado em uma posição de memória de nome head com
valor inicial 0 (NULL). Cada posição da lista ocupa 8 bytes, onde 4 bytes são usados para armazenar o valor
inteiro e 4 bytes para armazenar o ponteiro para o próximo elemento. Por exemplo:

* ```O elemento encontra-se na posição de memória 400```
* ```O valor armazenado no endereço &400 é 7, que corresponde ao valor do elemento da lista```
* ```O valor armazenado no endereço &404 é 220, que corresponde ao endereço do próximo elemento da lista na memória```

<div align="center">
  <img src="https://github.com/andreidanelli/Project-RISC-V/blob/main/Img/project.png"/>
</div>

# Funcionalidades do Programa
  -  Inserir elemento na lista
  -  Remover elemento da lista por indice
  -  Remover elemento da lista por valor
  -  Mostra todos os elementos da lista
  -  Mostra estatísticas
      -  Quantidade de elementos presentes na lista
      - Maior valor presente na lista
      - Menor valor presente na lista
      - Quantidade de inserções realizadas
      - Quantidade de remoções realizadas
 - Sair do programa

# Instalação

- Simulador RARS
  - [https://github.com/TheThirdOne/rars/releases](https://github.com/TheThirdOne/rars/releases)

# Referência
  - [Guia Prático RISC-V](https://github.com/andreidanelli/Project-RISC-V/blob/main/Documenta%C3%A7%C3%A3o/guia-pratico-risc-v-1.0.0.pdf)
  - [RARS Environment calls](https://github.com/andreidanelli/Project-RISC-V/blob/main/Documenta%C3%A7%C3%A3o/RARS_environment_calls.pdf)
