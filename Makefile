# $@ = target file
# $< = first dependency
# $^ = all dependencies

C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h)

OBJ = ${C_SOURCES:.c=.o}
OBJECTS = ${addprefix ${OBJ_DIR}/, ${OBJ}}
OBJ_DIR = obj
CFLAGS = -g

CC = i686-elf-gcc
GDB = gdb
QEMU = qemu-system-i386
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
build/kernel.bin: obj/boot/kernel_entry.o obj/cpu/stubs.o ${OBJECTS}
	${LD} -o $@ -T setup.ld $^ --oformat binary

obj/boot/kernel_entry.o: boot/kernel_entry.asm 
	${ASM} $< -f elf -o $@

obj/cpu/stubs.o: cpu/stubs.asm
	${ASM} $< -f elf -o $@

debug: build/os-image.bin build/kernel.elf
	${QEMU} -s -S -drive file=$<,format=raw,if=floppy

build/kernel.elf: obj/boot/kernel_entry.o obj/cpu/stubs.o ${OBJECTS}
	${LD} -o $@ -T setup.ld $^

# Generic rules for wildcards
# To make an object, always compile from its .c
${OBJECTS}: $(OBJ_DIR)/%.o : %.c
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

clean:
	rm -rf build/* obj/*/*.o