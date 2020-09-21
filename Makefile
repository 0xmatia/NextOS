# $@ = target file
# $< = first dependency
# $^ = all dependencies

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

OBJ = ${C_SOURCES:.c=.o}
OBJECTS = ${addprefix ${OBJ_DIR}/, ${OBJ}}
OBJ_DIR = obj
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
build/kernel.bin: obj/boot/kernel_entry.o ${OBJECTS}
	${LD} -o $@ -T setup.ld $^ --oformat binary

obj/boot/kernel_entry.o: boot/kernel_entry.asm
	${ASM} $< -f elf -o $@

# Open the connection to qemu and load our kernel-object file with symbols
debug1: os-image.bin kernel.elf
	${QEMU} -s -fda os-image.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

debug: build/os-image.bin
	${QEMU} -s -S -drive file=$<,format=raw,if=floppy

# Generic rules for wildcards
# To make an object, always compile from its .c
${OBJECTS}: $(OBJ_DIR)/%.o : %.c
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

clean:
	rm -rf build/* obj/*.o