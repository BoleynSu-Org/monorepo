all:
	as --32 bootloader.s -o bootloader.o
	gcc -m32 -c kernel.c -o kernel.o -ffreestanding -O2 -fno-zero-initialized-in-bss
	gcc -m32 -c vga.c -o vga.o -ffreestanding -O2 -fno-zero-initialized-in-bss
	ld -melf_i386 kernel.o vga.o bootloader.o -T linker.ld -o os.bin -nostdlib
	cp os.bin root/boot
	grub2-mkrescue -o os.iso root
clean:
	rm *.o os.bin os.iso root/boot/os.bin
test: all
	qemu-system-x86_64 -cdrom os.iso
