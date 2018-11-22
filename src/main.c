#include <stdio.h>
#include <stdlib.h>

int encriptar(unsigned char key, char* name);
int decriptar(unsigned char key, char* name);
/*
gcc −c −m32 main.c
nasm −f elf32 add.asm
gcc −m32 −o main main.o add.o
*/

int main(){
  unsigned char key;
  char name[100];
  int op;
  printf("Digite a chave:");
  scanf("%c",&key);
  printf("Digite o nome do arquivo:");
  scanf(" %100s",name);
//  encriptar(key,name);
  printf("1 - Criptografar\n2 - Descriptografar\n");
  scanf("%d",&op);
  if(op==1){
    encriptar(key,name);
  }else if(op==2){
    decriptar(key,name);
  }else{
    printf("Invalid option\n");
  }
  return 0;
}
