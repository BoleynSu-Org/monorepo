#include "vga.h"

static struct vga * const vga = (struct vga*) 0xb8000;
static unsigned char vga_current_color = 0;
static short vga_current_position = 0;

void draw_at(short x, short y, char data, unsigned char fg, unsigned char bg) {
  vga->cells[x * VGA_HEIGHT + y].data = data;
  vga->cells[x * VGA_HEIGHT + y].color = fg | bg << 4;
}

void set_position(short x, short y) {
  vga_current_position = x * VGA_HEIGHT + y;
}
void set_color(unsigned char fg, unsigned char bg) {
  vga_current_color = fg | bg << 4;
}
void draw_next(char data) {
  if (vga_current_position >= VGA_HEIGHT * VGA_WIDTH) {
    vga_current_position = 0;
  }
  vga->cells[vga_current_position].data = data;
  vga->cells[vga_current_position].color = vga_current_color;
  ++vga_current_position;
}
