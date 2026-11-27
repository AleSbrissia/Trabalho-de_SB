#include <stdio.h>
#include <unistd.h>

void *brk_original = 0, *brk_current = 0;
char livre = 0, em_uso = 1;

//Obtém o endereço de brk
void setup_brk(){
  brk_original = sbrk(0);
  brk_current = brk_original;
} 

//Restaura o endereço de brk                
void dismiss_brk(){
  brk_current = sbrk(0);
  brk(brk_original);
} 

// worst-fit (strategy = 0) e best-fit (strategy = 1)                    
void* memory_alloc(unsigned long int bytes, unsigned char
strategy){
  //1. Procura bloco livre com tamanho igual ou maior que a
  //requisição
  //2. Se encontrar, marca ocupação, utiliza os bytes
  //necessários do bloco, retornando o endereço
  //correspondente
  //3. Se não encontrar, abre espaço para um novo bloco
}

//Marca um bloco ocupado como livre
int memory_free(void *pointer){
  /* ja pensei em usar a variavel de livre e
     em uso que deixei la em cima*/
}

