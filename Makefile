default: link

SOURCES = arena.c main.c

CC = gcc
OBJECTS=$(SOURCES:%.c=obj/%.o)
OUT = out

ifeq ($(RLS),Y)
	CFLAGS = -std=c11 -O2 -DNDEBUG
	LDFLAGS =
else
	CFLAGS = -std=c11 -g3 -Wall -Wextra -Wpedantic -Werror -DDEBUG -fsanitize=address,undefined
	LDFLAGS =
endif

obj/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

compile: $(OBJECTS)

link: $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJECTS) -o bin/$(OUT)

$(OUT): link

run: $(OUT)
	./bin/$(OUT)

clean:
	rm -f bin/*
	rm -f obj/*.o
