#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stddef.h>
#include "arena.h"

Arena arena_create(ptrdiff_t size) {
  Arena out = {0};
  out.beg = malloc(size);
  out.cap = out.beg? size : 0; 
  out.end = (char *)out.beg + size;
  return out;
}

void arena_free(Arena arena) {
  free((char *)arena.end - arena.cap);
}

#define ALLOC_NOZERO   (1 << 0)
#define ALLOC_SOFTFAIL (1 << 1)

#if defined(__GNUC__) || defined(__MINGW32__) || defined(__clang__)
__attribute((malloc, alloc_size(2, 4), alloc_align(3)))
#endif
void *arena_alloc(Arena *arena, ptrdiff_t size, ptrdiff_t align, ptrdiff_t count, int flags) {
  ptrdiff_t arena_size = (char *)arena->end - (char *)arena->beg;
  ptrdiff_t padding = -(uintptr_t)arena->beg & (align - 1);
  if (count > (arena_size - padding)/size) {
    puts("Arena OOM");
    if (flags & ALLOC_SOFTFAIL)
      return NULL;
    abort();
  }
  ptrdiff_t total = size * count;
  void *p = (char *)arena->beg + padding;
  arena->beg = (char *)arena->beg + padding + total;
  return flags & ALLOC_NOZERO ? p : memset(p, 0, total);
}
#define ALLOC(arena, type, count) arena_alloc(arena, sizeof(type), _Alignof(type), count, 0)
#define ALLOCF(arena, type, count, flags) arena_alloc(arena, sizeof(type), _Alignof(type), count, flags)

