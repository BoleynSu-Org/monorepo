#ifndef BSOS_VGA_H
#define BSOS_VGA_H

enum vga_color {
  VGA_COLOR_BLACK = 0,
  VGA_COLOR_BLUE = 1,
  VGA_COLOR_GREEN = 2,
  VGA_COLOR_CYAN = 3,
  VGA_COLOR_RED = 4,
  VGA_COLOR_MAGENTA = 5,
  VGA_COLOR_BROWN = 6,
  VGA_COLOR_LIGHT_GREY = 7,
  VGA_COLOR_DARK_GREY = 8,
  VGA_COLOR_LIGHT_BLUE = 9,
  VGA_COLOR_LIGHT_GREEN = 10,
  VGA_COLOR_LIGHT_CYAN = 11,
  VGA_COLOR_LIGHT_RED = 12,
  VGA_COLOR_LIGHT_MAGENTA = 13,
  VGA_COLOR_LIGHT_BROWN = 14,
  VGA_COLOR_WHITE = 15,
};

#define VGA_WIDTH 80
#define VGA_HEIGHT 25

struct vga_cell {
  unsigned char data;
  unsigned char color;
};

struct vga {
  struct vga_cell cells[VGA_HEIGHT * VGA_WIDTH];
};

void draw_at(short x, short y, char data, unsigned char fg, unsigned char bg);
void set_position(short x, short y);
void set_color(unsigned char fg, unsigned char bg);
void draw_next(char data);

#endif
