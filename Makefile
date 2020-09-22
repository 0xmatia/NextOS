# $@ = target file
# $< = first dependency
# $^ = all dependencies

C_SOURCES = $(wildcard kernel/*.c drivers/*.c cpu/*.c libc/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h cpu/*.h libc/*.h)
DIRS = obj/drivers obj/boot obj/kernel obj/cpu obj/libc

OBJDIR = obj
OBJ = ${C_SOURCES:.c=.o}
OBJECTS = ${addprefix ${OBJDIR}/, ${OBJ}}
CFLAGS = -g -ffreestanding -masm=intel

CC = i686-elf-gcc
GDB = gdb
QEMU = qemu-system-i386
LD = i686-elf-ld
ASM = nasm
DISASM = ndisasm

all: create_directories run

create_directories:
	@mkdir -p ${DIRS}

run: build/os-image.bin
	${QEMU} -drive file=$<,format=raw,if=floppy

build/os-image.bin: build/boot_sector.bin build/kernel.bin
	cat $^ > $@

###############BOOT SECTOR#################
build/boot_sector.bin: boot/boot_sector.asm
	${ASM} $< -f bin -o $@

############################KERNEL#################
# Build the kernel.bin file - made from source files and kernel_entry.o assembly file
build/kernel.bin: obj/boot/kernel_entry.o obj/cpu/stubs.o ${OBJECTS}
	${LD} -o $@ -T setup.ld $^ --oformat binary

# Build the  kernel_entry.o with symbols for later linking
obj/boot/kernel_entry.o: boot/kernel_entry.asm
	${ASM} $< -f elf -o $@

obj/cpu/stubs.o: cpu/stubs.asm
	${ASM} $< -f elf -o $@

# debug
debug: build/os-image.bin build/kernel.elf
	${QEMU} -s -S -drive file=$<,format=raw,if=floppy

# build the kernel image with symbols for debugging
build/kernel.elf: obj/boot/kernel_entry.o obj/cpu/stubs.o ${OBJECTS}
	${LD} -o $@ -T setup.ld $^

# Generic rules for wildcards
# To make an object, always compile from its .c
${OBJDIR}/%.o: %.c
	${CC} ${CFLAGS} -c $< -o $@

clean:
	rm -rf build/* obj/*/*.o