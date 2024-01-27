.set MAGIC, 0x1badb002
.set FLAGS, 1 << 0 | 1 << 1
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.section .text
.global entry
entry:
mov $kernel_stack, %esp
push %eax
push %ebx
call kernel_main
cli
loop:
hlt
jmp loop

.section .bss
.align 16
.space 1 << 20
kernel_stack:

