#ifndef TAD_LST2_H
#define TAD_LST2_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/// Limites máximos para o nosso sistema
#define MAX_VEICULOS 100  /// Podemos cadastrar até 100 ônibus diferentes
#define MAX_EMPRESAS 10   /// Temos 10 empresas de ônibus no total

/// Aqui definimos como guardamos as informações de cada passagem
/// É como se fosse uma ficha com todos os detalhes de uma entrada
typedef struct {
    int cod_terminal;     /// Número do terminal onde o ônibus passou
    char data[9];         /// Data da passagem (formato: AAAA-MM-DD)
    char hora[5];         /// Horário da passagem (formato: HH:MM)
    char placa[8];        /// Placa do ônibus (formato: ABC1234)
    int cod_empresa;      /// Código da empresa dona do ônibus
} elemento;

/// Cada nó é como um elo de uma corrente
/// Ele guarda as informações de uma passagem e aponta para a próxima
typedef struct no_lista {
    elemento elem;                    /// As informações da passagem
    struct no_lista *prox;           /// Ponteiro para a próxima passagem
} no_lista, *ptr_nodo;

/// A lista é como um conjunto de elos
/// Ela guarda o primeiro elo e quantos elos temos no total
typedef struct {
    ptr_nodo lista;      /// Ponteiro para a primeira passagem
    int tamanho;         /// Quantidade total de passagens
} lista_encadeada;

/// Cada nó da árvore é como uma folha
/// Ele guarda as informações e tem duas conexões: uma para a esquerda e outra para a direita
typedef struct no_arvore {
    elemento elem;                    /// As informações da passagem
    struct no_arvore *esquerda;      /// Conexão para a folha da esquerda
    struct no_arvore *direita;       /// Conexão para a folha da direita
} no_arvore, *ptr_no_arvore;

/// Funções para trabalhar com a lista de passagens
/// São como ferramentas para organizar e acessar as informações

/// Conta quantas passagens temos na lista
int tamanho(lista_encadeada lista);

/// Pega as informações de uma passagem específica
int obter_elemento(lista_encadeada lista, int pos, elemento *elem);

/// Prepara a lista para receber novas passagens
int inicializa_lista(lista_encadeada *lista);

/// Adiciona uma nova passagem na lista
int incluir_elemento(lista_encadeada *lista, elemento elem);

/// Atualiza as informações de uma passagem existente
int alterar_elemento(lista_encadeada *lista, int pos, elemento elem);

/// Remove uma passagem da lista
int excluir_elemento(lista_encadeada *lista, int pos);

/// Funções para trabalhar com a árvore de placas
/// São como ferramentas para organizar e mostrar as placas em ordem

/// Adiciona uma nova placa na árvore
ptr_no_arvore inserir_arvore(ptr_no_arvore raiz, elemento elem);

/// Cria uma árvore a partir da lista de passagens
ptr_no_arvore criar_arvore_da_lista(lista_encadeada lista);

/// Mostra as placas em ordem (da menor para a maior)
void em_ordem(ptr_no_arvore raiz);

/// Mostra as placas começando pela raiz
void pre_ordem(ptr_no_arvore raiz);

/// Mostra as placas começando pelas folhas
void pos_ordem(ptr_no_arvore raiz);

/// Mostra a árvore de forma visual, com linhas conectando as placas
void exibir_arvore_normal(ptr_no_arvore raiz, int nivel, int eh_esquerdo);

/// Função que prepara a exibição da árvore
void exibir_arvore(ptr_no_arvore raiz);

/// Libera a memória usada pela árvore
void liberar_arvore(ptr_no_arvore raiz);

/// Função para retornar um elemento nulo
elemento elemento_nulo(void);

/// Definição do valor nulo
#define VL_NULO elemento_nulo()

#endif

