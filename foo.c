#define _CRT_SECURE_NO_WARNINGS // для возможности использования scanf
#include <stdio.h>

#include <stdlib.h> // для перехода на русский язык

#include <pthread.h>

//потоковая функция
void * threadFunc(void * thread_data) {
  int * m = thread_data;
  *(m + 1) = * m;
  printf("Повар приготовил еще %d кусков.\n", *(m));
  //завершаем поток
  pthread_exit(0);
}

int main() {

  int n;

  scanf("%d", & n);

  int m;

  scanf("%d", & m);

  int cur[] = {
    m,
    m
  };

  //создаем идентификатор потока
  pthread_t thread;

  //какие то данные для потока (для примера)
  void * thread_data = & cur;

  for (int i = 0; i < n; i++) {
    if (cur[1] == 0) {

      //создаем поток по идентификатору thread и функции потока threadFunc
      //и передаем потоку указатель на данные thread_data
      pthread_create( & thread, NULL, threadFunc, thread_data);

      //ждем завершения потока
      pthread_join(thread, NULL);
    }
    cur[1]--;
    printf("Каннибал %d пообедал, осталось кусков: %d.\n", i + 1, cur[1]);
  }

  return 0;
}
