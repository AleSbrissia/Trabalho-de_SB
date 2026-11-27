all: 
	gcc -c heap.s -o heap.o
	gcc -c main.c -o main.o
	gcc heap.o main.o -o heap_test

clean:
	rm *.o heap_test
