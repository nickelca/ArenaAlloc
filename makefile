# Usage:
# Compile and link in release mode: make release
# Compile and link in debug mode: make debug
# Compile in release mode: make crelease
# Compile in debug mode: make cdebug
# Clean obj/ and bin/
#
# Vars to modify:
# SOURCES_EXCLUDE: any source files you do not want to include
# DBG_EXE name of your debug exe
# DBG_CFLAGS: c flags used to compile and link in debug mode
# RLS_CFLAGS: c flags used to compile and link in release mode
# DBG_LDFLAGS: any additional c flags used only to link in debug mode
# RLS_LDFLAGS: any additional c flags used only to link in release mode
# DBG_LIBS: libraries to link into debug mode
# RLS_LIBS: libraries to link into release mode
# DBG_LD: compiler and linker used for debug mode
# RLS_LD: compiler and linker used for release mode

SOURCES_EXCLUDE =
SOURCES = $(filter-out $(SOURCES_EXCLUDE), $(wildcard src/*.c))

DBG_OBJECTS =$(patsubst src/%.c,obj/dbg/%.o, $(SOURCES))
RLS_OBJECTS =$(patsubst src/%.c,obj/rls/%.o, $(SOURCES))

DBG_EXE = debug
RLS_EXE = release

DBG_CFLAGS = -std=c11 -gdwarf-2 -Wall -Wextra -Wpedantic -Werror -DDEBUG -fsanitize=address
RLS_CFLAGS = -std=c11 -O3

DBG_LDFLAGS =
RLS_LDFLAGS =

DBG_LIBS =
RLS_LIBS =

DBG_LD = clang
RLS_LD = gcc

cdebug: $(DBG_OBJECTS)

crelease: $(RLS_OBJECTS)

debug: $(DBG_OBJECTS)
	$(DBG_LD) $(DBG_CFLAGS) $(DBG_LDFLAGS) $(DBG_OBJECTS) -o bin/$(DBG_EXE) $(DBG_LIBS)

release: $(RLS_OBJECTS)
	$(RLS_LD) $(RLS_CFLAGS) $(RLS_LDFLAGS) $(RLS_OBJECTS) -o bin/$(RLS_EXE) $(RLS_LIBS)

obj/dbg/%.o: src/%.c
	$(DBG_LD) $(DBG_CFLAGS) -c $< -o $@

obj/rls/%.o: src/%.c
	$(RLS_LD) $(RLS_CFLAGS) -c $< -o $@


clean:
	rm -f bin/*
	rm -f obj/rls/*.o
	rm -f obj/dbg/*.o
