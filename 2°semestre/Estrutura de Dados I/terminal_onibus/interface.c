
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>

void limparBufferTeclado() {
   int c;
   while ((c = getchar()) != '\n' && c != EOF) {
        // Descarta os caracteres até encontrar o fim da linha ou EOF
   }
}

void monta_tela() {
    setlocale(LC_ALL,"Portuguese");
   printf("\n=== SISTEMA DE CONTROLE DE ONIBUS ===\n");
   printf("\n1 - Carregar dados do arquivo");
   printf("\n2 - Listar registros de onibus");
   printf("\n3 - Calcular média de tempo entre terminais");
   printf("\n4 - Calcular valor a receber por empresa");
   printf("\n5 - Inverter Lista ");
   printf("\n6 - Tamanho da lista ");
   printf("\n7 - Inserir dados do arquivo na árvore: ");
   printf("\n8 - Mostrar percursos");
   printf("\n9 - Sair\n");
   printf("\nEscolha uma opção: ");
}

void exibir_opcoes_de_percuso(){
   printf("\n=== Opcoes de percurso  ===\n");
  printf("\n1 - Em Ordem");
   printf("\n2 - Pre Ordem");
   printf("\n3 - Pos ordem");
   printf("\n0 - Voltar menu");
    printf("\nEscolha uma opção: ");

}

void limpa_tela() {
   system("cls"); // Para Windows
}

char escolhe_opcao() {
   return getchar();
}

// Função para formatar e exibir um registro de ônibus
void exibe_registro(int cod_terminal, char* data, char* hora, char* placa, int cod_empresa) {
    printf("\nTerminal: %d", cod_terminal);
    printf("\nData: %s", data);
    printf("\nHora: %s", hora);
    printf("\nPlaca: %s", placa);
    printf("\nEmpresa: %d", cod_empresa);
    printf("\n-------------------");
}



// Função para exibir cabeçalho de relatório
void exibe_cabecalho_relatorio(const char* titulo) {
    printf("\n=== %s ===\n", titulo);
    printf("----------------------------------------\n");
}

// Função para exibir rodapé de relatório
void exibe_rodape_relatorio() {
    printf("----------------------------------------\n");
}

// Função para exibir mensagem de erro
void exibe_erro(const char* mensagem) {
    printf("\nERRO: %s\n", mensagem);
}

// Função para exibir mensagem de sucesso
void exibe_sucesso(const char* mensagem) {
    printf("\nSUCESSO: %s\n", mensagem);
}

