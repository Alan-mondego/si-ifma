#include "tad_lst2.h"
#include <stdlib.h>  // Para usar malloc e free
#include <string.h>  // Para usar strcpy

// Cria um elemento vazio com valores zerados
elemento elemento_nulo(void) {
    elemento e;
    e.cod_terminal = 0;       // Terminal zerado
    strcpy(e.data, "");       // Data vazia
    strcpy(e.hora, "");       // Hora vazia
    strcpy(e.placa, "");      // Placa vazia
    e.cod_empresa = 0;        // Empresa zerada
    return e;
}

// Retorna quantos elementos temos na lista
int tamanho(lista_encadeada le) {
    return le.tamanho;
}

// Pega um elemento específico da lista pelo índice
int obter_elemento(lista_encadeada le, int i, elemento *e) {
    if (i < 1 || i > le.tamanho) {  // Se o índice não existir
        *e = VL_NULO;               // Retorna um elemento vazio
        return 0;                   // E avisa que deu errado
    }

    ptr_nodo pnodo = le.lista;
    for (int j = 1; j < i; j++) {  // Vai até o índice que queremos
        pnodo = pnodo->prox;
    }

    *e = pnodo->elem;  // Pega o elemento que encontramos
    return 1;          // E avisa que deu certo
}

// Limpa a lista para começar do zero
int inicializa_lista(lista_encadeada *lista) {
    lista->lista = NULL;
    lista->tamanho = 0;
    return 1;
}

// Adiciona um novo elemento no final da lista
int incluir_elemento(lista_encadeada *lista, elemento elem) {
    ptr_nodo novo = (ptr_nodo)malloc(sizeof(no_lista));
    if (!novo) return 0;

    novo->elem = elem;
    novo->prox = NULL;

    if (tamanho(*lista) == 0) {
        lista->lista = novo;
    } else {
        ptr_nodo atual = lista->lista;
        while (atual->prox != NULL) {
            atual = atual->prox;
        }
        atual->prox = novo;
    }

    lista->tamanho++;
    return 1;
}

// Muda um elemento que já existe na lista
int alterar_elemento(lista_encadeada *le, int i, elemento e) {
    if (i < 1 || i > le->tamanho) {  // Se o índice não existir
        return 0;                    // Avisa que deu errado
    }

    ptr_nodo pnodo = le->lista;
    for (int j = 1; j < i; j++) {  // Vai até o índice que queremos
        pnodo = pnodo->prox;
    }

    pnodo->elem = e;  // Muda o elemento
    return 1;         // E avisa que deu certo
}

// Remove um elemento da lista
int excluir_elemento(lista_encadeada *le, int i) {
    if (i < 1 || i > le->tamanho) {  // Se o índice não existir
        return 0;                    // Avisa que deu errado
    }

    ptr_nodo pnodo_excluido;

    if (i == 1) {  // Se for o primeiro elemento
        pnodo_excluido = le->lista;       // Pega o nó que vai excluir
        le->lista = pnodo_excluido->prox; // O início da lista agora é o segundo elemento
    } else {  // Se não for o primeiro
        ptr_nodo pnodo_anterior = le->lista;
        for (int j = 1; j < i - 1; j++) {  // Vai até o elemento anterior
            pnodo_anterior = pnodo_anterior->prox;
        }
        pnodo_excluido = pnodo_anterior->prox;       // Pega o nó que vai excluir
        pnodo_anterior->prox = pnodo_excluido->prox; // Conecta o anterior com o próximo
    }

    free(pnodo_excluido);  // Libera a memória
    le->tamanho--;         // Diminui o tamanho da lista
    return 1;              // E avisa que deu certo
}

// Inverte a ordem dos elementos da lista
int inverte(lista_encadeada *le) {
    if (le == NULL || le->tamanho <= 1) {  // Se a lista estiver vazia ou tiver só um elemento
        return 1;
    }

    ptr_nodo anterior = NULL;
    ptr_nodo atual = le->lista;
    ptr_nodo proximo = NULL;

    while (atual != NULL) {  // Vai até o final da lista
        proximo = atual->prox;  // Guarda o próximo
        atual->prox = anterior; // Inverte o ponteiro
        anterior = atual;       // Avança o anterior
        atual = proximo;        // Avança o atual
    }

    le->lista = anterior;  // O último elemento agora é o primeiro
    return 1;
}

// Conta quantos elementos temos na lista
int tamanho_quantidade_nodos(lista_encadeada le) {
    int cont = 0;  // Contador

    ptr_nodo atual = le.lista;

    while (atual != NULL) {  // Vai até o final da lista
        cont++;              // Conta mais um
        atual = atual->prox; // Vai para o próximo
    }

    return cont;  // Retorna o total
}

// Calcula quanto tempo passou entre duas horas
int calcular_diferenca_minutos(char *hora1, char *hora2) {
    int h1 = atoi(hora1);  // Converte a primeira hora
    int h2 = atoi(hora2);  // Converte a segunda hora

    int min1 = (h1 / 100) * 60 + (h1 % 100);  // Converte para minutos
    int min2 = (h2 / 100) * 60 + (h2 % 100);  // Converte para minutos

    int diff = min2 - min1;  // Calcula a diferença
    if (diff < 0) {          // Se passou da meia-noite
        diff += 24 * 60;     // Adiciona 24 horas
    }

    return diff;  // Retorna a diferença em minutos
}

// Lê os dados do arquivo e coloca na lista
int carregar_lista(lista_encadeada *lista_bus) {
    FILE* arquivo = fopen("2025-09-06.txt", "r");  // Abre o arquivo
    if (arquivo == NULL) {
        printf("Erro ao abrir o arquivo!\n");
        return 0;
    }

    elemento elem;
    int pos = 1;  // Começa na posição 1
    while (fscanf(arquivo, "%d %s %s %s %d",  // Lê cada linha do arquivo
           &elem.cod_terminal, elem.data, elem.hora, elem.placa, &elem.cod_empresa) == 5) {
        if (!incluir_elemento(lista_bus, elem)) {  // Coloca na lista
            printf("Erro ao incluir elemento na lista!\n");
            fclose(arquivo);
            return 0;
        }
        pos++;  // Vai para a próxima posição
    }

    fclose(arquivo);  // Fecha o arquivo
    printf("Dados carregados com sucesso!\n");
    return 1;
}

// Mostra todos os elementos da lista
int listar(lista_encadeada lista_bus) {
    if (tamanho(lista_bus) == 0) {  // Se a lista estiver vazia
        printf("Lista vazia!\n");
        return 0;
    }

    elemento elem;
    elemento nulo = VL_NULO;

    for (int i = 1; i <= tamanho(lista_bus); i++) {  // Vai até o final da lista
        if (obter_elemento(lista_bus, i, &elem) && memcmp(&elem, &nulo, sizeof(elemento)) != 0) {
            printf("Terminal: %d, Data: %s, Hora: %s, Placa: %s, Empresa: %d\n",
                   elem.cod_terminal, elem.data, elem.hora, elem.placa, elem.cod_empresa);
        }
    }
    return 1;
}

// Calcula o tempo médio entre terminais para cada ônibus
int media_tempo(lista_encadeada lista_bus) {
    if (tamanho(lista_bus) == 0) {  // Se a lista estiver vazia
        printf("Não há dados na lista\n");
        return 0;
    }

    // Guarda os dados de cada ônibus
    struct {
        char placa[8];
        int total_tempos;
        int soma_tempos;
        int ultimo_terminal;
        char ultima_hora[5];
    } veiculos[MAX_VEICULOS];
    int num_veiculos = 0;

    // Pega todos os ônibus diferentes
    ptr_nodo atual = lista_bus.lista;
    while (atual != NULL) {
        int encontrado = 0;
        for (int i = 0; i < num_veiculos; i++) {
            if (strcmp(veiculos[i].placa, atual->elem.placa) == 0) {
                encontrado = 1;
                break;
            }
        }
        if (!encontrado) {
            strcpy(veiculos[num_veiculos].placa, atual->elem.placa);
            veiculos[num_veiculos].total_tempos = 0;
            veiculos[num_veiculos].soma_tempos = 0;
            veiculos[num_veiculos].ultimo_terminal = atual->elem.cod_terminal;
            strcpy(veiculos[num_veiculos].ultima_hora, atual->elem.hora);
            num_veiculos++;
        }
        atual = atual->prox;
    }

    // Calcula os tempos entre terminais
    atual = lista_bus.lista;
    while (atual != NULL) {
        for (int i = 0; i < num_veiculos; i++) {
            if (strcmp(veiculos[i].placa, atual->elem.placa) == 0) {
                if (veiculos[i].ultimo_terminal != atual->elem.cod_terminal) {
                    int tempo = calcular_diferenca_minutos(veiculos[i].ultima_hora, atual->elem.hora);
                    veiculos[i].soma_tempos += tempo;
                    veiculos[i].total_tempos++;
                    veiculos[i].ultimo_terminal = atual->elem.cod_terminal;
                    strcpy(veiculos[i].ultima_hora, atual->elem.hora);
                }
                break;
            }
        }
        atual = atual->prox;
    }

    // Mostra as médias
    printf("\nMédia de tempo entre terminais por veículo:\n");
    printf("----------------------------------------\n");
    for (int i = 0; i < num_veiculos; i++) {
        if (veiculos[i].total_tempos > 0) {
            double media = (double)veiculos[i].soma_tempos / veiculos[i].total_tempos;
            printf("Veículo %s: %.2f minutos\n", veiculos[i].placa, media);
        }
    }
    printf("----------------------------------------\n");

    return 1;
}

// Calcula quanto cada empresa vai receber
int valor_por_empresa(lista_encadeada lista_bus) {
    if (tamanho(lista_bus) == 0) {
        printf("Lista vazia!\n");
        return 0;
    }

    float valores[MAX_EMPRESAS] = {0};  // Guarda o valor de cada empresa

    // Conta cada entrada como um trajeto completo
    for (int i = 1; i <= tamanho(lista_bus); i++) {
        elemento elem;
        if (!obter_elemento(lista_bus, i, &elem)) continue;

        // Cada entrada em qualquer terminal vale R$ 200,00
        if (elem.cod_empresa >= 1 && elem.cod_empresa <= MAX_EMPRESAS) {
            valores[elem.cod_empresa - 1] += 200.0;
        }
    }

    // Mostra os resultados
    printf("\nValor por empresa:\n");
    printf("----------------------------------------\n");
    float valor_total = 0;
    for (int i = 0; i < MAX_EMPRESAS; i++) {
        if (valores[i] > 0) {
            printf("Empresa %d: R$ %.2f\n", i + 1, valores[i]);
            valor_total += valores[i];
        }
    }
    printf("----------------------------------------\n");
    printf("Valor total geral: R$ %.2f\n", valor_total);

    return 1;
}

// Compara duas placas (letras e números)
int comparar_placas(char *placa1, char *placa2) {
    int cmp_letras = strncmp(placa1, placa2, 3);  // Compara as letras

    if (cmp_letras != 0) {
        return cmp_letras;  // Se as letras forem diferentes, usa esse critério
    }

    return strcmp(placa1 + 3, placa2 + 3);  // Se as letras forem iguais, compara os números
}

// Adiciona um ônibus na árvore
ptr_no_arvore inserir_arvore(ptr_no_arvore raiz, elemento e) {
    if (raiz == NULL) {  // Se a árvore estiver vazia
        ptr_no_arvore novo = (ptr_no_arvore)malloc(sizeof(no_arvore));
        if (novo == NULL) {
            printf("Erro na alocação de memória!\n");
            return NULL;
        }
        novo->elem = e;
        novo->esquerda = NULL;
        novo->direita = NULL;
        return novo;
    }

    // Se a placa já existe
    if (comparar_placas(e.placa, raiz->elem.placa) == 0) {
        printf("Placa %s já cadastrada!\n", e.placa);
        return raiz;
    }

    // Se a placa for menor, vai para a esquerda
    if (comparar_placas(e.placa, raiz->elem.placa) < 0) {
        raiz->esquerda = inserir_arvore(raiz->esquerda, e);
    }
    // Se a placa for maior, vai para a direita
    else {
        raiz->direita = inserir_arvore(raiz->direita, e);
    }

    return raiz;
}

// Cria a árvore com todos os ônibus da lista
ptr_no_arvore criar_arvore_da_lista(lista_encadeada lista) {
    ptr_no_arvore raiz = NULL;
    ptr_nodo atual = lista.lista;

    // Coloca todos os ônibus na árvore
    while (atual != NULL) {
        raiz = inserir_arvore(raiz, atual->elem);
        atual = atual->prox;
    }

    return raiz;
}

// Mostra as placas em ordem (menor para maior)
void em_ordem(ptr_no_arvore raiz) {
    if (raiz != NULL) {
        em_ordem(raiz->esquerda);  // Mostra os menores
        printf("%s - ", raiz->elem.placa);  // Mostra a placa atual
        em_ordem(raiz->direita);  // Mostra os maiores
    }
}

// Mostra as placas começando pela raiz
void pre_ordem(ptr_no_arvore raiz) {
    if (raiz != NULL) {
        printf("%s - ", raiz->elem.placa);  // Mostra a placa atual
        pre_ordem(raiz->esquerda);  // Mostra os menores
        pre_ordem(raiz->direita);  // Mostra os maiores
    }
}

// Mostra as placas começando pelas folhas
void pos_ordem(ptr_no_arvore raiz) {
    if (raiz != NULL) {
        pos_ordem(raiz->esquerda);  // Mostra os menores
        pos_ordem(raiz->direita);  // Mostra os maiores
        printf("%s - ", raiz->elem.placa);  // Mostra a placa atual
    }
}

// Mostra a árvore de forma visual
void exibir_arvore_normal(ptr_no_arvore raiz, int nivel, int eh_esquerdo) {
    if (raiz == NULL) {
        return;
    }

    // Desenha as linhas de conexão
    for (int i = 0; i < nivel; i++) {
        if (i == nivel - 1) {
            if (eh_esquerdo) {
                printf("└── ");  // Último nível à esquerda
            } else {
                printf("├── ");  // Último nível à direita
            }
        } else {
            printf("│   ");  // Linha vertical
        }
    }

    // Mostra a placa
    printf("%s\n", raiz->elem.placa);

    // Mostra os maiores
    exibir_arvore_normal(raiz->direita, nivel + 1, 0);

    // Mostra os menores
    exibir_arvore_normal(raiz->esquerda, nivel + 1, 1);
}

// Prepara para mostrar a árvore
void exibir_arvore(ptr_no_arvore raiz) {
    printf("Árvore Binária de Busca:\n");
    exibir_arvore_normal(raiz, 0, 0);
}

// Libera a memória da árvore
void liberar_arvore(ptr_no_arvore raiz) {
    if (raiz != NULL) {
        liberar_arvore(raiz->esquerda);  // Libera os menores
        liberar_arvore(raiz->direita);  // Libera os maiores
        free(raiz);  // Libera o nó atual
    }
}
