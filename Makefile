CC       := gcc
CFLAGS   := -Wall -Wextra -g
TARGET   := heap_test
OBJECTS  := heap.o main.o

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@

heap.o: heap.c heap.h
main.o: main.c heap.h

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(OBJECTS) $(TARGET)
