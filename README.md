Отчёт
1) Маланьин Артём Денисович
2) БПИ212
3) 6 вариант

Задача о каннибалах. Племя из n дикарей ест вместе из большого горшка,
который вмещает m кусков тушеного миссионера. Когда дикарь хочет обедать, он ест из горшка один кусок, если только горшок не пуст, иначе дикарь
будит повара и ждет, пока тот не наполнит горшок. Повар, сварив обед, засыпает

Предполагаемая оценка - 6.

Мной была выбрана модель "Взаимодействующие равные", поскольку распределение работ в моем приложении фиксировано заранее.

4) приведено решение задачи на языке С(foo.c).
5) получена и скомпилирована соответствующая ассемблерная программа, добавлены комметарии(foo.s)

gcc -masm=intel \
    -fno-asynchronous-unwind-tables \
    -fno-jump-tables \
    -fno-stack-protector \
    -fno-exceptions \
    ./foo.c \
    -S -o ./foo.s

6) представлено полное тестовое покрытие дающее одинаковый резальтат на обоих программах.

tests/test1.in test1.out test2.in test2.out

Использование: 

gcc ./foo.c(или ./foo.s) -o ./foo.exe, ./foo.exe < tests/test1.in,
 
а зачем сравниваем со значением 

cat tests/test1.out

7) Были использованы дополнительные регистры процессора

QWORD PTR -24[rbp] -> r12

QWORD PTR -8[rbp] -> r13

8) в программе использованы локальные, функции и потоки.
9) добавлены комментарии описывающие связь между параметрами языка си и регистрами.

В условии, приведенном мной, нет необходимости в семафорах, потому что второму потоку не за чем ждать первый, а первый ждёт выполнения второго при помощи pthread_join. Обратил внимание на обязательность семафоров для моей задачи уже когда сдавал и мне не хватило бы времени переписать задачу(((
