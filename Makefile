# $@ = target file
# $< = first dependency
# $^ = all dependencies

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}
CFLAGS = -g

CC = i686-elf-gcc
GDB = gdb
QEMU = qemu-system-x86_64
LD = i686-elf-ld
ASM = nasm
DISASM = ndisasm

# First rule is the one executed when no parameters are fed to the Makefile
all: run

run: build/os-image.bin
	${QEMU} -drive file=$<,format=raw,if=floppy

build/os-image.bin: build/boot_sector.bin build/kernel.bin
	cat $^ > $@

build/boot_sector.bin: boot/boot_sector.asm
	${ASM} $< -f bin -o $@

# link kernel
build/kernel.bin: build/kernel_entry.o ${OBJ}
	${LD} -o $@ -Ttext 0x1000 $^ --oformat binary

# # Rule to disassemble the kernel - may be useful to debug
# build/kernel.dis: build/kernel.bin
# 	${DISASM} -b 32 $< > $@

# Open the connection to qemu and load our kernel-object file with symbols
debug: os-image.bin kernel.elf
	${QEMU} -s -fda os-image.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"


# Generic rules for wildcards
# To make an object, always compile from its .c
%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

clean:
	rm -rf *.bin *.dis *.o os-image.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o
