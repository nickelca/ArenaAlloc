#include <stdio.h>
#include <stdint.h>
#include "arena.h"

int main(void) {
  Arena foo = arena_create(1024 * 1024);
  int *bar = ALLOC(&foo, int, 1);
  *bar = 12;
  uint64_t *baz = ALLOC(&foo, uint64_t, 2);
  baz[0] = 2;
  baz[1] = 9;
  printf("%d: %ld, %ld\n", *bar, baz[0], baz[1]);
  arena_free(foo);
  return 0;
}
