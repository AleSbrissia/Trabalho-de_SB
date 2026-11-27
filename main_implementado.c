#include <stdio.h>
#include <string.h>

#include "heap.h"

extern void *original_brk;

#define CABECALHO 9

static unsigned long int tamanho_do_bloco(void *ponteiro) {
  unsigned long int tamanho;

  memcpy(&tamanho, (char *) ponteiro - sizeof(unsigned long int),
         sizeof(tamanho));
  return tamanho;
}

static int bloco_em_uso(void *ponteiro) {
  return *((unsigned char *) ponteiro - CABECALHO) == 1;
}

static void verifica(const char *descricao, int resultado) {
  printf("\t%s: %s\n", descricao, resultado ? "CORRETO!" : "INCORRETO!");
}

static void testa_alocacao_basica(void) {
  void *inicio = original_brk;
  void *primeiro;
  void *segundo;
  void *terceiro;
  void *quarto;

  printf("==>> ALOCANDO UM ESPAÇO DE 100 BYTES WORST FIT:\n");
  primeiro = memory_alloc(100, 0);
  verifica("LOCAL", (char *) primeiro - CABECALHO == (char *) inicio);
  verifica("IND. DE USO", bloco_em_uso(primeiro));
  verifica("TAMANHO", tamanho_do_bloco(primeiro) == 100);

  printf("==>> DESALOCANDO UM ESPAÇO DE 100 BYTES:\n");
  verifica("RETORNO", memory_free(primeiro) == 1);
  verifica("IND. DE USO", !bloco_em_uso(primeiro));
  verifica("TAMANHO", tamanho_do_bloco(primeiro) == 100);

  printf("==>> ALOCANDO UM ESPAÇO DE 50 BYTES WORST FIT:\n");
  segundo = memory_alloc(50, 0);
  verifica("LOCAL", segundo == primeiro);
  verifica("IND. DE USO", bloco_em_uso(segundo));
  verifica("TAMANHO", tamanho_do_bloco(segundo) == 50);

  printf("==>> ALOCANDO UM ESPAÇO DE 100 BYTES WORST FIT:\n");
  terceiro = memory_alloc(100, 0);
  verifica("LOCAL", (char *) segundo + 100 ==
                        (char *) terceiro - CABECALHO);
  verifica("IND. DE USO", bloco_em_uso(terceiro));
  verifica("TAMANHO", tamanho_do_bloco(terceiro) == 100);

  printf("==> VERIFICANDO A FRAGMENTAÇÃO DE MEMÓRIA:\n");
  verifica("IND. DE USO", *((unsigned char *) segundo + 50) == 0);
  verifica("TAMANHO", tamanho_do_bloco((char *) segundo + 59) == 41);

  printf("==>> DESALOCANDO TUDO:\n");
  verifica("PRIMEIRO BLOCO", memory_free(segundo) == 1);
  verifica("SEGUNDO BLOCO", memory_free(terceiro) == 1);
  verifica("PRIMEIRO LIVRE", !bloco_em_uso(segundo));
  verifica("SEGUNDO LIVRE", !bloco_em_uso(terceiro));

  printf("==>> ALOCANDO UM ESPAÇO DE 40 BYTES BEST FIT:\n");
  quarto = memory_alloc(40, 1);
  verifica("LOCAL", quarto == (char *) segundo + 59);
  verifica("IND. DE USO", bloco_em_uso(quarto));
  verifica("TAMANHO", tamanho_do_bloco(quarto) == 41);

  printf("==>> DESALOCANDO UM ESPAÇO DE 40 BYTES:\n");
  verifica("RETORNO", memory_free(quarto) == 1);
  verifica("IND. DE USO", !bloco_em_uso(quarto));
  verifica("TAMANHO", tamanho_do_bloco(quarto) == 41);
}

static void testa_worst_e_best_fit(void) {
  void *pequeno;
  void *medio;
  void *grande;
  void *resultado;

  printf("==>> TESTANDO WORST FIT COM VÁRIOS BLOCOS:\n");
  pequeno = memory_alloc(64, 0);
  medio = memory_alloc(128, 0);
  grande = memory_alloc(256, 0);
  memory_free(pequeno);
  memory_free(medio);
  memory_free(grande);

  resultado = memory_alloc(60, 0);
  verifica("MAIOR BLOCO ESCOLHIDO", resultado == grande);
  verifica("TAMANHO", tamanho_do_bloco(resultado) == 60);
  verifica("RETORNO", memory_free(resultado) == 1);

  dismiss_brk();
  setup_brk();

  printf("==>> TESTANDO BEST FIT COM VÁRIOS BLOCOS:\n");
  pequeno = memory_alloc(64, 0);
  medio = memory_alloc(128, 0);
  grande = memory_alloc(256, 0);
  memory_free(pequeno);
  memory_free(medio);
  memory_free(grande);

  resultado = memory_alloc(60, 1);
  verifica("MENOR BLOCO ESCOLHIDO", resultado == pequeno);
  verifica("TAMANHO", tamanho_do_bloco(resultado) == 64);
  verifica("RETORNO", memory_free(resultado) == 1);
}

static void testa_erros_e_requisicoes_invalidas(void) {
  void *ponteiro;
  int variavel_da_pilha;

  printf("==>> TESTANDO REQUISIÇÕES INVÁLIDAS:\n");
  verifica("ALOCAR ZERO", memory_alloc(0, 0) == NULL);
  verifica("ESTRATÉGIA INVÁLIDA", memory_alloc(10, 2) == NULL);
  verifica("LIBERAR NULL", memory_free(NULL) == 0);
  verifica("LIBERAR PILHA", memory_free(&variavel_da_pilha) == 0);

  printf("==>> TESTANDO DUPLA LIBERAÇÃO:\n");
  ponteiro = memory_alloc(32, 0);
  verifica("PRIMEIRA LIBERAÇÃO", memory_free(ponteiro) == 1);
  verifica("SEGUNDA LIBERAÇÃO", memory_free(ponteiro) == 0);
  verifica("PONTEIRO INTERNO", memory_free((char *) ponteiro + 1) == 0);
}

int main(void) {
  printf("============================== ROTINAS DE TESTE ==============================\n");

  setup_brk();
  testa_alocacao_basica();

  dismiss_brk();
  setup_brk();
  testa_worst_e_best_fit();

  dismiss_brk();
  setup_brk();
  testa_erros_e_requisicoes_invalidas();

  dismiss_brk();
  return 0;
}
