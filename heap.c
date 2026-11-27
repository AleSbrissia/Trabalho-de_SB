#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <unistd.h>

void *brk_original = 0, *brk_current = 0;
/* Nome esperado pelo programa de testes em main.c. */
void *original_brk = 0;
char livre = 0, em_uso = 1;

/*
 * Cada bloco da heap possui este cabeçalho. O campo tamanho representa
 * apenas a área de dados, não incluindo o próprio cabeçalho.
 */
 // __attribute__((packed)) serve para impedir padding
typedef struct __attribute__((packed)) {
  unsigned char uso;
  unsigned long int tamanho;
} bloco_header;

// garante que o header vai ocupar 9 bytes, mas é facultativo
_Static_assert(sizeof(bloco_header) == 9,
               "O cabecalho da heap deve ocupar 9 bytes");

/*
 * Procura um bloco livre que comporte bytes.
 *
 * strategy = 0: worst-fit, escolhe o maior bloco adequado.
 * strategy = 1: best-fit, escolhe o menor bloco adequado.
 *
 * Retorna o cabeçalho do bloco encontrado ou NULL se nenhum bloco servir.
 */
static bloco_header *procura_bloco_livre(unsigned long int bytes, unsigned char strategy) {

  //este tipo de ponteiro avança byte a byte na aritmetica
  uintptr_t inicio, fim, atual;
  bloco_header *melhor = NULL;

  if (bytes == 0 || strategy > 1 || brk_original == NULL ||
      brk_current == NULL)
    return NULL;

  inicio = (uintptr_t) brk_original;
  fim = (uintptr_t) brk_current;

  /* Ainda não há blocos registrados na heap. */
  if (inicio >= fim)
    return NULL;

  atual = inicio;
  while (atual + sizeof(bloco_header) <= fim) {
    bloco_header *bloco = (bloco_header *) atual;
    uintptr_t proximo;

    /* Um cabeçalho corrompido não pode fazer a busca sair da heap. */
    if (bloco->tamanho > fim - atual - sizeof(bloco_header))
      return NULL;

    proximo = atual + sizeof(bloco_header) + bloco->tamanho;

    if (bloco->uso == livre && bloco->tamanho >= bytes &&
        (melhor == NULL ||
         (strategy == 0 && bloco->tamanho > melhor->tamanho) ||
         (strategy == 1 && bloco->tamanho < melhor->tamanho))) {
      melhor = bloco;
    }

    atual = proximo;
  }

  return melhor;
}

/*
 * Abre um novo bloco no final da heap.
 *
 * O bloco recebe exatamente o tamanho solicitado. O endereço retornado
 * aponta para os dados, logo o cabeçalho fica escondido imediatamente antes
 * deles.
 */
static void *abre_novo_bloco(unsigned long int bytes) {
  unsigned long int total;
  bloco_header *bloco;
  void *endereco;

  if (bytes == 0)
    return NULL;

  if (bytes > (unsigned long int)-1 - sizeof(bloco_header))
    return NULL;

  total = sizeof(bloco_header) + bytes;
  endereco = sbrk(total);
  if (endereco == (void *)-1)
    return NULL;

  bloco = (bloco_header *) endereco;
  bloco->uso = em_uso;
  bloco->tamanho = bytes;

  brk_current = (unsigned char *) endereco + total;

  return (unsigned char *) endereco + sizeof(bloco_header);
}

//Obtém o endereço de brk
void setup_brk(){
  brk_original = sbrk(0);
  original_brk = brk_original;
  brk_current = brk_original;
} 

//Restaura o endereço de brk                
void dismiss_brk(){
  brk_current = sbrk(0);
  brk(brk_original);
} 

// worst-fit (strategy = 0) e best-fit (strategy = 1)                    
void* memory_alloc(unsigned long int bytes, unsigned char strategy){
  if (bytes == 0)
    return NULL;

  //1. Procura bloco livre com tamanho igual ou maior que a
  //requisição
  bloco_header *bloco = procura_bloco_livre(bytes, strategy);

  //2. Se encontrar, marca ocupação, utiliza os bytes
  //necessários do bloco, retornando o endereço
  //correspondente
  if (bloco != NULL) {
    unsigned long int tamanho_original = bloco->tamanho;

    /*
     * Só divide se o restante comportar outro cabeçalho e pelo menos
     * um byte de dados.
     */
    if (tamanho_original >= bytes + sizeof(bloco_header) + 1) {
      bloco_header *restante = (bloco_header *)
          ((unsigned char *) bloco + sizeof(bloco_header) + bytes);

      restante->uso = livre;
      restante->tamanho = tamanho_original - bytes - sizeof(bloco_header);
      bloco->tamanho = bytes;
    }

    bloco->uso = em_uso;
    return (void *)((uintptr_t)bloco + sizeof(bloco_header));
  }

  //3. Se não encontrar, abre espaço para um novo bloco
  return abre_novo_bloco(bytes);
}

//Marca um bloco ocupado como livre
int memory_free(void *pointer){
  uintptr_t alvo, inicio, fim, atual;

  if (pointer == NULL || brk_original == NULL || brk_current == NULL)
    return 0;

  alvo = (uintptr_t) pointer;
  inicio = (uintptr_t) brk_original;
  fim = (uintptr_t) brk_current;
  atual = inicio;

  while (atual + sizeof(bloco_header) <= fim) {
    bloco_header *bloco = (bloco_header *) atual;
    uintptr_t dados, proximo;

    /* Impede que um cabeçalho inválido faça a busca sair da heap. */
    if (bloco->tamanho > fim - atual - sizeof(bloco_header))
      return 0;

    dados = atual + sizeof(bloco_header);
    proximo = dados + bloco->tamanho;

    if (dados == alvo) {
      /* Liberar duas vezes o mesmo bloco é considerado erro. */
      if (bloco->uso != em_uso)
        return 0;

      bloco->uso = livre;
      return 1;
    }

    atual = proximo;
  }

  /* O ponteiro não corresponde ao início de nenhum bloco alocado. */
  return 0;
}

