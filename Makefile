CC       := gcc
CFLAGS   := -Wall -Wextra -g
TARGETS  := heap_test heap_test_implementado
OBJECTS  := heap.o main.o main_implementado.o

.PHONY: all run run-normal run-implementado clean

all: $(TARGETS)

heap_test: heap.o main.o
	$(CC) $(CFLAGS) $^ -o $@

heap_test_implementado: heap.o main_implementado.o
	$(CC) $(CFLAGS) $^ -o $@

heap.o: heap.c heap.h
main.o: main.c heap.h
main_implementado.o: main_implementado.c heap.h

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

run: run-normal run-implementado

run-normal: heap_test
	./heap_test

run-implementado: heap_test_implementado
	./heap_test_implementado

clean:
	rm -f $(OBJECTS) $(TARGETS)
