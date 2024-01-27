#include "vga.h"

void kernel_init() {
}

void print_str(const char* str) {
  for (int i = 0; str[i]; ++i) {
    draw_next(str[i]);
  }
}

void print_int(int x) {
  char buffer[12];
  int cur = 0;
  if (x < 0) {
    buffer[cur++] = '-';
    x = -x;
  }
  do {
    buffer[cur++] = '0' + x % 10;
    x /= 10;
  } while(x != 0);
  int i = buffer[0] == '-', j = cur - 1;
  while (i < j) {
    char swap = buffer[i];
    buffer[i++] = buffer[j];
    buffer[j--] = swap;
  }
  buffer[cur++] = 0;
  print_str(buffer);
}

int f(int x) {
  if (x <= 1) return x;
  else return f(x - 1) + f(x - 2);
}

void kernel_main(void* ptr, int magic) {
  kernel_init();
  set_color(VGA_COLOR_BLACK, VGA_COLOR_WHITE);
  print_str("Hello world!");
  for (int i = 0; ; ++i) {
    set_color(i % 15 + 1, VGA_COLOR_BLACK);
    print_str(" ");
    print_int(f(i));
  }
}

