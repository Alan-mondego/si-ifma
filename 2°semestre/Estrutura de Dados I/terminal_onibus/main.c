#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>
#include "tad_lst2.h"

int main() {
    setlocale(LC_ALL, "Portuguese");
    lista_encadeada lista_bus;
    inicializa_lista(&lista_bus);
    ptr_no_arvore arvore = NULL;
    int opcao, opcao_exibicao, opcao_arvore;
    char nova_placa[8];

    do {
        monta_tela();
        scanf(" %d", &opcao);
        limpa_tela();
        getchar();

        switch(opcao) {
            case 1:
                carregar_lista(&lista_bus);
                break;
            case 2:
                listar(lista_bus);
                break;
            case 3:
                media_tempo(lista_bus);
                break;
            case 4:
                valor_por_empresa(lista_bus);
                break;
            case 5:
                if(inverte(&lista_bus)) {
                    listar(lista_bus);
                } else {
                    printf("Erro ao inverter lista!\n");
                }
                break;
            case 6:
                printf("Quantidade de nodos: %d\n", tamanho_quantidade_nodos(lista_bus));
                break;
            case 7:
                printf("\nCriando árvore binária de busca...\n");
                if (arvore != NULL) {
                    printf("A árvore já existe! Use a opção 8 para visualizar.\n");
                    break;
                }
                printf("1. Inserir todas as placas da lista\n");
                printf("2. Inserir uma nova placa\n");
                printf("Escolha uma opção: ");
                scanf("%d", &opcao_arvore);

                if (opcao_arvore == 1) {
                    arvore = criar_arvore_da_lista(lista_bus);
                    printf("Árvore criada com sucesso!\n");
                } else if (opcao_arvore == 2) {
                    if (tamanho(lista_bus) == 0) {
                        printf("Erro: A lista de ônibus está vazia!\n");
                        break;
                    }
                    printf("\nDigite a placa (formato ABC1234): ");
                    scanf("%s", nova_placa);
                    if (strlen(nova_placa) == 7) {
                        elemento novo_elem = elemento_nulo();
                        strcpy(novo_elem.placa, nova_placa);
                        arvore = inserir_arvore(arvore, novo_elem);
                        printf("Placa inserida com sucesso!\n");
                    } else {
                        printf("Placa inválida! Use o formato ABC1234\n");
                    }
                }
                break;
            case 8:
                if (arvore == NULL) {
                    printf("A árvore está vazia!\n");
                } else {
                    printf("\nARVORE BINARIA DE BUSCA \n");
                    exibir_arvore(arvore);

                    exibir_opcoes_de_percuso();
                    scanf("%d", &opcao_exibicao);

                    printf("\nPercurso escolhido:\n");
                    switch(opcao_exibicao) {
                        case 1:
                            em_ordem(arvore);
                            break;
                        case 2:
                            pre_ordem(arvore);
                            break;
                        case 3:
                            pos_ordem(arvore);
                            break;
                        default:
                            printf("Opção inválida!\n");
                    }
                    printf("\n");
                }
                break;
            case 9:
                if (arvore == NULL) {
                    printf("A árvore está vazia!\n");
                } else {
                    printf("\nÁrvore no formato ABB:\n");
                    exibir_arvore(arvore);
                    printf("\nPercurso em ordem:\n");
                    em_ordem(arvore);
                    printf("\n");
                }
                printf("Fim de execução!\n");
                break;
            default:
                printf("Opção inválida!\n");
        }

    } while (opcao != 9);

    return 0;
}

