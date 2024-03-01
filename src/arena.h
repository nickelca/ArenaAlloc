#ifndef __ARENA_H
#define __ARENA_H 1

#include <stdint.h>
#include <stddef.h>

typedef struct Arena Arena;
struct Arena {
  void *beg;
  void *end;
  ptrdiff_t cap;
};

Arena arena_create(ptrdiff_t size);
void arena_free(Arena arena);

#define ALLOC_NOZERO   (1 << 0)
#define ALLOC_SOFTFAIL (1 << 1)

#if defined(__GNUC__) || defined(__MINGW32__) || defined(__clang__)
__attribute((malloc, alloc_size(2, 4), alloc_align(3)))
#endif
void *arena_alloc(Arena *arena, ptrdiff_t size, ptrdiff_t align, ptrdiff_t count, int flags);

#define ALLOC(arena, type, count) arena_alloc(arena, sizeof(type), _Alignof(type), count, 0)
#define ALLOCF(arena, type, count, flags) arena_alloc(arena, sizeof(type), _Alignof(type), count, flags)

#endif
