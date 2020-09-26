# $@ = target file
# $< = first dependency
# $^ = all dependencies

C_SOURCES = $(wildcard kernel/*.c drivers/*.c drivers/screen/*.c cpu/*.c libc/*.c)
ASM_SOURCES := boot/kernel_entry.asm cpu/stubs.asm
HEADERS = $(wildcard kernel/*.h drivers/*.h drivers/screen/*.h cpu/*.h libc/*.h)

OBJDIR = obj
C_OBJ = ${C_SOURCES:.c=.o}
ASM_OBJ = ${ASM_SOURCES:.asm=.o}
OBJECTS := ${addprefix ${OBJDIR}/, ${C_OBJ}} ${addprefix ${OBJDIR}/, ${ASM_OBJ}}

CFLAGS = -g -ffreestanding -masm=intel -Wextra -Wall \
-Wshadow -Wcast-align -Wstrict-prototypes -Wswitch-default -Wswitch-enum
CC = i686-elf-gcc
GDB = gdb
QEMU = qemu-system-i386
LD = i686-elf-ld
ASM = nasm
DISASM = ndisasm

all: run

run: build/os-image.bin
	${QEMU} -drive file=$<,format=raw,if=floppy

build/os-image.bin: build/boot_sector.bin build/kernel.bin
	cat $^ > $@

###############BOOT SECTOR#################
build/boot_sector.bin: boot/boot_sector.asm
	${ASM} $< -f bin -o $@

############################KERNEL#################
# Build the kernel.bin file - made from source files and kernel_entry.o assembly file
build/kernel.bin: ${OBJECTS}
	${LD} -o $@ -T setup.ld $^ --oformat binary

# debug
debug: build/os-image.bin build/kernel.elf
	${QEMU} -s -S -drive file=$<,format=raw,if=floppy

# build the kernel image with symbols for debugging
build/kernel.elf: ${OBJECTS}
	${LD} -o $@ -T setup.ld $^

# Generic rules for wildcards
# To make an object, always compile from its .c
${OBJDIR}/%.o: %.c ${HEADERS}
	@mkdir -p $(dir $@)
	${CC} ${CFLAGS} -c $< -o $@

# Generic rule for assembling .asm files, except
# for boot_sector.asm
${OBJDIR}/%.o: %.asm
	@mkdir -p $(dir $@)
	${ASM} $< -f elf -o $@

clean:
	rm -rf build/* obj/*
