# $@ = target file
# $< = first dependency
# $^ = all dependencies

CC = i686-elf-gcc
GDB = gdb
QEMU = qemu-system-x86_64
LD = i686-elf-ld
ASM = nasm
DISASM = ndisasm

# First rule is the one executed when no parameters are fed to the Makefile
all: run

# Notice how dependencies are built as needed
build/kernel.bin: build/kernel_entry.o kernel/kernel.o
	${LD} -o $@ -Ttext 0x1000 $^ --oformat binary

build/kernel_entry.o: boot/kernel_entry.asm
	${ASM} $< -f elf -o $@

kernel/kernel.o: kernel/kernel.c
	${CC} -ffreestanding -c $< -o $@

# Rule to disassemble the kernel - may be useful to debug
build/kernel.dis: build/kernel.bin
	${DISASM} -b 32 $< > $@

build/boot_sector.bin: boot/boot_sector.asm
	${ASM} $< -f bin -o $@

build/os-image.bin: build/boot_sector.bin build/kernel.bin
	cat $^ > $@

run: build/os-image.bin
	${QEMU} -fda $<

clean:
	rm build/*.bin kernel/*.o build/*.o build/*.dis || true